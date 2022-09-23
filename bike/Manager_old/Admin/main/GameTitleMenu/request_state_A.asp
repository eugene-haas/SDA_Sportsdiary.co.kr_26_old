<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"--> 
<!-- E: include header_top -->
<%
    
    dim CIDX          : CIDX        = crypt.DecryptStringENC(fInject(request("CIDX")))  '대회IDX
   
    '검색조건 항목 
    dim fnd_currPage    : fnd_currPage  = fInject(Request("fnd_currPage"))    '참가신청 현황 리스트 페이지                                         
    dim fnd_AreaGb      : fnd_AreaGb    = fInject(Request("fnd_AreaGb"))  
    dim fnd_AreaGbDt    : fnd_AreaGbDt  = fInject(Request("fnd_AreaGbDt"))
  dim fnd_GameType    : fnd_GameType  = fInject(Request("fnd_GameType"))   
    dim fnd_GameGroup   : fnd_GameGroup = fInject(Request("fnd_GameGroup"))  
  dim fnd_GameLevel   : fnd_GameLevel = fInject(Request("fnd_GameLevel"))  
    dim fnd_RKeyWord    : fnd_RKeyWord  = fInject(Request("fnd_RKeyWord"))  
   
    '대회정보 리스트 페이지  
    dim currPage      : currPage    = fInject(Request("currPage"))
    dim fnd_Year      : fnd_Year    = fInject(Request("fnd_Year"))    
    dim fnd_EnterType   : fnd_EnterType = fInject(Request("fnd_EnterType"))    
    dim fnd_KeyWord   : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))    

                                         
    IF CIDX = "" Then
    response.write "<script>"
    response.write "  alert('잘못된 접근입니다. 확인 후 이용하세요.');"
    response.write "  history.back();"
    response.write "</script>"
    response.end
    Else
    dim GameTitleName, GameStartYear

    LSQL = "      SELECT GameTitleName"
    LSQL = LSQL & "   ,LEFT(GameS, 4) + '년' GameStartYear"
    LSQL = LSQL & "   ,EnterType"                        
    LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitle]"
    LSQL = LSQL & " WHERE DelYN = 'N'"
    LSQL = LSQL & "     AND ViewYN = 'Y'"                     
    LSQL = LSQL & "     AND GameTitleIDX = '"&CIDX&"'"                                            

  '     response.Write LSQL

    SET LRs = DBCon.Execute(LSQL)
    IF Not(LRs.Eof OR LRs.Bof) Then                         
      GameTitleName = LRs("GameTitleName")
      GameStartYear = LRs("GameStartYear")
   
        IF fnd_EnterType = "" Then fnd_EnterType = LRs("EnterType")
    ELSE
      response.write "<script>"
        response.write "  alert('일치하는 정보가 없습니다. 확인 후 이용하세요.');"
        response.write "  history.back();"
        response.write "</script>"
        response.end
    END IF
      LRs.Close
    SET LRs = Nothing
  End IF
  
%>
<script>
  /**
   * left-menu 체크
   */
  var locationStr = "request_MatchState"; // 참가신청관리
  /* left-menu 체크 */


  function chk_Submit(valType, valIDX, chkPage){
    var strAjaxUrl = '/Ajax/Request/GameMatch_Request.asp';    


    if(chkPage!='') $('#fnd_currPage').val(chkPage);

    var fnd_currPage = $('#fnd_currPage').val();      

    switch(valType){
      case 'GAME':  //대회정보 리스트 이동
        $('form[name=s_frm]').attr('action','./request_MatchState.asp');
        $('form[name=s_frm]').submit();
        break;

      default :   //참가신청현황 리스트 조회
        var CIDX = $('#CIDX').val();
        var fnd_currPage = $('#fnd_currPage').val();                    
        var fnd_AreaGb = $('#fnd_AreaGb').val();
        var fnd_AreaGbDt = $('#fnd_AreaGbDt').val();
        var fnd_GameType = $('#fnd_GameType').val();
        var fnd_GameGroup = $('#fnd_GameGroup').val();
        var fnd_GameLevel = $('#fnd_GameLevel').val();
        var fnd_RKeyWord = $('#fnd_RKeyWord').val();
        var fnd_EnterType = $('#fnd_EnterType').val();  

        //전체검색
        if(valType=='ALL') {
          fnd_currPage = '';
          fnd_RKeyWord = '';

          $('#fnd_currPage').val('');
          $('#fnd_RKeyWord').val('');
          $('#fnd_GameGroup').val('');                         
          $('#fnd_GameLevel').val('');
          $('#fnd_AreaGb').val('');
          $('#fnd_AreaGbDt').val('');
        }   
        
        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',     
          data: { 
            CIDX          : CIDX
            ,fnd_currPage   : fnd_currPage
            ,fnd_AreaGb     : fnd_AreaGb      
            ,fnd_AreaGbDt   : fnd_AreaGbDt
            ,fnd_GameType : fnd_GameType
            ,fnd_GameGroup  : fnd_GameGroup
            ,fnd_GameLevel  : fnd_GameLevel           
            ,fnd_RKeyWord   : fnd_RKeyWord
            ,fnd_EnterType  : fnd_EnterType
            ,valType    : valType
          },    
          success: function(retDATA) {

            //console.log(retDATA);

            if(retDATA) {

              var strcut = retDATA.split('|');

              if(strcut[0]=='TRUE'){
                $('#info_count').html(strcut[1]);       
                $('#info_request').html(strcut[2]);       
                $('#info_page').html(strcut[3]);                                    
              }
              else{
                alert ('잘못된 접근입니다. 확인 후 이용하세요.');
                return; 
              }

            } 
          }, 
          error: function(xhr, status, error){           
            if(error!=''){
              alert ('오류발생! - 시스템관리자에게 문의하십시오!');
              return;
            }    
          }
        });    
    }
  }

  //상세지역(시/군/구) 조회                                 
  $(document).on('change', '#fnd_AreaGb', function(){
    var fnd_AreaGb = $('#fnd_AreaGb').val();
    var fnd_AreaGbDt = '<%=fnd_AreaGbDt%>';
    var valCode = fnd_AreaGb+','+fnd_AreaGbDt;

    //Make SelectBox: 상세지역(시/군/구)
    make_box('sel_fnd_AreaGbDt', 'fnd_AreaGbDt', valCode, 'AreaGbDt');
  });

  //경기구분에 따른 종목 셀렉박스 출력여부
  $(document).on('change', '#fnd_GameType', function(){

    //Make SelectBox: 경기구분2
    make_box('sel_fnd_GameGroup','fnd_GameGroup','<%IF fnd_GameGroup <> "" Then response.write CIDX&",'+$('#fnd_GameType').val()+',"&fnd_GameGroup Else response.write CIDX&",'+$('#fnd_GameType').val()+'," End IF%>','GameGroup'); 

    if($('#fnd_GameType').val()=='B0030002'){ //단체전 일 경우 종목 select box hide
      $('#sel_fnd_GameLevel').hide();  
      $('#fnd_GameLevel').val('');   
    } 
    else{ //개인전 일 경우 종목 select box show
      $('#sel_fnd_GameLevel').show(); 
    } 
  });

  //Make SelectBox: 경기구분2
  $(document).on('change', '#fnd_GameGroup', function(){      
    if($('#fnd_GameType').val()=='B0030002'){ //단체전 일 경우 종목 select box hide
      $('#sel_fnd_GameLevel').hide();  
      $('#fnd_GameLevel').val('');   
    } 
    else{ //개인전 일 경우 종목 select box show
      $('#sel_fnd_GameLevel').show(); 

      //Make SelectBox: 종목
      make_box('sel_fnd_GameLevel','fnd_GameLevel','<%IF fnd_GameLevel <> "" Then response.write CIDX&",'+$('#fnd_GameType').val()+','+$('#fnd_GameGroup').val()+',"&fnd_GameLevel Else response.write CIDX&",'+$('#fnd_GameType').val()+','+$('#fnd_GameGroup').val()+'," End IF%>','GameLevel'); 
    } 
  });

  //Make File: Excel file
  function make_FileExcel(){
    $('form[name=s_frm]').attr('action','./request_state_excel.asp');
    $('form[name=s_frm]').submit(); 
  }

  $(document).ready(function(){
    //Make SelectBox: 시/도
    make_box('sel_fnd_AreaGb','fnd_AreaGb','<%=fnd_AreaGb%>','AreaGb'); 

    //Make SelectBox: 경기구분[개인전|단체전]
    make_box('sel_fnd_GameType','fnd_GameType','<%IF fnd_GameType <> "" Then response.write CIDX&","&fnd_GameType Else response.write CIDX&"," End IF%>','GameType');         

    
    //Make SelectBox: 경기구분2       
    make_box('sel_fnd_GameGroup','fnd_GameGroup','<%IF fnd_GameGroup <> "" Then response.write CIDX&",'+$('#fnd_GameType').val()+',"&fnd_GameGroup Else response.write CIDX&",'+$('#fnd_GameType').val()+'," End IF%>','GameGroup');        

    chk_Submit('LIST', '', 1);    
    
  });
</script>
  <!-- S: content request_state_a -->
  <div id="content" class="request_state_a">
     <!-- S: page_title -->
      <div class="page_title clearfix">
      <h2>참가현황 조회</h2>
      <a href="./index.asp" class="btn btn-back">뒤로가기</a>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>대회정보</li>
          <li>대회관리</li>
          <li><a href="./request_MatchState.asp">참가신청관리</a></li>
          <li><a href="./request_state_A.asp">참가현황 조회</a></li>
        </ul>
      </div>
      <!-- E: 네비게이션 -->
    </div>
    <!-- E: page_title -->

    <form name="s_frm" method="post">
      <input type="hidden" name="CIDX" id="CIDX" value="<%=fInject(request("CIDX"))%>" />
      <input type="hidden" name="fnd_currPage" id="fnd_currPage" value="<%=fnd_currPage%>" />
      <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
      <input type="hidden" name="fnd_EnterType" id="fnd_EnterType" value="<%=fnd_EnterType%>" />
      <input type="hidden" name="fnd_Year" id="fnd_Year" value="<%=fnd_Year%>" />
      <div class="search_top community">
        <div class="search_box">
          <span id="sel_fnd_GameType">
            <select name="fnd_GameType" id="fnd_GameType" class="title_select">
              <option value="">경기구분Ⅰ</option>
              <!--
      <option>개인전</option>
                <option>단체전</option>
      -->
            </select>
          </span>
          <span id="sel_fnd_AreaGb">
            <select name="fnd_AreaGb" id="fnd_AreaGb" class="title_select">
                    <option value="">시/도</option>
                    <!--                      
                    <option>서울시</option>
                    <option>경기도</option>
          -->
              </select>
            </span>
            <span id="sel_fnd_AreaGbDt">
              <select name="fnd_AreaGbDt" id="fnd_AreaGbDt" class="title_select">
                    <option value="">시/군/구</option>
                    <!--  
                    <option>마포구</option>
                    <option>용인시</option>
                    <option>인천시</option>
          -->
                </select>
              </span>
              <span id="sel_fnd_GameGroup">
                <select name="fnd_GameGroup" id="fnd_GameGroup" class="title_select">
                    <option value="">경기구분</option>
                    <!--
                    <option>일반부</option>
                    <option>동호인부</option>
          -->
                </select>
              </span>
              <span id="sel_fnd_GameLevel">
                <select name="fnd_GameLevel" id="fnd_GameLevel" class="title_select">
                    <option value="">종목</option>
                    <!--
                    <option>남자단식</option>
                    <option>여자단식</option>
                    <option>남자복식</option>
                    <option>여자복식</option>
                    <option>혼합복식</option>
          -->
                </select>
              </span>
              <span class="divn divn_2 divn_key">
                <input type="text" placeholder="참가신청한 팀 이름" name="fnd_RKeyWord" id="fnd_RKeyWord" class="ipt-word" />
              </span>
              <span>
                <a href="javascript:chk_Submit('FND', '', 1)" class="btn btn-search">검색</a> <a href="javascript:chk_Submit('ALL', '', 1)" class="btn btn-basic">전체보기</a><a href="javascript:make_FileExcel()" class="btn">조회데이터 엑셀다운로드</a></span>
        <td></td> 
              </tr>
            </tbody>
          </table>
        </div>
        
        <!-- S: ch_year -->
        <div class="ch_year">
          <h3><%=GameStartYear%></h3>
          <h4 class="match_title"><%=GameTitleName%></h4>
        </div>
        <!-- E: ch_year -->
        <div id="info_count"></div>
        <!-- S: result_table -->
        <table class='table-list'>
          <thead>
            <tr>
              <th>시/도</th>
              <th>시/군/구</th>
              <th colspan="3">종목</th>
              <th>신청자</th>
              <th>참가자</th>
              <th>파트너</th>
              <th>신청일</th>
              <th>신청상태</th>
            </tr>
          </thead>
          <tbody id="info_request">
            <!--
                <tr>
                  <td>서울</td>
                  <td>마포구</td>
                  <td>남자 복식/20대/자강</td>
                  <td class="player_name">
                    <span>최보라</span>
                  </td>
                  <td class="player_name">
                    <span>홍길동서남북북서로기수를 돌려라</span>
                  </td>
                  <td class="player_name">
                    <span>임꺽정하지마 어차피 될놈되고 안될거 안돼</span>
                  </td>
                  <td>2018.02.11</td>                  
                </tr>
                <tr>
                  <td>서울</td>
                  <td>마포구</td>
                  <td>남자 복식/20대/자강</td>
                  <td class="player_name">
                    <span>최보라 스포츠다이어리 위드라인</span>
                  </td>
                  <td class="player_name">
                    <span>홍길동</span>
                  </td>
                  <td class="player_name">
                    <span>임꺽정</span>
                  </td>
                  <td>2018.02.11</td>
                </tr>
        -->
          </tbody>
        </table>
        <!-- E: result_table -->

        <!-- S: page_index -->
        <div class="page_index">
          <ul class="pagination" id="info_page">
          </ul>
        </div>
        <!-- E: page_index -->
      </div>
    </form>
  </div>
  <!-- E: content request_state_a -->

<!--#include file="../../include/footer.asp"-->