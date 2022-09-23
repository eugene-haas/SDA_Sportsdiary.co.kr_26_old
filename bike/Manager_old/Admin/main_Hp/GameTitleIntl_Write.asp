<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
	dim currPage      	: currPage      = fInject(Request("currPage"))
	dim fnd_KeyWord   	: fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
	dim fnd_Country   	: fnd_Country   = fInject(Request("fnd_Country"))
	dim fnd_Year   		: fnd_Year 		= fInject(Request("fnd_Year"))   
	dim CIDX			: CIDX   		= fInject(Request("CIDX"))
	
	dim CSQL, CRs
	dim GameTitleName, GameTitleEnName, GameS, GameE, ViewYN, ct_serial, City, GamePlace
   	dim Summary, PlayerList, PlayerListFile, GameScedule, GameSceduleFile, GameResult, GameResultFile
	dim URLMatch, URLSchedule
   
	IF CIDX <> "" Then
	
		CSQL = "		SELECT * "
		CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblGameTitleIntl]"
		CSQL = CSQL & " WHERE DelYN = 'N'"
		CSQL = CSQL & " 	AND GameTitleIDX = '"&CIDX&"'"
		
		SET CRs = DBCon.Execute(CSQL)   
		IF Not(CRs.eof or CRs.bof) Then			
			GameTitleName = CRs("GameTitleName")
			GameTitleEnName = CRs("GameTitleEnName")
			GameS = CRs("GameS")
			GameE = CRs("GameE")
			ViewYN = CRs("ViewYN")
			ct_serial = CRs("ct_serial")
			City = CRs("City")
			GamePlace = CRs("GamePlace")
			Summary = CRs("Summary")
			PlayerList = CRs("PlayerList")
			PlayerListFile = CRs("PlayerListFile")
			GameScedule = CRs("GameScedule")
			GameSceduleFile = CRs("GameSceduleFile")
			GameResult = CRs("GameResult")
			GameResultFile = CRs("GameResultFile")
			URLMatch = CRs("URLMatch")
			URLSchedule = CRs("URLSchedule")
		End IF
			CRs.Close
		SET CRs = Nothing
		
		IF fnd_Country = "" Then fnd_Country = ct_serial
	End IF
	
%>
<script src="../js/jscolor.js"></script>
<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>
<script language="javascript">
	/**
	 * locationStr로 표시 될 index 체크
	 */
	var locationStr = "GameTitleIntl_list.asp";
	
	function chk_Submit(valType){
		switch(valType){
			case 'DEL'	:
				if(confirm('대회정보를 삭제하시겠습니까?'))	{
					on_Submit(valType);
				}
				else{return;}	
				break;

			case 'MOD': case 'SAVE'	:
				on_Submit(valType);	
				break;
			
			case 'LIST'	:
				$('form[name=s_frm]').attr('action','./GameTitleIntl_List.asp');
				$('form[name=s_frm]').submit();
				//$(location).attr('href', './GameTitleIntl_List.asp');
				break;
			
			default		: 	window.history.back();	
		}
	}
	
	function on_Submit(valType){
		var formData = new FormData();
		var strAjaxUrl = '../Ajax/GameTitleMenu/GameTitleIntl_Write.asp';
		
		if(valType=='MOD' || valType=='SAVE'){
			
			if(!$('#GameTitleName').val()){
				alert('대회명을 입력해 주세요.');
				$('#GameTitleName').focus();
				return;
			}
			
			if(!$('#GameS').val()){
				alert('대회기간 시작일을 선택해 주세요.');
				$('#GameS').focus();
				return;
			}
			
			if(!$('#GameE').val()){
				alert('대회기간 종료일을 입력해 주세요.');
				$('#GameE').focus();
				return;
			}
			
			if(!$('input:radio[name=ViewYN]').is(':checked')){
				alert('대회 노출여부를 선택해 주세요.'); 
				return;
			}
			
			var elClickedObj = $("#s_frm");

			oEditors.getById["Summary"].exec("UPDATE_CONTENTS_FIELD", []);
			oEditors.getById["PlayerList"].exec("UPDATE_CONTENTS_FIELD", []);
			oEditors.getById["GameScedule"].exec("UPDATE_CONTENTS_FIELD", []);
			oEditors.getById["GameResult"].exec("UPDATE_CONTENTS_FIELD", []);

			var Summary = $("#Summary").val();
			var PlayerList = $("#PlayerList").val();
			var GameScedule = $("#GameScedule").val();
			var GameResult = $("#GameResult").val();

			if (Summary == '<p><br></p>') Summary = '';
			if (PlayerList == '<p><br></p>') PlayerList = '';
			if (GameScedule == '<p><br></p>') GameScedule = '';
			if (GameResult == '<p><br></p>') GameResult = '';
			
			/*
			if(!Summary) {
				alert('대회요강 내용을 입력해 주세요.');
				oEditors.getById["Summary"].exec("FOCUS");
				return;
			}
			
			if(!PlayerList) {
				alert('대회 출전선수명단 내용을 입력해 주세요.');
				oEditors.getById["PlayerList"].exec("FOCUS");
				return;
			}
			
			if(!GameScedule) {
				alert('대회일정 내용을 입력해 주세요.');
				oEditors.getById["GameScedule"].exec("FOCUS");
				return;
			}
			
			if(!GameResult) {
				alert('대회결과 내용을 입력해 주세요.');
				oEditors.getById["GameResult"].exec("FOCUS");
				return;
			}
			*/
			
			var Del_PlayerListFileYN = '';
			var Del_GameSceduleFileYN = '';
			var Del_GameResultFileYN = '';
			
			if($('#Del_PlayerListFile').is(':checked') == true){ Del_PlayerListFileYN = 'Y';}
			else{ Del_PlayerListFileYN = 'N';}
			if($('#Del_GameSceduleFile').is(':checked') == true){ Del_GameSceduleFileYN = 'Y';}
			else{ Del_GameSceduleFileYN = 'N';}
			if($('#Del_GameResultFile').is(':checked') == true){ Del_GameResultFileYN = 'Y';}
			else{ Del_GameResultFileYN = 'N';}
			
			formData.append('GameTitleName', $('#GameTitleName').val());
			formData.append('GameTitleEnName', $('#GameTitleEnName').val());
			formData.append('ViewYN', $('input:radio[name=ViewYN]:checked').val());			
			formData.append('GameS', $('#GameS').val());
			formData.append('GameE', $('#GameE').val());
			formData.append('City', $('#City').val());
			formData.append('GamePlace', $('#GamePlace').val());
			formData.append('fnd_Country', $('#fnd_Country').val());
			formData.append('URLMatch', $('#URLMatch').val());
			formData.append('URLSchedule', $('#URLSchedule').val());			
			
			formData.append('Summary', Summary);
			formData.append('PlayerList', PlayerList);
			formData.append('GameScedule', GameScedule);
			formData.append('GameResult', GameResult);
			
			formData.append('Del_PlayerListFileYN', Del_PlayerListFileYN);						
			formData.append('Del_GameSceduleFileYN', Del_GameSceduleFileYN);						
			formData.append('Del_GameResultFileYN', Del_GameResultFileYN);						
			
			if($('#PlayerListFile').val()){ formData.append('PlayerListFile', $('input[name=PlayerListFile]')[0].files[0]);}
			if($('#GameSceduleFile').val()){ formData.append('GameSceduleFile', $('input[name=GameSceduleFile]')[0].files[0]);}
			if($('#GameResultFile').val()){ formData.append('GameResultFile', $('input[name=GameResultFile]')[0].files[0]);}
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
							case '90'  : msg = '대회정보를 등록완료하였습니다.'; break;
							case '80'   : msg = '대회정보를 수정완료하였습니다.'; break;
							case '70'   : msg = '대회정보를 삭제완료하였습니다.'; break;							
						}           
						alert(msg);
						
						$('form[name=s_frm]').attr('action','./GameTitleIntl_List.asp');
						$('form[name=s_frm]').submit(); 
					}
					else{  //FALSE|
						
						switch (strcut[1]) { 
							case '99'   : msg = '일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
							case '66'   : msg = '대회정보 등록에 실패하였습니다.\n관리자에게 문의하세요.'; break;
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
		
		$(location).attr('href', '../dev/dist/dl.asp?FileName='+valFileName);				
	}
	
	$(document).ready(function(){		
		make_box('sel_fnd_Country','fnd_Country','<%=fnd_Country%>','Info_Country');	//국가 셀렉트박스 생성				
  	});
</script> 
<!-- S : content -->
<section>
  <div id="content">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>국제대회</h2>
        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>홈페이지관리</li>
            <li>대회정보</li>
            <li>국제대회</li>
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
      <input type="hidden" name="fnd_Year" id="fnd_Year" value="<%=fnd_Year%>" />
	  <input type="hidden" name="FileName" id="FileName" />		
      <div class="search_top GameTitlelntl_Write">
				<!-- s: 검색영역 -->
        <div class="search_box">
					<ul>
						<li>
							<span class="l_name">대회명</span>
							<input type="text" name="GameTitleName" class="title_input in_4 in_1" id="GameTitleName" value="<%=GameTitleName%>" />
						</li>
						<li>
							<span class="l_name">대회명 영문</span>
							<input type="text" name="GameTitleEnName" class="title_input in_4 in_1" id="GameTitleEnName" value="<%=GameTitleEnName%>" />
						</li>
					</ul>
					<ul>
						<li>
							<span class="l_name">대회기간</span>
							<input type="date" id="GameS" name="GameS" class="date_ipt in_3" value="<%=GameS%>"/>
                ~
               <input type="date" id="GameE" name="GameE" class="date_ipt in_3" value="<%=GameE%>"/>
						</li>
						<li>
							<span class="l_name">국가</span>
							<span id="sel_fnd_Country">
								<select name="fnd_Country" id="fnd_Country" class="title_select in_4">
									<option value="" selected>국가</option>
								</select>
							</span>
						</li>
						<li>
							<span class="l_name">도시</span>
							<input type="text" name="City" id="City" class="title_input in_2" value="<%=City%>" />
						</li>
						<li>
							<span class="l_name">대회장소</span>
							<input type="text" name="GamePlace" id="GamePlace" class="title_input in_4" value="<%=GamePlace%>" />
						</li>
			</ul>
			<ul>
						<li>
							<span class="l_name">토너먼트소프트 바로가기 : 대진표</span>
							<input type="text" name="URLMatch" id="URLMatch" class="title_input in_4 in_1" value="<%=URLMatch%>" />
						</li>
						<li>
							<span class="l_name">경기일정</span>
							<input type="text" name="URLSchedule" id="URLSchedule" class="title_input in_4 in_1" value="<%=URLSchedule%>" />
						</li>
			</ul>
			<ul>
						<li><span class="l_name">출력구분</span>
							<label for="ViewYN">
								<span>On</span>
								<input type="radio" name="ViewYN" id="ViewYN" value="Y" <%IF ViewYN = "Y" Then response.write "checked" End IF%>>
							</label>
							<label for="ViewYN">
								<span>Off</span>
								<input type="radio" name="ViewYN" id="ViewYN" value="N" <%IF ViewYN = "N" Then response.write "checked" End IF%> >
							</label>
						</li>
					</ul>
        </div>
				<!-- e: 검색영역 -->


				<!-- s: 대회요강 -->
				<div class="edit_box">
					<h2>대회요강</h2>
					<div class="text_box">
						<textarea name="Summary" id="Summary"><%=Summary%></textarea>
					</div>
					<h2>출전선수명단</h2>
					<div class="text_box">
						<textarea name="PlayerList" id="PlayerList"><%=PlayerList%></textarea>
						<div>
							<input type="file" name="PlayerListFile" id="PlayerListFile"> 
							<%
							IF PlayerListFile <> "" Then 
								response.Write "<div class='added-list'>"				  	
								response.Write "	<a href=""javascript:;"" onClick=""VIEW_ATTACHFILE('"&PlayerListFile&"');"">"&iFileExtImg(UCASE(mid(PlayerListFile, instr(PlayerListFile, ".")+1, len(PlayerListFile))))&PlayerListFile&"</a>"
								response.Write "	<span><input type='checkbox' name='Del_PlayerListFile' id='Del_PlayerListFile'>삭제시 체크</span>" 
								response.Write "</div>"
							End IF
							%>
						</div>
					</div>
					<h2>대회일정</h2>
					<div class="text_box">
						<textarea name="GameScedule" id="GameScedule"><%=GameScedule%></textarea>
						<div>
							<input type="file" name="GameSceduleFile" id="GameSceduleFile"> 
                <%
                IF GameSceduleFile <> "" Then 
                  	response.Write "<div class='added-list'>"
                  	response.Write "	<a href=""javascript:;"" onClick=""VIEW_ATTACHFILE('"&GameSceduleFile&"');"">"&iFileExtImg(UCASE(mid(GameSceduleFile, instr(GameSceduleFile, ".")+1, len(GameSceduleFile))))&GameSceduleFile&"</a>"
                    response.Write "	<span><input type='checkbox' name='Del_GameSceduleFile' id='Del_GameSceduleFile'>삭제시 체크</span>" 
                  	response.Write "</div>"
                End IF
                %>
						</div>
					</div>
					<h2>대회결과</h2>
					<div class="text_box">
						<textarea name="GameResult" id="GameResult"><%=GameResult%></textarea>
						<div>
							<input type="file" name="GameResultFile" id="GameResultFile"> 
                <%
                IF GameResultFile <> "" Then 
                  	response.Write "<div class='added-list'>"
                  	response.Write "	<a href=""javascript:;"" onClick=""VIEW_ATTACHFILE('"&GameResultFile&"');"">"&iFileExtImg(UCASE(mid(GameResultFile, instr(GameResultFile, ".")+1, len(GameResultFile))))&GameResultFile&"</a>"
                    response.Write "	<span><input type='checkbox' name='Del_GameResultFile' id='Del_GameResultFile'>삭제시 체크</span>" 
                  	response.Write "</div>"
                End IF
                %>
						</div>
					</div>
				</div>
				<!-- e: 대회요강 -->

				

        <%IF CIDX<>"" Then%>
        <div class="btn-right-list"> <a href="javascript:chk_Submit('MOD');" class="btn">수정</a> <a href="javascript:chk_Submit('DEL');" class="btn">삭제</a> <a href="javascript:chk_Submit('CANCEL');" class="btn">취소</a> <a href="javascript:chk_Submit('LIST');" class="btn">목록</a> </div>
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
<!--#include file="../include/footer.asp"-->
	  
<script>
	var oEditors = [];

	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: 'Summary',
		sSkinURI: '../dev/dist/se2/SmartEditor2Skin.html',
		fCreator: 'createSEditor2'
	});	  
	
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: 'PlayerList',
		sSkinURI: '../dev/dist/se2/SmartEditor2Skin.html',
		fCreator: 'createSEditor2'
	});	  
	
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: 'GameScedule',
		sSkinURI: '../dev/dist/se2/SmartEditor2Skin.html',
		fCreator: 'createSEditor2'
	});	  
	
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: 'GameResult',
		sSkinURI: '../dev/dist/se2/SmartEditor2Skin.html',
		fCreator: 'createSEditor2'
	});	  
</script>	