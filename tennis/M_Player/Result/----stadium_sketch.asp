<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
GameTitleIDX = fInject(request("GameTitleIDX")) 
%>
<script src="../js/library/jquery-1.12.2.min.js"></script>
<script src="../js/library/jquery.easing.1.3.min.js"></script>
<script>

var totalidx_1 = 1;
var totalidx_2 = 1;
var totalidx_3 = 5;
var totalidx_4 = 5;

$(window).scroll(function(){
  if  ($(window).scrollTop() == $(document).height() - $(window).height()){


    if($("#TeamGb").val() == "1"){
      //$("#DP_ImgList1").append("<li><img src='../images/sketch/type1/photo_04.jpg' alt=''></li>");
      totalidx_1 += 1;    
    }
    else if($("#TeamGb").val() == "2"){
      //$("#DP_ImgList2").append("<li><img src='../images/sketch/type2/photo_03.jpg' alt=''></li>");
      totalidx_2 += 1;        
    }
    else if($("#TeamGb").val() == "3"){

      if(totalidx_3 > 39){
        return;
      }

      var str_idx = "";

      if(totalidx_3.toString().length < 2){
        str_idx = "0" + totalidx_3.toString();
      }
      else{
        str_idx = totalidx_3.toString();      
      }

      $("#DP_ImgList3").append("<li><img src='../images/sketch/type3/open_" + str_idx + ".jpg' alt=''></li>");
      totalidx_3 += 1;  
    }
    else if($("#TeamGb").val() == "4"){

      if(totalidx_4 > 61){
        return;
      }

      var str_idx = "";

      if(totalidx_4.toString().length < 2){
        str_idx = "0" + totalidx_4.toString();
      }
      else{
        str_idx = totalidx_4.toString();      
      }

      $("#DP_ImgList4").append("<li><img src='../images/sketch/type4/gaenari_gookhwa_" + str_idx + ".jpg' alt=''></li>");
      totalidx_4 += 1;  
    }


  }
});

function change_teamgb(obj){

  if($(obj).val() == "1"){
  
    $("#DP_List1").css("display", "");
    $("#DP_List2").css("display", "none");
    $("#DP_List3").css("display", "none");
    $("#DP_List4").css("display", "none");
    //$("DP_List1").hide();
    //$("DP_List2").hide();
  }
  else if ($(obj).val() == "2"){

    $("#DP_List1").css("display", "none");
    $("#DP_List2").css("display", "");
    $("#DP_List3").css("display", "none");
    $("#DP_List4").css("display", "none");
    //$("DP_List1").hide();
    //$("DP_List2").hide();
  }
  else if ($(obj).val() == "3"){

    $("#DP_List1").css("display", "none");
    $("#DP_List2").css("display", "none");
    $("#DP_List3").css("display", "");
    $("#DP_List4").css("display", "none");
    //$("DP_List1").hide();
    //$("DP_List2").hide();
  }
  else if ($(obj).val() == "4"){

    $("#DP_List1").css("display", "none");
    $("#DP_List2").css("display", "none");
    $("#DP_List3").css("display", "none");
    $("#DP_List4").css("display", "");
    //$("DP_List1").hide();
    //$("DP_List2").hide();
  }
}
      

  
</script>
<body >
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>현장스케치</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->

  <!-- S: main -->
  <div class="main stadium_sketch">
    <!-- S: spinner -->
    <div class="spinner">
      <img src="../images/public/loading.gif" alt>
    </div>
    <!-- E: spinner -->
    <!-- S: ctr_select -->

    <div class="ctr_select">
      <ul>
        <li class="sel_box">
          <select>
            <option>년도일자 선택</option>
            <option>년도일자 선택</option>
            <option>년도일자 선택</option>
          </select>
        </li>
        <li class="sel_box">
          <select>
            <option>대회명 선택</option>
          </select>
        </li>
        <li class="sel_box">
          <select id="TeamGb" onchange="change_teamgb(this);">
            <option value="1">신인부</option>
            <option value="2">개나리부</option>
            <option value="3">오픈부</option>
            <option value="4">개나리부+국화부</option>
          </select>
        </li>
      </ul>
    </div>
    <div class="pic_info"># 공식런칭 후 사진 다운로드 가능</div>
    <!-- E: ctr_select -->
    <!-- S: photo_list -->
    <div class="photo_list">
      <!-- S: 신인부 -->
      <div class="order type1" id="DP_List1" style="display:block;">
        <ul id="DP_ImgList1">
          <li>
            <img src="../images/sketch/type1/sinin_01.jpg" alt="">
          </li>
          <li>
            <img src="../images/sketch/type1/sinin_02.jpg" alt="">
           </li>
          <li>
            <img src="../images/sketch/type1/sinin_03.jpg" alt="">
          </li>
          <!--<li>
            <img src="../images/sketch/type1/photo_04.jpg" alt="">
          </li>
          <li>
            <img src="../images/sketch/type1/photo_05.jpg" alt="">
          </li> -->
        </ul>
      </div>
      <!-- E: 신인부 -->
      
      <!-- S: 개나리부 -->


      
      <div class="order type2" id="DP_List2" style="display:none;">
        <ul id="DP_ImgList2">
          <li>
            <img src="../images/sketch/type2/gaenari_01.jpg" alt="">
          </li>
          <li>
            <img src="../images/sketch/type2/gaenari_02.jpg" alt="">
          </li>
           <li>
            <img src="../images/sketch/type2/gaenari_03.jpg" alt="">
          </li>
           <li>
            <img src="../images/sketch/type2/gaenari_04.jpg" alt="">
          </li>
          <!--<li>
            <img src="../images/sketch/type2/photo_04.jpg" alt="">
          </li>
          <li>
            <img src="../images/sketch/type2/photo_05.jpg" alt="">
          </li>-->
        </ul>
      </div>
      
      <!-- E: 개나리부 -->

      <!-- S: 개나리부 -->


      
      <div class="order type3" id="DP_List3" style="display:none;">
        <ul id="DP_ImgList3">
          <li>
            <img src="../images/sketch/type3/open_01.jpg" alt="">
          </li>
          <li>
            <img src="../images/sketch/type3/open_02.jpg" alt="">
          </li>
           <li>
            <img src="../images/sketch/type3/open_03.jpg" alt="">
          </li>
           <li>
            <img src="../images/sketch/type3/open_04.jpg" alt="">
          </li>
          <!--<li>
            <img src="../images/sketch/type2/photo_04.jpg" alt="">
          </li>
          <li>
            <img src="../images/sketch/type2/photo_05.jpg" alt="">
          </li>-->
        </ul>
      </div>
      
      <!-- E: 개나리부 -->

      <!-- S: 개나리부 -->


      
      <div class="order type4" id="DP_List4" style="display:none;">
        <ul id="DP_ImgList4">
          <li>
            <img src="../images/sketch/type4/gaenari_gookhwa_01.jpg" alt="">
          </li>
          <li>
            <img src="../images/sketch/type4/gaenari_gookhwa_02.jpg" alt="">
          </li>
           <li>
            <img src="../images/sketch/type4/gaenari_gookhwa_03.jpg" alt="">
          </li>
           <li>
            <img src="../images/sketch/type4/gaenari_gookhwa_04.jpg" alt="">
          </li>
          <!--<li>
            <img src="../images/sketch/type2/photo_04.jpg" alt="">
          </li>
          <li>
            <img src="../images/sketch/type2/photo_05.jpg" alt="">
          </li>-->
        </ul>
      </div>
      
      <!-- E: 개나리부 -->

    </div>
    <!-- E: photo_list -->
  </div>
  <!-- E: main -->

  <!-- S: footer -->
  <div class="footer light-footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->


  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>