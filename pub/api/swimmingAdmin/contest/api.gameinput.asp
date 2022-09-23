<%
'#############################################

'대회생성저장

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '23번까지 '13, 14 날짜형태
		'For intloop = 0 To oJSONoutput.PARR.length-1
		'   Response.write  reqArr.Get(intloop) & "<br>"
		'Next
		'Response.end
	End if

	Set db = new clsDBHelper 

		'0국제, 1체전, 2장소, 3주최 , 4주관, 5후원, 6협찬, 7대회명, 8요강, 9규모, 10레인수 ,11대회코드, 12참가비 , 13대회기간 , 14신청기간 , 15대회구분 , 16구분, 17개인, 18팀, 19시도신청, 20시도승인, 21팀당2명이내제한, 22종목수
		insertfield = " gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,GameTitleName,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt "

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case 13 '대회기간
						'2019/12/06 - 2019/12/06
					gameDate = Split(reqArr.Get(i),"-")
					gameS = CDate(gameDate(0))
					gameE = CDate(gameDate(1))
					'gameS = Left(games,10) & " " & Right(games,8)
					'gameE = Left(gamee,10) & " " & Right(gamee,8)

					insertvalue	= insertvalue & ",'"&gameS&"' " & ",'"&gameE&"' "
			Case 14 '신청기간
						'2019/12/06 12:00 AM - 2019/12/06 11:59 PM
					gameDate = Split(reqArr.Get(i),"-")
					'gameS = Left(gameDate(0),10) & " " & Right(gameDate(0),8)
					'gameE = Left(gameDate(1),10) & " " & Right(gameDate(1),8)
					'Response.write gameDate(0) & "<br>"
					'Response.write games
					'Response.end
					gameS = Left(CDate(gameDate(0)),10) & " " & FormatDateTime(CDate(gameDate(0)),4) & ":00"
					gameE = Left(CDate(gameDate(1)),10) & " " & FormatDateTime(CDate(gameDate(1)),4) & ":00"
					insertvalue	= insertvalue & ",'"&gameS&"' " & ",'"&gameE&"' "
			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "SET NOCOUNT ON INSERT INTO sd_gameTitle ( "&insertfield&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"

'Response.write sql
'Response.end


		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>