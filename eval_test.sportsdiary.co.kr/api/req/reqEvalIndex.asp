<!-- #include virtual = "/admin/inc/header.admin.asp" -->
<%




	If request("test") = "t" Then
		REQ ="{""CMD"":301,""PARR"":[""E"",""SW70011"",""어쩌다"",""대한민국"",""서울"",""2"",""3"",""2019/12/19"",""2019/12/11"",""짱님"",""지도자님"",""10544"",""경기 고양시 덕양구 가양대로 110 (덕은동) 여기는어디"",""07011111111"",""2019/12/11""]}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if

	CMD_CREATE = 100
	CMD_READ = 20000
	CMD_UPDATE = 200
	CMD_DELETE = 300
	CMD_SETENDFLAG = 210
	CMD_SETUSEFLAG = 220



	Select Case CDbl(CMD)
	Case CMD_SETUSEFLAG
		%><!-- #include virtual = "/api/ajax/evalindex/api.setuseflag.evalindex.asp" --><%
		Response.end

	Case CMD_SETENDFLAG
		%><!-- #include virtual = "/api/ajax/evalindex/api.setendflag.evalindex.asp" --><%
		Response.end

	Case CMD_CREATE
		%><!-- #include virtual = "/api/ajax/evalindex/api.create.evalindex.asp" --><%
		Response.end
	Case CMD_DELETE
		%><!-- #include virtual = "/api/ajax/evalindex/api.delete.evalindex.asp" --><%
		Response.end
	End Select
%>
