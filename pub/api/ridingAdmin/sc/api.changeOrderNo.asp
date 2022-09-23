<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then
		idx = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "CNGVAL") = "ok" Then
		cngval = oJSONoutput.CNGVAL
		If isnumeric(cngval) = False Then
			Call oJSONoutput.Set("result", 5 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	End If
	
	
	Set db = new clsDBHelper

	'startType 시작이 예선인지 본선인지 (1, 3)
	fld = " orderno,tidx,gbidx  " 
	SQL = "select "&fld&" from SD_gameMember_vs where idx  = '"&idx&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrR = rs.GetRows()
		no = arrR(0,0)
		tidx  = arrR(1,0)
		gbidx  = arrR(2,0)


		strwhere = " delyn = 'N' and tidx = "&tidx&" and gbidx = '"&gbidx&"'  "
		SQL = "select max(orderno) from SD_gameMember_vs where " & strwhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If CDbl(cngval) > CDbl(rs(0))  Then 
			Call oJSONoutput.Set("result", 5 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if

		SQL = " update  SD_gameMember_vs set orderno = "&no&"  where " & strwhere & " and orderno = "&cngval&" "
		SQL = SQL & " update  SD_gameMember_vs set orderno = "&cngval&"  where idx = " & idx 
		Call db.execSQLRs(SQL , null, ConStr)
	End if
 
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>