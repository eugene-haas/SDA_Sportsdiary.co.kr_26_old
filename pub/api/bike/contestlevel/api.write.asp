<%
'######################
'등록
'######################
	datareq = True

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	Else
		datareq = False
	End If
	If hasown(oJSONoutput, "SGB") = "ok" then
		stitle = oJSONoutput.SGB
	Else
		datareq = False
	End If
	If hasown(oJSONoutput, "SGBSUB") = "ok" then
		ssubtitle = oJSONoutput.SGBSUB
	Else
		datareq = False
	End If
	If hasown(oJSONoutput, "SGBDETAIL") = "ok" then
		sdetailtitle = oJSONoutput.SGBDETAIL
	Else
		datareq = False
	End If
	If hasown(oJSONoutput, "GameS") = "ok" then
		games = oJSONoutput.GameS
	Else
		datareq = False
	End if

	If hasown(oJSONoutput, "SOLOCNT") = "ok" then
		solocnt = oJSONoutput.SOLOCNT
	Else
		solocnt = 2
	End if

	If hasown(oJSONoutput, "GAMECNT") = "ok" then
		gamecnt = oJSONoutput.GAMECNT
	Else
		gamecnt = 1
	End if

	If hasown(oJSONoutput, "MEMBERSEX") = "ok" then
		membersex = oJSONoutput.MEMBERSEX
	Else
		datareq = False
	End if

	If hasown(oJSONoutput, "DEPARTMENT") = "ok" then
		department = oJSONoutput.DEPARTMENT
	Else
		datareq = False
	End if

	If solocnt = "" Then
		solocnt = 0
	End if


	'##############################

	If datareq = False then
		Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End
	End If


	Set db = new clsDBHelper

	SQL = "select top 1 EnterType from sd_bikeTitle  where titleIDX =  " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	entertype = rs(0)

	'levelno 구하기
	SQL = "select top 1 levelno from sd_titleList where title='"&stitle&"' and subtitle = '"&ssubtitle&"' and detailtitle = '"&sdetailtitle&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	levelno = rs(0)

	insertfield = " titleIDX,levelno,subtitle,detailtitle,GameDay,EnterType,solocnt,gamecnt,sex,booNM "
	fieldvalue = " "&tidx&","&levelno&", '"&ssubtitle&"', '"&sdetailtitle&"','"&games&"','"&entertype&"',"&solocnt&","&gamecnt&", '"&membersex&"', '"&department&"'  "
	SQL = " insert into sd_bikeLevel ("&insertfield&") values ("&fieldvalue&")"
	Call db.execSQLRs(SQL , null, ConStr)

	'############
	boofield = " (select title + ' ' + subtitle + ' ' + detailtitle from sd_titleList where levelno = a.levelno )  as boo "
	strFieldName = "levelIDX,titleIDX,levelno,detailtitle,GameDay,EnterType,sex,booNM,WriteDate,DelYN , " & boofield



	SQL = "Select top 1 "&strFieldName&" from sd_bikeLevel as a where delYN = 'N' order by levelIDX desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	Do Until rs.eof
		b_boo = rs("boo")
		b_idx = rs("levelIDX")
		b_tidx = rs("titleIDX")
		b_levelno = rs("levelno")
		b_sdetailtitle = rs("detailtitle")
		b_GameS = Replace(Left(rs("Gameday"),10),"-",".")
		b_writeday = Replace(Left(rs("writedate"),10),"-",".")
		b_sex = rs("sex")
		b_booNM = rs("booNM")

		%><!-- #include virtual = "/pub/html/bike/list.contestlevel2.asp" --><%
	  rs.movenext
	  Loop
	  Set rs = Nothing

	db.Dispose
	Set db = Nothing
%>
