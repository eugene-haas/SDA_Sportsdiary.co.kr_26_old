<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%


		Dim arrinfo(5)
		arrinfo(0) = "a"
		arrinfo(1) = "b"
		arrinfo(2) = "c"
		arrinfo(3) = "e"
		arrinfo(4) = "d"
		arrinfo(5) = "f"

		'session("leaderinfo") = arrinfo

		Set mobj =  JSON.Parse("{}")
		Call mobj.Set("a", arrinfo(0) )
		Call mobj.Set("aID", arrinfo(1) )
		Call mobj.Set("aNM", arrinfo(2) )	
		Call mobj.Set("c", arrinfo(3) )
		Call mobj.Set("d", arrinfo(4) )
		Call mobj.Set("e", arrinfo(5) )
		strmemberjson = JSON.stringify(mobj)
'		strmemberjson = f_enc(strmemberjson)

		Response.Cookies("leaderinfo") = strmemberjson
		Response.Cookies("leaderinfo").domain = CHKDOMAIN
	

Response.write request.cookies("leaderinfo")

%>