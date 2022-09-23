<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'게임 종료 처리
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	gubun = oJSONoutput.GN			'예선/본선 구분  0예선 1본선

	gidx = oJSONoutput.GIDX			'대회인덱스
	scidx = oJSONoutput.SCIDX		'결과테이블 인덱스


	leftetc = oJSONoutput.LT			'왼쪽 기타판정
	rightetc = oJSONoutput.RT		'오른쪽 기타판접
	courtno = oJSONoutput.CTNO	'코트번호
	courtkind = oJSONoutput.CTKD '코트종류
	winner = oJSONoutput.WINNER 'left right tie (승패위치)

	player1 = oJSONoutput.P1		 '선수 1인덱스 왼쪽
	player2 = oJSONoutput.P2		 '선수 2인덱스 오른쪽

	s2key = oJSONoutput.S2KEY		 '단복식구분정보
	levelno = oJSONoutput.S3KEY	 ' 상세번호(지역까지포함된)
	key3 = Left(levelno ,5)
	key3name = Split(oJSONoutput.S3STR," ")(0)

	'gameround = oJSONoutput.GRND '강수
	tournRd = oJSONoutput.JONO '16강 토너먼트
	rd = 	oJSONoutput.RD '1라운드 ...

	leftscore = oJSONoutput.LEFTSCORE
	rightscore = oJSONoutput.RIGHTSCORE
	'#################################
	Set db = new clsDBHelper

	'플레이어 정보가져오기
	If s2key = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " left "
		singlegame = false
	End if  

	If s2key = "202" Then '단체전
	else' 개인전
		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		strwhere = "  a.gamememberIDX = " & player1 & " or a.gamememberIDX = " & player2 
		strsort = " order by a.tryoutsortno asc" '정렬순이면 왼쪽오른쪽이 명확해진다.
		strAfield = " a.gamememberIDX as m1idx , a.PlayerIDX as m1pidx, a.userName as name1 , a.teamAna as m1t1, a.teamBNa as m1t2,a.sortNo  "
		strBfield = " b.partnerIDX as m2idx, b.PlayerIDX as m2pidx , b.userName as name2, b.teamAna as m2t1 , b.teamBNa as m2t2 "
		strfield = strAfield &  ", " & strBfield
		SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		i = 0
		Do Until rs.eof 
			If i = 0 Then
				m1pidx1 = rs("m1pidx")	'선수 테이블 인덱스
				m1pidx2 = rs("m2pidx")
				m1sortNo = rs("sortNo") '소팅번호
			Else
				m2pidx1 = rs("m1pidx")
				m2pidx2 = rs("m2pidx")
				m2sortNo = rs("sortNo") 
			End if
		i = i + 1
		rs.movenext
		loop
	End If

	'#######################################
		'승패 로그 저장
		Sub winlose(ByVal winloseval , ByVal playeridx)
			 If playeridx = "0" Or playeridx = "" Or isNull(playeridx) = True Then
				'부전
			 else
			 Dim SQL
			 SQL = " IF NOT EXISTS(SELECT * FROM sd_TennisScore WHERE gameyear = "&year(date)&" and PlayerIDX = "&playeridx& " and key3 = "& key3 &") "
			 SQL  = SQL & " INSERT INTO sd_TennisScore (gameyear,PlayerIDX,"&winloseval&",key3,key3name) values ("&year(date)&", "&playeridx&",1, "&key3&", '"&key3name&"') "
			 SQL  = SQL & " ELSE "
			 SQL  = SQL & " UPDATE sd_TennisScore Set "&winloseval&" = "&winloseval&" + 1 WHERE gameyear = "&year(date)&" and PlayerIDX = "&playeridx& " and key3 = "& key3 
			 Call db.execSQLRs(SQL , null, ConStr)		
			 End if
		End Sub

		'다음 라운드 추가
		Sub setNextRound(ByVal idx , ByVal rd, ByVal winpos, ByVal sortno) '대진맴버인덱스, 라운드번호, 승자위치, 홀수소팅번호
			Dim insertfield, selectfield,selectSQL,SQL, rs,nextRound,midx,nextSortNo
			nextRound = CDbl(rd) + 1 '최종라운드여부 확인
			
			If CDbl(sortno) Mod 2 = 1 Then
				sortno = CDbl(sortno) +1
			End If
			nextSortNo = Fix(CDbl(sortno) /2) 


			'//기존거 삭제 --
			'SQL = "Delete From sd_TennisMember Where GameTitleIDX = "&gidx&" And gamekey3 = "&levelno&"  And Round = "&nextRound&" And sortno = " & nextSortNo & " and playerIDX in ( 0,1)"
			SQL = "Delete From sd_TennisMember Where GameTitleIDX = "&gidx&" And gamekey3 = "&levelno&"  And Round = "&nextRound&" And sortno = " & nextSortNo '승패가 바뀌므로 이게 맞다고.
			Call db.execSQLRs(SQL , null, ConStr)
			
			
			'다음 라운드 부전맴버 insert * 구분2 준비 상태 구분 3 경기 시작상태( 코트 준비 또는 대기 기간 필요)
			insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,key3name,Round,SortNo "
			If winpos = "tie" then
				selectfield = "  3,GameTitleIDX,0,'부전',gamekey1,gamekey2,gamekey3,TeamGb,'','',key3name,"&nextRound&","&nextSortNo&"  "
			Else
				selectfield = "  3,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,key3name,"&nextRound&","&nextSortNo&"  "
			End if
			selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & idx

			SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			midx = rs(0)

			'파트너 insert
			insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
			If winpos = "tie" then
				selectfield =  " "&midx&",0,'부전','','' "
			Else
				selectfield =  " "&midx&",PlayerIDX,userName,TeamANa,TeamBNa "
			End if
			SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & idx
			Call db.execSQLRs(SQL , null, ConStr)

		End Sub

	'#######################################
	courtno = 1
	'결과 승패 기록
	strWhere =  " where resultIDX = " & scidx '게임 종료
	'SQLPLUS = " , leftetc = "&leftetc&" , rightetc = "&rightetc&",courtno= "&courtno&",courtkind="&courtkind & ", set1end = getdate()" & strWhere
	SQLPLUS = " , leftetc = "&leftetc&" , rightetc = "&rightetc&", set1end = getdate()" & strWhere

	Select Case winner
	Case "left" '위에 1번이이김 진출
		
		'보낼때 바뀌는 경우가 있는것 같다 ㅡㅡ'#############
		SQL = "select gameMemberIDX1 from sd_TennisResult " & strWhere & " and gameMemberIDX1 = " & player1
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof Then
			winner_chk = "right"
		Else
			winner_chk = "left"		
		End If
		'보낼때 바뀌는 경우가 있는것 같다 ㅡㅡ'#############		
		
		If CDbl(leftetc) = 7 Or CDbl(Rightetc) = 7 Then
		SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX="&player1&",winResult='"&winner_chk&"',m1set1="&leftscore&" , m2set1 = "&rightscore&" , m1set = 1,m2set = 0 " & SQLPLUS
		else
		SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX="&player1&",winResult='"&winner_chk&"',m1set = 1,m2set = 0 " & SQLPLUS
		End if
		Call db.execSQLRs(SQL , null, ConStr)

		'다음 라운드 member insert
		Call setNextRound(player1, rd, winner_chk, m1sortNo) '대진맴버인덱스, 라운드번호, 승자위치, 홀수소팅번호

		If s2key = "202" Then '단체전 > 년도별 팀 스코어 테이블 업데이트 (없을  경우 생성)
		else	'개인전 > 년도별 개인 스코어 테이블 업데이트
			'승
			 Call winlose("win", m1pidx1)
			 If singlegame = False then
				 Call winlose("win", m1pidx2)
			End if

			'패
			 Call winlose("lose", m2pidx1)
			 If singlegame = False then
				 Call winlose("lose", m2pidx2)
			 End if
		End if


	Case "right"

		'보낼때 바뀌는 경우가 있는것 같다 ㅡㅡ'#############
		SQL = "select gameMemberIDX2 from sd_TennisResult " & strWhere & " and gameMemberIDX2 = " & player2
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof Then
			winner_chk = "left"
		Else
			winner_chk = "right"		
		End if
		'보낼때 바뀌는 경우가 있는것 같다 ㅡㅡ'#############


		If CDbl(leftetc) = 7 Or CDbl(Rightetc) = 7 Then
		SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX="&player2&",winResult='"&winner_chk&"',m1set1="&leftscore&" , m2set1 = "&rightscore&" ,m2set = 1,m1set = 0  " & SQLPLUS
		else
		SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX="&player2&",winResult='"&winner_chk&"',m2set = 1,m1set = 0  " & SQLPLUS
		End If
		

		Call db.execSQLRs(SQL , null, ConStr)

		'다음 라운드 member insert
		Call setNextRound(player2, rd, winner_chk, m1sortNo) '대진맴버인덱스, 라운드번호, 승자위치, 홀수소팅번호

		If s2key = "202" Then
		else
			'승
			 Call winlose("win", m2pidx1)
			 If singlegame = False Then
				 Call winlose("win", m2pidx2)
			End if

			'패
			 Call winlose("lose", m1pidx1)
			 If singlegame = False then
				 Call winlose("lose", m1pidx2)
			 End if
		End if

	Case "tie" '본선이니까 다음 라운드 부전 생성
		SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX= null,winResult='"&winner&"'  " & SQLPLUS
		Call db.execSQLRs(SQL , null, ConStr)

		'다음 라운드 member insert
		Call setNextRound(player1, rd, winner, m1sortNo) '대진맴버인덱스, 라운드번호, 승자위치, 홀수소팅번호
	End Select



	'코트초기화############
	SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = (select top 1 courtno from sd_TennisResult " & strWhere & ") "
	Call db.execSQLRs(SQL , null, ConStr)
	'코트초기화############


	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 