<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	혁신평가 점수 등록 
	'  Date     : 	2021.09.08
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<% 	
	'=================================================================================
	' 	
	'================================================================================= 
%>

<%
' http://eval.sportsdiary.co.kr/api/ajax/mgr_input/reg_data/reg_point.asp 
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

   '=================================================================================
	'  eval_member_idx를 받아서 최고 관리자인지 유무를 판단
	'=================================================================================  
	Function getSqlCheckManager(eval_member_idx)
      Dim strSql, err_no
		
		If(eval_member_idx = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	        
         strSql = strSql & " Declare @Is_manager int  "
         
         ' 권한이 'A', 'B' 이면 최고 관리자 
         strSql = strSql & " Select @Is_manager = Case When Authority In ('A', 'B') Then 1 Else 0 End  "
         strSql = strSql & "       From tblAdminMember "
         strSql = strSql & sprintf("       Where DelYN = 'N' And AdminMemberIDX = {0} ", Array(eval_member_idx))

         strSql = strSql & " Select @Is_manager "
        
		End If  

		getSqlCheckManager = strSql 
	End Function

   '=================================================================================
	'  평가 위원 - 평가 점수 등록  - Valid Check 
	'=================================================================================  
	Function getSqlCheckValid(eval_table_idx, association_idx, eval_member_idx, eval_points, item_idxs)
      Dim strSql, err_no
		
		If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Or (eval_points = "") Or (item_idxs = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	        
         '평가위원 - 평가 항목 등록  "
         strSql = strSql & " Declare @valid_id int, @vaild_association int, @valid_items int , @valid_point int, @group_cd int  "
         strSql = strSql & " Declare @cnt_desc int , @cnt_idx int, @valid_data_cnt int  "
            
         ' /* --------------------------------------------------------------------------------------- "
         '    아이디 권한 체크 : 평가 위원일 경우만 vaild하다.  "
         '    아이디 Member Idx를 구한다.  "
         '  --------------------------------------------------------------------------------------- */    "
         strSql = strSql & " Select @valid_id = Case When AdminMemberIDX > 0 Then 1 Else 0 End "
         strSql = strSql & " From ( "
         strSql = strSql & "    Select IsNull(Max(AdminMemberIDX), 0) As AdminMemberIDX "
         strSql = strSql & "    From tblAdminMember "
         strSql = strSql & sprintf("    Where DelYN = 'N' And Authority In ('C') And AdminMemberIDX = {0} ", Array(eval_member_idx))
         strSql = strSql & " ) As C        "
     
         ' /* --------------------------------------------------------------------------------------- "
         '    협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가 "
         '  --------------------------------------------------------------------------------------- */ "
         strSql = strSql & " Select @vaild_association = Case When AssociationIDX Is Null Then 0 Else 1 End ,  "
         strSql = strSql & " @group_cd = EvalGroupCD "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
      
         ' /* --------------------------------------------------------------------------------------- "
         '    Client 측정 항목 검증 - 평가 점수과 평가 항목수가 일치 하는지 검사  "
         '    --------------------------------------------------------------------------------------- */    "
         '클라이언트로 부터 받아온 점수를 select문으로 바꾼다.  "
         strSql = strSql & " ;with cte_point As (	 "
         strSql = strSql & sprintf("    Select value As eval_point From string_split('{0}', ',') " ,Array(eval_points))
         strSql = strSql & " ) "
    
         '클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다.  "
         strSql = strSql & " , cte_client_idx As ( "
         strSql = strSql & sprintf("    Select Cast(value As int) As EvalItemTypeIDX From string_split('{0}', ',') " ,Array(item_idxs))
         strSql = strSql & " ) "
         
         strSql = strSql & " Select @cnt_desc = (Select Count(eval_point) From cte_point),  "
         strSql = strSql & "       @cnt_idx = (Select Count(EvalItemTypeIDX) From cte_client_idx) "

         strSql = strSql & " Select @valid_data_cnt = Case When @cnt_desc = @cnt_idx Then 1 Else 0 End       "
    
         ' /* --------------------------------------------------------------------------------------- "
         '    입력된 값이 평가 항목의 배점 최대값보다 큰지 비교 "
         '  --------------------------------------------------------------------------------------- */ "
         '서버에 설정된 EvalItemTypeIDX별 배점 포인트를 구한다.  "
         strSql = strSql & " ;with cte_item AS ( "
         strSql = strSql & "    Select T.EvalItemTypeIDX, G.StandardPoint "
         strSql = strSql & "    From tblEvalMember As T  "
         strSql = strSql & "    Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX "
         strSql = strSql & sprintf("    Where T.DelKey = 0 And T.EvalTableIDX = {0} And T.AdminMemberIDX = {1} ", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & sprintf("    And G.DelKey = 0 And G.EvalTableIDX = {0} And G.EvalGroupCD = @group_cd ", Array(eval_table_idx))
         strSql = strSql & " ) "
    
         '클라이언트로 부터 받아온 점수를 select문으로 바꾼다.  "
         strSql = strSql & " , cte_point As (	 "
         strSql = strSql & "    Select Row_Number() Over(Order By(Select 1)) As Idx, point From ( "
         strSql = strSql & sprintf("       Select Cast(value As decimal(7,2)) As point From string_split('{0}', ',') " ,Array(eval_points))
         strSql = strSql & "    ) As C "
         strSql = strSql & " ) "
   
         '클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다.  "
         strSql = strSql & " , cte_client_idx As ( "
         strSql = strSql & "    Select Row_Number() Over(Order By(Select 1)) As Idx, item_type_idx From ( "
         strSql = strSql & sprintf("       Select Cast(value As int) As item_type_idx From string_split('{0}', ',') " ,Array(item_idxs))
         strSql = strSql & "    ) As C "
         strSql = strSql & " ) "
    
         '클라이언트로 받아온 item_type_idx과 point를 merge한다.  "
         strSql = strSql & " , cte_client_item As ( "
         strSql = strSql & "    Select I.Idx, I.item_type_idx,  Cast(P.point As Float) As point "
         strSql = strSql & "       From cte_point As P  "
         strSql = strSql & "       Inner Join cte_client_idx As I On I.Idx = P.Idx  "
         strSql = strSql & " )  "
    
         'EvalItemTypeIDX(평가항목)마다 배점 최대값과 클라이언트 값을 비교하여 값의 적절성을 체크한다.  "
         '클라이언트 점수가 배점 최대값보다 크면 select한다.  "
         strSql = strSql & " , cte_over_point As ( "
         strSql = strSql & "    Select I.EvalItemTypeIDX, I.StandardPoint, C.point "
         strSql = strSql & "       From cte_item As I  "
         strSql = strSql & "       Inner Join cte_client_item As C On C.item_type_idx = I.EvalItemTypeIDX "
         strSql = strSql & "       And C.point > I.StandardPoint	 "
         strSql = strSql & " ) "
    
         '클라이언트 점수와 배점 최대값을 비교하여 값의 vaild를 체크한다.  "
         strSql = strSql & " Select @valid_point = Case When cnt_item > 0 Then 0 Else 1 End  "
         strSql = strSql & "    From ( "
         strSql = strSql & "       Select Count(EvalItemTypeIDX) As cnt_item From cte_over_point "
         strSql = strSql & "    ) As C  "
    
         ' /* --------------------------------------------------------------------------------------- "
         '    id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교  "
         '    --------------------------------------------------------------------------------------- */ "         
         strSql = strSql & " ;with cte_item As ( "
         strSql = strSql & "    Select EvalItemTypeIDX "
         strSql = strSql & "       From tblEvalMember "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AdminMemberIDX = {1} ", Array(eval_table_idx, eval_member_idx))
         strSql = strSql & " ) "
    
         '클라이언트로 부터 넘겨 받은 측정 항목 타입 list를 구한다.  "
         strSql = strSql & " , cte_client_item As ( "
         strSql = strSql & sprintf("       Select Cast(value As int) As EvalItemTypeIDX From string_split('{0}', ',') " ,Array(item_idxs))
         strSql = strSql & " ) "
    
         'id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구한후 union 한다.  "
         strSql = strSql & " , cte_diff As ( "
         strSql = strSql & "    Select Count(EvalItemTypeIDX) As cnt_item From ( "
         strSql = strSql & "       Select EvalItemTypeIDX From cte_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_client_item) "
         strSql = strSql & "       Union  "
         strSql = strSql & "       Select EvalItemTypeIDX From cte_client_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_item) "
         strSql = strSql & "    ) As C "
         strSql = strSql & " ) "
    
         'id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교  "
         'cte_diff는 차집합을 이용하여 두 값이 같은지를 찾는다.  "
         'id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구하고,  "
         '그 합이 공집합이면 같고 아니면 틀리다.  "
         strSql = strSql & " Select @valid_items = Case When cnt_item = 0 Then 1 Else 0 End From cte_diff "
   
         '0: 정상 , 1: 권한 없음, 2: 미등록 협회 , 3:id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다.  "
         '4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. , 5: 클라이언트에서 받은 포인트 값이 배점 최대값보다 크다.  "
     
         '정상 등록  "
         strSql = strSql & " If(@valid_id = 1 And @vaild_association = 1 And @valid_items = 1 And @valid_point = 1 And @valid_data_cnt = 1) 	  "
         strSql = strSql & "    Select 0 As err_code "
         strSql = strSql & " Else  "
     
         ' 권한 에러  "
         strSql = strSql & "       If(@valid_id = 0)					 "
         strSql = strSql & "          Select 1 As err_code "
      
         ' 미등록 협회 에러  "
         strSql = strSql & "       Else If(@vaild_association = 0)		 "
         strSql = strSql & "          Select 2 As err_code "
      
         ' id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다.  "
         strSql = strSql & "    Else If(@valid_items = 0)		 "
         strSql = strSql & "          Select 3 As err_code "
      
         ' 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다.  "
         strSql = strSql & "    Else If(@valid_data_cnt = 0)		 "
         strSql = strSql & "          Select 4 As err_code "
       
         ' 클라이언트에서 받은 포인트 값이 배점 최대값보다 크다.  "
         strSql = strSql & "    Else If(@valid_point = 0)		 "
         strSql = strSql & "          Select 5 As err_code "
		End If  

		getSqlCheckValid = strSql 
	End Function

   '=================================================================================
	'  평가 위원 - 최고관리자 이상 - 평가 점수 등록  - Valid Check 
	'=================================================================================  
	Function getSqlCheckValidMgr(eval_table_idx, association_idx, eval_member_idx, eval_points, item_idxs)
      Dim strSql, err_no
		
		If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Or (eval_points = "") Or (item_idxs = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	        
         ' 최고관리자 - 평가 항목 등록  "
         strSql = strSql & " Declare @valid_id int, @vaild_association int, @valid_items int , @valid_point int, @group_cd int  "
         strSql = strSql & " Declare @cnt_desc int , @cnt_idx int, @valid_data_cnt int  "
    
         ' /* --------------------------------------------------------------------------------------- "
         '    아이디 권한 체크 : 최고관리자 이상일 경우만 vaild하다.  "
         '  --------------------------------------------------------------------------------------- */    "
         strSql = strSql & " Select @valid_id = Case When AdminMemberIDX > 0 Then 1 Else 0 End "
         strSql = strSql & " From ( "
         strSql = strSql & "    Select IsNull(Max(AdminMemberIDX), 0) As AdminMemberIDX "
         strSql = strSql & "    From tblAdminMember "
         strSql = strSql & sprintf("    Where DelYN = 'N' And Authority In ('A', 'B') And AdminMemberIDX = {0} ", Array(eval_member_idx))
         strSql = strSql & " ) As C          "
    
         ' /* --------------------------------------------------------------------------------------- "
         '    협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가 "
         '     --------------------------------------------------------------------------------------- */ "
         strSql = strSql & " Select @vaild_association = Case When AssociationIDX Is Null Then 0 Else 1 End ,  "
         strSql = strSql & " @group_cd = EvalGroupCD "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
     
         ' /* --------------------------------------------------------------------------------------- "
         '    Client 측정 항목 검증 - 평가 점수과 평가 항목수가 일치 하는지 검사  "
         '    --------------------------------------------------------------------------------------- */    "
         '클라이언트로 부터 받아온 점수를 select문으로 바꾼다.  "
         strSql = strSql & " ;with cte_point As (	 "
         strSql = strSql & sprintf("    Select value As eval_point From string_split('{0}', ',') " ,Array(eval_points))
         strSql = strSql & " ) "
    
         '클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다.  "
         strSql = strSql & " , cte_client_idx As ( "
         strSql = strSql & sprintf("    Select Cast(value As int) As EvalItemTypeIDX From string_split('{0}', ',') " ,Array(item_idxs))
         strSql = strSql & " ) "
         
         strSql = strSql & " Select @cnt_desc = (Select Count(eval_point) From cte_point),  "
         strSql = strSql & "       @cnt_idx = (Select Count(EvalItemTypeIDX) From cte_client_idx) "

         strSql = strSql & " Select @valid_data_cnt = Case When @cnt_desc = @cnt_idx Then 1 Else 0 End       "
      
         ' /* --------------------------------------------------------------------------------------- "
         '    입력된 값이 평가 항목의 배점 최대값보다 큰지 비교 "
         '    --------------------------------------------------------------------------------------- */ "
         ' 서버에 설정된 EvalItemTypeIDX별 배점 포인트를 구한다.  "
         strSql = strSql & " ;with cte_item AS ( "
         strSql = strSql & "    Select T.EvalItemTypeIDX, T.EvalTypeCD, G.StandardPoint "
         strSql = strSql & "    From tblEvalItemType As T  "
         strSql = strSql & "    Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX "
         strSql = strSql & sprintf("    Where T.DelKey = 0 And T.EvalTableIDX = {0} And T.EvalTypeCD In (2, 100) ", Array(eval_table_idx))
         strSql = strSql & sprintf("    And G.DelKey = 0 And G.EvalTableIDX = {0} And G.EvalGroupCD = @group_cd ", Array(eval_table_idx))
         strSql = strSql & " ) "
      
         '클라이언트로 부터 받아온 점수를 select문으로 바꾼다.  "
         strSql = strSql & " , cte_point As (	 "
         strSql = strSql & "    Select Row_Number() Over(Order By(Select 1)) As Idx, point From ( "
         strSql = strSql & sprintf("       Select Cast(value As decimal(7,2)) As point From string_split('{0}', ',') " ,Array(eval_points))
         strSql = strSql & "    ) As C "
         strSql = strSql & " ) "
   
         '클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다.  "
         strSql = strSql & " , cte_client_idx As ( "
         strSql = strSql & "    Select Row_Number() Over(Order By(Select 1)) As Idx, item_type_idx From ( "
         strSql = strSql & sprintf("       Select Cast(value As int) As item_type_idx From string_split('{0}', ',') " ,Array(item_idxs))
         strSql = strSql & "    ) As C "
         strSql = strSql & " ) "
      
         ' 클라이언트로 받아온 item_type_idx과 point를 merge한다.  "
         strSql = strSql & " , cte_client_item As ( "
         strSql = strSql & "    Select I.Idx, I.item_type_idx,  P.point  "
         strSql = strSql & "       From cte_point As P  "
         strSql = strSql & "       Inner Join cte_client_idx As I On I.Idx = P.Idx  "
         strSql = strSql & " )  "
       
         ' EvalItemTypeIDX(평가항목)마다 배점 최대값과 클라이언트 값을 비교하여 값의 적절성을 체크한다.  "
         ' 클라이언트 점수가 배점 최대값보다 크면 select한다.  "
         strSql = strSql & " , cte_over_point As ( "
         strSql = strSql & "    Select I.EvalItemTypeIDX, I.StandardPoint, C.point "
         strSql = strSql & "       From cte_item As I  "
         strSql = strSql & "       Inner Join cte_client_item As C On C.item_type_idx = I.EvalItemTypeIDX "
         strSql = strSql & "       And C.point > I.StandardPoint	"
         strSql = strSql & "       Where I.EvalTypeCD < 100 "
         strSql = strSql & " ) "
       
         ' 클라이언트 점수와 배점 최대값을 비교하여 값의 vaild를 체크한다.  "
         strSql = strSql & " Select @valid_point = Case When cnt_item > 0 Then 0 Else 1 End  "
         strSql = strSql & "    From ( "
         strSql = strSql & "       Select Count(EvalItemTypeIDX) As cnt_item From cte_over_point "
         strSql = strSql & "    ) As C           "
       
         ' /* --------------------------------------------------------------------------------------- "
         '       id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교  "
         '    --------------------------------------------------------------------------------------- */ "
         ' 최고 관리자일 경우는 측정타입테이블에서 정량, 감점 평가 타입을 평가한다.  "
         strSql = strSql & " ;with cte_item As ( "
         strSql = strSql & "    Select EvalItemTypeIDX "
         strSql = strSql & "       From tblEvalItemType "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And EvalTypeCD In (2, 100) ", Array(eval_table_idx))
         strSql = strSql & " ) "
       
         '클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다.  "
         strSql = strSql & " , cte_client_item As ( "
         strSql = strSql & sprintf("       Select Cast(value As int) As EvalItemTypeIDX From string_split('{0}', ',') " ,Array(item_idxs))
         strSql = strSql & " ) "
       
         ' id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구한후 union 한다.  "
         strSql = strSql & " , cte_diff As ( "
         strSql = strSql & "    Select Count(EvalItemTypeIDX) As cnt_item From ( "
         strSql = strSql & "       Select EvalItemTypeIDX From cte_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_client_item) "
         strSql = strSql & "       Union  "
         strSql = strSql & "       Select EvalItemTypeIDX From cte_client_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_item) "
         strSql = strSql & "    ) As C "
         strSql = strSql & " ) "
       
         ' id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교  "
         ' cte_diff는 차집합을 이용하여 두 값이 같은지를 찾는다.  "
         ' id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구하고,  "
         ' 그 합이 공집합이면 같고 아니면 틀리다.  "
         strSql = strSql & " Select @valid_items = Case When cnt_item = 0 Then 1 Else 0 End From cte_diff "
       
         ' 0: 정상 , 1: 권한 없음, 2: 미등록 협회 , 3:id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다.  "
         ' 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. , 5: 클라이언트에서 받은 포인트 값이 배점 최대값보다 크다.  "
      
         ' 정상 등록  "
         strSql = strSql & " If(@valid_id = 1 And @vaild_association = 1 And @valid_items = 1 And @valid_point = 1 And @valid_data_cnt = 1) 	  "
         strSql = strSql & "    Select 0 As err_code "
         strSql = strSql & " Else  "
       
         ' 권한 에러  "
         strSql = strSql & "       If(@valid_id = 0)					 "
         strSql = strSql & "          Select 1 As err_code "
       
         ' 미등록 협회 에러  "
         strSql = strSql & "       Else If(@vaild_association = 0)		 "
         strSql = strSql & "          Select 2 As err_code "
        
         ' id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다.  "
         strSql = strSql & "    Else If(@valid_items = 0)		 "
         strSql = strSql & "          Select 3 As err_code "
       
         ' 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다.  "
         strSql = strSql & "    Else If(@valid_data_cnt = 0)		 "
         strSql = strSql & "          Select 4 As err_code "
       
         ' 클라이언트에서 받은 포인트 값이 배점 최대값보다 크다.  "
         strSql = strSql & "    Else If(@valid_point = 0)		 "
         strSql = strSql & "          Select 5 As err_code "
		End If  

		getSqlCheckValidMgr = strSql 
	End Function

   '=================================================================================
   '  평가 점수 등록 - Insert
   '=================================================================================  
   Function getSqlInsertPoint(eval_table_idx, association_idx, eval_member_idx, eval_points, item_idxs)
      Dim strSql, err_no
      
      If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Or (eval_points = "") Or (item_idxs = "") Then err_no = 1 End If 
      
      If( err_no <> 1 ) Then 	
         '평가위원 - 평가 항목 등록  "
         strSql = strSql & " Declare @group_cd int          "
         '  /* --------------------------------------------------------------------------------------- "
         '     협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가 "
         '      --------------------------------------------------------------------------------------- */ "
         strSql = strSql & " Select @group_cd = EvalGroupCD "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
         '  /* --------------------------------------------------------------------------------------- "
         '     입력된 값을 Insert한다.  "
         '     --------------------------------------------------------------------------------------- */ "
         
         '클라이언트로 부터 받아온 점수를 select문으로 바꾼다.  "
         strSql = strSql & " ;with cte_point As (	 "
         strSql = strSql & "    Select Row_Number() Over(Order By(Select 1)) As Idx, point * 100 As Point From ( "
         strSql = strSql & sprintf("       Select Cast(value As decimal(7,2)) As point From string_split('{0}', ',') " ,Array(eval_points))
         strSql = strSql & "    ) As C "
         strSql = strSql & " ) "
       
         '클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다.  "
         strSql = strSql & " , cte_client_idx As ( "
         strSql = strSql & "    Select Row_Number() Over(Order By(Select 1)) As Idx, item_type_idx From ( "
         strSql = strSql & sprintf("       Select Cast(value As int) As item_type_idx From string_split('{0}', ',') " ,Array(item_idxs))
         strSql = strSql & "    ) As C "
         strSql = strSql & " ) "
        
         '클라이언트로 받아온 item_type_idx과 point를 merge한다.  "
         strSql = strSql & " , cte_client_item As ( "
         strSql = strSql & "    Select I.Idx, I.item_type_idx,  Cast(P.point As Float) As point "
         strSql = strSql & "       From cte_point As P  "
         strSql = strSql & "       Inner Join cte_client_idx As I On I.Idx = P.Idx  "
         strSql = strSql & " ) "
     
         '평가위원으로 추가된 값이 있는지 확인한다.  "
         strSql = strSql & " , cte_diff_item As ( "
         strSql = strSql & "    Select *  "
         strSql = strSql & "       From cte_client_item "
         strSql = strSql & "       Where item_type_idx Not In (Select EvalItemTypeIDX From tblEvalValue  "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} And AdminMemberIDX = {2}  ) ", Array(eval_table_idx, association_idx, eval_member_idx))
         strSql = strSql & " ) "

         strSql = strSql & " Insert Into tblEvalValue (EvalTableIDX, AssociationIDX, EvalGroupCD, EvalCateCD, EvalItemCD, EvalSubCateCD, EvalItemIDX,  "
         strSql = strSql & "    EvalItemTypeIDX, AdminMemberIDX, EvalTypeCD, EvalTypeNm, StandardPoint, Point, PointCalc ) "
         strSql = strSql & " Select T.EvalTableIDX, A.AssociationIDX, A.EvalGroupCD, T.EvalCateCD, T.EvalItemCD, T.EvalSubCateCD, T.EvalItemIDX,  "
         strSql = strSql & sprintf(" T.EvalItemTypeIDX, {0} As AdminMemberIDX, T.EvalTypeCD, T.EvalTypeNm, StandardPoint, I.Point,  ", Array(eval_member_idx))
         strSql = strSql & " I.Point As PointCalc "
         strSql = strSql & " From tblEvalItemType As T "
         strSql = strSql & " Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX "
         strSql = strSql & sprintf(" Inner Join tblAssociation_sub As A On A.AssociationIDX = {0} And A.DelKey = 0 And A.EvalTableIDX = {1}  ", Array(association_idx, eval_table_idx))
         strSql = strSql & " Inner Join cte_diff_item AS I On I.item_type_idx = T.EvalItemTypeIDX "
         strSql = strSql & sprintf(" Where G.DelKey = 0 And G.EvalTableIDX = {0} And G.EvalGroupCD = @group_cd ", Array(eval_table_idx))
		End If  

		getSqlInsertPoint = strSql 
	End Function

   '=================================================================================
	'  평가 점수 등록 - Update
	'=================================================================================  
	Function getSqlModPoint(eval_table_idx, association_idx, eval_member_idx, eval_points, item_idxs)
      Dim strSql, err_no
		
		If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Or (eval_points = "") Or (item_idxs = "") Then err_no = 1 End If 
		
		If( err_no <> 1 ) Then 	
      '평가위원 - 평가 항목 등록  "
      strSql = strSql & " Declare @group_cd int          "
         '  /* --------------------------------------------------------------------------------------- "
         '     협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가 "
         '      --------------------------------------------------------------------------------------- */ "
         strSql = strSql & " Select @group_cd = EvalGroupCD "
         strSql = strSql & "    From tblAssociation_sub "
         strSql = strSql & sprintf("    Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} ", Array(eval_table_idx, association_idx))
         '  /* --------------------------------------------------------------------------------------- "
         '     입력된 값을 Insert한다.  "
         '     --------------------------------------------------------------------------------------- */ "
         
         '클라이언트로 부터 받아온 점수를 select문으로 바꾼다.  "
         strSql = strSql & " ;with cte_point As (	 "
         strSql = strSql & "    Select Row_Number() Over(Order By(Select 1)) As Idx, point * 100 As Point From ( "
         strSql = strSql & sprintf("       Select Cast(value As decimal(7,2)) As point From string_split('{0}', ',') " ,Array(eval_points))
         strSql = strSql & "    ) As C "
         strSql = strSql & " ) "
       
         '클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다.  "
         strSql = strSql & " , cte_client_idx As ( "
         strSql = strSql & "    Select Row_Number() Over(Order By(Select 1)) As Idx, item_type_idx From ( "
         strSql = strSql & sprintf("       Select Cast(value As int) As item_type_idx From string_split('{0}', ',') ",Array(item_idxs))
         strSql = strSql & "    ) As C "
         strSql = strSql & " ) "
        
         '클라이언트로 받아온 item_type_idx과 point를 merge한다.  "
         strSql = strSql & " , cte_client_item As ( "
         strSql = strSql & "    Select I.Idx, I.item_type_idx,  Cast(P.point As Float) As point "
         strSql = strSql & "       From cte_point As P  "
         strSql = strSql & "       Inner Join cte_client_idx As I On I.Idx = P.Idx  "
         strSql = strSql & " ) "
     
         '평가위원으로 추가된 값이 있는지 확인한다. 
         strSql = strSql & " , cte_same_item As ( "
         strSql = strSql & "    Select *  "
         strSql = strSql & "       From cte_client_item "
         strSql = strSql & "       Where item_type_idx In (Select EvalItemTypeIDX From tblEvalValue  "
         strSql = strSql & sprintf("          Where DelKey = 0 And EvalTableIDX = {0} And AssociationIDX = {1} And AdminMemberIDX = {2}  ) ", Array(eval_table_idx, association_idx, eval_member_idx))
         strSql = strSql & " ) "

         strSql = strSql & " Update tblEvalValue Set ModDate = GetDate(), Point = I.point, PointCalc = I.Point"
         strSql = strSql & "    From tblEvalValue As T "
         strSql = strSql & "    Inner Join cte_same_item As I On T.EvalItemTypeIDX = I.item_type_idx "
         strSql = strSql & sprintf("    Where T.DelKey = 0 And T.EvalTableIDX = {0} And T.AdminMemberIDX = {1} And T.AssociationIDX = {2} ", Array(eval_table_idx, eval_member_idx, association_idx))
		End If  

		getSqlModPoint = strSql 
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
   Dim eval_table_idx, association_idx, eval_member_idx, eval_points, item_idxs, is_mgr, rsp_err
	Dim cnt_list, list_info

   Set JsonObj 		      = JSON.Parse(join(array(JsonData)))   
	eval_table_idx		      = InjectionChk(JsonObj.get("eval_table_idx"))
   association_idx		   = InjectionChk(JsonObj.get("association_idx"))
   eval_member_idx		   = InjectionChk(JsonObj.get("eval_member_idx"))
   eval_points      		   = InjectionChk(JsonObj.get("eval_points"))
   item_idxs      		   = InjectionChk(JsonObj.get("item_idxs"))

	If(eval_table_idx = "") Or (association_idx = "") Or (eval_member_idx = "") Or (eval_points = "") Or (item_idxs = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 	
      If(eval_member_idx = 0) Then eval_member_idx = 2 End If 

      '  ----------------------------------------------------
      '  eval_member_idx를 받아서 최고 관리자인지 유무를 판단
      strSql = getSqlCheckManager(eval_member_idx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlCheckManager = {0} ", Array(strSql))
       ' ' ' ' Call utxLog(DEV_LOG1, strLog)      

      If(IsArray(RS_DATA)) Then     
         is_mgr = RS_DATA(0,0)
      End If

      '  ----------------------------------------------------
      ' 최고 관리자 이면 최고 관리자로 체크한다. 
      ' 0: 정상 , 1: 권한 없음, 2: 미등록 협회 , 3:id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다. 
      If(is_mgr = "1") Then 
         '  ----------------------------------------------------
         '  최고관리자 이상 - 평가 점수 등록  - Valid Check  
         strSql = getSqlCheckValidMgr(eval_table_idx, association_idx, eval_member_idx, eval_points, item_idxs)
         RS_DATA = ExecuteReturn(strSql, DB)
         
         strLog = sprintf("getSqlCheckValidMgr = {0} ", Array(strSql))
         ' ' ' ' Call utxLog(DEV_LOG1, strLog)      

         If(IsArray(RS_DATA)) Then     
            rsp_err = RS_DATA(0,0)
         End If
      Else 
         '  ----------------------------------------------------
         '  평가 점수 등록  - Valid Check   
         strSql = getSqlCheckValid(eval_table_idx, association_idx, eval_member_idx, eval_points, item_idxs)
         RS_DATA = ExecuteReturn(strSql, DB)
         
         strLog = sprintf("getSqlCheckValid = {0} ", Array(strSql))
         ' ' ' ' Call utxLog(DEV_LOG1, strLog)      

         If(IsArray(RS_DATA)) Then     
            rsp_err = RS_DATA(0,0)
         End If
      End If 


      If(rsp_err = "0") Then 
         '  ----------------------------------------------------
         '  평가 점수 등록 - Insert
         strSql = getSqlInsertPoint(eval_table_idx, association_idx, eval_member_idx, eval_points, item_idxs)
         Call ExecuteUpdate(strSql, DB)
         strLog = sprintf("getSqlInsertPoint = {0} ", Array(strSql))
         ' Call utxLog(DEV_LOG1, strLog)     

         '  ----------------------------------------------------
         '  평가 점수 등록 - Update
         strSql = getSqlModPoint(eval_table_idx, association_idx, eval_member_idx, eval_points, item_idxs)
         Call ExecuteUpdate(strSql, DB)
         strLog = sprintf("getSqlModPoint = {0} ", Array(strSql))
         ' Call utxLog(DEV_LOG1, strLog)     

		   JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("true", "SUCCESS"))
      ElseIf(rsp_err = "1") Then 
         JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", E_DESC_NOT_AUTHIRITY))	' 권한 없음 
      ElseIf(rsp_err = "2") Then 
         JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", E_DESC_NOT_ASSOCIATION))	' 미등록 협회 
      ElseIf(rsp_err = "3") Then 
         JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", E_DESC_MISSMATCH_DATA))	' id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다.
      ElseIf(rsp_err = "4") Then 
         JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", E_DESC_MISSMATCH_DATA_CNT))	' client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. 
      ElseIf(rsp_err = "5") Then 
         JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", E_POINT_OVER_MAXPOINT))	' 평가 점수가 최대 평가 점수보다 높다.
      End If 

	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

