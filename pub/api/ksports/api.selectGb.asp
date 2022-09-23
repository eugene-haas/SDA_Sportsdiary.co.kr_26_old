<%
'######################
'대분류 생성
'######################

	If hasown(oJSONoutput, "GB") = "ok" then
		sgb = oJSONoutput.GB
	End If

	Set db = new clsDBHelper


	SQL = "Select title from K_titleList where delYN = 'N' group by title order by title"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End If

	SQL = "Select tidx,subtitle from K_titleList where delYN = 'N' and title = '"&sgb&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrSub = rs.GetRows()
	End If

	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/ksports/s.ul03.asp" -->