<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%  
	'목록페이지
	dim currPage      	: currPage        	= fInject(Request("currPage"))
	dim fnd_KeyWord   	: fnd_KeyWord     	= fInject(Request("fnd_KeyWord"))  
	dim fnd_ResultGb   	: fnd_ResultGb     	= fInject(Request("fnd_ResultGb"))  
	dim SDate			: SDate	 			= fInject(Request("SDate"))		
	dim EDate			: EDate	 			= fInject(Request("EDate"))		 
%>
<script>
	function chk_Submit(valType, valIDX, chkPage){

		if(valType == "VIEW"){
			$("#CIDX").val(valIDX);   
			$('form[name=s_frm]').attr('action',"./sdmall_request_view.asp");     
			$('form[name=s_frm]').submit(); 
		}
		else{
			
			if(chkPage) $('#currPage').val(chkPage);
   
   			var strAjaxUrl = './ajax/sdmall_request_list.asp';
			var currPage = $('#currPage').val();
			var fnd_KeyWord = $('#fnd_KeyWord').val();
			var fnd_ResultGb = $('#fnd_ResultGb').val();
			var SDate = $('#SDate').val();
			var EDate = $('#EDate').val();
   	
			console.log(SDate);
								  
			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',     
				data: { 
					currPage 		: currPage 
					,fnd_KeyWord 	: fnd_KeyWord
					,fnd_ResultGb 	: fnd_ResultGb 	
					,SDate 			: SDate 
					,EDate 			: EDate 
				},    
				success: function(retDATA) {

					console.log(retDATA);

					$('#board_list').html(retDATA);
				}, 
				error: function(xhr, status, error){           
					if(error!=''){
						alert('오류발생! - 시스템관리자에게 문의하십시오!');     
						return;
					}
				}
			}); 
		}   
	}

  
	$(document).ready(function(){
		chk_Submit('LIST','',1);						
	});
</script>
<section class="noticeBoard">
  <div id="content">
    <form name="s_frm" method="post">
      <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
      <input type="hidden" name="CIDX" id="CIDX" />
      
      <!-- S: 네비게이션 -->
      <div class="navigation_box">광고/제휴·입점 관리 &gt; 제휴·입점 관리 &gt;  제휴·입점 관리</div>
      <!-- E: 네비게이션 -->
      <div class="search_top community">
        <div class="search_box"> <span>등록일</span>
          <input type="text" name="SDate" id="SDate" maxlength="10" value="<%=SDate%>" <%IF SDate="" Then%> placeholder="2017-07-01"<%End IF%> />
          <span>-</span>
          <input type="text" name="EDate" id="EDate" maxlength="10" value="<%=EDate%>" <%IF EDate="" Then%> placeholder="2017-07-01"<%End IF%> />
          <script>
					$(function() {
						$( "#SDate" ).datepicker({
							dateFormat: 'yy-mm-dd'
						});
						$( "#EDate" ).datepicker({
							dateFormat: 'yy-mm-dd'
						});						  
					});
					</script>
          <select id="fnd_ResultGb" name="fnd_ResultGb">
            <option value="" selected>===처리구분===</option>
            <option value="stan" <%IF fnd_ResultGb = "stan" Then response.write "selected" End IF%>>대기중</option>
            <option value="take" <%IF fnd_ResultGb = "take" Then response.write "selected" End IF%>>처리중</option>
            <option value="comp" <%IF fnd_ResultGb = "comp" Then response.write "selected" End IF%>>처리완료</option>
            <option value="canc" <%IF fnd_ResultGb = "canc" Then response.write "selected" End IF%>>취소</option>
          </select>
          <input type="text" class="title_input in_2" name="fnd_KeyWord" id="fnd_KeyWord" <%IF fnd_KeyWord<>"" Then%> placeholder="회사명, 담당자명, 제목" <%End IF%> value="<%=fnd_KeyWord%>" />
          <a href="javascript:chk_Submit('FND','',1);" class="btn btn-basic">조회</a> </div>
      </div>
      <br />
      <!-- S: article-bg --> 
      
      <!-- S: board-list -->
      <div id="board_list"> 
        
        <!--												 
      <table class="table-list notice-list basic-table" id="board_list">
														 
        <thead>
          <tr>
            <th>번호</th>
            <th>제목</th>
            <th>회사명</th>
            <th>취급상품군</th>
            <th>작성일</th>
          </tr>
          <tr>
            <td width="80"><span>1</span></td>
            <td width="800" style="text-align:left;"><span> <a href="sdmall_request_view.asp">제휴/입점문의 합니다.</a> </span></td>
            <td width="100"><span>나이키</span></td>
            <td width="100"><span>라켓</span></td>
            <td width="100"><span>2018.04.22</span></td>
          </tr>		
      </table>
												 --> 
      </div>
      <!-- E: board-list --> 
      
      <!-- E: article-bg -->
    </form>
  </div>
</section>
<!--#include file="footer.asp"-->