(function($){
  'use strict';

  /**
   * left-navi 활성화
   */
  var ActiveLeftNavi = {
    start: function(){
      this._$leftNavi = null; /* left-Navi 담을 프로퍼티 */
      this._$menu = null; /* 메뉴들 담은 a태그 */
      this._$menuBtn = []; /* leftNavi 메뉴들 중 onclick */

      this._nowLocation = ""; /* 현재 경로 */
      this._$nowActive = null; /* 활성화된 버튼 */

      this._locationStr = "";

      this._init();
      this._evt();
    },
    _init: function(){
      var that = this;
      this._$leftNavi = $('#left-navi');
      this._$menu = $('a', this._$leftNavi);

      this._$menu.each(function(){
        if(this.hasAttribute('onclick')){
          // this._$menu 중에 onclick이 있는 a 태그만 선별
          that._$menuBtn.push(this);
        }
      }); // each end

      this._nowLocation = window.location.pathname;

      for (var i = 0; i < this._$menuBtn.length; i++) {
        if (this._$menuBtn[i].onclick.toString().match(this._nowLocation) != null) {
          this._$nowActive = $(this._$menuBtn[i]);
        }
      }

      if (locationStr) {
        this._locationStr = locationStr;
      } else {
        this._locationStr = "";
        return
      }

    }, // init end
    _evt: function(){
      if (this._$nowActive) {
        this._$nowActive.addClass('active');
      } else {
        for (var i = 0; i < this._$menuBtn.length; i ++) {
          if (this._$menuBtn[i].onclick.toString().match(locationStr)) {
            this._$nowActive = $(this._$menuBtn[i]);
            this._$nowActive.addClass('active');
          } // if end
        } // for end
      } // if end
    },
    _chkMenuActive: function () { // bigCate, midCate, lowCate 활용,
      // locationStr 로 변경.
      // 필요시 재 설정하여 활용
      var $bigCateDepth = $('.depth', this._$leftNavi).eq(bigCate);
      var $midCateDepth = $('.depth-2 > li', $bigCateDepth).eq(midCate);
      var $lowCateDepth = $('.depth-3 > li', $midCateDepth).eq(lowCate);
      $lowCateDepth.children('a').addClass('active');
    }

  }

  function goBackBtn(){
    var $backBtn = $('.page_title .btn-back');
    $backBtn.click(function(){
      history.back(1);
    })
  }

  /**
   * 그외 판정결과 선택
   * el = .etc-judge
   */
  function SelJudge(el) {
    this._$el = null; /* etc-judge */
    this._$selList = null; /* sel-list */
    this._$selListBtn = null; /* sel-list 내 .btn */

    this._$selected = null; /* 선택된 버튼 담을 프로퍼티 */

    this._init(el);
    this._evt();
  }

  SelJudge.prototype._init = function(el) {
    this._$el = $(el);
    this._$selList = $(".sel-list");
    this._$selListBtn = $(".btn-judge", this._$selList);
  }

  SelJudge.prototype._evt = function() {
    var that = this;
    this._$selListBtn.on("click", function(){
      that._selecteBtn($(this));
    });
  }

  /**
   * $this = 선택한 버튼
   */
  SelJudge.prototype._selecteBtn = function($this) {
    $this.parent("li").siblings("li").find(".btn").removeClass("on");
    $this.addClass("on");
  };

  $.fn.selJudge = function(el){
    this.each(function(){
      var selJudge = new SelJudge(el);
    });
    return this;
  }


  function start() {
    ActiveLeftNavi.start();
    // goBackBtn(); // 상세에서 뒤로가기 버튼
    $(".etc-judge").selJudge(".etc-judge"); // 그외 판정 선택 버튼
  }

  start();
  
})(jQuery);