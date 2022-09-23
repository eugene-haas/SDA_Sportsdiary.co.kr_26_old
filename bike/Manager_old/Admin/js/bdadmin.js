$(document).ready (function(){
  registration();  /* 어드민 펼치기 접기  */
  tabletrbg();   /* 테이블 클릭 배경칼라변경  */
  scroll_top(); /* 스크롤 내리면 탑고정 */
  accordianMenu(); /* 어드민 left-vavi 작동 */

	$(".play_detail_modified").on("shown.bs.modal", function(e){
		var $depth2_modal_bg =	$(".modal-backdrop").last();
		$(this).prepend($depth2_modal_bg);
	})

});

/* s: 어드민 펼치기 접기 */
function registration(){
  var $registration_box = $(".registration_box");
  var $open_btn = $(".open_btn");
  var $esc_btn = $(".esc_btn");
  var $trActive = $("#contest tr.active");
  $open_btn.click(function(){
    $registration_box.css('display','block').addClass('on');
    $esc_btn.css('display','inline-block');
  });
  $esc_btn.click(function(){
    $registration_box.css('display','none').removeClass('on');
    $esc_btn.css('display','none');
  });
}
/* e: 어드민 펼치기 접기 */

/* s: 테이블 클릭 배경칼라변경 */
function tabletrbg(){
  var $registration_box = $(".registration_box");
  var $on_click_bg = $("#contest > tr");
  var $esc_btn = $(".esc_btn");
  $on_click_bg.click (function(){
      $on_click_bg.removeClass('active');
      $(this).addClass('active');
  })
  $on_click_bg.click(function(){
    if($on_click_bg.hasClass('active')){
      $registration_box.css('display','block');
      $esc_btn.css('display','inline-block');
    }
  })
}
/* e: 테이블 클릭 배경칼라변경 */

/* s: 스크롤 내리면 탑고정 */
function scroll_top(){
  var $top_fixe = $(".top_fixe");
  var $registration_box = $(".registration_box");
  var $subSearch = $('.sub_search');
  var $topFixeH = $('.top_fixe').height();
  $top_fixe.addClass("absolute");
  // $(".sub_search").css('margin-top','20px');
  $(window).scroll(function(){
    if($(window).scrollTop() > $topFixeH){  /* $topFixeH 수정 80 */
      $top_fixe.addClass("fixed");
      $top_fixe.removeClass("absolute");
      var $topFixeH = $('.top_fixe').height();
      //if($topFixeH){
        //$subSearch.css({
          //'position':'fixed',
          //'marginTop': $topFixeH
        //});
      //}
    }else{
      $top_fixe.addClass("absolute");
      $top_fixe.removeClass("fixed");
    }
  });


} // scroll_top end
/* e: 스크롤 내리면 탑고정 */


/**
 * --------------------------------
 * accordian 메뉴
 * --------------------------------
 */
function accordianMenu() {
  /**
   * 사용할 지역 변수
   * 1. 전체를 감싸는 wrap (deco) : #left-navi
   * 2. 하나의 depth    : 대 카테고리 - depth
   * 3. depth_1_btn   : depth1버튼 h2
   * 4. depth-2          : depth-2 요소들
   * 5. depth_2_btn   : depth2버튼 - menu-btn
   * 6. depth_3          : depth-3
   * 7. depth_3_btn   : depth3버튼 - a태그
   */
  // 지역 변수 선언
  var $leftMenu = null;    // 전체를 감싸는 wrap (deco) : #left-navi

  /* 카테고리 depth */
  var $depth = null;  // 하나의 depth    : 대 카테고리 - depth
  var $depth2 = null;  // depth-2 요소들
  var $depth3 = null;  // depth-3 요소들

  /* 버튼 2개 */
  var $depth1Btn = null;  // depth1버튼 h2
  var $depth2Btn = null;  // depth2버튼 - .menu-btn
  var SLIDESPEED = 0; // 슬라이드 속도
  var SLIDEEASING = ""; // 슬라이드 easing


  init();
  initEvent();
  initExec();
  leftmenuHeight();
  /**
   * 변수 초기화
   * 위에서 선언한 변수 각각 초기화
   */
  function init() {
    $leftMenu = $("#left-navi");

    $depth = $(".depth", $leftMenu);
    $depth2 = $(".depth-2", $depth);
    $depth3 = $(".depth-3", $depth);

    $depth1Btn = $("h2", $depth);
    $depth2Btn = $(".menu-btn", $depth2);
    SLIDESPEED = 300;
    SLIDEEASING = "easeInOutQuint"
  }

  /**
   * 이벤트 초기화
   */
  function initEvent() {
    $depth1Btn.on("click", function () {
      toggleDepth2($(this));
    });
    $depth2Btn.on("click", function () {
      toggleDepth3($(this));
    });
  }

  /* 처음 문서 open시 active 메뉴 열기  */
  function initExec() {
    var $activeMenu = $depth3.find("a").filter(".active");/*find 바로 밑에 자식들 filter 찾은것들 중에 필터링 */
    $activeMenu.parents(".depth-2").addClass("on").slideDown(SLIDESPEED, SLIDEEASING);
    $activeMenu.parents(".depth-3").addClass("on").slideDown(SLIDESPEED, SLIDEEASING);
    for(var i=0; i<$depth2.length; i++){
      //console.log($depth2.eq(i).hasClass("on"));
    }
  }

  /* 1단 클릭시 2단 열기/닫기
    $depth2 = $depth2 중에 클릭한 요소 
   */
  function toggleDepth2($this) {
    if (!($this.siblings(".depth-2").hasClass("on"))) {
      $depth2.removeClass("on").slideUp();
      $this.siblings(".depth-2").addClass("on").slideDown(SLIDESPEED, SLIDEEASING);
      return;
    } else {
      $this.siblings(".depth-2").removeClass("on").slideUp(SLIDESPEED, SLIDEEASING);
    }
  }

  /* 2단 클릭시 3단 열기/닫기 */
  function toggleDepth3($this) {
    $(".depth-3").slideUp(100);
    if (!($this.siblings(".depth-3").hasClass("on"))) {
      $depth3.removeClass("on").slideUp();
      $this.siblings(".depth-3").addClass("on").slideDown(SLIDESPEED, SLIDEEASING);
      return;
    } else {
      $this.siblings(".depth-3").removeClass("on").slideUp(SLIDESPEED, SLIDEEASING);
    }
  }

  /* leftmenu 높이 100% */
  function leftmenuHeight() {
    var $winHeight = $(window).height();
    var $headHeight = $("#header").outerHeight(true);
    var $leftHeight = $leftMenu.outerHeight(true);
    var $mainHeight = $(".main").outerHeight(true);
    if ($leftHeight <= $winHeight) {
      $leftMenu.css("height", $winHeight - $headHeight);
    } else{
      // $leftMenu.css("height", $mainHeight);
      $leftMenu.removeAttr("style")
    }
  }
}


