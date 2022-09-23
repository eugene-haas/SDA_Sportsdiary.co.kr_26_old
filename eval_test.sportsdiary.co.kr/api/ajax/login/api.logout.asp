<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<%@ codepage="65001" language="VBScript" %>
<%
	If request("EUCKR") = "Y" Then
		Response.CharSet="euc-kr"
		Session.codepage="65001"
		Response.codepage="65001"
		Response.ContentType="text/html;charset=euc-kr"
	Else
		Response.CharSet="utf-8"
		Session.codepage="65001"
		Response.codepage="65001"
		Response.ContentType="text/html;charset=utf-8"
	End If


	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1
	Response.AddHeader "pragma","no-cache"
	Response.AddHeader "cache-control","private"
	Response.CacheControl = "no-cache"
%>
<!-- #include virtual = "/api/cfg/cfg.asp" -->
<%
	session.Abandon
	
	for each Item in request.cookies
		if item = "saveinfo" or IsNumeric(item) = true then 'popup info / login info 
			'pass
		else
			Response.cookies(item).expires	= date - 1365
			Response.cookies(item).domain	= CHKDOMAIN	
		end if
	Next

	objstr = "{""errorcode"":""SUCCESS""}"
		strjson = objstr
	Response.Write strjson
%>