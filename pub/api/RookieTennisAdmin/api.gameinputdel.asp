<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.IDX
	Set db = new clsDBHelper

	SQL = "Update tblGameHost Set makegamecnt = makegamecnt - 1 where hostname = (select hostname from sd_TennisTitle where GameTitleIDX = " & idx & ")" 
	Call db.execSQLRs(SQL , null, ConStr)


	strSql = "update  sd_TennisTitle Set   DelYN = 'Y' where GameTitleIDX = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>

<!-- #include virtual = "/pub/html/RookietennisAdmin/gameinfoform.asp" -->
