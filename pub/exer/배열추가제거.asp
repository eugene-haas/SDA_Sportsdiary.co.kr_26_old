<!-- #include virtual = "/pub/header.tennis.asp" -->






<%
	'#####################
	Function arrfinddel(arrstr , delstr)
		Dim n, i ,newstr, arr
		n = 0
		arr = Split(arrstr,",")
		For i = 0 To ubound(arr)
			If CStr(arr(i)) <> CStr(delstr) Then
				If n = 0 then
					newstr = arr(i)
					n = n + 1
				Else
				newstr = newstr & "," & arr(i)
					n = n + 1
				End if
			End if
		Next
		arrfinddel = newstr
	End Function
	'#####################	




	vv = arrfinddel("123,234,2321,1,2,3,4" , "4")

	Response.write vv




%>