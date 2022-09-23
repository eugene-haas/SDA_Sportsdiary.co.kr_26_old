<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->
    <link rel="stylesheet" href="/home/css/index.css">
	<script src="/pub/js/swimming/certificate.js?v=210203"></script>
</head>
<%
	Set db = new clsDBHelper
'##############################################
' 소스 뷰 경계
'##############################################
%>

<body <%=CONST_BODY%>>
<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>

	<div class="index_wrap">
      <!-- s 헤더 영역 -->
      <h1 class="index_header">
        <img src="/home/images/logo-index.svg" alt="대한수영연맹 로고">
      </h1>
      <!-- e 헤더 영역 -->
      <!-- s 메인 영역 -->
      <div class="index_main">
        <section class="index_main__contents">
          <h2><strong class="hide">콘텐츠 시작</strong></h2>
          <span class="index_main__contents__span">전문 동호인 증명서를 선택해 주십시오.</span>
          <ul class="index_main__contents__list-group" style="width:60%; margin: auto;">
            <li class="index_main__contents__list-group__list">
              <h3 class="index_main__contents__list-group__list__header"><span>전문선수</span>증명</h3>
              <a class="index_main__contents__list-group__list__link" href="javascript:$('#certificatetype').val(1);$('#NotiModal2').fadeIn(300);">발급신청하기</a>
              <span class="index_main__contents__list-group__list__noti">※ 전문선수 등록증 <br>발급신청</span>
            </li>
            <li class="index_main__contents__list-group__list">
              <h3 class="index_main__contents__list-group__list__header"><span>동호인선수</span>증명</h3>
              <a class="index_main__contents__list-group__list__link" href="javascript:alert('준비 중 입니다.')">대회리스트 보기</a>
              <span class="index_main__contents__list-group__list__noti">※ 동호인 등록증<br>발급신청</span>
            </li>

          </ul>
        </section>
      </div>
      <!-- e 메인 영역 -->
    </div>
  </body>

	<!-- s 팝업창 영역 -->
      <!-- div.s_show = 팝업창 보이게 -->
      <div class="l_modal-wrap" id="NotiModal">
        <div class="l_modal">
          <!--#include file="../include/m_modal-manual.asp"-->
        </div>
      </div>


      <div class="l_modal-wrap" id="NotiModal2">
        <div class="l_modal">
			<section class="m_modal-manual">
			  <h1 class="m_modal-manual__header" id="">신청자인증</h1>
			  <ul class="m_modal-manual__con">
				<li class="m_modal-manual__con__list">
				  <h2 class="m_modal-manual__con__list__h2">공통사항</h2>
				  <p class="m_modal-manual__con__list__p">
				  <input type="hidden" id="certificatetype" >
				  <input type="text" id="nm" maxlength="10" style="width:30%" placeholder="이름">
				  <input type="text" id="pno" onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" maxlength="11"  style="width:30%" placeholder="핸드폰">
				  <button  type="button" name="button" onclick="mx.SMS()" style="width:30%">문자전송</button>
				  <p>

				  <input type="text" id="chkno" onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" maxlength="4"  style="width:30%" placeholder="인증번호">
				  <button   type="button" name="button" onclick="mx.chkSMS()" style="width:30%">인증확인</button>
				</li>
			  </ul>
			  <button  id="btnCloseNotiModal" type="button" name="button" onclick="$('#NotiModal2').fadeOut(300); $('body').removeClass('s_no-scroll');">닫 기</button>
			</section>
        </div>
      </div>
    <!-- e 팝업창 영역 -->


<!-- #include virtual = "/pub/html/swimming/html.footer.home.asp" -->
</html>





