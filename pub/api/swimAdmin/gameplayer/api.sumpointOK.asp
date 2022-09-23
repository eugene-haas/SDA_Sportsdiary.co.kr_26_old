<%
'#############################################
'동일 이름의 포인트 정보를 클릭한 아이디로 모두 합친다.
'#############################################
	'request
	If hasown(oJSONoutput, "PIDX") = "ok" then
		pidx = oJSONoutput.PIDX
	End If
	If hasown(oJSONoutput, "PNAME") = "ok" then
		pname = oJSONoutput.PNAME
	End If

	If hasown(oJSONoutput, "CHANGELIST") = "ok" then
		changelist = oJSONoutput.CHANGELIST
	End If

	Set db = new clsDBHelper


'Response.write changelist & "<br>"

	'동명인이 있는지 검색
	changepidxs = Split(changelist,"|")



	For i = 0 To ubound(changepidxs)
		Select Case  i
		Case 0
			w_pidx = ""
		Case 1
			w_pidx = changepidxs(i)
		Case Else
			w_pidx = w_pidx & "," & changepidxs(i)
		End Select
	next


	SQL = "update sd_TennisRPoint_log Set PlayerIDX = "&pidx&" where PlayerIDX in (" & w_pidx & ")"

'Response.write sql
'Response.end
	Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 3103 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>