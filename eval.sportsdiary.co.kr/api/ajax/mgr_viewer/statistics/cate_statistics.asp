<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 - 협회별 통계 - 카테고리
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
' http://eval.sportsdiary.co.kr/api/ajax/mgr_viewer/statistics/cate_statistics.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

   '=================================================================================
	'  협회별 통계 - 카테고리
	'=================================================================================  
	Function getSqlStatistics(eval_table_idx, association_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	         
         strSql = strSql & " Declare @group_code int , @cnt_group int, @cnt_association int "
        
         '  협회 코드를 받아서 협회가 속한 평가군 코드를 얻는다. (가,나,다,라,마 군) "
         strSql = strSql & " Select @group_code = EvalGroupCD "
         strSql = strSql & "       From tblAssociation_sub "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
    
         '  협회 평가군 count를 구한다.  "
         strSql = strSql & " Select @cnt_group = Count(EvalGroupCD) "
         strSql = strSql & "       From tblAssociation_sub "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And EvalGroupCD = @group_code ", Array(eval_table_idx))
    
         '  협회 전체 count를 구한다.  "
         strSql = strSql & " Select @cnt_association = Count(AssociationIDX) "
         strSql = strSql & "       From tblAssociation_sub "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0}    ", Array(eval_table_idx))
     
         '  카테고리 정보를 구한다. - 평가 지표 합 포함 "
         strSql = strSql & " ;with cte_group As ( "
         strSql = strSql & " Select *  "
         strSql = strSql & "    From tblEvalItemTypeGroup  "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    And EvalGroupCD = 1 "
         strSql = strSql & " ) "
    
         '  카테고리 정보를 구한다. - 평가 지표 합 포함 "
         strSql = strSql & " , cte_cate As ( "
         strSql = strSql & "    Select ROW_NUMBER() Over(Order By I.EvalCateCD) As Idx,  "
         strSql = strSql & "    I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, Sum(G.StandardPoint) As base_point "
         strSql = strSql & "    From tblEvalItemType As I  "
         strSql = strSql & "    Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX "
         strSql = strSql & sprintf("    Where I.DelKey = 0 And I.EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    Group By I.CateOrderNo, I.EvalCateCD, I.EvalCateNm "
         strSql = strSql & " ) "
   
         '  평가 카테고리에 대한 획득 총합을 구한다. (특정 종목) "
         strSql = strSql & " , cte_point As ( "
         strSql = strSql & "    Select EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalCateCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalCateCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
   
         strSql = strSql & " , cte_point_merge As ( "
         strSql = strSql & "    Select EvalCateCD , Sum(Point) As Point  "
         strSql = strSql & "       From cte_point "
         strSql = strSql & "    Group By EvalCateCD "
         strSql = strSql & " )             "
    
         '  평가 카테고리에 대한 획득 총합을 구한다. (Group) "
         strSql = strSql & " , cte_point_group As ( "
         strSql = strSql & "    Select EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} And EvalGroupCD = @group_code ", Array(eval_table_idx))
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalCateCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
      
         strSql = strSql & " , cte_point_group_merge As ( "
         strSql = strSql & "    Select EvalCateCD , Sum(Point) As Point  "
         strSql = strSql & "       From cte_point_group "
         strSql = strSql & "    Group By EvalCateCD "
         strSql = strSql & " ) "
    
         '  평가 카테고리에 대한 획득 총합을 구한다. (Group) "
         strSql = strSql & " , cte_point_all As ( "
         strSql = strSql & "    Select EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx)) 
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalCateCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
        
         strSql = strSql & " , cte_point_all_merge As ( "
         strSql = strSql & "    Select EvalCateCD , Sum(Point) As Point  "
         strSql = strSql & "       From cte_point_all "
         strSql = strSql & "    Group By EvalCateCD "
         strSql = strSql & " ) "
       
         strSql = strSql & " Select ROW_NUMBER() Over(Order By C.CateOrderNo) As Idx,  "
         strSql = strSql & "    C.CateOrderNo, C.EvalCateCD, C.EvalCateNm, C.base_point,  "
         strSql = strSql & "    IsNull(P.Point, 0) As point_assoc, Case When C.base_point = 0 Then 0 Else IsNull(Round( (Cast(P.Point As Float) / C.base_point * 100) , 2), 0) End As percent_assoc,  "
         strSql = strSql & "    IsNull(G.Point, 0) As point_group, Case When C.base_point = 0 Then 0 Else IsNull(Round( (Cast(G.Point As Float) / C.base_point * 100) , 2), 0) End As percent_group,  "
         strSql = strSql & "    IsNull(A.Point, 0) As point_total, Case When C.base_point = 0 Then 0 Else IsNull(Round( (Cast(A.Point As Float) / C.base_point * 100) , 2), 0) End As percent_total "
         strSql = strSql & " From cte_cate As C  "
         strSql = strSql & " Left Join cte_point_merge As P On P.EvalCateCD = C.EvalCateCD "
         strSql = strSql & " Left Join cte_point_group_merge As G On G.EvalCateCD = C.EvalCateCD "
         strSql = strSql & " Left Join cte_point_all_merge As A On A.EvalCateCD = C.EvalCateCD "
		End If  

		getSqlStatistics = strSql 
	End Function

   '=================================================================================
	'  협회별 통계 - 카테고리 - 감점
	'=================================================================================  
	Function getSqlSubtractPoint(eval_table_idx, association_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	         
         strSql = strSql & " Declare @group_code int , @cnt_group int, @cnt_association int "
       
         '  협회 코드를 받아서 협회가 속한 평가군 코드를 얻는다. (가,나,다,라,마 군) "
         strSql = strSql & " Select @group_code = EvalGroupCD "
         strSql = strSql & "       From tblAssociation_sub "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
      
         '  협회 평가군 count를 구한다.  "
         strSql = strSql & " Select @cnt_group = Count(EvalGroupCD) "
         strSql = strSql & "       From tblAssociation_sub "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And EvalGroupCD = @group_code ", Array(eval_table_idx))
       
         '  협회 전체 count를 구한다.  "
         strSql = strSql & " Select @cnt_association = Count(AssociationIDX) "
         strSql = strSql & "       From tblAssociation_sub "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0}   ", Array(eval_table_idx))
      
         '  감점 평가 항목을 구한다.  "
         strSql = strSql & " ;with cte_item As ( "
         strSql = strSql & " Select EvalItemTypeIDX, EvalItemIdx, EvalItemCD, EvalItemNm "
         strSql = strSql & "    From tblEvalItemType "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    And EvalTypeCD = 100 "
         strSql = strSql & " ) "
      
         '  감점 항목에 대한 획득 총합을 구한다. (특정 종목) "
         strSql = strSql & " , cte_point As ( "
         strSql = strSql & "    Select EvalItemTypeIDX, EvalItemIdx, Round(Cast(PointCalc As Float) /100, 2)  As Point  "
         strSql = strSql & "       From tblEvalValue "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
         strSql = strSql & "    And EvalTypeCD = 100 "
         strSql = strSql & " ) "
       
         '  감점 항목에 대한 획득 총합을 구한다. (Group) "
         strSql = strSql & " , cte_point_group As ( "
         strSql = strSql & "    Select EvalItemTypeIDX, EvalItemIdx, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalItemTypeIDX, EvalItemIdx, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} And EvalGroupCD = @group_code ", Array(eval_table_idx))
         strSql = strSql & "          And EvalTypeCD =100 "
         strSql = strSql & "          Group By EvalItemTypeIDX, EvalItemIdx "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
       
         '  감점 항목에 대한 획득 총합을 구한다. (Group) "
         strSql = strSql & " , cte_point_all As ( "
         strSql = strSql & "    Select EvalItemTypeIDX, EvalItemIdx, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalItemTypeIDX, EvalItemIdx, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "          And EvalTypeCD = 100 "
         strSql = strSql & "          Group By EvalItemTypeIDX, EvalItemIdx "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
      
         '  감점 항목에 대한 정보를 보여준다.  "
         strSql = strSql & " Select  "
         strSql = strSql & "    I.EvalItemTypeIDX, I.EvalItemIdx, I.EvalItemCD, I.EvalItemNm,  "
         strSql = strSql & "    IsNull(P.Point, 0) As point_assoc, IsNull(G.Point, 0) As point_group, IsNull(A.Point, 0) As point_total "
         strSql = strSql & " From cte_item As I  "
         strSql = strSql & " Left Join cte_point As P On P.EvalItemTypeIDX = I.EvalItemTypeIDX "
         strSql = strSql & " Left Join cte_point_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX "
         strSql = strSql & " Left Join cte_point_all As A On A.EvalItemTypeIDX = I.EvalItemTypeIDX "
		End If  

		getSqlSubtractPoint = strSql 
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
   Dim eval_table_idx, association_idx
	Dim cnt_statistics, statistics_info, cnt_subtract, subtract_info

	Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))
   association_idx		   = InjectionChk(JsonObj.get("association_idx"))

	If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
		'  ----------------------------------------------------
      '  통계 협회별 카테고리 점수 
      strSql = getSqlStatistics(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlStatistics = {0} ", Array(strSql))
      ' ' ' Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_cate_order, eval_cate_cd, eval_cate, base_point, point_assoc, percent_assoc, point_group, percent_group, point_total, percent_total"
         aryKey = Split(strKeys, ",")

         statistics_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_statistics = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  통계 협회별 카테고리 감점
      strSql = getSqlSubtractPoint(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlSubtractPoint = {0} ", Array(strSql))
      ' ' Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         strKeys = "item_type_idx, eval_item_idx, eval_item_cd, eval_item, point_assoc, point_group, point_total"
         aryKey = Split(strKeys, ",")

         subtract_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_subtract = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_statistics", "statistics_info", "cnt_subtract", "subtract_info"), Array("true", "SUCCESS", cnt_statistics, statistics_info, cnt_subtract, subtract_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

