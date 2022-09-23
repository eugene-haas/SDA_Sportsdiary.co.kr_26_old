
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
   '  Purpose  : 	평가 List 가져오기 
   '=================================================================================
   -- 같은 년도에 평가가 여러개일 경우 EvalTitle + YearOrder로 표시 하고, 
   -- 평가가 1개일 경우 EvalTitle만 표시한다. 
   -- 같은 년도에 여러개의 평가가 있는지 확인한다. 
   ;with cte_check_eval As(
      Select RegYear, cnt_eval From (
         Select RegYear, Count(RegYear) As cnt_eval 
            From tblEvalTable	
            Where DelKey = 0 And UseKey = 1
            Group By RegYear
      ) As C Where cnt_eval > 1
   )

   Select ROW_NUMBER() Over(Order By T.RegYear Desc, T.YearOrder Desc) As Idx, 
      T.EvalTableIDX, T.RegYear, 
      Case When C.RegYear Is Null Then EvalTitle Else EvalTitle + '_' + Cast(YearOrder As varChar(10)) End As EvalTitle
	From tblEvalTable As T
	Left Join cte_check_eval As C On C.RegYear = T.RegYear
	Where T.DelKey = 0 And T.UseKey = 1

   '=================================================================================
   '  Purpose  : 	-- 군별 배점 타입을 구한다. 
   '=================================================================================
   -- 군별 배점 타입을 구한다. 
   Select ROW_NUMBER() Over(Partition By G.EvalGroupCD Order By I.EvalTypeCD) As Idx, 
      G.EvalGroupCD, G.EvalGroupNm, I.EvalTypeCD, I.EvalTypeNm
      From tblEvalItem As I 
      Inner Join tblEvalItem_grp As G On G.EvalItemIDX = I.EvalItemIDX
      Where I.Delkey = 0 And I.EvalTableIDX = 1 And I.EvalTypeCD < 100
      And G.Delkey = 0 And G.EvalTableIDX = 1 
      Group By G.EvalGroupCD, G.EvalGroupNm, I.EvalTypeCD, I.EvalTypeNm

   '=================================================================================
   '  Purpose  : 	평가군 가져오기 
   '=================================================================================
   Select ROW_NUMBER() Over(Order By CodeCD) As Idx, CodeCD, CodeNm 
	   From tblPubCode Where KindCD = 2 And CodeCD > 0

   '=================================================================================
   '  Purpose  : 	평가 타입 가져오기 
   '=================================================================================
   Select ROW_NUMBER() Over(Order By CodeCD) As Idx, CodeCD, CodeNm 
	   From tblPubCode Where KindCD = 1 And CodeCD < 100

   '=================================================================================
   '  Purpose  : 	협회 목록 - 평가군, 회원군 순으로 정렬 , 년도별 데이터 
   '=================================================================================   
   Select ROW_NUMBER() Over(Partition By EvalGroupCD Order By MemberGroupCD, AssociationIdx) As Idx, 
      AssociationIDX, AssociationNm, EvalGroupCD, EvalGroupNm, MemberGroupCD, MemberGroupNm, RegYear
      From tblAssociation_sub 
      Where DelKey = 0 And EvalTableIDX = 1
  
   '=================================================================================
   '  Purpose  : 	평가 지표 - 배점 정보 
   '=================================================================================     
   -- 카테고리, sub 카테고리정보를 구한다. 
   ;with cte_cate As (
      Select EvalTableIDX, EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm 
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1 And EvalItemCD = 0
   )

   -- 평가 지표 항목 점수를  sub 카테고리 별로 구한다. 
   , cte_point As (
      Select EvalCateCD, EvalSubCateCD, Sum(StandardPoint) As sum_point
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1 And EvalItemCD > 0
         Group By EvalCateCD, EvalSubCateCD
   )

   -- 평가 지표 항목 점수를  카테고리 별로 구한다. 
   , cte_point_cate As (
      Select EvalCateCD, Sum(sum_point) As sum_point 
         From cte_point 
         Group By EvalCateCD
   )

   -- 군별 배점을 구한다. (정성, 정량 별) - 가군 
   , cte_point_group1 As (
      Select I.EvalCateCD, I.EvalSubCateCD, 
         Sum( Case When I.EvalTypeCD = 1 Then I.StandardPoint Else 0 End ) As Point1, 
         Sum( Case When I.EvalTypeCD = 2 Then I.StandardPoint Else 0 End ) As Point2 
         From tblEvalItem As I 
         Inner Join tblEvalItem_grp As G On I.EvalItemIDX = G.EvalItemIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalItemCD > 0	
         And G.Delkey = 0 And (G.EvalGroupCD = 0 Or G.EvalGroupCD = 1)
         Group By I.EvalCateCD, I.EvalSubCateCD
   )

   -- 군별 배점을 구한다. (정성, 정량 별) - 나군 
   , cte_point_group2 As (
      Select I.EvalCateCD, I.EvalSubCateCD, 
         Sum( Case When I.EvalTypeCD = 1 Then I.StandardPoint Else 0 End ) As Point1, 
         Sum( Case When I.EvalTypeCD = 2 Then I.StandardPoint Else 0 End ) As Point2 
         From tblEvalItem As I 
         Inner Join tblEvalItem_grp As G On I.EvalItemIDX = G.EvalItemIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalItemCD > 0	
         And G.Delkey = 0 And (G.EvalGroupCD = 0 Or G.EvalGroupCD = 2)
         Group By I.EvalCateCD, I.EvalSubCateCD
   )

   -- 군별 배점을 구한다. (정성, 정량 별) - 다군 
   , cte_point_group3 As (
      Select I.EvalCateCD, I.EvalSubCateCD, 
         Sum( Case When I.EvalTypeCD = 1 Then I.StandardPoint Else 0 End ) As Point1, 
         Sum( Case When I.EvalTypeCD = 2 Then I.StandardPoint Else 0 End ) As Point2 
         From tblEvalItem As I 
         Inner Join tblEvalItem_grp As G On I.EvalItemIDX = G.EvalItemIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalItemCD > 0	
         And G.Delkey = 0 And (G.EvalGroupCD = 0 Or G.EvalGroupCD = 3)
         Group By I.EvalCateCD, I.EvalSubCateCD
   )

   -- 군별 배점을 구한다. (정성, 정량 별) - 라군 
   , cte_point_group4 As (
      Select I.EvalCateCD, I.EvalSubCateCD, 
         Sum( Case When I.EvalTypeCD = 1 Then I.StandardPoint Else 0 End ) As Point1, 
         Sum( Case When I.EvalTypeCD = 2 Then I.StandardPoint Else 0 End ) As Point2 
         From tblEvalItem As I 
         Inner Join tblEvalItem_grp As G On I.EvalItemIDX = G.EvalItemIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalItemCD > 0	
         And G.Delkey = 0 And (G.EvalGroupCD = 0 Or G.EvalGroupCD = 4)
         Group By I.EvalCateCD, I.EvalSubCateCD
   )

   -- 군별 배점을 구한다. (정성, 정량 별) - 마군 
   , cte_point_group5 As (
      Select I.EvalCateCD, I.EvalSubCateCD, 
         Sum( Case When I.EvalTypeCD = 1 Then I.StandardPoint Else 0 End ) As Point1, 
         Sum( Case When I.EvalTypeCD = 2 Then I.StandardPoint Else 0 End ) As Point2 
         From tblEvalItem As I 
         Inner Join tblEvalItem_grp As G On I.EvalItemIDX = G.EvalItemIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalItemCD > 0	
         And G.Delkey = 0 And (G.EvalGroupCD = 0 Or G.EvalGroupCD = 5)
         Group By I.EvalCateCD, I.EvalSubCateCD
   )

   -- sub Cate 정보에 군별 배점을 적용한다. 
   , cte_info As (
      Select C.EvalTableIDX, C.EvalCateCD, C.EvalCateNm, C.EvalSubCateCD, C.EvalSubCateNm, 
            Case When C.EvalSubCateCD = 0 Then (Select sum_point From cte_point_cate Where EvalCateCD = C.EvalCateCD) 
               Else (Select sum_point From cte_point Where EvalCateCD = C.EvalCateCD And EvalSubCateCD = C.EvalSubCateCD) 
            End As sum_point,
            G1.Point1 As APoint1, G1.Point2 As APoint2, 
            G2.Point1 As BPoint1, G2.Point2 As BPoint2, 
            G3.Point1 As CPoint1, G3.Point2 As CPoint2, 
            G4.Point1 As DPoint1, G4.Point2 As DPoint2, 
            G5.Point1 As EPoint1, G5.Point2 As EPoint2 		
         From cte_cate As C
         Left Join cte_point_group1 As G1 On G1.EvalCateCD = C.EvalCateCD And G1.EvalSubCateCD = C.EvalSubCateCD
         Left Join cte_point_group2 As G2 On G2.EvalCateCD = C.EvalCateCD And G2.EvalSubCateCD = C.EvalSubCateCD
         Left Join cte_point_group3 As G3 On G3.EvalCateCD = C.EvalCateCD And G3.EvalSubCateCD = C.EvalSubCateCD
         Left Join cte_point_group4 As G4 On G4.EvalCateCD = C.EvalCateCD And G4.EvalSubCateCD = C.EvalSubCateCD
         Left Join cte_point_group5 As G5 On G5.EvalCateCD = C.EvalCateCD And G5.EvalSubCateCD = C.EvalSubCateCD
   )

   -- sub 카테고리에 적용한 군별 배점을 합산하여 카테고리별 군별 배점을 구한다. 
   , cte_group_merge As (
      Select EvalCateCD, 
         Sum(APoint1) As APoint1, Sum(APoint2) As APoint2, 
         Sum(BPoint1) As BPoint1, Sum(BPoint2) As BPoint2, 
         Sum(CPoint1) As CPoint1, Sum(CPoint2) As CPoint2, 
         Sum(DPoint1) As DPoint1, Sum(DPoint2) As DPoint2, 
         Sum(EPoint1) As EPoint1, Sum(EPoint2) As EPoint2 
         From cte_info 
         Group By EvalCateCD
   )

   -- 카테고리, Sub카테고리 정보에 배점 정보, 군별 배점 정보를 합하여 보여준다. 
   Select ROW_NUMBER() Over(Partition By I.EvalCateCD Order By I.EvalSubCateCD) As Idx, 
      I.EvalTableIDX, I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, I.sum_point,
      Case When EvalSubCateCD = 0 Then (Select APoint1 From cte_group_merge Where EvalCateCD = I.EvalCateCD ) Else APoint1 End As APoint1 , 
      Case When EvalSubCateCD = 0 Then (Select APoint2 From cte_group_merge Where EvalCateCD = I.EvalCateCD ) Else APoint2 End As APoint2 , 
         
      Case When EvalSubCateCD = 0 Then (Select BPoint1 From cte_group_merge Where EvalCateCD = I.EvalCateCD ) Else BPoint1 End As BPoint1 , 
      Case When EvalSubCateCD = 0 Then (Select BPoint2 From cte_group_merge Where EvalCateCD = I.EvalCateCD ) Else BPoint2 End As BPoint2 , 

      Case When EvalSubCateCD = 0 Then (Select CPoint1 From cte_group_merge Where EvalCateCD = I.EvalCateCD ) Else CPoint1 End As CPoint1 , 
      Case When EvalSubCateCD = 0 Then (Select CPoint2 From cte_group_merge Where EvalCateCD = I.EvalCateCD ) Else CPoint2 End As CPoint2 , 

      Case When EvalSubCateCD = 0 Then (Select DPoint1 From cte_group_merge Where EvalCateCD = I.EvalCateCD ) Else DPoint1 End As DPoint1 , 
      Case When EvalSubCateCD = 0 Then (Select DPoint2 From cte_group_merge Where EvalCateCD = I.EvalCateCD ) Else DPoint2 End As DPoint2 , 

      Case When EvalSubCateCD = 0 Then (Select EPoint1 From cte_group_merge Where EvalCateCD = I.EvalCateCD ) Else EPoint1 End As EPoint1 , 
      Case When EvalSubCateCD = 0 Then (Select EPoint2 From cte_group_merge Where EvalCateCD = I.EvalCateCD ) Else EPoint2 End As EPoint2      
      From cte_info As I 

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 점수 
   '================================================================================= 
   -- 카테고리, sub 카테고리정보를 구한다. 
   ;with cte_info As (
      Select EvalTableIDX, EvalItemIDX, EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm , EvalItemCD, EvalItemNm, EvalTypeCD, EvalTypeNm, StandardPoint
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1
   )

   -- 평가 지표 항목 점수를  sub 카테고리 별로 구한다. 
   , cte_point As (
      Select EvalCateCD, EvalSubCateCD, Sum(StandardPoint) As sum_point
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1 And EvalItemCD > 0
         Group By EvalCateCD, EvalSubCateCD
   )

   -- 평가 지표 항목 점수를  카테고리 별로 구한다. 
   , cte_point_cate As (
      Select EvalCateCD, Sum(sum_point) As sum_point 
         From cte_point 
         Group By EvalCateCD
   )

   , cte_value As (
      Select EvalItemIDX, Round(( Cast(Point As float) /100), 2) As Point From tblEvalValue 
      Where Delkey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
   )

   Select ROW_NUMBER() Over(Partition By I.EvalCateCD Order By I.EvalSubCateCD, I.EvalItemCD) As Idx, 
      I.EvalTableIDX, I.EvalItemIDX, I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, I.EvalItemCD, I.EvalItemNm, 
      Case When I.EvalSubCateCD = 0 Then (Select sum_point From cte_point_cate Where EvalCateCD = I.EvalCateCD) 
         When I.EvalItemCD > 0 Then I.StandardPoint
      Else (Select sum_point From cte_point Where EvalCateCD = I.EvalCateCD And EvalSubCateCD = I.EvalSubCateCD) 
      End As sum_point, I.EvalTypeCD, I.EvalTypeNm, 
      IsNull((Select Point From cte_value Where EvalItemIDX = I.EvalItemIDX), 0) As Point
      From cte_info As I

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 카테고리 
   '================================================================================= 
   -- 카테고리 정보를 구한다. - 평가 지표 합 포함
   Select EvalCateCD, EvalCateNm, Sum(StandardPoint) As sum_point
      From tblEvalItem 
      Where DelKey = 0 And EvalTableIDX = 1
      Group By EvalCateCD, EvalCateNm

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - Sub 카테고리 
   '================================================================================= 
   -- Sub 카테고리 정보를 구한다. - 평가 지표 합 포함
   Select EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm, Sum(StandardPoint) As sum_point
      From tblEvalItem 
      Where DelKey = 0 And EvalTableIDX = 1 And EvalSubCateCD > 0
      Group By EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm

   '=================================================================================
   '  Purpose  : 	평가 지표 - Sub 카테고리별 배점 정보 현황 
   '================================================================================= 
   -- 카테고리, sub 카테고리정보를 구한다. 
   ;with cte_cate As (
      Select EvalTableIDX, EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm 
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1 And EvalSubCateCD > 0 And EvalItemCD = 0 
   )

   -- 평가 지표 항목 점수를  sub 카테고리 별로 구한다. 
   , cte_point As (
      Select EvalCateCD, EvalSubCateCD, Sum(StandardPoint) As sum_point
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1 And EvalItemCD > 0
         Group By EvalCateCD, EvalSubCateCD
   )

   -- 군별 배점을 구한다. (정성, 정량 별) - 가군 
   , cte_point_group1 As (
      Select I.EvalCateCD, I.EvalSubCateCD, 
         Sum( Case When I.EvalTypeCD = 1 Then I.StandardPoint Else 0 End ) As Point1, 
         Sum( Case When I.EvalTypeCD = 2 Then I.StandardPoint Else 0 End ) As Point2 
         From tblEvalItem As I 
         Inner Join tblEvalItem_grp As G On I.EvalItemIDX = G.EvalItemIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalItemCD > 0	
         And G.Delkey = 0 And (G.EvalGroupCD = 0 Or G.EvalGroupCD = 1)
         Group By I.EvalCateCD, I.EvalSubCateCD
   )

   -- 군별 배점을 구한다. (정성, 정량 별) - 나군 
   , cte_point_group2 As (
      Select I.EvalCateCD, I.EvalSubCateCD, 
         Sum( Case When I.EvalTypeCD = 1 Then I.StandardPoint Else 0 End ) As Point1, 
         Sum( Case When I.EvalTypeCD = 2 Then I.StandardPoint Else 0 End ) As Point2 
         From tblEvalItem As I 
         Inner Join tblEvalItem_grp As G On I.EvalItemIDX = G.EvalItemIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalItemCD > 0	
         And G.Delkey = 0 And (G.EvalGroupCD = 0 Or G.EvalGroupCD = 2)
         Group By I.EvalCateCD, I.EvalSubCateCD
   )

   -- 군별 배점을 구한다. (정성, 정량 별) - 다군 
   , cte_point_group3 As (
      Select I.EvalCateCD, I.EvalSubCateCD, 
         Sum( Case When I.EvalTypeCD = 1 Then I.StandardPoint Else 0 End ) As Point1, 
         Sum( Case When I.EvalTypeCD = 2 Then I.StandardPoint Else 0 End ) As Point2 
         From tblEvalItem As I 
         Inner Join tblEvalItem_grp As G On I.EvalItemIDX = G.EvalItemIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalItemCD > 0	
         And G.Delkey = 0 And (G.EvalGroupCD = 0 Or G.EvalGroupCD = 3)
         Group By I.EvalCateCD, I.EvalSubCateCD
   )

   -- 군별 배점을 구한다. (정성, 정량 별) - 라군 
   , cte_point_group4 As (
      Select I.EvalCateCD, I.EvalSubCateCD, 
         Sum( Case When I.EvalTypeCD = 1 Then I.StandardPoint Else 0 End ) As Point1, 
         Sum( Case When I.EvalTypeCD = 2 Then I.StandardPoint Else 0 End ) As Point2 
         From tblEvalItem As I 
         Inner Join tblEvalItem_grp As G On I.EvalItemIDX = G.EvalItemIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalItemCD > 0	
         And G.Delkey = 0 And (G.EvalGroupCD = 0 Or G.EvalGroupCD = 4)
         Group By I.EvalCateCD, I.EvalSubCateCD
   )

   -- 군별 배점을 구한다. (정성, 정량 별) - 마군 
   , cte_point_group5 As (
      Select I.EvalCateCD, I.EvalSubCateCD, 
         Sum( Case When I.EvalTypeCD = 1 Then I.StandardPoint Else 0 End ) As Point1, 
         Sum( Case When I.EvalTypeCD = 2 Then I.StandardPoint Else 0 End ) As Point2 
         From tblEvalItem As I 
         Inner Join tblEvalItem_grp As G On I.EvalItemIDX = G.EvalItemIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1 And I.EvalItemCD > 0	
         And G.Delkey = 0 And (G.EvalGroupCD = 0 Or G.EvalGroupCD = 5)
         Group By I.EvalCateCD, I.EvalSubCateCD
   )

   -- sub Cate 정보에 군별 배점을 적용한다. 
   Select C.EvalTableIDX, C.EvalCateCD, C.EvalCateNm, C.EvalSubCateCD, C.EvalSubCateNm, 
		(Select sum_point From cte_point Where EvalCateCD = C.EvalCateCD And EvalSubCateCD = C.EvalSubCateCD)  As sum_point,
		G1.Point1 As APoint1, G1.Point2 As APoint2, 
		G2.Point1 As BPoint1, G2.Point2 As BPoint2, 
		G3.Point1 As CPoint1, G3.Point2 As CPoint2, 
		G4.Point1 As DPoint1, G4.Point2 As DPoint2, 
		G5.Point1 As EPoint1, G5.Point2 As EPoint2 		
    From cte_cate As C
    Left Join cte_point_group1 As G1 On G1.EvalCateCD = C.EvalCateCD And G1.EvalSubCateCD = C.EvalSubCateCD
    Left Join cte_point_group2 As G2 On G2.EvalCateCD = C.EvalCateCD And G2.EvalSubCateCD = C.EvalSubCateCD
    Left Join cte_point_group3 As G3 On G3.EvalCateCD = C.EvalCateCD And G3.EvalSubCateCD = C.EvalSubCateCD
    Left Join cte_point_group4 As G4 On G4.EvalCateCD = C.EvalCateCD And G4.EvalSubCateCD = C.EvalSubCateCD
    Left Join cte_point_group5 As G5 On G5.EvalCateCD = C.EvalCateCD And G5.EvalSubCateCD = C.EvalSubCateCD


   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 점수 
   '================================================================================= 
    -- 카테고리, sub 카테고리정보를 구한다. 
   ;with cte_info As (
      Select EvalTableIDX, EvalItemIDX, EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm , EvalItemCD, EvalItemNm, EvalTypeCD, EvalTypeNm, StandardPoint
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1 And EvalItemCD > 0
   )

   -- 종목별 점수를 구한다. 
   , cte_value As (
      Select EvalItemIDX, Round(( Cast(Point As float) /100), 2) As Point From tblEvalValue 
      Where Delkey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
   )

   -- 종목별 평가 항목및 점수를 구한다. 
   Select ROW_NUMBER() Over(Partition By I.EvalCateCD Order By I.EvalSubCateCD, I.EvalItemCD) As Idx, 
      I.EvalTableIDX, I.EvalItemIDX, I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, I.EvalItemCD, I.EvalItemNm, 
      I.StandardPoint, I.EvalTypeCD, I.EvalTypeNm, V.Point
      From cte_info As I
      Inner Join cte_value As V On V.EvalItemIDX = I.EvalItemIDX

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 의견 
   '================================================================================= 
   -- 카테고리, sub 카테고리정보를 구한다. 
   ;with cte_info As (
      Select EvalTableIDX, EvalItemIDX, EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm , EvalItemCD, EvalItemNm
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1 And EvalItemCD > 0
   )

   -- 종목별 평가 항목 의견을 구한다. 
   , cte_value As (
      Select EvalItemIDX, EvalDesc From tblEvalValue 
      Where Delkey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
   )

   -- 종목별 평가 항목및 의견를 구한다. 
   Select ROW_NUMBER() Over(Partition By I.EvalCateCD Order By I.EvalSubCateCD, I.EvalItemCD) As Idx, 
      I.EvalTableIDX, I.EvalItemIDX, I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, I.EvalItemCD, I.EvalItemNm, 
      V.EvalDesc
      From cte_info As I
      Inner Join cte_value As V On V.EvalItemIDX = I.EvalItemIDX

   
   '=================================================================================
   '  Purpose  : 	평가 지표 통계 - 카테고리별 
   '================================================================================= 
   Declare @group_code int , @cnt_group int, @cnt_association int

   -- 협회 코드를 받아서 협회가 속한 평가군 코드를 얻는다. (가,나,다,라,마 군)
   Select @group_code = EvalGroupCD
         From tblAssociation_sub
         Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1

   -- 협회 평가군 count를 구한다. 
   Select @cnt_group = Count(EvalGroupCD)
         From tblAssociation_sub
         Where DelKey = 0 And EvalTableIDX = 1 And EvalGroupCD = @group_code

   -- 협회 전체 count를 구한다. 
   Select @cnt_association = Count(AssociationIDX)
         From tblAssociation_sub
         Where DelKey = 0 And EvalTableIDX = 1 
         
   -- 카테고리 정보를 구한다. - 평가 지표 합 포함
   ;with cte_cate As (
      Select EvalCateCD, EvalCateNm, Sum(StandardPoint) As base_point
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1
         Group By EvalCateCD, EvalCateNm
   )

   -- 평가 카테고리에 대한 획득 총합을 구한다. (특정 종목)
   , cte_point As (
      Select EvalCateCD, Round(Cast(Sum(Point) As Float) /100, 1) As Point  
            From tblEvalValue 
            Where AssociationIDX = 1 And EvalTypeCD < 100		-- 감점은 제외한다. 
            Group By EvalCateCD
   )


   , cte_point_group As (
      Select EvalCateCD, Round(Cast(Sum(Point) As Float) /(@cnt_group * 100), 1) As Point
            From tblEvalValue 
            Where EvalGroupCD = @group_code And EvalTypeCD < 100		-- 감점은 제외한다. 
            Group By EvalCateCD
   )

   , cte_point_all As (
      Select EvalCateCD, Round(Cast(Sum(Point) As Float) /(@cnt_association * 100), 1) As Point, Sum(Point) As sum_point, @cnt_association As cnt_total
            From tblEvalValue 
			Where EvalTypeCD < 100		-- 감점은 제외한다. 
            Group By EvalCateCD
   )

   Select ROW_NUMBER() Over(Order By C.EvalCateCD) As Idx, 
      C.EvalCateCD, C.EvalCateNm, C.base_point, 
      P.Point As point_assoc, Round( (Cast(P.Point As Float) / C.base_point * 100) , 1) As percent_assoc, 
      G.Point As point_group, Round( (Cast(G.Point As Float) / C.base_point * 100) , 1) As percent_group, 
      A.Point As point_total, Round( (Cast(A.Point As Float) / C.base_point * 100) , 1) As percent_total
   From cte_cate As C 
   Inner Join cte_point As P On P.EvalCateCD = C.EvalCateCD
   Inner Join cte_point_group As G On G.EvalCateCD = C.EvalCateCD
   Inner Join cte_point_all As A On A.EvalCateCD = C.EvalCateCD

   '=================================================================================
   '  Purpose  : 	평가 지표 통계 - Sub 카테고리별 
   '================================================================================= 
   Declare @group_code int , @cnt_group int, @cnt_association int

   -- 협회 코드를 받아서 협회가 속한 평가군 코드를 얻는다. (가,나,다,라,마 군)
   Select @group_code = EvalGroupCD
         From tblAssociation_sub
         Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1

   -- 협회 평가군 count를 구한다. 
   Select @cnt_group = Count(EvalGroupCD)
         From tblAssociation_sub
         Where DelKey = 0 And EvalTableIDX = 1 And EvalGroupCD = @group_code

   -- 협회 전체 count를 구한다. 
   Select @cnt_association = Count(AssociationIDX)
         From tblAssociation_sub
         Where DelKey = 0 And EvalTableIDX = 1 
               
   -- 카테고리 정보를 구한다. - 평가 지표 합 포함
   ;with cte_subcate As (
      Select EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm, Sum(StandardPoint) As base_point
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1 And EvalSubCateCD > 0
         Group By EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm
   )

   -- 평가 카테고리에 대한 획득 총합을 구한다. (특정 종목)
   , cte_point As (
      Select EvalCateCD, EvalSubCateCD, Round(Cast(Sum(Point) As Float) /100, 1) As Point  
            From tblEvalValue 
            Where AssociationIDX = 1
			And EvalTypeCD < 100		-- 감점은 제외한다. 
            Group By EvalCateCD, EvalSubCateCD
   )


   , cte_point_group As (
      Select EvalCateCD, EvalSubCateCD, Round(Cast(Sum(Point) As Float) /(@cnt_group * 100), 1) As Point
            From tblEvalValue 
            Where EvalGroupCD = @group_code
			And EvalTypeCD < 100		-- 감점은 제외한다. 
            Group By EvalCateCD, EvalSubCateCD
   )

   , cte_point_all As (
      Select EvalCateCD, EvalSubCateCD, Round(Cast(Sum(Point) As Float) /(@cnt_association * 100), 1) As Point, Sum(Point) As sum_point, @cnt_association As cnt_total
            From tblEvalValue 
			Where EvalTypeCD < 100		-- 감점은 제외한다. 
            Group By EvalCateCD, EvalSubCateCD
   )

   Select ROW_NUMBER() Over(Order By C.EvalCateCD) As Idx, 
      C.EvalCateCD, C.EvalCateNm, C.EvalSubCateCD, C.EvalSubCateNm, C.base_point, 
      P.Point As point_assoc, Round( (Cast(P.Point As Float) / C.base_point * 100) , 1) As percent_assoc, 
      G.Point As point_group, Round( (Cast(G.Point As Float) / C.base_point * 100) , 1) As percent_group, 
      A.Point As point_total, Round( (Cast(A.Point As Float) / C.base_point * 100) , 1) As percent_total
   From cte_subcate As C 
   Inner Join cte_point As P On P.EvalCateCD = C.EvalCateCD And P.EvalSubCateCD = C.EvalSubCateCD
   Inner Join cte_point_group As G On G.EvalCateCD = C.EvalCateCD And G.EvalSubCateCD = C.EvalSubCateCD
   Inner Join cte_point_all As A On A.EvalCateCD = C.EvalCateCD And A.EvalSubCateCD = C.EvalSubCateCD



   '=================================================================================
   '  Purpose  : 	평가 지표 통계 - Item 별 
   '================================================================================= 
   Declare @group_code int , @cnt_group int, @cnt_association int

   -- 협회 코드를 받아서 협회가 속한 평가군 코드를 얻는다. (가,나,다,라,마 군)
   Select @group_code = EvalGroupCD
         From tblAssociation_sub
         Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1

   -- 협회 평가군 count를 구한다. 
   Select @cnt_group = Count(EvalGroupCD)
         From tblAssociation_sub
         Where DelKey = 0 And EvalTableIDX = 1 And EvalGroupCD = @group_code

   -- 협회 전체 count를 구한다. 
   Select @cnt_association = Count(AssociationIDX)
         From tblAssociation_sub
         Where DelKey = 0 And EvalTableIDX = 1 
               
   -- 카테고리 정보를 구한다. - 평가 지표 합 포함
   ;with cte_item As (
      Select EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm, EvalItemCD, EvalItemNm, 
         Sum(StandardPoint) As base_point
   --		Case When Sum(StandardPoint) = 0 Then 1 Else Sum(StandardPoint) End As base_point
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1 And EvalItemCD > 0
      And EvalTypeCD < 100		-- 감점은 제외한다. 
         Group By EvalCateCD, EvalCateNm, EvalSubCateCD, EvalSubCateNm, EvalItemCD, EvalItemNm
   )

   -- 평가 카테고리에 대한 획득 총합을 구한다. (특정 종목)
   , cte_point As (
      Select EvalCateCD, EvalSubCateCD, EvalItemCD, Round(Cast(Sum(Point) As Float) /100, 1) As Point  
            From tblEvalValue 
            Where AssociationIDX = 1
            Group By EvalCateCD, EvalSubCateCD, EvalItemCD
   )

   , cte_point_group As (
      Select EvalCateCD, EvalSubCateCD, EvalItemCD, Round(Cast(Sum(Point) As Float) /(@cnt_group * 100), 1) As Point
            From tblEvalValue 
            Where EvalGroupCD = @group_code
            Group By EvalCateCD, EvalSubCateCD, EvalItemCD
   )

   , cte_point_all As (
      Select EvalCateCD, EvalSubCateCD, EvalItemCD, Round(Cast(Sum(Point) As Float) /(@cnt_association * 100), 1) As Point
            From tblEvalValue 
            Group By EvalCateCD, EvalSubCateCD, EvalItemCD
   )

   Select ROW_NUMBER() Over(Order By I.EvalCateCD) As Idx, 
      I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, I.EvalItemCD, I.EvalItemNm, I.base_point, 
      P.Point As point_assoc, Round( (Cast(P.Point As Float) / I.base_point * 100) , 1) As percent_assoc, 
      G.Point As point_group, Round( (Cast(G.Point As Float) / I.base_point * 100) , 1) As percent_group, 
      A.Point As point_total, Round( (Cast(A.Point As Float) / I.base_point * 100) , 1) As percent_total
   From cte_item As I 
   Inner Join cte_point As P On P.EvalCateCD = I.EvalCateCD And P.EvalSubCateCD = I.EvalSubCateCD  And P.EvalItemCD = I.EvalItemCD
   Inner Join cte_point_group As G On G.EvalCateCD = I.EvalCateCD And G.EvalSubCateCD = I.EvalSubCateCD  And G.EvalItemCD = I.EvalItemCD
   Inner Join cte_point_all As A On A.EvalCateCD = I.EvalCateCD And A.EvalSubCateCD = I.EvalSubCateCD  And A.EvalItemCD = I.EvalItemCD

   '=================================================================================
   '  Purpose  : 	평가 보고서 - 총평
   '=================================================================================   
   Select EvalText From tblAssociation_sub 
	   Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1

   '=================================================================================
   '  Purpose  : 	종목 비교 평가
   '=================================================================================  
      -- 2개의 측정 기간, 측정 단체를 입력받아 데이터를 비교한다. 
   -- 카테고리 정보를 구한다. - 평가 지표 합 포함
   ;with cte_cate As (
      Select EvalCateCD, EvalCateNm, Sum(StandardPoint) As base_point
         From tblEvalItem 
         Where DelKey = 0 And EvalTableIDX = 1
         Group By EvalCateCD, EvalCateNm
   )

   -- 평가 카테고리에 대한 획득 총합을 구한다. (특정 종목)
   , cte_point As (
      Select EvalCateCD, Round(Cast(Sum(Point) As Float) /100, 1) As Point  
            From tblEvalValue 
            Where AssociationIDX = 1 And EvalTypeCD < 100		-- 감점은 제외한다. 
            Group By EvalCateCD
   )

   Select C.EvalCateCD, C.EvalCateNm, C.base_point, P.Point, 
    Round( (Cast(P.Point As Float) / C.base_point * 100) , 1) As percent_assoc
	From cte_cate As C 
	Inner Join cte_point As P On P.EvalCateCD = C.EvalCateCD

   
   '=================================================================================
   '  Purpose  : 	종목군 종합평가 
   '================================================================================= 
   -- 종목군 평가 
   -- 종목군 Count를 구한다. 
   ;with cte_group As (
      Select EvalGroupCD, Count(EvalGroupCD) As cnt_group
         From tblAssociation_sub
         Where DelKey = 0 
         Group By EvalGroupCD
   )

   -- 카테고리 별 총점 구함 
   , cte_cate As (
      Select EvalCateCD, EvalCateNm, Sum(StandardPoint) As base_point
            From tblEvalItem 
            Where DelKey = 0 And EvalTableIDX = 1
            Group By EvalCateCD, EvalCateNm
   )

   , cte_point As (
         Select V.EvalGroupCD, V.EvalCateCD, Round(Cast(Sum(V.Point) As Float) /(100 * G.cnt_group), 1) As Point  
               From tblEvalValue As V 
            Inner Join cte_group As G On G.EvalGroupCD = V.EvalGroupCD
               Where V.DelKey = 0 And V.EvalTypeCD < 100		-- 감점은 제외한다. 
               Group By V.EvalGroupCD, V.EvalCateCD, cnt_group
      )

   Select ROW_NUMBER() Over(Order By C.EvalCateCD) As Idx, 
      C.EvalCateCD, C.EvalCateNm, C.base_point, 
      (Select Point From cte_point Where EvalGroupCD = 1 And EvalCateCD = C.EvalCateCD) As point_group1, 
      (Select Point From cte_point Where EvalGroupCD = 2 And EvalCateCD = C.EvalCateCD) As point_group2, 
      (Select Point From cte_point Where EvalGroupCD = 3 And EvalCateCD = C.EvalCateCD) As point_group3, 
      (Select Point From cte_point Where EvalGroupCD = 4 And EvalCateCD = C.EvalCateCD) As point_group4, 
      (Select Point From cte_point Where EvalGroupCD = 5 And EvalCateCD = C.EvalCateCD) As point_group5 
      From cte_cate As C

%>
