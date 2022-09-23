

$(function(){
  // 배너 이미지 슬라이더 트리거
  var $bxSlider = $('.bxslider:not(.modal-dialog .bxslider)');
  $bxSlider.each(function(index,element){
    var slider = $(element).bxSlider({
      pager: false,
      auto: true,
      pause: 3000,
      width: "auto",
      control:true,
      onSlideAfter: function() {
          slider.stopAuto();
          slider.startAuto();
      }
    });
  });
  
})
