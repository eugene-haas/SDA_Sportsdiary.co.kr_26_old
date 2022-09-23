<%
'#############################################


'#############################################
	'request
	autono = oJSONoutput.AutoNo
	titleidx = oJSONoutput.TitleIDX
	title = oJSONoutput.Title
	teamidx = oJSONoutput.TeamIDX  '인덱스
	levelno = oJSONoutput.LevelNo
	teamgbnm = oJSONoutput.BOONM


	'Response.write "autono : " & autono & "</br>"
	'Response.write "titleidx : " & titleidx & "</br>"
	'Response.write "title : " & title & "</br>"
	'Response.write "teamidx : " & teamidx & "</br>"
	'Response.write "levelno : " & levelno & "</br>"
	'Response.write "teamgbnm : " & teamgbnm & "</br>"


	Select Case Left(levelno,3)
	Case "201","200"
		boo = "개인전"
		gamekey1 = "tn001001"
	Case "202"
		boo = "단체전"
		gamekey1 = "tn001002"
	End Select

	Set db = new clsDBHelper

	'1. 참여하지 않은 선수 두명을 가져온다.
	'2. 저장한다.

	'참가 신청하지 않은 유저 중에 검색작업할것
	subSql = " and PlayerIDX not in (Select P1_PlayerIDX from tblGameRequest Where  GameTitleIDX = " & titleIDX  & " and Level = " & levelno &" and DelYN = 'N')"
	subSql = subSql & " and PlayerIDX not in (Select P2_PlayerIDX from tblGameRequest Where GameTitleIDX = " & titleIDX  & " and Level = " & levelno &" and DelYN = 'N')"
	strSql = "SELECT top 2 PlayerIDX,UserName,userLevel,TeamNm,Team2Nm,UserPhone,Birthday,Sex  from tblPlayer_2018122853850 where SportsGb = 'tennis' and DelYN = 'N' " & subSql & " ORDER BY NEWID() "
	'Response.write " strSql : " & strSql & "</br>"
	'Response.End

	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	
	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if

		
	insertfield = " SportsGb, GameTitleIDX,Level,EnterType,UserPass,UserName,UserPhone,txtMemo " '여러팀을 등록했을시 ...
	insertfield = insertfield & " ,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX,P1_rpoint "
	insertfield = insertfield & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P2_rpoint "
	insertvalue = " 'tennis',"&titleidx&",'"&levelno&"','A','null','운영자','01000000000','자동생성'"		

'PlayerIDX,UserName,userLevel,UserPhone,Birthday,Sex,TeamNm,Team2Nm
		If IsArray(arrRS) Then
			For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
			Select Case ar 
				Case 0
					p1idx = arrRS(0, ar) 
					p1nm = arrRS(1, ar) 
					p1level =	 arrRS(2, ar) 
					p1t1 =	 arrRS(3, ar) 
					p1t2 =	 arrRS(4, ar) 
					p1phone =	 arrRS(5, ar) 
					p1birth =	 arrRS(6, ar) 
					p1sex =	 arrRS(7, ar) 

					'랭킹포인트를 가져온다.
					SQL = "select top 1 rankpoint  from sd_TennisRPoint where PlayerIDX = "&p1idx&" and teamGb = "&Left(levelno,5)
					'Response.write " SQL : " & SQL & "</br>"
					'Response.end

					Set rsr = db.ExecSQLReturnRS(SQL , null, ConStr)
					If rsr.eof Then
						p1rpoint = 0
					Else
						p1rpoint = rsr("rankpoint")
					End if
				
					insertvalue = insertvalue & "," &  p1idx & " ,'"&p1nm&"','"&p1level&"','"&p1t1&"','"&p1t2&"','"&p1phone&"','"&p1birth&"','"&p1sex&"',"&p1rpoint&" "
				Case 1
					p2idx = arrRS(0, ar) 
					p2nm = arrRS(1, ar) 
					p2level =	 arrRS(2, ar) 
					p2t1 =	 arrRS(3, ar) 
					p2t2 =	 arrRS(4, ar) 
					p2phone =	 arrRS(5, ar) 
					p2birth =	 arrRS(6, ar) 
					p2sex =	 arrRS(7, ar) 

					'랭킹포인트를 가져온다.
'					SQL = "select top 1 rankpoint  from sd_TennisRPoint where PlayerIDX = "&p2idx&" and teamGb = "&Left(levelno,5)
'					Set rsr = db.ExecSQLReturnRS(SQL , null, ConStr)
'					If rsr.eof Then
						p2rpoint = 0
'					Else
'						p2rpoint = rsr("rankpoint")
'					End if

					insertvalue = insertvalue  & "," &  p2idx & " ,'"&p2nm&"','"&p2level&"','"&p2t1&"','"&p2t2&"','"&p2phone&"','"&p2birth&"','"&p2sex&"',"&p2rpoint&" "
				End Select
			Next

			'SQL = "SET NOCOUNT ON  INSERT INTO tblGameRequest ( "&insertfield&" ) VALUES ("&insertvalue&")  SELECT @@IDENTITY" 
			'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			'idx = rs(0)

			SQL = "SET NOCOUNT ON INSERT INTO tblGameRequest ( "&insertfield&" ) VALUES ("&insertvalue&") SELECT @@IDENTITY" 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			idx = rs(0)

			'Response.write " idx : " & idx & "</br>"
			'Response.write " SQL : " & SQL & "</br>"
			'Response.End
			'Call db.execSQLRs(SQL , null, ConStr)

			SQL ="SELECT count(*) as attCnt FROM tblGameRequest where  GameTitleIDX = " & titleidx & " and Level = " & levelno & " and DelYN = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			attCNT = rs(0)

			SQL = "Update tblRGameLevel Set attmembercnt = " & attCNT & " where RGameLevelIdx = " & teamidx
			Call db.execSQLRs(SQL , null, ConStr)
			'Response.write " SQL : " & SQL & "</br>"
			'If titleidx = "2" Then '대진표 명단 생성
			'################################################
			'대진표등록
			'################################################
			
			insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,rankpoint,  requestIDX"
			insertvalue = " 0, "&titleidx&", "&p1idx&", '"&p1nm&"', '"&gamekey1&"',"&Left(levelno,3)&","&levelno&","&Left(levelno,5)&",'"&Split(teamgbnm,"(")(0)&"','"&p1t1&"','"&p1t2&"',"&p1rpoint&", "&idx&"   "
			SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
			'Response.write " SQL : " & SQL & "</br>"
			'Response.End
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			
			gamemidx = rs(0)	

			insertfield = " GameMemberIDX, PlayerIDX,userName,TeamANa,TeamBNa,rankpoint "
			insertvalue = " "&gamemidx&", "&p2idx&", '"&p2nm&"','"&p2t1&"','"&p2t2&"',"&p2rpoint&"   "
			SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
			Call db.execSQLRs(SQL , null, ConStr)		

			gamemember = "<a href='javascript:mx.delPlayer("&idx&","& gamemidx &")' class='btn_a' style='color:red'>예선 취소</a>"

			'################################################
		'End if

		SQL = "SELECT top 1 EntryListYN from tblGameRequest where SportsGb = 'tennis' and DelYN = 'N' and Level =" & levelno & " and GameTitleIDX = "&titleidx & " and RequestIDX = " &  idx 
		'response.write SQL
		'response.end
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof  then
			rEntryListYN = rs("EntryListYN")
		End if

		If rEntryListYN = "Y" Then
			rEntryListYN="참가자"
		Else
			rEntryListYN="대기자"
		End If

		



			Set rs = Nothing
			db.Dispose
			Set db = Nothing

			'타입 석어서 보내기
			Call oJSONoutput.Set("result", "0" )
			oJSONoutput.AutoNo = CDbl(autono) - 1
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"

			%>
			<!-- #include virtual = "/pub/html/swimAdmin/gameinfoPlayerList.asp" -->
			<%		
		
		Else
			Set rs = Nothing
			db.Dispose
			Set db = Nothing

			'타입 석어서 보내기
			Call oJSONoutput.Set("result", "1" )
			oJSONoutput.AutoNo = CDbl(autono) - 1
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
		End if
%>