<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
	<!-- #include file="../include/config.asp" -->

	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=09d9631f067e43ba998c6c82aed9449e&libraries=services"></script>
	<style>
		.m_header.s_sub{border-bottom:0;}

		.m_hidden{display:none;}
		.m_bgLightGray{background-color: #f2f2f2;}


		/* .m_board{margin:10px 0;padding:0 10px;border-bottom:1px solid #ddd;background-color:#fff;}
		.m_board.s_last{border-bottom:0;margin-bottom:0;}
		.m_board__tit{position:relative;margin-top:2px;height:38px;padding-top:13px;border-bottom:1px solid #ddd;font-size:16px;letter-spacing:-.02em;font-weight:500;line-height:100%;}
		.m_board__moreBtn{position:absolute;width:34px;height:34px;right:0;bottom:0;background-color:#dedede;background:url('http://img.sportsdiary.co.kr/sdapp/public/btn_more@3x.png') no-repeat right bottom 5px/22px;font-size:0;border:0;} */


		.m_tabMenu{display:flex;height:44px;background:#fff;font-family:'NotoKR', sans-serif; border-bottom:1px solid #ddd;}
		.m_tabMenu__wrapBtn{display:block;width:25%;height:38px;line-height:38px;}
		.m_tabMenu__btn{width:100%;height:100%;text-align:center;color:#444444;font-size:15px;letter-spacing:-.02em;font-weight:500;}
		.m_tabMenu__btn.s_active{border-bottom:2px solid #1390d4;color:#005895;}


		.m_quick{display:flex;height:73px;margin:10px 0;padding:0 10px;background:#fff;border-bottom:1px solid #ddd;color:#333;text-align:center;font-size:12px;}
		.m_quick__btn{display:block;width:34%;height:100%;}
		.m_quick__btn::before{display:block;content:'';width:44px;height:44px;margin:5px auto 2px;border-radius:44px;}
		.m_quick__btn.s_attend::before{background:#005895 url('http://img.sportsdiary.co.kr/sdapp/te/ic_trophy@3x.png') no-repeat center/44px;}
		.m_quick__btn.s_lesson::before{background:#005895 url('http://img.sportsdiary.co.kr/sdapp/te/ic_callLesson@3x.png') no-repeat center/44px;}
		.m_quick__btn.s_use::before{background:#005895 url('http://img.sportsdiary.co.kr/sdapp/te/ic_callUse@3x.png') no-repeat center/44px;}


		/* .m_quick.s_float{height:34px;  padding:5px 10px; justify-content:space-between; color:#fff; }
		.m_quick__btn.s_float{ width:90px; height:24px; border-radius:34px; padding:6px 0;  line-height:100%; font-size:14px; letter-spacing:-0.05em; }
		.m_quick__btn.s_float::before{display:none;}
		.m_quick__btn.s_attend.s_float{background:#005895 url('http://img.sportsdiary.co.kr/sdapp/te/ic_trophy@3x.png') no-repeat left 7px center/auto 20px; text-indent:13px;}
		.m_quick__btn.s_lesson.s_float{background:#005895 url('http://img.sportsdiary.co.kr/sdapp/te/ic_callLesson@3x.png') no-repeat left 7px center/auto 24px; text-indent:20px;}
		.m_quick__btn.s_use.s_float{background:#005895 url('http://img.sportsdiary.co.kr/sdapp/te/ic_callUse@3x.png') no-repeat left 7px center/auto 24px; text-indent:20px;} */


		.court .introTxt{margin:10px auto;font-size:14px;font-weight:300;color:#666;letter-spacing:-.02em;line-height:160%;}
		.court .map{margin-top:10px;height:200px;background-color:#eee;}
		.court .addrTxt{margin-top:9px;margin-bottom:10px;font-size:14px;letter-spacing:-.02em;color:#666;line-height:120%;}


		.m_coach{margin:10px auto;}
		.m_coach__img{width:145px;height:180px;float:left;}
		.m_coach__intro{float:left;width:calc(100% - 145px);min-height:225px;font-size:12px;letter-spacing:-.02em;color:#666;font-weight:300;padding-left:10px;}
		.m_coach__hist{margin-bottom:10px;}
		.m_coach__item{position:relative;padding-left:7px;line-height:140%;color:inherit;letter-spacing:inherit;}
		.m_coach__bar{position:absolute;left:0px;}
		.m_coach__special{position:relative;padding-left:7px;line-height:150%;color:inherit;letter-spacing:inherit;}
		.m_coach__star{position:absolute;left:0;top:2px;}


		.m_timeList{color:#666;letter-spacing:-.02em;font-size:14px;font-weight:300;line-height:145%;}


		.m_roundTbl__cap{margin:18px 0 9px 0;color:#333;font-size:14px;letter-spacing:-.02em;line-height:100%;}
		.m_roundTbl__tbl{width:100%;font-size:14px;letter-spacing:-.02em;border-spacing:0;}
		.m_roundTbl__thd{background-color:#bbb;color:#fff;}
		.m_roundTbl__tbd{background-color:#f2f2f2;color:#666;text-align:center;}
		.m_roundTbl__cell{padding:6px 0;border-left:1px solid #ddd;}
		.m_roundTbl__cell.s_th{text-align:center;font-weight:400;}
		.m_roundTbl__cell.s_th:first-child{border-radius:4px 0 0 0;border-left:0;}
		.m_roundTbl__cell.s_th:last-child{border-radius:0 4px 0 0;}
		.m_roundTbl__cell.s_td:first-child{border-radius:0 0 0 4px;border-left:0;}
		.m_roundTbl__cell.s_td:last-child{border-radius:0 0 4px 0;}


		.m_txtWran{margin-top:10px;font-size:12px;font-weight:300;letter-spacing:-.02em;color:#999;line-height:100%;}


		.m_photoList2{margin:10px auto;font-size:0;line-height:0;}
		.m_photoList2__item{position:relative;display:inline-block;width:calc(50% - 5px);vertical-align:top;margin-left:10px;margin-bottom:10px;}
		.m_photoList2__more{font-size:14px;width:100%;height:33.3333px;background-color:#005995;color:#fff;border:0;margin-top:10px;}
		@media all and (orientation: portrait){
			.m_photoList2__item:nth-of-type(2n-1){margin-left:0;}
			.m_photoList2__item:nth-last-of-type(1),
			.m_photoList2__item:nth-last-of-type(2){margin-bottom:0;}
		}
		@media all and (orientation: landscape){
			.m_photoList2__item{width:calc(25% - 7.5px);}
			.m_photoList2__item:nth-of-type(4n-3){margin-left:0;}
			.m_photoList2__item:nth-last-of-type(1),
			.m_photoList2__item:nth-last-of-type(2),
			.m_photoList2__item:nth-last-of-type(3),
			.m_photoList2__item:nth-last-of-type(4){margin-bottom:0;}
		}
	</style>
</head>
<body>
<div class="l">

	<!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
		<div class="m_header s_sub">
			<!-- #include file="../include/header_back.asp" -->
			<h1 class="m_header__tit">인천 송도 달빛공원 국제 테니스장</h1>
			<!-- #include file="../include/header_gnb.asp" -->
		</div>

		<div class="m_tabMenu">
	    <span class="m_tabMenu__wrapBtn"><a href="songdo_court.asp" class="m_tabMenu__btn s_active [ _s_tabBtn ]">코트정보</a></span>
	    <span class="m_tabMenu__wrapBtn"><a href="songdo_coach.asp" class="m_tabMenu__btn [ _s_tabBtn ]">강사소개</a></span>
	    <span class="m_tabMenu__wrapBtn"><a href="songdo_lesson.asp" class="m_tabMenu__btn [ _s_tabBtn ]">레슨안내</a></span>
	    <span class="m_tabMenu__wrapBtn"><a href="songdo_use.asp" class="m_tabMenu__btn [ _s_tabBtn ]">이용안내</a></span>
	  </div>
	</div>

  <div class="m_bgLightGray l_content m_scroll [ _content _scroll ]">
    <div class="m_quick  [ _quickBtnWrap ]">
      <!-- <a href="http://rt.sportsdiary.co.kr/tnrequest/list.asp" class="m_quick__btn s_attend  [ _quickBtn ]">대회참가</a> -->
			<a href="http://rt.sportsdiary.co.kr/tnrequest/list.asp" class="m_quick__btn s_attend  [ _quickBtn ]">대회참가</a>
      <a href="tel:01022154980" class="m_quick__btn s_lesson  [ _quickBtn ]">레슨문의</a>
      <a href="tel:01050334980" class="m_quick__btn s_use  [ _quickBtn ]">이용문의</a>
    </div>

		<section id="DP_Section"></section>
  </div>

	<!-- layer photoList viewer -->
  <div class="l_upLayer [ _overLayer _overLayer__photoList ]" >
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox [ _overLayer__box ]">
      <div class="l_upLayer__wrapTit">
        <h1 class="l_upLayer__tit [ _overLayer__title ]">현장스케치</h1>
        <button class="l_upLayer__close [ _overLayer__close ]">닫기</button>
      </div>
      <div class="l_uplayer__wrapCont [ _overLayer__wrap ]">

				<!-- S: main banner 01 -->
				<!-- <div class="major_banner">
			    <div class="banner banner_sm carousel">
			      <div>
			    		<div style="background-color: #D7E5E6"> <a href="javascript:;" onclick="" class="banner_area"> <img src="/ADImgR/tennis/스다몰_아이더패딩다운자켓3차.jpg" alt=""> </a> </div>
			      </div>
			    </div>
			  </div> -->
				<!-- E: main banner 01 -->

				<div class="pd10">

					<div id="DP_PhotoList" class="m_photoList2">

						<img src="" data-no="0" tabindex="-1" class="m_photoList2__item [ _openViewLayer _listItem ]">

						<!-- <img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_2018103011422846.jpg" data-no="1" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]">

						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_2018103011422810.jpg" data-no="2" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]">

						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_2018103011422754.jpg" data-no="3" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]">

						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_2018103011422787.jpg" data-no="4" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]">

						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_201810301142271.jpg" data-no="5" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]">

						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_2018103011422795.jpg" data-no="6" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]">

						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_2018103011422782.jpg" data-no="7" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]">

						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_201810301142273.jpg" data-no="8" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]">

						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_201810301142273.jpg" data-no="8" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]">

						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_201810301142273.jpg" data-no="9" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]">

						<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_201810301142273.jpg" data-no="10" tabindex="-1" class="m_photoList2__item [ _openViewLayer ]"> -->

					</div>

					<button id="PhotoMore" class="m_photoList2__more">더보기</button>

				</div>

      </div>
    </div>
  </div>

	<!-- layer photo viewer -->
  <div class="l_upLayer [ _overLayer _overLayer__photoView ]" >
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox [ _overLayer__box ]">
      <div class="l_upLayer__wrapTit">
        <h1 class="l_upLayer__tit [ _overLayer__title ]">현장스케치</h1>
        <button class="l_upLayer__close [ _overLayer__close ]">닫기</button>
      </div>
      <div class="l_uplayer__wrapCont  [ _overLayer__wrap ]">

				<!-- S: main banner 01 -->
				<!-- <div class="major_banner">
			    <div class="banner banner_sm carousel">
			      <div>
			    		<div style="background-color: #D7E5E6"> <a href="javascript:;" onclick="" class="banner_area"> <img src="/ADImgR/tennis/스다몰_아이더패딩다운자켓3차.jpg" alt=""> </a> </div>
			      </div>
			    </div>
			  </div> -->
				<!-- E: main banner 01 -->

				<div class="sd_photoViewer__swiper [ _photoViewer__swiper swiper-container ]">
          <div class="[ swiper-wrapper ]"></div>
        </div>


      </div>
    </div>
  </div>

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
	<script>
		var $body = $('body');
		var $tabBtns = $('._s_tabBtn');

		var historyManager = new HistoryManager();
	  historyManager.setReferrer('../Main/index.asp');
	  historyManager.replaceHistory({url:'http://tennis.sportsdiary.co.kr/tennis/M_Player/Ad/songdo_court.asp', btnIndex:0, type:'none'});
	  historyManager.addPopEvent(function(evt){
		 if(evt.state.url){
			 $tabBtns.removeClass('s_active');
			 $tabBtns.eq(evt.state.btnIndex).addClass('s_active');
			 getSection(evt.state.url);
			 layer_list.close();
			 // history.replaceState('view', null, null);
		 }

		 if(evt.state.type == 'none'){
			 layer_list.close();
		 }
		 else if(evt.state.type == 'list'){
			 layer_viewer.close();
		 }
		 else
			 location.href = document.referrer || historyManager.referrer;
	 });

		$tabBtns.on('click', function(evt){
			evt.preventDefault();
			var url = this.href;

			$tabBtns.removeClass('s_active');
			$(this).addClass('s_active');

			historyManager.pushHistory({ 'url':url, 'btnIndex':$tabBtns.index(this), type:'none' });

			getSection(url);

			$('._content _scroll').scrollTop(0);
		});

		getSection('http://tennis.sportsdiary.co.kr/tennis/M_Player/Ad/songdo_court.asp');

		function getSection(url){
			$.ajax({
				url: url
			}).done(function(data){
				var html = data;
				$('#DP_Section').replaceWith($(html));

				console.log(url)
				if(url == 'http://tennis.sportsdiary.co.kr/tennis/M_Player/Ad/songdo_court.asp'){

					var container = document.getElementById('map'); // 이미지 지도를 표시할 div
					var options = {
						center: new daum.maps.LatLng(33.450701, 126.570667), // 이미지 지도의 중심좌표
						level: 3
					};
					var map = new daum.maps.Map(container, options);

					// 주소-좌표 변환 객체를 생성합니다
					var geocoder = new daum.maps.services.Geocoder();

					// 주소로 좌표를 검색합니다
					geocoder.addressSearch('인천 연수구 컨벤시아대로 43', function(result, status){

						// 정상적으로 검색이 완료됐으면
						 if (status === daum.maps.services.Status.OK){
								var coords = new daum.maps.LatLng(result[0].y, result[0].x);

								// 결과값으로 받은 위치를 마커로 표시합니다
								var marker = new daum.maps.Marker({
										map: map,
										position: coords
								});

								// 인포윈도우로 장소에 대한 설명을 표시합니다
								// var infowindow = new daum.maps.InfoWindow({
								// 		content: '<div style="width:150px; height: 50px; display:inline-block; text-align:center;"></div>'
								// });
								//
								// infowindow.open(map, marker);

								// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
								map.setCenter(coords);
							}

					});
				}

			}).fail(function(xhr, status, errorThrown){ });
		}

	</script>
	<script>
		var pageCnt = 1;
		var listLength = 12;
		var imgList = [];

		var $list = $('#DP_PhotoList');
		var $more = $('#PhotoMore');

		var $listItem = $('._listItem');
		var $donwload = $('._download');
		var $swiperWarpper = $('.swiper-wrapper');

		var swiper_viewer = new Swiper('._photoViewer__swiper');
		swiper_viewer.on('slideChange', function(){

			$('[data-no="'+swiper_viewer.activeIndex+'"]').focus();

			setTimeout(function(){
			  $swiperWarpper.css({'height':'100%'});
			  swiper_viewer.updateAutoHeight();
			},1);

			var swiperPageNo = Math.floor(swiper_viewer.activeIndex/listLength);

			if((swiper_viewer.activeIndex%listLength) == 0 && (pageCnt == swiperPageNo)){
			  listMore();
			}

		});

		var layer_list = new OverLayer({
      overLayer: $('._overLayer__photoList'),
			transition: false,
      emptyHTML: '정보를 불러오고 있습니다.',
      errorHTML: ''
    });
		layer_list.on('beforeOpen', function(){
			historyManager.pushHistory({'type':'list'});
		});

		var layer_viewer = new OverLayer({
      overLayer: $('._overLayer__photoView'),
			transition: false,
      emptyHTML: '정보를 불러오고 있습니다.',
      errorHTML: ''
    });
		layer_viewer.on('beforeOpen', function(){
			historyManager.pushHistory({'type':'view'});
		});


		$body.on('click', '._openViewLayer', function(evt){
			layer_list.open({title:'인천 송도 달빛공원 국제 테니스장'});
			layer_viewer.open({title:'인천 송도 달빛공원 국제 테니스장'});
			viewer_open.call(this);
		});

		$body.on('click', '._openListLayer', function(evt){
			console.log('a');
			layer_list.open({title:'인천 송도 달빛공원 국제 테니스장'});
		});

		$more.on('click', function(){
			listMore();
		})

		listInit();

		function listInit(){
			pageCnt = 1;

			swiper_viewer.removeAllSlides();

			fn_List(pageCnt, appendList);

			$more.css({'display':'block'});
		}

		function listMore(){
			pageCnt++;
			fn_List(pageCnt, appendList);
		}

		function appendList(retDATA){
			if(retDATA == '') return;

			// var data = JSON.parse(retDATA);
			var data = retDATA;
			var totalCnt = data[0]['cnt'];
			var imgs = data[0]['links'];
			var html = '';

			if(pageCnt == 1){
				$list.html('');
				$more.css({'display':'block'});
			}

			if(Math.ceil(totalCnt/listLength) == pageCnt){
				$more.css({'display': 'none'});
			}

			if(pageCnt == 1){
				var slides = [];
				for(var i=0; i<totalCnt; i++){
					slides.push(
						'<div class="sd_photoViewer__slide [ swiper-slide ]"><img src="http://img.sportsdiary.co.kr/sdapp/empty/img_empty@3x.gif" class="sd_photoViewer__img"></div>'
					);
				}
				swiper_viewer.appendSlide(slides);
			}

			imgs.forEach(function(item, index){

				var gIndex = (index + ((pageCnt-1)*listLength));

				if($listItem.length !=0 ){
					var $clone = $listItem.clone(true);
					$clone.attr('src', 'songdo/photo460/' + item.link);
					$clone[0].dataset.no = gIndex;
					$list.append($clone);

				}
				// else{
				// 	$list.append('<img src="' + (item.link) + '" data-no="' + gIndex +'" tabIndex="-1" class="sd-photoList__img [ sd_photoList__item ]" >');
				// }


				swiper_viewer.slides[gIndex].getElementsByTagName('img')[0].src = 'songdo/photo1920/' + item.link;
				imgList.push(item.link);

			});
		}

		function viewer_open(callEl){
      layer_viewer.open();
      swiper_viewer.updateAutoHeight();
      swiper_viewer.slideTo(this.dataset.no, 0);
    }

		function fn_List(count, callback){

			var list = [
				[{
					"cnt":"87",
					"links":[
						{"link":"1.jpg"},
						{"link":"2.jpg"},
						{"link":"3.jpg"},
						{"link":"4.jpg"},
						{"link":"5.jpg"},
						{"link":"6.jpg"},
						{"link":"7.jpg"},
						{"link":"8.jpg"},
						{"link":"9.jpg"},
						{"link":"10.jpg"},
						{"link":"11.jpg"},
						{"link":"12.jpg"}
					]
				}],
				[{
					"cnt":"87",
					"links":[
						{"link":"13.jpg"},
						{"link":"14.jpg"},
						{"link":"15.jpg"},
						{"link":"16.jpg"},
						{"link":"17.jpg"},
						{"link":"18.jpg"},
						{"link":"19.jpg"},
						{"link":"20.jpg"},
						{"link":"21.jpg"},
						{"link":"22.jpg"},
						{"link":"23.jpg"},
						{"link":"24.jpg"}
					]
				}],
				[{
					"cnt":"87",
					"links":[
						{"link":"25.jpg"},
						{"link":"26.jpg"},
						{"link":"27.jpg"},
						{"link":"DSC00463.jpg"},
						{"link":"DSC00466.jpg"},
						{"link":"DSC00469.jpg"},
						{"link":"DSC00476.jpg"},
						{"link":"DSC00478.jpg"},
						{"link":"DSC00484.jpg"},
						{"link":"DSC00499.jpg"},
						{"link":"DSC00502.jpg"},
						{"link":"DSC00503.jpg"}
					]
				}],
				[{
					"cnt":"87",
					"links":[
						{"link":"DSC00509.jpg"},
						{"link":"DSC00518.jpg"},
						{"link":"DSC00521.jpg"},
						{"link":"DSC00523.jpg"},
						{"link":"DSC00537.jpg"},
						{"link":"DSC00539.jpg"},
						{"link":"DSC00541.jpg"},
						{"link":"DSC00549.jpg"},
						{"link":"DSC00562.jpg"},
						{"link":"DSC00567.jpg"},
						{"link":"DSC00568.jpg"},
						{"link":"DSC00572.jpg"}
					]
				}],
				[{
					"cnt":"87",
					"links":[
						{"link":"DSC00576.jpg"},
						{"link":"DSC00594.jpg"},
						{"link":"DSC00604.jpg"},
						{"link":"DSC00613.jpg"},
						{"link":"DSC00617.jpg"},
						{"link":"DSC00619.jpg"},
						{"link":"DSC00621.jpg"},
						{"link":"DSC00625.jpg"},
						{"link":"DSC00629.jpg"},
						{"link":"DSC00631.jpg"},
						{"link":"DSC00633.jpg"},
						{"link":"DSC00637.jpg"}
					]
				}],
				[{
					"cnt":"87",
					"links":[
						{"link":"DSC00640.jpg"},
						{"link":"DSC00648.jpg"},
						{"link":"DSC00672.jpg"},
						{"link":"DSC00680.jpg"},
						{"link":"DSC00684.jpg"},
						{"link":"DSC00689.jpg"},
						{"link":"DSC00701.jpg"},
						{"link":"DSC00703.jpg"},
						{"link":"DSC00717.jpg"},
						{"link":"DSC00722.jpg"},
						{"link":"DSC00730.jpg"},
						{"link":"DSC00735.jpg"}
					]
				}],
				[{
					"cnt":"87",
					"links":[
						{"link":"DSC00736.jpg"},
						{"link":"DSC00740.jpg"},
						{"link":"DSC00757.jpg"},
						{"link":"DSC00758.jpg"},
						{"link":"DSC00759.jpg"},
						{"link":"DSC00760.jpg"},
						{"link":"DSC00761.jpg"},
						{"link":"DSC00762.jpg"},
						{"link":"DSC00769.jpg"},
						{"link":"DSC00774.jpg"},
						{"link":"DSC00782.jpg"},
						{"link":"DSC00783.jpg"},
					]
				}],
				[{
					"cnt":"87",
					"links":[
						{"link":"DSC00784.jpg"},
						{"link":"DSC00785.jpg"},
						{"link":"DSC00800.jpg"}
					]
				}],
			]


			callback(list[count - 1]);
		}



	</script>
	<!-- <script>
		$('._content _scroll').on('scroll', function(evt){
			console.log('scrollTop', $(this).scrollTop());

			console.log($('._quickBtnWrap')[0].offsetTop - 96)

		});

		$('._content _scroll').on('touchstart', function(evt){
			// console.log('touchstart');
			// console.log(evt.touches[0].clientY);

		});

		$('._content _scroll').on('touchmove', function(evt){
			// console.log('touchmove');
			// console.log(evt.touches[0].clientY);

			// console.log('move scrollTop', $('._content _scroll').scrollTop());
		});

		$('._content _scroll').on('touchend', function(evt){
			console.log('touchend');
		});
	</script> -->
</div>
</body>
</html>
