

<%
	'=================================================================================
	'  Purpose  : 	쿼리 테스트 데이터 
	'  Author   : 												By Aramdry
	'=================================================================================

%>

<%
   '=================================================================================
   '  Purpose  : 	평가 입력 
   '=================================================================================
  
%>

<%
   '=================================================================================
   '  Purpose  : 	총평등록  - vaild check 
   '=================================================================================    
   Declare @valid_id int, @vaild_association int

   -- 아이디 권한 체크 : 최고 관리자 이상만 등록 가능하다. 
   Select @valid_id = IsNull(Max(AdminMemberIDX), 0)
      From tblAdminMember
      Where DelYN = 'N' And Authority In ('A', 'B') And AdminMemberIDX = 2

   -- 협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가
   Select @vaild_association = IsNull(Max(AssociationIDX), 0)
      From tblAssociation_sub
      Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1
            
   If(@valid_id > 0 And @vaild_association > 0) 
      Begin          
         -- 정상 등록 
         Select 0 As err_code
      End 
   Else
      -- 권한 에러 
      If(@valid_id = 0)					
         Select 1 As err_code
      -- 미등록 협회 에러 
      Else If(@vaild_association = 0)		
         Select 2 As err_code

   '=================================================================================
   '  Purpose  : 	총평등록  
   '=================================================================================   
   Update tblAssociation_sub Set EvalText = '참 훌륭하죠' 
               Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1

   '=================================================================================
   '  Purpose  : 	eval_member_idx를 받아서 최고 관리자인지 유무를 판단
   '=================================================================================   
   Declare @Is_manager int 

   Select @Is_manager = Case When Authority In ('A', 'B') Then 1 Else 0 End 
         From tblAdminMember
         Where DelYN = 'N' And AdminMemberIDX = 3

   Select @Is_manager

   '=================================================================================
   '  Purpose  : 	평가 위원 - 평가 의견 등록  - Valid Check 
   '=================================================================================    
   -- 평가 위원 - 평가 항목 등록 
   Declare @valid_id int, @vaild_association int, @valid_items int , @valid_data_cnt int 
   Declare @cnt_desc int , @cnt_idx int
   Declare @eval_desc varchar(max), @item_idx varchar(max)
   Set @eval_desc = '신난다.1, 신난다.2, 신난다.3, 신난다.4'
   Set @item_idx = '25, 26, 28'

   /* ---------------------------------------------------------------------------------------
		아이디 권한 체크 : 평가 위원일 경우만 vaild하다. 
     --------------------------------------------------------------------------------------- */   
   Select @valid_id = Case When AdminMemberIDX > 0 Then 1 Else 0 End
	From (
	   Select IsNull(Max(AdminMemberIDX), 0) As AdminMemberIDX
		  From tblAdminMember
		  Where DelYN = 'N' And Authority In ('C') And AdminMemberIDX = 3
	) As C

   
   /* ---------------------------------------------------------------------------------------
		협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가
     --------------------------------------------------------------------------------------- */   
   Select @vaild_association = Case When AssociationIDX Is Null Then 0 Else 1 End 
      From tblAssociation_sub
      Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1

	/* ---------------------------------------------------------------------------------------
		Client 측정 항목 검증 - 평가 의견과 평가 항목수가 일치 하는지 검사 
	   --------------------------------------------------------------------------------------- */   
	    -- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	;with cte_desc As (	
		Select value As eval_desc From string_split(@eval_desc, '|')
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Cast(value As int) As EvalItemTypeIDX From string_split(@item_idx, ',')
	)

	Select @cnt_desc = (Select Count(eval_desc) From cte_desc), 
	       @cnt_idx = (Select Count(EvalItemTypeIDX) From cte_client_idx)
		   	
	Select @valid_data_cnt = Case When @cnt_desc = @cnt_idx Then 1 Else 0 End
		

	/* ---------------------------------------------------------------------------------------
		Client 측정 항목 검증 
	   --------------------------------------------------------------------------------------- */   
	    -- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	;with cte_desc As (	
		Select Row_Number() Over(Order By(Select 1)) As Idx, eval_desc From (
			Select value As eval_desc From string_split(@eval_desc, '|')
		) As C
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Row_Number() Over(Order By(Select 1)) As Idx, EvalItemTypeIDX From (
			Select Cast(value As int) As EvalItemTypeIDX From string_split(@item_idx, ',')
		) As C
	)

	-- 클라이언트로 받아온 item_type_idx과 point를 merge한다. 
	, cte_client_item As (
		Select I.Idx, I.EvalItemTypeIDX,  eval_desc
			From cte_desc As P 
			Inner Join cte_client_idx As I On I.Idx = P.Idx 
	) 

   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교 
   -- id와 mapping되는 측정 항목을 구한다. 
   , cte_item As (
      Select EvalItemTypeIDX
         From tblEvalMember
      Where DelKey = 0 And EvalTableIDX = 2 And AdminMemberIDX = 3
   )
   
   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구한후 union 한다. 
   , cte_diff As (
      Select Count(EvalItemTypeIDX) As cnt_item From (
         Select EvalItemTypeIDX From cte_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_client_item)
         Union 
         Select EvalItemTypeIDX From cte_client_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_item)
      ) As C
   )

   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교 
   -- cte_diff는 차집합을 이용하여 두 값이 같은지를 찾는다. 
   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구하고, 
   -- 그 합이 공집합이면 같고 아니면 틀리다. 
   Select @valid_items = Case When cnt_item = 0 Then 1 Else 0 End From cte_diff

   -- 0: 정상 , 1: 권한 없음, 2: 미등록 협회 , 3:id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다. 
   -- 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. 

   -- 정상 등록 
   If(@valid_id = 1 And @vaild_association = 1 And @valid_items = 1 And @valid_data_cnt = 1) 	 
      Select 0 As err_code
   Else 
      -- 권한 에러 
         If(@valid_id = 0)					
            Select 1 As err_code
         -- 미등록 협회 에러 
         Else If(@vaild_association = 0)		
            Select 2 As err_code
      -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다. 
      Else If(@valid_items = 0)		
            Select 3 As err_code
      -- 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. 
	   Else If(@valid_data_cnt = 0)		
            Select 4 As err_code

   '=================================================================================
   '  Purpose  : 	최고관리자 이상 - 평가 의견 등록  - Valid Check 
   '=================================================================================      
   --  최고관리자 이상 - 평가 항목 등록 
   Declare @valid_id int, @vaild_association int, @valid_items int , @valid_data_cnt int 
   Declare @cnt_desc int , @cnt_idx int
   Declare @eval_desc varchar(max), @item_idx varchar(max)
   Set @eval_desc = '신난다.1, 신난다.2, 신난다.3, 신난다.4'
   Set @item_idx = '25, 26, 28'

  /* ---------------------------------------------------------------------------------------
		아이디 권한 체크 : 최고관리자 이상일 경우만 vaild하다. 
     --------------------------------------------------------------------------------------- */   
   Select @valid_id = Case When AdminMemberIDX > 0 Then 1 Else 0 End
	From (
	   Select IsNull(Max(AdminMemberIDX), 0) As AdminMemberIDX
		  From tblAdminMember
		  Where DelYN = 'N' And Authority In ('A', 'B') And AdminMemberIDX = 2
	) As C

   
   /* ---------------------------------------------------------------------------------------
		협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가
     --------------------------------------------------------------------------------------- */   
   Select @vaild_association = Case When AssociationIDX Is Null Then 0 Else 1 End 
      From tblAssociation_sub
      Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1

	/* ---------------------------------------------------------------------------------------
		Client 측정 항목 검증 - 평가 의견과 평가 항목수가 일치 하는지 검사 
	   --------------------------------------------------------------------------------------- */   
	    -- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	;with cte_desc As (	
		Select value As eval_desc From string_split(@eval_desc, '|')
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Cast(value As int) As EvalItemTypeIDX From string_split(@item_idx, ',')
	)

	Select @cnt_desc = (Select Count(eval_desc) From cte_desc), 
	       @cnt_idx = (Select Count(EvalItemTypeIDX) From cte_client_idx)
		   	
	Select @valid_data_cnt = Case When @cnt_desc = @cnt_idx Then 1 Else 0 End
		

	/* ---------------------------------------------------------------------------------------
		Client 측정 항목 검증 
	   --------------------------------------------------------------------------------------- */   
	    -- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	;with cte_desc As (	
		Select Row_Number() Over(Order By(Select 1)) As Idx, eval_desc From (
			Select value As eval_desc From string_split(@eval_desc, '|')
		) As C
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Row_Number() Over(Order By(Select 1)) As Idx, EvalItemTypeIDX From (
			Select Cast(value As int) As EvalItemTypeIDX From string_split(@item_idx, ',')
		) As C
	)

	-- 클라이언트로 받아온 item_type_idx과 point를 merge한다. 
	, cte_client_item As (
		Select I.Idx, I.EvalItemTypeIDX,  eval_desc
			From cte_desc As P 
			Inner Join cte_client_idx As I On I.Idx = P.Idx 
	) 

   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교 
   -- id와 mapping되는 측정 항목을 구한다. 
   , cte_item As (
      Select EvalItemTypeIDX
         From tblEvalItemType
      Where DelKey = 0 And EvalTableIDX = 2 And EvalTypeCD In (2, 100)
   )
   
   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구한후 union 한다. 
   , cte_diff As (
      Select Count(EvalItemTypeIDX) As cnt_item From (
         Select EvalItemTypeIDX From cte_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_client_item)
         Union 
         Select EvalItemTypeIDX From cte_client_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_item)
      ) As C
   )

   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교 
   -- cte_diff는 차집합을 이용하여 두 값이 같은지를 찾는다. 
   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구하고, 
   -- 그 합이 공집합이면 같고 아니면 틀리다. 
   Select @valid_items = Case When cnt_item = 0 Then 1 Else 0 End From cte_diff

   -- 0: 정상 , 1: 권한 없음, 2: 미등록 협회 , 3:id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다. 
   -- 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. 

   -- 정상 등록 
   If(@valid_id = 1 And @vaild_association = 1 And @valid_items = 1 And @valid_data_cnt = 1) 	 
      Select 0 As err_code
   Else 
      -- 권한 에러 
         If(@valid_id = 0)					
            Select 1 As err_code
         -- 미등록 협회 에러 
         Else If(@vaild_association = 0)		
            Select 2 As err_code
      -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다. 
      Else If(@valid_items = 0)		
            Select 3 As err_code
      -- 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. 
	   Else If(@valid_data_cnt = 0)		
            Select 4 As err_code
   '=================================================================================
   '  Purpose  : 	평가 의견 등록 - Insert
   '================================================================================= 
   Declare @eval_desc varchar(max), @item_idx varchar(max)
   Set @eval_desc = '신난다.1, 신난다.2, 신난다.3'
   Set @item_idx = '25, 26, 28'

   /* ---------------------------------------------------------------------------------------
		입력된 평가 항목을 추가한다 .
     --------------------------------------------------------------------------------------- */
	 
	 -- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	;with cte_desc As (	
		Select Row_Number() Over(Order By(Select 1)) As Idx, eval_desc From (
			Select value As eval_desc From string_split(@eval_desc, '|')
		) As C
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Row_Number() Over(Order By(Select 1)) As Idx, item_type_idx From (
			Select Cast(value As int) As item_type_idx From string_split(@item_idx, ',')
		) As C
	)

	-- 클라이언트로 받아온 item_type_idx과 point를 merge한다. 
	, cte_client_item As (
		Select I.Idx, I.item_type_idx,  eval_desc
			From cte_desc As P 
			Inner Join cte_client_idx As I On I.Idx = P.Idx 
	) 

	, cte_diff_item As (
		Select * 
			From cte_client_item
			Where item_type_idx Not In (Select EvalItemTypeIDX From tblEvalDesc 
				Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1 )
	)

	Insert Into tblEvalDesc(EvalTableIDX, AssociationIDX, EvalGroupCD, EvalItemIDX, EvalItemTypeIDX, EvalTypeCD, EvalDesc )
	Select T.EvalTableIDX, A.AssociationIDX, A.EvalGroupCD, T.EvalItemIDX, T.EvalItemTypeIDX, T.EvalTypeCD, I.eval_desc  
               From tblEvalItemType As T
               Inner Join tblAssociation_sub As A On A.AssociationIDX = 1 And A.DelKey = 0 And A.EvalTableIDX = 2 
			   Inner Join cte_diff_item AS I On I.item_type_idx = T.EvalItemTypeIDX
            where T.DelKey = 0 And T.EvalTableIDX = 2 

   '=================================================================================
   '  Purpose  : 	평가 의견 등록 - Update
   '================================================================================= 
   Declare @eval_desc varchar(max), @item_idx varchar(max)
   Set @eval_desc = '바꿔 신난다.11, 바꿔 신난다.12, 바꿔 신난다.13'
   Set @item_idx = '25, 26, 28'

   /* ---------------------------------------------------------------------------------------
		입력된 값이 평가 항목의 배점 최대값보다 큰지 비교
     --------------------------------------------------------------------------------------- */
	 
	 -- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	;with cte_desc As (	
		Select Row_Number() Over(Order By(Select 1)) As Idx, eval_desc From (
			Select value As eval_desc From string_split(@eval_desc, '|')
		) As C
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Row_Number() Over(Order By(Select 1)) As Idx, item_type_idx From (
			Select Cast(value As int) As item_type_idx From string_split(@item_idx, ',')
		) As C
	)

	-- 클라이언트로 받아온 item_type_idx과 point를 merge한다. 
	, cte_client_item As (
		Select I.Idx, I.item_type_idx,  eval_desc
			From cte_desc As P 
			Inner Join cte_client_idx As I On I.Idx = P.Idx 
	) 

	, cte_same_item As (
		Select * 
			From cte_client_item
			Where item_type_idx In (Select EvalItemTypeIDX From tblEvalDesc 
				Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1 )
	)

	Update tblEvalDesc Set EvalDesc = I.eval_desc
		From tblEvalDesc As D 
		Inner Join cte_same_item AS I On I.item_type_idx = D.EvalItemTypeIDX
		Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1
            

   '=================================================================================
   '  Purpose  : 	평가 위원 - 평가 점수 등록  - Valid Check 
   '=================================================================================    
   

-- 평가위원 - 평가 항목 등록 
   Declare @valid_id int, @vaild_association int, @valid_items int , @valid_point int, @group_cd int 
   Declare @cnt_desc int , @cnt_idx int, @valid_data_cnt int 
   Declare @eval_pt varchar(max), @item_idx varchar(max)
   Set @eval_pt = '5, 5, 6'
   Set @item_idx = '25, 26, 28'

  /* ---------------------------------------------------------------------------------------
		아이디 권한 체크 : 최고관리자 이상일 경우만 vaild하다. 
		아이디 Member Idx를 구한다. 
     --------------------------------------------------------------------------------------- */
   -- 아이디 권한 체크 : 평가 위원일 경우만 vaild하다. 
   -- 아이디 Member Idx를 구한다. 
   Select @valid_id = Case When AdminMemberIDX > 0 Then 1 Else 0 End
	From (
	   Select IsNull(Max(AdminMemberIDX), 0) As AdminMemberIDX
		  From tblAdminMember
		  Where DelYN = 'N' And Authority In ('A', 'B') And AdminMemberIDX = 2
	) As C
      
   /* ---------------------------------------------------------------------------------------
		협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가
     --------------------------------------------------------------------------------------- */
   Select @vaild_association = Case When AssociationIDX Is Null Then 0 Else 1 End , 
	  @group_cd = EvalGroupCD
      From tblAssociation_sub
      Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1

	/* ---------------------------------------------------------------------------------------
		Client 측정 항목 검증 - 평가 의견과 평가 항목수가 일치 하는지 검사 
	   --------------------------------------------------------------------------------------- */   
	-- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	;with cte_point As (	
		Select value As eval_point From string_split(@eval_pt, ',')
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Cast(value As int) As EvalItemTypeIDX From string_split(@item_idx, ',')
	)

	Select @cnt_desc = (Select Count(eval_point) From cte_point), 
	       @cnt_idx = (Select Count(EvalItemTypeIDX) From cte_client_idx)
		   	
	Select @valid_data_cnt = Case When @cnt_desc = @cnt_idx Then 1 Else 0 End
  
  /* ---------------------------------------------------------------------------------------
		입력된 값이 평가 항목의 배점 최대값보다 큰지 비교
     --------------------------------------------------------------------------------------- */
	 -- 서버에 설정된 EvalItemTypeIDX별 배점 포인트를 구한다. 
	 ;with cte_item AS (
		Select T.EvalItemTypeIDX, G.StandardPoint
		  From tblEvalMember As T 
		  Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX
		  Where T.DelKey = 0 And T.EvalTableIDX = 2 And T.AdminMemberIDX = 3
		  And G.DelKey = 0 And G.EvalTableIDX = 2 And G.EvalGroupCD = @group_cd
	 )

	 -- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	, cte_point As (	
		Select Row_Number() Over(Order By(Select 1)) As Idx, point From (
			Select Cast(value As decimal(5,2)) As point From string_split(@eval_pt, ',')
		) As C
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Row_Number() Over(Order By(Select 1)) As Idx, item_type_idx From (
			Select Cast(value As int) As item_type_idx From string_split(@item_idx, ',')
		) As C
	)

	-- 클라이언트로 받아온 item_type_idx과 point를 merge한다. 
	, cte_client_item As (
		Select I.Idx, I.item_type_idx,  Cast(P.point As Float) As point
			From cte_point As P 
			Inner Join cte_client_idx As I On I.Idx = P.Idx 
	) 

	-- EvalItemTypeIDX(평가항목)마다 배점 최대값과 클라이언트 값을 비교하여 값의 적절성을 체크한다. 
	-- 클라이언트 점수가 배점 최대값보다 크면 select한다. 
	, cte_over_point As (
		Select I.EvalItemTypeIDX, (I.StandardPoint* 100) As StandardPoint, (I.StandardPoint * (C.point/5) * 100) As point,  (I.StandardPoint * ( Cast(C.point As Float) / 5)) as Calc
			From cte_item As I 
			Inner Join cte_client_item As C On C.item_type_idx = I.EvalItemTypeIDX 
			And (I.StandardPoint * ( Cast(C.point As Float) / 5)) > I.StandardPoint			
	)

	-- 클라이언트 점수와 배점 최대값을 비교하여 값의 vaild를 체크한다. 
	Select @valid_point = Case When cnt_item > 0 Then 0 Else 1 End 
		From (
			Select Count(EvalItemTypeIDX) As cnt_item From cte_over_point
		) As C 


  /* ---------------------------------------------------------------------------------------
		id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교 
     --------------------------------------------------------------------------------------- */
   ;with cte_item As (
      Select EvalItemTypeIDX
         From tblEvalMember
      Where DelKey = 0 And EvalTableIDX = 2 And AdminMemberIDX = 3
   )

   -- 클라이언트로 부터 넘겨 받은 측정 항목 타입 list를 구한다. 
   , cte_client_item As (
      Select Cast(value As int) As EvalItemTypeIDX From string_split(@item_idx, ',')
   )

   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구한후 union 한다. 
   , cte_diff As (
      Select Count(EvalItemTypeIDX) As cnt_item From (
         Select EvalItemTypeIDX From cte_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_client_item)
         Union 
         Select EvalItemTypeIDX From cte_client_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_item)
      ) As C
   )

   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교 
   -- cte_diff는 차집합을 이용하여 두 값이 같은지를 찾는다. 
   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구하고, 
   -- 그 합이 공집합이면 같고 아니면 틀리다. 
   Select @valid_items = Case When cnt_item = 0 Then 1 Else 0 End From cte_diff

   -- 0: 정상 , 1: 권한 없음, 2: 미등록 협회 , 3:id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다. 
   -- 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. , 5: 클라이언트에서 받은 포인트 값이 배점 최대값보다 크다. 

   -- 정상 등록 
   If(@valid_id = 1 And @vaild_association = 1 And @valid_items = 1 And @valid_point = 1 And @valid_data_cnt = 1) 	 
      Select 0 As err_code
   Else 
      -- 권한 에러 
         If(@valid_id = 0)					
            Select 1 As err_code
         -- 미등록 협회 에러 
         Else If(@vaild_association = 0)		
            Select 2 As err_code
      -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다. 
      Else If(@valid_items = 0)		
            Select 3 As err_code
	  -- 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. 
	   Else If(@valid_data_cnt = 0)		
            Select 4 As err_code
      -- 클라이언트에서 받은 포인트 값이 배점 최대값보다 크다. 
      Else If(@valid_point = 0)		
            Select 5 As err_code
   
   '=================================================================================
   '  Purpose  : 	최고관리자 이상 - 평가 점수 등록  - Valid Check 
   '=================================================================================    
   -- 최고관리자 - 평가 항목 등록 
   Declare @member_idx int , @valid_id int, @vaild_association int, @valid_items int , @valid_point int, @group_cd int 
   Declare @cnt_desc int , @cnt_idx int, @valid_data_cnt int 
   Declare @eval_pt varchar(max), @item_idx varchar(max)
   Set @eval_pt = '1, 2, 3, 4, 5, 1, 2, 3, 4'
   Set @item_idx = '27, 33, 36, 38, 40, 42, 44, 47,48'

  /* ---------------------------------------------------------------------------------------
		아이디 권한 체크 : 최고관리자 이상일 경우만 vaild하다. 
		아이디 Member Idx를 구한다. 
     --------------------------------------------------------------------------------------- */
   Select @member_idx = IsNull(Max(AdminMemberIDX), 0)
      From tblAdminMember
      Where DelYN = 'N' And Authority In ('A', 'B') And UserID = 'eval_mgr'

   Set @valid_id = Case When @member_idx > 0 Then 1 Else 0 End 
      
   /* ---------------------------------------------------------------------------------------
		협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가
     --------------------------------------------------------------------------------------- */
   Select @vaild_association = Case When AssociationIDX Is Null Then 0 Else 1 End , 
	  @group_cd = EvalGroupCD
      From tblAssociation_sub
      Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1

  /* ---------------------------------------------------------------------------------------
		Client 측정 항목 검증 - 평가 의견과 평가 항목수가 일치 하는지 검사 
	   --------------------------------------------------------------------------------------- */   
	-- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	;with cte_point As (	
		Select value As eval_point From string_split(@eval_pt, ',')
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Cast(value As int) As EvalItemTypeIDX From string_split(@item_idx, ',')
	)

	Select @cnt_desc = (Select Count(eval_point) From cte_point), 
	       @cnt_idx = (Select Count(EvalItemTypeIDX) From cte_client_idx)
		   	
	Select @valid_data_cnt = Case When @cnt_desc = @cnt_idx Then 1 Else 0 End
  
  /* ---------------------------------------------------------------------------------------
		입력된 값이 평가 항목의 배점 최대값보다 큰지 비교
     --------------------------------------------------------------------------------------- */
	 -- 서버에 설정된 EvalItemTypeIDX별 배점 포인트를 구한다. 
	 ;with cte_item AS (
		Select T.EvalItemTypeIDX, T.EvalTypeCD, G.StandardPoint
		  From tblEvalItemType As T 
		  Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX
		  Where T.DelKey = 0 And T.EvalTableIDX = 2 And T.EvalTypeCD In (2, 100)
		  And G.DelKey = 0 And G.EvalTableIDX = 2 And G.EvalGroupCD = @group_cd
	 )

	 -- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	, cte_point As (	
		Select Row_Number() Over(Order By(Select 1)) As Idx, point From (
			Select Cast(value As int) As point From string_split(@eval_pt, ',')
		) As C
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Row_Number() Over(Order By(Select 1)) As Idx, item_type_idx From (
			Select Cast(value As int) As item_type_idx From string_split(@item_idx, ',')
		) As C
	)

	-- 클라이언트로 받아온 item_type_idx과 point를 merge한다. 
	, cte_client_item As (
		Select I.Idx, I.item_type_idx,  P.point 
			From cte_point As P 
			Inner Join cte_client_idx As I On I.Idx = P.Idx 
	) 

	-- EvalItemTypeIDX(평가항목)마다 배점 최대값과 클라이언트 값을 비교하여 값의 적절성을 체크한다. 
	-- 클라이언트 점수가 배점 최대값보다 크면 select한다. 
	, cte_over_point As (
		Select I.EvalItemTypeIDX, I.StandardPoint, C.point
			From cte_item As I 
			Inner Join cte_client_item As C On C.item_type_idx = I.EvalItemTypeIDX And C.point > I.StandardPoint
			Where I.EvalTypeCD < 100
	)

	-- 클라이언트 점수와 배점 최대값을 비교하여 값의 vaild를 체크한다. 
	Select @valid_point = Case When cnt_item > 0 Then 0 Else 1 End 
		From (
			Select Count(EvalItemTypeIDX) As cnt_item From cte_over_point
		) As C 
	
  /* ---------------------------------------------------------------------------------------
		id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교 
     --------------------------------------------------------------------------------------- */
   -- 최고 관리자일 경우는 측정타입테이블에서 정량, 감점 평가 타입을 평가한다. 
   ;with cte_item As (
      Select EvalItemTypeIDX
         From tblEvalItemType
      Where DelKey = 0 And EvalTableIDX = 2 And EvalTypeCD In (2, 100)
   )

   -- 클라이언트로 부터 넘겨 받은 측정 항목 타입 list를 구한다. 
   , cte_client_item As (
      Select Cast(value As int) As EvalItemTypeIDX From string_split(@item_idx, ',')
   )

   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구한후 union 한다. 
   , cte_diff As (
      Select Count(EvalItemTypeIDX) As cnt_item From (
         Select EvalItemTypeIDX From cte_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_client_item)
         Union 
         Select EvalItemTypeIDX From cte_client_item Where EvalItemTypeIDX Not In (Select EvalItemTypeIDX From cte_item)
      ) As C
   )

   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 동일 한지 비교 
   -- cte_diff는 차집합을 이용하여 두 값이 같은지를 찾는다. 
   -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목을 번갈아 차집합으로 구하고, 
   -- 그 합이 공집합이면 같고 아니면 틀리다. 
   Select @valid_items = Case When cnt_item = 0 Then 1 Else 0 End From cte_diff

  -- 0: 정상 , 1: 권한 없음, 2: 미등록 협회 , 3:id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다. 
   -- 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. , 5: 클라이언트에서 받은 포인트 값이 배점 최대값보다 크다. 

   -- 정상 등록 
   If(@valid_id = 1 And @vaild_association = 1 And @valid_items = 1 And @valid_point = 1 And @valid_data_cnt = 1) 	 
      Select 0 As err_code
   Else 
      -- 권한 에러 
         If(@valid_id = 0)					
            Select 1 As err_code
         -- 미등록 협회 에러 
         Else If(@vaild_association = 0)		
            Select 2 As err_code
      -- id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다. 
      Else If(@valid_items = 0)		
            Select 3 As err_code
	  -- 4: client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다. 
	   Else If(@valid_data_cnt = 0)		
            Select 4 As err_code
      -- 클라이언트에서 받은 포인트 값이 배점 최대값보다 크다. 
      Else If(@valid_point = 0)		
            Select 5 As err_code
      
   '=================================================================================
   '  Purpose  : 	평가 점수 등록  - Insert
   '================================================================================= 
   -- 평가위원 - 평가 항목 등록 
   Declare @member_idx int, @group_cd int
   Declare @eval_pt varchar(max), @item_idx varchar(max)
   Set @eval_pt = '1, 2, 3, 2, 2, 1, 2, 3, 1'
   Set @item_idx = '27, 33, 36, 38, 40, 42, 44, 47,48'

	/* ---------------------------------------------------------------------------------------
		아이디 Member Idx를 구한다. 
     --------------------------------------------------------------------------------------- */
   Select @member_idx = IsNull(Max(AdminMemberIDX), 0)
      From tblAdminMember
      Where DelYN = 'N' And Authority In ('C') And UserID = 'eval_test_1'

   /* ---------------------------------------------------------------------------------------
		협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가
     --------------------------------------------------------------------------------------- */
   Select @group_cd = EvalGroupCD
      From tblAssociation_sub
      Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1

   /* ---------------------------------------------------------------------------------------
		입력된 값을 Insert한다. 
     --------------------------------------------------------------------------------------- */
	 -- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	;with cte_point As (	
		Select Row_Number() Over(Order By(Select 1)) As Idx, point From (
			Select Cast(value As int) As point From string_split(@eval_pt, ',')
		) As C
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Row_Number() Over(Order By(Select 1)) As Idx, item_type_idx From (
			Select Cast(value As int) As item_type_idx From string_split(@item_idx, ',')
		) As C
	)

	-- 클라이언트로 받아온 item_type_idx과 point를 merge한다. 
	, cte_client_item As (
		Select I.Idx, I.item_type_idx,  Cast(P.point As Float) As point
			From cte_point As P 
			Inner Join cte_client_idx As I On I.Idx = P.Idx 
	) 

	-- 평가위원으로 추가된 값이 있는지 확인한다. 
	, cte_diff_item As (
		Select * 
			From cte_client_item
			Where item_type_idx Not In (Select EvalItemTypeIDX From tblEvalValue 
				Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1 And AdminMemberIDX = @member_idx  )
	)

	Insert Into tblEvalValue (EvalTableIDX, AssociationIDX, EvalGroupCD, EvalCateCD, EvalItemCD, EvalSubCateCD, EvalItemIDX, 
		EvalItemTypeIDX, AdminMemberIDX, EvalTypeCD, EvalTypeNm, StandardPoint, Point, PointCalc )
	Select T.EvalTableIDX, A.AssociationIDX, A.EvalGroupCD, T.EvalCateCD, T.EvalItemCD, T.EvalSubCateCD, T.EvalItemIDX, 
	T.EvalItemTypeIDX, @member_idx As AdminMemberIDX, T.EvalTypeCD, T.EvalTypeNm, StandardPoint, Point, 
	Case When EvalTypeCD = 1 Then Round(StandardPoint * (Cast(Point As Float) / 5), 2) * 100 Else Point* 100 End As PointCalc
	From tblEvalItemType As T
	Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX
	Inner Join tblAssociation_sub As A On A.AssociationIDX = 1 And A.DelKey = 0 And A.EvalTableIDX = 2 
	Inner Join cte_diff_item AS I On I.item_type_idx = T.EvalItemTypeIDX
	Where G.DelKey = 0 And G.EvalTableIDX = 2 And G.EvalGroupCD = @group_cd

   '=================================================================================
   '  Purpose  : 	평가 점수 등록  - Update
   '================================================================================= 
   
-- 평가위원 - 평가 항목 등록 
   Declare @member_idx int, @group_cd int
   Declare @eval_pt varchar(max), @item_idx varchar(max)
  -- Set @eval_pt = '1, 2, 3, 2, 2, 1, 2, 3, 1'
  Set @eval_pt = '2, 2, 2, 3, 3, 3, 1, 1, 1'
   Set @item_idx = '27, 33, 36, 38, 40, 42, 44, 47,48'

	/* ---------------------------------------------------------------------------------------
		아이디 Member Idx를 구한다. 
     --------------------------------------------------------------------------------------- */
   Select @member_idx = IsNull(Max(AdminMemberIDX), 0)
      From tblAdminMember
      Where DelYN = 'N' And Authority In ('C') And UserID = 'eval_test_1'

   /* ---------------------------------------------------------------------------------------
		협회 Valid 체크 : 해당 평가 회차에 등록된 협회인가
     --------------------------------------------------------------------------------------- */
   Select @group_cd = EvalGroupCD
      From tblAssociation_sub
      Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1

   /* ---------------------------------------------------------------------------------------
		입력된 값을 Insert한다. 
     --------------------------------------------------------------------------------------- */
	 -- 클라이언트로 부터 받아온 점수를 select문으로 바꾼다. 
	;with cte_point As (	
		Select Row_Number() Over(Order By(Select 1)) As Idx, point From (
			Select Cast(value As int) As point From string_split(@eval_pt, ',')
		) As C
	)

	-- 클라이언트로 부터 받아온 item_type_idx를 select문으로 바꾼다. 
	, cte_client_idx As (
		Select Row_Number() Over(Order By(Select 1)) As Idx, item_type_idx From (
			Select Cast(value As int) As item_type_idx From string_split(@item_idx, ',')
		) As C
	)

	-- 클라이언트로 받아온 item_type_idx과 point를 merge한다. 
	, cte_client_item As (
		Select I.Idx, I.item_type_idx,  Cast(P.point As Float) As point
			From cte_point As P 
			Inner Join cte_client_idx As I On I.Idx = P.Idx 
	) 

	-- 평가위원으로 추가된 값이 있는지 확인한다. 
	, cte_same_item As (
		Select * 
			From cte_client_item
			Where item_type_idx In (Select EvalItemTypeIDX From tblEvalValue 
				Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1 And AdminMemberIDX = @member_idx  )
	)

	--Update tblEvalValue Set  Point = 1, PointCalc = 2 


	Update tblEvalValue Set  Point = I.point, PointCalc = Case When EvalTypeCD = 1 Then Round(StandardPoint * (Cast(I.Point As Float) / 5), 2) * 100 Else I.Point* 100 End
		From tblEvalValue As T
		Inner Join cte_same_item As I On T.EvalItemTypeIDX = I.item_type_idx
		Where T.DelKey = 0 And T.EvalTableIDX = 2 And T.AdminMemberIDX = @member_idx

/*
	Insert Into tblEvalValue (EvalTableIDX, AssociationIDX, EvalGroupCD, EvalCateCD, EvalItemCD, EvalSubCateCD, EvalItemIDX, 
		EvalItemTypeIDX, AdminMemberIDX, EvalTypeCD, EvalTypeNm, StandardPoint, Point, PointCalc )
	Select T.EvalTableIDX, A.AssociationIDX, A.EvalGroupCD, T.EvalCateCD, T.EvalItemCD, T.EvalSubCateCD, T.EvalItemIDX, 
	T.EvalItemTypeIDX, @member_idx As AdminMemberIDX, T.EvalTypeCD, T.EvalTypeNm, StandardPoint, Point, 
	Case When EvalTypeCD = 1 Then Round(StandardPoint * (Cast(Point As Float) / 5), 2) * 100 Else Point* 100 End As PointCalc
	From tblEvalItemType As T
	Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX
	Inner Join tblAssociation_sub As A On A.AssociationIDX = 1 And A.DelKey = 0 And A.EvalTableIDX = 2 
	Inner Join cte_diff_item AS I On I.item_type_idx = T.EvalItemTypeIDX
	Where G.DelKey = 0 And G.EvalTableIDX = 2 And G.EvalGroupCD = @group_cd
*/

'=================================================================================
'  Purpose  : 	평가 의견 - 등록된 평가 의견을 가져온다 .
'================================================================================= 
Select ROW_NUMBER() Over(Order By EvalItemTypeIDX) As Idx, 
      EvalItemTypeIDX, EvalDesc
      From tblEvalDesc Where DelKey = 0 And EvalTableIDX = 7 And AssociationIDX = 3
	  And AdminMemberIDX = 3

'=================================================================================
'  Purpose  : 	평가 점수 - 등록된 평가 점수를 가져온다 .
'================================================================================= 
-- 최고 관리자일 경우 AdminMemberIDX를 0으로 mapping한다. 
	-- 최고 관리자는 평가 항목을 mapping하지 않고, 0을 대표 키로 사용한다. 
	;with cte_admin As (
		Select AdminMemberIDX From tblAdminMember
			Where DelYN = 'N' And UseYN = 'Y' And Authority In ('A', 'B')
	)

	Select ROW_NUMBER() Over(Partition By AdminMemberIDX Order By EvalItemTypeIDX) As Idx, 
		Case When AdminMemberIDX In (Select AdminMemberIDX From cte_admin) Then 0 Else AdminMemberIDX End As AdminMemberIDX , 
			EvalItemTypeIDX,
			Round( Cast(Point As Float) / 100, 2) As Point From tblEvalValue
			Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 2


%>
