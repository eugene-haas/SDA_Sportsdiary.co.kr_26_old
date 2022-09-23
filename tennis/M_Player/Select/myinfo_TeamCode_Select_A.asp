<!--#include file ="../Library/ajax_config.asp"-->
<%
	'=====================================================================================================
	'생활체육 회원 가입시 팀소속 조회 셀렉박스 생성페이지
	'=====================================================================================================
	dim element 	: element 		= fInject(Request("element"))
	dim attname 	: attname 		= fInject(Request("attname"))	
	dim code		: code    		= fInject(Request("code"))
	dim EnterType	: EnterType 	= "A"
	
	IF code = "" OR attname = "" Then 
		Response.End
	End IF 
	
	dim selData 
	dim LSQL, LRs
	
	dim array_code 	: array_code 	= Split(code,",")
	dim AreaGb 		: AreaGb 		= array_code(0)		
	dim AreaGbDt 	: AreaGbDt 		= array_code(1)
	
	
	selData = "<select name='"&attname&"' id='"&attname&"'>"
		
			
	LSQL =  " 		SELECT Team"
	LSQL = LSQL & "		,TeamNm " 
	LSQL = LSQL & "		,CASE Sex WHEN 1 THEN '(남)' WHEN 2 THEN '(여)' WHEN 3 THEN '(남+여)' END SEX " 
	LSQL = LSQL & "		,Address " 
	LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblTeamInfo] " 
	LSQL = LSQL & " WHERE DelYN = 'N' " 
	LSQL = LSQL & "		AND SportsGb = '"&SportsGb&"' "
	LSQL = LSQL & "		AND EnterType = '"&EnterType&"' "
	LSQL = LSQL & "		AND sido = '"&AreaGb&"' " 
	LSQL = LSQL & "		AND Address like '%"&AreaGbDt&"%' " 
	LSQL = LSQL & " ORDER BY TeamNm ASC " 
	LSQL = LSQL & "		,Sex ASC "
	
	
			
	SET LRs = Dbcon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		
		
		selData = selData & "<option value=''>:: 소속(체육관) 선택 ::</option>"
				
		Do Until LRs.Eof 

			'selData = selData & "<option value='"&LRs("Team")&"'>"&LRs("TeamNm")&LRs("SEX")&"</option>"	
			selData = selData & "<option value='"&LRs("Team")&"'>"&LRs("TeamNm")&"</option>"	

			LRs.MoveNext
		Loop 

		
	Else
		selData = selData & "<option value=''>:: 소속없음 ::</option>"
			
	End If 
	
		LRs.Close
	SET LRs = Nothing
	
	selData = selData&"</select>"	
	
	Response.Write selData	

	DBClose()

%>