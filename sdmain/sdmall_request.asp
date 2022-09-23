<!-- S: config -->
<!--#include file="./include/config.asp"-->
<!-- E: config -->
<%
   	'제휴/입점문의 페이지

	dim returnPageUrl 	: returnPageUrl = fInject(URLDecode(Server.URLEncode(Request.ServerVariables("HTTP_REFERER"))))	'리턴페이지 URL
   	dim SportsType		: SportsType	= fInject(request("SportsType"))												'종목구분

%>
<!-- S: 유효성 검사 및 문의 등록 ajax -->
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
		if((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39) {
			return;
		}
		else{
			return event.target.value.replace(/[0-9]/g, '');
		}
	}

	function chk_inputs(){
		if(!$('#CompanyName').val()){
			alert('회사명을 입력해 주세요.');
			$('#CompanyName').focus();
			return;
		}

		if(!$('#Product').val()){
			alert('취급상품군을 입력해 주세요.');
			$('#Product').focus();
			return;
		}

		if(!$('#ZipCode').val()){
			alert('회사주소를 입력해 주세요.');
			$('#ZipCode').focus();
			return;
		}

		if(!$('#CompanyAddr').val()){
			alert('회사주소를 입력해 주세요.');
			$('#CompanyAddr').focus();
			return;
		}

		if(!$('#ManagerName').val()){
			alert('담당자명을 입력해 주세요.');
			$('#ManagerName').focus();
			return;
		}

		if(!$('#ContactPhone2').val()){
			alert('연락처를 입력해 주세요.');
			$('#ContactPhone2').focus();
			return;
		}

		if(!$('#ContactPhone3').val()){
			alert('연락처를 입력해 주세요.');
			$('#ContactPhone3').focus();
			return;
		}

		var email = $('#ContactEmail1').val().replace(/ /g, '') +'@' + $('#ContactEmail2').val().replace(/ /g, '');
		var regexp=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;

		//이메일체크
		if(!$('#ContactEmail1').val()){
			alert('이메일을 입력해 주세요');
			$('#ContactEmail1').focus();
			return;
		}

		if(!$('#ContactEmail2').val()){
			alert('이메일을 입력해 주세요');
			$('#ContactEmail2').focus();
			return;
		}

		if(!regexp.test(email)){
			alert('잘못된 이메일 형식입니다.\n\n입력된 이메일을 확인해주세요');
			return;
		}

		if(!$('#ReqContent').val()){
			alert('문의내용을 입력해 주세요.');
			$('#ReqContent').focus();
			return;
		}

		var PrivacyYN = '';

		if(!($('#PersonalChk').is(':checked'))){
			alert('[개인정보 수집 및 이용]에 동의하여야 문의가 가능합니다.');
			$('#PersonalChk').focus();
			return;
		}
		else{
			PrivacyYN = 'Y';
		}


		if(confirm('제휴/입점문의 내용을 접수하시겠습니까?')){
			var strAjaxUrl = './Ajax/sdmall_request.asp';

			var CompanyName = $('#CompanyName').val();
			var Product = $('#Product').val();
			var ZipCode = $('#ZipCode').val();
			var CompanyAddr = $('#CompanyAddr').val();
			var CompanyAddrDtl = $('#CompanyAddrDtl').val();
			var CompanyURL = $('#CompanyURL').val();
			var ManagerName = $('#ManagerName').val();
			var ReqContent = $('#ReqContent').val();
			var UserPhone = $('#ContactPhone1').val() + '-' + $('#ContactPhone2').val().replace(/ /g, '') + '-' + $('#ContactPhone3').val().replace(/ /g, '');
			var UserEmail = $('#ContactEmail1').val().replace(/ /g, '') + '@' + $('#ContactEmail2').val().replace(/ /g, '');

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					CompanyName     : CompanyName
					,Product   		: Product
					,ZipCode       	: ZipCode
					,CompanyAddr   	: CompanyAddr
					,CompanyAddrDtl	: CompanyAddrDtl
					,CompanyURL     : CompanyURL
					,ManagerName	: ManagerName
					,ReqContent     : ReqContent
					,UserPhone      : UserPhone
					,UserEmail      : UserEmail
					,PrivacyYN		: PrivacyYN
				},
				success: function(retDATA) {

					console.log(retDATA);

					if(retDATA){

						var strcut = retDATA.split('|');

						if (strcut[0]=='TRUE') {
							alert('문의가 접수되었습니다.\n빠른 시일내에 연락드리도록 하겠습니다.');
							$(location).attr('href', '<%=returnPageUrl%>');
						}
						else{  //FALSE|

							var msg='';

							switch(strcut[1]){
								case '66'  	: msg='회원가입에 실패하였습니다.\n관리자에게 문의하십시오.'; break;
								default		: msg='잘못된 접근입니다.\n확인 후 다시 이용하세요.';  //200
							}
							alert(msg);
							return;
						}
					}
				},
				error: function(xhr, status, error){
					if(error!=''){
						alert('오류발생! - 시스템관리자에게 문의하십시오!');
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
<!-- E: 유효성 검사 및 문의 등록 ajax -->
<body>
	<div id="wrap" style="display: none; border:1px solid #000; width:100%; height:100%; margin:48px 0; position: absolute; z-index:1000;">
		<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnFoldWrap" style=" width:17px;cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onClick="foldDaumPostcode()" alt="접기 버튼">
	</div>
	<!-- S: sub-header -->
	<div class="sd-header sd-header-sub">
		<!-- #include file="./include/sub_header_arrow.asp" -->
		<h1>제휴/입점 문의</h1>
		<!-- #include file="./include/sub_header_gnb.asp" -->
	</div>
	<!-- E: sub-header -->

  <div class="sub sd-scroll [ _sd-scroll ]">
    <div class="sdmall banner_box">
      <img src="./images/sdmall_banner_02@2x.png" alt="sdmall 입점문의 배너"  />
    </div>
    <div class="sdmall jumbo">
      <div class="jumboInner">
        <h2>
          제휴/입점 문의
        </h2>
        <p>
          Sports diary의 다양한 서비스와 연계하여<br class="show_360"/> 상품 홍보 및 상품판매(문의)를 하실 수 있습니다.
        </p>
      </div>
    </div>
    <form name="" method="post" class="inputForm">
      <div>
        <label for="CompanyName">회사명<span class="required">*</span></label>
        <input type="text" name="CompanyName" id="CompanyName" class="" placeholder="A사" value="" />
      </div>
      <div>
        <label for="Product">취급상품군<span class="required">*</span></label>
        <input type="text" name="Product" id="Product" class="" placeholder="라켓" value="" />
      </div>
      <div class="find_address">
        <label>회사주소<span class="required">*</span></label>
        <div class="address_wrap">
          <a href="javascript:execDaumPostCode();" class="btn_gray">주소찾기</a>
          <input type="text" name="ZipCode" id="ZipCode" class="address_part" value="" readonly onClick="execDaumPostCode();" />
          <input type="text" name="CompanyAddr" id="CompanyAddr" class="address_part" value="" readonly onClick="execDaumPostCode();" />
          <input type="text" name="CompanyAddrDtl" id="CompanyAddrDtl" class="address_part" value="" placeholder="상세 주소를 입력해주세요" />
        </div>
      </div>
      <div>
        <label for="CompanyURL">회사 URL</label>
        <input type="text" name="CompanyURL" id="CompanyURL"  placeholder="www.회사URL.co.kr" value="" />
      </div>
      <div>
        <label for="ManagerName">담당자명<span class="required">*</span></label>
        <input type="text" name="ManagerName" id="ManagerName" class="" placeholder="송중기" value="" />
      </div>
      <div class="phone">
        <label>연락처<span class="required">*</span></label>
        <div class="phone_wrap">
          <select class="phone_part" name="ContactPhone1" id="ContactPhone1">
            <option value="010" selected>010</option>
            <option value="011">011</option>
            <option value="016">016</option>
            <option value="017">017</option>
            <option value="018">018</option>
            <option value="019">019</option>
          </select>
          <input type="number" name="ContactPhone2" id="ContactPhone2" class="phone_part" maxlength="4" oninput="maxLengthCheck(this);" onkeyup="chk_Number(event);if($('#ContactPhone2').val().length==4) $('#ContactPhone3').focus();" >
          <input type="number" name="ContactPhone3" id="ContactPhone3" class="phone_part" maxlength="4" oninput="maxLengthCheck(this);" onKeyUp="chk_Number(event);if($('#ContactPhone3').val().length==4) $('#ContactEmail1').focus();" >
        </div>
      </div>
      <div class="email">
        <label for="UserEmail1">이메일<span class="required">*</span></label>
        <div class="email_wrap">
          <input type="text" name="ContactEmail1" id="ContactEmail1" class="email_part" placeholder="sample123456" value="" />
          <span class="email_part">@</span>
          <input type="text" name="ContactEmail2" id="ContactEmail2" class="email_part" placeholder="hanmail.net" value="" />
          <span class="email_part">&nbsp;&nbsp;</span>
          <select name="EmailList" id="EmailList" class="email_part">
            <option value="">직접입력</option>
            <option value="gmail.com">gmail.com</option>
            <option value="hanmail.net">hanmail.net</option>
            <option value="hotmail.com">hotmail.com</option>
            <option value="naver.com">naver.com</option>
            <option value="nate.com">nate.com</option>
          </select>
        </div>
      </div>
      <div>
        <label for="ReqContent">문의내용</label>
        <textarea name="ReqContent" id="ReqContent" placeholder="제휴 입점 문의 내용을 등록해 주시면, 빠른 시일내에 연락을 드리도록 하겠습니다."></textarea>
      </div>
      <div class="info_persoanl">
        <p class="info_personal_label">개인정보 수집 및 이용안내</p>
        <p class="info_content">
          (주)위드라인(이하 "회사"라고 합니다)은 이용자들의 개인정보보호를 매우 중요시하며, 이용자는 회사가 운영하고 있는 인터넷관련 서비스(스포츠다이어리)의 서비스를 이용함과 동시에 온라인상에서 회사에 제공한 개인정보가 보호 받을 수 있도록 최선을 다하고 있습니다. 이에 회사는 통신비밀보호법, 전기통신사업법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 정보통신서비스제공자가 준수하여야 할 관련 법규상의 개인정보 보호 규정 및 정보통신부가 제정한 개인정보보호지침을 준수하고 있습니다.
          <br />
          <br />
          수집하는 개인정보의 항목
          <br />
          <br />
          - 회사명, 회사주소, 회사URL, 담당자명, 연락처, 이메일
          <br />
          <br />
          개인정보 수집 및 이용목적
          <br />
          <br />
          - 제휴/입점문의에 대한 처리와 결과 회신 용도
          <br />
          <br />
          개인정보 보유 및 이용기간
          <br />
          <br />
          [전자상거래 등에서의 소비자보호에 관련 법률]에 의거하여 문의처리 후 3년 간 보관 후 지체없이 파기
        </p>
        <label class="info_personal_check_warp"><input type="checkbox" name="PersonalChk" id="PersonalChk" />개인정보 수집 및 이용에 동의합니다.</label>
      </div>
      <div class="info_manager">
        <h3 class="info_title">담당자 정보</h3>
        <ul id="" class="info_list">
          <li>SDA몰 담당자 : 구자현 매니저</li>
          <li>Email : wkghks@nate.com</li>
          <li>TEL : 070-7437-8143</li>
        </ul>
      </div>
    </form>
    <div class="btn_wrap"> <a href="javascript:history.back();" class="button btn_cancel">취소</a> <a href="javascript:chk_inputs();" class="button btn_confirm">문의하기</a> </div>
  </div>
	<!--S: 다음 주소찾기 API-->

	<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
	<script>
			// 우편번호 찾기 찾기 화면을 넣을 element
			var element_wrap = document.getElementById('wrap');
			function foldDaumPostcode() {
					// iframe을 넣은 element를 안보이게 한다.
					element_wrap.style.display = 'none';
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
									document.getElementById('CompanyAddr').value = fullAddr;
									document.getElementById('CompanyAddrDtl').focus();


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
			}

			var isMobile = {
				Android: function () {
					 return navigator.userAgent.match(/Android/i);
				},
				BlackBerry: function () {
					 return navigator.userAgent.match(/BlackBerry/i);
				},
				iOS: function () {
					 return navigator.userAgent.match(/iPhone|iPad|iPod/i);
				},
				Opera: function () {
					 return navigator.userAgent.match(/Opera Mini/i);
				},
				Windows: function () {
					 return navigator.userAgent.match(/IEMobile/i);
				},
				any: function () {
					 return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
				}
			}
	</script>
	<!--E: 다음 주소찾기 API-->
	<script>
		//이메일 도메인 선택입력
		$(document).on('change','#EmailList', function(){
			if(!$('#EmailList').val()) $('#ContactEmail2').val('');
			else $('#ContactEmail2').val($('#EmailList').val());
		});
	</script>
</body>
</html>
