<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<%
	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1
	Response.AddHeader "pragma","no-cache"
	Response.AddHeader "cache-control","private"
	Response.CacheControl = "no-cache"

	URL_HOST        = Request.ServerVariables("HTTP_HOST")
	CHKDOMAIN = mid(URL_HOST,instr(URL_HOST,".")+1)
%>
<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->

<!-- #include virtual="/pub/class/json2.asp" -->
<!-- #include virtual = "/pub/inc/crypt.asp" -->
<!-- #include virtual = "/pub/inc/bike/request.admin.asp" -->
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

	'Response.redirect loginurl
%>
<!DOCTYPE html>
<html>
<head>
	<script type="text/javascript" src="/pub/js/common.js?ver=1"></script>
</head>
<body>
<form method="post"  name="sform" action="/index.asp">
<input type="hidden" name="p" id="p">
</form>


<script type="text/javascript">
<!--
	px.go(<%=reqjson%>, "<%=loginurl%>");
//-->
</script>

</body>
</html>
