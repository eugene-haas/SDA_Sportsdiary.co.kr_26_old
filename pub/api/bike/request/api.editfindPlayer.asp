<%
'######################
'참가신청완료
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


	strWhere = "   DelYN = 'N' and attmidx = "& attmidx '(현재 등록된선수

	strWhere = "   DelYN = 'N' and titleIdx = "& tidx & " and ridx = " & ridx
	tablename = "  v_bikeGame_attm  "
	strFieldName = "playeridx, levelno"
	SQL = "Select " & strFieldName & " from "&tablename&" where " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		Call oJSONoutput.Set("result", "401" ) '자전거 선수로 등록되지 않은..
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson & "`##`"
		Response.end
	Else
		levelidx = rs("levelno")
	End if

	'참가 플레이어 중복확인 levelno 꼬임 그냥 쓰자.
	SQL = "select  a.requestIDX from  sd_bikeRequest as a INNER JOIN v_bikeGame_attm as b ON a.gameIDX= b.gameIDX and a.levelno = b.levelno  where b.gubun in (0,1) and b.sex = '"&sex&"' and a.titleIDX = "&tidx&" and a.levelno = "&levelidx&" and b.playeridx  =  " & playeridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		Call oJSONoutput.Set("result", "300" ) '이미 참가중인 선수 중복
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson & "`##`"
		Response.end
	End if


		Call oJSONoutput.Set("fnm", findnm )		
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson & "`##`"

	db.Dispose
	Set db = Nothing
%>						

	<li>
	  <span><%=username%>(<%=findnm%>)</span>
	</li>
	<li>
	  <span><%=birthstr%></span>
	</li>
	<li>
	  <span><%=phonestr%></span>
	</li>