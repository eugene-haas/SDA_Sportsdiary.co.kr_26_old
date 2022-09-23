<%
	'request
	searchText = Replace(oJSONoutput.SVAL,Chr(34), "")
	Set db = new clsDBHelper
	'참가 신청하지 않은 유저 중에 검색작업할것

	IF LEN(searchText) = 1 Then
		top = "top 20"
	ELSEIF LEN(searchText) = 2 Then
		top = "top 20"
	END IF

	strSql = " Select " & top & " Team as TeamCode ,TeamNm,address,jangname "
	strSql = strSql  & " from tblTeamInfo "
	strSql = strSql  & " where SportsGb = 'tennis' and DelYN = 'N' and (TeamNm like '%" & searchText & "%' or Team like '%" & searchText & "%')"
	'Response.Write strSql & "<br>"

	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)

	rscnt =  rs.RecordCount

	ReDim JSONarr(rscnt-1)

	i = 0
	Do Until rs.eof
	Set rsarr = jsObject() 
	
		teamCode = rs("TeamCode") 
		teamName = rs("TeamNm") 
		address = rs("address")
		jangname = rs("jangname")
		
		rsarr("TeamCode") = teamCode
		rsarr("TeamName") = teamName
		rsarr("addr") = address
		rsarr("jangname") = jangname
	
		Set JSONarr(i) = rsarr

	i = i + 1
	rs.movenext
	Loop
	
	jsonstr = toJSON(JSONarr)
	Response.Write CStr(jsonstr)
	'Call oJSONoutput.Set("result", strSql )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write CStr(strjson)

	db.Dispose
	Set db = Nothing
%>