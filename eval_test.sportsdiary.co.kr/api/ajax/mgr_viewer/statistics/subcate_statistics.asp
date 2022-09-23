<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 - 협회별 통계 - Sub 카테고리, 평가 항목
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
' http://eval.sportsdiary.co.kr/api/ajax/mgr_viewer/statistics/subcate_statistics.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

   '=================================================================================
	'  협회별 통계 - Sub 카테고리
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
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0}  ", Array(eval_table_idx))
     
         '  평가 항목 평가 타입별 배점을 구한다.  "
         strSql = strSql & " ;with cte_group As ( "
         strSql = strSql & " Select *  "
         strSql = strSql & "    From tblEvalItemTypeGroup  "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    And EvalGroupCD = @group_code "
         strSql = strSql & " ) "
     
         '  Sub 카테고리 정보를 구한다. - 평가 지표 합 포함 "
         strSql = strSql & " , cte_subcate As ( "
         strSql = strSql & "    Select I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm, Sum(G.StandardPoint) As base_point "
         strSql = strSql & "    From tblEvalItemType As I  "
         strSql = strSql & "    Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX "
         strSql = strSql & sprintf("    Where I.DelKey = 0 And I.EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    Group By I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm "
         strSql = strSql & " ) "
     
         '  평가 Sub 카테고리에 대한 획득 총합을 구한다. (특정 종목) "
         strSql = strSql & " , cte_point As ( "
         strSql = strSql & "    Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
       
         strSql = strSql & " , cte_point_merge As ( "
         strSql = strSql & "    Select EvalCateCD , EvalSubCateCD, Sum(Point) As Point  "
         strSql = strSql & "       From cte_point "
         strSql = strSql & "    Group By EvalCateCD, EvalSubCateCD "
         strSql = strSql & " )             "
    
         '  평가 카테고리에 대한 획득 총합을 구한다. (Group) "
         strSql = strSql & " , cte_point_group As ( "
         strSql = strSql & "    Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} And EvalGroupCD = @group_code ", Array(eval_table_idx))
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
       
         strSql = strSql & " , cte_point_group_merge As ( "
         strSql = strSql & "    Select EvalCateCD , EvalSubCateCD, Sum(Point) As Point  "
         strSql = strSql & "       From cte_point_group "
         strSql = strSql & "    Group By EvalCateCD, EvalSubCateCD "
         strSql = strSql & " ) "
     
         '  평가 카테고리에 대한 획득 총합을 구한다. (Group) "
         strSql = strSql & " , cte_point_all As ( "
         strSql = strSql & "    Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
      
         strSql = strSql & " , cte_point_all_merge As ( "
         strSql = strSql & "    Select EvalCateCD , EvalSubCateCD, Sum(Point) As Point  "
         strSql = strSql & "       From cte_point_all "
         strSql = strSql & "    Group By EvalCateCD, EvalSubCateCD "
         strSql = strSql & " ) "
      
         strSql = strSql & " Select ROW_NUMBER() Over(Partition By S.EvalCateCD Order By S.CateOrderNo, S.SubCateOrderNo) As Idx,  "
         strSql = strSql & "    S.CateOrderNo, S.EvalCateCD, S.EvalCateNm, S.SubCateOrderNo, S.EvalSubCateCD, S.EvalSubCateNm, S.base_point,  "
         strSql = strSql & "    IsNull(P.Point, 0) As point_assoc, Case When S.base_point = 0 Then 0 Else IsNull(Round( (Cast(P.Point As Float) / S.base_point * 100) , 2), 0) End As percent_assoc,  "
         strSql = strSql & "    IsNull(G.Point, 0) As point_group, Case When S.base_point = 0 Then 0 Else IsNull(Round( (Cast(G.Point As Float) / S.base_point * 100) , 2), 0) End As percent_group,  "
         strSql = strSql & "    IsNull(A.Point, 0) As point_total, Case When S.base_point = 0 Then 0 Else IsNull(Round( (Cast(A.Point As Float) / S.base_point * 100) , 2), 0) End As percent_total "
         strSql = strSql & " From cte_subcate As S  "
         strSql = strSql & " Left Join cte_point_merge As P On P.EvalCateCD = S.EvalCateCD And  P.EvalSubCateCD = S.EvalSubCateCD "
         strSql = strSql & " Left Join cte_point_group_merge As G On G.EvalCateCD = S.EvalCateCD And  G.EvalSubCateCD = S.EvalSubCateCD "
         strSql = strSql & " Left Join cte_point_all_merge As A On A.EvalCateCD = S.EvalCateCD And  A.EvalSubCateCD = S.EvalSubCateCD "
		End If  

		getSqlStatistics = strSql 
	End Function

   '=================================================================================
	'  협회별 통계 - 통계 협회별  평가항목 점수 
	'=================================================================================  
	Function getSqlStatisticsItem(eval_table_idx, association_idx)
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
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0}", Array(eval_table_idx))
      
         '  평가 항목 평가 타입별 배점을 구한다.  "
         strSql = strSql & " ;with cte_group As ( "
         strSql = strSql & " Select *  "
         strSql = strSql & "    From tblEvalItemTypeGroup  "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    And EvalGroupCD = 1 "
         strSql = strSql & " ) "
       
         '  평가항목 정보를 구한다. - 평가 지표 합 포함 "
         strSql = strSql & " , cte_item As ( "
         strSql = strSql & "    Select I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm, I.ItemOrderNo, I.EvalItemCD, I.EvalItemNm, I.EvalTypeCD, I.EvalTypeNm, I.EvalItemTypeIDX, G.StandardPoint As base_point "
         strSql = strSql & "    From tblEvalItemType As I  "
         strSql = strSql & "    Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX "
         strSql = strSql & sprintf("    Where I.DelKey = 0 And I.EvalTableIDX = {0} And I.EvalTypeCD < 100", Array(eval_table_idx))
         strSql = strSql & " ) "
       
         '  평가 Sub 카테고리에 대한 획득 총합을 구한다. (특정 종목) "
         strSql = strSql & " , cte_point As ( "
         strSql = strSql & "    Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
      
         '  평가 카테고리에 대한 획득 총합을 구한다. (Group) "
         strSql = strSql & " , cte_point_group As ( "
         strSql = strSql & "    Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} And EvalGroupCD = @group_code ", Array(eval_table_idx))
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
       
         '  평가 카테고리에 대한 획득 총합을 구한다. (Group) "
         strSql = strSql & " , cte_point_all As ( "
         strSql = strSql & "    Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 2) As Point   "
         strSql = strSql & "       From ( "
         strSql = strSql & "       Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point  "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "          And EvalTypeCD < 100 "
         strSql = strSql & "          Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
       
         strSql = strSql & " Select ROW_NUMBER() Over(Partition By I.EvalCateCD Order By I.CateOrderNo, I.SubCateOrderNo, I.ItemOrderNo) As Idx,  "
         strSql = strSql & "    I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm, I.ItemOrderNo, I.EvalItemCD, I.EvalItemNm, I.EvalTypeCD, I.EvalTypeNm, I.EvalItemTypeIDX, I.base_point,  "
         strSql = strSql & "    IsNull(P.Point, 0) As point_assoc, IsNull(G.Point, 0) As point_group, IsNull(A.Point, 0) As point_total "
         strSql = strSql & " From cte_item As I  "
         strSql = strSql & " Left Join cte_point As P		On P.EvalCateCD = I.EvalCateCD And  P.EvalSubCateCD = I.EvalSubCateCD And  P.EvalItemTypeIDX = I.EvalItemTypeIDX "
         strSql = strSql & " Left Join cte_point_group As G	On G.EvalCateCD = I.EvalCateCD And  G.EvalSubCateCD = I.EvalSubCateCD And  G.EvalItemTypeIDX = I.EvalItemTypeIDX "
         strSql = strSql & " Left Join cte_point_all As A	On A.EvalCateCD = I.EvalCateCD And  A.EvalSubCateCD = I.EvalSubCateCD And  A.EvalItemTypeIDX = I.EvalItemTypeIDX "
		End If  

		getSqlStatisticsItem = strSql 
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
	Dim cnt_statistics, statistics_info, cnt_item_type, item_type_info

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
         strKeys = "idx, eval_cate_cd, eval_cate_order, eval_cate, eval_subcate_cd, eval_subcate_order, eval_subcate, base_point, point_assoc, percent_assoc, point_group, percent_group, point_total, percent_total"
         aryKey = Split(strKeys, ",")

         statistics_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_statistics = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  통계 협회별 카테고리 점수 
      strSql = getSqlStatisticsItem(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlStatisticsItem = {0} ", Array(strSql))
      ' ' Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_cate_order, eval_cate_cd, eval_cate, eval_subcate_order, eval_subcate_cd, eval_subcate, eval_item_order, eval_item_cd, eval_item, eval_type_cd, eval_type, item_type_idx, base_point, point_assoc, point_group, point_total"
         aryKey = Split(strKeys, ",")

         item_type_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_item_type = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_statistics", "statistics_info", "cnt_item_type", "item_type_info"), Array("true", "SUCCESS", cnt_statistics, statistics_info, cnt_item_type, item_type_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

