    <!-- S: start-modal -->
    <div class="modal fade start-modal"  data-backdrop="static">
      <div class="modal-dialog">
        <!-- S: modal-content -->
        <div class="modal-content">
          <!-- S: modal-header -->
          <div class="modal-header">
            <h3 id="rcpopmsg">기록관의 이름을 입력해주세요.</h3>
            <input type="text" placeholder="이름 입력" id="in_rcname">
          </div>
          <!-- E: modal-header -->
          <!-- S: modal-body -->
          <div class="modal-body">
            <h4>경기시작</h4>
            <!-- S: ipt-time -->
            <div class="ipt-time">
              <ul class="time-list">
                <li>
                  <!-- <a href="#">0</a> -->
                  <!-- <input type="text" placeholder="0" maxlength="1"> -->
                  <select id="startH">
                    <%
          nowh = hour(time)
          If Len(nowh) = 1 then
            nowh  = "0" & nowh
          End if
          For i = 0 To 23
          If Len(i) = 1 then
            istr  = "0" & i
          Else
            istr = i
          End if
          %>
          <option value="<%=istr%>" <%If istr = nowh then%>selected<%End if%>><%=istr%></option>
          <%next%>
                  </select>
                </li>
                <!-- <li>
                  <a href="#">0</a>
                  <input type="text" placeholder="0" maxlength="1">
                </li> -->
                <li class="divn time"><span>시</span></li>
                <li>
                  <!-- <a href="#">0</a> -->
                  <!-- <input type="text" placeholder="0" maxlength="1"> -->
                  <select id="startM">
                    <%
          nowm = hour(time)
          If Len(nowm) = 1 then
            nowm  = "0" & nowm
          End if
          For i = 0 To 59
          If Len(i) = 1 then
            istr  = "0" & i
          Else
            istr = i
          End if
          %>
          <option value="<%=istr%>" <%If istr = nowm then%>selected<%End if%>><%=istr%></option>
          <%next%>
                  </select>
                </li>
                <!-- <li>
                  <a href="#">0</a>
                  <input type="text" placeholder="0" maxlength="1">
                  <select name="">
                    <option value=""></option>
                  </select>
                </li> -->
                <li class="divn minute"><span>분</span></li>
              </ul>
              <p class="ipt-guide">경기 시작시간을 입력해주세요.</p>
            </div>
            <!-- E: ipt-time -->
          </div>
          <!-- E: modal-body -->
          <!-- S: modal-footer -->
          <div class="modal-footer">
            <a href="javascript:score.startGame()" class="btn btn-start"  role="button">경기시작</a>
            <!-- <a href="javascript:window.history.back();" class="btn btn-close" role="button">대진표 바로가기</a> -->
			<a href="javascript:score.gameReSetProcess()" class="btn btn-close" role="button">대진표 바로가기</a> 
			
          </div>
          <!-- E: modal-footer -->
        </div>
        <!-- E: modal-content -->
      </div>
    </div>
    <!-- E: start-modal -->