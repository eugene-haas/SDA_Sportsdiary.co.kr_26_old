/**
 * 경기 진행현황판
 */
;(function($){
  /**
   * S: 진행중 깜빡임 표시 
   */
  function twinkleText(){
    var colors = ['#ffd800', '#000'];
    var $tg = $('.playing');
    var count = 0;
    var textColor = 0;
    setInterval(function(){
      count++;
      (count >= colors.length) ? count=0 : '';
      textColor = (count+1);
      (textColor >= colors.length) ? textColor=0 : '';
      $tg.css({
        'backgroundColor' : colors[count],
        'color' : colors[textColor]
      });
    }, 1000)
  }
  twinkleText();


  /* E: 진행중 깜빡임 표시 */
})(jQuery);