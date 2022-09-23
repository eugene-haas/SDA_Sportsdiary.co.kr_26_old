<%
'#############################################
'대회기록저장
'#############################################
	
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 
		idx = oJSONoutput.IDX
	End If

	If hasown(oJSONoutput, "INVAL") = "ok" Then  '오류 보냄....(사유만 넣어둠)
		inval = oJSONoutput.INVAL
	End if	

	If hasown(oJSONoutput, "WIN") = "ok" Then 
		winmidx = oJSONoutput.WIN
	End if	
	If hasown(oJSONoutput, "LR") = "ok" Then 
		winLR = oJSONoutput.LR
	End if	

	If winmidx = "" Then
		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson		
		Response.end
	End if

	
	Set db = new clsDBHelper 

	SQL = "update SD_gameMember_vs Set winmidx  = '"&winmidx&"',result = '"&winLR&"',sayoocode = '"&inval&"',scoreL = LPL1+LPL2+LPL3+LPL4+LPL5,scoreR = RPL1+RPL2+RPL3+RPL4+RPL5   where idx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)








		'다음라운드 진출 시킨다.
		'부전승 필드 업데이트 
		SQL = "select top 1  midxL,midxR,teamL,teamR,teamnmL,teamnmR ,roundno  ,orderno  "
		SQL = SQL & ",(case when midxL =  winmidx then 'W' else 'L' end) as LWL, (case when midxR =  winmidx then 'W' else 'L' end) as RWL , tidx,levelno,gangno   ,vsType   "
		SQL = SQL & "  from sd_gameMember_vs where idx = " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		sno = array(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31) '32강까지만
		arrUp = rs.GetRows()

		If IsArray(arrUp) Then  '부전이니까 업데이트 할대상을 찾자.
			vstype = arrUp(13,0)
			tidx = arrup(10,0)
			lno = arrup(11,0)

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
						lno = arrup(11,x)
						gangno = arrup(12,x)

						'If CDbl(gangno) > 2 Then '마지막 라운드가 아니라면 

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
								strwhere = " tidx = "&tidx&" and levelno = '"&lno&"' and delYN= 'N' and roundno="&nextroundno&" and orderno = "&nextorderno&" "
								SQL = " update sd_gameMember_vs set midx"&inLR&" = "&midxL&" , team"&inLR&" = '"&teamL&"', teamnm"&inLR&" = '"&teamnmL&"' where " & strwhere
								Call db.execSQLRs(SQL , null, ConStr)

								'Response.write sql
							End If
							If RWL = "W" Then
								strwhere = " tidx = "&tidx&" and levelno = '"&lno&"' and delYN= 'N' and roundno="&nextroundno&" and orderno = "&nextorderno&" "
								SQL = " update sd_gameMember_vs set midx"&inLR&" = "&midxR&" , team"&inLR&" = '"&teamR&"', teamnm"&inLR&" = '"&teamnmR&"' where " & strwhere
								Call db.execSQLRs(SQL , null, ConStr)

								'Response.write sql
							End If		
							
						'End if
				Next

			End if


			'승수 업데이트 (순위 업데이트)
			SQL = ""
			SQL = SQL & ";with cte_member as (select gameMemberIDX as mIdx from  sd_gameMember where gametitleidx = "&tidx&" and levelno = '"&lno&"' and delYN= 'N' ) "

			'memberIdx와 일치하는 게임의 idx를 구한다. ( 중복제거 ) 
			SQL = SQL & ", cte_gameIdx As ( "
			SQL = SQL & "select  idx	from sd_gameMember_vs As R  "
			SQL = SQL & "	Inner Join cte_member As M On ( (R.midxL = M.mIdx) Or (R.midxR = M.mIdx) )  "
			SQL = SQL & "	Where R.delYN = 'N' Group By idx)  "

			'게임 결과에서 해당 게임을 구한다. (idx와 일치하는 게임)
			SQL = SQL & ", cte_resultGame As ( "
			SQL = SQL & "	select R.* From sd_gameMember_vs As R Inner Join cte_gameIdx As I On I.idx = R.idx  "
			SQL = SQL & "		Where R.delYN = 'N' )"

			'각의 member에 대하여 total Count, left win Count, right win count를 구한다. 
			SQL = SQL & ", cte_result As ( "
			SQL = SQL & "	select  M.mIdx, "
			SQL = SQL & "			(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxL Or M. mIdx = R.midxR)) As cntTotal,		 "
			SQL = SQL & "			(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxL And M. mIdx = R.winmidx)) As cntLWin, "
			SQL = SQL & "			(Select count(idx) As TotalCnt From cte_resultGame As R Where R.delYN = 'N' And (M.mIdx = R.midxR And M. mIdx = R.winmidx)) As cntRWin	 "	
			SQL = SQL & "	from cte_member As M )"

			'total Count, left win Count, right win count를 이용하여 win count, lose count를 구한다. 
			'SQL = SQL & "	Select mIdx, (cntLWin+cntRWin) As cntWin, (cntTotal-(cntLWin+cntRWin)) As cntLose From cte_result "


			selecttbl  =  " ( Select b.tryoutresult , b.tryouttotalorder ,(cntLWin+cntRWin) As cntWin, (cntTotal-(cntLWin+cntRWin)) As cntLose  "
			selecttbl = selecttbl & " ,RANK() OVER (Order By (cntLWin+cntRWin) desc,(cntTotal-(cntLWin+cntRWin)) asc ) AS RowNum "
			selecttbl = selecttbl & " From cte_result as a inner join sd_gameMember as b on a.midx = b.gameMemberidx and b.delyn = 'N'  ) as A "
			SQL = SQL & " UPDATE A  SET A.tryoutresult= A.cntWin,  A.tryouttotalorder = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
			'resultfld = "tryoutresult" '승수
			'orderfld = "tryouttotalorder" '순위
		
		
		End If
		
	'gameMember 에 결과 저장 (순위)



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>