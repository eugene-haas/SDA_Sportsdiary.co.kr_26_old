<%
'#############################################
' 총점 감점 처리
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	roundno = oJSONoutput.Get("RNO") '라운드
	setvalue = oJSONoutput.Get("SETVAL") '값
	CDA = "F2" '아티스틱

	Set db = new clsDBHelper


		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)
		cdc = booinfo(4)

		'예외처리
		
		'a_eletotaldeduction = arrR(68, ari) '엘리먼트총점에서 감점
		'a_totaldeduction = arrR(67, ari) '아티스틱 총점에서 감점
		'a_elededuction  = arrR(69, ari)'각엘리먼트에서 감점

		'사용자가 보고 보낼당시 상황에 맞추어서 처리 ( 각라운드 동일하게 다넣어두자. )
		SQL = "Update sd_gameMember_roundRecord set a_totaldeduction = "&setvalue&" where  midx  = "&midx&" "
		'Call oJSONoutput.Set("sql", sql )
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