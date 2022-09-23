<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"--> 
<script language="javascript">

  var locationStr = 'MajorGame_List.asp';
	

	/*	
	//2 Depth Button output
  	function fnd_Selector(valType) {
		
		var strAjaxUrl='../ajax/MajorGame_Select.asp';
		
		$('.btn-search').attr('class','btn btn-blue-empty');
		$('#btn'+valType).attr('class','btn btn-search');
		$('#fnd_MajorGame').val('');
		//btn btn-back
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {     
				valType	: valType 
			},
			success: function(retDATA) {

				console.log(retDATA);
				
				if(retDATA){
				
					var strcut = retDATA.split('|');
					
					if (strcut[0] == 'TRUE') {						
						$('#fnd_Division').val(valType);				
						$('#btn_MajorGame').html(strcut[1]);				
					}
					else{
						switch (strcut[1]) { 
							case '99'   : msg = '일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
							default 	: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
						}           
						alert(msg);
						return;         	
					}
				}
			},
			error: function(xhr, status, error){
				if(error != ''){
					alert ('오류발생! - 시스템관리자에게 문의하십시오!');
					return;
				}
			}
		});  
	 }
	
	//3 Depth Button output
	function fnd_SelectorSub(valType) {
		var strAjaxUrl='../ajax/MajorGameSub_Select.asp';
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {     
				valType	: valType 
			},
			success: function(retDATA) {

				console.log(retDATA);
				
				if(retDATA){
				
					var strcut = retDATA.split('|');
					
					if (strcut[0] == 'TRUE') {						
						$('#btn_GameCub').html(strcut[1]);				
					}
					else{
						switch (strcut[1]) { 
							case '99'   : msg = '일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
							default 	: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
						}           
						alert(msg);
						return;         	
					}
				}
			},
			error: function(xhr, status, error){
				if(error != ''){
					alert ('오류발생! - 시스템관리자에게 문의하십시오!');
					return;
				}
			}
		});  
	}
	
	//CHK: Button Contents output
	function chk_INFOContents(valType) {
		
		$('#fnd_MajorGame').val(valType);			
		
		switch(valType){
			case 'MAJCUB1'	: case 'MAJCUB2' :
				$('#btn_GameCub > .btn-back').attr('class','btn btn-blue-empty');
				$('#SSubBtn_'+valType).attr('class','btn btn-back');
				break;
			
			default	: 
				if(valType=='MAJINT2'){
					$('#btn_GameCub').show();	
					fnd_SelectorSub('CUB');
				}
				else{
					$('#btn_GameCub').hide();					
				}
				
				$('#btn_MajorGame > .btn-add').attr('class','btn btn-blue-empty');
				$('#SubBtn_'+valType).attr('class','btn btn-add');
	   	}
	}
	*/	
	
  	$(document).ready(function(){
    	//chk_Submit('', '', 1); //대회정보   
    	
		/*
		$('#btn_GameCub').hide();
		$('#fnd_MajorGame').val('');	
		*/
  	});
</script> 
<!-- S : content GameTitleIntl_List -->
<div id="content" class="GameTitleIntl_List">
  <input type="text" name="fnd_Division" id="fnd_Division" />
  <input type="text" name="fnd_MajorGame" id="fnd_MajorGame" />
  <!-- S: page_title -->
  <div class="page_title clearfix">
    <h2>주요국제대회정보</h2>
    <!-- S: 네비게이션 -->
    <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
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
    <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
    <input type="hidden" id="CIDX" name="CIDX"  />
    <div class="search_top community"> 
      
      <!--
		<select name="fnd_Division" id="fnd_Division" class="title_select">
			<option value="GAME" <%IF fnd_Division = "1" Then response.write "selected" End IF%>>국제종합경기</option>
			<option value="INTL" <%IF fnd_Division = "2" Then response.write "selected" End IF%>>주요국제대회</option>
		</select>

		<select name="fnd_MajorGame" id="fnd_MajorGame" class="title_select">
		</select>
		<select name="fnd_GameCub" id="fnd_GameCub" class="title_select">
		</select>
	  	--> 
      <!--
      <a href="javascript:fnd_Selector('GAME');" class="btn btn-blue-empty" id="btnGAME">국제종합경기</a> <a href="javascript:fnd_Selector('INTL');" class="btn btn-blue-empty" id="btnINTL">주요국제대회</a>
      <div id="btn_MajorGame"></div>
      <div id="btn_GameCub"> </div>
      -->
      <!-- S : 리스트형 20개씩 노출 -->
      <div id="board-contents" class="table-list-wrap"> 
        <!-- S : table-list --> 
        <!-- E : table-list --> 
      </div>
      <!-- E : 리스트형 20개씩 노출 --> 
    </div>
  </form>
  <!-- E : sch 검색조건 선택 및 입력 --> 
</div>
<!-- E : content GameTitleIntl_List --> 

<!--#include file="../include/footer.asp"-->