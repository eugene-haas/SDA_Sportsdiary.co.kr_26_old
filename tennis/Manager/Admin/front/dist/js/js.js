$(document).ready(function(){

    /* HEADER > SLIDE */
    headerSlider();

    /* HEADER > GNB */
    headerGnb();

  /**
   * ready 이후 호출할 기능
   */

   // placeholder IE 하위 대응
   $('input, textarea').placeholder();

   // 팝업 창 사용
   if (!($('.open-pop')))
    popupOpen(addrs);

   // 첨부파일 간격 조절
   arrAddFile();

}); // ready end


/**
 * ready 이전 호출할 기능
 */

function headerSlider(){
  $(".main_slide .bxslider").bxSlider({
    auto:true,
    autoControls: false,
    pager: false, // 배너 추가시 true 로 변경
    // autoHover: true
  });
  $("#main_content .banner_zone .bxslider").bxSlider({
    auto:true,
    autoControls: false,
    pager:false,
  })
}

function headerGnb(){
  $(".gnb").mouseover(function(){
    $(".gnb ul").show();
  });
  $(".gnb").mouseout(function(){
    $(".gnb ul").hide();
  });
  $(".gnb_sub").mouseover(function(){
    $(this).css("background-color","#1689cd");
  });
  $(".gnb_sub").mouseout(function(){
    $(this).css("background-color","#2ea2e6");
  });
}

// 서브페이지 네비게이션 / 배너 조절 함수
function fn_NB(i) {
  $('#' + i).css('display', 'block');
}

// 팝업 오픈
function popupOpen(addrs, w, h){
  if (w === undefined)
    w = 1280;
  if (h === undefined)
    h = 747;
  var popWidth = w; // 팝업창 넓이
  var popHeight = h; // 팝업창 높이
  var winWidth = document.body.clientWidth; // 현재창 넓이
  var winHeight = document.body.clientHeight; // 현재창 높이
  var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
  var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표
  var popLeftPos = (winX + (winWidth - popWidth) / 2); // 팝업 x 가운데
  var popTopPos = (winY + (winHeight - popHeight) / 2)-100; // 팝업 y 가운데


  var popUrl = addrs; //팝업창에 출력될 페이지 URL
  var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
  window.open(popUrl,"",popOption);
}


/* 국가대표팀 tab버튼 */
$('#myTab a').click(function (e) {
  e.preventDefault();
  $(this).tab('show');
});


/* 회원가입 */
$(document).ready(function(){
  var $hhbtn= $('.hhbtn');

  $hhbtn.click(function(){
    $(this).parents('.right_con').next('.show_table').toggle();
  });
});



/* 유도규정 2중탭 */
$(document).ready(function(){
  $('.tab li').click(function(){
    var tab_id = $(this).attr('data-tab');
    $('.tab li').removeClass('active');
    $('.tabcontent').removeClass('current');
    $(this).addClass('active');
    $("#"+tab_id).addClass('current');
  $("#"+tab_id).addClass('tabcontent');
  });
})


/**
 * 유도장 정보 버튼
 */
function stadiumMapBtn(){
  // 첫번째 버튼 활성화
  $('.gym_list:first-child .btn_map').addClass('on');

  // 버튼 클릭시 tab 기능
  $('.gym_list .btn_map').click(function(e){
    $('.gym_list .btn_map').filter('.on').removeClass('on');
    $(this).addClass('on');
  });
}



/* 달력 */
$.datepicker.setDefaults({
  dateFormat: 'yy-mm-dd',
  prevText: '이전 달',
  nextText: '다음 달',
  monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
  monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
  dayNames: ['일', '월', '화', '수', '목', '금', '토'],
  dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
  showMonthAfterYear: true,
  yearSuffix: '년'
});

$(function() {
  $("#datepicker1").datepicker();
});

$.datepicker.setDefaults({
  dateFormat: 'yy-mm-dd',
  prevText: '이전 달',
  nextText: '다음 달',
  monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
  monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
  dayNames: ['일', '월', '화', '수', '목', '금', '토'],
  dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
  showMonthAfterYear: true,
  yearSuffix: '년'
});

$(function() {
  $("#datepicker2").datepicker();
});


/* 메인 모달 팝업 */
$('#myModal').on('shown.bs.modal', function () {
  $('#myInput').focus()
});

function arrAddFile(){
  var $dh_sch = $('.dh_schedule');
  var $btmList = $dh_sch.find('.btm_list');
  var $btmLi = $btmList.find('li');

  $btmLi.each(function(){
    if ($(this).index() > 3) {
      $(this).addClass('empty_tit');
    }
  });
}