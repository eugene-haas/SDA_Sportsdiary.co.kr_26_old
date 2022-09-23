<li>
  <span class="l-title">그룹/종목</span>
  <span class="r-con">
      <select  id="sportsgb"  class="sl_search" onchange="mx.SelectGb()">
          <option value="">=대분류=</option>
              <%
              If IsArray(arrRS) Then
                  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
                      gtitleCode = arrRS(0, ar)
                      ghostTitle = arrRS(1, ar)
                      %><option value="<%=ghostTitle%>" <%If CStr(ghostTitle) = sgb then%>selected<%End if%>><%=ghostTitle%></option><%
                  i = i + 1
                  Next
              End if
              %>
              <option value="insert">[추가생성]</option>
      </select>
  </span>
</li>

<li>
  <span class="l-title"> 대회명</span>
  <span class="r-con">
      <input type="text" name="gametitle" id="gametitle" placeholder="대회명을 입력해주세요." value="<%=GameTitle%>" class="in_txt" maxlength="40">
  </span>
</li>
<li>
  <span class="l-title">대회유형</span>
  <span class="r-con">
      <select  id="gametype"  class="sl_search">
      <option value="">==선택==</option>
      <option value="E" <%If gametype="E" then%>selected<%End if%>>전문</option>
      <option value="A"  <%If gametype="A" then%>selected<%End if%>>생활</option>
      </select>
  </span>
</li>
