<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가입력 - 평가의견 입력 - 초기화 
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
' http://eval.sportsdiary.co.kr/api/ajax/mgr_input/reg_data/reg_desc_init.asp
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
         strSql = strSql & " Select ROW_NUMBER() Over(Order By T.RegYear Desc, T.YearOrder Desc) As Idx,  "
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
	'  평가범주 - 카테고리 
	'=================================================================================  
	Function getSqlEvalCate(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         ' 평가군별 평가 배점을 구한다.  "
         strSql = strSql & " ;with cte_group As ( "
         strSql = strSql & " Select *  "
         strSql = strSql & "    From tblEvalItemTypeGroup  "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & " ) "
       
         ' Sub 카테고리 정보를 구한다. - 평가 지표 합 포함 "
         strSql = strSql & " Select Row_Number() Over(Partition By G.EvalGroupCD Order By I.CateOrderNo) As Idx,  "
         strSql = strSql & " G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, Sum(G.StandardPoint) As sum_point "
         strSql = strSql & "    From tblEvalItemType As I "
         strSql = strSql & " Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX "
         strSql = strSql & sprintf("    Where I.DelKey = 0 And I.EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    Group By G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm "
		End If  

		getSqlEvalCate = strSql 
	End Function

	'=================================================================================
	'  평가범주 - Sub 카테고리 
	'=================================================================================  
	Function getSqlEvalSubCate(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         ' 평가군별 평가 배점을 구한다. "
         strSql = strSql & " ;with cte_group As ( "
         strSql = strSql & " Select *  "
         strSql = strSql & "    From tblEvalItemTypeGroup  "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & " ) "
       
         ' Sub 카테고리 정보를 구한다. - 평가 지표 합 포함 "
         strSql = strSql & " Select Row_Number() Over(Partition By G.EvalGroupCD Order By I.CateOrderNo, I.SubCateOrderNo) As Idx,  "
         strSql = strSql & " G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm, Sum(G.StandardPoint) As sum_point "
         strSql = strSql & "    From tblEvalItemType As I "
         strSql = strSql & " Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX "
         strSql = strSql & sprintf("    Where I.DelKey = 0 And I.EvalTableIDX = {0}  ", Array(eval_table_idx))
         strSql = strSql & "    Group By G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm "
		End If  

		getSqlEvalSubCate = strSql 
	End Function

	'=================================================================================
	'  평가범주 - 평가 항목
	'=================================================================================  
	Function getSqlEvalItem(eval_table_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         '평가군별 평가 배점을 구한다. " 
         strSql = strSql & "  ;with cte_group As ( " 
         strSql = strSql & "  Select *  " 
         strSql = strSql & "     From tblEvalItemTypeGroup  " 
         strSql = strSql & sprintf("     Where DelKey = 0 And EvalTableIDX = {0} " , Array(eval_table_idx))
         strSql = strSql & "  ) " 
        
         '평가 항목 지표를 구한다. - 평가 방법 포함 " 
         strSql = strSql & "  Select Row_Number() Over(Partition By G.EvalGroupCD Order By T.CateOrderNo, T.SubCateOrderNo, T.ItemOrderNo) As Idx,  " 
         strSql = strSql & "  G.EvalGroupCD, G.EvalGroupNm, T.EvalItemTypeIdx, T.EvalItemIDX, T.CateOrderNo, T.EvalCateCD, T.EvalCateNm, T.SubCateOrderNo, T.EvalSubCateCD, T.EvalSubCateNm,  " 
         strSql = strSql & "  T.ItemOrderNo, T.EvalItemCD, T.EvalItemNm, G.StandardPoint, T.EvalTypeCD, T.EvalTypeNm " 
         strSql = strSql & "     From tblEvalItemType As T " 
         strSql = strSql & "  Inner Join cte_group As G On G.EvalItemTypeIdx = T.EvalItemTypeIdx " 
         strSql = strSql & sprintf("     Where T.DelKey = 0 And T.EvalTableIDX = {0} " , Array(eval_table_idx))
		End If  

		getSqlEvalItem = strSql 
	End Function

   '=================================================================================
	'  평가 위원 - 평가 의견은 정성만 입력한다. 
	'=================================================================================  
	Function getSqlEvalMember(eval_table_idx)
		Dim strSql, err_no

      If(eval_table_idx = "") Then err_no = 1 End If 
				
		If( err_no <> 1 ) Then 	
         ' 평가위원을 구한다.  "
         strSql = strSql & " ;with cte_member As ( "
         strSql = strSql & "    Select  AdminMemberIDX, AdminName "
         strSql = strSql & "       From tblEvalMember "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "       Group By  AdminMemberIDX, UserID, AdminName "
         strSql = strSql & " ) "

         strSql = strSql & " Select ROW_NUMBER() Over(Order By AdminMemberIDX) As Idx, AdminMemberIDX, AdminName  "
         strSql = strSql & "    From cte_member "
		End If  

		getSqlEvalMember = strSql 
	End Function
   

   '=================================================================================
	'  평가범주 - 평가 위원 평가 항목
	'=================================================================================  
	Function getSqlEvalMemberItem(eval_table_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         '  평가자를 구한다.  "
         strSql = strSql & " ;with cte_eval_member As ( "
         strSql = strSql & "    Select EvalItemTypeIDX, AdminMemberIdx, AdminName		 "
         strSql = strSql & "       From tblEvalMember "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & " ) "

         '  정량, 감점에서 최고 관리자를 구한다.  "
         strSql = strSql & " , cte_mgr As ( "
         strSql = strSql & "    Select EvalItemTypeIDX, 0 As  AdminMemberIdx, '최고관리자' As AdminName "
         strSql = strSql & "       From tblEvalItemType  "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And EvalTypeCD In (2, 100) ", Array(eval_table_idx))
         strSql = strSql & " ) "

         strSql = strSql & " , cte_info As ( "
         strSql = strSql & "    Select EvalItemTypeIDX, AdminMemberIdx, AdminName From cte_eval_member "
         strSql = strSql & "    Union  "
         strSql = strSql & "    Select EvalItemTypeIDX, AdminMemberIdx, AdminName From cte_mgr "
         strSql = strSql & " ) "

         '  정량 평가 , 감점 평가의 경우 최고 관리자로 ,  "
         '  정성일 경우 등록된 평가자를 뿌려 준다.  "
         strSql = strSql & " Select Row_Number() Over(Order By T.EvalItemTypeIDX) As Idx,  "
         strSql = strSql & "    T.EvalItemTypeIDX, T.EvalItemCD, M.AdminMemberIdx,  "
         strSql = strSql & "    M.AdminName As EvalName "
         strSql = strSql & " From tblEvalItemType As T  "
         strSql = strSql & " Inner Join cte_info As M On M.EvalItemTypeIDX = T.EvalItemTypeIDX "
         strSql = strSql & sprintf(" Where T.DelKey = 0 And T.EvalTableIDX = {0} ", Array(eval_table_idx))
		End If   

		getSqlEvalMemberItem = strSql 
	End Function

   '=================================================================================
	'  평가 의견 - 등록된 평가 의견을 가져온다 .
	'=================================================================================  
	Function getSqlEvalDesc(eval_table_idx, association_idx)
		Dim strSql, err_no

		If(eval_table_idx = "") Or (association_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         ' 최고 관리자의 AdminMemberIDX를 구한다. 
         strSql = strSql & " ;with cte_admin As ( "
         strSql = strSql & "    Select AdminMemberIDX From tblAdminMember "
         strSql = strSql & "       Where DelYN = 'N' And UseYN = 'Y' And Authority In ('A', 'B') "
         strSql = strSql & " ) "

         strSql = strSql & " Select ROW_NUMBER() Over(Order By EvalItemTypeIDX) As Idx, "
         strSql = strSql & "  EvalItemTypeIDX, dbo.FN_DEC_VAL(EvalDesc), " 
         strSql = strSql & "    Case When AdminMemberIDX In (Select AdminMemberIDX From cte_admin) Then 0 Else AdminMemberIDX End As AdminMemberIDX "
         strSql = strSql & "    From tblEvalDesc  "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
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
	Dim eval_table_idx, association_idx	
   Dim cnt_eval_title, eval_title_info 
	Dim cnt_cate, cate_info, cnt_subcate, subcate_info, cnt_item_type, item_type_info
   Dim cnt_member, member_info, cnt_member_item, member_item_info, cnt_desc, desc_info

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
      ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "association_name, eval_title"
         aryKey = Split(strKeys, ",")

         eval_title_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_eval_title = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '   평가 위원 
      strSql = getSqlEvalMember(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalMember = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_member_idx, eval_member"
         aryKey = Split(strKeys, ",")

         member_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_member = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  평가범주 - 카테고리
      strSql = getSqlEvalCate(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalCate = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group, eval_cate_order, eval_cate_cd, eval_cate, sum_point"
         aryKey = Split(strKeys, ",")

         cate_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_cate = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가범주 - Sub 카테고리 
      strSql = getSqlEvalSubCate(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalSubCate = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group, eval_cate_order,eval_cate_cd, eval_cate, eval_subcate_order,eval_subcate_cd, eval_subcate,sum_point"
         aryKey = Split(strKeys, ",")

         subcate_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_subcate = UBound(RS_DATA, 2) + 1
      End If

		'  ----------------------------------------------------
      '  평가범주 - 평가 항목
      strSql = getSqlEvalItem(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalItem = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group, item_type_idx, eval_item_idx, eval_cate_order,eval_cate_cd, eval_cate, eval_subcate_order, eval_subcate_cd, eval_subcate, eval_item_order, eval_item_cd, eval_item, sum_point, eval_type_cd, eval_type"
         aryKey = Split(strKeys, ",")

         item_type_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_item_type = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '   평가 위원 
      strSql = getSqlEvalMember(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalMember = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_member_idx, eval_member"
         aryKey = Split(strKeys, ",")

         member_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_member = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  평가범주 - 평가 위원 평가 항목
      strSql = getSqlEvalMemberItem(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalMemberItem = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog)  cnt_member_item, member_item_info		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, item_type_idx, eval_item_cd, eval_member_idx, eval_member"
         aryKey = Split(strKeys, ",")

         member_item_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_member_item = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  평가 의견 - 등록된 평가 의견을 가져온다 .
      strSql = getSqlEvalDesc(eval_table_idx, association_idx)
      RS_DATA = ExecuteReturn(strSql, ENC_DB)
      
      strLog = sprintf("getSqlEvalDesc = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog)  cnt_member_item, member_item_info		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, item_type_idx, eval_desc, eval_member_idx "
         aryKey = Split(strKeys, ",")

         desc_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_desc = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_eval_title", "eval_title_info", "cnt_cate", "cate_info", "cnt_subcate", "subcate_info", "cnt_item_type", "item_type_info", "cnt_member", "member_info", "cnt_member_item", "member_item_info", "cnt_desc", "desc_info"), Array("true", "SUCCESS", cnt_eval_title, eval_title_info, cnt_cate, cate_info, cnt_subcate, subcate_info, cnt_item_type, item_type_info, cnt_member, member_info, cnt_member_item, member_item_info, cnt_desc, desc_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
ENC_DBClose()
%>

