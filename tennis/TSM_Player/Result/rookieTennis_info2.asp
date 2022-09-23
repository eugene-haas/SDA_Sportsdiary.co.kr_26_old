<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=09d9631f067e43ba998c6c82aed9449e&libraries=services"></script>
</head>
<body>
<div class="l">

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">SD 대회안내</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll competitionInfo [ _content _scroll ]">
    <!-- S: main banner 01 -->
		<!-- <div class="major_banner">
      <div class="banner banner_md carousel">
        <div>
    			<div style="background-color:#fff">
						<a class="banner_area" target="_blank" onclick="javascript:;">
							<img src="" alt="">
						</a>
					</div>
        </div>
      </div>
    </div> -->
		<!-- E: main banner 01 -->

    <header class="subHeader">
<!--       <img class="subHeader__img" src="http://img.sportsdiary.co.kr/images/etc/banner/SD_Rookey_tennis_championship_190603.jpg" /> -->
      <h2 class="tit">제1회 헤드컵</h2>
      <p class="addTxt">전국 루키테니스 챔피언십 대회</p>
    </header>

    <section id="tab1" class="m_bg__lGray pdb20">
      <img src="http://img.sportsdiary.co.kr/images/SD/img/head_tennis.png?3" alt="">
      <div class="m_board">
        <!-- <h3 class="m_board__tit">대회관련문의</h3>
        <p class="m_board__txt mgt6 mgb18">
          스포츠다이어리 고객센터: 02-704-0282<br />
          운영시간 9:00 - 18:00 / 점심시간 12:00 - 1:00
        </p> -->
      </div>
    </section>

    <a href="http://rt.sportsdiary.co.kr/tnrequest/list.asp" class="applyBtn">참가신청</a>
    <!-- <a href="javascript:alert('- 대회 참가신청은 2월11일 오전 10시 부터 가능합니다.')" class="applyBtn">참가신청</a> -->
  </div>
  <script>
    //인천송도배 좌표
    var coords = new daum.maps.LatLng(37.39797980415739, 126.65364797730398);
    var map = new daum.maps.Map(document.getElementById('map'), {
      center: coords,
      level: 3
    });
    var marker = new daum.maps.Marker({
        map: map,
        position: coords
    });
    //강원춘천배 좌표
    // var coords2 = new daum.maps.LatLng(37.85551611204005, 127.6915604045517);
    // var map2 = new daum.maps.Map(document.getElementById('map2'), {
    //   center: coords2,
    //   level: 3
    // });
    // var marker = new daum.maps.Marker({
    //     map: map2,
    //     position: coords2
    // });

    $.fn.extend({
      fold: function(text){
        var fg = true;
        var $btn = this.find('._folder__btn');
        var $btnTxt = this.find('._folder__btnTxt');
        var $content = this.find('._folder__con');
        var btnTxt =  text || '자세히보기';

        $content.addClass('s_fold');
        $btnTxt.html(text);
        $btnTxt.addClass('s_fold');

        this.on('click', $btn, function(evt){
          if(fg){
            $content.removeClass('s_fold');
            $btn.addClass('s_unFold');
            $btnTxt.html('접기');
            $btnTxt.removeClass('s_fold');
            fg = false;
          }
          else{
            $content.addClass('s_fold');
            $btn.removeClass('s_unFold');
            $btnTxt.html(btnTxt);
            $btnTxt.addClass('s_fold');
            fg = true;
          }
        });
      }
    })
    $('._folder').eq(0).fold();

    // $('._folder').eq(1).fold();

    $('._folder').eq(1).fold('자세히보기');

  </script>

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->

</div>
</body>
</html>
<!-- #include file="../Library/sub_config.asp" -->