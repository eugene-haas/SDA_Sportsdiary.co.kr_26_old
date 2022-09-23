<%
'#############################################


'#############################################
	'request
	name = oJSONoutput.pname
	phone = oJSONoutput.pphone
	levelno = oJSONoutput.levelno

	If hasown(oJSONoutput, "pteam1") = "ok" then
		team1 = oJSONoutput.pteam1
	Else
		team1 = ""
	End If

	If hasown(oJSONoutput, "pteam2") = "ok" then
		team2 = oJSONoutput.pteam2
	Else
		team2 = ""
	End If

	Set db = new clsDBHelper
	If isnumeric(phone) = False Then
		Call oJSONoutput.Set("result", 4002 ) '숫자가 아닌전화번호
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	Set db = new clsDBHelper

	If stateRegExp(name ,"[^-가-힣a-zA-Z0-9/ ]") = False Or stateRegExp(team1 ,"[^-가-힣a-zA-Z0-9/ ]") = False Or stateRegExp(team2 ,"[^-가-힣a-zA-Z0-9/ ]") = False then '한,영,숫자
		Call oJSONoutput.Set("result", "10" ) '사용하면 안되는 문자발생
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	'1.기존 이름과 폰번호가 중복되었는지 확인해서 알려준다.
		SQL = "SELECT top 1 playeridx from tblPlayer where DelYN = 'N' and UserName = '" & name & "' and UserPhone = '" & phone & "' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
		If Not rs.eof Then 
			Call oJSONoutput.Set("result", 4003 ) '등록된 선수
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.end
		End if

	'2 팀명 중복확인 팀명 생성
	Function teamChk(ByVal teamNm)
		Dim rs, SQL ,insertfield ,insertvalue ,teamcode
		SQL = "Select Team from tblTeamInfo where SportsGb = 'tennis' and TeamNm = '"&Replace(Trim(teamNm)," ","")&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		If rs.eof Then
			'등록 후 정보
			SQL = "Select top 1 convert(nvarchar,SUBSTRING(Team,4,LEN(Team))+1) teamLast,len(Team)TeamLen from  tblTeamInfo where SportsGb = 'tennis'  ORDER BY Team desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			teamcode = "ATE000" & rs(0)

			insertfield = " SportsGb,Team,TeamNm,EnterType,TeamLoginPwd,NowRegYN "
			insertvalue = "'tennis','"&teamcode&"','"&Replace(Trim(teamNm)," ","")&"','A','"&teamcode&"','Y' "

			SQL = "INSERT INTO tblTeamInfo ( "&insertfield&" ) VALUES ( "&insertvalue&" ) "
			Call db.execSQLRs(SQL , null, ConStr)
			teamChk = teamcode
		Else
			teamChk = rs(0)
		End If
	End function

	If team1 <> "" then
	team1code = teamChk(team1)
	End If
	If team2 <> "" then
	team2code = teamChk(team2)
	End if


	'부명칭구하기
	SQL = "select top 1 teamGbNm from tblRGameLevel where TeamGb = '"&Left(levelno,5)&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	belongBoo = rs(0)


	'3 선수 생성
	insertfield = " SportsGb,UserName,EnterType,Team,TeamNm, Team2,Team2Nm,UserPhone,belongBoo "
	insertvalue = " 'tennis','"&name&"','A','"&team1code&"','"&team1&"','"&team2code&"','"&team2&"', '"&phone&"','"&belongBoo&"' "

	SQL = "INSERT INTO tblPlayer ( "&insertfield&" ) VALUES ( "&insertvalue&" ) "
	Call db.execSQLRs(SQL , null, ConStr)
	

	Set rs = Nothing
	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>