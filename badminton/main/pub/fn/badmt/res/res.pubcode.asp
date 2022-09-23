<% 
'   ===============================================================================     
'    Purpose : tblPubcode에서 code를 비교하여 Name을 반환한다. 
'    Make    : 2019.05.28
'    Author  :                                                       By Aramdry
'   ===============================================================================   
%>


<% 
'   ===============================================================================     
'     tblPubcode의 모든 값을 DB로 부터 가져다가 2차원 배열에 저장한후 , 
'     그 배열을 가지고 특정 Text를 추출하는 함수를 만든다. 
'     PubCode, PubName, PPubCode, PPubName
'   ===============================================================================   
   Dim db_pub, rs_pub, strSql_pub, aryPubCode
   Set db_pub = new clsDBHelper   

   strSql_pub = "Select PubCode, PubName, PPubCode, PPubName From tblPubcode Where DelYN = 'N'"
   Set rs_pub = db_pub.ExecSQLReturnRS(strSql_pub , null, ConStr) 

   If Not (rs_pub.Eof Or rs_pub.Bof) Then
      aryPubCode = rs_pub.GetRows()
      rs_pub.Close
   End If 

   Set rs_pub = Nothing
	Call db_pub.Dispose
   Set db_pub = Nothing
%>

<% 
'   ===============================================================================     
'           pubCode를 받아서 pubName을 반환한다. 
'   ===============================================================================   
   Function rxPubGetName(pCode)
      Dim pName, ub, ai
      pName = ""

      If( IsArray(aryPubCode) ) Then 
         ub = UBound(aryPubCode, 2) 

         For ai = 0 To ub 
            If(aryPubCode(0, ai) = pCode) Then 
               pName = aryPubCode(1, ai)
               Exit For 
            End If 
         Next 

      End If 
      rxPubGetName = pName
   End Function 

'   ===============================================================================     
'           pubCode, ppubCode를 받아서 PPubName 반환한다. 
'   ===============================================================================   
   Function rxPubGetSubName(pCode, pSubCode)
      Dim pName, ub
      pName = ""

      If( IsArray(aryPubCode) ) Then 
         ub = UBound(aryPubCode, 2)

         For ai = 0 To ub 
            If(aryPubCode(0, ai) = pCode) And (aryPubCode(2, ai) = pSubCode) Then 
               pName = aryPubCode(3, ai)
               Exit For 
            End If 
         Next 
      End If 
      rxPubGetSubName = pName
   End Function 

'   ===============================================================================     
'     tblPubcode의 pubCode를 받아서 pubName을 반환한다. 
'   ===============================================================================   
   Function pubGetName(pCode)
      Dim pName, ub, ai
      pName = ""

      If( IsArray(aryPubCode) ) Then 
         ub = UBound(aryPubCode, 2) 

         For ai = 0 To ub 
            If(aryPubCode(0, ai) = pCode) Then 
               pName = aryPubCode(1, ai)
               Exit For 
            End If 
         Next 

      End If 
      pubGetName = pName
   End Function 

'   ===============================================================================     
'     tblPubcode의 pubCode, ppubCode를 받아서 PPubName 반환한다. 
'   ===============================================================================   
   Function pubGetSubName(pCode, pSubCode)
      Dim pName, ub
      pName = ""

      If( IsArray(aryPubCode) ) Then 
         ub = UBound(aryPubCode, 2)

         For ai = 0 To ub 
            If(aryPubCode(0, ai) = pCode) And (aryPubCode(2, ai) = pSubCode) Then 
               pName = aryPubCode(3, ai)
               Exit For 
            End If 
         Next 
      End If 
      pubGetSubName = pName
   End Function 
%>


