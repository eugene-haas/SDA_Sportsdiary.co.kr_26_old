<%
'#############################################
'심사관리 상세 (종목, 클레스, 안내 값으로 동일 값이 있는지 검색 해서 (있다면 수정상태로 호출, 없다면 생성후 수정상태로 호출)
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "TITLE") = "ok" then
		testtitle= oJSONoutput.TITLE
	End If
	If hasown(oJSONoutput, "TM") = "ok" then
		tm= oJSONoutput.TM
	End If
	If hasown(oJSONoutput, "TESTTYPE") = "ok" Then '운동과목 1, 종합관찰 2 , 경로위반 3
		testtype= oJSONoutput.TESTTYPE
	End If

	Set db = new clsDBHelper 
	'심사지명 업데이트 
	SQL = "update tblTeamGbInfoDetail set title = '"&testtitle&"' ,timestr = '"&tm&"' where idx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("e_idx", idx )
	Call oJSONoutput.Set("testtype", testtype)
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
