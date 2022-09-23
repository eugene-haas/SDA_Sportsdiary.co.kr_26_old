<% 
'   ===============================================================================     
'    Purpose : TB_SELECTITEM에서 subCode를 비교하여 subTitle을 반환한다. 
'    Make    : 2019.12.03
'    Author  :                                                       By Aramdry
'   ===============================================================================   
%>

<% 
	DBOpen()
	
'   ===============================================================================     
'     TB_SELECTITEM의 모든 값을 DB로 부터 가져다가 2차원 배열에 저장한후 , 
'     그 배열을 가지고 특정 Text를 추출하는 함수를 만든다. 
'     TITLE,MASTER_CODE,SUB_TITLE,SUB_CODE
'   ===============================================================================   
   
  strSqlRes = 						"Select ROW_NUMBER() Over(Partition by MASTER_CODE Order By Sub_Code) As Idx, "
	strSqlRes = strSqlRes & "TITLE,MASTER_CODE,SUB_TITLE,SUB_CODE From TB_SELECTITEM Where DelKey = 0 "
  aryResSelItem = ExecuteReturn(strSqlRes, DB)

	DBClose()
%>

<%
'   ===============================================================================     
'     SUB_TITLE 반환한다. 
'   ===============================================================================  
   Function rxGetSubTitle(subCode)
      Dim pName, ub, Idx 
      pName = ""

      If( IsArray(aryResSelItem) ) Then 
         ub = UBound(aryResSelItem, 2) 

         For Idx = 0 To ub 
            If(aryResSelItem(4, Idx) = subCode) Then 
               pName = aryResSelItem(3, Idx)
               Exit For 
            End If 
         Next 

      End If 
      rxGetSubTitle = pName
   End Function 

'   ===============================================================================     
'     SUB_CODE 반환한다. 
'   =============================================================================== 
   Function rxGetSubCode(subName)
      Dim subCode, ub, Idx 
      pName = ""

      If( IsArray(aryResSelItem) ) Then 
         ub = UBound(aryResSelItem, 2) 

         For Idx = 0 To ub 
            If(aryResSelItem(3, Idx) = subName) Then 
               subCode = aryResSelItem(4, Idx)
               Exit For 
            End If 
         Next 

      End If 
      rxGetSubCode = subCode
   End Function 
%>

