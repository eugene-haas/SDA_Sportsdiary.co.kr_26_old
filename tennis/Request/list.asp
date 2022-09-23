<!--#include file="./include/config_top.asp" -->
<title>KATA Tennis 대회 참가신청</title>
<!--#include file="./include/config_bot.asp"-->
<!--#include file="./Library/ajax_config.asp"-->
<%  
    '=========================================================================================
  '대회참가신청 대회목록 페이지
  '=========================================================================================
  dim currPage      : currPage        = fInject(Request("currPage"))
  dim Fnd_KeyWord   : Fnd_KeyWord     = fInject(Request("Fnd_KeyWord"))
  
%>
<script>
  //대회목록조회
  function CHK_OnSubmit(valType, valIDX, chkPage){
  
    if(valType=="WR"){
      $('#Fnd_GameTitle').val(valIDX);   
      $('#act').val(valType);   
      
      if(chkPage!="") $("#currPage").val(chkPage);
      
      $('form[name=s_frm]').attr('action',"./write.asp");
      $('form[name=s_frm]').submit(); 
    }
    else{
	  //	console.log(chkPage);

      
      //리스트페이지
      var strAjaxUrl = "./ajax/list_GameTitle_info.asp";         
      var Fnd_KeyWord = $("#Fnd_KeyWord").val();
      
      if(chkPage!="") $("#currPage").val(chkPage);
      
      var currPage = $("#currPage").val();
      
      $.ajax({
        url: strAjaxUrl,
        type: "POST",
        dataType: "html",     
        data: { 
          currPage      : currPage
          ,Fnd_KeyWord    : Fnd_KeyWord       
        },    
        success: function(retDATA) {
        
          //console.log(retDATA);
          
          if(retDATA){
            var strcut = retDATA.split("|");
            
            //목록
            $("#tbl_list").html(strcut[0]);
            
            //페이징
            $("#page_list").html(strcut[1]);          
          }       
        }, 
        error: function(xhr, status, error){           
          if(error!=""){ 
            alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); 
            return; 
          }     
        }
      });  
    }
  }
  
  $(document).ready(function(){
    //참가신청 목록조회
    CHK_OnSubmit('LIST','',1);
  
  });              
</script>
</head>
<body class="lack_bg">
  <!-- S: header -->
  <!-- #include file = "./include/header.asp" -->
  <!-- E: header -->
  <form name="s_frm" method="post"> 
    <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
    <input type="hidden" id="Fnd_GameTitle" name="Fnd_GameTitle" />
    <input type="hidden" id="act" name="act" />
  <!-- S: main -->
  <div class="main list">
    <!-- S: cont_box -->
    <div class="cont_box">
      <!-- S: list_header -->
      <div class="list_header">
        <ul>
          <!--
          <li id="sel_GameTitle">
            <select class="match_sel" id="GameTitle" name="GameTitle">
              <option value="">:: 대회선택 ::</option>              
              <option>[B그룹] 2017 테니스사랑배</option>
              <option>[SA그룹] 2017 엔프라니배</option>
              <option>[C그룹] 2017 Flex Power 용인클레이배</option>
              <option>[B그룹] 2017 프렌드쉽오픈</option>              
            </select>
          </li>          
          <li id="sel_GameGb">
            <select class="part_sel" id="GameGb" name="GameGb">
              <option value="">:: 참가종목선택 ::</option>              
              <option>국화부</option>
              <option>개나리부-부천</option>
              <option>개나리부-구리</option>
              <option>오픈부</option>
              <option>신인부(부천)</option>
              <option>신인부(구리)</option>
              <option>신인부(부천대기)</option>
              <option>신인부(구리대기)</option>              
            </select>
          </li>
          -->
          <li>
            <span class="ic_deco"><i class="fa fa-search"></i></span>
            <input type="text" placeholder="대회명을 검색하세요" id="Fnd_KeyWord" name="Fnd_KeyWord" autocomplete="off">
          </li>
          <li>
            <a href="javascript:CHK_OnSubmit('FND');" class="btn btn_srch btn_dark_blue">검색</a>
          </li>
        </ul>
      </div>
      <!-- E: list_header -->

      <!-- S: list_table -->
      <div class="list_table">
        <!-- S: 참가신청하기 버튼 -->
        <!--
        <div class="btn_list">
          <a href="write.asp" class="btn btn_green">
            <span class="ic_deco">
              <i class="fa fa-pencil"></i>
            </span>
            <span>참가신청하기</span>
          </a>
        </div>
        -->
        <!-- E: 참가신청하기 버튼 -->
        <a href="list_repair.asp" class="btn btn_brown go_list">참가신청목록보기</a>

        <!-- S: 참가신청 리스트 목록표 -->
        <table class="table table-striped req_list conq">
          <thead>
            <tr>
              <th>번호</th>
              <th>대회명</th>
              <th>기간</th>
              <th>신청</th>
            </tr>
          </thead>
          <tbody id="tbl_list">
          <!--
            <tr>
              <td>15</td>
              <td>[SA그룹] 2017 엔프라니배</td>
              <td>2017.09.02(토) ~ 2017.09.04(월)</td>
              <td><a href="write.asp" class="btn btn_green">참가신청</a></td>
            </tr>
            <tr>
              <td>14</td>
              <td>[SA그룹] 2017 엔프라니배</td>
              <td>2017.09.02(토) ~ 2017.09.04(월)</td>
              <td><a href="write.asp" class="btn btn_green">참가신청</a></td>
            </tr>
            <tr>
              <td>13</td>
              <td>[SA그룹] 2017 엔프라니배</td>
              <td>2017.09.02(토) ~ 2017.09.04(월)</td>
              <td><a href="write.asp" class="btn btn_green">참가신청</a></td>
            </tr>
            <tr>
              <td>12</td>
              <td>[SA그룹] 2017 엔프라니배</td>
              <td>2017.09.02(토) ~ 2017.09.04(월)</td>
              <td><a href="write.asp" class="btn btn_green">참가신청</a></td>
            </tr>
            -->
          </tbody>
        </table>
        <!-- E: 참가신청 리스트 목록표 -->
      </div>
      <!-- E: list_table -->

      <!-- S: pagination -->
      <ul class="pagination" id="page_list">
      <!--
        <li><a href="#"><i class="fa fa-chevron-left" aria-hidden="true"></i></a></li>
        <li><a href="#" class="on">1</a></li>
        <li><a href="#">2</a></li>
        <li><a href="#">3</a></li>
        <li><a href="#">4</a></li>
        <li><a href="#"><i class="fa fa-chevron-right" aria-hidden="true"></i></a></li>
        -->
      </ul>
      <!-- E: pagination -->
    </div>
    <!-- E: cont_box -->
  </div>
  <!-- E: main -->
  </form>
</body>
</html>