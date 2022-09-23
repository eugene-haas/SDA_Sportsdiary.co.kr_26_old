<%

'######################
'수정항목불러오기
'######################
	datareq = True

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

	If datareq = False then
		Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End
	End If


	Set db = new clsDBHelper




	strTable = " sd_bikeLevel "
	strfield = "levelIDX, titleIDX, levelno, GameDay, WriteDate, DelYN, solocnt, gamecnt, sex, booNM"
	strWhere = " levelIDX = " & idx

	SQL = " SELECT " & strfield & " FROM " & strTable & " WHERE " & strWhere & " AND DelYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	levelno = rs("levelno")
	game_cnt = rs("gamecnt")
	gamemcnt = rs("solocnt")
	GameS = rs("GameDay")
	ssex = rs("sex")
	sdepartment = rs("booNM")


	'levelno 로 title구하기
	strTable = " sd_titleList "
	strfield = " title, subtitle, detailtitle "
	strWhere = " levelno = " & levelno

	SQL = " SELECT " & strfield & " FROM " & strTable & " WHERE " & strWhere & " AND delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	stitle = rs("title")
	ssubtitle = rs("subtitle")
	sdetailtitle = rs("detailtitle")

	'부
	SQL = "Select idx,name from sd_openList where delYN = 'N' and gubun = 2"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrD = rs.GetRows()
	End If

	'종목
	SQL = "Select levelno,title,subtitle,detailtitle from sd_titleList where delYN = 'N'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End If





	db.Dispose
	Set db = Nothing
%>

<!-- #include virtual = "/pub/html/bike/form.contestlevel2.asp" -->
