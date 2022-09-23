<%
'#############################################

'실행날짜 선택 플레그 변경

'#############################################
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "FIDX") = "ok" Then
		fidx = oJSONoutput.FIDX
	End If

	Set db = new clsDBHelper

	'기존내용 업데이트 N
	SQL = "update sd_gameStartAMPM set selectflag= 'N' where tidx = " & tidx
	Call db.execSQLRs(SQL , null, ConStr)

	SQL = "update sd_gameStartAMPM set selectflag= 'Y' where idx = " & fidx
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>