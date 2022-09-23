<%
'#############################################

'결과 생성 코트정보 변경

'#############################################
	'request
	idx = oJSONoutput.SCIDX 'resultIDX  결과 인덱스
	player1IDX = oJSONoutput.P1
	player2IDX = oJSONoutput.P2
	gubun = oJSONoutput.GN '0예선

	gamekey1 = oJSONoutput.S1KEY 
	gamekey2 = oJSONoutput.S2KEY 
	gamekey3 = oJSONoutput.S3KEY '게임종목 키
	levelkey = gamekey3
	gamekey3 = Left(gamekey3,5)
	gamekeyname = oJSONoutput.TeamNM '부명칭
	gametitleidx = oJSONoutput.TitleIDX '게임타이틀 인덱스
	jono = oJSONoutput.JONO '조번호 (예선/순위결정 작업때 사용)
	courtno = oJSONoutput.COURTNO 

	If Left(gamekey3,3) = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " inner "
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
		If CDbl(startgamescore) > 0 Then
		strField = " gameMemberIDX1, gameMemberIDX2, stateno, gubun,gamekey3,gamekeyname,GameTitleIDX, level,tryoutgroupno,m1set1,m1set2,m1set3,m2set1,m2set2,m2set3  " 'gubun 0 예선
		else
		strField = " gameMemberIDX1, gameMemberIDX2, stateno, gubun,gamekey3,gamekeyname,GameTitleIDX, level,tryoutgroupno   " 'gubun 0 예선
		End if
		strField = strField & ", courtno "    '승자 , 승자위치(열 왼쪽, 행 오른쪽), 셋트종료시간, 운영자, 관리툴에서종료(ADMIN),결과판정번호좌우
	

		SQL = "INSERT INTO "& strTableName &" ("& strField &") VALUES "
		SQL = SQL & "(" & player1IDX
		SQL = SQL & "," & player2IDX
		If CDbl(startgamescore) > 0 Then 
		SQL = SQL & "," & "2, "&gubun&", "&gamekey3&", '"&gamekeyname&"',"&gametitleidx&", '"&levelkey&"',"&jono&","&startgamescore&","&startgamescore&","&startgamescore&","&startgamescore&","&startgamescore&","&startgamescore 'stateno 0 진행전, 2진행중, 1 완료
		Else
		SQL = SQL & "," & "2, "&gubun&", "&gamekey3&", '"&gamekeyname&"',"&gametitleidx&", '"&levelkey&"',"&jono 'stateno 0 진행전, 2진행중, 1 완료
		End if
		SQL = SQL & " ," & courtno & ")"
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "select Max(resultIDX) from " & strTableName
		Set rsmax = db.ExecSQLReturnRS(SQL , null, ConStr)

		oJSONoutput.SCIDX	= rsmax(0)

	Else
		'코트 정보 업데이트
		SQL = "update sd_TennisResult Set courtno = " & courtno  & " where resultIDX = " & idx
		Call db.execSQLRs(SQL , null, ConStr)


	End if

	Call oJSONoutput.Set("resout", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>