<%
	response.Cookies("user").Domain = ".sportsdiary.co.kr"
	response.Cookies("user").path = "/"
	response.Cookies("user")("UserName2") = "쿠키테스트2"

	response.write "sportsdiary.co.kr = "&request.Cookies("user")("UserName")&"<br>"
	response.write "tennis.sportsdiary.co.kr = "&request.Cookies("user")("UserName2")&"<br>"
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>쿠키테스트</title>
    <script type="text/JavaScript">

	
	var expdate = new Date();
		
	function setCookie(name, value, expiredays, domain){
		var todayDate = new Date();
		
		todayDate.setDate (todayDate.getDate() + expiredays);
		document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + "domain="+domain;
	}
	
	function getCookie(cName) {
		cName = cName + '=';
		
		var cookieData = document.cookie;
		var start = cookieData.indexOf(cName);
		var cValue = '';
		
		if(start != -1){
			start += cName.length;
			
			var end = cookieData.indexOf(';', start);
		
			if(end == -1)end = cookieData.length;
			
			cValue = cookieData.substring(start, end);
		}
		return unescape(cValue);
	}
	
	setCookie("sd_saveid2", "cookie test2", expdate,".sportsdiary.co.kr");
	
	console.log("sd_saveid="+getCookie("sd_saveid"));
	console.log("sd_saveid2="+getCookie("sd_saveid2"));
	
    </script>
</head>
<body>
</body>
</html>

