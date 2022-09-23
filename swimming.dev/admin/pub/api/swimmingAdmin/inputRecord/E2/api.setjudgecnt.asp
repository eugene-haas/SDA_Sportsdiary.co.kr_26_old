<%
'#############################################
'다이빙심사위원수 설정
'#############################################
	
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	gbidx = oJSONoutput.Get("GBIDX")
	jcnt = oJSONoutput.Get("JCNT")

	CDA = "E2" '다이빙


	Set db = new clsDBHelper 

		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)

		'예외처리
		Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '체점여부
		'심판정보 리셋
		Call resetJudge(tidx, lidxs , db, ConStr ,CDA)



		'심사위원명수 설정
		SQL = "update tblRGameLevel set judgecnt = " & jcnt & " where RGameLevelidx in ( "&lidxs&" ) "
		Call db.execSQLRs(SQL , null, ConStr)



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>