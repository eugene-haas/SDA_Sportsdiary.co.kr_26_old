<%
'#############################################

'순서항목추가.

'#############################################
	'request
	If hasown(oJSONoutput, "BOXNO") = "ok" then
		boxno= oJSONoutput.BOXNO
	End If
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "INPUT") = "ok" then
		input= htmlEncode(oJSONoutput.INPUT)
	End If

	Set db = new clsDBHelper 

	Select Case boxno
	Case "1" '과목 1번값
		SQL = "Update tblTeamGbInfoDetail_s2 Set ktest = '"&input&"' where idxs2 = " & idx
		Call db.execSQLRs(SQL , null, ConStr)
	Case "2"
		SQL = "Update tblTeamGbInfoDetail_s2 Set etest = '"&input&"' where idxs2 = " & idx
		Call db.execSQLRs(SQL , null, ConStr)
	Case "3"
		SQL = "Update tblTeamGbInfoDetail_s1 Set eidear = '"&input&"' where idxs1 = " & idx
		Call db.execSQLRs(SQL , null, ConStr)
	Case "4"
		SQL = "Update tblTeamGbInfoDetail_s1 Set kidear = '"&input&"' where idxs1 = " & idx
		Call db.execSQLRs(SQL , null, ConStr)

	Case "5"
		SQL = "Update tblTeamGbInfoDetail_s1 Set maxval = '"&input&"' where idxs1 = " & idx
		Call db.execSQLRs(SQL , null, ConStr)

	Case "6"
		SQL = "Update tblTeamGbInfoDetail_s1 Set gesoo = '"&input&"' where idxs1 = " & idx
		Call db.execSQLRs(SQL , null, ConStr)

	Case "7" 's2순서
		SQL = "Update tblTeamGbInfoDetail_s2 Set orderstr = '"&input&"' where idxs2 = " & idx
		Call db.execSQLRs(SQL , null, ConStr)
	End Select





  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
