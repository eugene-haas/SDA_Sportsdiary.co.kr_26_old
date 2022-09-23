<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"--> 
<!-- E: include header_top -->
<%
    
    dim CIDX          : CIDX        = crypt.DecryptStringENC(fInject(request("CIDX")))
   
    '검색조건 항목 
    dim fnd_currPage    : fnd_currPage  = fInject(Request("fnd_currPage"))    '참가신청 현황 리스트 페이지                                         
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

    LSQL = "    SELECT GameTitleName"
    LSQL = LSQL & "   ,LEFT(GameS, 4) + '년' GameStartYear"
'   LSQL = LSQL & "   ,EnterType"                        
    LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitle]"
    LSQL = LSQL & " WHERE DelYN = 'N'"
    LSQL = LSQL & "   AND ViewYN = 'Y'"                     
    LSQL = LSQL & "   AND GameTitleIDX = '"&CIDX&"'"                                            

  '     response.Write LSQL

    SET LRs = DBCon.Execute(LSQL)
    IF Not(LRs.Eof OR LRs.Bof) Then                         
      GameTitleName = LRs("GameTitleName")
      GameStartYear = LRs("GameStartYear")
   
 '      IF fnd_EnterType = "" Then fnd_EnterType = LRs("EnterType")
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
    var strAjaxUrl = '/Ajax/Request/GameMatch_Request_Receive.asp';    


    if(chkPage!='') $('#fnd_currPage').val(chkPage);

    var fnd_currPage = $('#fnd_currPage').val();  
    

    switch(valType){
      case 'GAME':  //대회정보 리스트 이동
        $('form[name=s_frm]').attr('action','./request_MatchState.asp');
        $('form[name=s_frm]').submit();
        break;
        
      case 'VIEW':  //참가신청접수현황
        $('#ReceptionistIDX').val(valIDX);  
        $('form[name=s_frm]').attr('action','./request_receive_A_detail.asp');
        $('form[name=s_frm]').submit();
        break;  

      default :   //참가신청접수현황 리스트 조회
        var CIDX = $('#CIDX').val();
        var fnd_currPage = $('#fnd_currPage').val();                    
        var fnd_RKeyWord = $('#fnd_RKeyWord').val();
        var fnd_EnterType = $('#fnd_EnterType').val();  

        //전체검색
        if(valType=='ALL') {
          fnd_currPage = '';
          fnd_RKeyWord = '';

          $('#fnd_currPage').val('');
          $('#fnd_RKeyWord').val('');
        }   
        
        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',     
          data: { 
            CIDX          : CIDX
            ,fnd_currPage   : fnd_currPage
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

  $(document).ready(function(){
    chk_Submit('LIST', '', 1);    
  });
</script>

  <!-- S: content request_recevie_a -->
  <div id="content" class="request_recevie_a">
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>신청접수현황</h2>
      <a href="./request_MatchState.asp" class="btn btn-back">뒤로가기</a>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>대회정보</li>
          <li>대회관리</li>
          <li><a href="./request_MatchState.asp">참가신청관리</a></li>
          <li><a href="./request_state_A.asp">신청접수현황</a></li>
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
    <input type="hidden" name="ReceptionistIDX" id="ReceptionistIDX"  />  
        <div class="search_top community">
          <div class="search_box">
            <span id="sel_fnd_GameType"><input type="text" placeholder="신청자, 신청팀" name="fnd_RKeyWord" id="fnd_RKeyWord" class="ipt-word"></span>
            <a href="javascript:chk_Submit('FND', '', 1)" class="btn btn-search">검색</a> <a href="javascript:chk_Submit('ALL', '', 1)" class="btn btn_point">전체보기</a><!-- <a href="javascript:chk_Submit('GAME', '', '')" class="btn btn_cta">참가신청관리</a> -->
          </div>
          
          <!-- S: ch_year -->
          <div class="ch_year">
            <!--<h3><%=GameStartYear%></h3>-->
            <h4 class="match_title"><%=GameTitleName%></h4>
          </div>
          <!-- E: ch_year --> 
          <div id="info_count" class="total_count"></div>
          <!-- S: result_table -->
          <table class='table-list'>
            <thead>
              <tr>
                <th>No.</th>
                <th>신청자(동호인번호)</th>
                <th>전화번호</th>
                <th>소속팀</th>
                <th>참가비</th>
                <th>신청상태</th>
                <th>상세보기</th>
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
            <ul class="pagination" id="info_page"></ul>
          </div>
          <!-- E: page_index -->
          
        </div>
      </form>
  
    
  </div>
  <!-- E: content request_recevie_a -->


<!--#include file="../../include/footer.asp"-->