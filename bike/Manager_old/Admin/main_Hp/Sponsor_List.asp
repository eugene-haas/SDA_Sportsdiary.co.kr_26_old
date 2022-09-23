<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
  dim currPage    : currPage      = fInject(Request("currPage"))
  dim fnd_UseYN     : fnd_UseYN     = fInject(Request("fnd_UseYN"))
  dim fnd_KeyWord     : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
  dim fnd_SponType    : fnd_SponType  = fInject(Request("fnd_SponType"))
%>
<script language="javascript">
  var locationStr = "";

  //검색
  function chk_Submit(valType, valIDX, chkPage){
  
    var strAjaxUrl = "../Ajax/Sponsor_List.asp";    
    var fnd_KeyWord = $("#fnd_KeyWord").val();
    var fnd_UseYN = $("#fnd_UseYN").val();
    var fnd_SponType = $("#fnd_SponType").val();    
    
    
    if(chkPage!="") $("#currPage").val(chkPage);
    
    var currPage = $("#currPage").val();
    
    if(valType=="VIEW"){
      $("#CIDX").val(valIDX);   
      
      $('form[name=s_frm]').attr('action',"./Sponsor_Write.asp");
      $('form[name=s_frm]').submit(); 
    }
    else{ 
      //전체검색
      if(valType=='ALL') {
        currPage = '';
        fnd_KeyWord = '';
        
        $("#fnd_KeyWord").val('');
        $("#currPage").val('');
      }
    
      $.ajax({
        url: strAjaxUrl,
        type: "POST",
        dataType: "html",     
        data: { 
          currPage    : currPage     
          ,fnd_KeyWord    : fnd_KeyWord  
          ,fnd_UseYN    : fnd_UseYN
          ,fnd_SponType : fnd_SponType
        },    
        success: function(retDATA) {
          $("#board-contents").html(retDATA);       
        }, 
        error: function(xhr, status, error){           
          if(error!=""){
            alert ("오류발생! - 시스템관리자에게 문의하십시오!");
            return;
          }
        }
      });
    } 
  }

  $(document).ready(function(){
    chk_Submit('','', 1);    
    make_box('sel_fnd_SponType','fnd_SponType','<%=fnd_SponType%>','Info_SponType');  //후원사 셀렉트박스 생성
  });
</script>
<!-- S : content sponsor_list -->
  <div id="content" class="sponsor_list">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>후원사 관리</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>홈페이지관리</li>
            <li>메인</li>
            <li><a href="./Sponsor_List.asp">후원사관리</a></li></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
    
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
      <input type="hidden" id="CIDX" name="CIDX" class="user_list_input" />
      <div class="search_top community">
        <div class="search_box">
          <span id="sel_fnd_SponType">
            <select name="fnd_SponType" id="fnd_SponType" class="title_select">
              <option value="">:: 후원사 구분 선택 ::</option>
            </select>
          </span>
            <select name="fnd_UseYN" id="fnd_UseYN" class="title_select">
                <option value="">===노출여부===</option>
                <option value="Y">사용</option>
                <option value="N">사용안함</option>
              </select>
            <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" placeholder="키워드 검색 [제목]" class="ipt-word">
          <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a>
          <a href="javascript:chk_Submit('ALL','',1);" class="btn btn-blue-empty">전체목록</a>
          <a href="./Sponsor_Write.asp" class="btn btn-add">후원사등록</a>
        </div>
        
        <!-- S : 리스트형 20개씩 노출 -->
        <div id="board-contents" class="table-list-wrap">
          <!-- S : table-list -->
          <!-- E : table-list -->
        </div>
        <!-- E : 리스트형 20개씩 노출 -->
      </div>
    </form>
    <!-- E : sch 검색조건 선택 및 입력 -->
  </div>
<!-- E : content sponsor_list -->

<!--#include file="../include/footer.asp"-->
