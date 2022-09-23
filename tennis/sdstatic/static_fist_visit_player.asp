<%'<!--#include virtual="/dbconn/ICDbPath-utf8.inc"-->%>

<%
'dim vtinckfist
'dim ipfist
'dim strurlfist
'dim strcutfist
'dim strcutcntfist
'dim strsetmediafist
'dim strsetrulfist
'
'vtinckfist = trim(Request.Cookies("vtinck"))
'ipfist = Request.ServerVariables("REMOTE_ADDR")
'
'if mid(trim(ipfist),1,14) <> "118.33.86.240" then
'	if vtinckfist <> "ok" then
'
'		Response.Cookies("vtinck") = "ok"
'        Response.Cookies("vtinck").Expires = date + 1 
'		
'		strsetmediafist = "EE1"		
'		
'		Set DBConStaticfist = Server.CreateObject("ADODB.Connection")
'            DBConStaticfist.CommandTimeout = 1000
'            DBConStaticfist.Open strConnect
'
'            strqrystaticfist = " EXEC SD_Tennis.DBO.Sd_Static_Visit "
'            strqrystaticfist = strqrystaticfist & " @media = '" & strsetmediafist & "'"
'
'            DBConStaticfist.Execute(strqrystaticfist)
'
'            DBConStaticfist.Close	
'		Set DBConStaticfist = Nothing
'		
'	end if
'end if	

%>
