<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.IDX
	titleidx = oJSONoutput.TitleIDX
	title = oJSONoutput.Title

	TeamIDX = oJSONoutput.TEAMIDX
	LevelNo = oJSONoutput.LEVELNO
	teamnm = oJSONoutput.temnm
	levelnm = oJSONoutput.levelnm


	Set db = new clsDBHelper

	'팀정보목록가져오기
	SQL = "Select Team,TeamNm from tblTeamInfo where SportsGb = 'tennis' and DelYN = 'N' "
	Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rst.EOF Then 
		arrRS = rst.GetRows()
	End if

	strTableName = "  tblGameRequest as a "
	lvlsql = " (select top 1 n.TeamGbNm + '('+ m.LevelNm + ')'  from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as TeamGbNm "
	strFieldName = " RequestIDX,GameTitleIDX,level,"&lvlsql&",EnterType,WriteDate,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX  "
	strFieldName = strFieldName & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P1_rpoint,P2_rpoint  "
	strWhere = " RequestIDX = "&idx

	strSql = "SELECT top 1 " & strFieldName
	strSql = strSql &  "  FROM  " & strTableName
	strSql = strSql &  " WHERE " & strWhere
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		 



	If Not rs.eof Then
'
		updateidx = rs("RequestIDX") '수정, 삭제 인덱스
		level = rs("level")
		Select Case Left(level,3)
		Case "201","200"
			boo = "개인전"
		Case "202"
			boo = "단체전"
		End Select
		
		p1idx = rs("P1_PlayerIDX")
		p1name = rs("P1_UserName")
		p1birth = rs("P1_Birthday")
		p1grade = rs("P1_UserLevel")
		p1phone = rs("P1_UserPhone")

		p1t1 = rs("P1_TeamNm")
		p1t2 = rs("P1_TeamNm2")
		p1sex = rs("P1_SEX")

		p2idx = rs("P2_PlayerIDX")
		p2name = rs("P2_UserName")
		p2birth = rs("P2_Birthday")
		p2grade = rs("P2_UserLevel")
		p2phone = rs("P2_UserPhone")

		p2t1 = rs("P2_TeamNm")
		p2t2 = rs("P2_TeamNm2")
		p2sex = rs("P2_SEX")
		p1rpoint = rs("P1_rpoint")
		p2rpoint = rs("P2_rpoint")

		If Sex2 = "Man" Then
			Sex2 = "남"
		else
			Sex2 = "여"
		End if

		p1 = "<span style='color:orange'>" & p1nm & "</span> (" & p1t1& ", " & p1t2 & ") " & sex1
		p2 = "<span style='color:orange'>" & p2nm & "</span> (" & p2t1& ", " & p2t2 & ") " & sex2

		player = p1 & "&nbsp;&nbsp;&nbsp;" & p2
		teamgbnm = rs("TeamGbNm")

	End if

	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/tennisAdmin/gameinfoPlayerForm.asp" -->