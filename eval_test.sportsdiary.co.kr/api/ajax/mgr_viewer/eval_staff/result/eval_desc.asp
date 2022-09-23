<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 - 협회별 평가 의견
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
' http://eval_test.sportsdiary.co.kr/api/ajax/mgr_viewer/eval_staff/result/eval_desc.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

   '=================================================================================
	'  평가 지표 결과 - 협회별 평가 의견
	'=================================================================================  
	Function getSqlAssociationDesc(eval_table_idx, association_idx, eval_member_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	           
         strSql = strSql & " Select Row_Number() Over(Order By EvalItemTypeIDX) As Idx,  " 
         strSql = strSql & "    EvalItemTypeIDX, EvalItemIDX, EvalTypeCD, dbo.FN_DEC_VAL(EvalDesc)  "  
         strSql = strSql & "    From tblEvalDesc " 
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} " , Array(eval_table_idx))
         strSql = strSql & sprintf("    And AssociationIDX = {0} And AdminMemberIdx = {1} " , Array(association_idx, eval_member_idx))
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
   Dim eval_table_idx, association_idx, eval_member_idx
	Dim cnt_eval_desc, eval_desc_info

	Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))
   association_idx		   = InjectionChk(JsonObj.get("association_idx"))
   eval_member_idx		   = InjectionChk(JsonObj.get("eval_member_idx"))

	If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
		'  ----------------------------------------------------
      '  평가 지표 결과 - 협회별 평가 의견
      strSql = getSqlAssociationDesc(eval_table_idx, association_idx, eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlAssociationDesc = {0} ", Array(strSql))
      ' ' ' Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, item_type_idx, eval_item_idx, eval_type_cd, eval_desc "
         aryKey = Split(strKeys, ",")

         eval_desc_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_eval_desc = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_eval_desc", "eval_desc_info"), Array("true", "SUCCESS", cnt_eval_desc, eval_desc_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
ENC_DBClose()
%>

