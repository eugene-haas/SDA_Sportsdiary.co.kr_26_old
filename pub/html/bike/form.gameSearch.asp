
<%If DROWTYPE = "B" then%>

	<%If CDbl(cmd) = CMD_FINDYEAR then%>
			<select name="sgameYear" id="sgameYear"  class="sl_search w_50" onchange="mx.selectYear('A',<%=page%>);">
				  <%
				  If IsArray(arrY) Then
					  For ar = LBound(arrY, 2) To UBound(arrY, 2)
						  s_gameyear = arrY(0, ar)
						  %><option value="<%=s_gameyear%>" <%If CStr(GY) = s_gameyear then%>selected<%End if%>><%=s_gameyear%></option><%
					  i = i + 1
					  Next
				  End if
				  %>
			</select>
			<select name="sgametitle" id="sgametitle"  class="sl_search" onchange="mx.SelectTitle('A',<%=page%>)">
			  <option value="">=대회선택=</option>
				  <%
				  If IsArray(arrRS) Then
					  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
						  gtitleIDX = arrRS(0, ar)
						  gtitleName = arrRS(1, ar)
						  %><option value="<%=gtitleIDX%>" <%If CStr(gtitleIDX) = tidx then%>selected<%End if%>><%=gtitleName%></option><%
					  i = i + 1
					  Next
				  End if
				  %>
			</select>
	<%else%>
			<select name="slevelno" id="slevelno"  class="sl_search">
			  <option value="">=종목선택=</option>
				  <%
				  If IsArray(arrB) Then
					  %><option value="0">연습시간</option><%
					  For ar = LBound(arrB, 2) To UBound(arrB, 2)
						  glevelno = arrB(0, ar)
						  gsubtitle = arrB(1, ar)
						  gbooNM = arrB(2, ar)
						  %><option value="<%=glevelno%>" <%If CStr(glevelno) = levelno then%>selected<%End if%>><%=gsubtitle%>[<%=gbooNM%>] </option><%
					  i = i + 1
					  Next
				  End if
				  %>
			</select>
	<%End if%>

<%else%>


		  <form method="post"  name="sform" action="bbs.asp">
		  <input type="hidden" name="tid"  id = "tid" value="<%=tid%>">
		  <input type="hidden" name="p">
          <div class="search-box-1">
				<select id="sgameYear"  onchange="mx.selectYear('A',<%=page%>);">
				<%
				If IsArray(arrY) Then
				  For ar = LBound(arrY, 2) To UBound(arrY, 2)
					  s_gameyear = arrY(0, ar)
					  %><option value="<%=s_gameyear%>" <%If CStr(GY) = CStr(s_gameyear) then%>selected<%End if%>><%=s_gameyear%></option><%
				  i = i + 1
				  Next
				End if
				%>
				</select>
				<select  id="sgametitle" onchange="mx.SelectTitle('A',<%=page%>)">
				<option value="">=대회선택=</option>
				  <%
				  If IsArray(arrRS) Then
					  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
						  gtitleIDX = arrRS(0, ar)
						  gtitleName = arrRS(1, ar)
						  %><option value="<%=gtitleIDX%>" <%If CStr(gtitleIDX) = CStr(tidx) then%>selected<%End if%>><%=gtitleName%></option><%
					  i = i + 1
					  Next
				  End if
				  %>
				</select>

				<select  id="slevelno"  class="sl_search">
				<option value="">=종목선택=</option>
				  <%
				  If IsArray(arrB) Then
					  %><option value="0">연습시간</option><%
					  For ar = LBound(arrB, 2) To UBound(arrB, 2)
						  glevelno = arrB(0, ar)
						  gsubtitle = arrB(1, ar)
						  gbooNM = arrB(2, ar)
						  %><option value="<%=glevelno%>" <%If CStr(glevelno) = CStr(levelno) then%>selected<%End if%>><%=gsubtitle%>[<%=gbooNM%>] </option><%
					  i = i + 1
					  Next
				  End if
				  %>
				</select>
				<a href="javascript:mx.searchBBS(<%=page%>);" class="navy-btn search-btn">검색</a>
          </div>
 		  </form>
<%End if%>