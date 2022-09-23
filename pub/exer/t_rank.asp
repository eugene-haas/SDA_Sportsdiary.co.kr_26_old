<!-- #include virtual = "/pub/header.mobileTennisAdmin.asp" -->

<%
	reqmidx = 14648
	rankno = 100
	tidx = 25
	levelno = "20104001"
	jono = 6

	Set db = new clsDBHelper


'순위구하기
If rankno = "100" Then
		'현조의 3명의 전적비교 해서 현재팀의 상황 확인
		'동일등수가 있다면 득실 비교
		'동일하다면 결과리턴
		'순위가 나온다면 순위설정 1등 또는 2등

		'select tbl.gamememberidx,tbl.rownum,tbl.wincnt, RANK() OVER (Order By tbl.RowNum asc,tbl.wincnt desc) AS RowNum  from (
		'	select ( select sum(jumsu) from 
		'	(select (case when gameMemberidx1 = t.gamememberidx then m1set1 else m2set1 end) as jumsu from sd_TennisResult 
		'	where (gamememberidx1 = t.gamememberidx or gamememberidx2 = t.gamememberidx)) a ) as wincnt, gamememberidx,RANK() OVER (Order By t_win desc,t_lose asc) AS RowNum,t_rank from sd_TennisMember as t where gubun = 1 and GameTitleIDX = 25 and gamekey3 = 20104001 and tryoutgroupno = 5 and DelYN = 'N' 
		') as tbl



		winsql = " select sum(jumsu) from (select (case when gameMemberidx1 = t.gamememberidx then m1set1 else m2set1 end) as jumsu from sd_TennisResult where  (gamememberidx1 = t.gamememberidx or gamememberidx2 = t.gamememberidx)) a "

		SQL = "select tbl.gamememberidx,tbl.rownum,tbl.wincnt, RANK() OVER (Order By tbl.RowNum asc,tbl.wincnt desc) AS RowNum,tbl.t_rank  from ( "

		SQL = SQL & "select ("&winsql&") as wincnt,  gamememberidx,RANK() OVER (Order By t_win asc) AS RowNum,t_rank " '원래순위도
		SQL = SQL & " from sd_TennisMember  as t "
		SQL = SQL & " where gubun = 1 and GameTitleIDX = " & tidx & " and gamekey3 = " & levelno & "  and tryoutgroupno =  " & jono & " and DelYN = 'N' "
		SQL = SQL & ") as tbl "
		'Response.write sql		
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrR = rs.GetRows()

		Call getrowsdrow(arrr)
		End If

		Dim samearr
		If IsArray(arrR)  Then

			strw = " "
			For ar = LBound(arrR, 2) To UBound(arrR,2)
				l_idx = arrR(0,ar)			'라인인덱스
				l_order = arrR(1,ar)		'순위값
				l_scoresum = arrR(2,ar)	'총승점
				l_rank = arrR(3,ar)		'구해진 순위
				l_orgrank = arrR(4,ar)	'원래순위
Response.write l_idx & "<br>"
				If CStr(l_idx) = CStr(reqmidx) Then
					my_orgrank = l_orgrank		'원래순위 (동일한순위인지 체크)
					my_rank = l_rank				'요청한맴버의 순위값
					
					rankno = l_rank				'순위

					If CStr(my_orgrank) = CStr(my_rank) Then '원래순위면 패스

						'Call oJSONoutput.Set("result", 0 )
						'strjson = JSON.stringify(oJSONoutput)
						'Response.Write strjson
						'Response.end						
					End if
				End If
			'Exit for
			Next

			For ar = LBound(arrR, 2) To UBound(arrR,2)
					l_idx = arrR(0,ar)				'멤버인덱스
					l_rank = arrR(3,ar)			'구해진 순위
					If CStr(l_idx) <> CStr(reqmidx) And CStr(l_rank) = Cstr(my_rank) Then '나말고 같은순위가 있다면
					'Call oJSONoutput.Set("result", 0 )
					'strjson = JSON.stringify(oJSONoutput)
					'Response.Write strjson
					'Response.end						
				End If
			Next
Response.write rankno

		End if
End if

%>