<%
'#############################################
'다이빙부통합해제
'#############################################

	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
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


	SQL = "update tblRGameLevel set Grouplevelidx = null  Where Grouplevelidx in (" & lidxs & ") "
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>