<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!-- #include file='./include/config.asp' -->
	<%
		'로그인 되었다면 index.asp로 이동
		Check_NoLogin()
	%>
	<script type="text/javascript">
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

		function chk_frm(){
			if(!$('#UserPhone2').val()){
				alert("휴대폰 번호를 입력해 주세요.");
				$('#UserPhone2').focus();
				return;
			}

			if(!$('#UserPhone3').val()){
				alert("휴대폰 번호 뒷자리를 입력해 주세요.");
				$('#UserPhone3').focus();
				return;
			}


			if(!$('#UserName').val()){
				alert("이름을 입력해 주세요.");
				$('#UserName').focus();
				return;
			}

			var strAjaxUrl = "./Ajax/fnd_id.asp";
			var UserPhone = $("#UserPhone1").val() + $('#UserPhone2').val().replace(/ /g, '') + $('#UserPhone3').val().replace(/ /g, '');
			var UserName = $('#UserName').val();

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					UserPhone : UserPhone
					,UserName  : UserName
				},
				success: function(retDATA) {

					//console.log(retDATA);

					if(retDATA){

						var strcut = retDATA.split('|');

						if (strcut[0]=="TRUE") {
							$(location).attr('href','./fnd_id_ok.asp?fnd_UserID='+strcut[1]);
						}
						else{
							if(strcut[1]=='200'){
								alert('잘못된 접근입니다.\n확인 후 다시 이용하세요.');
								return;
							}
							else{	//99
								alert('일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.');
								return;
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

	    $(document).ready(function() {
	        $('#UserPhone2').focus();
	    });
	</script>
</head>
<body>
<div class="l">
	<div class="l_header">
		<div class="m_header s_sub">
		  <!-- #include file="./include/header_back.asp" -->
		  <h1 class="m_header__tit">아이디 찾기</h1>
		  <!-- #include file="./include/header_home.asp" -->
		</div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_combineHeader">
      <p class="m_combineHeader__txt">
        회원가입시 등록된 회원정보로 아이디를 찾을 수 있습니다.<br />
        아래 정보를 입력해주세요.
      </p>
    </div>

    <ul class="m_combineFormListB">
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

          <input type="number" name="UserPhone2" id="UserPhone2" class="m_combineFormListB__input s_phone" maxlength="4" placeholder="0000" oninput="maxLengthCheck(this);" onKeyPress="CHK_Number();" onKeyUp="if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}" />

          <span class="m_combineFormListB__phoneBar">-</span>

          <input type="number" name="UserPhone3" id="UserPhone3" class="m_combineFormListB__input s_phone" maxlength="4" placeholder="0000" oninput="maxLengthCheck(this);" onKeyPress="CHK_Number();" onKeyUp="if($('#UserPhone3').val().length==4){$('#UserName').focus();}" />

        </div>
      </li>
      <li class="m_combineFormListB__item">
        <div class="m_combineFormListB__inputWrap">
          <input type="text" name="UserName" id="UserName" class="m_combineFormListB__input" placeholder="이름" />
        </div>
      </li>
    </ul>

    <div class="m_combineCont">
      <a href="javascript:chk_frm();" class="m_combineCont__btn">아이디 찾기</a>
    </div>
  </div>

  <!-- #include file='./include/footer.asp' -->

</div>
</body>
</html>
