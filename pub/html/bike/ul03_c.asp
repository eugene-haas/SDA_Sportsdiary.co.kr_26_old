		  <li>
            <span class="txt">대회일자</span>
            <input type="text" id="GameS" value="<%=GameS%>" class="in_txt w_50" style="margin-right:8px;" placeholder="시작일"  >
            <input type="text" id="GameE"  value="<%=GameE%>"  class="in_txt w_50" placeholder="종료일"  >
          </li>
          <li>
            <span class="txt">신청기간</span>
            <input type="text" id="GameAS" value="<%=GameAS%>" class="in_txt w_50" style="margin-right:8px;" placeholder="시작일"  >
            <input type="text" id="GameAE"  value="<%=GameAE%>"  class="in_txt w_50" placeholder="종료일"  >
          </li>
          <li>
            <span class="txt">대회주최</span>
            <select id="gamehost" class="sl_search"  onchange="mx.Select('gamehost',mx.CMD_GAMEHOST)">
				<option value="">=대회주최=</option>
					<%			
					If IsArray(arrO) Then
						For ar = LBound(arrO, 2) To UBound(arrO, 2) 
							op2idx = arrO(0, ar) 
							op2name = arrO(1, ar) 
						%>
								<option value="<%=op2name%>" <%If CStr(op2name) = newname then%>selected<%End if%>><%=op2name%></option>
						<%
						i = i + 1
						Next
					End if					
					%>
					<option value="insert">[추가생성]</option>
            </select>
            </select>     
          </li>