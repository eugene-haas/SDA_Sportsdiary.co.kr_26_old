<%
'#############################################

'심사관리 상세 (종목, 클레스, 안내 값으로 동일 값이 있는지 검색 해서 (있다면 수정상태로 호출, 없다면 생성후 수정상태로 호출)

'#############################################
	'request
	If hasown(oJSONoutput, "Y") = "ok" then
		useyear= oJSONoutput.Y
	End If
	If hasown(oJSONoutput, "GB") = "ok" then
		gb= oJSONoutput.GB
	End If
	If hasown(oJSONoutput, "GBNM") = "ok" then
		gbnm= oJSONoutput.GBNM
	End If
	If hasown(oJSONoutput, "RCLASS") = "ok" then
		rclass = oJSONoutput.RCLASS
	End If
	If hasown(oJSONoutput, "RCLASSHELP") = "ok" then
		rclasshelp= oJSONoutput.RCLASSHELP
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
	'규정관리가 수정되었을때 같이수정되어야한다.
	strwhere = " delYN = 'N' and useyear = '"&useyear&"' and teamgb = '"&gb&"' and ridingclass = '"&rclass&"'  and ridingclasshelp = '"&rclasshelp&"' "
	SQL = "Select idx from tblTeamGbInfoDetail where " & strwhere
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

	If rs.eof Then
		'생성
		insertfield = " useyear,TeamGb,TeamGbNm,ridingclass,ridingclasshelp,title,timestr"
		insertvalue = " '"&useyear&"','"&gb&"','"&gbnm&"','"&rclass&"','"&rclasshelp&"','"&testtitle&"','"&timestr&"' "

		SQL = "SET NOCOUNT ON INSERT INTO tblTeamGbInfoDetail ( "&insertfield&" ) VALUES ( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		'순서 항목 1개 (운동과목)############
		SQL = "SET NOCOUNT ON INSERT INTO tblTeamGbInfoDetail_s1 ( idx,testtype ) VALUES ( "&idx&",1 ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idxs1 = rs(0)		
		'과목 항목 1개 
		SQL = "INSERT INTO tblTeamGbInfoDetail_s2 ( idxs1,orderno ) VALUES ( "&idxs1&",1 ) "
		Call db.execSQLRs(SQL , null, ConStr)

		'(종합관찰)####################
		SQL = "SET NOCOUNT ON INSERT INTO tblTeamGbInfoDetail_s1 ( idx,testtype ) VALUES ( "&idx&",2 ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idxs1 = rs(0)		
		'과목 항목 1개 
		SQL = "INSERT INTO tblTeamGbInfoDetail_s2 ( idxs1,orderno ) VALUES ( "&idxs1&", 1 ) "
		Call db.execSQLRs(SQL , null, ConStr)

		'(경로위반)####################
		SQL = "INSERT INTO tblTeamGbInfoDetail_s1 ( idx,testtype ) VALUES ( "&idx&",3 ) "
		Call db.execSQLRs(SQL , null, ConStr)


	Else
		'심사지명 업데이트 
		idx = rs(0)
		'SQL = "update tblTeamGbInfoDetail set title = '' ,timestr = '' where idx = " & idx
		'Call db.execSQLRs(SQL , null, ConStr)
	End if

  	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("e_idx", idx )
	Call oJSONoutput.Set("testtype", testtype)
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
