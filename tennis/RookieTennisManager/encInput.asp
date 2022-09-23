<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
response.end
'관리자 암호화키 단방향저장 
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/RookietennisAdmin/html.head.v1.asp" -->
<script type="text/javascript" src="/pub/js/RookieTennis/tennis_contest.js<%=CONST_JSVER%>"></script>




</head>

<body <%=CONST_BODY%>>

관리자 암호화키 단방향 패스워드 저장 <br><br>

<%
set encrypt512 = server.createobject("EncryptSha512.CESSA")


SQL = "Select AdminMemberIDX,userPass,encPass,encKey from tblAdminMember "
Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)


Do Until rs.eof
	uidx = rs(0)
	upwd = rs(1)


	strSault = encrypt512.GetSaultKey()
    strPass = strPrintf("{0}{1}", Array(strSault, upwd  ))
    strEncrypt = encrypt512.EncryptUsingSHA(strPass)

	'SQL = strPrintf("Update tblAdminMember set encKey = '{0}', encPass = '{1}' where AdminMemberIDX = {2} ", array( strSault, strEncrypt, uidx) )
	'Call db.execSQLRs(SQL , null, B_ConStr)


'strPass = "WU85Mbbc8mzreFnucm+GWabY3Uif9kD/8X7095XXo8g=1234"
'strEncrypt2 = "99e5994bdf96d340c1bd61d1a5b1edf66069c92953892a4a48aead2a2026322e3d86aa01f40bcfc0dcba4a92f68634ef971ac71ace77d62efdb96ec803d5cc79"
'strEncrypt = crypt.EncryptUsingSHA(strPass)


rs.movenext
loop


reqpwd = "padmin"

SQL = "Select encPass,encKey from tblAdminMember  where  AdminMemberIDX = 1 " 
Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

strkey = rs("encKey") & reqpwd
strEncrypt = encrypt512.EncryptUsingSHA(strkey)

%>
유저 : <%=rs("encPass")%><br>
생성 : <%=strEncrypt%><br>
<%


If rs("encPass") = strEncrypt Then
	Response.write "로그인 성공"
Else
	Response.write "로그인 실패"
End if



 
Set crypt = Nothing
%>








<!-- #include virtual = "/pub/html/RookietennisAdmin/html.footer.asp" -->	
</body>
</html>