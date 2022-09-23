<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim fnd_KeyWord     : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
    dim fnd_Year      : fnd_Year    = fInject(Request("fnd_Year"))
    dim fnd_Country     : fnd_Country   = fInject(Request("fnd_Country"))
%>
<script language="javascript">

  var locationStr = "GameTitleIntl_list.asp";


  //검색
  function chk_Submit(valType, valIDX, chkPage){

    var strAjaxUrl = '../Ajax/GameTitleMenu/GameTitleIntl_List.asp';    
    var fnd_KeyWord = $('#fnd_KeyWord').val();
    var fnd_Year = $('#fnd_Year').val();
    var fnd_Country = $('#fnd_Country').val();  

    if(chkPage!='') $('#currPage').val(chkPage);

    var currPage = $('#currPage').val();

    if(valType=='VIEW'){
      $('#CIDX').val(valIDX);   
      $('form[name=s_frm]').attr('action','./GameTitleIntl_Write.asp');
      $('form[name=s_frm]').submit(); 
    }
    else{ 
      //전체검색
      if(valType=='ALL') {
        currPage = '';
        fnd_KeyWord = '';
        fnd_Year = '';  
        fnd_Country = '';

        $('#currPage').val('');
        $('#fnd_KeyWord').val('');
        $('#fnd_Year').val('');
        $('#fnd_Country').val('');
      }

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',     
        data: { 
          currPage      : currPage     
          ,fnd_KeyWord    : fnd_KeyWord  
          ,fnd_Year     : fnd_Year
          ,fnd_Country  : fnd_Country
        },    
        success: function(retDATA) {
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
    chk_Submit('', '', 1); //대회정보   
    
    make_box('sel_fnd_Country', 'fnd_Country', '<%=fnd_Country%>', 'Info_Country'); //국가 Select Box Option 
  });
</script>
<!-- S : content GameTitleIntl_List -->
  <div id="content" class="GameTitleIntl_List">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>국제대회</h2>
        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>홈페이지관리</li>
            <li>대회정보</li>
            <li>국제대회</li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
    
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
      <input type="hidden" id="CIDX" name="CIDX"  />
      <div class="search_top community">
        <div class="search_box">          
    <select name="fnd_Year" id="fnd_Year" class="title_select">
      <option value="" selected>년도</option>
      <option value="2018" <%IF fnd_Year = "2018" Then response.write "selected" End IF%>>2018</option>
      <option value="2019" <%IF fnd_Year = "2019" Then response.write "selected" End IF%>>2019</option>
    </select>
    <span id="sel_fnd_Country">
    <select name="fnd_Country" id="fnd_Country" class="title_select">
      <option value="" selected>국가</option>
    </select></span>  
            <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" placeholder="대회명, 대회명영문, 도시, 대회장소" class="ipt-word">
          <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a>
          <a href="javascript:chk_Submit('ALL','',1);" class="btn btn-blue-empty">전체목록</a>
          <a href="./GameTitleIntl_Write.asp" class="btn btn-add">국제대회 등록</a>
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
<!-- E : content GameTitleIntl_List -->

<!--#include file="../include/footer.asp"-->
