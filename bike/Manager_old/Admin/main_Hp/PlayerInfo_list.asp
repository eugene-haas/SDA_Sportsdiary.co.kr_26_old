<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
	dim currPage			: currPage      	= fInject(Request("currPage"))
	dim SDate       		: SDate         	= fInject(Request("SDate"))
	dim EDate       		: EDate         	= fInject(Request("EDate"))	
   	dim fnd_Year   			: fnd_Year   		= fInject(Request("fnd_Year"))  
   	dim fnd_EnterType		: fnd_EnterType		= fInject(Request("fnd_EnterType"))  
   	dim fnd_KoreaTeamType	: fnd_KoreaTeamType	= fInject(Request("fnd_KoreaTeamType"))     
   	dim fnd_Sex   			: fnd_Sex   		= fInject(Request("fnd_Sex"))  
   	dim fnd_KeyWord 		: fnd_KeyWord   	= fInject(Request("fnd_KeyWord"))  
   
   	IF fnd_Year = "" Then fnd_Year = Year(Date())
%>
<script language="javascript">
  	var locationStr = "PlayerInfo_list.asp";

	//검색
	function chk_Submit(valType, valIDX, chkPage){

		var strAjaxUrl = '../Ajax/PlayerInfo_List.asp';    
		var SDate = $('#SDate').val();
		var EDate = $('#EDate').val();
		var fnd_Year = $('#fnd_Year').val();
		var fnd_EnterType = $('#fnd_EnterType').val();
		var fnd_KoreaTeamType = $('#fnd_KoreaTeamType').val();	
		var fnd_Sex = $('#fnd_Sex').val();
		var fnd_KeyWord = $('#fnd_KeyWord').val();
		var fnd_PlayerType = $('#fnd_PlayerType').addClass("title_select").val();		
		
		if(chkPage) $('#currPage').val(chkPage);

		var currPage = $('#currPage').val();

		switch(valType){
			case 'VIEW'	: //수정/VIEW
				$('#CIDX').val(valIDX);   

				$('form[name=s_frm]').attr('action','./PlayerInfo_Mod.asp');
				$('form[name=s_frm]').submit(); 
				break;
			
			case 'WRITE' :	//등록
				$('form[name=s_frm]').attr('action','./PlayerInfo_Write.asp');
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
						,fnd_Year	    	: fnd_Year           
						,fnd_Sex    		: fnd_Sex           
						,fnd_KeyWord    	: fnd_KeyWord 
						,fnd_EnterType		: fnd_EnterType
						,fnd_KoreaTeamType	: fnd_KoreaTeamType
						,fnd_PlayerType 	: fnd_PlayerType
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

	$(document).ready(function(){
		//대표팀구분 셀렉박스 목록 생성 
		make_box('sel_KoreaTeamType', 'fnd_KoreaTeamType', '<%=fnd_KoreaTeamType%>', 'Info_KoreaTeam'); 
		make_box('sel_PlayerType', 'fnd_PlayerType', '<%=fnd_PlayerType%>', 'Info_PlayerNational'); 
		//등록팀 현황 년도 SELECT OPTION LIST
		make_box('sel_fnd_Year', 'fnd_Year', '<%IF fnd_Year <> "" Then response.write fnd_Year Else response.write Year(Date()) End IF%>', 'RegYear_Player');
		
		chk_Submit('', '', '<%IF currPage = "" Then response.write "1" Else response.write currPage End IF%>');    
	});
</script>
<!-- S : content -->
<section class="list_conten_box">
  <div id="content">
    <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>선수관리</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>대회정보</li>
            <li>대회운영</li>
            <li>선수관리</li>
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
        <div class="search_box"><span class="tit">등록년도</span>
            <span id="sel_fnd_Year"><select name="fnd_Year" id="fnd_Year" class="title_select">
				<!--
				<option value="2018" <%IF fnd_Year = "2018" Then response.write "selected" End IF%>>2018</option>	
				<option value="2019" <%IF fnd_Year = "2019" Then response.write "selected" End IF%>>2019</option>	
		  		<option value="2020" <%IF fnd_Year = "2020" Then response.write "selected" End IF%>>2020</option>	
				-->
			</select></span>
			<span class="tit">등록일</span>
            <input type="date" name="SDate" id="SDate" maxlength="10" class="date_ipt" value="<%=SDate%>" <%IF SDate="" Then%> placeholder="2017-07-01"<%End IF%>>
            <span class="divn">-</span>
            <input type="date" name="EDate" id="EDate" maxlength="10" class="date_ipt" value="<%=EDate%>" <%IF EDate="" Then%> placeholder="2017-07-01"<%End IF%>>

            <!--<a href="#" class="btn btn-close" data-dismiss="modal">X</a>-->
				
	  		<span id="sel_PlayerType" class="sel_box">
	  	<select name="fnd_PlayerType" id="fnd_PlayerType" class="title_select">
				<option value="" selected>내외국인 선택</option>				
			</select>
			</span>
           	<select name="fnd_EnterType" id="fnd_EnterType" class="title_select">
				<option value="" selected>선수구분</option>
				<option value="E" <%IF fnd_EnterType = "E" Then response.write "selected" End IF%>>엘리트</option>
	  			<option value="A" <%IF fnd_EnterType = "A" Then response.write "selected" End IF%>>체육동호인</option>
			</select>
	  		<span id="sel_KoreaTeamType" class="sel_box type_sel">
	  		<select name="fnd_KoreaTeamType" id="fnd_KoreaTeamType" class="title_select">
				<option value="" selected>대표팀구분</option>
			</select></span>
	  		<select name="fnd_Sex" id="fnd_Sex" class="title_select">
				<option value="" selected>성별선택</option>
				<option value="Man" <%IF fnd_Sex = "Man" Then response.write "selected" End IF%>>남</option>
	  			<option value="WoMan" <%IF fnd_Sex = "WoMan" Then response.write "selected" End IF%>>여</option>
			</select>
            <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" class="ipt-word" value="<%=fnd_KeyWord%>" placeholder="이름, 생년월일, 팀코드, 팀명, 전화번호, 이메일, 체육인번호">
            <!--<div id="div_InfoKeyWord">키워드 검색 [회원명, 생년월일, 아이디, 전화번호, 이메일]</div>-->
          <a href="javascript:chk_Submit('FND','',1);" class="btn btn-search">검색</a>
			<a href="javascript:chk_Submit('WRITE','','');" class="btn btn-add">추가 등록</a>
			
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
