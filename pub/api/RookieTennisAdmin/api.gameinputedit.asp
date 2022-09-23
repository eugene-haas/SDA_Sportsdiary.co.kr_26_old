<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.IDX


	Set db = new clsDBHelper

	strSql = "SELECT top 1  GameTitleName,GameS,GameE, GameArea,EnterType,GameRcvDateS,GameRcvDateE,ViewYN,stateNo,ViewState,cfg,hostname,titlecode,titlegrade,gameprize  "
	strSql = strSql &  "  FROM sd_TennisTitle  "
	strSql = strSql &  " WHERE GameTitleIDX = " & idx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then
		GameTitleName = rs("GameTitleName")
		GameS = rs("GameS")
		GameE = rs("GameE")
		GameArea = rs("GameArea")
		EnterType = rs("EnterType")
		GameRcvDateS = rs("GameRcvDateS")
		GameRcvDateE = rs("GameRcvDateE")
		ViewYN = rs("ViewYN")
		MatchYN = rs("stateNo")
		ViewState = rs("ViewState")
		hostname = rs("hostname")
		titlecode = rs("titlecode")
		titlegrade = rs("titlegrade")
		gameprize = rs("gameprize")

		cfg = rs("cfg")
		tie = Left(cfg,1)
		duc = Mid(cfg,2,1)
	End if


	'대회주최
	SQL = "Select hostname from tblGameHost where SportsGb = 'tennis' and DelYN = 'N' "
	Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rst.EOF Then 
		arrRS = rst.GetRows()
	End if

	'대회그룹/등급
	SQL = "Select titleCode,titleGrade,hostTitle,idx from sd_TennisTitleCode where  DelYN = 'N' "
	Set rsg = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rsg.EOF Then 
		arrRSG = rsg.GetRows()
	End If
	
	'사은품
	SQL = "Select name from sd_gamePrize where gubun = 1  and delYN = 'N'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrG = rs.GetRows()
	End If


	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/RookietennisAdmin/gameinfoform.asp" -->