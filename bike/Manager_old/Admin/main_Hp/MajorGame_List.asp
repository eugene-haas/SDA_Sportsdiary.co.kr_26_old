<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
	dim currPage      : currPage      	= fInject(Request("currPage"))
	dim fnd_KeyWord   : fnd_KeyWord   	= fInject(Request("fnd_KeyWord"))
	dim fnd_MajorGame : fnd_MajorGame   = fInject(Request("fnd_MajorGame"))
	dim fnd_Division  : fnd_Division   	= fInject(Request("fnd_Division"))
%>
<script language="javascript">

	var locationStr = 'MajorGame_List.asp';
	


	//검색
	function chk_Submit(valType, valIDX, chkPage){

		var strAjaxUrl = '../Ajax/GameTitleMenu/MajorGame_List.asp';    
		var fnd_Division = $('#fnd_Division').val();  
		var fnd_MajorGame = $('#fnd_MajorGame').val();

		if(chkPage!='') $('#currPage').val(chkPage);

		var currPage = $('#currPage').val();

		if(valType=='VIEW' || valType=='WRITE'){
			$('#CIDX').val(valIDX);   
			$('form[name=s_frm]').attr('action','./MajorGame_Write.asp');
			$('form[name=s_frm]').submit(); 
		}
		else{ 
			//전체검색
			if(valType=='ALL') {
				currPage = '';
				fnd_Division = '';
				fnd_MajorGame = '';  
				
				$('#currPage').val(1);
				$('#fnd_Division').val('');
				$('#fnd_MajorGame').val('');
			}

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',    				
				data: { 
					currPage      	: currPage     
					,fnd_Division  	: fnd_Division
					,fnd_MajorGame  : fnd_MajorGame
				},    
				success: function(retDATA) {
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

	$(document).on('change', '#fnd_Division', function(){
		make_box('sel_fnd_MajorGame', 'fnd_MajorGame', $('#fnd_Division').val()+',', 'Info_MajorGame');
	});
	
	$(document).ready(function(){
		chk_Submit('', '', 1); 

		make_box('sel_fnd_MajorGame', 'fnd_MajorGame', <%IF fnd_Division<> "" Then response.write "'"&fnd_Division&"'" Else response.write "$('#fnd_Division').val()" End IF%>+',<%=fnd_MajorGame%>', 'Info_MajorGame'); //Select Box Option 
	});
</script>
<!-- S : content GameTitleIntl_List -->
  <div id="content" class="GameTitleIntl_List">
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
      <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
      <input type="hidden" id="CIDX" name="CIDX"  />
      <div class="search_top community">
        <div class="search_box">          
    	<select name="fnd_Division" id="fnd_Division" class="title_select">
			<option value="">대회구분Ⅰ</option>
			<option value="GAME" <%IF fnd_Division = "GAME" Then response.write "selected" End IF%>>국제종합경기</option>
			<option value="INTL" <%IF fnd_Division = "INTL" Then response.write "selected" End IF%>>주요국제대회</option>
		</select>

    <span id="sel_fnd_MajorGame">
    <select name="fnd_MajorGame" id="fnd_MajorGame" class="title_select">    
		<option value="">대회구분Ⅱ</option>
    </select></span>  
            <!--<input type="text" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" placeholder="대회명, 대회명영문, 도시, 대회장소" class="ipt-word">-->
          <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a>
          <a href="javascript:chk_Submit('ALL','',1);" class="btn btn-blue-empty">전체목록</a>
          <a href="javascript:chk_Submit('WRITE','',1);" class="btn btn-add">국제대회정보 등록</a>
        </div>
        
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
