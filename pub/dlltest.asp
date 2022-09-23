<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

<%
	Set db = new clsDBHelper


	SQL = "select top 1 encKey,encPass  from tblAdminMember where UserID = '20181003' and delYN = 'N'  and useYN = 'Y' " '사용여부
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

	If rs.eof Then
		Response.write "오류"
		Response.end
	Else
		sKey = rs("encKey")
		sPass = rs("encPass")

		'단방향 암호화모듈
		Set encrypt512 = server.createobject("EncryptSha512.CESSA")
		strKey = sKey & upwd

		strEncrypt = encrypt512.EncryptUsingSHA(strKey)
		Set encrypt512 = Nothing

		Response.write "성공"
	End If
%>