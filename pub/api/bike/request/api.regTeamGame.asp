<%
'######################
'참가신청완료
'######################

'REQ = "{"pg":1,"tidx":23,"name":"참가종목선택","subtype":"2","chkgame":"121,CAT3:","bikeidx":"9","marriage":"Y","job":"JOB02","bloodtype":"AB","career":"CR002","brand":"BR009","gamegift":"M","CMD":210,"teamnm":"단체팀","teamlist":"mujerk,sjh123,bnbnbn,","p_nm":"백승훈","p_phone":"01047093650","p_relation":"부","adult":"N"}"

'request
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


	If hasown(oJSONoutput, "bikeidx") = "ok" Then 'bike.tblmember.MemberIDX 입니당.
		bikeidx = oJSONoutput.bikeidx
	Else
		Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	If hasown(oJSONoutput, "brand") = "ok" Then '사용중인 브렌드
		brand = oJSONoutput.brand
	End if
	If hasown(oJSONoutput, "gamegift") = "ok" Then '사은품
		gamegift = oJSONoutput.gamegift
	End if


	If hasown(oJSONoutput, "teamnm") = "ok" Then '팀명칭
		teamnm = oJSONoutput.teamnm
	End if

	If hasown(oJSONoutput, "teamlist") = "ok" Then '참가선수 아이디
		teamlist = oJSONoutput.teamlist
	End if

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
'request

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

	If Replace(p_phone,"-","")  = Replace(userPhone,"-","") Then
        Call oJSONoutput.Set("result", "302" ) '보호자 = 본인 전화번호
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	'참가신청
	chkgames = Split(chkgame,":") '단체 1개씩
	If IsArray(chkgames) Then

		memberids = Split(teamlist,",")
		For m = 0 To ubound(memberids)
			If m = 0 then
				inchkstr = "('" & memberids(m) & "' "
			Else
				If memberids(m) <> "" Then
					inchkstr = inchkstr & ",'" & memberids(m) & "' "
				End if
			End if
		Next
		inchkstr = inchkstr & ")"

		'playeridx 구하기 (순서대로 들어가야하는데 어떻게?
		fieldstr = "playerIDX,username,EnterType,memberIDX,sd_UserID,sd_gameIDSET,BloodType,MarriageGb,Job,PlayerRelnMemo,Team,PhotoPath,BikeCareer,BikeBrand "
		SQL = "select " & fieldstr & " from tblMember where PlayerReln='R'  and sd_UserID in  " & inchkstr & " and DelYN = 'N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			arrRS = rs.GetRows()
		End if

		membercnt = 0
		If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

			playerIDX  = arrRS(0, ar)
			userNm = arrRS(1, ar)
			EnterType = arrRS(2, ar)
			usermidx = arrRS(3,ar)
			m_userID = arrRS(4,ar)
			If arrRS(4,ar) = userID Then
				attplayeridx = playeridx
			End if

			If ar = 0 Then
				inplayerIDX = "(" & playerIDX
			Else
				inplayerIDX = inplayerIDX & "," & playerIDX
			end If
			membercnt = membercnt + 1
		Next
		inplayerIDX = inplayerIDX & ")"
		End if

		'참가 신청 중복확인 levelIDX 체크가 빠졌네
		SQL = "select  a.requestIDX from  sd_bikeRequest as a INNER JOIN v_bikeGame_attm as b ON a.gameIDX= b.gameIDX  where a.titleIDX = "&tidx&" and a.subtype = '"&subtypestr&"' and a.levelno = "&Split(chkgames(0), ",")(0)&" and b.playeridx  in  " & inplayerIDX & " and b.gubun in ( 0, 1)"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql
'Call rsdrow(rs)
'Response.end


		If Not rs.eof Then
			Call oJSONoutput.Set("result", "2" ) '중복
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if

'		'선수들의 전화번호를 구한 후 내전화번호를 뺀다... 그리고 gameIDX 를 붙여서 만들어두자.
			fieldstr = "memberIDX,UserName,userPhone,birthday,userID "
			SQL = "select " & fieldstr & " from tblMember where userID in " & inchkstr & " and userID <> '"&userID&"'"
			Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

'Call rsdrow(rs)
'Response.end

			If Not rs.eof Then
				arrM = rs.GetRows()
			End If

			sendcnt = 0
			If IsArray(arrM) Then
				For ar = LBound(arrM, 2) To UBound(arrM, 2)
					lms_midx  = arrM(0, ar)
					lms_nm = arrM(1, ar)
					lms_phone = arrM(2, ar)
					lms_birthday = arrM(3, ar)
					lms_sduid = arrM(4,ar)
					lmsstr = lmsstr &  lms_midx&","&lms_nm&","&lms_phone& "^"
					sendcnt = sendcnt + 1


					'나이#######################
					myage = Cint(year(date)) - CInt(Left(lms_birthday,4))
					if CDbl(mid(Replace(date,"-",""),5))  >  CDbl(Mid(lms_birthday, 5)) Then
						myage = myage - 1
					End if
					myageST = "Y"
					If CDbl(myage) < 19 Then
						myageST = "N"
					End if
					teamAdult = teamAdult & lms_sduid & ","&myageST& "^"
					'나이#######################

				Next
			End If


'Response.write teamAdult
'Response.end

			If adult = "N" Then
				lmsstr = lmsstr &  "*보호자*,"&p_nm&","&p_phone& "^"
				sendcnt = sendcnt + 1
			End If
		'선수들의 전화번호를 구한 후 내전화번호를 뺀다...

		'참가비
		'SOLOATTMONEY = array(30000, 50000, 70000)
		'TEAMATTMONEY = 10000

		attmoney = CDbl(TEAMATTMONEY) * CDbl(membercnt)

		For i = 0 To ubound(chkgames) - 1
			attinfo = Split(chkgames(i), ",")

				If IsArray(arrRS) Then
				For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

					playerIDX  = arrRS(0, ar)
					userNm = arrRS(1, ar)
					EnterType = arrRS(2, ar)
					memberIDX = arrRS(3,ar)
					m_uID = arrRS(4,ar)

					'Response.write attinfo(0) & " " & attinfo(1) & "<br>"
					'sd_bikeGame (경기정보 gameIDX) 여기에 선수를 추가 시켜 팀을 만든다. 1명 ~~~
					'sd_bikeAttMember 에 넣고
					'sd_bikeRequest 넣음

					If CDbl(ar) = 0 Then '처음에 무조건 넣어야할자료니까....
					SQL = "Select case when max(requestIDX) is null then 1 else max(requestIDX) + 1 end from sd_bikeRequest where delYN = 'N' "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					ridx = rs(0)
					End if

'Response.write sql & "<br>"

					'게임정보
					If CDbl(ar) = 0 Then '처음에 무조건 넣어야할자료니까....
						insertfield = " gubun,titleIDX,levelno,EnterType,requestIDX,sex "
						fieldvalue = "0, "&tidx&","&attinfo(0)&",'"&EnterType&"',"& ridx  &", '"&sex&"' "
						SQL = "SET NOCOUNT ON  insert into sd_bikeGame ("&insertfield&") values ("&fieldvalue&")  SELECT @@IDENTITY"
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						gameIDX = rs(0)
					End if

'Response.write sql & "   " & ridx &  "<br>"
'Response.end

					'선수 (보호자 정보 , 동의여부)
					If CDbl(playeridx) = CDbl(attplayeridx) then
						insertfield = " gameIDX, PlayerIDX,userName,sex,pgrade,brand,myagree,p_nm,p_phone,p_relation,myadult,groupno,teamtitle,giftcode,reqsortno " 'groupno 0 단체전신청자. reqsortno 참가신청자
						fieldvalue = gameIDX & ","&playerIDX&",'"&userNm&"','"&sex&"','"&attinfo(1)&"','"&brand&"','"&agree&"','"&p_nm&"','"&p_phone&"','"&p_relation&"','"&adult&"',0, '"&teamnm&"','"&gamegift&"' ,1"
					Else
						insertfield = " gameIDX, PlayerIDX,userName,groupno, myadult,sex,pgrade ,teamtitle,giftcode "

						ta = Split(teamAdult,"^")
						For m = 0 To ubound(ta)-1
							If m_uID = Split(ta(m),",")(0) Then
								member_adult = Split(ta(m),",")(1)
							End if
						next
						fieldvalue = gameIDX & ","&playerIDX&",'"&userNm&"', 0, " & " '"&member_adult&"','"&sex&"','"&attinfo(1)&"', '"&teamnm&"','"&gamegift&"' "
					end if
					SQL = "insert into sd_bikeAttMember ("&insertfield&") values ("&fieldvalue&")"
					Call db.execSQLRs(SQL , null, ConStr)

'Response.write sql & "<br>"



					'참가신청
					If CDbl(playeridx) = CDbl(attplayeridx) then
						insertfield = " requestIDX,titleIDX,levelno,gameidx,subtype,EnterType,PlayerIDX,username,brand,giftcode,teamNm,groupno,attmoney "
						fieldvalue = ridx & "," & tidx & "," & attinfo(0) & "," &gameIDX & ",'"&subtypestr&"','"&entertype&"',"&playerIDX&",'"&userNm&"','"&brand&"','"&gamegift&"','"&teamnm&"',0, "&attmoney
						SQL = "insert into sd_bikeRequest ("&insertfield&") values ("&fieldvalue&")"
						Call db.execSQLRs(SQL , null, ConStr)
'Response.write sql & "---<br>"
					End if
'

'Response.write  "---------------------------------------<br>"
'sql = ""

				Next
				End if
		Next

'Response.End

		Call oJSONoutput.Set("sendcnt", sendcnt ) '총발송할 건수
		Call oJSONoutput.Set("lmsno", 0 ) '시작카운트
		Call oJSONoutput.Set("lms", lmsstr ) '발송정보 아이디,이름,전화번호
		Call oJSONoutput.Set("gameidx", gameidx )
		Call oJSONoutput.Set("ridx", ridx )

'Response.write lmsstr & "<br><br>"

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
