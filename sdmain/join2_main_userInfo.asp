<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!-- #include file='./include/config.asp' -->
  <%
    '로그인이 되어있다면 메인페이지 이동
    Check_NoLogin()

    dim sd_terms    	: sd_terms        = fInject(Request("sd_terms"))                 '이용약관
    dim privacy_terms : privacy_terms   = fInject(Request("privacy_terms"))            '개인정보 처리방침
    dim data_terms    : data_terms      = fInject(Request("data_terms"))               '개인훈련 데이터 정보열람 활용
    dim market_terms  : market_terms    = fInject(Request("market_terms"))             '마케팅 정보수신동의
    dim UserName      : UserName        = fInject(Request("UserName"))
    dim UserBirth     : UserBirth       = decode(fInject(Request("UserBirth")), 0)

    ' sd_terms = "on"
    ' privacy_terms = "on"
    ' data_terms = "on"
    ' market_terms = "on"
    ' UserName = "김우람"
    ' UserBirth = "19990101"

    IF sd_terms = "" OR privacy_terms = "" OR data_terms = "" Then
       Response.Write "<script>alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.'); history.back();</script>"
       Response.End
    End If
  %>
  <script type="text/javascript">

  	//maxlength 체크
  	function maxLengthCheck(object){
  		if(object.value.length > object.maxLength){
  			object.value = object.value.slice(0, object.maxLength);
  		}
  	}

  	//입력값 체크
  	//영문[Eng], 숫자[Digit], 영문or숫자[EngDigit]
  	function chk_InputValue(obj, valType){
  		var regexp = '';
  		var msg = '';

  		switch(valType){
  			case 'Digit'		: regexp = /[^0-9]/gi;			msg = '숫자만 입력하세요.';	break;
  			case 'Eng'			: regexp = /[^a-zA-Z]/gi; 		msg = '영문만 입력하세요.'; break;
  			case 'EngSpace'		: regexp = /[^a-zA-Z\s]+$/gi; 	msg = '영문(공백포함)만 입력하세요.'; break;
  			case 'EngDigit'		: regexp = /[^a-z0-9]/gi; 		msg = '영문 또는 숫자를 입력하세요.'; break;
  			default				: regexp = /[^0-9]/gi;			msg = '숫자만 입력하세요.';
  		}

  		if(regexp.test($('#'+obj.id).val())){
  			alert(msg);
  			$('#'+obj.id).focus();
  			$('#'+obj.id).val($('#'+obj.id).val().replace(regexp,''));
  			return;
  		}
  	}


  	//회원가입항목 체크
  	function chk_Submit(){
  		if(!$('#UserID').val()){
  			alert('사용하실 아이디를 입력해 주세요.');
  			$('#UserID').focus();
  			return;
  		}
  		else{
  			if($('#UserID').val().length<6 || $('#UserID').val().length>12){
  				alert('아이디는 6자~12자입니다.');
  				$('#UserID').focus();
  				return;
  			}
  		}

  		if($('#ID_CheckYN').val()=='N'){
  			alert('사용하실 아이디 중복확인을 진행해 주세요.');
  			$('#UserID').focus();
  			return;
  		}
  		else{
  			if($('#UserID').val() != $('#Hidden_UserID').val()) {
  				alert('아이디가 변경되었습니다. 아이디 중복확인을 다시 진행해주세요.');
  				$('#UserID').focus();
  				$('#ID_CheckYN').val('N');
  				return;
  			}
  		}

  		//비밀번호 체크
  		if($('#UserPass').val().length<6 || $('#UserPass').val().length>12){
  			alert('비밀번호는 6~12자 영문과 숫자 조합입니다.');
  			$('#UserPass').focus();
  			return;
  		}

  		//비밀번호확인
  		if($('#UserPassRe').val().length<6 || $('#UserPassRe').val().length>12){
  			alert('비밀번호는 6~12자 영문과 숫자 조합입니다.');
  			$('#UserPassRe').focus();
  			return;
  		}

  		//비밀번호동일체크
  		if($('#UserPass').val()!=$('#UserPassRe').val()){
  			alert('비밀번호가 일치하지 않습니다.');
  			$('#UserPass').focus();
  			return;
  		}

          var upw = $('#UserPass').val().replace(/ /g, '');
          var uid = $('#UserID').val().replace(/ /g, '');

          var chk_num = upw.search(/[0-9]/g);
          var chk_eng = upw.search(/[a-zA-Z]/ig);

          if(chk_num < 0 || chk_eng < 0) {
              alert('비밀번호는 숫자와 영문자를 혼용하여야 합니다.');
              return;
          }

          if(/(\w)\1\1\1/.test(upw)) {
              alert('비밀번호에 같은 문자를 4번 이상 사용하실 수 없습니다.');
              return;
          }

          if(upw.search(uid)>-1) {
              alert('ID가 포함된 비밀번호는 사용하실 수 없습니다.');
              return;
          }

  		//성별체크
  		if(!$('input:radio[name=gender-type]').is(':checked')){
  			alert('성별을 선택해 주세요.');
  			$('#gender-type').focus();
  			return;
  		}

  		//휴대폰번호체크
  		if(!$('#UserPhone1').val()){
  			alert('휴대폰 번호를 선택해 주세요.');
  			$('#UserPhone1').focus();
  			return;
  		}

  		if(!$('#UserPhone2').val()){
  			alert('휴대폰 번호를 입력해 주세요.');
  			$('#UserPhone2').focus();
  			return;
  		}

  		if(!$('#UserPhone3').val()){
  			alert('휴대폰 번호를 입력해 주세요.');
  			$('#UserPhone3').focus();
  			return;
  		}

  		//SMS인증체크
  		if($('#Hidden_SMS').val()=='N'){
  			alert('휴대폰 인증을 진행해 주세요.');
  			$('#sms_button').focus();
  			return;
  		}

  		//SMS인증 후 휴대폰 번호가 변경되었는지 검증
  		if($('#UserPhone1').val()!=$('#Hidden_UserPhone1').val()){
  			alert('휴대폰 번호가 변경되었습니다. 재인증을 받아주세요.');
  			return;
  		}

  		if($('#UserPhone2').val()!=$('#Hidden_UserPhone2').val()){
  			alert('휴대폰 번호가 변경되었습니다. 재인증을 받아주세요.');
  			return;
  		}

  		if($('#UserPhone3').val()!=$('#Hidden_UserPhone3').val()){
  			alert('휴대폰 번호가 변경되었습니다. 재인증을 받아주세요.');
  			return;
  		}

          /*
  		//이메일체크
  		if(!$('#UserEmail1').val()){
  			alert('이메일을 입력해 주세요');
  			$('#UserEmail1').focus();
  			return;
  		}

  		if(!$('#UserEmail2').val()){
  			alert('이메일을 입력해 주세요');
  			$('#UserEmail2').focus();
  			return;
  		}

          var regex=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;

          if($('#UserEmail1').val() || $('#UserEmail2').val()){
              var email = $('#UserEmail1').val().replace(/ /g, '') +'@' + $('#UserEmail2').val().replace(/ /g, '');

              if(!regex.test(email)){
                  alert('잘못된 이메일 형식입니다.\n\n입력된 이메일을 확인해주세요');
                  return;
              }
          }

  		//주소체크
  		if(!$('#ZipCode').val()){
  			alert('주소를 입력해 주세요');
  			return;
  		}

  		if(!$('#UserAddr').val()){
  			alert('주소를 입력해 주세요');
  			return;
  		}

  		if(!($('#AgreeSMS').is(':checked'))){
  			alert('휴대폰 수신동의에 동의해 주세요.');
  			$('#AgreeSMS').focus();
  			return;
  		}

  		if(!($('#AgreeEmail').is(':checked'))){
  			alert('이메일 수신동의에 동의해 주세요.');
  			$('#AgreeEmail').focus();
  			return;
  		}
          */

  		//휴대폰인증이 끝났다면 휴대폰 번호 변경이 되었는지 체크
  		if($('#Hidden_SMS').val()=='Y'){
  			var a = $('#UserPhone1').val() + $('#UserPhone2').val() + $('#UserPhone3').val();
  			var b = $('#Hidden_UserPhone1').val() + $('#Hidden_UserPhone2').val() + $('#Hidden_UserPhone3').val();

  			if(a!=b){	//휴대폰번호가 변경이 됐다면 재진행
  				alert('휴대폰 번호가 변경되었습니다.\n다시 인증절차를 진행해주세요');
  				$('#Hidden_SMS').val('N');
  				$('#Auth_Num').val('');
  				$('#Re_Auth_Num').val('');
  				return;
  			}
      }



  		//alert($('input:radio[name=gender-type]:checked').val());

  		var strAjaxUrl 		= './ajax/join_OK.asp';
  		var UserID        	= $('#UserID').val();
  		var UserPass      	= $('#UserPass').val().replace(/ /g, '');
  		var UserName      	= $('#UserName').val();
  		var UserEnName     	= $('#UserEnName').val();
  		var UserBirth     	= $('#UserBirth').val();
  		var UserPhone 		= $('#UserPhone1').val() + '-' + $('#UserPhone2').val() + '-' + $('#UserPhone3').val();
  		var SEX           	= $('input:radio[name=gender-type]:checked').val();

          /*
  		var UserEmail       = $('#UserEmail1').val().replace(/ /g, '') + '@' + $('#UserEmail2').val().replace(/ /g, '');
  		var ZipCode       	= $('#ZipCode').val();
  		var UserAddr      	= $('#UserAddr').val();
  		var UserAddrDtl   	= $('#UserAddrDtl').val();
          */

  		var SmsYn='';
  		//var EmailYn='';

  		if($('#AgreeSMS').is(':checked')) SmsYn = 'Y';
  		else SmsYn = 'N';

          /*
  		if($('#AgreeEmail').is(':checked')) EmailYn = 'Y';
  		else EmailYn = 'N';
          */



  		$.ajax({
  			url: strAjaxUrl,
  			type: 'POST',
  			dataType: 'html',
  			data: {
  				UserID			: UserID,
          UserPass		: UserPass,
          UserName		: UserName,
          UserEnName		: UserEnName,
          UserPhone		: UserPhone,
          UserBirth		: UserBirth,
          SEX       		: SEX,
          SmsYn   		: SmsYn
                  /*
  				,UserEmail 		: UserEmail
  				,EmailYn		: EmailYn
  				,ZipCode    	: ZipCode
  				,UserAddr   	: UserAddr
  				,UserAddrDtl	: UserAddrDtl
                  */
  			},
  			success: function(retDATA) {

  				console.log(retDATA);

  				if(retDATA){
  					var strcut = retDATA.split('|');

            if (strcut[0] == 'TRUE') {

              var date2 = new Date();
              var iy = date2.getFullYear();
              var im = date2.getMonth() + 1;
              var id = date2.getDate();

              var iff = iy + '-' + im + '-' + id;

              alert('※ 수신동의안내\n\n 처리자 : 스포츠다이어리 \n 동의일시 : ' + iff + ' \n 처리내용 : 수신 동의 처리 완료되었습니다.\n 설정> 마이페이지> 앱 알림 수신설정에서 변경 가능합니다.');
  					  $(location).attr('href', './join3_main_complete.asp');
  					}
  					else{
  						switch(strcut[1]) {
  							case '99' 	: msg = '이미 가입된 회원정보입니다.\n확인 후 다시 이용하세요.'; break;
  							case '66' 	: msg = '회원가입에 실패하였습니다.\n관리자에게 문의하세요.'; break;
  							default		: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
  						}

  						alert(msg);
  						return;
  					}
  				}
  			},
  			error: function(xhr, status, error){
  				if(error){
  					alert('오류발생! - 시스템관리자에게 문의하십시오!');
  					return;
  				}
  			}
  		});
  	}

  	//아이디중복체크
  	function chk_id(){
  		if(!$('#UserID').val()){
  			alert('사용하실 아이디를 입력해 주세요.');
  			$('#UserID').focus();
  			return;
  		}

  		if($('#UserID').val().length<6 || $('#UserID').val().length>12){
  			alert('아이디는 6자~12자입니다.');
  			$('#UserID').focus();
  			return;
  		}
  		else{
  			// /[0-9]|[^\!-z]/gi 영문만
  			// /[^a-z0-9]/gi 영문+ 숫자
  			var regexp = /[^a-z0-9]/gi;

  			if(regexp.test($('#UserID').val())){
  				alert('영문 + 숫자만 입력 가능합니다.');
  				$('#UserID').focus();
  				$('#UserID').val($('#UserID').val().replace(/[^a-z0-9]/gi,''));
  				return;
  			}
  		}

  		//중복확인체크
  		if($('#UserID').val()){
  			var strAjaxUrl = './ajax/Check_Overlap_ID.asp';
  			var UserID  = $('#UserID').val();

  			$.ajax({
  				url: strAjaxUrl,
  				type: 'POST',
  				dataType: 'html',
  				data: {
  					UserID : UserID
  				},
  				success: function(retDATA) {
  					if(retDATA){
  						//alert(retDATA);
  						if (retDATA=='TRUE') {
  							if(confirm('['+$('#UserID').val()+']를 사용하시겠습니까?')){
  								$('#Hidden_UserID').val($('#UserID').val());
  								$('#ID_CheckYN').val('Y');
  								$('#UserPass').focus();
  							}
  							else{
  								$('#UserID').val('');
  								$('#Hidden_UserID').val('');
  								$('#ID_CheckYN').val('N');
  								$('#UserID').focus();
  							}
  						}
  						else{
  							alert('이미 사용중인 아이디입니다.');
  							$('#UserID').val('');
  							$('#Hidden_UserID').val('');
  							$('#ID_CheckYN').val('N');
  							$('#UserID').focus();
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
  	}

  	//이메일 도메인 선택입력
  	function chk_Email(){
  		if(!$('#EmailList').val()){
  			$('#UserEmail2').val('');
  		}
  		else{
  			$('#UserEmail2').val($('#EmailList').val());
  		}
  	}

  	//인증번호 체크
  	function chk_Auth_Num(){
  		if(!$('#Re_Auth_Num').val()){
  			alert('인증번호를 입력해 주세요.');
  			$('#Re_Auth_Num').focus();
  			return;
  		}
  		else{
  			var a = $('#Auth_Num').val();
  			var b = $('#Re_Auth_Num').val();

  			// $('#chk_Agree').text('');
  			// $('#chk_Agree').hide();




  			if(a!=b){
  				alert('휴대폰 인증이 실패하였습니다.\n다시 확인해주세요.');
  				$('#Hidden_SMS').val('N');
  				//$('#Auth_Num').val('');
  				$('#Re_Auth_Num').val('');
  			}
  			else{
  				alert('휴대폰 인증이 완료되었습니다.');
  				$('#CHK_REAUTH').hide();
  				$('#Hidden_SMS').val('Y');

// !@
          $('#Chk_SMS').text('인증완료');
          $('#Chk_SMS').removeAttr('href')
  			}
  		}
  	}

  	//SMS인증
  	function Chk_SMS(){
  		//휴대폰번호체크
  		if(!$('#UserPhone1').val()){
  			alert('휴대폰 번호를 선택해 주세요.');
  			$('#UserPhone1').focus();
  			return;
  		}

  		if(!$('#UserPhone2').val()){
  			alert('휴대폰 번호를 입력해 주세요.');
  			$('#UserPhone2').focus();
  			return;
  		}

  		if(!$('#UserPhone3').val()){
  			alert('휴대폰 번호를 입력해 주세요.');
  			$('#UserPhone3').focus();
  			return;
  		}

  		//휴대폰인증체크 여부
  		if($('#Hidden_SMS').val()=='N'){
  			//인증진행
  			var strAjaxUrl = './ajax/Check_AuthNum.asp';
  			var UserPhone1 = $('#UserPhone1').val();
  			var UserPhone2 = $('#UserPhone2').val();
  			var UserPhone3 = $('#UserPhone3').val();

  			$.ajax({
  				url: strAjaxUrl,
  				type: 'POST',
  				dataType: 'html',
  				data: {
  					UserPhone1   : UserPhone1,
            UserPhone2   : UserPhone2,
            UserPhone3   : UserPhone3
  				},
  				success: function(retDATA) {

  					if(retDATA){
  						var strcut = retDATA.split('|');
  						if (strcut[0]=='TRUE') {

  							$('#Auth_Num').val(strcut[1]);
  							//$('#Re_Auth_Num').val(strcut[1]); //테스트인증

  							$('#Hidden_UserPhone1').val(strcut[2]);
  							$('#Hidden_UserPhone2').val(strcut[3]);
  							$('#Hidden_UserPhone3').val(strcut[4]);

  							$('#CHK_REAUTH').show();
  							// $('#chk_Agree').show();
  							// $('#chk_Agree').text('※ 인증번호가 발송되었습니다.');
                alert('인증번호가 발송 되었습니다.\n통신사 사정에 따라 최대 1분이 소요될 수 있습니다.');

                $('#Chk_SMS').text('다시받기');
  							$('#Re_Auth_Num').focus();




  						}
  						else{
  							alert('인증번호가 발송되지 않았습니다.\n휴대폰 번호를 확인해 주세요');
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
  	}


  	$(document).on('change', '#UserPhone1', function(){
  		$('#UserPhone2').focus();
  	});

    $(document).ready(function(){
        var AgreeSMS = '<%=market_terms%>';

        if(AgreeSMS=='on') {
            $('#AgreeSMS').attr('checked', true);
            $('.ic_check').addClass('on')

        }
        else {
            $('#AgreeSMS').attr('checked', false);
            $('.ic_check').removeClass('on')
        }
    });
  </script>
</head>
<body>
<div class="l">

  <!--S: 다음 주소찾기 API-->
  <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
  <div id="wrap" style="display: none; border:1px solid #000; width:95%; height:100%; margin:0px 0; position: absolute; z-index:1000; margin-top: -100px;"> <img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style=" width:17px;cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onClick="foldDaumPostcode()" alt="접기 버튼"> </div>

  <script>
      // 우편번호 찾기 찾기 화면을 넣을 element
      var element_wrap = document.getElementById('wrap');
      // 주소 넣을 element
      var userAddr = document.getElementById("UserAddr");

      function foldDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_wrap.style.display = 'none';
        userAddr.style.display = "none";
      }

      function execDaumPostCode() {
          // 현재 scroll 위치를 저장해놓는다.
          var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
          new daum.Postcode({
              oncomplete: function(data) {
                  // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                  // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                  // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                  var fullAddr = data.address; // 최종 주소 변수
                  var extraAddr = ''; // 조합형 주소 변수

                  // 기본 주소가 도로명 타입일때 조합한다.
                  if(data.addressType === 'R'){
                      //법정동명이 있을 경우 추가한다.
                      if(data.bname !== ''){
                          extraAddr += data.bname;
                      }
                      // 건물명이 있을 경우 추가한다.
                      if(data.buildingName !== ''){
                          extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                      }
                      // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                      fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                  }

                  // 우편번호와 주소 정보를 해당 필드에 넣는다.
                  document.getElementById('ZipCode').value = data.zonecode; //5자리 새우편번호 사용
                  document.getElementById('UserAddr').value = fullAddr;
                  document.getElementById('UserAddrDtl').focus();


                  // iframe을 넣은 element를 안보이게 한다.
                  // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                  element_wrap.style.display = 'none';

                  // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
                  document.body.scrollTop = currentScroll;
              },
              // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
              onresize : function(size) {
                  element_wrap.style.height = size.height+'px';
              },
              width : '100%',
              height : '100%'
          }).embed(element_wrap);

          // iframe을 넣은 element를 보이게 한다.
          element_wrap.style.display = 'block';
          userAddr.style.display = "block";
      }
  </script>
  <!--E: 다음 주소찾기 API-->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="./include/header_back.asp" -->
      <h1 class="m_header__tit">통합회원가입</h1>
      <!-- #include file="./include/header_home.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">

    <form name="s_frm" id="s_frm" method="post" class="m_combineForm">
      <input type="hidden" name="sd_terms" id="sd_terms" value="<%=sd_terms%>" />
      <input type="hidden" name="privacy_terms" id="privacy_terms" value="<%=privacy_terms%>" />
      <input type="hidden" name="data_terms" id="data_terms" value="<%=data_terms%>" />
    	<input type="hidden" name="Hidden_UserID" id="Hidden_UserID" />
    	<input type="hidden" name="ID_CheckYN" id="ID_CheckYN" value="N" />


      <ul class="m_combineFormList">
        <li class="m_combineFormList__item">
          <label class="m_combineFormList__inputWrap [ _inputWrap ]">
            <span class="m_combineFormList__placeholder [ _placeholder ]">아이디 6~12자의 영문/숫자 조합</span>
            <input type="email" class="m_combineFormList__input s_id [ _input ]" name="UserID" id="UserID" maxlength="12" style="ime-mode:disabled; text-transform:lowercase;">
          </label>

          <a href="javascript:chk_id();" class="m_combineFormList__btn s_id">중복확인</a>

        </li>
        <li class="m_combineFormList__item">
          <label class="m_combineFormList__inputWrap [ _inputWrap ]">
            <span class="m_combineFormList__placeholder [ _placeholder ]">비밀번호 6~12자의 영문+숫자 조합</span>
            <input type="password" class="m_combineFormList__input [ _input ]" name="UserPass" id="UserPass" maxlength="12" onKeyUp="chk_InputValue(this, 'EngDigit');">
          </label>
        </li>

        <li class="m_combineFormList__item">
          <label class="m_combineFormList__inputWrap [ _inputWrap ]">
            <span class="m_combineFormList__placeholder [ _placeholder ]">비밀번호 재확인</span>
            <input type="password" class="m_combineFormList__input [ _input ]" name="UserPassRe" id="UserPassRe" maxlength="12" onKeyUp="chk_InputValue(this, 'EngDigit');">
          </label>
        </li>
      </ul>



      <ul class="m_combineFormListB">
        <li class="m_combineFormListB__item">
          <div class="m_combineFormListB__inputWrap">
            <input type="text" value="<%=UserName%>" name="UserName" id="UserName" class="m_combineFormListB__input" readonly />
          </div>
        </li>

        <li class="m_combineFormListB__item">
          <div class="m_combineFormListB__inputWrap">
            <input type="text" value="<%=UserBirth%>" name="UserBirth" id="UserBirth" class="m_combineFormListB__input s_birth" readonly />
            <div class="m_combineFormListB__genderWrap">
              <input type="radio" name="gender-type" id="gender-type" class="m_combineFormListB__radioGender" value="Man" checked hidden><label for="gender-type" class="m_combineFormListB__genderTxt">남</label>
              <input type="radio" name="gender-type" id="gender-type1" class="m_combineFormListB__radioGender" value="WoMan" hidden><label for="gender-type1" class="m_combineFormListB__genderTxt">여</label>
            </div>
          </div>
        </li>

        <li class="m_combineFormListB__item">

          <div class="m_combineFormListB__inputWrap">
            <div class="m_combineFormListB__selectWrap">
              <select name="UserPhone1" id="UserPhone1" class="m_combineFormListB__select s_phone">
                <option value="010">010</option>
                <option value="011">011</option>
                <option value="016">016</option>
                <option value="017">017</option>
                <option value="018">018</option>
                <option value="019">019</option>
              </select>
            </div>

            <input type="number" name="UserPhone2" id="UserPhone2" class="m_combineFormListB__input s_phone" placeholder="0000" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit'); if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}" />

            <span class="m_combineFormListB__phoneBar">-</span>

            <input type="number" name="UserPhone3" id="UserPhone3" class="m_combineFormListB__input s_phone" placeholder="0000" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');if($('#UserPhone3').val().length==4){$('#UserEmail1').focus();}" />

            <a href="javascript:Chk_SMS();" id="Chk_SMS" class="m_combineFormList__btn">인증하기</a>
          </div>

          <!--SMS인증여부-->
          <input type="hidden" name="Hidden_SMS" id="Hidden_SMS" value="N" />

          <input type="hidden" name="Hidden_UserPhone1" id="Hidden_UserPhone1" />
          <input type="hidden" name="Hidden_UserPhone2" id="Hidden_UserPhone2" />
          <input type="hidden" name="Hidden_UserPhone3" id="Hidden_UserPhone3" />
          <input type="hidden" name="Auth_Num" id="Auth_Num" />
        </li>

        <li class="m_combineFormListB__item" id="CHK_REAUTH" style="display:none;">
          <div class="m_combineFormListB__inputWrap">
            <input type="number" name="Re_Auth_Num" id="Re_Auth_Num" class="m_combineFormListB__input s_auth" placeholder="인증번호를 입력해주세요" />

						<a href="javascript:chk_Auth_Num()" class="m_combineFormList__btn">확인</a>
          </div>
        </li>


        <!-- <li class="qualify-list">
          <input type="text" placeholder="인증번호 입력">
          <div class="pos-right">
            <span class="count-time">3:00</span>
            <a href="#" class="btn btn-default btn-chk">확인</a>
          </div>
        </li> -->

      </ul>



		  <!-- S: input-box -->
      <div class="input-box" style="display:none;">
        <ul>
          <li class="agree-list">
            <!-- S: ic_check act_btn bind_whole -->
            <label class="ic_check act_btn bind_whole">
              <input type="checkbox" name="AgreeSMS" id="AgreeSMS">
              <span class="txt">정보 및 안내사항 SMS 수신동의</span>
              <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
              </svg>
            </label>
            <!-- E: ic_check act_btn bind_whole -->
            <!-- S: ic_check act_btn bind_whole -->
            <!--
            <label class="ic_check act_btn bind_whole">
              <input type="checkbox" name="AgreeEmail" id="AgreeEmail">
              <span class="txt">관련정보 및 안내사항 E-mail 수신동의</span>
              <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
                <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
              </svg>
            </label>
            -->
            <!-- E: ic_check act_btn bind_whole -->
          </li>
          <li class="agree-info">
            <span>※</span>대회정보, 선수정보, 이벤트 및 광고 등 다양한 정보를 SMS로 받아 보실 수 있습니다.
          </li>
        </ul>
      </div>
      <!-- E: input-box -->


      <div class="m_combineCont">
        <a href="javascript:chk_Submit();" class="m_combineCont__btn">확인</a>
      </div>

    </form>
  </div>

  <!-- #include file='./include/footer.asp' -->

</div>


<script>
  $('._input').one('focus', function(evt){
    $(this).parent().find('._placeholder').addClass('s_focus');
  });
</script>

</body>
</html>
