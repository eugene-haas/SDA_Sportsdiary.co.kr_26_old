<%
cookiesInfo = request.cookies("tennisinfo")

If cookiesInfo <> "" Then
	cookiesInfoArr =  Split(f_dec(cookiesInfo), "_`_")
	ck_id = cookiesInfoArr(0)
	ck_hostcode = cookiesInfoArr(1)
	ck_gubun = cookiesInfoArr(2)
End if


	se_userid				= f_dec(session("user_id"))
	se_hostcode		= f_dec(session("hostcode"))
	se_gubun				= f_dec(session("gubun"))


	ADGRADE = 700
	If LCase(ck_id) = "tennis" Then 'password tennis1234 현장운영자
		'999최고 운영자는 500번부터 
		ADGRADE = 500
	End if
%>