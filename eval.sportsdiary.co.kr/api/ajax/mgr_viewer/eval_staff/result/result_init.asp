<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 - 전체 평가 초기화 - 평가위원
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
' http://eval_test.sportsdiary.co.kr/api/ajax/mgr_viewer/eval_staff/result/result_init.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

   '=================================================================================
	'  평가 List 가져오기 
	'=================================================================================  
	Function getSqlEvalList(eval_member_idx)
		Dim strSql, err_no
		
      If(eval_member_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	        
         '  평가자가 평가한 평가 Table List를 구한다 . "
         strSql = strSql & " ;with cte_eval_member As ( "
         strSql = strSql & "    Select EvalTableIdx From tblEvalMember "
         strSql = strSql & sprintf("       Where DelKey = 0 And AdminMemberIDX = {0} ", Array(eval_member_idx))
         strSql = strSql & "       Group By EvalTableIdx "
         strSql = strSql & " ) "
         
         '  같은 년도에 평가가 여러개일 경우 EvalTitle + YearOrder로 표시 하고,  "
         '  평가가 1개일 경우 EvalTitle만 표시한다.  "
         '  같은 년도에 여러개의 평가가 있는지 확인한다.  "
         strSql = strSql & " , cte_check_eval As( "
         strSql = strSql & "    Select RegYear, cnt_eval From ( "
         strSql = strSql & "       Select RegYear, Count(RegYear) As cnt_eval  "
         strSql = strSql & "          From tblEvalTable	 "
         strSql = strSql & "          Where DelKey = 0 "
         strSql = strSql & "          Group By RegYear "
         strSql = strSql & "    ) As C Where cnt_eval > 1 "
         strSql = strSql & " )             "
       
         strSql = strSql & " Select ROW_NUMBER() Over(Order By T.RegYear Desc, T.YearOrder Desc) As Idx,  "
         strSql = strSql & "    T.EvalTableIDX, T.RegYear,  "
         strSql = strSql & "    Case When C.RegYear Is Null Then EvalTitle Else EvalTitle + '_' + Cast(YearOrder As varChar(10)) End As EvalTitle "
         strSql = strSql & " From tblEvalTable As T "
         strSql = strSql & " Left Join cte_check_eval As C On C.RegYear = T.RegYear "
         strSql = strSql & " Where T.DelKey = 0 And T.EvalTableIDX In (Select EvalTableIdx From cte_eval_member) "
        
		End If  

		getSqlEvalList = strSql 
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
   Dim eval_member_idx
	Dim cnt_list, list_info

   Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
   eval_member_idx		   = InjectionChk(JsonObj.get("eval_member_idx"))

	If(eval_member_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
		'  ----------------------------------------------------
      '  평가 List 가져오기 
      strSql = getSqlEvalList(eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalList = {0} ", Array(strSql))
      ' ' ' Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_table_idx, reg_year, eval_title"
         aryKey = Split(strKeys, ",")

         list_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_list = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_list", "list_info"), Array("true", "SUCCESS", cnt_list, list_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

