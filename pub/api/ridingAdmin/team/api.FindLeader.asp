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
	SQL = " Select top 20 ksportsno as lkey, username as lnm from tblLeader where delyn = 'N' and  username like '"& sval &"%'  order by username desc"

	'Response.write sql
	'Response.end
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>