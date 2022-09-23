
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
   '  Purpose  : 	배점및 총평등록  - 
   '           카테고리, sub카테고리, 평가항목 갯수, 평가 배점 총합을 구한다. 
   '=================================================================================    
   -- 카테고리, sub카테고리, 평가항목 갯수를 구하기 위해 평가 지표를 구한다. 
   ;with cte_item As (
      Select * 
         From tblEvalItem
         Where DelKey = 0 And EvalTableIDX = 2
   )

   -- 가군을 기준으로 평가 지표에 할당된 총 점수를 얻는다. 
   , cte_point As (
      Select Sum(StandardPoint) As sum_point
         From tblEvalItemTypeGroup
         Where DelKey = 0 And EvalTableIDX = 2
         And EvalGroupCD = 1
   )

   -- 카테고리, sub카테고리, 평가항목 갯수, 평가 배점 총합을 구한다. 
   Select (Select Count(EvalItemIDX) As cnt_cate From cte_item Where EvalSubCateCD = 0) As cnt_cate, 
         (Select Count(EvalItemIDX) As cnt_subcate From cte_item Where EvalSubCateCD > 0 And EvalItemCD = 0) As cnt_subcate, 
         (Select Count(EvalItemIDX) As cnt_item From cte_item Where EvalItemCD > 0) As cnt_item, 
      sum_point 
      From cte_point

   '=================================================================================
   '  Purpose  : 	배점및 총평등록  - 
   '           협회의 평가 등록 상태를 보여준다.  0:없음, 1:완료, 2:평가중 
   '=================================================================================    
   -- 전체 평가 항목 갯수를 구한다 .
   -- 정성평가 갯수 : 평가위원 count * 평가 항목 갯수 
   -- 정량 평가및 감점 갯수 : 평가 항목 갯수 

   -- 평가의견 갯수 : 평가 항목 갯수 
   -- 총평 등록갯수 : 1개 

   Declare @cnt_total int, @cnt_earnest int, @cnt_fixed int, @cnt_desc int 

   -- 정성 평가 갯수는 평가위원에 할당된 갯수와 동일하다. 
   Select @cnt_earnest = Count(EvalMemberIDX)
         From tblEvalMember
         Where DelKey = 0 And EvalTableIDX = 1

   -- 정량 평가 갯수는 정량평가 + 감점평가 갯수와 동일하다. 
   Select @cnt_fixed = Count(EvalItemTypeIDX)
      From tblEvalItemType
      Where DelKey = 0 And EvalTableIDX = 1
         And EvalTypeCD In (2, 100)

   -- 평가 의견 갯수를 구한다. 
   Select @cnt_desc = Count(EvalItemTypeIDX)
      From tblEvalItemType
      Where DelKey = 0 And EvalTableIDX = 1

   -- 전체 평가 항목 갯수를 구한다. 
   Set @cnt_total = @cnt_earnest + @cnt_fixed

   -- 종목별 정보를 구한다. 
   ;with cte_association As (
      Select AssociationIDX, AssociationNm, EvalGroupCD, EvalGroupNm, EvalText
         From tblAssociation_sub 
         Where DelKey = 0 And EvalTableIDX = 1
   )

   -- 평가 점수를 구한다. 
   , cte_value As (
      Select AssociationIDX, Count(EvalValueIDX) As cnt_value
      From tblEvalValue
         Where DelKey = 0 And EvalTableIDX = 1
      Group By AssociationIDX
   )

   -- 평가 의견을 구한다. 
   , cte_desc As (
      Select AssociationIDX, Count(EvalDescIDX) As cnt_desc
      From tblEvalDesc
         Where DelKey = 0 And EvalTableIDX = 1
      Group By AssociationIDX
   )

   Select ROW_NUMBER() Over(Partition By A.EvalGroupCD Order By A.AssociationNm) As Idx, 
      A.EvalGroupCD,  A.EvalGroupNm, A.AssociationIDX, A.AssociationNm, 
      Case When V.cnt_value = 0 Or V.cnt_value Is Null Then 0 
         When V.cnt_value = @cnt_total Then 1 
         Else 2 End As point_state, 
      Case When D.cnt_desc = 0 Or D.cnt_desc Is Null  Then 0 
         When D.cnt_desc = @cnt_desc Then 1 
         Else 2 End As desc_state, 
      Case When A.EvalText Is Null Then 0 Else 1 End total_desc_state
      From cte_association As A 
      Left Join cte_value As V On V.AssociationIDX = A.AssociationIDX
      Left Join cte_desc As D On D.AssociationIDX = A.AssociationIDX
   
   '=================================================================================
   '  Purpose  : 	배점및 총평등록  - 평가 위원별 
   '           협회의 평가 등록 상태를 보여준다.  0:없음, 1:완료, 2:평가중 
   '================================================================================= 
   -- 평가 위원별 평가 완료 여부를 표시한다. 
   -- 일반 평가위원: 평가위원 등록테이블에 등록된 항목 갯수 
   -- 평가의견 갯수 : 평가 항목 갯수 
   -- 총평 등록갯수 : 1개 - 최고 관리자 일 경우만 보여준다. 

   Declare @cnt_item int, @cnt_desc int 

   -- 평가위원에 배정된 평가 항목의 갯수를 구한다. 
   Select  @cnt_item = Count(EvalItemTypeIDX) 
            From tblEvalMember
            Where DelKey = 0 And EvalTableIDX = 1
            And AdminMemberIDX = 3

   -- 일반 평가위원: 평가위원 등록테이블에 등록된 항목 갯수 
   ;with cte_member As (
      Select  EvalItemTypeIDX
            From tblEvalMember
            Where DelKey = 0 And EvalTableIDX = 1
            And AdminMemberIDX = 3
   )

   -- 종목별 정보를 구한다. 
   ,  cte_association As (
      Select AssociationIDX, AssociationNm, EvalGroupCD, EvalGroupNm, EvalText
         From tblAssociation_sub 
         Where DelKey = 0 And EvalTableIDX = 1
   )

   -- 평가 의견 갯수를 구한다. 
   , cte_desc As (
      Select AssociationIDX, Count(EvalItemTypeIDX) As cnt_desc
         From tblEvalDesc
         Where DelKey = 0 And EvalTableIDX = 1
         And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member)
         Group By AssociationIDX
   )

   -- 평가 점수를 구한다. 
   , cte_value As (
      Select AssociationIDX, Count(EvalValueIDX) As cnt_value
      From tblEvalValue
         Where DelKey = 0 And EvalTableIDX = 1
      And AdminMemberIDX = 3
      Group By AssociationIDX
   )

   Select ROW_NUMBER() Over(Partition By A.EvalGroupCD Order By A.AssociationNm) As Idx, 
      A.EvalGroupCD,  A.EvalGroupNm, A.AssociationIDX, A.AssociationNm, 
      Case When V.cnt_value = 0 Then 0 
         When V.cnt_value = @cnt_item Then 1 
         Else 2 End As point_state, 
      Case When D.cnt_desc = 0 Then 0 
         When D.cnt_desc = @cnt_item Then 1 
         Else 2 End As desc_state, 
      Case When A.EvalText Is Null Then 0 Else 1 End total_desc_state
      From cte_association As A 
      Left Join cte_value As V On V.AssociationIDX = A.AssociationIDX
      Left Join cte_desc As D On D.AssociationIDX = A.AssociationIDX

   '=================================================================================
   '  Purpose  : 	배점및 총평등록  - 최고관리자
   '           협회의 평가 등록 상태를 보여준다.  0:없음, 1:완료, 2:평가중 
   '================================================================================= 
   -- 최고관리자  평가 완료 여부를 표시한다. 
   -- 최고관리자 : 정량 평가및 감점 갯수
   -- 평가의견 갯수 : 평가 항목 갯수 
   -- 총평 등록갯수 : 1개 - 최고 관리자 일 경우만 보여준다. 

   Declare @cnt_item int, @cnt_desc int 

   -- 평가위원에 배정된 평가 항목의 갯수를 구한다. 
   Select  @cnt_item = Count(EvalItemTypeIDX) 
            From tblEvalItemType
            Where DelKey = 0 And EvalTableIDX = 1
            And EvalTypeCD In (2, 100)


   -- 최고관리자 평가 항목을 구한다. 
   ;with cte_item As (
      Select  EvalItemTypeIDX
            From tblEvalItemType
            Where DelKey = 0 And EvalTableIDX = 1
            And EvalTypeCD In (2, 100)
   )

   -- 종목별 정보를 구한다. 
   ,  cte_association As (
      Select AssociationIDX, AssociationNm, EvalGroupCD, EvalGroupNm, EvalText
         From tblAssociation_sub 
         Where DelKey = 0 And EvalTableIDX = 1
   )

   -- 평가 의견 갯수를 구한다. 
   , cte_desc As (
      Select AssociationIDX, Count(EvalItemTypeIDX) As cnt_desc
         From tblEvalDesc
         Where DelKey = 0 And EvalTableIDX = 1
         And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_item)
         Group By AssociationIDX
   )

   -- 평가 점수를 구한다. 
   , cte_value As (
      Select AssociationIDX, Count(EvalValueIDX) As cnt_value
      From tblEvalValue
         Where DelKey = 0 And EvalTableIDX = 1
      And EvalTypeCD In (2, 100)
      Group By AssociationIDX
   )

   Select ROW_NUMBER() Over(Partition By A.EvalGroupCD Order By A.AssociationNm) As Idx, 
      A.EvalGroupCD,  A.EvalGroupNm, A.AssociationIDX, A.AssociationNm, 
      Case When V.cnt_value = 0 Then 0 
         When V.cnt_value = @cnt_item Then 1 
         Else 2 End As point_state, 
      Case When D.cnt_desc = 0 Then 0 
         When D.cnt_desc = @cnt_item Then 1 
         Else 2 End As desc_state, 
      Case When A.EvalText Is Null Then 0 Else 1 End total_desc_state
      From cte_association As A 
      Left Join cte_value As V On V.AssociationIDX = A.AssociationIDX
      Left Join cte_desc As D On D.AssociationIDX = A.AssociationIDX        

   '=================================================================================
   '  Purpose  : 	배점 등록  - 
   '              평가자별 등록된 평가 항목을 가져온다.
   '================================================================================= 
   -- 평가자별 등록된 평가 항목을 가져온다.
   -- 최고관리자 평가 항목을 가져온다. 
   ;with cte_mgr As (
      Select 0 As AdminMemberIDX, EvalItemTypeIDX, EvalItemIDX, EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm, EvalItemCD, EvalItemNm, EvalTypeCD, EvalTypeNm 
         From tblEvalItemType
            Where DelKey = 0 And EvalTableIDX = 1
            And EvalTypeCD In (2, 100)
   )

   -- 평가위원별 등록된 평가 항목을 가져온다.
   , cte_member As (
      Select M.AdminMemberIDX, T.EvalItemTypeIDX, T.EvalItemIDX, T.EvalCateCD, T.EvalCateNm, T.EvalSubCateCD, T.EvalSubCateNm, T.EvalItemCD, T.EvalItemNm, T.EvalTypeCD, T.EvalTypeNm 
         From tblEvalItemType As T 
         Inner Join tblEvalMember As M On M.EvalItemTypeIDX = T.EvalItemTypeIDX
            Where T.DelKey = 0 And T.EvalTableIDX = 1 
            And M.DelKey = 0 And M.EvalTableIDX = 1 
   )

   -- 최고관리자, 평가위원의 평가 항목을 합쳐 하나로 나타낸다. 
   Select ROW_NUMBER() Over(Order By EvalItemTypeIDX)+ 1000 As Idx , 
      AdminMemberIDX, EvalItemTypeIDX, EvalItemIDX
      From cte_mgr
   Union All 
   Select ROW_NUMBER() Over(Partition By AdminMemberIDX Order By EvalCateCD, EvalSubCateCD, EvalItemCD) As Idx, 
      AdminMemberIDX, EvalItemTypeIDX, EvalItemIDX
      From cte_member

   '=================================================================================
   '  Purpose  : 	배점 등록  - 평가 점수를 가져온다.  - 최고관리자 
   '================================================================================= 
   Select EvalItemTypeIDX, Point 
      From tblEvalValue
         Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
         And EvalTypeCD In (2, 100)

   '=================================================================================
   '  Purpose  : 	배점 등록  - 평가 점수를 가져온다.  - 평가 위원
   '================================================================================= 
   Select EvalItemTypeIDX, Point 
      From tblEvalValue
         Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
         And AdminMemberIDX = 3

   '=================================================================================
   '  Purpose  : 	배점 등록  - 평가 의견를 가져온다.  - 최고관리자 
   '================================================================================= 
   -- 평가위원에 종속된 평가 항목을 구한다. 
	;with cte_item As (
		Select EvalItemTypeIDX
         From tblEvalItemType
         Where DelKey = 0 And EvalTableIDX = 1
         And EvalTypeCD In (2, 100)
	)

  -- 평가위원에 종속된 평가 항목의 평가 의견 데이터를 구한다. 
   Select EvalItemTypeIDX, EvalDesc
      From tblEvalDesc
     Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
	 And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_item)

   '=================================================================================
   '  Purpose  : 	배점 등록  - 평가 의견를 가져온다.  - 평가 위원
   '================================================================================= 
   -- 평가위원에 종속된 평가 항목을 구한다. 
	;with cte_item As (
		Select  EvalItemTypeIDX
			From tblEvalMember
			Where DelKey = 0 And EvalTableIDX = 1
			And AdminMemberIDX = 3
	)

  -- 평가위원에 종속된 평가 항목의 평가 의견 데이터를 구한다. 
   Select EvalItemTypeIDX, EvalDesc
      From tblEvalDesc
     Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
	 And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_item)

   '=================================================================================
   '  Purpose  : 	배점및 총평등록  -  평가 위원 List를 구한다. 
   '================================================================================= 
    -- 평가위원을 구한다. 
   ;with cte_member As (
      Select  AdminMemberIDX, AdminName
         From tblEvalMember
         Where DelKey = 0 And EvalTableIDX = 1
         Group By  AdminMemberIDX, UserID, AdminName
   )

   -- 최고 관리자는 설정을 안하므로 임의로 셋팅한다. 
   , cte_master As (
      Select 0 As AdminMemberIDX, '최고관리자' As AdminName
   )

   -- 평가위원 정보를 merge한다. 
   , cte_info As (
      Select AdminMemberIDX, AdminName From cte_member	
      Union 
      Select AdminMemberIDX, AdminName From cte_master
   )

   Select ROW_NUMBER() Over(Order By AdminMemberIDX) As Idx, AdminMemberIDX, AdminName 
      From cte_info

   '=================================================================================
   '  Purpose  : 	배점등록  - Title (평가 타이틀 + 협회명)
   '================================================================================= 
   -- 같은 년도에 평가가 여러개일 경우 EvalTitle + YearOrder로 표시 하고, 
   -- 평가가 1개일 경우 EvalTitle만 표시한다. 
   -- 같은 년도에 여러개의 평가가 있는지 확인한다. 
	;with cte_check_eval As(
		Select RegYear, cnt_eval From (
			Select RegYear, Count(RegYear) As cnt_eval 
			From tblEvalTable	
			Where DelKey = 0
			Group By RegYear
		) As C Where cnt_eval > 1
	)

	, cte_eval As (
      Select ROW_NUMBER() Over(Order By T.RegYear Desc, T.YearOrder Desc) As Idx, 
		  T.EvalTableIDX, T.RegYear, 
		  Case When C.RegYear Is Null Then EvalTitle Else EvalTitle + '_' + Cast(YearOrder As varChar(10)) End As EvalTitle
		From tblEvalTable As T
		Left Join cte_check_eval As C On C.RegYear = T.RegYear
		Where T.DelKey = 0 And T.EvalTableIDX = 1
	)

	, cte_association As (
		Select AssociationIDX, AssociationNm 
		From tblAssociation_sub
		Where DelKey = 0 And EvalTableIDX = 1
		And AssociationIDX = 1
	)

	Select AssociationNm, (Select EvalTitle From cte_eval) As eval_title
		From cte_association

   '=================================================================================
   '  Purpose  : 	배점등록  - 총평 등록
   '================================================================================= 
   Select IsNull(EvalText, '') As EvalText
      From tblAssociation_sub
      Where DelKey = 0 And EvalTableIDX = 2 And AssociationIDX = 1
%>
