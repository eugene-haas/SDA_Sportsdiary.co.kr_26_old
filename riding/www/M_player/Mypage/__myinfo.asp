<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
</head>
<body>
<div id="app" class="l m_bg_edf0f4 myinfo" v-cloak>

	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
  		<h1 class="m_header__tit">마이페이지</h1>
    </div>
	</div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <form name="s_frm" method="post">
		  <fieldset>
		    <legend>마이페이지 내정보 관리</legend>

				<p class="m_guideTxt">기본정보</p>

		    <ul class="m_form">
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">아이디</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt">{{id}}</span>
						</p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">이름</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt">{{name}}</span>
						</p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">성별</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt">{{gender}}</span>
		        </p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">생년월일</p>
		        <p class="m_form__inputWrap">
							<span class="m_form__txt">{{birthday}}</span>
						</p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">휴대폰<span class="m_form__labelTxtStar">＊</span></p>
		        <div class="m_form__inputWrap">

		          <select name="UserPhone1" id="UserPhone1" class="m_form__select s_phone">
		            <option value="010" <%IF UserPhone1 = "010" Then response.Write "selected" End IF%>>010</option>
		            <option value="011" <%IF UserPhone1 = "011" Then response.Write "selected" End IF%>>011</option>
		            <option value="016" <%IF UserPhone1 = "016" Then response.Write "selected" End IF%>>016</option>
		            <option value="017" <%IF UserPhone1 = "017" Then response.Write "selected" End IF%>>017</option>
		            <option value="018" <%IF UserPhone1 = "018" Then response.Write "selected" End IF%>>018</option>
		            <option value="019" <%IF UserPhone1 = "019" Then response.Write "selected" End IF%>>019</option>
		          </select>

		          <span class="m_form__txt s_phone">-</span>
							<input type="number" name="UserPhone2" id="UserPhone2" class="m_form__input s_phone" maxlength="4" value="<%=UserPhone2%>" onKeyUp="if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}"/>
							<span class="m_form__txt s_phone">-</span>
							<input type="number" name="UserPhone3" id="UserPhone3" class="m_form__input s_phone" maxlength="4" value="<%=UserPhone3%>" />
							<a href="javascript:chk_sms();" class="m_form__btn s_phone" id="sms_button">인증</a>

		        </div>
		      </li>
		      <li id="CHK_REAUTH" class="m_form__item s_linkedItem s_hidden">
		        <p class="m_form__labelWrap s_hidden">휴대폰 인증번호 입력</p>
		        <div class="m_form__inputWrap">
		          <input type="number" name="Re_Auth_Num" id="Re_Auth_Num" class="m_form__input s_phoneAuth" placeholder="인증번호 입력" />
		          <a href="javascript:chk_Auth_Num()" class="m_form__btn s_phoneAuth">확인</a>
							<p id="chk_Agree" class="m_form__txt s_alert"></p>
						</div>
		      </li>
		      <li class="m_form__item s_linkedItem">
		        <p class="m_form__labelWrap s_hidden">휴대폰 수신동의</p>
		        <div class="m_form__inputWrap">
		          <label for="AgreeSMS" class="m_form__checkWrap img-replace sms <%IF SmsYn = "Y" Then response.Write "on" End IF%>" onClick="inputExc($(this));">
								수신동의<input type="checkbox" name="AgreeSMS" id="AgreeSMS" class="m_form__check" <%IF SmsYn = "Y" Then response.Write "checked" End IF%> />
		          </label>
							<p class="m_form__infoTxt">
								<span>※</span>대회정보, 선수정보, 이벤트 및 광고 등 다양한 정보를 SMS로 받아 보실 수 있습니다.
							</p>
		        </div>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">이메일</p>
		        <p class="m_form__inputWrap">
		          <input type="text" name="UserEmail1" id="UserEmail1" placeholder="sample123456" class="m_form__input s_email" value="<%=Email1%>" />
		          <span class="m_form__txt s_email">@</span>
		          <input type="text" name="UserEmail2" id="UserEmail2" placeholder="hanmail.net" class="m_form__input s_email" value="<%=Email2%>" />
		          <select name="EmailList" id="EmailList" class="m_form__select" onChange="chk_Email();">
		            <option value="">직접입력</option>
		            <option value="gmail.com" <%IF Email2 = "gmail.com" Then response.Write "selected" End IF%>>gmail.com</option>
		            <option value="hanmail.net" <%IF Email2 = "hanmail.net" Then response.Write "selected" End IF%>>hanmail.net</option>
		            <option value="hotmail.com" <%IF Email2 = "hotmail.com" Then response.Write "selected" End IF%>>hotmail.com</option>
		            <option value="naver.com" <%IF Email2 = "naver.com" Then response.Write "selected" End IF%>>naver.com</option>
		            <option value="nate.com" <%IF Email2 = "nate.com" Then response.Write "selected" End IF%>>nate.com</option>
		          </select>
		        </p>
		      </li>
		      <li class="m_form__item s_linkedItem">
		        <p class="m_form__labelWrap s_hidden">이메일 수신동의</p>
		        <p class="m_form__inputWrap">
		          <label for="AgreeEmail" class="m_form__checkWrap img-replace sms <%IF EmailYn = "Y" Then response.Write "on" End IF%>" onClick="inputExc($(this));">
								수신동의<input type="checkbox" name="AgreeEmail" id="AgreeEmail" class="m_form__check" <%IF EmailYn = "Y" Then response.Write "checked" End IF%> />
		          </label>
		        </p>
		      </li>
		      <li class="m_form__item">
		        <p class="m_form__labelWrap">주소</p>
		        <p class="m_form__inputWrap">
		          <input type="text" readonly name="ZipCode" id="ZipCode" class="m_form__input s_post" value="<%=ZipCode%>" />
		          <a href="javascript:execDaumPostCode();" class="m_form__btn s_post">우편번호 검색</a>
		          <input type="text" readonly name="UserAddr" id="UserAddr" class="m_form__input" value="<%=Address%>" />
		          <input type="text" name="UserAddrDtl" id="UserAddrDtl" class="m_form__input" placeholder="나머지 주소 입력" value="<%=AddressDtl%>" />
		        </p>
		      </li>
		    </ul>
		  </fieldset>
		</form>

		<div class="m_bottomBtn">
			<a href="./mypage.asp" class="m_bottomBtn__btn s_cancel">수정취소</a>
			<a href="javascript:chk_frm();" class="m_bottomBtn__btn s_modify">수정완료</a>
		</div>
	</div>

</div>

<script>
  let app=new Vue({
    el:"#app",
    data:{
      id:null,
      name:null,
      gender:null,
      birthday:null,
    },
    computed:{},
    methods:{
      // sdmain에 위치 //
      // 로그인해야 보임
      // http://riding.sportsdiary.co.kr/pub/ajax/sdmain/mobile/reqRiding.asp?req={"CMD":"10000","id":"player11"}

    },
    created:function(){},
    mounted:function(){},
  });
</script>
</body>
</html>
