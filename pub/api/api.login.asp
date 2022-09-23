<%

'CMD:1
'CMT:"테"
'DN:"ITEMCENTER"
'MD:2
'NM:"IC_T_ONLINE_GDS_2"


	ID = oJSONoutput.value("ID") 
	PWD = oJSONoutput.value("PWD")
	ISV = oJSONoutput.value("ISV") '정보저장 쿠키생성

	ID = chkLength(chkStrRpl(ID, "") ,30)
	PWD = chkLength(chkStrRpl(PWD, "") ,20)


	If ISV = "1" Then
		Response.AddHeader "Set-Cookie","saveinfo="&ID&"^"&PWD&"; expires=" & dateAdd("d", 365, Now()) & ";path=/;HttpOnly;"  'Response.AddHeader "Set-Cookie","saveinfo="&ID&"^"&PWD&";path=/;HttpOnly;domain=widline.co.kr"
		'정보 저장 쿠키생성
	Else
		Response.Cookies("saveinfo").Expires = Date - 365
	End if

	If LCase(ID) = "widline1234" Then
		targeturl = "./klist.asp"
	Else
		targeturl = "./index.asp"
	End if


	If ID = "widline" And PWD = "1111" Then
		logincheck = 1
		'암호화된 세션 생성
		session("user_id")       = f_enc(ID)
		session("user_name")       = f_enc("백승훈")
	Else
		logincheck = 0
	End if


	




	'ConStr = Replace(ConStr, "ITEMCENTER", DN)
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


	jstr = "{""result"":""0"",""logincheck"":""" & logincheck & """,""targeturl"":"""  & targeturl  & """}"
	Response.write jstr


	'db.Dispose
	'Set db = Nothing
%>