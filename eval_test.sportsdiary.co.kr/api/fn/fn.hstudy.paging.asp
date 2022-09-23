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
	'	관리자 페이징 처리
	' params total_page  : 총 페이지 수
	' params block_size  : 페이징 블럭 수
	' params page        : 현재 페이지 번호
	' params page_params : 파라미터 값
	' params list_page   : 리스트 페이지 주소
	'------------------------------------------------------------
	Sub adminPaging(ByVal total_page, ByVal block_size, ByVal page, ByVal page_params, ByVal list_page)
		Call adminPagingCustom(total_page, block_size, page, page_params, list_page, "page")
	End Sub


	Sub adminPagingCustom(ByVal total_page, ByVal block_size, ByVal page, ByVal page_params, ByVal list_page, ByVal key_name)
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


		response.write "<ul>"

		If page = 1 Then
			response.write "<li class=""first""><a href=""javascript:;"">맨앞으로</a></li>" & vbcrlf
		Else
			response.write "<li class=""first""><a href=""" & list_page & "?" & key_name & "=1" & page_params & """>맨앞으로</a></li>" & vbcrlf
		End if


		If min_page > block_size Then
			response.write "<li class=""prev""><a href=""" & list_page & "?" & key_name & "="& min_page-1 & page_params & """>이전</a></li>" & vbcrlf
		Else
			response.write "<li class=""prev""><a href=""javascript:;"">이전</a></li>" & vbcrlf
		End if

		For i = min_page To max_page
			If Int(i) = Int(page) Then
				response.write "<li class=""on""><a href=""javascript:;""><strong>" & i & "</strong></a></li>" & vbcrlf
			Else
				response.write "<li><a href="""& list_page & "?" & key_name & "=" & i & page_params & """ >" & i & "</a></li>" & vbcrlf
			End if
		Next

		If max_page < total_page Then
			response.write "<li class=""next""><a href=""" & list_page & "?" & key_name & "="& max_page+1 & page_params & """>다음</a></li>" & vbcrlf
		Else
			response.write "<li class=""next""><a href=""javascript:;"">다음</a></li>" & vbcrlf
		End If

		If Int(page) = Int(total_page) Then
			response.write "<li class=""last""><a href=""javascript:;"">맨뒤로</a></li>" & vbcrlf
		Else
			response.write "<li class=""last""><a href=""" & list_page & "?" & key_name & "=" & total_page & page_params & """>맨뒤로</a></li>" & vbcrlf
		End If

		response.write "</ul>"
	End Sub



















	'------------------------------------------------------------
	' Description
	'	front 페이징 처리
	' params total_page  : 총 페이지 수
	' params block_size  : 페이징 블럭 수
	' params page        : 현재 페이지 번호
	' params page_params : 파라미터 값
	' params list_page   : 리스트 페이지 주소
	'------------------------------------------------------------
	Sub userPaging(ByVal total_page, ByVal block_size, ByVal page, ByVal page_params, ByVal list_page)
		Call userPagingCustom(total_page, block_size, page, page_params, list_page, "page")
	End Sub

	Sub userPagingCustom (ByVal total_page, ByVal block_size, ByVal page, ByVal page_params, ByVal list_page, ByVal key_name)
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

		response.write "<div class=""pagination"">" & vbcrlf

		response.write "<a href='javascript:query_build(1);'><img src='./images/cmd_prev_10.gif' border='0' WIDTH='13' HEIGHT='11'></a>&nbsp;"
		If min_page > block_size Then
			response.write "<a href=""javascript:query_build("& min_page-1 &");"" ><img src='./images/cmd_prev.gif' border='0' WIDTH='13' HEIGHT='11'></a>&nbsp;" & vbcrlf
		Else
			response.write "<a href=""javascript:alert('첫 페이지 입니다.');""><img src='./images/cmd_prev.gif' border='0' WIDTH='13' HEIGHT='11'></a>&nbsp;" & vbcrlf
		End if

		For i = min_page To max_page
			If Int(i) = Int(page)  Then
				response.write "<a href=""javascript:;"" style='color:#000000'>" & i & "</a><font color='#D8D3D0'>&nbsp;|&nbsp;</font>" & vbcrlf
			Else
				response.write "<a href=""javascript:query_build("&i&");"" > " & i & " </a>"
				If i < max_page Then
				Response.write "<font color='#D8D3D0'>&nbsp;|&nbsp;</font>"
				End if
			End if
		Next

		If max_page < total_page Then
			response.write "&nbsp;<a href=""javascript:query_build("&max_page + 1 &");"" ><img src='./images/cmd_next.gif' border='0' WIDTH='13' HEIGHT='11'></a>" & vbcrlf
		Else
			response.write "&nbsp;<a href=""javascript:alert('마지막 페이지 입니다.');""><img src='./images/cmd_next.gif' border='0' WIDTH='13' HEIGHT='11'></a>" & vbcrlf
		End If

		response.write "&nbsp;<a href=""javascript:query_build("&total_page&");""><img src='./images/cmd_next_10.gif' border='0' WIDTH='13' HEIGHT='11'></a>" & vbcrlf

		response.write "</div>" & vbcrlf
	End Sub























	Sub userPagingScript (ByVal total_page, ByVal block_size, ByVal page, ByVal function_name)
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

		response.write "<ul>" & vbcrlf


		If min_page > block_size Then
			response.write "<li class=""prev""><a href=""javascript:"" onclick=""" & function_name & "("& min_page-1 & ")"">&lt;</a></li>" & vbcrlf
		Else
			response.write "<li class=""prev""><a href=""javascript:alert('첫 페이지 입니다.');"">&lt;</a></li>" & vbcrlf
		End if

		For i = min_page To max_page
			If Int(i) = Int(page)  Then
				response.write "<li class=""on""><a href=""javascript:;"">" & i & "</a></li>" & vbcrlf
			Else
				response.write "<li><a href=""javascript:"" onclick=""" & function_name & "(" & i & ")"" > " & i & " </a></li>" & vbcrlf
			End if
		Next

		If max_page < total_page Then
			response.write "<li class=""next""><a href=""javascript:"" onclick=""" & function_name & "(" & max_page + 1 & ")"">&gt;</a></li>" & vbcrlf
		Else
			response.write "<li class=""next""><a href=""javascript:alert('마지막 페이지 입니다.');"">&gt;</a></li>" & vbcrlf
		End If


		response.write "</ul>" & vbcrlf
	End Sub




















	'------------------------------------------------------------
	' Description
	'	front 페이징 처리
	' params total_page  : 총 페이지 수
	' params block_size  : 페이징 블럭 수
	' params page        : 현재 페이지 번호
	' params page_params : 파라미터 값
	' params list_page   : 리스트 페이지 주소
	'------------------------------------------------------------
	Sub mobileUserPaging (ByVal total_page, ByVal block_size, ByVal page, ByVal page_params, ByVal list_page)
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

		response.write "<ul>" & vbcrlf

		If min_page > block_size Then
			response.write "<li><a class=""prev"" href=""" & list_page & "?page="& min_page-1 & page_params & """>&lt;</a></li>" & vbcrlf
		Else
			response.write "<li><a class=""prev"" href=""javascript:alert('첫 페이지 입니다.');"">&lt;</a></li>" & vbcrlf
		End if

		For i = min_page To max_page
			If Int(i) = Int(page)  Then
				response.write "<li class=""on""><a href=""javascript:;"">" & i & "</a></li>" & vbcrlf
			Else
				response.write "<li><a href="""& list_page & "?page=" & i & page_params & """ > " & i & " </a></li>" & vbcrlf
			End if
		Next

		If max_page < total_page Then
			response.write "<li><a class=""next"" href=""" & list_page & "?page=" & max_page + 1 & page_params & """>&gt;</a></li>" & vbcrlf
		Else
			response.write "<li><a class=""next"" href=""javascript:alert('마지막 페이지 입니다.');"">&gt;</a></li>" & vbcrlf
		End If

		response.write "</ul>" & vbcrlf
	End Sub
%>