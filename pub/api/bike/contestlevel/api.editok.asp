<%
'######################
'등록
'######################
	datareq = True

'데이터확인 시작
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx = oJSONoutput.IDX
	Else
		datareq = False
	End If

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	Else
		datareq = False
	End If

	If hasown(oJSONoutput, "SGB") = "ok" then
		sgb = oJSONoutput.SGB
	Else
		datareq = False
	End If

	If hasown(oJSONoutput, "SGBSUB") = "ok" then
		sgbsub = oJSONoutput.SGBSUB
	Else
		datareq = False
	End If

	If hasown(oJSONoutput, "SGBDETAIL") = "ok" then
		sgbdetail = oJSONoutput.SGBDETAIL
	Else
		datareq = False
	End If

	If hasown(oJSONoutput, "GameS") = "ok" then
		gameday = oJSONoutput.GameS
	Else
		datareq = False
	End If

	If hasown(oJSONoutput, "SOLOCNT") = "ok" then
		solocnt = oJSONoutput.SOLOCNT
	Else
		solocnt = 0
	End If

	If hasown(oJSONoutput, "GAMECNT") = "ok" then
		gamecnt = oJSONoutput.GAMECNT
	Else
		datareq = False
	End If

	If hasown(oJSONoutput, "MEMBERSEX") = "ok" then
		membersex = oJSONoutput.MEMBERSEX
	Else
		datareq = False
	End If

	If hasown(oJSONoutput, "DEPARTMENT") = "ok" then
		department = oJSONoutput.DEPARTMENT
	Else
		datareq = False
	End If

	If datareq = False then
		Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End
	End If

'데이터확인 끝

Set db = new clsDBHelper

	'levelno 구하기
	SQL = "select top 1 levelno from sd_titleList where title='" & sgb & "' and subtitle = '" & sgbsub & "' and detailtitle = '" & sgbdetail & "' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	levelno = rs(0)


	'업데이트
	updateTable = " sd_bikeLevel "
	updatefield = "	levelno = " & levelno & ", subtitle = '" & sgbsub & "', detailtitle = '" & sgbdetail & "', GameDay = '" & gameday & "', "
	updatefield = updatefield & " WriteDate = getdate() , solocnt = " & solocnt & ", gamecnt = " & gamecnt & ", sex = '" & membersex & "', booNM = '" & department & "'  "
	SQL = " UPDATE " & updateTable & " SET " & updatefield & " WHERE levelIDX = " & idx
	Call db.execSQLRs(SQL , null, ConStr)


	'리스트 다시가져오기
	boofield = " (select title + ' ' + subtitle + ' ' + detailtitle from sd_titleList where levelno = a.levelno )  as boo "
	strFieldName = "levelIDX,titleIDX,levelno,detailtitle,GameDay,EnterType,sex,booNM,WriteDate,DelYN , " & boofield

	SQL = "Select " & strFieldName & " from sd_bikeLevel as a where delYN = 'N'  AND levelIDX= " & idx

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	b_boo = rs("boo")
	b_idx = rs("levelIDX")
	b_tidx = rs("titleIDX")
	b_levelno = rs("levelno")
	b_sdetailtitle = rs("detailtitle")
	b_GameS = Replace(Left(rs("Gameday"),10),"-",".")
	b_writeday = Replace(Left(rs("writedate"),10),"-",".")
	b_sex = rs("sex")
	b_booNM = rs("booNM")

db.Dispose
Set db = Nothing
%>

<!-- #include virtual = "/pub/html/bike/list.contestlevel2.asp" -->
