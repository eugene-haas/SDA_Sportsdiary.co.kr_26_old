<!--#include file="../Library/ajax_config.asp"-->
<%
	'=================================================================================================
	'비등록선수 --> 등록선수 전환처리
	'=================================================================================================
	
	Check_Login()
	
	dim UpMemberIDX : UpMemberIDX 	= fInject(Request("MemberIDX"))
	dim UpPlayerIDX : UpPlayerIDX 	= fInject(Request("PlayerIDX"))
	dim Team 		: Team 			= fInject(Request("Team"))
	dim SportsType 	: SportsType 	= fInject(Request("SportsType"))
	
	
	dim CSQL, CRs
	
	If UpMemberIDX = "" Or UpPlayerIDX = "" OR Team = "" OR SportsType = "" Then 
		RE_DATA = "FALSE|1"
		Response.End
	Else
		'EnterType = E
		'업데이트 할 회원정보 조회
		CSQL =  " 		SET NOCOUNT ON "
		CSQL = CSQL & "	IF EXISTS( "
		CSQL = CSQL & " 			SELECT MemberIDX " 
		CSQL = CSQL & "				FROM [SportsDiary].[dbo].[tblMember] "
		CSQL = CSQL & " 			WHERE DelYN = 'N' "
		CSQL = CSQL & " 				AND SportsType = '"&SportsType&"' " 
		CSQL = CSQL & "					AND MemberIDX = '"&UpMemberIDX&"' " 
		CSQL = CSQL & "			) "
		CSQL = CSQL & "		BEGIN " 
		CSQL = CSQL & "			UPDATE [SportsDiary].[dbo].[tblMember] " 
		CSQL = CSQL & "			SET PlayerIDX = '"&UpPlayerIDX&"' "
		CSQL = CSQL & "				,Team = '"&Team&"' "
		CSQL = CSQL & "				,PlayerReln = 'R' "
		CSQL = CSQL & "				,PlayerType = 'sd045001' "
		CSQL = CSQL & "				,EnterType = 'E' "
		CSQL = CSQL & "			WHERE DelYN = 'N' "
		CSQL = CSQL & "				AND SportsType = '"&SportsType&"' "
		CSQL = CSQL & "				AND MemberIDX = '"&UpMemberIDX&"' "
		CSQL = CSQL & " 		SELECT PlayerIDX " 
		CSQL = CSQL & " 			,Team" 
		CSQL = CSQL & " 			,PlayerReln" 
		CSQL = CSQL & " 			,'TRUE' ChkData "
		CSQL = CSQL & "			FROM [SportsDiary].[dbo].[tblMember] "
		CSQL = CSQL & " 		WHERE DelYN = 'N' "
		CSQL = CSQL & " 			AND SportsType = '"&SportsType&"' " 
		CSQL = CSQL & "				AND MemberIDX = '"&UpMemberIDX&"' "
		CSQL = CSQL & "		END " 
		CSQL = CSQL & "	ELSE " 
		CSQL = CSQL & "		BEGIN " 
		CSQL = CSQL & " 		SELECT PlayerIDX " 
		CSQL = CSQL & " 			,Team" 
		CSQL = CSQL & " 			,PlayerReln" 
		CSQL = CSQL & " 			,'FALSE' ChkData "
		CSQL = CSQL & "			FROM [SportsDiary].[dbo].[tblMember] "
		CSQL = CSQL & " 		WHERE DelYN = 'N' "
		CSQL = CSQL & " 			AND SportsType = '"&SportsType&"' " 
		CSQL = CSQL & "				AND MemberIDX = '"&UpMemberIDX&"' "
		CSQL = CSQL & "		END " 
		CSQL = CSQL & " SET NOCOUNT OFF "
		
'		response.Write CSQL
		
		SET CRs = Dbcon.Execute(CSQL)
		IF Not(CRs.eof or CRs.bof) Then
		
			SELECT CASE CRs("ChkData")
				
				CASE "TRUE"
					RE_DATA = "TRUE|"
					Response.Cookies("PlayerIDX") = encode(CRs("PlayerIDX"), 0)
					Response.Cookies("Team") = encode(CRs("Team"), 0)
					Response.Cookies("PlayerReln") = encode("R", 0)
				
				CASE "FALSE"	
					RE_DATA = "FALSE|2"
			
			END SELECT	
		
		End IF			
			CRs.Close
		SET CRs = Nothing
		
		DBClose()
		
	End If 
	
	response.Write RE_DATA
%>