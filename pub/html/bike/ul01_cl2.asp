<li class="li-block">
  <span class="l-title">종목</span>
  <span class="r-con">
      <select  id="sportsgb"   class="sl_search w_50" onchange="mx.SelectGb()">
          <option value="">=대분류=</option>
              <%
              If IsArray(arrRS) Then
                  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
                      ghevelno = arrRS(0, ar)
                      gtitle = arrRS(1, ar)
                      gsubtitle = arrRS(2, ar)
                      gdetailtitle = arrRS(3, ar)

                      If isnull(gsubtitle) = true  then
                      %><option value="<%=gtitle%>" <%If CStr(gtitle) = stitle then%>selected<%End if%>><%=gtitle%></option><%
                      End if
                  i = i + 1
                  Next
              End if
              %>
              <option value="insert">[추가생성]</option>
      </select>

      <select  id="sportssubgb"   class="sl_search w_50" onchange="mx.SelectSubGb()">
          <option value="">=중분류=</option>
              <%
              If stitle <> "" then
              If IsArray(arrRS) Then
                  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
                      ghevelno = arrRS(0, ar)
                      gtitle = arrRS(1, ar)
                      gsubtitle = arrRS(2, ar)
                      gdetailtitle = arrRS(3, ar)

                      If isnull(gsubtitle) = False And isnull(gdetailtitle) = True And gtitle = stitle then
                      %><option value="<%=gsubtitle%>" <%If CStr(gsubtitle) = ssubtitle then%>selected<%End if%>><%=gsubtitle%></option><%
                      End if
                  i = i + 1
                  Next
              End if
              %>
              <option value="insert">[추가생성]</option>
              <%End if%>
      </select>

      <select  id="sportsdetailgb"   class="sl_search w_50" onchange="mx.SelectDetailGb()">
          <option value="">=경기종류=</option>
              <%
              If stitle <> "" then
              If IsArray(arrRS) Then
                  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
                      ghevelno = arrRS(0, ar)
                      gtitle = arrRS(1, ar)
                      gsubtitle = arrRS(2, ar)
                      gdetailtitle = arrRS(3, ar)

                      If isnull(gsubtitle) = False And isnull(gdetailtitle) = false And gtitle = stitle And gsubtitle = ssubtitle then
                      %><option value="<%=gdetailtitle%>" <%If CStr(gdetailtitle) = sdetailtitle then%>selected<%End if%>><%=gdetailtitle%></option><%
                      End if
                  i = i + 1
                  Next
              End if
              %>
              <option value="insert">[추가생성]</option>
              <%End if%>
      </select>
  </span>
</li>

<li id="solo_cnt" <%If ssubtitle = "개인경기" then%>style="display:block;"<%else%>style="display:none;"<%End if%>>
  <span class="l-title">한경기인원수</span>
  <span class="r-con">
      <select  id="gamemcnt"  class="sl_search w_50">
      <option value="">==선택==</option>
      <option value="10"  <%If gamemcnt="10" then%>selected<%End if%>>10명</option>
      <option value="20"  <%If gamemcnt="20" then%>selected<%End if%>>20명</option>
      <option value="30"  <%If gamemcnt="30" then%>selected<%End if%>>30명</option>
      <option value="40"  <%If gamemcnt="40" then%>selected<%End if%>>40명</option>
      <option value="50"  <%If gamemcnt="50" then%>selected<%End if%>>50명</option>
      </select>
  </span>
</li>

<li>
  <span class="l-title">경기수</span>
  <span class="r-con">
      <select  id="game_cnt"  class="sl_search w_50">
      <option value="">==선택==</option>
      <option value="1" <%If game_cnt="1" then%>selected<%End if%>>1</option>
      <option value="2"  <%If game_cnt="2" then%>selected<%End if%>>2</option>
      <option value="3"  <%If game_cnt="3" then%>selected<%End if%>>3</option>
      </select>
  </span>
</li>

<li>
  <span class="l-title"> 경기일자</span>
  <span class="r-con">
      <input type="text" id="GameS" value="<%=GameS%>" class="in_txt w_50" style="margin-right:8px;" placeholder="경기일자"  >
  </span>
</li>

<li>
  <span class="l-title">성별</span>
  <span class="r-con">
      <select id="memberSex">
          <option value="">==선택==</option>
          <option value="man"  <%If ssex = "man" then%>selected<%End if%> >남자</option>
          <option value="woman" <%If ssex = "woman" then%>selected<%End if%>>여자</option>
      </select>
  </span>
</li>

<li>
  <span class="l-title">부</span>
  <span class="r-con">
      <select id="department">
          <option value="">==선택==</option>
              <%
              If IsArray(arrD) Then
                  For ar = LBound(arrD, 2) To UBound(arrD, 2)
                      idx = arrD(0, ar)
                      name = arrD(1, ar)
                      %><option value="<%=name%>" <%If sdepartment = name then%>selected<%End if%> ><%=name%></option><%
                  Next
              End if
              %>
      </select>
  </span>
</li>
