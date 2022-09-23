<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 - 종목비교 평가 - 협회 List
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
' http://eval.sportsdiary.co.kr/api/ajax/mgr_viewer/compare/association_list.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================
   
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
	Dim cnt_association, association_info

	Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))

	If(eval_table_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
		
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

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_association", "association_info"), Array("true", "SUCCESS", cnt_association, association_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

