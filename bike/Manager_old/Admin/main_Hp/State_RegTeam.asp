<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
  <%
  Check_AdminLogin()
%>
  <script language="javascript">
	/**
	* left-menu 체크
	*/
	var locationStr = ""; // 
	/* left-menu 체크 */

	//검색
	function chk_Submit(valType){

		var strAjaxUrl = '../Ajax/State_RegTeam.asp';
		var fnd_Year = $('#fnd_Year').val();
		var fnd_TeamGb = $('#fnd_TeamGb').val();

		if(valType=='PRINT') {
			$('form[name=s_frm]').attr('action','./State_RegTeam_Excel.asp');
			$('form[name=s_frm]').submit(); 
		}
		else{
			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					fnd_Year  	: fnd_Year
					,fnd_TeamGb : fnd_TeamGb
				},    
				success: function(retDATA) {
					//console.log(retDATA);

					$('#board-contents').html(retDATA);
				}, 
				error: function(xhr, status, error){
					if(error){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});   
		}
	}

	$(document).on('change', '#fnd_Year', function(){
		chk_Submit('FND');      
	});
	  
	//종별 조회 																 
	$(document).on('change', '#fnd_TeamGb', function(){
		chk_Submit('FND');      
	});  

	$(document).ready(function(){
		//Make SelectBox OPTION LIST: 등록팀 현황 년도 
		make_box('sel_fnd_Year', 'fnd_Year', '<%IF fnd_Year <> "" Then response.write fnd_Year Else response.write Year(Date()) End IF%>', 'RegYear_Team');
		//Make SelectBox OPTION LIST: 종별
		make_box('sel_fnd_TeamGb','fnd_TeamGb','','TeamGb');	
		
		chk_Submit('FND');    
		
	});
</script> 
  <!-- S : content association_list -->
  <div id="content" class="association_list reg_team"> 
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>등록팀 현황(종별) </h2>
      
      <!-- S: 네비게이션 -->
      <div class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
        <ul>
          <li>대회정보</li>
          <li>대회운영</li>
          <li>등록팀 현황(종별)</li>
        </ul>
      </div>
      <!-- E: 네비게이션 --> 
      
    </div>
    <!-- E: page_title --> 
    
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <div class="search_box reg-team"> <span id="sel_fnd_Year">
        <select name="fnd_Year" id="fnd_Year" class="title_select">
          <!--
        <option value="2018" <%IF fnd_Year = "2018" Then response.write "selected" End IF%>>2018</option>
        <option value="2019" <%IF fnd_Year = "2019" Then response.write "selected" End IF%>>2019</option>
        <option value="2020" <%IF fnd_Year = "2020" Then response.write "selected" End IF%>>2020</option>
		-->
        </select>
		  </span>
        <span id="sel_fnd_TeamGb">
        <select name="fnd_TeamGb" id="fnd_TeamGb" class="title_select">
          <option value="" selected>종별선택</option>
        </select>
        </span> 
		<span><a href="javascript:chk_Submit('PRINT');" class="btn btn-search">엑셀저장</a></span> 
	  </div>
      <div class="search_top community">
        <div class="community"> 
          <!-- S : 리스트형 20개씩 노출 -->
          <div id="board-contents" class="table-list-wrap"> 
            <!-- S : table-list --> 
            <!-- E : table-list --> 
          </div>
          <!-- E : 리스트형 20개씩 노출 --> 
        </div>
      </div>
    </form>
    <!-- E : sch 검색조건 선택 및 입력 --> 
  </div>
  <!-- E : content association_list --> 
  <!--#include file="../include/footer.asp"-->