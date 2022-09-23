<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	strFieldName = " SEQ,CDA,CDC,title,CODE1,CODE2,CODE3,CODE4,codename "

	strSql = "SELECT top 1  " & strFieldName &  "  FROM tblGameCode  WHERE seq = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		
	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
								e_idx = arrR(0, ari)
								e_cda = arrR(1, ari)
								e_cdc = arrR(2, ari)
								e_title = arrR(3, ari)
								e_code1 = arrR(4, ari)
								e_code2 = arrR(5, ari)
								e_code3 = arrR(6, ari)
								e_code4 = arrR(7, ari)
								e_codename = arrR(8,ari)
'								e_code5 = arrR(9, ari)
'								e_code6 = arrR(10, ari)
'								e_code7 = arrR(11, ari)
'								e_code8 = arrR(12, ari)


		Next
	End If
	

	Select Case e_cda
	case "E2"
	%><!-- #include virtual = "/pub/html/swimming/DcodeForm.asp" --><%
	Case "F2"
	%><!-- #include virtual = "/pub/html/swimming/F2codeForm.asp" --><%
	End Select 

	db.Dispose
	Set db = Nothing
%>
