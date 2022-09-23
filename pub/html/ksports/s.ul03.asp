          <li>
			<span class="txt">종목</span>
            <select  id="sportsgb"  class="sl_search w_50"  onchange="mx.SelectGb()">
				<option value="">=대분류=</option>
					<%			
					If IsArray(arrRS) Then
						For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
							gbtitle = arrRS(0, ar) 
						%>
								<option value="<%=gbtitle%>" <%If CStr(gbtitle) = sgb then%>selected<%End if%>><%=gbtitle%></option>
						<%
						i = i + 1
						Next
					End if					
					%>
            </select>


			<select  id="sportssubgb"  class="sl_search w_50">
				<%			
				If IsArray(arrSub) Then
					For ar = LBound(arrSub, 2) To UBound(arrSub, 2) 
						gbidx  = arrSub(0, ar) 
						gbsubtitle = arrSub(1, ar)
						If isnull(gbsubtitle) = True Then
							gbsubtitle = ""
							%><option value="">=종목명=</option><%
						else
							%><option value="<%=gbsubtitle%>" <%If CStr(gbsubtitle) = sgbsub then%>selected<%End if%>><%=gbsubtitle%></option><%
						End if
					i = i + 1
					Next
				Else
				%>
				<option value="">=종목명=</option>
				<%
				End if					
				%>
            </select>
          </li>
  		  <li></li>
		  <li>&nbsp;</li>


