<!-- #include virtual = "/pub/header.RookieTennis.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<%

'Sub getRowsDrow(arr)
'
'		For i = 0 To Rs.Fields.Count - 1
'			response.write "<th>"& Rs.Fields(i).name &"</th>"
'		Next

'		Response.write "</thead>"
'	
'	Response.write "<table border=1>"
'	If IsArray(arr) Then
'		For ar = LBound(arr, 2) To UBound(arr, 2) 
'			Response.write "<tr>"
'			For c = LBound(arr, 1) To UBound(arr, 1) 
'				Response.write "<td>" & arr(c, ar) & "</td>"
'			Next
'			Response.write "</tr>"			
'		Next
'	End if
'	Response.write "</table>"
'End Sub


Set rsObj = JSON.Parse("{}")
Set subObj = JSON.Parse("{}")

	Set db = new clsDBHelper
	SQL ="SELECT playeridx,username FROM tblplayer "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	ReDim fieldarr(Rs.Fields.Count-1)
	For i = 0 To Rs.Fields.Count - 1
		fieldarr(i) = Rs.Fields(i).name
	Next

	If Not rs.EOF Then 
		arr = rs.GetRows()
	End if

	If IsArray(arr) Then
		For ar = LBound(arr, 2) To UBound(arr, 2) 

			For c = LBound(arr, 1) To UBound(arr, 1) 
				'Call subObj.Set( c, arr(c, ar) )
				Call subObj.Set( fieldarr(c), arr(c, ar) )
			Next

			Call rsObj.Set( ar ,  subObj)
		Next
	End if

		arrStr = JSON.stringify(rsObj)
		Response.write arrStr


Response.end

	If Not rs.EOF Then 
		arr = rs.GetRows()

		arrStr = JSON.stringify(rsObj)
		Response.write arrStr
	End If



	Response.End 


'REQ  = "{""CMD"":20003,""IDX"":"""",""S1"":""tn001001"",""S2"":""201"",""S3"":""20101002"",""TT"":""1"",""SIDX"":0,""Round_s"":""""}"
'Set oJSON = JSON.Parse(REQ)
'Call oJSON.Set("arr", array(1,2,3,4,5) )
'
'Dim arrA(10)
'
'
'
'Call oJSON.Set("arr", JSON.Parse("{}") )
''Response.write oJSON.arr
'
'Call oJSON.arr.Set("arr", 123 )
'Response.write oJSON.arr.arr


'Call oJSON.Set("arr", JSON.Parse("[0,1,0,1]") )
'Call oJSON.arr.Set("4" ,6  )

'Response.write oJSON.arr



Set oJSON = JSON.Parse("{}")
Call oJSON.Set("arrA", array(1,2,3,4,5) )
Call oJSON.Set("objA", JSON.Parse("{}") )
Set obj = JSON.Parse("{}")
Call obj.Set("child","객체안에객체")
Call oJSON.Set("objB",obj)

strjson = JSON.stringify(oJSON)

'전체 json string
Response.write strjson

Response.write "<br>"

'객체안에 배열 불러올때
arr =  JSON.Parse(oJSON.arrA)
Response.write arr

'Response.write oJSON.arr

'Call oJSON.arr.Set("arr", 123 )
'Response.write oJSON.arr.arr


'Call oJSON.Set("arr", JSON.Parse("[0,1,0,1]") )
'Call oJSON.arr.Set("4" ,6  )



%>