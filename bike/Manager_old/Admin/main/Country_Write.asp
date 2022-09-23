<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
  <%
	dim currPage      	: currPage      = fInject(Request("currPage"))
	dim fnd_KeyWord   	: fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
	dim fnd_CountryGb   : fnd_CountryGb = fInject(Request("fnd_CountryGb"))
	dim CIDX          	: CIDX        	= crypt.DecryptStringENC(fInject(Request("CIDX")))

	dim CSQL, CRs
	dim CountryGb, CountryEnNmShort, CountryNm, CountryEnNm, CountryFlag
	dim CountryFlagGb

    IF CIDX <> "" Then

		CSQL = "      SELECT CountryIDX"
		CSQL = CSQL & "     ,CountryGb"
		CSQL = CSQL & "     ,CountryNm"
		CSQL = CSQL & "     ,CountryEnNm"
		CSQL = CSQL & "     ,CountryEnNmShort"
		CSQL = CSQL & "     ,CountryFlag"
		CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblCountryInfo] A "
		CSQL = CSQL & " WHERE DelYN = 'N'"
		CSQL = CSQL & "   AND CountryIDX = '"&CIDX&"'"


		SET CRs = DBCon.Execute(CSQL)   
		IF Not(CRs.eof or CRs.bof) Then
			CountryGb = CRs("CountryGb")
			CountryNm = ReHtmlSpecialChars(CRs("CountryNm"))
			CountryEnNm = ReHtmlSpecialChars(CRs("CountryEnNm"))
			CountryEnNmShort = ReHtmlSpecialChars(CRs("CountryEnNmShort"))      
			CountryFlag = CRs("CountryFlag")


			IF CountryFlag <> "" Then
				CountryFlagGb = "<img src='/FileDown/country_flag/"&CountryFlag&"' alt=''>"
			End IF

		End IF
			CRs.Close
		SET CRs = Nothing

	End IF
  
%>
  <script language="javascript">
  /**
  * left-menu 체크
  */
  var locationStr = "Country_List"; // 국가정보
  /* left-menu 체크 */

  function chk_Submit(valType){

    if(valType=="DEL"){
      if(confirm(" 정보를 삭제하시겠습니까?"))  {
        on_Submit(valType);
      }
      else{
        return;
      }
    }
    else if(valType=="MOD" || valType=="SAVE"){
      on_Submit(valType); 
    }
    else if(valType=="LIST"){
      $(location).attr('href', "./Country_List.asp");
    }
    else{
      window.history.back();    
    }
  }
  
    function on_Submit(valType){
    var formData = new FormData();
    var strAjaxUrl = "../Ajax/Country_Write.asp";

    if(valType=="MOD" || valType=="SAVE"){

      if(!$('#CountryGb').val()){
        alert("소속대륙을 선택해 주세요.");
        $('#CountryGb').focus();
        return;
      }

      if(!$('#CountryNm').val()){
        alert("국가명(국문)을 입력해 주세요.");
        $('#CountryNm').focus();
        return;
      }

      if(!$('#CountryEnNm').val()){
        alert("국가명(영문)을 입력해 주세요.");
        $('#CountryEnNm').focus();
        return;
      }     

      if(!$('#CountryEnNmShort').val()){
        alert("국가명(영문) 축약을 입력해 주세요.");
        $('#CountryEnNmShort').focus();
        return;
      }   
      
      <%
      '등록된 이미지 파일이 없는 경우 이미지 선택 메세지 출력
      IF CountryFlag = "" Then
      %>
      if(!$('#CountryFlag').val()){
        alert("국기를 선택해 주세요.");
        $('#CountryFlag').focus();
        return;
      } 
      <%End IF%>
      var Del_CountryFlagYN = '';

      if($("#Del_CountryFlag").is(":checked") == true){ Del_CountryFlagYN = "Y"}
      else{ Del_CountryFlagYN = "N"}

      formData.append("CountryGb", $("#CountryGb").val());
      formData.append("CountryNm", $("#CountryNm").val());

      formData.append("CountryEnNm", $("#CountryEnNm").val());
      formData.append("CountryEnNmShort", $("#CountryEnNmShort").val());
      formData.append("Del_CountryFlagYN", Del_CountryFlagYN);            

      if($("#CountryFlag").val()){ 
        formData.append("CountryFlag", $("input[name=CountryFlag]")[0].files[0]);
      }
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

        //console.log(retDATA);

        if(retDATA){

          var strcut = retDATA.split("|");

          if (strcut[0] == "TRUE") {

            switch (strcut[1]) { 
              case '90'   : msg = "정보를 등록완료하였습니다."; break;
              case '80'   : msg = "정보를 수정완료하였습니다."; break;
              case '70'   : msg = "정보를 삭제완료하였습니다."; break;
              default   : break;
            }           
            alert(msg);

            $('form[name=s_frm]').attr('action',"./Country_List.asp");
            $('form[name=s_frm]').submit(); 
          }
          else{  //FALSE|

            switch (strcut[1]) { 
              case '200'  : msg = "잘못된 접근입니다.\n확인 후 다시 이용하세요."; break;
              case '99'   : msg = "일치하는 정보가 없습니다.\n확인 후 다시 이용하세요."; break;
              case '66'   : msg = "등록에 실패하였습니다.\n관리자에게 문의하세요."; break;
              case '33'   : msg = "이미지파일만 업로드 가능합니다."; break;
              default   : break;
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

  });
</script> 
  <!-- S : content sponsor_write -->
  <div id="content" class="sponsor_write"> 
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>국가정보</h2>
      <a href="./Country_List.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a> 
      
      <!-- S: 네비게이션 -->
      <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
        <ul>
          <li>대회정보</li>
          <li>대회운영</li>
          <li><a href="./Sponsor_List.asp">국가정보</a></li>
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
      <input type="hidden" name="fnd_CountryGb" id="fnd_CountryGb" value="<%=fnd_CountryGb%>" />
      <table class="left-head view-table">
        <tr class="short-line">
          <th rowspan="5"><%=CountryFlagGb%></th>
          <th>구분</th>
          <td><select name="CountryGb" id="CountryGb" class="title_select">
              <option value="">소속대륙선택</option>
              <option value="OCEANIA" <%IF CountryGb = "OCEANIA" Then response.write "selected" End IF%>>OCEANIA</option>
              <option value="ASIA" <%IF CountryGb = "ASIA" Then response.write "selected" End IF%>>ASIA</option>
              <option value="EUROPE" <%IF CountryGb = "EUROPE" Then response.write "selected" End IF%>>EUROPE</option>
              <option value="AFRICA" <%IF CountryGb = "AFRICA" Then response.write "selected" End IF%>>AFRICA</option>
              <option value="AMERICA" <%IF CountryGb = "AMERICA" Then response.write "selected" End IF%>>AMERICA</option>
            </select></td>
        </tr>
        <tr class="short-line">
          <th>국가명(국문)</th>
          <td><span class="con">
            <input type="text" name="CountryNm" id="CountryNm" value="<%=CountryNm%>">
            </span></td>
        </tr>
        <tr>
          <th>국가명(영문)</th>
          <td><span class="con">
            <input type="text" name="CountryEnNm" id="CountryEnNm" value="<%=CountryEnNm%>">
            </span></td>
        </tr>
        <tr>
          <th>국가명(영문축약)</th>
          <td><span class="con">
            <input type="text" name="CountryEnNmShort" id="CountryEnNmShort" value="<%=CountryEnNmShort%>">
            </span></td>
        </tr>
        <tr class="file-line">
          <th>국기이미지</th>
          <td><input type="file" name="CountryFlag" id="CountryFlag">
            <%
        IF CountryFlag <> "" Then 
        response.Write "<div class='added-list'>"
        response.Write CountryFlag 
          response.Write "<span><input type='checkbox' name='Del_CountryFlag' id='Del_CountryFlag'>삭제시 체크</span>" 
        response.Write "</div>"
      End IF
      %>
            
            <!-- <div class="guide-txt">이미지 사이즈 220px(W) * 89px(H)</div>--></td>
        </tr>
      </table>
      
      <!-- S: btn-list-center -->
      <%IF CIDX<>"" Then%>
      <div class="btn-list-center"> <a href="javascript:chk_Submit('MOD');" class="btn btn-confirm">수정</a> <a href="javascript:chk_Submit('DEL');" class="btn btn-red">삭제</a> <a href="javascript:chk_Submit('CANCEL');" class="btn btn-cancel">취소</a> <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a> </div>
      <%Else%>
      <div class="btn-list-center"> <a href="javascript:chk_Submit('SAVE');" class="btn btn-add">등록</a> <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a> </div>
      <%End IF%>
      <!-- E: btn-list-center -->
      
    </form>
    <!-- E : sch 검색조건 선택 및 입력 --> 
  </div>
  <!-- E : content sponsor_write --> 
  <!--#include file="../include/footer.asp"-->