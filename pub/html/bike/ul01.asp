          <li>
            <span class="txt">종목</span>
            <select  id="sportsgb"  class="sl_search w_50"  onchange="mx.SelectGb()">
				<option value="">=대분류=</option>
					<%			
					If IsArray(arrRS) Then
						For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
							gkey = arrRS(0, ar)
							gbtitle = arrRS(1, ar) 
							gbsubtitle = arrRS(2, ar)
							gbsubdetailtitle = arrRS(3, ar)
							If isNull(gbsubtitle) = true then
									%><option value="<%=gbtitle%>" <%If CStr(gbtitle) = sgb then%>selected<%End if%>><%=gbtitle%></option><%
							End if
						i = i + 1
						Next
					End if					
					%>
					<option value="insert">[추가생성]</option>
            </select>


			<select  id="sportssubgb"  class="sl_search w_50"  onchange="mx.SelectSubGb()">
				<option value="">=중분류=</option>
				<%
					If IsArray(arrRS) Then
						For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
							gkey = arrRS(0, ar)
							gbtitle = arrRS(1, ar) 
							gbsubtitle = arrRS(2, ar)
							gbsubdetailtitle = arrRS(3, ar)
							If isNull(gbsubtitle) = False And isNull(gbsubdetailtitle) = true And gbtitle = sgb then
									%><option value="<%=gbsubtitle%>" <%If CStr(gbsubtitle) = sgbsub then%>selected<%End if%>><%=gbsubtitle%></option><%
							End if
						i = i + 1
						Next
					End if					
				%>				
				<option value="insert">[추가생성]</option>			
            </select>

			<select  id="sportssubgb2"  class="sl_search w_50"  onchange="mx.SelectSubGb2()">
				<option value="">=소분류=</option>
				<%
					If IsArray(arrRS) Then
						For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
							gkey = arrRS(0, ar)
							gbtitle = arrRS(1, ar) 
							gbsubtitle = arrRS(2, ar)
							gbsubdetailtitle = arrRS(3, ar)
							If isNull(gbsubtitle) = False And isNull(gbsubdetailtitle) = False And sgbsub = gbsubtitle  then
									%><option value="<%=gbsubdetailtitle%>" <%If CStr(gbsubdetailtitle) = sgbsub2 then%>selected<%End if%>><%=gbsubdetailtitle%></option><%
							End if
						i = i + 1
						Next
					End if					
				%>				
				<option value="insert">[추가생성]</option>			
            </select>

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