<%
'#############################################
'팀명칭 검색
'#############################################
	'request
	If hasown(oJSONoutput, "SVAL") = "ok" then
		sval = oJSONoutput.SVAL
	End if
		entertype = OJSONoutput.Get("ENTERTYPE")  'N E A 초기상태 엘리트 아마추어


	Set db = new clsDBHelper



	SQL = " Select top 20 team,teamnm, (teamnm +  left(TeamRegDt,4)) as teamtxt from tblTeamInfo where teamnm like '"& sval &"%'  and entertype = '"&entertype&"' and delyn = 'N' order by TeamRegDt desc"

	'Response.write sql
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>