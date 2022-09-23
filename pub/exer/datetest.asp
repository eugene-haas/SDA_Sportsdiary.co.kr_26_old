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
 <body>
  
<script type="text/javascript">
<!--

function getLocalISOTime(twDate) {
    var d = new Date(twDate);
    var utcd = Date.UTC(d.getFullYear(), d.getMonth(), d.getDate(), d.getHours(),
        d.getMinutes(), d.getSeconds(), d.getMilliseconds());

    // obtain local UTC offset and convert to msec
    localOffset = d.getTimezoneOffset() * 60000;
    var newdate = new Date(utcd + localOffset);
    return newdate.toISOString().replace(".000", "");
}
	
	
	
	// 날짜 설정
	//한국시간과 맞추기 위해 9시간을 더해야한다.
	function getDateStr (myDate){
	
//		var kdate = new Date(myDate.getFullYear() + '-' + (myDate.getMonth() + 1) + '-' + myDate.getDate()).toISOString();
		var kdate = new Date(myDate.getFullYear() + '-' + (myDate.getMonth() + 1) + '-' + myDate.getDate());
		var utc = new Date(kdate.getTime() - kdate.getTimezoneOffset() * 60000);
		var utc2= utc.toISOString().slice(0,10);


		console.log( kdate +"==1");
		console.log( utc   +"==2");
		console.log( utc2   +"==3");

return utc2;


//		var offset = kdate
//		const offset = new Date().getTimezoneOffset() * 60000;
//		console.log(offset);
//		var today = new Date(kdate.now() - offset);

//const offset = new Date().getTimezoneOffset() * 60000;
//const today = new Date(Date.now() - offset);






//날짜  2자리 표시
//('0' + myDate.getDate()).slice(-2);
//월 2자리 표시
//('0' + (myDate.getMonth() + 1)).slice(-2);


		//return  myDate.getFullYear() + '-' + ('0' + (myDate.getMonth() + 1)).slice(-2)+ '-' + ('0' + myDate.getDate()).slice(-2)  ;
		//return new Date(myDate.getFullYear() + '-' + (myDate.getMonth() + 1) + '-' + myDate.getDate()).toISOString().slice(0,10);
	}	


//console.log(new Date('2020-06-01'));
	console.log( getDateStr(new Date('2020-06-01'))  );
//-->
</script>

 </body>
</html>
