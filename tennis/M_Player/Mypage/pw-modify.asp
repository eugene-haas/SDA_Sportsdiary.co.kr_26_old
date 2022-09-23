<!-- #include file="../include/config.asp" -->
<script type="text/javascript">
function chk_pass(){
	if(!$('#nowpass').val()){
		alert("현재 비밀번호를 입력해 주세요.");
		$('#nowpass').focus();
		return;
	}
	if($('#nowpass').val().length<4 || $('#nowpass').val().length>12){
		alert("패스워드는 4자~12자입니다.");
		$('#nowpass').focus();
		return;
	}
	if(!$('#change_pass1').val()){
		alert("변경하실 비밀번호를 입력해 주세요.");
		$('#change_pass1').focus();
		return;
	}
	if($('#change_pass1').val().length<4 || $('#change_pass1').val().length>12){
		alert("변경하실 패스워드는 4자~12자입니다.");
		$('#change_pass1').focus();
		return;
	}
	if(!$('#change_pass2').val()){
		alert("변경하실 비밀번호 를 한번더 입력해 주세요.");
		$('#change_pass2').focus();
		return;
	}
	if($('#change_pass2').val().length<4 || $('#change_pass2').val().length>12){
		alert("변경하실 패스워드는 4자~12자입니다.");
		$('#change_pass2').focus();
		return;
	}

	if($('#change_pass1').val() != $('#change_pass2').val()){
		alert("변경하실 비밀번호가 일치하지 않습니다.");
		$('#change_pass1').val('');
		$('#change_pass2').val('');
		return;
	}

	var strAjaxUrl = "../Ajax/pw-modify_ok.asp";
	var NowPass      = $('#nowpass').val();
	var Change_Pass  = $('#change_pass1').val();

	$.ajax({
		url: strAjaxUrl,
		type: 'POST',
		dataType: 'html',
		data: {
			NowPass    : NowPass ,
			Change_Pass  : Change_Pass
		},
		success: function(retDATA) {
			if(retDATA){
				var strcut = retDATA.split("|");

				if (strcut[0]=="TRUE") {
					alert("비밀번호 변경이 완료되었습니다.");
					/*
					//비밀번호 초기화
					$('#nowpass').val('');
					$('#change_pass1').val('');
					$('#change_pass2').val('');
					*/

					$(location).attr("href", "../mypage/mypage.asp");

				}else if(strcut[1]==1){
					alert('잘못된 접근입니다.\n확인 후 이용하세요.');
					$('#nowpass').val('');
					return;
				}else if(strcut[1]==2){
					alert('변경하고자 하는 비밀번호와 현재비밀번호와 같습니다..');
					$('#nowpass').val('');
					return;
				}else{
					alert('기존 비밀번호가 일치하지 않습니다.\n확인 후 다시 이용하세요');
					$("#nowpass").val("");
					$("#nowpass").focus();
					return;
				}
			}
		},
            error: function (xhr, status, error) {
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
	});
}
</script>
<!-- E: config -->
<body class="lack-bg">

	<!-- S: sub-header -->
	<div class="sd-header sd-header-sub">
		<!-- #include file="../include/sub_header_arrow.asp" -->
		<h1>비밀번호 변경</h1>
		<%
			SELECT CASE request.Cookies("EnterType")
				CASE "E"
		%>
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <%
			'생활체육의 경우 메뉴 출력 OFF
			'생활체육 컨텐츠 사용 기획 이후 제거해야함
				CASE ELSE
		%>
        <!-- S: 로그아웃 버튼 -->
        <div class="sub-logout login-btn">
          <!-- logout start -->
          <a href="javascript:chk_logout();" role="button" class="log-out">
            <span class="link-deco"><i class="fa fa-power-off" aria-hidden="true"></i></span>
            <span class="txt">로그아웃</span>
          </a>
          <!-- logout end -->
        </div>
        <!-- E: 로그아웃 버튼 -->
    <%
			END SELECT
		%>
	</div>
	<!-- #include file = "../include/gnb.asp" -->
	<!-- E: sub-header -->


  <!-- S: sub-header -->
  <!-- <div class="sub-header flex"> -->
    <!-- S: sub_header_arrow -->
    <!-- include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <!-- <h1>비밀번호 변경</h1> -->
    <!-- S: sub_header_gnb -->
    <!-- <%
			SELECT CASE request.Cookies("EnterType")
				CASE "E"
		%> -->
    <!-- include file="../include/sub_header_gnb.asp" -->
    <!-- <%
			'생활체육의 경우 메뉴 출력 OFF
			'생활체육 컨텐츠 사용 기획 이후 제거해야함
				CASE ELSE
		%> -->
        <!-- S: 로그아웃 버튼 -->
        <!-- <div class="sub-logout login-btn"> -->
          <!-- logout start -->
          <!-- <a href="javascript:chk_logout();" role="button" class="log-out">
            <span class="link-deco"><i class="fa fa-power-off" aria-hidden="true"></i></span>
            <span class="txt">로그아웃</span>
          </a> -->
          <!-- logout end -->
        <!-- </div> -->
        <!-- E: 로그아웃 버튼 -->
    <!-- <%
			END SELECT
		%> -->
    <!-- E: sub_header_gnb -->
  <!-- </div> -->
  <!-- E: sub-header -->



  <!-- S: sub -->
  <div class="sub mypage">
		<ul class="top-list">
			<li>&middot; 패스워드는 영문,숫자 4~12자 이상 입력합니다.</li>
			<li>&middot; 패스워드 변경 후 변경한 패스워드로 로그인을 하시기 바랍니다.</li>
		</ul>
		<form>
			<fieldset>
				<legend>비밀번호 변경</legend>
				<ul class="pw-modify">
					<li>
						<p><label for="pw-01">현재 비밀번호</label></p>
						<p><input type="password" id="nowpass" maxlength="12" /></p>
					</li>
					<li>
						<p><label for="pw-02">변경할 비밀번호</label></p>
						<p><input type="password" id="change_pass1" maxlength="12" /></p>
					</li>
					<li>
						<p><label for="pw-03">변경할 비밀번호 확인</label></p>
						<p><input type="password" id="change_pass2" maxlength="12" /></p>
					</li>
				</ul>
			</fieldset>
		</form>
		<div class="container">
			<div class="btn-center">
				<a href="#" onClick="javascript:history.back(); return false;" class="btn-left">취소</a>
				<a href="javascript:chk_pass();" class="btn-right">수정</a>
			</div>
		</div>
  </div>
	<!-- E : sub -->
  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file="../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
