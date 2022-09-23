<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 - 협회별 평가  - 평가위원
	'  Date     : 	2021.09.02
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<% 	
	'=================================================================================
	' 	
	'================================================================================= 
%>

<%
' http://eval_test.sportsdiary.co.kr/api/ajax/mgr_viewer/eval_staff/result/result.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================
	   
	'=================================================================================
	'  평가군
	'=================================================================================  
	Function getSqlEvalGroup()
		Dim strSql, err_no
				
		If( err_no <> 1 ) Then 	
			strSql = strSql & " Select ROW_NUMBER() Over(Order By CodeCD) As Idx, CodeCD, CodeNm  "
			strSql = strSql & " 		From tblPubCode Where KindCD = 2 And CodeCD > 0 "
		End If  

		getSqlEvalGroup = strSql 
	End Function

   
	'=================================================================================
	'  평가 협회 
	'=================================================================================  
	Function getSqlEvalAssociation(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         strSql = strSql & " Select ROW_NUMBER() Over(Partition By EvalGroupCD Order By MemberGroupCD, AssociationNm) As Idx,  "
         strSql = strSql & "     AssociationIDX, AssociationNm, EvalGroupCD, EvalGroupNm, MemberGroupCD, MemberGroupNm, RegYear "
         strSql = strSql & " From tblAssociation_sub  "
         strSql = strSql & sprintf(" Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
		End If  

		getSqlEvalAssociation = strSql 
	End Function
	
	'=================================================================================
	'  평가범주 - 카테고리 
	'=================================================================================  
	Function getSqlEvalCate(eval_table_idx, eval_member_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Or (eval_member_idx = "")  Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         ' 평가군별 평가 배점을 구한다.   "
         ' 일반 평가위원: 평가위원 등록테이블에 등록된 항목 갯수  "
         strSql = strSql & " ;with cte_member As ( "
         strSql = strSql & "    Select  EvalItemTypeIDX "
         strSql = strSql & "       From tblEvalMember "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And AdminMemberIDX = {1}  ", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & " ) "
        
         strSql = strSql & " , cte_group As (  "
         strSql = strSql & " Select *   "
         strSql = strSql & "    From tblEvalItemTypeGroup   "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member) "
         strSql = strSql & " )          "
    
         ' 카테고리 정보를 구한다. - 평가 지표 합 포함  "
         strSql = strSql & " Select Row_Number() Over(Order By I.CateOrderNo) As Idx,   "
         strSql = strSql & " G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm "
         strSql = strSql & "    From tblEvalItemType As I  "
         strSql = strSql & " Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX  "
         strSql = strSql & sprintf("    Where I.DelKey = 0 And I.EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    And I.EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member) "
         strSql = strSql & "    Group By G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm  "
		End If  

		getSqlEvalCate = strSql 
	End Function

	'=================================================================================
	'  평가범주 - Sub 카테고리 
	'=================================================================================  
	Function getSqlEvalSubCate(eval_table_idx, eval_member_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Or (eval_member_idx = "")  Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         ' 평가군별 평가 배점을 구한다.   "
         ' 일반 평가위원: 평가위원 등록테이블에 등록된 항목 갯수  "
         strSql = strSql & " ;with cte_member As ( "
         strSql = strSql & "    Select  EvalItemTypeIDX "
         strSql = strSql & "       From tblEvalMember "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And AdminMemberIDX = {1}  ", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & " ) "
        
         strSql = strSql & " , cte_group As (  "
         strSql = strSql & " Select *   "
         strSql = strSql & "    From tblEvalItemTypeGroup   "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0}", Array(eval_table_idx))
         strSql = strSql & "    And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member) "
         strSql = strSql & " )          "
   
         ' Sub 카테고리 정보를 구한다. - 평가 지표 합 포함  "
         strSql = strSql & " Select Row_Number() Over(Order By I.CateOrderNo, I.SubCateOrderNo) As Idx,   "
         strSql = strSql & " G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm "
         strSql = strSql & "    From tblEvalItemType As I  "
         strSql = strSql & " Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX  "
         strSql = strSql & sprintf("    Where I.DelKey = 0 And I.EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    And I.EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member) "
         strSql = strSql & "    Group By G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm "
      
		End If  

		getSqlEvalSubCate = strSql 
	End Function

	'=================================================================================
	'  평가범주 - 평가 항목
	'=================================================================================  
	Function getSqlEvalItem(eval_table_idx, eval_member_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Or (eval_member_idx = "")  Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         ' 평가군별 평가 배점을 구한다.   "
         ' 일반 평가위원: 평가위원 등록테이블에 등록된 항목 갯수  "
         strSql = strSql & " ;with cte_member As ( "
         strSql = strSql & "    Select  EvalItemTypeIDX "
         strSql = strSql & "       From tblEvalMember "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And AdminMemberIDX = {1}  ", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & " ) "
        
         strSql = strSql & " , cte_group As (  "
         strSql = strSql & " Select *   "
         strSql = strSql & "    From tblEvalItemTypeGroup   "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0}", Array(eval_table_idx))
         strSql = strSql & "    And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member) "
         strSql = strSql & " )          "
   
         ' Sub 카테고리 정보를 구한다. - 평가 지표 합 포함  "
         strSql = strSql & " Select Row_Number() Over(Order By T.CateOrderNo, T.SubCateOrderNo, T.ItemOrderNo) As Idx,   "
         strSql = strSql & " G.EvalGroupCD, G.EvalGroupNm, T.EvalItemTypeIdx, T.EvalItemIDX, T.CateOrderNo, T.EvalCateCD, T.EvalCateNm, T.SubCateOrderNo, T.EvalSubCateCD, T.EvalSubCateNm, "
         strSql = strSql & " T.ItemOrderNo, T.EvalItemCD, T.EvalItemNm, G.StandardPoint, T.EvalTypeCD, T.EvalTypeNm "
         strSql = strSql & "    From tblEvalItemType As T  "
         strSql = strSql & " Inner Join cte_group As G On G.EvalItemTypeIdx = T.EvalItemTypeIdx  "
         strSql = strSql & sprintf("    Where T.DelKey = 0 And T.EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    And T.EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member) "
		End If  

		getSqlEvalItem = strSql 
	End Function
   
%>

<%
	'=================================================================================
	'  Sub Function 
	'================================================================================= 
%>

<%
DBOpen()
	Dim JsonStr, JsonObj, strSql, RS_DATA, err_no
   Dim aryKey, strKeys
	Dim eval_table_idx, eval_member_idx
	Dim cnt_group, group_info, cnt_association, association_info
	Dim cnt_cate, cate_info, cnt_subcate, subcate_info, cnt_item_type, item_type_info

	Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx")) 
   eval_member_idx		   = InjectionChk(JsonObj.get("eval_member_idx"))

	If(eval_table_idx = "") Or (eval_member_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
		
      '  ----------------------------------------------------
      '  평가군 가져오기
      strSql = getSqlEvalGroup()
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalGroup = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group"
         aryKey = Split(strKeys, ",")

         group_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_group = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가 협회 
      strSql = getSqlEvalAssociation(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalAssociation = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, association_idx, association_name, eval_group_cd, eval_group, member_group_cd, member_group, reg_year "
         aryKey = Split(strKeys, ",")

         association_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_association = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  평가범주 - 카테고리
      strSql = getSqlEvalCate(eval_table_idx, eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalCate = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group, eval_cate_order, eval_cate_cd, eval_cate"
         aryKey = Split(strKeys, ",")

         cate_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_cate = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가범주 - Sub 카테고리 
      strSql = getSqlEvalSubCate(eval_table_idx, eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalSubCate = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group, eval_cate_order, eval_cate_cd, eval_cate, eval_subcate_order, eval_subcate_cd, eval_subcate"
         aryKey = Split(strKeys, ",")

         subcate_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_subcate = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가범주 - 평가 항목
      strSql = getSqlEvalItem(eval_table_idx, eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalItem = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group, item_type_idx, eval_item_idx, eval_cate_order, eval_cate_cd, eval_cate, eval_subcate_order, eval_subcate_cd, eval_subcate, eval_item_order, eval_item_cd, eval_item, sum_point, eval_type_cd, eval_type"
         aryKey = Split(strKeys, ",")

         item_type_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_item_type = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_group", "group_info", "cnt_association", "association_info", "cnt_cate", "cate_info", "cnt_subcate", "subcate_info", "cnt_item_type", "item_type_info"), Array("true", "SUCCESS", cnt_group, group_info, cnt_association, association_info, cnt_cate, cate_info, cnt_subcate, subcate_info, cnt_item_type, item_type_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

