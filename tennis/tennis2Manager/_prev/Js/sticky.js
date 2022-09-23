/*! sticky.js © 스포츠 다이어리 어드민 2016. 11. 24 */
;(function($){
  function Sticky($item){
    this._$window = null; /* window */
    this._$item = null; /* sticky 대상 */
    this._$itemPositionY = -1; /* PositionY 값으로 현재위치 절대값 get */
    this._$itemPositionX = -1; /* PositionX 값으로 현재위치 절대값 get */

    this._init($item);
    this._evt();
  };

  Sticky.prototype._init = function($item) {
    this._$window = $(window);
    this._$item = $($item);
    this._$itemPositionY = this._$item.position().top;
    this._$itemPositionX = this._$item.position().left;
    if (this._$item.hasClass('stickyz')) {
      this._$itemPositionX = parseInt(this._$item.offset().left);
    }
    console.log(this._$itemPositionX);
  };

  Sticky.prototype._evt = function() {
    var that = this;
    this._$window.on('scroll', function(){
      // sticky 대상 보다 스크롤 영역이 커질 경우
       if (that._$window.scrollTop() > that._$itemPositionY) {
        that._$item.css({
          'position' : 'fixed',
          'top' : '0px',
          'left' : that._$itemPositionX
        });
      }
      // sticky 대상 보다 스크롤 영역이 작아질 경우
      if (that._$window.scrollTop() < that._$itemPositionY) {
        that._$item.css({
          'position': 'static',
        });
      } // if end
    });
  };

  $.fn.sticky = function($item){
    this.each(function(e){
      var sticky = new Sticky($item);
    });
    return this;
  }

  // 실행
  $('.sticky').sticky('.sticky');
  $('.stickyz').sticky('.stickyz');
})(jQuery);