<%
'#############################################

'바이자리에 신규팀, 또는 신규조를 생성후 신규팀을 생성한다.

'#############################################
	'request
	lidx = oJSONoutput.lidx
	p1idx = oJSONoutput.p1idx
	p2idx = oJSONoutput.p2idx
	tidx = oJSONoutput.tidx
	levelno = oJSONoutput.levelno
	pos = oJSONoutput.pos '예 rankL_1_3 조_소팅번호

	If  pos = "newjoo" Then
		joono = -1
		sotrno = 1
	Else
		posarr = Split(pos,"_")
		joono = posarr(1)
		sotrno = posarr(2)
	End if

	Select Case Left(levelno,3)
	Case "201","200"
		boo = "개인전"
		gamekey1 = "tn001001"
	Case "202"
		boo = "단체전"
		gamekey1 = "tn001002"
	End Select

	Set db = new clsDBHelper

	'편성정보가 있다면 있다고 알려주자..
		SQL = "select gubun from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "&levelno&" and gubun in (0,1) and tryoutgroupno = " & joono & " and tryoutsortNo = " & sotrno
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then '생선된곳이라면
			Call oJSONoutput.Set("result", 9092 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if

	
	'0. 조의 구분값을 구한다. (편성완료에 대한) 3개다 없을수도 있어
		SQL = "select max(gubun),max(TeamGb),max(key3name),max(place) from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "&levelno&" and gubun in (0,1) and tryoutgroupno = " & joono
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If isnull(rs(0)) = false then
			gubun = rs(0)
			TeamGb = rs(1)
			key3name = rs(2)
			place = rs(3)
		Else
			gubun = 0 '신규조 생성
			TeamGb = Left(levelno,5)
			SQL = "select top 1 key3name,tryoutgroupno from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "&levelno&" and gubun in (0,1) order by tryoutgroupno desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			key3name = rs(0)							'부명칭(한글)
			newgroupno = CDbl(rs(1)) + 1			'마지막 조번호 (신규조 생성)

			'x. 추가조가 생기면 조수업데이트  lastjoono , joocnt update
			SQL = "update tblRGameLevel set lastjoono = "&newgroupno&" , joocnt = "&newgroupno&"  where DelYN = 'N' and  RGameLevelidx = " & lidx
			Call db.execSQLRs(SQL , null, ConStr)
			joono = newgroupno
		End if

	'1. 선수 정보 가져오기
		SQL = "SELECT PlayerIDX,UserName,UserPhone,Team,TeamNm,Team2,Team2Nm,Birthday,Sex from tblPlayer where DelYN = 'N'  and (PlayerIDX = '"&p1idx&"' or PlayerIDX = '"&p2idx&"')"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		Do Until rs.eof
			pidx = rs("PlayerIDX")
			If Cstr(pidx) = CStr(p1idx) Then
				p1name = rs("UserName")
				p1team1 = rs("TeamNm")
				p1team2 = rs("Team2Nm")
				p1phone = rs("UserPhone")
				p1_birth = rs("Birthday")
				p1sex = rs("Sex")
				p1tm1code = rs("Team")
				p1tm2code = rs("Team2")
			Else
				p2name = rs("UserName")
				p2team1 = rs("TeamNm")
				p2team2 = rs("Team2Nm")
				p2phone = rs("UserPhone")
				p2_birth = rs("Birthday")
				p2sex = rs("Sex")
				p2tm1code = rs("Team")
				p2tm2code = rs("Team2")	
			End if
		rs.movenext
		loop


	'3. 랭킹포인트 구하기
		SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where PlayerIDX = "&p1idx&" and teamGb = "&Left(levelno,5)&" order by getpoint desc )"
		Set rs1 = db.ExecSQLReturnRS(SQL , null, ConStr)

		If isNull(rs1(0)) = true Then
			p1point = 0
		Else
			p1point = rs1(0)
		End if

		SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where PlayerIDX = "&p2idx&" and teamGb = "&Left(levelno,5)&" order by getpoint desc )"
		Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr)
		If isNull(rs2(0)) = true Then
			p2point = 0
		Else
			p2point = rs2(0)
		End if

	'4. 참가신청 선수 정보 생성
		insertfield = " SportsGb, GameTitleIDX,Level,EnterType,UserPass,UserName,UserPhone,txtMemo " '여러팀을 등록했을시 ...
		insertfield = insertfield & " ,P1_PlayerIDX,P1_UserName,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX,P1_team,p1_team2 "
		insertfield = insertfield & " ,P2_PlayerIDX,P2_UserName,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P2_team,p2_team2 "
		insertvalue = " 'tennis',"&tidx&",'"&levelno&"','A','null','운영자','01000000000','자동생성'"
		insertvalue = insertvalue & "," &  p1idx & " ,'"&p1name&"','"&p1team1&"','"&p1team2&"','"&p1phone&"','"&p1_birth&"','"&p1sex&"','"&p1tm1code&"','"&p1tm2code&"' "
		insertvalue = insertvalue & "," &  p2idx & " ,'"&p2name&"','"&p2team1&"','"&p2team2&"','"&p2phone&"','"&p2_birth&"','"&p2sex&"','"&p2tm1code&"','"&p2tm2code&"' "
		
		SQL = "INSERT INTO tblGameRequest ( "&insertfield&" ) VALUES ("&insertvalue&") " 
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "select max(RequestIDX) from tblGameRequest where GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN = 'N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		reqidx = rs(0)	

		'참가팀 카운트 업데이트
		SQL = "Update tblRGameLevel Set attmembercnt = (SELECT count(*) as attCnt FROM tblGameRequest where  GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN = 'N' ) where RGameLevelIdx = " & lidx
		Call db.execSQLRs(SQL , null, ConStr)

	'5. 대진표 선수 생성
		insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,rankpoint , tryoutgroupno, tryoutsortNo , requestIDX, place"
		insertvalue = gubun&","&tidx&","&p1idx&",'"&p1name&"','"&gamekey1&"',"&Left(levelno,3)&","&levelno&","&Left(levelno,5)&",'"&key3name&"','"&p1team1&"','"&p1team2&"',"&p1point&" ," & joono & "," & sotrno & ","& reqidx& ",'"&place&"' "
		SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		gamemidx = rs(0)	
		insertfield = " GameMemberIDX, PlayerIDX,userName,TeamANa,TeamBNa,rankpoint "
		insertvalue = " "&gamemidx&", "&p2idx&", '"&p2name&"','"&p2team1&"','"&p2team2&"',"&p2point&"   "
		SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
		Call db.execSQLRs(SQL , null, ConStr)		




	Set rs = Nothing
	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>