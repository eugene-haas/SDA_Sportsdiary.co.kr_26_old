<%
  'request
  gameidx = oJSONoutput.IDX '게임인덱스
  strs1 = oJSONoutput.S1 '경기구분
  strs2 = oJSONoutput.S2 '경기유형
  strs3 = oJSONoutput.S3 '종목선택
  tabletype = oJSONoutput.TT '예선 본선 구분 (대진표 구분)
  subidx = oJSONoutput.SIDX '조별 인덱스

  If strs2 = "" Then
	strs2 = Left(strs3,3)
  End If

  If strs2 = "200" Then
	joinstr = " left "
    singlegame =  true
  Else
	joinstr = " inner "
	singlegame = false
  End If  


  Set db = new clsDBHelper

	SQL = "select stateNo from sd_TennisTitle where GameTitleIDX = " & gameidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'게임상태 0표시전, 1참가신청, 2신청마감, 3 예선발표 , 4 예선마감, 5 본선발표 , 6 본선마감 , 7 결과발표
	If Not eof then
		gamestate = rs("stateNo")
		Select Case gamestate
		Case "1" : statestr = "참가신청 중 입니다."
		Case "2" : statestr = "예선 추첨 중 입니다."
		End Select
	End if


	Select Case tabletype
	Case "0" ,"10","20"
		
		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		'strwhere = " a.GameTitleIDX = " & gameidx & " and a.gamekey1 = '" & strs1 & "' and a.gamekey2 = " & strs2 & " and  a.gamekey3 = " & strs3 & " and a.tryoutgroupno > 0 " 'a.tryoutgroupno 부전승 허수 맴버


		If tabletype = "10" Then
			strwhere = " a.GameTitleIDX = " & gameidx & " and  a.gamekey3 = " & strs3 & " and a.tryoutgroupno > 0 and a.gubun = 1 " 'a.tryoutgroupno 부전승 허수 맴버 gubun 1예선 2예선 종료
			strsort = " order by a.tryoutgroupno asc, a.t_rank asc" '결과순
		else
			strwhere = " a.GameTitleIDX = " & gameidx & " and  a.gamekey3 = " & strs3 & " and a.tryoutgroupno > 0 " 'a.tryoutgroupno 부전승 허수 맴버
			strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '게임순
		End if
		strAfield = " a. gamememberIDX, a.userName as aname , a.tryoutgroupno, a.tryoutsortno, a.teamAna as aNTN, a.teamBNa as aBTN, a.tryoutstateno, a.t_rank,a.key3name "
		strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo "
		strfield = strAfield &  ", " & strBfield 

		SQL = "select "& strfield &" from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		rscnt =  rs.RecordCount


		ReDim JSONarr(rscnt-1)

		i = 0
		Do Until rs.eof
			key3name = rs("key3name") '참가부명

		Set rsarr = jsObject() 
			rsarr("AID") = rs("gamememberIDX")
			rsarr("ANM") = rs("aname")
			rsarr("GNO") = rs("tryoutgroupno")
			rsarr("SNO") = rs("tryoutsortno")
			rsarr("ATANM") = rs("aNTN")
			rsarr("ATBNM") = rs("aBTN")
			rsarr("BID") = rs("partnerIDX")
			rsarr("BNM") = rs("bname")
			rsarr("BTANM") = rs("bATN")
			rsarr("BTBNM") = rs("bBTN")
			rsarr("PNO") = rs("positionNo") ' 파트너의 시작위치 정보 
			rsarr("STNO") = rs("tryoutstateno") '예선 진행 상태  0
			rsarr("RT1") = rs("t_rank") '예선 결과 순위 1 또는 2라면 통과
			Set JSONarr(i) = rsarr
		i = i + 1
		rs.movenext
		Loop
		datalen = Ubound(JSONarr) - 1




	Case "1", "11", "21"

		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		'strwhere = " a.GameTitleIDX = " & gameidx & " and  a.gamekey3 = " & strs3  & " and tryoutresult = 'pass'"
		strwhere = " a.GameTitleIDX = " & gameidx & " and  a.gamekey3 = " & strs3  & " and tryoutresult = 'pass'" '다시작업 gubun = 1 인것부터 가져와서
		strsort = " order by a.SortNo asc"
		
		strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aNTN, a.teamBNa as aBTN, a.Round as COL, a.SortNo as ROW  "
		strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo "
		strfield = strAfield &  ", " & strBfield

		SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		rscnt =  rs.RecordCount


		ReDim JSONarr(rscnt-1)

		i = 0
		Do Until rs.eof
		Set rsarr = jsObject() 
			rsarr("AID") = rs("gamememberIDX")
			rsarr("ANM") = rs("aname")
			'rsarr("GNO") = rs("groupno")

			rsarr("CO") = rs("COL")
			rsarr("RO") = rs("ROW")

			rsarr("ATANM") = rs("aNTN")
			rsarr("ATBNM") = rs("aBTN")
			rsarr("BID") = rs("partnerIDX")
			rsarr("BNM") = rs("bname")
			rsarr("BTANM") = rs("bATN")
			rsarr("BTBNM") = rs("bBTN")
			rsarr("PNO") = rs("positionNo") ' 파트너의 시작위치 정보 

			Set JSONarr(i) = rsarr
		i = i + 1
		rs.movenext
		Loop
		datalen = Ubound(JSONarr)


		'스코어 입력 정보 가져오기######################################

		'각결과 및 결과입력 상태값 
			strtable = " sd_TennisMember "
			strresulttable = " sd_TennisResult "
			'strwhere = " GameTitleIDX = " & gameidx & " and a.gamekey1 = '" & strs1 & "' and a.gamekey2 = " & strs2 & " and  a.gamekey3 = " & strs3  & " and b.gubun = 1  and a.tryoutgroupno = " & subidx 'gubun 1 본선
			strwhere = " GameTitleIDX = " & gameidx & " and a.gamekey3 = " & strs3  & " and b.gubun = 1  and a.tryoutgroupno = " & subidx 'gubun 1 본선

			strsort = " order by a.tryoutsortno asc"
			strAfield = " a. gamememberIDX as RIDX " '열 인덱스(기준)
			strBfield = " b.resultIDX as IDX, b.gameMemberIDX2 as CIDX, b.stateno as GSTATE " '인덱스 , 행 인덱스(대상) ,게임상태 ( 1, 진행 , 2, 종료 여부)
			strfield = strAfield &  ", " & strBfield 

			'SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1  where " & strwhere & strsort
			'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			'If Not rs.EOF Then 
			'	arrRS = rs.GetRows() 'RIDX, CIDX, GSTATE
			'End if

		'스코어 입력 정보 가져오기######################################








	Case "2", "12" ,"22" '예선 스코어 입력창
		If strs2 = "200" Then
			joinstr = " left "
			singlegame =  true
		Else
			joinstr = " inner "
			singlegame = false
		End if

		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		'strwhere = " GameTitleIDX = " & gameidx & " and a.gamekey1 = '" & strs1 & "' and a.gamekey2 = " & strs2 & " and  a.gamekey3 = " & strs3  & " and tryoutgroupno = " & subidx
		strwhere = " GameTitleIDX = " & gameidx & " and a.gamekey3 = " & strs3  & " and tryoutgroupno = " & subidx

		strsort = " order by a.tryoutsortno asc"
		strAfield = " a. gamememberIDX, a.userName as aname , a.tryoutgroupno, a.tryoutsortno, a.teamAna as aNTN, a.teamBNa as aBTN, a.tryoutstateno, a.t_win,t_tie,t_lose,t_rank "
		strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo "
		strfield = strAfield &  ", " & strBfield 

		SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		rscnt =  rs.RecordCount


		ReDim JSONarr(rscnt-1)

		i = 0
		Do Until rs.eof
		Set rsarr = jsObject() 
			rsarr("AID") = rs("gamememberIDX")
			rsarr("ANM") = rs("aname")
			rsarr("GNO") = rs("tryoutgroupno")
			rsarr("SNO") = rs("tryoutsortno")
			rsarr("ATANM") = rs("aNTN")
			rsarr("ATBNM") = rs("aBTN")
			rsarr("BID") = rs("partnerIDX")
			rsarr("BNM") = rs("bname")
			rsarr("BTANM") = rs("bATN")
			rsarr("BTBNM") = rs("bBTN")
			rsarr("PNO") = rs("positionNo") ' 파트너의 시작위치 정보 
			rsarr("STNO") = rs("tryoutstateno") '예선 진행 상태  0
			'rsarr("RT1") = rs("tryoutresult") '예선 결과

			rsarr("TWIN") = rs("t_win") 
			rsarr("TTIE") = rs("t_tie") 
			rsarr("TLOSE") = rs("t_lose")
			rsarr("TRANK") = rs("t_rank")
			Set JSONarr(i) = rsarr
		i = i + 1
		rs.movenext
		Loop
		datalen = Ubound(JSONarr) - 1


		'스코어 입력 정보 가져오기######################################

		'각결과 및 결과입력 상태값 
			strtable = " sd_TennisMember "
			strresulttable = " sd_TennisResult "
			'strwhere = " a.GameTitleIDX = " & gameidx & " and a.gamekey1 = '" & strs1 & "' and a.gamekey2 = " & strs2 & " and  a.gamekey3 = " & strs3  & " and b.gubun = 0  and a.tryoutgroupno = " & subidx 'gubun 0 예선
			strwhere = " a.GameTitleIDX = " & gameidx & " and a.gamekey3 = " & strs3  & " and b.gubun = 0  and a.tryoutgroupno = " & subidx 'gubun 0 예선

			strsort = " order by a.tryoutsortno asc"
			strAfield = " a. gamememberIDX as RIDX " '열 인덱스(기준)
			strBfield = " b.resultIDX as IDX, b.gameMemberIDX2 as CIDX, b.stateno as GSTATE " '인덱스 , 행 인덱스(대상) ,게임상태 ( 1, 진행 , 2, 종료 여부)
			strfield = strAfield &  ", " & strBfield 

			SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1 or a.gameMemberIDX = b.gameMemberIDX2   where " & strwhere & strsort
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then 
				arrRS = rs.GetRows() 'RIDX, CIDX, GSTATE
			End if


		'Response.write sql
		'스코어 입력 정보 가져오기######################################
	End Select

	'스코어 입력 정보 가져오기
	jsonstr = toJSON(JSONarr)
	Set ojson = JSON.Parse(jsonstr)

  db.Dispose
  Set db = Nothing

%>


<%
''=======================
'	Response.write SQL & "<br>"
'	Response.write "CMD > " & cmd & "<br>"
'	Response.write "게임인덱스 > " & gameidx & "<br>"
'	Response.write "경기구분 > " & strs1 & "<br>"
'	Response.write "경기유형 > " & strs2 & "<br>"
'	Response.write "종목선택 > " & strs3 & "<br>"
'	Response.write "예선본선구분 > " & tabletype & "<br>"
'	Response.write "조번호 > " & subidx & "<br>"

	'tabletype 
	'0 ,10  예선 , 결과예선
	'1 ,11  본선 , 결과 본선
'2  예선입력 
'=======================

Select Case tabletype
Case "0" ,"10","20"
%>
<!-- #include virtual = "/pub/api/inc/api.search0.asp" -->

<%Case "1", "11", "21"%>
<!-- #include virtual = "/pub/api/inc/api.search1.asp" -->

<%Case "2", "12" ,"22"%>
<!-- #include virtual = "/pub/api/inc/api.search2.asp" -->

<%End Select%>




