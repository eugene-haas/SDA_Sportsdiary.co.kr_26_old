<%
'######################
'참가신청완료
'######################

'REQ = "{"pg":1,"tidx":23,"name":"참가신청","subtype":"1","chkgame":"116,루키:117,CAT3:118,루키:","bikeidx":"4571","marriage":"Y","job":"JOB02","bloodtype":"A","career":"CR001","brand":"BR001","gamegift":"S","CMD":200}"


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
	If hasown(oJSONoutput, "chkgame") = "ok" Then '신청정보   116,루키:117,CAT3:118,루키:  (부에 키값(levelno), 선수등급)
		chkgame = oJSONoutput.chkgame
	End If


	If hasown(oJSONoutput, "bikeidx") = "ok" Then 'bike.tblmember.MemberIDX
		bikeidx = oJSONoutput.bikeidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if
	If hasown(oJSONoutput, "marriage") = "ok" Then '결혼유무 N Y
		marriage = oJSONoutput.marriage
	End If
	If hasown(oJSONoutput, "job") = "ok" Then '직업코드
		jobcode = oJSONoutput.job
	End if
	If hasown(oJSONoutput, "bloodtype") = "ok" then
		bloodtype = oJSONoutput.bloodtype
	End if
	If hasown(oJSONoutput, "career") = "ok" Then '자전거 경력
		career = oJSONoutput.career
	End if
	If hasown(oJSONoutput, "brand") = "ok" Then '사용중인 브렌드
		brand = oJSONoutput.brand
	End if
	If hasown(oJSONoutput, "gamegift") = "ok" Then '사은품
		gamegift = oJSONoutput.gamegift
	End if

	'동의관련
	If hasown(oJSONoutput, "adult") = "ok" Then '성인미성인 Y N 부모 동의 문자 발송여부
		adult = oJSONoutput.adult
	End if
	If hasown(oJSONoutput, "agree") = "ok" Then
		agree = oJSONoutput.agree
	End if

	If hasown(oJSONoutput, "p_nm") = "ok" Then
		p_nm = oJSONoutput.p_nm
	End if
	If hasown(oJSONoutput, "p_phone") = "ok" Then
		p_phone = oJSONoutput.p_phone
	End if
	If hasown(oJSONoutput, "p_relation") = "ok" Then
		p_relation = oJSONoutput.p_relation
	End if

	'##############################
	Set db = new clsDBHelper

	'대회 참가 신청기간 확인
	'나중에 ㅡㅡ꼭


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

'	SOLOATTMONEY1 = 30000
'	SOLOATTMONEY2 = 50000
'	SOLOATTMONEY3 = 70000
'	TEAMATTMONEY = 10000



	'개인이라면 참가신청 참가신청
	chkgames = Split(chkgame,":")
	attmoney = SOLOATTMONEY(ubound(chkgames) - 1) '참가비
	For i = 0 To ubound(chkgames) - 1
		If i = 0 then
			inlevelnos = Split(chkgames(i), ",")(0)
		Else
			inlevelnos = inlevelnos & "," & Split(chkgames(i), ",")(0)
		End if
	next


	If IsArray(chkgames) Then

		fieldstr = "memberIDX,username,sd_gameIDSET,playerIDX,BloodType,MarriageGb,Job,PlayerRelnMemo,Team,EnterType,PhotoPath,BikeCareer,BikeBrand "
		SQL = "select " & fieldstr & " from tblMember where PlayerReln='R' and  sd_UserID = '"&userID&"' and DelYN = 'N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		playerIDX  = rs("playerIDX")
		EnterType = rs("EnterType")
		userNm = rs("username")

		'참가 신청 중복확인
		SQL = "select  a.requestIDX from  sd_bikeRequest as a inner join  sd_bikegame as b on a.gameidx = b.gameidx  where a.titleIDX = "&tidx&" and a.subtype = '"&subtypestr&"' and a.playeridx  =  " & playerIDX & " and a.levelno in ("&inlevelnos&") and  b.gubun in (0,1) and a.DelYN = 'N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			Call oJSONoutput.Set("result", "2" ) '중복
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if


		'변경내용수정
		SQL = "update tblMember Set MarriageGb = '"&marriage&"' ,Job = '"&jobcode&"' , BloodType = '"&bloodtype&"' , BikeCareer= '"&career&"' , BikeBrand = '"&brand&"' where PlayerReln='R' and  sd_UserID = '"&userID&"'"
		Call db.execSQLRs(SQL , null, ConStr)


		If CDbl(subtype) = 1 Then '개인인 경우 참가 신청 완료
			For i = 0 To ubound(chkgames) - 1
				attinfo = Split(chkgames(i), ",")
				'Response.write attinfo(0) & " " & attinfo(1) & "<br>"
				'sd_bikeGame (경기정보 gameIDX) 여기에 선수를 추가 시켜 팀을 만든다. 1명 ~~~
				'sd_bikeAttMember 에 넣고
				'sd_bikeRequest 넣음

				SQL = "Select case when max(requestIDX) is null then 1 else max(requestIDX) + 1 end from sd_bikeRequest "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				ridx = rs(0)
				If i = 0 Then
					Groupno = ridx
				End If

				'게임정보 	'sd_bikeGame.gubun = 0 진행중, 1 확정 ,2 취소 (경기에 관해서 동의완료, 입금완료로 업데이트)
				If adult = "N" Then '미성년
					gubun = 0
				Else'성인 (참가신청완료) 동의까지만 완료인거야 1은 입금완료된 상태임
					gubun = 0
				End if
				insertfield = " gubun,titleIDX,levelno,EnterType,requestIDX,sex "
				fieldvalue = gubun & ", "&tidx&","&attinfo(0)&",'"&EnterType&"',"& ridx  &", '"&sex&"' "
				SQL = "SET NOCOUNT ON  insert into sd_bikeGame ("&insertfield&") values ("&fieldvalue&")  SELECT @@IDENTITY"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				gameIDX = rs(0)
				'Response.write sql &"<br>"
				'선수
				insertfield = " gameIDX, PlayerIDX,userName,sex,pgrade,brand,myagree,p_nm,p_phone,p_relation,myadult,groupno,giftcode "
				fieldvalue = gameIDX & ","&playerIDX&",'"&userNm&"','"&sex&"','"&attinfo(1)&"','"&brand&"','"&agree&"','"&p_nm&"','"&p_phone&"','"&p_relation&"','"&adult&"' , "&Groupno&",'"&gamegift&"' " '한번에 신청한 종목묶기
				SQL = "insert into sd_bikeAttMember ("&insertfield&") values ("&fieldvalue&")"
				Call db.execSQLRs(SQL , null, ConStr)
				'Response.write sql &"<br>"
				'참가신청
				insertfield = " requestIDX,titleIDX,levelno,gameidx,subtype,EnterType,PlayerIDX,username,brand,giftcode,groupno,attmoney "
				fieldvalue = ridx & "," & tidx & "," & attinfo(0) & "," &gameIDX & ",'"&subtypestr&"','"&entertype&"',"&playerIDX&",'"&userNm&"','"&brand&"','"&gamegift&"', " & Groupno & "," & attmoney '한번에 신청한 종목묶기
				SQL = "insert into sd_bikeRequest ("&insertfield&") values ("&fieldvalue&")"
				Call db.execSQLRs(SQL , null, ConStr)
				' Response.write sql &"<br><br>===============================<br>"
        ' response.end
			Next

			'발송여부확인
			If DEBUG_MODE  And InStr(DEBUG_IP, USER_IP) > 0 Then
				adult = "N"
			End If

			If adult = "N" Then
				lmsstr = "*보호자*,"&p_nm&","&p_phone& "^"
				Call oJSONoutput.Set("lms", lmsstr ) '발송정보 아이디,이름,전화번호
				Call oJSONoutput.Set("gno", Groupno )
			End if

			Call oJSONoutput.Set("gameidx", gameidx )
		End if
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if




	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>
