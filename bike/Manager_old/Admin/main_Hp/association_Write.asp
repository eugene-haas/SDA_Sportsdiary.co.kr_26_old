<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
  dim CIDX      : CIDX      = crypt.DecryptStringENC(fInject(Request("CIDX")))
  dim currPage    : currPage      = fInject(Request("currPage"))
  dim fnd_KeyWord     : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))   
    dim fnd_ViewYN    : fnd_ViewYN    = fInject(Request("fnd_ViewYN")) 
   
  dim CSQL, CRs
  dim AssoNm, AssoNmShort, AssoEnNm, Address, AddressDtl, ViewYN, Orderby
  dim strPhone, Phone1, Phone2, Phone3
    dim strFax, Fax1, Fax2, Fax3
  
    
  IF CIDX <> "" Then
  
    CSQL = "    SELECT * "
    CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblAssociationInfo]"
    CSQL = CSQL & " WHERE DelYN = 'N'"
    CSQL = CSQL & "   AND AssociationIDX = '"&CIDX&"'"
    
    SET CRs = DBCon.Execute(CSQL)   
    IF Not(CRs.eof or CRs.bof) Then
      AssoNm = ReHtmlSpecialChars(CRs("AssoNm"))
      AssoNmShort = ReHtmlSpecialChars(CRs("AssoNmShort"))
      AssoEnNm = ReHtmlSpecialChars(CRs("AssoEnNm"))
      Address = ReHtmlSpecialChars(CRs("Address"))
      AddressDtl = ReHtmlSpecialChars(CRs("AddressDtl"))
      Phone = CRs("Phone")
      Fax = CRs("Fax")  
      Orderby = CRs("Orderby")
      ViewYN = CRs("ViewYN")

      IF Phone <> "" Then
        strPhone = split(Phone, "-")
        Phone1 = strPhone(0)
        Phone2 = strPhone(1)
        Phone3 = strPhone(2)
      End IF
      
      IF Fax <> "" Then
        strFax = split(Fax, "-")
        Fax1 = strFax(0)
        Fax2 = strFax(1)
        Fax3 = strFax(2)
      End IF
    Else
      response.write "<script>alert('일치하는 정보가 없습니다.'); history.back();</script>"
      response.end
    End IF
      CRs.Close
    SET CRs = Nothing
    
  End IF
  
%>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script language="javascript">
  /**
   * left-menu 체크
   */
  var bigCate = 1; // 홈페이지관리
  var midCate = 1; // 협회정보
  var lowCate = 0; // 임원현황
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
      $('form[name=s_frm]').attr('action','./association_list.asp');
          $('form[name=s_frm]').submit(); 
    }
    else{
      window.history.back();    
    }
  }
  
  function on_Submit(valType){
    if(valType=='MOD' || valType=='SAVE'){
      if(!$('#AssoNm').val()){
        alert('협회명을 입력해 주세요.');
        $('#AssoNm').focus();
        return;
      }

      if(!$('#AssoNmShort').val()){
        alert('협회명 줄임을 입력해 주세요.');
        $('#AssoNmShort').focus();
        return;
      }

      if(!$('#Phone2').val()){
        alert('전화번호를 입력해 주세요.');
        $('#Phone2').focus();
        return;
      }

      if(!$('#Phone3').val()){
        alert('전화번호를 입력해 주세요.');
        $('#Phone3').focus();
        return;
      }

      
      if(!$('input:radio[name=ViewYN]').is(':checked')){
        alert("노출여부를 선택해 주세요."); 
        return;
      }

      if(!$('#Orderby').val()){
        alert('정렬순서를 입력해 주세요.(오름차순으로 정렬됩니다.)');
        $('#Orderby').focus();
        return;
      }
    
      /*
      if(!$('#Fax').val()){
        alert('팩스번호를 입력해 주세요.');
        $('#Fax').focus();
        return;
      }
      
      if(!$('#Address').val()){
        alert('주소를 입력해 주세요.');
        $('#Address').focus();
        return;
      }
      
      if(!$('#AddressDtl').val()){
        alert('상세주소를 입력해 주세요.');
        $('#AddressDtl').focus();
        return;
      }
    */  
    }
    
    var strAjaxUrl  = '../ajax/association_write.asp';
    var AssoNm    = $('#AssoNm').val();
    var AssoNmShort = $('#AssoNmShort').val();
    var AssoEnNm  = $('#AssoEnNm').val();
    var Address   = $('#Address').val();
    var AddressDtl  = $('#AddressDtl').val();
    var Phone     = $('#Phone1').val() + '-' + $('#Phone2').val().replace(/ /g, '') + '-' + $('#Phone3').val().replace(/ /g, '');  
    var Fax     = $('#Fax1').val() + '-' + $('#Fax2').val().replace(/ /g, '') + '-' + $('#Fax3').val().replace(/ /g, '');  
    var ViewYN    = $('input:radio[name=ViewYN]:checked').val();
    var Orderby   = $('#Orderby').val();
    var CIDX    = $('#CIDX').val();

    var msg = '';
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: { 
        CIDX    : CIDX 
        ,AssoNm   : AssoNm 
        ,AssoNmShort: AssoNmShort 
        ,AssoEnNm   : AssoEnNm 
        ,Address  : Address 
        ,AddressDtl : AddressDtl 
        ,Phone    : Phone 
        ,Fax    : Fax 
        ,ViewYN   : ViewYN 
        ,Orderby  : Orderby
        ,valType  : valType 
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
            $('form[name=s_frm]').attr('action','./association_list.asp');
            $('form[name=s_frm]').submit(); 
          }
          else{  //FALSE|
            switch(strcut[1]){
              case '99' : msg='일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
              case '88' : msg='동일한 협회명이 존재합니다.\n확인 후 다시 이용하세요.'; $('#AssoNm').focus(); break; 
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
  
  /**
   * 다음 우편번호 서비스
   */
  function execDaumPostCode() {

    var themeObj = {
     bgColor: "", //바탕 배경색
     searchBgColor: "#0B65C8", //검색창 배경색
     contentBgColor: "#fefefe", //본문 배경색(검색결과,결과없음,첫화면,검색서제스트)
     pageBgColor: "#dedede", //페이지 배경색
     textColor: "#000", //기본 글자색
     queryTextColor: "#FFFFFF", //검색창 글자색
     //postcodeTextColor: "#000", //우편번호 글자색
     //emphTextColor: "", //강조 글자색
     //outlineColor: "" //테두리
    };

    var width = 500;
    var height = 600;

    new daum.Postcode({
    width: width,
    height: height,
    oncomplete: function(data) {
      // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

      // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
      // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
      var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
      var extraRoadAddr = ''; // 도로명 조합형 주소 변수

      // 법정동명이 있을 경우 추가한다. (법정리는 제외)
      // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
      if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
        extraRoadAddr += data.bname;
      }
      // 건물명이 있고, 공동주택일 경우 추가한다.
      if(data.buildingName !== '' && data.apartment === 'Y'){
       extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
      }
      // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
      if(extraRoadAddr !== ''){
        extraRoadAddr = ' (' + extraRoadAddr + ')';
      }
      // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
      if(fullRoadAddr !== ''){
        fullRoadAddr += extraRoadAddr;
      }

      // 우편번호와 주소 정보를 해당 필드에 넣는다.
      document.getElementById('ZipCode').value = data.zonecode; //5자리 새우편번호 사용
      document.getElementById('Address').value = fullRoadAddr;
      // document.getElementById('AddressDtl').value = data.jibunAddress;
      document.getElementById('AddressDtl').focus();

      // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
      if(data.autoRoadAddress) {
        //예상되는 도로명 주소에 조합형 주소를 추가한다.
        var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
        document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

      } else if(data.autoJibunAddress) {
        var expJibunAddr = data.autoJibunAddress;
        document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

      } else {
        document.getElementById('guide').innerHTML = '';
      }
    },
    theme: themeObj
    }).open({
    popupName: 'postcodePopup', //팝업 이름을 설정(영문,한글,숫자 모두 가능, 영문 추천)
    left: (window.screenLeft) + (document.body.clientWidth / 2) - (width / 2),
    top: (window.screen.height / 2) - (height / 2)
    });
  }
  
</script>
<!-- S : content -->
  <div id="content" class="association_write">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>협회등록/수정</h2>
        <a href="./association_list.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>홈페이지관리</li>
            <li>협회정보</li>
            <li><a href="./association_membership.asp">임원현황</a></li>
            <li><a href="./association_list.asp">협회정보관리</a></li>
            <li><a href="./association_write.asp">협회등록/수정</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
    <input type="hidden" name="CIDX" id="CIDX" value="<%=fInject(Request("CIDX"))%>" />
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
    <input type="hidden" name="fnd_ViewYN" id="fnd_ViewYN" value="<%=fnd_ViewYN%>" />

      <table class="left-head view-table">
        <%IF CIDX <> "" Then%>
            <tr>
              <th>협회코드</th>
              <td><%=AssoCode%></td>
            </tr>
        <%End IF%>
        <tr class="short-line">
              <th>협회명</th>
              <td>
                <div class="con">
                  <input type="text" name="AssoNm" id="AssoNm" class="in_1" value="<%=AssoNm%>">
                </div>
              </td>
            </tr>
             <tr class="short-line">
              <th>협회명 줄임</th>
              <td>
                <div class="con">
                  <input type="text" name="AssoNmShort" id="AssoNmShort" value="<%=AssoNmShort%>">
                </div>
              </td>
            </tr>
      <tr class="short-line">
              <th>협회명 영문</th>
              <td>
                <div class="con">
                  <input type="text" name="AssoEnNm" id="AssoEnNm" class="in_1" value="<%=AssoEnNm%>" onKeyUp="chk_InputValue(this, 'EngSpace');">
                </div>
              </td>
            </tr>  
            <tr class="phone_line">
          <th>전화번호</th>
          <td><select name="Phone1" id="Phone1"  class="title_select">
        <option value="010" <%IF Phone1 = "02" Then response.Write "selected" End IF%>>02</option>
        <option value="031" <%IF Phone1 = "031" Then response.Write "selected" End IF%>>031</option>
        <option value="032" <%IF Phone1 = "032" Then response.Write "selected" End IF%>>032</option>
        <option value="033" <%IF Phone1 = "033" Then response.Write "selected" End IF%>>033</option>
        <option value="041" <%IF Phone1 = "041" Then response.Write "selected" End IF%>>041</option>
        <option value="042" <%IF Phone1 = "042" Then response.Write "selected" End IF%>>042</option>
        <option value="043" <%IF Phone1 = "043" Then response.Write "selected" End IF%>>043</option>
        <option value="049" <%IF Phone1 = "049" Then response.Write "selected" End IF%>>049</option>
        <option value="051" <%IF Phone1 = "051" Then response.Write "selected" End IF%>>051</option>
        <option value="052" <%IF Phone1 = "052" Then response.Write "selected" End IF%>>052</option>
        <option value="053" <%IF Phone1 = "053" Then response.Write "selected" End IF%>>053</option>
        <option value="054" <%IF Phone1 = "054" Then response.Write "selected" End IF%>>054</option>
        <option value="055" <%IF Phone1 = "055" Then response.Write "selected" End IF%>>055</option>
        <option value="061" <%IF Phone1 = "061" Then response.Write "selected" End IF%>>061</option>
        <option value="062" <%IF Phone1 = "062" Then response.Write "selected" End IF%>>062</option>
        <option value="063" <%IF Phone1 = "063" Then response.Write "selected" End IF%>>063</option>
        <option value="064" <%IF Phone1 = "064" Then response.Write "selected" End IF%>>064</option>
            </select>
            <span>-</span>
            <input type="text" class="in_2" name="Phone2" id="Phone2" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit'); if($('#Phone2').val().length==4) $('#Phone3').focus();" value="<%=Phone2%>" />
            <span>-</span>
            <input type="text" class="in_2" name="Phone3" id="Phone3" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit'); if($('#Phone3').val().length==4)$('#Fax1').focus();" value="<%=Phone3%>" />
            </td>
        </tr>
            
            <tr class="phone_line">
          <th>팩스</th>
          <td><select name="Fax1" id="Fax1" class="title_select">
                <option value="010" <%IF Fax1 = "02" Then response.Write "selected" End IF%>>02</option>
        <option value="031" <%IF Fax1 = "031" Then response.Write "selected" End IF%>>031</option>
        <option value="032" <%IF Fax1 = "032" Then response.Write "selected" End IF%>>032</option>
        <option value="033" <%IF Fax1 = "033" Then response.Write "selected" End IF%>>033</option>
        <option value="041" <%IF Fax1 = "041" Then response.Write "selected" End IF%>>041</option>
        <option value="042" <%IF Fax1 = "042" Then response.Write "selected" End IF%>>042</option>
        <option value="043" <%IF Fax1 = "043" Then response.Write "selected" End IF%>>043</option>
        <option value="049" <%IF Fax1 = "049" Then response.Write "selected" End IF%>>049</option>
        <option value="051" <%IF Fax1 = "051" Then response.Write "selected" End IF%>>051</option>
        <option value="052" <%IF Fax1 = "052" Then response.Write "selected" End IF%>>052</option>
        <option value="053" <%IF Fax1 = "053" Then response.Write "selected" End IF%>>053</option>
        <option value="054" <%IF Fax1 = "054" Then response.Write "selected" End IF%>>054</option>
        <option value="055" <%IF Fax1 = "055" Then response.Write "selected" End IF%>>055</option>
        <option value="061" <%IF Fax1 = "061" Then response.Write "selected" End IF%>>061</option>
        <option value="062" <%IF Fax1 = "062" Then response.Write "selected" End IF%>>062</option>
        <option value="063" <%IF Fax1 = "063" Then response.Write "selected" End IF%>>063</option>
        <option value="064" <%IF Fax1 = "064" Then response.Write "selected" End IF%>>064</option>
            </select>
            <span>-</span>
            <input type="text" class="in_2" name="Fax2" id="Fax2" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit'); if($('#Fax2').val().length==4)$('#Fax3').focus();" value="<%=Fax2%>" />
            <span>-</span>
            <input type="text" class="in_2" name="Fax3" id="Fax3" maxlength="4" onKeyUp="chk_InputValue(this, 'Digit');" value="<%=Fax3%>" />
            </td>
        </tr>
            <tr id="div_POST" class="addr_line tr_view">
                    <th>주소</th>
                    <td>
                      <div class="srch_post_num">
                        <a href="#" onclick="execDaumPostCode(); return false;">
                          <input type="text" disabled name="ZipCode" id="ZipCode" />
                          <span class="btn btn_gray">우편번호검색</span>
                        </a>
                      </div>
                      <div class="detail_post">
                        <input type="text" name="Address" id="Address" disabled placeholder="우편번호검색을 눌러 주세요" />
                        <input type="text" name="AddressDtl" id="AddressDtl" placeholder="상세주소 입력" />
                        <span id="guide"></span>
                      </div>
                    </td>
                  </tr>
            <tr>
              <th>노출구분</th>
              <td>
                <label>
                  <input type="radio" name="ViewYN" id="ViewYN" value="Y" <%IF ViewYN = "Y" Then response.write "checked" End IF%> > 노출
                </label>
                <label>
                  <input type="radio" name="ViewYN" id="ViewYN" value="N" <%IF ViewYN = "N" Then response.write "checked" End IF%> > 노출 안함
                </label>
                </td>
            </tr>
      <tr class="tiny-line">
              <th>정렬순서</th>
              <td>
                <div class="con">
                  <input type="text" name="Orderby" id="Orderby" value="<%=Orderby%>" placeholder="오름차순으로 정렬합니다." onKeyUp="chk_InputValue(this, 'Digit');">
                </div>
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
      </div>
    </form>
    <!-- E : sch 검색조건 선택 및 입력 -->
  </div>
<!-- E : content association_write -->
<!--#include file="../include/footer.asp"-->

