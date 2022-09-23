var apploading = function(obj, str){
  $("#" + obj).oLoader({
  backgroundColor:'#fff',
  //image: 'images/ownageLoader/loader1.gif',
  style: "<div id='DP_Loading' style='position:absolute;top:200px;background:#000;color:#fff;padding:20px;border-radius:4px; width:350px; margin:0 auto; text-align:center;'>"+str+"<br><br><img src='../../imgs/ownageLoader/loader1.gif'></div>",
  fadeInTime: 100,
  fadeOutTime: 100,
  fadeLevel: 0.5
  });			
  
  var width_window = ($(window).width() / 2) - 200;

  $("#DP_Loading").css("left", width_window);

}  

$(document).ajaxStart(function() {

  
  apploading("DP_BODY", "조회 중 입니다.");


});
$(document).ajaxStop(function() {

      
  $('#DP_BODY').oLoader('hide');

});
           