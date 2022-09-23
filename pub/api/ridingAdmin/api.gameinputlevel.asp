<%
'#############################################

'대회종목저장

'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		parr= oJSONoutput.PARR
		reqarr = Split(parr,",")		'//년도, 개인/단체, 종목, 마종, 클레스, 클레스안내, 대회일자, 대회시간, 신청시작일, 신청시작시간 , 신청종료일, 신청종료시간, 초등부, 금액,  대학부, 금액, 중등부, 금액, 일반부 , 금액, 고등부, 금액, 동호인부 , 금액

		p_1 = reqarr(0) '년도
		p_2 = reqarr(1) '개인/단체
		p_3 = reqarr(2) '종목
		p_4 = reqarr(3) '마종
		p_5 = reqarr(4) '클레스
		p_6 = reqarr(5) '클레스안내
		
		WhereStr = " useyear = '"&p_1&"' and levelno = '"&p_4&"' and ridingclass = '"&p_5&"' and ridingclasshelp = '"&p_6&"' "
		SQL = "select top 1 teamGbIDX from tblTeamGbInfo where " &  WhereStr
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			teamGbIDX = rs(0) '종목상세구분인덱스
		Else
			teamGbIDX = ""
		End if

		p_7 = reqarr(6) '대회일자
		p_8 = reqarr(7) '대회시간
		p_9 = reqarr(8) '신청시작일
		p_10 = reqarr(9) '신청시작시간
		p_11 = reqarr(10) '종료일
		p_12 = reqarr(11) '종료시간
		'#################
		p_13 = reqarr(12) '초등부 
		p_14 = reqarr(13) '초등금액
		If p_14 = "" Then p_14 = 0 End if

		p_15 = reqarr(14) '대학부
		p_16 = reqarr(15) '대학금액
		If p_16 = "" Then p_16 = 0 End if

		p_17 = reqarr(16) '중등부 
		p_18 = reqarr(17) '중등금액
		If p_18 = "" Then p_18 = 0 End if

		p_19 = reqarr(18) '일반부
		p_20 = reqarr(19) '일반금액
		If p_20 = "" Then p_20 = 0 End if

		p_21 = reqarr(20) '고등부 
		p_22 = reqarr(21) '고등금액
		If p_22 = "" Then p_22 = 0 End if

		p_23 = reqarr(22) '동호부
		p_24 = reqarr(23) '동호금액
		If p_24 = "" Then p_24 = 0 End if
	End if

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx =   oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "TITLE") = "ok" then
		title =   oJSONoutput.TITLE
	End If


	'통합부서가 있는지 체크후 
	SQL = "select top 1 pubcode from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and gbidx = "&teamGbIDX&"  and pubcode > 6 "
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


	insertfield = " gameno,gamenostr,GameTitleIDX,GbIDX,pubcode,engcode,pubName,attdateS,attdateE,GameDay,GameTime,levelno,fee "
	If P_13 = "Y" Then '초등
		pubcode = "1"
		pubName = "초등부"
		SQL = "select RGameLevelidx from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and GbIDX = '"&teamGbIDX&"' and pubcode = '"&pubcode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			insertvalue = " '"&inggameno&"','"&inggameno&"',"&tidx&",'"&teamGbIDX&"','"&pubcode&"','EXXXXX','"&pubName&"','"&attdateS&"','"&attdateE&"','"&gamedate&"','"&gametime&"','"& p_4 &"','"&P_14&"' "  
			SQL = "INSERT INTO tblRGameLevel ( "&insertfield&" ) VALUES ( "&insertvalue&" )"
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	End If
	
	If P_15 = "Y" Then '대학
		pubcode = "4"
		pubName = "대학부"
		SQL = "select RGameLevelidx from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and GbIDX = '"&teamGbIDX&"' and pubcode = '"&pubcode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			insertvalue = " '"&inggameno&"','"&inggameno&"',"&tidx&",'"&teamGbIDX&"','"&pubcode&"','XMXXXX','"&pubName&"','"&attdateS&"','"&attdateE&"','"&gamedate&"','"&gametime&"','"& p_4 &"','"&P_16&"' "  
			SQL = "INSERT INTO tblRGameLevel ( "&insertfield&" ) VALUES ( "&insertvalue&" )"
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	End if

	
	If P_17 = "Y" Then '중등
		pubcode = "2"
		pubName = "중등부"
		SQL = "select RGameLevelidx from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and GbIDX = '"&teamGbIDX&"' and pubcode = '"&pubcode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			insertvalue = " '"&inggameno&"','"&inggameno&"',"&tidx&",'"&teamGbIDX&"','"&pubcode&"','XXHXXX','"&pubName&"','"&attdateS&"','"&attdateE&"','"&gamedate&"','"&gametime&"','"& p_4 &"','"&P_18&"' "  
			SQL = "INSERT INTO tblRGameLevel ( "&insertfield&" ) VALUES ( "&insertvalue&" )"
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	End if
	If P_19 = "Y" Then '일반
		pubcode = "5"
		pubName = "일반부"
		SQL = "select RGameLevelidx from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and GbIDX = '"&teamGbIDX&"' and pubcode = '"&pubcode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			insertvalue = " '"&inggameno&"','"&inggameno&"',"&tidx&",'"&teamGbIDX&"','"&pubcode&"','XXXUXX','"&pubName&"','"&attdateS&"','"&attdateE&"','"&gamedate&"','"&gametime&"','"& p_4 &"','"&P_20&"' "  
			SQL = "INSERT INTO tblRGameLevel ( "&insertfield&" ) VALUES ( "&insertvalue&" )"
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	End if
	If P_21 = "Y" Then '고등
		pubcode = "3"
		pubName = "고등부"
		SQL = "select RGameLevelidx from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and GbIDX = '"&teamGbIDX&"' and pubcode = '"&pubcode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			insertvalue = " '"&inggameno&"','"&inggameno&"',"&tidx&",'"&teamGbIDX&"','"&pubcode&"','XXXXGX','"&pubName&"','"&attdateS&"','"&attdateE&"','"&gamedate&"','"&gametime&"','"& p_4 &"','"&P_22&"' "  
			SQL = "INSERT INTO tblRGameLevel ( "&insertfield&" ) VALUES ( "&insertvalue&" )"
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	End if
	If P_23 = "Y" Then '동호
		pubcode = "6"
		pubName = "동호인부"
		SQL = "select RGameLevelidx from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and GbIDX = '"&teamGbIDX&"' and pubcode = '"&pubcode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			insertvalue = " '"&inggameno&"','"&inggameno&"',"&tidx&",'"&teamGbIDX&"','"&pubcode&"','EXXXXC','"&pubName&"','"&attdateS&"','"&attdateE&"','"&gamedate&"','"&gametime&"','"& p_4 &"','"&P_24&"' "  
			SQL = "INSERT INTO tblRGameLevel ( "&insertfield&" ) VALUES ( "&insertvalue&" )"
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	End if


	'날짜 순서대로 번호를 자동소팅한다.
	Selecttbl = "( SELECT gameno,DENSE_RANK() OVER (ORDER BY GameDay asc,gameno) AS RankNum  FROM tblRGameLevel where DelYN = 'N' and GameTitleIDX = "&tidx&" ) AS A "
	SQL = "UPDATE A  SET A.gameno = A.RankNum FROM " & selecttbl
	Call db.execSQLRs(SQL , null, ConStr)



	'보여줄때 gbidx로 묶어서 경기번호 생성 
'	strfieldA = " a.RGameLevelidx,a.gameno,a.GameTitleIDX,a.GbIDX,a.pubcode,a.pubName,a.attdateS,a.attdateE,a.GameDay,a.GameTime,a.levelno,a.attmembercnt,a.fee,a.cfg "
'	strfieldB = " b.TeamGbIDX,b.useyear,b.PTeamGb,b.PTeamGbNm,b.TeamGb,b.TeamGbNm,b.levelno,b.levelNm,b.ridingclass,b.ridingclasshelp,b.EnterType,b.Orderby,b.WriteDate,b.DelYN "
'	strTableName = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
'	SQL = "select "&strfieldA &","& strfieldA &" from " & strTableName & " where a.gbIDX = " & teamGbIDX & " order by a.pubcode asc"
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'	If Not rs.EOF Then
'		arrR = rs.GetRows()
'	End If


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