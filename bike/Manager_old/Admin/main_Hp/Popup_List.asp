<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim SDate         : SDate         = fInject(Request("SDate"))
  dim EDate         : EDate         = fInject(Request("EDate")) 
  dim fnd_PUseYN    : fnd_PUseYN    = fInject(Request("fnd_PUseYN"))
  dim fnd_KeyWord   : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
  dim fnd_PViewYN   : fnd_PViewYN   = fInject(Request("fnd_PViewYN"))
  
%>
<script language="javascript">

  //검색
  function chk_Submit(valType, valIDX, chkPage){

    var strAjaxUrl = '../Ajax/Popup_List.asp';    
    //    var SDate = $('#SDate').val();
    //    var EDate = $('#EDate').val();
    var fnd_KeyWord = $('#fnd_KeyWord').val();
    var fnd_PUseYN = $('#fnd_PUseYN').val();
    var fnd_PViewYN = $('#fnd_PViewYN').val();


    if(chkPage!='') $('#currPage').val(chkPage);

    var currPage = $('#currPage').val();

    if(valType=='VIEW'){
      $('#CIDX').val(valIDX);   

      $('form[name=s_frm]').attr('action','./Popup_Write.asp');
      $('form[name=s_frm]').submit(); 
    }
    else{ 
      //전체검색
      if(valType=='ALL') {
        currPage = '';
        //SDate = '';
        //EDate = '';
        fnd_KeyWord = '';
        fnd_PUseYN = '';
        fnd_PViewYN = '';

        //$('#SDate').val('');
        //$('#EDate').val('');
        $('#fnd_KeyWord').val('');
        $('#fnd_PUseYN').val('');
        $('#fnd_PViewYN').val('');
        $('#currPage').val('');
      }

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',     
        data: { 
          currPage      : currPage     
    //          ,SDate          : SDate
    //          ,EDate          : EDate
          ,fnd_KeyWord    : fnd_KeyWord  
          ,fnd_PUseYN     : fnd_PUseYN
          ,fnd_PViewYN    : fnd_PViewYN
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
    chk_Submit('', '', 1);    
  });
</script> 
<!-- S : content -->
  <div id="content" class="popup_list">
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>팝업 관리</h2>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>홈페이지관리</li>
          <li><a href="#">메인</a></li>
          <li>팝업관리</li>
        </ul>
      </div>
      <!-- E: 네비게이션 -->
      </div>
      <!-- E: page_title -->

    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
      <input type="hidden" id="CIDX" name="CIDX" class="user_list_input" />
      <div class="search_top">
        <div class="search_box">
          <select name="fnd_PViewYN" id="fnd_PViewYN" class="title_select">
              <option value="">===출력구분===</option>
              <option value="Y" <%IF fnd_PViewYN = "Y" Then response.Write "selected" End IF%>>ON</option>
              <option value="N" <%IF fnd_PViewYN = "N" Then response.Write "selected" End IF%>>OFF</option>
            </select>

            <select name="fnd_PUseYN" id="fnd_PUseYN" class="title_select">
              <option value="">===사용구분===</option>
              <option value="Y" <%IF fnd_PUseYN = "Y" Then response.Write "selected" End IF%>>사용</option>
              <option value="N" <%IF fnd_PUseYN = "N" Then response.Write "selected" End IF%>>사용안함</option>
            </select>
                
            <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" placeholder="키워드 검색 [제목, 내용]" class="ipt-word">
                 
            <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a>
            <a href="javascript:chk_Submit('ALL','',1);" class="btn btn-blue-empty">전체목록</a>
            <a href="./Popup_Write.asp" class="btn btn-add">팝업등록</a>
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
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../include/footer.asp"-->