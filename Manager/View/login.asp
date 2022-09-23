<!--#include virtual="/Manager/Common/common_header.asp"-->

<script type="text/javascript">
//통합관리자 로그인
function chk_login(){
	var f = document.login_frm;
	if(f.Userid.value==""){
		alert("사용자 아이디를 입력해 주세요");
		f.Userid.focus();
		return false;
	}
	if(f.UserPwd.value==""){
		alert("사용자 패스워드를 입력해 주세요");
		f.UserPwd.focus();
		return false;
	}
	if(f.Uni_Grp_Cd.value==""){
		alert("업체코드를 입력해 주세요.");
		f.Uni_Grp_Cd.focus();
		return false;
	}

	//아이디저장 체크
	if(f.saveid.checked){
			chk_saveid();
	 }
	//f.target = "iSQL"
	f.action = "login_ok.asp"
	f.submit();
}

//체크박스 클릭시
function chk_saveid() {
	var f = document.login_frm;
  var expdate = new Date();
  // 30일동안 아이디 저장 
  if (f.saveid.checked)
    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
  else
    expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
  setCookie("icbiz_saveid", f.Userid.value, expdate);
}

//폼 로드시 쿠키 아이디 가지고 오기
function chk_getid() {
	var f = document.login_frm;
  f.saveid.checked = ((f.Userid.value = getCookie("icbiz_saveid")) != "");
}

//쿠키 정보 가지고 오기
function getCookie(Name) {
  var search = Name + "="
  if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
    offset = document.cookie.indexOf(search)
    if (offset != -1) { // 쿠키가 존재하면
      offset += search.length
      // set index of beginning of value
      end = document.cookie.indexOf(";", offset)
      // 쿠키 값의 마지막 위치 인덱스 번호 설정
      if (end == -1)
        end = document.cookie.length
      return unescape(document.cookie.substring(offset, end))
    }
  }
  return "";
}
//쿠키정보 저장
function setCookie (name, value, expires) {
  document.cookie = name + "=" + escape (value) +
    "; path=/; expires=" + expires.toGMTString();
}

</script>
</head>

<body class="gateBg" onload="chk_getid();">
	<form name="login_frm" method="post">
		<div class="gateform">
			<h1><img src="../Images/logo_admin_top.png" alt="스포츠 다이어리 어드민" /></h1>
			<div class="login">
				<h2><img src="../Images/tit_login.png" alt="Sports Diary ADMIN LOGIN" /></h2>
				<fieldset>
					<legend>로그인</legend>
					<ul>
						<li class="idpw">
							<label for="id">User ID</label>
							<div class="keep">
								<input type="checkbox" name="saveid" id="saveid" onclick="chk_saveid();" >
								<label for="saveid">아이디저장</label>
							</div>
							<input type="text" id="id" class="input" name="Userid" style="ime-mode:disabled;" onKeyDown="if(event.keyCode==13){chk_login();}" required />
						</li>
						<li class="idpw">
							<label for="pw">Password</label>
							<input type="password" id="pw" class="input" name="UserPwd" onKeyDown="if(event.keyCode==13){chk_login();}" required />
						</li>
						</li>
						<!--//<li class="error">아이디 또는 비밀번호를 다시 확인하세요.</li>-->
						<li class="btn-login"><img src="../images/btn_sign_in.png" alt="로그인" onclick="chk_login();" /></li>
					</ul>
					<p class="login-txt">아이디 비밀번호 분실시 전화문의 ( 02-235-1234 )</p>
				</div>
				<div class="copy">
					<p>Copyright &copy; <strong>WIDLINE</strong> All Rights Reserved.</p>
				</div>
			</fieldset>
		</div>
	</form>
</body>
</html>
