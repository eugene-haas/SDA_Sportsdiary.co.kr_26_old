<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
	dim currPage    	: currPage      = fInject(Request("currPage"))
	dim fnd_CountryGb  	: fnd_CountryGb = fInject(Request("fnd_CountryGb"))
	dim fnd_KeyWord     : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
%>
<script language="javascript">
	//검색
	function chk_Submit(valType, valIDX, chkPage){

		var strAjaxUrl = "../Ajax/Country_List.asp";    
		var fnd_KeyWord = $("#fnd_KeyWord").val();
		var fnd_CountryGb = $("#fnd_CountryGb").val();

		if(chkPage!="") $("#currPage").val(chkPage);

		var currPage = $("#currPage").val();

		if(valType=="VIEW"){
			$("#CIDX").val(valIDX);   
			$('form[name=s_frm]').attr('action',"./Country_Write.asp");
			$('form[name=s_frm]').submit(); 
		}
		else{ 
			//전체검색
			if(valType=='ALL') {
				currPage = '';
				fnd_KeyWord = '';
				fnd_CountryGb = '';	

				$("#fnd_KeyWord").val('');
				$("#currPage").val('');
				$("#fnd_CountryGb").val('');
			}

			$.ajax({
				url: strAjaxUrl,
				type: "POST",
				dataType: "html",     
				data: { 
					currPage    	: currPage     
					,fnd_KeyWord    : fnd_KeyWord  
					,fnd_CountryGb  : fnd_CountryGb
				},    
				success: function(retDATA) {
					$("#board-contents").html(retDATA);       
				}, 
				error: function(xhr, status, error){           
					if(error!=""){
						alert ("오류발생! - 시스템관리자에게 문의하십시오!");
						return;
					}
				}
			});
		} 
	}

	$(document).ready(function(){
		chk_Submit('LIST','', 1); 
	});
</script>
<!-- S : content sponsor_list -->
  <div id="content" class="sponsor_list">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>국가정보</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>대회정보</li>
            <li>대회운영</li>
            <li>국가정보</li>
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
		<select name="fnd_CountryGb" id="fnd_CountryGb" class="title_select">
		  <option value="">소속대륙선택</option>
			<option value="OCEANIA" <%IF fnd_fnd_CountryGb = "OCEANIA" Then response.write "selected" End IF%>>OCEANIA</option>
			<option value="ASIA" <%IF fnd_fnd_CountryGb = "ASIA" Then response.write "selected" End IF%>>ASIA</option>
			<option value="EUROPE" <%IF fnd_fnd_CountryGb = "EUROPE" Then response.write "selected" End IF%>>EUROPE</option>
			<option value="AFRICA" <%IF fnd_fnd_CountryGb = "AFRICA" Then response.write "selected" End IF%>>AFRICA</option>
			<option value="AMERICA" <%IF fnd_fnd_CountryGb = "AMERICA" Then response.write "selected" End IF%>>AMERICA</option>
		</select>            
            <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" placeholder="국가명" class="ipt-word">
          <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a>
          <a href="javascript:chk_Submit('ALL','',1);" class="btn btn-blue-empty">전체목록</a>
          <a href="./Country_Write.asp" class="btn btn-add">국가등록</a>
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
<!-- E : content sponsor_list -->

<!--#include file="../include/footer.asp"-->
