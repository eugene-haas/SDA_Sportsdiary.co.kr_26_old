/**
 * --------------------------------
 * 대한 유도회 홈페이지 script
 * --------------------------------
 */
;(function($){
  'use strict'

  /**
   * SnbIndexing : Snb 인덱스 값에 따른 on 처리 (indexing)
   * 페이지 상단 bigN, midN 설정 필수!
   */
  var SnbIndex = {
    _$gnb: null, /* gnb */
    _$gnbBigCate: null, /* 대카테고리 */
    _$gnbBtn: null, /* gnb 버튼 */
    _$pathName: null, /* href 경로 */
    _selCate: null, /* 카테고리 담을 프로퍼티 */

    _$snb: null,
    _$snbBigCate: null,
    _$midCate: null,
    start : function(bigN, midN){
      this._init();
      this._evt(bigN, midN);
    },
    _init: function(){
      this._$gnb = $('#gnbwrap .gnb');
      this._$gnbBigCate = this._$gnb.children();
      this._$gnbBtn = $('li li a', this._$gnb);
      this._pathName = window.location.pathname;

      this._$snb = $('#snb .snb-group');
      this._$snbBigCate = $('.panel-title', this._$snb);
      this._$midCate = $('.snb_sub li', this._$snb);
    },
    _evt: function(bigN, midN){
      this.activeBigCate(bigN, midN);
      this._findBigCate(bigN);
    },
    _findBigCate: function(bigN){
      // 협회정보
      if (this._pathName.match('Info')) {
        this._selCate = this._$gnbBigCate.eq(0);
      }
      // 유도소식
      if (this._pathName.match('News')) {
        this._selCate = this._$gnbBigCate.eq(1);
      }
      // 대회정보
      if (this._pathName.match('Match')) {
        this._selCate = this._$gnbBigCate.eq(2);
      }
      // 팀/선수 정보
      if (this._pathName.match('Player')) {
        this._selCate = this._$gnbBigCate.eq(3);
      }
      // 커뮤니티
      if (this._pathName.match('Community')) {
        this._selCate = this._$gnbBigCate.eq(4);
      }
      // 온라인서비스
      if (this._pathName.match('Online')) {
        this._selCate = this._$gnbBigCate.eq(5);
      }
      this._actGnbBtnOn(this._selCate, bigN);
    },
    _actGnbBtnOn: function(cate, bigN){
      // bigN 미설정시 중지
      if (bigN === undefined) {
        return;
      }

      $(cate).find('.gnb_sub').find('li a').eq(bigN).addClass('on');
    },
    activeBigCate: function(bigN, midN){
      // bigN 미설정시 중지
      if (bigN === undefined) {
        return;
      }

      this._$snbBigCate.eq(bigN).addClass('on');
      this._$snbBigCate.eq(bigN).next('.panel-collapse').addClass('in');
      if (this._$snbBigCate.eq(bigN).children() && !(midN === undefined)) {
        this.activeMidCate(bigN, midN)
      }
    },
    activeMidCate: function(bigN, midN) {
      this._$snbBigCate.eq(bigN).next('.panel-collapse').find('.snb_sub li').eq(midN).addClass('on');
    }
  }

  /**
   * SnbIndexing: Gnb 인덱스 값에 따른 on 처리 (indexing)
   * 페이지 상단 bigN
   */
  var GnbIndex = {
    _$gnb: null, /* gnb */
    _$bigCate: null, /* 대카테고리 */
    _$gnbBtn: null, /* gnb 버튼 */
    _$pathName: null, /* href 경로 */
    _selCate: null, /* 카테고리 담을 프로퍼티 */
    start: function(bigN){
      this._init();
      this._evt(bigN);
    },
    _init: function(){
      this._$gnb = $('#gnbwrap .gnb');
      this._$bigCate = this._$gnb.children();
      this._$gnbBtn = $('li li a', this._$gnb);
      this._pathName = window.location.pathname;
    },
    _evt: function(bigN){
      this._findBigCate(bigN);
    },
    _findBigCate: function(bigN){
      // 협회정보
      if (this._pathName.match('Info')) {
        this._selCate = this._$bigCate.eq(0);
      }
      // 유도소식
      if (this._pathName.match('News')) {
        this._selCate = this._$bigCate.eq(1);
      }
      // 대회정보
      if (this._pathName.match('Match')) {
        this._selCate = this._$bigCate.eq(2);
      }
      // 팀/선수 정보
      if (this._pathName.match('Player')) {
        this._selCate = this._$bigCate.eq(3);
      }
      // 커뮤니티
      if (this._pathName.match('Community')) {
        this._selCate = this._$bigCate.eq(4);
      }
      // 온라인서비스
      if (this._pathName.match('Online')) {
        this._selCate = this._$bigCate.eq(5);
      }
      this._actGnbBtnOn(this._selCate, bigN);
    },
    _actGnbBtnOn: function(cate, bigN){
      // bigN 미설정시 중지
      if (bigN === undefined) {
        return;
      }

      $(cate).find('.gnb_sub').find('li a').eq(bigN).addClass('on');
    }
  }


  /**
   * --------------------------------
   * start 부분 (호출)
   * --------------------------------
   */
  start();

  function start(){
    SnbIndex.start(bigN, midN); // SnbIndexing
    // GnbIndex.start(bigN, midN); // GnbIndexing
  }

})(jQuery);