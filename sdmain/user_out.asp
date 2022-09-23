<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!-- #include file="./include/config.asp" -->

  <%
    '로그인체크
    Check_Login()
  %>
<script>
	function chk_onSubmit(){
		if(!$("#UserPass").val()){
			alert("비밀번호를 입력해 주세요.");
			$("#UserPass").focus();
			return;
		}

		var strAjaxUrl = "./ajax/user_out.asp";
		var UserPass = $("#UserPass").val().replace(/ /g, '');

		if(confirm("가입된 모든 회원계정이 삭제됩니다.\n회원탈퇴를 진행하시겠습니까?")){
			$.ajax({
				url: strAjaxUrl,
				type: "POST",
				dataType: "html",
				data: {
					UserPass : UserPass
				},
				success: function(retDATA) {
					var strcut = retDATA.split("|");

					if (strcut[0]=="TRUE") {
						alert("회원탈퇴가 완료되었습니다.");
						$(location).attr("href", "./bye.asp");   //a href
					}
					else{
						var msg = '';

						switch(strcut[1]){
							case "200"	: 	msg = "잘못된 접근입니다.\n확인 후 이용하세요."; break;
							case "99" 	: 	msg = "일치하는 정보가 없습니다.\n확인 후 이용하세요."; break;
							default		:	msg = "회원탈퇴가 완료되지 않았습니다.\n시스템관리자에게 문의하십시오!";
						}

						alert(msg);
						$("#UserPass").val("");
						return;
					}
				},
				error: function(xhr, status, error){
					if(error!=""){
						alert ("오류발생! - 시스템관리자에게 문의하십시오!");
						return;
					}
				}
			});
		}
		else{
			return;
		}
	}
</script>
<body>
<div class="l userOut">
  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file='./include/header_back.asp' -->
      <h1 class="m_header__tit">회원탈퇴</h1>
      <!-- #include file='./include/header_home.asp' -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <pre class="byeUserGuide">
· 통합아이디로 가입된 모든 계정의 서비스 이용기록, 개인 기록 및 정보가 삭제되며, 삭제된 데이터는 복구되지 않습니다.

· 탈퇴 이후 아이디 복구 및 동일한 아이디로 재가입은 불가능 합니다.

· 게시판 및 커뮤니티에 등록한 모든 게시물과 업로드 한 이미지 및 영상은 탈퇴 후에도 삭제되지 않으며, 삭제를 원할 경우 반드시 탈퇴 이전에 삭제해 주셔야 합니다.

· 전자상거래 등에서의 소비자보호에 관한 법률 제 6조(거래기록의 보전 등)에 의거, 거래의 주체를 식별할 수 있는 정보에 한하여 서비스 이용에 관한 동의를 철회한 경우에도 이를 보전할 수 있으며, 동법 시행령 제6조에 의거 다음과 같이 거래 기록을 보관합니다.

- 표시,광고에 관한 기록 : 6개월
- 계약 또는 청약철회 등에 관한 기록 : 5년
- 대금결제 및 재화 등의 공급에 관한 기록 : 5년
- 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년
    </pre>

    <p class="byeDate">서비스해지일자 : <%=FormatDateTime(now(),1)%></p>

    <ul class="m_combineFormList">
      <li class="m_combineFormList__item">
        <label class="m_combineFormList__inputWrap [ _inputWrap ]">
          <span class="m_combineFormList__placeholder [ _placeholder ]">비밀번호를 입력하세요.</span>
          <input id="UserPass" name="UserPass" type="password" class="m_combineFormList__input [ _input ]" />
        </label>
      </li>
    </ul>

    <div class="m_combineCont">
      <a href="javascript:chk_onSubmit();" class="m_combineCont__btn">확인</a>
    </div>
  </div>

  <!-- #include file= "./include/footer.asp" -->

</div>
<script>
  $('._input').one('focus', function(evt){
    $(this).parent().find('._placeholder').addClass('s_focus');
  });
</script>
</body>
</html>
