<!--#include file="../Library/ajax_config.asp"-->
<%
	dim element : element = fInject(Request("element"))
	dim attname : attname = fInject(Request("attname"))	
	dim code : code    = fInject(Request("code"))	
	dim SEX : SEX	= fInject(Request("SEX"))
	dim TeamGb : TeamGb	= fInject(Request("TeamGb"))
	
	dim txtSEX
	
	If SEX = "" OR TeamGb = "" Then 
		Response.End
	Else
		
		SELECT CASE SEX
			CASE "Man" : txtSEX = "남자"
			CASE "WoMan" : txtSEX = "여자"
		END SELECT	

		LSQL =  " 	SELECT Level " &_
				"		, LevelNm  " &_
				"	FROM [Sportsdiary].[dbo].[tblLevelInfo] " &_
				"	WHERE TeamGb in ( " &_
				"		SELECT TeamGb FROM [Sportsdiary].[dbo].[tblTeamGbInfo] " &_
				"		WHERE  DelYN='N' " &_
				"			And SportsGb = '"&SportsGb&"' " &_
				"			And Sex='"&SEX&"' " &_	
				"			And PTeamGb = '"&TeamGb&"' " &_
				"		) "
		
		SET LRs = Dbcon.Execute(LSQL)
		If Not(LRs.Eof Or LRs.Bof) Then 
			
			selData = "<select name='"&attname&"' id='"&attname&"'>"
			selData = selData&"<option value=''>체급선택</option>"
					
			Do Until LRs.Eof 
	
				selData = selData &"<option value='"&LRs("Level")&"'>"
				selData = selData &		txtSEX&" "&LRs("LevelNm")
				selData = selData &"</option>"	
	
				LRs.MoveNext
			Loop 
	
			selData = selData&"</select>"	
	
		End If 
		
			LRs.Close
		SET LRs = Nothing
		
		Response.Write selData	
	
		DBClose()
	
	End If 
	
%>