<!DOCTYPE html>
<html lang="ko">
  <head>
    <!--#include file="../include/head.asp"-->
    <title>참가신청서 작성-대한수영연맹</title>
  </head>
  <body>
    <!-- s 헤더 영역 -->
      <header class="l_header">
        <div class="l_header-wrap clear">
          <h1 class="l_header__con">
            참가신청서 작성
          </h1>
          <button id="btnOpenManual" class="l_header__manual" type="button" name="button">메뉴얼</button>
        </div>
      </header>
    <!-- e 헤더 영역 -->

    <!-- s 메인 영역 -->
      <div class="l_main">
        <section class="l_main__contents">
          <!--#include file="../include/m_apply-parti.asp"-->
        </section>
      </div>
    <!-- e 메인 영역 -->

    <!-- s 팝업창 영역 -->
      <!-- div.s_show = 팝업창 보이게 -->
      <div class="l_modal-wrap" id="applyCompleteModal">
        <div class="l_modal">
          <section class="m_modal-apply-noti t_alert">
            <span class="m_modal-apply-noti__header">대회 참가신청 완료</span>
            <span class="m_modal-apply-noti__con">참가 신청이 완료되었습니다.</span>
            <div class="m_modal-apply-noti__btns clear">
              <button onclick="closeModal()" id="btnOk-ApplyCancelModal" type="button" name="button">확인</button>
            </div>
          </section>
        </div>
      </div>
    <!-- e 팝업창 영역 -->
    <script>
      // 버튼이벤트
        $('button').on('click',function(){
          console.log($(this).attr('id') + ' click!');
        });
        $('#btnCompleteApplyPay').on('click', function(){
          $('#applyCompleteModal').fadeIn(300);
          $('body').addClass('s_no-scroll');
        });
        function closeModal(){
          $('.l_modal-wrap').fadeOut(300);
          $('body').removeClass('s_no-scroll');
        }
      </script>
  </body>
</html>
