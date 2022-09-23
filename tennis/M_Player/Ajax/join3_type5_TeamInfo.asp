<!--#include file ="../Library/ajax_config.asp"-->
<%
	'================================================================================
	'팀소속정보 조회 및 출력
	'join3_type5.asp
	'================================================================================
	
	dim TeamCode 	: TeamCode 	= fInject(Request("TeamCode"))
	dim EnterType 	: EnterType = fInject(Request("EnterType"))

	IF TeamCode = "" OR EnterType = "" Then 
		Response.End
	End IF

	
	dim selData 
	dim LSQL, LRs
	
	LSQL =  " 		SELECT TeamNm " 
	LSQL = LSQL & " 	,Address" 
	LSQL = LSQL & " 	,ISNULL(AddrDtl,'') AddrDtl" 
	LSQL = LSQL & " 	,ISNULL(TeamTel,'') TeamTel" 
	LSQL = LSQL & "		,CASE Sex WHEN 1 THEN '(남)' WHEN 2 THEN '(여)' WHEN 3 THEN '(남+여)' END SEX " 
	LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblTeamInfo] " 
	LSQL = LSQL & " WHERE DelYN = 'N' " 
	LSQL = LSQL & "		AND SportsGb = '"&SportsGb&"' "
	LSQL = LSQL & "		AND EnterType = '"&EnterType&"' "
	LSQL = LSQL & "		AND Team = '"&TeamCode&"' " 
	
'	response.Write LSQL
	
	SET LRs = Dbcon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		
'		selData = LRs("TeamNm")&LRs("SEX")&"|"&LRs("Address")&"|"&LRs("AddrDtl")&"|"&LRs("TeamTel")
'		selData = LRs("TeamNm")&"|"&LRs("Address")&"|"&LRs("AddrDtl")&"|"&LRs("TeamTel")
		selData = LRs("TeamNm")&"|"&LRs("Address")&"|"&LRs("AddrDtl")

	End If 
		LRs.Close
	SET LRs = Nothing
	
	Response.Write selData	

	DBClose()

%>