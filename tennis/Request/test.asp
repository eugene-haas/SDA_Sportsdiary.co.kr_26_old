  <script src="js/jquery-1.12.2.min.js"></script>
<!--#include file = "./Library/ajax_config.asp"-->

<script>	
    function on_Submit(valPhone){		
		var strAjaxUrl = './test2.asp';		
		
		$.ajax({			
			url: strAjaxUrl,			
			type: 'POST',			
			dataType: 'html',			
			data: { 	
				valPhone : valPhone	
			},
			success: function(retDATA) {
				alert(retDATA);
			}, 
			error: function(xhr, status, error){
				if(error!=""){ 
					alert ("시스템관리자에게 문의하십시오!"); 
					return; 
				}     
			}
		});	
    }
</script>
<input type="button" value="click" onclick="on_Submit('01072907647');" />
