<%
'#############################################

'#############################################
	'request
	If hasown(oJSONoutput, "SVAL") = "ok" then
		sval= oJSONoutput.SVAL
	End if	

	If hasown(oJSONoutput, "IDXARR") = "ok" then
		Set idxs = oJSONoutput.IDXARR
		idxlen = idxs.length
		'Set this = idxs.Get(0) '배열안에 객체 다시 가져올때
	End if	

	Set db = new clsDBHelper

	'마자막 사용된 상장번호
	SQL = "select max(crapeNo) from sd_tennisMember where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If isnull(rs(0)) = false Then
		lastcrapeNo = rs(0)
		If  CDbl(sval) <= CDbl(lastcrapeNo) Then
			Call oJSONoutput.Set("result", "12" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	End if



	For i = 0 To idxlen -1
		If i = 0 Then
			no = sval
		Else
			no = CDbl(sval) + 1
		End if
		SQL = SQL & " update SD_tennisMember Set crapeNo = '" & no  & "',crapeDate = '"&Date()&"' where gameMemberIDx = " & idxs.Get(i) & " " & vbcrLf
	Next
	Call db.execSQLRs(SQL , null, ConStr)	
	
  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>
