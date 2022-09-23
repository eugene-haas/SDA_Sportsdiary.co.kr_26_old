

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
   '     특정 협회를 평가했던 평가 Table List를 구한다 
   '=================================================================================       
	-- 특정 협회를 평가했던 평가 Table List를 구한다 .
	;with cte_association As (
		Select EvalTableIdx From tblAssociation_sub
			Where DelKey = 0 And AssociationIDX = 1
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
	Where T.DelKey = 0 And T.EvalTableIDX In (Select EvalTableIdx From cte_association)

   '=================================================================================
   ' Purpose  : 	평가 List - 협회별 등록/수정 최신 날짜 
   '=================================================================================      
   -- 총평등록, 평가의견 등록, 점수 등록에 대한 최신 날짜를 구한다. 
   -- 총평 등록 날짜를 구한다. 
   ;with cte_total_desc As (
      Select AssociationIDX, RegDate, ModDate
            From tblAssociation_sub 
            Where DelKey = 0 And EvalTableIDX = 9 
   )

   -- 평가 의견의 등록/수정 날짜를 구한다.
   , cte_desc As (
      Select AssociationIDX, Max(RegDate) As RegDate, Max(ModDate) As ModDate
            From tblEvalDesc 
            Where DelKey = 0 And EvalTableIDX = 9 
         Group By AssociationIDX
   )

   -- 평가 점수의 등록/수정 날짜를 구한다. 
   , cte_value As (
      Select AssociationIDX, Max(RegDate) As RegDate, Max(ModDate) As ModDate
            From tblEvalValue
            Where DelKey = 0 And EvalTableIDX = 7 
         Group By AssociationIDX
   )

   -- 등록, 수정 날짜를 협회별로 하나로 하여 merge한다. (최신값 구하기 위해)
   , cte_info As (
      Select AssociationIDX, Max(reg_date) As reg_date From (
         Select AssociationIDX, RegDate As reg_date From cte_total_desc
         Union 
         Select AssociationIDX, ModDate As reg_date From cte_total_desc
         Union
         Select AssociationIDX, RegDate As reg_date From cte_desc
         Union 
         Select AssociationIDX, ModDate As reg_date From cte_desc
         Union 
         Select AssociationIDX, RegDate As reg_date From cte_value
         Union 
         Select AssociationIDX, ModDate As reg_date From cte_value
      ) As C
      Group By AssociationIDX
   )

   Select ROW_NUMBER() Over(Partition By A.EvalGroupCD Order By A.MemberGroupCD, A.AssociationNm) As Idx, 
      A.AssociationIDX, A.AssociationNm, A.EvalGroupCD, A.EvalGroupNm, A.MemberGroupCD, A.MemberGroupNm, A.RegYear, convert(varchar(10), I.reg_date, 120) As reg_date
      From tblAssociation_sub As A 
	  Inner Join cte_info As I On I.AssociationIDX = A.AssociationIDX
      Where A.DelKey = 0 And A.EvalTableIDX = 9
   '=================================================================================
   ' Purpose  : 	평가 List - 협회별 등록/수정 최신 날짜 - 평가위원
   '=================================================================================   
   -- 평가위원에서는 총평 등록을 하지 않지만, 협회 등록 날짜를 Default로 넣기 위해 구한다.  
   -- 평가의견 등록, 점수 등록에 대한 최신 날짜를 구한다. 
   -- 총평 등록 날짜를 구한다. 
   ;with cte_total_desc As (
      Select AssociationIDX, RegDate, ModDate
            From tblAssociation_sub 
            Where DelKey = 0 And EvalTableIDX = 9 
   )

   -- 평가 위원에 종속된 평가 항목을 구한다. 
   , cte_member As (
      Select EvalItemTypeIDX 
         From tblEvalMember 
         Where DelKey = 0 And EvalTableIDX = 9 And AdminMemberIDX = 3
   )

   -- 평가위원의 평가 항목에 대한 평가 의견의 등록/수정 날짜를 구한다. 
   , cte_desc As (
      Select AssociationIDX, Max(RegDate) As RegDate, Max(ModDate) As ModDate
            From tblEvalDesc 
            Where DelKey = 0 And EvalTableIDX = 9 
         And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member)
         Group By AssociationIDX
   )

   -- 평가위원의 평가 항목에 대한 평가 점수의 등록/수정 날짜를 구한다. 
   , cte_value As (
      Select AssociationIDX, Max(RegDate) As RegDate, Max(ModDate) As ModDate
            From tblEvalValue
            Where DelKey = 0 And EvalTableIDX = 9 
         And EvalItemTypeIDX In (Select EvalItemTypeIDX From cte_member)
         Group By AssociationIDX
   )

   -- 등록, 수정 날짜를 협회별로 하나로 하여 merge한다. (최신값 구하기 위해)
   , cte_info As (
      Select AssociationIDX, Max(reg_date) As reg_date From (
         Select AssociationIDX, RegDate As reg_date From cte_total_desc
         Union 
         Select AssociationIDX, ModDate As reg_date From cte_total_desc
         Union
         Select AssociationIDX, RegDate As reg_date From cte_desc
         Union 
         Select AssociationIDX, ModDate As reg_date From cte_desc
         Union 
         Select AssociationIDX, RegDate As reg_date From cte_value
         Union 
         Select AssociationIDX, ModDate As reg_date From cte_value
      ) As C
      Group By AssociationIDX
   )

   Select ROW_NUMBER() Over(Partition By A.EvalGroupCD Order By A.MemberGroupCD, A.AssociationNm) As Idx, 
      A.AssociationIDX, A.AssociationNm, A.EvalGroupCD, A.EvalGroupNm, A.MemberGroupCD, A.MemberGroupNm, A.RegYear, convert(varchar(10), I.reg_date, 120) As reg_date
      From tblAssociation_sub As A 
	  Inner Join cte_info As I On I.AssociationIDX = A.AssociationIDX
      Where A.DelKey = 0 And A.EvalTableIDX = 9


%>
