<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
<%
	dim tIDX 	:    tIDX 	= crypt.DecryptStringENC(fInject(request("tIDX")))
   	dim i2 		:    i2 	= fInject(request("i2"))			'NowPage
																 
	dim CSQL, CRs
	dim GameTitleName
   		
	IF tIDX = "" Then
		response.write "<script>alert('잘못된 접근입니다. 확인 후 이용하세요.'); history.back();</script>"						
		response.end
	Else
		CSQL = "		SELECT GameTitleName"													  
		CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblGameTitle]"
		CSQL = CSQL & " WHERE GameTitleIDX = '"&tIDX&"'"													  
		SET CRs = DBCon.Execute(CSQL)
        IF Not (CRs.Eof OR CRs.Bof) Then
			GameTitleName = ReHtmlSpecialChars(CRs("GameTitleName"))
		Else
			response.write "<script>alert('일치하는 정보가 없습니다. 확인 후 이용하세요.'); history.back();</script>"						
			response.end										   
		End IF
			CRs.Close
		SET CRs = Nothing
	End IF
														 
%>
<script language="javascript">
	
    /**
	* left-menu 체크
	*/
	var locationStr = "GameTitleMenu/index"; // 대회
	/* left-menu 체크 */

  
  	function chk_Submit(valType, valIDX){

		var strAjaxUrl = '../../Ajax/GameTitleMenu/GameTitle_Referee.asp';    
		var tIDX = $('#tIDX').val();
		
		switch(valType){
			case 'GLIST' : 
				$('form[name=s_frm]').attr('action','./index.asp');
				$('form[name=s_frm]').submit(); 	   
				break;
									
			case 'VIEW' : case 'SAVE' : 
				$('#CIDX').val(valIDX);   
				$('form[name=s_frm]').attr('action','./GameTitle_Referee_Mod.asp');
				$('form[name=s_frm]').submit(); 	   
				break;
									
			default : 
				$.ajax({
					url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',     
					data: { 
						tIDX    : tIDX  
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
		chk_Submit('')
  	});
</script> 
<!-- S : content -->
<section>
  <div id="content"> 
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>대회-심판등록</h2>
      <!-- S: 네비게이션 -->
      <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
        <ul>
          <li>대회정보</li>
          <li>대회운영</li>
          <li>대회-심판등록</li>
        </ul>
      </div>
      <!-- E: 네비게이션 --> 
      
    </div>
    <!-- E: page_title --> 
    
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" name="tIDX" id="tIDX" value="<%=fInject(request("tIDX"))%>">
      <input type="hidden" name="CIDX" id="CIDX">
      <input type="hidden" name="i2" id="i2" value="<%=i2%>">
					 
      <div class="search_top GameTitlelntl_Write"> 
        <!-- s: 검색영역 -->
        
        <div class="search_box">

              <h4><%=GameTitleName%></h4>
					 <a href="javascript:chk_Submit('SAVE');" class="btn btn-confirm">심판등록하기</a>
					<a href="javascript:chk_Submit('GLIST');" class="btn btn-confirm">대회목록</a>															  

        </div>
        
        <!-- e: 검색영역 -->
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
      </div>
    </form>
    <!-- E : sch 검색조건 선택 및 입력 --> 
  </div>
</section>
<!-- E : content --> 
<!-- E : container --> 
<!--#include file="../../include/footer.asp"-->