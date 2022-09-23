<div class="modal fade tn_modal tn_score film-modal" id="round-res">
  <!-- S: modal-dialog -->
  <div class="modal-dialog">
    <!-- S: modal-content -->
    <div class="modal-content">
      <!-- S: modal-header -->
      <div class="modal-header">
        <h3 id="modalTitle">상세스코어</h3>
        <!-- <a href="#" class="btn btn-close" data-dismiss="modal">&times;</a> -->
		    <a href="javascript:mx.closeModal('round-res')" class="btn btn-close">&times;</a>
      </div>
      <!-- E: modal-header -->

      <!-- S: main banner 03 -->
      <%
        imType = "1"
        imSportsGb = "tennis"
        imLocateIDX = LocateIDX_3

        LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"
        'response.Write "LSQL="&LSQL&"<br>"
        'response.End

        Set LRs = DBCon6.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
      %>
	    <div class="major_banner">
	      <div class="banner banner_<%=LRs("LocateGb")%> carousel">
	    	  <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
	    		<!-- #include file="../banner_Include.asp" -->
	    		</div>
	    	</div>
	    </div>
	    <%
	      End If
	      LRs.close
	    %>
      <!-- E: main banner 03 -->

      <!-- S: modal-body -->
      <div class="modal-body">

        <!-- S: score_board -->
        <div class="score_board" id="ScoreBoard">
          <h4><span>SET SCORE 2:1</span></h4>

          <!-- S: board_table -->
          <ul class="tn_board_table clearfix">
            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                </div>
                <!-- E: p_self -->

                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="http://img.sportsdiary.co.kr/sdapp/modal/win_crown@3x.png" alt="win">
                </div>
              </div>
              <!-- E: win -->
              <div class="num y">7</div>
              <div class="num">4</div>
              <div class="num y">7</div>
              <div class="num"></div>
              <div class="num y"></div>
            </li>

            <li class="set_line">
              <div class="board_header"></div>
              <div class="win"></div>
              <div class="num">1</div>
              <div class="num">2</div>
              <div class="num">3</div>
              <div class="num">4</div>
              <div class="num">5</div>
            </li>

            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="http://img.sportsdiary.co.kr/sdapp/modal/win_crown@3x.png" alt="win">
                </div>
              </div>
              <!-- E: win -->
              <div class="num">5</div>
              <div class="num y">6</div>
              <div class="num">6 <span class="tie">(11)</span></div>
              <div class="num y"></div>
              <div class="num"></div>
            </li>

            <li class="duration">
              <div class="board_header">
                <span class="ic_deco"><i class="fa fa-clock-o"></i></span>
                <span>Match Duration</span>
                <span>2'10'</span>
              </div>
              <div class="win"></div>
              <div class="num">46'</div>
              <div class="num">29'</div>
              <div class="num">55'</div>
              <div class="num"></div>
              <div class="num"></div>
            </li>
          </ul>
          <!-- E: board_table -->
        </div>
        <!-- E: score_board -->

        <!-- S: tn_display_board -->
        <div class="tn_display_board" id="DetailScoreBoard">
        <!--S: record-box-->

          <div class="record-box panel">
          <!--<h4>득실기록</h4>-->

    			<!--상세스코어 개발시 아래 문구는 삭제처리합니다 : txt-상세스코어와 통계그래프는 준비 중에 있습니다.-->
    			<!-- <div class="scroll_box" style="text-align: center; line-height: 50px;">상세스코어와 통계그래프는 준비 중에 있습니다. </div> -->
              <div class="scroll_box" id="ScoreList"></div>
          </div>

          <!-- S: 영상보기  -->
          <!-- <div class="film-box panel clearfix">
            <iframe width="100%" height="220" src="https://www.youtube.com/embed/DCLAOwf9rgM?rel=0" frameborder="0" allowfullscreen></iframe>
            <button id="btnrewind" onclick="rewind(5);" class="btn btn-orage btn-rewind"><<</button>
            <button id="btnfastforward" onclick="fastforward(5)" class="btn btn-orange btn-fastforward">>></button>
          </div> -->
          <!-- E: 영상보기  -->
        </div>
        <!-- E: tn_display_board -->
      </div>
      <!-- E: modal-body -->


      <!-- S: modal-footer -->
      <div class="modal-footer">
        <div class="btn-list flex">
          <!-- <button class="btn btn-green">
            <span class="ic-deco"><img src="../images/stats/film-icon@3x.png" alt></span>
            영상보기
          </button>
          <button class="btn btn-green btn-record">기록보기</button> -->
          <!-- <button class="btn btn-default" data-dismiss="modal">닫기</button> -->
		      <button class="btn btn-default" onmousedown="mx.closeModal('round-res')">닫기</button>
        </div>
      </div>
      <!-- E: modal-footer -->

    </div>
  </div>
</div>
