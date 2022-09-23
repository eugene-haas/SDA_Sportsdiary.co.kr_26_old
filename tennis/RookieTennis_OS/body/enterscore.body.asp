<script language="javascript" runat="server">

	function loadREQ(){
		//var obj = {};
		//obj.a = 1;
		//obj.b = 2;
		//var req = localStorage.getItem("REQ");
		//var jsondata = JSON.parse(req);
		//return obj;
	}

</script>
<%
'Set db = new clsDBHelper

'코트 정보를 불러오자
'Response.write loadREQ()
'Call loadREQ()

'db.Dispose
'Set db = Nothing
%>


      <!-- S: score-enter -->
      <div class="score-enter row">
        <!-- S: select-court -->
        <ul class="select-court clearfix">
          <li id= "game_courtno">
            <select id="T-courtno" disabled><!-- onchange="score.setCourtNo()" -->
              <option value="0" selected>==C==</option>
			  <option value="1">1번 코트</option>
              <option value="2">2번 코트</option>
              <option value="3">3번 코트</option>
              <option value="4">4번 코트</option>
              <option value="5">5번 코트</option>
              <option value="6">6번 코트</option>
              <option value="7">7번 코트</option>
              <option value="8">8번 코트</option>
              <option value="9">9번 코트</option>
            </select>
          </li>
          <li>
            <select id="T-courtkind" disabled>
              <option value="0" selected>==K==</option>
			  <option value="1">하드코트</option>
              <option value="2">클레이코트</option>
              <option value="3">잔디코트</option>
            </select>
          </li>
        </ul>
        <ul class="match-info clearfix">
          <li id="DP_play-division">개인전</li>
          <li id="DP_play-s2">복식</li>
          <li id="DP_play-s3" class="long-word"><span>신인부</span></li>
          <li class="match-round">
            <p>
              <span id="DP_play-num">1경기</span>
              <span>/</span>
              <span id="DP_play-round">16강</span>
            </p>
          </li>
          <li class="play-title long-word"><span id="DP_play-title"></span></li>
        </ul>
        <!-- E: select-court -->

   

		<span id="enterscore"></span>		
		


		
		
		<!-- S: confirm_end modal -->
        <div class="modal fade  start-modal confirm_end">
          <!-- S: modal-dialog -->
          <div class="modal-dialog">
            <!-- S: modal-content -->
            <div class="modal-content">
              <div class="modal-body">
                <p class="message">
                   <span id="result_winner"></span><span class="result" id="result_msg"></span>
                  <!-- <span class="winner orange"  id="result_winner"></span> -->

                <!-- S: 결과 선택 -->
                <div class="sel_result" id="score_box">
                  <ul>
                    <li class="orange">
                      <div class="player_name" id="rt_left_member">
                        <p>박태규</p>
                        <p>김준회</p>
                      </div>
                      <div class="sel_list">
                        <select id="rt_left_score">
                          <option value="0">0</option>
						  <option value="1">1</option>
                          <option value="2">2</option>
                          <option value="3">3</option>
                          <option value="4">4</option>
                          <option value="5">5</option>
                          <option value="6">6</option>
                          <option value="7">7</option>
                        </select>
                      </div>
                    </li>
                    <li class="green">
                      <div class="player_name"  id="rt_right_member">
                        <p>남윤희</p>
                        <p>이기현</p>
                      </div>
                      <div class="sel_list" >
                        <select id="rt_right_score">
                          <option value="0">0</option>
						  <option value="1">1</option>
                          <option value="2">2</option>
                          <option value="3">3</option>
                          <option value="4">4</option>
                          <option value="5">5</option>
                          <option value="6">6</option>
                          <option value="7">7</option>
                        </select>
                      </div>
                    </li>
                  </ul>
                </div>
                <!-- E: 결과 선택 -->

				
				
				</p>










                <!-- S: btn-list -->
                <div class="btn-list" id='confirm_area'>
                  <a href="javascript:$('.confirm_end').modal('hide');" class="btn cancel btn_green">취소</a>
                  <a href="javascript:score.gameEndProcess();" class="btn confirm btn_orange" id='stopendokbtn'>확인</a>
                </div>
                <!-- E: btn-list -->
              </div>
            </div>
            <!-- E: modal-content -->
          </div>
          <!-- E: modal-dialog -->
        </div>
        <!-- E: confirm_end modal -->
		  








