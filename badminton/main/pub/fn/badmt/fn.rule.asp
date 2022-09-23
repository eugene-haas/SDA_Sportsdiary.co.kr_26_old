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

'   ===============================================================================     
'     result code를 입력받아 win / lose를 판정한다. 
'     gAryGameResult(0~3) 승 gAryGameResult(4~7) 패 
'   ===============================================================================
   Function IsResultWin(rstCode) 
      Dim bWin , ai, aul
      aul = UBound(gAryGameResult)

      For ai = 0 To aul 
        If (gAryGameResult(ai)(0) = rstCode) Then 
            If(ai < 4) Then     ' 승 
                bWin = 1 
            Else                ' 패 
                bWin = 0
            End If 
            Exit For
        End If 
      Next
         
      IsResultWin = bWin
   End Function 



%>