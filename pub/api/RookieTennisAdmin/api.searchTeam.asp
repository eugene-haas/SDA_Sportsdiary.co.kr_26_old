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


	'strSql = "SELECT " & top & " UserName,PlayerIDX,UserPhone,Birthday,Sex,TeamNm,Team2Nm  from tblPlayer where SportsGb = 'tennis' and DelYN = 'N' and UserName like '" & uname & "%' " 
	'strSql =  strSql &" and PlayerIDX not in (Select P1_PlayerIDX from tblGameRequest Where  GameTitleIDX = " & titleIDX & " And Level = " & lvlIDX & " And P1_PlayerIDX is not null" 
	'strSql = strSql &" UNION Select P2_PlayerIDX from tblGameRequest Where  GameTitleIDX = " & titleIDX & " And Level = " & lvlIDX & " and P2_PlayerIDX is not null) "
	strSql = " Select " & top & " Team as TeamCode ,TeamNm "
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
		
		rsarr("TeamCode") = teamCode
		rsarr("TeamName") = teamName
	
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