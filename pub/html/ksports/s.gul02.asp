		<li>
            <span class="txt">년도</span>
            <select  id="sRegYear"  class="sl_search" onchange="">
            <option value="">==선택==</option>
            <option value="2018" <% If ey = "2018" Then %> selected <% End If%> > 2018 </option>
            </select>
          </li>
		 
		<li>
            <span class="txt">종목</span>
			<select  id="sClassinfo"  class="sl_search w_50" onchange="">
				<option value="">=종목명=</option>
				<%			
				If IsArray(arrClass) Then
					For ar = LBound(arrClass, 2) To UBound(arrClass, 2) 
						classIdx  = arrClass(0, ar) 
						classCode = arrClass(1, ar)
						className = arrClass(2, ar)
						If isnull(className) = True Then
							className = ""
							%><%
						else
							%><option value="<%=classCode%>" <% If cc = classCode Then %> selected <% End If%> ><%=className%></option><%
						End if
					i = i + 1
					Next
				End if					
				%>
			</select>
        </li>
        <li>
		  	<span class="txt">대회명</span>
            <input type="text" name="gameName" id="sGameName" placeholder="대회명을 입력해주세요."  class="in_txt" maxlength="40" value="<%=gn%>" >			
        </li>
		<li>
			<a class="btn" onclick="mx.searchGameInfo(<%=page%>);">검색</a>
        </li>
		

