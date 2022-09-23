(function($){
  'use strict';

  /**
   * tab menu
   * list = '.tab-list li'
   * --------------------------------
   */
  
  function TabMenu(list, selNum){
    this._$tabList          = null; // li 태그
    this._$tabBtn          = null; // li 태그 안의 a
    this._$tabImg          = null; // a 태그 안의 img

    this._$selected        = null; // 선택될 메뉴 담아둘 변수
    this._imgSrc            = null; // img태그의 변경될 src
    this._selectedImg    = null; // 선택된 이미지

    this._$resultCont     = null; // 대진결과, 결과현황 내용
    this._$tourneyMain  = null; // 대진표 그룹

    this._$onList            = null; // 스코어 보드 한판, 절반, 유효, 지도

    this._init(list);
    this._initEvent();
    // 처음 선택될 탭
    this._setSelectTab(selNum);
  };

  TabMenu.prototype._init = function(list) {
    this._$tabList          = $(list);
    this._$tabBtn          = this._$tabList.find('a');
    this._$tabImg         = this._$tabBtn.find('img');
    this._$resultCont    = $('.result-content').children();
    this._$tourneyMain = $('.tourney-main.tourney-result');
    this._$onList           = $('.player-point li').not('.tgClass');
  };

  TabMenu.prototype._initEvent = function() {
    var that = this;
    this._$tabBtn.on('click', function(e){
      var index = $(this).parent().index();
      // 스코어 보드 > 경기시간 index 조절
      if ($(this).parent('dd').length > 0) {
        index -= 1;
      }

      // 스코어 보드, li에 선수 이름까지 묶여 있어서 별도 관리
      // if ($(this).children().hasClass('score')) {
      //   var index = $(this).parent('li').index()-1;
      // }
      // 클릭된 a 태그 인덱스 넘겨줌
      // 스코어 입력 전광판 묶어줌
      if ($(this).parents('.player-point').index() == 3) {
        index += (that._$onList.length)/2;
      }

      // 결과 조회 팝업창 반칙승, 부전승 선택 처리
      if ($(this).parents('.type-point').index() == 2 ) {
        index += 2;
      }

      // 단체전 입력화면 > 출전선수 등록, 연장경기 추가 버튼
      if ($(this).parents('.top-navi-list').length > 0 ) {
        index = $(this).index();
      }

      that._setSelectTab(index);

      // // 실격승, 반칙승, 부전승
      // if ($(this).filter('.win-type')) {
      //   that._toggleExec($(this).find('.win-type'));
      // }
      e.preventDefault();
    });
  };

  // toggle 기능 구현 
  TabMenu.prototype._toggleExec = function($target) {
    if ($target.hasClass('on')) {
      $target.removeClass('on');
    }
  };

  // 탭메뉴 구현
  TabMenu.prototype._setSelectTab = function(index) {
    if (this._$selected) {
      this._$selected.removeClass('on');
    }
    this._$selected = this._$tabBtn.eq(index);
    this._$selected.addClass('on')

    var selSpan = this._$selected.find('span.tab-img').first();
    
    if (selSpan.length > 0) {
      // 클릭된 a 태그의 img 넘겨줌
      this._changeImg(this._$selected.find('.tab-img img'));
    }

    if (this._$selected.hasClass('result-search-list')) {
      this._showPanelAt(index);
    }

  };

  // 몇번째 패널 보일지 선택 기능
  TabMenu.prototype._showPanelAt  = function(index) {
    this._$resultCont.css({
      'display': 'none'
    });
    this._$resultCont.eq(index).css({
      'display': 'block'
    });

    // '대진결과(result-report)' 가 클릭되면 토너먼트 대진표 보이고
    // 아니면 감추기
    if (this._$resultCont.eq(index).hasClass('result-report')) {
      this._$tourneyMain.css({
        'display': 'none'
      });
    } else {
      this._$tourneyMain.css({
        'display': 'block'
      });
    }
  };

  // 탭메뉴 이미지 src 변경 기능
  TabMenu.prototype._changeImg = function($item) {
    if ($item.parent('on')) {
      if (this._$selectedImg) {
        this._imgSrc = this._$selectedImg.attr('src').replace('-on', '-off');
        this._$selectedImg.attr('src', this._imgSrc);
      }
      this._$selectedImg = $item;
      this._imgSrc = this._$selectedImg.attr('src').replace('-off', '-on');
      this._$selectedImg.attr('src', this._imgSrc);
    }
  };


  $.fn.tabMenu = function(list, selNum){
    this.each(function() {
      var tabMenu = new TabMenu(list, selNum);
    });
    return this;
  };

  // 탭메뉴 실행
  $('.tab-menu').tabMenu('.tab-list li', 0);
  $('.result-tab-menu').tabMenu('.result-tab li', 0);
  $('.score-enter-main .player-point').tabMenu('.player-point li:not(.tgClass)');
  $('.time-table').tabMenu('.time-list dd');
  $('.top-navi-1').tabMenu('.top-navi-btn');
  $('.type-point a').on('click', function(e){
    e.preventDefault();
  });
  $('.modal-body .player-point').on('click', function(e){
    e.preventDefault();
  });



  /**
   * 스킬 그룹 한개씩 선택
   * --------------------------------
   */
   function RadioInput(input){
    this._$input = null;

    this._init(input);
    this._initEvent();
   };

   RadioInput.prototype._init = function(input) {
    this._$input = $(input);
   };

   RadioInput.prototype._initEvent = function() {
    var that = this;
    this._$input.on('click', function(){
      if ($(this).is(':checked') == true) {
        that._$input.parent('label').removeClass('on');
        $(this).parent('label').addClass('on');
        that._$input.not($(this)).attr('checked', false);
      }
    });
   };

   $.fn.radioInput = function(input){
    this.each(function(){
      var radioInput = new RadioInput(input);
    });
    return this;
   };

   // RadioInput 실행
   $('.skill-group').radioInput('.skill-group input'); // ajax 에서 호출
   // 대회통계 >성적조회 > 성적현황 선수명 radio 실행
   $('.who').radioInput('.who-chk');

   $('.group-list-wrap').radioInput('.group-content dt label input');

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
    this._$delBtn = $('.btn-del');
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

  // 리스트 삭제 실행
  $('.btn-del').delList();

  /**
   * --------------------------------
   * toggle 클래스
   * --------------------------------
   */
  function TgClass(tg){
    this._$tg = null;
    this._$selected = null;

    this._init(tg);
    this._evt();
  }

  TgClass.prototype._init = function(tg) {
    this._$tg = $(tg);
  };

  TgClass.prototype._evt = function() {
    var that = this;
    this._$tg.on('click', function(e){
      // 실격승, 반칙승, 부전승
      if ($(this).parents('.player-point').length > 0) {
        // that._toggleExec($(this));
        that._selectTab($(this));
        e.preventDefault();
      }
      // 연장 버튼
      if ($(this).parents('.injury-mark').length > 0) {
        that._toggleExec($(this));
        e.preventDefault();
      }
    });
  };

  // toggle 클래스
  TgClass.prototype._toggleExec = function($this) {
    if ($this.hasClass('on')) {
       $this.removeClass('on');
    } else {
       $this.addClass('on');
    }
  };

  // 탭 기능
  TgClass.prototype._selectTab = function($this) {
    this._$selected = $this;
    if ($this.hasClass('on')) {
      $this.removeClass('on');
      return;
    }
    if (!($this.hasClass('on'))) {
      this._$tg.removeClass('on');
      $this.addClass('on');
      return;
    }
  };

  $.fn.tgClass = function(tg){
    this.each(function(e){
      var tgClass = new TgClass(tg);
    });
    return this;
  }

  $('.injury-mark').tgClass('.injury-mark label');
  $('.score-enter-main').tgClass('.tgClass a');

  
  /**
   * '조회'버튼 클릭시 내용 나오도록
   * 메인 부분 보이기 / 숨기기
   */
  function SearchCont() {
    this._$searchBtn    = null;
    this._$hiddenMain  = null;

    this._init();
    this._initEvent();
  };

  SearchCont.prototype._init = function() {
    this._$searchBtn     = $('.btn-search');
    this._$hiddenMain   = $('.hidden-main');
  };

  SearchCont.prototype._initEvent = function() {
    var that = this;
    this._$searchBtn.one('click', function(e){
      that._showMain();
      e.preventDefault();
    });
  };

  // hiddenMain 보이기 기능
  SearchCont.prototype._showMain = function() {
    this._$hiddenMain.css({'display': 'block'});
  };

  $.fn.searchCont = function(){
    this.each(function(){
      var searchCont = new SearchCont();
    });
    return this;
  };

  $('.hidden-main').searchCont();

  /**
   * --------------------------------
   * tourney 페이지에서 개인전, 단체전 구분
   * - 링크 변경 및
   * - .player-name 위치 변경 (2016-11-07 미사용 결정)
   * --------------------------------
   */
  
  function ChangeType(a){
    this._$menuBtn = null; // 개인전, 단체전 입력하기 버튼
    this._$btnLook   = null;

    this._$enterList = null; // 상단 메뉴 묶음
    this._$enterListBtn = null; // 입력하기 상단 버튼 2개
    this._$privateBtn = null; // 개인전 입력하기 버튼
    this._$searchBtn = null; // '조회' 버튼

    this._$colorGuide = null; // 버튼 색상 안내 select
    this._$guideCont = null; // 개인전 입력 버튼 설명 
    this._$guideGroupCont = null; // 단체전 입력 버튼 설명

    this._$playerInfo = null; // player-name, 간격 조절
    this._$playerSchool = null; // player-school
    this._$gameType = null; // input name="game-type"

    // a 버튼 넘김
    this._init(a);
    this._initEvent();
  };

  ChangeType.prototype._init = function(a) {
    // a 버튼 받음
    this._$menuBtn = $(a);
    this._$btnLook = $('.btn-look');

    this._$enterList = $('.enter-list');
    this._$enterListBtn = this._$enterList.find('li a');
    this._$privateBtn = $('.private-btn');
    this._$searchBtn = $('#search.btn');

    this._$colorGuide = $('.color-guide');
    this._$guideCont = $('.guide-cont');
    this._$guideGroupCont = $('.guide-group-cont');

    this._$playerSchool = $('.player-school');
    this._$gameType = $('input[name="game-type"]');
  };

  ChangeType.prototype._initEvent = function() {
    var that = this;

    this._$menuBtn.on('click', function(e){
      // 'private-btn' 클래스가 있으면 개인전 입력 페이지
      if ($(this).hasClass('private-btn')) {
        that._$btnLook.attr('href', 'enter-score.html');
      }

      // 'group-btn' 클래스가 있으면 단체전 입력 페이지
      if ($(this).hasClass('group-btn')) {
        that._$btnLook.attr('href', 'enter-group.html');
      }
      // 결과 조회하기 링크 연결 해제
      // e.preventDefault();
      // console.log(that._$playerSchool.eq(0).text().length);
      // console.log(that._$gameType.eq(1).is(':checked'));
      // 개인전에 체크되어 있을때
      if (that._$gameType.eq(0).is(':checked')) {
        // 개인전 : 두줄
        // that._$playerInfo = $('.player-info');
        // that._$playerInfo.css({
        //   'padding-top' : '12px'
        // });

        // 색상별 버튼 기능 안내
        that._showGuide();
      }
      // 단체전에 체크되어 있을때
      if (that._$gameType.eq(1).is(':checked')) {
        // 단체전 : 한줄
        // that._$playerInfo = $('.player-info');
        // that._$playerInfo.css({
        //   'padding-top' : '24px'
        // });

        // 색상별 버튼 기능 안내
        that._showGroupGuide();
      }
    });
  };

  ChangeType.prototype._showGuide = function() {
    console.log('개인전');
    this._$colorGuide.css({
      'width' : '370',
      'left' : 'calc(50% - 175px)'
    });
    this._$guideCont.css({
      'display' : 'block'
    });
    this._$guideGroupCont.css({
      'display' : 'none'
    });
  };

  ChangeType.prototype._showGroupGuide = function() {
    console.log('단체전');
    this._$colorGuide.css({
      'width' : '508',
      'left' : 'calc(50% - 254px)'
    });
    this._$guideCont.css({
      'display' : 'none'
    });
    this._$guideGroupCont.css({
      'display' : 'block'
    });
  };

  $.fn.changeType = function(a){
    this.each(function(){
      var changeType = new ChangeType(a);
    });
    return this;
  };

  $('.enter-type').changeType('.btn-list .btn');

   /**
    * 협회코드 띄우기
    * --------------------------------
    */
   function InstituteCode(){
    this._$lineDivA = null;
    this._moveHref = null;
    this._$modalBtn = null;

    this._$btnRepair = null;
    this._$insGroup = null;
    this._$footerBtn = null;
    this._$btnClose = null;
    this._$btnInsConf = null;

    this._init();
    this._initEvent();
   }

   InstituteCode.prototype._init = function() {
    this._$lineDivA = $('.line-div a');
    this._$modalBtn = $('span.skill').parent('a');

    this._$btnRepair = $('.modal-footer').find('.btn.btn-repair');
    this._$insGroup = $('.ins_group');
    this._$footerBtn = $('.modal-footer .btn');
    this._$btnClose = this._$footerBtn.filter('.btn-close');
    this._$btnInsConf = this._$footerBtn.filter('.btn-repair.btn-ins');
   };

   InstituteCode.prototype._initEvent = function() {
     var that = this;

     this._$modalBtn.on('click', function(e){
      that._moveHref = that._$lineDivA.attr('href');
     });
     this._$btnRepair.on('click', function(e){
      $(this).text('확인');
      that._$insGroup.css({
        'display' : 'inline-block'
      });
      if ($(this).hasClass('btn-ins')) {
        $(this).attr('role', '').removeAttr('data-dismiss data-toggle data-target').attr('href', that._moveHref);
        return;
      }
      that._$footerBtn.addClass('btn-ins');
      e.preventDefault();
     });

     this._$btnInsConf.on('click', function(e){
      $(this).attr('role', '').removeAttr('data-dismiss data-toggle data-target').attr('href', 'enter-score.html');
     });


     this._$btnClose.on('click', function(e){
      that._$insGroup.css({
        'display' : 'none'
      });
      that._$footerBtn.removeClass('btn-ins');
      that._$btnRepair.text('수정하기');
      e.preventDefault();
     });
   };

   $.fn.instituteCode = function(){
    this.each(function(e){
      var instituteCode = new InstituteCode();
    });
    return this;
   }

   $('.btn-repair').instituteCode();
   

   /**
    * --------------------------------
    * login 영역 toggleClass
    * --------------------------------
    */
   function ToggleClass() {
      this._$loginBtn = null;

      this._init();
      this._evt();
    };

    ToggleClass.prototype._init = function() {
      this._$loginBtn = $('.login-btn');
    };

    ToggleClass.prototype._evt = function() {
      var that = this;
      this._$loginBtn.on('click', function(e){
        $(this).addClass('login-click');
        that._clearClass($(this));
        e.preventDefault();
      });
    };

    ToggleClass.prototype._clearClass = function($btn) {
      setTimeout(function(){
          $btn.removeClass('login-click');
        }, 500)
    };

    $.fn.toggleClass = function(){
      this.each(function(e){
        var toggleClass = new ToggleClass();
      });
      return this;
    };

    // 실행
    $('.login-btn').toggleClass();

    /**
     * 입력화면 개인전, 중학교, 여자, -52kg 구분
     * target : arrange 클래스
     */
    function ArrangeList(target){
      this._$arrange = null;
      this._$playWeight = null;

      this._init(target);
      this._evt();
    };

    ArrangeList.prototype._init = function(target) {
      this._$arrange = $(target); /* target */
      this._$playWeight = $('.play-weight') /* 체급 */
    };

    ArrangeList.prototype._evt = function() {
      // 개인전 : 개인전, 소속, 남녀구분, 체급 일때
      if (this._$arrange.length === 4) {
        this._$arrange.css({
          'width' : '103px'
        });
      }
      // 단체전 : 개인전, 소속, 남녀구분 일때
      if (this._$arrange.length === 3) {
        this._$arrange.css({
          'width' : '136px'
        });
      }
    };

    $.fn.arrangeList = function(target){
      this.each(function(e){
        var arrangeList = new ArrangeList(target);
      });
      return this;
    };

    // 실행
    $('.selected-list').arrangeList('.arrange');

})(jQuery);