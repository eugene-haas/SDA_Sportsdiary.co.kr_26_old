<%
'request
	If hasown(oJSONoutput, "CHKNO") = "ok" then
		chkno = oJSONoutput.CHKNO
	End if
'request


	'session("chkrndno") = ""
	'내부테스트
	' If USER_IP = "118.33.86.240" Then
	' 	session("chkrndno") = ""
	' 	Call oJSONoutput.Set("result", "0" )
	' 	strjson = JSON.stringify(oJSONoutput)
	' 	Response.Write strjson
	' 	Response.end
	' End if


	'인증번호 확인
	sessionChkno = session("chkrndno")
	If CStr(chkno) = CStr(sessionChkno)  Then
		session("chkrndno") = ""
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	Else
		Call oJSONoutput.Set("result", "4" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	End if

%>
