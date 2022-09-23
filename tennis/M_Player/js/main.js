
//객체(이벤트 처리)
var mx_player =  mx_player || {};
mx_player.CMD_DATAGUBUN = 10000;

(function($){
  'use strict';

  /**
   * S :공통 ajax 호출 처리 로직
   * 추가 : 2017-11-06 김주영
   */
  mx_player.IsHttpSuccess = function( r ){
      try{
        return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
      }
      catch(e){

      }
   return false;
  };

    mx_player.HttpData = function( r, type ){
      var ct = r.getResponseHeader( "Content-Type" );
      var data = !type && ct && ct.indexOf( "xml" ) >=0;
      data = type == "xml" || data ? r.responseXML : r.responseText;
      if( type == "script" ){
        eval.call( "window", data );
      }
      else if( type == "mix" ){
        if ( data.indexOf("$$$$") !== -1 ){
          var mixdata = data.split( "$$$$" );
          ( function () { eval.call("window", mixdata[0]); } () );
          data = mixdata[1];
        }
      }
      return data;
    };

    //동일한 패킷이 오는경우 (막음 처리해야겠지)
    mx_player.SendPacket = function( sender, packet,TargetUrl){
      var defer = $.Deferred();

      var datatype = "mix";
      var timeout = 5000;
      var reqcmd = packet.CMD;
      var reqdone = false;//Closure
      var url = TargetUrl;
      var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
      var xhr = new XMLHttpRequest();
      xhr.open( "POST", url );
      xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
      setTimeout( function(){ reqdone = true; }, timeout );
      xhr.onreadystatechange = function(){
        if( xhr.readyState == 4 && !reqdone ){
          if( mx_player.IsHttpSuccess( xhr ) ){
             defer.resolve(mx_player.ReceivePacket( reqcmd, mx_player.HttpData( xhr, datatype ), sender ));
          }
          xhr = null;
        }
      };
      console.log(JSON.stringify( packet  ) );
      xhr.send( strdata );

      return defer.promise();
    };

    mx_player.ReceivePacket = function( reqcmd, data, sender ){// data는 response string
      var rsp = null;
      var callback = null;
      var resdata = null;

      var jsondata = null;
      var htmldata = null;

        if ( Number(reqcmd) > mx_player.CMD_DATAGUBUN  ){
            if ( data.indexOf("`##`") !== -1 ){
                resdata = data.split( "`##`" );
                jsondata =  resdata[0];

                if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
                htmldata = resdata[1];
            }
            else{
                htmldata = data;
                try{
                jsondata = JSON.parse(data);
                }
                catch(ex)
                {

                }
            }
        }
        else{
            if(typeof data == 'string'){jsondata = JSON.parse(data);}
            else{jsondata = data;}
        }

        var obj = {};
        obj.htmldata=htmldata;
        obj.jsondata=jsondata;

        mx_player.ReceiveData=obj;
        return obj;
    };

    //그리기
    mx_player.OndrowHTML =  function(cmd, packet, html, sender){
      document.getElementById(sender).innerHTML = html;
    };

    //추가 그리기
    mx_player.OnAppendHTML =  function(cmd, packet, html, sender){
        $('#'+sender).append(html);
    };

    //삭제
    mx_player.OndelHTML =  function(cmd, packet, html, sender){
        $("#"+sender).remove();
    };

    //선처리(추후 수정)
    mx_player.OnBeforeHTML =  function(cmd, packet, html, sender){

    };
    //후처리(추후 수정)
    mx_player.OnAfterHTML =  function(cmd, packet, html, sender){

    };

  /**
   * E : ajax
   */

  /**
   * sub-menu 높이 조절
   */
  function StableSubHeight(){
    this._$stable = null;
    this._$target = null;

    this._$targetH = -1;
    this._hCalc = -1;

    this._init();
    this._evt();
  };

  StableSubHeight.prototype._init = function() {
    this._$stable = $('.sub-menu');
    this._$target = this._$stable.find('.target');
  };

  StableSubHeight.prototype._evt = function() {
    var that = this;
    $(window).on('load resize', function(e){
      that._setHeight();
    });
  };

  StableSubHeight.prototype._setHeight = function() {
    this._$targetH = this._$target.height();
    /**
     * hCalc : 대상 target 높이 / 비율을 적용할 값
     */
    this._hCalc = parseInt(this._$targetH / 1.26);
    this._$stable.height(this._hCalc);
  };

  $.fn.stableSubHeight = function(){
    this.each(function(){
      var stableSubHeight = new StableSubHeight();
    });
    return this;
  }



  /**
   * main-menu 높이 조절
   */
  function StableMainHeight(){
    this._$mainMenu = null;
    this._$mainTarget = null;
    this._$subMenu = null;

    this._$targetH = -1;
    this._hCalc = -1;
    this._bCalc = -1;

    this._init();
    this._evt();
  };

  StableMainHeight.prototype._init = function() {
    this._$mainMenu = $('.main-menu');
    this._$mainTarget = this._$mainMenu.find('.target');
    this._$subMenu = $('.sub-menu');
  };

  StableMainHeight.prototype._evt = function() {
    var that = this;
    $(window).on('load resize', function(){
      that._setHeight();
    });
  };

  StableMainHeight.prototype._setHeight = function() {
    this._$targetH = this._$mainMenu.height();
    /**
     * hCalc : 대상 target 높이 / 비율을 적용할 값
     */
    this._hCalc = parseInt(this._$targetH * 3.75);
    this._bCalc = parseInt( (this._$subMenu.height()/4) + (this._$mainTarget.height()/.35) );
    this._$mainMenu.css({
      'padding-top' : this._hCalc,
      'padding-bottom' : this._bCalc
    });
  };

  $.fn.stableMainHeight = function(){
    this.each(function(e){
      var mainMenu = new StableMainHeight();
    });
    return this;
  }

  // 실행
  // $('.main-menu').stableMainHeight();

  /**
   * --------------------------------
   * gnb, hamberger menu
   * --------------------------------
   */
  function GnbHam(el){
    this._$body            = null; /* body */
    this._$dim              = null; /* .dim 요소 */
    this._$gnb              = null; /* el .gnb */
    this._$gnbW           = null; /* gnb width */
    this._$gnbBtn         = null; /* gnb 작동 버튼 */
    this._$closeBtn       = null; /* gnb 닫기 버튼 */
    this._docH              = null; /* 문서 높이값 */
    this._dragSW          = false; /* drag 담을 프로퍼티 */
    this._$dragTarget    = null; /* 움직이는 이미지를 담을 프로퍼티 */
    this._$gnbCtr          = null; /* gnb ctr 버튼 */

    this._init(el);
    this._evt();

  };

  GnbHam.prototype._init = function(el) {
    this._$body                = $('body');
    this._$gnb                  = $(el);
    this._$gnbBtn             = $('.hamBtn');
    this._$closeBtn            = this._$gnb.find('.close-btn');
    this._docH                  = $(window).innerHeight();
  };

  GnbHam.prototype._evt = function(){
    var that = this;
    this._createDim();
    $(window).on('load resize', function(){
      that._$gnbW = that._$gnb.width();
    });
    this._$gnbBtn.on('click', function(e){
      that._showMenu();
      e.preventDefault();
    }); // gnbBtn end
    this._$closeBtn.on('click', function(e){
      that._hideMenu();
      e.preventDefault();
    }); // closeBtn end
    this._$dim.not(this._$gnb).on('click', function(e){
      that._hideMenu();
      e.preventDefault();
    }); // body end
  };

  // dim 만들기
  GnbHam.prototype._createDim = function() {
    if (this._$gnb.find('.dim').length < 1) {
      this._$gnb.after('<div class="dim"></div>');
    }
    this._$dim = $('.dim');
    this._$dim.css({
      'height' : this._docH
    });
  };

  /**
   * --------------------------------
   * gnb, hamberger menu
   * --------------------------------
   */
  function GnbHam(el){
    this._$body            = null; /* body */
    this._$dim              = null; /* .dim 요소 */
    this._$gnb              = null; /* el .gnb */
    this._$gnbW           = null; /* gnb width */
    this._$gnbBtn         = null; /* gnb 작동 버튼 */
    this._$closeBtn       = null; /* gnb 닫기 버튼 */
    this._docH              = null; /* 문서 높이값 */
    this._$dragTarget    = null; /* 움직이는 이미지를 담을 프로퍼티 */
    this._$gnbCtr          = null; /* gnb ctr 버튼 */
    this._$tgPop            = null; /* 계정 전환 안내 팝업 */

    this._init(el);
    this._evt();
    // this._dragEvt();
  };

  GnbHam.prototype._init = function(el) {
    this._$body                = $('body');
    this._$gnb                  = $(el);
    this._$gnbBtn             = $('.hamBtn');
    this._$closeBtn            = this._$gnb.find('.close-btn');
    this._docH                  = $(window).outerHeight(true);
    this._$gnbCtr              = $('.gnb .gnb_ctr');
    this._$tgPop                = $('.tg_pop', this._$gnb);
  };

  GnbHam.prototype._evt = function(){
    var that = this;
    this._createDim();
    $(window).on('load resize', function(){
      that._$gnbW = that._$gnb.width();
    });
    this._$gnbBtn.on('click', function(e){
      that._showMenu();
      that._$gnbCtr.addClass('on');
      that._$tgPop.fadeIn();
      e.preventDefault();
    }); // gnbBtn end
    this._$closeBtn.on('click', function(e){
      that._hideMenu();
      that._$gnbCtr.removeClass('on');
      that._$tgPop.fadeOut();
      e.preventDefault();
    }); // closeBtn end
    this._$dim.not(this._$gnb).on('click', function(e){
      that._hideMenu();
      that._$gnbCtr.removeClass('on');
      that._$tgPop.fadeOut();
      e.preventDefault();
    }); // body end

    // 계정 전환 안내 모달
    this._$gnb.on('click', function() {
      that._$tgPop.fadeOut();
    }); // gnb end
    this._$tgPop.on('click', function(){
      $(this).fadeOut();
    }).on('click', $('.gnb'),function(e){
      e.stopPropagation();
    });

  };

  GnbHam.prototype._dragEvt = function() {
    var that = this;
    var touch;
    var ox;
    var y;
    var sc = 0;
    var limitX = $(window).innerWidth() - this._$gnb.outerWidth(true);
    var limitY = this._$gnb.outerHeight(true) - $(window).innerHeight();
    var gnbLeft = this._$gnb.offset().left;

    this._$gnb.on('touchmove', function(e){
      touch = event.touches[0];
      ox = touch.pageX;

      sc = (ox - $(this).find('.gnb-box').position().left);
      if (sc < 64) {
        sc = 64;
      }
      if (sc > $(this).innerWidth()+64) {
        sc = ($(this).innerWidth()+64);
      }

      $(this).css({
        right : -sc
      });

    });
  };

  // dim 만들기
  GnbHam.prototype._createDim = function() {
    if (this._$gnb.find('.dim').length < 1) {
      this._$gnb.after('<div class="dim"></div>');
    }
    this._$dim = $('.dim');
    this._$dim.css({
      'height' : this._docH
    });
  };

  /**
   * 사이드 메뉴 보이기
   * --------------------------------
   */
  GnbHam.prototype._showMenu = function() {
    var that = this;
    // dim 생성
    this._$dim.css({
      'display' : 'block'
    });
    // gnb 메뉴 나타내기
    this._$gnb.css({
      'position' : 'absolute',
      'height' : this._docH,
      'overflow-y' : 'scroll'
    }).addClass('on');
    // body 스크롤 막기
    this._$body.css({
      'position' : 'fixed',
      'overflow' : 'hidden',
      'height' : $(window).innerHeight(),
      'width' : '100%'
    });

  };

  /**
   * 사이드 메뉴 감추기
   * --------------------------------
   */
  GnbHam.prototype._hideMenu = function() {
    // dim 가리기
    this._$dim.css({
      'display' : 'none'
    });
    // gnb 메뉴 감추기
    this._$gnb.css('position', 'fixed').removeClass('on');
    // body 스크롤 풀기
    this._$body.css({
      'position' : 'relative',
      'overflow' : 'auto',
      'height' : 'auto',
    });
    // $('html').css({
    //   'overflow' : 'auto'
    // });
  };

  $.fn.gnbHam = function(el){
    this.each(function(){
      var gnbHam = new GnbHam(el);
    });
    return this;
  }

  /**
   * --------------------------------
   * bottom-menu
   * --------------------------------
   */
  function BottomMenu(){
    this._$botBtn = null;
    this._$botMenu = null;
    this._init();
    this._evt();
  };

  BottomMenu.prototype._init = function() {
    this._$botBtn = $('.bot-menu-btn');
    this._$botMenu = $('.bottom-menu');
  };

  BottomMenu.prototype._evt = function() {
    var that = this;
    this._$botBtn.on('click', function(){
     var src = '';
     var nSrc = '';
      if (!(that._$botMenu.hasClass('show'))) {
        that._$botMenu.addClass('show');
        src = $(this).find('img').attr('src');
        if (src.match('open')) {
          nSrc = src.replace('open', 'close');
          $(this).find('img').attr('src', nSrc);
        }
      } else {
        that._$botMenu.removeClass('show');
        src = $(this).find('img').attr('src');
        nSrc = src.replace('close', 'open');
        $(this).find('img').attr('src', nSrc);
      } // if end
    })
  };

  $.fn.bottomMenu = function(){
    this.each(function(){
      var bottomMenu = new BottomMenu();
    });
    return this;
  }

  // 탭메뉴
  $(".tab-menu > li").each(function(i){
    $(".tab-menu > li").eq(i).click(function(){
      $(".tabc").hide();
      $(".tabc").eq(i).show();
      $(".tab-menu > li").removeClass("on");
      $(this).addClass("on");
    });
  });

  // accordian
  function accordian(el){
    var divQ = $(el);
    var divA = $('div.a');
    var arrow = divQ.find('.-morea');

    divQ.on('click', function(){
      arrow.detach();
      $(this).append(arrow.eq(0));
      divA.stop().animate({
        'height' : 0,
        'padding-top' : 0,
        'padding-bottom' : 0,
      }); // animate end
      $(this).siblings(divA).stop().animate({
        'height' : 48,
        'padding-top' : 10,
        'padding-bottom' : 10,
      }); // animate end
    }); // click end
  };
  accordian('div.q');

  /**
   * --------------------------------
   * select change시 경로 이동
   * --------------------------------
   */
  function change_evt(){
    var $tg = $('select.conditoin');
    $tg.on('change', function(){
      if ($tg.value == 0) {
        console.log('근력');
      }
      if ($tg.value == 1) {
        console.log('근파워');
      }
      if ($tg.value == 2) {
        console.log('유연성');
      }
      if ($tg.value == 3) {
        console.log('민첩성');
      }
      if ($tg.value == 4) {
        console.log('근지구력');
      }
      if ($tg.value == 5) {
        console.log('협응력');
      }
      if ($tg.value == 6) {
        console.log('심폐소지구력');
      }
    })
  }
  // change_evt();

  /**
   * --------------------------------
   * tab-menu
   * tg = ul의 tabMenu
   * --------------------------------
   */
  function TabMenu(tg, count){
    this._$tabMenu = null; /* ul 담기 */
    this._$tabBtn = null; /* ul 아래 li 아래 a 버튼 */
    this._selected = null; /* 선택된 요소 담을 변수 */

    this._parentH = null; /* a태그 감싸는 바로 위의 ul */
    this._childH = null; /* a태그 형제요소 .panel */

    this._parentNH = -1; /* tabMenu 감싸는 요소 높이 */

    this._init(tg);
    this._evt();
    this._arrangeH(count);
    this._selectTab(count);
    this._showSub(count);
  };

  TabMenu.prototype._init = function(tg) {
    this._$tabMenu = $(tg);
    this._$tabBtn = this._$tabMenu.find('.tabList > a');
    // this._parentH = $(this).parents('ul').height();
    // this._childH = $(this).siblings('.panel').height();
  };

  TabMenu.prototype._evt = function() {
    var that = this;
    var index;
    //this._showSub(this._$tabBtn.eq(0));  패널 초기화
    this._$tabBtn.on('click', function(e){
      index = $(this).parents('.tabList').index();
      that._selectTab(index);
      if ($(this).children('ul')) {
        that._showSub(index);
      }
      that._arrangeH(index);
      e.preventDefault();
    });
  };

  /**
   * _arrangeH : 탭메뉴 감싸는 요소 높이 조절
   * $parent : .board
   * $this : .panel li
   * nH : .board-list outerHeight(true) + .panel outerHeight(true)
   * --------------------------------
   */
  TabMenu.prototype._arrangeH = function(count) {
    // $parent.css('height', nH);
    var nh = this._$tabMenu.outerHeight(true) + this._$tabMenu.find('.panel').eq(count).outerHeight(true);
    this._$tabMenu.parents('.board').css({
      'height' : nh
    });
  };


  /**
   * _showSub : 탭메뉴의 패널들 보이게 하기
   * @param  {obj} $this [tabBtn a 요소]
   */
  TabMenu.prototype._showSub = function(idx) {
    this._$tabBtn.siblings('.panel').css({
      'display' : 'none'
    });
    this._$tabBtn.eq(idx).siblings('.panel').css({
      'display' : 'block'
    });
  };

  /**
   * _selectTab = 선택된 요소 활성화
   * {idx} 선택된 요소의 부모 li
   */
  TabMenu.prototype._selectTab = function(idx) {
    if (this._$tabBtn.hasClass('on')) {
      this._$tabBtn.removeClass('on');
    }
    if (this._selected) {
      this._selected.removeClass('on');
    }
    this._selected = this._$tabBtn.eq(idx);
    this._selected.addClass('on');
  };

  $.fn.tabMenu = function(tg, count){
    this.each(function(){
      var tabMenu = new TabMenu(tg, count);
    });
    return this;
  }

  /**
   * collapse 높이 조절
   * el = collapse
   */
  function ArrHCollapse(el){
    this._$el = null; /* data-toggle="collapse" */
    this._$parentWrap = null; /* collapse의 부모 arr-box */
    this._$collapse = null; /* collapse (show/hide 될 요소) */

    /* this._changeH = -1; 변경 될 높이 값을 담을 프로퍼티 */

    this._init(el);
    this._evt();
  };

  ArrHCollapse.prototype._init = function(el) {
    this._$el = $(el);
    this._$collapse = this._$el.parents('.arr-box').find('.collapse');
    this._$elParentH = this._$el.parent().outerHeight(true);
    this._collapseH = this._$collapse.outerHeight(true);
  };

  ArrHCollapse.prototype._evt = function() {
    var that = this;
    this._$el.on('click', function(e){
      that._$parentWrap = $(this).parents('.arr-box');
      that._arrH($(this), that._$parentWrap);
      $(this).toggleClass('on');
      e.preventDefault();
    });
  };

  /**
   * [_arrH 높이 조절]
   * $wrap = '.arr-box'
   */
  ArrHCollapse.prototype._arrH = function($this, $wrap) {
    var changeH;
    if (!(this._$collapse.hasClass('in'))) {
      changeH = Math.ceil(this._$elParentH + this._collapseH);
    } // if end
    if (this._$collapse.hasClass('in')) {
      changeH = Math.ceil($this.parent().outerHeight());
    }
    $wrap.stop().animate({
      'height' : changeH
    });
  };

  $.fn.arrHCollapse = function(el){
    this.each(function(){
      var arrHCollapse = new ArrHCollapse(el);
    });
    return this;
  }

  /**
   * icon-favorite on, off 변경
   */

  function IconFav(el) {
    this._$el = null; /* sw-char, a 태그 */
    this._$iconFav = null; /* .icon- 으로 시작하는 span */

    this._init(el);
    this._evt();
  }

  IconFav.prototype._init = function(el) {
    this._$el = $(el);
    this._$iconFav = this._$el.find('span');
  };

  IconFav.prototype._evt = function() {
    var that = this;
    var thisKlass;
    this._$el.on('click', function(e){
      thisKlass = $(this).children('span').attr('class');
      that._changeOnOff($(this), thisKlass);
      e.preventDefault();
    });
  };

  IconFav.prototype._changeOnOff = function($this, cls) {
    var nKlass;
    if (cls == undefined) {
      return;
    }
    if (cls.match('-on')) {
      nKlass = cls.replace('-on', '-off');
    }
    if (cls.match('-off')) {
      nKlass = cls.replace('-off', '-on');
    }
    $this.find('span').attr('class', nKlass);
  };

  $.fn.iconFav = function(el){
    this.each(function(){
      var iconFav = new IconFav(el);
    });
    return this;
  }

  /**
   * icon-favorite v2
   * el 은 각각 다르게 호출
   */
  function IconFavo(el){
    this._$el = null;
    this._$swChar = null; /* sw-char */

    this._init(el);
    this._evt();
  };

  IconFavo.prototype._init = function(el) {
    this._$el = $(el);
    this._$swChar = this._$el.find('.sw-chara');
  };

  IconFavo.prototype._evt = function() {
    var that = this;
    var thisKlass;
    this._$swChar.find('span[class*="favorite"]').on('click', function(){
      if ($(this).hasClass('df')) {
        return;
      }
      thisKlass = $(this).attr('class');
      that._changeOnOff($(this), thisKlass);
    }); // click end
  };

  IconFavo.prototype._changeOnOff = function($this, cls) {
    var nKlass;
    if (cls == undefined) {
      return;
    }
    if (cls.match('-on')) {
      nKlass = cls.replace('-on', '-off');
    }
    if (cls.match('-off')) {
      nKlass = cls.replace('-off', '-on');
    }
    $this.attr('class', nKlass);
  };

  $.fn.iconFavo = function(el){
    this.each(function(){
      var iconFavo = new IconFavo(el);
    });
    return this;
  };


  /**
   * 단체정보 조회, 사업자 정보 조회 버튼 클릭시 이미지 교체
   * el = info-map
   * mapBtn = a.map-btn
   */
  function MapToggleImg(el){
    this._$el = null; /* info-map */
    this._$mapBtn = null; /* a태그 .map-btn */
    this._$mapImg = null; /* a태그 안의 span.icon 밑의 img */

    this._init(el);
    this._evt();
  };

  MapToggleImg.prototype._init = function(el) {
    this._$el = $(el);
    this._$mapBtn = this._$el.find('.map-btn');
    this._$mapImg = this._$mapBtn.find('.icon img');
    this._$daumMap = this._$el.find('.daum-map');
  };

  MapToggleImg.prototype._evt = function() {
    this._daumMapToggle();
  };

  MapToggleImg.prototype._daumMapToggle = function() {
    this._$daumMap.addClass('collapse');
  };

  $.fn.mapToggleImg = function(el){
    this.each(function(){
      var mapToggleImg = new MapToggleImg(el);
    });
    return this;
  }

  // 실행
  // $('.info-map').mapToggleImg('.info-map');

  /**
   * --------------------------------
   * label on switch
   * tg = 'label.img-replace'
   * --------------------------------
   */
  function LabelSw(tg){
    this._$tg = null; /* label */
    this._selectTg = null; /* 선택된 label */

    this._init(tg);
    this._evt();
  };

  LabelSw.prototype._init = function(tg) {
    this._$tg = $(tg);
  };

  LabelSw.prototype._evt = function() {
    var that = this;
    this._$tg.on('click', function(e){
      that._toggleClass($(this));
      e.preventDefault();
    });
  };

  LabelSw.prototype._toggleClass = function($this) {
    this._selectTg = $this;
    this._selectTg.toggleClass('on')
  };

  $.fn.labelSw = function(tg){
    this.each(function(){
      var labelSw = new LabelSw(tg);
    });
    return this;
  }

  /**
   * --------------------------------
   * input창에 focus시 서브 메뉴 활성화
   * --------------------------------
   */
  function InputSub(tg){
    this._$tg = null;
    this._$tgActive = null;
    this._$sideMain = null;

    this._init(tg);
    this._evt();
  };

  InputSub.prototype._init = function(tg) {
    this._$tg = $(tg);
    this._$tgActive = this._$tg.siblings('.srch-inpt');
    this._$sideMain = $('.side-main:not(.has-sub)');
  };

  InputSub.prototype._evt = function() {
    var that = this;
    this._$tg.on('focusin', function(){
      that._$tgActive.show();
    }); // focusin
    this._$tg.on('focusout', function(){
      // that._$tgActive.hide();
    }); // focusout
    this._$tgActive.find('a').on('click', function(){
      that._$tgActive.hide();
    }) // click
    this._$tgActive.find('a').last().on('focusout', function(){
      that._$tgActive.hide();
    });
  };

  $.fn.inputSub = function(tg){
    this.each(function(){
      var inputSub = new InputSub(tg);
    });
    return this;
  }

  // InputSub 실행
  // $(document).inputSub('input.has-sub');

  /**
   * del-list
   * --------------------------------
   */
  function DelList(){
    this._$delBtn = null; // btn-del
    this._init();
    this._initEvent();
  };

  DelList.prototype._init = function() {
    this._$delBtn = $('.btn-delete');
  };

  DelList.prototype._initEvent = function() {
    var that = this;
    this._$delBtn.on('click', function(e){
      that._removeList($(this));
      e.preventDefault();
    });
  };

  // 삭제 기능
  DelList.prototype._removeList = function($this) {
    // $this = 클릭된 btn-del
    $this.parents('li').stop().animate({
      'height': 0,
      'opacity': 0
    },300, function(){
      $this.parents('li').remove();
    });
  };

  $.fn.delList = function(){
    this.each(function(i){
      var delList = new DelList();
    });
    return this;
  }

  /**
  * --------------------------------
  * 가로 스크롤 메뉴
  * --------------------------------
  */
   function ScrollHoriGnb(){
    this._$bigCateBox = null; /* big-cate 감싸는 div */

    this._$bigCate = null; /* 최상단 메뉴 ul */
    this._$bigCateBtn = null; /* 최상단 메뉴 a 태그 */
    this._$bigCateBtnW = -1; /* 최상단 메뉴 a태그 width */
    this._$bigCateBtnPadding = -1; /* 최상단ㄷ 메뉴 a태그 padding */
    this._bigCateBtnWEach = 0; /* 최상단 메뉴 a태그 각각 */

    this._$bigCateBtnOn = null; /* 상단 버튼 중 on */
    this._bigCateBtnOnLeft = -1; /* on 버튼의 위치 */

    this._$midCate = null; /* 하단 메뉴 ul */
    this._$midCateBtn = null; /* 하단 메뉴 a 태그 */
    this._$midCateBtnW = -1; /* 하단 메뉴 a 태그 width */
    this._midCateBtnWEach = -1; /* 하단 메뉴 a태그 각각 */

    this._$midCateBtnOn = null; /* 하단 버튼 중 on */
    this._midCateBtnOnLeft = -1; /* on 버튼의 위치 */

    this._$windowW = -1; /* 브라우저 가로 길이 */

    this._init();
    this._evt();
   };

   ScrollHoriGnb.prototype._init = function() {
     this._$bigCateBox = $('.big-cat');

     this._$bigCate = this._$bigCateBox.find('ul.menu-list');
     this._$bigCateBtn = this._$bigCate.find('a');
     this._$bigCateBtnPadding = (parseInt(this._$bigCateBtn.css('padding-left'))*2)+10;

     this._$bigCateBtnOn = this._$bigCateBtn.filter('.on');
     if (this._$bigCateBtnOn.length > 0) {
       this._bigCateBtnOnLeft = this._$bigCateBtnOn.offset().left;
     }

     this._$midCateBox = $('.mid-cat');
     this._$midCate = this._$midCateBox.find('ul');
     this._$midCateBtn = this._$midCate.find('a');
     this._$midCateBtnPadding = (parseInt(this._$midCateBtn.css('padding-left'))*2)+10;

     this._$midCateBtnOn = this._$midCateBtn.filter('.on');

     this._$windowW = $('body').outerWidth();
   };

   ScrollHoriGnb.prototype._evt = function() {
     var that = this;
     $(window).on('load', function(){
      that._menuArrange();
      that._scrollCate();
     });
   };

   // bigCate on 위치로 스크롤
   ScrollHoriGnb.prototype._scrollCate = function() {
    // 상단 메뉴 on 버튼 위치로 스크롤
     this._$bigCateBox.scrollLeft(this._bigCateBtnOnLeft - this._$bigCateBtnPadding);
     // 하단 메뉴 on 버튼 위치로 스크롤
     this._$midCateBox.scrollLeft(this._midCateBtnOnLeft - this._$midCateBtnPadding);
   };

   // 메뉴 길이 조절
   ScrollHoriGnb.prototype._menuArrange = function() {
    var that = this;
    // 상단 메뉴 길이 조절
    this._$bigCateBtn.each(function(){
      that._bigCateBtnWEach += $(this).outerWidth(true) + 5
    });
    this._$bigCate.css({
     'width' : (this._bigCateBtnWEach)
    });

    // 하단 메뉴 길이 조절
    this._$midCateBtn.each(function(){
      that._midCateBtnWEach += $(this).outerWidth(true) + 30
    });

    // 상단 메뉴 길이가 브라우저 길이보다 작을 경우 100%
    if (this._bigCateBtnWEach <= this._$windowW) {
      this._$bigCate.css({
        'width' : this._$windowW
      });
    }

    // 하단 메뉴 길이가 브라우저 길이보다 작을 경우 100%
    if (this._midCateBtnWEach <= this._$windowW) {
      this._$midCate.css({
        'width' : this._$windowW
      });
    }

    this._$midCate.css({
     'width' : (this._midCateBtnWEach)
    });

    if (this._$midCateBtnOn.length > 0) {
      this._midCateBtnOnLeft = this._$midCateBtnOn.offset().left;
    } else {
      this._midCateBtnOnLeft = 0;
    }

   };

   $.fn.scrollHoriGnb = function(){
    this.each(function(){
      var scrollHoriGnb = new ScrollHoriGnb();
    });
    return this;
   };

   /**
    * [가로 스크롤 메뉴 2]
    * el = 가로스크롤 메뉴 요소
    * count = 처음 활성화 요소
    * bigN = bigCat 부분 on
    * midN = midCat 부분 on
    * 활용 부분 : 나의 통계
    */
   function HoriSnb(el, count, bigN, midN){
    this._$el = null;
    this._$bigCat = null; /* 상단메뉴 */
    this._$midCat = null; /* 서브메뉴 */

    this._$bigCatBtn = null; /* 상단 메뉴 버튼 */
    this._$midCatList = null; /* 서브메뉴 리스트 */

    this._selectedBig = null; /* 선택될 bigCat */
    this._selectedMid = null; /* 선택 될 midCat */

    this._init(el);
    this._evt();
    this._showMidCat(count);
    this._addOn(bigN, midN);
   }

   HoriSnb.prototype._init = function(el) {
     this._$el = $(el);
     this._$bigCat = this._$el.find('.big-cat');
     this._$midCat = this._$el.find('.mid-cat');

     this._$bigCatBtn = this._$bigCat.find('.btn');
     this._$midCatList = this._$midCat.find('.mid-menu-list');
   };

   HoriSnb.prototype._evt = function() {
     var that = this;
     var idx;
     this._$bigCatBtn.on('click', function(e){
       idx = $(this).parents('li').index();
       that._selectBigCat(idx);
       that._showMidCat(idx);
       // midCat 보다 bigCat 버튼이 많을 경우
       if (idx >= that._$midCatList.length) {
        return;
       }
       that._$midCat.addClass('on');
       that._midWArrange(idx);
     });
   };

   HoriSnb.prototype._selectBigCat = function(idx) {
     this._$bigCatBtn.removeClass('on');
     if (this._selectedBig) {
      this._selectedBig.removeClass('on');
     }
     this._selectedBig = this._$bigCatBtn.eq(idx);
     this._selectedBig.addClass('on');
   };

   HoriSnb.prototype._showMidCat = function(idx) {
     if (idx == -1) {
      this._$midCatList.hide().removeClass('on');
     }
     if (this._selectedMid) {
       this._selectedMid.hide().removeClass('on');
     }
     this._selectedMid = this._$midCatList.eq(idx);
     this._selectedMid.show().addClass('on');
   };

   // midCat 길이 조절
   HoriSnb.prototype._midWArrange = function(idx) {
    var w = 0;
    var thisW = 0;
    this._$midCatList.eq(idx).find('a').each(function(){
      thisW = parseInt($(this).outerWidth(true) + 20);
      w = (w+thisW);
    });
     if (w < $(window).innerWidth()) {
      this._$midCat.css({
        'width' : $(window).innerWidth(),
        'overflow-x' : 'hidden'
      });
     } else {
      this._$midCat.css({
        'width' : w,
        'overflow-x' : 'scroll'
      });
     }
   };

   // on 클래스 추가
   HoriSnb.prototype._addOn = function(bigN, midN) {
     this._$bigCatBtn.eq(bigN).addClass('on');
     $('.mid-menu-list.on').find('li').eq(midN).find('a').addClass('on');
   };


   $.fn.horiSnb = function(el,count, bigN, midN){
    this.each(function(){
      var horiSnb = new HoriSnb(el,count, bigN, midN);
    });
    return this;
   }

   // 실행
   // 나의통계 서브메뉴
   // $('.stat-menu').horiSnb('.stat-menu', -1, bigN, midN);

   /**
    * [FilmPanel description]
    * record-box, film-box 영역 필요
    * btn-record, btn-record 버튼 필요
    */
   function FilmTab(el){
    this._$el = null; /* film-modal */
    this._$btnFilm = null; /* 영상보기 버튼 */
    this._$btnRecord = null; /* 기록보기 버튼 */
    this._$closeBtn = null; /* 닫기 버튼 */
    this._$recordBox = null; /* record-box */
    this._$filmBox = null; /* film-box */

    this._init(el);
    this._evt();
   };

   FilmTab.prototype._init = function(el) {
    this._$el = $(el);
    this._$btnFilm = this._$el.find('.btn-film');
    this._$btnRecord = this._$el.find('.btn-record');
    this._$closeBtn = this._$el.find('.modal-footer .btn-default');
    this._$recordBox = this._$el.find('.record-box');
    this._$filmBox = this._$el.find('.film-box');
   };

   FilmTab.prototype._evt = function() {
     var that = this;
     // 영상보기 버튼 클릭시
     this._$btnFilm.on('click', function(){
      if ($(this).hasClass('off')) {
        alert('등록된 영상이 없습니다.');
        return;
      }
       that._showFilm($(this));
     });
     // 기록보기 버튼 클릭시
     this._$btnRecord.on('click', function(){
      that._showRecord($(this));
     });
     this._$closeBtn.on('click', function(){
      that._resetRecord();
     });
   };

   // 닫기 버튼시 reset
   FilmTab.prototype._resetRecord = function() {
     this._$filmBox.css({
      'display' : 'none'
     });
     this._$recordBox.css({
      'display' : 'block'
     });
     // 영상보기 버튼 show
     this._$btnFilm.css({
      'display' : 'block',
     });
     // 기록보기 버튼 hide
     this._$btnRecord.css({
      'display' : 'none'
     });
   };

   // 영상보기 부분 보이기
   FilmTab.prototype._showFilm = function($this) {
     this._$filmBox.css({
      'display' : 'block'
     });
     this._$recordBox.css({
      'display' : 'none'
     });

     // 버튼 변경
     this._$btnRecord.css({
        'display' : 'block'
      });
     $this.css({
        'display' : 'none'
      });
   };

   // 기록보기
   FilmTab.prototype._showRecord = function($this) {
     this._$recordBox.css({
      'display' : 'block'
     });
     this._$filmBox.css({
      'display' :'none'
     });

     // 버튼 변경
     this._$btnFilm.css({
        'display' : 'block'
      });
     $this.css({
        'display' : 'none'
      });
   };

   $.fn.filmTab = function(el){
    this.each(function(){
      var filmTab = new FilmTab(el);
    });
    return this;
   };


   /**
    * [scrollTop 상단으로 이동]
    */
   function scrollTop(){
    $(window).scroll(function () {
        if ($(this).scrollTop() > 10) {
            $('.top_btn').parents('.tops').stop().animate({
              'opacity' : 1
            });
        } else {
            $('.top_btn').parents('.tops').stop().animate({
              'opacity' : 0
            });
        }
    });

    $('.top_btn').click(function () {
        $('body,html').animate({
            scrollTop: 0
        }, 200);
        return false;
    });
  };


  /**
   * 선수분석 > 전적 > 입상현황 : 상세 입상현황 보기 클릭시 화면 이동
   */
  function ArrWindowH(el){
    this._$el = null; /* 상세 현황 보기 버튼 */
    this._$window = null; /* window */

    this._init(el);
    this._evt();
  };

  ArrWindowH.prototype._init = function(el) {
    this._$el = $(el);
    this._$window = $(window);
  };

  ArrWindowH.prototype._evt = function() {
    var that = this;
    var nh;
    this._$el.on('click', function(){
      nh = $(this).offset().top - $(this).outerHeight(true);
      $('body, html').stop().animate({
        scrollTop : nh
      }); // animate end
    }); // click end
  };

  $.fn.arrWindowH = function(el){
    this.each(function(){
      var arrWindowH = new ArrWindowH(el);
    });
    return this;
  }


    /**
   * [SwOnOff on-off 스위치 기능]
   * .sw 클래스 추가시 스위치 기능 작동
   */
  function SwOnOff (el) {
    this._$el = null; /* sw 버튼 */

    this._init(el);
    this._evt();
  };

  // _init
  SwOnOff.prototype._init = function(el) {
    this._$el = $(el);
  };

  // _evt
  SwOnOff.prototype._evt = function() {
    var that = this;
    this._$el.on('click', function(e){
      $(this).toggleClass('on');
      e.preventDefault();
    });
  };

  $.fn.swOnOff = function(el){
    this.each(function(){
      var swOnOff = new SwOnOff(el);
    });
    return this;
  };

  /**
   * 훈련일지 부상부위 체크
   * el = .table_01
   */
  function ChkInjury(el){
    this._$el = null; /*.table_01*/
    this._$injuryAreaIpt = null; /* input의 InjuryArea */
    this._$bodyImgOn = null; /* body-img 아래 on 이미지 */

    this._$injuryIptVal = null; /* injury value */
    this._$foldingBtn = null; /* 등, 척추, 허리 */
    this._$foldingTd = null; /* 등, 척추, 허리 겹쳐지는 부분 img */

    this._init(el);
    this._evt();
  };

  ChkInjury.prototype._init = function(el) {
    this._$el = $(el);
    this._$injuryAreaIpt = this._$el.find('input[name="InjuryArea"]');
    this._$bodyImgOn = this._$el.find('.body-img img');
    this._$foldingImg = this._$injuryAreaIpt.filter('.folding');
  };

  ChkInjury.prototype._evt = function() {
    var that = this;
    // that._showInjury();
    this._$injuryAreaIpt.on('click', function(){
      that._$injuryIptVal = $(this).attr('value');
      that._$bodyImgOn.filter('#tbody_'+that._$injuryIptVal).toggleClass('on').toggle();
      $('.body-img td').filter('#ttd_'+that._$injuryIptVal).toggle();
    });
    $('.btn-or-pop').on('click', function(){
      that._showInjury();
    });
  };

  ChkInjury.prototype._initShow = function() {
    var that = this;
    that._$injuryIptVal =  this._$injuryAreaIpt.filter(':checked').attr('value');
    that._$bodyImgOn.filter('#tbody_'+that._$injuryIptVal).toggleClass('on').toggle();
    $('.body-img td').filter('#ttd_'+that._$injuryIptVal).toggle();
  };

  ChkInjury.prototype._showInjury = function() {
    var that = this;
    this._$injuryAreaIpt.each(function(){
      that._$injuryIptVal = $(this).attr('value');
      if ($(this).prop('checked')) {
        $('.body-img td').find('#tbody_'+that._$injuryIptVal).css({
          'display' : 'table-cell'
        });
        $('.body-img td').find('#tbody_'+that._$injuryIptVal).parents('td').show();
      } else {
        $('.body-img td').find('#tbody_'+that._$injuryIptVal).hide();
        // $('.body-img td').find('#tbody_'+that._$injuryIptVal).parents('td').hide();
      }
    });
  };

  $.fn.chkInjury = function(el){
    this.each(function(){
      var chkInjury = new ChkInjury(el);
    });
    return this;
  };


  /**
   * --------------------------------
   * showTab 탭메뉴2
   * 사용법, el = tab-menu 구현할 요소
   * tab-btn = a 요소
   * 높이 자동조절 막기 = tab-panel에 h-fix 클래스 추가
   * --------------------------------
   */
  function ShowTab(el, count){
    this._$el = $(el); /* tab-menu */
    this._elH = -1; /* tab-menu 높이 */
    this._$tabBtn = null; /* tab-btn */
    this._$tabPanel = null;
    this._panelH = -1; /* tab-panel 높이 */

    this._selected = null; /* 선택된 요소 담을 프로퍼티 */
    this._selectedPanel = null; /* 선택된 패널 담을 프로퍼티 */

    this._elNHeight = -1; /* 감싸고 있는 요소의 높이값 */

    if (this._$el.length == 0) {
      return;
    }

    this._init(el, count);
    this._evt();
    this._selectTab(this._$tabBtn.eq(count));
    this._showPanel(count);
    this._arrangeTabH(this._$tabBtn.eq(count));
  };

  ShowTab.prototype._init = function(el, count) {
    // this._$el = $(el);
    this._elH = this._$el.outerHeight(true);
    this._$tabBtn = this._$el.find('.tab-btn');
    (count == undefined) ? count = 0 : '';
    this._$tabPanel = this._$el.find('.tab-panel');
    (this._$tabPanel == undefined) ? this._$tabPanel = $('.tab-panel > li') : '';
  };

  ShowTab.prototype._evt = function() {
    var that = this;
    var idx;
    this._$tabBtn.on('click', function(e){
      that._$tabBtn.removeClass('on');
      idx = $(this).parents('li').index(); /* li의 index 값 */
      that._selectTab($(this));
      that._showPanel(idx);
      that._arrangeTabH($(this), idx);
      e.preventDefault();
    }); // tabBtn click end
  };

  /* selectTab 탭메뉴 기능 구현 - toggle 제외 */
  ShowTab.prototype._selectTab = function($this) {
    if (this._selected) {
      this._selected.removeClass('on');
    }
    this._selected = $this;
    this._selected.addClass('on');
  };

  /* tabPanel 보이기 */
  ShowTab.prototype._showPanel = function(idx) {
    if (this._selectedPanel) {
      this._selectedPanel.removeClass('on').css({
        'display' : 'none',
      });
    }
    this._selectedPanel = this._$tabPanel.eq(idx);
    this._selectedPanel.addClass('on').css({
      'display' : 'block',
    });
  };

  /* tab-menu 높이 조절 */
  /* $this 는 $tab-btn */
  ShowTab.prototype._arrangeTabH = function($this, idx) {
    if ($this == undefined) {
      return false;
    }
    // 리스트 보기일때
    if ($this.hasClass('result-report')) {
      this._$el.css({
        'height' : 'auto'
      });
      if ($this.parents('.show-btn').siblings('.result-report').children().length < 1) {
        $this.parents('.show-btn').siblings('.result-report').css({
          'padding-bottom' : 0
        });
      }
      if ($this.parents('.show-btn').siblings('.result-report').children().length > 0) {
        $this.parents('.show-btn').siblings('.result-report').css({
          'padding-bottom' : 30
        });
      }
    }
    // 대진표 보기일때
    // if ($this.hasClass('tourney-result')) {
    //   var y = parseInt($('.tourney-mode > .tourney').outerHeight(true) + $('.tourney-mode > .btn-guide').outerHeight(true));
    //   this._$el.css({
    //     'height' : y + 260
    //   });
    // }
    // this._$el (실행 타겟)에 h-fix 클래스 있으면 중지
    if (this._$el.hasClass('h-fix')) {
      return false;
    }
    (idx == undefined) ? idx = 0 : '';
    this._panelH = this._$tabPanel.eq(idx).outerHeight(true);
    this._elNHeight = this._elH + this._panelH;
    // 메인 : 대회일정/결과, 훈련계획/결과 버튼 클릭시
    if ($this.parents().hasClass('sche-tab')) {
      this._elNHeight = this._elH + this._panelH + 10;
    }
    this._$el.css({
      'height' : this._elNHeight
    });
  };

  $.fn.showTab = function(el, count){
    this.each(function(){
      var showTab = new ShowTab(el, count);
    });
    return this;
  }


  /**
   * collapse 태그 on toggle
   * a태그의 클래스 .rotate-caret
   */
  function CollapseTgOn(el){
    this._$el = null; /* .rotate-caret */

    this._init(el);
    this._evt();
  };

  CollapseTgOn.prototype._init = function(el) {
    this._$el = $(el);
  };

  CollapseTgOn.prototype._evt = function() {
    this._$el.on('click', function(){
      $(this).toggleClass('on');
    });
  };

  $.fn.collapseTgOn = function(el){
    this.each(function(){
      var collapseTgOn = new CollapseTgOn(el);
    });
    return this;
  };


  // 아코디언 btn rotate
  function tgRotateOn(){    
    var selected
    $(".panel-title > a").click(function(){
      if ($(this).hasClass('on')){
          $(this).removeClass('on');
          return;
      }
      if (selected) {
          selected.removeClass('on');
      }
      selected = $(this);
      selected.addClass("on");
    });
  }
  tgRotateOn();

  function TgRotateOns(el){
    var selected
    $('.panel-title > a').click(function(){
      if ($(this).hasClass('on')){
          $(this).removeClass('on');
          return;
      }
      if (selected) {
          selected.removeClass('on');
      }
      selected = $(this);
      selected.addClass("on");
    }); // click end
  }

  $.fn.tgRotateOns = function(el){
    this.each(function(){
      var tgRotateOns = new TgRotateOns(el);
    });
    return this;
  }


  /**
   * 자주하는 질문, faq Q & A 수정
   * el = faq-contents id로 전체 지정
   */
  function FaqMove(el){
    this._$el = null; /* #faq-contents */
    this._$panel = null; /* 전체 감싸는 panel */
    this._$panelCollapse = null; /* 답변내용 */

    this._init(el);
    this._evt();
  };

  FaqMove.prototype._init = function(el) {
    this._$el = $(el);
    this._$panel = this._$el.find('.panel');
    this._$panelCollapse = this._$el.find('.panel-collapse');
  };

  FaqMove.prototype._evt = function() {
    this._moveAnswer();
  };

  FaqMove.prototype._moveAnswer = function() {
   this._$panelCollapse.each(function(){
     $(this).appendTo($(this).prev('.panel'));
   });
  };

  $.fn.faqMove = function(el){
    this.each(function(){
       var faqMove = new FaqMove(el);
    });
    return this;
  };


  /**
   * [SwOnOff on-off 스위치 기능]
   * .sw 클래스 추가시 스위치 기능 작동
   */
  function SwOnOff (el) {
    this._$el = null; /* sw 버튼 */

    this._init(el);
    this._evt();
  };

  // _init
  SwOnOff.prototype._init = function(el) {
    this._$el = $(el);
  };

  // _evt
  SwOnOff.prototype._evt = function() {
    var that = this;
    this._$el.on('click', function(e){
      $(this).toggleClass('on');
      e.preventDefault();
    });
  };

  $.fn.swOnOff = function(el){
    this.each(function(){
      var swOnOff = new SwOnOff(el);
    });
    return this;
  };


  /**
   * S: 체력측정 날짜 선택
   */
  function ChoiceDate(el){
    this._$el = null;
    this._$formCtrl = null;
    this._$addon = null;

    this._init(el);
    this._evt();
  }

  ChoiceDate.prototype._init = function(el) {
    this._$el = $(el);
    this._$formCtrl = this._$el.find('.form-control');
    this._$addon = this._$el.find('.input-group-addon');
  };

  ChoiceDate.prototype._evt = function() {
    var that = this;
    this._$addon.on('click', function(e){
      that._$formCtrl.focus().click();
    });
  };

  $.fn.choiceDate = function(el){
    this.each(function(){
      var choiceDate = new ChoiceDate(el);
    });
    return this;
  }

  // 실행
  $('.train.strength').choiceDate('.input-group.date');


  /**
   * S: 하단 고정 메뉴들 ios 대응
   */
  function PolyfillPositionBottom(el){
    this._$el = null;
    this._$input = null;

    this._init(el);
    this._evt();
  }

  PolyfillPositionBottom.prototype._init = function(el) {
    this._$el = $(el);
    this._$textarea = $('#memory textarea');
    this._$joinIpt = $('.join-2 input');
  };

  PolyfillPositionBottom.prototype._evt = function() {
    var that = this;
    this._$textarea.on('focusin', function(){
      that._$el.stop().animate({
        'opacity' : 0
      }, 200).hide();
    });
    this._$textarea.on('focusout', function(){
      that._$el.stop().animate({
        'opacity' : 1
      }, 600, function(){
        $(this).show();
      });
    });

    this._$joinIpt.on('focusin', function(){
      that._$el.stop().animate({
        'opacity' : 0
      }, 200).hide();
    });

    this._$joinIpt.on('focusout', function(){
      that._$el.stop().animate({
        'opacity' : 1
      }, 600, function(){
        $(this).show();
      });
    })
  };

  $.fn.polyfillPositionBottom = function(el){
    this.each(function(){
      var polyfillPositionBottom = new PolyfillPositionBottom(el);
    });
    return this;
  }

  // 실행
  // 하단 메뉴
/*  $('.bottom-menu').polyfillPositionBottom('.bottom-menu');
  // 상단 이동 버튼 TOP
  $('a.top_btn').polyfillPositionBottom('a.top_btn');*/
  /* E: 하단 고정 메뉴들 ios 대응 */


  /**
   * S: join4 배경 전체 화면 대응
   */
  var fullHeight = {
    start : function(tg) {
      this._init(tg);
      this._evt();
    },
    _$tg : null, /* 늘어날 요소 */
    _$window : null, /* window 객체 */
    _$subHeader : null, /* sub-header */
    _nh : -1, /* 높이값 계산 */

    _init : function(tg) {
      this._$tg = $(tg);
      this._$window = $(window);
      this._$subHeader = $('.sub-header');
    },
    _evt : function(){
      var that = this;
      this._$window.on('load', function(){
        that._nh = ($(this).innerHeight() - that._$subHeader.innerHeight());
        if (that._$tg.hasClass('type-2')) {
          that._nh = $(document).outerHeight();
        }
        that._$tg.css({
          'height' : that._nh
        });
      });
    }
  }

  // 실행
  fullHeight.start('.sub .join-end');
  /* E: join4 배경 전체 화면 대응 */

  function addressInput() {
    var stY;
    $('.address-input a.btn-gray').on('click', function(){
      stY = $(window).scrollTop();
      $('html, body').scrollTop(0);
      console.log(stY);
    });
    $('#btnFoldWrap').on('click', function(){
      $('html, body').scrollTop(stY);
    })
  }

  addressInput();

  /**
   * S: modal-fade 높이 대응
   */
  function arrangeModalBg(){
    $('#show-score').on('shown.bs.modal', function(){
      $(this).find('.modal-backdrop.in').eq(0).css({
        'height' : $(window).innerHeight()
      });
    });
  }

  arrangeModalBg();
  /* E: modal-fade 높이 대응 */

  /**
   * S: select-on
   */
  function selectOnChange(){
    $('#search_date select').on('change', function(){
      $(this).parents('#search_date').addClass('on');
    });
    $('#SDate').on('change', function(){
      $('#search_date').removeClass('on');
    });
    $('#EDate').on('change', function(){
      $('#search_date').removeClass('on');
    })
  }
  selectOnChange();
  /* E: select-on */

  /**
   * S: 훈련일지 공식훈련 추가/삭제
   */
  function PublicTrain(el){
    this._$el = null;
    this._$trainWrap = null;
    this._$addTrainBtn = null; // 1번째 추가 버튼
    this._$removeTrainBtn = null; // 1번째 삭제 버튼

    this._sc = -1; /* scroll 위치 */

    this._init(el);
    this._evt();
  }

  PublicTrain.prototype._init = function(el) {
    this._$el = $(el);
    this._$trainWrap = this._$el.find('#official-train-wrap');
    this._$addTrainBtn = this._$trainWrap.find('.btn-navyline'); // 추가 버튼
    this._$removeTrainBtn = this._$el.find('.del-train-btn'); // 삭제 버튼
  };

  PublicTrain.prototype._evt = function() {
    var that = this;
    /**
     * --------------------------------
     * 추가 기능
     * --------------------------------
     */
    // 훈련구분 추가 버튼
    this._$addTrainBtn.on('click', function(e){
      if ($(this).hasClass('lock')) {
        alert("지도자의 관리를 받고 있습니다. 변경 할 수 없습니다.");
        return;
      }
      $(this).slideUp();
      $(this).next().delay(300).slideDown();
      e.preventDefault();
    });

    /**
     * --------------------------------
     * 삭제 기능
     * --------------------------------
     */
    this._$removeTrainBtn.on('click', function(e){
      if ($(this).hasClass('lock')) {
        alert("지도자의 관리를 받고 있습니다. 변경 할 수 없습니다.");
        return;
      }
      $(this).parents('.official-train-wrap').slideUp();
      $(this).parents('.official-train-wrap').prev().delay(300).slideDown();
      e.preventDefault();
    });
  };

  $.fn.publicTrain = function(el){
    this.each(function(){
      var publicTrain = new PublicTrain(el);
    });
    return this;
  }


  /**
   * S: prof-img 모달내 이미지 조절
   * el = .show-prof-img.modal
   */
  function ProfImgArr(el){
    this._$el = null;
    this._$mBody = null; /* modal-body */
    this._$pImg = null; /* .prof-img */

    this._init(el);
    this._evt();
  }

  ProfImgArr.prototype._init = function(el) {
    this._$el = $(el);
    this._$mBody = this._$el.find('.modal-body');
    this._$pImg = this._$mBody.find('.prof-img');
  };

  ProfImgArr.prototype._evt = function() {
    var that = this;
    this._$el.on('show.bs.modal', function(){
      that._setBodyH();
    }); // end show.bs.modal
  };

  ProfImgArr.prototype._setBodyH = function() {
    var y = ($(window).innerHeight() - 155);
    this._$pImg.css({
      'height' : y
    })
  };

  $.fn.profImgArr = function(el){
    this.each(function(){
      var profImgArr = new ProfImgArr(el);
    });
    return this;
  }

  // 실행  안넣기로 함
  // $('.show-prof-img').profImgArr('.show-prof-img');
  /* E: prof-img 모달내 이미지 조절  */


  function btnMapWidline (){
    var $btnMapWidline = $('.btn-map-widline');
    $btnMapWidline.on('click', function(){
      $(this).toggleClass('on');
    });
  }

  btnMapWidline();



  /* E: 단체정보 조회 지도보기 버튼 toggle */

  /**
   * S: lastBorderDel
   */
  function lastBorderDel(){
    var $subs = $('.list-info span.subs');
    console.log($subs.length);
  }

  // 실행 - ajax 에서 실행
  // lastBorderDel();
  /* E: lastBorderDel */

  // 실행 select > train_search.asp 에서 실행
  // $('#official-train-wrap').publicTrain('#official-train-wrap');
  /* E: 훈련일지 공식훈련 추가/삭제 */

  /**
   * S: 경기기록실, 나의통계, 메모리, 선수분석 intro-bg
   */
  function IntroBg(){
    this._$bgIpt = null;
    this._$bgInst = null;
    this._$bgTail = null;

    this._$cClose = null;
    this._$cOpen = null;
    this._$closeBtn = null; /* 닫기 버튼 (좌측) */

    this._init();
    this._evt();
  }

  IntroBg.prototype._init = function() {
    this._$bgIpt = $('.bg-ipt');
    this._$bgInst = $('.bg-inst');
    this._$bgTail = $('.bg-tail');

    this._$cOpen = $('#click_open');
    this._$cClose = $('#click_close');
    this._$closeBtn = $('.bg-ipt .btn-list .btn-close');
  };

  IntroBg.prototype._evt = function() {
    var that = this;
    // 열림 아이콘 클릭
    this._$cOpen.on('click', function(){
      that._showBg();
    });

    // 닫기 아이콘 클릭
    this._$cClose.on('click', function(){
      that._hideBg();
    });

    // 닫기 버튼 클릭
    this._$closeBtn.on('click', function(){
      that._hideBg();
    });
  };

  IntroBg.prototype._showBg = function() {
    var that = this;
    this._$bgIpt.slideDown('slow', function(){
      that._$cClose.show();
      that._$cOpen.hide();
    });
    if (this._$bgInst.hasClass('closed')) {
      this._$bgInst.removeClass('closed');
    }
  };

  IntroBg.prototype._hideBg = function() {
    var that = this;
    this._$bgIpt.slideUp('slow', function(){
      that._$cClose.hide();
      that._$cOpen.show();
    });
    if (!(this._$bgInst.hasClass('closed'))) {
      this._$bgInst.addClass('closed');
    }
  };

  $.fn.introBg = function(){
    this.each(function(){
      var introBg = new IntroBg();
    });
    return this;
  }

  // 실행
  $(document).introBg();
  /* E: 경기기록실, 나의통계, 메모리, 선수분석 intro-bg */

  // 마이페이지 > 내정보 관리 : 관심 분야
  function TabFavList(){
    var $favBtn = $('.fav-list ul li a');

    $favBtn.on('click', function(e){
      $(this).toggleClass('on');
      e.preventDefault();
      if ($(this).hasClass('on')) {
        $(this).find('input').prop('checked', 'checked')
      } else {
        $(this).find('input').prop('checked', '')
      }
    });
  }

  $.fn.tabFavList = function(){
    this.each(function(){
      var tabFavList = new TabFavList();
    });
  }

  // 실행 - ajax 에서 실행
  $('.fav-list').tabFavList();

  // 실행 - ajax 실행
  // tabFavList();

  var calendarCtr = {
    _$cal : null,
    _touchStart : 0,
    _swipeOrigin : 0, /* swipe 할 원래 위치 */
    _handlingTouch : false,
    _x : 0,
    start : function(){
      this._init();
      this._evt();
    },
    _init : function(){
      this._$cal = $('#calendar');
    },
    _evt : function(){
      var that = this;
     /* $('body').on('touchstart', $('#calendar'), function(e){
        if (e.touches == undefined) {
          return;
        }
        if (e.touches.length == e.changedTouches.length) {
          that._touchStart = {
            x : e.touches[0].clientX,
          }
        }
        e.preventDefault();

      }); // touchstart end

      this._$cal.on('touchmove', function(e){
        if (that._touchStart) {
          if (Math.abs(e.changedTouches[0].clientX - that._touchStart.x)) {
            that._handlingTouch = true;
            that._swipeStart(e);
          }
          // 터치 시작 위치 초기화
          that._touchStart = undefined;
        } else if (that._handlingTouch) {
            that._swipeMove(e);
        }
        e.preventDefault();

      }); // touchmove end
      this._$cal.on('touchend', function(e){
        if (that._handlingTouch && e.touches.length == 0) {
          that._swipeEnd(e);
          that._handlingTouch = false;
        }
          e.preventDefault();

      }); // touchend*/
      this._$cal.on('touchstart', function(e){
        if (e.touches == undefined) {
          return;
        }
        if (e.touches.length == e.changedTouches.length) {
        that._touchStart = {
          x : e.touches[0].clientX,
        }
      }
      }); // touchstart end

      this._$cal.on('touchmove', function(e){
        if (that._touchStart) {
          if (Math.abs(e.changedTouches[0].clientX - that._touchStart.x)) {
            that._handlingTouch = true;
            e.preventDefault();
            that._swipeStart(e);
          }
          // 터치 시작 위치 초기화
          that._touchStart = false;
        } else if ( that._handlingTouch ) {
          e.preventDefault();
          that._swipeMove(e);
        }
      }); // touchmove end

      this._$cal.on('touchend', function(e){
        if (that._handlingTouch && e.touches.length == 0) {
          e.preventDefault();
          that._swipeEnd(e);
          that._handlingTouch = false;
        }
      }); // touchend end
    }, // evt end

    _swipeStart : function(e) {
      this._swipeOrigin = e.touches[0].clientX;
    },
    _swipeMove : function(e) {
      this._x = e.touches[0].clientX - this._swipeOrigin;
    },
    _swipeEnd : function(e) {
      if (this._swipeOrigin < this._x) {
        // '왼쪽 이전달';
        $('#calendar').fullCalendar('prev');
        var calendar = $('#calendar').fullCalendar('getDate');
        var m = calendar.format();
        var year = this._yy(m);
        var mon = this._mm(m);
        $(".year").val(year);
        $(".month").text(mon);

        document.cookie = "GameTitleIDX=; path=/;";
        document.cookie = "SearchDate="+m+"; path=/;";
      }
      if (this._swipeOrigin > this._x) {
        // '오른쪽 다음달';
        this._$cal.fullCalendar('next');
        var calendar = this._$cal.fullCalendar('getDate');
        var m = calendar.format();
        var year = this._yy(m);
        var mon = this._mm(m);

        $(".year").val(year);
        $(".month").text(mon);

        document.cookie = "GameTitleIDX=; path=/;";
        document.cookie = "SearchDate="+m+"; path=/;";
      }
    }, // swipe end
    _moveCalendar : function(dir){
      if (dir == 'left') {
        this._$cal.fullCalendar('prev');
      }
      if (dir == 'right') {
        this._$cal.fullCalendar('next');
      }
    }, // moveCalendar end
    _yy : function (yy) {
        var month = yy.split('-');
        return month[0];
    },
     _mm : function (mm) {
        var month = mm.split('-');
        return month[1] + "월";
    },
  }

  // calendar swipe
  // calendarCtr.start();

  /**
   * BoardSwTail 지도자 상담 tail-btn
   */
  function BoardSwTail (){
    this._$body = null;
    this._$btn = null;

    this._init();
    this._evt();
  }

  BoardSwTail.prototype._init = function() {
    this._$body = $('body');
    this._$btn = $('.lack-sw-tail');
  };

  BoardSwTail.prototype._evt = function() {
    var that = this;
    this._$btn.on('click', function(){
      if (that._$body.hasClass('lack-bg')) {
        $(this).toggleClass('gray-bg');
      }
    });
  };

  $.fn.boardSwTail = function(){
    this.each(function(){
      var boardSwTail = new BoardSwTail();
    });
    return this;
  }

  // 실행
  $('.lack-sw-tail').boardSwTail();

  /**
   * S: select > option value 의 내용과 일치하는 class 보이기
   */
  function ShowValueClass(tg, showClass){
    this._$memberType = null; /* change 할 select */
    this._$guideText = null; /* guide text */
    this._$guideItem = null; /* guide text 의 항목들 */

    this._$valueBox = null; /* select 가 변경되면서 담을 value */
    this._selectedItem = null; /* select 된 text 항목 */

    this._init(tg, showClass);
    this._evt();
  };

  ShowValueClass.prototype._init = function(tg, showClass) {
    this._$memberType = $(tg);
    this._$guideText = $(showClass);
    this._$guideItem = this._$guideText.children();
  };

  ShowValueClass.prototype._evt = function() {
    var that = this;
    this._$memberType.on('change', function(){
      that._$valueBox = $(this).val();
      that._chkValue(that._$valueBox);
    });
  };

  ShowValueClass.prototype._chkValue = function(val) {
    switch (val) {
      case 'PLY_REG' :
        // console.log('대한체육회 등록선수');
        this._showItem('PLY_REG');
        break;
      case 'PLY_NONREG' :
        // console.log('대한체육회 비등록선수');
        this._showItem('PLY_NONREG');
        break;
      case 'PLY_PARENTS' :
        // console.log('선수 보호자');
        this._showItem('PLY_PARENTS');
        break;
      case 'PLY_NORMAL' :
        // console.log('일반');
        this._showItem('PLY_NORMAL');
        break;
      default :
        this._hideItem();
        break;
    }
  };

  // guide text 내용들 전부 감추기
  ShowValueClass.prototype._hideItem = function() {
    this._$guideText.css({
      'display' : 'none'
    });
    this._$guideItem.css({
      'display' : 'none'
    });
  };

  // guide text 중 선택된 내용 보이기
  ShowValueClass.prototype._showItem = function(val) {
    this._$guideText.css({
      'display' : 'block'
    });
    if (this._selectedItem) {
      this._selectedItem.fadeOut().hide();
    }
    this._selectedItem = this._$guideItem.filter('.'+val.toLowerCase());
    this._selectedItem.fadeIn().show();
  };

  $.fn.showValueClass = function(tg, showClass){
    this.each(function(e){
      var showValueClass = new ShowValueClass(tg, showClass);
    });
    return this;
  }

  /* E: select > option value 의 내용과 일치하는 class 보이기 */


  /**
   * 대진표 경기 버튼 터치 시
   * scale 원래대로 유지
   */
  function ScaleStay(tg){
    this._$tourney = null;
    this._$modalBtn = null;

    this._init(tg);
    this._evt();
  }

  ScaleStay.prototype._init = function(tg) {
    this._$tourney = $('.tourney', tg);
    this._$modalBtn = $('.line-div a.btn', this._$tourney);
  };

  ScaleStay.prototype._evt = function() {
    this._$modalBtn.on('click', function(e){
      $(document).attr('content', 'width=100%');
      e.preventDefault();
    });
  };

  $.fn.scaleStay = function(tg){
    this.each(function(){
      var scaleStay = new ScaleStay(tg);
    });
    return this;
  }

  // 실행
  // $('#DP_tourney').scaleStay('#DP_tourney');

  /**
   * Android 버전 체크 후,
   * 대진표 scale 조절
   */
    function ChkAndroid(){
      this._$version = -1;
      this._$body = null;
      this._$head = null;
      this._$additionLink = '';

      this._init();
      this._evt();
    };

    ChkAndroid.prototype._init = function() {
      this._$version = window.navigator.userAgent.toLowerCase();
      this._$html = $('html');
      this._$head = this._$html.find('head');
      this._$additionLink = '<link rel="stylesheet" href="../css/add_tourney.css">'
    };

    ChkAndroid.prototype._evt = function() {
      if (this._$version.indexOf('android 2.0') > 0) {
        this._$head.append(this._$additionLink);
        // alert(this._$version); // 버전 체크
      }
    };

    $.fn.chkAndroid = function(){
      this.each(function(){
        var chkAndroid = new ChkAndroid();
      });
      return this;
    }

  // $('.sub.sub-main.tourney').chkAndroid();

  /**
   * S: 상단 메뉴 가로 스크롤
   */
  function ScrollHoriMenu(tg){
    this._$tg = null;
    this._$btn = null;

    this._init(tg);
    this._evt();
  }

  ScrollHoriMenu.prototype._init = function(tg) {
    this._$tg = $(tg);
    this._$btn = $('.btn', this._$tg);
  };

  ScrollHoriMenu.prototype._evt = function() {
    var that = this;
    this._arrBtnParent(this._$btn);
  };

  ScrollHoriMenu.prototype._arrBtnParent = function(btn) {
    var $btnParent = btn.parents('.total-box');
    var nw = 0;
    btn.each(function(){
      nw += $(this).parent().outerWidth(true);
    });
    $btnParent.css({
      'width' : nw
    });
  };

  $.fn.scrollHoriMenu = function(tg){
    this.each(function(){
      var scrollHoriMenu = new ScrollHoriMenu(tg);
    });
    return this;
  }

  $('.hori-scroll').scrollHoriMenu('.hori-scroll');
  /* E: 상단 메뉴 가로 스크롤 */


  /**
   * 회원가입 > 가입자구분
   */
  function DivnUser(el){
    this._$el = null; /* user-division */
    this._$step1Btn = null; /* step_1 label */
    this._step1LabelClass = ''; /* step1_label의 클래스 */

    this._$step2 = null; /* step_2 */
    this._$step2Btn = null; /* step_2 label */
    this._$step2DD = null; /* step_2의 자식 dd */

    this._$step3 = null; /* step_3 */
    this._$step3Btn = null; /* step_3 label */

    this._$step4 = null; /* step_4 */
    this._$step4Btn = null; /* step_4 label */

    this._$selectedLabelStep1 = null; /* step1의 선택된 label */
    this._$selectedLabelStep2 = null; /* step2의 선택된 label */
    this._$selectedLabelStep3 = null; /* step3의 선택된 label */
    this._$selectedLabelStep4 = null; /* step3의 선택된 label */
    this._$selectedDD = null; /* step2 의 선택된 dd */

    this._$sportsType = null; /* 종목 선택 select */

    this._init(el);
    this._evt();
    this._initSubStep();
  }

  DivnUser.prototype._init = function(el){
    this._$el = $(el);
    this._$step1Btn = $('.step_1 input', this._$el);
    this._$step2 = $('.step_2', this._$el);
    this._$step2Btn = $('input', this._$step2);
    this._$step2DD = $('dd', this._$step2);
    this._$step3 = $('.step_3', this._$el);
    this._$step3Btn = $('input', this._$step3);
    this._$step4 = $('.step_4', this._$el);
    this._$step4Btn = $('input', this._$step4);
    this._$sportsType = $('.sports_type', this._$el);
  };

  DivnUser.prototype._evt = function() {
    var that = this;
    // 클릭한 input의 부모 label에 on 클래스에 따라 구분
    this._$step1Btn.on('click', function(){
      if ($(this).parent().hasClass('normal')) { // 일반
        if ($(this).parent().hasClass('on')) {
          $(this).parent().removeClass('on');
          $(this).prop('checked','');
          that._$sportsType.slideDown();
          return;
        } else {
          that._$sportsType.slideUp();
        }
        if (!($(this).parent().siblings('label').hasClass('on'))) {
          $(this).parent().addClass('on');
          that._$step2.hide();
        }
        if ($(this).parent().siblings('label').hasClass('on')) {
          that._$selectedLabelStep1.removeClass('on');
          $(this).parent().addClass('on');
          that._step2Toggle('off');
        }
        that._$step3.slideUp();
        that._$step4.slideUp();
        if (that._$selectedLabelStep3) {
          that._$selectedLabelStep3.removeClass('on');
          that._$selectedLabelStep3.find('input').prop('checked', '');
        }
        if (that._$selectedLabelStep4) {
          that._$selectedLabelStep4.removeClass('on');
          that._$selectedLabelStep4.find('input').prop('checked', '');
        }
        return;
      } // 일반 end

      if ($(this).parent('label').hasClass('on')) {
        that._labelRemoveOn($(this));
        that._$sportsType.slideUp();
      } else {
        that._labelAddOn($(this));
        that._$sportsType.slideDown();
      }

      // 선수 외 end
      if (!($(this).parent().hasClass('player'))) {
        that._step3Toggle('off');
        that._$step4.slideUp();

        if (that._$selectedLabelStep3) {
          that._$selectedLabelStep3.removeClass('on');
          that._$selectedLabelStep3.find('input').prop('checked', '');
        }
        if (that._$selectedLabelStep4) {
          that._$selectedLabelStep4.removeClass('on');
          that._$selectedLabelStep4.find('input').prop('checked', '');
        }
      } // 선수 외 end

      if (that._$selectedLabelStep2) {
        that._$selectedLabelStep2.removeClass('on');
        that._$selectedLabelStep2.find('input').prop('checked','');
      }
    }); // click end

    this._$step2Btn.on('click', function(){
      if ($(this).parent('label').hasClass('on')) {
        that._step2LabelRemoveOn($(this));
        that._$step3.slideUp();
        that._$step4.slideUp();
        if (that._$selectedLabelStep3) {
          that._$selectedLabelStep3.removeClass('on');
          that._$selectedLabelStep3.find('input').prop('checked','');
        }
        if (that._$selectedLabelStep4) {
          that._$selectedLabelStep4.removeClass('on');
          that._$selectedLabelStep4.find('input').prop('checked','');
        }
      } else {
        that._step2LabelAddOn($(this));
      }
    }); // step2Btn click end

    this._$step3Btn.on('click', function(){
      if ($(this).parent('label').index() == 1) {
        that._$step4.slideDown();
      } else {
        that._$step4.slideUp();
        if (that._$selectedLabelStep4) {
          that._$selectedLabelStep4.removeClass('on');
          that._$selectedLabelStep4.find('input').prop('checked','');
        }
      }
      if ($(this).parent('label').hasClass('on')) {
        that._step3LabelRemoveOn($(this));
      } else {
        that._step3LabelAddOn($(this));
      }
    }); // step3Btn click end

    this._$step4Btn.on('click', function(){
      if ($(this).parent('label').hasClass('on')) {
        that._step4LabelRemoveOn($(this));
      } else {
        that._step4LabelAddOn($(this));
      }
    })
  };

  DivnUser.prototype._initSubStep = function() {
    this._$step2.hide();
    this._$step2DD.fadeOut();
    this._$step3.hide();
    this._$step4.hide();
  };

  /**
   * 선택된 input의 checked 속성 제거
   * 선택된 input의 부모 label에 on 클래스 제거
   * step2 off
   * @param  {object} el [현재 선택한 input]
   */
  DivnUser.prototype._labelRemoveOn = function($el) {
    $el.prop('checked', ''); // input에 checked 제거
    this._$selectedLabelStep1 = $el.parent('label');
    this._$selectedLabelStep1.removeClass('on'); // label에 on 제거

    var labelClass = this._$selectedLabelStep1.attr('class');

    /* step2 toggle */
    this._step2Toggle(this._$selectedLabelStep1);
    this._step3Toggle('off');
  };

  /**
   * 선택된 input의 checked 속성 추가
   * 선택된 input의 부모 label에 on 클래스 추가
   * step2 on
   * @param  {object} el [현재 선택한 input]
   */
  DivnUser.prototype._labelAddOn = function($el) {
    $el.prop('checked', 'checked'); // input에 checked 추가
    this._$selectedLabelStep1 = $el.parent('label');
    this._$selectedLabelStep1.siblings('label').removeClass('on'); // label 형제 on 제거
    this._$selectedLabelStep1.addClass('on'); // label에 on 추가

    /* step2 toggle */
    this._step2Toggle(this._$selectedLabelStep1);
  };

  /**
   * step2Toggle : step2 보이기/감추기
   * @param  {[type]} $selected [선택한 input 의 label]
   */
  DivnUser.prototype._step2Toggle = function($selected) {
    if ($selected == 'off') { // off 를 던지면 무조건 step2 감추기
      this._$step2.slideUp();
      return;
    }
    if ($selected.hasClass('on')) {
      this._$step2.slideDown();
    } else {
      this._$step2.slideUp();
    }
    this._step1LabelClass = $selected.attr('class').replace('on', '');
    this._step2dd(this._step1LabelClass);
  };

  /**
   * step2dd  : label 클래스와 같은 step2 dd 클래스 보이기
   * @param  {[type]} $selected [선택한 input 의 label]
   */
  DivnUser.prototype._step2dd = function(name){
    if (this._$selectedDD) {
      this._$selectedDD.hide();
    }
    this._$selectedDD = this._$step2DD.filter('.'+name);
    this._$selectedDD.fadeIn();
  };

  DivnUser.prototype._step2LabelRemoveOn = function($el) {
    $el.prop('checked', ''); // input에 checked 제거
    this._$selectedLabelStep2 = $el.parent('label');
    this._$selectedLabelStep2.removeClass('on'); // label에 on 제거
    this._step3Toggle(this._$selectedLabelStep2);
  };

  DivnUser.prototype._step2LabelAddOn = function($el) {
    $el.prop('checked', 'checked'); // input에 checked 추가
    this._$selectedLabelStep2 = $el.parent('label');
    this._$selectedLabelStep2.siblings('label').removeClass('on'); // label 형제 on 제거
    this._$selectedLabelStep2.addClass('on'); // label에 on 추가
    this._step3Toggle(this._$selectedLabelStep2);
  };

  /**
   * step3Toggle : step3 보이기/감추기
   * @param  {[type]} $selected [선택한 input 의 label]
   */
  DivnUser.prototype._step3Toggle = function($selected) {
    if ($selected == 'off') {
      this._$step3.slideUp();
      return;
    }
    if ($selected.hasClass('elite')) {
      this._$step3.slideDown();
    } else {
      this._$step3.slideUp();
      this._$step4.slideUp();
      if (this._$selectedLabelStep3) {
        this._$selectedLabelStep3.removeClass('on');
        this._$selectedLabelStep3.find('input').prop('checked', '');
      }
      if (this._$selectedLabelStep4) {
        this._$selectedLabelStep4.removeClass('on');
        this._$selectedLabelStep4.find('input').prop('checked', '');
      }
    }
  };

  DivnUser.prototype._step3LabelRemoveOn = function($el) {
    $el.prop('checked', ''); // input에 checked 제거
    this._$selectedLabelStep3 = $el.parent('label');
    this._$selectedLabelStep3.removeClass('on'); // label에 on 제거
    this._$step4.slideUp();
    if (this._$selectedLabelStep4) {
      this._$selectedLabelStep4.removeClass('on');
      this._$selectedLabelStep4.find('input').prop('checked', '');
    }
  };

  DivnUser.prototype._step3LabelAddOn = function($el) {
    $el.prop('checked', 'checked'); // input에 checked 추가
    this._$selectedLabelStep3 = $el.parent('label');
    this._$selectedLabelStep3.siblings('label').removeClass('on'); // label 형제 on 제거
    this._$selectedLabelStep3.addClass('on'); // label에 on 추가
  };

    DivnUser.prototype._step4LabelRemoveOn = function($el) {
    $el.prop('checked', ''); // input에 checked 제거
    this._$selectedLabelStep4 = $el.parent('label');
    this._$selectedLabelStep4.removeClass('on'); // label에 on 제거
  };

  DivnUser.prototype._step4LabelAddOn = function($el) {
    $el.prop('checked', 'checked'); // input에 checked 추가
    this._$selectedLabelStep4 = $el.parent('label');
    this._$selectedLabelStep4.siblings('label').removeClass('on'); // label 형제 on 제거
    this._$selectedLabelStep4.addClass('on'); // label에 on 추가
  };


  $.fn.divnUser = function(el){
    this.each(function(){
      var divnUser = new DivnUser(el);
    });
    return this;
  }


  /**
   * 스위치 토글 버튼
   * el = '.on_off_switch' btn-switch를 묶는 그룹
   */
  function ToggleSwBtn (el) {
    this._$el = null; /* toggle 할 버튼의 그룹 */
    this._$btn = null; /* btn-switch */

    this._init(el);
    this._evt();
  }

  ToggleSwBtn.prototype._init = function (el) {
    this._$el = $(el);
    this._$btn = $('.btn_switch', this._$el);
  }

  ToggleSwBtn.prototype._evt = function () {
    var that = this;
    this._$btn.on('click', function(e){
      $(this).toggleClass('on');
      e.preventDefault();
    })
  }

  $.fn.toggleSwBtn = function (el) {
    this.each(function(){
      var toggleSwBtn = new ToggleSwBtn(el);
    });
    return this;
  }


  /**
   * 종목 메인 검색창 기능
   */
  function ChangeMainSrch() {
    this._$btn = null; /* 검색창 버튼 */
    this._$srchBox = null; /* 검색창 */
    this._$ptMain = null; /* body 전체 */
    this._$closeSrch = null; /* 검색창 닫기 */
    this._$actBtn = null; /* 검색창 버튼 담기 */

    this._init();
    this._evt();
  }

  ChangeMainSrch.prototype._init = function() {
    this._$btn = $('.srch_cont .srch_btn');
    this._$srchBox = $('.srch_box');
    this._$ptMain = $('.part_main');
    this._$closeSrch = $('.ic_close', this._$srchBox);
  }

  ChangeMainSrch.prototype._evt = function() {
    var that = this;
    this._$btn.on('click', function(e) {
      $(this).removeClass('srch_btn').hide();
      that._$actBtn = $(this);
      that._$srchBox.show();
      e.preventDefault();
    });

    this._$closeSrch.on('click', function(){
      that._$actBtn.addClass('srch_btn').show();
      that._$srchBox.hide();
    })
  }

  $.fn.changeMainSrch = function () {
    this.each(function () {
      var changeMainSrch = new ChangeMainSrch();
    });
    return this;
  }


  /**
   * 종목 메인 메인 메뉴
   */
  function MainHoriMain () {
    this._$menuUl = null;
    this._$menuLi = null; /* main menu li */
    this._menuWidth = 0; /* main menu li 전체 길이 */

    this._init();
    this._evt();
  }

  MainHoriMain.prototype._init = function() {
    this._$menuUl = $('.main_menu ul');
    this._$menuLi = $('li', this._$menuUl);
  }

  MainHoriMain.prototype._evt = function() {
    var that = this;
    $(window).on('load resize',function(){
      that._menuWidth = that._$menuLi.width() * that._$menuLi.length;

      that._$menuUl.css({
        'width' : that._menuWidth
      }); // css end
    }); // ready end
  }

  $.fn.mainHoriMain = function () {
    this.each(function () {
      var mainHoriMain = new MainHoriMain();
    });
    return this;
  }


  /**
   * swBtn 구현 아이폰 스위치
   * el = 실행 시킬 대상, 2017. 11. 10 현재 계정 전환에서 사용
   *        : .change_account .count_list
   */
  function SwToggleBtn (el) {
    this._$el = null; /* 실행 시킬 대상 */
    this._$ipt = $('.ctr_btn input'); /* div.ctr_btn 아래 input checkbox */
    this._$selected = null; /* 선택한 요소 담을 프로퍼티 */

    this._init(el);
    this._evt();
  }

  SwToggleBtn.prototype._init = function(el) {
    this._$el = $(el);
    this._$ipt = $('.ctr_btn input', this._$el);
  }

  SwToggleBtn.prototype._evt = function() {
    var that = this;
    this._$ipt.on('click', function(){
      that._chkOnOff($(this));
    });

    $(document).ready(function () {
      that._initChk();
    });
  }

  SwToggleBtn.prototype._initChk = function() {
    var that = this;
    this._$ipt.each(function(){
      if ($(this).parents('.tg').hasClass('on')) {
        $(this).prop('checked', true);
        that._$selected = $(this).parents('.tg');
      } else {
        $(this).prop('checked', false);
      }
    })
  }

  SwToggleBtn.prototype._chkOnOff = function($this) {
    if ($this.parents('.tg').hasClass('on')) {
      $this.parents('.tg').removeClass('on');
      return;
    }
    if (this._$selected) {
      this._$selected.removeClass('on');
      this._$selected.find('.ctr_btn input').prop('checked', false);
    }
    this._$selected = $this.parents('.tg');
    this._$selected.addClass('on');
    this._$selected.find('.ctr_btn input').prop('checked', true);
  }


  $.fn.swToggleBtn = function (el) {
    this.each(function(){
      var swToggleBtn = new SwToggleBtn(el);
    });
    return this;
  }

  $('.change_account .count_list').swToggleBtn('.change_account .count_list');

  var IptLabel = {
  _$el: null,
  _$label: null, /* label */
  _$ipt: null, /* label 안에 있는 span .tit */
  _$iptTit: null, /* label 안에 있는 input */
  _$warnTxt: null, /* 유형성 체크 후 경고 글자 */

  _init: function (el) {
    this._$el = $(el);
    this._$label = $('label', this._$el);
    this._$ipt = $('.no_placeholder', this._$label);
    this._$iptTit = $('.tit', this._$label);
    this._$warnTxt = $('.text-warning', this._$el);

    if (this._$ipt.length < 1) {
      return;
    }

  },
  _evt: function () {
    var that = this;
    this._$ipt.on('click focus', function () {
      TextMove.mvUp($(this).prev('.tit')); // .tit 위로 올리기
      // border 생성
      $(this).parents('li').addClass('on');// on 클래스 추가
    }); // click, focus end

    this._$ipt.on('focusout', function () {
      if ($(this).val().length < 1) {
        TextMove.mvDown($(this).prev('.tit')) // .tit 아래로 내리기
        // border 감추기
        $(this).parents('li').removeClass('on'); // on 클래스 제거
      }
    }); // focusout end

    $(window).on('load', function(){
      that._$ipt.each(function(){
        if ($(this).val().length > 0) {
          TextMove.mvUp($(this).prev('.tit')); // .tit 위로 올리기
          // border 생성
          $(this).parents('li').addClass('on');// on 클래스 추가
        }
      });
    }); // on load end
  },

  start: function (el) {
    if ($(el).length < 1) {
      return;
    }
    this._init(el);
    this._evt();
  }
}

var TextMove = {
  mvUp: function (el) {
    $(el).stop().animate({
      'top' : '-25px',
      'fontSize': '0.76em'
    }, 400, 'easeInOutQuint') // animate end
  }, // mvUp end

  mvDown: function (el) {
    $(el).stop().animate({
      'top': '10px',
      'fontSize': '0.88em'
    }, 400, 'easeInOutQuint') // animate end
  } // mvDown end
}

/**
 * S: 준비중 버튼
 */
function BtnReadyDef(){
  this._$btnReady = null; /* btn_not_yet */

  this._init();
  this._evt();
}

BtnReadyDef.prototype._init = function() {
  this._$btnReady = $('.btn_not_yet');
}

BtnReadyDef.prototype._evt = function() {
  this._$btnReady.on('click', function(e){
    alert('서비스 준비중입니다. \n보다 완성된 서비스로 찾아뵙겠습니다.')
    e.preventDefault();
  })
}

$.fn.btnReadyDef = function(){
  this.each(function(){
    var btnReadyDef = new BtnReadyDef();
  });
  return this;
}

$(document).btnReadyDef();
/* E: 준비중 버튼 */


  /**
 * 상단에 걸리는 메뉴
 * @param {[type]} el [.main_menu]
 */
function FixHeightMenu(el) {
  this._$tg = null; /* .main_menu */
  this._$window = null; /* window */

  this._$tgOffsetY = -1; /* target의 offsetY 위치 */

  this._init(el);
  this._evt();
}

FixHeightMenu.prototype._init = function(el) {
  this._$tg = $(el);
  this._$window = $(window);
  this._$tgOffsetY = this._$tg.offset().top;
}

FixHeightMenu.prototype._evt = function() {
  var that = this;
  this._$window.on('scroll', function(){
    if ($(this).scrollTop() >= that._$tgOffsetY) {
      that._stickyTg('sticky');
    } else {
      that._stickyTg('resolve');
    }
  });
}

FixHeightMenu.prototype._stickyTg = function(act) {
  if (act == 'sticky') {
    this._$tg.addClass('fixed');
  } else {
    this._$tg.removeClass('fixed');
  }
}

$.fn.fixHeightMenu = function(el){
  this.each(function(){
    var fixHeightMenu = new FixHeightMenu(el);
  });
  return this;
}

// $('.main_menu').fixHeightMenu('.main_menu');


  /**
 * ChkSvg = SVG 버튼 체크
 * el = sdmain-pack
 */
  function ChkSvgAni(el) {
    this._$el = $(el);
    this._$icCheck = null;
    this._$ipt = null;

    this._init();
    this._evt();
  }

  ChkSvgAni.prototype._init = function() {
    this._$icCheck = $(".ic_check", this._$el);
    this._$ipt = $("input", this._$icCheck);
  };

  ChkSvgAni.prototype._evt = function() {
    this._$ipt.on("click", function(){
      $(this).parents(".ic_check").toggleClass("on")
    })
  };

  $.fn.chkSvgAni = function(){
    this.each(function(){
      var chkSvgAni = new ChkSvgAni(this);
    });
    return this;
  }



  /**
 * js 시작
 */
  start();
  function start(){
    // sub-menu 실행
    $('.sub-menu').stableSubHeight();
    // side 메뉴
    $(document).gnbHam('.gnb');
    // 하단 메뉴
    $(document).bottomMenu();
    // 메인 공지사항 - .board-list  ajax 에서 호출
    $(document).tabMenu('.board-list', 0);
    // 결제하기 - 결제방법
    $(document).tabMenu('.pay-way ul.tabMenu');
    // 대진표 > 대진표로 보기 : 리스트로 보기
    $('.sub-main.tourney').showTab('.sub-main.tourney');
    // label on sw 실행
    $(document).labelSw('label.img-replace');
    // icon-favorite on, off 변경 실행
    $('.sw-char').iconFav('.sw-char');
    // 리스트 삭제 실행
    $(document).delList();
    // 가로 스크롤 메뉴 > 경기기록실
    $('.record-menu').scrollHoriGnb('.record-menu');
    // 가로 스크롤 메뉴 해당 되는 컨텐츠들 적용
    $('.hori_gnb').scrollHoriGnb('.hori_gnb');
    // 영상보기 모달 > 기록보기 : 영상보기
    $('.film-modal').filmTab('.film-modal');
    // 영상보기 단체전 모달 > 기록보기 : 영상보기
    $('.groups-res').filmTab('.groups-res');
    // collapse 높이 조절
    // 단체정보 조회 지도
    $('.set-collapse').arrHCollapse('.set-collapse');

    // 선수분석 > 전적 > 입상현황 : 상세 보기현황
    $('.detail-win h3 a').arrWindowH('.detail-win h3 a');

    // 부상부위 앞 체크 실행
    $('.table_01').chkInjury('.table_01');
    // 부상부위 뒤 체크 실행
    $('.table_02').chkInjury('.table_02');

    // 상단 이동
    scrollTop();

    // caret 회전 실행
    // $('.rotate-caret').collapseTgOn('.rotate-caret');

   // faq 질문, 내용 DOM 이동 실행 ajax 에서 호출
   // $('#faq-contents').faqMove('#faq-contents');

    // on-off 스위치 실행
    $(document).swOnOff('.sw');

    // toggle on_off_switch 실행
    $(document).toggleSwBtn('.on_off_switch');

    // subMenuCate('.top-icon-menu', subTopCate); // top-icon-menu 인덱싱

    // 가입자 정보 > 회원 구분 radio 선택에 따른 구분
    $('.user-division').divnUser('.user-division');

    // 종목 메인 검색창
    $('.part_main .srch_cont').changeMainSrch();

    // $('.part_main .main_menu').mainHoriMain(); /* 종목 메인 : 메인 메뉴 가로 스크롤 */

    IptLabel.start('.input-form'); /* input placeholder 대신 다른 텍스트 활용 */
    $(".join-body").chkSvgAni();   /* 체크 박스 svg 애니메이션 */








    // 배너 이미지 슬라이더 트리거
		// var $bxSlider = $('.bxslider:not(.modal-dialog .bxslider)');
		// $bxSlider.each(function(index,element){
		// 	var slider = $(element).bxSlider({
		// 		pager: false,
		// 		auto: true,
		// 		pause: 3000,
		// 		width: "auto",
    //     control:true,
		// 		onSlideAfter: function() {
		//         slider.stopAuto();
		//         slider.startAuto();
		//     }
		// 	});
		// });

    // 스크롤 영역 height 셋팅
    // var $sdScrollSection = $('._content _scroll');
    // $sdScrollSection.css({'height': 'calc(100vh - ' + $sdScrollSection[0].offsetTop + 'px)'});
  }
})(jQuery);
