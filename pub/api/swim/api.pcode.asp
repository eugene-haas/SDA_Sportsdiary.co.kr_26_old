<%
	'request
	strSportsGb = oJSONoutput.SportsGb
	strPPubCode = oJSONoutput.PPubCode

	Set db = new clsDBHelper

	strSql = "Select SportsGb,PubCode,PubName,PPubCode,PPubName,OrderBy "
	strSql = strSql &  "From tblPubCode Where PPubCode='" & strPPubCode & "' and SportsGb='" & strSportsGb & "' and DelYN='N' "
	strSql = strSql &  " order by PubCode asc"

'Response.write strSQL
'Response.end
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	rscnt =  rs.RecordCount

	ReDim JSONarr(rscnt-1)

	i = 0
	Do Until rs.eof
	Set rsarr = jsObject() 
		rsarr("SportsGb") = rs("SportsGb")
		rsarr("PubCode") = rs("PubCode")
		rsarr("PubName") = rs("PubName")
		rsarr("PPubCode") = rs("PPubCode")
		rsarr("PPubName") = rs("PPubName")
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