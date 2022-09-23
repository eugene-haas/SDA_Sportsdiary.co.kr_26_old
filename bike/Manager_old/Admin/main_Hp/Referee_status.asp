<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
    Check_AdminLogin()
   
    dim currPage    : currPage    = fInject(request("currPage"))    
    dim fnd_RefereeGb : fnd_RefereeGb = fInject(request("fnd_RefereeGb"))   
    dim fnd_KeyWord   : fnd_KeyWord   = fInject(request("fnd_KeyWord"))
%>  
<script>
	var locationStr = 'Referee_status';
	
	//목록 조회
	function chk_Submit(valType, valIDX, chkPage){

		var strAjaxUrl = '../ajax/Referee_Status.asp';    
		var fnd_RefereeGb = $('#fnd_RefereeGb').val();
		var fnd_KeyWord = $('#fnd_KeyWord').val();

		if(chkPage!='') $('#currPage').val(chkPage);

		var currPage = $('#currPage').val();  

		if(valType=='VIEW'){
			$('#CIDX').val(valIDX);   

			$('form[name=s_frm]').attr('action','./Referee_Write.asp');
			$('form[name=s_frm]').submit(); 
		}
		else{ 

			//전체검색
			if(valType=='ALL') {
				currPage = '';
				fnd_KeyWord = '';
				fnd_RefereeGb = '';

				$('#fnd_KeyWord').val('');
				$('#fnd_RefereeGb').val('');
				$('#currPage').val('');
			}

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',     
				async: false, 
				data: { 
					fnd_RefereeGb : fnd_RefereeGb
					,fnd_KeyWord  : fnd_KeyWord
					,currPage   : currPage
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

		var strAjaxUrl = '../ajax/Select_RefereeGb.asp'; 

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

	//print
	function INFO_PRINT(valIDX){

		$('#CIDX').val(valIDX);

		if(!$('#LC_Num'+valIDX).val()){
			if(confirm('자격발급 번호가 기입누락되었습니다.\n인쇄를 진행하시겠습니까?')){
				window.open('about:blank','PrintViewer');

				$('form[name=s_frm]').attr('target','PrintViewer');
				$('form[name=s_frm]').attr('action','./license_print.asp');
				$('form[name=s_frm]').submit(); 
			}
			else{
				$('#LC_Num'+valIDX).focus();
				return;
			}
		}
		else{
			window.open('about:blank','PrintViewer');

			$('form[name=s_frm]').attr('target','PrintViewer');
			$('form[name=s_frm]').attr('action','./license_print.asp');
			$('form[name=s_frm]').submit(); 	
		}	
	}  

	$(document).ready(function(){   
		fnd_SelectType('fnd_RefereeGb','<%=fnd_RefereeGb%>');
		//목록 조회
		chk_Submit('LIST', '', '<%IF currPage="" Then response.write "1" Else response.write currPage End IF%>'); 
	});  
</script>
<!-- S : content -->
  <div id="content" class="popup_list">
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>경기지도자/심판자격</h2>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>홈페이지관리</li>
          <li><a href="#">팀/선수/클럽/심판</a></li>
          <li>경기지도자/심판자격</li>
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
          <select name="fnd_RefereeGb" id="fnd_RefereeGb" class="title_select">
        <option value="">구분</option>
      </select>
            
            <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" placeholder="이름을 입력하세요" class="ipt-word">
                 
            <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a>
            <a href="javascript:chk_Submit('ALL','',1);" class="btn btn-blue-empty">전체목록</a>            
      <a href="./Referee_write.asp" class="btn btn-blue">등록하기</a>            
        </div>
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
