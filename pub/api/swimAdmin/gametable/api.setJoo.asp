<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	tidx = oJSONoutput.TitleIDX '게임타이틀 인덱스
	gamekey3 = oJSONoutput.S3KEY '게임종목 키
	gubun = oJSONoutput.GUBUN '게임종목 키
	levelkey = gamekey3

	gamekey3 = Left(gamekey3,5)
	gamekeyname = oJSONoutput.TeamNM '부명칭
	jono = oJSONoutput.JONO '조번호 (예선/순위결정 작업때 사용)
	delok = oJSONoutput.DELOK '삭제하고 다시 편성할지 결정

	If Left(gamekey3,3) = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " inner "
		singlegame = false
	End if  

	Set db = new clsDBHelper

	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strresulttable = " sd_TennisResult "
	
	If  CDbl(delok) = 0 then
		'gubun 업데이트 ( 토글 , 결과에 따라서 경고 별도 생성)
		If CDbl(gubun) = 1 Then

			'경기 결과가 있는지 확인
			strwhere = " a.delYN = 'N' and a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelkey  & " and b.gubun in (0,1)  and a.tryoutgroupno = " & jono
			strsort = " order by a.tryoutgroupno asc , a.tryoutsortno asc"
			strAfield = " a. gamememberIDX as RIDX " '열 인덱스(기준)
			strBfield = " b.resultIDX as IDX, b.gameMemberIDX2 as CIDX, b.stateno as GSTATE,b.courtno,b.leftetc,b.rightetc " '1P인덱스 ,결과인덱스, 2P인덱스 ,게임상태 ( 1, 진행 , 2, 종료 여부), 코트번호
			strfield = strAfield &  ", " & strBfield 
			SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1 where " & strwhere & strsort
			'Response.Write "SQL : " & SQL & "</br>"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then 
				resultRS = rs.GetRows() 'RIDX, CIDX, GSTATE, COURTNO
			End if

			If IsArray(resultRS) Then
				For r = LBound(resultRS, 2) To UBound(resultRS, 2) 
					r_m1idx = resultRS(0,r) 'p1
					r_ridx = resultRS(1,r) 'resultIDX
					r_m2idx = resultRS(2,r) 'c_p1
					r_state = resultRS(3,r)
					r_courtno = resultRS(4,r)
					r_leftetc = resultRS(5,r)
					r_rightetc = resultRS(6,r)
				Next
			
				Call oJSONoutput.Set("DELOK", 1 )
				Call oJSONoutput.Set("result", 101 )
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				db.Dispose
				Set db = Nothing
				Response.end
			End if
		End if
	Else
	

			
			'1.예선의 Result 지우기
			strwhere = " a.delYN = 'N' and a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelkey  & "  and a.tryoutgroupno = " & jono & " and a.gubun in(0, 1) "
			strfield = " b.resultIDX "
			SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1 where " & strwhere
			SQL = "Delete from "& strresulttable &" where resultIDX in (" & SQL & ")"
			Call db.execSQLRs(SQL , null, ConStr)
			'Response.Write SQL
			'Response.END
			'Response.End
			'2.편성 시 승리/패배, 장소에 대한 값 초기화 
			SQL = "UPDATE " & strtable & " SET t_win=0, t_lose=0, t_rank=0, place = '' WHERE delYN = 'N' and GameTitleIDX = " & tidx & " and gamekey3 = " & levelkey  & " and gubun in (0, 1)  and tryoutgroupno = " & jono
			Call db.execSQLRs(SQL , null, ConStr)
			'Response.Write SQL
			'Response.END

			'3. 2라운드 전까지 같은 조의  1위, 2위 본선, 본선 결과 지우기 
			SQL = "select a.gameMemberIDX from sd_TennisMember as a inner JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX "
			SQL = SQL & " where a.GameTitleIDX = " & tidx & " and a.gamekey3 = "  & levelkey & " and a.tryoutgroupno = "&jono&" and DelYN = 'N' and a.gubun in (2, 3) and a.Round < 3 "
			'Response.Write SQL
			'Response.END
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			Do Until rs.eof
				delidx2 = rs(0)
				'Response.write "delidx" & delidx&"</br>"
				SQL = "delete from " & strtable & " where gamememberIDX = " & delidx2
				'Response.Write SQL &"<br>"
				Call db.execSQLRs(SQL , null, ConStr)

				SQL = "delete from " & strtablesub  & " where gamememberIDX = " & delidx2
				'Response.Write SQL &"<br>"
				Call db.execSQLRs(SQL , null, ConStr)

				SQL = "delete from " & strresulttable  & " where gameMemberIDX1 = " & delidx2
				'Response.Write SQL &"<br>"
				Call db.execSQLRs(SQL , null, ConStr)

				SQL = "delete from " & strresulttable  & " where gameMemberIDX2 = " & delidx2
				'Response.Write SQL &"<br>"
				Call db.execSQLRs(SQL , null, ConStr)
				rs.movenext
			Loop
			
			SQL = " select a.userName"
			SQL = SQL & " from sd_TennisMember as a LEFT JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX "
			SQL = SQL & " where a.GameTitleIDX =  " & tidx & "  and a.gamekey3 = " & levelkey  & " and a.DelYN = 'N' and  a.tryoutgroupno = "&jono&" and a.gubun in ( 0, 1)"
			'Response.write SQL
			'Response.END
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			'3. 본선 2라운드 전까지 조를 알 수 없는 경우, 이름으로 찾아서  1위, 2위 본선, 본선 결과 지우기 
			Do Until rs.eof
					rUserName = rs(0) 'p1
					'Response.Write rUserName & "<br>"
					SQL = " select a.gameMemberIDX"
					SQL = SQL & " from sd_TennisMember as a LEFT JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX "
					SQL = SQL & " where a.GameTitleIDX =  " & tidx & "  and a.gamekey3 = " & levelkey  & " and a.DelYN = 'N' and a.userName = '"& rUserName &"' and a.gubun in ( 2, 3) and a.Round < 3 "
					'SQL = SQL & " where a.GameTitleIDX =  " & tidx & "  and a.gamekey3 = " & levelkey  & " and a.DelYN = 'N' and a.userName = '"& rUserName &"' and a.gubun in ( 2, 3)  "
					'Response.Write SQL &"<br>"
					Set rsSub = db.ExecSQLReturnRS(SQL , null, ConStr)
					
					Do Until rsSub.eof
						delidx2 = rsSub(0)
						'Response.write "delidx" & delidx&"</br>"
						SQL = "delete from " & strtable & " where gamememberIDX = " & delidx2
						Call db.execSQLRs(SQL , null, ConStr)
						'Response.Write SQL &"<br>"
						SQL = "delete from " & strtablesub  & " where gamememberIDX = " & delidx2
						Call db.execSQLRs(SQL , null, ConStr)
						'Response.Write SQL &"<br>"
						SQL = "delete from " & strresulttable  & " where gameMemberIDX1 = " & delidx2
						Call db.execSQLRs(SQL , null, ConStr)
						'Response.Write SQL &"<br>"
						SQL = "delete from " & strresulttable  & " where gameMemberIDX2 = " & delidx2
						Call db.execSQLRs(SQL , null, ConStr)
						'Response.Write SQL &"<br>"
						rsSub.movenext
					Loop
				rs.movenext
			Loop
			'Response.End
	End if

	if gubun = 0 Then
		gubun = 1 
	else 
		gubun = 0
	END IF

  '적용전 상태 =============================================s
	Call oJSONoutput.Set("ALLDROW", true ) '전체새로고침
	If CDbl(gubun) = 0 then
		SQL = "select gubun from  sd_TennisMember where  GameTitleIDX = " & tidx & " and  gamekey3 = " & levelkey & " and tryoutgroupno > 0  and gubun in ( 0, 1) and DelYN = 'N' " 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then 
			arrRSALL = rs.getrows()
		End If
		Set rs = Nothing

		'조편성 상태 확인하기
		If IsArray(arrRSALL) Then
		For ar = LBound(arrRSALL, 2) To UBound(arrRSALL, 2) 
		  chk_gn = arrRSALL(0,ar)
		  If chk_gn = 0 Then
			oJSONoutput.ALLDROW = false
			Exit For
		  End if
		Next
		End If
	End if
  '적용전 상태 =============================================e

	'참가자 목록 (예선 리그)
	strwhere = " GameTitleIDX = " & tidx & " and  gamekey3 = " & levelkey & " and tryoutgroupno = " & jono & " and gubun in (0,1) "
	SQL = "Update " & strtable & " Set gubun = " & gubun &","
	SQL = SQL & " areaChanging = 'N',"
	SQL = SQL & " Rndno1 = case when gubun = 1 then 0 end,"
	SQL = SQL & " Rndno2 = case when gubun = 1 then 0 end"
	SQL = SQL & " where " & strwhere 
	Call db.execSQLRs(SQL , null, ConStr)



  '적용후 상태 =============================================s
	If CDbl(gubun) = 1 Then '편성완료됨 0 -> 1
		'전체 편성완료 여부확인
		SQL = "select gubun from  sd_TennisMember where  GameTitleIDX = " & tidx & " and  gamekey3 = " & levelkey & " and tryoutgroupno > 0  and gubun in ( 0, 1) and DelYN = 'N' " 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then 
			arrRSALL = rs.getrows()
		End If
		Set rs = Nothing

		'조편성 상태 확인하기
		If IsArray(arrRSALL) Then
		For ar = LBound(arrRSALL, 2) To UBound(arrRSALL, 2) 
		  chk_gn = arrRSALL(0,ar)
		  If chk_gn = 0 Then
			oJSONoutput.ALLDROW = false
			Exit For
		  End if
		Next
		End If 


	Else '편성상태됨 1 -> 0
		'이전 편성상태가 ALL 이라면 
		If oJSONoutput.ALLDROW = True Then
			'전체 다시그림 호출
			oJSONoutput.ALLDROW = true
		End if
	end If
  '적용후 상태 =============================================e




	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>