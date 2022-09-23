<%
	'request
	rkey = oJSONoutput.RKEY
	rckey = oJSONoutput.RCKEY
	setno  = oJSONoutput.SETNO
	winpos = oJSONoutput.WINPOS 'left , right

	startsc = oJSONoutput.STARTSC '시작점수
	tiesc = oJSONoutput.TIESC '타이블레이크룰 점수
	deucest = oJSONoutput.DEUCEST '듀스 상태 0: 기본룰 ,1: 노에드, 2: 1듀스 노에드

	Set db = new clsDBHelper

	strSql = "Delete from sd_TennisResult_record where rcIDX = " & rckey
	Call db.execSQLRs(strSql , null, ConStr)

	Select Case winpos
	Case "left" '마지막 값이 왼쪽 이지만 net out 이라면 ....
		SQL = "update sd_TennisResult Set m1set"&setno&" = m1set"&setno&"-1 where resultIDX =  " & rkey
		Call db.execSQLRs(SQL , null, ConStr)
	Case "right"
		SQL = "update sd_TennisResult Set m2set"&setno&" = m2set"&setno&"-1 where resultIDX =  " & rkey
		Call db.execSQLRs(SQL , null, ConStr)

	Case "left_svdel"
		SQL = "update sd_TennisResult Set m1set"&setno&" = m1set"&setno&"-1,secondserve=0 where resultIDX =  " & rkey
		Call db.execSQLRs(SQL , null, ConStr)
	Case "right_svdel"
		SQL = "update sd_TennisResult Set m2set"&setno&" = m2set"&setno&"-1,secondserve=0 where resultIDX =  " & rkey
		Call db.execSQLRs(SQL , null, ConStr)
	End Select

	'1경기 마지막꺼면 2서브도 삭제



	'##############################
	strTableName = " sd_TennisResult "
	strField = " a.gameMemberIDX1, a.gameMemberIDX2, a.stateno, a.gubun,gamekey3,gamekeyname,GameTitleIDX " 'gubun 0 예선
	strField = strField & " ,a.courtno,a.courtkind,a.recorderName,a.startserve,a.secondserve,a.courtmode,a.preresult,      b.setno,b.gameno,b.playsortno,b.gameend,b.leftscore,b.rightscore "
	SQL = "Select top 1 " & strField & " from " & strTableName & " as a LEFT JOIN sd_TennisResult_record as b ON a.resultIDX = b.resultIDX where a.resultIDX = " & rkey & " order by b.rcIDX desc"
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
	leftsc = rs("leftscore")
	rightsc = rs("rightscore")

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


	If courtno = "0" Then
		courtno = 1
		courtkind = 1
	End If


	'결과종료시 뒤로 돌리기
	If preresult <> "ING" Then
		SQL = "update sd_TennisResult Set preresult = 'ING' where resultIDX =  " & rkey
		Call db.execSQLRs(SQL , null, ConStr)
		preresult = "ING"
	End if



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

	Call oJSONoutput.Set("LSCORE", leftsc )
	Call oJSONoutput.Set("RSCORE", rightsc )
	Call oJSONoutput.Set("result", "0" )

	
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%>