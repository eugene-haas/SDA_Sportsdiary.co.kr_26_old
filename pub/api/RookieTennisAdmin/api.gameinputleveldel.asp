<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.IDX
	Set db = new clsDBHelper

	strSql = "update  tblRGameLevel Set   DelYN = 'Y' where RGameLevelidx = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>


<!-- #include virtual = "/pub/html/RookietennisAdmin/gameinfolevelform.asp" -->
