<%
  '5조
  JooDivision = 5
  '100명을 배분해라
  For i = 1 To 100
    Response.Write i & "<br>"
    ModValue =  i Mod JooDivision
    Response.Write "ModValue : " & ModValue & "<br>"
  next

%>
