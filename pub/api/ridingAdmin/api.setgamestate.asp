<%
'#############################################

'참가자들 상태변경

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
	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx= oJSONoutput.IDX 
	End If
	If hasown(oJSONoutput, "RIDX") = "ok" then
		r_ridx= oJSONoutput.RIDX
	End If
	If hasown(oJSONoutput, "STNO") = "ok" then
		r_stno= oJSONoutput.STNO
	End If

	Select Case CStr(r_stno)
	Case "1" : nextstno = 2
	Case "2" : nextstno = 3
	Case "3" : nextstno = 1
	End Select


	'업데이트  (보낸사람 기준으로 다음 상태로 업데이트)
	SQL = "Update SD_tennisMember Set gamest = "&nextstno&" where gameMemberIDX = " & r_idx
	Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson



'필요값
'tidx  = r_tidx
'find_gbidx  = r_gbidx
%><%'<!-- #include virtual = "/pub/html/riding/judgelist.asp" -->%><%


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>