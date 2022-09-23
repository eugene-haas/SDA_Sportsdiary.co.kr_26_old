<%
'#############################################

'순서항목추가.

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "IDXS1") = "ok" then
		idxs1= oJSONoutput.IDXS1
	End If
	If hasown(oJSONoutput, "IDXS2") = "ok" then
		idxs2= oJSONoutput.IDXS2
	End If

	If hasown(oJSONoutput, "TESTTYPE") = "ok" Then '운동과목 1, 종합관찰 2 , 경로위반 3
		testtype= oJSONoutput.TESTTYPE
	End If

	Set db = new clsDBHelper 

	If testtype <> "3" then
		'과목 항목 1개 
		SQL = "Update tblTeamGbInfoDetail_s2 Set DelYN = 'Y' where idxs2 = " & idxs2
		Call db.execSQLRs(SQL , null, ConStr)
	
		'전체 순서번호 다시 업데이트
		'RANK   ROW_NUMBER
		Selecttbl = "( SELECT orderno, ROW_NUMBER() OVER (Order By orderno asc ) AS RowNum FROM tblTeamGbInfoDetail_s2 where DelYN = 'N'  and idxs1 = "&idxs1&" ) AS A "
		SQL = "UPDATE A  SET A.orderno = A.RowNum FROM " & selecttbl 
		Call db.execSQLRs(SQL , null, ConStr)		
	
	End if


  	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("e_idx", idx )
	Call oJSONoutput.Set("e_idxs1", idxs1 )
	Call oJSONoutput.Set("e_idxs2", idxs2 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
