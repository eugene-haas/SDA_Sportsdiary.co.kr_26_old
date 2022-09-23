<%
'#############################################


'#############################################
	'request
	idx = oJSONoutput.IDX
	rankno = oJSONoutput.RANK

	Set db = new clsDBHelper

	If rankno = "1"  Or rankno = "2" Or rankno = "4" Or  rankno = "8" Or  rankno = "16" Or  rankno = "32" then

		SQL = "Select rankno from sd_TennisRPoint_log  where idx = " & idx & " and rankno = " & rankno
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		

		If rs.eof then
			strSql = "update  sd_TennisRPoint_log set rankno = "&rankno&"  where idx = " & idx
			Call db.execSQLRs(strSQL , null, ConStr)
		Else
			Call oJSONoutput.Set("result", "1003" ) '동일값보냄
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.End
		End if
	Else
		Call oJSONoutput.Set("result", "1003" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End
	End if

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
