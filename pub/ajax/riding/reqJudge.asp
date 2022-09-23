<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->



<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수

    ' classHelp를 입력받아 orderUpdate의 OrderType을 반환한다.
	'fnc >> GetOrderType >> fn_riding.asp


Sub orderUpdate( ByRef db, ByVal tidx, ByVal  gbidx, ByVal pubcode, ByVal rdno, ByVal orderType) '게임인덱스, 클레스인덱스,  부인덱스, 라운드번호, 순위방식에 따른 타입
	Dim wherestr,SQL , selecttbl, rs,arrP,pcode,bestsc,maxorder,ar,chkrdno, kgame

	'체전여부 확인	
	SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	kgame = rs(0)

	Select Case  orderType 

	Case "BM" '복합마술 결과 순위

		If CDbl(pubcode) = 0 Then '경기의 부서를 찾아서 각각 업데이트
			SQL = "Select pubcode from SD_tennisMember where delYN = 'N' and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' group by pubcode"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrP = rs.GetRows()
				If IsArray(arrP)  Then
					For ar = LBound(arrP, 2) To UBound(arrP, 2)
						pcode = arrP(0, ar) '부서코드

						'부별순위 업데이트 (pubcode) 부별업데이트            (tryoutresult = '0' and score_1 > 0) or ( tryoutresult in ('r','e') ) 동점 (장애물감점 적은순 score_1 , 소요시간 적은 순 score_1)
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode= '"&pcode&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and isnull(score_1,0) > 0) or ( tryoutresult in ('r','e') )) " 
						'감점이 0일수 있으니 score_1 > 0
						Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_total2 end asc,Case when (tryoutresult = '0') then  score_total end asc,Case when (tryoutresult = '0') then  score_1 end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
						SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
						Call db.execSQLRs(SQL , null, ConStr)
					Next
				End if
			End If
		End if

		'전체순위 업데이트 (각경기별) 전체업데이트  
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and isnull(score_1,0)  > 0) or ( tryoutresult in ('r','e') )) "
		Selecttbl = "( SELECT total_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_total2 end asc,Case when (tryoutresult = '0') then  score_total end asc,Case when (tryoutresult = '0') then  score_1 end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)



	Case "MM" '마장마술

		If CDbl(pubcode) = 0 Then '경기의 부서를 찾아서 각각 업데이트
			SQL = "Select pubcode from SD_tennisMember where delYN = 'N' and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' group by pubcode"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrP = rs.GetRows()
				If IsArray(arrP)  Then
					For ar = LBound(arrP, 2) To UBound(arrP, 2)
						pcode = arrP(0, ar) '부서코드
						'부별순위 업데이트 (pubcode) 부별업데이트   ROW_NUMBER 'score_total2 종합관찰점수 총합 (tryoutresult 정상 0 기권관련 숫자 100,200...)
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pcode&"' and gubun < 100 and ( (tryoutresult  = '0' and score_total > 0) or  (tryoutresult in ('r','e') ) ) " 
						Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_per end desc,Case when (tryoutresult = '0') then  midval end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
						SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
						Call db.execSQLRs(SQL , null, ConStr)
					Next
				End if
			End If
		else
			'부별순위 업데이트 (pubcode) 부별업데이트   ROW_NUMBER
			'Order By tryoutresult, Case when (tryoutresult = '0') then  score_total end desc,Case when (tryoutresult = '0') then  midval end desc
			wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pubcode&"' and gubun < 100 and ( (tryoutresult  = '0' and score_total > 0) or  (tryoutresult in ('r','e') ) )  "
			Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_per end desc,Case when (tryoutresult = '0') then  midval end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
		End If

		'전체순위 업데이트 (각경기별) 전체업데이트   기준 score_total >> score_per 로 변경 19년 7월 8일 희정요청
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and gubun < 100 and ( (tryoutresult  = '0' and score_total > 0) or  (tryoutresult in ('r','e') ) )   "
		Selecttbl = "( SELECT total_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_per end desc,Case when (tryoutresult = '0') then  midval end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)

	'##########################################################################################################################
	Case "A"   '최고 라운드가 어떻게 되는지도 체크해야함.
		If CDbl(pubcode) = 0 Then '경기의 부서를 찾아서 각각 업데이트
			SQL = "Select pubcode from SD_tennisMember where delYN = 'N' and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' group by pubcode"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrP = rs.GetRows()
				If IsArray(arrP)  Then
					For ar = LBound(arrP, 2) To UBound(arrP, 2)
						pcode = arrP(0, ar) '부서코드

						'부별순위 업데이트 (pubcode) 부별업데이트            (tryoutresult = '0' and score_1 > 0) or ( tryoutresult in ('r','e') )
						If (kgame = "N" And CDbl(rdno) > 1) Or  (kgame = "Y" And CDbl(rdno) > 3) then
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode= '"&pcode&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and isnull(score_1,0) > 0) or ( tryoutresult in ('r','e','w','d') )) " 
						Else
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode= '"&pcode&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and isnull(score_1,0) > 0) or ( tryoutresult in ('r','e') )) " 
						End if
						'감점이 0일수 있으니 score_1 > 0
						Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_total end asc,Case when (tryoutresult = '0') then  score_1 end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
						SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
						Call db.execSQLRs(SQL , null, ConStr)
					Next
				End if
			End If
		else
			'부별순위 업데이트 (pubcode) 부별업데이트 
			If (kgame = "N" And CDbl(rdno) > 1) Or  (kgame = "Y" And CDbl(rdno) > 3) then
			wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode= '"&pubcode&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and isnull(score_1,0)  > 0) or ( tryoutresult in ('r','e','w','d') )) " 
			Else
			wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode= '"&pubcode&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and isnull(score_1,0)  > 0) or ( tryoutresult in ('r','e') )) " 
			End if
			'감점이 0일수 있으니 score_1 > 0
			Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_total end asc,Case when (tryoutresult = '0') then  score_1 end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
		End if

		'전체순위 업데이트 (각경기별) 전체업데이트 
		If (kgame = "N" And CDbl(rdno) > 1) Or  (kgame = "Y" And CDbl(rdno) > 3) then
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and isnull(score_1,0)  > 0) or ( tryoutresult in ('r','e','w','d') )) "
		Else
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and isnull(score_1,0)  > 0) or ( tryoutresult in ('r','e') )) "
		End if
		Selecttbl = "( SELECT total_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_total end asc,Case when (tryoutresult = '0') then  score_1 end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)


		'@@@@@  본선 경기에 재경기 순위 업데이트 하기 @@@@@@@@@@@@@@@@@@@@@@@@@
		'rdno > 1 재경기 본경기(round = 1) 순위에 반영하기
		'대상 member 의 부와 전체 순위 select 
		'루프생성후 동일 playeridx 값을 업데이트 해준다...끝
		'순위가 끝이라면
		'부의순위: 변경된것들과 다르다면 부순위 유지
		
		'체전인 경우는 2,3 에서 하면 안됨 4,5에서 해야된다...어쩌지
		' 쿠키는 judgefindform.asp 에서 생성한다. 이걸로 체크하자.
		If Cookies_kgame = "N" Then
			chkrdno = 1 '2부터 다음라운드보냄
		Else
			chkrdno = 3 '4부터 재경기임 
		End If
		
		If CDbl(rdno) > CDbl(chkrdno) Then

			Dim arrU, pidx,boono,totalno,midx1,lasttotalno
			lasttotalno = 1

			SQL = "select midx1,     playeridx, boo_orderno, total_order,pubcode   from  sd_tennisMember "
			SQL = SQL &  " where DelYN = 'N' and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and round= "&rdno& " order by total_order "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrU = rs.GetRows()

				If IsArray(arrU)  Then
					For ar = LBound(arrU, 2) To UBound(arrU, 2)
						midx1 = arrU(0, ar)
						pidx = arrU(1, ar) 					
						boono = arrU(2, ar)
						totalno = arrU(3, ar)

						If boono > 0 Then '결과가 반영된 것만 
							SQL = "Update sd_tennisMember Set boo_orderno = '"&boono&"' , total_order = '"&totalno&"'  Where  gameMemberidx = " & midx1
							Call db.execSQLRs(SQL , null, ConStr)
							lasttotalno = totalno
						'Else
						'	SQL = "Update sd_tennisMember Set boo_orderno = '-1' , total_order = '-1'  Where  gameMemberidx = " & midx1
						'	Call db.execSQLRs(SQL , null, ConStr)							
						End if

					Next
				End If


				If IsArray(arrU)  Then
					For ar = LBound(arrU, 2) To UBound(arrU, 2)
						midx1 = arrU(0, ar)
						'pidx = arrU(1, ar) 					
						boono = arrU(2, ar)
						'totalno = arrU(3, ar)

						If boono > 0 Then '결과가 반영된 것만 
						'	SQL = "Update sd_tennisMember Set boo_orderno = '"&boono&"' , total_order = '"&totalno&"'  Where  gameMemberidx = " & midx1
						'	Call db.execSQLRs(SQL , null, ConStr)
						Else
							SQL = "Update sd_tennisMember Set boo_orderno = '-"&lasttotalno&"' , total_order = '-"&lasttotalno&"'  Where  gameMemberidx = " & midx1
							Call db.execSQLRs(SQL , null, ConStr)							
						End if

					Next
				End If

			End If

		End if
		'@@@@@  본선 경기에 재경기 순위 업데이트 하기 @@@@@@@@@@@@@@@@@@@@@@@@@




	Case "A_1"

		SQL = "select top 1 bestsc       from tblRGameLevel  where gametitleidx = '"&tidx&"' and Gbidx = '"&gbidx&"'  "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		If Not rs.eof then
		bestsc = rs(0)

		If CDbl(pubcode) = 0 Then '경기의 부서를 찾아서 각각 업데이트
			SQL = "Select pubcode from SD_tennisMember where delYN = 'N' and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' group by pubcode"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrP = rs.GetRows()
				If IsArray(arrP)  Then
					For ar = LBound(arrP, 2) To UBound(arrP, 2)
						pcode = arrP(0, ar) '부서코드

						'부별순위 업데이트 (pubcode) 부별업데이트 
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode= '"&pcode&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and score_1 > 0) or ( tryoutresult in ('r','e') )) " 
						'감점이 0일수 있으니 score_1 > 0
						Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_total end asc,Case when (tryoutresult = '0') then  (case when ("&bestsc&" - score_1) < 0 then abs("&bestsc&" - score_1) * 100  else abs("&bestsc&" - score_1) * 100  end) end asc, score_1 asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
						SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
						Call db.execSQLRs(SQL , null, ConStr)
					Next
				End if
			End If
		else
			'부별순위 업데이트 (pubcode) 부별업데이트 
			wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode= '"&pubcode&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and score_1 > 0) or ( tryoutresult in ('r','e') )) " 
			'감점이 0일수 있으니 score_1 > 0
			Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_total end asc,Case when (tryoutresult = '0') then  (case when ("&bestsc&" - score_1) < 0 then abs("&bestsc&" - score_1) * 100  else abs("&bestsc&" - score_1) * 100  end) end asc , score_1 asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
		End if

		'전체순위 업데이트 (각경기별) 전체업데이트 
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and round= "&rdno&" and gubun < 100 and ((tryoutresult = '0' and score_1 > 0) or ( tryoutresult in ('r','e') )) "

		Selecttbl = "( SELECT total_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  score_total end asc,Case when (tryoutresult = '0') then  (case when ("&bestsc&" - score_1) < 0 then abs("&bestsc&" - score_1) * 100  else abs("&bestsc&" - score_1) * 100  end) end asc, score_1 asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "

		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)

		End if

	'##########################################################################################################################
	Case "B"

		If CDbl(pubcode) = 0 Then '경기의 부서를 찾아서 각각 업데이트 (통합 또는 체전 경기결과 합산에 사용)
			SQL = "Select pubcode from SD_tennisMember where delYN = 'N' and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' group by pubcode"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrP = rs.GetRows()
				If IsArray(arrP)  Then
					For ar = LBound(arrP, 2) To UBound(arrP, 2)
						pcode = arrP(0, ar) '부서코드
						'$$$$$$$$$$$$$$$$
						'2단계 순위   tryoutresult  in ( '0','r','e') and  score_4 > 0   -- tryoutresult 0 또는 기권/실격
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pcode&"' and gubun < 100 and ((tryoutresult = '0' and score_4 > 0) or ( tryoutresult in ('r','e') )) " 
						'score_per 감점이 없을수도 있지....소요시간은 0일수 없지...
						Selecttbl = "( SELECT boo_orderno,ROW_NUMBER() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
						SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
						Call db.execSQLRs(SQL , null, ConStr)

						SQL = "select max(boo_orderno) from SD_tennisMember where DelYN = 'N' " & wherestr
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						maxorder = rs(0)

						If isNull(rs(0)) = True Then
							maxorder = 0	
						Else
							maxorder = rs(0)
						End if

						'1단계 순위  tryoutresult  in ( '0','r','e') and isNull(score_4,0) = 0
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pcode&"' and gubun < 100 and ((tryoutresult = '0' and isNull(score_1,0) > 0 and isNull(score_4,0) = 0) or ( tryoutresult in ('r','e') )) "
						Selecttbl = "( SELECT boo_orderno,ROW_NUMBER() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
						SQL = "UPDATE A  SET A.boo_orderno = A.RowNum + "&maxorder&" FROM " & selecttbl
						Call db.execSQLRs(SQL , null, ConStr)
						'$$$$$$$$$$$$$$$$
					Next
				End if
			End If
		else
			'$$$$$$$$$$$$$$$$
			'2단계 순위
			wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pubcode&"' and gubun < 100 and ((tryoutresult = '0' and score_4 > 0) or ( tryoutresult in ('r','e') )) " 
			'score_per 감점이 없을수도 있지....소요시간은 0일수 없지...
			Selecttbl = "( SELECT boo_orderno,ROW_NUMBER() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)

			SQL = "select max(boo_orderno) from SD_tennisMember where DelYN = 'N' " & wherestr
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			maxorder = rs(0)

			If isNull(rs(0)) = True Then
				maxorder = 0	
			Else
				maxorder = rs(0)
			End if

			'1단계 순위 (1번 소요시간이 0보다 크고  2번소요시간이 0인
			wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pubcode&"' and gubun < 100 and ((tryoutresult = '0' and isNull(score_1,0) > 0 and isNull(score_4,0) = 0) or ( tryoutresult in ('r','e') )) "
			Selecttbl = "( SELECT boo_orderno,ROW_NUMBER() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum + "&maxorder&" FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
			'$$$$$$$$$$$$$$$$
		End If


		'###########################

		'전체순위 업데이트 (각경기별) 전체업데이트 
		'2단계 순위
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and gubun < 100 and ((tryoutresult = '0' and score_4 > 0) or ( tryoutresult in ('r','e') ))  "
		Selecttbl = "( SELECT total_order,ROW_NUMBER() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "select max(boo_orderno) from SD_tennisMember where DelYN = 'N' " & wherestr
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If isNull(rs(0)) = True Then
			maxorder = 0	
		Else
			maxorder = rs(0)
		End if

		'1단계 순위
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and gubun < 100 and ((tryoutresult = '0' and isNull(score_1,0) > 0 and isNull(score_4,0) = 0) or ( tryoutresult in ('r','e') )) "
		Selecttbl = "( SELECT total_order,ROW_NUMBER() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum + "&maxorder&"  FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)

	'##########################################################################################################################
	Case "C"

		If CDbl(pubcode) = 0 Then '경기의 부서를 찾아서 각각 업데이트 (통합 또는 체전 경기결과 합산에 사용)
			SQL = "Select pubcode from SD_tennisMember where delYN = 'N' and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' group by pubcode"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrP = rs.GetRows()
				If IsArray(arrP)  Then
					For ar = LBound(arrP, 2) To UBound(arrP, 2)
						pcode = arrP(0, ar) '부서코드
						'$$$$$$$$$$$$$$$$
						'부별순위 업데이트 (pubcode) 부별업데이트 
						'부별 소팅해서 인덱스 순으로 가져온다.  tryoutresult  in ( '0','r','e') and score_total > 0 
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pcode&"'  and gubun < 100 and ((tryoutresult = '0' and score_total > 0 ) or ( tryoutresult in ('r','e') ))  "
						Selecttbl = "( SELECT boo_orderno,ROW_NUMBER() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then score_total end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
						SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
						Call db.execSQLRs(SQL , null, ConStr)
						'$$$$$$$$$$$$$$$$
					Next
				End if
			End If
		else
			'$$$$$$$$$$$$$$$$
			'부별순위 업데이트 (pubcode) 부별업데이트 
			'부별 소팅해서 인덱스 순으로 가져온다. 
			wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pubcode&"'  and gubun < 100 and ((tryoutresult = '0' and score_total > 0 ) or ( tryoutresult in ('r','e') )) "
			Selecttbl = "( SELECT boo_orderno,ROW_NUMBER() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then score_total end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
			'$$$$$$$$$$$$$$$$
		End If

		'전체순위 업데이트 (각경기별) 전체업데이트 
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"'  and gubun < 100 and ((tryoutresult = '0' and score_total > 0 ) or ( tryoutresult in ('r','e') )) "
		Selecttbl = "( SELECT total_order,ROW_NUMBER() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then score_total end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)


	End Select 
End Sub

'*** 소팅주의 tryoutresult가 앞에온이유는 이거에 순위를 부여해야해서...꼴지에다..





' http://tennis.sportsdiary.co.kr/pub/ajax/riding/reqJudge.asp?test=t
'############################################
	If request("test") = "t" Then
	'REQ = "{""CMD"":600,""RDNO"":1,""TIDX"":149,""GBIDX"":146,""MIDXS"":[],""KGAME"":""Y""}"
	'REQ = "{""PARR"":[""693""],""CMD"":12000}"
    REQ = "{""CMD"":600,""RDNO"":2,""TIDX"":44,""GBIDX"":200,""MIDXS"":[],""KGAME"":""Y"",""ORTYPE"":""A""}" 
	else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
		'Set oJSONoutput = JSON.Parse(REQ)
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if


	'define CMD
	CMD_GAMEINPUT2 = 15001	'공지사항저장2
	CMD_GAMEINPUTEDITOK = 15002	'수정
	CMD_GAMEINPUTDEL = 15003	'삭제

	CMD_SETRECORDINIT = 400	'심사지점 수 최고점수 저정
	CMD_SETSIGN = 401
	CMD_SETSHOW = 402
	CMD_EXCEPTMAX = 403 '최고점제거
	CMD_EXCEPTMIN = 404


	CMD_RC01 = 20000	'기록입력시작 01
	CMD_RC02 = 20010	
	CMD_RC03 = 500	'저장후 reload
	CMD_MMRCOK = 505 '저장후 reload 마장마술 저장 (통합으로)
	CMD_RCCLOSE= 501	'기록창에서 창닫음 (입력상태복구)


	CMD_SETGIVEUP = 300	'기권사유선택
	CMD_SETGIVEUPDOC = 301	'사유서제출
	CMD_SETGAMESTATE = 620	'경기상태변경

	CMD_JRCOK = 510	'장애물 A타입 저장
	CMD_JRCOK2 = 520	'장애물 B타입 저장
	CMD_JRCOK3 = 530	'장애물 C타입 저장
	CMD_JRCOKA_1 = 540	'장애물 A_1타입 저장

	CMD_JREGAME = 600 '재경기생성 
	CMD_JREGAMEDEL = 610	'재경기 삭제

    CMD_SUMBOO_INJUDGE = 11101        ' 수동 통합 - 심사기록입력
    CMD_DIVBOO_INJUDGE  = 11102        ' 수동 분리 - 심사기록입력
    CMD_REFRESHBOO_INJUDGE = 11103    ' 부 재조회 - 심사기록입력


	CMD_CHANGEWINDOW = 30000 '선수변경창

	CMD_SEARCHPLAYER = 30030 '선수검색
	CMD_CHANGEPLAYER = 700 '변경
	CMD_CHANGEMAKEPLAYER = 710 '선수생성변경

	CMD_SEARCHHORSE = 30040  '말검색
	CMD_CHANGEHORSE = 800		'말변경
	CMD_CHANGEMAKEHORSE = 810		'말생성변경
	CMD_BMRESULT = 900 '복합마술 경기결과생성


	CMD_CHANGEBOO = 30050 '부서변경
	CMD_CHANGEBOOOK = 730 '부변경
	Select Case CDbl(CMD)


	case CMD_BMRESULT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.BMResult.asp" --><%  '복합마술 경기결과 생성
	Response.End


	case CMD_CHANGEBOO
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changeboo.asp" --><% 
	Response.End

	case CMD_CHANGEBOOOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changeboook.asp" --><% 
	Response.End

	case CMD_CHANGEWINDOW
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changewindow.asp" --><% 
	Response.End

	case CMD_SEARCHPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchplayer.asp" --><% 
	Response.End

	case CMD_CHANGEPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changeplayer.asp" --><% 
	Response.End

	case CMD_CHANGEMAKEPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changemakeplayer.asp" --><% 
	Response.End


	case CMD_SEARCHHORSE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchhorse.asp" --><% 
	Response.End

	case CMD_CHANGEHORSE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changehorse.asp" --><% 
	Response.End

	case CMD_CHANGEMAKEHORSE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changemakehorse.asp" --><% 
	Response.End





	case CMD_JREGAMEDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jReGameDel.asp" --><% 
	Response.End

	case CMD_JREGAME
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jReGame.asp" --><% 
	Response.End

	case CMD_JRCOK3
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOK3.asp" --><% 
	Response.End
	case CMD_JRCOK2
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOK2.asp" --><% 
	Response.End
	case CMD_JRCOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOK.asp" --><% 
	Response.End
	case CMD_JRCOKA_1
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOKA_1.asp" --><% 
	Response.End



	case CMD_SETGAMESTATE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgamestate.asp" --><% 
	Response.End
	case CMD_SETGIVEUP
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgiveup.asp" --><% 
	Response.End

	case CMD_SETGIVEUPDOC
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgiveupdoc.asp" --><% 
	Response.End


	case CMD_RCCLOSE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rcclose.asp" --><% 
	Response.End

	case CMD_RC01
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rc01.asp" --><% 
	Response.End
	case CMD_RC02
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rc02.asp" --><% 
	Response.End
	case CMD_RC03
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rc03.asp" --><% 
	Response.End

	case CMD_MMRCOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.mmTypeOk.asp" --><% 
	Response.End




	case CMD_SETSIGN
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setsign.asp" --><% 
	Response.End

	case CMD_SETSHOW 
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setshow.asp" --><% 
	Response.End

	case CMD_EXCEPTMAX 
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.exceptmax.asp" --><% 
	Response.End
	case CMD_EXCEPTMIN 
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.exceptmin.asp" --><% 
	Response.End




	case CMD_SETRECORDINIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setrecordinit.asp" --><% 
	Response.End

	case CMD_GAMEINPUT2
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.scSavenotice2.asp" --><% 
	Response.End

	case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.orderNoticeEditOk.asp" --><% 
	Response.End

	case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.orderNoticeDel.asp" --><% 
	Response.End

    case CMD_SUMBOO_INJUDGE    
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.sumboo.asp" --><%
	Response.End

    case CMD_DIVBOO_INJUDGE    
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.divboo.asp" --><%
	Response.End

    case CMD_REFRESHBOO_INJUDGE		
        %><!-- #include virtual = "/pub/api/RidingAdmin/api.refresh.boo.injudge.asp" --><%
	Response.End



	End Select
%>
