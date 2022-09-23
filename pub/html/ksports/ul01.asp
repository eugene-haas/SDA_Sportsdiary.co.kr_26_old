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
					<option value="insert">[추가생성]</option>
            </select>


			<select  id="sportssubgb"  class="sl_search w_50"  onchange="mx.SelectSubGb()">
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
				<option value="insert">[추가생성]</option>			
          </li>
          <li>
            <span class="txt"> 대회명</span>
            <input type="text" name="gametitle" id="gametitle" placeholder="대회명을 입력해주세요." value="<%=GameTitle%>" class="in_txt" maxlength="40">
          </li>
          <li>
            <span class="txt">대회유형</span>
            <select  id="gametype"  class="sl_search">
            <option value="">==선택==</option>
            <option value="E" <%If gametype="E" then%>selected<%End if%>>전문</option>
            <option value="A"  <%If gametype="A" then%>selected<%End if%>>생활</option>
            <option value="EA"  <%If gametype="EA" then%>selected<%End if%>>전문+생활</option>
            </select>
          </li>