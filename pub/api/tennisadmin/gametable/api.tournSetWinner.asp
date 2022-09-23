<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
''라운드 승리 처리
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	gubun = oJSONoutput.GN			'예선/본선 구분  0예선 1본선
	tidx = oJSONoutput.TitleIDX		'대회인덱스
	midx = oJSONoutput.T_MIDX		'승자 인덱스

	levelno = oJSONoutput.S3KEY	 ' 상세번호(지역까지포함된)
	key3 = Left(levelno ,5)
	s2key = Left(key3,3)				 '단복식구분정보
	key3name = oJSONoutput.TeamNM
	sortno = oJSONoutput.T_SORTNO
	rd = oJSONoutput.T_NOWRD

	Call oJSONoutput.Set("state", "0" )

	If CDbl( sortno Mod 2) = 1 then
		winner = "left" 'left right tie (승패위치)
		sortno1 = sortno
		sortno2 = CDbl(sortno) + 1
	Else
		winner = "right"
		sortno1 = CDbl(sortno) - 1
		sortno2 = sortno
	End if

	'#################################
	Set db = new clsDBHelper

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
			Dim insertfield, selectfield,selectSQL,SQL, rs,nextRound,midx,nextSortNo,nextgubun
			nextRound = CDbl(rd) + 1 '최종라운드여부 확인
			
			If CDbl(sortno) Mod 2 = 1 Then
				sortno = CDbl(sortno) +1
			End If
			nextSortNo = Fix(CDbl(sortno) /2) 

			'--------------------------------------
			'보낼 라운드에 3이 있으면 gubun = 3 이고 없으면 2로
			'SQL = "select top 1 gubun from sd_TennisMember where gubun > 2 and GameTitleIDX = "&tidx&" And gamekey3 = "&levelno&"  And Round = "&nextRound
			'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			'If rs.eof Then
			'	nextgubun = 2
			'Else
			'	nextgubun = 3
			'End if

			'//기존거 삭제 --
			SQL = "Delete From sd_TennisMember Where GameTitleIDX = "&tidx&" And gamekey3 = "&levelno&"  And Round = "&nextRound&" And sortno = " & nextSortNo
			Call db.execSQLRs(SQL , null, ConStr)
			'--------------------------------------


			'다음 라운드 부전맴버 insert * 구분2 준비 상태 구분 3 경기 시작상태( 코트 준비 또는 대기 기간 필요)
			insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,Round,SortNo,place,ABC "
			selectfield = " 3 ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,"&nextRound&","&nextSortNo&",place,ABC  "
			selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & idx

			SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			midx = rs(0)

			'파트너 insert
			insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
			selectfield =  " "&midx&",PlayerIDX,userName,TeamANa,TeamBNa "
			SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & idx
			Call db.execSQLRs(SQL , null, ConStr)



		End Sub
	'#######################################

	strtable = " sd_TennisMember "
	strtablesub =" sd_TennisMember_partner "


	'플레이어 정보가져오기
	If s2key = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " inner "
		singlegame = false
	End if  
	joinstr = " left " 


	If s2key = "202" Then '단체전
	else' 개인전

		'상대선수 구하기
		strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun = "&TOURNSTART&"  and DelYN = 'N' and Round = " & rd & " and sortNo in ( "&sortno1&", "&sortno2&")"
		SQL = "SELECT top 2 gameMemberIDX,userName,gubun,sortNo FROM  " &strtable&   " where " & strWhere & " ORDER BY sortNo ASC"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		

		i = 0
		Do Until rs.eof 
			If i = 0 Then
				player1 = rs("gameMemberIDX")
			Else
				player2 = rs("gameMemberIDX")
			End if
			i = i + 1
		rs.movenext
		loop

		strwhere = "  a.gamememberIDX = " & player1 & " or a.gamememberIDX = " & player2 
		strsort = " order by a.sortNo asc" '정렬순이면 왼쪽오른쪽이 명확해진다.
		strAfield = " a.gamememberIDX as m1idx , a.PlayerIDX as m1pidx, a.userName as name1 , a.teamAna as m1t1, a.teamBNa as m1t2,a.sortNo  "
		strBfield = " b.partnerIDX as m2idx, b.PlayerIDX as m2pidx , b.userName as name2, b.teamAna as m2t1 , b.teamBNa as m2t2 "
		strfield = strAfield &  ", " & strBfield
		SQL = "select top 2  "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'Call rsDrow(rs)
		'Response.end
		i = 0
		Do Until rs.eof 
			If i = 0 Then
				m1idx = rs("m1idx")
				m1pidx1 = rs("m1pidx")	'선수 테이블 인덱스
				m1pidx2 = rs("m2pidx")
				m1sortNo = rs("sortNo") '소팅번호
			Else
				m2idx = rs("m1idx")
				m2pidx1 = rs("m1pidx")
				m2pidx2 = rs("m2pidx")
				m2sortNo = rs("sortNo") 
			End if
		i = i + 1
		rs.movenext
		loop
	End If
	'##########

	'결과 승패 기록이 있는지 찾아보자
	rtwhere = " (gameMemberIDX1 = " & player1 & " and gameMemberIDX2 = "&player2 & " or gameMemberIDX1 = " & player2 & " and gameMemberIDX2 = "&player1 & ") " 
	SQL = "Select resultIDX,gameMemberIDX1,gameMemberIDX2,stateno,winIDX,preresult,recorderName,courtno from sd_tennisResult where "& rtwhere &" and delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If rs.eof Then
		'상대가 부전이 경우 인서트 하지 않음 X
		If  CDbl(m1pidx1) = 0 or CDbl(m2pidx1)= 0 then
			'둘다부전이라면?
				insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winIDX,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level "
				insertvalue = " "&m1idx&","&m2idx&",1,1,getdate(),"&midx&",'"&winner&"','운영자','ADMIN','"&tidx&"',"&key3&",'"&key3name&"',"&levelno& " "
				SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
				Call db.execSQLRs(SQL , null, ConStr)

			'다음 라운드 member insert
			Call setNextRound(midx, rd, winner, sortno) '대진맴버인덱스, 라운드번호, 승자위치, 홀수소팅번호		
		Else
			If CDbl(m1pidx1) > 0 And CDbl(m2pidx1) > 0   then
				insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winIDX,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level "
				insertvalue = " "&m1idx&","&m2idx&",1,1,getdate(),"&midx&",'"&winner&"','운영자','ADMIN','"&tidx&"',"&key3&",'"&key3name&"',"&levelno& " "
				SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
				Call db.execSQLRs(SQL , null, ConStr)
			End if

			'다음 라운드 member insert
			Call setNextRound(midx, rd, winner, sortno) '대진맴버인덱스, 라운드번호, 승자위치, 홀수소팅번호		
		End if
	Else
		'update
		scidx = rs("resultIDX")
		courtidx = rs("courtno") '코트가 지정되어있는지 확인 (코트 인덱스가 들어가있다)

		rcname = rs("recorderName") '빈값이라면 뒤로가기해서 생성된 경우이므로 업데이트해도 된다.
		stateno = rs("stateno") '1 종료 2 진행중 , gubun = 1 본선, preresult = 'ING' 진행중 


		If (rcname = "" Or rcname = "운영자") or (stateno = "0" Or stateno = "2") Then '심판명이없어

			If CDbl(courtidx) > 0 then
				SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = " & courtidx '예선 본선두개가 된경우도 풀리도록
				Call db.execSQLRs(SQL , null, ConStr)
			End if
			
			SQL = "update sd_TennisResult Set stateno = 1, winIDX = "&midx&", winResult = '"&winner&"', recorderName = '운영자', preresult = 'ADMIN',courtno=0  where resultIDX = " & scidx
			Call db.execSQLRs(SQL , null, ConStr)

			'다음 라운드 member insert
			Call setNextRound(midx, rd, winner, sortno) '대진맴버인덱스, 라운드번호, 승자위치, 홀수소팅번호
		
		Else

			Call oJSONoutput.Set("result", "1234" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.End
			
			'다음 라운드 member insert
			'Call setNextRound(midx, rd, winner, sortno) '대진맴버인덱스, 라운드번호, 승자위치, 홀수소팅번호
			'새로고침할수 있도록

		'	Select Case CDbl(stateno)
		'	case 1 '종료된건 변경금지
		'	Case 2 '진행중임
		'	End Select 
		End if
	End if


	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 