<%
	'------------------------------------------------------------
	' Description
	'	총 페이지수 구하기
	' params total_cnt  : 총 페이지 개수
	' params list_size  : 게시물 노출개수
	'------------------------------------------------------------
	Function totalPage(ByVal total_cnt, ByVal list_size)
		If total_cnt = 0 Then
			totalPage = 1
		ElseIf (total_cnt Mod list_size) = 0 then
			totalPage = Int(total_cnt / list_size)
		Else
			totalPage = int(total_cnt / list_size) + 1
		End If
	End Function


	'------------------------------------------------------------
	' Description
	'	front 페이징 처리
	' params total_page  : 총 페이지 수
	' params block_size  : 페이징 블럭 수
	' params page        : 현재 페이지 번호
	' params page_params : 파라미터 값
	' params list_page   : 리스트 페이지 주소
	'------------------------------------------------------------


	'수영사용
	Sub userPagingSW (ByVal total_page, ByVal block_size, ByVal page, ByVal function_name, ByVal packet)
	Dim max_page, min_page, i

	If page Mod block_size = 0 then
		min_page = Int(page / block_size - 1) * block_size   +1
	Else
		min_page = Int(page / block_size) * block_size + 1
	End if
	If (min_page + block_size - 1) > total_page Then
		max_page = total_page
	Else
		max_page = min_page + block_size - 1
	End If

	If min_page > block_size Then
		%><button class="list-pro__nav__btn" type="button" name="button" onclick="<%=function_name%>(<%=packet%>, <%=min_page-1 %>)"></button><%
		response.write "<li class=""prev""><a href=""javascript:"" onclick='" & function_name & "("&packet&", "& min_page-1 &")'>&lt;</a></li>" & vbcrlf
	Else
		%><button class="list-pro__nav__btn" type="button" name="button" onclick="alert('첫 페이지 입니다.');"></button><%
	End if

	%><ol class="list-pro__nav__list-group"><%
	For i = min_page To max_page
		If Int(i) = Int(page)  Then
			%><li class="list-pro__nav__list-group__list"><a href="javascript:;"><%=i%></a></li><%
		Else
			%><li class="list-pro__nav__list-group__list s_on"><a href="javascript:<%=function_name%>(<%=packet%>,<%=i%>)"><%=i%></a></li><%
		End if
	Next
	%></ol><%

	If max_page < total_page Then
		%><button class="list-pro__nav__btn" type="button" name="button" onclick="<%=function_name%>(<%=packet%>, <%=min_page+1 %>)"></button><%
	Else
		%><button class="list-pro__nav__btn" type="button" name="button" onclick="alert('마지막 페이지 입니다.');"></button><%
	End If

End Sub
%>
