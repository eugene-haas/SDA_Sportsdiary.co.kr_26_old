<%
'#############################################
'난이율 인덱스 저장
'#############################################
	
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	gbidx = oJSONoutput.Get("GBIDX")
	gamedate = oJSONoutput.Get("GAMEDATE")
	CDA = "F2"
	
	Set db = new clsDBHelper 

		'통합기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)
		cdc = booinfo(4)
		'grouplevelidx = booinfo(0) 
		'RoundCnt =  booinfo(1)
		'judgeCnt =  booinfo(2)
		'lidxs = booinfo(3) '통합한 부서구...


		'화면에서 통합시 사용못함으로 처리하자.
		artinfo = getArtiGroup(tidx,lidx,gbidx,  db,Constr,CDA)
		lidxs = artinfo(0)
		gbidxs = artinfo(1)

		if CDC = "05" or CDC = "07" or CDC = "11" then '프리는 한날짜고정 동일날짜로  만든다.
		SQL = "update tblRGameLevel set tryoutgamedate = '" & gamedate & "',finalgamedate = '" & gamedate & "' where  RGameLevelidx in ( "&lidxs&" ) "
		else
		SQL = "update tblRGameLevel set finalgamedate = '" & gamedate & "' where  RGameLevelidx in ( "&lidxs&" ) "
		end if
		Call db.execSQLRs(SQL , null, ConStr)



	'Call oJSONoutput.Set("sql", sql ) ' debug
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>