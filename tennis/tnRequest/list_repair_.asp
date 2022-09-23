<!--#include file="./include/config_top.asp" -->
<title>KATA Tennis 대회 참가신청</title>
<!--#include file="./include/config_bot_.asp"-->
<!--#include file="./Library/ajax_config.asp"-->
<%  
  '=========================================================================================
  '대회참가신청 목록 페이지
  '=========================================================================================    

  dim currPage        : currPage          = fInject(Request("currPage"))
  dim Fnd_GameTitle   : Fnd_GameTitle     = fInject(Request("Fnd_GameTitle"))
  dim Fnd_TeamGb      : Fnd_TeamGb        = fInject(Request("Fnd_TeamGb"))
  dim Fnd_KeyWord     : Fnd_KeyWord       = fInject(Request("Fnd_KeyWord"))

  
%>
<script>
  //create Select box 대회조회 및 대회참가종목 조회
  function FND_SELECTOR(element){
    var strAjaxUrl = "./ajax/Request_Select.asp";  
    var Fnd_GameTitle = $("#GameTitle").val();
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: { 
        element       : element
        ,Fnd_GameTitle  : Fnd_GameTitle
      },
      success: function(retDATA) {
      
        //console.log(retDATA);
        
        if(retDATA){
        
          var strcut = retDATA.split("|");
        
          if(strcut[0]=="TRUE") $('#'+element).append(strcut[1]);
          
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
  
    //상세페이지 및 목록조회
    function CHK_OnSubmit(valType, valIDX, chkPage){
    
    //상세페이지
    if(valType=="VIEW"){
      var strAjaxUrl = "./ajax/list_repair_info.asp";      
      var CIDX = $("#CIDX").val();        //참가신청 IDX 
      var CUserPass = $("#CUserPass").val();  //참가신청 비밀번호
      
      var txtErr;
      
      if(!$('#CUserPass').val()){
        alert("비밀번호를 입력해 주세요.");
        $('#CUserPass').focus();
        return;
      }
      
      $.ajax({
        url: strAjaxUrl,
        type: "POST",
        dataType: "html",     
        data: { 
          CIDX      : CIDX
          ,CUserPass  : CUserPass       
        },    
        success: function(retDATA) {
        
          console.log(retDATA);
          
          if(retDATA){
            var strcut = retDATA.split("|");
            
            if(strcut[0]=="TRUE"){
              
              $('#act').val('MOD');
              $('#RequestIDX').val(strcut[2]);       //참가신청IDX
              $('#Fnd_GameTitle').val(strcut[1]);   //대회IDX
              //$('#RequestGroupNum').val(strcut[2]); //참가신청 그룹번호
              
              
              $('form[name="s_frm"]').attr('action', './write.asp');
              $('form[name="s_frm"]').submit();
            }
            else{
          
              switch (strcut[1]) { 
                case '200': txtErr = "잘못된 접근입니다. 확인 후 이용하세요."; break;
                case '66': txtErr = "비밀번호가 일치하지 않습니다."; $('#CUserPass').val(''); break;
                case '99': txtErr = "일치하는 정보가 없습니다. 확인 후 이용하세요"; $('#CUserPass').val(''); $('.conf_pw').hide(); break;
                default:   break;             
              }
          
              alert(txtErr);  
              return;           
            }
          }
          else{
            alert("잘못된 접근입니다. 확인 후 이용하세요"); 
            return;
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
    
      //리스트페이지
      else{
          var strAjaxUrl = "./ajax/request_list.asp";         
          var Fnd_GameTitle = $("#GameTitle").val();      
          var Fnd_TeamGb = $("#TeamGb").val();
          var Fnd_KeyWord = $("#Fnd_KeyWord").val();
      
          if(chkPage!="") $("#currPage").val(chkPage);
    
          var currPage = $("#currPage").val();
    
          $.ajax({
            url: strAjaxUrl,
            type: "POST",
            dataType: "html",     
            data: { 
                currPage      : currPage
                ,Fnd_GameTitle  : Fnd_GameTitle
                ,Fnd_TeamGb     : Fnd_TeamGb    
                ,Fnd_KeyWord    : Fnd_KeyWord       
            },    
            success: function(retDATA) {
          
               console.log(retDATA);
          
                if(retDATA){
                  var strcut = retDATA.split("|");
            
                  //참가신청 목록
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
  
  $(document).on('change','#GameTitle',function(){
  
    //참가종목 초기화
    $('#TeamGb').children('option').remove();
    
    //참가종목 조회 
    FND_SELECTOR('TeamGb');
    
  }); 
  
  
  $(document).ready(function(){
    //참가신청 목록조회
    CHK_OnSubmit('LIST','',1);
    
    //검색조건 대회명 조회
    FND_SELECTOR('GameTitle');
    
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
    <input type="hidden" id="RequestIDX" name="RequestIDX" />    
    
  <!-- S: main -->
  <div class="main list">
    <!-- S: cont_box -->
    <div class="cont_box">
      <!-- S: list_header -->
      <div class="list_header">
        <ul>
          <li id="sel_GameTitle">
            <select class="match_sel" id="GameTitle" name="GameTitle">
              <option value="">:: 대회선택 ::</option>
              <!--
              <option>[B그룹] 2017 테니스사랑배</option>
              <option>[SA그룹] 2017 엔프라니배</option>
              <option>[C그룹] 2017 Flex Power 용인클레이배</option>
              <option>[B그룹] 2017 프렌드쉽오픈</option>
              -->
            </select>
          </li>
          <li id="sel_TeamGb">
            <select class="part_sel" id="TeamGb" name="TeamGb">
              <option value="">:: 참가종목선택 ::</option>
              <!--
              <option>국화부</option>
              <option>개나리부-부천</option>
              <option>개나리부-구리</option>
              <option>오픈부</option>
              <option>신인부(부천)</option>
              <option>신인부(구리)</option>
              <option>신인부(부천대기)</option>
              <option>신인부(구리대기)</option>
              -->
            </select>
          </li>
          <li>
            <span class="ic_deco"><i class="fa fa-search"></i></span>
            <input type="text" placeholder="이름을 검색하세요" id="Fnd_KeyWord" name="Fnd_KeyWord"/>
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
        <!-- <div class="btn_list">
          <a href="write.asp" class="btn btn_green">
            <span class="ic_deco">
              <i class="fa fa-pencil"></i>
            </span>
            <span>참가신청하기</span>
          </a>
        </div> -->
        <!-- E: 참가신청하기 버튼 -->
        <a href="list.asp" class="btn btn_brown go_list">대회목록보기</a>
        <!-- S: 참가신청 리스트 목록표 -->
        <table class="table table-striped req_list repair">
          <thead>
            <tr>
              <th>번호</th>
              <th>대회명</th>
              <th>참가종목</th>
              <th>참가자1</th>
              <th>참가자1클럽</th>
              <th>참가자2</th>
              <th>참가자2클럽</th>
            </tr>
          </thead>
          <tbody id="tbl_list">
          <!--
            <tr>
              <td><a href=".conf_pw" data-toggle="modal">15</a></td>
              <td><a href=".conf_pw" data-toggle="modal">[SA그룹] 2017 엔프라니배</a></td>
              <td><a href=".conf_pw" data-toggle="modal">베테랑부</a></td>
              <td><a href=".conf_pw" data-toggle="modal">김학윤</a></td>
              <td><a href=".conf_pw" data-toggle="modal">클레이/기흥</a></td>
              <td><a href=".conf_pw" data-toggle="modal">박안용</a></td>
              <td><a href=".conf_pw" data-toggle="modal">서남제우스</a></td>
            </tr>
            <tr>
              <td><a href=".conf_pw" data-toggle="modal">14</a></td>
              <td><a href=".conf_pw" data-toggle="modal">[SA그룹] 2017 엔프라니배</a></td>
              <td><a href=".conf_pw" data-toggle="modal">신입부(목동)</a></td>
              <td><a href=".conf_pw" data-toggle="modal">나현찬</a></td>
              <td><a href=".conf_pw" data-toggle="modal">보람회.MTC</a></td>
              <td><a href=".conf_pw" data-toggle="modal">박선민</a></td>
              <td><a href=".conf_pw" data-toggle="modal">일산</a></td>
            </tr>
            <tr>
              <td><a href=".conf_pw" data-toggle="modal">13</a></td>
              <td><a href=".conf_pw" data-toggle="modal">[SA그룹] 2017 엔프라니배</a></td>
              <td><a href=".conf_pw" data-toggle="modal">신인부(부천)</a></td>
              <td><a href=".conf_pw" data-toggle="modal">한문수</a></td>
              <td><a href=".conf_pw" data-toggle="modal">강서어택,아리수</a></td>
              <td><a href=".conf_pw" data-toggle="modal">000</a></td>
              <td><a href=".conf_pw" data-toggle="modal">00000</a></td>
            </tr>
            <tr>
              <td><a href=".conf_pw" data-toggle="modal">12</a></td>
              <td><a href=".conf_pw" data-toggle="modal">[SA그룹] 2017 엔프라니배</a></td>
              <td><a href=".conf_pw" data-toggle="modal">오픈부</a></td>
              <td><a href=".conf_pw" data-toggle="modal">정진교</a></td>
              <td><a href=".conf_pw" data-toggle="modal">목동레인보우,몬스</a></td>
              <td><a href=".conf_pw" data-toggle="modal">하수호</a></td>
              <td><a href=".conf_pw" data-toggle="modal">청운,몬스터,테플</a></td>
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

  <!-- S: .conf_pw -->
  <div class="modal fade conf_pw">
    <!-- S: modal-dialog -->
    <div class="modal-dialog">
      <!-- S: modal-content -->
      <div class="modal-content">
        <!-- S: modal-header -->
        <div class="modal-header">
          <h3>비밀번호</h3>
          <!-- S: btn_close -->
          <a href="#" class="btn btn_close" data-dismiss="modal">
            <span class="ic_deco">
              <i class="fa fa-times"></i>
            </span>
          </a>
          <!-- E: btn_close -->
        </div>
        <!-- E: modal-header -->
        <!-- S: modal-body -->
        <div class="modal-body">
          
            <fieldset>
              <legend>비밀번호 입력</legend>
              <input type="password" class="ipt_pw" id="CUserPass" name="CUserPass" />
              <input type="hidden" id="act" name="act" />
              <input type="hidden" id="CIDX" name="CIDX" />
              <input type="button" onClick="CHK_OnSubmit('VIEW','','');" value="확인" class="btn btn_dark_blue">
            </fieldset>
          
          <p class="guide_txt">이 게시물의 비밀번호를 입력하십시오.</p>
        </div>
        <!-- E: modal-body -->

      </div>
      <!-- E: modal-content -->
    </div>
    <!-- E: modal-dialog -->
  </div>
  <!-- E: .conf_pw -->
  </form>
</body>
</html>
<script>
  (function($){
    var $this;
    var $btn;
    var $TxtIDX;

    $('.conf_pw').on('show.bs.modal', function(evt){
    
      $this = $(this);
      $btn = $(evt.relatedTarget);
      
      $TxtIDX = $btn.data('title');
      
      $('#CUserPass').focus();
      $('#CIDX').val($TxtIDX);
    
    });
    
  })(jQuery);
</script>