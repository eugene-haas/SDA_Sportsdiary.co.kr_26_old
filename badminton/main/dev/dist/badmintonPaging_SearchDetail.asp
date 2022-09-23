<!-- 이전/다음 : 시작 ---------->
<div class="page">
	<ul class="pagination">
			<%
				Dim iTemp, iLoop
				iLoop = 1
				iTemp = Int((NowPage - 1) / BlockPage) * BlockPage + 1
				If MasterGB = "Admin" Then 
					MasterGB = "1" 
				Else
					MasterGB = "2" 
				End If 
				'Response.Write("페이징.asp NowPage : " & NowPage & "<br/>")
				'Response.Write("페이징.asp BlockPage : " & BlockPage & "<br/>")
				'Response.Write("페이징.asp iTemp : " & iTemp & "<br/>")
				'Response.Write("페이징.asp iTotalPage : " & iTotalPage& "<br/>")
				'Response.Write("페이징.asp iLoop: " & iLoop & "<br/>")
				''<li class="page-item"><a href="#"><span>이전</span></a></li>
				'Response.Write "<li class=""page-item""><a href='javascript:PagingLinkSearchDetail(1)' class=""page-link"" ><span class=""img_box""><img src=""/enroll/imgs/table/page_prev_10.png""></span></a></li>"
				If iTemp = 1 Then
						Response.Write "<li class=""page-item""><a href='javascript:;' class=""page-link"" ><span class=""img_box""><<</span></a></li>"
				Else 
						Response.Write "<li class=""page-item""><a href='javascript:;' class=""page-link""  onClick = 'javascript:PagingLinkSearchDetail(" & iTemp - BlockPage &  "," & MasterGB &")'><span class=""img_box""><<</span></a></li>"
						'Response.Write"<li class=""page-item""><a href='javascript:;'  class=""page-link"" onClick = 'javascript:PagingLinkSearchDetail(" & iTemp - BlockPage & ")' ></a></li>"
				End If
				
				IF( LCnt > 0 ) Then
					Do Until iLoop > BlockPage Or iTemp > iTotalPage
							If iTemp = CInt(NowPage) Then
									'Response.Write "[" & temp &"]&nbsp;" 
									Response.Write "<li class=""page-item active""><a href='javascript:;' class=""page-link"" >" & iTemp &"</a></li>"
							Else
									 Response.Write"<li><a href='javascript:;'  onClick='javascript:PagingLinkSearchDetail(" & iTemp & "," & MasterGB &")' class=""page-link"" >" & iTemp &"</a></li>"
									'Response.Write"<a href='javascript:;'>["& temp &"]</a>&nbsp;"
							End If
							iTemp = iTemp + 1
							iLoop = iLoop + 1
					Loop
				Else
					Response.Write "<li class=""active""><a href='javascript:;'>" & iTemp &"</a></li>"
				End IF

				If iTemp > iTotalPage Then
					If iTotalPage = iTemp Then 
						Response.Write "<li class=""next""><a class=""page-link"" href=""javascript:;"" aria-label=""Next"">>></a></li>"
					Else
						Response.Write "<li class=""next""><a class=""page-link"" href=""javascript:;"" aria-label=""Next"">>></a></li>"
					End If 
						'Response.Write"<a href='javascript:;' onClick = 'javascript:PagingLinkSearchDetail(" & temp - blockPageCount & ")'><IMG src=""../images/btn_page-item.jpg"" width=""20"" height=""20"" align=""middle""></a>&nbsp;"
						'Response.Write "<IMG src=""../images/btn_next.jpg"" width=""20"" height=""20"" align=""middle"">"
				Else
						Response.Write "<li class=""next""><a class=""page-link"" href=""javascript:PagingLinkSearchDetail(" & iTemp & "," & MasterGB &");"" aria-label=""Next"">>></a></li>"
						'Response.Write "<li class=""next""><a href='javascript:;' onClick='javascript:PagingLinkSearchDetail(" & iTemp & ")'></a></li>"
						'Response.Write"<a href='javascript:;' onClick='javascript:PagingLinkSearchDetail(" & temp & ")'><IMG src=""../images/btn_next.jpg"" width=""20"" height=""20"" align=""middle""></a>"
				End If
				'Response.Write "<li class=""page-item""><a href=""javascript:PagingLinkSearchDetail("&iTotalPage& "," & MasterGB &");"" class=""page-link"" aria-label=""Next""><span class=""img_box""><img src=""/enroll/imgs/table/page_next_10.png""></span></a></li>"
			%>
	</ul>
</div>
