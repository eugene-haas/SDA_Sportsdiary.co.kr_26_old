<%
'#############################################
'선수 정보 수정 ( 이름은 변경 되지 않습니다.)
'#############################################
	'request
	idx = oJSONoutput.p1idx
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

	If hasown(oJSONoutput, "syymm") = "ok" Then 
		syymm = oJSONoutput.syymm
	Else
		syymm = ""
	End If	


	phone = Replace(phone, "-","")

	If team1 = "" Then
		team1txt = ""
	End If
	If team2 = "" Then
		team2txt = ""
	End if	

	Set db = new clsDBHelper



	If team2txt <> "" Then
		SQL = "select top 1 team from tblTeamInfo where teamnm = '" & team2txt &"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof Then
			team2 = ""
		else
			team2 = rs(0)
		End If
	End if
	

	'부목록
	SQL = "select sex,PTeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('201') and DelYN = 'N' order by Orderby asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrBoo = rs.GetRows()
	End if

	SQL = "select TeamGb, TeamGbNm from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('201') and DelYN = 'N' and teamgb = '"&boo&"'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		bookey = rs("TeamGb")
		boo = rs("TeamGbNm")
	End if
	
	
	'이름 수정빼자
	If syymm <> "" Then
		syymmplus = ", gamestartyymm = '"&syymm&"' "
	End if

	updatevalue = " UserPhone='"&phone&"',Birthday='"&birth&"',sex='"&sex&"',userLevel='"&grade&"',Team='"&team1&"',TeamNm='"&team1txt&"',Team2='"&team2&"',Team2Nm='"&team2txt&"' ,teamgb='"&bookey&"',belongBoo='" &boo& "' " & syymmplus
	SQL = " Update  tblPlayer Set  " & updatevalue & " where PlayerIDX = " & idx
	'Response.write "SQL : " & SQL & "</br>"
	'Response.End
	Call db.execSQLRs(SQL , null, ConStr)

	pidx = idx
	pname =  name
	pbirth =  birth
	p1sex =  sex
	pteam1 =  team1txt
	pteam2 =  team2txt
	pphone =  phone
	prankno =  0
	pgrade =  grade
	writeday = Date()
	belongBoo = boo

  db.Dispose
  Set db = Nothing

belongBoo = boo
%>

	<!-- #include virtual = "/pub/html/RookietennisAdmin/PlayerList.asp" -->
