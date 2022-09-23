<%
'#############################################
'
'#############################################
	'request
	If hasown(oJSONoutput, "SVAL") = "ok" then
		sval = oJSONoutput.SVAL
	End if

	Set db = new clsDBHelper


	'참가 신청하지 않은 유저 중에 검색작업할것
	SQL = " Select top 20 team,teamnm, (teamnm +  left(TeamRegDt,4)) as teamtxt from tblTeamInfo where teamnm like '"& sval &"%'  order by TeamRegDt desc"

	'Response.write sql
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>