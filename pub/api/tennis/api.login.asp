<%
	ID = oJSONoutput.ID
	PWD = oJSONoutput.PWD

	ID = chkLength(chkStrRpl(ID, "") ,30)
	PWD = chkLength(chkStrRpl(PWD, "") ,20)


	Set db = new clsDBHelper

	strTable = " tblGameManager "
	If USER_IP = "112.187.195.132" Then
		StrWhere = "  DelYN = 'N' AND SportsGb = 'judo' AND ManagerID = '" & ID & "' "
		'StrWhere = "  DelYN = 'N' AND ManagerID = '" & ID & "' AND ManagerPwd = '" + PWD + "'"
		'StrWhere = "  DelYN = 'N'"
	else
		'StrWhere = "  DelYN = 'N'"
		'StrWhere = "  DelYN = 'N' AND SportsGb = 'judo' AND ManagerID = '" & ID & "' AND ManagerPwd = '" + PWD + "'"
		StrWhere = "  DelYN = 'N' AND ManagerID = '" & ID & "' AND ManagerPwd = '" + PWD + "'"
	End if
	SQL = "SELECT TOP 1 ManagerID, HostCode, Gubun  FROM " & strTable & " WHERE " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql

'	Response.write ConStr & "<br>"
	If rs.eof then
		logincheck = 0
	Else
		logincheck = 1
		'암호화된 세션 생성
		session("user_id")       = f_enc(ID)
		session("hostcode") =	f_enc(rs("HostCode"))
		session("gubun") =	f_enc(rs("gubun"))

		tennisinfo = f_enc(  ID &"_`_"& rs("HostCode")&"_`_"& rs("gubun")  )
		'tennisinfo = ID &"80_80"& rs("HostCode")&"80_80"& rs("gubun")
		'Response.AddHeader "Set-Cookie" , "tennisinfo="& tennisinfo &"; expires=" & dateAdd("d", 365, Now()) & ";path=/;HttpOnly;domain=sportsdiary.co.kr"  'Response.AddHeader 
		Response.Cookies("tennisinfo") = tennisinfo
		'Response.Cookies("tennisinfo").expires = Date + 1
		Response.Cookies("tennisinfo").domain = CHKDOMAIN
	End if


	'Set db = new clsDBHelper
	'sql = "" &_
	'		"SELECT " &_
	'		" SEQ,RECEIVER_CUST_NAME " &_
	'		"FROM IC_T_ALPHA_GD " &_
	'		"WHERE SEQ=? AND USE_YN='Y' "
	'
	'params = Array(_
	'				db.MakeParam("@seq" ,adInteger ,adParamInput ,"" ,seq) _
	'				)
	'Set rs = db.ExecSQLReturnRS(sql, params, ConStr)


	jstr = "{""result"":""0"",""logincheck"":""" & logincheck & """}"
	'jstr = "{""result"":""0"",""logincheck"":""1""}"
	Response.write jstr


	db.Dispose
	Set db = Nothing
%>