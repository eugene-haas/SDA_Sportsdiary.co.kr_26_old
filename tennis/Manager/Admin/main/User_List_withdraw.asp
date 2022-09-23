<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%
	dim currPage   		: currPage    	= fInject(Request("currPage"))
	dim SDate     		: SDate     	= fInject(Request("SDate"))
	dim EDate     		: EDate     	= fInject(Request("EDate")) 
	dim fnd_KeyWord  	: fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
%>
<script language="javascript">
	//검색
	function chk_Submit(chkPage){
		var fnd_Role = "";
		var strAjaxUrl = "../Ajax/admin_User_List_withdraw.asp";    
		
		
		var SDate = $("#SDate").val();
		var EDate = $("#EDate").val();
		var fnd_KeyWord = $("#fnd_KeyWord").val();
	
		if(chkPage!="") $("#currPage").val(chkPage);
		
		var currPage = $("#currPage").val();
		
		
		$.ajax({
			url: strAjaxUrl,
			type: "POST",
			dataType: "html",     
			data: { 
				currPage    		: currPage     
				,SDate				: SDate
				,EDate				: EDate
				,fnd_KeyWord  		: fnd_KeyWord  
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
	
	function chk_Withdraw(){
		var cntWithdraw = $("input[name='list_CHK']:checkbox:checked").length;
		var currPage = $('#currPage').val();
		var vallist_CHK = "";
		
		if(cntWithdraw==0){
			alert("회원탈퇴처리할 회원정보를 선택해주세요.");	
			return;
		}
		else{
			
			if(confirm(cntWithdraw+"명의 회원을 탈퇴처리하시겠습니까?")){
				
				$("input[name='list_CHK']:checkbox:checked").each(function() { 
					vallist_CHK += "|" + $(this).val();
				});
				
				var strAjaxUrl = "../Ajax/admin_User_List_withdraw_OK.asp";    
				
				$.ajax({
					url: strAjaxUrl,
					type: "POST",
					dataType: "html",     
					data: {
						vallist_CHK : vallist_CHK
						},    
					success: function(retDATA) {
						
						console.log(retDATA);
						
						if(retDATA){
							var strcut = retDATA.split("|");
							
							if (strcut[0]=="TRUE") {      
								alert(strcut[1]+"명의 회원을 탈퇴처리하였습니다.");
								
								$("form[name='s_frm']").attr("action", "./User_List_withdraw.asp");
								$("form[name='s_frm']").submit();
								//location.reload();  
								
							}
							else{
								if (strcut[1]==200) {      
									alert("잘못된 접근입니다. 확인 후 이용하세요");
									return;
								}
								else if (strcut[1]==99) {      
									alert("정상적으로 회원탈퇴처리를 하지 못하였습니다. 확인 후 이용하세요.");
									return;
								}
								else{
								}
							}
						}
					}, 
					error: function(xhr, status, error){           
						if(error!=""){
							alert ("시스템관리자에게 문의하십시오!");
							return;
						}
					}
				});			
			}
			else{
				return;	
			}
		}
	}	
	
	//전체선택 체크박스 클릭 	
	$(document).on("click", "#iallCheck", function checkall(){
		if($("#iallCheck").prop("checked")) { 
			$("input[type=checkbox]").prop("checked",true); 
		} 
		else { 
			$("input[type=checkbox]").prop("checked",false); 
		} 
	});


	
	$(document).ready(function(){
		chk_Submit(1);		
	});
</script>

<!-- S : content -->
<section>
  <div id="content">
    <div class="navigation_box"> 회원관리 &gt; 회원탈퇴신청 목록</div>
    <!-- S : top-navi -->
    <!-- E : top-navi -->
    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
      <div class="search_top community">
        <div class="search_box">
          <table class="sch-table">
            <tbody>
              <tr>
                <th scope="row">회원탈퇴신청일</th>
                <td><input type="date" name="SDate" id="SDate" maxlength="10" value="<%=SDate%>" <%IF SDate="" Then%> placeholder="2017-07-01"<%End IF%> />
                  -
                  <input type="date" name="EDate" id="EDate" maxlength="10" value="<%=EDate%>" <%IF EDate="" Then%> placeholder="2017-07-01"<%End IF%> /></td>
                
              </tr>
              <tr>
              	<th>키워드</th>
                <td colspan="3"><input type="text" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
                <div id="div_InfoKeyWord">키워드 검색 [소속팀명, 회원명, 생년월일, 체육인번호, 아이디, 전화번호, 이메일]</div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="btn-right-list">
        	<a href="javascript:chk_Withdraw();;" class="btn" accesskey="w">회원탈퇴</a>
            <a href="javascript:chk_Submit();" class="btn" accesskey="s">검색(S)</a> 
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
<!--#include file="footer.asp"-->
