<%
'#############################################


'#############################################
	'request
	seq = oJSONoutput.IDX

	If hasown(oJSONoutput, "OKVAL") = "ok" then
		okval = oJSONoutput.OKVAL
	Else
		okval = ""
	End If

	


	Set db = new clsDBHelper




	Select Case CDbl(CMD)
	Case CMD_WORKOK
		SQL = "update sd_TennisBoard set workok  = "&okval&" where seq = " & seq
		Call db.execSQLRs(SQL , null, ConStr)
	Case CMD_DELOK
		SQL = "delete from sd_TennisBoard where seq = " & seq
		Call db.execSQLRs(SQL , null, ConStr)
	End select

	Set rs = Nothing
	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>