;(function($){
  'use strict';

  /**
   * 높이값 기기 height full
   */
  var FullHeight = {
    _$tg : null,
    _$body: null,
    _$docH: -1,

    start: function (tg) {
      this._init(tg);
      this._evt();
    },
    _init: function(tg){
      this._$tg = $(tg);
      this._$body = $(document);
    },
    _evt: function(){
      this.docH();
      this.setHeight();
    },
    setHeight : function (tg) {
      this._$tg.css('height', this._$docH)
    },
    docH : function(){
      this._$docH = this._$body.outerHeight();
    },
  }

  FullHeight.start('.intro_bg');
})(jQuery);


	