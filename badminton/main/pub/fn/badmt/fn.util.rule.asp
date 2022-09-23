<% 
'   ===============================================================================     
'    Purpose : badminton util rule
'    Make    : 2019.03.11
'    Author  :                                                       By Aramdry
'   ===============================================================================   
%>


<%
'   ===============================================================================     
'    베드민턴 Text Short name Replace
'   ===============================================================================
   Function TeamGBtoSimple(text)
      Dim temptext
      If isNull(text)  = True Then
         temptext = ""
      Else
         tempText = replace(text,"여자중학교","여중")
         tempText = replace(tempText,"여자고등학교","여고")
         tempText = replace(tempText,"여자대학교","여대")
         tempText = replace(tempText,"남자중학교","남중")
         tempText = replace(tempText,"남자고등학교","남고")
         tempText = replace(tempText,"남자대학교","남대")
         tempText = replace(tempText,"체육중학교","체중")
         tempText = replace(tempText,"체육고등학교","체고")
         tempText = replace(tempText,"체육대학교","체대")
         tempText = replace(tempText,"초등학교","초")
         tempText = replace(tempText,"중학교","중")
         tempText = replace(tempText,"고등학교","고")
         tempText = replace(tempText,"대학교","대")
      End if
      TeamGBtoSimple = temptext
   End Function

   Function TeamGBtoSimpleEx(text)
      Dim temptext
      If isNull(text)  = True Then
         temptext = ""
      Else
         temptext = text
         If(InStr(text,"여자중학교") <> 0) Then 
            tempText = replace(temptext,"여자중학교","여중")
         ElseIf(InStr(text,"여자고등학교") <> 0) Then 
            tempText = replace(tempText,"여자고등학교","여고")
         ElseIf(InStr(text,"여자대학교") <> 0) Then 
            tempText = replace(tempText,"여자대학교","여대")
         ElseIf(InStr(text,"남자중학교") <> 0) Then 
            tempText = replace(tempText,"남자중학교","남중")
         ElseIf(InStr(text,"남자고등학교") <> 0) Then 
            tempText = replace(tempText,"남자고등학교","남고")
         ElseIf(InStr(text,"남자대학교") <> 0) Then 
            tempText = replace(tempText,"남자대학교","남대")
         ElseIf(InStr(text,"체육중학교") <> 0) Then 
            tempText = replace(tempText,"체육중학교","체중")
         ElseIf(InStr(text,"체육고등학교") <> 0) Then 
            tempText = replace(tempText,"체육고등학교","체고")
         ElseIf(InStr(text,"체육대학교") <> 0) Then 
            tempText = replace(tempText,"체육대학교","체대")
         ElseIf(InStr(text,"초등학교") <> 0) Then 
            tempText = replace(tempText,"초등학교","초")
         ElseIf(InStr(text,"중학교") <> 0) Then 
            tempText = replace(tempText,"중학교","중")
         ElseIf(InStr(text,"고등학교") <> 0) Then 
            tempText = replace(tempText,"고등학교","고")
         ElseIf(InStr(text,"대학교") <> 0) Then 
            tempText = replace(tempText,"대학교","대")
         End If 
      End if
      TeamGBtoSimpleEx = temptext
   End Function

   Function IsDoublePlay(playType)
      Dim IsDblPlay
      IsDblPlay = 0

      If(playType = "B0020002") Then IsDblPlay = 1 End If 

      IsDoublePlay = IsDblPlay
   End Function 
%>