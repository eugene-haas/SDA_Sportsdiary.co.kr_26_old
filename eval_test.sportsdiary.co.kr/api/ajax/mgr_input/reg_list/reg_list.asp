<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 데이터 등록 - 등록 현황 List
	'  Date     : 	2021.09.03
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<% 	
	'=================================================================================
	' 	
	'================================================================================= 
%>

<%
' http://eval.sportsdiary.co.kr/api/ajax/mgr_input/reg_list/reg_list.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

   '=================================================================================
	'  평가군
	'=================================================================================  
	Function getSqlEvalGroup()
		Dim strSql, err_no
				
		If( err_no <> 1 ) Then 	
			strSql = strSql & " Select ROW_NUMBER() Over(Order By CodeCD) As Idx, CodeCD, CodeNm  "
			strSql = strSql & " 		From tblPubCode Where KindCD = 2 And CodeCD > 0 "
		End If  

		getSqlEvalGroup = strSql 
	End Function

   '=================================================================================
	'  평가 협회 정보 , 협회별 등록/수정 최신 날짜 
	'=================================================================================  
	Function getSqlEvalAssociation(eval_table_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         '  총평등록, 평가의견 등록, 점수 등록에 대한 최신 날짜를 구한다.  "
         '  총평 등록 날짜를 구한다.  "
         strSql = strSql & " ;with cte_total_desc As ( "
         strSql = strSql & "    Select AssociationIDX, RegDate, ModDate "
         strSql = strSql & "          From tblAssociation_sub  "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0}  ", Array(eval_table_idx))
         strSql = strSql & " ) "
       
         '  평가 의견의 등록/수정 날짜를 구한다. "
         strSql = strSql & " , cte_desc As ( "
         strSql = strSql & "    Select AssociationIDX, Max(RegDate) As RegDate, Max(ModDate) As ModDate "
         strSql = strSql & "          From tblEvalDesc  "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0}  ", Array(eval_table_idx))
         strSql = strSql & "       Group By AssociationIDX "
         strSql = strSql & " ) "
       
         '  평가 점수의 등록/수정 날짜를 구한다.  "
         strSql = strSql & " , cte_value As ( "
         strSql = strSql & "    Select AssociationIDX, Max(RegDate) As RegDate, Max(ModDate) As ModDate "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0}  ", Array(eval_table_idx))
         strSql = strSql & "       Group By AssociationIDX "
         strSql = strSql & " ) "
      
         '  등록, 수정 날짜를 협회별로 하나로 하여 merge한다. (최신값 구하기 위해) "
         strSql = strSql & " , cte_info As ( "
         strSql = strSql & "    Select AssociationIDX, Max(reg_date) As reg_date From ( "
         strSql = strSql & "       Select AssociationIDX, RegDate As reg_date From cte_total_desc "
         strSql = strSql & "       Union  "
         strSql = strSql & "       Select AssociationIDX, ModDate As reg_date From cte_total_desc "
         strSql = strSql & "       Union "
         strSql = strSql & "       Select AssociationIDX, RegDate As reg_date From cte_desc "
         strSql = strSql & "       Union  "
         strSql = strSql & "       Select AssociationIDX, ModDate As reg_date From cte_desc "
         strSql = strSql & "       Union  "
         strSql = strSql & "       Select AssociationIDX, RegDate As reg_date From cte_value "
         strSql = strSql & "       Union  "
         strSql = strSql & "       Select AssociationIDX, ModDate As reg_date From cte_value "
         strSql = strSql & "    ) As C "
         strSql = strSql & "    Group By AssociationIDX "
         strSql = strSql & " ) "

         strSql = strSql & " Select ROW_NUMBER() Over(Partition By A.EvalGroupCD Order By A.MemberGroupCD, A.AssociationNm) As Idx,  "
         strSql = strSql & "    A.AssociationIDX, A.AssociationNm, A.EvalGroupCD, A.EvalGroupNm, A.MemberGroupCD, A.MemberGroupNm, A.RegYear, convert(varchar(10), I.reg_date, 120) As reg_date "
         strSql = strSql & "    From tblAssociation_sub As A  "
         strSql = strSql & "    Inner Join cte_info As I On I.AssociationIDX = A.AssociationIDX "
         strSql = strSql & sprintf("    Where A.DelKey = 0 And A.EvalTableIDX = {0}  ", Array(eval_table_idx))
		End If  

		getSqlEvalAssociation = strSql 
	End Function

   '=================================================================================
	'  평가 위원 
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
      
         ' 최고 관리자는 설정을 안하므로 임의로 셋팅한다.  "
         strSql = strSql & " , cte_master As ( "
         strSql = strSql & "    Select 0 As AdminMemberIDX, '최고관리자' As AdminName "
         strSql = strSql & " ) "
     
         ' 평가위원 정보를 merge한다.  "
         strSql = strSql & " , cte_info As ( "
         strSql = strSql & "    Select AdminMemberIDX, AdminName From cte_member	 "
         strSql = strSql & "    Union  "
         strSql = strSql & "    Select AdminMemberIDX, AdminName From cte_master "
         strSql = strSql & " ) "
         strSql = strSql & " Select ROW_NUMBER() Over(Order By AdminMemberIDX) As Idx, AdminMemberIDX, AdminName  "
         strSql = strSql & "    From cte_info "
		End If  

		getSqlEvalMember = strSql 
	End Function

   '=================================================================================
	'  평가 정보 
   '  카테고리, sub카테고리, 평가항목 갯수, 평가 배점 총합을 구한다. 
	'=================================================================================  
	Function getSqlEvalInfo(eval_table_idx)
		Dim strSql, err_no

      If(eval_table_idx = "") Then err_no = 1 End If 
				
		If( err_no <> 1 ) Then 	
         '카테고리, sub카테고리, 평가항목 갯수를 구하기 위해 평가 지표를 구한다.  "
         strSql = strSql & " ;with cte_item As ( "
         strSql = strSql & "    Select *  "
         strSql = strSql & "       From tblEvalItem "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & " ) "
         
         '가군을 기준으로 평가 지표에 할당된 총 점수를 얻는다.  "
         strSql = strSql & " , cte_point As ( "
         strSql = strSql & "    Select Sum(StandardPoint) As sum_point "
         strSql = strSql & "       From tblEvalItemTypeGroup "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "       And EvalGroupCD = 1 "
         strSql = strSql & " ) "
       
         '카테고리, sub카테고리, 평가항목 갯수, 평가 배점 총합을 구한다.  "
         strSql = strSql & " Select (Select Count(EvalItemIDX) As cnt_cate From cte_item Where EvalSubCateCD = 0) As cnt_cate,  "
         strSql = strSql & "       (Select Count(EvalItemIDX) As cnt_subcate From cte_item Where EvalSubCateCD > 0 And EvalItemCD = 0) As cnt_subcate,  "
         strSql = strSql & "       (Select Count(EvalItemIDX) As cnt_item From cte_item Where EvalItemCD > 0) As cnt_item,  "
         strSql = strSql & "    sum_point  "
         strSql = strSql & "    From cte_point "
		End If  

		getSqlEvalInfo = strSql 
	End Function

   '=================================================================================
	'  평가 현황 
   '  종목별 평가 현황을 보여준다. 
   '     -- 전체 평가 항목 갯수를 구한다 .
   '     -- 정성평가 갯수 : 평가위원 count * 평가 항목 갯수 
   '     -- 정량 평가및 감점 갯수 : 평가 항목 갯수 
   '     -- 평가의견 갯수 : 정성 평가 항목 * 평가위원
   '     -- 총평 등록갯수 : 1개 
	'=================================================================================  
	Function getSqlEvalState(eval_table_idx)
		Dim strSql, err_no

      If(eval_table_idx = "") Then err_no = 1 End If 
				
		If( err_no <> 1 ) Then 	
         strSql = strSql & " Declare @cnt_total int, @cnt_earnest int, @cnt_fixed int "
         
         ' 정성 평가 갯수는 평가위원에 할당된 갯수와 동일하다.  "
         strSql = strSql & " Select @cnt_earnest = Count(EvalMemberIDX) "
         strSql = strSql & "       From tblEvalMember "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
       
         ' 정량 평가 갯수는 정량평가 + 감점평가 갯수와 동일하다.  "
         strSql = strSql & " Select @cnt_fixed = Count(EvalItemTypeIDX) "
         strSql = strSql & "    From tblEvalItemType "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "       And EvalTypeCD In (2, 100) "
     
         ' 전체 평가 항목 갯수를 구한다.  "
         strSql = strSql & " Set @cnt_total = @cnt_earnest + @cnt_fixed "
     
         ' 종목별 정보를 구한다.  "
         strSql = strSql & " ;with cte_association As ( "
         strSql = strSql & "    Select AssociationIDX, AssociationNm, EvalGroupCD, EvalGroupNm, EvalText "
         strSql = strSql & "       From tblAssociation_sub  "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & " ) "
   
         ' 평가 점수를 구한다.  "
         strSql = strSql & " , cte_value As ( "
         strSql = strSql & "    Select AssociationIDX, Count(EvalValueIDX) As cnt_value "
         strSql = strSql & "    From tblEvalValue "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    Group By AssociationIDX "
         strSql = strSql & " ) "
    
         ' 평가 의견을 구한다.  "
         strSql = strSql & " , cte_desc As ( "
         strSql = strSql & "    Select AssociationIDX, Count(EvalDescIDX) As cnt_desc "
         strSql = strSql & "    From tblEvalDesc "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    Group By AssociationIDX "
         strSql = strSql & " ) "
     
         strSql = strSql & " Select ROW_NUMBER() Over(Partition By A.EvalGroupCD Order By A.AssociationNm) As Idx,  "
         strSql = strSql & "    A.EvalGroupCD,  A.EvalGroupNm, A.AssociationIDX, A.AssociationNm,  "
         strSql = strSql & "    Case When V.cnt_value = 0  Or V.cnt_value Is Null Then 0  "
         strSql = strSql & "       When V.cnt_value = @cnt_total Then 1  "
         strSql = strSql & "       Else 2 End As point_state,  "
         strSql = strSql & "    Case When D.cnt_desc = 0 Or D.cnt_desc Is Null Then 0  "
         strSql = strSql & "       When D.cnt_desc = @cnt_earnest Then 1  "
         strSql = strSql & "       Else 2 End As desc_state,  "
         strSql = strSql & "    Case When A.EvalText Is Null Then 0 Else 1 End total_desc_state "
         strSql = strSql & "    From cte_association As A  "
         strSql = strSql & "    Left Join cte_value As V On V.AssociationIDX = A.AssociationIDX "
         strSql = strSql & "    Left Join cte_desc As D On D.AssociationIDX = A.AssociationIDX "
		End If  

		getSqlEvalState = strSql 
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
	Dim cnt_group, group_info, cnt_member, member_info, cnt_association, association_info
   Dim cnt_eval, eval_info, cnt_eval_state, eval_state_info

   Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))

	If(eval_table_idx = "") Or (eval_table_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
		'  ----------------------------------------------------
      '  평가군 가져오기
      strSql = getSqlEvalGroup()
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalGroup = {0} ", Array(strSql))  
      ' ' ' ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group"
         aryKey = Split(strKeys, ",")

         group_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_group = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  평가 협회 
      strSql = getSqlEvalAssociation(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalAssociation = {0} ", Array(strSql))  
      ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, association_idx, association_name, eval_group_cd, eval_group, member_group_cd, member_group, reg_year, reg_date "
         aryKey = Split(strKeys, ",")

         association_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_association = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '   평가 위원 
      strSql = getSqlEvalMember(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalMember = {0} ", Array(strSql))  
      ' ' ' ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_member_idx, eval_member"
         aryKey = Split(strKeys, ",")

         member_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_member = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '   평가 정보  - 카테고리, sub카테고리, 평가항목 갯수, 평가 배점 총합
      strSql = getSqlEvalInfo(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalInfo = {0} ", Array(strSql))  
      ' ' ' ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "cnt_cate, cnt_subcate, cnt_item, sum_point"
         aryKey = Split(strKeys, ",")

         eval_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_eval = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '   평가 현황   - 종목별 평가 현황을 보여준다. 
      strSql = getSqlEvalState(eval_table_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalState = {0} ", Array(strSql))  
      ' ' ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group, association_idx, association, point_state, desc_state, total_desc_state"
         aryKey = Split(strKeys, ",")

         eval_state_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_eval_state = UBound(RS_DATA, 2) + 1
      End If

		JsonStr = utxAryToJsonStr(Array("state", "errorcode", "cnt_group", "group_info", "cnt_association", "association_info", "cnt_member", "member_info", "cnt_eval", "eval_info", "cnt_eval_state", "eval_state_info"), Array("true", "SUCCESS", cnt_group, group_info, cnt_association, association_info, cnt_member, member_info, cnt_eval, eval_info, cnt_eval_state, eval_state_info))
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

