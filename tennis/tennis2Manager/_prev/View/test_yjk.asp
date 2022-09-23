<!--#include virtual="/Manager/Library/config.asp"-->

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge, Chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>������ ���̾</title>
<meta name="apple-mobile-web-app-title" content="������ ���̾">
<link rel="stylesheet" type="text/css" href="../tablet/css/library/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="../tablet/css/app.css">
<link rel="stylesheet" href="../tablet/css/bootstrap.css">
<link rel="stylesheet" href="../tablet/css/fullcalendar.css">
<link rel="stylesheet" href="../tablet/css/fullcalendar.min.css">
<link rel="stylesheet" href="../tablet/css/fullcalendar.print.css">
<link rel="stylesheet" href="../tablet/css/fullcalendar_test.css">
<link rel="stylesheet" href="../tablet/css/pop-style.css">
<link rel="stylesheet" type="text/css" href="../tablet/css/style.css">
<script src="../tablet/js/library/jquery-1.12.2.min.js"></script>
<script type="text/javascript" src="/Manager/Script/common.js"></script>

<script>
	
	var ck = 1;

	function fn_start() {
			
		var totcnt       = "10";
		var gametitleidx = "20";
		var RGameLevelIDX = "63";
		
		var strAjaxUrl = "/Manager/Ajax/yjk_test.asp";
		var retDATA="";
		 $.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',				
			data: {
				totcnt: totcnt  ,
				gametitleidx : gametitleidx ,
				rgamelevelidx : RGameLevelIDX
			},		
			success: function(retDATA) {
				if(retDATA){		
								
					array_Data = retDATA.split("|")					
				
					document.getElementById("p1").value = array_Data[0];
					document.getElementById("p1_2").value = array_Data[1];
					
					document.getElementById("p2").value = array_Data[2];
					document.getElementById("p2_2").value = array_Data[3];
					
					document.getElementById("p3").value = array_Data[4];
					document.getElementById("p3_2").value = array_Data[5];
					
					
					ck = ck+1;
					
					if(ck != 10){
						fn_start()
					}
					
					if(ck == 10){
						ck = 1;
						return 1;
					}
					
					//for(k=1;k<=20000;k++){  //�ӵ�����
						
					//}
					
					
				}else{
					alert("error")
				}
			}, error: function(xhr, status, error){						
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}
				
			}
		});	
	}

</script>

</head>

<body>
	<br>
	<br>
	<input id="p1" type="text" style="width:200px;" value="" />
	<input id="p1_2" type="text" style="width:200px;" value="" />
	<br>
	<br>
	<input id="p2" type="text" style="width:200px;" value="" />
	<input id="p2_2" type="text" style="width:200px;" value="" />
	<br>
	<br>
	<input id="p3" type="text" style="width:200px;" value="" />
	<input id="p3_2" type="text" style="width:200px;" value="" />
  <br>
	<br>
	<input type="button" value="start" onClick="fn_start()" />
	
</body>
</html>
