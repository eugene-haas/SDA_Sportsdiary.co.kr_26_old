<%
'#############################################
'시간변경
'#############################################


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



'객체에 객체 
Function jsonTors(rs)
	Dim rsObj, subObj, fieldarr, arr

	Set rsObj = JSON.Parse("{}")
	Set subObj = JSON.Parse("{}")

	ReDim fieldarr(Rs.Fields.Count-1)
	For i = 0 To Rs.Fields.Count - 1
		fieldarr(i) = Rs.Fields(i).name
	Next

	If Not rs.EOF Then
		arr = rs.GetRows()

		If IsArray(arr) Then
			For ar = LBound(arr, 2) To UBound(arr, 2)

				For c = LBound(arr, 1) To UBound(arr, 1)
					Call subObj.Set( fieldarr(c), arr(c, ar) )
				Next

				Call rsObj.Set( ar ,  subObj)
			Next
		End if

		jsonTors = JSON.stringify(rsObj)

	Else
		jsontors = JSON.stringify(rsObj)
	End if

End Function


'###########################################



Set db = new clsDBHelper

	'request

	If hasown(oJSONoutput, "CNT") = "ok" then
		cnt= oJSONoutput.CNT
	End If
	If hasown(oJSONoutput, "LINECNT") = "ok" then
		linecnt= oJSONoutput.LINECNT
	End If

	If hasown(oJSONoutput, "Q") = "ok" then
		SQL= oJSONoutput.Q
		'첫번째 select 만 치환 해야한다. 
		firstselectstart = InStr(LCase(SQL) , "select") 
		Q1 = 	Left(SQL, firstselectstart + 6)  & " top " & linecnt & " "
		Q2 = mid(SQL, firstselectstart + 6) 

		SQL = Q1 & Q2
	End If

	n = 0
	For i = 1 To cnt
		If hasown(oJSONoutput, "mx_"&n ) = "ok" then

			Select Case n
			Case 0 : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_0)
			Case 1 : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_1)
			Case 2 : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_2)
			Case 3 : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_3)
			Case 4  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_4)
			Case 5  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_5)
			Case 6  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_6)
			Case 7  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_7)
			Case 8  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_8)
			Case 9  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_9)
			Case 10  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_10)
			Case 11  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_11)
			Case 12  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_12)
			Case 13  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_13)
			Case 14  : SQL = Replace(SQL , "mx_"&n , oJSONoutput.mx_14)
			End Select 

		
		End If
	n = n + 1
	Next 

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'reqJsonStr = jsonTors(rs)
	reqJsonStr = jsonTors_arr(rs)




	'Response.ContentType = "application/json"
	
	Call oJSONoutput.Set("reqjson", reqJsonStr )	
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


'Call rsdrow(rs)
'Response.write SQL & "--"

db.Dispose
Set db = Nothing
%>
