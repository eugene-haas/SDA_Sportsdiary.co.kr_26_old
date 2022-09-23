<%
'######################
'폰번호 업데이트 (바이크에 있는 정보만 업데이트 한다. ㅡㅡ+
'######################

	'---------------
	If Cookies_midx = "" Then '로그인 여부체크
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If
	'---------------



	If hasown(oJSONoutput, "PNO") = "ok" then
		pno = oJSONoutput.PNO
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	'##############################
	Set db = new clsDBHelper

	fieldstr = "MemberIDX,userID,UserName,userPhone,birthday,sex,email,zipcode,address "
	SQL = "select " & fieldstr & " from tblMember where MemberIDX = " & Cookies_midx 
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

	If Not rs.eof Then
	Uidx = rs("MemberIDX")
	userID		= rs("userID")
	UserName		= rs("UserName")
	userPhone		= rs("userPhone")
	birthday		= rs("birthday")
	sex		= LCase(rs("sex"))
	email		= rs("email")
	zipcode		= rs("zipcode")
	address				= rs("address")
	End if


	fieldstr = "username,playerIDX "
	SQL = "select " & fieldstr & " from tblMember where PlayerReln='R' and sd_UserID = '"&userID&"'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	playerIDX  = rs("playerIDX")
	userNm = rs("username")


	'변경내용수정
	SQL = "update tblMember Set UserPhone = '"&pno&"' where memberIDX =  " & Uidx
	Call db.execSQLRs(SQL , null, T_ConStr)

	SQL = "update sd_bikePlayer Set UserPhone = '"&Replace(pno,"-","")&"' where playerIDX =  " & playerIDX
	Call db.execSQLRs(SQL , null, ConStr)



	Call oJSONoutput.Set("CHANGEVAL", pno  ) '변경된값
	Call oJSONoutput.Set("TARGETID", "pno_chk" ) '원위치값
	Call oJSONoutput.Set("FNO", 2 ) '원위치값
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>						
