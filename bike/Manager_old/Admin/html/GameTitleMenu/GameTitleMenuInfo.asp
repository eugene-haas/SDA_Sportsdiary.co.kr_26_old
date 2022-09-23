


            <table class="navi-tp-table">
              <caption>대회정보 기본정보</caption>
              <colgroup>
                <col width="110px">
                <col width="*">
                <col width="110px">
                <col width="*">
                <col width="110px">
                <col width="*">
              </colgroup>
              <tbody>
                <tr>
                  <th scope="row"><label for="competition-name">대회구분</label></th>
                  <td>
                    <select id ="SelNationType">
                    <%IF rGameGb = "B0010002" THEN%>
                    <option value="B0010002" Selected>국제대회</option>
                    <option value="B0010001">국내대회</option>  
                    <%ELSE%>
                    <option value="B0010002" >국제대회</option>
                    <option value="B0010001" Selected>국내대회</option>
                    <%END IF%>
                    </select>											
                  </td>
                  <th scope="row">
                    <label for="competition-name">대회명</label>
                  </th>
                  <td>
                    <input type="text" id="txtGameTitleName" placeholder="대회명을 입력해주세요." value="<%=rGameTitleName%>">
                  </td>
                  <th scope="row">
                    <label for="competition-name">대회장소</label>
                  </th>
                  <td>
                  <input type="text" id="txtGamePlace" placeholder="대회장소를 입력해주세요." value="<%=rGamePlace%>" style="width:200px;margin-bottom:0px;">
                  </td>
                </tr>
                <tr>
                  
                  <th scope="row">시작일</th>
                  <td>
                    <div class="ymd-list">
                      <span id="sel_GameSYear"><input type="text" id="GameS" value="<%=rGameS%>" class="date_ipt"></span>
                    </div>
                  </td>
                  <th scope="row">종료일</th>
                  <td>
                    <div class="ymd-list">
                      <span id="sel_GameEYear"><input type="text" id="GameE" value="<%=rGameE%>" class="date_ipt"></span>
                  </div></td>

                     <th scope="row">주최</th>
                  <td>
                    <div class="ymd-list">
                      <span id="sel_GameTitleHost">
                        <input type="text" id="txtGameTitleHost" value="<%=rGameTitleHost%>" class="date_ipt">
                      </span>
                    </div>
                  </td>
                  <!--
            
                  -->
                </tr>
                <!--
                <tr>
                  <th scope="row">접수시작일</th>
                  <td>
                    <div class="ymd-list">
                      <span id="sel_GameRcvSMonth"><input type="text" id="GameRcvS" value="" class="date_ipt"></span>
                    </div>
                  </td>
                  <th scope="row">접수종료일</th>
                  <td>
                    <div class="ymd-list">
                      <span id="sel_GameRcvEYear"><input type="text" id="GameRcvE" value="" class="date_ipt"></span>
                  </div></td>
                </tr>
                  -->

                <tr>
                  <th scope="row"><label for="competition-place">지역</label></th>
                  <td>
                    <select id="SelGameTitleLocation" style="width:150px;">
                      <%
                        LSQL = "SELECT Sido ,SidoNm "
                        LSQL = LSQL & " FROM  tblSidoInfo"
                        LSQL = LSQL & " WHERE DELYN = 'N' "
                        LSQL = LSQL & " Order by OrderbyNum "
                                            
                        Set LRs = DBCon.Execute(LSQL)
                        If Not (LRs.Eof Or LRs.Bof) Then
                          Do Until LRs.Eof
                              rSido= LRs("Sido")
                              rSidoNm = LRs("SidoNm")
                              if(rSido = rGameTitleSido ) Then
                              %>
                              <option value="<%=rSido%>" selected><%=rSidoNm%></option>
                              <%
                              Else
                              %>
                              <option value="<%=rSido%>" ><%=rSidoNm%></option>
                              <%
                              End if
                            LRs.MoveNext
                          Loop
                        End If
                        LRs.close
                      %>
                    </select>
                  </td>
                        <th scope="row">대회구분</th>
                  <td>
                    <select id="selEntertype" style="width:40%;">
                      <% IF rEnterType = "E" THEN%>
                      <option value="A">아마추어</option>
                      <option value="E" selected>엘리트</option>
                      <% ELSE %>
                      <option value="A" selected>아마추어</option>
                      <option value="E">엘리트</option>
                      <%END IF%>
                    </select>											
                  </td>
                  </tr>
                <tr>
                  <th scope="row">참가신청노출</th>
                  <td>
                    <select id="selViewYN">
                    <%IF rViewYN = "Y" Then %>
                    <option value="Y" selected>노출</option>
                    <option value="N" >미노출</option>
                    <%Else%>
                    <option value="N" selected>미노출</option>
                    <option value="Y" >노출</option>
                    <%End IF%>
                    </select>
                  </td>
                    <!--
                  <th scope="row">대회달력노출</th>
                  <td>
                    <select id="ViewState">
                      <option value="N">미노출</option>
                      <option value="Y">노출</option>
                    </select>
                  </td>	
                  -->		

                </tr>
              
              </tbody>
            </table>
         