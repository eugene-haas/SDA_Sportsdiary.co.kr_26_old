<%
'#############################################
' 라운드별 심판별 입력값 저장
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	roundno = oJSONoutput.Get("RNO") '라운드
	judgeno = oJSONoutput.Get("JNO") '심판위치번호
	setval = CDbl(Replace(oJSONoutput.Get("SETVAL"),".",""))
	If setval = "" then
		setval = 0
	End If
	If Len(setval) = 1 Then
		setval = setval & "0"
	End if
	
	CDA = "E2" '다이빙

	Set db = new clsDBHelper


		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)
		cdc = booinfo(4)

		'저장
		SQL = "Update sd_gameMember_roundRecord set jumsu"&judgeno&" = "&setval&" where  midx  = "&midx&"  and gameround = "&roundno&"  "
		Call db.execSQLRs(SQL , null, ConStr)

		'결과체크및 결과반영 순위생성 totalscore 다시계산해서 넣는다.
		Call setGameResut(lidx, midx, roundno, db, ConStr)



  refreeno = judgeno '종료되었다면 Y 심판번호위치
	Call setBooEnd(grouplevelidx,lidxs,lidx,midx,judgeCnt,refreeno, db, ConStr)



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
