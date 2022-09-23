<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<%
	PAGENAME = LCase(Mid(Request.ServerVariables("URL"), InStrRev(Request.ServerVariables("URL"), "/") + 1))

	If Left(PAGENAME, 3) = "req" Then 'ajax 콜파일만 적용되도록
		Response.Expires = -1
		Response.Expiresabsolute = Now() - 1
		Response.AddHeader "pragma","no-cache"
		Response.AddHeader "cache-control","private"
		Response.CacheControl = "no-cache"
	End if


	'ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=IcheonUser;Password=#icheonuser$20191104%;Initial Catalog=ICHEON;Data Source=49.247.3.208\SQLExpress,1433;"
	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=IcheonUser;Password=#icheonuser$20191104%;Initial Catalog=IC_RETORE;Data Source=49.247.3.208\SQLExpress,1433;"

	'ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sportsdiary;Password=dnlemfkdls715)@*@;Initial Catalog=SD_Member;Data Source=115.68.112.26;"
%>
<!-- #include virtual = "/pub/class/db_helper.asp" -->
<%
	Set db = new clsDBHelper 

	SQL = "select top 1 * from tb_file "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


%>


<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=3">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge, chrome=1">
    <title>Tournament Tree</title>

  <body>


  
  <%
  

  %>
  </body>
</html>

