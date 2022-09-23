<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim SDate         : SDate         = fInject(Request("SDate"))
  dim EDate         : EDate         = fInject(Request("EDate")) 
  dim fnd_KeyWord   : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))  
%>
<script language="javascript">
  var locationStr = "";

  //검색
  function chk_Submit(valType, valIDX, chkPage){
  
    var strAjaxUrl = '../Ajax/User_List.asp';    
    var SDate = $('#SDate').val();
    var EDate = $('#EDate').val();
    var fnd_KeyWord = $('#fnd_KeyWord').val();
    
    if(chkPage!='') $('#currPage').val(chkPage);
    
    var currPage = $('#currPage').val();
    
    if(valType=='VIEW'){
      $('#CIDX').val(valIDX);   
      
      $('form[name=s_frm]').attr('action','./User_Mod.asp');
      $('form[name=s_frm]').submit(); 
    }
    else{ 
      //전체검색
      if(valType=='ALL') {
        currPage = '';
        SDate = '';
        EDate = '';
        fnd_KeyWord = '';

        $('#SDate').val('');
        $('#EDate').val('');
        $('#fnd_KeyWord').val('');        
        $('#currPage').val('');
      }
    
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',     
        data: { 
          currPage          : currPage     
          ,SDate            : SDate
          ,EDate          : EDate
          ,fnd_KeyWord        : fnd_KeyWord           
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
    chk_Submit('ALL', '', '');    
  });
</script>
<!-- S : content -->
<section class="list_conten_box">
  <div id="content">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>회원목록</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>홈페이지관리</li>
            <li>온라인 회원관리</li>
            <li>회원목록</li>
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
            <span class="tit">가입일</span>
            <input type="date" name="SDate" id="SDate" maxlength="10" class="date_ipt" value="<%=SDate%>" <%IF SDate="" Then%> placeholder="2017-07-01"<%End IF%>>
            <span class="divn">-</span>
            <input type="date" name="EDate" id="EDate" maxlength="10" class="date_ipt" value="<%=EDate%>" <%IF EDate="" Then%> placeholder="2017-07-01"<%End IF%>>

            <!--<a href="#" class="btn btn-close" data-dismiss="modal">X</a>-->
            
            <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" class="ipt-word" value="<%=fnd_KeyWord%>" placeholder="회원명, 생년월일, 아이디, 전화번호, 이메일">
            <!--<div id="div_InfoKeyWord">키워드 검색 [회원명, 생년월일, 아이디, 전화번호, 이메일]</div>-->
          <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a> <a href="javascript:chk_Submit('ALL','',1);" class="btn btn-blue-empty">전체목록</a>
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
</section>
<!-- E : content -->
<!-- E : container -->
<!--#include file="../include/footer.asp"-->
