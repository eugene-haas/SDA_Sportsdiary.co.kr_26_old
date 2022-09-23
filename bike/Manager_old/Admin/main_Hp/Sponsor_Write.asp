<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
  dim currPage        : currPage      = fInject(Request("currPage"))
  dim fnd_KeyWord     : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
  dim fnd_UseYN     : fnd_UseYN     = fInject(Request("fnd_UseYN"))
  dim fnd_SponType    : fnd_SponType  = fInject(Request("fnd_SponType"))   
  dim CIDX      : CIDX      = fInject(Request("CIDX"))
  
  dim CSQL, CRs
  dim Subject, SponImage, SponLink, SponUseYN, SponSort, SponType
    
  IF CIDX <> "" Then
  
    CSQL = "    SELECT * "
    CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblSponsorManage]"
    CSQL = CSQL & " WHERE DelYN = 'N'"
    CSQL = CSQL & "   AND SponsorIDX = '"&CIDX&"'"
    
    SET CRs = DBCon.Execute(CSQL)   
    IF Not(CRs.eof or CRs.bof) Then
      Subject = CRs("Subject")
      SponImage = CRs("SponImage")
      SponLink = CRs("SponLink")
      SponUseYN = CRs("SponUseYN")
      SponSort = CRs("SponSort")
      SponType = CRs("SponType")
    End IF
      CRs.Close
    SET CRs = Nothing
    
  End IF
  
%>

<script language="javascript">
  /**
   * left-menu 체크
   */
  var locationStr = "Sponsor_List"; // 임원현황
  /* left-menu 체크 */

  function chk_Submit(valType){
    
    if(valType=="DEL"){
      if(confirm("후원사 정보를 삭제하시겠습니까?"))  {
        on_Submit(valType);
      }
      else{return;}
    }
    else if(valType=="MOD" || valType=="SAVE"){
      on_Submit(valType); 
    }
    else if(valType=="LIST"){
      $(location).attr('href', "./Sponsor_List.asp");
    }
    else{
      window.history.back();    
    }
  }
  
  function on_Submit(valType){
    var formData = new FormData();
    var strAjaxUrl = "../Ajax/Sponsor_Write.asp";
    
    if(valType=="MOD" || valType=="SAVE"){
      
      if(!$('#Subject').val()){
        alert("제목을 입력해 주세요.");
        $('#Subject').focus();
        return;
      }
      
      /*
      if(!$('#SponImage').val()){
        alert("후원사 로고이미지를 선택해 주세요.");
        $('#SponImage').focus();
        return;
      }
      
      
      if(!$('#SponLink').val()){
        alert("후원사 링크주소를 입력해 주세요.");
        $('#SponLink').focus();
        return;
      }     
      */
      
      if(!$('input:radio[name=SponUseYN]').is(':checked')){
        alert("후원사 노출여부를 선택해 주세요."); 
        return;
      }
            
      var Del_SponImageYN = '';
      
      if($("#Del_SponImage").is(":checked") == true){ Del_SponImageYN = "Y"}
      else{ Del_SponImageYN = "N"}
      
      formData.append("Subject", $("#Subject").val());
      formData.append("SponLink", $("#SponLink").val());
      formData.append("SponUseYN", $('input:radio[name=SponUseYN]:checked').val());     
      formData.append("SponSort", $("#SponSort").val());
      formData.append("SponType", $("#SponType").val());
      formData.append("Del_SponImageYN", Del_SponImageYN);            
      if($("#SponImage").val()){ formData.append("SponImage", $("input[name=SponImage]")[0].files[0]);}
    }
    
    formData.append("CIDX", $("#CIDX").val());
    formData.append("valType", valType);
    
    var msg = '';
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      data: formData, 
      processData: false,
      contentType: false,    
      success: function(retDATA) {
        
        console.log(retDATA);
        
        if(retDATA){
        
          var strcut = retDATA.split("|");
          
          if (strcut[0] == "TRUE") {
            
            switch (strcut[1]) { 
              case '90'  : msg = "후원사정보를 등록완료하였습니다."; break;
              case '80'   : msg = "후원사정보를 수정완료하였습니다."; break;
              case '70'   : msg = "후원사정보를 삭제완료하였습니다."; break;
              default :
            }           
            alert(msg);
            
            $('form[name=s_frm]').attr('action',"./Sponsor_List.asp");
            $('form[name=s_frm]').submit(); 
          }
          else{  //FALSE|
            
            switch (strcut[1]) { 
              case '200'  : msg = "잘못된 접근입니다.\n확인 후 다시 이용하세요."; break;
              case '99'   : msg = "일치하는 정보가 없습니다.\n확인 후 다시 이용하세요."; break;
              case '66'   : msg = "후원사등록에 실패하였습니다.\n관리자에게 문의하세요."; break;
              case '33'   : msg = "이미지파일만 업로드 가능합니다."; break;
              default :
            }           
            alert(msg);
            return;           
          }
        }
      }, 
      error: function(xhr, status, error){           
        if(error!=""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
          return;
        }
      }
    }); 
  }
  
  $(document).ready(function(){
    
    make_box('sel_SponType','SponType','<%=SponType%>','Info_SponType');  //후원사 셀렉트박스 생성
        
    });
</script>
<!-- S : content sponsor_write -->
  <div id="content" class="sponsor_write">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>후원사 관리</h2>
        <a href="./Sponsor_List.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>홈페이지관리</li>
            <li>메인</li>
            <li><a href="./Sponsor_List.asp">후원사관리</a></li>
            <li><a href="./Sponsor_Write.asp">후원사 상세내역</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
     <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
     <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
     <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
   <input type="hidden" name="fnd_SponType" id="fnd_SponType" value="<%=fnd_SponType%>" />
     <input type="hidden" name="fnd_UseYN" id="fnd_UseYN" value="<%=fnd_UseYN%>" />
     
        <table class="left-head view-table">
          <tr class="short-line">
            <th>구분</th>
            <td><p id="sel_SponType" class="con">
            <select name="SponType" id="SponType" class="">
              <option value="">:: 후원사 구분 선택 ::</option>
            </select>
          </p></td>
          </tr>
    <tr class="short-line">
            <th>제목</th>
            <td>
              <span class="con">
                <input type="text" name="Subject" id="Subject" value="<%=Subject%>">
              </span>
            </td>
          </tr>
          
          <tr>
            <th>후원사 노출여부</th>
            <td>
              <label>
                <input type="radio" name="SponUseYN" id="SponUseYN" value="Y" <%IF SponUseYN = "Y" Then response.write "checked" End IF%> > 노출함
              </label>
              <label>
                <input type="radio" name="SponUseYN" id="SponUseYN" value="N" <%IF SponUseYN = "N" Then response.write "checked" End IF%> > 노출안함
              </label>
            </td>
          </tr>
          <tr class="file-line">
            <th>로고이미지</th>
            <td><input type="file" name="SponImage" id="SponImage"> 
      <%
        IF SponImage <> "" Then 
        response.Write "<div class='added-list'>"
        response.Write SponImage 
          response.Write "<span><input type='checkbox' name='Del_SponImage' id='Del_SponImage'>삭제시 체크</span>" 
        response.Write "</div>"
      End IF
      %>
              <div class="guide-txt">로고이미지 사이즈 220px(W) * 89px(H)</div>
              </td>
          </tr>
          <tr class="half-line">
            <th>링크주소</th>
            <td>
              <span class="con">
                <input type="text" name="SponLink" id="SponLink" value="<%=SponLink%>">
              </span>
            </td>
          </tr>
          <tr class="tiny-line">
            <th>정렬</th>
            <td>
              <span class="con"><input type="text" name="SponSort" id="SponSort" value="<%=SponSort%>" onkeyup='chk_InputValue(this, "Digit")'></span>
              <p class="guide-txt">입력값이 높을 수록 앞에 위치합니다.</p></td>
          </tr>
         
        </table>

        <!-- S: btn-list-center -->
        <%IF CIDX<>"" Then%>
        <div class="btn-list-center"> 
          <a href="javascript:chk_Submit('MOD');" class="btn btn-confirm">수정</a> 
          <a href="javascript:chk_Submit('DEL');" class="btn btn-red">삭제</a> 
            <a href="javascript:chk_Submit('CANCEL');" class="btn btn-cancel">취소</a> 
          <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a> 
        </div>
        <%Else%>
        
        <div class="btn-list-center"> 
            <a href="javascript:chk_Submit('SAVE');" class="btn">등록</a> 
            <a href="javascript:chk_Submit('LIST');" class="btn">목록</a> 
        </div>
        <%End IF%>
        <!-- E: btn-list-center -->

    </form>
    <!-- E : sch 검색조건 선택 및 입력 -->
  </div>
<!-- E : content sponsor_write -->
<!--#include file="../include/footer.asp"-->

