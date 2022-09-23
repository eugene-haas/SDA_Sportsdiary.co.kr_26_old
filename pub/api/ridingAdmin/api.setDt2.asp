<%
'#############################################
'체전에서 2.1 2.2 에 2라운드 날짜와 시간을 설정한다.
'#############################################

	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 
		idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "DTVAL") = "ok" Then 
		dtval2= oJSONoutput.DTVAL
	End If

	Set db = new clsDBHelper 



		SQL = "update tblRGameLevel Set gameday2 = '"& dtval2 &"' where RGameLevelidx = " & idx
		Call db.execSQLRs(SQL , null, ConStr)

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
