<!--#include file="./Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'KATA 대회참가신청 동의 페이지
	'===============================================================================================
	dim UserInfo 	: UserInfo 	= fInject(request("UserInfo"))	
	
%>
<script>
	function Info_Request(){
		var strAjaxUrl = "./ajax/request_agree_ok.asp";  
		var UserInfo = $("#UserInfo").val();
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { 
				UserInfo : UserInfo
			},
			success: function(retDATA) {
			
				console.log(retDATA);
				
				if(retDATA){
				
					var strcut = retDATA.split("|");
					
					if(strcut[0]=="TRUE") {
						alert ("참가신청 접수가 완료되었습니다."); 	
						return;
					}
					else{
						switch (strcut[1]) { 
							case 200: alert ("잘못된 접근입니다. 확인 후 이용하십시오."); break;
							case 99: lert ("일치하는 정보가 없습니다."); break;  
							default: break;				
						}
					}
				}   
				else{
					alert ("본인 확인이 이루지지 않았습니다. 관리자에게 문의하십시오."); 
					return;		
				}
			}, 
			error: function(xhr, status, error){
				if(error!=""){ 
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); 
					return; 
				}     
			}
			
			self.close();
			
		});
	}
</script>
<form name="s_frm" method="post">
	<input type="hidden" name="UserInfo" id="UserInfo" value="<%=UserInfo%>" />
    <input type="button" value="확인" onclick="Info_Request();" />
</form>