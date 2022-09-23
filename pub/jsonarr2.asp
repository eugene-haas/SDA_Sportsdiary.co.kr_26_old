<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>Using iframe - Launch App with page loading</title>
<%
'	  <link href="http://img.sportsdiary.co.kr/lib/jquery/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
'	  <link href="http://img.sportsdiary.co.kr/lib/bootstrap/bootstrap.min.css" rel="stylesheet" media="screen">
'	  <link href="http://img.sportsdiary.co.kr/Manager/import_ri.css" rel="stylesheet">
%>
	 <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-3.1.1.min.js"></script>


</head>
<body>


<%

Function jsonTors_arr(rs)
	Dim rsObj,subObj, fieldarr, i, arr, mainObj


	Set mainObj = jsObject()

	ReDim rsObj(rs.RecordCount - 1)
	ReDim fieldarr(Rs.Fields.Count-1)
	For i = 0 To Rs.Fields.Count - 1
		fieldarr(i) = Rs.Fields(i).name
	Next

	If Not rs.EOF Then
		arr = rs.GetRows()

		If IsArray(arr) Then
			For ar = LBound(arr, 2) To UBound(arr, 2)

				Set subObj = jsObject()
				For c = LBound(arr, 1) To UBound(arr, 1)
					subObj(fieldarr(c)) = arr(c, ar)
				Next
				Set rsObj(ar) = subObj
			Next
		End if

		jsonTors_arr = toJSON(rsObj)
	Else
		jsonTors_arr = toJSON(rsObj)
	End if
End Function



	Set db = new clsDBHelper

	SQL = "Select idx,nm,akind from sd_arrTest"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




Response.write jsonTors_arr(rs)

'
'
'
'	If Not rs.EOF Then
'		rscnt = rs.RecordCount
'		arrRS = rs.GetRows()
'
'	End If
'	rs.close	
'
'	SQL = "Select akind, count(akind) as cnt from sd_arrTest group by akind order by cnt desc"
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rs.EOF Then
'		arrK = rs.GetRows()
'	End If
%>

</body>
</html>