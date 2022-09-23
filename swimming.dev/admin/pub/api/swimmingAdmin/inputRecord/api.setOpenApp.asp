<%
'#############################################
'순서에서 오전순서 제거
'#############################################
	'request
	If hasown(oJSONoutput, "LIDX") = "ok" then
		lidx = oJSONoutput.LIDX
	End if
	If hasown(oJSONoutput, "AMPM") = "ok" then
		ampm = oJSONoutput.AMPM
	End if


	Set db = new clsDBHelper

		If ampm = "am" Then
			SQL = "Update tblRGameLevel Set resultopenAMYN = case when resultopenAMYN = 'N' then 'Y' else 'N' end where RGameLevelidx = " & lidx
			Call db.execSQLRs(SQL , null, ConStr) 	
		Else
			SQL = "Update tblRGameLevel Set resultopenPMYN = case when resultopenPMYN = 'N' then 'Y' else 'N' end where RGameLevelidx = " & lidx
			Call db.execSQLRs(SQL , null, ConStr) 	
		End if


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


