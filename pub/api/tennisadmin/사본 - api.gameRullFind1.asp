<%
'#############################################

' 대회 정보 코드 생성용 조회

'#############################################
	'request
	tidx = oJSONoutput.FSTR


	Set db = new clsDBHelper


	strTableName = " sd_TennisTitle "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	strFieldName = " GameTitleIDX,gameTitleName   " ',GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,viewState,stateNo
	strSort = "  order by GameTitleIDX desc"
	strWhere = " DelYN = 'N' "'and stateNo = 0"

	SQL = "Select top 30 " & strFieldName & " from " & strTableName & " where " & strWhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRT = rs.GetRows()
	End if
	'=======================================


	strTableName = "  tblRGameLevel as a left join tblLevelInfo as b  ON a.level = b.level and b.DelYN ='N' "
	strFieldName = " a.Level,a.TeamGbNm,b.LevelNm "

	strSort = "  ORDER BY RGameLevelidx Desc"
	strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' "

	SQL = "Select " & strFieldName & " from " & strTableName & " where " & strWhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsDrow(rs)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if

	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/tennisAdmin/gameRullForm.asp" -->
