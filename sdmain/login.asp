  <!--#include file="./include/config.asp"-->
<%
'	Call Response.AddHeader("Access-Control-Allow-Origin", "http://img.sportsdiary.co.kr/")
	Call Response.AddHeader("Access-Control-Allow-Origin", "*")
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <%
  '    IF mid(trim(Request.ServerVariables("REMOTE_ADDR")),1,14) = "118.33.86.240" Then
  '        response.write "txtReferer="&txtReferer
  '    End IF

      '로그인 되었다면 초기 진입화면[index.asp]으로 이동
      'index.asp - 유도메인으로 설정
      Check_NoLogin()

      '로그인 후 리턴 페이지
      dim txtReferer  : txtReferer = Request.ServerVariables("HTTP_REFERER")


	  If InStr(txtReferer, "judo.") > 0  Then
		txtReferer = "http://judo.sportsdiary.co.kr/M_Player/Main/index.asp"
	  Else
		txtReferer = "http://sdmain.sportsdiary.co.kr/sdmain/index.asp"
	  End If




  %>
  <script type="text/javascript">
  	var txtReferer = '<%=txtReferer%>';

      //푸시관련 기기식별자 자동등록처리
      function REG_IDENTITY(valID){
        /*
        var strAjaxUrl = './ajax/SET_Identity.asp';

          $.ajax({
            url: strAjaxUrl,
            type: 'POST',
            dataType: 'html',
            data: {},
            success: function(retDATA) {

              console.log(retDATA);

              if(retDATA=='TRUE'){
                //alert(retDATA);
                alert('sportsdiary://setIdentity?id='+valID);    //기기식별자 등록처리
                //alert('식별자를 등록하였습니다.');
              }
              else{/*FALSE
                alert('sportsdiary://setIdentity?id='+valID);    //기기식별자 등록처리
              }
            },
            error: function(xhr, status, error){
              if(error!=''){
                alert ('오류발생! - 시스템관리자에게 문의하십시오!');
                return;
              }
            }
          });
        */

        alert('sportsdiary://setIdentity?id='+valID);    //기기식별자 등록처리
      }

  	//통합관리자 로그인
  	function chk_login(){

  	 	//자동로그인 체크시 쿠키저장
  		var saveid = '';

  		if(!$('#UserID').val()){
  			alert('아이디를 입력해 주세요.');
  			$('#UserID').focus();
  			return;
  		}

  		if(!$('#UserPass').val()){
  			alert('비밀번호를 입력해 주세요.');
  			$('#UserPass').focus();
  			return;
  		}

      var strAjaxUrl = './ajax/Login_OK.asp';
  		var UserID = $('#UserID').val().replace(/ /g, '');		//공백제거 .replace(/ /g, '')
  		var UserPass = $('#UserPass').val().replace(/ /g, '');  //공백제거 .replace(/ /g, '')

  		if($('input:checkbox[id=saveid]').is(':checked') == true) saveid = 'Y';

  		//console.log(txtReferer);

  		$.ajax({
  			url: strAjaxUrl,
  			type: 'POST',
  			dataType: 'html',
  			data: {
  				UserID    	: UserID
  				,UserPass   : UserPass
  				,saveid   	: saveid
  			},
  			success: function(retDATA) {

  				//console.log(retDATA);

  				if(retDATA){

  					var strcut = retDATA.split('|');

  					if(strcut[0] == 'TRUE') {

              //푸시관련 기기식별자등록처리
              REG_IDENTITY(UserID);

              /*
  						회원통합으로 유도회원DB를 통합회원 DB로 복사하였기때문에 통합회원DB[SD_Member.dbo.tblMember]에 1개 이상의 계정이 있을 경우
  						통합ID설정 페이지로 이동하여 통합설정 후 1개 계정만 남기고 삭제처리합니다.
  						SD_Member.dbo.tblMember 가입계정 카운트 [chk_User]
  						*/

  						if(strcut[1] > 1){    //통합설정페이지로 이동합니다.
  							$('#UserName').val(strcut[2]);
  							$('#UserBirth').val(strcut[3]);

  							$('form[name=s_frm]').attr('action','./total_id_sel.asp');
  							$('form[name=s_frm]').submit();
  						}
  						else{    //통합회원 설정이 된 경우는 리턴페이지로 이동합니다.
                if(txtReferer) $(location).attr('href', txtReferer);
  							else $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/index.asp');
  						}
  					}
  					else{
  						var msg='';

  						switch(strcut[1]){
  							case '99'	: msg='일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
  							default		: msg='잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
  						}

  						$('#UserID').val('');
  						$('#UserPass').val('');
  						$('#UserID').focus();

  						alert(msg);
  						return;
  					}
  				}
  			},
  			error: function(xhr, status, error){
  				if(error!=''){
  					alert ('오류발생! - 시스템관리자에게 문의하십시오!');
  					return;
  				}
  			}
  		});
  	}
  </script>
</head>
<body>
<div class="l login">
  <form name="s_frm" id="s_frm" method="post">
    <input type="hidden" name="UserName" id="UserName"  />
    <input type="hidden" name="UserBirth" id="UserBirth" />
    <input type="hidden" name="txtReferer" id="txtReferer" value="<%=txtReferer%>" />
  </form>

  <!-- <div class="l_content m_scroll login [ _content _scroll ]"> -->
  <div class="l_content m_scroll login [ _content _scroll ]">


    <div class="m_combineHeader">
      <div class="m_combineHeader__logoWrap"><img src="./images/sd_logo__origin.png" class="m_combineHeader__img" alt="스포츠다이어리"></div>
    </div>

    <ul class="m_combineFormList">
      <li class="m_combineFormList__item">
        <label class="m_combineFormList__inputWrap [ _inputWrap ]">
          <span class="m_combineFormList__placeholder [ _placeholder ]">아이디를 입력하세요</span>
          <input type="text" id="UserID" name="UserID" class="m_combineFormList__input [ _input ]" style="ime-mode:disable;text-transform:lowercase;" tabindex="1">
        </label>
      </li>
      <li class="m_combineFormList__item">
        <label class="m_combineFormList__inputWrap [ _inputWrap ]">
          <span class="m_combineFormList__placeholder [ _placeholder ]">비밀번호를 입력하세요</span>
          <input type="password" id="UserPass" name="UserPass" class="m_combineFormList__input [ _input ]" tabindex="2">
        </label>
      </li>
    </ul>

    <div class="savedId">
      <input type="checkbox" name="saveid" id="saveid" class="savedId__checkbox" hidden checked >
      <label class="savedId__labelTxt" for="saveid">자동 로그인</label>
      <svg class="savedId__checkSVG" version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
        <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
      </svg>
    </div>

    <ul class="subLinkList">
      <li class="subLinkList__item"><a href="./fnd_pwd.asp" class="subLinkList__link" tabindex="6">비밀번호 찾기</a></li>
      <li class="subLinkList__item"><a href="./fnd_id.asp" class="subLinkList__link" tabindex="5">아이디 찾기</a></li>
      <li class="subLinkList__item"><a href="./combine_check.asp" class="subLinkList__link" tabindex="7">회원가입</a></li>
    </ul>

    <div class="m_combineCont">
      <a href="javascript:chk_login();" class="m_combineCont__btn" tabindex="3">로그인</a>
      <a href="./index.asp" class="m_combineCont__btn s_home" tabindex="4">홈으로</a>
    </div>
  </div>

  <!-- #include file='./include/footer.asp' -->

</div>

<script>
  // WholeAgree.start('.id_check'); // 개인 정보 제공 동의 체크 박스
  $('._input').one('focus', function(evt){
    $(this).parent().find('._placeholder').addClass('s_focus');
  });
  $('#UserID').focus();
</script>
</body>
</html
