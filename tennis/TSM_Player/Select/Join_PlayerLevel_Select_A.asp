<!--#include file ="../Library/ajax_config.asp"-->
<%
	'==============================================================================
	'체급조회(회원가입) 페이지
	'생활체육 EnterType = A
	'==============================================================================
	
'	dim element 	: element 		= fInject(Request("element"))
	dim attname 	: attname 		= fInject(Request("attname"))	
'	dim code 		: code    		= fInject(Request("code"))	
	dim SEX 		: SEX			= fInject(Request("SEX"))
	dim TeamGb 		: TeamGb		= fInject(Request("TeamGb"))
	dim EnterType 	: EnterType		= fInject(Request("EnterType"))
	
	dim txtSEX
	
	If SEX = "" OR TeamGb = "" Then 
		Response.End
	Else
		
		SELECT CASE SEX
			CASE "Man" : txtSEX = "남자"
			CASE "WoMan" : txtSEX = "여자"
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
		IF Not(LRs.Eof Or LRs.Bof) Then 
			Do Until LRs.Eof 
				selData = selData &"<option value='"&LRs("Level")&"'>"&LRs("TeamGbNm")&" "&LRs("LevelNm")&"</option>"		
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