<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/config.asp" -->

  <%
      dim GameTitleIDX : GameTitleIDX = fInject(request("GameTitleIDX"))
      dim CSQL, CRs
      dim TeamGbIDX
      dim top_index : top_index = 3

      IF GameTitleIDX <> "" Then
          CSQL =  "EXEC Stadium_Sketch_select_list @GameTitleIDX = '"&GameTitleIDX&"'"
          'Response.write CSQL
          SET CRs = DBCon4.Execute(CSQL)
          IF Not(CRs.Eof OR CRs.Bof) Then
              TeamGbIDX = CRs("TeamGbIDX")
          Else
              Response.write "<script>"
              response.write "    alert('일치하는 정보가 없습니다.'); "
              response.write "    history.back();"
              response.write "</script>"
              response.end
          End IF
              CRs.close
          SET CRs = Nothing
      Else
          Response.write "<script>"
          response.write "    alert('잘못된 접근입니다. 확인 후 이용하세요.'); "
          response.write "    history.back();"
          response.write "</script>"
          response.end
      End IF
  %>
  <!-- <script src="../js/library/jquery-1.12.2.min.js"></script>
  <script src="../js/library/jquery.easing.1.3.min.js"></script> -->
  <script>

    // var totalidx_1 = 3;
    // var timer ;
    //
    // $(window).on('scroll', function(e){
    //     if ( timer ) clearTimeout(timer);
    //
    //     timer = setTimeout(function(){
    //       if($(window).scrollTop() + $(window).height() == $(document).height()){
    //
    //         totalidx_1 = totalidx_1 + 3;
    //         Fnd_TeamGb_open_two('<%=GameTitleIDX%>','',totalidx_1);
    //
    //       }
    //     }, 30);
    // });


    function change_teamgb(obj){
      var GameTitleIDX = '<%=GameTitleIDX%>';
      var r_TeamGbIDX = obj.value;
      document.getElementById("r_TeamGbIDX").value = obj.value;
      var strAjaxUrl = "../Ajax/stadium_sketch.asp?r_TeamGbIDX="+r_TeamGbIDX + "&GameTitleIDX="+GameTitleIDX;
      //location.href= strAjaxUrl
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
         GameTitleIDX  : GameTitleIDX ,
         r_TeamGbIDX   : r_TeamGbIDX
        },
        success: function(retDATA) {
         if (retDATA!='')
         {
           totalidx_1 = 3;
           document.getElementById("DP_List").innerHTML = retDATA;
         }

        }
      });


    }

    function Fnd_TeamGb_open(GameTitleIDX,r_TeamGbIDX,Top_index)
      {
        //alert(r_TeamGbIDX);
        if (Top_index ==undefined)
        {
          Top_index = 3
        }
        //1. 처음 데이터 불러올때 셀렉트 선택 데이터 불러옴
         var strAjaxUrl = "../Ajax/stadium_sketch_Team_select.asp?GameTitleIDX="+GameTitleIDX;
         //location.href = strAjaxUrl
        // return;
        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',
          data: {
           GameTitleIDX  : GameTitleIDX ,
           r_TeamGbIDX   : r_TeamGbIDX
          },
          success: function(retDATA) {
             //TeamGb_Select_Div div에 해당 데이터를 보여줌
             document.getElementById("TeamGb_Select_Div").innerHTML = retDATA;

             //2. 셀렉트 박스 셋팅 후 사진 데이터 뿌려주는 부분
             if (Top_index==3)
             {
               //alert('1');
               //alert(Top_index);
               var strAjaxUrl = "../Ajax/stadium_sketch.asp?Top_index="+Top_index + "&GameTitleIDX="+GameTitleIDX;
              //location.href= strAjaxUrl
              $.ajax({
                url: strAjaxUrl,
                type: 'POST',
                dataType: 'html',
                data: {
                 GameTitleIDX  : GameTitleIDX ,
                 r_TeamGbIDX   : r_TeamGbIDX
                },
                success: function(retDATA) {
                 document.getElementById("DP_List").innerHTML = retDATA;
                }
              });

             }
             else
             {
                //alert('2');
             }
           }
        });

      }

    function Fnd_TeamGb_open_two(GameTitleIDX,r_TeamGbIDX,Top_index){
      console.log('dd')

      if (r_TeamGbIDX=='')
      {
        r_TeamGbIDX = document.getElementById("r_TeamGbIDX").value;
      }
      if (r_TeamGbIDX == '')
      {
        r_TeamGbIDX = 0;
      }
      var strAjaxUrl = "../Ajax/stadium_sketch.asp?Top_index="+Top_index + "&GameTitleIDX="+GameTitleIDX + "&r_TeamGbIDX="+r_TeamGbIDX;
      //alert(strAjaxUrl);
      //location.href= strAjaxUrl
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
         GameTitleIDX  : GameTitleIDX ,
         r_TeamGbIDX   : r_TeamGbIDX
        },
        success: function(retDATA) {
         if (retDATA!='')
         {
          $("#DP_List").append(retDATA)
         }

        }
      });
    }

    $(document).ready(function(){
        $("#TeamGb").append("<option value='1'>신인부</option>");
        $("#TeamGb").append("<option value='2'>개나리부</option>");
        $("#TeamGb").append("<option value='3'>오픈부</option>");

        //$("#DP_List1").css("display", "");
        Fnd_TeamGb_open('<%=GameTitleIDX%>','<%=TeamGbIDX%>');

        var totalidx_1 = 3;
        var timer ;
        $('._sd-infinite').on('scroll', function(evt){
          var $this = $(this);
          if ( timer ) clearTimeout(timer);
          timer = setTimeout(function(){
            if(($this.scrollTop() + $this.height())  >= $this.prop('scrollHeight') - 50){

              totalidx_1 = totalidx_1 + 3;
              Fnd_TeamGb_open_two('<%=GameTitleIDX%>','',totalidx_1);

            }
          }, 30);
        });


    });


    function sketch_download(FileName,FilePath){
      document.getElementById('FileName').value = FileName;
      //return;
      document.sketchForm.target="sketch_download"
      document.sketchForm.action='stadium_sketch_download.asp'
      document.sketchForm.submit();
    }

  </script>
</head>
<body >
  <form name="sketchForm">
    <input type="hidden" id="FileName" name="FileName">
  </form>
  <iframe id="sketch_download" style="display:none;" ></iframe>


  <input type="hidden" id="top_index" name="top_index" value="<%=top_index%>">
  <input type="hidden" id="r_TeamGbIDX" name="r_TeamGbIDX" value="">

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
   <!-- #include file="../include/sub_header_arrow.asp" -->
   <h1>현장스케치</h1>
   <!-- #include file="../include/sub_header_right.asp" -->
  </div>
  <!-- E: sub-header -->

  <!-- #include file = "../include/gnb.asp" -->

  <!-- S: main -->
  <div class="main stadium_sketch sd-main-A sd-scroll [ _sd-scroll _sd-infinite ]">
    <!-- S: spinner -->
    <div class="spinner">
      <img src="http://img.sportsdiary.co.kr/sdapp/public/loading.gif" alt>
    </div>
    <!-- E: spinner -->
    <!-- S: ctr_select -->

    <div class="ctr_select sel_box" id="TeamGb_Select_Div">
      <select id="TeamGb" onchange="change_teamgb(this);"></select>
    </div>
    <div class="pic_info" onclick="javascript:alert(fn_OSCHK());"># 공식런칭 후 사진 다운로드 가능</div>
    <!-- E: ctr_select -->
    <!-- S: photo_list -->
    <div class="photo_list">
      <!-- S: 신인부 -->
      <div class="order type1" id="DP_List" style="">
      </div>
      <!-- E: 신인부 -->
    </div>
    <!-- E: photo_list -->
  </div>
  <!-- E: main -->

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</body>
</html>
