<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!--#include file="./include/config.asp"-->
	<%
	   	'===============================================================================================================
		'STEP1
	   	'동호인 선수보호자 회원가입
	   	'===============================================================================================================
		dim UserName  		: UserName    		= fInject(Request.Cookies("SD")("UserName"))
		dim UserBirth  		: UserBirth    		= fInject(Request.Cookies("SD")("UserBirth"))

	   	dim EnterType   	: EnterType     	= fInject(Request("EnterType"))     '회원구분[E:엘리트 | A:생활체육]
		dim SportsType  	: SportsType    	= fInject(Request("SportsType"))    '종목구분
		dim PlayerReln  	: PlayerReln    	= fInject(Request("PlayerReln"))  	'가입자 구분

	'  	IF UserName = "" OR UserBirth = "" OR EnterType = "" OR SportsType = "" OR PlayerReln = "" Then
	'      	Response.Write "<script>alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.'); history.back();</script>"
	'		Response.End
	'    End IF
	%>
	<script>
		//maxlength 체크
		function maxLengthCheck(obj){
			if (obj.value.length > obj.maxLength){
				obj.value = obj.value.slice(0, obj.maxLength);
			}
		}

		//숫자입력체크
		function CHK_Number(){
			if((event.keyCode < 48)||(event.keyCode > 57)) event.returnValue = false;
			if(event.returnValue==false) alert("숫자만 입력해 주세요."); return;
		}

		function chk_onSubmit(){
			if(!$('#PlayerName').val()){
				alert("이름을 입력해 주세요.");
				$('#PlayerName').focus();
				return;
			}

			if(!$('#PlayerBirth').val()){
				alert("생년월일 8자리를 입력해 주세요.");
				$('#PlayerBirth').focus();
				return;
			}
			else{
				if($('#PlayerBirth').val().length < 8){
					alert("생년월일 8자리를 입력해 주세요.");
					$('#PlayerBirth').focus();
					return;
				}
				else{
					var data = $('#PlayerBirth').val();

					var y = parseInt(data.substr(0, 4), 10);
					var m = parseInt(data.substr(4, 2), 10);
					var d = parseInt(data.substr(6, 2), 10);

					var dt = new Date(y, m-1, d);

					if(dt.getDate() != d) { alert("생년월일 [일]이 유효하지 않습니다.");
						$('#PlayerBirth').focus();
						//$('#UserBirth').select();
						return;
					}
					else if(dt.getMonth()+1 != m) { alert("생년월일 [월]이 유효하지 않습니다."); $('#PlayerBirth').focus(); return;}
					else if(dt.getFullYear() != y) { alert("생년월일 [년도]가 유효하지 않습니다."); $('#PlayerBirth').focus(); return;}
					else { }
				}
			}

			if(!$('#UserPhone2').val()){
				alert("휴대폰 번호를 입력해 주세요.");
				$('#UserPhone2').focus();
				return;
			}

			if(!$('#UserPhone3').val()){
				alert("휴대폰 번호를 입력해 주세요.");
				$('#UserPhone3').focus();
				return;
			}

			if(!($('#sd_parents').is(":checked"))){
				alert("보호자 권한 회원가입 안내사항에 동의해 주세요.");
				$('#sd_parents').focus();
				return;
			}

			$('form[name=s_frm]').attr('action','./join2_type3_child_form.asp');
			$('form[name=s_frm]').submit();
		}
	</script>
</head>
<body class="join-body">
<div class="l">


	<div class="l_header">
	  <div class="m_header s_sub">
	    <!-- #include file="./include/header_back.asp" -->
	    <h1 class="m_header__tit">회원구분 정보</h1>
	    <!-- #include file="./include/header_home.asp" -->
	  </div>
	</div>

	<div class="l_content m_scroll [ _content _scroll ]">

	  <!-- S: main -->
	  <div class="main user_divn parents pack">
	    <form name="s_frm" id="s_frm" method="post">
	        <input type="hidden" id="sd_terms" name="sd_terms" value="<%=sd_terms%>" />
	        <input type="hidden" id="privacy_terms" name="privacy_terms" value="<%=privacy_terms%>" />
	        <input type="hidden" id="data_terms" name="data_terms" value="<%=data_terms%>" />
	        <input type="hidden" id="EnterType" name="EnterType" value="<%=EnterType%>" />
	        <input type="hidden" id="SportsType" name="SportsType" value="<%=SportsType%>" />
	        <input type="hidden" id="PlayerReln" name="PlayerReln" value="<%=PlayerReln%>" />
	        <input type="hidden" id="UserBirth" name="UserBirth" value="<%=UserBirth%>" />
	        <input type="hidden" id="UserName" name="UserName" value="<%=UserName%>" />

	      <!-- S: input-list -->
	      <div class="input-list">
	        <ul>
	          <li>
	            <p>테니스 생활체육(동호인) 선수 보호자</p>
	          </li>
	        </ul>

	        <!-- S: 자녀 선수 정보 입력 -->
	        <section class="child_info">
	          <h2>자녀 선수 정보</h2>
	          <ul class="info_list">
	            <li>
	              <input type="text" name="PlayerName" id="PlayerName" placeholder="이름" />
	              <p class="text-warning">특수기호, 숫자를 포함할 수 없습니다.</p>
	            </li>
	            <li>
	            <input type="text" name="PlayerBirth" id="PlayerBirth" maxlength="8" oninput="maxLengthCheck(this);" onKeyPress="CHK_Number();" class="input-control no_placeholder" placeholder="생년월일은 8자리 입니다. (예: 198131209)">
	              <p class="text-warning">생년월일은 8자리 입니다. (예: 198131209)</p>
	            </li>
	            <li class="phone_line">
	              <div class="sel_box num">
	                <select name="UserPhone1" id="UserPhone1">
	                    <option value="010">010</option>
	                    <option value="011">011</option>
	                    <option value="016">016</option>
	                    <option value="017">017</option>
	                    <option value="018">018</option>
	                    <option value="019">019</option>
	                  </select>
	              </div>
	              <!-- <div class="divn">-</div> -->
	              <div class="num">
	                <input type="number" name="UserPhone2" id="UserPhone2" maxlength="4" onKeyUp="if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}" />
	              </div>
	              <div class="divn">-</div>
	              <div class="num">
	                <input type="number" name="UserPhone3" id="UserPhone3" maxlength="4" onKeyUp="if($('#UserPhone3').val().length==4){$('#UserBirth').focus();}" />
	              </div>
	            </li>
	          </ul>
	        </section>
	        <!-- E: 자녀 선수 정보 입력 -->
	      </div>
	      <!-- E: input-list -->

	      <!-- S: check_agree -->
	      <div class="check_agree">
	        <label class="bind_whole ic_check act_btn">
	          <span class="txt">보호자 권한 회원가입 안내사항을 확인하였습니다.</span>
	          <input type="checkbox" name="sd_parents" id="sd_parents" />
	          <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
	            <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
	          </svg>
	        </label>
	      </div>
	      <!-- E: check_agree -->

	    </form>

	    <!-- S: small_link -->
	    <!-- <div class="small_link">
	      <a href="./fnd_pwd.asp" class="btn btn-link">
	        <span>신규 소속 생성 요청</span>
	        <span class="triangle"></span>
	      </a>
	    </div> -->
	    <!-- E: small_link -->

	  </div>
	  <!-- E: main -->

	  <!-- S: user_agree_info -->
	  <div class="user_agree_info parents">
	    <!-- S: guide_txt -->
	    <div class="guide_txt">
	      <ul>
	        <li>
	          <p>자녀 선수는 스포츠 다이어리 App에 반드시 회원가입이 되어 있어야 합니다.</p>
	        </li>
	        <li>
	          <p>자녀선수 정보 입력 및 회원가입 여부가 확인 후 보호자 회원가입 절차가 진행됩니다.</p>
	        </li>
	        <li>
	          <p>보호자 권한 회원가입 완료 후 자녀선수에게 정보 공유 시작일자 및 보호자 정보가 안내됩니다.</p>
	        </li>
	        <li>
	          <p>자녀선수는 사전에 보호자와 스포츠다이어리 정보를 공유 한다는 인지를 반드시 해야 합니다.</p>
	        </li>
	      </ul>
	    </div>
	    <!-- E: guide_txt -->
	  </div>
	  <!-- E: user_agree_info -->


	  <div class="cta">
	    <a href="javascript:chk_onSubmit();" class="btn btn-ok btn-block btn_chk_account">다음</a>
	  </div>

	</div>

  <!-- #include file="./include/footer.asp"-->

  <script>
    WholeAgree.start('.check_agree');
  </script>

</div>
</body>
</html>
