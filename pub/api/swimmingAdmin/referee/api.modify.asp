<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	strFieldName = " SEQ,CDA,CDC,name,sex,teamnm,grade,team,userphone "

	strSql = "SELECT top 1  " & strFieldName &  "  FROM tblReferee  WHERE seq = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		
	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
								e_idx = arrR(0, ari)
								e_cda = arrR(1, ari)
								e_cdc = arrR(2, ari)
								e_name = arrR(3, ari)
								e_sex = arrR(4, ari)
								e_teamnm = arrR(5, ari)
								e_grade = arrR(6, ari)
								e_team = arrR(7, ari)
								e_userphone = arrR(8, ari)
		Next
	End If
	
	%><!-- #include virtual = "/pub/html/swimming/refereeform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
