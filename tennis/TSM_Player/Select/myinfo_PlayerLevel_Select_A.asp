<!--#include file = "../Library/ajax_config.asp"-->
<%
	'=====================================================================================
	'Mypage/Myinfo_type2.asp 체급조회 셀렉박스 생성 페이지
	'=====================================================================================
	dim attname 	: attname 		= fInject(Request("attname"))	
	dim SEX 		: SEX			= fInject(Request("SEX"))
	dim TeamGb 		: TeamGb		= fInject(Request("TeamGb"))

	dim MemberIDX	: MemberIDX		= decode(request.Cookies("MemberIDX"), 0)
	dim EnterType	: EnterType		= request.Cookies("EnterType")
	
	dim txtSEX
	dim chkPlayerLevel	
		
	If SEX = "" OR TeamGb = "" Then 		
		Response.End
	Else
		'가입회원 체급조회
		LSQL =  " 		SELECT PlayerLevel " 
		LSQL = LSQL & "	FROM [Sportsdiary].[dbo].[tblMember] " 
		LSQL = LSQL & "	WHERE DelYN = 'N' " 
		LSQL = LSQL & "		AND MemberIDX = "&	MemberIDX			
		
		SET LRs = Dbcon.Execute(LSQL)	
		IF Not(LRs.eof or LRs.bof) Then
			chkPlayerLevel = LRs(0)		
		End IF		
			LRs.Close
		
		'체급[성별 붙이기]			
		SELECT CASE SEX
			CASE "Man" 		: txtSEX = "남자"
			CASE "WoMan" 	: txtSEX = "여자"
		END SELECT	
		
		selData = "<select name='"&attname&"' id='"&attname&"'>"
		selData = selData&"<option value=''>:: 체급선택 ::</option>"
			
		LSQL = "		SELECT I.Level "
		LSQL = LSQL & "		,I.LevelNm "		  
		LSQL = LSQL & "		,T.TeamGbNm "
		LSQL = LSQL & "		,T.TeamGb "
		LSQL = LSQL & "	FROM [Sportsdiary].[dbo].[tblLevelInfo] I "
		LSQL = LSQL & "		inner join [Sportsdiary].[dbo].[tblTeamGbInfo] T on I.TeamGb = T.TeamGb "
		LSQL = LSQL & "			AND T.DelYN = 'N' "
		LSQL = LSQL & "			AND T.SportsGb = '"&SportsGb&"' "
		LSQL = LSQL & "			AND T.EnterType = '"&EnterType&"' "
		LSQL = LSQL & "			AND (T.Sex='"&SEX&"' OR T.Sex IS NULL OR T.Sex = '') "
		LSQL = LSQL & "			AND t.PTeamGb = '"&TeamGb&"' "
		LSQL = LSQL & "		WHERE I.DelYN = 'N' "
		LSQL = LSQL & "			AND I.SportsGb = '"&SportsGb&"' "
		LSQL = LSQL & "		ORDER BY T.Orderby "
		
		
		SET LRs = Dbcon.Execute(LSQL)
		If Not(LRs.Eof Or LRs.Bof) Then 
			Do Until LRs.Eof 
			
				selData = selData & "<option value='"&LRs("Level")&"'"
				
				IF chkPlayerLevel = LRs("Level") Then selData = selData & " selected "  
				
				selData = selData & ">"&LRs("TeamGbNm")&" "&LRs("LevelNm")&"</option>"		
				
				LRs.MoveNext
			Loop 
		End If 
		
			LRs.Close
		SET LRs = Nothing
		
		selData = selData&"</select>"
			
		Response.Write selData	
	
		DBClose()
	
	End If 
	
%>