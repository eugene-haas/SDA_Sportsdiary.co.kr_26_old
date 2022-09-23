<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta charset="utf-8">





	<style>
    div.backLayer {
        display:none;
        background-color:black;
        position:absolute;
        left:0px;
        top:0px;
    }
    div#loadingDiv{
        background-color:skyblue;
        display: none;
        position: absolute;
        width:300px;
        height:300px;
    }
  </style>
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
  <script>
   
    //window onload
     $(document).ready(function(){
        // 배경 조절 버튼 클릭시 클릭 이벤트
        $("#btn1").click(function(){

			var width = $(window).width();
            var height = $(window).height();
             
            //화면을 가리는 레이어의 사이즈 조정
            $(".backLayer").width(width);
            $(".backLayer").height(height);
             
            //화면을 가리는 레이어를 보여준다 (0.5초동안 30%의 농도의 투명도)
            $(".backLayer").fadeTo(500, 0.3);
             
            //팝업 레이어 보이게
            var loadingDivObj = $("#loadingDiv");
            loadingDivObj.css("top", $(document).height()/2-150);
            loadingDivObj.css("left",$(document).width()/2-150);
            loadingDivObj.fadeIn(500);

        });
         
     });
      
     //esc키 누르면 화면 잠김 해제
      $(document).keydown(function(event){
        if(event.which=='27'){
            $("#loadingDiv").fadeOut(300);
            $(".backLayer").fadeOut(1000);
        }
      });
      
     //윈도우가 resize될때마다 backLayer를 조정
     $(window).resize(function(){
        var width = $(window).width();
        var height = $(window).height();
        $(".backLayer").width(width).height(height);
    });
  </script>
</head>
<body>
  <div class='backLayer' style='' > </div>
  <form id="frm">
    <input type="text" class="myClass" id="myClass1"/>
    <div>div1</div>
    <input type="button" id="btn1" value="배경 조절"/>
  </form>


  <div class='backLayer' style='' > </div>
  <div id="loadingDiv">
    숨겨진 레이어 보인다!.
  </div>
</body>
</html>