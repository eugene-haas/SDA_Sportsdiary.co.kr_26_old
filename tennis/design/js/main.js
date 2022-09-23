/**
 * 스포츠 다이어리 종목 메인 기능
 */
;(function($){
  'use strict';


  /**
   * S: 메뉴 indexing 
   */
  var MenuIdx = {
    _idx : null,
    _$menu : null,
    _$menuList: null,
    _init : function(idx) {
      this._idx = idx;
      this._$menu = $('#menu');
      this._$menuList = $('li', this._$menu)
    },
    _evt : function() {
      this._$menuList.removeClass('active');
      this._$menuList.eq(this._idx).addClass('active');
    },
    start : function(idx) {
      this._init(idx);
      this._evt();
    }
  }
  /* E: 메뉴 indexing */


  /**
   * 탭메뉴 이미지 ajax loading
   */
  function TabLoadImg(el){
    this._$tg = null;
    this._$tabBtn = null;
    this._$selectedItem = null; /* 선택된 tab 요소 */
    this._$selectedPanel = null; /* 선택된 panel */

    this._$moduleList = null; /* module list */

    this._init(el);
    this._evt();
    this._selectItemAt(0);
  }

  TabLoadImg.prototype._init = function(el) {
    this._$tg = $(el);
    this._$tabBtn = $('.part_btn a', this._$tg);
    this._$moduleList = $('.module_list');
  };

  TabLoadImg.prototype._evt = function() {
    var that = this;
    this._$tabBtn.on('click', function(){
      that._selectItem($(this));
    });
  };

  TabLoadImg.prototype._selectItemAt = function(idx) {
    var index = this._$tabBtn.eq(idx);
    this._selectItem(index);
  };

  TabLoadImg.prototype._selectItem = function($this) {
    if (this._$selectedItem)
      this._$selectedItem.removeClass('on');

    this._$selectedItem = $this;
    this._$selectedItem.addClass('on');

    var loadIdx = this._$selectedItem.parent().index();
    this._selectPanel(loadIdx);
  };

  /**
   * Panel 선택, 버튼 누를때 버튼의 index에 따라 움직임
   */
  TabLoadImg.prototype._selectPanel = function(idx) {
    this._$moduleList.find('li img').hide();
    this._$moduleList.find('li img').eq(idx).show();
  };

  $.fn.tabLoadImg = function(el){
    this.each(function(){
      var tabLoadImg = new TabLoadImg(el);
    });
    return this;
  }

  /**
   * template 페이지 tab메뉴
   */
  function TabLoadTemp (el) {
    this._$tempTab = null;
    this._$tabBtn = null;
    this._$moduleList = null;

    this._init(el);
    this._evt();
  }

  TabLoadTemp.prototype._init = function(el) {
    this._$tempTab = $(el);
    this._$tabBtn = $('.part_btn > ul > li > a', this._$tempTab);
    this._$moduleList = $('.module_list');
  }

  TabLoadTemp.prototype._evt = function() {
    var that = this;
    this._$tabBtn.on('click', function(){
      that._$tabBtn.removeClass('on');
      $(this).addClass('on');
    });

    this._$tabBtn.eq(0).on('click', function(){
      that._$moduleList.hide();
      that._$moduleList.filter('.temp_1').show();
    })
    this._$tabBtn.eq(1).on('click', function () {
      that._$moduleList.hide();
      $(this).siblings('.sub_part').show();
    });
  }

  $.fn.tabLoadTemp = function (el) {
    this.each(function(){
      var tabLoadTemp = new TabLoadTemp(el);
    });
    return this;
  }


  function start(){
    MenuIdx.start(cateIdx); // 메뉴 인덱싱
    $('.tab.load_img').tabLoadImg('.tab.load_img'); // 탭메뉴 이미지 로딩
    $('.tab.load_temp').tabLoadTemp('.tab.load_temp'); // 탭메뉴 template 로딩
  }

  start();


})(jQuery)
