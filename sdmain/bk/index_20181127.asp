<!--#include file="./include/config.asp"-->
<%
	'로그인하지 않았다면 login.asp로 이동2018 전국 여성배드민턴대회 및 전국시도대항리그전
	'베타오픈시 주석처리, 정식오픈때 주석해제해야합니다.
	'Check_Login()

	'통합메인을 경유하지 않고 바로 유도메인으로 접근을 막기위하여
	dim valSDMAIN : valSDMAIN = encode("sd027150424",0)
	dim AppType : AppType = Request("AppType")


%>
<script>
  //상단 종목 메인메뉴 URL
  function chk_TOPMenu_URL(obj){
    switch(obj){
      case 'judo'      : $(location).attr('href', 'http://judo.sportsdiary.co.kr/M_Player/Main/index.asp'); break;
      case 'tennis'    : $(location).attr('href', 'http://tennis.sportsdiary.co.kr/tennis/M_Player/main/index.asp'); break;
      case 'bike'      : $(location).attr('href', 'http://bike.sportsdiary.co.kr/bike/M_Player/main/index.asp'); break;
      case 'badminton' : $(location).attr('href', 'http://badminton.sportsdiary.co.kr/badminton/M_player/page/institute-schedule.asp'); break;
      default 			   : $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/index.asp');
    }
  }

	function beginInstall(){

	 alert('sportsdiary://AccAuthPopupYN=Y');

	}
</script>
</head>
<body>
<!-- S: main -->
<div class="main category pack">

  <!-- S: top_section -->
  <section class="top_section">
    <h1 class="logo"><img src="images/part/intro_sportsdiary_logo@3x.png" alt="스포츠다이어리"></h1>
    <!-- <h1>
        <a href="http://sportsdiary.co.kr" target="_blank"><img src="images/open_title.png" alt="Start! Open Beta"></a>
      </h1> -->
    <!-- <p class="intro_copy">스포츠다이어리 종목 통합을 위한<br><span class="bluy">오픈베타 서비스</span>를 시작합니다.</p> -->
    <h2 class="slogan">종목을 선택해주세요</h2>
    <ul class="round_btn clearfix">
      <li> <a href="#" onclick="chk_TOPMenu_URL('judo');"> <span class="img_box"> <img src="images/part/ic_judo@3x.png" alt="유도"> </span> <span class="txt">유도</span> </a> </li>
      <li> <a href="#" onclick="chk_TOPMenu_URL('tennis');"> <span class="img_box"> <img src="images/part/ic_tennis@3x.png" alt="테니스"> </span> <span class="txt">테니스</span> </a> </li>
      <!--
        <li>
          <a href="#" onclick="chk_JoinUser('badminton', this);">
            <span class="img_box">
              <img src="images/part/ic_badminton@3x.png" alt="배드민턴">
            </span>
            <span class="txt">배드민턴
            </span>
          </a>
        </li>
		-->

      <!-- <li>
          <a href="javascript:chk_JoinUser('judo');">
            <span class="img_box">
              <img src="images/part/ic_judo@3x.png" alt="유도">
            </span>
            <span class="txt">유도</span>
          </a>
        </li>
        <li>
          <a href="javascript:chk_JoinUser('tennis');">
            <span class="img_box">
              <img src="images/part/ic_tennis@3x.png" alt="테니스">
            </span>
            <span class="txt"><span class="point_yellow">BETA</span> 테니스</span>
          </a>
        </li> -->
      <!-- <li class="ready">
          <div class="ribbon">
            <p>comming<br>soon</p>
          </div>
          <a href="#">
            <span class="img_box">
              <img src="images/part/ic_wrestling@3x.png" alt="레슬링">
            </span>
            <span class="txt">레슬링</span>
          </a>
        </li>
        <li class="ready">
          <div class="ribbon">
            <p>comming<br>soon</p>
          </div>
          <a href="#">
            <span class="img_box">
              <img src="images/part/ic_badminton@3x.png" alt="배드민턴">
            </span>
            <span class="txt">배드민턴</span>
          </a>
        </li>
        <li class="ready">
          <div class="ribbon">
            <p>comming<br>soon</p>
          </div>
          <a href="#">
            <span class="img_box">
              <img src="images/part/ic_kumdo@3x.png" alt="검도">
            </span>
            <span class="txt">검도</span>
          </a>
        </li> -->
        <li>
          <!-- <div class="ribbon">
            <p>comming<br>soon</p>
          </div> -->
          <a href="#" onclick="chk_TOPMenu_URL('bike');">
            <span class="img_box">
              <img src="images/part/ic_cycle@3x.png" alt="자전거">
            </span>
            <span class="txt">자전거</span>
          </a>
        </li>
    </ul>
  </section>
  <div class="main_intro_bg"><img src="images/part/intro_bg@3x.png"></div>
  <!-- E: top_section -->

  <!--
    <div class="cta">
      <a href="./category.asp" class="btn btn-ok btn-block">다음</a>
    </div>
  -->
</div>
<!-- E: main -->

<!-- #include file="./include/footer.asp"-->
<!-- #include file="./include/modal_JoinUs.asp"-->

<script>
    function cateTab() {
      var $cateBtn = $('.round_btn a');
      var $selected = null;
      $cateBtn.click(function(){
        if ($selected) {
          $selected.removeClass('on');
        }
        $selected = $(this);
        $selected.addClass('on');
      })
    }

    // comming soon 버튼 클릭시
    function readyChk() {
      var $readyBtn = $('.ready');
      $readyBtn.click(function(e){
        alert('해당 종목은 서비스 준비중 입니다.')
        e.preventDefault();
      });
    }

    cateTab();
    readyChk();
  </script>
</body>
</html>
