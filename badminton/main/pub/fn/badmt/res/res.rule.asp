<% 
'   ===============================================================================     
'    Purpose : badminton game rule or define constant
'    Make    : 2019.05.09
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%>

<%
   Dim gAryGameResult
'   ===============================================================================     
'    베드민턴 경기 결과 값 - tblGameResult Result field에서 사용
'   ===============================================================================
   gAryGameResult = Array( _
                        Array("B5010001", "판정승"), _
                        Array("B5010002", "기권승(경기전)"), _
                        Array("B5010003", "기권승(경기중)"), _
                        Array("B5010004", "불참"), _
                        Array("B6010001", "판정패"), _
                        Array("B6010002", "기권패(경기전)"), _
                        Array("B6010003", "기권패(경기중)"), _
                        Array("B6010004", "불참") _
   )


%>