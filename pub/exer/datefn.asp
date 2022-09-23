<!-- #include virtual = "/pub/header.ridingadmin.asp" -->
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=3">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge, chrome=1">
    <title>Tournament Tree</title>

  <body>

  일년전<br>
	<%=DateAdd("m", -12, Date)%><br><br>

  
  <%
  
  l_CDCNM= "ghs계영"
  aaa= InStr(l_CDCNM,"계영") 
  Response.write aaa
  %>
  </body>
</html>

