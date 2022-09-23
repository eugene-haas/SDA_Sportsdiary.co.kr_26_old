<%
'######################
'참가신청완료
'######################

'{"pg":1,"tidx":23,"name":"참가종목선택","subtype":"2","chkgame":"121,루키:122,CAT3:","CMD":20010,"levelidx":121,"uid":"hjhjkhk"}

	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If

	If hasown(oJSONoutput, "subtype") = "ok" Then '개인 , 단체 1,2
		subtype = oJSONoutput.subtype
		If CDbl(subtype) = 1 then
			subtypestr = "개인"
		Else
			subtypestr = "단체"
		End if
	End If

	If hasown(oJSONoutput, "levelidx") = "ok" Then
		levelidx = oJSONoutput.levelidx
	End If

	If hasown(oJSONoutput, "uid") = "ok" Then '팀명칭
		uid = oJSONoutput.uid
	End If

	If hasown(oJSONoutput, "ids") = "ok" Then '탭의 아이디들 , 로
		ids = oJSONoutput.ids
	End If

	If hasown(oJSONoutput, "pno") = "ok" Then '배열위치번호 같은 위치에서 올경우 채크 해서 변경
		pno = oJSONoutput.pno
	End If

	'##############################
	Set db = new clsDBHelper

	idss = Split(ids,",")
	For i = 0 To ubound(idss)
'Response.write  idss(i) &"--"& uid & "<br>"
		If idss(i) = uid Then
			If i <> CDbl(pno) Then '배열번호가 다를때만 비교
				Call oJSONoutput.Set("result", "300" ) '중복
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson & "`##`"
				Response.End
			End if
		End if
	next


	'천지인체크값이 들어있지 않다. \u119E\u11A2
	'  var deny_char = /^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|+-ㅣ\u318D\u119E\u11A2\u2022\u2025a\u00B7\uFE55]+$/gi;
	'If stateRegExp(teamnm ,"[^-가-힣a-zA-Z0-9/ ]") = False then '한,영,숫자
	'	Call oJSONoutput.Set("result", "300" ) '사용하면 안되는 문자발생
	'	strjson = JSON.stringify(oJSONoutput)
	'	Response.Write strjson & "`##`"
	'	Response.end
	'End if

	fieldstr = "MemberIDX,userID,UserName,userPhone,birthday,sex,email,zipcode,address "
	SQL = " SELECT " & fieldstr & " FROM tblMember WHERE userID = '" & uid & "' AND DelYN = 'N' "
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

	SQL = "select  playeridx,memberidx,username from tblMember where  PlayerReln='R' and SD_userID = '"&uid&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If rs.eof Then
		Call oJSONoutput.Set("result", "401" ) '자전거 선수로 등록되지 않은..
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson & "`##`"
		Response.end
	else
		playeridx = rs(0)
	End if

	'성별체크


	'SQL = "select levelno from sd_bikeLevel where sex = '"&sex&"' and levelIDX = " & levelidx
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'levelno = rs(0)

	'참가 플레이어 중복확인
	SQL = "select  a.requestIDX from  sd_bikeRequest as a INNER JOIN v_bikeGame_attm as b ON a.gameIDX= b.gameIDX  where b.gubun in (0,1) and a.titleIDX = "&tidx&" and a.levelno = "&levelidx&" and b.playeridx  =  " & playeridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		Call oJSONoutput.Set("result", "300" ) '이미 참가중인 선수 중복
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson & "`##`"
		Response.end
	End if


		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson & "`##`"


	db.Dispose
	Set db = Nothing
%>

	<li>
	  <span><%=username%>(<%=uid%>)</span>
	</li>
	<li>
	  <span><%=birthstr%></span>
	</li>
	<li>
	  <span><%=phonestr%></span>
	</li>
