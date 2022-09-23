/**
 * popover template
 * bootstrap 기반 webuipopover 편집
 * https://github.com/sandywalker/webui-popover 참고
 */
;(function($){
  /**
   * S: back-btn-warn 
   */
   var backBtnWarn = {
    title : ['<div class="title clearfix">' +
        // '<a href="#" class="btn-close pop-close" data-dismiss="popover"><span class="ic-close">&times</span></a>' +
        '<span class="icon"><i class="fa fa-exclamation-circle" aria-hidden="true"></i></span>'+
        '<h2>우측 상단의 <span class="strong">X 버튼을 반드시</span> 눌러 주세요!</h2>' +
      '</div>'
        ].join(''),
    content : [
      '<div class="main warn-txt">' +
        '<p>모바일 기기의 뒤로가기 버튼을 누르시면 이전에 입력한 내용은 모두 초기화 됩니다.</p>'+
      '</div>' +
      '<div class="btn-list"><a class="btn btn-close" data-dismiss="warn-back-popove">닫기</a></div>' +
      '<script>' +
      '$(".btn-list .btn-close").on("click", function(e){$(this).parents(".webui-popover").hide();e.preventDefault();});' +
      '</script>'
    ].join(''),
  }

  // 실행
  // $('.btn-popovera').webuiPopover({
  //   title : backBtnWarn.title,
  //   content : backBtnWarn.content,
  //   onShow : function(e){
  //     $('div.main.warn-txt').parents(".webui-popover").addClass("warn-back-popover");
  //   },
  // });

  $('.modal').on('shown.bs.modal', function(e){
      $(this).find('.modal-content').append($('.back-btn-warn'));
      $('.back-btn-warn').show();
      // $('.back-btn-warn a').click();
        WebuiPopovers.show($('.btn-popovera'), {
          title : backBtnWarn.title,
          content : backBtnWarn.content,
          onShow : function(e){
            $('div.main.warn-txt').parents(".webui-popover").addClass("warn-back-popover");
          },
        });
    });
    // $('.btn-popovera').webuiPopover();

  /* E: back-btn-warn */

})(jQuery);