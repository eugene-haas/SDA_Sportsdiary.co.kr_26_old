<%'<!-- #include virtual = "/pub/header.tennis.asp" -->%>

<%
'source = Stream_BinaryToString( GetHTTPFile("http://judo.sportsdiary.co.kr/M_Player/Main/index.asp") , "utf-8" )
'Response.write year(date)
'Response.write source



''	Response.AddHeader "Content-type", "text/xml"
'	Response.AddHeader "Content-Type", "text/html;charset=utf-8"
'	Response.CodePage = "65001"
 '   Response.AddHeader "Access-Control-Allow-Origin", "*"
'Call Response.AddHeader("Access-Control-Allow-Origin", "*")
%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="mobile-web-app-capable" content="yes">

	<meta charset="UTF-8">
	<meta name="apple-mobile-web-app-title" content="스포츠다이어리 - 대한유도회">
	<title>유도</title>


	<link rel="stylesheet" href="/pub/jquery/jquery.mobile-1.4.5.min.css">
	<script src="/pub/js/jquery-1.11.1.min.js"></script>
	<script src="/pub/jquery/jquery.mobile-1.4.5.min.js"></script>
	<script src="/pub/js/SwipePage.js?ver=4"></script>
 
 <style>
 .sortable-handler { touch-action: none; }
 </style>
</head>
<body>
 
<section data-role="page" id="01" class="eventPage" data-next="02" data-prev="03" data-dom-cache="true">

	
	
	<header data-role="header">
        <h1>유도</h1>
    </header> 
    <div class="content" data-role="content">
        
        내용입니다.<br>
        01<br/>

    </div>
    <footer data-role="footer"><h1>cofs</h1></footer>


</section>
</body>
</html>