<%
'#############################################
' 라운드 감점 처리
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	roundno = oJSONoutput.Get("RNO") '라운드
	btnstate = oJSONoutput.Get("BTNST") '보낼때 버튼상태
	CDA = "E2" '다이빙

	Set db = new clsDBHelper


		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)
		cdc = booinfo(4)

		'예외처리
		'call judgeExceptionRound(midx,roundno , db, ConStr ,CDA) '완료여부체크

		'사용자가 보고 보낼당시 상황에 맞추어서 처리
		If btnstate = "default" then
			SQL = "Update sd_gameMember_roundRecord set rounding = 'Y' where  midx  = "&midx&"  and gameround = "&roundno&"  "
		Else
			SQL = "Update sd_gameMember_roundRecord set rounding = 'N' where  midx  = "&midx&"  and gameround = "&roundno&"  "
		End If
		Call db.execSQLRs(SQL , null, ConStr)




		'결과체크및 결과반영 순위생성 totalscore 다시계산해서 넣는다.
		Call setGameResut(lidx, midx, roundno, db, ConStr)




	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
