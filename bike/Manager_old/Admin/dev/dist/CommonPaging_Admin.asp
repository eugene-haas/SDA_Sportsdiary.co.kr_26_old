<!-- 이전/다음 : 시작 ---------->
<ul class="pagination">
		<%
			Dim iTemp, iLoop
			iLoop = 1
			iTemp = (Int((NowPage - 1) / BlockPage) * BlockPage) + 1
			
			'Response.Write("페이징.asp iTemp : " & iTemp & "<br/>")
			'Response.Write("페이징.asp iTotalPage : " & iTotalPage& "<br/>")
			'Response.Write("페이징.asp iLoop: " & iLoop & "<br/>")
			'Response.Write("페이징.asp BlockPage: " & BlockPage & "<br/>")
			'Response.Write("페이징.asp (NowPage - 1) / BlockPage): " & (NowPage - 1) / BlockPage & "<br/>")

			'<li class="prev"><a href="#"><span>이전</span></a></li>

			If iTemp = 1 Then
					Response.Write "<li class=""prev""><a href='javascript:;' class='fas fa-angle-left'></a></li>"
			Else 
					Response.Write"<li class=""prev""><a href='javascript:;' onClick = 'javascript:PagingLink(" & iTemp - BlockPage & ")' class='fas fa-angle-left'></a></li>"
			End If
			
			IF( LCnt > 0 ) Then
				Do Until iLoop > BlockPage Or iTemp > iTotalPage
						If iTemp = CInt(NowPage) Then
								'Response.Write "[" & temp &"]&nbsp;" 
								Response.Write "<li class=""active""><a href='javascript:;'>" & iTemp &"</a></li>"
						Else
								 Response.Write"<li><a href='javascript:;'  onClick='javascript:PagingLink(" & iTemp & ")'>" & iTemp &"</a></li>"
								'Response.Write"<a href='javascript:;'>["& temp &"]</a>&nbsp;"
						End If
						iTemp = iTemp + 1
						iLoop = iLoop + 1
				Loop
			Else
				Response.Write "<li class=""active""><a href='javascript:;'>" & iTemp &"</a></li>"
			End IF

			If iTemp > iTotalPage Then
					Response.Write "<li class=""next""><a href='javascript:;' class='fas fa-angle-right'></a></li>"
					'Response.Write"<a href='javascript:;' onClick = 'javascript:PagingLink(" & temp - blockPageCount & ")'><IMG src=""../images/btn_prev.jpg"" width=""20"" height=""20"" align=""middle""></a>&nbsp;"
					'Response.Write "<IMG src=""../images/btn_next.jpg"" width=""20"" height=""20"" align=""middle"">"
			Else
					Response.Write "<li class=""next""><a href='javascript:;' onClick='javascript:PagingLink(" & iTemp & ")' class='fas fa-angle-right'></a></li>"
					'Response.Write"<a href='javascript:;' onClick='javascript:PagingLink(" & temp & ")'><IMG src=""../images/btn_next.jpg"" width=""20"" height=""20"" align=""middle""></a>"
			End If
		%>
</ul>
<!-- 이전/다음 : 종료 ---------->