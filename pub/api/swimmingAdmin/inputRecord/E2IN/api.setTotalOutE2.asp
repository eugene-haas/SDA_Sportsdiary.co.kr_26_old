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
	
		SQL = "update sd_gameMember_roundRecord Set rounding = case when totalscore > 0 then 'Y' else 'N' end where midx = "&midx&" "
		Call db.execSQLRs(SQL , null, ConStr)
	
	else
		SQL = "update SD_gameMember Set tryoutresult  = '"&setval&"',tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx
		Call db.execSQLRs(SQL , null, ConStr)
		
		SQL = "update sd_gameMember_roundRecord Set rounding = 'Y' where midx = "&midx&" "
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


	
	for i = 1 to judgeCnt
	Call setBooEnd(grouplevelidx,lidxs,lidx,midx,judgeCnt,i, db, ConStr)
	next

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>