<%
'#############################################

'순서항목추가.

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "TESTTYPE") = "ok" Then '운동과목 1, 종합관찰 2 , 경로위반 3
		testtype= oJSONoutput.TESTTYPE
	End If
	If hasown(oJSONoutput, "NO") = "ok" Then '운동과목 1, 종합관찰 2 , 경로위반 3
		no= oJSONoutput.NO
	End If

	Set db = new clsDBHelper 

		'순서 항목 1개 (운동과목)############
		SQL = "SET NOCOUNT ON INSERT INTO tblTeamGbInfoDetail_s1 ( idx,testtype,orderno ) VALUES ( "&idx&","&testtype&","&no&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idxs1 = rs(0)		

		If testtype <> "3" then
			'과목 항목 1개 
			SQL = "SET NOCOUNT ON  INSERT INTO tblTeamGbInfoDetail_s2 ( idxs1, orderno ) VALUES ( "&idxs1&" ,1 )  SELECT @@IDENTITY"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			idxs2 = rs(0)
		End if


  	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("e_idx", idx )
	Call oJSONoutput.Set("e_idxs1", idxs1 )
	Call oJSONoutput.Set("e_idxs2", idxs2 )
	Call oJSONoutput.Set("nos1", "1" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
