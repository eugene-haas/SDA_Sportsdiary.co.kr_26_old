		<li>
            <span class="txt">년도</span>
            <select  id="regYear"  class="sl_search" onchange="">
            <option value="2018" <% If rsEventYear = 2018 Then %> selected <% End If%> > 2018 </option>
            <option value="2019" <% If rsEventYear = 2019 Then %> selected <% End If%> > 2019 </option>
            </select>
          </li>

		<li>
            <span class="txt">종목</span>
			<select  id="classinfo"  class="sl_search w_50" onchange="">
				<option value="">=종목명=</option>
				<%
				If IsArray(arrClass) Then
					For ar = LBound(arrClass, 2) To UBound(arrClass, 2)
						classIdx  = arrClass(0, ar)
						classCode = arrClass(1, ar)
						className = arrClass(2, ar)
                        classVideoCount = arrClass(3, ar)
						If isnull(className) = True Then
							className = ""
							%><%
						else
							%><option value="<%=classCode%>" <% If rsClassCode = classCode Then %> selected <% End If%> ><%=className%></option><%
						End if
					i = i + 1
					Next
				End if
				%>
			</select>
        </li>
        <li>
		  	<span class="txt">대회명</span>
            <input type="text" name="gameName" id="gameName" placeholder="대회명을 입력해주세요."  class="in_txt" maxlength="40" value="" >
        </li>
		<li>
			<a class="btn" onclick="mx.searchGameVideo();">검색</a>
        </li>
