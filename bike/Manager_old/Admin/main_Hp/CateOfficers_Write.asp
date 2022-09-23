<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
	dim CIDX      : CIDX        = crypt.DecryptStringENC(fInject(Request("CIDX")))
	dim currPage    : currPage        = fInject(Request("currPage"))
	dim fnd_AssoCode    : fnd_AssoCode    = fInject(Request("fnd_AssoCode"))  
	dim fnd_Successive  : fnd_Successive    = fInject(Request("fnd_Successive"))  
	dim fnd_KeyWord     : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))   
	dim fnd_ViewYN    : fnd_ViewYN      = fInject(Request("fnd_ViewYN")) 

	dim CSQL, CRs
	dim AssoCode, CateSuccessiveIDX, OfficerNm, OfficerEnNm, ViewYN, Orderby

	IF CIDX <> "" Then

		CSQL = "    SELECT CateOfficersIDX"
		CSQL = CSQL & "   ,AssoCode"
		CSQL = CSQL & "   ,CateSuccessiveIDX"
		CSQL = CSQL & "   ,OfficerNm"
		CSQL = CSQL & "   ,OfficerEnNm"
		CSQL = CSQL & "   ,Orderby"
		CSQL = CSQL & "   ,ViewYN"   
		CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblCateOfficers] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & "   AND CateOfficersIDX = '"&CIDX&"'"

		SET CRs = DBCon.Execute(CSQL)   
		IF Not(CRs.eof or CRs.bof) Then
			AssoCode = CRs("AssoCode")
			CateSuccessiveIDX = CRs("CateSuccessiveIDX")
			OfficerNm = ReHtmlSpecialChars(CRs("OfficerNm"))
			OfficerEnNm = ReHtmlSpecialChars(CRs("OfficerEnNm"))
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
			else{
				return;
			}
		}
		else if(valType=='MOD' || valType=='SAVE'){
			on_Submit(valType); 
		}
		else if(valType=='LIST'){
			$('form[name=s_frm]').attr('action','./CateOfficers_list.asp');
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

			if(!$('#Successive').val()){
				alert('역대타이틀을 선택해 주세요.');
				$('#Successive').focus();
				return;
			}

			if(!$('#OfficerNm').val()){
				alert('임원직책을 입력해 주세요.');
				$('#OfficerNm').focus();
				return;
			}
			/*
			if(!$('#OfficerEnNm').val()){
				alert('임원직책 영문명을 입력해 주세요.');
				$('#OfficerEnNm').focus();
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
		
		var strAjaxUrl      = '../ajax/CateOfficers_write.asp';   
		var AssoCode      = $('#AssoCode').val();
		var CateSuccessiveIDX   = $('#Successive').val();   
		var OfficerNm       = $('#OfficerNm').val();
		var OfficerEnNm     = $('#OfficerEnNm').val();
		var ViewYN        = $('input:radio[name=ViewYN]:checked').val();
		var Orderby       = $('#Orderby').val();
		var CIDX        = $('#CIDX').val();

		var msg = '';

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',     
			data: { 
				CIDX 				: CIDX 
				,AssoCode     		: AssoCode
				,CateSuccessiveIDX  : CateSuccessiveIDX
				,OfficerNm     	 	: OfficerNm 
				,OfficerEnNm    	: OfficerEnNm 
				,ViewYN       		: ViewYN 
				,Orderby      		: Orderby
				,valType      		: valType 
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
						$('form[name=s_frm]').attr('action','./CateOfficers_list.asp');
						$('form[name=s_frm]').submit(); 
					}
					else{  //FALSE|
						switch(strcut[1]){
							case '99' : msg='일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
							case '88' : msg='동일한 임원직책명이 존재합니다.\n확인 후 다시 이용하세요.'; $('#AssoNm').focus(); break; 
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
<!-- S : content officers_write -->
<div id="content" class="officers_write"> 
  <!-- S: page_title -->
  <div class="page_title clearfix">
    <h2>임원직책 정보 등록/수정</h2>
    <a href="./CateOfficers_list.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a> 
    
    <!-- S: 네비게이션 -->
    <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
      <ul>
        <li>홈페이지관리</li>
        <li>협회정보</li>
        <li><a href="./association_membership.asp">임원현황</a></li>
        <li><a href="./association_list.asp">임원직책 정보</a></li>
        <li><a href="./association_write.asp">임원직책 정보 등록/수정</a></li>
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
    <table class="left-head view-table">
      <tr>
        <th>협회</th>
        <td id="sel_AssoCode"><select name="AssoCode" id="AssoCode">
            <option value=''>:: 협회 선택 ::</option>
          </select></td>
      </tr>
      <tr>
        <th>역대타이틀</th>
        <td id="sel_Successive"><select name="Successive" id="Successive">
            <option value=''>:: 역대타이틀 선택 ::</option>
          </select></td>
      </tr>
      <tr>
        <th>임원직책명</th>
        <td><div class="con">
            <input type="text" name="OfficerNm" id="OfficerNm" value="<%=OfficerNm%>" placeholder="ex) 회장">
          </div></td>
      </tr>
      <tr>
        <th>임원직책 영문명</th>
        <td><div class="con">
            <input type="text" name="OfficerEnNm" id="OfficerEnNm" value="<%=OfficerEnNm%>" placeholder="ex) President" onKeyUp="chk_InputValue(this, 'EngSpace');">
          </div></td>
      </tr>
      <tr>
        <th>노출구분</th>
        <td><label>
            <input type="radio" name="ViewYN" id="ViewYN" value="Y" <%IF ViewYN = "Y" Then response.write "checked" End IF%> >
            노출 </label>
          <label>
            <input type="radio" name="ViewYN" id="ViewYN" value="N" <%IF ViewYN = "N" Then response.write "checked" End IF%> >
            노출 안함 </label></td>
      </tr>
      <tr class="tiny-line">
        <th>순서</th>
        <td><div class="con">
            <input type="text" name="Orderby" id="Orderby" value="<%=Orderby%>" placeholder="오름차순으로 정렬합니다." onKeyUp="chk_InputValue(this, 'Digit');" />
         	</div>
		</td>
      </tr>
    </table>
    
    <!-- S: btn-list-center -->
    <%IF CIDX<>"" Then%>
    <div class="btn-list-center"> <a href="javascript:chk_Submit('MOD');" class="btn btn-confirm">수정</a> <a href="javascript:chk_Submit('DEL');" class="btn btn-red">삭제</a> <a href="javascript:chk_Submit('CANCEL');" class="btn btn-gray">취소</a> <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a> </div>
    <%Else%>
    <div class="btn-right-list"> <a href="javascript:chk_Submit('SAVE');" class="btn">등록</a> <a href="javascript:chk_Submit('LIST');" class="btn">목록</a> </div>
    <%End IF%>
    <!-- E: btn-list-center -->
    
  </form>
  <!-- E : sch 검색조건 선택 및 입력 --> 
</div>
<!-- E : content officers_write --> 
<!--#include file="../include/footer.asp"-->