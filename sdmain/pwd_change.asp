<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!-- #include file="./include/config.asp"-->
  <%
    '로그인하지 않았다면 login.asp로 이동
    Check_Login()

    dim refererValue : refererValue = Request.ServerVariables("HTTP_REFERER")
  %>
  <script type="text/javascript">
  	//maxlength 체크
  	function maxLengthCheck(object){
  		if(object.value.length > object.maxLength){
  			object.value = object.value.slice(0, object.maxLength);
  		}
  	}


    function chk_onSubmit() {
          var upw = $('#nowpass').val().replace(/ /g, '');
          var upw1 = $('#change_pass1').val().replace(/ /g, '');
          var upw2 = $('#change_pass2').val().replace(/ /g, '');
          var uid = '<%=request.Cookies("SD")("UserID")%>';

  		if(!upw){
  			alert('현재 비밀번호를 입력해 주세요.');
  			upw.focus();
  			return;
  		}

  		if(!upw1){
  			alert('변경하실 비밀번호를 입력해 주세요.');
  			upw1.focus();
  			return;
  		}
  		else{
              if(upw1.length<6 || upw1.length>12){
                  alert('변경하실 비밀번호는 6~12자입니다.');
                  upw1.focus();
                  return;
              }
          }

  		if(!upw2){
  			alert('변경하실 비밀번호 를 한번더 입력해 주세요.');
  			upw2.focus();
  			return;
  		}
          else{
              if(upw2.length<6 || upw2.length>12){
                  alert('변경하실 비밀번호는 6~12자입니다.');
                  upw2.focus();
                  return;
              }
          }

  		if(upw1 != upw2){
  			alert('변경하실 비밀번호가 일치하지 않습니다.');
  			$('#change_pass1').val('');
  			$('#change_pass2').val('');
  			return;
        }

          var chk_num = upw1.search(/[0-9]/g);
          var chk_eng = upw1.search(/[a-zA-Z]/ig);

          if(chk_num < 0 || chk_eng < 0) {
              alert('비밀번호는 숫자와 영문자를 혼용하여야 합니다.');
              return;
          }

          if(/(\w)\1\1\1/.test(upw1)) {
              alert('비밀번호에 같은 문자를 4번 이상 사용하실 수 없습니다.');
              return;
          }

          if(upw1.search(uid)>-1) {
              alert('ID가 포함된 비밀번호는 사용하실 수 없습니다.');
              return;
          }


  		if(confirm("비밀번호를 변경하시겠습니까?")){

  			var strAjaxUrl = './ajax/pwd_change.asp';

  			$.ajax({
  				url: strAjaxUrl,
  				type: 'POST',
  				dataType: 'html',
  				data: {
  					NowPass        : upw
  					,Change_Pass   : upw1
  				},
  				success: function(retDATA) {
  					if(retDATA){
  						var strcut = retDATA.split('|');

  						if (strcut[0]=='TRUE') {
  							alert('비밀번호 변경이 완료되었습니다.');
                     location.href = "/sdmain/index.asp"; //루트로 보내기
  							// $(location).attr('href', '<%=refererValue%>');
  						}
  						else{
                              var msg = '';

                              switch(strcut[1]){
                                  case '99' : msg = alert('일치하는 정보가 없습니다. 확인 후 이용하세요.'); $('#nowpass').val(''); $('#nowpass').focus(); break;
                                  case '66' : msg = alert('비밀번호 변경에 실패하였습니다. 관리자에게 문의하세요.'); break;
                                  case '33' : msg = alert('변경하고자 하는 비밀번호와 현재비밀번호와 같습니다.'); $('#change_pass1').val(''); $('#change_pass2').val(''); break;
                                  default   : msg = alert('잘못된 접근입니다. 확인 후 이용하세요.'); $('#nowpass').val(''); $('#change_pass1').val(''); $('#change_pass2').val('');   //200
                              }
  						}
  					}
  				},
  				error: function(xhr, status, error){
  					if(error!=''){
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
</head>
<body>
<div class="l">

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="./include/header_back.asp" -->
      <h1 class="m_header__tit">비밀번호 변경</h1>
      <!-- #include file="./include/header_home.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_combineHeader">
      <p class="m_combineHeader__txt">
        비밀 번호 변경을 위해 현재 비밀번호 확인 후<br>
        새로운 비밀번호를 입력해 주세요.
      </p>
    </div>

    <ul class="m_combineFormListB">
      <li class="m_combineFormListB__item">
        <div class="m_combineFormListB__inputWrap">
          <input type="password" name="nowpass" id="nowpass" placeholder="현재 비밀번호" class="m_combineFormListB__input" style="ime-mode:disabled;text-transform:lowercase;" />
        </div>
      </li>
      <li class="m_combineFormListB__item">
        <div class="m_combineFormListB__inputWrap">
          <input type="password" name="change_pass1" id="change_pass1" class="m_combineFormListB__input"  placeholder="새 비밀번호 6~12자 영문과 숫자 조합" maxlength="12" style="ime-mode:active;" oninput="maxLengthCheck(this);" />
        </div>
      </li>
      <li class="m_combineFormListB__item">
        <div class="m_combineFormListB__inputWrap">
          <input type="password" name="change_pass2" id="change_pass2" class="m_combineFormListB__input"  placeholder="새 비밀번호 확인 6~12자 영문과 숫자 조합" maxlength="12" style="ime-mode:active;" oninput="maxLengthCheck(this);" />
        </div>
      </li>
    </ul>

    <div class="m_combineCont">
      <a href="javascript:chk_onSubmit();" class="m_combineCont__btn"> 비밀번호 변경</a>
    </div>
  </div>

  <!-- #include file='./include/footer.asp' -->

</div>
</body>
</html>
