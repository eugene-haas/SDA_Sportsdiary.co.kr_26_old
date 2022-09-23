<%
'#############################################
'삭제
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		e_idx = oJSONoutput.IDX
	End if

	Set db = new clsDBHelper

	'참가 신청자가 있는지 여부 확인
	'SQL= "select gametitleidx, gbidx from  tblRGameLevel where  rgamelevelidx = " & e_idx
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	'SQL = "select  GameTitleIDX from tblGameRequest where GameTitleIDX = '"&rs(0)&"' and gbidx = '"&rs(1)&"' and delyn = 'N' "


	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'If Not rs.eof Then
	'	Call oJSONoutput.Set("result", 3)
	'	strjson = JSON.stringify(oJSONoutput)
	'	Response.Write strjson
	'	Response.end
	'End If




	Sql = "update  tblRGameLevel Set DelYN = 'Y' where rgamelevelidx = " & e_idx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


