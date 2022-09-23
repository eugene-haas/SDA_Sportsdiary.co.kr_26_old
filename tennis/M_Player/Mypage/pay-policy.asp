<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>결제관리</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub-main pay -->
  <div class="sub sub-main pay">
    <!-- S: user-pay -->
    <section class="pay-title">
      <h3>나의요금제</h3>
      <p class="user-name"><span>임현숙(Happysook)</span>님</p>
      <p class="pay-guide">현재 사용하고 계시는 요금제입니다.<br>
다양한 데이터와 빠른 서비스를 제공하겠습니다.</p>
    </section>
    <!-- E: pay-title -->
    <!-- S: pay-info -->
    <div class="pay-info user-pay-info clearfix">
      <h4><span class="type"><!-- <img src="../images/main/pay/icon-coupon@3x.png" alt="일반"> -->일반</span><span>스포츠다이어리 보호자용(월 무제한)</span></h4>
      <ul>
        <li>- 선수의 훈련일지 작성에 따른 훈련데이터 공유</li>
        <li>- 공식경기 데이터 열람조회</li>
        <li>- 라운드별 대회결과 조회(실시간)</li>
        <li>- 라운드별 경기영상 보기</li>
      </ul>
      <p>
        <span>(월 자동결제)</span>
        <div class="money-buy">
          <span class="money">9,900원</span>
          <a href="#" class="buy-btn" data-target="#pay-cancel-bankbook" data-toggle="modal">해지신청</a>
          <a href="#" class="buy-btn" data-target="#pay-cancel-card" data-toggle="modal">해지신청</a>
        </div>
      </p>
    </div>
    <!-- E: pay-info -->
    <!-- S: term-guide 무통장 -->
    <div class="term-guide clearfix">
      <div class="icon-img"><img src="http://img.sportsdiary.co.kr/sdapp/mypage/icon-no-bankbook@3x.png" alt></div>
      <div class="term">
        <p class="tit orangi">무통장입금</p>
        <p class="cont">
          <span>요금제 사용기한: </span>
          <span>2017.12.31 24:00</span>
        </p>
      </div>
    </div>
    <!-- E: term-guide 무통장 -->
    <!-- S: term-guide 휴대폰 -->
    <div class="term-guide clearfix">
      <div class="icon-img"><img src="http://img.sportsdiary.co.kr/sdapp/mypage/icon-slim-phone@3x.png" alt></div>
      <div class="term">
        <p class="tit orangi">휴대폰결제</p>
        <p class="cont">
          <span>요금제 결제일: </span>
          <span>2017.12.31 24:00</span>
        </p>
      </div>
    </div>
    <!-- E: term-guide 휴대폰 -->
    <!-- S: term-guide 카드 -->
    <div class="term-guide clearfix">
      <div class="icon-img"><img src="http://img.sportsdiary.co.kr/sdapp/mypage/icon-card@3x.png" alt></div>
      <div class="term">
        <p class="tit orangi">카드결제</p>
        <p class="cont">
          <span>요금제 결제일: </span>
          <span>2017.12.31 24:00</span>
        </p>
      </div>
    </div>
    <!-- E: term-guide 카드 -->
  </div>
  <!-- E: sub-main pay -->

  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->

  <!-- S: pay-modal bankbook 무통장 -->
  <div class="modal fade confirm-modal" id="pay-cancel-bankbook" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><img src="http://img.sportsdiary.co.kr/sdapp/public/close-x@3x.png" alt="닫기"></span></button>
          <h4 class="modal-title" id="myModalLabel">요금제 해지하기</h4>
        </div>
        <div class="modal-body">
          <p class="txt">
            <span>홍길동 </span>님, <br>
            이용기간 중 서비스 해지시,<br>
            다음 결제일 이후부터 해지됩니다.<br>
            해지된 이후부터는 데이터 서비스를<br>
            이용하실 수 없으며 해지를 원하시면<br>
            고객센터로 문의바랍니다.
          </p>
          <p class="phone orangi">02)000-0000</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        </div>
      </div>
    </div>
  </div>
  <!-- E: pay-modal bankbook 무통장 -->

    <!-- S: pay-modal card 카드 휴대폰  -->
  <div class="modal fade confirm-modal" id="pay-cancel-card" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><img src="http://img.sportsdiary.co.kr/sdapp/public/close-x@3x.png" alt="닫기"></span></button>
          <h4 class="modal-title" id="myModalLabel">요금제 해지하기</h4>
        </div>
        <div class="modal-body">
          <p class="txt">
            <span>홍길동 </span>님, <br>
            자동결제 이용기간 중 이용 해지 시,<br>
            다음 결제일 이후부터 해지됩니다.<br>
            자동결제가 해지된 이후부터는 데이터<br>
            서비스를 이용하실 수 없습니다.<br>
            그래도 서비스를 해지 하시겠습니까?
          </p>
          <p class="phone orangi">서비스 해지일: 2017.02.05</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-cancel" data-dismiss="modal">취소</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">해지</button>
        </div>
      </div>
    </div>
  </div>
  <!-- E: pay-modal card 카드 휴대폰 -->

  <!-- S: bot-config -->
  <!-- #include file="../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
