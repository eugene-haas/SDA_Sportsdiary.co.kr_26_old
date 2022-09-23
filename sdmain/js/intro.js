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

var WholeAgree = {
  _$el: null,
  _$wholeBtn: null,
  _$bindBtn: null,
  _resBtn: [],

  _init: function(el) {
    this._$el = $(el);
    this._$wholeBtn = $('.whole_btn input', this._$el);
    this._$bindBtn = $('.bind_whole input', this._$el);
  },
  _evt: function() {
    var that = this;
    this._$wholeBtn.on('click', function(){
      if ($(this).prop('checked')) {
        that._$bindBtn.prop('checked', true);
        $(this).parents('label').addClass('on');
        that._$bindBtn.parents('label').addClass('on');
      } else {
        that._$bindBtn.prop('checked', false);
        $(this).parents('label').removeClass('on');
        that._$bindBtn.parents('label').removeClass('on');
      }
    });

    this._$bindBtn.on('click', function() {
      that._resBtn = [];
      that._$bindBtn.each(function(){
        if ($(this).is(':checked')) {
          that._resBtn.push($(this));
          $(this).parents('label').addClass('on');
        } else {
          $(this).parents('label').removeClass('on');
        }
        that._$wholeBtn.prop('checked', false);
        that._$wholeBtn.parents('label').removeClass('on');
      });
      if (that._resBtn.length == that._$bindBtn.length) {
        // 전부 선택된 경우
        that._$wholeBtn.prop('checked', true);
        that._$wholeBtn.parents('label').addClass('on');
      }
    }); // click end
  },

  start : function(el) {
    this._init(el);
    this._evt();
  }
}

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
 * 검색어 자동 완성 기능 창 보이기
 * @param {jQuery obj} el user_divn
 */
function AutoSrchList (el) {
  this._$el = null; /* use_divn */
  this._$ctrIpt = null; /* 소속 검색창 */

  this._init(el);
  this._evt();
}

AutoSrchList.prototype._init = function(el) {
  this._$el = $(el);
  this._$ctrIpt = $('.srch_list input', this._$el);
}

AutoSrchList.prototype._evt = function() {
  var that = this;
  this._$ctrIpt.on('keyup', function () {
    if ($(this).val().length > 0) {
      that._showSrchRes($(this));
    } else {
      that._hideSrchRes($(this));
    }
  });
  this._$ctrIpt.on('focusout', function () {
    that._hideSrchRes($(this));
  });
}

AutoSrchList.prototype._showSrchRes = function($this) {
  $this.parent('label').siblings('.srch_res_list').show();
}

AutoSrchList.prototype._hideSrchRes = function($this) {
  $this.parent('label').siblings('.srch_res_list').hide();
}

$.fn.autoSrchList = function (el) {
  this.each(function () {
    var autoSrchList = new AutoSrchList(el);
  });
  return this;
}


/**
 * UserGenderLabel = 남,여 선택 label
 * _$el = user-gender
 */
function UserGenderLabel(el) {
  this._$el = $(el);
  this._$label = null;
  this._$labelIpt = null;

  this._init();
  this._evt();
}

UserGenderLabel.prototype._init = function() {
  this._$label = $("label", this._$el);
  this._$labelIpt = $("input", this._$label);
};

UserGenderLabel.prototype._evt = function() {
  this._$labelIpt.on("click", function(e){
    this._selectIpt($(e.target));
  }.bind(this));
};

UserGenderLabel.prototype._selectIpt = function($this) {
  if ($this.is(":checked")) {
    this._$label.removeClass("on");
    $this.parents("label").addClass("on")
  }
};

$.fn.userGenderLabel = function() {
  this.each(function() {
    var userGenderLabel = new UserGenderLabel(this);
  });
  return this;
}

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

  //통합회원가입 > 이메일
  function emailEvent(){

    var $emailAdress = $("#EmailList");
    var $emailR = $(".email-r");

    // toggleMailInput($EmailAdress);
    $emailAdress.change(function(){
      toggleMailInput($(this));
    })

    function toggleMailInput($this){
      var $findSelect = $this.find('option:selected');

      if(!($findSelect.val() == "userWrite")){
        $emailR.hide();
      }else{
        $emailR.show();
        $emailR.find('input').val('');
      }
    }
  }
  emailEvent();


/**
 * S: 호출 구문 
 */
  WholeAgree.start('.agree'); /* 약관 전체 동의 */
  //WholeAgree.start('.total_guide'); /* 통합 ID 안내 - 페이지에서 호출 */
  //WholeAgree.start('.id_sel'); /* 통합 ID 선택 - 페이지에서 호출 */
  FullHeight.start('.intro_bg'); /* 높이값 기기 높이값에 맞게 조절 */
  IptLabel.start('.input-form'); /* input placeholder 대신 다른 텍스트 활용 */
  IptLabel.start('.input-box'); /* input placeholder 대신 다른 텍스트 활용 */
  // $('.user_divn').autoSrchList('.user_divn'); /* 소속 선택 창 */

  $(".user-gender").userGenderLabel();  /* 통합회원 남, 녀 선택 */
  $(".sdmain-pack").chkSvgAni();   /* 체크 박스 svg 애니메이션 */


/* E: 호출 구문 */
