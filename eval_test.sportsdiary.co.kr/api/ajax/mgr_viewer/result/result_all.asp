<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 - 전체 평가 
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
' http://eval.sportsdiary.co.kr/api/ajax/mgr_viewer/result/result_all.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================
   
	'=================================================================================
	'  평가군별 평가 타입
	'=================================================================================  
	Function getSqlEvalType(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
			strSql = strSql & " Select ROW_NUMBER() Over(Partition By G.EvalGroupCD Order By T.EvalTypeCD) As Idx,  "
			strSql = strSql & " 		G.EvalGroupCD, G.EvalGroupNm, T.EvalTypeCD, T.EvalTypeNm  "
			strSql = strSql & " 	 From tblEvalItemType As T  "
			strSql = strSql & " 	 Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX "
			strSql = strSql & sprintf(" 	 Where T.Delkey = 0 And T.EvalTableIDX = {0} And T.EvalTypeCD < 100 ", Array(eval_table_idx))
			strSql = strSql & sprintf(" 	 And G.Delkey = 0 And G.EvalTableIDX = {0}  ", Array(eval_table_idx))
			strSql = strSql & " 	 Group By G.EvalGroupCD, G.EvalGroupNm, T.EvalTypeCD, T.EvalTypeNm  "
		End If  

		getSqlEvalType = strSql 
	End Function

	'=================================================================================
	'  평가군별 평가 타입
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
	'  평가범주 - 카테고리 
	'=================================================================================  
	Function getSqlEvalCate(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
			' 가군에서 평가 배점을 구한다.  "
			strSql = strSql & " ;with cte_group As ( "
			strSql = strSql & " Select *  "
			strSql = strSql & " 	From tblEvalItemTypeGroup  "
			strSql = strSql & sprintf(" 	Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
			strSql = strSql & " 	And EvalGroupCD = 1 "
			strSql = strSql & " ) "
			
			' 카테고리 정보를 구한다. - 평가 지표 합 포함 "
			strSql = strSql & " Select ROW_NUMBER() Over(Order By I.CateOrderNo) As Idx,  "
			strSql = strSql & " 		I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, Sum(G.StandardPoint) As sum_point "
			strSql = strSql & " 	From tblEvalItemType As I  "
			strSql = strSql & " 	Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX "
			strSql = strSql & sprintf(" 	Where I.DelKey = 0 And I.EvalTableIDX = {0} ", Array(eval_table_idx))
			strSql = strSql & " 	Group By I.CateOrderNo, I.EvalCateCD, I.EvalCateNm "
		End If  

		getSqlEvalCate = strSql 
	End Function

	'=================================================================================
	'  평가범주 - Sub 카테고리 
	'=================================================================================  
	Function getSqlEvalSubCate(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
			' 가군에서 평가 배점을 구한다.  "
			strSql = strSql & " ;with cte_group As ( "
			strSql = strSql & " Select *  "
			strSql = strSql & " 	From tblEvalItemTypeGroup  "
			strSql = strSql & sprintf(" 	Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
			strSql = strSql & " 	And EvalGroupCD = 1 "
			strSql = strSql & " ) "
		
			' 마군에서 평가 배점을 구한다.  "
			strSql = strSql & " , cte_group5 As ( "
			strSql = strSql & " Select *  "
			strSql = strSql & " 	From tblEvalItemTypeGroup  "
			strSql = strSql & sprintf(" 	Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
			strSql = strSql & " 	And EvalGroupCD = 5 "
			strSql = strSql & " ) "
		
			' Sub 카테고리 정보를 구한다. - 평가 지표 합 포함 "
			strSql = strSql & " Select ROW_NUMBER() Over(Order By I.CateOrderNo, I.SubCateOrderNo) As Idx,  "
			strSql = strSql & " 		I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm, Sum(G.StandardPoint) As sum_point, Sum(G5.StandardPoint) As sum_point5 "
			strSql = strSql & " 	From tblEvalItemType As I "
			strSql = strSql & " 	Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX "
			strSql = strSql & " 	Inner Join cte_group5 As G5 On G5.EvalItemTypeIDX = I.EvalItemTypeIDX "
			strSql = strSql & sprintf(" 	Where I.DelKey = 0 And I.EvalTableIDX = {0}  ", Array(eval_table_idx))
			strSql = strSql & " 	Group By I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm "
		End If  

		getSqlEvalSubCate = strSql 
	End Function

	'=================================================================================
	'  평가범주 - 평가 항목
	'=================================================================================  
	Function getSqlEvalItem(eval_table_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
			' 가군에서 평가 배점을 구한다.  "
			strSql = strSql & " ;with cte_group As ( "
			strSql = strSql & " 	Select *  "
			strSql = strSql & " 		From tblEvalItemTypeGroup  "
			strSql = strSql & sprintf(" 		Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
			strSql = strSql & " 		And EvalGroupCD = 1 "
			strSql = strSql & " ) "
			
			' Sub 카테고리 정보를 구한다. - 평가 지표 합 포함 "
			strSql = strSql & " Select ROW_NUMBER() Over(Order By I.CateOrderNo, I.SubCateOrderNo, I.ItemOrderNo) As Idx,  "
			strSql = strSql & " 		I.EvalItemIDX, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo,I.EvalSubCateCD, I.EvalSubCateNm, I.ItemOrderNo, I.EvalItemCD, I.EvalItemNm,   "
			strSql = strSql & " 		Sum(G.StandardPoint) As sum_point "
			strSql = strSql & " 	From tblEvalItemType As I "
			strSql = strSql & " 	Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX "
			strSql = strSql & sprintf(" 	Where I.DelKey = 0 And I.EvalTableIDX = {0} ", Array(eval_table_idx))
			strSql = strSql & " 	Group By I.EvalItemIDX, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo,I.EvalSubCateCD, I.EvalSubCateNm, I.ItemOrderNo, I.EvalItemCD, I.EvalItemNm "
		End If  

		getSqlEvalItem = strSql 
	End Function

	'=================================================================================
	'  평가범주 - 평가군별 , 평가 타입별 평균 점수를 구한다. 
	'=================================================================================  
	Function getSqlEvalPoint(eval_table_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
			'  군별 측정 타입을 가져온다.  " 
			strSql = strSql & " ;with cte_type As ( " 
			strSql = strSql & " 	Select ROW_NUMBER() Over(Partition By G.EvalGroupCD Order By T.EvalTypeCD) As Idx,  " 
			strSql = strSql & " 	G.EvalGroupCD, G.EvalGroupNm, T.EvalTypeCD, T.EvalTypeNm  " 
			strSql = strSql & " 	From tblEvalItemType As T  " 
			strSql = strSql & " 	Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX " 
			strSql = strSql & sprintf(" 	Where T.Delkey = 0 And T.EvalTableIDX = {0} And T.EvalTypeCD < 100 " , Array(eval_table_idx))
			strSql = strSql & sprintf(" 	And G.Delkey = 0 And G.EvalTableIDX = {0}  " , Array(eval_table_idx))
			strSql = strSql & " 	Group By G.EvalGroupCD, G.EvalGroupNm, T.EvalTypeCD, T.EvalTypeNm  " 
			strSql = strSql & " ) " 
			
			'  측정 항목별, 군별 점수를 얻어온다. (평균) " 
			'  감점 타입일 경우 정량으로 변동하여 표시한다.  " 
			strSql = strSql & " , cte_info As ( " 
			strSql = strSql & " 	Select EvalItemIdx, EvalGroupCD,  " 
			strSql = strSql & " 		Case When EvalTypeCD = 100 Then 2 Else EvalTypeCD End As EvalTypeCD,   " 
			strSql = strSql & " 		Count(EvalValueIdx) As cnt_val, Sum(PointCalc) As sum_point " 
			strSql = strSql & " 		From tblEvalValue  " 
			strSql = strSql & sprintf(" 		Where Delkey = 0 And EvalTableIDX = {0} " , Array(eval_table_idx))
			strSql = strSql & " 		Group By EvalItemIdx, EvalGroupCD, EvalTypeCD " 
			strSql = strSql & " ) " 
		
			'  평가군별 , 평가 타입별 평균 점수를 구한다.  " 
			strSql = strSql & " Select ROW_NUMBER() Over(Partition By EvalItemIdx Order By I.EvalGroupCD, T.EvalTypeCD) As Idx,  " 
			strSql = strSql & " 	I.EvalItemIdx, I.EvalGroupCD, T.EvalTypeCD,  " 
			strSql = strSql & " 	Case When I.EvalGroupCD = T.EvalGroupCD And I.EvalTypeCD <> T.EvalTypeCD Then 0 " 
			strSql = strSql & " 		Else Round(Cast(I.sum_point As Float) /(I.cnt_val *100), 2) End As ave_val " 
			strSql = strSql & " 	From cte_info As I " 
			strSql = strSql & " 	Left Join cte_type As T On T.EvalGroupCD = I.EvalGroupCD And T.EvalTypeCD = I.EvalTypeCD " 
		End If  

		getSqlEvalPoint = strSql 
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
	Dim eval_table_idx
	Dim cnt_group, group_info, cnt_type, type_info
	Dim cnt_cate, cate_info, cnt_subcate, subcate_info, cnt_item, item_info, cnt_eval_point, eval_point_info

	Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))

	If(eval_table_idx = "") Or (eval_table_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
		
		'  ----------------------------------------------------
      '  평가군 가져오기
      strSql = getSqlEvalGroup()
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalGroup = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group"
         aryKey = Split(strKeys, ",")

         group_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_group = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가군별 평가 타입
      strSql = getSqlEvalType(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalType = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group, eval_type_cd, eval_type"
         aryKey = Split(strKeys, ",")

         type_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_type = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가범주 - 카테고리
      strSql = getSqlEvalCate(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalCate = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_cate_order, eval_cate_cd, eval_cate, sum_point"
         aryKey = Split(strKeys, ",")

         cate_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_cate = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가범주 - Sub 카테고리 
      strSql = getSqlEvalSubCate(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalSubCate = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_cate_order, eval_cate_cd, eval_cate, eval_subcate_order, eval_subcate_cd, eval_subcate,sum_point, sum_point5"
         aryKey = Split(strKeys, ",")

         subcate_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_subcate = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가범주 - 평가 항목
      strSql = getSqlEvalItem(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalItem = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_item_idx, eval_cate_order, eval_cate_cd, eval_cate, eval_subcate_order, eval_subcate_cd, eval_subcate, eval_item_order, eval_item_cd, eval_item, sum_point"
         aryKey = Split(strKeys, ",")

         item_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_item = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가범주 - 평가군별 , 평가 타입별 평균 점수를 구한다.
      strSql = getSqlEvalPoint(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalPoint = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_item_idx, eval_group_cd, eval_type_cd, ave_val"
         aryKey = Split(strKeys, ",")

         eval_point_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_eval_point = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_group", "group_info", "cnt_type", "type_info", "cnt_cate", "cate_info", "cnt_subcate", "subcate_info", "cnt_item", "item_info", "cnt_eval_point", "eval_point_info"), Array("true", "SUCCESS", cnt_group, group_info, cnt_type, type_info, cnt_cate, cate_info, cnt_subcate, subcate_info, cnt_item, item_info, cnt_eval_point, eval_point_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

