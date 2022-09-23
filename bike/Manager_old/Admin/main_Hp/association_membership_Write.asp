<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
    Check_AdminLogin()
   
  dim CIDX      : CIDX        = crypt.DecryptStringENC(fInject(Request("CIDX")))
  dim currPage    : currPage        = fInject(Request("currPage"))
  dim fnd_AssoCode    : fnd_AssoCode    = fInject(Request("fnd_AssoCode"))  
  dim fnd_Successive  : fnd_Successive    = fInject(Request("fnd_Successive"))  
  dim fnd_KeyWord     : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))   
    dim fnd_ViewYN    : fnd_ViewYN      = fInject(Request("fnd_ViewYN"))       
   
  dim CSQL, CRs
  dim AssoCode, CateSuccessiveIDX, CateOfficersIDX, UserName, UserBirth, UserCompanyNm, UserCompanyLevel, ImgProfile, ViewYN
    
  IF CIDX <> "" Then
  
    CSQL = "    SELECT AssoOfficersIDX"
    CSQL = CSQL & "   ,AssoCode"
    CSQL = CSQL & "   ,CateSuccessiveIDX"
    CSQL = CSQL & "   ,CateOfficersIDX"
    CSQL = CSQL & "   ,UserName"
	CSQL = CSQL & "   ,UserBirth"
    CSQL = CSQL & "   ,UserCompanyNm"
    CSQL = CSQL & "   ,UserCompanyLevel"
    CSQL = CSQL & "   ,ImgProfile"
    CSQL = CSQL & "   ,ViewYN"
    CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblAssoOfficers] "
    CSQL = CSQL & " WHERE DelYN = 'N'"
    CSQL = CSQL & "   AND AssoOfficersIDX = '"&CIDX&"'"
    
    SET CRs = DBCon.Execute(CSQL)   
    IF Not(CRs.eof or CRs.bof) Then
      AssoCode = CRs("AssoCode")
      CateSuccessiveIDX = CRs("CateSuccessiveIDX")
      CateOfficersIDX = CRs("CateOfficersIDX")
	  UserBirth = CRs("UserBirth")	
      UserName = ReHtmlSpecialChars(CRs("UserName"))
      UserCompanyNm = ReHtmlSpecialChars(CRs("UserCompanyNm"))
      UserCompanyLevel = ReHtmlSpecialChars(CRs("UserCompanyLevel"))
      ImgProfile = CRs("ImgProfile")
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
      $('form[name=s_frm]').attr('action','./association_membership.asp');
          $('form[name=s_frm]').submit(); 
    }
    else{
      window.history.back();    
    }
  }
  
  function on_Submit(valType){
    var formData = new FormData();
    var strAjaxUrl = '../Ajax/association_membership_Write.asp';
    var Del_ImgProfile='';
    
    if(valType=='MOD' || valType=='SAVE'){    
      if(!$('#AssoCode').val()){
        alert('협회를 선택해 주세요.');
        $('#AssoCode').focus();
        return;
      }

      if(!$('#Successive').val()){
        alert('역대타이틀을 선택해 주세요.');
        $('#Successive').focus();
        return;
      }

      if(!$('#SuccAsso').val()){
        alert('임원직책을 선택해 주세요.');
        $('#SuccAsso').focus();
        return;
      }

      if(!$('#UserName').val()){
        alert('이름을 입력해 주세요.');
        $('#UserName').focus();
        return;
      }
		
	  if(!$('#UserBirth').val()){
        alert('생년월일을 입력해 주세요.');
        $('#UserBirth').focus();
        return;
      }	
	  else{
		  if($('#UserBirth').val().length<8){
				alert("생년월일을 정확히 입력해 주세요");
				$('#UserBirth').focus();
				return;
			}
			else{
				var data = $('#UserBirth').val();
				
				var y = parseInt(data.substr(0, 4), 10); 
				var m = parseInt(data.substr(4, 2), 10); 
				var d = parseInt(data.substr(6, 2), 10); 
				
				var dt = new Date(y, m-1, d); 
				
				if(dt.getDate() != d) { alert("생년월일 일이 유효하지 않습니다"); $('#UserBirth').focus(); return;} 
				else if(dt.getMonth()+1 != m) { alert("생년월일 월이 유효하지 않습니다."); $('#UserBirth').focus(); return;} 
				else if(dt.getFullYear() != y) { alert("생년월일 년도가 유효하지 않습니다."); $('#UserBirth').focus(); return;} 
				else {$('#UserPhone1').focus();}    
			}
		  
	  }
      /*
      if(!$('#UserCompanyNm').val()){
        alert('재직기업을 입력해 주세요.');
        $('#UserCompanyNm').focus();
        return;
      }

      if(!$('#UserCompanyLevel').val()){
        alert('직책을 입력해 주세요.');
        $('#UserCompanyLevel').focus();
        return;
      }
      */
      <%IF ImgProfile = "" Then%>
      if(!$('#ImgProfile').val()){
        alert('프로필 이미지를 선택해 주세요.');
        $('#ImgProfile').focus();
        return;
      }
      <%
      Else
      %>
      if($("#Del_ImgProfile").is(":checked")==true){ Del_ImgProfile = "Y";}
      else{ Del_ImgProfile = "N";}  
      <%
      End IF
      %>
      
      if(!$('input:radio[name=ViewYN]').is(':checked')){
        alert("노출여부를 선택해 주세요."); 
        return;
      }
      
      
      
      formData.append('AssoCode', $('#AssoCode').val());
      formData.append('CateSuccessiveIDX', $('#Successive').val());
      formData.append('CateOfficersIDX', $('#SuccAsso').val());
      formData.append('UserName', $('#UserName').val());
	  formData.append('UserBirth', $('#UserBirth').val());	
      formData.append('UserCompanyNm', $('#UserCompanyNm').val());
      formData.append('UserCompanyLevel', $('#UserCompanyLevel').val());
      formData.append('ViewYN', $('input:radio[name=ViewYN]:checked').val());
      formData.append("Del_ImgProfile", Del_ImgProfile);            
      
      if($("#ImgProfile").val()){ 
        formData.append("ImgProfile", $("input[name=ImgProfile]")[0].files[0]);
      }
    }
    
    formData.append('CIDX', $('#CIDX').val());  
    formData.append('valType', valType);
    
    var msg = '';
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      data: formData, 
      processData: false,
      contentType: false,    
      success: function(retDATA) {

        //console.log(retDATA);
        
        if(retDATA){
        
          var strcut = retDATA.split('|');
          
          if (strcut[0] == 'TRUE') {
            
            switch (strcut[1]) { 
              case '80'   : msg = '정보를 수정완료하였습니다.'; break;
              case '70'   : msg = '정보를 삭제완료하였습니다.'; break;
              default   : msg = '정보를 등록완료하였습니다.'; //90
            }           
            alert(msg);
            
            $('form[name=s_frm]').attr('action','./association_membership.asp');
            $('form[name=s_frm]').submit(); 
          }
          else{  //FALSE|
            
            switch (strcut[1]) { 
              case '99'   : msg = '일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
              case '66'   : msg = '정보등록에 실패하였습니다.\n관리자에게 문의하세요.'; break;
              case '33'   : msg = '이미지파일만 업로드 가능합니다.'; break;
              default   : msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
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
  
  //협회선택 Select Box Change
  $(document).on('change', '#AssoCode', function(){ 
    make_box('sel_Successive', 'Successive', $('#AssoCode').val()+',', 'Info_Successive');  //역대타이틀 정보 
    
    $.when( $.ajax(make_box('sel_Successive', 'Successive', $('#AssoCode').val()+',', 'Info_Successive'))).then(function() {  
      make_box('sel_SuccAsso', 'SuccAsso', $('#AssoCode').val()+','+$('#Successive').val()+',<%=CateOfficersIDX%>', 'Info_SuccAsso');     //임원직책 정보 
    });
  }); 
  
  //역대타이틀 선택 Select Box Change
  $(document).on('change', '#Successive', function(){ 
    make_box('sel_SuccAsso', 'SuccAsso', $('#AssoCode').val()+','+$('#Successive').val()+',<%=CateOfficersIDX%>', 'Info_SuccAsso');     //임원직책 정보     
  }); 
           
  $(document).ready(function(){ 
    //make:select box 
    make_box('sel_AssoCode', 'AssoCode', '<%IF CIDX<>"" Then response.write AssoCode Else response.write fnd_AssoCode End IF%>', 'Info_AssoCode');          //협회정보 
    
    
    $.when( $.ajax(make_box('sel_AssoCode', 'AssoCode', '<%IF CIDX<>"" Then response.write AssoCode Else response.write fnd_AssoCode End IF%>', 'Info_AssoCode'))).then(function() {
      make_box('sel_Successive', 'Successive', $('#AssoCode').val()+',<%IF CIDX<>"" Then response.write CateSuccessiveIDX Else response.write fnd_Successive End IF%>', 'Info_Successive'); //역대타이틀 정보 
      
      $.when( $.ajax(make_box('sel_Successive', 'Successive', $('#AssoCode').val()+',<%IF CIDX<>"" Then response.write CateSuccessiveIDX Else response.write fnd_Successive End IF%>', 'Info_Successive'))).then(function() { 
        make_box('sel_SuccAsso', 'SuccAsso', $('#AssoCode').val()+','+$('#Successive').val()+',<%=CateOfficersIDX%>', 'Info_SuccAsso');     //임원직책 정보 
      });   
    });     
  }); 
</script>
<!-- S : content -->
  <div id="content" class="association_write">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>임원등록정보</h2>
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
            <li><a href="./association_membership_Write.asp">임원등록정보</a></li>
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
    <input type="hidden" name="fnd_Successive" id="fnd_Successive" value="<%=fnd_Successive%>" />
    <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
    <input type="hidden" name="fnd_ViewYN" id="fnd_ViewYN" value="<%=fnd_ViewYN%>" />

          <table class="profile-table">
        
        <tr class="img-box">
        <%IF CIDX <> "" Then%>
          <th rowspan="9" valign="top">
        <%
        IF ImgProfile <> "" Then
          response.write "<img src='/FileTemp/"&ImgProfile&"' width='100' alt=''>"
        Else
          response.write "<img src='"&ImgDefault&"' width='100' alt=''>"
        End IF
        %></th>
        <%End IF%>    
              <th>협회</th>
              <td id="sel_AssoCode">
                  <select name="AssoCode" id="AssoCode">
                    <option value=''>:: 협회 선택 ::</option>
                  </select>
              </td>
            </tr>
      
        <tr>
          <th>역대타이틀</th>
              <td id="sel_Successive"><select name="Successive" id="Successive">
                  <option value=''>:: 역대타이틀 선택 ::</option>
                </select></td>
            </tr>
         <tr>
           <th>임원직책</th>
              <td id="sel_SuccAsso"><select name="SuccAsso" id="SuccAsso">
                  <option value=''>:: 임원직책 선택 ::</option>
                </select></td>
            </tr>
             <tr>
               <th>이름</th>
              <td>
                <div class="con">
                  <input type="text" name="UserName" id="UserName" class="in_1" value="<%=UserName%>">
                </div>
              </td>
            </tr>
			<tr>
               <th>생년월일</th>
              <td>
                <div class="con">
                  <input type="text" name="UserBirth" id="UserBirth" class="in_1" value="<%=UserBirth%>" maxlength="8" onKeyUp="chk_InputValue(this, 'Digit');" oninput="maxLengthCheck(this);" />
                <span class="right_text">8자리 (예) 19801234</span></div>
              </td>
            </tr>  
      <tr>
        <th>재직기업명</th>
              <td>
                <div class="con">
                  <input type="text" name="UserCompanyNm" id="UserCompanyNm" value="<%=UserCompanyNm%>">
                </div>
              </td>
            </tr>  
            <tr>
              <th>직책</th>
              <td>
                <div class="con">
                  <input type="text" name="UserCompanyLevel" id="UserCompanyLevel" value="<%=UserCompanyLevel%>">
                </div>
              </td>
            </tr>  
       <tr>
         <th>프로파일 이미지</th>
              <td><input type="file" name="ImgProfile" id="ImgProfile" class="in_1" /><%
        IF ImgProfile <> "" Then 
          response.Write "<div class='added-list'>"
          response.Write ImgProfile 
          response.Write "<span><input type='checkbox' name='Del_ImgProfile' id='Del_ImgProfile'>삭제시 체크</span>" 
          response.Write "</div>"
        End IF
      %></td>
            </tr>   
            <tr>
              <th>노출구분</th>
              <td>
                <label>
                  <input type="radio" name="ViewYN" id="ViewYN" value="Y" <%IF ViewYN = "Y" Then response.write "checked" End IF%> >노출
                </label>
                <label>
                  <input type="radio" name="ViewYN" id="ViewYN" value="N" <%IF ViewYN = "N" Then response.write "checked" End IF%> >노출 안함
                </label>
                </td>
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
            <a href="javascript:chk_Submit('SAVE');" class="btn btn-confirm">등록</a> 
            <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a> 
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

