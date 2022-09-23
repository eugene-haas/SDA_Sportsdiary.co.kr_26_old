<%
'#############################################
'
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		e_idx = oJSONoutput.Get("IDX")
	End If

	Set db = new clsDBHelper


	SQL = "select delyn from tblPlayer where playeridx = " & e_idx
	Set rs = db.ExecSQLReturnRS(Sql , null, ConStr)
	delyn = rs(0)

	If delyn = "W" Then  ' > Y
	
		Sql = "update  tblplayer Set delyn = 'N' where playeridx = " & e_idx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "update tblWebRegLog Set state = 1 where gubun= 1 and regseq = " & e_idx
		Call db.execSQLRs(SQL , null, ConStr)
	
	Else

		Sql = "update  tblplayer Set delyn = 'W'  where playeridx = " & e_idx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "update tblWebRegLog Set state = 0 where gubun= 1 and  regseq = " & e_idx '홈페이지용 생성해둔 부분 그냥 사용
		Call db.execSQLRs(SQL , null, ConStr)

	End if

	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>