<%
'#############################################
'
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 'level idx 
		idx = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "SVAL") = "ok" then
		sval = oJSONoutput.SVAL
	End if

	Set db = new clsDBHelper

	IF LEN(searchText) = 1 Then
		top = "top 20"
	ELSEIF LEN(searchText) = 2 Then
		top = "top 20"
	END IF


	Set db = new clsDBHelper

	'참가 신청하지 않은 유저 중에 검색작업할것

	SQL = " Select top 20 team,teamnm,max(sido) as sido,max(teamregdt) as teamregdt,max(sexno) as sexno from tblteaminfo where teamnm like '"& sval &"%'  and delYN = 'N' group by team,teamnm "'order by TeamIDX desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>