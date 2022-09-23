<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/config.asp" -->

  <%
      dim GameTitleIDX : GameTitleIDX = fInject(request("GameTitleIDX"))
      dim CSQL, CRs
      dim TeamGbIDX
      dim top_index : top_index = 3

      IF GameTitleIDX <> "" Then
          CSQL =  "EXEC Stadium_Sketch_select_list @GameTitleIDX = '"&GameTitleIDX&"'"
          'Response.write CSQL
          SET CRs = DBCon4.Execute(CSQL)
          IF Not(CRs.Eof OR CRs.Bof) Then
              TeamGbIDX = CRs("TeamGbIDX")
          Else
              Response.write "<script>"
              response.write "    alert('일치하는 정보가 없습니다.'); "
              response.write "    history.back();"
              response.write "</script>"
              response.end
          End IF
              CRs.close
          SET CRs = Nothing
      Else
          Response.write "<script>"
          response.write "    alert('잘못된 접근입니다. 확인 후 이용하세요.'); "
          response.write "    history.back();"
          response.write "</script>"
          response.end
      End IF
  %>
  <!-- <script src="../js/library/jquery-1.12.2.min.js"></script>
  <script src="../js/library/jquery.easing.1.3.min.js"></script> -->


  <!-- S: !@# -->
  <!-- S: as-is -->
  <script type="text/javascript">
    function sketch_download(FileName,FilePath){
      document.getElementById('FileName').value = FileName;
      //return;
      document.sketchForm.target="sketch_download"
      document.sketchForm.action='stadium_sketch_download.asp'
      document.sketchForm.submit();
    }
    
    function change_teamgb(obj){
      var GameTitleIDX = '<%=GameTitleIDX%>';
      var r_TeamGbIDX = obj.value;
      document.getElementById("r_TeamGbIDX").value = obj.value;
      var strAjaxUrl = "../Ajax/stadium_sketch.asp?r_TeamGbIDX="+r_TeamGbIDX + "&GameTitleIDX="+GameTitleIDX;
      //location.href= strAjaxUrl
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          GameTitleIDX  : GameTitleIDX,
          r_TeamGbIDX   : r_TeamGbIDX
        },
        success: function(retDATA) {
          if(retDATA!=''){
            totalidx_1 = 3;
            document.getElementById("DP_List").innerHTML = retDATA;
          }
        }
      });
    }

    function Fnd_TeamGb_open(GameTitleIDX,r_TeamGbIDX,Top_index)
      {
        //alert(r_TeamGbIDX);
        if (Top_index ==undefined)
        {
          Top_index = 3
        }
        //1. 처음 데이터 불러올때 셀렉트 선택 데이터 불러옴
         var strAjaxUrl = "../Ajax/stadium_sketch_Team_select_Test.asp?GameTitleIDX="+GameTitleIDX;
         //location.href = strAjaxUrl
        // return;
        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',
          data: {
           GameTitleIDX  : GameTitleIDX ,
           r_TeamGbIDX   : r_TeamGbIDX
          },
          success: function(retDATA) {
             //TeamGb_Select_Div div에 해당 데이터를 보여줌
             document.getElementById("TeamGb_Select_Div").innerHTML = retDATA;

             //2. 셀렉트 박스 셋팅 후 사진 데이터 뿌려주는 부분
             if (Top_index==3)
             {
               //alert('1');
               //alert(Top_index);
               var strAjaxUrl = "../Ajax/stadium_sketch.asp?Top_index="+Top_index + "&GameTitleIDX="+GameTitleIDX;
              //location.href= strAjaxUrl
              $.ajax({
                url: strAjaxUrl,
                type: 'POST',
                dataType: 'html',
                data: {
                 GameTitleIDX  : GameTitleIDX ,
                 r_TeamGbIDX   : r_TeamGbIDX
                },
                success: function(retDATA) {
                 document.getElementById("DP_List").innerHTML = retDATA;
                }
              });

             }
             else
             {
                //alert('2');
             }
           }
        });

      }

    function Fnd_TeamGb_open_two(GameTitleIDX,r_TeamGbIDX,Top_index){
      console.log('dd')

      if (r_TeamGbIDX=='')
      {stadium_sketch_Team_select
        r_TeamGbIDX = document.getElementById("r_TeamGbIDX").value;
      }
      if (r_TeamGbIDX == '')
      {
        r_TeamGbIDX = 0;
      }
      var strAjaxUrl = "../Ajax/stadium_sketch.asp?Top_index="+Top_index + "&GameTitleIDX="+GameTitleIDX + "&r_TeamGbIDX="+r_TeamGbIDX;
      //alert(strAjaxUrl);
      //location.href= strAjaxUrl
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
         GameTitleIDX  : GameTitleIDX ,
         r_TeamGbIDX   : r_TeamGbIDX
        },
        success: function(retDATA) {
         if (retDATA!='')
         {
          $("#DP_List").append(retDATA)
         }

        }
      });
    }

    $(function(){
        $("#TeamGb").append("<option value='1'>신인부</option>");
        $("#TeamGb").append("<option value='2'>개나리부</option>");
        $("#TeamGb").append("<option value='3'>오픈부</option>");

        //$("#DP_List1").css("display", "");
        Fnd_TeamGb_open('<%=GameTitleIDX%>','<%=TeamGbIDX%>');



        var totalidx_1 = 3;
        var timer ;
        $('._sd-infinite').on('scroll', function(evt){
          var $this = $(this);
          if ( timer ) clearTimeout(timer);
          timer = setTimeout(function(){
            if(($this.scrollTop() + $this.height())  >= $this.prop('scrollHeight') - 50){

              totalidx_1 = totalidx_1 + 3;
              Fnd_TeamGb_open_two('<%=GameTitleIDX%>','',totalidx_1);

            }
          }, 30);
        });
    });
  </script>
  <!-- E: as-is -->

  <!-- S: to-be 유도 현장스케치에서 복사해놓음. ajax 부분 봐주세용 -->
  <script type="text/javascript">
    var GameTitleIDX = '<%=GameTitleIDX%>';
    var iTOTALCNT = 0;

    // get gameTitle
    function Fnd_GameTitle_Info(valIDX){
      var strAjaxUrl = '../Ajax/stadium_sketch_FndGameTitle_test.asp';

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          GameTitleIDX  : valIDX
        },
        success: function(retDATA) {

          if(retDATA){
            var strcut = retDATA.split('|');

            if (strcut[0]=='TRUE') {
              $('#txt_GameTitle').html(strcut[1]);
            }
            else{
              var msg = '';

              switch(strcut[1]){
                case '99' : msg='일치하는 정보가 없습니다. 확인 후 이용하세요.'; break;
                    default : msg='일치하는 정보가 없습니다. 확인 후 이용하세요.'; //200
                }
                alert(msg);
                return;
            }
          }
        },
        error: function (xhr, status, error) {
          if(error) {
            alert ('조회중 에러발생 - 시스템관리자에게 문의하십시오!'+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
            return;
          }
        }
      });
    }

    // get team select
    function Fnd_TeamGb_open(GameTitleIDX,r_TeamGbIDX,Top_index){
      //alert(r_TeamGbIDX);
      if (Top_index == undefined){ Top_index = 3 }

      //1. 처음 데이터 불러올때 셀렉트 선택 데이터 불러옴
      var strAjaxUrl = "../Ajax/stadium_sketch_Team_select_test.asp";

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        async: false,
        data: {
          GameTitleIDX  : GameTitleIDX ,
          r_TeamGbIDX   : r_TeamGbIDX
        },
        success: function(retDATA) {

          document.getElementById("TeamGb").innerHTML = retDATA;

        }
      });
    }

    // get img list
    function fn_List(np, callback) {

      var selTeamGbIDX = document.getElementById("TeamGb").value;

      if (selTeamGbIDX == 0) { selTeamGbIDX = ""; }

      //alert("GameTitleIDX : " + GameTitleIDX + " , TeamGbIDX : " + selTeamGbIDX);

      var strAjaxUrl = "../Ajax/stadium_sketch_test.asp";
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        // async: false,
        data: {
          NowPage : np,
          GameTitleIDX  : GameTitleIDX,
          TeamGbIDX   : selTeamGbIDX
        },
        success: function (retDATA) {

          if(callback) callback(retDATA, np);
          // document.getElementById("sklist").innerHTML = retDATA;
          // iTOTALCNT = document.getElementById("hdtotalcnt").value;

        },
        error: function (xhr, status, error) {
          if (error != "") {
            alert("오류발생! - 시스템관리자에게 문의하십시오!");
            return;
          }
        }
      });

      // alert(iTOTALCNT);

    }




    var HistoryManager = (function(){
      function Singleton(){
        var that = this;
        this.referrer = document.referrer;
        this.callArray = [];
        this.addPopEvent = function(callback){
          this.callArray.push(callback);
        }
        this.pushHistory = function(state){
          history.pushState(state, null, null)
        }
        this.replaceHistory = function(state){
          history.replaceState(state, null, null);
        }
        this.setReferrer = function(referrer){
          this.referrer = referrer;
        }

        if (typeof history.pushState === "function"){
    			window.onpopstate = function(evt){
            that.callArray.forEach(function(item, index){
              item(evt);
            });
          }
    		}
      }

      var instance = new Singleton();
      return function(){ return instance; }
    })();

    function OverLayer(obj){
      this.$layer = {},
      this.$title = {},
      this.$content = {};

      this.init = function(obj){
        var that = this;
        this.$layer = (obj.overLayer.jquery) ? obj.overLayer : $(obj.overLayer);
        this.$contentBox = this.$layer.find('._sd-over-layer__box');
        this.$content = this.$layer.find('._sd-over-layer__contentWrap');

        this.emptyHTML = obj.emptyHTML || '';
        this.errorHTML = obj.errorHTML || '';
        this.$title = this.$layer.find('._sd-over-layer__titleWrap-title');
        this.transition = obj.transition || true;

        this.$layer.on('click', '._sd-over-layer__titleWrap-close', function(evt){
          that.close();
        });

        this.addPopEvent(function(evt){
          if(evt.state == 'list'){
            history.replaceState('view', null, null);
            that.close();
          }
          else{
            location.href = document.referrer || that.referrer;
          }
        });

        this.replaceHistory('list');
      }
      this.open = function(obj){
        if(!this.$layer.hasClass('_s-on')){
          this.pushHistory('view');

          if(obj && obj.title){ this.$title.html(obj.title); }

          var transition = (obj && typeof obj.transition == 'boolean') ? obj.transition : this.transition;

          this.$layer.addClass('_s-on');
          if(transition){
            this.$contentBox.addClass('_s-on');
          }
          else{
            this.$contentBox.addClass('_s-on-noTransition');
          }
        }
      }
      this.close = function(){
        if(this.$layer.hasClass('_s-on')){
          this.pushHistory('list');

          this.$layer.removeClass('_s-on');
          this.$contentBox.removeClass('_s-on');

          if(this.$contentBox.hasClass('_s-on-noTransition')) this.$contentBox.removeClass('_s-on-noTransition');
        }
      }
      this.innerContent = function(content){
        this.$content.html(content);
      }
      this.empty = function(emptyHTML){
        var html = emptyHTML || this.emptyHTML;
        this.$content.html(html);
      }

      if(obj) this.init(obj);
    }
    OverLayer.prototype = new HistoryManager;

    function PaginationWithScroll(obj){
      if(obj){ this.init(obj); }
    }
    PaginationWithScroll.prototype = {
      init : function(obj){
        var that = this;
        this.$prev = obj.$prev || $('._pagination-B__prev');
        this.$next = obj.$next || $('._pagination-B__next');
        this.$pagerWrap = obj.$pagerWrap || $('._pagination-B__pagerWrap');
        this.pagerClassname = '.' + obj.pagerClassname || '._pagination-B__pagerWrap-pager';
        this.scrollWeight = obj.scrollWeight || null;
        this.scrollIncrease = obj.scrollIncrease || 10;
        this.scrollIncreaseTime = obj.scrollIncreaseTime || 10;

        this.$prev.on('click', function(evt){
          var scroll = that.$pagerWrap.scrollLeft();
          var scrollChanged = Number(scroll);
          var scrollWeight = that.scrollWeight || that.$pagerWrap.width();

          var a = setInterval(function(){
            that.$pagerWrap.scrollLeft(scrollChanged -= that.scrollIncrease);
            if(Math.abs(scroll - scrollChanged) >= scrollWeight) clearInterval(a);
          }, that.scrollIncreaseTime);
        });

        this.$next.on('click', function(evt){
          var scroll = that.$pagerWrap.scrollLeft();
          var scrollChanged = Number(scroll);
          var scrollWeight = that.scrollWeight || that.$pagerWrap.width();

          var a = setInterval(function(){
            that.$pagerWrap.scrollLeft(scrollChanged += that.scrollIncrease);
            if(Math.abs(scroll - scrollChanged) >= scrollWeight) clearInterval(a);
          }, that.scrollIncreaseTime);

        });
      },
      updatePager : function(array){
        this.$pagerWrap.html('');
        this.$pagerWrap.html(array.join(''));

        this.$pagerWrap.children().eq(0).addClass('_s-on');
      },
      on : function(eventname, eventCallback){
        switch(eventname){
          case 'pager':
            this.$pagerWrap.on('click', this.pagerClassname, function(evt){
              eventCallback.call(this, evt);
            });
        }
      },
      moveToPager : function(pageNo){
        this.$pagerWrap.children().each(function(index, item){
          var $item = $(item);
          if($item.hasClass('_s-on')) $item.removeClass('_s-on');
        });

        this.$pagerWrap.children().eq(pageNo-1).addClass('_s-on');

        var that = this;
        var $pager = this.$pagerWrap.find(this.pagerClassname).eq(pageNo - 1);
        var scroll = this.$pagerWrap.scrollLeft();

        var scrollChanged = Number(scroll);

        var scrollEnd= this.$pagerWrap.scrollLeft() + $pager.position().left - (this.$pagerWrap.outerWidth()/2) + ($pager.outerWidth(true)/2);
        scrollEnd = (scrollEnd < 0) ? 0 : scrollEnd;

        this.$pagerWrap.scrollLeft(scrollEnd);
      }
    }


    $(function() {
      Fnd_TeamGb_open('<%=GameTitleIDX%>');
      Fnd_GameTitle_Info('<%=GameTitleIDX%>');

      var historyManager = new HistoryManager();
      historyManager.setReferrer('./institute-search.asp');
      historyManager.replaceHistory('list');
      historyManager.addPopEvent(function(evt){
        if(evt.state == 'list'){
          history.replaceState('view', null, null);
          layer_viewer.close();
        }
        else
          location.href = document.referrer || historyManager.referrer;
      });

      var layer_viewer = new OverLayer({
        overLayer: $('._sd-over-layer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
      layer_viewer.on('beforeOpen', function(){ historyManager.pushHistory('view'); });
      layer_viewer.on('beforeClose', function(){ historyManager.pushHistory('list'); });

      var $swiper_list = $('._swiper-container-list');
      var $swiper_list_slide_wrapper = $swiper_list.find('.swiper-wrapper');
      var swiper_list = new Swiper($swiper_list);
      var pagination = new PaginationWithScroll({
        $prev : $('._pagination-B__prev'),
        $pagerWrap : $('._pagination-B__pagerWrap'),
        $next : $('._pagination-B__next'),
        pagerClassname : '_pagination-B__pagerWrap-pager',
      });
      var swiper_viewer = new Swiper('._swiper-contianer-viewer', {
        virtual: {
          cache: true,
        },
        navigation:{
          nextEl: '._swiper-next',
          prevEl: '._swiper-prev',
        }
      });

      // if(isIOS) $('.sd-photo-viewer ._download').remove();
      if(/Android/i.test(navigator.userAgent)) { // 안드로이드
      }
      else if(/iPhone|iPad|iPod/i.test(navigator.userAgent)) {// iOS 아이폰, 아이패드, 아이팟
          $('.sd-photo-viewer ._download').remove();
      }
      else{
          // 그 외 디바이스
      }


      var count_list = 16;
      var init = function(length){
        var length_item = length;
        // var count_list = 16;
        var length_list = Math.ceil(length_item/count_list);

        var items = []; //imgs
        var pagers = []; //pagers
        var lists = []; //slides

        for(var i=0, ii=length_item; i<ii; i++) items.push('<div class="slide-list-img"><img src="http://img.sportsdiary.co.kr/sdapp/empty.png" data-no=' + i + ' class="_trigger_photoViewer" /></div>');

        for(var i=0, ii=length_list; i<ii; i++){
          lists.push(
            [
              '<div class="[ swiper-slide ]">',
                items.slice( (i*count_list), i*count_list + count_list).join(''),
              '</div>'
            ].join('')
          );
          // !@# update 방법 수정
          pagers.push('<button class="pagination-B__pagerWrap-pager [ _pagination-B__pagerWrap-pager ]">' + (i+1) + '</button>');
        }

        $swiper_list_slide_wrapper.html(lists);
        swiper_list.update();
        swiper_list.slideTo(0, 0);

        pagination.updatePager(pagers);

        swiper_viewer.virtual.cache = [];
        swiper_viewer.virtual.slides = items;
        swiper_viewer.update();
      }

      var bindList = function(list){
        var inSlide_imgs = swiper_list.slides[swiper_list.activeIndex].getElementsByTagName('img');
        setTimeout(function(){
          for(var i=0, ii=list.length; i<ii; i++){
            if(!list[i]) break;
            inSlide_imgs[i].src = list[i].link.replace('src="', '').replace('"', '');
          }
        }, 100);
      }
      bindList.cache = [];


      fn_List(1, function(response, np){
        var data = JSON.parse(response);
        var count = data[0].cnt;
        var array = data[0].links;

        init(count);

        bindList.cache = [];
        bindList.cache.push(np);
        bindList(array);
      });

      // select 종목
      $('#TeamGb').on('change', function(evt){
        fn_List(1, function(response, np){
          var data = JSON.parse(response);
          var count = data[0].cnt;
          var array = data[0].links;

          init(count);

          bindList.cache = [];
          bindList.cache.push(np);
          bindList(array);
        });
      });

      // click - move slide
      pagination.on('pager', function(evt){
        swiper_list.slideTo( Number($(this).text()) - 1);
      });

      // swipe - get list img, move pager, set img in viewer active slide
      swiper_list.on('slideChange', function(){

        // !@# 캐쉬
        fn_List(swiper_list.activeIndex + 1, function(response, np){
          // var reg = /<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>/g;
          // var reg = /src\s*=\s*"?(.+?)["|\s]/g;
          // var array = response.match(reg);

          var data = JSON.parse(response);
          var count = data[0].cnt;
          var array = data[0].links;

          if(!bindList.cache.includes(np)){
              bindList.cache.push(np)
              bindList(array);

              setTimeout(function(){
                layer_viewer.$layer.find('.swiper-slide-active img').prop('src', array[0].replace('src="', '').replace('"', ''));
              }, 100);
          };

        });

        pagination.moveToPager(swiper_list.activeIndex + 1);
      });

      // click - open viewer
      $swiper_list.on('click', '._trigger_photoViewer', function(evt){
        // $viewer.addClass('s-on');

        layer_viewer.open();

        var no = this.dataset.no;

        if(this.dataset.no == 0){
          swiper_viewer.slideTo(Number(2), 0);
          swiper_viewer.slidePrev(0);
          swiper_viewer.slidePrev(0);
        }
        else {
          swiper_viewer.slideTo(Number(no), 0);
        }

        var imgSrc = this.src;

        // setTimeout(function(){

          layer_viewer.$layer.find('.swiper-slide-active img')[0].src = imgSrc;
          if(layer_viewer.$layer.find('._download').length != 0) layer_viewer.$layer.find('._download')[0].href = imgSrc;

        // }, 100);

      });

      var count_inSlide_img = count_list;
      swiper_viewer.on('slideChange', function(){

        if(layer_viewer.$layer.find('._download').length != 0) layer_viewer.$layer.find('._download')[0].href = '';
        var swiperSlideNo = Math.floor(swiper_viewer.activeIndex/count_inSlide_img);
        var imgSrc = swiper_list.slides[swiperSlideNo].getElementsByTagName('img')[swiper_viewer.activeIndex - swiperSlideNo * count_inSlide_img].src;

        // var reg = /<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>/;
        // var photoviewerImg = swiper_viewer.virtual.slides[swiper_viewer.activeIndex];
        // photoviewerImg = photoviewerImg.replace(reg, '<img src="'+ 'http://sportsdiary.co.kr/m_player/upload/sketch/201810122257344.jpg' +'" />');
        // swiper_viewer.virtual.slides[swiper_viewer.activeIndex] = photoviewerImg;

        setTimeout(function(){

          layer_viewer.$layer.find('.swiper-slide-active img')[0].src = imgSrc;
          if(layer_viewer.$layer.find('._download').length != 0) layer_viewer.$layer.find('._download')[0].href = imgSrc;

        }, 100);

        swiper_list.slideTo(swiperSlideNo);
      });
    });
  </script>
  <!-- E: to-be -->
  <!-- S: !@# -->


</head>
<body >
  <!-- !@# ???? -->
  <form name="sketchForm">
    <input type="hidden" id="FileName" name="FileName">
  </form>
  <iframe id="sketch_download" style="display:none;" ></iframe>
  <!-- !@# ???? -->


  <input type="hidden" id="top_index" name="top_index" value="<%=top_index%>">
  <input type="hidden" id="r_TeamGbIDX" name="r_TeamGbIDX" value="">

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
   <!-- #include file="../include/sub_header_arrow.asp" -->
   <h1>현장스케치</h1>
   <!-- #include file="../include/sub_header_right.asp" -->
  </div>
  <!-- E: sub-header -->

  <!-- #include file = "../include/gnb.asp" -->

  <!-- S: main -->
  <div class="main stadium_sketch sd-main-A sd-scroll [ _sd-scroll ]">
    <!-- S: spinner -->
    <!-- <div class="spinner">
      <img src="http://img.sportsdiary.co.kr/sdapp/public/loading.gif" alt>
    </div> -->
    <!-- E: spinner -->

    <!-- !@#  S: ctr_select -->
    <!-- S: as-is -->
    <div class="ctr_select sel_box" id="TeamGb_Select_Div">
      <!--<select id="TeamGb" onchange="change_teamgb(this);"></select>-->
      <select id="TeamGb" name="TeamGb"></select>
    </div>
    <div class="pic_info" onclick="javascript:alert(fn_OSCHK());"># 공식런칭 후 사진 다운로드 가능</div>
    <!-- E: as-is -->

    <!-- S: to-be -->
    <!-- <div id="txt_GameTitle" class="sd-sub-title"></div>
    <div class="sd-select-wrap-A" id="TeamGb_Select_Div">
    	<select id="TeamGb" name="TeamGb"></select>
    </div> -->
    <!-- E: to-be -->
    <!-- !@#  E: ctr_select -->



    <!-- !@# S: photo_list -->

    <!-- S: as-is -->
    <div class="photo_list">
      <!-- S: 신인부 -->
      <div class="order type1" id="DP_List" style="">
      </div>
      <!-- E: 신인부 -->
    </div>
    <!-- E: as-is -->

    <!-- S: to-be -->
    <!-- <div class="swiper-container-list [ swiper-container _swiper-container-list ]">
      <div class="[ swiper-wrapper ]"></div>
    </div>

    <div class="pagination-B [ _pagination-B ]">
      <button class="pagination-B__prev [ _pagination-B__prev ]">prev</button>
      <div class="pagination-B__pagerWrap [ _pagination-B__pagerWrap ]"></div>
      <button class="pagination-B__next [ _pagination-B__next ]">next</button>
    </div> -->
    <!-- E: to-be -->

    <!-- !@# E: photo_list -->


  </div>
  <!-- E: main -->

  <!-- !@# 추가 -->
  <!-- <div class="sd-over-layer sd-photo-viewer [ _sd-over-layer ]" >
    <div class="content-box [ _sd-over-layer__box ]">
      <div class="title-wrap [ _sd-over-layer__titleWrap ]">
        <h1 class="title [ _sd-over-layer__titleWrap-title ]">현장스케치</h1>
        <button class="btn-close [ _sd-over-layer__titleWrap-close ]">닫기</button>
      </div>
      <div class="content-wrap [ _sd-over-layer__contentWrap ]">

        <div class="swiper-contianer-viewer [ swiper-container _swiper-contianer-viewer ]">
          <div class="[ swiper-wrapper ]"></div>
          <div class="swiper-navigation">
            <button class="swiper-prev [ _swiper-prev ]">prev</button>
            <button class="swiper-next [ _swiper-next ]">next</button>
          </div>
        </div>

        <a href="" class="download [ _download ]" download="download">다운로드</a>
        <p class="info">
          * 스포츠 다이어리의 모든 이미지는 저작권의 보호를 받고 있습니다.
           상업적인 용도/무단도용을 금하고 있습니다.
        </p>

    </div>
  </div> -->
  <!-- !@# 추가 -->

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</body>
</html>
