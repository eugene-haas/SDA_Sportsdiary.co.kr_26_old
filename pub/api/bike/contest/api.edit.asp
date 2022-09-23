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

	If datareq = False then
		Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End
	End If


	Set db = new clsDBHelper


	strTable = " sd_bikeTitle a"
	strfield = "titleIDX, GameTitleName, EnterType, GameS, GameE, GameRcvDateS, GameRcvDateE, hostname, titleCode, GameArea, addr, zipcode, sido,"
	substrfield = " ( select hostTitle from sd_bikeTitleCode where titleCode = a.titleCode ) as hostTitle "
	strWhere = " titleIDX = " & idx

	SQL = " SELECT " & strfield & substrfield & " FROM " & strTable & " WHERE " & strWhere & " AND DelYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	sgb = rs("hostTitle")
	GameTitle = rs("GameTitleName")
	gametype = rs("EnterType")
	gameaddr = rs("addr")
	zipcode = rs("zipcode")
	sido = rs("sido")
	stadium = rs("GameArea")
	GameS = rs("GameS")
	GameE = rs("GameE")
	GameAS = rs("GameRcvDateS")
	GameAE = rs("GameRcvDateE")
	newname = rs("hostname")

	'그룹/종목
	SQL = "Select titleCode,hostTitle from sd_bikeTitleCode where delYN = 'N' order by hostTitle "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End If

	SQL = "Select idx,name from sd_openList where delYN = 'N' and gubun = 1"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrO = rs.GetRows()
	End If

	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/bike/form.contest2.asp" -->
