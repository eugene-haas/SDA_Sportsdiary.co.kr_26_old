<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.UIDX
	levelno = oJSONoutput.LevelNo
	playerno = oJSONoutput.player

	titleidx = oJSONoutput.TitleIDX
	title = oJSONoutput.Title
	teamidx = oJSONoutput.TeamIDX  '인덱스
	teamnm = oJSONoutput.temnm
	levelnm = oJSONoutput.levelnm
	urpoint =  oJSONoutput.URPOINT


	Set db = new clsDBHelper
	'팀정보목록가져오기
	SQL = "Select Team,TeamNm from tblTeamInfo where SportsGb = 'tennis' and DelYN = 'N' "
	Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rst.EOF Then 
		arrRS = rst.GetRows()
	End if

	strSql = "SELECT top 1 UserName,PlayerIDX,UserPhone,Birthday,Sex,TeamNm,Team2Nm,userLevel  from tblPlayer where SportsGb = 'tennis' and DelYN = 'N' and PlayerIDX = " & idx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	rscnt =  rs.RecordCount

	ReDim JSONarr(rscnt-1)

	i = 0
	Do Until rs.eof
		If playerno = "1" then
		p1idx = rs("PlayerIDX")
		p1name = rs("UserName")
		p1phone = rs("UserPhone")
		p1birth = rs("Birthday")
		p1sex = rs("Sex")
		p1t1 = rs("TeamNm")
		p1t2 = rs("Team2Nm")
		p1grade = rs("userLevel")
		Else
		p2idx = rs("PlayerIDX")
		p2name = rs("UserName")
		p2phone = rs("UserPhone")
		p2birth = rs("Birthday")
		p2sex = rs("Sex")
		p2t1 = rs("TeamNm")
		p2t2 = rs("Team2Nm")
		p2grade = rs("userLevel")
		End if
	i = i + 1
	rs.movenext
	Loop




	db.Dispose
	Set db = Nothing

Select Case playerno
Case "1"
p1rpoint = urpoint
%>
<!-- #include virtual = "/pub/html/RookietennisAdmin/gameinfoPlayerFormP1.asp" -->
<%Case "2"
p2rpoint = urpoint
%>
<!-- #include virtual = "/pub/html/RookietennisAdmin/gameinfoPlayerFormP2.asp" -->
<%End Select%>