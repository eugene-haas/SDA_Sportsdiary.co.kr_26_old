<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	fstr = oJSONoutput.FSTR
	fstr2 = oJSONoutput.FSTR2
	title = oJSONoutput.TITLE
	idx = oJSONoutput.TitleIDX
	entrycnt = oJSONoutput.EntryCnt
	'courtcnt = oJSONoutput.COURTCNT

	startscore = oJSONoutput.StartSC 
	endround= oJSONoutput.LastRnd
	gametype = oJSONoutput.VersusGb
	gamedate = oJSONoutput.GameDate
	gametime = oJSONoutput.GameTime

	Set db = new clsDBHelper

	If  fstr = "tn001001" Then '개인전
	SQL = "select sex,PTeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('200', '201') and DelYN = 'N' order by Orderby asc"
	Else
	SQL = "select sex,TeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis'  and PTeamGb in ('202') and DelYN = 'N' order by Orderby asc"
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End If

	'#######################


	SQL = "select Level,LevelNm,Orderby  from tblLevelINfo where SportsGb = 'tennis' and TeamGb = '"&fstr2&"' and DelYN = 'N' order by Orderby asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS2 = rs.GetRows()
	End If

	db.Dispose
	Set db = Nothing
%>

<!-- #include virtual = "/pub/html/swimAdmin/gameinfoLevelFormLine1.asp" -->