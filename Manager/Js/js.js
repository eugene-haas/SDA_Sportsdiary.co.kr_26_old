/*! js.js 스포츠 다이어리 어드민 , 2016. 11. 14  */
'use strict';
(function($){
  function Sticky(){
    this._$topNavi = null; /* 대회정보 div */
    this._$btnTopSdr = null; /* 열기 / 접기 버튼 */

    this._$topNaviTp = null; /* 대회정보 상단 div */
    this._$topNaviBtm = null; /* 대회정보 하단 div */
    this._topNaviTpH = -1; /* 대회정보 상단 div 높이 */
    this._topNaviBtmH = -1; /* 대회정보 하단 div 높이 */

    this._topNaviH = -1; /* topNavi 높이값 */
    this._topNaviHNow = -1; /* topNavi 현재 높이값 담을 변수 */

    this._$location = null; /* 현재 위치 표시하는 div */
    this._$locationH = -1; /* location hight */

    this._$window = null; /* window */

    this._init();
    this._evt();
  };

  Sticky.prototype._init = function() {
    this._$topNavi = $('.top-navi');
    this._$btnTopSdr = $('.btn-top-sdr');

    this._$topNaviTp = $('.top-navi-tp');
    this._$topNaviBtm = $('.top-navi-btm');

    this._topNaviH = this._$topNavi.innerHeight();
    this._$location = $('.loaction');
    this._$locationH = this._$location.innerHeight();

    this._$window = $(window);

  };

  Sticky.prototype._evt = function() {
    var that = this;
    // location margin-bottom 처음 로딩
    this._setLocationBot();
    // top-navi 열림, 닫힘 버튼
    this._$btnTopSdr.on('click', function(e){
      that._topNaviH = parseInt(that._$topNavi.css('height'));
      that._topNaviTpH = parseInt(that._$topNaviTp.css('height'));
      that._topNaviBtmH = parseInt(that._$topNaviBtm.css('height'));
     that._setLocationBot();
      e.preventDefault();
    }); // click end

    this._$window.on('scroll', function(){
      // 스크롤 한 부분이 68px 이상일때
      if ($(this).scrollTop() > that._$locationH ) {
        that._naviStickyTop();
      };
      // 스크롤 한 부분이 8px 이하일때
      if ($(this).scrollTop() < that._$locationH ) {
          that._naviStickyResolve();
        };
    });
  };

  Sticky.prototype._setLocationBot = function() {
    // top-navi 접힘 상태
    if (this._topNaviH == this._$topNaviTp.innerHeight()) {
      this._collapseInfo();
    }
    // top-navi 열린 상태
    if (this._topNaviH == (this._$topNaviTp.innerHeight() + this._$topNaviBtm.innerHeight())) {
     this._expandInfo();
    }
  };

  // top-navi 상단에 붙이기
  Sticky.prototype._naviStickyTop = function() {
    this._$topNavi.css({
      'position': 'fixed',
      'top': '0px'
    });
  };

  // top-navi 상단 고정 풀기
   Sticky.prototype._naviStickyResolve = function() {
    this._$topNavi.css({
      'position': 'absolute',
      'top': '48px'
    });
  };

  // location 부분 margin 좁게
  Sticky.prototype._collapseInfo = function() {
    this._$location.css({
      'margin-bottom' : (this._$topNaviTp.innerHeight()) + 20
    });
  };

  // location 부분 margin 넓게
  Sticky.prototype._expandInfo = function() {
    this._$location.css({
      'margin-bottom' : (this._$topNaviTp.innerHeight() + this._$topNaviBtm.innerHeight()) + 20
    });
  };

  $.fn.sticky = function(){
    this.each(function(e){
      var sticky = new Sticky();
    });
    return this;
  }

  // 실행
  $('.top-navi').sticky();
})(jQuery);