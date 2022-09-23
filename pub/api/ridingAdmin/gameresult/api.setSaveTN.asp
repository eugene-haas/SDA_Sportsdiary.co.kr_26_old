<%
'#############################################
'대회기록저장
'#############################################
	
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 
		idx = oJSONoutput.IDX
	End If



	If hasown(oJSONoutput, "LIDX") = "ok" Then 
		midxL = oJSONoutput.LIDX
	End if	
	If hasown(oJSONoutput, "RIDX") = "ok" Then 
		midxR = oJSONoutput.RIDX
	End if	
	If hasown(oJSONoutput, "LR") = "ok" Then 
		winLR = oJSONoutput.LR
	End if	

	If winLR = "L" Then
		winmidx = midxL
	Else
		winmidx = midxR	
	End if

	
	Set db = new clsDBHelper 

	SQL = "update SD_gameMember_vs Set winmidx  = '"&winmidx&"',result = '"&winLR&"'   where idx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)


		'다음라운드 진출 시킨다.
		SQL = "select top 1  midxL,midxR,teamL,teamR,teamnmL,teamnmR ,roundno  ,orderno  "
		SQL = SQL & ",(case when midxL =  winmidx then 'W' else 'L' end) as LWL, (case when midxR =  winmidx then 'W' else 'L' end) as RWL , tidx,gbidx,gangno   ,vsType   "
		SQL = SQL & "  from sd_gameMember_vs where idx = " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		sno = array(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31) '32강까지만
		arrUp = rs.GetRows()

		If IsArray(arrUp) Then  '업데이트 할대상을 찾자.
			vstype = arrUp(13,0)
			tidx = arrup(10,0)
			gbidx = arrup(11,0)

			If vstype = "T" Then '토너먼트

				For x = LBound(arrUp, 2) To UBound(arrUp, 2)
						midxL = arrUP(0,x)
						midxR = arrUP(1,x)
						teamL = arrUP(2,x)
						teamR = arrUp(3,x)
						teamnmL = arrUp(4,x)
						teamnmR = arrUp(5,x)
						roundno = arrUp(6,x)
						orderno = arrUp(7,x)
						LWL = arrup(8,x)
						RWL = arrup(9,x)
						tidx = arrup(10,x)
						gbidx = arrup(11,x)
						gangno = arrup(12,x)

						
						If CDbl(gangno) = 0 Then '3 4위전
							'상대의 순위를 4등으로 업데이트 하다.
							If LWL = "W" Then
							SQL34  = " UPDATE sd_tennisMember  SET tryoutresult = tryoutresult + 1,  total_order = 4  where  gameMemberIDx = " & midxR
							Else
							SQL34  = " UPDATE sd_tennisMember  SET tryoutresult = tryoutresult + 1,  total_order = 4  where  gameMemberIDx = " & midxL
							End if

						else

							nextroundno = CDbl(roundno) + 1
							nextorderno =  Fix(CDbl(orderno/2)) 

							If nextorderno Mod 2 = 0 Then '짝수라면
								nextorderno =  nextorderno + 1
							End if

							For s = 0 to ubound(sno)
								If CDbl(orderno) = sno(s) Then
									chkLR = orderno - s - 1
								End if
							next

							If chkLR Mod 2 = 0 Then '짝수면 왼족에 넣고
								inLR = "L"
							Else '홀수면 오른쪽에 넣고
								inLR = "R"
							End If

							If LWL = "W" Then
								strwhere = " tidx = "&tidx&" and gbidx = '"&gbidx&"' and delYN= 'N' and roundno="&nextroundno&" and orderno = "&nextorderno&" "
								SQL = " update sd_gameMember_vs set midx"&inLR&" = "&midxL&" , team"&inLR&" = '"&teamL&"', teamnm"&inLR&" = '"&teamnmL&"' where " & strwhere
								Call db.execSQLRs(SQL , null, ConStr)

								'3 4위전 선수 업데이트 (진사람 넣기)
								If CDbl(gangno) = 4 Then
									strwhere = " tidx = "&tidx&" and gbidx = '"&gbidx&"' and delYN= 'N' and roundno=0 and orderno = 1 "
									SQL = " update sd_gameMember_vs set midx"&inLR&" = "&midxR&" , team"&inLR&" = '"&teamR&"', teamnm"&inLR&" = '"&teamnmR&"' where " & strwhere
									Call db.execSQLRs(SQL , null, ConStr)
								End If
								
							End If

							If RWL = "W" Then
								strwhere = " tidx = "&tidx&" and gbidx = '"&gbidx&"' and delYN= 'N' and roundno="&nextroundno&" and orderno = "&nextorderno&" "
								SQL = " update sd_gameMember_vs set midx"&inLR&" = "&midxR&" , team"&inLR&" = '"&teamR&"', teamnm"&inLR&" = '"&teamnmR&"' where " & strwhere
								Call db.execSQLRs(SQL , null, ConStr)

								'3 4위전 선수 업데이트 
								If CDbl(gangno) = 4 Then
									strwhere = " tidx = "&tidx&" and gbidx = '"&gbidx&"' and delYN= 'N' and roundno=0 and orderno = 1 "
									SQL = " update sd_gameMember_vs set midx"&inLR&" = "&midxL&" , team"&inLR&" = '"&teamL&"', teamnm"&inLR&" = '"&teamnmL&"' where " & strwhere
									Call db.execSQLRs(SQL , null, ConStr)
								End If
							End If		
							
						End if
				Next

			End if

			'###################################
			' 쿼리확인용
			'###################################
				';with cte_member as (select gameMemberIDX as mIdx from sd_tennisMember where gametitleidx = 45 and gamekey3 = '191' and delYN= 'N' ) 
				', cte_gameIdx As ( select idx from sd_gameMember_vs As R Inner Join cte_member As M On ( (R.midxL = M.mIdx) Or (R.midxR = M.mIdx) ) Where R.delYN = 'N' Group By idx) 
				', cte_resultGame As ( select R.* From sd_gameMember_vs As R Inner Join cte_gameIdx As I On I.idx = R.idx Where R.delYN = 'N' )
				', cte_result As
				'( select 
				'    M.mIdx 
				'	,(Select MAX(roundno) as rndno from cte_resultGame as R where R.delYN = 'N' And (M.mIdx = R.midxL Or M. mIdx = R.midxR)) As roundNo
				'	,(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxL Or M. mIdx = R.midxR)) As cntTotal
				'	,(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxL And M. mIdx = R.winmidx)) As cntLWin
				'	,(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxR And M. mIdx = R.winmidx)) As cntRWin 
				'	
				'	from cte_member As M )
				'  select * from cte_result
			'###################################


If vstype = "T" Then
			'승수 업데이트 (순위 업데이트)
			SQL = ""
			SQL = SQL & ";with cte_member as (select gameMemberIDX as mIdx from  sd_tennisMember where gametitleidx = "&tidx&" and gamekey3 = '"&gbidx&"' and delYN= 'N' ) "

			'memberIdx와 일치하는 게임의 idx를 구한다. ( 중복제거 ) 
			SQL = SQL & ", cte_gameIdx As ( "
			SQL = SQL & "select  idx	from sd_gameMember_vs As R  "
			SQL = SQL & "	Inner Join cte_member As M On ( (R.midxL = M.mIdx) Or (R.midxR = M.mIdx) )  "
			SQL = SQL & "	Where R.delYN = 'N' and R.roundno > 0 Group By idx)   "

			'게임 결과에서 해당 게임을 구한다. (idx와 일치하는 게임)
			SQL = SQL & ", cte_resultGame As ( "
			SQL = SQL & "	select R.* From sd_gameMember_vs As R Inner Join cte_gameIdx As I On I.idx = R.idx  "
			SQL = SQL & "		Where R.delYN = 'N'   and R.roundno > 0  )"

			'각의 member에 대하여 total Count, left win Count, right win count를 구한다. 
			SQL = SQL & ", cte_result As ( "
			SQL = SQL & "	select  M.mIdx "
			SQL = SQL & "			,(Select MAX(roundno) as rndno from cte_resultGame as R where R.delYN = 'N' And (M.mIdx = R.midxL Or M. mIdx = R.midxR)) As roundNo "
			SQL = SQL & "			,(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxL Or M. mIdx = R.midxR)) As cntTotal	 "
			SQL = SQL & "			,(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxL And M. mIdx = R.winmidx)) As cntLWin "
			SQL = SQL & "			,(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxR And M. mIdx = R.winmidx)) As cntRWin "	
			SQL = SQL & "	from cte_member As M )"

			'total Count, left win Count, right win count를 이용하여 win count, lose count를 구한다. 
			'SQL = SQL & "	Select mIdx, (cntLWin+cntRWin) As cntWin, (cntTotal-(cntLWin+cntRWin)) As cntLose From cte_result "

			'** sd_tennisMember.roundno 올라간 최종 라운드 번호순서 1~~~
			selecttbl  =  " ( Select b.tryoutresult , b.round as bno ,A.roundNo as ano, b.total_order ,(cntLWin+cntRWin) As cntWin, (cntTotal-(cntLWin+cntRWin)) As cntLose  "
			selecttbl = selecttbl & " ,RANK() OVER (Order By (cntLWin+cntRWin) desc,(cntTotal-(cntLWin+cntRWin)) asc ) AS RowNum "
			selecttbl = selecttbl & " From cte_result as a inner join sd_tennisMember as b on a.midx = b.gameMemberidx and b.delyn = 'N'  ) as A "
			SQL = SQL & " UPDATE A  SET A.tryoutresult= A.cntWin,  A.total_order = A.RowNum  ,A.bno = A.ano FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
			'resultfld = "tryoutresult" '승수
			'orderfld = "tryouttotalorder" '순위
		

			If SQL34 <> "" then
			Call db.execSQLRs(SQL34 , null, ConStr)
			End if
Else

			'승수 업데이트 (순위 업데이트)
			SQL = ""
			SQL = SQL & ";with cte_member as (select gameMemberIDX as mIdx from  sd_tennisMember where gametitleidx = "&tidx&" and gamekey3 = '"&gbidx&"' and delYN= 'N' ) "

			'memberIdx와 일치하는 게임의 idx를 구한다. ( 중복제거 ) 
			SQL = SQL & ", cte_gameIdx As ( "
			SQL = SQL & "select  idx	from sd_gameMember_vs As R  "
			SQL = SQL & "	Inner Join cte_member As M On ( (R.midxL = M.mIdx) Or (R.midxR = M.mIdx) )  "
			SQL = SQL & "	Where R.delYN = 'N' Group By idx)   "

			'게임 결과에서 해당 게임을 구한다. (idx와 일치하는 게임)
			SQL = SQL & ", cte_resultGame As ( "
			SQL = SQL & "	select R.* From sd_gameMember_vs As R Inner Join cte_gameIdx As I On I.idx = R.idx  "
			SQL = SQL & "		Where R.delYN = 'N'  )"

			'각의 member에 대하여 total Count, left win Count, right win count를 구한다. 
			SQL = SQL & ", cte_result As ( "
			SQL = SQL & "	select  M.mIdx "
			SQL = SQL & "			,(Select MAX(roundno) as rndno from cte_resultGame as R where R.delYN = 'N' And (M.mIdx = R.midxL Or M. mIdx = R.midxR)) As roundNo "
			SQL = SQL & "			,(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxL Or M. mIdx = R.midxR) and R.result is not Null) As cntTotal	 "
			SQL = SQL & "			,(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxL And M. mIdx = R.winmidx)) As cntLWin "
			SQL = SQL & "			,(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxR And M. mIdx = R.winmidx)) As cntRWin "	
			SQL = SQL & "	from cte_member As M )"

			'total Count, left win Count, right win count를 이용하여 win count, lose count를 구한다. 
			'SQL = SQL & "	Select mIdx, (cntLWin+cntRWin) As cntWin, (cntTotal-(cntLWin+cntRWin)) As cntLose From cte_result "

			'** sd_tennisMember.roundno 올라간 최종 라운드 번호순서 1~~~
			selecttbl  =  " ( Select b.t_win,t_lose , b.round as bno ,A.roundNo as ano, b.total_order ,(cntLWin+cntRWin) As cntWin, (cntTotal-(cntLWin+cntRWin)) As cntLose  "
			selecttbl = selecttbl & " ,RANK() OVER (Order By (cntLWin+cntRWin) desc,(cntTotal-(cntLWin+cntRWin)) asc ) AS RowNum "
			selecttbl = selecttbl & " From cte_result as a inner join sd_tennisMember as b on a.midx = b.gameMemberidx and b.delyn = 'N'  ) as A "
			SQL = SQL & " UPDATE A  SET A.t_win= A.cntWin ,A.t_lose = A.cntLose,  A.total_order = A.RowNum  ,A.bno = A.ano FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)



			'승자승 원칙 적용은 마지막에
			'경기가 끝났니 
			'			SQL = "select idx from sd_gameMember_vs where  tidx ="&tidx&" gbidx = "&gbidx&" and winmidx is Null "
			'			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			'			If isNull(rs(0)) = True then
			'				'리그 중복순위가 있는 맴버는 누구고 중복순위는
			'				SQL = "SELECT total_order FROM sd_tennisMember WHERE gametitleidx = "&tidx&" and gamekey3 = "&gbidx&" and delyn = 'N' and total_order IN (SELECT total_order FROM sd_tennisMember where gametitleidx = "&tidx&" and gamekey3 = "&gbidx&" and delyn = 'N' GROUP BY total_order HAVING COUNT(*) > 1 ) group by total_order "
			'				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			'
			'				Do Until rs.eof 
			'					totalorder = rs(0)
			'					SQL = "SELECT gameMemberIDX,total_order FROM sd_tennisMember WHERE gametitleidx = "&tidx&" and gamekey3 = "&gbidx&" and delyn = 'N' and total_order IN (SELECT total_order FROM sd_tennisMember where gametitleidx = "&tidx&" and gamekey3 = "&gbidx&" and delyn = 'N' and total_order="&totalorder&" GROUP BY total_order HAVING COUNT(*) > 1 ) group by totalorder "
			'				rs.movenext
			'				loop
			'			End if





End if


		End If
		
	'gameMember 에 결과 저장 (순위)



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>