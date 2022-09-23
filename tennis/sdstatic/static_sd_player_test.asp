<!--#include virtual="/dbconn/ICDbPath-utf8.inc"-->

<%

	ip = Request.ServerVariables("REMOTE_ADDR")

'if mid(trim(ip),1,14) <> "118.33.86.240" then
	strseturl =  Request.ServerVariables("http_host")&Request.ServerVariables("PATH_INFO")
	strsetmedia = "EE1"

	Set DBConStatic = Server.CreateObject("ADODB.Connection")
	DBConStatic.CommandTimeout = 1000
	DBConStatic.Open strConnect

	strqrystatic = " EXEC [SD_Tennis].[dbo].[Sd_Static_test] "
	strqrystatic = strqrystatic & " @media = '" & strsetmedia & "'"
	strqrystatic = strqrystatic & ",@url = '" & mid(strseturl, 1, len(strseturl)) & "'"		'http://제거
	
																								 
	DBConStatic.Execute(strqrystatic)
	DBConStatic.Close	
	Set DBConStatic = Nothing
'END IF
%>
