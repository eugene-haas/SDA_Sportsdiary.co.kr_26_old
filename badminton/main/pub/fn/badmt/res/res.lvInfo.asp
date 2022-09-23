<% 
'   ===============================================================================     
'    Purpose : tblLevelInfo에서 code를 비교하여 Name을 반환한다. 
'    Make    : 2019.05.28
'    Author  :                                                       By Aramdry
'   ===============================================================================   
%>


<% 
'   ===============================================================================     
'     tblLevelInfo의 모든 값을 DB로 부터 가져다가 2차원 배열에 저장한후 , 
'     그 배열을 가지고 특정 Text를 추출하는 함수를 만든다. 
'     PubCode, PubName, PPubCode, PPubName
'   ===============================================================================   
   Dim db_lvi, rs_lvi, strSql_lvi, aryLvInfo
   Set db_lvi = new clsDBHelper   

   strSql_lvi = "Select Level, LevelNM From tblLevelInfo As lvi Where lvi.DelYN = 'N' Order By lvi.Level"
   Set rs_lvi = db_lvi.ExecSQLReturnRS(strSql_lvi , null, ConStr) 

   If Not (rs_lvi.Eof Or rs_lvi.Bof) Then
      aryLvInfo = rs_lvi.GetRows()
      rs_lvi.Close
   End If 

   Set rs_lvi = Nothing
	Call db_lvi.Dispose
   Set db_lvi = Nothing
%>

<%
'   ===============================================================================     
'                                   tblLevelInfo
'   ===============================================================================  

'   ===============================================================================     
'     Level Name 반환한다. 
'   ===============================================================================  
   Function rxLevelName(lvCode)
      Dim pName, ub, ai
      pName = ""

      If( IsArray(aryLvInfo) ) Then 
         ub = UBound(aryLvInfo, 2) 

         For ai = 0 To ub 
            If(aryLvInfo(0, ai) = lvCode) Then 
               pName = aryLvInfo(1, ai)
               Exit For 
            End If 
         Next 

      End If 
      rxLevelName = pName
   End Function 
%>

