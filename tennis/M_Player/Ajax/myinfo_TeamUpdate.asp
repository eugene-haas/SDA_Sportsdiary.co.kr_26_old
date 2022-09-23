<!--#include file="../Library/ajax_config.asp"-->
<%
	'=================================================================================================
	'소속팀 변경페이지(myinfo.asp)
	'=================================================================================================
	Check_Login()
	
	dim MemberIDX 	: MemberIDX 	= fInject(Request("MemberIDX"))
	dim PlayerIDX 	: PlayerIDX 	= fInject(Request("PlayerIDX"))
	dim TeamCode 	: TeamCode 		= fInject(Request("TeamCode"))	
	dim EnterType 	: EnterType 	= fInject(Request("EnterType"))
	dim UserName 	: UserName 		= fInject(Request("UserName"))
	dim Birthday 	: Birthday 		= fInject(Request("Birthday"))
	
	dim CSQL, CRs
	dim FndData

	
	IF MemberIDX = "" OR PlayerIDX = "" OR TeamCode = "" OR EnterType = "" Then 
		Response.Write "FALSE|200"
		Response.End
	Else
		
		On Error Resume Next
	
		DBcon.BeginTrans()
		
		
		SELECT CASE EnterType
			
			'tblPlayer 테이블의 정보가 먼저 업데이트 된 후 --> 체육협회에서의 선 정보업데이트가 필요
			CASE "E"		
			
				'업데이트 할 선수정보 조회 [PlayerIDX]
				LSQL = 	"		SELECT PlayerIDX " 
				LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblPlayer] " 
				LSQL = LSQL & " WHERE DelYN = 'N' "
				LSQL = LSQL & " 	AND EnterType = '"&EnterType&"'" 
				LSQL = LSQL & " 	AND SportsGb = '"&SportsGb&"'" 
				LSQL = LSQL & "		AND NowRegYN = 'Y' " 
				LSQL = LSQL & "		AND UserName = '"&UserName&"' " 
				LSQL = LSQL & "		AND Team = '"&TeamCode&"' " 
				LSQL = LSQL & "	 	AND Replace(Birthday,'-','') = '"&Birthday&"' "
				
			'	response.Write LSQL
				
				SET LRs = DBcon.Execute(LSQL)		
				IF Not(LRs.Eof Or LRs.Bof) Then 			
					'-----------------------------------------------------------------------------------
					'UPDATE : tblMember 국가대표-PlayerReln[K] :PlayerIDXNow, 현소속팀[TeamNow] 정보
					'-----------------------------------------------------------------------------------
					CSQL = "		UPDATE [SportsDiary].[dbo].[tblMember] " 
					CSQL = CSQL & "	SET TeamNow = '"&TeamCode&"' "
					CSQL = CSQL & "	WHERE DelYN = 'N' "
					CSQL = CSQL & "		AND SportsType = '"&SportsGb&"' "
					CSQL = CSQL & "		AND EnterType = 'K' "
					CSQL = CSQL & "		AND PlayerReln = 'R' "
					CSQL = CSQL & "		AND PlayerIDXNow = '"&PlayerIDX&"' "
		
					DBcon.Execute(CSQL)
					ErrorNum = ErrorNum + DBcon.Errors.Count				
					'-----------------------------------------------------------------------------------
					'UPDATE : tblMember 보호자 -PlayerReln[A,B,Z] PlayerIDX :매칭된 선수 PlayerIDX 정보
					'-----------------------------------------------------------------------------------
					CSQL = "		UPDATE [SportsDiary].[dbo].[tblMember] " 
					CSQL = CSQL & "	SET Team = '"&TeamCode&"' "
					CSQL = CSQL & "	WHERE DelYN = 'N' "
					CSQL = CSQL & "		AND SportsType = '"&SportsGb&"'"
					CSQL = CSQL & "		AND EnterType = '"&EnterType&"'"
					CSQL = CSQL & "		AND PlayerReln IN('A','B','Z')"
					CSQL = CSQL & "		AND PlayerIDX = '"&PlayerIDX&"'"
		
					DBcon.Execute(CSQL)
					ErrorNum = ErrorNum + DBcon.Errors.Count		
					'-----------------------------------------------------------------------------------
					'UPDATE: tblMember 본인-PlayerReln[R] :PlayerIDX, Team
					'-----------------------------------------------------------------------------------
					CSQL =  " 		SET NOCOUNT ON "
					CSQL = CSQL & "	IF EXISTS( "
					CSQL = CSQL & " 	SELECT MemberIDX " 
					CSQL = CSQL & "		FROM [SportsDiary].[dbo].[tblMember] "
					CSQL = CSQL & " 	WHERE DelYN = 'N' "
					CSQL = CSQL & " 		AND SportsType = '"&SportsGb&"' " 
					CSQL = CSQL & "			AND MemberIDX = '"&MemberIDX&"' " 
					CSQL = CSQL & "	) "
					CSQL = CSQL & "	BEGIN " 					
					CSQL = CSQL & "		UPDATE [SportsDiary].[dbo].[tblMember] " 
					CSQL = CSQL & "		SET Team = '"&TeamCode&"' "
					CSQL = CSQL & "		WHERE DelYN = 'N' AND MemberIDX = '"&MemberIDX&"' "
					CSQL = CSQL & " 	SELECT Team" 
					CSQL = CSQL & "		FROM [SportsDiary].[dbo].[tblMember] "
					CSQL = CSQL & " 	WHERE DelYN = 'N' AND MemberIDX = '"&MemberIDX&"' "
					CSQL = CSQL & "	END " 
					CSQL = CSQL & " SET NOCOUNT OFF "
					
			'		response.Write CSQL
			
					SET CRs = DBcon.Execute(CSQL)
					ErrorNum = ErrorNum + DBcon.Errors.Count	
					
					IF Not(CRs.eof or CRs.bof) Then
						Response.Cookies("Team") = encode(CRs("Team"), 0)
					End IF			
						CRs.Close
					SET CRs = Nothing
						
					
					IF ErrorNum > 0 Then
						DBcon.RollbackTrans()
						response.Write "FALSE|66"
						response.End()
					Else	
						DBcon.CommitTrans()
						response.Write "TRUE|"
						response.End()
					End IF
					
					'초기화
					ErrorNum = 0			
					
				Else
					response.Write "FALSE|99"
					response.End()
				End IF 
					
					LRs.Close
				SET LRs = Nothing
				
				
		'UPDATE: tblPlayer[Team] - 선수(본인), tblMember[Team] - 보호자, 선수(본인)
		CASE "A"
			'-----------------------------------------------------------------------------------
			'UPDATE : 'tblPlayer 테이블 소속팀 정보 업데이트 처리
			'-----------------------------------------------------------------------------------
			CSQL = "		UPDATE [SportsDiary].[dbo].[tblPlayer] " 
			CSQL = CSQL & "	SET Team = '"&TeamCode&"' "
			CSQL = CSQL & "	WHERE DelYN = 'N' "
			CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
			CSQL = CSQL & "		AND EnterType = 'A' "
			CSQL = CSQL & "		AND PlayerIDX = '"&PlayerIDX&"' "

			DBcon.Execute(CSQL)
			ErrorNum = ErrorNum + DBcon.Errors.Count				
			'-----------------------------------------------------------------------------------
			'UPDATE : tblMember 보호자 -PlayerReln[A,B,Z] PlayerIDX :매칭된 선수 PlayerIDX 정보
			'-----------------------------------------------------------------------------------
			CSQL = "		UPDATE [SportsDiary].[dbo].[tblMember] " 
			CSQL = CSQL & "	SET Team = '"&TeamCode&"' "
			CSQL = CSQL & "	WHERE DelYN = 'N' "
			CSQL = CSQL & "		AND SportsType = '"&SportsGb&"'"
			CSQL = CSQL & "		AND EnterType = '"&EnterType&"'"
			CSQL = CSQL & "		AND PlayerReln IN('A','B','Z')"
			CSQL = CSQL & "		AND PlayerIDX = '"&PlayerIDX&"'"

			DBcon.Execute(CSQL)
			ErrorNum = ErrorNum + DBcon.Errors.Count		
			'-----------------------------------------------------------------------------------
			'UPDATE: tblMember 본인-PlayerReln[R] :PlayerIDX, Team
			'-----------------------------------------------------------------------------------
			CSQL =  " 		SET NOCOUNT ON "
			CSQL = CSQL & "	IF EXISTS( "
			CSQL = CSQL & " 	SELECT MemberIDX " 
			CSQL = CSQL & "		FROM [SportsDiary].[dbo].[tblMember] "
			CSQL = CSQL & " 	WHERE DelYN = 'N' "
			CSQL = CSQL & " 		AND SportsType = '"&SportsGb&"' " 
			CSQL = CSQL & "			AND MemberIDX = '"&MemberIDX&"' " 
			CSQL = CSQL & "	) "
			CSQL = CSQL & "	BEGIN " 					
			CSQL = CSQL & "		UPDATE [SportsDiary].[dbo].[tblMember] " 
			CSQL = CSQL & "		SET Team = '"&TeamCode&"' "
			CSQL = CSQL & "		WHERE DelYN = 'N' AND MemberIDX = '"&MemberIDX&"' "
			CSQL = CSQL & " 	SELECT Team" 
			CSQL = CSQL & "		FROM [SportsDiary].[dbo].[tblMember] "
			CSQL = CSQL & " 	WHERE DelYN = 'N' AND MemberIDX = '"&MemberIDX&"' "
			CSQL = CSQL & "	END " 
			CSQL = CSQL & " SET NOCOUNT OFF "
			
	'		response.Write CSQL
	
			SET CRs = DBcon.Execute(CSQL)
			ErrorNum = ErrorNum + DBcon.Errors.Count	
			
			IF Not(CRs.eof or CRs.bof) Then
				'업데이트 후 소속팀 쿠키변경처리
				Response.Cookies("Team") = encode(CRs("Team"), 0)
			End IF			
				CRs.Close
			SET CRs = Nothing
				
			
			IF ErrorNum > 0 Then
				DBcon.RollbackTrans()
				response.Write "FALSE|66"
				response.End()
			Else	
				DBcon.CommitTrans()
				response.Write "TRUE|"
				response.End()
			End IF
			
			'초기화
			ErrorNum = 0
			
		END SELECT

		
		DBClose()
		
	End If 

%>