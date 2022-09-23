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
	
	
	
	'이름 수정빼자
	updatevalue = " UserPhone='"&phone&"',Birthday='"&birth&"',sex='"&sex&"',userLevel='"&grade&"',Team='"&team1&"',TeamNm='"&team1txt&"',Team2='"&team2&"',Team2Nm='"&team2txt&"' ,belongBoo='" &boo& "' "
	SQL = " Update  tblPlayer Set  " & updatevalue & " where PlayerIDX = " & idx
	'Response.write "SQL : " & SQL & "</br>"
	'Response.End
	Call db.execSQLRs(SQL , null, ConStr)

	pidx = idx
	pname =  name
	pbirth =  birth
	psex =  sex
	pteam1 =  team1txt
	pteam2 =  team2txt
	pphone =  phone
	prankno =  0
	pgrade =  grade
	writeday = Date()

  db.Dispose
  Set db = Nothing

belongBoo = boo
%>

	<!-- #include virtual = "/pub/html/tennisAdmin/PlayerList.asp" -->
