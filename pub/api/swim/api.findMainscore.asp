<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.SCIDX
	player1IDX = oJSONoutput.P1
	player2IDX = oJSONoutput.P2
	gubun = oJSONoutput.GN '0예선

	gamekey1 = oJSONoutput.S1KEY 
	gamekey2 = oJSONoutput.S2KEY 
	gamekey3 = oJSONoutput.S3KEY '게임종목 키

	levelkey = gamekey3
	gamekey3 = Left(gamekey3,5)

	gamekeyname = Split(oJSONoutput.S3STR," ")(0) '부명칭
	gametitleidx = oJSONoutput.GIDX '게임타이틀 인덱스


	rd = oJSONoutput.RD '라운드 보낸값 1라운드 ..

	jono = oJSONoutput.JONO			'조번호 (예선/순위결정 작업때 사용) (강수가 들어가있슴)
	grnd  = oJSONoutput.GRND			'몇강인지 16강
	oJSONoutput.JONO = grnd
	sort_no = oJSONoutput.SNO		'경기 번호
	'몇번째 게임인가


	If Left(gamekey3,3) = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " left "
		singlegame = false
	End if  

	Set db = new clsDBHelper

		'cfg설정값 가져와서 설정#############
		strSql = "SELECT top 1  a.cfg, b.startscore  "
		strSql = strSql &  "  FROM sd_TennisTitle as a inner join tblRGameLevel as b  ON a.GameTitleIDX = b.GameTitleIDX "
		strSql = strSql &  " WHERE a.GameTitleIDX = " & gametitleidx & " and b.level = " & levelkey 
		strSql = strSql &  " AND a.DelYN = 'N'"
		Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

		cfg = rs(0)
		starttiescore = Left(cfg,1)
		startgamescore = rs(1)
		deucestate = Mid(cfg,2,1)
		'cfg설정값 가져와서 설정#############


	'있는지 다시검사. 
	SQL = "select resultIDX from sd_tennisResult where gameMemberIDX1 ="&player1IDX&"  and gameMemberIDX2 = " & player2IDX
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
	
	If rs.eof Then
		idx = "0"
	Else
		idx = rs(0)
		oJSONoutput.SCIDX = idx
	End if


	If idx = "0" Then
		'insert 예선결과 담을 테이블 , 순위적용 시킬 테이블 
		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		strwhere = "  a.gamememberIDX = " & player1IDX & " or a.gamememberIDX = " & player2IDX
		strsort = " order by a.tryoutsortno asc"
		strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aATN, a.teamBNa as aBTN  "
		strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN "
		strfield = strAfield &  ", " & strBfield
		SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		Do Until rs.eof
			'GameTitleIDX, key3 , m1idx , m2idx 가 중복이라면 들어가지 않아야 한다.
			SQL = "Select top 1 key3  from sd_TennisRanking where GameTitleIDX = "&gametitleidx&"  and  key3 = "&gamekey3&"  and  m1idx = "&rs(0)&" and  m2idx = "&rs(4)
			Set rsm = db.ExecSQLReturnRS(SQL , null, ConStr)
			
			If rsm.eof then
				SQL = "INSERT INTO sd_TennisRanking (GameTitleIDX,key1,key2,key3, key3name, m1idx,m1name, m1team1, m1team2 ,m2idx,m2name, m2team1, m2team2,level ) VALUES " 'confirm 확인여부
				SQL = SQL & "(" & gametitleidx & ",'"&gamekey1&"',"&gamekey2&"," & gamekey3 & ",'" & gamekeyname  & "', "
				SQL = SQL & rs(0) &  ",  '" & rs(1) & "', '" & rs(2) & "','" & rs(3) & "', "
				SQL = SQL & rs(4) &  ", '" & rs(5) & "', '" & rs(6) & "','" & rs(7) & "','"&levelkey&"' )"
				Call db.execSQLRs(SQL , null, ConStr)
			End if
		rs.movenext
		Loop
		'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


		strTableName = " sd_TennisResult "
		strField = " a.gameMemberIDX1, a.gameMemberIDX2, a.stateno, a.gubun,gamekey3,gamekeyname,GameTitleIDX, level,tryoutgroupno  " 'gubun 0 예선 본선 1

		SQL = "INSERT INTO "& strTableName &" ("& strField &") VALUES "
		SQL = SQL & "(" & player1IDX
		SQL = SQL & "," & player2IDX
		SQL = SQL & "," & "2, "&gubun&", "&gamekey3&", '"&gamekeyname&"',"&gametitleidx&", '"&levelkey&"',"&jono&")" 'stateno 0 진행전, 2진행중, 1 완료
		Call db.execSQLRs(SQL , null, ConStr)



		SQL = "Select max(resultIDX) from " & strTableName
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		oJSONoutput.SCIDX = rs(0)  '저장 인덱스
		courtno = 1
		courtkind = 1
		serveno = 0
		serveno2 = 0
		setno = 1
		gameno = 1
		pointno = 0
		preresult = "ING"
	
	Else

		strTableName = " sd_TennisResult "
		strField = " a.gameMemberIDX1, a.gameMemberIDX2, a.stateno, a.gubun,gamekey3,gamekeyname,GameTitleIDX  " 
		'gubun 0 예선
	
		strField = strField & " ,a.courtno,a.courtkind,a.recorderName,a.startserve,a.secondserve,a.courtmode,a.preresult,      b.setno,b.gameno,b.playsortno,b.gameend "
		SQL = "Select top 1 " & strField & " from " & strTableName & " as a LEFT JOIN sd_TennisResult_record as b ON a.resultIDX = b.resultIDX where a.resultIDX = " & idx & " order by b.rcIDX desc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		courtno = rs("courtno")
		courtkind = rs("courtkind")
		recorderName = rs("recorderName")
		serveno = rs("startserve")
		serveno2 = rs("secondserve")
		courtmode = rs("courtmode")
		setno = rs("setno")
		gameno = rs("gameno")
		pointno = rs("playsortno")
		gameend = rs("gameend")
		preresult = rs("preresult")


		If isNull(setno) = True Then
			setno = 1
		End If
		If isNull(gameno) = True Then
			gameno = 1
		End If
		If gameend = "1" Then
			gameno = CDbl(gameno) + 1
		End if

		If isNull(pointno) = True Then
			pointno = 0
		End If

	End If

	If courtno = "0" Then
		courtno = 1
		courtkind = 1
	End If


	Call oJSONoutput.Set("CMODE", courtmode ) '코트 모드 0 시작 1 저장완료 2 수정모드
	Call oJSONoutput.Set("SERVE", serveno ) '서브위치 번호 1.2 위 3, 4 아래
	Call oJSONoutput.Set("SERVE2", serveno2 ) '서브위치 번호 1.2 위 3, 4 아래
	Call oJSONoutput.Set("RNM", recorderName ) '심판명칭
	Call oJSONoutput.Set("CRTNO", courtno ) '코드번호
	Call oJSONoutput.Set("CRTKND", courtkind ) '코트종류

	Call oJSONoutput.Set("SETNO", setno ) '최종세트번호
	Call oJSONoutput.Set("GAMENO", gameno ) '최종게임번호
	Call oJSONoutput.Set("POINTNO", pointno ) '포인트 진행 번호
	Call oJSONoutput.Set("PRERESULT", preresult ) '최종 결과 1종료 2타이브레이크
	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("targeturl", "enter-score.asp" )

	Call oJSONoutput.Set("TIESC", starttiescore )
	Call oJSONoutput.Set("STARTSC", startgamescore )
	Call oJSONoutput.Set("DEUCEST", deucestate )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%>