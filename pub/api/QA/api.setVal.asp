<%
'#############################################

'대회생성저장

'#############################################
	'request
	If hasown(oJSONoutput, "DOMID") = "ok" then
		domid = oJSONoutput.DOMID
	End if
	If hasown(oJSONoutput, "CLUMN") = "ok" then
		clumn = oJSONoutput.CLUMN
	End if
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "INVAL") = "ok" then
		inval = Replace(oJSONoutput.INVAL,"'", "''")
	End if	



	Set db = new clsDBHelper 

		SQL = "update  tblqa set "&clumn&"  = '"&inval&"' where idx = " & idx
		Call db.execSQLRs(SQL , null, ConStr)
		'Response.write sql

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>