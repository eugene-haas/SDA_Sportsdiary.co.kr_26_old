<!DOCTYPE HTML>
<html lang="en">
<head>
<meta charset="utf-8">
</head>
<body>
<%
	'강
	TotalCnt = 16

	intTotalCnt = TotalCnt

	strDepth = ""
	strDepth_prv = ""
	
	Do Until intTotalCnt < 2 
		If TotalCnt = intTotalCnt Then
			strDepth = strDepth & cstr(intTotalCnt / 2) 
			strDepth_prv  = strDepth_prv & cstr(intTotalCnt / 2) 
		Else
			strDepth = cstr(intTotalCnt / 2) & "," & strDepth 
			strDepth_prv = strDepth_prv & "," & cstr(intTotalCnt / 2)
		End If

		intTotalCnt = intTotalCnt / 2
	Loop

	Response.Write strDepth & "<br>"
	Response.Write strDepth_prv

	array_Depth = Split(strDepth,",")
	array_Depth_prv = Split(strDepth_prv,",")

%>
<table border="1">
	<%For i = 1 To CLng(array_Depth(UBound(array_Depth)))%>	
		<tr>
			<td>최승규</td>
			<td>-</td>

			<%For j = 0 To UBound(array_Depth) + 1%>
				
					<%For k = 1 To array_Depth_prv(j + 1)%>
						<td rowspan=""><%=UBound(array_Depth)%>칸</td>
					<%Next%>

			<%Next%>


			<td>-</td>
			<td>상대</td>
		</tr>
	<%Next%>
</table>


</body>
</html>