;(function($){
  function GnbMenu(){
    this._$gnbBtn = null;
    this._$closeBtn = null;
    this._$gnb = null;
    this._$dim = '';

    this._sc = 0;
    this._nx = -1;
    this._position = -1; /* 이전 스크롤 위치 */
    this._nPosition = -1; /* 스크롤 끝난 위치 */
    this._currentPos = -1; /* 현재 스크롤 위치 */

    this._$body = null;
    this._$window = null;
    this._touchStart; /* touch-start */
    this._touchEnd = 0; /* touch-end */

    this._swipeOrigin; /* touch시 원래 위치 담을 프로퍼티 */
    this._x;
    this._setEndX = -1; /* touchend 지점을 담을 프로퍼티 */

    this._remainder = 0;
    this._docH = 0; /* 높이 설정 */

    this._init();
    this._evt();
    this._createDim();
  }

  GnbMenu.prototype._init = function() {
    this._$gnbBtn = $('.hamBtn');
    this._$gnb = $('.gnb');
    this._$closeBtn = this._$gnb.find('.close-btn');
    this._$dim = $('<div class="dim"></div>');
    this._$body = $('body');
    this._$window = $(window);
    this._remainder = this._$window.outerWidth() - this._$gnb.outerWidth();
    this._docH = $(window).innerHeight();
  };

  GnbMenu.prototype._evt = function() {
    var that = this;
    this._$gnbBtn.on('click', function(){
      that._inSightGnb();
    }); // gnb 버튼 클릭
    
    this._$closeBtn.on('click', function(){
      that._outSightGnb();
    }); // close 버튼 클릭
    
    this._$dim.on('click', function(){
      that._outSightGnb();
    }); // dim 영역 클릭

    // 터치 시작 위치 지정
    this._$gnb.on('touchstart', function(e){
      if (e.touches == undefined) {
        return;
      }
      if (e.touches.length == e.changedTouches.length) {
        that._touchStart = {
          x : e.touches[0].clientX,
        }
      }
    }); // touchstart end

    this._$gnb.on('touchmove', function(e){
      if (that._touchStart) {
        if (Math.abs(e.changedTouches[0].clientX - that._touchStart.x)) {
          that._handlingTouch = true;
          e.preventDefault();
          that._swipeStart(e);
        }
        // 터치 시작 위치 초기화
        that._touchStart = undefined;
      } else if (that._handlingTouch) {
          e.preventDefault();
          that._swipeMove(e);
      }
    }); // touchmove end

    this._$gnb.on('touchend', function(e){
      if (that._handlingTouch && e.touches.length == 0) {
        e.preventDefault();
        that._swipeEnd(e);
        that._handlingTouch = false;
      }
    });
  }; // evt end

  GnbMenu.prototype._swipeStart = function(e) {
    this._swipeOrigin = e.touches[0].clientX;
  };

  GnbMenu.prototype._swipeMove = function(e) {
    this._x = e.touches[0].clientX - this._swipeOrigin;
    this._moveGnb(this._x);
  };

  GnbMenu.prototype._swipeEnd = function(e) {
    if (this._x < (this._$gnb.outerWidth() - (this._$window.outerWidth()/1.6))) {
      // 좌측
      this._inSightGnb();
    } else if (this._x >= (this._$gnb.outerWidth() - (this._$window.outerWidth()/1.6))) {
      // 우측
      this._outSightGnb();
    } else {
      // 일반
      this._moveGnb(this._x);
    }
  };

  GnbMenu.prototype._moveGnb = function(x) {
    if (x < 0) {
      x = 0;
    }
    this._$gnb.css({
      'right' : -x,
    });
    this._setEndX = x;
  };

  GnbMenu.prototype._moveGnbAnim = function(x) {
    if (x < 0) {
      x = 0;
    }
    this._$gnb.stop().animate({
      'right' : -x,
    }, 300, 'easeInOutExpo');
    this._setEndX = x;
  };

  // gnb 보이기
  GnbMenu.prototype._inSightGnb = function() {
    this._showGnb();
  };

  // gnb 감추기
  GnbMenu.prototype._outSightGnb = function() {
    this._hideGnb();
  };

  GnbMenu.prototype._createDim = function() {
    if ($('.dim').length < 1) {
      this._$gnb.before(this._$dim);
    }
  };

  GnbMenu.prototype._showGnb = function() {
    this._$gnb.stop().animate({
      'right' : 0
    }, 400, 'easeInOutExpo');
    this._$gnb.css({
      'overflow-y' : 'scroll',
      'height' : this._docH,
    });
    this._showDim();
    this._defenceBody();
  };

  GnbMenu.prototype._showDim = function() {
    this._$dim.css({
      'display' : 'block',
      'height' : $(window).innerHeight()
    });
  };

  GnbMenu.prototype._hideGnb = function() {
    this._$gnb.stop().animate({
      'right' : '-100%'
    }, 400, 'easeInOutExpo');
    this._hideDim();
    this._solveBody();
  };

  GnbMenu.prototype._hideDim = function() {
    // this._$dim.css({
    //   'display' : 'none'
    // });
    this._$dim.hide();
  };

  GnbMenu.prototype._defenceBody = function() {
    var wh = $(window).innerHeight();
    this._$body.addClass('def_scroll').css({
      'position' : 'fixed',
      'overflow' : 'hidden',
      'width' : '100%',
      'height' : wh
    });
    $('html').addClass('def_scroll').css({
      'height' : wh
    });
  };

  GnbMenu.prototype._solveBody = function() {
    this._$body.removeClass('def_scroll').css({
      'position' : 'relative',
      'overflow' : 'auto',
      'width' : 'auto',
      'height' : 'auto',
    });
    $('html').removeClass('def_scroll').css({
      'height' : 'auto'
    });
  };

  $.fn.gnbMenu = function(){
    this.each(function(){
      var gnbMenu = new GnbMenu();
    });
    return this;
  }

  // 실행
  // $('.gnb').gnbMenu();


  /**
   * S: touchSwipe 
   */
  $(function(){
    $('.gnb').swipe({
      swipeStatus : function(event, phase, direction, distance, duration, fingers, fingerData, currentDirection) {
        if (phase == "end") {
          $(this).moveGnbSwipe(currentDirection);
        }
      }
    }) // swipe end

    function MoveGnbSwipe(dir){
      if (dir == "left") {
        this._inSightGnb();
      }
      if (dir == "right") {
        this._outSightGnb();
      }
    }
    MoveGnbSwipe.prototype = new GnbMenu();

    $.fn.moveGnbSwipe = function(dir){
      this.each(function(){
        var moveGnbSwipe = new MoveGnbSwipe(dir);
      });
      return this;
    } // moveGnbSwipe end

  });
  /* E: touchSwipe */

  // function hammerSet($){
  //   var ele = document.getElementById('gnb');

  //   var mc = new Hammer(ele);

  //   mc.on("panleft panright tap press", function(ev) {
  //     $(this).moveGnbSwipe(ev.additionalEvent);
  //   });
  // }

  //   function MoveGnbSwipe(dir) {
  //     var $gnb = $('#gnb');
  //     var that = this;
  //     $gnb.on('touchend', function(e){
  //       if (dir == "panleft") {
  //         that._inSightGnb();
  //       }
  //       if (dir == "panright") {
  //         that._outSightGnb();
  //       }
  //     });
  //   }
  //   MoveGnbSwipe.prototype = new GnbMenu();

  //   $.fn.moveGnbSwipe = function(dir){
  //     this.each(function(){
  //       var moveGnbSwipe = new MoveGnbSwipe(dir);
  //     });
  //     return this;
  //   }

  //   hammerSet($);

})(jQuery);