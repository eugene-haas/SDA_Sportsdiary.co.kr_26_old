/*! sticky.js © 스포츠 다이어리 어드민 2016. 11. 24 */
;(function($){
  'use strict';
  function Sticky(item){
    this._$window = null; /* window */
    this._$item = null; /* sticky 대상 */
    this._$itemPositionY = -1; /* PositionY 값으로 현재위치 절대값 get */
    this._$itemPositionX = -1; /* PositionX 값으로 현재위치 절대값 get */

    this._init(item);
    this._evt();

    /**
     * sticky item 기본 옵션 설정
     */
    $.stickyOption = {
      _$item: $(item),
      _posY: this._$item.offset().top,
      _posX: this._$item.offset().left,
      _itemW : this._$item.outerWidth(true)
    }
  };

  Sticky.prototype._init = function(item) {
    this._$window = $(window);
    this._$item = $(item);
    this._$itemPositionY = this._$item.offset().top;
    this._$itemPositionX = this._$item.offset().left;
    this._$itemWidth = this._$item.outerWidth(true);
  };

  Sticky.prototype._evt = function() {
    var that = this;
    this._$window.on('scroll', function(){
      // sticky 대상 보다 스크롤 영역이 커질 경우
       if (that._$window.scrollTop() > that._$itemPositionY) {
        stickyTop.sticky($.stickyOption);
      }
      // sticky 대상 보다 스크롤 영역이 작아질 경우
      if (that._$window.scrollTop() < that._$itemPositionY) {
        solveTop.sticky($.stickyOption);
      } // if end
    });
  };

  // stickyTop 고정
  var stickyTop = {
    sticky : function(opt){
      opt._$item.css({
        'position' : 'fixed',
        'top' : '70px',
        'left' : opt._itemX,
        'width' : opt._itemW
      })
    }
  }

  // stickyTop 풀기
  var solveTop = {
    sticky: function(opt){
      opt._$item.css({
        'position' : 'static'
      });
    }
  }

  $.fn.sticky = function(item){
    this.each(function(e){
      var sticky = new Sticky(item);
    });
    return this;
  }

  // 실행
  $(document).ready(function(){
    $('.sticky').sticky('.sticky'); // 스티키 메뉴
  });
})(jQuery);