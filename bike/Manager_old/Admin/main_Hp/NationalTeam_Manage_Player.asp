<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
   	'대표팀 관리 - 선수
    Check_AdminLogin()
   
    dim currPage    	: currPage    		= fInject(request("currPage"))    
    dim fnd_Year 		: fnd_Year 			= fInject(request("fnd_Year"))   
	dim fnd_TeamGb 		: fnd_TeamGb 		= fInject(request("fnd_TeamGb"))    	   
	dim fnd_Sex 		: fnd_Sex 			= fInject(request("fnd_Sex"))    
    dim fnd_KeyWord   	: fnd_KeyWord   	= fInject(request("fnd_KeyWord"))
	 
	IF fnd_Year = "" Then fnd_Year = Year(Date()) 
%>
<script>
	var locationStr = 'NationalTeam_Manage_Player';
	 
	//목록 조회
	function chk_Submit(valType, valIDX, chkPage){

		var strAjaxUrl = '../ajax/NationalTeam_Manage_Player.asp';    
		var fnd_Year = $('#fnd_Year').val();
		var fnd_TeamGb = $('#fnd_TeamGb').val();		
		var fnd_Sex = $('#fnd_Sex').val();		
		var fnd_KeyWord = $('#fnd_KeyWord').val();										  

		if(chkPage) $('#currPage').val(chkPage);

		var currPage = $('#currPage').val();  

		if(valType=='VIEW'){
			$('#CIDX').val(valIDX);   

			$('form[name=s_frm]').attr('action','./NationalTeam_write_Player.asp');
			$('form[name=s_frm]').submit(); 
		}
		else{ 

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',     
				async: false, 
				data: { 
					currPage   		: currPage			
					,fnd_Year 		: fnd_Year			
					,fnd_TeamGb 	: fnd_TeamGb
					,fnd_Sex 		: fnd_Sex			
					,fnd_KeyWord  	: fnd_KeyWord					
				},    
				success: function(retDATA) {

					//console.log(retDATA);

					$('#board-contents').html(retDATA);                               
				}, 
				error: function(xhr, status, error){           
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}    
				}
			});   
		}
	}

	//SELECT BOX Option 리스트 조회      
	function fnd_SelectType(attname, code) {

		var strAjaxUrl = '../ajax/Select_NationalTeam_Manage.asp'; 

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			async: false, 
			data: {     
				code  : code 
			},
			success: function(retDATA) {

				//console.log(retDATA);

				$('#'+attname).empty().append();
				$('#'+attname).append(retDATA);
			},
			error: function(xhr, status, error){
				if(error != ''){
					alert ('오류발생! - 시스템관리자에게 문의하십시오!');
					return;
				}
			}
		});      
	}
	

	$(document).ready(function(){   
		fnd_SelectType('fnd_TeamGb','<%=fnd_TeamGb%>');
		//목록 조회
		chk_Submit('', '', '<%IF currPage="" Then response.write "1" Else response.write currPage End IF%>'); 
	});  
</script> 
<!-- S : content -->
<div id="content" class="popup_list"> 
  <!-- S: page_title -->
  <div class="page_title clearfix">
    <h2>대표팀 관리-선수</h2>
    
    <!-- S: 네비게이션 -->
    <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
      <ul>
        <li>홈페이지관리</li>
        <li>팀/선수/클럽/심판</li>
        <li>대표팀 관리-선수</li>
      </ul>
    </div>
    <!-- E: 네비게이션 --> 
  </div>
  <!-- E: page_title --> 
  
  <!-- S : sch 검색조건 선택 및 입력 -->
  <form name="s_frm" method="post">
    <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
    <input type="hidden" id="CIDX" name="CIDX" />
    <div class="search_top">
      <div class="search_box">
		  
        <select name="fnd_Year" id="fnd_Year" class="title_select">
          <option value="2018" <%IF fnd_Year = "2018" Then response.write "selected" End IF%>>2018 년</option>
          <option value="2019" <%IF fnd_Year = "2019" Then response.write "selected" End IF%>>2019 년</option>
          <option value="2020" <%IF fnd_Year = "2020" Then response.write "selected" End IF%>>2020 년</option>
        </select>
        <select name="fnd_TeamGb" id="fnd_TeamGb" class="title_select">
          <option value="">대표팀구분</option>
        </select>		
		<select name="fnd_Sex" id="fnd_Sex" class="title_select">
		  <option value="" selected>성별</option>	
          <option value="Man" <%IF fnd_Sex = "Man" Then response.write "selected" End IF%>>남자</option>
          <option value="WoMan" <%IF fnd_Sex = "WoMan" Then response.write "selected" End IF%>>여자</option>          
        </select>
        <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" placeholder="이름을 입력하세요" class="ipt-word">
        <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a><a href="./NationalTeam_write_Player.asp" class="btn btn-blue">등록하기</a> </div>
      <!-- S : 리스트형 20개씩 노출 -->
      <div id="board-contents" class="table-list-wrap referee-table"> 
        <!-- S : table-list --> 
        <!-- E : table-list --> 
      </div>
      <!-- E : 리스트형 20개씩 노출 --> 
    </div>
  </form>
  <!-- E : sch 검색조건 선택 및 입력 --> 
</div>
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../include/footer.asp"-->