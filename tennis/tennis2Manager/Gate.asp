<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
<title>스포츠다이어리 테니스 관리자 로그인</title>
</head>
<!-- #include virtual = "/pub/html/tennisAdmin/html.head.asp" -->

<%

'Response.Write CONST_BODY
 %>
<body class="gateBg" <%=CONST_BODY%>>
  <form name="login_frm" method="post">
    <div class="gateform">
      <h1><img src="/Images/logo_admin_top.png" alt="스포츠 다이어리 어드민"></h1>
      <div class="login">
        <h2><img src="/Images/tit_login.png" alt="Sports Diary ADMIN LOGIN"></h2>
        <fieldset>
          <legend>로그인</legend>
          <ul>
            <li class="idpw">
              <label for="id">User ID</label>
              <div class="keep">
                <input type="checkbox" name="saveid" id="saveid" onclick="chk_saveid();">
                <label for="saveid">아이디저장</label>
              </div>
              <input type="text" id="id" class="input" name="UserID" style="ime-mode:disabled;" onkeydown="if(event.keyCode==13){chk_login();}" required="">
            </li>
            <li class="idpw">
              <label for="pw">Password</label>
              <input type="password" id="pw" class="input" name="UserPass" onkeydown="if(event.keyCode==13){chk_login();}" required="">
            </li>
            <li class="btn-login"><a href="index.asp"><img src="/images/btn_sign_in.png" alt="로그인"></a></li>
          </ul>
          <p class="login-txt">아이디 비밀번호 분실시 전화문의 ( 010-3619-1169 )</p>
        </fieldset>
        </div>
        <div class="copy">
          <p>Copyright © <strong>WIDLINE</strong> All Rights Reserved.</p>
        </div>
      
    </div>
  </form>
</body>
</html>