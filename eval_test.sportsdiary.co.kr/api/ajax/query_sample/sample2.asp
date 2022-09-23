
<%
	'=================================================================================
	'  Purpose  : 	쿼리 테스트 데이터 
	'  Author   : 												By Aramdry
	'=================================================================================

%>

<%
   '=================================================================================
   '  Purpose  : 	
   '=================================================================================
  
%>

<%
   '=================================================================================
   '  Purpose  : 	평가 타입별 배점 구하기 
   '=================================================================================
   -- 평가 타입별 설정된 평가군 정보를 구한다. 
   ;with cte_group As (
      Select EvalItemTypeIDX, EvalGroupCD, EvalGroupNm, StandardPoint 
      From tblEvalItemTypeGroup
      Where Delkey = 0 And  EvalTableIDX = 1
   )

   -- 평가 타입에 평가군에서 구한 평가 배점 점수를 적용한다. 
   Select T.EvalTableIDX, T.EvalItemIDX, T.EvalCateCD, T.EvalCateNm, T.EvalSubCateCD, T.EvalSubCateNm, 
         T.EvalItemCD, T.EvalItemNm, T.EvalTypeCD, T.EvalTypeNm,  
         (Select StandardPoint From cte_group Where EvalItemTypeIDX = T.EvalItemTypeIDX And EvalGroupCD = 1) As A_Point, 
         (Select StandardPoint From cte_group Where EvalItemTypeIDX = T.EvalItemTypeIDX And EvalGroupCD = 2) As B_Point, 
         (Select StandardPoint From cte_group Where EvalItemTypeIDX = T.EvalItemTypeIDX And EvalGroupCD = 3) As C_Point, 
         (Select StandardPoint From cte_group Where EvalItemTypeIDX = T.EvalItemTypeIDX And EvalGroupCD = 4) As D_Point, 
         (Select StandardPoint From cte_group Where EvalItemTypeIDX = T.EvalItemTypeIDX And EvalGroupCD = 5) As E_Point
      From tblEvalItemType As T
      Where T.Delkey = 0 And  T.EvalTableIDX = 1

   '=================================================================================
   '  Purpose  : 	평가 List 가져오기 
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

   Select ROW_NUMBER() Over(Order By T.RegYear Desc, T.YearOrder Desc) As Idx,  
      T.EvalTableIDX, T.RegYear, 
      Case When C.RegYear Is Null Then EvalTitle Else EvalTitle + '_' + Cast(YearOrder As varChar(10)) End As EvalTitle
	From tblEvalTable As T
	Left Join cte_check_eval As C On C.RegYear = T.RegYear
	Where T.DelKey = 0

   '=================================================================================
   '  Purpose  : 	평가군 가져오기 
   '=================================================================================
   Select ROW_NUMBER() Over(Order By CodeCD) As Idx, CodeCD, CodeNm 
	   From tblPubCode Where KindCD = 2 And CodeCD > 0

   '=================================================================================
   '  Purpose  : 	협회 목록 - 평가군, 회원군 순으로 정렬 , 년도별 데이터 
   '=================================================================================   
   Select ROW_NUMBER() Over(Partition By EvalGroupCD Order By MemberGroupCD, AssociationIdx) As Idx, 
      AssociationIDX, AssociationNm, EvalGroupCD, EvalGroupNm, MemberGroupCD, MemberGroupNm, RegYear
      From tblAssociation_sub 
      Where DelKey = 0 And EvalTableIDX = 1

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 카테고리 
   '================================================================================= 
   -- 가군에서 평가 배점을 구한다. 
   ;with cte_group As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
		And EvalGroupCD = 1
   )

   -- 카테고리 정보를 구한다. - 평가 지표 합 포함
   Select ROW_NUMBER() Over(Order By I.EvalCateCD) As Idx, 
	  I.EvalCateCD, I.EvalCateNm, Sum(G.StandardPoint) As sum_point
      From tblEvalItem As I 
	  Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX
      Where I.DelKey = 0 And I.EvalTableIDX = 1
      Group By I.EvalCateCD, I.EvalCateNm
   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - Sub 카테고리  - 마군 포함
   '================================================================================= 
   -- 가군에서 평가 배점을 구한다. 
   ;with cte_group As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
		And EvalGroupCD = 1
   )
   -- 마군에서 평가 배점을 구한다. 
   , cte_group5 As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
		And EvalGroupCD = 5
   )

   -- Sub 카테고리 정보를 구한다. - 평가 지표 합 포함
   Select ROW_NUMBER() Over(Order By I.EvalCateCD, I.EvalSubCateCD) As Idx, 
		I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, Sum(G.StandardPoint) As sum_point, Sum(G5.StandardPoint) As sum_point5
      From tblEvalItem As I
	  Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX
	  Inner Join cte_group5 As G5 On G5.EvalItemIDX = I.EvalItemIDX
      Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalSubCateCD > 0
      Group By I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - Sub 카테고리 
   '================================================================================= 
   -- 가군에서 평가 배점을 구한다. 
   ;with cte_group As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
		And EvalGroupCD = 1
   )

   -- Sub 카테고리 정보를 구한다. - 평가 지표 합 포함
   Select I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, Sum(G.StandardPoint) As sum_point
      From tblEvalItem As I
	  Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX
      Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalSubCateCD > 0
      Group By I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 평가 항목 
   '================================================================================= 
   -- 가군에서 평가 배점을 구한다. 
   ;with cte_group As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
		And EvalGroupCD = 1
   )

   -- Sub 카테고리 정보를 구한다. - 평가 지표 합 포함
   Select ROW_NUMBER() Over(Order By I.EvalCateCD, I.EvalSubCateCD, I.EvalItemCD) As Idx, 
	  I.EvalItemIDX, I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, I.EvalItemCD, I.EvalItemNm,  
	  Sum(G.StandardPoint) As sum_point
      From tblEvalItem As I
	  Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX
      Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalSubCateCD > 0
      Group By I.EvalItemIDX, I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, I.EvalItemCD, I.EvalItemNm


   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 군별 측정 타입
   '================================================================================= 
      -- 군별 측정 타입을 가져온다. 
   Select ROW_NUMBER() Over(Partition By G.EvalGroupCD Order By T.EvalTypeCD) As Idx, 
      G.EvalGroupCD, G.EvalGroupNm, T.EvalTypeCD, T.EvalTypeNm 
      From tblEvalItemType As T 
      Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX
      Where T.Delkey = 0 And T.EvalTableIDX = 1 And T.EvalTypeCD < 100
      And G.Delkey = 0 And G.EvalTableIDX = 1 
      Group By G.EvalGroupCD, G.EvalGroupNm, T.EvalTypeCD, T.EvalTypeNm 

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 평가군별 , 평가 타입별 평균 점수를 구한다. 
   '================================================================================= 
   -- 군별 측정 타입을 가져온다. 
   ;with cte_type As (
      Select ROW_NUMBER() Over(Partition By G.EvalGroupCD Order By T.EvalTypeCD) As Idx, 
      G.EvalGroupCD, G.EvalGroupNm, T.EvalTypeCD, T.EvalTypeNm 
      From tblEvalItemType As T 
      Inner Join tblEvalItemTypeGroup As G On G.EvalItemTypeIDX = T.EvalItemTypeIDX
      Where T.Delkey = 0 And T.EvalTableIDX = 1 And T.EvalTypeCD < 100
      And G.Delkey = 0 And G.EvalTableIDX = 1 
      Group By G.EvalGroupCD, G.EvalGroupNm, T.EvalTypeCD, T.EvalTypeNm 
   )

   -- 측정 항목별, 군별 점수를 얻어온다. (평균)
   -- 감점 타입일 경우 정량으로 변동하여 표시한다. 
   , cte_info As (
      Select EvalItemIdx, EvalGroupCD, 
         Case When EvalTypeCD = 100 Then 2 Else EvalTypeCD End As EvalTypeCD,  
         Count(EvalValueIdx) As cnt_val, Sum(PointCalc) As sum_point
         From tblEvalValue 
         Where Delkey = 0 And EvalTableIDX = 1
         Group By EvalItemIdx, EvalGroupCD, EvalTypeCD
   )

   -- 평가군별 , 평가 타입별 평균 점수를 구한다. 
   Select ROW_NUMBER() Over(Partition By EvalItemIdx Order By I.EvalGroupCD, T.EvalTypeCD) As Idx, 
      I.EvalItemIdx, I.EvalGroupCD, T.EvalTypeCD, 
      Case When I.EvalGroupCD = T.EvalGroupCD And I.EvalTypeCD <> T.EvalTypeCD Then 0
         Else Round(Cast(I.sum_point As Float) /(I.cnt_val *100), 2) End As ave_val
      From cte_info As I
      Inner Join cte_type As T On T.EvalGroupCD = I.EvalGroupCD
%>
