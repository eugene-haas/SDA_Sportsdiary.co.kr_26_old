<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <meta name="Generator" content="EditPlus®">
  <meta name="Author" content="">
  <meta name="Keywords" content="">
  <meta name="Description" content="">
  <title>Document</title>
 </head>
<script src="/pub/js/jquery-1.11.1.min.js"></script>

<script type="text/javascript">
<!--
  var score =  score || {};

	score.backbtn = function(){

		if (typeof history.pushState === "function") {
			history.pushState("jibberish", null, null);
			window.onpopstate = function () {
				history.pushState('newjibberish', null, null);

				// Handle the back (or forward) buttons here
				// Will NOT handle refresh, use onbeforeunload for this.
				//if( score.jsondata.PRERESULT == "ING" ){
					//var msg = '경기입력을 중단하시겠습니까?';	
					if (confirm('경기입력을 중단하시겠습니까? 화면이동을 할 경우 모든 입력 데이터가 초가화 됩니다.')) {
						score.gameReSetProcess();
					} else {
						return;
					}	
				//}
				//else{
				//	score.splashmsg('경기가 종료 되었습니다. 경기종료 버튼을 눌러주세요. ',1500);	
				//	return;
				//}

				//$('#result_msg').html(msg);
				//$('#result_winner').html('화면이동을 할 경우 모든 입력 데이터가 초가화 됩니다.');
				//$('#stopendokbtn').prop('href', 'javascript:javascript:score.gameReSetProcess();');
				//$('.confirm_end').modal('show');
			};
		}
		else {
			var ignoreHashChange = true;
			window.onhashchange = function () {
				if (!ignoreHashChange) {
					ignoreHashChange = true;
					window.location.hash = Math.random();

					// Detect and redirect change here
					// Works in older FF and IE9
					// * it does mess with your hash symbol (anchor?) pound sign
					// delimiter on the end of the URL
					//if( score.jsondata.PRERESULT == "ING" ){
						//var msg = '경기입력을 중단하시겠습니까?';	
						if (confirm('경기입력을 중단하시겠습니까? 화면이동을 할 경우 모든 입력 데이터가 초가화 됩니다.')) {
							score.gameReSetProcess();
						} else {
							return;
						}	
					//}
					//else{
					//	score.splashmsg('경기가 종료 되었습니다. 경기종료 버튼을 눌러주세요. ',1500);	
					//	return;
					//}

					//$('#result_msg').html(msg);
					//$('#result_winner').html('화면이동을 할 경우 모든 입력 데이터가 초가화 됩니다.');
					//$('#stopendokbtn').prop('href', 'javascript:javascript:score.gameReSetProcess();');
					//$('.confirm_end').modal('show');
				}
				else {
					ignoreHashChange = false;
				}
			};
		}		
	
	};	


  $(document).ready(function(){
	 if (window.history && window.history.pushState) {
		score.backbtn();
	  }
  }); 
//-->
</script>
 <body>
  
나오나

 </body>
</html>
