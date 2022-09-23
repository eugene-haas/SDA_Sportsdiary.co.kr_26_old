<%
'#############################################
'난이율 인덱스 저장
'#############################################
	
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	gbidx = oJSONoutput.Get("GBIDX")
	gamedate = oJSONoutput.Get("GAMEDATE")
	
	Set db = new clsDBHelper 

	'기본정보 호출
	booinfo = getBooInfo(lidx, db, ConStr, CDA)
	grouplevelidx = booinfo(0) 
	RoundCnt =  booinfo(1)
	judgeCnt =  booinfo(2)
	lidxs = booinfo(3)



	SQL = "update tblRGameLevel set tryoutgamedate = '" & gamedate & "' where  RGameLevelidx in ( "&lidxs&" ) "
	Call db.execSQLRs(SQL , null, ConStr)


	'Call oJSONoutput.Set("sql", sql ) ' debug
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson



	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>