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




Sub orderUpdateGroup( ByRef db, ByVal tidx, ByVal  gbidx, ByVal pubcode, ByVal rdno, ByVal orderType) '게임인덱스, 클레스인덱스,  부인덱스, 라운드번호, 순위방식에 따른 타입
	Dim wherestr,SQL , selecttbl, rs,arrP,pcode,bestsc,maxorder,ar,chkrdno, kgame

	'체전여부 확인
	SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	kgame = rs(0)

	Select Case  orderType

	Case "MM" '마장마술

		'그룹별 전체순위 업데이트 (각경기별) 전체업데이트   group_score_per
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and gubun < 100 and  tryoutresult  = '0' and group_score_per > 0  "
		Selecttbl = "( SELECT group_order,DENSE_RANK() OVER (Order By tryoutresult, group_score_per desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.group_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)

	'##########################################################################################################################
	Case "A"   '최고 라운드가 어떻게 되는지도 체크해야함.


		SQL = "UPDATE  SD_tennisMember SET group_order = b.RowNum "
		SQL = SQL & "	FROM SD_tennisMember as a "
		SQL = SQL & "	inner join ( "

		SQL = SQL & "		select x.gametitleidx,x.teamANa,x.group_order, RANK() OVER(order by x.rownum ) as rownum  from "
		SQL = SQL & "		(  "
		SQL = SQL & "		SELECT gametitleidx,teamANa,group_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  group_score_total end asc,Case when (tryoutresult = '0') then  group_score_1 end asc) AS RowNum "
		SQL = SQL & "		FROM SD_tennisMember where DelYN = 'N'  and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and round= "&rdno&" and gubun < 100 and (tryoutresult = '0' and isnull(group_score_1,0)  > 0) "
		SQL = SQL & "		) as x "
		SQL = SQL & "		group by x.gametitleidx,x.teamANa,x.group_order, x.rownum "

		SQL = SQL & "	) as b on a.gametitleidx = b.gametitleidx and a.teamana = b.teamana where a.DelYN = 'N'  and a.gametitleidx =  '"&tidx&"' and a.gamekey3 = '"&gbidx&"' and a.round= "&rdno&" and a.gubun < 100 and (a.tryoutresult = '0' and isnull(a.group_score_1,0)  > 0)	"
		'Response.write sql
		'Response.end
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

			SQL = "select midx1,     playeridx, boo_orderno, group_order,pubcode   from  sd_tennisMember "
			SQL = SQL &  " where DelYN = 'N' and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and round= "&rdno& " order by group_order "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrU = rs.GetRows()

				If IsArray(arrU)  Then
					For ar = LBound(arrU, 2) To UBound(arrU, 2)
						midx1 = arrU(0, ar)
						pidx = arrU(1, ar)
						boono = arrU(2, ar)
						totalno = arrU(3, ar)

						If totalno > 0 Then '결과가 반영된 것만
							SQL = "Update sd_tennisMember Set  group_order = '"&totalno&"'  Where  gameMemberidx = " & midx1
							Call db.execSQLRs(SQL , null, ConStr)
							lasttotalno = totalno
						End if

					Next
				End If


				If IsArray(arrU)  Then
					For ar = LBound(arrU, 2) To UBound(arrU, 2)
						midx1 = arrU(0, ar)
						boono = arrU(2, ar)

						If totalno > 0 Then '결과가 반영된 것만
						Else
							SQL = "Update sd_tennisMember Set group_order = '-"&lasttotalno&"'  Where  gameMemberidx = " & midx1
							Call db.execSQLRs(SQL , null, ConStr)
						End if

					Next
				End If

			End If

		End if
		'@@@@@  본선 경기에 재경기 순위 업데이트 하기 @@@@@@@@@@@@@@@@@@@@@@@@@




	Case "A_1" '최적시간

		SQL = "select top 1 bestsc       from tblRGameLevel  where gametitleidx = '"&tidx&"' and Gbidx = '"&gbidx&"'  "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof then
		bestsc = rs(0)

		'전체순위 업데이트 (각경기별) 전체업데이트
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and gubun < 100 and (tryoutresult = '0' and group_score_1 > 0)  "

		Selecttbl = "( SELECT group_order,DENSE_RANK()  OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  group_score_total end asc,Case when (tryoutresult = '0') then  (case when ("&bestsc&" - group_score_1) < 0 then abs("&bestsc&" - group_score_1) * 100  else abs("&bestsc&" - group_score_1) * 100  end) end asc, group_score_1 asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "

		SQL = "UPDATE A  SET A.group_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)

		End if

	'##########################################################################################################################
	Case "B"


		SQL = "UPDATE  SD_tennisMember SET group_order = b.RowNum "
		SQL = SQL & "	FROM SD_tennisMember as a "
		SQL = SQL & "	inner join ( "

		SQL = SQL & "		select x.gametitleidx,x.teamANa,x.group_order, RANK() OVER(order by x.rownum ) as rownum  from "
		SQL = SQL & "		(  "
		SQL = SQL & "		SELECT gametitleidx,teamANa,group_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  group_score_total end asc,Case when (tryoutresult = '0') then  group_score_1 end asc) AS RowNum "
		SQL = SQL & "		FROM SD_tennisMember where DelYN = 'N'  and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and gubun < 100 and (tryoutresult = '0' and isnull(group_score_1,0)  > 0) "
		SQL = SQL & "		) as x "
		SQL = SQL & "		group by x.gametitleidx,x.teamANa,x.group_order, x.rownum "

		SQL = SQL & "	) as b on a.gametitleidx = b.gametitleidx and a.teamana = b.teamana where a.DelYN = 'N'  and a.gametitleidx =  '"&tidx&"' and a.gamekey3 = '"&gbidx&"' and a.gubun < 100 and (a.tryoutresult = '0' and isnull(a.group_score_1,0)  > 0)	"
		'Response.write sql
		'Response.end
		Call db.execSQLRs(SQL , null, ConStr)

	'##########################################################################################################################
	Case "C" 'typeC 239

		'전체순위 업데이트 (각경기별) 전체업데이트
		SQL = "UPDATE  SD_tennisMember SET group_order = b.RowNum "
		SQL = SQL & "	FROM SD_tennisMember as a "
		SQL = SQL & "	inner join ( "

		SQL = SQL & "		select x.gametitleidx,x.teamANa,x.group_order, RANK() OVER(order by x.rownum ) as rownum  from "
		SQL = SQL & "		(  "
		SQL = SQL & "		SELECT gametitleidx,teamANa,group_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  group_score_total end asc,Case when (tryoutresult = '0') then  group_score_1 end asc) AS RowNum "
		SQL = SQL & "		FROM SD_tennisMember where DelYN = 'N'  and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and gubun < 100 and (tryoutresult = '0' and isnull(group_score_1,0)  > 0) "
		SQL = SQL & "		) as x "
		SQL = SQL & "		group by x.gametitleidx,x.teamANa,x.group_order, x.rownum "

		SQL = SQL & "	) as b on a.gametitleidx = b.gametitleidx and a.teamana = b.teamana where a.DelYN = 'N'  and a.gametitleidx =  '"&tidx&"' and a.gamekey3 = '"&gbidx&"' and a.gubun < 100 and (a.tryoutresult = '0' and isnull(a.group_score_1,0)  > 0)	"
		Call db.execSQLRs(SQL , null, ConStr)


	End Select
End Sub




























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
						wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pcode&"' and gubun < 100 and ((tryoutresult = '0' and score_4 > 0)) " ' or ( tryoutresult in ('r','e') )) " 'score_4 총소요시간 2번째 --기권 실격된 사람들은 순위에서 빼야함.
						'score_per 감점이 없을수도 있지....소요시간은 0일수 없지...
						Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc,Case when (tryoutresult = '0') then  (isNull(score_1,0) + isNull(score_4,0)) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
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
						Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc,Case when (tryoutresult = '0') then  (isNull(score_1,0) + isNull(score_4,0)) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
						SQL = "UPDATE A  SET A.boo_orderno = A.RowNum + "&maxorder&" FROM " & selecttbl
						Call db.execSQLRs(SQL , null, ConStr)
						'$$$$$$$$$$$$$$$$
					Next
				End if
			End If
		else
			'$$$$$$$$$$$$$$$$
			'2단계 순위
			wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode = '"&pubcode&"' and gubun < 100 and ((tryoutresult = '0' and score_4 > 0)) " 'or ( tryoutresult in ('r','e') )) "  'score_4 총소요시간 2번째 --기권 실격된 사람들은 순위에서 빼야함.
			'score_per 감점이 없을수도 있지....소요시간은 0일수 없지...
			Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc,Case when (tryoutresult = '0') then  (isNull(score_1,0) + isNull(score_4,0)) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)

			'기권 실격된 사람들은 순위에서 빼야함.
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
			Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc,Case when (tryoutresult = '0') then  (isNull(score_1,0) + isNull(score_4,0)) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum + "&maxorder&" FROM " & selecttbl '2단계까지 완료
			Call db.execSQLRs(SQL , null, ConStr)

			'$$$$$$$$$$$$$$$$
		End If


		'###########################

		'전체순위 업데이트 (각경기별) 전체업데이트
		'2단계 순위
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and gubun < 100 and ((tryoutresult = '0' and score_4 > 0)) " ' or ( tryoutresult in ('r','e') ))  " 'score_4 총소요시간 2번째 --기권 실격된 사람들은 순위에서 빼야함. (1단계에서 계산하도록)
		Selecttbl = "( SELECT total_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc,Case when (tryoutresult = '0') then  (isNull(score_1,0) + isNull(score_4,0)) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "select max(boo_orderno) from SD_tennisMember where DelYN = 'N' " & wherestr
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If isNull(rs(0)) = True Then
			maxorder = 0
		Else
			maxorder = rs(0)
		End if

		'1단계 순위 ROW_NUMBER
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and gubun < 100 and ((tryoutresult = '0' and isNull(score_1,0) > 0 and isNull(score_4,0) = 0) or ( tryoutresult in ('r','e') )) "
		Selecttbl = "( SELECT total_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then (score_total + score_per) end asc,Case when (tryoutresult = '0') then  (isNull(score_1,0) + isNull(score_4,0)) end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum + "&maxorder&"  FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)
		'Response.write sql

	'##########################################################################################################################
	Case "C" 'typeC 239

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
						Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then score_total end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
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
			Selecttbl = "( SELECT boo_orderno,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then score_total end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
			'$$$$$$$$$$$$$$$$
		End If

		'전체순위 업데이트 (각경기별) 전체업데이트
		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"'  and gubun < 100 and ((tryoutresult = '0' and score_total > 0 ) or ( tryoutresult in ('r','e') )) "
		Selecttbl = "( SELECT total_order,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then score_total end asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)


	End Select
End Sub


'*** 소팅주의 tryoutresult가 앞에온이유는 이거에 순위를 부여해야해서...꼴지에다..





' http://tennis.sportsdiary.co.kr/pub/ajax/riding/reqJudge.asp?test=t
'############################################
	If request("test") = "t" Then
    REQ = "{""CMD"":901,""TIDX"":45,""GBIDX"":212,""KGAME"":""N"",""TEAMGB"":""20101""}" 
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
	CMD_JRCOK3 = 530	'장애물 C타입 저장----------
	CMD_JRCOKA_1 = 540	'장애물 A_1타입 저장--------------최적시간

	CMD_JREGAME = 600 '재경기생성
	CMD_JREGAMEDEL = 610	'재경기 삭제

    CMD_SUMBOO_INJUDGE = 11101        ' 수동 통합 - 심사기록입력
    CMD_DIVBOO_INJUDGE  = 11102        ' 수동 분리 - 심사기록입력
    CMD_REFRESHBOO_INJUDGE = 11103    ' 부 재조회 - 심사기록입력


	CMD_CHANGEWINDOW = 30000 '선수변경창

	CMD_SEARCHPLAYER = 30030 '선수검색
	CMD_SEARCHPLAYERGROUP = 30031	'그룹선수검색
	CMD_CHANGEPLAYER = 700 '변경
	CMD_CHANGEGROUPPLAYER = 778 '릴레이선수 변경

	CMD_CHANGEMAKEPLAYER = 710 '선수생성변경
	CMD_SAVEJUDGE = 720 '심판저장

	CMD_SEARCHHORSE = 30040  '말검색
	CMD_CHANGEHORSE = 800		'말변경
	CMD_CHANGEMAKEHORSE = 810		'말생성변경
	CMD_BMRESULT = 900 '복합마술 경기결과생성

	CMD_SETJUDGE = 31000	'심판,스크라이버,	스튜어드, set-in, shadow
	CMD_SEARCHJUDGE =  30050	'심판검색

	CMD_VALUATION = 150 '채점 상세 기록


	CMD_CHANGEBOO = 30051 '부서변경
	CMD_CHANGEBOOOK = 730 '부변경

	CMD_SETHURDLE =  40000 '장애물 기준및 배칭창
	CMD_JRC = 740  '장애물기준및 배치정보 내용 입력

	CMD_SETDT2 = 750
	CMD_CHANGEORDER = 751	'체전 2라운드 경기순서변경


	CMD_GAMEINRC = 13010'게임결과 입력 (릴레이 토너먼트)
	CMD_SETSAVETN = 815 '승패저장
	CMD_SETORDER = 112 '리그 순위 변경
	CMD_SETGIGOLEG = 113


	CMD_SAVERESULT = 901	'경기최종결과 저장


	Select Case CDbl(CMD)

	Case CMD_SAVERESULT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.saveResult.asp" --><%
	Response.End

	Case CMD_SETGIGOLEG
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setBeeGo.asp" --><%
	Response.End

	Case CMD_SETORDER
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setOrder.asp" --><%
	Response.End

	Case CMD_SETSAVETN
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setSaveTN.asp" --><%
	Response.End

	case CMD_GAMEINRC
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setresultWindow.asp" --><%
	Response.End


	case CMD_CHANGEORDER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changeorder.asp" --><%
	Response.End


	case CMD_SETDT2 '체전 2.1 2.2 2라운드 시간설정
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setDT2.asp" --><%
	Response.End

	case CMD_JRC
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jrc.asp" --><%
	Response.End

	case CMD_SETHURDLE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.sethurdle.asp" --><%
	Response.End

	case CMD_VALUATION
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.valuation.asp" --><%
	Response.End


	case CMD_SETJUDGE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setJudge.asp" --><%
	Response.End
	case CMD_SEARCHJUDGE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchJudge.asp" --><%
	Response.End


	'#################################################################


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

	case CMD_SEARCHPLAYERGROUP
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchplayergroup.asp" --><%
	Response.End

	case CMD_SEARCHPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchplayer.asp" --><%
	Response.End

	case CMD_SAVEJUDGE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.savejudge.asp" --><%
	Response.End




	case CMD_CHANGEPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changeplayer.asp" --><%
	Response.End

	Case CMD_CHANGEGROUPPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changegroupplayer.asp" --><%
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
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOK3_detail.asp" --><%
	Response.End
	case CMD_JRCOK2
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOK2_detail.asp" --><%
	Response.End
	case CMD_JRCOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOK_detail.asp" --><%
	Response.End
	case CMD_JRCOKA_1
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.jTypeAOKA_1_detail.asp" --><%
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
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rc01_typeA.asp" --><%
	Response.End
	case CMD_RC02
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rc02_detail.asp" --><%  ' 마장마술 상세 기입화면 (단체전 작업 시작 1)
	Response.End




	case CMD_RC03 '마장마술 저장
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rc03_MM.asp" --><%
	Response.End

	case CMD_MMRCOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.mmTypeOk_detail.asp" --><%  '마장마술 저장 (단체전 작업 2)
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
