<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper



	strSql = "SELECT top 1  reqID  FROM tblQA  WHERE idx = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		
	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
		e_idx = arrR(0, ari)
		Next
	End If
	
	%><!-- #include virtual = "/pub/html/swimming/QAform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
