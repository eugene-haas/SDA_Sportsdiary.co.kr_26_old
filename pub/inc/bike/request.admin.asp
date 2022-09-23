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
		selecttype = "search"
		page = chkInt(oJSONoutput.pg,1)

		If hasown(oJSONoutput, "sv") = "ok" Then
			svalue = chkLength(chkStrRpl(oJSONoutput.sv, ""), 20)
			If svalue = "" Then
			   selecttype = "default"
			End if
		Else
			selecttype = "default"
		End if

		If hasown(oJSONoutput, "tidx") = "ok" then
			tidx = oJSONoutput.tidx
		Else
			tidx = 0
		End If

		If hasown(oJSONoutput, "ridx") = "ok" then
			ridx = oJSONoutput.ridx
		Else
			ridx = 0
		End if


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
		page = chkInt(chkReqMethod("page", "GET"), 1)
		selecttype = "default"

		Set oJSONoutput = JSON.Parse("{}")
		Call oJSONoutput.Set( "pg",  page )

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
