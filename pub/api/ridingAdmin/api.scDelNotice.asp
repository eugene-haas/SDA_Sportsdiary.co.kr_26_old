<%
'#############################################

'일정관리 공지 삭제

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then
		r_idx = oJSONoutput.IDX
	End if



	Set db = new clsDBHelper 
	SQL = "delete from  sd_TennisMember where gamememberIDX = " & r_idx & " and gubun = 100 "
	Call db.execSQLRs(SQL , null, ConStr)

  

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>
