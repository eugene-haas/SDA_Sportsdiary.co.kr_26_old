$(document).ready(function () {
  // contentheight(); /* content 높이 */
  leftgnb(); /* left-gnb */
})

// function contentheight() {
//   var $tableLconheight = $(".basic_setting .tab-content .tab-1 .seting-list ul li .l-name");
//   var $tableRconheight = $(".basic_setting .tab-content .tab-1 .seting-list ul li .r-con").outerHeight(true);
//   var $Rconheight = $(".basic_setting .tab-content .tab-1 .seting-list ul li .r-con");
//   var $rHeight = $tableLconheight.css("height",$tableRconheight + 30).outerHeight(true);
//   $Rconheight.css("height",$rHeight);
// }

function leftgnb() {
  /**
   * 사요알 지역변수
   * 1.depth-2
   * 2.depth-2-con
   */
  var $depthTow =null;
  var $depthTowcon = null;
  var SLIDESPEED = 0; // 슬라이드 속도
  var SLIDEEASING = ""; // 슬라이드 easing

  init();
  initEvent();
  function init() {
    $depthTow = $(".left-gnb .panel-body ul li .depth-2");
    $depthTowcon = $(".left-gnb .panel-body ul li .depth-2-con");
    SLIDESPEED = 100;
    SLIDEEASING = "easeInOutSine"
  }
  function initEvent() {


    $depthTow.addClass("on");
	if($(".depth-2-con").hasClass("on")){
		$(".depth-2-con.on").slideDown(SLIDESPEED, SLIDEEASING);
	}else{
		$depthTowcon.slideUp(SLIDESPEED, SLIDEEASING);
	}
    $depthTow.click(function () {
      if(!($(this).siblings(".depth-2-con").hasClass("on"))){
        $(this).removeClass("on");
        $(this).addClass("off");
				$(this).siblings(".depth-2-con").addClass("on").slideDown(SLIDESPEED, SLIDEEASING);
				return;
      }else{
        $(this).addClass("on");
        $(this).removeClass("off");
        $(this).siblings(".depth-2-con").removeClass("on").slideUp(SLIDESPEED, SLIDEEASING);
      }
    });
  }
}