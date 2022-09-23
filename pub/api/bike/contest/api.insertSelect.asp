<%
'######################
'주최, 주관 생성
'######################

	If hasown(oJSONoutput, "IDX") = "ok" then
		idx = oJSONoutput.IDX
	End if

	If hasown(oJSONoutput, "NAME") = "ok" then
		newname = oJSONoutput.NAME
	End if

	If hasown(oJSONoutput, "GAMES") = "ok" then
		GameS = oJSONoutput.GAMES
	Else
		GameS = ""
	End If
	If hasown(oJSONoutput, "GAMEE") = "ok" then
		GameE = oJSONoutput.GAMEE
	Else
		GameE = ""
	End if

	If hasown(oJSONoutput, "GAMEAS") = "ok" then
		GameAS = oJSONoutput.GAMEAS
	Else
		GameAS = ""
	End if

	If hasown(oJSONoutput, "GAMEAE") = "ok" then
		GameAE = oJSONoutput.GAMEAE
	Else
		GameAE = ""
	End if

	If hasown(oJSONoutput, "GH") = "ok" then
		g_h = oJSONoutput.GH
	End if


	Set db = new clsDBHelper

	'중복값확인
	SQL = "select idx from sd_openList where name =  '"&newname&"'  and gubun = 1"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof then
		Call oJSONoutput.Set("result", "2" ) '중복
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End
	End if

	'생성
	SQL = " insert into sd_openList (gubun , name) values (1,'"&newname&"')"
	Call db.execSQLRs(SQL , null, ConStr)

	'############

	SQL = "Select idx,name from sd_openList where delYN = 'N' and gubun = 1"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrO = rs.GetRows()
	End If


	If idx <> "" then
'		sfield = "SportsGb,SportsGbSub,GameTitle,GameType,Sido,zipcode,addr,Stadium,GameYear,GameS,GameE,Gamedatecnt,GameHost,GameOrganize"
'		sfield = sfield & ",VOD1,VOD2,VOD3,VOD4,VOD5,m_videoDate,h_videoDate,ip"
'		SQL = "Select top 1 GIDX,"&sfield&" from K_gameinfo where delYN = 'N' and GIDX =" & idx
'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'		If Not rs.eof then
'			newname = rs("gamehost")
'			newname2 = rs("gameorganize")
'			GameS = rs("GameS")
'			GameE = rs("GameE")
'		End if
	End if


	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/bike/ul03_c2.asp" -->
