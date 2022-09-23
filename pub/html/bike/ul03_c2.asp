<li>
  <span class="l-title">대회일자</span>
  <span class="r-con">
      <input type="text" id="GameS" value="<%=GameS%>" class="in-data" placeholder="시작일"  >
      <span class="s-txt">~</span>
      <input type="text" id="GameE"  value="<%=GameE%>"  class="in-data" placeholder="종료일"  >
  </span>
</li>
<li>
  <span class="l-title">신청기간</span>
  <span class="r-con">
      <input type="text" id="GameAS" value="<%=GameAS%>" class="in-data" placeholder="시작일"  >
      <span class="s-txt">~</span>
      <input type="text" id="GameAE"  value="<%=GameAE%>"  class="in-data" placeholder="종료일"  >
  </span>
</li>
<li>
  <span class="l-title">대회주최</span>
  <span class="r-con">
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
  </span>
</li>
