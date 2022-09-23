/**
 * popover template
 * bootstrap 기반 webuipopover r 편집
 * https://github.com/sandywalker/webui-popover 참고
 */
;(function($){
  'use strict';

  if ($('.btn-popover').length <= 0) {
    return;
  }

  var template = ['<div class="webui-popover">' +
      '<div class="webui-arrow"></div>' +
      '<div class="webui-popover-inner">' +
        '<h3 class="webui-popover-title"></h3>' +
      '</div>' +
    '</div>'
  ].join('');

  /**
   * 훈련 삭제 popover
   */
  var trainDel = {
    template : ['<div class="webui-popover train-del">' +
        '<div class="webui-arrow"></div>' +
        '<div class="webui-popover-inner">' +
          '<h3 class="webui-popover-title"></h3>' +
          '<div class="webui-popover-content></div>' +
        '</div>' +
      '</div>'
    ].join(''),
    title : ['<div class="train-del-title clearfix"><a href="#" class="btn-close pop-close" data-dismiss="popover"><span class="ic-close">&times</span></a></div>'].join(''),
    content : [
        '<p>훈련종류를 삭제하시겠습니까?</p>' +
        '<div class="btn-list train-del-confirm">' +
          '<a class="btn btn-grayline pop-close">취소</a>'+
          '<a class="btn btn-basic del-confirm" id="del-confirm">완료</a>'+
        '</div>' +
        '<script>' +
          '$(".pop-close").on("click", function(e){$(this).parents(".webui-popover").hide();e.preventDefault();});' +
          '$(".webui-popover").on("shown.bs.popover", function(){alert("나왔다!")});' +
          // '$(".btn-train-del").on("click", function(e){overValue()})' +
        '</script>'
    ].join(''),
  }



  // 실행
  $('.btn-popover.id_change').webuiPopover();
  /* 훈련 삭제 popover */

})(jQuery);