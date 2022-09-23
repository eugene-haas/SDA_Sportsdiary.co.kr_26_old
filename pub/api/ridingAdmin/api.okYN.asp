<%
	'통합 인원 조정확정 

	'request 처리##############
	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx = oJSONoutput.IDX
		r_YN = oJSONoutput.YN

		Set db = new clsDBHelper
		'SQL = "update tblRGameLevel Set okYN = case when okYN = 'N' then 'Y' else 'N' end  where RGameLevelidx = " & r_idx
		SQL = "update tblRGameLevel Set okYN = '"&r_YN&"'  where RGameLevelidx = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)

		db.Dispose
		Set db = Nothing
	End if

	
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>