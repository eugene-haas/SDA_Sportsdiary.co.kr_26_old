<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <title>Document</title>
 </head>
 <body>
<!-- 118.33.86.240 --><br>
<%= Request.ServerVariables("REMOTE_ADDR")%>

 <br>
<%
Function Ceil(ByVal intParam)
	Ceil = -(Int(-(intParam)))
End Function


'Response.write ceil(34.3)
%>

<br>
 <%'=FormatNumber(34.3,0)%>

 
 
 
 
 <%
'Dim elementarr(4) '엘리먼트경기라운드배열값들
'
'For i = 0 To ubound(elementarr)
'	If isNull(elementarr(i)) = True Then
'		Response.write "널인가"
'	else
'		If elementarr(i) = "" Then
'			Response.write "공백인가"
'		End if
'	Response.write elementarr(i) & "--<br>"
'	End if
'next


'For i = 0 To 4
'	elementarr(i) = i
'Next 
'
'For i = 0 To ubound(elementarr)
'	Response.write elementarr(i) & "<br>"
'next
 %>
 
 
 
 </body>
</html>
