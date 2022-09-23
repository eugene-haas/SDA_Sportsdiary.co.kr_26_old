<!-- #include virtual = "/pub/header.RookieTennis.mobile.asp" -->
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
 <body >


<%
b = "19730425"

b = korAge(Left(b,4) &"-"& mid(b,5,2) &"-"& Right(b,2))

'DateAdd("m",10,now()) 

dd = cint(datediff("m", "2018-12-01" , date()))

Response.write dd
'Response.write b




%>


 </body>

</html>



<!-- http://spicaryn.tistory.com/23
옵션설명 주소 참고 -->