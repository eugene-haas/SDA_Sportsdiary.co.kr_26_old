<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<script>

function aa(){
		var totcnt = 4


		var strAjaxUrl = "/Manager/random_test2.asp";
		var retDATA="";
		 
		 $.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',				
			data: { totcnt: totcnt },		
			success: function(retDATA) {
				if(retDATA){
					document.getElementById("list").innerHTML  = retDATA;
				}
			}, error: function(xhr, status, error){						
				//parent.fBottom.popupClose("btndel","btndel","");
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");			
			}
		});	
}


function bb(){
	for(i=0;i<200;i++){
		aa();
	}
}


</script>
<form name="aaa">
<input type="button" value="aaaaa" onclick="bb();">
</form>
<table id="list" border="1">
	
</table>
