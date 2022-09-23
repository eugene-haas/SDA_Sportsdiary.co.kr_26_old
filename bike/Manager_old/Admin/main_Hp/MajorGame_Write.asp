<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
	dim currPage      	: currPage      	= fInject(Request("currPage"))
	dim fnd_Division   	: fnd_Division  	= fInject(Request("fnd_Division"))
   	dim fnd_MajorGame   : fnd_MajorGame   	= fInject(Request("fnd_MajorGame"))	
	dim CIDX			: CIDX   			= crypt.DecryptStringENC(fInject(Request("CIDX")))
	
	dim CSQL, CRs
	dim Division, GameYear, GamePlace, GameType, GameTypeSub, Contents
		
	IF CIDX <> "" Then
	
		CSQL = "		SELECT * "
		CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblMajorGameInfo]"
		CSQL = CSQL & " WHERE DelYN = 'N'"
		CSQL = CSQL & " 	AND MajorGameIDX = '"&CIDX&"'"
		
		SET CRs = DBCon.Execute(CSQL)   
		IF Not(CRs.eof or CRs.bof) Then			
			Division = CRs("Division")
			GameYear = CRs("GameYear")
			GamePlace = ReHtmlSpecialChars(trim(CRs("GamePlace")))
			GameType = CRs("GameType")
			GameTypeSub = CRs("GameTypeSub")			
			Contents = CRs("Contents")
		End IF
			CRs.Close
		SET CRs = Nothing
		
		'IF Division = "" Then Division = fnd_Division
		'IF GameType = "" Then GameType = fnd_MajorGame
		
		IF fnd_Division = "" Then fnd_Division = Division
		IF fnd_MajorGame = "" Then fnd_MajorGame = GameType

	End IF
	
%>
<script src="../js/jscolor.js"></script>
<script src="../dev/dist/se2/js/service/HuskyEZCreator.js" type="text/javascript" charset="utf-8"></script>
<script language="javascript">
	var locationStr = 'MajorGame_List.asp';
	
	function chk_Submit(valType){
		switch(valType){
			case 'DEL'	:
				if(confirm('선택하신 정보를 삭제하시겠습니까?'))	{
					on_Submit(valType);
				}
				else{
					return;
				}	
				break;

			case 'MOD': case 'SAVE'	:
				on_Submit(valType);	
				break;
			
			case 'LIST'	:
				$('form[name=s_frm]').attr('action','./MajorGame_List.asp');
				$('form[name=s_frm]').submit();
				//$(location).attr('href', './GameTitleIntl_List.asp');
				break;
			
			default		: 	window.history.back();	
		}
	}
	
	function on_Submit(valType){
		var strAjaxUrl = '../Ajax/GameTitleMenu/MajorGame_Write.asp';
		
		if(valType=='MOD' || valType=='SAVE'){
			
			
			if(!$('#fnd_Division').val()){
				alert('대회구분(Ⅰ)을 선택해 주세요.');
				$('#fnd_Division').focus();
				return;
			}
			else{
				if($('#fnd_Division').val()=='GAME'){
					if(!$('#GameYear').val()){
						alert('개최년도를 입력해주세요.');
						$('#GameYear').focus();
						return;
					}

					if(!$('#GamePlace').val()){
						alert('개최장소를 입력해주세요.');
						$('#GamePlace').focus();
						return;
					}
				}
			}			
			
			if(!$('#fnd_MajorGame').val()){
				alert('대회구분(Ⅱ)을 선택해 주세요.');
				$('#fnd_MajorGame').focus();
				return;
			}
			else{
				if($('#fnd_MajorGame').val()=='MAJINT2'){
					if(!$('#fnd_MajorCub').val()){
						alert('대회구분(Ⅲ)을 선택해 주세요.');
						$('#fnd_MajorCub').focus();
						return;
					}	
				}
			}
			
			
			var elClickedObj = $("#s_frm");

			oEditors.getById["Contents"].exec("UPDATE_CONTENTS_FIELD", []);

			var Contents = $("#Contents").val();

			if (Contents == '<p><br></p>') Contents = '';
			
			
			if(!Contents) {
				alert('내용을 입력해 주세요.');
				oEditors.getById["Contents"].exec("FOCUS");
				return;
			}
			
			var fnd_Division = $('#fnd_Division').val();
			var fnd_MajorGame = $('#fnd_MajorGame').val();
			var fnd_MajorCub = $('#fnd_MajorCub').val();
			var GameYear = $('#GameYear').val();
			var GamePlace = $('#GamePlace').val();
		}
		
		var CIDX = $('#CIDX').val();
		
		
		var msg = '';
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',    				
			data: { 
				fnd_Division  	: fnd_Division
				,fnd_MajorGame  : fnd_MajorGame
				,fnd_MajorCub  	: fnd_MajorCub
				,GameYear  		: GameYear
				,GamePlace 		: GamePlace
				,Contents  		: Contents
				,CIDX  			: CIDX
				,valType  		: valType
			}, 
			success: function(retDATA) {
				
				console.log(retDATA);
				
				if(retDATA){
				
					var strcut = retDATA.split('|');
					
					if (strcut[0] == 'TRUE') {
						
						switch (strcut[1]) { 
							case '90'  	: msg = '정보를 등록완료하였습니다.'; break;
							case '80'   : msg = '정보를 수정완료하였습니다.'; break;
							case '70'   : msg = '정보를 삭제완료하였습니다.'; break;							
						}           
						alert(msg);
						
						if(strcut[1]=='90'){
							$(location).attr('href','./MajorGame_List.asp');
						}
						else{
							$('form[name=s_frm]').attr('action','./MajorGame_List.asp');
							$('form[name=s_frm]').submit(); 
						} 							
					}
					else{  //FALSE|
						
						switch (strcut[1]) { 
							case '99'   : msg = '일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
							case '66'   : msg = '정보 등록에 실패하였습니다.\n관리자에게 문의하세요.'; break;
							case '33'   : msg = '선택한 대회구분 카테고리의 정보가 이미 등록되어 있습니다.\n확인 후 다시 이용하세요.'; break;	
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
	
	$(document).on('change', '#fnd_Division', function(){
		make_box('sel_fnd_MajorGame', 'fnd_MajorGame', $('#fnd_Division').val()+',', 'Info_MajorGame');
		
		//개최년도는 국제 종합경기에만 해당됨 
		if($('#fnd_Division').val()=='GAME'){
			$('#div_GameYear').show();			
			$('#div_GamePlace').show();			
		}
		else {
			$('#div_GameYear').hide();
			$('#div_GamePlace').hide();
			$('#GameYear').val('');
			$('#GamePlace').val('');
		}
	});
	
	$(document).on('change', '#fnd_MajorGame', function(){
		if($('#fnd_MajorGame').val()=='MAJINT2'){
			$('#div_fnd_MajorCub').show();	
			make_box('sel_fnd_MajorCub', 'fnd_MajorCub', $('#fnd_MajorGame').val()+',<%=GameTypeSub%>', 'Info_MajorCub'); //Select Box Option 	
		}
		else{
			$('#div_fnd_MajorCub').hide();	
			//$('#fnd_MajorCub').val('');	
		}
	});
	
	$(document).ready(function(){		
		make_box('sel_fnd_MajorGame', 'fnd_MajorGame', $('#fnd_Division').val()+',<%=GameType%>', 'Info_MajorGame'); //Select Box Option 		
		
		//개최년도는 국제 종합경기에만 해당됨 
		if($('#fnd_Division').val()=='GAME'){
			$('#div_GameYear').show();			
			$('#div_GamePlace').show();						
		}
		else {//주요국제대회
			$('#div_GameYear').hide();
			$('#div_GamePlace').hide();
			$('#GameYear').val('');
			$('#GamePlace').val('');
			
			
			//alert('<%=fnd_MajorGame%>')
			//초기화
			<%				
			IF fnd_MajorGame = "MAJINT2" Then
				response.write "$('#div_fnd_MajorCub').show();"
				response.write "make_box('sel_fnd_MajorCub', 'fnd_MajorCub', '"&GameType&","&GameTypeSub&"', 'Info_MajorCub');" 	'Select Box Option 		
			Else
				response.write "$('#div_fnd_MajorCub').hide();"
			End IF
			%>
			
		}		
  	});
</script> 
<!-- S : content -->
<section>
  <div id="content">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>주요국제대회정보</h2>
        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>홈페이지관리</li>
            <li>대회정보</li>
            <li>주요국제대회정보</li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
    
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" name="CIDX" id="CIDX" value="<%=fInject(Request("CIDX"))%>" />
      <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
      <div class="search_top MajorGame_Write">
        <div class="search_box">
					<ul>
						<li>
							<span class="l_name">대회구분 Ⅰ</span>
							<select name="fnd_Division" id="fnd_Division" class="title_select">
								<option value="" selected>대회구분Ⅰ</option>
								<option value="GAME" <%IF Division = "GAME" Then response.write "selected" End IF%>>국제종합경기</option>
								<option value="INTL" <%IF Division = "INTL" Then response.write "selected" End IF%>>주요국제대회</option>
							</select>
						</li>
						<li>
							<span class="l_name">대회구분 Ⅱ</span>							
							<span id="sel_fnd_MajorGame">
								<select name="fnd_MajorGame" id="fnd_MajorGame" class="title_select">    	
								</select>
							</span>							
						</li>
						<li id="div_fnd_MajorCub">
							<span class="l_name">대회구분 Ⅲ</span>							
							<span id="sel_fnd_MajorCub">
								<select name="fnd_MajorCub" id="fnd_MajorCub" class="title_select">    	
								</select>
							</span>							
						</li>
						<li>
							<span class="l_name">개최년도</span>
							<input type="text" id="GameYear" name="GameYear" value="<%=GameYear%>" onkeyup='chk_InputValue(this, "Digit")' />
						</li>
						<li>
							<span class="l_name">개최장소</span>
							<input type="text" id="GamePlace" name="GamePlace" value="<%=GamePlace%>" class="in_4" />
						</li>
					</ul>
        </div>

				<div class="edit_box">
					<h2>내용</h2>
					<div class="text_box">
						<textarea name="Contents" id="Contents" style="height:400px;"><%=Contents%></textarea>
					</div>
				</div>
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
		elPlaceHolder: 'Contents',
		sSkinURI: '../dev/dist/se2/SmartEditor2Skin.html',
		fCreator: 'createSEditor2'
	});	  
		  
</script>	