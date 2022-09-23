<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 - 협회별 평가 
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
' http://eval_test.sportsdiary.co.kr/api/ajax/mgr_viewer/association/result/result.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

   '=================================================================================
	'  그룹 정보 - 협회임원
	'=================================================================================  
	Function getSqlEvalGroup(eval_table_idx, association_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	   
         strSql = strSql & " Select AssociationIDX, AssociationNm, EvalGroupCD, EvalGroupNm "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
		End If  

		getSqlEvalGroup = strSql 
	End Function


	'=================================================================================
	'  평가범주 - 카테고리 
	'=================================================================================  
	Function getSqlEvalCate(eval_table_idx, association_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
   
         strSql = strSql & " Declare @group_cd int "

		   ' 협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가   
         strSql = strSql & " Select @group_cd = EvalGroupCD "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))

         ' 평가군별 평가 배점을 구한다.  "
         strSql = strSql & " ;with cte_group As ( "
         strSql = strSql & " Select *  "
         strSql = strSql & "    From tblEvalItemTypeGroup  "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And EvalGroupCD = @group_cd ", Array(eval_table_idx))
         strSql = strSql & " ) "
       
         ' 카테고리 정보를 구한다. - 평가 지표 합 포함 "
         strSql = strSql & " Select Row_Number() Over(Order By I.CateOrderNo) As Idx,  "
         strSql = strSql & " G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, Sum(G.StandardPoint) As sum_point "
         strSql = strSql & "    From tblEvalItemType As I "
         strSql = strSql & " Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX "
         strSql = strSql & sprintf("    Where I.DelKey = 0 And I.EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    Group By G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm "
		End If  

		getSqlEvalCate = strSql 
	End Function

	'=================================================================================
	'  평가범주 - Sub 카테고리 
	'=================================================================================  
	Function getSqlEvalSubCate(eval_table_idx, association_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         strSql = strSql & " Declare @group_cd int "
         
		   ' 협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가   
         strSql = strSql & " Select @group_cd = EvalGroupCD "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))

         ' 평가군별 평가 배점을 구한다. "
         strSql = strSql & " ;with cte_group As ( "
         strSql = strSql & " Select *  "
         strSql = strSql & "    From tblEvalItemTypeGroup  "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And EvalGroupCD = @group_cd ", Array(eval_table_idx))
         strSql = strSql & " ) "
       
         ' Sub 카테고리 정보를 구한다. - 평가 지표 합 포함 "
         strSql = strSql & " Select Row_Number() Over(Order By I.CateOrderNo, I.SubCateOrderNo) As Idx,  "
         strSql = strSql & " G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm, Sum(G.StandardPoint) As sum_point "
         strSql = strSql & "    From tblEvalItemType As I "
         strSql = strSql & " Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX "
         strSql = strSql & sprintf("    Where I.DelKey = 0 And I.EvalTableIDX = {0}  ", Array(eval_table_idx))
         strSql = strSql & "    Group By G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm "
		End If  

		getSqlEvalSubCate = strSql 
	End Function

	'=================================================================================
	'  평가범주 - 평가 항목
	'=================================================================================  
	Function getSqlEvalItem(eval_table_idx, association_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         strSql = strSql & " Declare @group_cd int "
         
		   ' 협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가   
         strSql = strSql & " Select @group_cd = EvalGroupCD "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))


         '평가군별 평가 배점을 구한다. " 
         strSql = strSql & "  ;with cte_group As ( " 
         strSql = strSql & "  Select *  " 
         strSql = strSql & "     From tblEvalItemTypeGroup  " 
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And EvalGroupCD = @group_cd ", Array(eval_table_idx))
         strSql = strSql & "  ) " 
        
         '평가 항목 지표를 구한다. - 평가 방법 포함 " 
         strSql = strSql & "  Select Row_Number() Over(Partition By G.EvalGroupCD Order By T.CateOrderNo, T.SubCateOrderNo, T.ItemOrderNo) As Idx,  " 
         strSql = strSql & "  T.EvalItemTypeIdx, T.EvalItemIDX, G.EvalGroupCD, G.EvalGroupNm, T.CateOrderNo, T.EvalCateCD, T.EvalCateNm, T.SubCateOrderNo, T.EvalSubCateCD, T.EvalSubCateNm,  " 
         strSql = strSql & "  T.ItemOrderNo, T.EvalItemCD, T.EvalItemNm, G.StandardPoint, T.EvalTypeCD, T.EvalTypeNm " 
         strSql = strSql & "     From tblEvalItemType As T " 
         strSql = strSql & "  Inner Join cte_group As G On G.EvalItemTypeIdx = T.EvalItemTypeIdx " 
         strSql = strSql & sprintf("     Where T.DelKey = 0 And T.EvalTableIDX = {0} " , Array(eval_table_idx))
		End If  

		getSqlEvalItem = strSql 
	End Function

   '=================================================================================
	'  평가 지표 결과 - 협회별 평가 점수
	'=================================================================================  
	Function getSqlAssociationPoint(eval_table_idx, association_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         '협회별 평가 점수를 구한다.  "
         strSql = strSql & " ;With cte_score As ( "
         strSql = strSql & "    Select EvalItemTypeIDX, EvalItemIDX, EvalTypeCD, Sum(PointCalc) As sum_point, Count(EvalValueIDX) As cnt_val "
         strSql = strSql & "       From tblEvalValue "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & sprintf("       And AssociationIDX = {0} ", Array(association_idx))
         strSql = strSql & "       Group By EvalItemTypeIDX, EvalItemIDX, EvalTypeCD "
         strSql = strSql & " ) "
        
         strSql = strSql & " Select Row_Number() Over(Order By EvalItemTypeIDX) As Idx,  "
         strSql = strSql & " EvalItemTypeIDX, EvalItemIDX, EvalTypeCD,  "
         strSql = strSql & "    Round(Cast(sum_point As Float) /(cnt_val * 100), 2) As ave_val "
         strSql = strSql & "    From cte_score "
		End If  

		getSqlAssociationPoint = strSql 
	End Function

   '=================================================================================
	'  평가 지표 결과 - 협회별 평가 의견
	'=================================================================================  
	Function getSqlAssociationDesc(eval_table_idx, association_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	         
         ' 최고 관리자의 AdminMemberIDX를 구한다. 
         strSql = strSql & " ;with cte_admin As ( "
         strSql = strSql & "    Select AdminMemberIDX From tblAdminMember "
         strSql = strSql & "       Where DelYN = 'N' And UseYN = 'Y' And Authority In ('A', 'B') "
         strSql = strSql & " ) "

         strSql = strSql & " Select Row_Number() Over(Order By EvalItemTypeIDX) As Idx,  " 
         strSql = strSql & "    EvalItemTypeIDX, EvalItemIDX, EvalTypeCD, dbo.FN_DEC_VAL(EvalDesc) ,  "  
			strSql = strSql & "    Case When AdminMemberIDX In (Select AdminMemberIDX From cte_admin) Then 0 Else AdminMemberIDX End As AdminMemberIDX  "
         strSql = strSql & "    From tblEvalDesc " 
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} " , Array(eval_table_idx))
         strSql = strSql & sprintf("    And AssociationIDX = {0} " , Array(association_idx))
		End If  

		getSqlAssociationDesc = strSql 
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
	Dim cnt_group, group_info, cnt_eval_desc, eval_desc_info, cnt_eval_point, eval_point_info
	Dim cnt_cate, cate_info, cnt_subcate, subcate_info, cnt_item_type, item_type_info

	Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))
   association_idx		   = InjectionChk(JsonObj.get("association_idx"))

	If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
      '  ----------------------------------------------------
      '  그룹 정보 - 협회임원
      strSql = getSqlEvalGroup(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalGroup = {0} ", Array(strSql))  
      ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "association_idx, association, eval_group_cd, eval_group"
         aryKey = Split(strKeys, ",")

         group_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_group = UBound(RS_DATA, 2) + 1
      End If
		
      '  ----------------------------------------------------
      '  평가범주 - 카테고리
      strSql = getSqlEvalCate(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalCate = {0} ", Array(strSql))  
      ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group, eval_cate_order, eval_cate_cd, eval_cate, sum_point"
         aryKey = Split(strKeys, ",")

         cate_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_cate = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가범주 - Sub 카테고리 
      strSql = getSqlEvalSubCate(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalSubCate = {0} ", Array(strSql))  
      ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group, eval_cate_order, eval_cate_cd, eval_cate, eval_subcate_order, eval_subcate_cd, eval_subcate,sum_point"
         aryKey = Split(strKeys, ",")

         subcate_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_subcate = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가범주 - 평가 항목
      strSql = getSqlEvalItem(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalItem = {0} ", Array(strSql))  
      ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, item_type_idx, eval_item_idx, eval_group_cd, eval_group, eval_cate_order, eval_cate_cd, eval_cate, eval_subcate_order, eval_subcate_cd, eval_subcate, eval_item_order, eval_item_cd, eval_item, sum_point, eval_type_cd, eval_type"
         aryKey = Split(strKeys, ",")

         item_type_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_item_type = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  평가 지표 결과 - 협회별 평가 점수
      strSql = getSqlAssociationPoint(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlAssociationPoint = {0} ", Array(strSql))
      ' Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, item_type_idx, eval_item_idx, eval_type_cd, ave_val"
         aryKey = Split(strKeys, ",")

         eval_point_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_eval_point = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  평가 지표 결과 - 협회별 평가 의견
      strSql = getSqlAssociationDesc(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlAssociationDesc = {0} ", Array(strSql))
      ' Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, item_type_idx, eval_item_idx, eval_type_cd, eval_desc ,eval_member_idx " 'by baek
         aryKey = Split(strKeys, ",")

         eval_desc_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_eval_desc = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_group", "group_info", "cnt_cate", "cate_info", "cnt_subcate", "subcate_info", "cnt_item_type", "item_type_info", "cnt_eval_point", "eval_point_info", "cnt_eval_desc", "eval_desc_info"), Array("true", "SUCCESS", cnt_group, group_info, cnt_cate, cate_info, cnt_subcate, subcate_info, cnt_item_type, item_type_info, cnt_eval_point, eval_point_info, cnt_eval_desc, eval_desc_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
ENC_DBClose()
%>

