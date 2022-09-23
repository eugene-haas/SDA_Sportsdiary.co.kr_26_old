<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <meta name="Generator" content="EditPlus®">
  <title>Document</title>
 </head>
 <body>

<%
function chkvalue(chkstr)

   Dim regEx
   Set regEx = New RegExp
   regEx.Pattern = "[^-가-힣a-zA-Z0-9/]"
   regEx.Global = True
   chkvalue = regEx.Replace(chkstr, "")

end Function


response.write chkvalue("a백1승 훈*")
%>

 </body>
</html>
