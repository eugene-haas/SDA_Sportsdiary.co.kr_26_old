<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

' 한게임 종료 됨

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


	scidx = oJSONoutput.SCIDX '결과테이블 인덱스
	rkey = oJSONoutput.RKEY '기록 인덱스
	setno = oJSONoutput.SETNO '세트번호
	gameno = oJSONoutput.GAMENO '게임번호
	pos = oJSONoutput.POS 'left right 왼쪽 오른쪽 누가 이겼는지
	gubun = oJSONoutput.GN '예선 0 
	etype = oJSONoutput.ETYPE  'A 아마추어 (1세트)
	player1 = oJSONoutput.P1  'index
	player2 = oJSONoutput.P2 
	tielose = oJSONoutput.TIELOSE '타이블레이크 패자점수

	startsc = oJSONoutput.STARTSC '시작점수
	tiesc = oJSONoutput.TIESC '타이블레이크룰 점수
	deucest = oJSONoutput.DEUCEST '듀스 상태 0: 기본룰 ,1: 노에드, 2: 1듀스 노에드
	'#################################
	Set db = new clsDBHelper

	If pos = "left" then
		SQL = "UPDATE sd_TennisResult Set  m1set"&setno&"= m1set"&setno&" + 1 " & ",tiebreakpt="&tielose&",set"&setno&"end = getdate()    where resultIDX = " & scidx
		Call db.execSQLRs(SQL , null, ConStr)
	Else
		SQL = "UPDATE sd_TennisResult Set  m2set"&setno&"= m2set"&setno&" + 1 " & ",tiebreakpt="&tielose&",set"&setno&"end = getdate()  where resultIDX = " & scidx
		Call db.execSQLRs(SQL , null, ConStr)
	End if

	
	'세트종료확인
	SQL = "select top 1 m1set"&setno &", m2set"&setno & " from sd_TennisResult where  resultIDX = " & scidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		leftset = 0
		rightset = 0
		totalsetscore = 0
	else
		leftset = rs(0)
		rightset = rs(1)
		totalsetscore = CDbl(leftset) + CDbl(rightset)
		setdis = Asc(CDbl(leftset) - CDbl(rightset)) '세트차이
	End If
	
	'세트교체, 종료 체크 ======================
	'타이브레이크 종료 이거나 게임 종료 먼저 2점차로 7점 득점
	If (CDbl(leftset) > CDbl(tiesc) Or CDbl(rightset) > CDbl(tiesc))  Then '한셋트 종료 요건만족

		If (etype = "A"  and setno = "1")  Or  (etype = "E"  and setno = "3")  then

			If gubun = "0" Then '예선

			Else '본선

			End If
			
			If (CDbl(leftset) > CDbl(tiesc) And CDbl(rightset) = CDbl(tiesc)) Or (CDbl(rightset) > CDbl(tiesc) And CDbl(leftset) = CDbl(tiesc)) Then '타이브레이크 종료
				If CDbl(leftset) > CDbl(rightset) then
					preresult = "LEFT_TIE"
				Else
					preresult = "RIGHT_TIE"
				End if
			Else
				If CDbl(leftset) > CDbl(rightset) then
					preresult = "LEFT"
				Else
					preresult = "RIGHT"
				End if
			End If
			Call oJSONoutput.Set("SETEND", preresult )
			SQL = "UPDATE sd_TennisResult  Set preresult = '"&preresult&"'    where resultIDX = " & scidx
			Call db.execSQLRs(SQL , null, ConStr)			

		Else
			Call oJSONoutput.Set("SETEND", "ING" )		
		End if
			
	Else
			Call oJSONoutput.Set("SETEND", "ING" )
	End If

	
	strTableName = " sd_TennisResult_record "
	strWhere = "  where  rcIDX = " & rkey
		
	SQL = "UPDATE " & strTableName &" Set  gameend= 1 " & strWhere
	Call db.execSQLRs(SQL , null, ConStr)


	setno = setno '경기종료 확인 후
	gameno = CDbl(gameno) + 1
	imode = 0 '처음 부터 시작


	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("GSET", setno )
	Call oJSONoutput.Set("GAME", gameno )

	'Call oJSONoutput.Set("debug",startsc )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 