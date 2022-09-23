<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 데이터 등록 - 등록 현황 List - 평가위원
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
' http://eval_test.sportsdiary.co.kr/api/ajax/mgr_input/eval_staff/reg_list/reg_list.asp
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
	'  평가 협회 
	'=================================================================================  
	Function getSqlEvalAssociation(eval_table_idx, eval_member_idx)
		Dim strSql, err_no
		
		If(eval_table_idx = "") Or (eval_member_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
         '  평가위원에서는 총평 등록을 하지 않지만, 협회 등록 날짜를 Default로 넣기 위해 구한다.   "
         '  평가의견 등록, 점수 등록에 대한 최신 날짜를 구한다.  "
         '  총평 등록 날짜를 구한다.  "
         strSql = strSql & " ;with cte_total_desc As ( "
         strSql = strSql & "    Select AssociationIDX, RegDate, ModDate "
         strSql = strSql & "          From tblAssociation_sub  "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0}  ", Array(eval_table_idx))
         strSql = strSql & " ) "
        
         '  평가 위원에 종속된 평가 항목을 구한다.  "
         strSql = strSql & " , cte_member As ( "
         strSql = strSql & "    Select EvalItemTypeIDX  "
         strSql = strSql & "       From tblEvalMember  "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And AdminMemberIDX = {1}  ", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & " ) "
      
         '  평가위원의 평가 항목에 대한 평가 의견의 등록/수정 날짜를 구한다.  "
         strSql = strSql & " , cte_desc As ( "
         strSql = strSql & "    Select AssociationIDX, Max(RegDate) As RegDate, Max(ModDate) As ModDate "
         strSql = strSql & "          From tblEvalDesc  "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX ={0}  ", Array(eval_table_idx))
         strSql = strSql & "       And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member) "
         strSql = strSql & "       Group By AssociationIDX "
         strSql = strSql & " ) "
      
         '  평가위원의 평가 항목에 대한 평가 점수의 등록/수정 날짜를 구한다.  "
         strSql = strSql & " , cte_value As ( "
         strSql = strSql & "    Select AssociationIDX, Max(RegDate) As RegDate, Max(ModDate) As ModDate "
         strSql = strSql & "          From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0}  ", Array(eval_table_idx))
         strSql = strSql & "       And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member) "
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
	Function getSqlEvalMember(eval_table_idx, eval_member_idx)
		Dim strSql, err_no

      If(eval_table_idx = "") Or (eval_member_idx = "") Then err_no = 1 End If 
				
		If( err_no <> 1 ) Then 	
         ' 평가위원을 구한다.  "
         strSql = strSql & " ;with cte_member As ( "
         strSql = strSql & "    Select  AdminMemberIDX, AdminName "
         strSql = strSql & "       From tblEvalMember "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And AdminMemberIDX = {1}", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & "       Group By  AdminMemberIDX, UserID, AdminName "
         strSql = strSql & " ) "
               
         strSql = strSql & " Select ROW_NUMBER() Over(Order By AdminMemberIDX) As Idx, AdminMemberIDX, AdminName  "
         strSql = strSql & "    From cte_member "
		End If  

		getSqlEvalMember = strSql 
	End Function

   '=================================================================================
	'  평가 정보 
   '  카테고리, sub카테고리, 평가항목 갯수, 평가 배점 총합을 구한다. 
	'=================================================================================  
	Function getSqlEvalInfo(eval_table_idx, eval_member_idx)
		Dim strSql, err_no

      If(eval_table_idx = "") Or (eval_member_idx = "") Then err_no = 1 End If 
				
		If( err_no <> 1 ) Then 	
         '  카테고리, sub카테고리, 평가항목 갯수를 구하기 위해 평가 지표를 구한다.  "
         strSql = strSql & " ; with cte_member As ( "
         strSql = strSql & "    Select *  "
         strSql = strSql & "       From tblEvalMember "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And AdminMemberIDX = {1}", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & " ) "
         
         '  평가위원에 할당된 아이템 정보를 구한다.  "
         strSql = strSql & " , cte_item As ( "
         strSql = strSql & "    Select *  "
         strSql = strSql & "       From tblEvalItem "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "    And EvalItemIDx In (Select EvalItemIDX From cte_member) "
         strSql = strSql & " )          "
      
         '  평가위원에 할당된 카테고리 Count를 구한다.  "
         strSql = strSql & " , cte_cate As ( "
         strSql = strSql & "    Select Count(EvalCateCD) As cnt_cate From ( "
         strSql = strSql & "       Select EvalCateCD From cte_item Group By EvalCateCD "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
       
         '  평가위원에 할당된 Sub 카테고리 Count를 구한다.  "
         strSql = strSql & " , cte_subcate As ( "
         strSql = strSql & "    Select Count(EvalSubCateCD) As cnt_subcate From ( "
         strSql = strSql & "       Select EvalSubCateCD From cte_item Group By EvalSubCateCD "
         strSql = strSql & "    ) As C  "
         strSql = strSql & " ) "
      
         '  가군을 기준으로 평가 위원에 할당된 총 점수를 얻는다.  "
         strSql = strSql & " , cte_point As ( "
         strSql = strSql & "    Select Sum(StandardPoint) As sum_point "
         strSql = strSql & "       From tblEvalItemTypeGroup "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} ", Array(eval_table_idx))
         strSql = strSql & "       And EvalGroupCD = 1 And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member) "
         strSql = strSql & " ) "
      
         '  카테고리, sub카테고리, 평가항목 갯수, 평가 배점 총합을 구한다.  "
         strSql = strSql & " Select (Select cnt_cate From cte_cate) As cnt_cate,  "
         strSql = strSql & "       (Select cnt_subcate From cte_subcate) As cnt_subcate,  "
         strSql = strSql & "       (Select Count(EvalItemIDX) As cnt_item From cte_item) As cnt_item,  "
         strSql = strSql & "    sum_point  "
         strSql = strSql & "    From cte_point "
		End If  

		getSqlEvalInfo = strSql 
	End Function

   '=================================================================================
	'  평가 현황 
   '  종목별 평가 현황을 보여준다. 
   '      평가 위원별 평가 완료 여부를 표시한다. 
   '      일반 평가위원: 평가위원 등록테이블에 등록된 항목 갯수 
   '      평가의견 갯수 : 평가 항목 갯수 
   '      총평 등록갯수 : 1개 - 최고 관리자 일 경우만 보여준다. 
	'=================================================================================  
	Function getSqlEvalState(eval_table_idx, eval_member_idx)
		Dim strSql, err_no

      If(eval_table_idx = "") Or (eval_member_idx = "") Then err_no = 1 End If 
				
		If( err_no <> 1 ) Then 	
         strSql = strSql & " Declare @cnt_item int, @cnt_desc int  "
      
         '  평가위원에 배정된 평가 항목의 갯수를 구한다.  "
         strSql = strSql & " Select  @cnt_item = Count(EvalItemTypeIDX)  "
         strSql = strSql & "          From tblEvalMember "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0}  And AdminMemberIDX = {1}", Array(eval_table_idx, eval_member_idx))
       
         '  일반 평가위원: 평가위원 등록테이블에 등록된 항목 갯수  "
         strSql = strSql & " ;with cte_member As ( "
         strSql = strSql & "    Select  EvalItemTypeIDX "
         strSql = strSql & "          From tblEvalMember "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0}  And AdminMemberIDX = {1}", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & " ) "
       
         '  종목별 정보를 구한다.  "
         strSql = strSql & " ,  cte_association As ( "
         strSql = strSql & "    Select AssociationIDX, AssociationNm, EvalGroupCD, EvalGroupNm, EvalText "
         strSql = strSql & "       From tblAssociation_sub  "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0}", Array(eval_table_idx))
         strSql = strSql & " ) "
      
         '  평가 의견 갯수를 구한다.  "
         strSql = strSql & " , cte_desc As ( "
         strSql = strSql & "    Select AssociationIDX, Count(EvalItemTypeIDX) As cnt_desc "
         strSql = strSql & "       From tblEvalDesc "
         strSql = strSql & sprintf("       Where DelKey = 0 And EvalTableIDX = {0} And AdminMemberIDX = {1}", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & "       And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member) "
         strSql = strSql & "       Group By AssociationIDX "
         strSql = strSql & " ) "
       
         '  평가 점수를 구한다.  "
         strSql = strSql & " , cte_value As ( "
         strSql = strSql & "    Select AssociationIDX, Count(EvalValueIDX) As cnt_value "
         strSql = strSql & "    From tblEvalValue "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0}  And AdminMemberIDX = {1}", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & "    Group By AssociationIDX "
         strSql = strSql & " ) "
     
         strSql = strSql & " Select ROW_NUMBER() Over(Partition By A.EvalGroupCD Order By A.AssociationNm) As Idx,  "
         strSql = strSql & "    A.EvalGroupCD,  A.EvalGroupNm, A.AssociationIDX, A.AssociationNm,  "
         strSql = strSql & "    Case When V.cnt_value Is Null Or V.cnt_value = 0 Then 0  "
         strSql = strSql & "       When V.cnt_value = @cnt_item Then 1  "
         strSql = strSql & "       Else 2 End As point_state,  "
         strSql = strSql & "    Case When D.cnt_desc Is Null Or D.cnt_desc = 0 Then 0  "
         strSql = strSql & "       When D.cnt_desc = @cnt_item Then 1  "
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
   Dim eval_table_idx, eval_member_idx
	Dim cnt_group, group_info, cnt_member, member_info, cnt_association, association_info
   Dim cnt_eval, eval_info, cnt_eval_state, eval_state_info

   Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))
   eval_member_idx		      = InjectionChk(JsonObj.get("eval_member_idx"))

	If(eval_table_idx = "") Or (eval_table_idx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
		'  ----------------------------------------------------
      '  평가군 가져오기
      strSql = getSqlEvalGroup()
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalGroup = {0} ", Array(strSql))  
      ' ' ' ' ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_group_cd, eval_group"
         aryKey = Split(strKeys, ",")

         group_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_group = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '  평가 협회 
      strSql = getSqlEvalAssociation(eval_table_idx, eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalAssociation = {0} ", Array(strSql))  
      ' ' ' ' ' Call utxLog(DEV_LOG1, strLog) 		

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, association_idx, association_name, eval_group_cd, eval_group, member_group_cd, member_group, reg_year, reg_date "
         aryKey = Split(strKeys, ",")

         association_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_association = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '   평가 위원 
      strSql = getSqlEvalMember(eval_table_idx, eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalMember = {0} ", Array(strSql))  
      ' ' ' ' ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "idx, eval_member_idx, eval_member"
         aryKey = Split(strKeys, ",")

         member_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_member = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '   평가 정보  - 카테고리, sub카테고리, 평가항목 갯수, 평가 배점 총합
      strSql = getSqlEvalInfo(eval_table_idx, eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalInfo = {0} ", Array(strSql))  
      ' Call utxLog(DEV_LOG1, strLog) 

      If(IsArray(RS_DATA)) Then
         strKeys = "cnt_cate, cnt_subcate, cnt_item, sum_point"
         aryKey = Split(strKeys, ",")

         eval_info = utx2DAryToJsonStr(aryKey, RS_DATA)
			cnt_eval = UBound(RS_DATA, 2) + 1
      End If

      '  ----------------------------------------------------
      '   평가 현황   - 종목별 평가 현황을 보여준다. 
      strSql = getSqlEvalState(eval_table_idx, eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlEvalState = {0} ", Array(strSql))  
      ' Call utxLog(DEV_LOG1, strLog) 

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

