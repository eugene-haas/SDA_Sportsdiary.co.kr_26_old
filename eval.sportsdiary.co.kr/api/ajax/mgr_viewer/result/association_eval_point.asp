<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 - 협회별 평가 점수 
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
' http://eval.sportsdiary.co.kr/api/ajax/mgr_viewer/result/association_eval_point.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

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
	Dim cnt_eval_point, eval_point_info

	Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))
   association_idx		   = InjectionChk(JsonObj.get("association_idx"))

	If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
		'  ----------------------------------------------------
      '  평가 지표 결과 - 협회별 평가 점수
      strSql = getSqlAssociationPoint(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlAssociationPoint = {0} ", Array(strSql))
      ' ' ' Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, item_type_idx, eval_item_idx, eval_type_cd, ave_val"
         aryKey = Split(strKeys, ",")

         eval_point_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_eval_point = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_eval_point", "eval_point_info"), Array("true", "SUCCESS", cnt_eval_point, eval_point_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

