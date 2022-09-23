<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	reqidx = oJSONoutput.IDX


	Set db = new clsDBHelper

	strFieldName = " GameTitleIDX,GameTitleName,GameS,GameE,GameYear,GameArea,  ViewYN,stateNo,ViewState, hostname,subjectnm,afternm,titleCode,titleGrade,gameNa,kgame,gameTypeE,gameTypeA,gameTypeL,gameTypeP,gameTypeG   ,vacReturnYN "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql &  "  FROM sd_TennisTitle  "
	strSql = strSql &  " WHERE GameTitleIDX = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then
		e_idx = rs(0)
		e_GameTitleName = rs("GameTitleName")
		e_GameS = rs("GameS")
		e_GameE = rs("GameE")
		e_GameArea = rs("GameArea")
		e_ViewYN = rs("ViewYN")
		e_MatchYN = rs("stateNo")
		e_ViewState = rs("ViewState")
		e_hostname = rs("hostname")
		e_subjectnm = rs("subjectnm") '주관
		e_afternm = rs("afternm") '후원

		e_titlecode = rs("titlecode")
		e_titlegrade = rs("titlegrade")

		e_gameNa = rs("gameNa")
		e_kgame = rs("kgame")
		e_gameTypeE = rs("gameTypeE")
		e_gameTypeA = rs("gameTypeA")
		e_gameTypeL = rs("gameTypeL")
		e_gameTypeP = rs("gameTypeP")
		e_gameTypeG    = rs("gameTypeG")
		e_vacReturnYN = rs("vacReturnYN")
	End if

	%><!-- #include virtual = "/pub/html/riding/gameinfoform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
