<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	reqmidx = oJSONoutput.P1					'대상팀키
	rankno = oJSONoutput.RANKNO				'순위번호 1,2,3
	gamekey3 = oJSONoutput.S3KEY				'게임종목 키
	levelno = gamekey3
	gamekey3 = Left(gamekey3,5)
	gamekeyname = oJSONoutput.TeamNM		'부명칭
	tidx = oJSONoutput.TitleIDX					'게임타이틀 인덱스
	jono = oJSONoutput.JONO						'조번호 (예선/순위결정 작업때 사용)
	
	joinstr = " left "

	Set db = new clsDBHelper

	'같은 조 멤버 조회 (예선 리그)
		strAfield = " a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX, a.userName, a.teamAna, a.teamBNa "
		strBfield = " b.userName, b.teamANa, b.teamBNa ,a.gamekey1,a.gamekey2,a.gamekey3, t_rank,      a.PlayerIDX,b.PlayerIDX, a.rndno1,a.rndno2, a.TeamGb,a.key3name, a.place"
		strfield = strAfield &  ", " & strBfield

		SQL = "select   " & strfield
		SQL = SQL & " from sd_TennisMember as a inner JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX "
		SQL = SQL & " where a.gubun = 1 and a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelno & "  and a.tryoutgroupno =  " & jono & " and DelYN = 'N' order by a.tryoutsortno asc" 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		membercnt = 0
		If Not rs.EOF Then
			arrNo = rs.GetRows()
		End If
		rs.close


		If IsArray(arrNo)  Then
			membercnt = UBound(arrNo,2) 
			For ar = LBound(arrNo, 2) To membercnt
				prerank = arrNo(12,ar)
				If CDbl(prerank) = 1 Then '이전 1등정보
					rank1midx = arrNo(2, ar)
					rank1pidx = arrNo(13,ar)
				End if
				If CDbl(prerank) = 2 Then '이전 2등정보
					rank2midx = arrNo(2, ar)
					rank2pidx = arrNo(14,ar)
				End if

				If ar = 0 Then '조원 인덱스 묶음
					midxWhere =  arrNo(2, ar)
				Else
					midxWhere =  midxWhere & "," & arrNo(2, ar) 'midx
				End if
			Next
		End if
	'같은 조 멤버 조회 (예선 리그)

	'Call getRowsDrow(arrNo)
	'Response.write midxWhere
	'Response.end

	'코트해제 및 결과 저장 
		SQL = " SELECT resultIDX,gameMemberIDX1,gameMemberIDX2,courtno FROM sd_TennisResult where ( gameMemberIDX1 in (" & midxWhere & ") or gameMemberIDX2 in (" & midxWhere & " ) )  and delYN = 'N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrRS = rs.GetRows()

		'Call getRowsDrow(arrRS)

		Else '없다면 결과를 만들어서 넣어...(코트 배정이 없는경우 나랑 관계된것만 만들어넣어....야...)
			insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno"
			If IsArray(arrNo)  Then
				For ar = LBound(arrNo, 2) To UBound(arrNo,2) 
					If ar = 0 Then
						insertvalue = " ("&arrNo(2, ar)&","&arrNo(2, ar)&",0,0,getdate(),'','운영자','ING','"&tidx&"',"&gamekey3&",'"&gamekeyname&"',"&levelno& "," &jono & ")" 
					Else
						insertvalue = insertvalue & ", ("&arrNo(2, ar)&","&arrNo(2, ar)&",0,0,getdate(),'','운영자','ING','"&tidx&"',"&gamekey3&",'"&gamekeyname&"',"&levelno& "," &jono & ")" 
					End if
				Next
			End if

			If insertvalue <> "" then
				SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values " & insertvalue
				Call db.execSQLRs(SQL , null, ConStr)		
			End if
		End If
		rs.close

		c = 0
		If IsArray(arrRS)  Then
			For ar = LBound(arrRS, 2) To UBound(arrRS,2) 
				ridx = arrRS(0, ar)		'결과인덱스
				midx1 = arrRS(1, ar)		'대진표인덱스1 
				midx2 = arrRS(2, ar)		'대진표인덱스2
				cno = arrRS(3, ar)		'코트인덱스(지정된)

				'  3개중에  요청한 reqmidx의 gameMemberIDX1, gameMemberIDX2 중에 포함된 코트만해제해야해....(요청한것만 해제)
				If (	CStr(midx1) = CStr(reqmidx) Or CStr(midx2) = CStr(reqmidx)	) And CDbl(cno) > 0 Then
					If c = 0 Then
						ridxin = ridx
					Else
						ridxin = ridxin & "," & ridx 
					End If
					c = c + 1
				End if

			Next

		End if

		'코트해제
		If ridxin <> "" Then
			SQL = "update sd_TennisResult Set courtno= 0  where resultIDX in  (" & ridxin & ")"
			Call db.execSQLRs(SQL , null, ConStr)
		End If
	'코트해제 및 결과 저장	

	'##############################
	'본선기록 삭제
	'##############################
	Sub delUpgradeInfo(tidx, levelno, pidx)
			Dim subquery,SQL,midx,sortno,insertfield,insertvalue, arrRS,rs, ar,del_midx

			'subquery = "( select gameMemberIDX from sd_TennisMember "
			'subquery = subquery & " where gubun in (2, 3) and GameTitleIDX = " & tidx & " and gamekey3 = " & levelno & " and round in (1,2) and DelYN = 'N' and PlayerIDX = " & pidx & ")" '부전승까지는 지우자. ? 
			SQL = "select gameMemberIDX from sd_TennisMember where gubun in (2, 3) and GameTitleIDX = " & tidx & " and gamekey3 = " & levelno & " and round in (1,2) and DelYN = 'N' and PlayerIDX = " & pidx
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		

			If Not rs.eof Then
				arrRS = rs.GetRows()
				If IsArray(arrRS)  Then
					For ar = LBound(arrRS, 2) To UBound(arrRS,2) 
						midx = arrRS(0, ar)

						If ar = 0 Then
							del_midx = midx
						Else
							del_midx = del_midx & "," & midx
						End If
					Next
				End if
			
				'부전또는 올라간 경기가 있다면 결과값도 지워야....		
				SQL = "delete from sd_TennisResult where gameMemberIDX1 in  ("&del_midx&") or gameMemberIDX2  in ("&del_midx&")  "
				Call db.execSQLRs(SQL , null, ConStr)

				SQL = "update sd_TennisMember Set playeridx = 1, userName= '--' where gamememberIDX in ("&del_midx&") " ' & subquery
				Call db.execSQLRs(SQL , null, ConStr)

				SQL = "delete from sd_TennisMember_partner where gamememberIDX in  ("&del_midx&")  " '& subquery
				Call db.execSQLRs(SQL , null, ConStr)

			End if

	End Sub
	'##############################


	'##############################
	'추첨룰 가져오기 (본선 룰 다시 가져오기)
	'##############################
	    jooidx = CStr(tidx) & CStr(levelno) '생성된 추첨룰이 있다면
		SQL = "Select orderno,sortno,joono,mxjoono,idx     ,gang,round,ABC from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
		Set rsrndno = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rsrndno.eof then
		  arrRND = rsrndno.GetRows()    
		  'Call getRowsDrow (arrRND)		
		Else
			'추첨룰이 없습니다.
			Call oJSONoutput.Set("result", 100003 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

			db.Dispose
			Set db = Nothing
			Response.end
		End If
		rsrndno.close
	'##############################


	'##############################
	'본선정보확인 (1라운드 갯수)
	'##############################
		SQL = "SELECT top 1 joocnt from tblRGameLevel where gametitleidx ='"&tidx&"' and level = '"&levelno&"' and delYN='N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		t_joocntStr = 0
		tcnt = 0
		If Not rs.eof Then
			t_joocntStr = rs(0)
			tcnt = CDbl(rs(0)) * 2
		End If
		rs.close

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
		   '###################################

		SQL = "Select count(*) from sd_TennisMember where GameTitleIDX = '"&tidx&"' and gamekey3 = '"& levelno & "' and gubun in (2,3)  and DelYN = 'N' and Round = '1' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If CDbl(rs(0))  = CDbl(drowcnt)  Then
			'패스
		Else
			'본선 편성완료 후 다시 해주세요. (1라운드 명수가 틀리다면)
			Call oJSONoutput.Set("result", 100001 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

			db.Dispose
			Set db = Nothing
			Response.end
		End If
		
	'본선정보확인 (1라운드 갯수) ###############




	'예선 조 참가자 데이터 중에서
	IF IsArray(arrNo) Then
		For ar = LBound(arrNo, 2) To UBound(arrNo, 2)
			'##############
				gno =			arrNo(0,ar)
				sortno =		arrNo(1,ar)
				m1idx =			arrNo(2,ar)
				p1name =		arrNo(3,ar)
				p1team1 =		arrNo(4,ar)
				p1team2 =		arrNo(5,ar)
				p2name =		arrNo(6,ar)
				p2team1 =		arrNo(7,ar)
				p2team2 =		arrNo(8,ar)
				key1  =	arrNo(9,ar)
				key2  =	arrNo(10,ar)
				key3  =	arrNo(11,ar)
				rank = arrNo(12,ar)
				p1idx = arrNo(13,ar)
				p2idx = arrNo(14,ar)
				rndno1 = isNullDefault(arrNo(15,ar),0)
				rndno2 = isNullDefault(arrNo(16,ar),0)
				TeamGb = arrNo(17,ar)
				key3name = arrNo(18,ar)
				place = arrNo(19,ar)
			'##############

			'나인데
			If CDbl(reqmidx) = CDbl(m1idx) Then '받아온 인덱스 (요청한 인덱스랑 비교)
				
					If CDbl(rndno1) = 0  Or CDbl(rndno2) = 0  Then
						'본선 편성완료 후 다시 해주세요.(랜덤번호 설정안된경우)
						Call oJSONoutput.Set("result", 100002 )
						strjson = JSON.stringify(oJSONoutput)
						Response.Write strjson

						db.Dispose
						Set db = Nothing
						Response.end
					Exit For
					End if

					'대상의 랭크가 다를경우 교체해준다.
					IF (CDbl(rankno) <> CDbl(rank)) Then '받아온순위번호
						SQL = "Update sd_TennisMember Set t_rank = " & rankno & "  where gamememberIDX = " & reqmidx ' rankno  1, 2 ,3
						Call db.execSQLRs(SQL , null, ConStr)	

						If CDbl(rank) = 1 Or CDbl(rank) = 2 Then '내링킹이 1등또는 2등이라면
							Call delUpgradeInfo(tidx, levelno, p1idx) '내본선기록지우기
						END IF 

						'본선 1라운드 로 복사
						IF CDbl(rankno) = 1 Or CDbl(rankno) = 2 Then
								
							'소팅번호찾기 
							If IsArray(arrRND) Then 'rullmake info
							For i = LBound(arrRND, 2) To UBound(arrRND, 2) 
								  r_orderno = arrRND(0, i) 
								  r_sortno = arrRND(1, i) 
								  r_joono  = arrRND(2, i) 
								  r_abc = arrRND(7,i) '경기진행 조ABC


									'바뀐 나의 랭크와 같은 대상을 찾는다. 바뀐 나의 랭크가 0인 경우는 찾을 필요 없다. 
									If (CDbl(rank) = 1 Or CDbl(rank) = 0) And CDbl(rankno) = 2  Then '나 1등 or 3등 이였는데 요청이 2야
										'내껀지웠고 2등했던애가 있으면 본선기록 지워 rank 는 0으로 하고 
										If rank2midx <> "" Then
											'2등한애 본선기록 지우기 
											Call delUpgradeInfo(tidx, levelno, rank2pidx)
											SQL = "Update sd_TennisMember Set t_rank = 0 where gamememberIDX = " & rank2midx
											Call db.execSQLRs(SQL , null, ConStr)	
										End If
									End if

									If (CDbl(rank) = 2 Or CDbl(rank) = 0) And CDbl(rankno) = 1  Then '나 2등 or 3등 이였는데 요청이 1야
										'내껀지웠고 1등했던애가 있으면 본선기록 지워 rank 는 0으로 하고 
										If rank1midx <> "" Then
											'1등한애 본선기록 지우기 
											Call delUpgradeInfo(tidx, levelno, rank1pidx)
											SQL = "Update sd_TennisMember Set t_rank = 0 where gamememberIDX = " & rank1midx
											Call db.execSQLRs(SQL , null, ConStr)
										End if
									End if
								

								  '랜덤번호가 0보다 크다면
								  If CDbl(rankno) = 1 And Cdbl(r_orderno) = CDbl(rankno) And CDbl(r_joono) = CDbl(rndno1) Then '요청랭킹 1등  1등자리이고 1등자리 랜덤번호

											'SQL = "delete from sd_TennisMember where GameTitleIDX = '"&tidx&"' and gamekey3 = '"& levelno & "' and gubun in (2,3)  and DelYN = 'N' and Round = '1'  and sortNo = " & r_sortno
											'지우고 (--  부전, 플레이어 ) and playerIDX  in (0,1) '기존위치꺼 지우고

											SQL = "select gameMemberIDX from sd_tennisMember where GameTitleIDX = '"&tidx&"' and gamekey3 = '"& levelno & "' and gubun in (2,3)  and DelYN = 'N' and Round = '1'  and sortNo="& r_sortno	
											Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

											If rs.eof then'인서트
												insertfield  = " gubun,Round,  GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,t_rank,tryoutgroupno,tryoutsortNo,rndno1,rndno2,place,sortno,ABC "
												insertvalue = "  3,1, '"&tidx&"', '"&p1idx&"', '"&p1name&"', '"&key1&"', '"&key2&"', '"&key3&"', '"&teamgb&"', '"&key3name&"', '"&p1team1&"', '"&p1team2&"', '"&rankno&"', '"&gno&"', '"&sortno&"', '"&rndno1&"', '"&rndno2&"', '"&place&"' ,'"&r_sortno&"','"&r_abc&"'  " 

												SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  values (" & insertvalue & ") SELECT @@IDENTITY"
												Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
												midx = rs(0)

											Else
												midx = rs(0)
												SQL = "Update sd_tennisMember set gubun=3,Round=1,  GameTitleIDX = "&tidx&",PlayerIDX="&p1idx&",userName='"&p1name&"',gamekey1='"&key1&"',gamekey2='"&key2&"',gamekey3='"&key3&"',TeamGb='"&teamgb&"',key3name='"&key3name&"',TeamANa='"&p1team1&"',TeamBNa='"&p1team2&"',t_rank='"&rankno&"',tryoutgroupno='"&gno&"',tryoutsortNo='"&sortno&"',rndno1='"&rndno1&"',rndno2='"&rndno2&"',place='"&place&"',sortno='"&r_sortno&"',ABC='"&r_abc&"' where gameMemberidx = " & rs(0)
												Call db.execSQLRs(SQL , null, ConStr)
											End if

											'파트너 insert
											insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
											insertvalue = " "&midx&", '"&p2idx&"', '"&p2name&"', '"&p2team1&"', '"&p2team2&"' "
											SQL = "insert into sd_TennisMember_partner ("&insertfield&")  values  (" & insertvalue & ") "
											Call db.execSQLRs(SQL , null, ConStr)

										Exit for
								  End If

								  If CDbl(rankno) = 2 And Cdbl(r_orderno) = CDbl(rankno) And CDbl(r_joono) = CDbl(rndno2) Then
											
											'지우고 (--  부전, 플레이어 ) and playerIDX  in (0,1)
											'SQL = "delete from sd_TennisMember where GameTitleIDX = '"&tidx&"' and gamekey3 = '"& levelno & "' and gubun in (2,3)  and DelYN = 'N' and Round = '1'  and sortNo = " & r_sortno	
											'Call db.execSQLRs(SQL , null, ConStr)
											SQL = "select gameMemberIDX from sd_tennisMember where GameTitleIDX = '"&tidx&"' and gamekey3 = '"& levelno & "' and gubun in (2,3)  and DelYN = 'N' and Round = '1'  and sortNo="& r_sortno	
											Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

											If rs.eof then'인서트
												insertfield  = " gubun,Round,  GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,t_rank,tryoutgroupno,tryoutsortNo,rndno1,rndno2,place,sortno,ABC "
												insertvalue = "  3,1, '"&tidx&"', '"&p1idx&"', '"&p1name&"', '"&key1&"', '"&key2&"', '"&key3&"', '"&teamgb&"', '"&key3name&"', '"&p1team1&"', '"&p1team2&"', '"&rankno&"', '"&gno&"', '"&sortno&"', '"&rndno1&"', '"&rndno2&"', '"&place&"' ,'"&r_sortno&"','"&r_abc&"'  " 

												SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  values (" & insertvalue & ") SELECT @@IDENTITY"
												Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
												midx = rs(0)
											Else
												midx = rs(0)
												SQL = "Update sd_tennisMember set gubun=3,Round=1,  GameTitleIDX = "&tidx&",PlayerIDX="&p1idx&",userName='"&p1name&"',gamekey1='"&key1&"',gamekey2='"&key2&"',gamekey3='"&key3&"',TeamGb='"&teamgb&"',key3name='"&key3name&"',TeamANa='"&p1team1&"',TeamBNa='"&p1team2&"',t_rank='"&rankno&"',tryoutgroupno='"&gno&"',tryoutsortNo='"&sortno&"',rndno1='"&rndno1&"',rndno2='"&rndno2&"',place='"&place&"',sortno='"&r_sortno&"',ABC='"&r_abc&"' where gameMemberidx = " & rs(0)
												Call db.execSQLRs(SQL , null, ConStr)
											End if

											'파트너 insert
											insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
											insertvalue = " "&midx&", '"&p2idx&"', '"&p2name&"', '"&p2team1&"', '"&p2team2&"' "
											SQL = "insert into sd_TennisMember_partner ("&insertfield&")  values  (" & insertvalue & ") "
											Call db.execSQLRs(SQL , null, ConStr)										
										
										Exit for
								  End If


							 Next 
							End if

						End IF
					End If




			End If

		Next
	End IF

	


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>