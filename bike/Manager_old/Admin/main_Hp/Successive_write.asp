<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
  dim CIDX      : CIDX      = crypt.DecryptStringENC(fInject(Request("CIDX")))
  dim currPage    : currPage      = fInject(Request("currPage"))
    dim fnd_AssoCode    : fnd_AssoCode  = fInject(Request("fnd_AssoCode"))   
  dim fnd_KeyWord     : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))   
    dim fnd_ViewYN    : fnd_ViewYN    = fInject(Request("fnd_ViewYN"))
   
  dim CSQL, CRs
  dim AssoCode, AssoNm, SuccessiveNm, DatePeriod, DatePeriodStart, ViewYN, Orderby
    
  IF CIDX <> "" Then
  
    CSQL = "    SELECT A.CateSuccessiveIDX"
    CSQL = CSQL & "   ,A.AssoCode"
    CSQL = CSQL & "   ,B.AssoNm"
    CSQL = CSQL & "   ,A.SuccessiveNm"
    CSQL = CSQL & "   ,A.DatePeriod"
    CSQL = CSQL & "   ,A.DatePeriodStart"
    CSQL = CSQL & "   ,A.Orderby"
    CSQL = CSQL & "   ,A.ViewYN"   
    CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblCateSuccessive] A"
    CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblAssociationInfo] B on A.AssoCode = B.AssoCode"
    CSQL = CSQL & "     AND B.DelYN = 'N' " 
    CSQL = CSQL & " WHERE A.DelYN = 'N' "
    CSQL = CSQL & "   AND CateSuccessiveIDX = '"&CIDX&"'"
    
    SET CRs = DBCon.Execute(CSQL)   
    IF Not(CRs.eof or CRs.bof) Then
      AssoCode = CRs("AssoCode")
      AssoNm = ReHtmlSpecialChars(CRs("AssoNm"))
      SuccessiveNm = ReHtmlSpecialChars(CRs("SuccessiveNm"))
      DatePeriod = ReHtmlSpecialChars(CRs("DatePeriod"))
      DatePeriodStart = ReHtmlSpecialChars(CRs("DatePeriodStart"))
      Orderby = CRs("Orderby")
      ViewYN = CRs("ViewYN")
    Else
      response.write "<script>alert('일치하는 정보가 없습니다.'); history.back();</script>"
      response.end
    End IF
      CRs.Close
    SET CRs = Nothing
    
  End IF
  
%>
<script language="javascript">
  /**
   * left-menu 체크
   */
  var locationStr = "association_membership"; // 임원현황
  /* left-menu 체크 */
  
  function chk_Submit(valType){
    
    if(valType=='DEL'){
      if(confirm('선택하신 정보를 삭제하시겠습니까?')) {
        on_Submit(valType);
      }
      else{return;}
    }
    else if(valType=='MOD' || valType=='SAVE'){
      on_Submit(valType); 
    }
    else if(valType=='LIST'){
      $('form[name=s_frm]').attr('action','./successive_list.asp');
          $('form[name=s_frm]').submit(); 
    }
    else{
      window.history.back();    
    }
  }
  
  function on_Submit(valType){
    if(valType=='MOD' || valType=='SAVE'){
      if(!$('#AssoCode').val()){
        alert('협회를 선택해 주세요.');
        $('#AssoCode').focus();
        return;
      }

      if(!$('#SuccessiveNm').val()){
        alert('역대타이틀 명을 입력해 주세요.');
        $('#SuccessiveNm').focus();
        return;
      }

      if(!$('#DatePeriod').val()){
        alert('재임기간을 입력해 주세요.');
        $('#DatePeriod').focus();
        return;
      }
      /*  
      if(!$('#DatePeriodStart').val()){
        alert('취임일자를 입력해 주세요.');
        $('#DatePeriodStart').focus();
        return;
      }
      */
      if(!$('input:radio[name=ViewYN]').is(':checked')){
        alert("노출여부를 선택해 주세요."); 
        return;
      }

      if(!$('#Orderby').val()){
        alert('정렬순서를 입력해 주세요.(오름차순으로 정렬됩니다.)');
        $('#Orderby').focus();
        return;
      }
    }
    var strAjaxUrl    = '../ajax/successive_write.asp';
    var SuccessiveNm  = $('#SuccessiveNm').val();
    var DatePeriod    = $('#DatePeriod').val();
    var DatePeriodStart = $('#DatePeriodStart').val();
    var ViewYN      = $('input:radio[name=ViewYN]:checked').val();
    var Orderby     = $('#Orderby').val();
    var CIDX      = $('#CIDX').val();
    var AssoCode    = $('#AssoCode').val();
    
    var msg = '';
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: { 
        CIDX        : CIDX 
        ,SuccessiveNm     : SuccessiveNm 
        ,DatePeriod     : DatePeriod 
        ,DatePeriodStart  : DatePeriodStart 
        ,ViewYN       : ViewYN 
        ,Orderby      : Orderby
        ,AssoCode       : AssoCode 
        ,valType      : valType 
      },    
      success: function(retDATA) {

        //console.log(retDATA);

        if(retDATA){
          var strcut = retDATA.split('|');

          if (strcut[0] == 'TRUE') {
            switch(strcut[1]){
              case '80' : msg='정보를 성공적으로 수정하였습니다.'; break;
              case '70' : msg='정보를 성공적으로 삭제하였습니다.'; break;  
              default   : msg='정보를 성공적으로 등록되었습니다.' //90
            }
            alert(msg);
            $('form[name=s_frm]').attr('action','./successive_list.asp');
            $('form[name=s_frm]').submit(); 
          }
          else{  //FALSE|
            switch(strcut[1]){
              case '99' : msg='일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
              case '88' : msg='동일한 역대타이틀명이 존재합니다.\n확인 후 다시 이용하세요.'; $('#AssoNm').focus(); break;  
              case '66' : msg='정보 등록에 실패하였습니다.\n시스템관리자에게 문의하십시오!'; break;
              case '33' : msg='정보 수정에 실패하였습니다.\n시스템관리자에게 문의하십시오!'; break; 
              case '11' : msg='정보 삭제에 실패하였습니다.\n시스템관리자에게 문의하십시오!'; break;   
              default   : msg='잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
            }
            alert(msg);
            return;
          }
        }
      }, 
      error: function(xhr, status, error){           
        if(error!=''){
          alert('오류발생! - 시스템관리자에게 문의하십시오!');     
          return;
        }
      }
    }); 
  } 
  
  $(document).ready(function(){ 
    //협회정보 make:select box 
    make_box('sel_AssoCode', 'AssoCode', '<%IF CIDX <> "" Then response.write AssoCode Else response.write fnd_AssoCode End IF%>', 'Info_AssoCode');    
  });
</script> 
<!-- S : content -->
  <div id="content" class="successive_write">
        <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>역대타이틀정보 등록/수정</h2>
      <a href="./Successive_list.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

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
          <li><a href="./Successive_wriet.asp">역대타이틀정보 등록/수정</a></li>
        </ul>
      </div>
      <!-- E: 네비게이션 -->

    </div>
    <!-- E: page_title -->

    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" name="CIDX" id="CIDX" value="<%=fInject(Request("CIDX"))%>" />
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="fnd_AssoCode" id="fnd_AssoCode" value="<%=fnd_AssoCode%>" />
    <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
    <input type="hidden" name="fnd_ViewYN" id="fnd_ViewYN" value="<%=fnd_ViewYN%>" />
    
          <table class="left-head view-table succ_write">
            <tr>
              <th>협회명</th>
              <td id="sel_AssoCode">
                <div class="con">
                  <select name="AssoCode" id="AssoCode">
                    <option value=''>:: 협회 선택 ::</option>
                  </select>
                </div>
              </td>
            </tr>
            <tr>
              <th>역대타이틀명</th>
              <td>
                <div class="con">
                  <input type="text" name="SuccessiveNm" id="SuccessiveNm" class="in_1" value="<%=SuccessiveNm%>" placeholder=" ex) 27대" />
                </div>
              </td>
            </tr>
            <tr>
              <th>재임기간</th>
              <td>
                <div class="con">
                  <input type="text" name="DatePeriod" id="DatePeriod" class="in_1" value="<%=DatePeriod%>" placeholder="ex) 2016.08.04 ~ 현재">
                </div>
              </td>
            </tr>
            <tr>
              <th>취임일자</th>
              <td>
                <div class="con">
                  <input type="text" name="DatePeriodStart" id="DatePeriodStart" class="in_1" value="<%=DatePeriodStart%>" placeholder="ex) 2016.08.04">
                </div>
              </td>
            </tr>
            <tr>
              <th>노출구분</th>
              <td>
                <label>
                  <input type="radio" name="ViewYN" id="ViewYN" value="Y" <%IF ViewYN = "Y" Then response.write "checked" End IF%> > 노출</label>
                <label>
                  <input type="radio" name="ViewYN" id="ViewYN" value="N" <%IF ViewYN = "N" Then response.write "checked" End IF%> > 노출 안함</label>
              </td>
            </tr>
            <tr class="tiny-line">
              <th>순서</th>
              <td>
                <div class="con">
                  <input type="text" name="Orderby" id="Orderby" value="<%=Orderby%>" placeholder="내림차순으로 정렬합니다." onKeyUp="chk_InputValue(this, 'Digit');">
                </div>
              </td>
            </tr>
          </table>

        <!-- S: btn-list-center -->
        <%IF CIDX<>"" Then%>
        <div class="btn-list-center"> <a href="javascript:chk_Submit('MOD');" class="btn btn-confirm">수정</a> <a href="javascript:chk_Submit('DEL');" class="btn btn-red">삭제</a> <a href="javascript:chk_Submit('CANCEL');" class="btn btn-cancel">취소</a> <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a> </div>
        <%Else%>
        <div class="btn-list-center">
          <a href="javascript:chk_Submit('SAVE');" class="btn btn-confirm">등록</a> <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a>
        </div>
        <%End IF%>
        <!-- E: btn-list-center -->
  
    </form>
    <!-- E : sch 검색조건 선택 및 입력 --> 
  </div>
</section>
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../include/footer.asp"-->