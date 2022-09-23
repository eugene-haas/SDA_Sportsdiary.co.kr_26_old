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

	If delyn = "W" Then  
	
		strSql = "update  tblPlayer Set   DelYN = 'N' where playeridx = " & e_idx
		Call db.execSQLRs(strSQL , null, ConStr)

		SQL = "update tblWebRegLog Set state = 1 where gubun= 2 and regseq = " & e_idx
		Call db.execSQLRs(SQL , null, ConStr)
	
	Else

		strSql = "update  tblPlayer Set   DelYN = 'W' where playeridx = " & e_idx
		Call db.execSQLRs(strSQL , null, ConStr)

		SQL = "update tblWebRegLog Set state = 0 where gubun= 2 and regseq = " & e_idx
		Call db.execSQLRs(SQL , null, ConStr)

	End if

	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>