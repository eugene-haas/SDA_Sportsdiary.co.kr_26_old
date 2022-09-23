;(function($){
  /**
   * radio 버튼
   */
  function ReEditRadio(){
    this._$btnList = null; /* radio 버튼들 묶음 */
    this._$btn = null; /* radio 버튼들 */

    this._btnIdx = -1; /* 선택된 버튼의 index */
    this._selected = null; /* 선택된 버튼 담을 프로퍼티 */

    this._init();
    this._evt();
  };

  ReEditRadio.prototype._init = function() {
    this._$btnList = $('.radio_list');
    this._$btn = $('.btn', this._$btnList);
    this._$input = $('input', this._$btn);
  };

  ReEditRadio.prototype._evt = function() {
    var that = this;
    this._$btn.unbind().on('click', function(e){
      that._selectTab($(this));
    });
  };

  ReEditRadio.prototype._selectTab = function(tg){
    this._selected = tg;
    this._selected.addClass('on').siblings('.btn').removeClass('on');
  }

  $.fn.reEditRadio = function(el){
    this.each(function(){
      var reEditRadio = new ReEditRadio(el);
    });
    return this;
  }

  /**
   * 참가팀 추가등록
   * tg = entry_list
   */
  function AddTeam(tg){
    this._$tg = null;
    this._$addBtn = null; /* 참가팀 추가 등록 버튼 */
    this._$delBtn = null; /* 참가팀 삭제 버튼 */
    this._$entry = null; /* 고정된 참가자 field */
    this._$numBox = null; /* entry의 number */

    this._$party = null; /* party : 참가자, 파트너 구분 */
    this._$type = null; /* 성별 구분 영역 */
    this._$typeBtn = null; /* 성별 구분 버튼 */

    this._currentEntry = 1; /* 현재 entry 갯수 담을 프로퍼티, 최소 1 */
    this._$copiedEntry = null; /* 복사된 entry */

    this._clubID = []; /* 소속에 input에 저장된 id */
    this._autoSrchID = []; /* 자동검색 표시 창에 저장된 id */
    this._typeRadioID = []; /* 성별에 input에 저장된 id */

    this._editable = true; /* 소속, 성별 등에 편집 여부 컨트롤 */

    this._init(tg);
    this._evt();
  }

  AddTeam.prototype._init = function(tg) {
    this._$tg = $(tg);
    this._$addBtn = $('.add_party');
    this._$delBtn = $('.btn_party_del', this._$tg);
    this._$entry = $('.entry', this._$tg);
    this._$numBox = $('.num-box', this._$tg);
    this._$party = $('.party', this._$entry);
    this._$type = $('.type', this._$entry);
    this._$typeBtn = $('.btn', this._$type);
  };

  AddTeam.prototype._evt = function() {
    var that = this;
    // 참가팀 추가 클릭
    this._$addBtn.on('click', function(e){
      that._addList();
      e.preventDefault();
    });

    // 참가팀 삭제 클릭
    this._$delBtn.on('click', function(e){
      var userCfm = confirm('참가자를 삭제 할까요?');
      if (userCfm == true) {
        that._removeList($(this));
      }
      e.preventDefault();
    });

    // 성별 버튼 클릭
    this._$typeBtn.on('click', function(){
      var $p1GdIdx = $(this).parents('.entry').find('.p1_gender_idx');
      var $p2GdIdx = $(this).parents('.entry').find('.p2_gender_idx');

      switch ($(this).parents('.party').index()) {
        case 0 :
          // 참가자 성별
          that._printGenderValue($(this).find('input').val(), $p1GdIdx);
          break;
        case 1 :
          // 파트너 성별
          that._printGenderValue($(this).find('input').val(), $p2GdIdx);
          break;
        default :
          console.log('잘못된 입력 입니다.');
      }
    });

    this._saveInputId(this._$entry); // id, name 저장
    this._arrEntry(this._$entry); // entry 초기화
    // this._initGender(this._$entry); // 초기 성별 checked 값 표시
  };

  // 참가팀 추가하기
  AddTeam.prototype._addList = function() {
    this._$entry = $('.entry');
    var checkIpt = null;
    checkIpt = this._$entry.find('.gender').find('input').filter(':checked');

    this._$entry.last().clone(true).appendTo(this._$tg); // 복사
    checkIpt.attr('checked', 'checked');
    this._$copiedEntry = $('.entry').last(); // 복사된 entry 담기
    this._initEntry(this._$copiedEntry); // 복사한 entry 초기화
    this._arrEntry(this._$copiedEntry); // 복사한 entry 소속, 성별
    this._arrangeNum(); // 번호 상자 numbering
    this._$typeBtn = this._$entry.find('.type .btn');
  };

  // act = 삭제 버튼
  AddTeam.prototype._removeList = function(act) {
    if ($('.entry').length <= 1) {
      alert('마지막 참가자 영역은 삭제할 수 없습니다.');
    }
    if ($('.entry').length > 1) {
      act.parents('.entry').detach().remove();
      this._arrEntry($('.entry'));
    }
    this._arrangeNum();
  };

  AddTeam.prototype._arrangeNum = function() {
    this._currentEntry = $('.entry');
    this._currentEntry.each(function(i){
      $(this).find('.num-box').text(i+1);
      $(this).find('.type input').attr('id');
    })
  };

  // input의 id 값 배열로 담기
  AddTeam.prototype._saveInputId = function($entry) {
    var that = this;
    // 성별 input의 id 값 저장
    $entry.find('.type input').each(function(){
      that._typeRadioID.push($(this).attr('id'));
    });
    // 소속 input의 id 값 저장
    $entry.find('.club input').each(function(){
      that._clubID.push($(this).attr('id'));
    });
    // 소속 자동검색의 id 값 저장
    $entry.find('.auto_srch').each(function(i){
      that._autoSrchID.push($(this).attr('id'));
    });
  };

  // entry 초기화
  AddTeam.prototype._initEntry = function($entry) {
    $entry.find('.header label > input').prop('checked', ''); // 신청자 정보와 동일 리셋
    $entry.find('input[type="hidden"]').val(''); // 대회 신청 목록 (수정 페이지)에서 input hidden 리셋
    $entry.find('input.p1_gender_idx, input.p2_gender_idx').val(''); // input hidden 성별 리셋
    $entry.find('.type input').each(function(){
      $(this).removeAttr('checked');
    }); // 성별 checked 리셋
    $entry.find('li').not('.gender').find('input').val(''); // 성별 리셋
    $entry.find('.auto_srch').removeClass('on'); // 잠동 검색 펼침 리셋
    $entry.find('.gender label.btn').removeClass('on').removeAttr('checked'); // 성별 리셋
  };

  // entry 초기화 및 id, name 편집
  AddTeam.prototype._arrEntry = function($entry) {
    var that = this;
    // 성별 id, name 값 재정렬
    $entry.find('.type input').each(function(index, el) {
      $(el).attr('id', that._typeRadioID[index]+'_'+($(this).parents('.entry').index()+1));
      $(el).attr('name', that._typeRadioID[index]+'_'+($(this).parents('.entry').index()+1));
    });

    // 소속 id, name 값 재정렬
    $entry.find('.club input').each(function(index, el) {
      $(el).attr('id', that._clubID[index]+'_'+($(this).parents('.entry').index()+1));
      $(el).attr('name', that._clubID[index]+'_'+($(this).parents('.entry').index()+1));
    });

    // 소속 자동 검색창 id 값 재정렬
    $entry.find('.auto_srch').each(function(index, el){
      $(el).attr('id', that._autoSrchID[index]+ '_' + ($(this).parents('.entry').index()+1));
    });
  };

  AddTeam.prototype._printGenderValue = function(val, $input){
    $input.val(val);
  }

  $.fn.addTeam = function(tg){
    this.each(function(){
      var addTeam = new AddTeam(tg);
    });
    return this;
  }


  /**
   * S: auto_srch - 포커스 이동 및 text 변경
   */
  function AutoSrchMove(){
    this._$entryList = null; /* entry_list 참가자 정보 */
    this._$autoSrch = null; /* 자동 검색 내용 나올 부분 */
    this._$autoSrchOn = null; /* 자동 검색 내용 나온 부분만 */
    this._$iptSrch = null; /* 소속 입력 input */
    this._$autoSrchItem = null; /* 검색해서 나온 목록들 */

    this._$window = null; /* window */
    this._winH = -1; /* window 스크롤 위치 담을 프로퍼티 */

    this._init();
    this._evt();
  }

  AutoSrchMove.prototype._init = function() {
    this._$entryList = $('.entry_list');
    this._$autoSrch = $('.auto_srch', this._$entryList);
    this._$iptSrch = this._$autoSrch.prev('input');
  };

  AutoSrchMove.prototype._evt = function() {
    var that = this;

    // 자동 검색창에서 downkey
    this._$iptSrch.on('click', function(e){
      console.log(e.keyCode);
    })

    // 자동 검색창 안에서 keyup
    this._$autoSrch.find('li a').on('keyup', function(e){
      that._controlKdb(e.keyCode, $(this));
      e.preventDefault();
    });

    // 자동 검색창 안에서 click
    this._$autoSrch.find('li a').on('click', function(e){
      that._selectSrchItem($(this).parents('.auto_srch'), $(this));
      e.preventDefault();
    });

    // 자동 검색될 input 안에서의 keyup
    this._$iptSrch.unbind().on('keyup', function(e){
      // 소속 검색 input 을 통해 검색 결과가 없을경우
      if ($(this).next('.auto_srch').children().length == 0) {
        that._hideAutoSrch($(this));
      }
      // 소속 검색 글자가 1글자 이상
      if ($(this).val().length > 0) {
        // 자동 검색 내용 1개 이상
        if ($(this).next('.auto_srch').children().length >= 1) {
          // 자동 검색 내용 열림
          that._showAutoSrch($(this));
          if (e.keyCode == 40) {
            that._moveFocusSrch($(this));
          }
        }
      }
      // that._moveIptSrch(e, e.keyCode, $(this));
      e.preventDefault();
    });

    // 소속 검색 input 창 focusin
    this._$iptSrch.on('focusin', function(){
      // 소속 검색창에 1글자 이상
      if ($(this).val().length > 0) {
        // 자동 검색리스트에 1개 이상이면 show
        if ($(this).next('.auto_srch').children().length > 0) {
          that._showAutoSrch($(this));
        }
      }
    });

    // 검색된 마지막 list 에서 tab 했을 경우
    this._$autoSrch.find('li:last-child a').on('keydown', function(e){
      if (e.keyCode == 9) {
        that._hideAutoSrch($(this).parents('.auto_srch').prev('input'));
      }
    });

    // 자동 검색창 focusout
    /*this._$iptSrch.on('focusout', function(e){

      // that._hideAutoSrch($(this));
    });*/
    $('body').on('click', function(){
      $('.auto_srch').filter('.on').removeClass('on');
    })
  };

  /**
   * _controlKdb
   * 키보드 코드값에 따른 auto_srch list의 focus 이동
   */
  AutoSrchMove.prototype._controlKdb = function(k, $this) {
    // k = keyCode
    // 키보드 코드 참조 (Keyboard codes reference)
    // Left arrow  37
    // Up arrow  38
    // a          65
    // w          87
    // 4 (numpad)  100
    // 8 (numpad)  104
    if (k == 37 || k == 38) {
      this._srchFocusUp($this);
    }
    
    // 키보드 코드 참조 (Keyboard codes reference)
    // Right arrow  39
    // Down arrow  40
    // d          68
    // s          83
    // 2 (numpad)  98
    // 5 (numpad)  101
    // 6 (numpad)  102
    if (k == 39 || k == 40) {
      this._srchFocusDown($this);
    }
  };

  // auto_srch 포커스 위
  AutoSrchMove.prototype._srchFocusUp = function($this) {
    $this.parent('li').prev().find('a').focus();
    if ($this.parent('li').index() == 0) {
      $this.parents('.auto_srch').prev('input').focus();
    }
  };

  // auto_srch 포커스 아래
  AutoSrchMove.prototype._srchFocusDown = function($this) {
    $this.parent('li').next().find('a').focus();
  };

  /**
   * _moveFocusSrch
   * auto_srch list의 첫번째로 포커스 이동
   */
  AutoSrchMove.prototype._moveFocusSrch = function($this) {
    // Key  Keyboard code
    // Down arrow  40
    if ($this.parents('.show_srch').length == 0) {
      $this.next('.auto_srch').find('li').eq(0).find('a').focus();
    }
    $this.parents('.show_srch').find('.auto_srch li').eq(0).find('a').focus();
  };

  /**
   * _hideAutoSrch
   */
  AutoSrchMove.prototype._hideAutoSrch = function($this) {
    $this.next('.auto_srch').removeClass('on');
  };

  /**
   * auto_srch 열기
   * $this = 소속 검색 input
   */
  AutoSrchMove.prototype._showAutoSrch = function($this) {
    $this.next('.auto_srch').addClass('on');
    this._$autoSrchOn = $this.next('.auto_srch');
    this._selectSrchItem(this._$autoSrchOn);
  };

  /**
   * _selectSrchItem 자동 검색 해서 나온 리스트 선택(클릭)시 바꿔주기
   * $srchOn = $('.auto_srch.on')
   * $this = 자동 검색 list중 클릭한 a 요소의 text
   */
  AutoSrchMove.prototype._selectSrchItem = function($srchOn, $this) {
    // var that = this;
    // this._$autoSrchItem = $srchOn.find('li a');
    if ($this) {
      this._changeIptWord($this, $this.text())
    }

    // this._$autoSrchItem.on('click', function(e){
    //   that._changeIptWord($(this), $(this).text());
    //   e.preventDefault();
    // })
  };

  /**
   * _changeIptWord
   * $this = 클릭한 a 태그
   * txt = 클릭한 a 태그의 text()
   */
  AutoSrchMove.prototype._changeIptWord = function($this, txt) {
    $this.parents('.auto_srch').prev('input').val(txt);
    $this.parents('.auto_srch').removeClass('on');
  };

  $.fn.autoSrchMove = function(){
    this.each(function(){
      var autoSrchMove = new AutoSrchMove();
    });
    return this;
  }
  /* E: auto_srch 포커스 이동 */

  /**
   * 실행 구문
   */
  function start(){
    $('.form_cont').reEditRadio(); // radio 버튼
    $('.entry_list').addTeam('.entry_list'); // 참가팀 추가 등록 
    // $('.entry_list').autoSrchMove(); /* 자동 검색 - ajax */
    console.log($('.form_cont li input'));
  }

  start();
})(jQuery);