          <li>
            <span class="txt">지역</span>
            <select  id="sidogb"  class="sl_search w_50"  onchange="mx.SelectSido()">
				<option value="">=시,도=</option>
					<%			
					If IsArray(arrSD) Then
						For ar = LBound(arrSD, 2) To UBound(arrSD, 2) 
							sidono = arrSD(0, ar) 
							sidonm = arrSD(1,ar)
						%>
								<%If s_sidonm <> "" then%>
								<option value="<%=sidono%>" <%If CStr(sidonm) = s_sidonm then%>selected<%End if%>><%=sidonm%></option>
								<%else%>
								<option value="<%=sidono%>" <%If CStr(sidono) = s_sidono then%>selected<%End if%>><%=sidonm%></option>
								<%End if%>
						<%
						i = i + 1
						Next
					End if					
					%>
            </select>


			<select  id="googun"  class="sl_search w_50">
				<option value="">=시,군,구=</option>
				<%			
				If IsArray(arrGG) Then
					For ar = LBound(arrGG, 2) To UBound(arrGG, 2) 
						gugun = arrGG(0, ar)
						%><option value="<%=gugun%>" <%If CStr(gugun) = s_gugun then%>selected<%End if%>><%=gugun%></option><%
					i = i + 1
					Next
				End if
				%>
          </li>
          <li>
            <span class="txt">경기장명</span>
            <input type="text" name="stadium" id="stadium" placeholder="경기장명을 입력해주세요." value="<%=stadium%>" class="in_txt" maxlength="25" onkeydown="if(event.keyCode == 13){mx.searchPlayer(1);}">
          </li>
  		  <li></li>