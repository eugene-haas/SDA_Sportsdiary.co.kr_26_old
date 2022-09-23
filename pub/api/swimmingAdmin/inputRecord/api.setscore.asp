<%
'#############################################
'대회기록저장
'#############################################
	
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 
		idx = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "LR") = "ok" Then  '소문자
		lr = oJSONoutput.LR
	End if	
	If hasown(oJSONoutput, "ID") = "ok" Then 
		ID = oJSONoutput.ID
	End if	

	If hasown(oJSONoutput, "INVAL") = "ok" Then 
		inval = oJSONoutput.INVAL
	End if	

	
	Set db = new clsDBHelper 

	SQL = "update SD_gameMember_vs Set "&ID&"  = '"&inval&"'  where idx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>