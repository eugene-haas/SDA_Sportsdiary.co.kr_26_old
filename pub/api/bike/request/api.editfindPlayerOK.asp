<%
'######################
'팀원 변경 완료
'######################

	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	If hasown(oJSONoutput, "ridx") = "ok" then
		ridx = oJSONoutput.ridx
	End if
	

	If hasown(oJSONoutput, "attmidx") = "ok" Then 
		attmidx = oJSONoutput.attmidx
	End If

	If hasown(oJSONoutput, "findnm") = "ok" Then 
		findnm = oJSONoutput.findnm
	End If

	'##############################
	Set db = new clsDBHelper


	fieldstr = "MemberIDX,userID,UserName,userPhone,birthday,sex,email,zipcode,address "
	SQL = "select " & fieldstr & " from tblMember where userID = '" & findnm & "' "
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

	If rs.eof Then
		Call oJSONoutput.Set("result", "400" ) '존재하지 않는 아이디
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson & "`##`"
		Response.End
	else
		Uidx = rs("MemberIDX")
		userID		= rs("userID")
		UserName		= rs("UserName")
		userPhone		= rs("userPhone")
		If userphone <> "" Then
			phonestr = Left(userphone,8) &"-****"
		End if
		birthday		= rs("birthday")
		birthstr = Left(birthday,4)& "." & Mid(birthday,5,2) & "." & Mid(birthday,7,2)
		sex		= LCase(rs("sex"))
		email		= rs("email")
		zipcode		= rs("zipcode")
		address				= rs("address")
	End if

	SQL = "select  playeridx,memberidx,username from tblMember where  PlayerReln='R' and SD_userID = '"&findnm&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If rs.eof Then
		Call oJSONoutput.Set("result", "401" ) '자전거 선수로 등록되지 않은..
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson & "`##`"
		Response.end
	else
		playeridx = rs(0)
	End if


	SQL = "update sd_bikeAttMember Set PlayerIDX = "&playeridx&" ,userName = '"&userName&"' where attmidx = " & attmidx
	Call db.execSQLRs(SQL , null, ConStr)



		Call oJSONoutput.Set("fnm", findnm )		
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.write strjson

	db.Dispose
	Set db = Nothing
%>