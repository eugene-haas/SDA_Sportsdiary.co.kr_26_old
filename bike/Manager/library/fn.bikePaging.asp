
<%
Sub bikeAdminPaging (ByVal total_page, ByVal block_size, ByVal page, ByVal function_name, ByVal packet, ByVal url, ByVal listId)
  response.end
	Dim max_page, min_page, i

	If page Mod block_size = 0 Then
		min_page = Int(page / block_size - 1) * block_size   +1
	Else
		min_page = Int(page / block_size) * block_size + 1
	End if

	If (min_page + block_size - 1) > total_page Then
		max_page = total_page
	Else
		max_page = min_page + block_size - 1
	End If

	Response.Write "<ul class='pagination'>" & vbcrlf

	If min_page > block_size Then
		Response.Write "<li class=""prev""><a href='javascript:" & function_name & "("&packet&", "& min_page-1 &", """& url &""", """& listId &""")'></a></li>" & vbcrlf
	Else
		Response.Write "<li class=""prev""><a href='javascript:alert(""첫 페이지 입니다."");'></a></li>" & vbcrlf
	End if

	For i = min_page To max_page
		If Int(i) = Int(page)  Then
			Response.Write "<li class=""active""><a href=""javascript:;"">" & i & "</a></li>" & vbcrlf
		Else
			Response.Write "<li><a href='javascript:"& function_name &"("&packet&", "& i &", """& url &""", """& listId &""");'>"& i &"</a></li>"& vbcrlf
		End if
	Next

	If max_page < total_page Then
		Response.Write "<li class=""next""><a onclick='"& function_name &"("&packet&", "& max_page + 1 &", """& url &""", """& listId &""")'></a></li>" & vbcrlf
	Else
		Response.Write "<li class=""next""><a onclick='javascript:alert(""마지막 페이지 입니다."");' ></a></li>" & vbcrlf
	End If

	Response.Write "</ul>" & vbcrlf
End Sub
%>
