<% 
'   ===============================================================================     
'    Purpose : TB_ASSOCIATION에서 seq를 비교하여 Title을 반환한다. 
'    Make    : 2019.12.08
'    Author  :                                                       By Aramdry
'   ===============================================================================   
%>

<% 
	DBOpen()
	
'   ===============================================================================     
'     TB_ASSOCIATION의 모든 값을 DB로 부터 가져다가 2차원 배열에 저장한후 , 
'     그 배열을 가지고 특정 Text를 추출하는 함수를 만든다. 
'     SEQ, TITLE, SPORTS_CODE, SPORTS_TITLE
'   ===============================================================================   
   
  strSqlAssociation = 						"Select SEQ, TITLE, SPORTS_CODE, SPORTS_TITLE From TB_ASSOCIATION "
	strSqlAssociation = strSqlAssociation & "Where DELKEY = 0 Order By Seq "
  aryResAssociation = ExecuteReturn(strSqlAssociation, DB)

	DBClose()
%>

<%
'   ===============================================================================     
'     SUB_TITLE 반환한다. 
'   ===============================================================================  
   Function rxGetAssociationTitle(Seq)
      Dim pName, ub, Idx 
      pName = ""

      If( IsArray(aryResAssociation) ) Then 
         ub = UBound(aryResAssociation, 2) 

         For Idx = 0 To ub 
            If(CStr(aryResAssociation(0, Idx)) = CStr(Seq)) Then 
               pName = aryResAssociation(1, Idx)
               Exit For 
            End If 
         Next 

      End If 
      rxGetAssociationTitle = pName
   End Function 

'   ===============================================================================     
'     SUB_CODE 반환한다. 
'   =============================================================================== 
   Function rxGetAssociationSeq(strName)
      Dim assoc_seq, ub, Idx 
      pName = ""

      If( IsArray(aryResAssociation) ) Then 
         ub = UBound(aryResAssociation, 2) 

         For Idx = 0 To ub 
            If(aryResAssociation(1, Idx) = strName) Then 
               assoc_seq = aryResAssociation(0, Idx)
               Exit For 
            End If 
         Next 

      End If 
      rxGetAssociationSeq = subCode
   End Function 
%>

