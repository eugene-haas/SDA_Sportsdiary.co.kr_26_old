<%'<!--#include virtual="/dbconn/ICDbPath-utf8.inc"-->%>

<%
'dim strip
'dim strurl
'dim strcut
'dim strcutcnt
'dim strsetmedia
'dim strsetrul

ip = Request.ServerVariables("REMOTE_ADDR")

'if mid(trim(ip),1,14) <> "118.33.86.240" then
'
'	strseturl =  Request.ServerVariables("http_host")&Request.ServerVariables("PATH_INFO")	
'	strsetmedia = "EE1"
'	
'	
'	Set DBConStatic = Server.CreateObject("ADODB.Connection")
'	DBConStatic.CommandTimeout = 1000
'	DBConStatic.Open strConnect
'	
'	strqrystatic = " EXEC SD_Tennis.DBO.Sd_Static "
'	strqrystatic = strqrystatic & " @media = '" & strsetmedia & "'"
'	strqrystatic = strqrystatic & ",@url = '" & strseturl & "'"
'	
'	DBConStatic.Execute(strqrystatic)
'	
'	DBConStatic.Close	
'	Set DBConStatic = Nothing
'end if

%>
