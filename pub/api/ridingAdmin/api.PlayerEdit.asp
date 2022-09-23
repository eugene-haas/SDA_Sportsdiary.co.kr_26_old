<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.IDX


	Set db = new clsDBHelper

	'부목록
	SQL = "select sex,PTeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('201') and DelYN = 'N' order by Orderby asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrBoo = rs.GetRows()
	End if	

	
	'팀정보목록가져오기
	SQL = "Select Team,TeamNm from tblTeamInfo where SportsGb = 'tennis' and DelYN = 'N' "
	Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rst.EOF Then 
		arrRS = rst.GetRows()
	End if


	strSql = "SELECT top 1  PlayerIDX,UserName, Sex,Birthday,userLevel,UserPhone,teamNm,team2Nm,Team,Team2,belongBoo"
	strSql = strSql &  "  FROM tblPlayer  "
	strSql = strSql &  " WHERE PlayerIDX = " & idx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then
		p1idx = rs("PlayerIDX")
		p1name = rs("UserName")
		p1sex = rs("Sex")
		p1birth = rs("Birthday") 
		p1grade = rs("userLevel")
		p1phone = rs("UserPhone")
		team = rs("Team")
		p1t1 = rs("teamNm")
		team2 = rs("Team")
		p1t2 = rs("team2Nm")
		belongBoo = rs("belongBoo")
	End if

	db.Dispose
	Set db = Nothing



Call oJSONoutput.Set("result", "0" ) 
Call oJSONoutput.Set("NM", p1name ) 
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
%>
<!-- #include virtual = "/pub/html/riding/PlayerFormP1.asp" -->