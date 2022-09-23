<% 
'   ===============================================================================     
'    Purpose : tblTeamGbInfo에서 code를 비교하여 Name을 반환한다. 
'    Make    : 2019.05.28
'    Author  :                                                       By Aramdry
'   ===============================================================================   
%>


<% 
'   ===============================================================================     
'     tblTeamGbInfo의 모든 값을 DB로 부터 가져다가 2차원 배열에 저장한후 , 
'     그 배열을 가지고 특정 Text를 추출하는 함수를 만든다. 
'     TeamGb, TeamGbNm, PTeamGbCode, PTeamGbName
'   ===============================================================================   
   Dim db_teamgb, rs_teamgb, strSql_teamgb, aryTeamGb
   Set db_teamgb = new clsDBHelper   

   strSql_teamgb = "Select TeamGb, TeamGbNm, PTeamGbCode, PTeamGbName From tblTeamGbInfo Where DelYN = 'N' Order By TeamGb"
   Set rs_teamgb = db_teamgb.ExecSQLReturnRS(strSql_teamgb , null, ConStr) 

   If Not (rs_teamgb.Eof Or rs_teamgb.Bof) Then
      aryTeamGb = rs_teamgb.GetRows()
      rs_teamgb.Close
   End If 

   Set rs_teamgb = Nothing
	Call db_teamgb.Dispose
   Set db_teamgb = Nothing
%>

<%
'   ===============================================================================     
'     TeamGBName 반환한다. 
'   ===============================================================================  
   Function rxTeamGBGetName(gbCode)
      Dim pName, ub, ai
      pName = ""

      If( IsArray(aryTeamGb) ) Then 
         ub = UBound(aryTeamGb, 2) 

         For ai = 0 To ub 
            If(aryTeamGb(0, ai) = gbCode) Then 
               pName = aryTeamGb(1, ai)
               Exit For 
            End If 
         Next 

      End If 
      rxTeamGBGetName = pName
   End Function 

'   ===============================================================================     
'     TeamGBPName 반환한다. 
'   =============================================================================== 
   Function rxTeamGBGetPName(pgbCode)
      Dim pName, ub
      pName = ""

      If( IsArray(aryTeamGb) ) Then 
         ub = UBound(aryTeamGb, 2) 

         For ai = 0 To ub 
            If(aryTeamGb(2, ai) = pgbCode) Then 
               pName = aryTeamGb(3, ai)
               Exit For 
            End If 
         Next 

      End If 
      rxTeamGBGetPName = pName
   End Function 
%>

