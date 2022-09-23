<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
   	'소속팀 이적관리 목록페이지 
	 
	dim currPage			: currPage      	= fInject(Request("currPage"))
	dim SDate       		: SDate         	= fInject(Request("SDate"))
	dim EDate       		: EDate         	= fInject(Request("EDate"))	
   	dim fnd_MemberType		: fnd_MemberType	= fInject(Request("fnd_MemberType"))  
   	dim fnd_KeyWord 		: fnd_KeyWord   	= fInject(Request("fnd_KeyWord"))  
   
%>
<script language="javascript">
  	var locationStr = "TeamTransfer_list";

	//검색
	function chk_Submit(valType, valIDX, chkPage){

		var strAjaxUrl = '../Ajax/TeamTransfer_list.asp';    
		var SDate = $('#SDate').val();
		var EDate = $('#EDate').val();
		var fnd_MemberType = $('#fnd_MemberType').val();
		var fnd_KeyWord = $('#fnd_KeyWord').val();
		
		if(chkPage) $('#currPage').val(chkPage);

		var currPage = $('#currPage').val();

		switch(valType){
			case 'VIEW'	: case 'WRITE' : 
				$('#CIDX').val(valIDX);   
				$('form[name=s_frm]').attr('action','./TeamTransfer_Write.asp');
				$('form[name=s_frm]').submit(); 
				break;
			
			default : 
				
				$.ajax({
					url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',     
					data: { 
						currPage 			: currPage     
						,SDate          	: SDate
						,EDate         	 	: EDate
						,fnd_KeyWord    	: fnd_KeyWord 
						,fnd_MemberType		: fnd_MemberType
					},    
					success: function(retDATA) {
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

	$(document).ready(function(){
		chk_Submit('', '', '<%IF currPage = "" Then response.write "1" Else response.write currPage End IF%>');    
	});
</script>
<!-- S : content -->
<section class="list_conten_box">
  <div id="content">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>소속팀 이적관리</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>대회정보</li>
            <li>대회운영</li>
            <li>소속팀 이적관리</li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      	<input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
    	<input type="hidden" id="CIDX" name="CIDX" />
      <div class="search_top community">
        <div class="search_box">
			<span class="tit">이적일</span>
            <input type="date" name="SDate" id="SDate" maxlength="10" class="date_ipt" value="<%=SDate%>" <%IF SDate="" Then%> placeholder="2017-07-01"<%End IF%>>
            <span class="divn">-</span>
            <input type="date" name="EDate" id="EDate" maxlength="10" class="date_ipt" value="<%=EDate%>" <%IF EDate="" Then%> placeholder="2017-07-01"<%End IF%>>
	  		<select name="fnd_MemberType" id="fnd_MemberType" class="title_select">
				<option value="" selected>구분</option>
				<option value="P" <%IF fnd_MemberType = "P" Then response.write "selected" End IF%>>선수</option>
	  			<option value="L" <%IF fnd_MemberType = "L" Then response.write "selected" End IF%>>지도자</option>
			</select>
	  		<input type="text" name="fnd_KeyWord" id="fnd_KeyWord" class="ipt-word" value="<%=fnd_KeyWord%>" placeholder="이름">            
          <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a>
			<a href="javascript:chk_Submit('WRITE','','');" class="btn btn-add">소속팀 이적</a>
			
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
</section>
<!-- E : content -->
<!-- E : container -->
<!--#include file="../include/footer.asp"-->
