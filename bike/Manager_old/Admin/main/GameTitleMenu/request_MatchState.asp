<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"--> 
<!-- E: include header_top -->
<%
    dim currPage      : currPage    = fInject(Request("currPage"))
    dim fnd_Year      : fnd_Year    = fInject(Request("fnd_Year"))    
    dim fnd_EnterType   : fnd_EnterType = fInject(Request("fnd_EnterType"))    
    dim fnd_KeyWord   : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))    
%>
<script type="text/javascript">
    function chk_Submit(valType, valIDX, chkPage){
      var strAjaxUrl = '/Ajax/Request/match_list.asp';    
      var fnd_Year = $('#fnd_Year').val();
    var fnd_EnterType = $('#fnd_EnterType').val();  
    var fnd_KeyWord = $('#fnd_KeyWord').val();    

      if(chkPage!='') $('#currPage').val(chkPage);

      var currPage = $('#currPage').val();
      var valUrl = '';
      
      switch(valType){
          
        //참가현황 보기   
        case 'STATE' :
          $('#CIDX').val(valIDX);   
          
          if(fnd_EnterType=='A') { 
        valUrl = './request_state_A.asp'; 
      }
          else{ 
        alert('준비중입니다.');
        return;
        //valUrl = './request_state_E.asp'; 
      }
          
          $('form[name=s_frm]').attr('action', valUrl);
          $('form[name=s_frm]').submit(); 
          
          break;  
        
    //신청접수 보기   
        case 'RECEIVE' :
          $('#CIDX').val(valIDX);   
          
          if(fnd_EnterType=='A') { 
        valUrl = './request_receive_A.asp'; 
      }
          else{ 
        alert('준비중입니다.');
        return;
        //valUrl = './request_receive_E.asp'; 
      }
          
          $('form[name=s_frm]').attr('action', valUrl);
          $('form[name=s_frm]').submit(); 
          
          break;  
              
        //대회목록 조회
        default   :  
      //전체검색
      if(valType=='ALL') {
        currPage = '';
        fnd_KeyWord = '';
        fnd_EnterType = '';
        
        $('#currPage').val('');   
        $('#fnd_KeyWord').val('');
        $('#fnd_EnterType').val('');        
      }
        
        
            $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',     
        data: { 
          currPage : currPage
          ,fnd_Year  : fnd_Year
          ,fnd_EnterType  : fnd_EnterType 
          ,fnd_KeyWord  : fnd_KeyWord 
              },    
              success: function(retDATA) {

                  //console.log(retDATA);

                  if(retDATA) $('#info_match').html(retDATA);       

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
    
    //개최년도 별 대회목록 조회 
    $(document).on('change', '#fnd_Year', function(){
      chk_Submit('FND', '', 1); 
    });
  
  $(document).on('change', '#fnd_EnterType', function(){
      chk_Submit('FND', '', 1); 
    });
    
    $(document).ready(function(){
      chk_Submit('', '', 1);    
    });
  </script>

  <!-- S: content req_match_state -->
  <div id="content" class="req_match_state">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>참가신청관리</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>대회정보</li>
            <li>대회관리</li>
            <li><a href="./request_MatchState.asp">참가신청관리</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->
      </div>
      <!-- E: page_title -->

    <form name="s_frm" method="post">
      <input type="hidden" name="CIDX" id="CIDX" />
      <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
      <div class="search_top community">
        <!-- S: search_box -->
        <div class="search_box">
          <table>
            <tbody>
              <tr>
                <td><select name="fnd_Year" id="fnd_Year" class="title_select">
                    <option value="2019">2019</option>
                    <option value="2018" selected>2018</option>
                    <option value="2017">2017</option>
                  </select></td>
                <td><select name="fnd_EnterType" id="fnd_EnterType" class="title_select">
                    <!--<option value="">:: 구분 ::</option>-->
                    <option value="A" <%IF fnd_EnterType = "A" Then response.write "selected" End IF%>>생활체육</option>
                    <option value="E" <%IF fnd_EnterType = "E" Then response.write "selected" End IF%>>엘리트</option>
                  </select></td>
                <td class="divn divn_2 divn_key"><input type="text" name="fnd_KeyWord" id="fnd_KeyWord" placeholder="대회명 검색" class="ipt-word" /></td>
                <td><a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a> <!--<a href="javascript:chk_Submit('ALL','',1);" class="btn">전체목록</a>--></td>
              </tr>
            </tbody>
          </table>
        </div>
        <!-- E: search_box -->
        
        <!-- S: info_match -->
        <div id="info_match"></div>
        <!-- E: info_match -->
      </div>
    </form>
  </div>
  <!-- E: content req_match_state -->

<!--#include file="../../include/footer.asp"-->