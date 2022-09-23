<%
'#############################################
'불러오기
'#############################################


Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "IDX" ) = "ok" then
		idx =  oJSONoutput.IDX
	End if
	

	strWhere = " seq = " & idx
	strFieldName = " seq,dbcode,inputval,inputq,outputval,outputcnt,title,useurl "
	SQL = "Select top 1 " & strFieldName & " from tblJSON where " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			e_a1 = arrR(0, ari) 'idx
			e_a2 = arrR(1, ari) 'dbcode
			e_a3 = Replace(arrR(2, ari),"""","&quot;") 'inval
			e_a4 = arrR(3, ari) 'inquery
			e_a5 = arrR(4, ari) 'outval
			e_a6 = arrR(5, ari) 'outcnt
			e_a7 = Replace(arrR(6, ari),"""","&quot;") 'title
			e_a8 = arrR(7, ari) 'useurl
		Next
	End if

		sortd = " o.name asc"
		SQL = "SELECT o.name , (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY " & sortd
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arr = rs.GetRows()
		End if



	%><!-- #include virtual = "/pub/html/adm/jsonForm.asp" --><%

db.Dispose
Set db = Nothing
%>