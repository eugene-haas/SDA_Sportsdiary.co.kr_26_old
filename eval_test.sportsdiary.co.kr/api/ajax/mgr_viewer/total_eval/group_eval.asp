<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	종목군 종합평가
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
' http://eval.sportsdiary.co.kr/api/ajax/mgr_viewer/total_eval/group_eval.asp
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
	'  종목군 종합 평가 - 카테고리별 평가군 점수 
	'=================================================================================  
	Function getSqlCate(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         '  카테고리 정보를 구한다 가군을 기준으로 구한다.  "
         strSql = strSql & " ;with cte_group As ( "
         strSql = strSql & "    Select *  "
         strSql = strSql & "       From tblEvalItemTypeGroup  "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    And EvalGroupCD = 1 "
         strSql = strSql & " ) "
        
         '  카테고리 정보를 구한다. - 평가 지표 합 포함 "
         strSql = strSql & " , cte_cate As ( "         
         strSql = strSql & "    Select    I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, Sum(G.StandardPoint) As base_point "
         strSql = strSql & "       From tblEvalItemType As I  "
         strSql = strSql & "       Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX "
         strSql = strSql & sprintf("       Where I.DelKey = 0 And I.EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "       Group By I.CateOrderNo, I.EvalCateCD, I.EvalCateNm "
         strSql = strSql & " )   "
      
         '  카테고리별, 평가군 점수를 구한다.  "
         strSql = strSql & " Select  ROW_NUMBER() Over(Order By C.CateOrderNo) As Idx,  "
         strSql = strSql & "    C.CateOrderNo, C.EvalCateCD, C.EvalCateNm, C.base_point "
         strSql = strSql & "    From cte_cate As C  "
		End If  

		getSqlCate = strSql 
	End Function

   '=================================================================================
	'  종목군 종합 평가 - 카테고리별 평가군 점수 
	'=================================================================================  
	Function getSqlGroupPoint(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         ' 평가군별, 카테고리별, 평가 항목별 점수를 구한다.  "
         strSql = strSql & " ;with cte_point As ( "
         strSql = strSql & "    Select EvalGroupCD, EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalGroupCD, EvalCateCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalGroupCD, EvalCateCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
 
         ' 평가군별, 카테고리별 평가 점수를 구한다.  "
         strSql = strSql & " , cte_point_merge As ( "
         strSql = strSql & "       Select EvalGroupCD, EvalCateCD, Sum(Point) As Point  "
         strSql = strSql & "          From cte_point "
         strSql = strSql & "       Group By EvalGroupCD, EvalCateCD "
         strSql = strSql & " ) "
         strSql = strSql & " Select ROW_NUMBER() Over(Partition By EvalCateCD Order By EvalGroupCD) As Idx,  "
         strSql = strSql & "    EvalGroupCD, EvalCateCD, Point  "
         strSql = strSql & " From cte_point_merge "
		End If  

		getSqlGroupPoint = strSql 
	End Function

   '=================================================================================
	'  종목군 종합 평가 - 평가군별 총합 
	'=================================================================================  
	Function getSqlTotalInfo(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         '  평가 군별 , 평가 항목별 평가 점수를 구한다.  "
         strSql = strSql & " ;with cte_point As ( "
         strSql = strSql & "    Select EvalGroupCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalGroupCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalGroupCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
       
         '  평가군별 평가 항목의 합을 구한다.  "
         strSql = strSql & " , cte_info As ( "
         strSql = strSql & "    Select EvalGroupCD, Sum(Point) As Point  "
         strSql = strSql & "          From cte_point "
         strSql = strSql & "       Group By EvalGroupCD "
         strSql = strSql & " ) "
      
         '  평가 군별 평가 점수 합을 구한다.  "
         strSql = strSql & " Select EvalGroupCD, Point	From cte_info  "
		End If  

		getSqlTotalInfo = strSql 
	End Function

   '=================================================================================
	'  종목군 종합 평가 - 감점 평균
	'=================================================================================  
	Function getSqlSubtractInfo(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         '  감점 점수를 구한다 . "
         strSql = strSql & " ;with cte_subtract As ( "
         strSql = strSql & "    Select EvalGroupCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "             From tblEvalValue "
         strSql = strSql & sprintf("             Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "             And EvalTypeCD = 100 "
         strSql = strSql & "             Group By EvalGroupCD, EvalItemTypeIDX "
         strSql = strSql & " ) "
         
         '  감점 점수의 평균을 구한다.  "
         strSql = strSql & " Select  EvalGroupCD, Case When cnt_val = 0 Then 0 Else Round(Cast(sum_point As Float) /(cnt_val *100), 2) End As subtract_point  "
         strSql = strSql & "    From cte_subtract "
		End If  

		getSqlSubtractInfo = strSql 
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
	Dim cnt_group, group_info, cnt_cate, cate_info, cnt_group_point, group_point_info, cnt_total, total_info, cnt_subtract, subtract_info

	Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))

	If(eval_table_idx = "") Or (eval_table_idx = "") Then err_no = 1 End If 

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
      '  종목군 종합 평가 - 카테고리별 평가군 점수 
      strSql = getSqlCate(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlCate = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_cate_order, eval_cate_cd, eval_cate, base_point"
         aryKey = Split(strKeys, ",")

         cate_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_cate = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  종목군 종합 평가 - 평가군별 카테고리 점수 
      strSql = getSqlGroupPoint(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlGroupPoint = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_cate_cd, ave_point"
         aryKey = Split(strKeys, ",")

         group_point_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_group_point = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  종목군 종합 평가 - 평가군별 총합 
      strSql = getSqlTotalInfo(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlTotalInfo = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 		cnt_total, total_info

      If(IsArray(RS_DATA)) Then
         strKeys = "eval_group_cd, total_point"
         aryKey = Split(strKeys, ",")

         total_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_total = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  종목군 종합 평가 - 감점 평균
      strSql = getSqlSubtractInfo(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlSubtractInfo = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "eval_group_cd, subtract_point"
         aryKey = Split(strKeys, ",")

         subtract_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_subtract = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_group", "group_info", "cnt_cate", "cate_info", "cnt_group_point", "group_point_info", "cnt_total", "total_info", "cnt_subtract", "subtract_info"), Array("true", "SUCCESS", cnt_group, group_info, cnt_cate, cate_info, cnt_group_point, group_point_info, cnt_total, total_info, cnt_subtract, subtract_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

