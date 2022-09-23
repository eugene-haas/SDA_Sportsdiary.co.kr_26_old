<%
'#############################################
'입력저장안하고 창닫음
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End If

	If hasown(oJSONoutput, "PTLOC") = "ok" then
		r_ptloc= oJSONoutput.PTLOC
	End If

	'지점 입력중으로 업데이트 null >> 0 
	SQL = "Update SD_tennisMember Set score_"&r_ptloc&" = null where gamememberidx = " & r_idx
	Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
