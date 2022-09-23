<%

If REQ <> "" then
    If hasown(oJSONoutput, "returnurl") = "ok" then
    	returnurl = oJSONoutput.returnurl
    Else
    	 returnurl= NOW_URL
    	If NOW_URL = "" then
    		returnurl = "/index2.asp"
    	End If
    	Call oJSONoutput.Set( "returnurl",  returnurl )
    End if
Else
    Set oJSONoutput = JSON.Parse("{}")
    page = chkInt(chkReqMethod("page", "GET"), 1)
    Call oJSONoutput.Set( "pg",  page )

	returnurl= NOW_URL
	If NOW_URL = "" then
		returnurl = "/index2.asp"
	End If
	Call oJSONoutput.Set( "returnurl",  returnurl )
End if

logouturl = "/pub/pub.logout.asp"
loginurl = "/Admin/main/AdminMenu/Admin_Login.asp"
reqjson = JSON.stringify(oJSONoutput)

  %>
