<%
'#############################################

'#############################################
	'request
	idx = oJSONoutput.IDX

	Set db = new clsDBHelper

	'strSql = "update  tblPlayer Set   DelYN = 'Y' where PlayerIDX = " & idx
	strSql = "delete  tblPlayer where PlayerIDX = " & idx '중복키값으로 삭제후 신규생성이 안됨 그냥 지우자
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>

<!-- #include virtual = "/pub/html/swimAdmin/PlayerForm.asp" -->
