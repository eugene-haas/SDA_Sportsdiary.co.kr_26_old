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

    this._$matchStadium = null; // 경기장

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
    this._$matchStadium = $('.match-stadium');
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
      // 2016. 11  삭제
      // if ($(this).children().hasClass('score')) {
      //   var index = $(this).parent('li').index()-1;
      // }
      // 클릭된 a 태그 인덱스 넘겨줌
      // 스코어 입력 전광판 묶어줌
      if ($(this).parents('.player-point').index() == $(this).parents('.player-point').length+1) {
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

      if ($(this).parents('.gym-tab').length > 0) {
        that._$tabBtn.parents('li').removeClass('on');
        $(this).parents('li').addClass('on');
      }

      // 경기장 현황
      if ($(this).parents('.stadium').length > 0) {
        index = $(this).parents('li').index();
        that._showStadium(index);
        // return;
      }

      if ($(this).parents('.operating-list').length > 0) {

      }

      that._setSelectTab(index);

      // // 실격승, 반칙승, 부전승
      // if ($(this).filter('.win-type')) {
      //   that._toggleExec($(this).find('.win-type'));
      // }
      // e.preventDefault();
    });
  };

  // 경기장 보기
  // idx = a 태그 부모인 li의 인덱스값
  TabMenu.prototype._showStadium = function(idx) {
    var index = (idx -2); // sync 조절
    this._$matchStadium.hide().stop().animate({
      'width' : 1260
    });
    this._$matchStadium.eq(index).show();
    if (index < 0) {
      this._$matchStadium.show().stop().animate({
        'width' : 1100
      });
    }
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
  $('.skill-btn').tabMenu('.tab-list li');
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
  // 대회별 현황
  $('.gym-tab').tabMenu('.gym-tab li');
  // 경기장 현황
  // $('.stadium-board').tabMenu('.stadium-board li');



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
        console.log($(this).is(':checked'));
      } else {
        $(this).parent('label').removeClass('on');
      }
    }); // click end
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
   // enter-score, enter-group 개인전, 단체전 top
   $('.selected-list').radioInput('.selected-list dt p label input');
   $('.player-match-option').radioInput('.player-match-option input');

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
    this._$prevSel = null;
    this._selectedLabel = null;

    this._init(tg);
    this._evt();
  }

  TgClass.prototype._init = function(tg) {
    this._$tg = $(tg);
  };

  TgClass.prototype._evt = function() {
    var that = this;
    this._$tg.on('click', function(e){
      // fixed 클래스 가지면 중단
      if ($(this).parents('.fixed').length > 0) {
        return this;
      }
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
      // 대회별 결과보기 > 수상현황 > 확인 버튼
      if ($(this).parents('.medal-check').length > 0) {
        that._toggleExec($(this));
        that._toggleSelect($(this));
        e.preventDefault();
      };
      if ($(this).parents('.modal').length > 0) {
        $(this).removeClass('on')
      }
    });
  };

  /**
   * _toggleSelect, tr에 컬러 toggle
   * @param  {[string]} $this [클릭한 요소]
   */
  TgClass.prototype._toggleSelect = function($this) {
    this._selectedLabel = $this;
    if (this._selectedLabel.hasClass('on')) {
      this._selectedLabel.parents('tr').addClass('selected');
    }
    if (!(this._selectedLabel.hasClass('on'))) {
      this._selectedLabel.parents('tr').removeClass('selected');
    }
  };

  // toggle 클래스
  TgClass.prototype._toggleExec = function($this) {
    if ($this.hasClass('on')) {
       $this.removeClass('on');
       // $this.find('input').attr('checked', 'checked');
       // $this.find('input').attr('checked', true);
       // console.log($this.find('input').attr('checked'));
       // alert($("#OverTime").is(":checked"));
       // console.log('꺼짐');
    } else {
       $this.addClass('on');
       // $this.find('input').attr('checked', '');
       // $this.find('input').attr('checked', false);
       // console.log($this.find('input').attr('checked'));
       // alert($("#OverTime").is(":checked"));
       // console.log('켜짐');
    }
  };

  // 탭 기능
  TgClass.prototype._selectTab = function($this) {
    if ($this.hasClass('on')) {
      this._$tg.filter('.on').removeClass('on');
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

  // ajax에서 호출
  $('.injury-mark').tgClass('.injury-mark label');
  $('.score-enter-main').tgClass('.tgClass a');
  // 대회별 결과 보기 > 수상현황 > 확인 버튼
  $('.operating-medal').tgClass('.medal-check label');
  // 경기스코어 입력 > 무승부, 부전패
  $('.player-match-option').tgClass('.player-match-option label');

  
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
    // console.log('개인전');
    this._$colorGuide.css({
      'width' : '540',
      // 'left' : 'calc(50% - 175px)'
    });
    this._$guideCont.css({
      'display' : 'block'
    });
    this._$guideGroupCont.css({
      'display' : 'none'
    });
  };

  ChangeType.prototype._showGroupGuide = function() {
    // console.log('단체전');
    this._$colorGuide.css({
      'width' : '508',
      // 'left' : 'calc(50% - 254px)'
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

  // $('.enter-type').changeType('.btn-list .btn');

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
      // if ($(this).hasClass('btn-ins')) {
        $(this).attr('role', '').removeAttr('data-dismiss data-toggle data-target').attr('href', that._moveHref);
        that._$insGroup.css({
          'display' : 'inline-block'
        });
        // return;
      // }
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
    // $('.selected-list').arrangeList('.arrange');


    /**
     * SelectBox, select-box 구현
     */
    function SelectBox(el){
      this._$selectBox        = null; /* select-box 할당 */
      this._$optionValue     = null; /* select의 option 할당 */
      this._$option             = null; /* .option 클래스 */

      this._currentIdx         = -1; /* option에 넘길 index */
      this._selectedEl         = null; /* select 박스 감싸는 .player-point 요소가 담길 프로퍼티 */
      this._firstChr             = '';

      this._document         = null;

      this._init(el);
      this._evt();
    };

    SelectBox.prototype._init = function(el) {
      this._$selectBox = $(el);
      this._$selectBtn = this._$selectBox.parent('.select-btn');
      this._$optionValue = this._$selectBox.find('option');
      this._$option = this._$selectBox.find('.option');
      this._firstChr = this._$option.eq(0).text();
      this._document = $(document);
    };

    SelectBox.prototype._evt = function() {
      var that = this;
      this._$selectBox.on('change', function(){
        if ($(this).find(':selected').index() > 0) {
          this._selectedEl = $(this);
          that._$selectBox.filter('.on').removeClass('on');
          $(this).addClass('on');
        }
        if ($(this).find(':selected').index() < 0) {
          $(this).removeClass('on');
        }
      });
    };

    $.fn.selectBox = function(el){
      this.each(function(){
        var selectBox = new SelectBox(el);
      });
      return this;
    }

    // ajax에서 호출
    $('.select-box').selectBox('.select-box');


    /**
     * DropChange : select 태그 대체하여 bootstrap dropdown 수정
     * @param {[object]} el .dropdown 요소 참조
     */
    function DropChange(el) {
      this._$dropdown = null; /* 찾은 .dropdown */
      this._$dropBtn = null; /* dropdown btn */
      this._$menuBtn = null; /* 메뉴 리스트 */

      this._init(el);
      this._evt();
    };

    DropChange.prototype._init = function(el) {
      this._$dropdown = $(el)
      this._$dropBtn = this._$dropdown.find('.btn');
      this._$menuBtn = this._$dropdown.find('.dropdown-menu a');
    };

    DropChange.prototype._evt = function() {
      var that = this;
      var str;
      this._$menuBtn.on('click', function(){
        str = $(this).text();
        $(this).parents('.dropdown').find('.btn').text(str);
      })
    };

    $.fn.dropChange = function(el){
      this.each(function(e){
        var dropChange = new DropChange(el);
      });
      return this;
    }

    $(document).dropChange('.dropdown');


    /**
     * 대회별 현황보기 종별 버튼 가로 scroll
     * el = .operating-list
     */
    function OperatingList(el){
      this._$el = null; /* operating-list */
      this._$btn = null; /* 버튼 */
      this._btnTotWidth = 0; /* 버튼 전체 width */
      this._btnLastWidth = 0; /* 버튼 마지막 width */

      this._init(el);
      this._evt();
    }

    OperatingList.prototype._init = function(el) {
      this._$el = $(el);
      this._$btn = $('li a', this._$el);
    };

    OperatingList.prototype._evt = function() {
      var that = this;
      this._$btn.each(function(idx, el){
        that._btnTotWidth += ($(el).outerWidth(true)+12)
      });
      this._$el.css({
        'width' : that._btnTotWidth + 50
      })
    };

    $.fn.operatingListScroll = function(el){
      this.each(function(){
        var operatingListScroll = new OperatingList(el);
      });
      return this;
    }

    // $('.operating-list').operatingListScroll('.operating-list');
    
})(jQuery);