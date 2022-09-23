<!-- S: game-point-modal -->
<div class="modal point-ipt-modal"  id="tennisinputmodal">


<%If showmode = True then%>
  <div class="modal-dialog" >
    <!-- S: modal-content -->
    <div class="modal-content" >
      <!-- S: modal-header -->
      <div class="modal-header clearfix">
        <!-- S: team -->
        <ul class="team team-1 clearfix">
          <li class="group">
            <a href="#" class="btn btn-player">최보라</a>
            <a href="#" class="btn btn-player">김선영</a>
          </li>
          <li class="score">
            <a href="#" class="btn btn-score">30</a>
          </li>
        </ul>
        <!-- E: team -->
        <span class="v-s">VS</span>
        <!-- S: team -->
        <ul class="team team-2 clearfix">
          <li class="score">
            <a href="#" class="btn btn-score">15</a>
          </li>
          <li class="solo">
            <a href="#" class="btn btn-player">나윤주</a>
            <!-- <a href="#" class="btn btn-player">지춘희</a> -->
          </li>
        </ul>
        <!-- E: team -->
      </div>
      <!-- E: modal-header -->

      <!-- S: modal-body -->
      <div class="modal-body">
        <!-- S: state -->
        <section class="state clearfix">
          <h3>득실기록</h3>
          <!-- S: log -->
          <div class="log">
            <span>최보라</span>
            <span>F.스트로크</span>
            <span>퍼스트서브</span>
            <span>스트레이트</span>
            <span class="now">ACE</span>
          </div>
          <!-- E: log -->
        </section>
        <!-- E: state -->

        <!-- S: skill-box -->
        <div class="enter skill-box">
          <!-- S: SHOT -->
          <div class="skill-item line-3 shot">
            <!-- S: skill-list -->
            <ul class="skill-list clearfix">
              <li><a href="#" class="btn btn-skill">퍼스트서브</a></li>
              <li><a href="#" class="btn btn-skill">F.리턴</a></li>
              <li><a href="#" class="btn btn-skill on">F.스트로크</a></li>
              <li><a href="#" class="btn btn-skill">F.발리</a></li>
              <li><a href="#" class="btn btn-skill">세컨서브</a></li>
              <li><a href="#" class="btn btn-skill">B.리턴</a></li>
              <li><a href="#" class="btn btn-skill">B.스트로크</a></li>
              <li><a href="#" class="btn btn-skill">B.발리</a></li>
              <li><a href="#" class="btn btn-skill">스매싱</a></li>
              <li class="mr0 so-on long-2"><a href="#" class="btn btn-skill">기타</a></li>
            </ul>
            <!-- E: skill-list -->
          </div>
          <!-- E: SHOT -->

          <!-- S: TECHNIC -->
          <div class="skill-item line-2 technic">
            <!-- S: skill-list -->
            <ul class="skill-list clearfix">
              <li><a href="#" class="btn btn-skill">일반/수비</a></li>
              <li><a href="#" class="btn btn-skill">패싱</a></li>
              <li><a href="#" class="btn btn-skill">드롭</a></li>
              <li><a href="#" class="btn btn-skill on">어프로치</a></li>
              <li class="mr0 so-on long-2"><a href="#" class="btn btn-skill">기타</a></li>
            </ul>
            <!-- E: skill-list -->
          </div>
          <!-- E: TECHNIC -->

          <!-- S: COURSE -->
          <div class="skill-item line-2 course">
            <!-- S: skill-list -->
            <ul class="skill-list clearfix">
              <li><a href="#" class="btn btn-skill">크로스</a></li>
              <li><a href="#" class="btn btn-skill on">스트레이트</a></li>
              <li><a href="#" class="btn btn-skill">로브</a></li>
              <li><a href="#" class="btn btn-skill">역크로스</a></li>
              <li><a href="#" class="btn btn-skill">센터</a></li>
              <li class="mr0 so-on"><a href="#" class="btn btn-skill">기타</a></li>
            </ul>
            <!-- E: skill-list -->
          </div>
          <!-- E: COURSE -->

          <!-- S: point-result -->
          <div class="skill-item line-3 point-result">
            <!-- S: win -->
            <dl class="win">
              <dt>WIN</dt>
              <dd>
                <a href="#" class="btn btn-skill">IN</a>
                <a href="#" class="btn btn-skill on">ACE</a>
              </dd>
            </dl>
            <!-- E: win -->

            <!-- S: error -->
            <dl class="error">
              <dt>ERROR</dt>
              <dd>
                <a href="#" class="btn btn-skill">NET</a>
                <a href="#" class="btn btn-skill on">OUT</a>
              </dd>
            </dl>
            <!-- E: error -->
          </div>
          <!-- E: point-result -->
        </div>
        <!-- E: enter skill-box -->

        <!-- S: btn-footer -->
        <div class="btn-footer">
          <a href="#" class="btn btn-prev">
            <span class="ic-deco"><img src="images/tournerment/public/btn-prev@3x.png" alt></span>
            <span class="txt">이전 단계</span>
          </a>
          <a href="#" class="btn btn-out" data-dismiss="modal">나가기</a>
        </div>
        <!-- E: btn-footer -->


        <!-- S: point-board -->
        <div class="point-board clearfix">
          <!-- S: ctrl-btn -->
          <div class="ctrl-btn">
            <a href="#" class="open-record">포인트기록</a>
          </div>
          <!-- E: ctrl-btn -->
          
          <!-- S: content -->
          <div class="content">
            <a href="#" class="btn btn-close"><img src="images/tournerment/public/x@3x.png" alt="닫기"></a>
            <h3>포인트 기록</h3>
            <!-- S: point-list -->
            <ul class="point-list">
              <li>
                <span class="name">최보라</span>
                <span class="serve on"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"></span>
                <span class="score me">GAME WIN</span>
                <span>F.스트로크 / </span>
                <span>어프로치 / </span>
                <span>스트레이트 / </span>
                <span>ACE</span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
              <li>
                <span class="name">최보라</span>
                <span class="serve on"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"></span>
                <span class="score you">40 : 15</span>
                <span>F.스트로크 / </span>
                <span>어프로치 / </span>
                <span>스트레이트 / </span>
                <span>ACE</span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
              <li>
                <span class="name">최보라</span>
                <span class="serve"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"></span>
                <span class="score me">30 : 15</span>
                <span>F.스트로크 / </span>
                <span>어프로치 / </span>
                <span>스트레이트 / </span>
                <span>ACE</span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
              <li>
                <span class="name">최보라</span>
                <span class="serve"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"></span>
                <span class="score you">15 : 15</span>
                <span>F.스트로크 / </span>
                <span>어프로치 / </span>
                <span>스트레이트 / </span>
                <span>ACE</span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
              <li>
                <span class="name">최보라</span>
                <span class="serve on"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt="서브"></span>
                <span class="score me">15 : 0</span>
                <span>F.스트로크 / </span>
                <span>어프로치 / </span>
                <span>스트레이트 / </span>
                <span>ACE</span>
                <a href="#" class="btn btn-modify">수정</a>
              </li>
            </ul>
            <!-- E: point-list -->
          </div>
          <!-- E: content -->
        </div>
        <!-- E: point-board -->
      </div>
      <!-- E: modal-body -->
    </div>
    <!-- E: modal-content -->
  </div>
<%End if%>




</div>
<!-- E: game-point-modal -->



<!-- S: warn-modal -->
<div class="modal fade warn-modal ipt-modal">
  <div class="modal-dialog">
    <!-- S: modal-body -->
    <div class="modal-body">
      <p><span id="sf_msg">선수를 먼저 선택해 주셔야 합니다.</span></p>
    </div>
    <!-- E: modal-body -->
  </div>
</div>
<!-- E: warn-modal -->