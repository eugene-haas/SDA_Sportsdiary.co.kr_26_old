<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!--#include file="./include/config.asp"-->
	<script>

		//maxlength 체크
		function maxLengthCheck(obj){
			if (obj.value.length > obj.maxLength){
				obj.value = obj.value.slice(0, obj.maxLength);
			}
		}

		//유효성 체크 : 숫자입력체크
		function chk_Number(event){
			event = event || window.event;

			var keyID = (event.which) ? event.which : event.keyCode;

			console.log('keyID='+keyID);
			console.log('keyCode='+event.keyCode);

			//if((event.keyCode < 48)||(event.keyCode > 57)) event.returnValue = false;
			//if(event.returnValue==false) alert("숫자만 입력해 주세요."); return;

			if((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39){
				return;
			}
			else{
				return event.target.value.replace(/[^0-9]/g, '');
			}
		}

		//유효성 체크 : 한글만 입력
		function chk_Text(event){
			var regExp = /[a-zA-Z0-9]|[\s\[\]{}()<>?|`~!@#$%^&*-_+=,.;:\"'\\]+$/;				//입력불가문자
			var regExpKOR = /^[가-힣ㄱ-ㅎㅏ-ㅣ\u119E\u11A2\u318D\u2022\u2025a\u00B7\uFE55]+$/; 	//한글만 입력(천지인 고려)
			var valText = $('#UserName').val();

			if(valText){
				if(!regExpKOR.test(valText)) {			//false
					alert('한글만 입력가능합니다.');
					$('#UserName').val(valText.replace(regExp, ''));
				}
				else{
					if(valText.match(/a/g)){			//'a' 문자 별도 처리함
						alert('한글만 입력가능합니다.');
						$('#UserName').val(valText.replace(regExp, ''));
					}
				}
			}
		}

		/*
		//유효성 체크 : 숫자입력체크
		function chk_Number(){
			if((event.keyCode < 48)||(event.keyCode > 57)) event.returnValue = false;
			if(event.returnValue==false) alert("숫자만 입력해 주세요."); return;
		}
		*/

		//통합계정체크
		function chk_frm(){
			if(!$('#UserName').val()){
				alert('이름을 입력해 주세요.');
				$('#UserName').focus();
				return;
			}

			if(!$('#UserBirth').val()){
				alert('생년월일 8자리를 입력해 주세요.');
				$('#UserBirth').focus();
				return;
			}
			else{
				if($('#UserBirth').val().length < 8){
					alert('생년월일 8자리를 입력해 주세요.');
					$('#UserBirth').focus();
					return;
				}
				else{
					var data = $('#UserBirth').val();

					var y = parseInt(data.substr(0, 4), 10);
					var m = parseInt(data.substr(4, 2), 10);
					var d = parseInt(data.substr(6, 2), 10);

					var dt = new Date(y, m-1, d);
	        var now = new Date();
					var valYear =  parseInt(data.substr(0, 1), 10);

					if(valYear == 1 || valYear == 2){
						if(dt.getDate() != d) { alert('생년월일 [일]이 유효하지 않습니다'); $('#UserBirth').focus(); return;}
						else if(dt.getMonth()+1 != m) { alert('생년월일 [월]이 유효하지 않습니다.'); $('#UserBirth').focus(); return;}
						else if(dt.getFullYear() != y) { alert('생년월일 [년도]가 유효하지 않습니다.'); $('#UserBirth').focus(); return;}
						else {
	            if(now.getFullYear() <= dt.getFullYear()) { alert('생년월일 [년도]가 유효하지 않습니다.'); $('#UserBirth').focus(); return;}
	          }
					}
					else{
						alert('생년월일 [년도]가 유효하지 않습니다.'); $('#UserBirth').focus(); return;
					}
				}
			}

			var strAjaxUrl = './ajax/combine_check_ph.asp';
			var UserName = $('#UserName').val();
	    	var UserBirth = $('#UserBirth').val();

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					UserName	: UserName
					,UserBirth	: UserBirth
				},
				success: function(retDATA) {

					//console.log(retDATA);

					if(retDATA){
						var strcut = retDATA.split('|');

						//alert(strcut[1]);

						if(strcut[0] == 'TRUE') {
							/*
							<%
							'1. 유도의 경우
							'  	1) SD_Member.dbo.tblMember 동일정보(name, birthday)가 있을 경우 통합아이디 설정페이지로 이동
							'    	- 1개 이상의 계정이 있을 경우
							'  	2) 통합아이디 설정한 경우 SD_Member.dbo.tblMember에 1개의 계정만 남기고 삭제한다.
							'    	- 1개 이상의 계정이 있다는건 통합아이디 설정이 안된 경우에 해당한다.
							'	3) 통합아이디 설정 페이지로 이동
							%>
							*/
							if(strcut[1] > 1){
								$('#UserName').val(strcut[2]);
								$('#UserBirth').val(strcut[3]);
								$('form[name=s_frm]').attr('action','./total_id_sel.asp');
								$('form[name=s_frm]').submit();

								//$(location).attr('href', './total_id_sel.asp?UserName='+strcut[2]+'&UserBirth='+strcut[3]);
							}
							//계정이 1개만 있는 경우나 통합아이디 설정이 된 경우 통합ID계정목록페이지로 이동하여 가입된 계정목록을 출력한다.
							//로그인 후 계정추가하기
							else{
								$('form[name=s_frm]').attr('action','./check_yes_id.asp');
								$('form[name=s_frm]').submit();
							}
						}
						/*
						2.통합계정이 없는 경우(유도 외 종목)
							1) 가입된 통합회원계정이 없는 경우 회원 가입 Step 페이지로 이동
						*/
						else{
							switch(strcut[1]){
								case '99'	: //회원계정이 없는 경우 약관동의 페이지로 이동
								   	$('form[name=s_frm]').attr('action','./join1_main_agree.asp');
									$('form[name=s_frm]').submit();
									break;

								default : 	//200
									alert('잘못된 접근입니다.\n확인 후 다시 이용하세요.');
									return;
							}
						}
					}
				},
				error: function(xhr, status, error){
					if(error){	//error is not Null
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}

		$(document).ready(function() {
			//First Focus
			$('#UserName').focus();
		});

	</script>
</head>
<body>
<div class="l">
	
	<div class="l_header">
		<div class="m_header s_sub">
		  <!-- #include file="./include/header_back.asp" -->
		  <h1 class="m_header__tit">통합계정 확인</h1>
		  <!-- #include file="./include/header_home.asp" -->
		</div>
	</div>

  <div class="l_content m_scroll combine_check [ _content _scroll ]">
	  <form name="s_frm" method="post">
	    <!-- S: type_info -->
	    <div class="type_info info">
	      <!-- S: top_section -->
	      <div class="top_section">
	        <p>기존에 스포츠다이어리에 가입된 정보가 있는지<br>확인절차를 거치고 있습니다.<br>입력하신 개인정보는 회원님의 동의없이<br>제 3자에게 제공되지 않으며,<br>개인정보 취급방침에 따라 보호되고 있습니다.</p>
	      </div>
	      <!-- E: top_section -->

	      <!-- S: input-form -->
	      <div class="input-form">
	        <ul>
	          <li>
	            <label>
	              <span class="tit">이름을 입력하세요</span>
	              <input type="text" name="UserName" id="UserName" class="input-control no_placeholder" style="ime-mode:active;" onkeyup='chk_Text(event);' />
	            </label>
	            <p class="text-warning">특수문자, 숫자를 사용할 수 없습니다.</p>
	          </li>
	          <li>
	            <label>
	              <span class="tit">생년월일 8자리를 입력해 주세요.</span>
	              <input type="number" name="UserBirth" id="UserBirth" maxlength="8" oninput="maxLengthCheck(this);" onkeyup='chk_Number(event);'  class="input-control no_placeholder" />
	            </label>
	            <p class="text-warning">올바르지 않은 형식 입니다. 예)19910101</p>
	          </li>

						<!-- !@# 휴대전화 번호 추가 -->
						<li>
	            <label>
	              <span class="tit">휴대전화 번호를 입력해주세요..</span>
	              <input type="number" name="UserPhoneNo" id="UserPhoneNo" maxlength="8" oninput="" onkeyup=""  class="input-control no_placeholder" />
	            </label>
	            <p class="text-warning">올바르지 않은 형식 입니다. 예)01012345678</p>
	          </li>

	        </ul>

	        <div class="cta">
	          <a href="javascript:chk_frm();" class="btn btn-ok btn-block btn_chk_account">확인</a>
	          <!--
	          <a href="./check_no_id.asp" class="btn btn-ok btn-block btn_chk_account">확인<small style="font-size: 0.72em">(아이디 없음)</small></a>
	          -->
	        </div>
	      </div>
	      <!-- E: input-form -->
	    </div>
	    <!-- E: type_info -->
	  </form>
  </div>

  <!-- #include file="./include/footer.asp"-->

</div>
</body>
</html>
