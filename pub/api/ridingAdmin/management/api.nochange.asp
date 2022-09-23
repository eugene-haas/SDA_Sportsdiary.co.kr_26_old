<%
'#############################################

'순서변경

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "IDXS1") = "ok" Then '바뀔아이
		idxs1= oJSONoutput.IDXS1
	End If
	If hasown(oJSONoutput, "INPUT") = "ok" then
		input= htmlEncode(oJSONoutput.INPUT)
	End If
	If hasown(oJSONoutput, "TESTTYPE") = "ok" Then '운동과목 1, 종합관찰 2 , 경로위반 3
		testtype= oJSONoutput.TESTTYPE
	End If

	Set db = new clsDBHelper 
	
	SQL = "select orderno from tblTeamGbInfoDetail_s1 where idxs1 = " & idxs1
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	
	orderno = rs(0) '바뀔아이의 원래 순서번호

	'기존아이에 값 바꾸고
	SQL = "Update tblTeamGbInfoDetail_s1 Set orderno  = '"& orderno &"' where idx = " & idx & " and orderno = '"&input&"' " 
	Call db.execSQLRs(SQL , null, ConStr)

	'나 바꾸고
	SQL = "Update tblTeamGbInfoDetail_s1 Set orderno  = '"& input &"' where idxs1 = " & idxs1
	Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("e_idx", idx )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
