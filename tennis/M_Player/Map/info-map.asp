<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c2d63644c815d3f9c28da9ab8c347311"></script>
<script type="text/javascript">
  //키워드 자동완성 검색키워드 입력
  function input_KeyWord(word){
    $("#fnd_KeyWord").val(word);
  }
  //키워드 자동완성기능
  function view_keyword(){
    if(!$("#fnd_SctGb").val()){
      alert("기관선택을 해주세요");
      $("#fnd_SctGb").focus();
      $("#fnd_KeyWord").val("");
      return;
    }

    var strAjaxUrl="../ajax/info-map-find.asp";
    var fnd_SctGb   = $("#fnd_SctGb").val();
    var fnd_KeyWord   = $("#fnd_KeyWord").val();

    $.ajax({
    url: strAjaxUrl,
    type: 'POST',
    dataType: 'html',
    data: {
      fnd_SctGb : fnd_SctGb ,
      fnd_KeyWord   : fnd_KeyWord ,
      fnd_Type      : 'WAUTO'
    },
    success: function(retDATA) {

      $("#grouplist").html(retDATA);
    }, error: function(xhr, status, error){
      if(error!=""){
			alert ("오류발생! - 시스템관리자에게 문의하십시오!");
			return;
		}
    }
    });
  }

	//단체정보 더보기
	$(function(){
		$('.more').live("click",function()  {
			var strAjaxUrl="../ajax/info-map-find.asp";
			var fnd_SctGb   = $("#fnd_SctGb").val();
			var fnd_KeyWord   = $("#fnd_KeyWord").val();
			var cnt_board   = $("#cnt_board").val();
			var ID = $(this).attr("id");

			if(ID)  {

				$.ajax({
					url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',
					data: {
							fnd_SctGb : fnd_SctGb
							,fnd_KeyWord   : fnd_KeyWord
							,fnd_Type    : 'WFIND'
							,fnd_LastID : ID
							,cnt_board  : cnt_board
						},
					cache: false,
					success: function(retDATA) {
						$(".map-box").append(retDATA);

						$("#more"+ID).remove(); // removing old more button
						$('.info-map').mapToggleImg('.info-map');
						tgMapBtn();

					}, error: function(xhr, status, error){
						if(error!=""){
							alert ("오류발생! - 시스템관리자에게 문의하십시오!");
							return;
						}
					}
				});
			}
			return false;
		});
	});

  //단체정보조회
  function view_match(){

    if(!$("#fnd_SctGb").val()){
      alert("기관선택을 해주세요");
      $("#fnd_SctGb").focus();
      $("#fnd_KeyWord").val("");
      return;
    }

    var strAjaxUrl="../ajax/info-map-find.asp";
    var fnd_SctGb   = $("#fnd_SctGb").val();
    var fnd_KeyWord   = $("#fnd_KeyWord").val();



      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
        fnd_SctGb : fnd_SctGb ,
        fnd_KeyWord   : fnd_KeyWord ,
        fnd_Type    : 'WFIND'
      },
      success: function(retDATA) {

        $(".map-box").html(retDATA);
        $('.info-map').mapToggleImg('.info-map');
        $(".map-slogan").hide();
        $('.map-btn').eq(0).click().addClass('on');
        tgMapBtn();

      }, error: function(xhr, status, error){
       if(error!=""){
			alert ("오류발생! - 시스템관리자에게 문의하십시오!");
			return;
		}
      }
    });

	/*
else{
    alert ("검색할 키워드를 입력하세요");
    return;
    }
	*/
  }

    /**
   * S: 단체정보 조회 지도보기 버튼 toggle
   */
  function tgMapBtn(){
    // var y;
    $('.info-map .map-btn').on('click', function(e){
      $('.daum-map.collapse').on('shown.bs.collapse', function(){
        y = $(this).offset().top;

        $('html, body').stop().animate({
          'scrollTop' : y
        });
      });
      if ($(this).parents('h3').siblings('.daum-map').hasClass('in')) {
        $(this).removeClass('on');
      } else {
        $(this).addClass('on');
      }
      // $('.daum-map').removeClass('in');
      console.log($(this).parents('h3').siblings('.daum-map'));
      e.preventDefault();
    });
  }


  $(document).ready(function(){
    //select box option list
    //element,attname,code,action_type
    make_box("sel_InfoGb","fnd_SctGb","","Info_MapGb");
  });





</script>
<body class="lack-bg">
<input type="hidden" name='cnt_board' id='cnt_board' />
<!-- S: sub-header -->
<div class="sd-header sd-header-sub">
  <!-- #include file="../include/sub_header_arrow.asp" -->
  <h1>단체정보 조회</h1>
  <!-- #include file="../include/sub_header_gnb.asp" -->
</div>
<!-- #include file = "../include/gnb.asp" -->
<!-- E: sub-header -->

<div class="side-main">
  <!-- S: sub srch-list -->
  <ul class="sub side srch-list clearfix">
    <li>
      <p id="sel_InfoGb">
        <select id="fnd_SctGb" name="fnd_SctGb">
          <!--<option>기관(협회)</option>-->
        </select>
      </p>
    </li>
    <li class="">
      <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" placeholder="검색어 입력" class="has-sub" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onKeyUp="view_keyword();" autocomplete="off">
      <ul class="srch-inpt dropdown-menu" role="menu" id="grouplist"></ul>
    </li>
    <li> <a href="javascript:view_match();" class="btn-gray">검색</a> </li>
  </ul>
  <!-- E: sub srch-list -->
  <!-- S: 문구 -->

  <div class="map-slogan">
    <img src="http://img.sportsdiary.co.kr/sdapp/map/icon_map.png">
    <p>단체정보의 <strong>정확성</strong> 및 <strong>신뢰성</strong>을<br> 담보하지 않습니다.</p>
   스포츠다이어리에서 제공하는 단체정보(주소, 연락처 등)는 단체정보 제공자의 사정의 따라 지연되거나 잘못 표시될 수 있습니다.<br>
    궁금하신 사항은 스포츠다이어리 고객센터를 통해 문의해주시기 바랍니다.
    <a class="btn_customer" href="tel:070-7493-8111">고객센터 070-7493-8111</a>
    </div>

  <!-- E: 문구 -->
  <!-- S: map-box -->
  <div class="map-box" id="map-box">
  </div>
  <!-- E: map-box -->
</div>
<!-- E: side-main -->
<!-- S: footer -->
<div class="footer">
  <!-- S: bottom-menu -->
  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- E: bottom-menu -->
</div>
<!-- E: footer -->
<!-- S: bot-config -->
<!-- #include file= "../include/bot_config.asp" -->
<!-- E: bot-config -->
<script>
    $('input.has-sub').dropdown();
  </script>
</body>
