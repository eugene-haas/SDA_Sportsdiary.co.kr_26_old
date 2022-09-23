
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
   '  Purpose  : 	평가 지표 결과 - 그룹별 카테고리 
   '================================================================================= 
   -- 평가군별 평가 배점을 구한다. 
   ;with cte_group As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
   )

   -- Sub 카테고리 정보를 구한다. - 평가 지표 합 포함
   Select Row_Number() Over(Partition By G.EvalGroupCD Order By I.EvalCateCD) As Idx, 
	  G.EvalGroupCD, G.EvalGroupNm, I.EvalCateCD, I.EvalCateNm, Sum(G.StandardPoint) As sum_point
      From tblEvalItem As I
	  Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX
      Where I.DelKey = 0 And I.EvalTableIDX = 1
      Group By G.EvalGroupCD, G.EvalGroupNm, I.EvalCateCD, I.EvalCateNm

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 그룹별 Sub 카테고리 
   '================================================================================= 
   -- 평가군별 평가 배점을 구한다.
   ;with cte_group As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
   )

   -- Sub 카테고리 정보를 구한다. - 평가 지표 합 포함
   Select Row_Number() Over(Partition By G.EvalGroupCD Order By I.EvalCateCD, I.EvalSubCateCD) As Idx, 
	  G.EvalGroupCD, G.EvalGroupNm, I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm, Sum(G.StandardPoint) As sum_point
      From tblEvalItem As I
	  Inner Join cte_group As G On G.EvalItemIDX = I.EvalItemIDX
      Where I.DelKey = 0 And I.EvalTableIDX = 1 
      Group By G.EvalGroupCD, G.EvalGroupNm, I.EvalCateCD, I.EvalCateNm, I.EvalSubCateCD, I.EvalSubCateNm
   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 그룹별 평가 항목 타입 
   '================================================================================= 
   -- 평가군별 평가 배점을 구한다.
   ;with cte_group As (
	 Select * 
		From tblEvalItemTypeGroup 
		Where DelKey = 0 And EvalTableIDX = 1
   )

   -- 평가 항목 지표를 구한다. - 평가 방법 포함
   Select Row_Number() Over(Partition By G.EvalGroupCD Order By T.EvalCateCD, T.EvalSubCateCD, T.EvalItemCD) As Idx, 
	  G.EvalGroupCD, G.EvalGroupNm, T.EvalItemTypeIdx, T.EvalItemIDX, T.EvalCateCD, T.EvalCateNm, T.EvalSubCateCD, T.EvalSubCateNm, 
	  T.EvalItemCD, T.EvalItemNm, G.StandardPoint, T.EvalTypeCD, T.EvalTypeNm
      From tblEvalItemType As T
	  Inner Join cte_group As G On G.EvalItemTypeIdx = T.EvalItemTypeIdx
      Where T.DelKey = 0 And T.EvalTableIDX = 1

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 평가자 List 
   '================================================================================= 
   -- 평가자를 구한다. 
   ;with cte_eval_member As (
		Select * From tblEvalMember
			Where DelKey = 0 And EvalTableIDX = 1
   )

   -- 정량 평가 , 감점 평가의 경우 최고 관리자로 , 
   -- 정성일 경우 등록된 평가자를 뿌려 준다. 
   Select Row_Number() Over(Order By T.EvalItemTypeIDX) As Idx, 
		T.EvalItemTypeIDX, T.EvalItemCD, IsNull(M.AdminMemberIdx, 0) As AdminMemberIdx, 
		Case When T.EvalTypeCD In (2, 100) Then '최고관리자'
			Else IsNull(M.AdminName, '') End As EvalName
	From tblEvalItemType As T 
	Left Join cte_eval_member As M On M.EvalItemTypeIDX = T.EvalItemTypeIDX
   Where T.DelKey = 0 And T.EvalTableIDX = 1 And T.EvalItemCD > 0

   '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 협회별 평가 점수
   '================================================================================= 
   -- 협회별 평가 점수를 구한다. 
   ;With cte_score As (
      Select EvalItemTypeIDX, EvalItemIDX, EvalTypeCD, Sum(PointCalc) As sum_point, Count(EvalValueIDX) As cnt_val
         From tblEvalValue
         Where DelKey = 0 And EvalTableIDX = 1
         And AssociationIDX = 1
         Group By EvalItemTypeIDX, EvalItemIDX, EvalTypeCD
   )

   Select Row_Number() Over(Order By EvalItemTypeIDX) As Idx, 
	  EvalItemTypeIDX, EvalItemIDX, EvalTypeCD, 
      Round(Cast(sum_point As Float) /(cnt_val * 100), 2) As ave_val
      From cte_score

    '=================================================================================
   '  Purpose  : 	평가 지표 결과 - 협회별 평가 의견
   '================================================================================= 
   -- 협회별 평가 의견을 구한다. 
   Select Row_Number() Over(Order By EvalItemTypeIDX) As Idx, 
		EvalItemTypeIDX, EvalItemIDX, EvalTypeCD, EvalDesc
		From tblEvalDesc
		Where DelKey = 0 And EvalTableIDX = 1
		And AssociationIDX = 1
	 
%>
