<%
'#############################################


'#############################################
	'request
	If hasown(oJSONoutput, "t_midx") = "ok" then
		memberidx= oJSONoutput.t_midx
	End if
	If hasown(oJSONoutput, "t_mid") = "ok" then
		userid= oJSONoutput.t_mid
	End if


	name = oJSONoutput.p1name
	phone = oJSONoutput.p1phone
	birth = oJSONoutput.p1_birth
	sex = oJSONoutput.p1sex
	grade = oJSONoutput.p1grade
	team1 = oJSONoutput.p1team1
	team1txt = oJSONoutput.p1team1txt
	team2 = oJSONoutput.p1team2
	team2txt = oJSONoutput.p1team2txt
	boo = oJSONoutput.boo

	phone = Replace(phone, "-","")

	If team1 = "" Then
		team1txt = ""
	End If
	If team2 = "" Then
		team2txt = ""
	End if	

	Set db = new clsDBHelper

	SQL = "select MAX(PersonCode) from tblPlayer where SportsGb = 'tennis' and DelYN = 'N'"

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If isNumeric(rs(0)) = False  then
		pcode = 200000000
	Else
		If CDbl(rs(0)) < 200000000 Then
			pcode = 200000000
		else
			pcode = CDbl(rs(0)) + 1
		End if
	End if

	'유저명
	SQL = "select UserName from tblPlayer where UserName = '"&name&"' and belongBoo = '"&boo&"' and userPhone = '"&phone&"' " 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	If rs.eof Then
		


		SQL = "select TeamGb, TeamGbNm from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('201') and DelYN = 'N' and teamgb = '"&boo&"'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			bookey = rs("TeamGb")
			boo = rs("TeamGbNm")
		End if

		insertfield = " SportsGb,UserName,UserPhone,Birthday,Sex,EnterType,Team,TeamNm,Team2,Team2Nm,userLevel,PersonCode,teamgb,belongBoo,memberidx,userid "
		insertvalue = " 'tennis','"&name&"','"&phone&"','"&birth&"','"&sex&"','A','"&team1&"','"&team1txt&"','"&team2&"','"&team2txt&"','"&grade&"','"&pcode& "','"&bookey&"','"&boo&"','"&memberidx&"','"&userid&"' "
		SQL = "SET NOCOUNT ON INSERT INTO tblPlayer ( "&insertfield&" ) VALUES " 
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		pidx = rs(0)
	Else
		
		'중복
		Call oJSONoutput.Set("result", "2" ) '신청된 사용자 존재
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.End			
	End if

	pidx = pidx
	pname =  name
	pbirth =  birth
	psex =  sex
	pteam1 =  team1txt
	pteam2 =  team2txt
	pphone =  phone
	prankno =  0
	pgrade =  grade
	belongBoo = boo
	writeday = Date()


  Set rs = Nothing
  db.Dispose
  Set db = Nothing

%>
	<!-- #include virtual = "/pub/html/riding/PlayerList.asp" -->