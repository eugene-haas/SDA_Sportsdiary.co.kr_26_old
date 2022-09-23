<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"--> 
<%
    Check_AdminLogin()
   
  dim currPage    : currPage        = fInject(Request("currPage"))
  dim fnd_AssoCode    : fnd_AssoCode    = fInject(Request("fnd_AssoCode"))  
  dim fnd_KeyWord     : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))   
    dim fnd_ViewYN    : fnd_ViewYN      = fInject(Request("fnd_ViewYN"))   
%>
<script language="javascript">
  /**
   * left-menu 체크
   */
  var locationStr = "association_membership"; // 임원현황
  /* left-menu 체크 */

  //검색
  function chk_Submit(valType, valIDX, chkPage){
    var strAjaxUrl = '../Ajax/Successive_list.asp';    
    var fnd_AssoCode = $('#fnd_AssoCode').val();
    var fnd_KeyWord = $('#fnd_KeyWord').val();
    var fnd_ViewYN = $('#fnd_ViewYN').val();

    if(chkPage!='') $('#currPage').val(chkPage);

    var currPage = $('#currPage').val();

    if(valType=='VIEW' || valType=='WRITE'){
      $('#CIDX').val(valIDX);   

      $('form[name=s_frm]').attr('action','./Successive_write.asp');
      $('form[name=s_frm]').submit(); 
    }
    else{ 
      //전체검색
      if(valType=='ALL') {
        currPage = '';
        fnd_AssoCode = '';
        fnd_KeyWord = '';
        fnd_ViewYN = '';
        
        $('#currPage').val('');
        $('#fnd_AssoCode').val('');          
        $('#fnd_KeyWord').val('');          
        $('#fnd_ViewYN').val('');          
      }
      
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',     
        data: {
          currPage      : currPage 
          ,fnd_AssoCode   : fnd_AssoCode  
          ,fnd_KeyWord    : fnd_KeyWord  
          ,fnd_ViewYN     : fnd_ViewYN  
        },    
        success: function(retDATA) {
          
          //console.log(retDATA);
          
          $('#board-contents').html(retDATA);       
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
    //협회정보 make:select box 
    make_box('sel_fnd_AssoCode', 'fnd_AssoCode', '<%=fnd_AssoCode%>', 'Info_AssoCode'); 
    
    $.when( $.ajax(make_box('sel_fnd_AssoCode', 'fnd_AssoCode', '<%=fnd_AssoCode%>', 'Info_AssoCode'))).then(function() {
      chk_Submit('', '', 1);        
    }); 
  });
</script> 
<!-- S : content -->
  <div id="content" class="successive_list">
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>역대타이틀정보</h2>
      <a href="./association_membership.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>홈페이지관리</li>
          <li>협회정보</li>
          <li><a href="./association_membership.asp">임원현황</a></li>
          <li><a href="./Successive_list.asp">역대타이틀정보</a></li>
        </ul>
      </div>
      <!-- E: 네비게이션 -->

    </div>
    <!-- E: page_title -->

    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
      <input type="hidden" id="CIDX" name="CIDX" />
  <div class="search_top community">  
      <div class="search_box">

        <span id="sel_fnd_AssoCode">
          <select name="fnd_AssoCode" id="fnd_AssoCode" class="title_select">
                  <option value="">:: 협회 선택 ::</option>
                </select>
        </span>
               
        <select name="fnd_ViewYN" id="fnd_ViewYN" class="title_select">
            <option value="">:: 노출구분 선택 ::</option>
            <option value="Y" <%IF fnd_ViewYN = "Y" Then response.write "selected" End IF%>>노출</option>
            <option value="N" <%IF fnd_ViewYN = "N" Then response.write "selected" End IF%>>노출안함</option>  
          </select>
          <input type="text" id="fnd_KeyWord" name="fnd_KeyWord" placeholder="제목 검색어를 입력해 주세요." value="<%=fnd_KeyWord%>" class="title_input ipt-word">
       <a href="javascript:chk_Submit('FND','',1);" class="btn btn-confirm">검색</a> 
          <a href="javascript:chk_Submit('ALL','',1);" class="btn btn-blue-empty">전체목록</a>
          <a href="javascript:chk_Submit('WRITE','',1);" class="btn btn-add">역대타이틀정보 등록</a>
          
    
      </div>
    <div class="btn-list top-menu-btn no-empty-bot">
      <a href="./association_list.asp" class="btn">협회정보관리</a>  
      <a href="./CateOfficers_list.asp" class="btn">임원직책정보관리</a>
      <a href="./association_membership.asp" class="btn">임원현황</a>
      </div>
      <div class="search_top community"> 
        <!-- S : 리스트형 20개씩 노출 -->
        <div id="board-contents" class="table-list-wrap"> 
          <!-- S : table-list --> 
          <!-- E : table-list --> 
        </div>
        <!-- E : 리스트형 20개씩 노출 --> 
        
      </div>
    </div>
    </form>
    <!-- E : sch 검색조건 선택 및 입력 --> 
  </div>
</section>
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../include/footer.asp"-->