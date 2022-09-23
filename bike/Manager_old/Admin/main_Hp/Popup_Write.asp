<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
  dim currPage        : currPage      = fInject(Request("currPage"))
  dim SDate           : SDate         = fInject(Request("SDate"))
  dim EDate           : EDate         = fInject(Request("EDate")) 
  dim fnd_KeyWord     : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
  dim fnd_PUseYN    : fnd_PUseYN    = fInject(Request("fnd_PUseYN"))
  dim fnd_PViewYN     : fnd_PViewYN   = fInject(Request("fnd_PViewYN"))
  dim CIDX      : CIDX      = fInject(Request("CIDX"))
  
  dim CSQL, CRs
  dim Subject, PWidth, PHeight, PLeft, PTop, PZindex
  dim PSDate, PEDate, PContents, PUseYN, PDailyUseYN
  dim PDailyTxtColor, PDailyBgColor, PBackground, PBgColor, PBorderColor, PBorder

    
  IF CIDX <> "" Then
  
    CSQL = "    SELECT * "
    CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblPopupManage]"
    CSQL = CSQL & " WHERE DelYN = 'N'"
    CSQL = CSQL & "   AND PopIDX = '"&CIDX&"'"
    
    SET CRs = DBCon.Execute(CSQL)   
    IF Not(CRs.eof or CRs.bof) Then
      Subject = CRs("Subject")
      PWidth = CRs("PWidth")
      PHeight = CRs("PHeight")
      PLeft = CRs("PLeft")
      PTop = CRs("PTop")
      PSDate = CRs("SDate")
      PEDate = CRs("EDate")
      PContents = CRs("PContents")
      PUseYN = CRs("PUseYN")
      PDailyUseYN = CRs("PDailyUseYN")
      PZindex = CRs("PZindex")
      PDailyBgColor = CRs("PDailyBgColor")
      PDailyTxtColor = CRs("PDailyTxtColor")
      PBackground = CRs("PBackground")
      PBgColor = CRs("PBgColor")
      PBorder = CRs("PBorder")
      PBorderColor = CRs("PBorderColor")
      PZIndex = CRs("PZIndex")
    End IF
      CRs.Close
    SET CRs = Nothing
    
  End IF
  
%>
<script src="../js/jscolor.js"></script>
<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>
<script language="javascript">
  /**
   * left-menu 체크
   */
  var locationStr = "Popup_List"; // 팝업관리
  /* left-menu 체크 */

  // 스마트 에디터 사용시 제일 아래에 해당 코드를 넣어야 반영 됀다.
  
  
  function chk_Submit(valType){
    
    if(valType=='DEL'){
      if(confirm('팝업을 삭제하시겠습니까?'))  {
        on_Submit(valType);
      }
      else{return;}
    }
    else if(valType=='MOD' || valType=='SAVE'){
      on_Submit(valType); 
    }
    else if(valType=='LIST'){
      //$(location).attr('href', './Popup_List.asp');
      $('form[name=s_frm]').attr('action','./Popup_List.asp');
          $('form[name=s_frm]').submit(); 
    }
    else{
      window.history.back();    
    }
  }
  
  function on_Submit(valType){
    var formData = new FormData();
    var strAjaxUrl = '../Ajax/Popup_Write.asp';
    
    if(valType=='MOD' || valType=='SAVE'){      
      
      if(!$('#Subject').val()){
        alert('제목을 입력해 주세요.');
        $('#Subject').focus();
        return;
      }
      
      if(!$('#PWidth').val()){
        alert('팝업 가로사이즈를 입력해 주세요.');
        $('#PWidth').focus();
        return;
      }
      
      if(!$('#PHeight').val()){
        alert('팝업 세로사이즈를 입력해 주세요.');
        $('#PHeight').focus();
        return;
      }
      
      if(!$('#PLeft').val()){
        alert('팝업 위치 LEFT을 입력해 주세요.');
        $('#PLeft').focus();
        return;
      }
      
      if(!$('#PTop').val()){
        alert('팝업 위치 TOP을 입력해 주세요.');
        $('#PTop').focus();
        return;
      }
      
      if(!$('#PZindex').val()){
        alert('팝업 Z-index 값을 입력해 주세요. 입력 값이 높을 수록 앞에 위치됩니다.');
        $('#PZindex').focus();
        return;
      }
      
      if(!$('#PSDate').val()){
        alert('팝업 노출기간 시작일을 입력해 주세요.');
        $('#PSDate').focus();
        return;
      }
      
      if(!$('#PEDate').val()){
        alert('팝업 노출기간 마지막일을 입력해 주세요.');
        $('#PEDate').focus();
        return;
      }
      
      if(!$('input:radio[name=PUseYN]').is(':checked')){
        alert('팝업 노출여부를 선택해 주세요.'); 
        return;
      }
      
      if(!$('input:radio[name=PDailyUseYN]').is(':checked')){
        alert('하루동안 안보기 기능 사용여부를 선택해 주세요.'); 
        return;
      }
        
      
      var elClickedObj = $("#s_frm");
      
      oEditors.getById["PContents"].exec("UPDATE_CONTENTS_FIELD", []);
      
      var PContents = $("#PContents").val();
      
      if (PContents == '<p><br></p>') PContents = '';
      
      if(!PContents) {
        alert('팝업 내용을 입력해 주세요.');
        oEditors.getById["PContents"].exec("FOCUS");
        return;
      }
      
      // 스마트에디터 공란인데 <p><br></p> 가 들어가서 빈값을 <p><br></p> 로 잡아야 함
      // 빈값에 태그가 들어가서 값을 빈값으로 변경해줌
      
      
      var Del_PBackgroundYN = '';
      
      if($('#Del_PBackground').is(':checked') == true){ Del_PBackgroundYN = 'Y';} //백그라운드 이미지 삭제 체크박스       
      else{ Del_PBackgroundYN = 'N';}
      
      formData.append('Subject', $('#Subject').val());
      formData.append('PWidth', $('#PWidth').val());
      formData.append('PHeight', $('#PHeight').val());
      formData.append('PLeft', $('#PLeft').val());
      formData.append('PTop', $('#PTop').val());
      formData.append('PZindex', $('#PZindex').val());
      formData.append('PSDate', $('#PSDate').val());
      formData.append('PEDate', $('#PEDate').val());
      formData.append('PContents', PContents);
      formData.append('PUseYN', $('input:radio[name=PUseYN]:checked').val());
      formData.append('PDailyUseYN', $('input:radio[name=PDailyUseYN]:checked').val());
      formData.append('PDailyBgColor', $('#PDailyBgColor').val());
      formData.append('PDailyTxtColor', $('#PDailyTxtColor').val());
      formData.append('PBgColor', $('#PBgColor').val());
      formData.append('PBorder', $('#PBorder').val());
      formData.append('PBorderColor', $('#PBorderColor').val());
      formData.append('Del_PBackgroundYN', Del_PBackgroundYN);            
      if($('#PBackground').val()){ formData.append('PBackground', $('input[name=PBackground]')[0].files[0]);}
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
        
        console.log(retDATA);
        
        if(retDATA){
        
          var strcut = retDATA.split('|');
          
          if (strcut[0] == 'TRUE') {
            
            switch (strcut[1]) { 
              case '80'   : msg = '팝업정보를 수정완료하였습니다.'; break;
              case '70'   : msg = '팝업정보를 삭제완료하였습니다.'; break;
              default   : msg = '팝업정보를 등록완료하였습니다.'; //90
            }           
            alert(msg);
            
            $('form[name=s_frm]').attr('action','./Popup_List.asp');
            $('form[name=s_frm]').submit(); 
          }
          else{  //FALSE|
            
            switch (strcut[1]) { 
              case '99'   : msg = '일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
              case '66'   : msg = '팝업등록에 실패하였습니다.\n관리자에게 문의하세요.'; break;
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
          alert ('오류발생! - 시스템관리자에게 문의하십시오!');     
          return;
        }
      }
    }); 
  }
  
  
  
</script>
<!-- S : content -->
  <div id="content" class="popup_write">
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>팝업 상세내역</h2>
      <a href="./Popup_List.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>홈페이지 관리</li>
          <li>메인</li>
          <li><a href="./Popup_List.asp">팝업 관리</a></li>
          <li><a href="./Popup_Write.asp">팝업 상세내역</a></li>
        </ul>
      </div>
      <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
    

    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
     <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
     <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
     <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
     <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />
     <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
     <input type="hidden" name="fnd_PUseYN" id="fnd_PUseYN" value="<%=fnd_PUseYN%>" />
     <input type="hidden" name="fnd_PViewYN" id="fnd_PViewYN" value="<%=fnd_PViewYN%>" />     
     

          <table class="left-head view-table popup-ctr">
            <tr class="short-line">
              <th>제목</th>
              <td>
                <span class="con">
                  <input type="text" name="Subject" id="Subject" class="in_1" value="<%=Subject%>">
                </span>
              </td>
            </tr>
            <tr class="ipt-px">
              <th>사이즈</th>
              <td>
                <div>
                  <ul class="clearfix">
                    <li>
                      <span>가로:</span>
                      <input type="text" name="PWidth" id="PWidth" class="" value="<%=PWidth%>" onkeyup='chk_InputValue(this, "Digit")'>px
                    </li>
                    <li>
                      <span>세로:</span>
                      <input type="text" name="PHeight" id="PHeight" class="" value="<%=PHeight%>" onkeyup='chk_InputValue(this, "Digit")'>px
                    </li>
                  </ul>
                </div>
              </td>
            </tr>
            <tr class="ipt-px">
              <th>팝업 위치</th>
              <td> 
                <div>
                  <ul>
                    <li>
                      <span>좌측:</span>
                      <input type="text" name="PLeft" id="PLeft" class="" value="<%=PLeft%>" onkeyup='chk_InputValue(this, "Digit")'>px
                    </li>
                    <li>
                      <span>상단:</span>
                      <input type="text" name="PTop" id="PTop" class="" value="<%=PTop%>" onkeyup='chk_InputValue(this, "Digit")'>px
                    </li>
                  </ul>
                </div>
              
            
</td>
            </tr>
            
            <tr>
              <th>BackgroundColor</th>
              <td> <input type="text" name="PBgColor" id="PBgColor" class="jscolor" readonly value="<%=PBgColor%>" onkeyup='chk_InputValue(this, "EngDigit")' style="width:239px;height:32px;line-height:30px;border:1px solid #bbb;padding:0 5px;"/>
              <!--
        <p style="margin-top:5px;">
              <span style="float:left;margin-right:10px;margin-top:6px;">입력하지 않을 시 BackgroundColor(#FFFFFF)</span>
              <span style="width:25px;height:25px;background:#fff;display:inline-block;border:1px solid #bbb;float:left;"></span>
              </p>
-->
              </td>
            </tr>
            <tr>
              <th>팝업 Border</th>
              <td> 
              <input type="text" name="PBorder" id="PBorder" class="" value="<%=PBorder%>"  onkeyup='chk_InputValue(this, "Digit")'style="width:239px;height:32px;line-height:30px;border:1px solid #bbb;padding:0 5px;" />
              <!--<p style="margin-top:5px;">입력하지 않을 시 Border 기본(3px)</p>-->
              </td>
            </tr>
            <tr>
              <th>팝업 BorderColor</th>
              <td> <input type="text" name="PBorderColor" id="PBorderColor" class="jscolor" readonly value="<%=PBorderColor%>" onkeyup='chk_InputValue(this, "EngDigit")' style="width:239px;height:32px;line-height:30px;border:1px solid #bbb;padding:0 5px;"/>
              <!--
          <p style="margin-top:5px;">
                <span style="float:left;margin-right:10px;margin-top:6px;">입력하지 않을 시 BorderColor(#BBBBBB)</span>
                <span style="width:25px;height:25px;background:#bbb;display:inline-block;border:1px solid #bbb;float:left;"></span>
              </p>
-->
              </td>
            </tr>
            <tr class="tiny-line">
              <th> 정렬(z-index)</th>
              <td> 
                <span class="con">
                  <input type="text" name="PZindex" id="PZindex" class="" value="<%=PZindex%>" onkeyup='chk_InputValue(this, "Digit")'>
                </span>
                <span class="guide-txt">팝업이 겹치는 경우 입력 값이 높은 경우 앞에 위치합니다. 입력하지 않을 시 z-index 기본(0)</span>
              </td>
            </tr>
            <tr>
              <th>팝업 사용구분</th>
              <td>
                <label>
                  <input type="radio" name="PUseYN" id="PUseYN" value="Y" <%IF PUseYN = "Y" Then response.write "checked" End IF%> >
                  사용
                </label>
                <label>
                  <input type="radio" name="PUseYN" id="PUseYN" value="N" <%IF PUseYN = "N" Then response.write "checked" End IF%> >
                  사용안함
                </label>
              </td>
            </tr>
            <tr>
              <th>하루동안 안보기 <br> 사용여부</th>
              <td>
                <label>
                  <input type="radio" name="PDailyUseYN" id="PDailyUseYN" value="Y" <%IF PDailyUseYN = "Y" Then response.write "checked" End IF%>>
                  사용
                </label>
                <label>
                  <input type="radio" name="PDailyUseYN" id="PDailyUseYN" value="N" <%IF PDailyUseYN = "N" Then response.write "checked" End IF%> >
                  사용안함
                </label>
              </td>
            </tr>
            <tr>
              <th>하루동안 안보기BackgroundColor</th>
              <td><input type="text" name="PDailyBgColor" id="PDailyBgColor" class="jscolor" readonly value="<%=PDailyBgColor%>" maxlength="6" onkeyup='chk_InputValue(this, "EngDigit")' oninput="maxLengthCheck(this);" style="width:239px;height:32px;line-height:30px;border:1px solid #bbb;padding:0 5px;"/>
          <!--
              <p style="margin-top:5px;">
                <span style="float:left;margin-right:10px;margin-top:6px;">입력하지 않을 시 BackgroundColor(#222222)</span>
                <span style="width:25px;height:25px;background:#222;display:inline-block;border:1px solid #bbb;float:left;"></span>
              </p>
-->
        </td>
            </tr>
            <tr>
              <th>하루동안 안보기 TextColor</th>
              <td><input type="text" name="PDailyTxtColor" id="PDailyTxtColor" class="jscolor" readonly value="<%=PDailyTxtColor%>" maxlength="6" onkeyup='chk_InputValue(this, "EngDigit")' oninput="maxLengthCheck(this);" style="width:239px;height:32px;line-height:30px;border:1px solid #bbb;padding:0 5px;"/>
          <!--
              <p style="margin-top:5px;">
                <span style="float:left;margin-right:10px;margin-top:6px;">입력하지 않을 시 FontColor(#FFFFFF)</span>
                <span style="width:25px;height:25px;background:#fff;display:inline-block;border:1px solid #bbb;float:left;"></span>
              </p>
        -->
</td>
            </tr>
            <tr>
              <th>노출기간</th>
              <td><input type="date" id="PSDate" name="PSDate" class="date_ipt" value="<%=PSDate%>" style="width:239px;height:32px;line-height:30px;border:1px solid #bbb;padding:0 5px;"/>
                ~
               <input type="date" id="PEDate" name="PEDate" class="date_ipt" value="<%=PEDate%>" style="width:239px;height:32px;line-height:30px;border:1px solid #bbb;padding:0 5px;"/></td>
            </tr>
            <tr class="file-line">
              <th>백그라운드이미지</th>
              <td>
                <input type="file" name="PBackground" id="PBackground"> 
                <%
                  IF PBackground <> "" Then 
                  response.Write "<div class='added-list'>"
                  response.Write PBackground 
                    response.Write "<span><input type='checkbox' name='Del_PBackground' id='Del_PBackground'>삭제시 체크</span>" 
                  response.Write "</div>"
                End IF
                %>
              </td>
            </tr>
            <tr>
              <th>내용</th>
              <td><textarea name="PContents" id="PContents"><%=PContents%></textarea></td>
            </tr>
          </table>
        
        <!-- S: btn-list-center -->
        <%IF CIDX<>"" Then%>
        <div class="btn-list-center"> 
          <a href="javascript:chk_Submit('MOD');" class="btn btn-confirm">수정</a> 
          <a href="javascript:chk_Submit('DEL');" class="btn btn-delete">삭제</a> 
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
  <!-- E : content popup_write -->
<!--#include file="../include/footer.asp"-->
<script>
  var oEditors = [];
  
  nhn.husky.EZCreator.createInIFrame({
    oAppRef: oEditors,
    elPlaceHolder: "PContents",
    sSkinURI: "../dev/dist/se2/SmartEditor2Skin.html",
    fCreator: "createSEditor2"
  });

  
  $( document ).ready(function() {
    
    //팝업 하단 닫기 영역 기본컬러 SET
    if(!$("#PDailyBgColor").val()) $("#PDailyBgColor").val('222222');
    if(!$("#PDailyTxtColor").val()) $("#PDailyTxtColor").val('FFFFFF');
    //팝업 BgColor, Border, Color
    if(!$("#PBgColor").val()) $("#PBgColor").val('FFFFFF');
    if(!$("#PBorderColor").val()) $("#PBorderColor").val('BBBBBB');
    if(!$("#PBorder").val()) $("#PBorder").val('3');
  });
</script>
