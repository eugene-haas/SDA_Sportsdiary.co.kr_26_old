

<%
	'=================================================================================
	'  Purpose  : 	쿼리 테스트 데이터 
	'  Author   : 												By Aramdry
	'=================================================================================

%>

<%
   '=================================================================================
   '  Purpose  : 	평가 위원
   '=================================================================================
  
%>

<%
   '=================================================================================
   ' '  Purpose  : 	평가 List 가져오기 - 평가 위원
   '     평가위원이 평가를 진행했던 평가 테이블 List만 가져온다. 
   '=================================================================================       
	-- 평가자가 평가한 평가 Table List를 구한다 .
	;with cte_eval_member As (
		Select EvalTableIdx From tblEvalMember
			Where DelKey = 0 And AdminMemberIDX = 10
			Group By EvalTableIdx
	)

   -- 같은 년도에 평가가 여러개일 경우 EvalTitle + YearOrder로 표시 하고, 
   -- 평가가 1개일 경우 EvalTitle만 표시한다. 
   -- 같은 년도에 여러개의 평가가 있는지 확인한다. 
   , cte_check_eval As(
      Select RegYear, cnt_eval From (
         Select RegYear, Count(RegYear) As cnt_eval 
            From tblEvalTable	
            Where DelKey = 0
            Group By RegYear
      ) As C Where cnt_eval > 1
   )
   	  
   Select ROW_NUMBER() Over(Order By T.RegYear Desc, T.YearOrder Desc) As Idx, 
      T.EvalTableIDX, T.RegYear, 
      Case When C.RegYear Is Null Then EvalTitle Else EvalTitle + '_' + Cast(YearOrder As varChar(10)) End As EvalTitle
	From tblEvalTable As T
	Left Join cte_check_eval As C On C.RegYear = T.RegYear
	Where T.DelKey = 0 And T.EvalTableIDX In (Select EvalTableIdx From cte_eval_member)

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
         Where DelKey = 0 And EvalTableIDX = 1 And AdminMemberIDX = 3
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
      Case When V.cnt_value Is Null Or V.cnt_value = 0 Then 0 
         When V.cnt_value = @cnt_item Then 1 
         Else 2 End As point_state, 
      Case When D.cnt_desc Is Null Or D.cnt_desc = 0 Then 0 
         When D.cnt_desc = @cnt_item Then 1 
         Else 2 End As desc_state, 
      Case When A.EvalText Is Null Then 0 Else 1 End total_desc_state
      From cte_association As A 
      Left Join cte_value As V On V.AssociationIDX = A.AssociationIDX
      Left Join cte_desc As D On D.AssociationIDX = A.AssociationIDX

   '=================================================================================
   '  Purpose  : 	배점및 총평등록  - 
   '           카테고리, sub카테고리, 평가항목 갯수, 평가 배점 총합을 구한다. 
   '=================================================================================    
   -- 카테고리, sub카테고리, 평가항목 갯수를 구하기 위해 평가 지표를 구한다. 
   ; with cte_member As (
		Select * 
			From tblEvalMember
			Where DelKey = 0 And EvalTableIDX = 2 And AdminMemberIDX = 3

   )

   -- 평가위원에 할당된 아이템 정보를 구한다. 
   , cte_item As (
      Select * 
         From tblEvalItem
         Where DelKey = 0 And EvalTableIDX = 2 
		 And EvalItemIDx In (Select EvalItemIDX From cte_member)
   )
   
   -- 평가위원에 할당된 카테고리 Count를 구한다. 
   , cte_cate As (
		Select Count(EvalCateCD) As cnt_cate From (
			Select EvalCateCD From cte_item Group By EvalCateCD
		) As C 
   )

   -- 평가위원에 할당된 Sub 카테고리 Count를 구한다. 
    , cte_subcate As (
		Select Count(EvalSubCateCD) As cnt_subcate From (
			Select EvalSubCateCD From cte_item Group By EvalSubCateCD
		) As C 
   )

   -- 가군을 기준으로 평가 위원에 할당된 총 점수를 얻는다. 
   , cte_point As (
      Select Sum(StandardPoint) As sum_point
         From tblEvalItemTypeGroup
         Where DelKey = 0 And EvalTableIDX = 2
         And EvalGroupCD = 1 And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member)
   )

   -- 카테고리, sub카테고리, 평가항목 갯수, 평가 배점 총합을 구한다. 
   Select (Select cnt_cate From cte_cate) As cnt_cate, 
         (Select cnt_subcate From cte_subcate) As cnt_subcate, 
         (Select Count(EvalItemIDX) As cnt_item From cte_item) As cnt_item, 
		 sum_point 
      From cte_point

   '=================================================================================
   '  Purpose  : 	배점등록  -  카테고리 정보 
   '=================================================================================    
   -- 평가군별 평가 배점을 구한다.  
   -- 일반 평가위원: 평가위원 등록테이블에 등록된 항목 갯수 
   ;with cte_member As (
      Select  EvalItemTypeIDX
         From tblEvalMember
         Where DelKey = 0 And EvalTableIDX = 7
         And AdminMemberIDX = 3
   )

   , cte_group As ( 
   Select *  
      From tblEvalItemTypeGroup  
      Where DelKey = 0 And EvalTableIDX = 7 And EvalGroupCD = 1
      And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member)
   )
   
   -- 카테고리 정보를 구한다. - 평가 지표 합 포함 
   Select Row_Number() Over(Order By I.CateOrderNo) As Idx,  
   G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm
      From tblEvalItemType As I 
   Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX 
      Where I.DelKey = 0 And I.EvalTableIDX = 7
      And I.EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member)
      Group By G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm 

   '=================================================================================
   '  Purpose  : 	배점등록  -  Sub 카테고리 정보 
   '=================================================================================    
   -- 평가군별 평가 배점을 구한다.  
   -- 일반 평가위원: 평가위원 등록테이블에 등록된 항목 갯수 
   ;with cte_member As (
      Select  EvalItemTypeIDX
         From tblEvalMember
         Where DelKey = 0 And EvalTableIDX = 7 And AdminMemberIDX = 3
         And AdminMemberIDX = 3
   )

   , cte_group As ( 
   Select *  
      From tblEvalItemTypeGroup  
      Where DelKey = 0 And EvalTableIDX = 7 And EvalGroupCD = 1
      And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member)
   )
   
   -- Sub 카테고리 정보를 구한다. - 평가 지표 합 포함 
   Select Row_Number() Over(Order By I.CateOrderNo, I.SubCateOrderNo) As Idx,  
   G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm
      From tblEvalItemType As I 
   Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX 
      Where I.DelKey = 0 And I.EvalTableIDX = 7
      And I.EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member)
      Group By G.EvalGroupCD, G.EvalGroupNm, I.CateOrderNo, I.EvalCateCD, I.EvalCateNm, I.SubCateOrderNo, I.EvalSubCateCD, I.EvalSubCateNm
      
   '=================================================================================
   '  Purpose  : 	배점등록  -  측정항목 정보 
   '=================================================================================    
   -- 평가군별 평가 배점을 구한다.  
   -- 일반 평가위원: 평가위원 등록테이블에 등록된 항목 갯수 
   ;with cte_member As (
      Select  EvalItemTypeIDX
         From tblEvalMember
         Where DelKey = 0 And EvalTableIDX = 7
         And AdminMemberIDX = 3
   )

   , cte_group As ( 
   Select *  
      From tblEvalItemTypeGroup  
      Where DelKey = 0 And EvalTableIDX = 7 And EvalGroupCD = 1
      And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member)
   )
   
   -- Sub 카테고리 정보를 구한다. - 평가 지표 합 포함 
   Select Row_Number() Over(Order By T.CateOrderNo, T.SubCateOrderNo, T.ItemOrderNo) As Idx,  
   G.EvalGroupCD, G.EvalGroupNm, T.EvalItemTypeIdx, T.EvalItemIDX, T.CateOrderNo, T.EvalCateCD, T.EvalCateNm, T.SubCateOrderNo, T.EvalSubCateCD, T.EvalSubCateNm,
   T.ItemOrderNo, T.EvalItemCD, T.EvalItemNm, G.StandardPoint, T.EvalTypeCD, T.EvalTypeNm
      From tblEvalItemType As T 
   Inner Join cte_group As G On G.EvalItemTypeIdx = T.EvalItemTypeIdx 
      Where T.DelKey = 0 And T.EvalTableIDX = 7
      And T.EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member)

   '=================================================================================
   '  Purpose  : 	배점등록  -  측정항목 배점 정보
   '=================================================================================   
   Select ROW_NUMBER() Over(Partition By AdminMemberIDX Order By EvalItemTypeIDX) As Idx,  
             AdminMemberIDX ,  
                EvalItemTypeIDX, 
                Round( Cast(Point As Float) / 100, 2) As Point
                From tblEvalValue 
             Where DelKey = 0 And EvalTableIDX = 7 And AssociationIDX = 1 And AdminMemberIDX = 3
   
   '=================================================================================
   '  Purpose  : 	배점등록  -  측정항목 평가의견
   '=================================================================================   
   Select ROW_NUMBER() Over(Partition By AdminMemberIDX Order By EvalItemTypeIDX) As Idx,  
             AdminMemberIDX ,  
                EvalItemTypeIDX, EvalDesc
                From tblEvalDesc 
             Where DelKey = 0 And EvalTableIDX = 7 And AssociationIDX = 3 And AdminMemberIDX = 3

   '=================================================================================
   '  Purpose  : 	그룹 정보 - 협회임원 - 협회 idx를 입력받아 그룹 정보를 돌려준다. 
   '=================================================================================   
   Select AssociationIDX, AssociationNm, EvalGroupCD, EvalGroupNm
			 From tblAssociation_sub
			 Where DelKey = 0 And EvalTableIDX = 7 And AssociationIDX = 3
%>
