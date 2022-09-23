<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
  dim currPage          : currPage          = fInject(Request("currPage"))
  dim SDate             : SDate             = fInject(Request("SDate"))
  dim EDate             : EDate             = fInject(Request("EDate")) 
  dim fnd_KeyWord       : fnd_KeyWord       = fInject(Request("fnd_KeyWord"))  
  dim fnd_TypeCertificate   : fnd_TypeCertificate   = fInject(Request("fnd_TypeCertificate"))   
  dim fnd_TypeUse       : fnd_TypeUse       = fInject(Request("fnd_TypeUse"))   
  dim fnd_TypeRecive      : fnd_TypeRecive      = fInject(Request("fnd_TypeRecive"))    
  dim fnd_TypeResult      : fnd_TypeResult      = fInject(Request("fnd_TypeResult")) 
%>
<script language="javascript">
  //검색
  function chk_Submit(valType, valIDX, chkPage){
    
    if(chkPage!='') $('#currPage').val(chkPage);
    
    var currPage = $('#currPage').val();
    
    if(valType=='VIEW'){
      $('#CIDX').val(valIDX);   
      
  //    $('form[name=s_frm]').attr('action','./cert_view.asp');
      $('form[name=s_frm]').attr('action','./cert_req_mod.asp');
      $('form[name=s_frm]').submit(); 
    }
    else{ 
      
      var strAjaxUrl = '../Ajax/cert_regist.asp';    
      var SDate = $('#SDate').val();
      var EDate = $('#EDate').val();
      var fnd_KeyWord = $('#fnd_KeyWord').val();
      var fnd_TypeCertificate = $('#fnd_TypeCertificate').val();
      var fnd_TypeUse = $('#fnd_TypeUse').val();
      var fnd_TypeRecive = $('#fnd_TypeRecive').val();
      var fnd_TypeResult = $('#fnd_TypeResult').val();
      
      //전체검색
      if(valType=='ALL') {
        SDate = '';
        EDate = '';
        currPage = '';
        fnd_KeyWord = '';
        fnd_TypeCertificate = '';
        fnd_TypeUse = '';
        fnd_TypeRecive = '';
        fnd_TypeResult = '';
        
        $('#SDate').val('');        
        $('#EDate').val('');        
        $('#currPage').val('');
        $('#fnd_KeyWord').val('');        
        $('#fnd_TypeCertificate').val('');        
        $('#fnd_KeyWord').val('');        
        $('#fnd_TypeRecive').val('');       
        $('#fnd_TypeResult').val('');       
      }

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',     
        data: { 
          currPage            : currPage     
          ,SDate              : SDate
          ,EDate            : EDate
          ,fnd_KeyWord          : fnd_KeyWord           
          ,fnd_TypeCertificate  : fnd_TypeCertificate           
          ,fnd_TypeUse          : fnd_TypeUse           
          ,fnd_TypeRecive       : fnd_TypeRecive            
          ,fnd_TypeResult       : fnd_TypeResult            
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
  
  //발급종류 | 발급용도 Radio Btn 생성 
  function makeBox_Req(valType, valCode){
    var strAjaxUrl = '../ajax/cert_req_Select.asp';
    
    console.log(valCode);
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        valType   : valType
        ,valCode  : valCode 
      }, 
      success: function(retDATA) {
        
        //console.log(retDATA);
        
        $('#div_'+valType).html(retDATA);       
      }, 
      error: function(xhr, status, error){           
        if(error!=''){
          alert ('오류발생! - 시스템관리자에게 문의하십시오!');     
          return;
        }
      }
    });
  }

  $(document).ready(function(){   
    makeBox_Req('TypeCertificate', '<%=fnd_TypeCertificate%>'); //발급종류    
    
    $.when( $.ajax(makeBox_Req('TypeCertificate', '<%=fnd_TypeCertificate%>'))).then(function() {
      makeBox_Req('TypeUse', '<%=fnd_TypeUse%>'); //발급용도        
    });
    
    $.when( $.ajax(makeBox_Req('TypeUse', '<%=fnd_TypeUse%>'))).then(function() {
      chk_Submit('', '', '');         
    });
    
  });
</script> 
<!-- S : content -->
  <div id="content" class="cert_regist">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>증명서 발급신청</h2>
        <!-- <a href="./Admin_List.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a> -->

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>홈페이지관리</li>
            <li>온라인서비스</li>
            <li><a href="./cert_regist.asp">증명서발급신청</a></li>
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

          <span id="div_TypeCertificate"></span>
          <span id="div_TypeUse"></span>
          <span><select name="fnd_TypeRecive" id="fnd_TypeRecive" class="title_select">
              <option value="">:: 수령방법 선택 ::</option>
              <option value="FAX" <%IF fnd_TypeRecive = "FAX" Then response.write "selected" End IF%>>팩스수령</option>
              <option value="VISIT" <%IF fnd_TypeRecive = "VISIT" Then response.write "selected" End IF%>>방문수령</option>
              <option value="POST" <%IF fnd_TypeRecive = "POST" Then response.write "selected" End IF%>>우편수령</option>
            </select>
          </span>
          <span><select name="fnd_TypeResult" id="fnd_TypeResult" class="title_select">
          <option value="">:: 처리상태 선택 ::</option>
                <option value="S" <%IF fnd_TypeResult = "S" Then response.write "selected" End IF%>>신청대기</option>
                <option value="P" <%IF fnd_TypeResult = "P" Then response.write "selected" End IF%>>처리중</option>
                <option value="R" <%IF fnd_TypeResult = "R" Then response.write "selected" End IF%>>발급완료</option>
                <option value="C" <%IF fnd_TypeResult = "C" Then response.write "selected" End IF%>>취소</option>
              </select>
            </span>

              <div class="req-date">
                <span class="sub-tit">신청일</span>
                <input type="date" name="SDate" id="SDate" maxlength="10" class="date_ipt" value="<%=SDate%>" <%IF SDate="" Then%> placeholder="2017-07-01"<%End IF%> />
                <span class="division">-</span>
                <input type="date" name="EDate" id="EDate" maxlength="10" class="date_ipt" value="<%=EDate%>" <%IF EDate="" Then%> placeholder="2017-07-01"<%End IF%>>
              </div>

               <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" class="ipt-word" value="<%=fnd_KeyWord%>" placeholder="검색 키워드[신청자/생년월일/전화번호]" >
                <a href="javascript:chk_Submit('FND','','1');" class="btn btn-search">검색</a> <a href="javascript:chk_Submit('ALL','','');" class="btn btn-blue-empty">전체목록</a>
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
<!-- E : content cert_regist --> 
<!--#include file="../include/footer.asp"-->