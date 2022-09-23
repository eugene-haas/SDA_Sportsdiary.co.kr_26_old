<div class="paging">
  <%
  	Dim iTemp, iLoop
  	iLoop = 1
  	iTemp = Int((NowPage - 1) / BlockPage) * BlockPage + 1
  	
  	'Response.Write("페이징.asp iTemp : " & iTemp & "<br/>")
  	'Response.Write("페이징.asp iTotalPage : " & iTotalPage& "<br/>")
  	'Response.Write("페이징.asp iLoop: " & iLoop & "<br/>")
  	'<li class="prev"><a href="#"><span>이전</span></a></li>
  
  	If iTemp = 1 Then
  	  Response.Write "<a href='javascript:;' class='icon-btn'><i class='fas fa-angle-left'></i></a>"
  	Else
      Response.Write"<a href='javascript:;' onClick = 'javascript:PagingLink(" & iTemp - BlockPage & ")' class='icon-btn'><i class='fas fa-angle-left'></i></a>"
  	  'Response.Write"<li class=""prev""><a href='javascript:;' onClick = 'javascript:PagingLink(" & iTemp - BlockPage & ")' class='fa fa-angle-left'></a></li>"
  	End If
  	
  	IF( iTotalCount > 0 ) Then
  		Do Until iLoop > BlockPage Or iTemp > iTotalPage
  		  If iTemp = CInt(NowPage) Then
          Response.Write "<a href='javascript:;' class='active'><span>" & iTemp &"</span></a>"
  		    'Response.Write "[" & temp &"]&nbsp;"
  		    'Response.Write "<li class=""active""><a href='javascript:;'>" & iTemp &"</a></li>"
  		  Else
  		    Response.Write"<a href='javascript:;' onClick='javascript:PagingLink(" & iTemp & ")'><span>" & iTemp &"</span></a>"
          'Response.Write"<li><a href='javascript:;'  onClick='javascript:PagingLink(" & iTemp & ")'>" & iTemp &"</a></li>"
  		    'Response.Write"<a href='javascript:;'>["& temp &"]</a>&nbsp;"
  		  End If
  		  iTemp = iTemp + 1
  		  iLoop = iLoop + 1
  		Loop
  	Else
      Response.Write "<a href='javascript:;' class='active'><span>" & iTemp &"</span></a>"
  		'Response.Write "<li class=""active""><a href='javascript:;'>" & iTemp &"</a></li>"
  	End IF
  
  	If iTemp > iTotalPage Then
      Response.Write "<a href='javascript:;' class='icon-btn'><i class='fas fa-angle-right'></i></a>"
  	  'Response.Write "<li class=""next""><a href='javascript:;' class='fa fa-angle-right'></a></li>"
  	  'Response.Write"<a href='javascript:;' onClick = 'javascript:PagingLink(" & temp - blockPageCount & ")'><IMG src=""../images/btn_prev.jpg"" width=""20"" height=""20"" align=""middle""></a>&nbsp;"
  	  'Response.Write "<IMG src=""../images/btn_next.jpg"" width=""20"" height=""20"" align=""middle"">"
  	Else
      Response.Write "<a href='javascript:;' onClick='javascript:PagingLink(" & iTemp & ")' class='icon-btn'><i class='fas fa-angle-right'></i></a>"
  	  'Response.Write "<li class=""next""><a href='javascript:;' onClick='javascript:PagingLink(" & iTemp & ")' class='fa fa-angle-right'></a></li>"
  	  'Response.Write"<a href='javascript:;' onClick='javascript:PagingLink(" & temp & ")'><IMG src=""../images/btn_next.jpg"" width=""20"" height=""20"" align=""middle""></a>"
  	End If
  %>
</div>