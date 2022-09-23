<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%

'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'삭제
'#############################################
	'request
	If hasown(oJSONoutput, "CHKNO") = "ok" then
		chkno = oJSONoutput.Get("CHKNO")
	End if

	'내부테스트
	If USER_IP = DEBUG_IP Then
		Session.Contents.Remove("chkrndno")
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if


	'인증번호 확인
	sessionChkno = session("chkrndno")
	If CStr(chkno) = CStr(sessionChkno)  Then
		'session("chkrndno") = ""
		Session.Contents.Remove("chkrndno")
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	Else
		Call oJSONoutput.Set("result", "4" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson	
	End if
%>


