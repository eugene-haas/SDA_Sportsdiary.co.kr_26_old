<%
'#############################################
'temp 데이터를 request 테이블에 밀어넣는다.
'#############################################

	'request
	If hasown(oJSONoutput, "PIDX") = "ok" Then
		pidx = oJSONoutput.get("PIDX")
	End If

	Set db = new clsDBHelper


	'공통 ###########################################
   SQL = " update tblreader set chkmsg = 'Y' where idx = " & pidx
   Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing


%>
