
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
   '  Purpose  : 	평가 지표 결과 - 통계 협회별 카테고리 점수 
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
   ;with cte_group As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
		And EvalGroupCD = 1
   )

   -- 카테고리 정보를 구한다. - 평가 지표 합 포함
   , cte_cate As (
	   Select ROW_NUMBER() Over(Order By I.EvalCateCD) As Idx, 
		  I.EvalCateCD, I.EvalCateNm, Sum(G.StandardPoint) As base_point
		  From tblEvalItemType As I 
		  Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX
		  Where I.DelKey = 0 And I.EvalTableIDX = 1
		  Group By I.EvalCateCD, I.EvalCateNm
	)
   
   -- 평가 카테고리에 대한 획득 총합을 구한다. (특정 종목)
   , cte_point As (
		Select EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
			From (
			Select EvalCateCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
				From tblEvalValue
				Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
				And EvalTypeCD < 100
				Group By EvalCateCD, EvalItemTypeIDX
		) As C 
   )

   , cte_point_merge As (
		Select EvalCateCD , Sum(Point) As Point 
			From cte_point
		Group By EvalCateCD
   )
   	 
   -- 평가 카테고리에 대한 획득 총합을 구한다. (Group)
   , cte_point_group As (
		Select EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
			From (
			Select EvalCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
				From tblEvalValue
				Where DelKey = 0 And EvalTableIDX = 1 And EvalGroupCD = @group_code
				And EvalTypeCD < 100
				Group By EvalCateCD, EvalItemTypeIDX
		) As C 
   )

   , cte_point_group_merge As (
		Select EvalCateCD , Sum(Point) As Point 
			From cte_point_group
		Group By EvalCateCD
   )

   -- 평가 카테고리에 대한 획득 총합을 구한다. (Group)
   , cte_point_all As (
		Select EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
			From (
			Select EvalCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
				From tblEvalValue
				Where DelKey = 0 And EvalTableIDX = 1
				And EvalTypeCD < 100
				Group By EvalCateCD, EvalItemTypeIDX
		) As C 
   )

   , cte_point_all_merge As (
		Select EvalCateCD , Sum(Point) As Point 
			From cte_point_all
		Group By EvalCateCD
   )


  Select ROW_NUMBER() Over(Order By C.EvalCateCD) As Idx, 
      C.EvalCateCD, C.EvalCateNm, C.base_point, 
      P.Point As point_assoc, Round( (Cast(P.Point As Float) / C.base_point * 100) , 1) As percent_assoc, 
      G.Point As point_group, Round( (Cast(G.Point As Float) / C.base_point * 100) , 1) As percent_group, 
      A.Point As point_total, Round( (Cast(A.Point As Float) / C.base_point * 100) , 1) As percent_total
   From cte_cate As C 
   Inner Join cte_point_merge As P On P.EvalCateCD = C.EvalCateCD
   Inner Join cte_point_group_merge As G On G.EvalCateCD = C.EvalCateCD
   Inner Join cte_point_all_merge As A On A.EvalCateCD = C.EvalCateCD

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 통계 협회별  Sub 카테고리 점수 
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

         
   -- 평가 항목 평가 타입별 배점을 구한다. 
   ;with cte_group As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
		And EvalGroupCD = 1
   )

   -- Sub 카테고리 정보를 구한다. - 평가 지표 합 포함
   , cte_subcate As (
	   Select I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, Sum(G.StandardPoint) As base_point
		  From tblEvalItemType As I 
		  Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX
		  Where I.DelKey = 0 And I.EvalTableIDX = 1
		  Group By I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm
	)
   
   -- 평가 Sub 카테고리에 대한 획득 총합을 구한다. (특정 종목)
   , cte_point As (
		Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
			From (
			Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
				From tblEvalValue
				Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
				And EvalTypeCD < 100
				Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX
		) As C 
   )

   , cte_point_merge As (
		Select EvalCateCD , EvalSubCateCD, Sum(Point) As Point 
			From cte_point
		Group By EvalCateCD, EvalSubCateCD
   )
   	 
   -- 평가 카테고리에 대한 획득 총합을 구한다. (Group)
   , cte_point_group As (
		Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
			From (
			Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
				From tblEvalValue
				Where DelKey = 0 And EvalTableIDX = 1 And EvalGroupCD = @group_code
				And EvalTypeCD < 100
				Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX
		) As C 
   )

   , cte_point_group_merge As (
		Select EvalCateCD , EvalSubCateCD, Sum(Point) As Point 
			From cte_point_group
		Group By EvalCateCD, EvalSubCateCD
   )

   -- 평가 카테고리에 대한 획득 총합을 구한다. (Group)
   , cte_point_all As (
		Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
			From (
			Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
				From tblEvalValue
				Where DelKey = 0 And EvalTableIDX = 1
				And EvalTypeCD < 100
				Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX
		) As C 
   )

   , cte_point_all_merge As (
		Select EvalCateCD , EvalSubCateCD, Sum(Point) As Point 
			From cte_point_all
		Group By EvalCateCD, EvalSubCateCD
   )


  Select ROW_NUMBER() Over(Partition By S.EvalCateCD Order By S.EvalSubCateCD) As Idx, 
	  S.EvalCateCD, S.EvalCateNm, S.EvalSubCateCD, S.EvalSubCateNm, S.base_point, 
      P.Point As point_assoc, Round( (Cast(P.Point As Float) / S.base_point * 100) , 1) As percent_assoc, 
      G.Point As point_group, Round( (Cast(G.Point As Float) / S.base_point * 100) , 1) As percent_group, 
      A.Point As point_total, Round( (Cast(A.Point As Float) / S.base_point * 100) , 1) As percent_total
   From cte_subcate As S 
   Inner Join cte_point_merge As P On P.EvalCateCD = S.EvalCateCD And  P.EvalSubCateCD = S.EvalSubCateCD
   Inner Join cte_point_group_merge As G On G.EvalCateCD = S.EvalCateCD And  G.EvalSubCateCD = S.EvalSubCateCD
   Inner Join cte_point_all_merge As A On A.EvalCateCD = S.EvalCateCD And  A.EvalSubCateCD = S.EvalSubCateCD

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 통계 협회별  평가항목 점수 
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

         
   -- 평가 항목 평가 타입별 배점을 구한다. 
   ;with cte_group As (
   Select * 
      From tblEvalItemTypeGroup 
      Where DelKey = 0 And EvalTableIDX = 1
      And EvalGroupCD = 1
   )

   -- 평가항목 정보를 구한다. - 평가 지표 합 포함
   , cte_item As (
      Select I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, I.EvalItemCD, I.EvalItemNm, I.EvalItemTypeIDX, G.StandardPoint As base_point
      From tblEvalItemType As I 
      Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX
      Where I.DelKey = 0 And I.EvalTableIDX = 1
   )

   -- 평가 Sub 카테고리에 대한 획득 총합을 구한다. (특정 종목)
   , cte_point As (
      Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
         From (
         Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
            From tblEvalValue
            Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
            And EvalTypeCD < 100
            Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX
      ) As C 
   )
      
   -- 평가 카테고리에 대한 획득 총합을 구한다. (Group)
   , cte_point_group As (
      Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
         From (
         Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
            From tblEvalValue
            Where DelKey = 0 And EvalTableIDX = 1 And EvalGroupCD = @group_code
            And EvalTypeCD < 100
            Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX
      ) As C 
   )

   -- 평가 카테고리에 대한 획득 총합을 구한다. (Group)
   , cte_point_all As (
      Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
         From (
         Select EvalCateCD, EvalSubCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
            From tblEvalValue
            Where DelKey = 0 And EvalTableIDX = 1
            And EvalTypeCD < 100
            Group By EvalCateCD, EvalSubCateCD, EvalItemTypeIDX
      ) As C 
   )

   Select ROW_NUMBER() Over(Partition By I.EvalCateCD Order By I.EvalSubCateCD, I.EvalItemCD) As Idx, 
   I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, I.EvalItemCD, I.EvalItemNm, I.base_point, 
      P.Point As point_assoc, G.Point As point_group, A.Point As point_total
   From cte_item As I 
   Inner Join cte_point As P		On P.EvalCateCD = I.EvalCateCD And  P.EvalSubCateCD = I.EvalSubCateCD And  P.EvalItemTypeIDX = I.EvalItemTypeIDX
   Inner Join cte_point_group As G	On G.EvalCateCD = I.EvalCateCD And  G.EvalSubCateCD = I.EvalSubCateCD And  G.EvalItemTypeIDX = I.EvalItemTypeIDX
   Inner Join cte_point_all As A	On A.EvalCateCD = I.EvalCateCD And  A.EvalSubCateCD = I.EvalSubCateCD And  A.EvalItemTypeIDX = I.EvalItemTypeIDX
   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 통계 협회별  감점
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
            
   -- 감점 평가 항목을 구한다. 
   ;with cte_item As (
   Select EvalItemTypeIDX, EvalItemIdx, EvalItemCD, EvalItemNm
      From tblEvalItemType
      Where DelKey = 0 And EvalTableIDX = 1
      And EvalTypeCD = 100
   )

   -- 감점 항목에 대한 획득 총합을 구한다. (특정 종목)
   , cte_point As (
      Select EvalItemTypeIDX, EvalItemIdx, Round(Cast(PointCalc As Float) /100, 1)  As Point 
         From tblEvalValue
      Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
      And EvalTypeCD = 100
   )

   -- 감점 항목에 대한 획득 총합을 구한다. (Group)
   , cte_point_group As (
      Select EvalItemTypeIDX, EvalItemIdx, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
         From (
         Select EvalItemTypeIDX, EvalItemIdx, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
            From tblEvalValue
            Where DelKey = 0 And EvalTableIDX = 1 And EvalGroupCD = @group_code
            And EvalTypeCD =100
            Group By EvalItemTypeIDX, EvalItemIdx
      ) As C 
   )

   -- 감점 항목에 대한 획득 총합을 구한다. (Group)
   , cte_point_all As (
      Select EvalItemTypeIDX, EvalItemIdx, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
         From (
         Select EvalItemTypeIDX, EvalItemIdx, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
            From tblEvalValue
            Where DelKey = 0 And EvalTableIDX = 1
            And EvalTypeCD = 100
            Group By EvalItemTypeIDX, EvalItemIdx
      ) As C 
   )

   -- 감점 항목에 대한 정보를 보여준다. 
   Select 
      I.EvalItemTypeIDX, I.EvalItemIdx, I.EvalItemCD, I.EvalItemNm, 
      P.Point As point_assoc, G.Point As point_group, A.Point As point_total
   From cte_item As I 
   Inner Join cte_point As P On P.EvalItemTypeIDX = I.EvalItemTypeIDX
   Inner Join cte_point_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX
   Inner Join cte_point_all As A On A.EvalItemTypeIDX = I.EvalItemTypeIDX

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 협회별 감점 점수, 총평을 얻는다. 
   '================================================================================= 
   -- 협회별 감점 점수를 얻는다. 
   with cte_subtract As (
      Select Round(Cast(PointCalc As Float) /100, 1) As subtract_point 
         From tblEvalValue
         Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
         And EvalTypeCD = 100
   )

   -- 협회별 대한 총평을 얻는다. 
   , cte_eval_desc As (
      Select EvalText As total_desc 
         From tblAssociation_sub
         Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
   )

   Select (Select subtract_point From cte_subtract) As subtract_point, total_desc
      From cte_eval_desc

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 협회별 감점 정보를 얻는다. 
   '================================================================================= 
   -- 협회의 감점 정보를 얻는다. 
   Select T.EvalItemCD, T.EvalItemNm, 
         Round(Cast(V.PointCalc As Float) /100, 1) As subtract_point 
         From tblEvalValue As V
         Inner Join tblEvalItemType As T On T.EvalItemTypeIDX = V.EvalItemTypeIDX
         Where V.DelKey = 0 And V.EvalTableIDX = 1 
         And V.AssociationIDX = 1 And V.EvalTypeCD = 100
         And T.DelKey = 0 And T.EvalTableIDX = 1 

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 통계 평가군별 카테고리 점수 
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
   ;with cte_group As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
		And EvalGroupCD = 1
   )

   -- 카테고리 정보를 구한다. - 평가 지표 합 포함
   , cte_cate As (
	   Select ROW_NUMBER() Over(Order By I.EvalCateCD) As Idx, 
		  I.EvalCateCD, I.EvalCateNm, Sum(G.StandardPoint) As base_point
		  From tblEvalItemType As I 
		  Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX
		  Where I.DelKey = 0 And I.EvalTableIDX = 1
		  Group By I.EvalCateCD, I.EvalCateNm
	)
   
   -- 평가 카테고리에 대한 획득 총합을 구한다. (특정 종목)
   , cte_point As (
		Select EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
			From (
			Select EvalCateCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
				From tblEvalValue
				Where DelKey = 0 And EvalTableIDX = 1 And AssociationIDX = 1
				And EvalTypeCD < 100
				Group By EvalCateCD, EvalItemTypeIDX
		) As C 
   )

   , cte_point_merge As (
		Select EvalCateCD , Sum(Point) As Point 
			From cte_point
		Group By EvalCateCD
   )
   	 
   -- 평가 카테고리에 대한 획득 총합을 구한다. (Group)
   , cte_point_group As (
		Select EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
			From (
			Select EvalCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
				From tblEvalValue
				Where DelKey = 0 And EvalTableIDX = 1 And EvalGroupCD = @group_code
				And EvalTypeCD < 100
				Group By EvalCateCD, EvalItemTypeIDX
		) As C 
   )

   , cte_point_group_merge As (
		Select EvalCateCD , Sum(Point) As Point 
			From cte_point_group
		Group By EvalCateCD
   )

   -- 평가 카테고리에 대한 획득 총합을 구한다. (Group)
   , cte_point_all As (
		Select EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
			From (
			Select EvalCateCD, EvalItemTypeIDX, Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
				From tblEvalValue
				Where DelKey = 0 And EvalTableIDX = 1
				And EvalTypeCD < 100
				Group By EvalCateCD, EvalItemTypeIDX
		) As C 
   )

   , cte_point_all_merge As (
		Select EvalCateCD , Sum(Point) As Point 
			From cte_point_all
		Group By EvalCateCD
   )


  Select ROW_NUMBER() Over(Order By C.EvalCateCD) As Idx, 
      C.EvalCateCD, C.EvalCateNm, C.base_point, 
      P.Point As point_assoc, Round( (Cast(P.Point As Float) / C.base_point * 100) , 1) As percent_assoc, 
      G.Point As point_group, Round( (Cast(G.Point As Float) / C.base_point * 100) , 1) As percent_group, 
      A.Point As point_total, Round( (Cast(A.Point As Float) / C.base_point * 100) , 1) As percent_total
   From cte_cate As C 
   Inner Join cte_point_merge As P On P.EvalCateCD = C.EvalCateCD
   Inner Join cte_point_group_merge As G On G.EvalCateCD = C.EvalCateCD
   Inner Join cte_point_all_merge As A On A.EvalCateCD = C.EvalCateCD

   '=================================================================================
   '  Purpose  : 	종목군 종합 평가 - 카테고리
   '================================================================================= 
   -- 카테고리 정보를 구한다 가군을 기준으로 구한다. 
   ;with cte_group As (
      Select * 
         From tblEvalItemTypeGroup 
         Where DelKey = 0 And EvalTableIDX = 1
		 And EvalGroupCD = 1
   )

   -- 카테고리 정보를 구한다. - 평가 지표 합 포함
   , cte_cate As (
      Select ROW_NUMBER() Over(Order By I.EvalCateCD) As Idx, 
         I.EvalCateCD, I.EvalCateNm, Sum(G.StandardPoint) As base_point
         From tblEvalItemType As I 
         Inner Join cte_group As G On G.EvalItemTypeIDX = I.EvalItemTypeIDX
         Where I.DelKey = 0 And I.EvalTableIDX = 1
         Group By I.EvalCateCD, I.EvalCateNm
   )
   
   -- 카테고리별, 평가군 점수를 구한다. 
	Select  ROW_NUMBER() Over(Order By C.EvalCateCD) As Idx, 
		C.EvalCateCD, C.EvalCateNm, C.base_point
		From cte_cate As C 


   '=================================================================================
   '  Purpose  : 	종목군 종합 평가 - 평가군별 카테고리 점수 
   '================================================================================= 
   -- 평가군별, 카테고리별, 평가 항목별 점수를 구한다. 
   with cte_point As (
      Select EvalGroupCD, EvalCateCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
         From (
         Select EvalGroupCD, EvalCateCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
            From tblEvalValue
            Where DelKey = 0 And EvalTableIDX = 1
            And EvalTypeCD < 100
            Group By EvalGroupCD, EvalCateCD, EvalItemTypeIDX
      ) As C 
   )

  -- 평가군별, 카테고리별 평가 점수를 구한다. 
   , cte_point_merge As (
         Select EvalGroupCD, EvalCateCD, Sum(Point) As Point 
            From cte_point
         Group By EvalGroupCD, EvalCateCD
   )

   Select ROW_NUMBER() Over(Partition By EvalCateCD Order By EvalGroupCD) As Idx, 
		EvalGroupCD, EvalCateCD, Point 
	From cte_point_merge


   '=================================================================================
   '  Purpose  : 	종목군 종합 평가 - 평가군별 총합 
   '================================================================================= 
   -- 평가 군별 , 평가 항목별 평가 점수를 구한다. 
   ;with cte_point As (
      Select EvalGroupCD, EvalItemTypeIDX, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As Point  
         From (
         Select EvalGroupCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
            From tblEvalValue
            Where DelKey = 0 And EvalTableIDX = 1
            And EvalTypeCD < 100
            Group By EvalGroupCD, EvalItemTypeIDX
      ) As C 
   )

   -- 평가군별 평가 항목의 합을 구한다. 
   , cte_info As (
		Select EvalGroupCD, Sum(Point) As Point 
            From cte_point
         Group By EvalGroupCD
   )

   -- 평가 군별 평가 점수 합을 구한다. 
	Select EvalGroupCD, Point	From cte_info

   '=================================================================================
   '  Purpose  : 	종목군 종합 평가 - 감점 평균
   '=================================================================================    
   -- 감점 점수를 구한다 .
   ;with cte_subtract As (
      Select EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
               From tblEvalValue
               Where DelKey = 0 And EvalTableIDX = 1
               And EvalTypeCD = 100
               Group By EvalItemTypeIDX
   )

   -- 감점 점수의 평균을 구한다. 
   Select  S.EvalItemTypeIDX, T.EvalItemCD, T.EvalItemNm, Round(Cast(S.sum_point As Float) /(S.cnt_val *100), 1) As subtract_point 
      From cte_subtract As S 
      Inner Join tblEvalItemType As T On T.EvalItemTypeIDX = S.EvalItemTypeIDX
      Where T.DelKey = 0 And T.EvalTableIDX = 1

   '=================================================================================
   '  Purpose  : 	종목군 종합 평가 - 감점 평균 군별로 
   '=================================================================================    
   -- 감점 점수를 구한다 .
   ;with cte_subtract As (
      Select EvalGroupCD, EvalItemTypeIDX,  Count(EvalValueIDX) As cnt_val, Sum(PointCalc) As sum_point 
               From tblEvalValue
               Where DelKey = 0 And EvalTableIDX = 1
               And EvalTypeCD = 100
               Group By EvalGroupCD, EvalItemTypeIDX
   )

   -- 감점 점수의 평균을 구한다. 
   Select  EvalGroupCD, Round(Cast(sum_point As Float) /(cnt_val *100), 1) As subtract_point 
      From cte_subtract

   '=================================================================================
   '  Purpose  : 	평가보고서 - 카테고리 항목
   '=================================================================================  
   Select ROW_NUMBER() Over(Order By EvalCateCD) As Idx, 
      EvalCateCD, EvalCateNm
      From tblEvalItem
      Where DelKey = 0 And EvalTableIDX = 1
      And EvalSubCateCD = 0

            
%>
