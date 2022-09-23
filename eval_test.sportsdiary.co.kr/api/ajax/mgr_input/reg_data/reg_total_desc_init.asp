<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가입력 - 총평 입력 - 초기화 
	'  Date     : 	2021.09.06
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<% 	
	'=================================================================================
	' 	
	'================================================================================= 
%>

<%
' http://eval.sportsdiary.co.kr/api/ajax/mgr_input/reg_data/reg_total_desc_init.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

   '=================================================================================
	'  배점등록  - Title (평가 타이틀 + 협회명)
	'=================================================================================  
	Function getSqlEvalTitle(eval_table_idx, association_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         ' 같은 년도에 평가가 여러개일 경우 EvalTitle + YearOrder로 표시 하고,  "
         ' 평가가 1개일 경우 EvalTitle만 표시한다.  "
         ' 같은 년도에 여러개의 평가가 있는지 확인한다.  "
         strSql = strSql & " ;with cte_check_eval As( "
         strSql = strSql & "    Select RegYear, cnt_eval From ( "
         strSql = strSql & "       Select RegYear, Count(RegYear) As cnt_eval  "
         strSql = strSql & "       From tblEvalTable	 "
         strSql = strSql & "       Where DelKey = 0 "
         strSql = strSql & "       Group By RegYear "
         strSql = strSql & "    ) As C Where cnt_eval > 1 "
         strSql = strSql & " ) "

         strSql = strSql & " , cte_eval As ( "
         strSql = strSql & " Select ROW_NUMBER() Over(Order By T.RegYear Desc, T.YearOrder Desc) As Idx,   "
         strSql = strSql & "    T.EvalTableIDX, T.RegYear,  "
         strSql = strSql & "    Case When C.RegYear Is Null Then EvalTitle Else EvalTitle + '_' + Cast(YearOrder As varChar(10)) End As EvalTitle "
         strSql = strSql & "    From tblEvalTable As T "
         strSql = strSql & "    Left Join cte_check_eval As C On C.RegYear = T.RegYear "
         strSql = strSql & sprintf("    Where T.DelKey = 0 And T.EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & " ) "

         strSql = strSql & " , cte_association As ( "
         strSql = strSql & "    Select AssociationIDX, AssociationNm  "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & sprintf("    And AssociationIDX = {0} ", Array(association_idx))
         strSql = strSql & " ) "

         strSql = strSql & " Select AssociationNm, (Select EvalTitle From cte_eval) As eval_title "
         strSql = strSql & "    From cte_association "
		End If  

		getSqlEvalTitle = strSql 
	End Function

   '=================================================================================
	'  배점등록 - 카테고리
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
         strSql = strSql & "    Select ROW_NUMBER() Over(Order By I.CateOrderNo) As Idx,  "
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
         strSql = strSql & "    IsNull(P.Point, 0) As point_assoc, IsNull(Round( (Cast(P.Point As Float) / C.base_point * 100) , 2), 0) As percent_assoc,  "
         strSql = strSql & "    IsNull(G.Point, 0) As point_group, IsNull(Round( (Cast(G.Point As Float) / C.base_point * 100) , 2), 0) As percent_group,  "
         strSql = strSql & "    IsNull(A.Point, 0) As point_total, IsNull(Round( (Cast(A.Point As Float) / C.base_point * 100) , 2), 0) As percent_total "
         strSql = strSql & " From cte_cate As C  "
         strSql = strSql & " Left Join cte_point_merge As P On P.EvalCateCD = C.EvalCateCD "
         strSql = strSql & " Left Join cte_point_group_merge As G On G.EvalCateCD = C.EvalCateCD "
         strSql = strSql & " Left Join cte_point_all_merge As A On A.EvalCateCD = C.EvalCateCD "
		End If  

		getSqlStatistics = strSql 
	End Function

   '=================================================================================
	'  배점등록 - 카테고리 - 감점
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

   '=================================================================================
	'  배점등록  - 총평 등록
	'=================================================================================  
	Function getSqlTotalDesc(eval_table_idx, association_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	         
         strSql = strSql & " Select IsNull( dbo.FN_DEC_VAL(EvalText), '') As EvalText "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
		End If  

		getSqlTotalDesc = strSql 
	End Function
   
%>

<%
	'=================================================================================
	'  Sub Function 
	'================================================================================= 
%>

<%
ENC_DBOpen()
	Dim JsonStr, JsonObj, strSql, RS_DATA, err_no
   Dim aryKey, strKeys
   Dim eval_table_idx, association_idx
	Dim cnt_eval_title, eval_title_info, cnt_statistics, statistics_info, cnt_subtract, subtract_info
   Dim cnt_total_desc, total_desc_info

	Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))
   association_idx		   = InjectionChk(JsonObj.get("association_idx"))

	If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
      '  ----------------------------------------------------
      '  배점등록  - Title (평가 타이틀 + 협회명)
      strSql = getSqlEvalTitle(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalCate = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "association_name, eval_title"
         aryKey = Split(strKeys, ",")

         eval_title_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_eval_title = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  통계 협회별 카테고리 점수 
      strSql = getSqlStatistics(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
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
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlSubtractPoint = {0} ", Array(strSql))
      ' ' ' Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         strKeys = "item_type_idx, eval_item_idx, eval_item_cd, eval_item, point_assoc, point_group, point_total"
         aryKey = Split(strKeys, ",")

         subtract_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_subtract = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  배점등록  - 총평 등록
      strSql =getSqlTotalDesc(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlTotalDesc = {0} ", Array(strSql))
      ' ' ' Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         strKeys = "total_eval_desc"
         aryKey = Split(strKeys, ",")

         total_desc_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_total_desc = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_eval_title", "eval_title_info", "cnt_statistics", "statistics_info", "cnt_subtract", "subtract_info", "cnt_total_desc", "total_desc_info"), Array("true", "SUCCESS", cnt_eval_title, eval_title_info, cnt_statistics, statistics_info, cnt_subtract, subtract_info, cnt_total_desc, total_desc_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
ENC_DBClose()
%>

