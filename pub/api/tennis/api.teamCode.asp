<%
	'request
	strSportsGb = oJSONoutput.SportsGb
	strTeamGb = oJSONoutput.TeamGb

	Set db = new clsDBHelper

	strSql = "SELECT Sex, TeamGb, TeamGbNm,OrderBy "
	strSql = strSql &  "  FROM tblTeamGbInfo "
	strSql = strSql &  " WHERE PTeamGb = '" + strTeamGb + "'"
	strSql = strSql &  " AND SportsGb = '" + strSportsGb + "'"
	strSql = strSql &  " AND DelYN = 'N'"
	strSql = strSql &  " ORDER BY OrderBY ASC"
	'Response.write strSQL
	'Response.end
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	rscnt =  rs.RecordCount

	ReDim JSONarr(rscnt-1)

	i = 0
	Do Until rs.eof
	Set rsarr = jsObject() 
		rsarr("Sex") = rs("Sex")
		rsarr("TeamGb") = rs("TeamGb")
		rsarr("TeamGbNm") = rs("TeamGbNm")
		rsarr("OrderBy") = rs("OrderBy") 
		Set JSONarr(i) = rsarr

	i = i + 1
	rs.movenext
	Loop
	datalen = Ubound(JSONarr) - 1

	jsonstr = toJSON(JSONarr)

	
	'response.ContentType="text/plain"	
	Response.Write CStr(jsonstr)

	db.Dispose
	Set db = Nothing
%>