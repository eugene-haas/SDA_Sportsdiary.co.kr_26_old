<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 총평 등록 
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
' http://eval.sportsdiary.co.kr/api/ajax/mgr_input/reg_data/reg_total_desc.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

   '=================================================================================
	'  총평을 등록한다. 
   '  Vaild Check : 아이디 권한 체크 : 최고 관리자 이상만 등록 가능하다.  
   '                협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가 
   '  0: 정상 , 1: 권한 없음, 2: 미등록 협회 
	'=================================================================================  
	Function getSqlCheckValid(eval_table_idx, association_idx, eval_member_idx)
      Dim strSql, err_no
		
		If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
        
         strSql = strSql & " Declare @valid_id int, @vaild_association int "
        
         '  아이디 권한 체크 : 최고 관리자 이상만 등록 가능하다.  "
         strSql = strSql & " Select @valid_id = IsNull(Max(AdminMemberIDX), 0) "
         strSql = strSql & "    From tblAdminMember "
         strSql = strSql & sprintf("    Where DelYN = 'N' And Authority In ('A', 'B') And AdminMemberIDX = '{0}' ", Array(eval_member_idx))
       
         '  협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가 "
         strSql = strSql & " Select @vaild_association = IsNull(Max(AssociationIDX), 0) "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
         
         '  정상 등록  "
         strSql = strSql & " If(@valid_id > 0 And @vaild_association > 0)  "         
         strSql = strSql & "       Select 0 As err_code "
         strSql = strSql & " Else "
     
         '  권한 에러  "
         strSql = strSql & "    If(@valid_id = 0)					 "
         strSql = strSql & "       Select 1 As err_code "
     
         '  미등록 협회 에러  "
         strSql = strSql & "    Else If(@vaild_association = 0)		 "
         strSql = strSql & "       Select 2 As err_code "
        
		End If  

		getSqlCheckValid = strSql 
	End Function

   '=================================================================================
	'  총평을 등록한다. 
   '  eval_member_idx의 권한이 최고관리자 이상만 등록이 가능하다. 
	'=================================================================================  
	Function getSqlModDesc(eval_table_idx, association_idx, eval_desc)
      Dim strSql, err_no
		
		If(eval_table_idx = "") Or (association_idx = "") Or (eval_desc = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         strSql = strSql & sprintf(" Update tblAssociation_sub Set EvalText = dbo.FN_ENC_VAL('{0}'), ModDate = GetDate()  ", Array(eval_desc))
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
		End If  

		getSqlModDesc = strSql 
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
   Dim eval_table_idx, association_idx, eval_member_idx, eval_desc, rsp_err
	Dim cnt_list, list_info

   Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))
   association_idx		   = InjectionChk(JsonObj.get("association_idx"))
   eval_member_idx		   = InjectionChk(JsonObj.get("eval_member_idx"))
   eval_desc      		   = InjectionChk(JsonObj.get("eval_desc"))

	If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Or (eval_desc = "") Then err_no = 1 End If 

   strLog = sprintf("AdminMemberIDX = {0} ", Array(strSql))
   ' ' ' Call utxLog(DEV_LOG1, strLog)   

	If( err_no <> 1 ) Then 	
      If(eval_member_idx = 0) Then eval_member_idx = 2 End If 
      eval_desc = htmlEncode(eval_desc)

		'  ----------------------------------------------------
      '  Vaild Check  0: 정상 , 1: 권한 없음, 2: 미등록 협회 
      strSql = getSqlCheckValid(eval_table_idx, association_idx, eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlCheckValid = {0} ", Array(strSql))
       ' ' ' Call utxLog(DEV_LOG1, strLog)      

      If(IsArray(RS_DATA)) Then     
         rsp_err = RS_DATA(0,0)
      End If

      If(rsp_err = "0") Then 
         '  ----------------------------------------------------
         '  총평을 등록한다. 
         strSql = getSqlModDesc(eval_table_idx, association_idx, eval_desc)
         Call ExecuteUpdate(strSql, ENC_DB)

		   JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("true", "SUCCESS"))
      ElseIf(rsp_err = "1") Then 
         JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", E_TOTAL_DESC_NOT_AUTHIRITY))	' 권한 없음 
      ElseIf(rsp_err = "2") Then 
         JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", E_TOTAL_DESC_NOT_ASSOCIATION))	' 미등록 협회 
      End If 

	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
ENC_DBClose()
%>

