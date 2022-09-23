<%
'#############################################
'오전 오후
'#############################################
	
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	gbidx = oJSONoutput.Get("GBIDX")
	timestr = oJSONoutput.Get("TIMESTR") '10:00 오전 13:00 오후
	CDA = "F2"
	
	Set db = new clsDBHelper 


		'화면에서 통합시 사용못함으로 처리하자.
		artinfo = getArtiGroup(tidx,lidx,gbidx,  db,Constr,CDA)
		lidxs = artinfo(0)
		gbidxs = artinfo(1)

		'두번째 대회 날짜와 오전오후 (음 구조가 ㅡㅡ+)
		SQL = "update tblRGameLevel set finalgamestarttime = '" & timestr & "' where RGameLevelidx in ( "&lidxs&" ) "
		Call db.execSQLRs(SQL , null, ConStr)




	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>