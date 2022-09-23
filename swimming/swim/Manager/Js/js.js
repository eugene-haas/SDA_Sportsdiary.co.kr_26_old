/*! js.js 스포츠 다이어리 어드민 , 2016. 11. 14  */
'use strict';
(function($){
  /**
   * table row 클릭 되도록
   */
  $(document).ready(function(){
    if ($('tr').find('a').length > 0) {
      $('tr').click(function(){
        window.location = $(this).find('a').attr('href');
      }).hover(function(){
        $(this).toggleClass('hover');
      }) // click, hover end
    } // if end
  });

  /**
  * left-navi height 값 조절
  * tg = nav 태그
  */
  function NaviHArr(tg){
    this._$tg = null;
    this._$leftNavi = null; /* left-navi */
    this._$scrollBox = null; /* scroll-box */
    this._$depth = null; /* depth 들 */

    this._depthH = -1; /* depth 높이 담을 프로퍼티 */
    this._sc = 0;
    this._bodyHeight = -1; /* body 높이 담을 프로퍼티 */
    this._leftNaviPosY = -1; /* leftNavi position y */

    this._init(tg);
    this._evt();
  }

  NaviHArr.prototype._init = function(tg) {
    this._$tg = $(tg);
    this._$leftNavi = $('#left-navi', this._$tg);
    this._$scrollBox = $('.scroll-box', this._$tg);
    this._$depth = $('.depth', this._$scrollBox);
    this._bodyHeight = $('body').outerHeight(true);
    this._leftNaviPosY = this._$leftNavi.offset().top;
  };

  NaviHArr.prototype._evt = function() {
    var that = this;
    var lnbPos = this._bodyHeight - this._leftNaviPosY;
    this._keepDepthH(); // depth 높이값 할당
    this._putDepthH(this._depthH); // depth 높이값 scrollBox에 대입
    this._putDocH(lnbPos); // document 높이값 - leftNavi top leftNavi에 대입
  };

  // depth 높이값 저장
  NaviHArr.prototype._keepDepthH = function() {
    var that = this;
    this._$depth.each(function(){
      that._depthH += $(this).outerHeight(true);
    });
    this._$bodyH = $(document).outerHeight(true);
  };

  // depth 높이값 대입
  NaviHArr.prototype._putDepthH = function(h) {
    this._$scrollBox.css('height', (h + 100));
  };

  // document 높이값 대입
  NaviHArr.prototype._putDocH = function(h) {
    this._$leftNavi.css('height', h);
  };

  $.fn.naviHArr = function(tg){
    this.each(function(){
      var naviHArr = new NaviHArr(tg);
    });
    return this;
  }

  /**
   * 관리자 리스트 collapse
   */
  function TopNaviCollapse(el){
    this._$el = null;
    this._$closeBtn = null;

    this._init(el);
    this._evt();
  }

  TopNaviCollapse.prototype._init = function(el) {
    this._$el = $(el);
    this._$closeBtn = $('.btn-top-sdr', this._$el);
  };

  TopNaviCollapse.prototype._evt = function() {
    var that = this;
    this._$closeBtn.on('click', function(e){
      clsBtnToggle.toggleFrm($(this));
      e.preventDefault();
    })
  };

  var clsBtnToggle = {
    toggleFrm : function($btn){
      this._$colTg = $('.col-tg'); /* 접혀질 form */

      this._toggleClass($btn);
    },
    _toggleClass : function($btn) {
      if ($btn.length == 0) {
        return;
      } // if end
      if ($btn.hasClass('close')) {
        $btn.removeClass('close').addClass('open');
        this._$colTg.stop().slideUp();
        return;
      } // if end
      if ($btn.hasClass('open')) {
        $btn.removeClass('open').addClass('close');
        this._$colTg.stop().slideDown();
        return;
      } // if end
    },
  }

  $.fn.topNaviCollapse = function(el){
    this.each(function(){
      var topNaviCollapse = new TopNaviCollapse(el);
    });
    return this;
  }

  // 실행
  $(document).ready(function(){
    $('.top-navi').topNaviCollapse('.top-navi');
    $('nav').naviHArr('nav'); // navi 높이 조절
  });
})(jQuery);