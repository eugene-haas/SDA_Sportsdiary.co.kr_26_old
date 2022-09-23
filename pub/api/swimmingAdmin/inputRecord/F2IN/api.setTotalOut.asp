<%
'#############################################
'사유 실격등 (전체에 대해)
'#############################################
	
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	roundno = oJSONoutput.Get("RNO") '라운드 (비교할 라운드)

	setval = oJSONoutput.Get("SETVAL")
	If setval = "" then
		setval = "00000" '숫자로 저장
	End if
	
	Set db = new clsDBHelper 

	'사유(전체)결과 저장
	if setval = "00000" then '해제
		SQL = "update SD_gameMember Set tryoutresult  = '"&setval&"',tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx
		Call db.execSQLRs(SQL , null, ConStr)
	else
		SQL = "update SD_gameMember Set tryoutresult  = '"&setval&"',tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx
		Call db.execSQLRs(SQL , null, ConStr)
	end if
	


	'결과체크및 결과반영 순위생성 totalscore 다시계산해서 넣는다.
	Call setGameResut(lidx, midx, roundno, db, ConStr)



	'tblRGameLevel_judge_EndCheck 끝인지 판단해서 1~15까지 N > Y
	booinfo = getBooInfo(lidx, db, ConStr, CDA)
	grouplevelidx = booinfo(0) 
	RoundCnt =  booinfo(1)
	judgeCnt =  booinfo(2)
	lidxs = booinfo(3)
	cdc = booinfo(4)


	'refreeno = 0 '종료되었다면 모두 Y (심판번호와 상관없이) 취소는 다된상태에서 발생할일이 없다고 가정하자.... (되돌리기 만들어야할까 )
	
	'심판수 만큼 호출해주자. 
	'if 피겨 1234 라면 심판 7까지만
	if cdc = "01" and Cdbl(roundno) < 5  then '피겨솔로
		judgeCnt = 7
	end if

	for i = 1 to judgeCnt
		Call setBooEnd(grouplevelidx,lidxs,lidx,midx,judgeCnt,i,roundno, db, ConStr)
	next




	
	Call oJSONoutput.Set("result", 0 ) '취소때는
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>