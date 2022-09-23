<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <meta name="Generator" content="EditPlus®">
  <title>Document</title>

<style type="text/css">
#swipezone{
  width: 100%;
  height: 100vh;
  text-align: center;
  background: #000;
  color: #fff;
  cursor: pointer;
  font-size: 30px;
}	
</style>


 
 </head>
 <body >

<div id="swipezone">
  Swipe me
</div>









<script>
window.addEventListener('touchstart', function(event) {
    var touch = event.touches[0];
    touchstartX = touch.clientX;
    touchstartY = touch.clientY;
}, false);
window.addEventListener('touchend', function(event) {
    if(event.touches.length == 0) {
        var touch = event.changedTouches[event.changedTouches.length - 1];
        touchendX = touch.clientX;
        touchendY = touch.clientY;
        touchoffsetX = touchendX - touchstartX;
        touchoffsetY = touchendY - touchstartY;
        if(Math.abs(touchoffsetX) >= 100 && Math.abs(touchoffsetY) <= 30) {
            if(touchoffsetX < 0)
                alert("swipe left");
            else
                alert("swipe right");
        }
    }
}, false);
</script>
 </body>

</html>

