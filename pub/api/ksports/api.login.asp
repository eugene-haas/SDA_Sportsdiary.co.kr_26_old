<%
	ID = oJSONoutput.ID
	PWD = oJSONoutput.PWD

	ID = chkLength(chkStrRpl(ID, "") ,30)
	PWD = chkLength(chkStrRpl(PWD, "") ,20)


	Set db = new clsDBHelper

	strTable = " tblGameManager "
	If USER_IP = "118.33.86.240" Then
		StrWhere = "  DelYN = 'N' AND ManagerID = '" & ID & "' AND ManagerPwd = '" + PWD + "'"
	else
		StrWhere = "  DelYN = 'N' AND ManagerID = '" & ID & "' AND ManagerPwd = '" + PWD + "'"
	End if
	SQL = "SELECT TOP 1 ManagerID, HostCode, Gubun  FROM " & strTable & " WHERE " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof then
		logincheck = 0
	Else
		logincheck = 1
		'암호화된 세션 생성
		session("user_id")       = f_enc(ID)
		session("hostcode") =	f_enc(rs("HostCode"))
		session("gubun") =	f_enc(rs("gubun"))

		tennisinfo = f_enc(  ID &"_`_"& rs("HostCode")&"_`_"& rs("gubun")  )
		Response.Cookies("tennisinfo") = tennisinfo
		'Response.Cookies("tennisinfo").expires = Date + 1
		Response.Cookies("tennisinfo").domain = CHKDOMAIN
	End if

	If LCase(ID) = "widline1234" Then
		targeturl = "./klist.asp"
	Else
		targeturl = "./klist.asp"
	End if

	jstr = "{""result"":""0"",""logincheck"":""" & logincheck & """,""targeturl"":"""  & targeturl  & """}"
	Response.write jstr

	db.Dispose
	Set db = Nothing
%>