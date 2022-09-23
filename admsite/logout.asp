<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<%
	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1
	Response.AddHeader "pragma","no-cache"
	Response.AddHeader "cache-control","private"
	Response.CacheControl = "no-cache"
%>
<!-- #include virtual = "/pub/cfg/cfg.Adm.asp" -->
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

	Response.redirect "/pub/admlogin.asp"
%>