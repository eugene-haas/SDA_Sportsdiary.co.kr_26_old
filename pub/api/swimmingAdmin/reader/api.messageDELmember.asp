<%
'#############################################
'문자전송 개별 맴버 삭제
'#############################################

	'request
	If hasown(oJSONoutput, "PIDX") = "ok" Then
		pidx = oJSONoutput.get("PIDX")
	End If

	Set db = new clsDBHelper


	'공통 ###########################################
      SQL = " update tblreader set chkmsg = 'N' where idx = " & pidx
      Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
