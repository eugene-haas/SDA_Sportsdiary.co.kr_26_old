<!-- 이전/다음 : 시작 ---------->
<div id="notice_page">
	<div class="notice_page_btn">
		<%
			iTemp = Int((NowPage - 1) / BlockPage) * BlockPage + 1
							
			If iTemp = 1 Then
					Response.Write "<IMG src=""../images/btn_prev.jpg"" width=""20"" height=""20"" align=""middle"">&nbsp;"
			Else 
					Response.Write"<a href='javascript:;' onClick = 'javascript:PagingLink(" & iTemp - BlockPage & ")'><IMG src=""../images/btn_prev.jpg"" width=""20"" height=""20"" align=""middle""></a>&nbsp;"
			End If

			iLoop = 1

			Do Until iLoop > BlockPage Or iTemp > iTotalPage
					If iTemp = CInt(NowPage) Then
							Response.Write "[" & iTemp &"]&nbsp;" 
					Else
							Response.Write"<a href='javascript:;' onClick='javascript:PagingLink(" & iTemp & ")'>["& iTemp &"]</a>&nbsp;"
					End If
					iTemp = iTemp + 1
					iLoop = iLoop + 1
			Loop

			If iTemp > iTotalPage Then
					Response.Write "<IMG src=""../images/btn_next.jpg"" width=""20"" height=""20"" align=""middle"">"
			Else
					Response.Write"<a href='javascript:;' onClick='javascript:PagingLink(" & iTemp & ")'><IMG src=""../images/btn_next.jpg"" width=""20"" height=""20"" align=""middle""></a>"
			End If
		%>
	</div>
</div>
<!-- 이전/다음 : 종료 ---------->