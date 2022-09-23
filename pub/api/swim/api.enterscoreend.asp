<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

''종료처리

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	gidx = oJSONoutput.GIDX '대회인덱스
	scidx = oJSONoutput.SCIDX '결과테이블 인덱스
	leftetc = oJSONoutput.LT	'왼쪽 기타판정
	rightetc = oJSONoutput.RT
	courtno = oJSONoutput.CTNO '코트번호
	courtkind = oJSONoutput.CTKD '코트종류
	winner = oJSONoutput.WINNER 'left right tie (승패위치)

	player1 = oJSONoutput.P1  '선수 1인덱스 왼쪽
	player2 = oJSONoutput.P2  '선수 2인덱스 오른쪽

	s2key = oJSONoutput.S2KEY '단복식구분정보
	levelno = oJSONoutput.S3KEY ' 상세번호(지역까지포함된)
	key3 = Left(levelno ,5)
	key3name = Split(oJSONoutput.S3STR," ")(0)

	jono = oJSONoutput.JONO '예선 조번호
	gubun = oJSONoutput.GN '예선/본선 구분  0예선

	leftscore = oJSONoutput.LEFTSCORE
	rightscore = oJSONoutput.RIGHTSCORE
	'#################################
	Set db = new clsDBHelper



	'플레이어 정보가져오기
	If s2key = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " inner "
		singlegame = false
	End if  

	If s2key = "202" Then '단체전

	else' 개인전
		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		strwhere = "  a.gamememberIDX = " & player1 & " or a.gamememberIDX = " & player2 
		strsort = " order by a.tryoutsortno asc" '정렬순이면 왼쪽오른쪽이 명확해진다.
		strAfield = " a.gamememberIDX as m1idx , a.PlayerIDX as m1pidx, a.userName as name1 , a.teamAna as m1t1, a.teamBNa as m1t2  "
		strBfield = " b.partnerIDX as m2idx, b.PlayerIDX as m2pidx , b.userName as name2, b.teamAna as m2t1 , b.teamBNa as m2t2 "
		strfield = strAfield &  ", " & strBfield
		SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		i = 0
		Do Until rs.eof 

			If i = 0 Then
				m1pidx1 = rs("m1pidx")
				m1pidx2 = rs("m2pidx")
			Else
				m2pidx1 = rs("m1pidx")
				m2pidx2 = rs("m2pidx")
			End if

		i = i + 1
		rs.movenext
		loop
	End If

'Response.write "2. " & sql & "<br>"
'Response.write winner
'Response.end

	Sub winlose(ByVal winloseval , ByVal playeridx)
		 Dim SQL
		 SQL = " IF NOT EXISTS(SELECT * FROM sd_TennisScore WHERE gameyear = "&year(date)&" and PlayerIDX = "&playeridx& " and key3 = "& key3 &") "
		 SQL  = SQL & " INSERT INTO sd_TennisScore (gameyear,PlayerIDX,"&winloseval&",key3,key3name) values ("&year(date)&", "&playeridx&",1, "&key3&", '"&key3name&"') "
		 SQL  = SQL & " ELSE "
		 SQL  = SQL & " UPDATE sd_TennisScore Set "&winloseval&" = "&winloseval&" + 1 WHERE gameyear = "&year(date)&" and PlayerIDX = "&playeridx& " and key3 = "& key3 
		 Call db.execSQLRs(SQL , null, ConStr)		
	End Sub

	'결과 승패 기록
	strWhere =  " where resultIDX = " & scidx '게임 종료
	SQLPLUS = " , leftetc = "&leftetc&" , rightetc = "&rightetc&",courtno= "&courtno&",courtkind="&courtkind & ", set1end = getdate()" & strWhere
	Select Case winner
	Case "left"
		If CDbl(leftetc) = 7 Or CDbl(Rightetc) = 7 Then
		SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX="&player1&",winResult='"&winner&"',m1set1="&leftscore&" , m2set1 = "&rightscore&" , m1set = 1,m2set = 0 " & SQLPLUS
		else
		SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX="&player1&",winResult='"&winner&"',m1set = 1,m2set = 0 " & SQLPLUS
		End if

'Response.write sql
'Response.end
		
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "UPDATE sd_TennisMember Set  t_win = t_win + 1 where gameMemberIDX = " & player1
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "UPDATE sd_TennisMember Set  t_lose = t_lose + 1 where gameMemberIDX = " & player2
		Call db.execSQLRs(SQL , null, ConStr)

		If s2key = "202" Then '단체전 > 년도별 팀 스코어 테이블 업데이트 (없을  경우 생성)

		else	'개인전 > 년도별 개인 스코어 테이블 업데이트
			'승
			 Call winlose("win", m1pidx1)
			 If singlegame = False then
				 Call winlose("win", m1pidx2)
			End if

			'패
			 Call winlose("lose", m2pidx1)
			 If singlegame = False then
				 Call winlose("lose", m2pidx2)
			 End if
		End if


	Case "right"
		If CDbl(leftetc) = 7 Or CDbl(Rightetc) = 7 Then
		'SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX="&player2&",winResult='"&winner&"',m1set1="&leftscore&" , m2set1 = "&rightscore&" ,m2set = m2set + 1  " & SQLPLUS
		SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX="&player2&",winResult='"&winner&"',m1set1="&leftscore&" , m2set1 = "&rightscore&" ,m2set = 1,m1set = 0  " & SQLPLUS
		else
		'SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX="&player2&",winResult='"&winner&"',m2set = m2set + 1  " & SQLPLUS
		SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX="&player2&",winResult='"&winner&"',m2set = 1,m1set = 0  " & SQLPLUS
		End if
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "UPDATE sd_TennisMember Set  t_win = t_win + 1 where gameMemberIDX = " & player2
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "UPDATE sd_TennisMember Set  t_lose = t_lose + 1 where gameMemberIDX = " & player1
		Call db.execSQLRs(SQL , null, ConStr)

		If s2key = "202" Then '단체전 > 년도별 팀 스코어 테이블 업데이트 (없을  경우 생성)

		else	'개인전 > 년도별 개인 스코어 테이블 업데이트
			'승
			 Call winlose("win", m2pidx1)
			 If singlegame = False Then
				 Call winlose("win", m2pidx2)
			End if

			'패
			 Call winlose("lose", m1pidx1)
			 If singlegame = False then
				 Call winlose("lose", m1pidx2)
			 End if
		End if

	Case "tie"
		SQL = "UPDATE sd_TennisResult Set  stateno = 1,winIDX= null,winResult='"&winner&"'  " & SQLPLUS
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "UPDATE sd_TennisMember Set  t_lose = t_lose + 1 where gameMemberIDX = " & player1 & " or gameMemberIDX = " & player2
		Call db.execSQLRs(SQL , null, ConStr)
	End Select




	'#################################################################################
	'예선 조경기가 완료되었다면 순위 1,2,3 위를 결정하여 넣어준다. sd_TennisMember > t_rank #############
	If gubun = "0" Then '예선이고
		SQL = "select gameMemberIDX,t_win,t_lose from sd_TennisMember where gameTitleIDX = "&gidx&"  and gamekey3 = "&levelno&"  and tryoutgroupno = " & jono & " and DelYN = 'N' and gubun = 1 order by t_win desc, t_lose asc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)			

		'조인원은 1 ~ 3명 까지 있을수 있지
		If Not rs.EOF Then 
			arrRS2 = rs.GetRows()

			jocount = UBound(arrRS2, 2)  '1 ~ 3
			ReDim jomemidx(jocount)
			ReDim jowincnt(jocount)

			For ar = LBound(arrRS2, 2) To UBound(arrRS2, 2) 
				jomemidx(ar) = arrRS2(0, ar)
				jowincnt(ar) = arrRS2(1, ar)
			next
		End if

		'######################
		'본선에 추가 시키고
		Sub uptable(ByVal idx)
			'gubun 0예선 1예선종료 본선 2 본선종료 3 
			Dim insertfield, selectfiled,fieldpartner,SQL, rs,newplayerkey
			insertfield = " GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,key3name,Round,gubun,tryoutgroupno,tryoutsortNo " 'gubun 2 본선 올라감 3 본선 대진표 설정완료
			selectfield = " max(GameTitleIDX),max(PlayerIDX),max(userName),max(gamekey1),max(gamekey2),max(gamekey3),max(TeamGb),max(TeamANa),max(TeamBNa),max(key3name),1,2,max(tryoutgroupno),max(tryoutsortNo) " 
			fieldpartner = " PlayerIDX,userName,TeamANa,TeamBNa "
			
			SQL = "SET NOCOUNT ON Insert into sd_TennisMember ( "&insertfield&" ) select "& selectfield&" from sd_TennisMember where gameMemberIDX = " & idx & "   SELECT @@IDENTITY"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			newplayerkey = rs(0)

			SQL = "Insert into sd_TennisMember_partner ( "&fieldpartner&",gameMemberIDX ) select "& fieldpartner&","&newplayerkey&" from sd_TennisMember_partner where gameMemberIDX = " & idx
			Call db.execSQLRs(SQL , null, ConStr)
		End Sub
		
		'예선 1,2,3위 업데이트
		Sub uprank(ByVal one, ByVal two, ByVal three)
			Dim SQL
			If CDbl(one) >0 then
			SQL = "update sd_TennisMember set t_rank = 1 where gameMemberIDX = " & one
			Call db.execSQLRs(SQL , null, ConStr)
			End If
			If CDbl(two) >0 then			
			SQL = "update sd_TennisMember set t_rank = 2 where gameMemberIDX = " & two
			Call db.execSQLRs(SQL , null, ConStr)
			End if
			If CDbl(three) >0 then
			SQL = "update sd_TennisMember set t_rank = 3 where gameMemberIDX = " & three
			Call db.execSQLRs(SQL , null, ConStr)
			End if
		End sub
		'######################		
		
		SQL = "select  winIDX,winResult,m1set1,m2set1   from sd_TennisResult where delYN = 'N' and gameTitleIDX = "&gidx&" and level = "&levelno&" and  tryoutgroupno = "&jono&" and stateno = 1" '경기모두 완료
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



		If Not rs.EOF Then 

			arrRS = rs.GetRows()

			If IsArray(arrRS) Then

				If ( jocount >= 2 And UBound(arrRS, 2) >= jocount) Or (jocount = 1 And UBound(arrRS, 2) = 0 )  Then '모든 경기 완료  조인원 2 = jocount 1 경기는 1이야

				Set renkdef =Server.CreateObject("Scripting.Dictionary")
				For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
					winidx = arrRS(0, ar) 
					m1set1score =  arrRS(2, ar)	
					m2set1score  =  arrRS(3, ar)
					score_div = Abs(m1set1score - m2set1score)

					If renkdef.Exists(winidx) = true then
						renkdef(winidx) = CDbl(renkdef(winidx)) + CDbl(score_div) '승수
					Else
						renkdef.ADD winidx, score_div
						'Response.write "def  . " &winidx & " " & score_div & "<br>"
					End if
				Next

					Select Case CDbl(jocount) + 1  '참여자(무조건)
					Case 3 
						'SQL = "update sd_TennisMember set gubun = 1 where gameMemberIDX in ( " & jomemidx(0) & "," & jomemidx(1) & "," & jomemidx(2) & ")" ' 
						'Call db.execSQLRs(SQL , null, ConStr)

						Select Case jowincnt(0) '승수 1등
						Case "2"
							Select Case jowincnt(1)
							Case "1"
								'2등 3등 명확
								Call uprank( jomemidx(0), jomemidx(1), jomemidx(2) )
								'결과가 1또는 2인 인원은 본선 대진표 인서트 시켜준다.
								Call uptable( jomemidx(0) )
								Call uptable( jomemidx(1) )

							
							Case "0"
								Call uprank( jomemidx(0), ,0, 0 ) '둘이 한판식 지고 기권 둘다 실격
								Call uptable( jomemidx(0) ) '본선진출
							End Select

						Case "1"
							Select Case jowincnt(1)
							Case "1"
								If jowincnt(2) = "1" Then
									'3자 동률 게임 득실차로 비교
									If renkdef(jomemidx(0)) >= renkdef(jomemidx(1))  Then 
										If renkdef(jomemidx(0)) >= renkdef(jomemidx(2))  Then
											Call uprank( jomemidx(0), 0,0 )
											Call uptable( jomemidx(0) )

											If renkdef(jomemidx(1)) >= renkdef(jomemidx(2))  Then
												Call uprank( 0, jomemidx(1), jomemidx(2) )
												Call uptable( jomemidx(1) )
											Else
												Call uprank( 0, jomemidx(2), jomemidx(1) )
												Call uptable( jomemidx(2) )
											End if
										Else
											Call uprank( jomemidx(2), jomemidx(0), jomemidx(1) )
											Call uptable( jomemidx(2) )
											Call uptable( jomemidx(0) )
										End if
									Else
										If renkdef(jomemidx(0)) >= renkdef(jomemidx(2))  Then
											Call uprank( jomemidx(1), jomemidx(0), jomemidx(2) )
											Call uptable( jomemidx(1) )
											Call uptable( jomemidx(0) )
										Else
											If renkdef(jomemidx(1)) >= renkdef(jomemidx(2))  Then
												Call uprank( jomemidx(1), jomemidx(2), jomemidx(0) )
												Call uptable( jomemidx(1) )
												Call uptable( jomemidx(2) )
											Else
												Call uprank( jomemidx(2), jomemidx(1), jomemidx(0) )
												Call uptable( jomemidx(2) )
												Call uptable( jomemidx(1) )
											End If
											
										End if
									End if

								Else
									If renkdef(jomemidx(0)) >= renkdef(jomemidx(1))  Then 
										Call uprank( jomemidx(0), jomemidx(1), jomemidx(2) )
										Call uptable( jomemidx(0) )
										Call uptable( jomemidx(1) )
									Else
										Call uprank( jomemidx(1), jomemidx(0), jomemidx(2) )
										Call uptable( jomemidx(1) )
										Call uptable( jomemidx(0) )
									End if
									'1등과 2등 득실차 비교
									'3등은 그냥 처리
								End if
							Case "0"
								Call uprank( jomemidx(0), 0, 0 )
								Call uptable( jomemidx(0) )
								'2와 3이 0점 실격
							End Select

						Case "0" '모두 0 모두 기권처리됨 모두 실격
						End Select



					Case 2 
						'Select Case jowincnt(0)
						'Case "1"
							Call uprank( jomemidx(0), jomemidx(1), 0 )							
							Call uptable( jomemidx(0) )
							Call uptable( jomemidx(1) )
							'1등
						'Case "0"
							'0이면 실격
						'End Select
					End Select 


				End if
			End if

		End If

	End if
	

	'예선 조경기가 완료되었다면 순위 1,2,3 위를 결정하여 넣어준다. sd_TennisMember > t_rank #############
	'#################################################################################



	
	'Call oJSONoutput.Set("debug", debugstr )
	Call oJSONoutput.Set("result", "0" )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 