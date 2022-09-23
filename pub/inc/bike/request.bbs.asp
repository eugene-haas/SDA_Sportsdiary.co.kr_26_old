<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>

<%

  'request 처리##############
	REQ = chkReqMethod("p", "POST")

	''디버그 프린트
	'Call debugprint(req)
	''디버그 프린트

	If REQ <> "" then
	Set oJSONoutput = JSON.Parse(REQ)
		page = chkInt(oJSONoutput.pg,1)

		If hasown(oJSONoutput, "sv") = "ok" Then
			svalue = chkLength(chkStrRpl(oJSONoutput.sv, ""), 20)
		End if

		'If hasown(oJSONoutput, "c") = "ok" then
		'	bbscfg = oJSONoutput.c
		'End If

		If hasown(oJSONoutput, "tid") = "ok" then
			tid = oJSONoutput.tid
		Else
			tid = 1
		End If

		If hasown(oJSONoutput, "tidx") = "ok" then
			tidx = oJSONoutput.tidx
		End If

		If hasown(oJSONoutput, "GY") = "ok" then
			GY = oJSONoutput.GY
		End If
		If hasown(oJSONoutput, "levelno") = "ok" then
			levelno = oJSONoutput.levelno
		End If


		If hasown(oJSONoutput, "seq") = "ok" then
			seq = oJSONoutput.seq
		End If


		If hasown(oJSONoutput, "returnurl") = "ok" then
			returnurl = oJSONoutput.returnurl
		Else
			 returnurl= NOW_URL
			If NOW_URL = "" then
				returnurl = "/index.asp"
			End If
			Call oJSONoutput.Set( "returnurl",  returnurl )
		End if
	Else

		'findmode 전체검색
		tid = chkInt(chkReqMethod("tid", "GET"), 1) '테이블아이디
		page = chkInt(chkReqMethod("page", "GET"), 1)

		Set oJSONoutput = JSON.Parse("{}")
		Call oJSONoutput.Set( "pg",  page )
		Call oJSONoutput.Set( "CMD",  100 )
		Call oJSONoutput.Set( "SEQ",  0 )

		returnurl= NOW_URL
		If NOW_URL = "" then
			returnurl = "/index.asp"
		End If
		Call oJSONoutput.Set( "returnurl",  returnurl )
	End if
  'request 처리##############




  logouturl = "/pub/pub.logout.asp"
  loginurl = "/Admin/main/AdminMenu/Admin_Login.asp"
  reqjson = JSON.stringify(oJSONoutput)


%>
