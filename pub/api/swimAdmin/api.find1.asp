<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	fstr = oJSONoutput.FSTR
	title = oJSONoutput.TITLE
	idx = oJSONoutput.TitleIDX
	entrycnt = oJSONoutput.EntryCnt
	'courtcnt = oJSONoutput.COURTCNT

	'fstr = "tn001001" '개인전
	'fstr = "tn001002" '단체전

	startscore = oJSONoutput.StartSC 
	endround= oJSONoutput.LastRnd

	gametype = oJSONoutput.VersusGb
	gamedate = oJSONoutput.GameDate
	gametime = oJSONoutput.GameTime


	Set db = new clsDBHelper


	SQL = "select sex,PTeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('201') and DelYN = 'N' order by Orderby asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if


	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/swimAdmin/gameinfoLevelFormLine1.asp" -->
