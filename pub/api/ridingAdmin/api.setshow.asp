<%
'#############################################
'기권 실격저장
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End If

	If hasown(oJSONoutput, "SHOW") = "ok" then
		r_show= oJSONoutput.SHOW
	End If


	'지운거 혹 살릴까봐 delYN 된것도 모두 변경
	SQL = "Update tblRGameLevel Set judgeshowYN = '"& r_show &"'   where gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"' " 
	Call db.execSQLRs(SQL , null, ConStr)

  
  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
