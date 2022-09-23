<!--#include file ="../Library/ajax_config.asp"-->
<%
	'=====================================================================================================
	'국가대표 회원 가입시 팀소속 조회 셀렉박스 생성페이지
	'=====================================================================================================
	dim EnterType	: EnterType 	= fInject(Request("EnterType"))
	dim attname 	: attname 		= fInject(Request("attname"))	
	
	IF attname = "" OR EnterType = "" Then 
		Response.End
	End IF 
	
	dim selData 
	dim LSQL, LRs
	
'	response.Write "EnterType="&EnterType&"<br>"
'	response.Write "attname="&attname&"<br>"
'	response.End()

	selData = "<select name='"&attname&"' id='"&attname&"'>"

	LSQL =  " 		SELECT Team"
	LSQL = LSQL & "		,TeamNm " 
	LSQL = LSQL & "		,CASE Sex WHEN 1 THEN '(남)' WHEN 2 THEN '(여)' WHEN 3 THEN '(남+여)' END SEX " 
	LSQL = LSQL & "		,Address " 
	LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblTeamInfo] " 
	LSQL = LSQL & " WHERE DelYN = 'N' " 
	LSQL = LSQL & "		AND SportsGb = '"&SportsGb&"' "
	LSQL = LSQL & "		AND EnterType = '"&EnterType&"' "
	LSQL = LSQL & "		AND PTeamGb = '90'" 
	LSQL = LSQL & " ORDER BY TeamNm ASC " 

	
	SET LRs = Dbcon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 		
		
		selData = selData & "<option value=''>:: 소속선택 ::</option>"
				
		Do Until LRs.Eof 

			selData = selData & "<option value='"&LRs("Team")&"'>"&LRs("TeamNm")&LRs("SEX")&"</option>"	

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