<!--#include file="../Library/ajax_config.asp"-->
<%
	dim element 	: element 	= fInject(Request("element"))
	dim attname 	: attname 	= fInject(Request("attname"))	
	dim code		: code    	= fInject(Request("code"))
	
	dim EnterType	: EnterType = "E"
	
	If code = "" Then 
		Response.End
	End If 
	
	dim selData 
	dim LSQL, LRs
	
	dim array_code 	: array_code 	= Split(code,",")
	dim TeamGb 		: TeamGb 		= array_code(0)		
	dim AreaGb	 	: AreaGb 		= array_code(1)
	
	
	selData = "<select name='"&attname&"' id='"&attname&"'>"
		
	LSQL =  " 		SELECT Team"
	LSQL = LSQL & "		,TeamNm " 
	LSQL = LSQL & "		,CASE Sex WHEN 1 THEN '(남)' WHEN 2 THEN '(여)' WHEN 3 THEN '(남+여)' END SEX " 
	LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblTeamInfo] " 
	LSQL = LSQL & " WHERE DelYN = 'N' " 
	LSQL = LSQL & "		AND SportsGb = '"&SportsGb&"' "
	LSQL = LSQL & "		AND EnterType = '"&EnterType&"' "
	LSQL = LSQL & "		AND PTeamGb = '"&TeamGb&"'" 
	LSQL = LSQL & "		AND sido = '"&AreaGb&"' " 
	LSQL = LSQL & " 	AND NowRegYN = 'Y' "
	LSQL = LSQL & " ORDER BY TeamNm ASC " 
	LSQL = LSQL & "		,Sex ASC "
			
	SET LRs = Dbcon.Execute(LSQL)
	If Not(LRs.Eof Or LRs.Bof) Then 
		
		
		selData = selData&"<option value=''>소속선택</option>"
				
		Do Until LRs.Eof 

			selData = selData &"<option value='"&LRs("Team")&"'>"&LRs("TeamNm")&LRs("SEX")&"</option>"	

			LRs.MoveNext
		Loop 

		
	Else
		selData = selData&"<option value=''>소속없음</option>"
			
	End If 
	
		LRs.Close
	SET LRs = Nothing
	
	selData = selData&"</select>"	
	
	Response.Write selData	

	DBClose()

%>