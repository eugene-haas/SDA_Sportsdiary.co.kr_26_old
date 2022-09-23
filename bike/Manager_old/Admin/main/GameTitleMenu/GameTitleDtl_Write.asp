<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
<%
	dim tIDX 	:    tIDX 	= crypt.DecryptStringENC(fInject(request("tIDX")))
   	dim i2 		:    i2 	= fInject(request("i2"))			'NowPage
																 
	dim CSQL, CRs
	dim GameTitleDtlIDX, txtSummary, txtTSchedule, TScheduleFile, txtStayTravel, GameTitleName
   		
	IF tIDX = "" Then
		response.write "<script>alert('잘못된 접근입니다. 확인 후 이용하세요.22'); history.back();</script>"						
		response.end
	Else	
		CSQL = "		SELECT B.GameTitleDtlIDX"
		CSQL = CSQL & "		,B.GameTitleIDX "
		CSQL = CSQL & "		,B.txtSummary "
		CSQL = CSQL & "		,B.txtTSchedule "
		CSQL = CSQL & "		,B.TScheduleFile "
		CSQL = CSQL & "		,B.txtStayTravel "
		CSQL = CSQL & "		,A.GameTitleName "
		CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblGameTitle] A"
		CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblGameTitleDtl] B on B.GameTitleIDX = A.GameTitleIDX AND B.DelYN = 'N'"													
		CSQL = CSQL & " WHERE A.DelYN = 'N'"
		CSQL = CSQL & " 	AND A.GameTitleIDX = '"&tIDX&"'"
		
		SET CRs = DBCon.Execute(CSQL)   
		IF Not(CRs.eof or CRs.bof) Then			
			GameTitleName = ReHtmlSpecialChars(CRs("GameTitleName"))														   
			GameTitleDtlIDX = CRs("GameTitleDtlIDX")
														   
			IF GameTitleDtlIDX <> "" Then
				GameTitleDtlIDX = crypt.EncryptStringENC(CRs("GameTitleDtlIDX"))
				txtSummary = Replace( CRs("txtSummary"), "&#039;", "'")
				txtTSchedule = Replace( CRs("txtTSchedule"), "&#039;", "'")
				txtStayTravel = Replace( CRs("txtStayTravel"), "&#039;", "'")
				TScheduleFile = CRs("TScheduleFile")			
			End IF
												   
		End IF
			CRs.Close
		SET CRs = Nothing
	End IF
														 
%>
<script src="../../js/jscolor.js"></script> 
<script src="../../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script> 
<script language="javascript">
	/**
	  * left-menu 체크
	  */
	  var locationStr = "index.asp";  // 지도자
	  /* left-menu 체크 */

						
	function chk_Submit(valType){
		switch(valType){
			case 'DEL'	:
				if(confirm('추가정보를 삭제하시겠습니까?'))	{
					on_Submit(valType);
				}
				else{return;}	
				break;

			case 'MOD': case 'SAVE'	:
				on_Submit(valType);	
				break;
			
			case 'LIST'	:	
				$('form[name=s_frm]').attr('action','./index.asp');
				$('form[name=s_frm]').submit();				
				break;
			
			default		: 	window.history.back();	
		}
	}
	
	function on_Submit(valType){
		var formData = new FormData();
		var strAjaxUrl = '../../ajax/GameTitleMenu/GameTitleDtl_Write.asp';
		
		if(valType=='MOD' || valType=='SAVE'){
			
			var elClickedObj = $('#s_frm');

			oEditors.getById['txtSummary'].exec('UPDATE_CONTENTS_FIELD', []);
			oEditors.getById['txtTSchedule'].exec('UPDATE_CONTENTS_FIELD', []);
			oEditors.getById['txtStayTravel'].exec('UPDATE_CONTENTS_FIELD', []);
			
							 
			var txtSummary = $('#txtSummary').val();
			var txtTSchedule = $('#txtTSchedule').val();
			var txtStayTravel = $('#txtStayTravel').val();
			
			if (txtSummary == '<p><br></p>') txtSummary = '';
			if (txtTSchedule == '<p><br></p>') txtTSchedule = '';
			if (txtStayTravel == '<p><br></p>') txtStayTravel = '';
			
			/*
			if(!txtSummary) {
				alert('대회요강 내용을 입력해 주세요.');
				oEditors.getById['txtSummary'].exec('FOCUS');
				return;
			}
			
			if(!txtTSchedule) {
				alert('연습일정표 내용을 입력해 주세요.');
				oEditors.getById['txtTSchedule'].exec('FOCUS');
				return;
			}
			
			if(!txtStayTravel) {
				alert('숙박/주변관광 내용을 입력해 주세요.');
				oEditors.getById['txtStayTravel'].exec('FOCUS');
				return;
			}
			*/
			
			if(!txtSummary && !txtTSchedule && !txtStayTravel <%IF TScheduleFile="" Then%>&& !$('#TScheduleFile').val()<%End IF%>) {
				alert('추가정보 내용을 입력해 주세요.');
				return;
			}
												 
			var Del_TScheduleFileYN = '';
			
			if($('#Del_TScheduleFile').is(':checked') == true){ Del_TScheduleFileYN = 'Y';}
			else{ Del_TScheduleFileYN = 'N';}
			
			
			formData.append('txtSummary', txtSummary);
			formData.append('txtTSchedule', txtTSchedule);
			formData.append('txtStayTravel', txtStayTravel);
			formData.append('Del_TScheduleFileYN', Del_TScheduleFileYN);						
			
			if($('#TScheduleFile').val()){ formData.append('TScheduleFile', $('input[name=TScheduleFile]')[0].files[0]);}
		}
																				   
		formData.append('GameTitleIDX', $('#tIDX').val());
		formData.append('GameTitleDtlIDX', $('#GameTitleDtlIDX').val());																				   																		   
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
							case '80'   : msg = '정보를 수정완료하였습니다.'; $('form[name=s_frm]').attr('action','./GameTitleDtl_write.asp'); break;
							case '70'   : msg = '정보를 삭제완료하였습니다.'; $('form[name=s_frm]').attr('action','./index.asp'); break;							
							default		: msg = '정보를 등록완료하였습니다.'; $('form[name=s_frm]').attr('action','./GameTitleDtl_write.asp'); //90
						}           
						alert(msg);
						
						
						$('form[name=s_frm]').submit(); 
					}
					else{  //FALSE|
						
						switch (strcut[1]) { 
							case '99'   : msg = '일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
							case '66'   : msg = '정보 등록에 실패하였습니다.\n관리자에게 문의하세요.'; break;
							case '33'   : msg = '업로드 파일형식이 아닙니다.'; break;
							default 	: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
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
	
	function VIEW_ATTACHFILE(valFileName){		
		//console.log(encodeURIComponent('../dev/dist/dl.asp?FileName='+valFileName));
		
		$(location).attr('href', '../../dev/dist/dl.asp?FileName='+valFileName);				
	}
	
	$(document).ready(function(){		
		
  	});
</script> 
<!-- S : content -->
<section>
  <div id="content"> 
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>대회-추가정보</h2>
      <!-- S: 네비게이션 -->
      <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
        <ul>
          <li>대회정보</li>
          <li>대회운영</li>
          <li>대회-추가정보</li>
        </ul>
      </div>
      <!-- E: 네비게이션 --> 
      
    </div>
    <!-- E: page_title --> 
    
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" name="tIDX" id="tIDX" value="<%=fInject(request("tIDX"))%>" />
      <input type="hidden" name="GameTitleDtlIDX" id="GameTitleDtlIDX" value="<%=GameTitleDtlIDX%>" />
      <input type="hidden" name="i2" id="i2" value="<%=i2%>" />
      <div class="search_top GameTitlelntl_Write"> 
        <!-- s: 검색영역 -->
        
        <div class="search_box">
          <ul>
            <li>
              <h4><%=GameTitleName%></h4>
            </li>
          </ul>
        </div>
        
        <!-- e: 검색영역 --> 
        
        <!-- s: 대회요강 -->
        <div class="edit_box">
          <h2>대회요강</h2>
          <div class="text_box">
            <textarea name="txtSummary" id="txtSummary"><%=txtSummary%></textarea>
          </div>
          <h2>연습일정표</h2>
          <div class="text_box">
            <textarea name="txtTSchedule" id="txtTSchedule"><%=txtTSchedule%></textarea>
            <div>
              <input type="file" name="TScheduleFile" id="TScheduleFile">
              <%
				IF TScheduleFile <> "" Then 
					response.Write "<div class='added-list'>"				  	
					response.Write "	<a href=""javascript:;"" onClick=""VIEW_ATTACHFILE('"&TScheduleFile&"');"">"&iFileExtImg(UCASE(mid(TScheduleFile, instr(TScheduleFile, ".")+1, len(TScheduleFile))))&TScheduleFile&"</a>"
					response.Write "	<span><input type='checkbox' name='Del_TScheduleFile' id='Del_TScheduleFile'>삭제시 체크</span>" 
					response.Write "</div>"
				End IF
				%>
            </div>
          </div>
          <h2>숙박/주변관광</h2>
          <div class="text_box">
            <textarea name="txtStayTravel" id="txtStayTravel"><%=txtStayTravel%></textarea>
          </div>
        </div>
        <!-- e: 대회요강 -->
        
        <%IF tIDX <> "" AND GameTitleDtlIDX <> "" Then%>
        <div class="btn-right-list"> <a href="javascript:chk_Submit('MOD');" class="btn">수정</a> <a href="javascript:chk_Submit('DEL');" class="btn">삭제</a> <!--<a href="javascript:chk_Submit('CANCEL');" class="btn">취소</a>--> <a href="javascript:chk_Submit('LIST');" class="btn">목록</a> </div>
        <%Else%>
        <div class="btn-right-list"> <a href="javascript:chk_Submit('SAVE');" class="btn">등록</a> <a href="javascript:chk_Submit('LIST');" class="btn">목록</a> </div>
        <%End IF%>
      </div>
    </form>
    <!-- E : sch 검색조건 선택 및 입력 --> 
  </div>
</section>
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../../include/footer.asp"-->

<script>
	var oEditors = [];

	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: 'txtSummary',
		sSkinURI: '../../dev/dist/se2/SmartEditor2Skin.html',
		fCreator: 'createSEditor2'
	});	  
	
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: 'txtTSchedule',
		sSkinURI: '../../dev/dist/se2/SmartEditor2Skin.html',
		fCreator: 'createSEditor2'
	});	  
	
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: 'txtStayTravel',
		sSkinURI: '../../dev/dist/se2/SmartEditor2Skin.html',
		fCreator: 'createSEditor2'
	});	  
</script>