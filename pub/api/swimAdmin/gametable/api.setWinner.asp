<%
'리그에 상세정보에 만들어둔거임...지금은 안보임 국장 ㅌㅌㅌ ㅡㅡ+


	'//////////////////////////////////////////////////////////////////////////////////////////////
	'승패 기록 테이블 저장
	Sub winlose(ByVal winloseval , ByVal playeridx, ByVal key3, ByVal key3name)
			Dim SQL
			SQL = " IF NOT EXISTS(SELECT * FROM sd_TennisScore WHERE gameyear = "&year(date)&" and PlayerIDX = "&playeridx& " and key3 = "& key3 &") "
			SQL  = SQL & " INSERT INTO sd_TennisScore (gameyear,PlayerIDX,"&winloseval&",key3,key3name) values ("&year(date)&", "&playeridx&",1, "&key3&", '"&key3name&"') "
			SQL  = SQL & " ELSE "
			SQL  = SQL & " UPDATE sd_TennisScore Set "&winloseval&" = "&winloseval&" + 1 WHERE gameyear = "&year(date)&" and PlayerIDX = "&playeridx& " and key3 = "& key3 
			Call db.execSQLRs(SQL , null, ConStr)		
	End Sub

	Sub setWin(ByVal playeridx, ByVal winfield, ByVal giho)
		SQL = "UPDATE sd_TennisMember Set  "&winfield&" = "&winfield&" "&giho&" 1 where gameMemberIDX = " & playeridx
		Call db.execSQLRs(SQL , null, ConStr)
	End sub
	'//////////////////////////////////////////////////////////////////////////////////////////////
%>

<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.SCIDX 'resultIDX  결과 인덱스
	player1IDX = oJSONoutput.P1
	player2IDX = oJSONoutput.P2
	gubun = oJSONoutput.GN '0예선
	gamekey1 = oJSONoutput.S1KEY 
	gamekey2 = oJSONoutput.S2KEY 
	gamekey3 = oJSONoutput.S3KEY '게임종목 키
	levelkey = gamekey3
	gamekey3 = Left(gamekey3,5)
	gamekeyname = oJSONoutput.TeamNM '부명칭
	tidx = oJSONoutput.TitleIDX '게임타이틀 인덱스
	gametitleidx = tidx
	jono = oJSONoutput.JONO '조번호 (예선/순위결정 작업때 사용)
	winidx = oJSONoutput.WINIDX '승자IDX
	resultno = oJSONoutput.RTNO '승자판정 번호
	stateno = oJSONoutput.STATENO '1게임종료 /판정완료 2 진행중 

	'Response.write "idx : " & idx & "</br>"
	'Response.write "player1IDX : " & player1IDX & "</br>"
	'Response.write "player2IDX : " & player2IDX & "</br>"
	'Response.write "gubun : " & gubun & "</br>"
	'Response.write "gamekey1 : " & gamekey1 & "</br>"
	'Response.write "gamekey2 : " & gamekey2 & "</br>"
	'Response.write "levelkey : " & levelkey & "</br>"
	'Response.write "rankno : " & rankno & "</br>"	
	'Response.write "gamekey3 : " & gamekey3 & "</br>"
	'Response.write "gamekeyname : " & gamekeyname & "</br>"
	'Response.write "tidx : " & tidx & "</br>"
	'Response.write "gametitleidx : " & gametitleidx & "</br>"
	'Response.write "jono : " & jono & "</br>"
	'Response.write "winidx : " & winidx & "</br>"
	'Response.write "resultno : " & resultno & "</br>"
	'Response.write "stateno : " & stateno & "</br>"
	'Response.Write "<br>"
	
	If Left(gamekey3,3) = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " inner "
		singlegame = false
	End if  

	Set db = new clsDBHelper

	'cfg설정값 가져와서 설정#############
	strSql = "SELECT top 1  a.cfg, b.startscore  "
	strSql = strSql &  "  FROM sd_TennisTitle as a inner join tblRGameLevel as b  ON a.GameTitleIDX = b.GameTitleIDX "
	strSql = strSql &  " WHERE a.GameTitleIDX = " & tidx & " and b.level = " & levelkey 
	strSql = strSql &  " AND a.DelYN = 'N'"
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		
	'Response.Write strSql & "</br>"

	cfg = rs(0) ' 타이브레이크 
	starttiescore = Left(cfg,1) 
	startgamescore = rs(1) '경기 스코어 시작 점수 
	deucestate = Mid(cfg,2,1)

	'cfg설정값 가져와서 설정#############
	'Response.Write "cfg : " & cfg & "</br>"
	'Response.Write "starttiescore : " &starttiescore & "</br>"
	'Response.Write "startgamescore : " &startgamescore & "</br>"
	'Response.Write "deucestate : " &deucestate & "</br>"
	'Response.Write "</br>"

	Select Case CStr(resultno)
		Case "100","1","2","3"  '승리, 부전승,기권승,실격승
			'wpos t_win lpos t_lose
			If WINIDX = player1IDX  Then
				winResult = "left"
				leftetc = resultno
				rightetc = 0
			Else
				winResult = "right"
				leftetc = 0
				rightetc = resultno
			End if
		Case "4","5","6"  '양선수 불참,양선수 기권패,선수 실격패
			winResult = "tie"
			leftetc = resultno
			rightetc = resultno
	End Select

	'Response.Write "idx : " &idx & "</br>"
	

	IF CDBl(idx) = 0 Then
		courtno  = 0
		'insert 예선결과 담을 테이블 , 순위적용 시킬 테이블 
		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		strwhere = "  a.gamememberIDX = " & player1IDX & " or a.gamememberIDX = " & player2IDX
		strsort = " order by a.tryoutsortno asc"
		strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aATN, a.teamBNa as aBTN  "
		strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN "
		strfield = strAfield &  ", " & strBfield
		SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		'Response.Write SQL & "</br>"

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		Do Until rs.eof
			''GameTitleIDX, key3 , m1idx , m2idx 가 중복이라면 들어가지 않아야 한다.
			SQL = "Select top 1 key3  from sd_TennisRanking where GameTitleIDX = "&tidx&"  and  key3 = "&gamekey3&"  and  m1idx = "&rs(0)&" and  m2idx = "&rs(4)
			'Response.Write SQL & "</br>"
			
			Set rsm = db.ExecSQLReturnRS(SQL , null, ConStr)
			If rsm.eof then
				SQL = "INSERT INTO sd_TennisRanking (GameTitleIDX,key1,key2,key3, key3name, m1idx,m1name, m1team1, m1team2 ,m2idx,m2name, m2team1, m2team2,level ) VALUES " 'confirm 확인여부
				SQL = SQL & "(" & tidx & ",'"&gamekey1&"',"&gamekey2&"," & gamekey3 & ",'" & gamekeyname  & "', "
				SQL = SQL & rs(0) &  ",  '" & rs(1) & "', '" & rs(2) & "','" & rs(3) & "', "
				SQL = SQL & rs(4) &  ", '" & rs(5) & "', '" & rs(6) & "','" & rs(7) & "','"&levelkey&"' )"
				'Response.Write SQL & "</br>"
				Call db.execSQLRs(SQL , null, ConStr)
			'Response.End
			End if
		rs.movenext
		Loop
		'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		
		strTableName = " sd_TennisResult "
		If CDbl(startgamescore) > 0 Then
		strField = " gameMemberIDX1, gameMemberIDX2, stateno, gubun,gamekey3,gamekeyname,GameTitleIDX, level,tryoutgroupno,m1set1,m1set2,m1set3,m2set1,m2set2,m2set3  " 'gubun 0 예선
		else
		strField = " gameMemberIDX1, gameMemberIDX2, stateno, gubun,gamekey3,gamekeyname,GameTitleIDX, level,tryoutgroupno   " 'gubun 0 예선
		End if
		strField = strField & ", courtno "    '승자 , 승자위치(열 왼쪽, 행 오른쪽), 셋트종료시간, 운영자, 관리툴에서종료(ADMIN),결과판정번호좌우
		'response.End
		SQL = "SET NOCOUNT ON INSERT INTO "& strTableName &" ("& strField &") VALUES "
		SQL = SQL & "(" & player1IDX
		SQL = SQL & "," & player2IDX
		If CDbl(startgamescore) > 0 Then 
		SQL = SQL & "," & "2, "&gubun&", "&gamekey3&", '"&gamekeyname&"',"&gametitleidx&", '"&levelkey&"',"&jono&","&startgamescore&","&startgamescore&","&startgamescore&","&startgamescore&","&startgamescore&","&startgamescore 'stateno 0 진행전, 2진행중, 1 완료
		Else
		SQL = SQL & "," & "2, "&gubun&", "&gamekey3&", '"&gamekeyname&"',"&gametitleidx&", '"&levelkey&"',"&jono 'stateno 0 진행전, 2진행중, 1 완료
		End if
		SQL = SQL & " ," & courtno & ")  SELECT @@IDENTITY"
		'Response.Write SQL & "</br>"
		'Response.End
		Set rsmax = db.ExecSQLReturnRS(SQL , null, ConStr)
		'Response.Write SQL & "</br>"
		'Response.End
		idx = rsmax(0)
	End IF

	If stateno = "1" then
		SQL = "Select winidx,winresult,gameMemberIDX1,gameMemberIDX2  from sd_TennisResult  where resultIDX = " & idx

		'Response.Write SQL & "</br>"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		o_winidx = rs("winidx") ' gameMemberIDX
		o_winresult = rs("winresult") ' 승자 결과 left, right, tile

		o_gameMemberIDX1 = rs("gameMemberIDX1")
		o_gameMemberIDX2 = rs("gameMemberIDX2")

		' 원래 승패 돌림
	Select Case o_winresult
		Case "left"
			Call setWin(o_gameMemberIDX1, "t_win" , "-")
			Call setWin(o_gameMemberIDX2, "t_lose", "-")
		Case "right"
			Call setWin(o_gameMemberIDX1, "t_lose", "-")
			Call setWin(o_gameMemberIDX2, "t_win", "-")
		Case "tie"
			Call setWin(o_gameMemberIDX1, "t_lose", "-")
			Call setWin(o_gameMemberIDX2, "t_lose", "-")
		End Select 
	End if

	'승패 업데이트
	Select Case winResult
		Case "left"
			Call setWin(player1IDX, "t_win", "+")
			Call setWin(player2IDX, "t_lose", "+")
		Case "right"
			Call setWin(player1IDX, "t_lose", "+")
			Call setWin(player2IDX, "t_win", "+")
		Case "tie"
			Call setWin(player1IDX, "t_lose", "+")
			Call setWin(player2IDX, "t_lose", "+")
	End Select 

	'-------------------------------------------------------------------------------

	'정보 업데이트
	strTableName = " sd_TennisResult "
	'승자 , 승자위치(열 왼쪽, 행 오른쪽), 셋트종료시간, 운영자, 관리툴에서종료(ADMIN),결과판정번호좌우
	setvalue = " winIDX = "&winidx&" ,winResult = '"&winResult&"' ,set1end = getdate(),recorderName ='운영자',preresult = 'ADMIN',leftetc = "&leftetc&",rightetc = "&rightetc&",stateno =1  "    ' stateno 1 종료
	SQL = "update "&strTableName&" Set " & setvalue  & " where resultIDX = " & idx
	'Response.Write SQL & "</br>"
	'Response.End
	Call db.execSQLRs(SQL , null, ConStr)

	If s2key = "202" Then '단체전 > 년도별 팀 스코어 테이블 업데이트 (없을  경우 생성)
	else	'개인전 > 년도별 개인 스코어 테이블 업데이트
		'승
			Call winlose("win", player1IDX,gamekey3,gamekeyname )
			If singlegame = False then
			Call winlose("win", player2IDX,gamekey3,gamekeyname)
		End if

		'패
			Call winlose("lose", player1IDX,gamekey3,gamekeyname)
		If singlegame = False then
			Call winlose("lose", player2IDX,gamekey3,gamekeyname)
		End if
	End If

	'순위가 업데이트 되면 
	'리그 대진표항목에 업데이트 시켜준다.
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>