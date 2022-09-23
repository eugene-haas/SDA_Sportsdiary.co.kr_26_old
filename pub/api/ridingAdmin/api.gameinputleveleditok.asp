<%
'#############################################

'수정

'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		parr= oJSONoutput.PARR
		reqarr = Split(parr,",")		'//년도, 개인/단체, 종목, 마종, 클레스, 클레스안내, 대회일자, 대회시간, 신청시작일, 신청시작시간 , 신청종료일, 신청종료시간, 초등부, 금액,  대학부, 금액, 중등부, 금액, 일반부 , 금액, 고등부, 금액, 동호인부 , 금액

		idx = reqarr(0) 'idx

		p_1 = reqarr(1) '년도
		p_2 = reqarr(2) '개인/단체
		p_3 = reqarr(3) '종목
		p_4 = reqarr(4) '마종
		p_5 = reqarr(5) '클레스
		p_6 = reqarr(6) '클레스안내
		
		SQL = "select top 1 GbIDX from tblRGameLevel where RGameLevelidx = " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		org_teamGbIDX = rs(0) '기존

		
		WhereStr = " useyear = '"&p_1&"' and levelno = '"&p_4&"' and ridingclass = '"&p_5&"' and ridingclasshelp = '"&p_6&"' "
		SQL = "select top 1 teamGbIDX from tblTeamGbInfo where " &  WhereStr
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			teamGbIDX = rs(0) '종목상세구분인덱스
		Else
			teamGbIDX = ""
		End if

		If CStr(org_teamGbIDX) <> CStr(teamGbIDX) Then
			Call oJSONoutput.Set("result", "7" ) '수정시 세부종목 변경 불가
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.End			
		End if

		p_7 = reqarr(7) '대회일자
		p_8 = reqarr(8) '대회시간
		p_9 = reqarr(9) '신청시작일
		p_10 = reqarr(10) '신청시작시간
		p_11 = reqarr(11) '종료일
		p_12 = reqarr(12) '종료시간
		'#################
		p_13 = reqarr(13) '초등부 
		p_14 = reqarr(14) '초등금액
'		If p_13 = "" Then p_13 = "N" End if
		If p_14 = "" Then p_14 = 0 End if

		p_15 = reqarr(15) '대학부
		p_16 = reqarr(16) '대학금액
'		If p_15 = "" Then p_15 = "N" End if
		If p_16 = "" Then p_16 = 0 End if

		p_17 = reqarr(17) '중등부 
		p_18 = reqarr(18) '중등금액
'		If p_17 = "" Then p_17 = "N" End if
		If p_18 = "" Then p_18 = 0 End if

		p_19 = reqarr(19) '일반부
		p_20 = reqarr(20) '일반금액
'		If p_19 = "" Then p_19 = "N" End if
		If p_20 = "" Then p_20 = 0 End if

		p_21 = reqarr(21) '고등부 
		p_22 = reqarr(22) '고등금액
'		If p_21 = "" Then p_21 = "N" End if
		If p_22 = "" Then p_22 = 0 End if

		p_23 = reqarr(23) '동호부
		p_24 = reqarr(24) '동호금액
'		If p_23 = "" Then p_23 = "N" End if
		If p_24 = "" Then p_24 = 0 End if
	End if

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx =   oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "TITLE") = "ok" then
		title =   oJSONoutput.TITLE
	End If

	'통합부서가 있는지 체크후 
	SQL = "select top 1 pubcode from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and gbidx = "&org_teamGbIDX&"  and pubcode > 6 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
			Call oJSONoutput.Set("result", "8" ) '부서통합작업 진행됨 해제후 수정요청
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.End			
	End if



	'등록된 gbidx 가 있는지 우선 검사.
	SQL = "select gameno,GbIDX from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" group by gameno, gbidx order by gameno desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	i = 1
	Do Until rs.eof
		gameno = rs(0)
		If i = 1 Then
			nextgameno = CDbl(gameno) + 1
		End if
		gbidx = rs(1)
		If CStr(gbidx) = CStr(teamGbIDX) Then
			inggameno = gameno
		End if
	i = i + 1
	rs.movenext
	loop
	If nextgameno = "" Then
		nextgameno = 1
	End If

	If inggameno = "" Then
		inggameno = nextgameno	
	End If
			
	gamedate = Replace(P_7,"/","-")
	gametime = Left(setTimeFormat(P_8& ":00"),5)

	attdateS = Replace(P_9,"/","-") & " " & setTimeFormat(P_10& ":00")
	attdateE = Replace(P_11,"/","-") & " " & setTimeFormat(P_12& ":00")






	
	sub setPubProc(ByVal chkbtnval, ByVal pcode, ByVal pnm, ByVal fee)
		Dim SQL, rs ,insertvalue,insertfield, upfield, engcode
		
		insertfield = " gameno,gamenostr,GameTitleIDX,GbIDX,pubcode,engcode,pubName,attdateS,attdateE,GameDay,GameTime,levelno,fee "

		Select Case CStr(pcode)
		Case "1" :  engcode = "EXXXXX"
		Case "2" :  engcode = "XMXXXX"
		Case "3" :  engcode = "XXHXXX"
		Case "4" :  engcode = "XXXUXX"
		Case "5" :  engcode = "XXXXGX"
		Case "6" :  engcode = "XXXXXC"
		End Select 

		If chkbtnval = "Y" Then '초등...
			SQL = "select RGameLevelidx from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and GbIDX = '"&teamGbIDX&"' and pubcode = '"&pcode&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rs.eof Then
				insertvalue = " '"&inggameno&"','"&inggameno&"',"&tidx&",'"&teamGbIDX&"','"&pcode&"','"&engcode&"','"&pnm&"','"&attdateS&"','"&attdateE&"','"&gamedate&"','"&gametime&"','"& p_4 &"','"&fee&"' "  
				SQL = "INSERT INTO tblRGameLevel ( "&insertfield&" ) VALUES ( "&insertvalue&" )"
				Call db.execSQLRs(SQL , null, ConStr)
			Else
				
				upfield = " attdateS = '"&attdateS&"',attdateE = '"&attdateE&"',GameDay = '"&gamedate&"',GameTime = '"&gametime&"',fee = '"&fee&"' "
				SQL = "Update tblRGameLevel Set " & upfield &  " where DelYN='N' and GameTitleIDX = "&tidx&" and GbIDX = '"&teamGbIDX&"' and pubcode = '"&pcode&"' "
				Call db.execSQLRs(SQL , null, ConStr)
				'update
			End if

		Else 'N
			SQL = "select RGameLevelidx,gametitleidx,gbidx from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and GbIDX = '"&teamGbIDX&"' and pubcode = '"&pcode&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof Then
				'통합부에서 합침때 복구됨 (추후 트리거 생성 요) 삭제에도....
				'SQL = "Update tblRGameLevel Set DelYN = 'Y' where RGameLevelidx = " & rs(0) 'delete
				SQL = "Delete from tblRGameLevel where RGameLevelidx = " & rs(0) 'delete
				Call db.execSQLRs(SQL , null, ConStr)

				'참가자도 지우자.
				'Sql = "update  tblGameRequest Set   DelYN = 'Y' where gbIDX = " & teamGbIDX & " and GameTitleIDX = " & tidx & " and pubcode = '"&pcode&"' "
				SQL = "Delete from tblGameRequest  where gbIDX = " & teamGbIDX & " and GameTitleIDX = " & tidx & " and pubcode = '"&pcode&"' "
				Call db.execSQLRs(SQL , null, ConStr)

				'대진표도
				'Sql = "update  sd_tennisMember Set DelYN = 'Y' where gamekey3 = " & teamGbIDX & " and GameTitleIDX = " & tidx & " and pubcode = '"&pcode&"' "
				SQL = "Delete from sd_tennisMember where gamekey3 = " & teamGbIDX & " and GameTitleIDX = " & tidx & " and pubcode = '"&pcode&"' "
				Call db.execSQLRs(SQL , null, ConStr)			
			
			End if		
		End If
	End sub 



	Call setPubProc( P_13, "1", "초등부", P_14)
	Call setPubProc( P_15, "4", "대학부", P_16)
	Call setPubProc( P_17, "2", "중등부", P_18)
	Call setPubProc( P_19, "5", "일반부", P_20)
	Call setPubProc( P_21, "3", "고등부", P_22)
	Call setPubProc( P_23, "6", "동호인부", P_24)



	'날짜 순서대로 번호를 자동소팅한다.
	Selecttbl = "( SELECT gameno,DENSE_RANK() OVER (ORDER BY GameDay asc,gameno) AS RankNum  FROM tblRGameLevel where DelYN = 'N' and GameTitleIDX = "&tidx&" ) AS A "
	SQL = "UPDATE A  SET A.gameno = A.RankNum FROM " & selecttbl
	Call db.execSQLRs(SQL , null, ConStr)




	'최대 최소값으로 업데이트 하자...신청날짜 
	SQL = " Select min(attdates), max(attdatee) from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If isnull(rs(0)) = True  Then
		SQL = "update sd_tennisTitle set atts = '"&attdateS&"' , atte = '"&attdateE&"' where gametitleidx = "& tidx
		Call db.execSQLRs(SQL , null, ConStr)
	Else
		atts = Left(rs(0),10)
		atte = Left(rs(1),10)
		SQL = "update sd_tennisTitle set atts = '"&atts&"' , atte = '"&atte&"' where gametitleidx = "& tidx
		Call db.execSQLRs(SQL , null, ConStr)	
	End if
	'최대 최소값으로 업데이트 하자...신청날짜 



%><!-- #include virtual = "/pub/html/riding/gameinfolevellist.asp" --><%


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>