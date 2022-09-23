<%
'#############################################

'대회 정보 수정

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		parr= oJSONoutput.PARR
		reqarr = Split(parr,",")		'//년도,    개인(단체), 종목,마종,    class, class안내

		'국제, 체전, 장소, 주최 , 주관, 후원, 대회명, 그룹, [전문, 생활, 유소년], [개인, 단체], 시작일, 종료일

		idx = reqarr(0) 'idx

		p_1 = reqarr(1) 'K,F 국내국제
		p_2 = reqarr(2) 'Y,N 체전, 비체전

		p_3 = reqarr(3) '장소
		p_4 = reqarr(4) '주최
		p_5 = reqarr(5) '주관
		p_6 = reqarr(6) '후원
		p_7 = reqarr(7) '대회명
		p_8 = reqarr(8) '그룹코드

		p_9 = reqarr(9) '전문 Y,N
		If p_9 = "" Then p_9 = "N" End if
		p_10 = reqarr(10) '생활 Y,N
		If p_10 = "" Then p_10 = "N" End if
		p_11 = reqarr(11) '유소년 Y,N
		If p_11 = "" Then p_11 = "N" End If
		p_12 = reqarr(12) '개인 Y,N
		If p_12 = "" Then p_12 = "N" End If
		p_13 = reqarr(13) '단체 Y,N
		If p_13 = "" Then p_13 = "N" End If
		p_14 = reqarr(14) '시작
		p_15 = reqarr(15) '종료
	End if

	title = p_7
	hostname = P_4
	sdate = p_14
	edate = P_15
	area = P_3
	codegrade = p_8

	code_grade = Split(codegrade,"_")
	titlecode = code_grade(0)
	titlegrade = code_grade(1)

	cfg = ""
	gyear = Left(sdate,4)


	Set db = new clsDBHelper


    viewMatchYN="N"
    if MatchYN>=1 then 
        viewMatchYN="Y"
    end if 

	updatefield = " GameTitleName ='"&title&"',GameS='"&sdate&"',GameE ='"&edate&"', GameYear ='"&gyear&"', GameArea ='"&area&"',hostname = '"&hostname&"',subjectnm ='"&p_5&"',afternm ='"&p_6&"',titlecode ="&titlecode&" ,titlegrade = "&titlegrade&"        ,gameNa ='"&P_1&"',kgame ='"&P_2&"',gameTypeE ='"&P_9&"',gameTypeA ='"&P_10&"',gameTypeL ='"&P_11&"',gameTypeP ='"&P_12&"',gameTypeG ='"&P_13&"' "

	strSql = "update  sd_TennisTitle Set   " & updatefield & " where GameTitleIDX = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)




	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	strFieldName = " GameTitleIDX,stateNo,GameTitleName,GameS,GameE,GameYear,GameArea,ViewYN,ViewState,hostname,subjectnm,afternm,titleCode,titleGrade,gameNa,kgame,gameTypeE,gameTypeA,gameTypeL,gameTypeP,gameTypeG   ,vacReturnYN "

	SQL = "select " & strFieldName & " from sd_TennisTitle where GameTitleIDX = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		GameTitleName = rs("GameTitleName")
		GameS = rs("GameS")
		GameE = rs("GameE")
		GameArea = rs("GameArea")
		ViewYN = rs("ViewYN")
		MatchYN = rs("stateNo")
		ViewState = rs("ViewState")
		hostname = rs("hostname")
		subjectnm = rs("subjectnm") '주관
		afternm = rs("afternm") '후원

		titlecode = rs("titlecode")
		titlegrade = rs("titlegrade")

		gameNa = rs("gameNa")
		kgame = rs("kgame")
		gameTypeE = rs("gameTypeE")
		gameTypeA = rs("gameTypeA")
		gameTypeL = rs("gameTypeL")
		gameTypeP = rs("gameTypeP")
		gameTypeG    = rs("gameTypeG")
		vacReturnYN = rs("vacReturnYN")
	End if

  db.Dispose
  Set db = Nothing
%>

<!-- #include virtual = "/pub/html/riding/gameinfolist.asp" -->
