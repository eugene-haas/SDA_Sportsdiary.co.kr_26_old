      <!-- S: intro-bg -->
      <div class="intro-bg">

		<!-- S: login-form -->
		<form action="/" method="post">
          <fieldset class="clrFix" id="DP_Login"  <%If ck_id <> "" then%>style="display:none;"<%End if%>>
            <legend class="sr-only">로그인 영역</legend>
            <ul class="login-input">
              <li>
                <input type="text" placeholder="아이디" maxlength="20" aria-required="true" aria-invalid="false" id="UserID">
              </li>
              <li>
                <input type="password" placeholder="비밀번호" maxlength="20" aria-required="true" aria-invalid="false" id="UserPass">
              </li>
            </ul>
			<a href="javascript:mx.login()" class="btn login-btn" role="button">로그인</a>
            <p class="login-guide">
              아이디, 비밀번호 분실시 해당 경기 위원장에게 문의하세요.
            </p>
          </fieldset>
        </form>
        <!-- E: login-form -->

		<!-- S: logout-form -->
        <div class="logout-form" id="DP_Logout" <%If ck_id = "" then%>style="display:none;"<%End if%>>
          <a href="javascript:mx.SendPacket(null, {'CMD':mx.CMD_LOGOUT});" class="logout-main">
            <span class="ic-deco"><i class="fa fa-power-off" aria-hidden="true"></i></span>
            <span class="txt">로그아웃</span>
          </a>
        </div>
        <!-- E: logout-form -->


        <ul class="menu-intro clearfix">
          <li>
            <a href="javascript:mx.SendPacket(null, {'CMD':mx.CMD_LOGCHECK,'NO':1});" class="menu-btn">
              <span class="icon">
                <img src="images/tournerment/intro/btn-intro1@3x.png" alt width="61" height="61">
              </span>
              <span>경기스코어 입력</span>
            </a>
          </li>
          <li>
            <a href="javascript:mx.SendPacket(null, {'CMD':mx.CMD_LOGCHECK,'NO':2});" class="menu-btn">
              <span class="icon">
                <img src="images/tournerment/intro/btn-intro2@3x.png" alt width="53" height="64">
              </span>
              <span>대회별 결과 보기</span>
            </a>
          </li>
          <li>
            <a href="javascript:mx.SendPacket(null, {'CMD':mx.CMD_LOGCHECK,'NO':3});" class="menu-btn">
              <span class="icon">
                <img src="images/tournerment/intro/btn-intro3@3x.png" alt width="61" height="61">
              </span>
              <span>경기운영본부</span>
            </a>
          </li>
          <li>
            <a href="javascript:mx.SendPacket(null, {'CMD':mx.CMD_LOGCHECK,'NO':4});" class="menu-btn">
            <span class="icon">
              <img src="images/tournerment/intro/btn-intro4@3x.png" alt width="71" height="57">
            </span>
            <span>경기 기록실</span>
            </a>
          </li>
        </ul>
        <h2>
          <img src="images/tournerment/intro/logo@3x.png" alt="스포츠 다이어리" width="182">
        </h2>
      </div>
      <!-- E: intro-bg -->
