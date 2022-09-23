<%
	gameLevelIDX= oJSONoutput.IDX
	gameTitleIDX= oJSONoutput.TitleIDX
	attachCnt = oJSONoutput.T_ATTCNT
	nowRound = oJSONoutput.T_NOWRD
	trRoundID= oJSONoutput.T_RDID
	gamekey3 = oJSONoutput.S3KEY

	Call oJSONoutput.Set("RESET", "notok" )
	Call oJSONoutput.Set("ONEMORE", "notok" )

	Set db = new clsDBHelper

	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "



	'예선총명수로 참가자 명수 확정
	strWhere = " GameTitleIDX = "&gameTitleIDX&" and gamekey3 = "& gamekey3 & " and gubun in (0, 1)  and DelYN = 'N' "
	SQL = "select  max(tryoutgroupno) as maxgno,COUNT(*) as gcnt  from "&strtable&" where "&strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		attmembercnt = rs("gcnt")					'총참가자
		maxgno = rs("maxgno")						'설정된 마지막조
		tcnt  = CDbl(maxgno) * 2			'토너먼트 참가 인원
	End if

	'강수 계산##############
		if tcnt <=2 then
		drowCnt = 2
		depthCnt = 2
		elseif tcnt >2 and tcnt <=4 then
		drowCnt = 4
		depthCnt = 3
		elseif tcnt >4 and tcnt <=8 then
		drowCnt=8
		depthCnt = 4
		elseif tcnt >8 and  CDbl(tcnt) <=16 then
		drowCnt=16
		depthCnt = 5
		elseif tcnt >16 and  tcnt <=32 then
		drowCnt=32
		depthCnt = 6
		elseif tcnt >32 and  tcnt <=64 then
		drowCnt=64
		depthCnt = 7
		elseif tcnt >64 and  tcnt <=128 then
		drowCnt=128
		depthCnt = 8
		elseif tcnt >128 and  tcnt <=256 then
		drowCnt=256
		depthCnt = 9
		end if 
	'강수 계산##############



	'상위 라운드진출되었다면 재편성 막음 (결과값이 생겼으므로)
		If CDbl(depthCnt) = CDbl(nowRound) Then
			nextrd = nowRound
		else
			nextrd = CDbl(nowRound) + 1
		End if

		SQL = "SELECT COUNT(*)  FROM sd_TennisMember where GameTitleIDX = '" & gameTitleIDX & "' and gamekey3 = " & gamekey3 & " and round = '" & nextrd & "' and DelYN = 'N' and gubun in (2,3)"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If CDbl(rs(0)) > 0 Then
			Call oJSONoutput.Set("result", 1002 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

			db.Dispose
			Set db = Nothing
			Response.end		
		End if
	'상위 라운드진출되었다면 재편성 막음 (결과값이 생겼으므로)

	'현재 편성정보
	SQL = "SELECT max(gubun)  FROM sd_TennisMember where GameTitleIDX = " & gameTitleIDX & " and gamekey3 = " & gamekey3 & " and round = " & nowRound & " and DelYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	tourngubun = rs(0)
	If isNull(tourngubun) Then
		tourngubun = 2
	End If

	'###
	Select Case CDbl(tourngubun)
	Case 2 '편성완료 > 부전승자 생성 

		strWhere = " GameTitleIDX = "&gameTitleIDX&" and gamekey3 = "& gamekey3 & " and gubun in (2,3)  and Round = 1"
		SQL = "SELECT sortno FROM sd_TennisMember  WHERE delYN = 'N' and " & strWhere & " order by sortNO asc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrSt = rs.getrows()
		End If	

		'빈소팅 번호 찾기
		reDim temsortnoarr(drowCnt)
		tempi= 0
		For i = 1 To drowCnt
			tempsortno = tempno(arrST, i) '공통함수에 req 페이지에 존재
			If tempsortno > 0 then
				temsortnoarr(tempi) = tempsortno
				tempi = tempi + 1
			End if
		next	

		'2 -> 3 업데이트 
		SQL = "Update sd_TennisMember Set gubun = 3, areaChanging = 'N' where  GameTitleIDX = '" & gameTitleIDX & "' and  gamekey3 = " & gamekey3 & " and round = " & nowRound
		Call db.execSQLRs(SQL , null, ConStr)	

		If temsortnoarr(0) <> "" Then '빈곳이 없는경우
		For n = 0 To ubound(temsortnoarr)
			If temsortnoarr(n) = "" Or isNull(temsortnoarr(n)) = True Then
				Exit For
			Else
				'부전 인서트
				insertfield = " gubun,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round "
				selectfield = TOURNSTART &  ",GameTitleIDX,'부전',gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round"
				selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where Round= 1 and gubun in (2,3) and GameTitleIDX = "&gameTitleIDX&" and gamekey3= " & gamekey3
				SQL = "SET NOCOUNT ON  insert into "&strtable&" ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				midx = rs(0)
				'파트너 insert
				insertfield  = " gameMemberIDX,userName "
				selectfield = " "&midx&",'부전' "
				SQL = "insert into "&strtablesub&" ("&insertfield&")  values ("&selectfield&")"
				Call db.execSQLRs(SQL , null, ConStr)
			End if
		Next
		End if

		oJSONoutput.ONEMORE = "ok"


	Case 3 '재편성 > 부전승자 삭제
		'3 -> 2 업데이트 
		SQL = "Update sd_TennisMember Set gubun = 2, areaChanging = 'N' where  GameTitleIDX = '" & gameTitleIDX & "' and  gamekey3 = " & gamekey3 & " and round = " & nowRound
		Call db.execSQLRs(SQL , null, ConStr)	

		'부전승 삭제
		strWhere = " a.GameTitleIDX = " & gameTitleIDX & " and  a.gamekey3 = " & gamekey3 & " and a.round = " & nowRound & " and a.userName = '부전' "
		SQL = "DELETE From sd_TennisMember From sd_TennisMember As a Left Join sd_TennisMember_partner As b On a.gameMemberIDX = b.gameMemberIDX Where " & strWhere

		Call db.execSQLRs(SQL , null, ConStr)		
	End Select 


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%>
