<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가입력 - 평가의견 요청
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
' http://eval_test.sportsdiary.co.kr/api/ajax/mgr_input/reg_data/req_desc.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================
  
   '=================================================================================
	'  평가 의견 - 등록된 평가 의견을 가져온다 .
	'=================================================================================  
	Function getSqlEvalDesc(eval_table_idx, association_idx, eval_member_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	         
         strSql = strSql & " Select ROW_NUMBER() Over(Order By EvalItemTypeIDX) As Idx,  "
         strSql = strSql & "    EvalItemTypeIDX, dbo.FN_DEC_VAL(EvalDesc), AdminMemberIdx "
         strSql = strSql & sprintf("    From tblEvalDesc Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
         strSql = strSql & sprintf("    And AdminMemberIDX = {0} ", Array(eval_member_idx))
		End If  

		getSqlEvalDesc = strSql 
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
   Dim cnt_eval_title, eval_title_info 
	Dim cnt_desc, desc_info

	Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))
   association_idx		   = InjectionChk(JsonObj.get("association_idx"))
   eval_member_idx		   = InjectionChk(JsonObj.get("eval_member_idx"))

	If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 		
      
      '  ----------------------------------------------------
      '  평가 의견 - 등록된 평가 의견을 가져온다 .
      strSql = getSqlEvalDesc(eval_table_idx, association_idx, eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalDesc = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog)  cnt_member_item, member_item_info		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, item_type_idx, eval_desc, eval_member_idx "
         aryKey = Split(strKeys, ",")

         desc_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_desc = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_desc", "desc_info"), Array("true", "SUCCESS", cnt_desc, desc_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
ENC_DBClose()
%>

