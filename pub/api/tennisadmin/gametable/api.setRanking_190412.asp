<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	player1IDX = oJSONoutput.P1 '대상팀키
	rankno = oJSONoutput.RANKNO '순위번호 1,2,3
	gamekey3 = oJSONoutput.S3KEY '게임종목 키
	levelkey = gamekey3
	gamekey3 = Left(gamekey3,5)
	gamekeyname = oJSONoutput.TeamNM '부명칭
	tidx = oJSONoutput.TitleIDX '게임타이틀 인덱스
	jono = oJSONoutput.JONO '조번호 (예선/순위결정 작업때 사용)
	
	If Left(gamekey3,3) = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " left "
		singlegame = false
	End if  

	Set db = new clsDBHelper

	SQL = "select a.gameMemberIDX  "
	SQL = SQL & " from sd_TennisMember as a inner JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX "
	SQL = SQL & " where a.gubun = 1 and a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelkey & "  and a.tryoutgroupno =  " & jono & " and DelYN = 'N' order by a.tryoutsortno asc" 
	sd_TennisMemberCnt = 0
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	Do Until rs.eof
	sd_TennisMemberCnt = sd_TennisMemberCnt + 1

		if(CDbl(sd_TennisMemberCnt) = 1) Then
			oneIdx = rs(0)
		ELSEIF(CDbl(sd_TennisMemberCnt) = 2) Then
			twoIdx  = rs(0)
		ELSEIF(CDbl(sd_TennisMemberCnt) = 3) Then
			treeIdx = rs(0)
		END IF
	rs.movenext
	Loop

	'결과값 생성
	IF CDbl(sd_TennisMemberCnt) = 3 Then '조인원 3인인경우
		SQL = " SELECT Count(*) as Cnt FROM sd_TennisResult "
		SQL = SQL & " where gameMemberIDX1 = " & oneIdx &" or gameMemberIDX1 = " & twoIdx &" or gameMemberIDX1 = " & treeIdx &" and delYN = 'N'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		ResultCnt = rs(0)
		StateNo = 0 ' 0 진행중, 1 경기종료, 2 경기진행중
		Preresult = "ING"

		'winIDX 값 삭제 (18년 1월 18일 백승훈)
		IF CDbl(ResultCnt) = 0 Then
			insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno"
			insertvalue = " "&oneIdx&","&twoIdx&",0,0,getdate(),'"&winner&"','운영자','"&Preresult&"','"&tidx&"',"&gamekey3&",'"&gamekeyname&"',"&levelkey& "," &jono 
			SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
			Call db.execSQLRs(SQL , null, ConStr)	

			insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno"
			insertvalue = " "&oneIdx&","&treeIdx&",0,0,getdate(),'"&winner&"','운영자','"&Preresult&"','"&tidx&"',"&gamekey3&",'"&gamekeyname&"',"&levelkey& "," &jono
			SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
			Call db.execSQLRs(SQL , null, ConStr)	

			insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno"
			insertvalue = " "&twoIdx&","&treeIdx&",0,0,getdate(),'"&winner&"','운영자','"&Preresult&"','"&tidx&"',"&gamekey3&",'"&gamekeyname&"',"&levelkey& "," &jono
			SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
			Call db.execSQLRs(SQL , null, ConStr)

		Else '한개라도 예선 경기 진행건이 있다면 코트 해제

			SQL = " SELECT resultIDX,gameMemberIDX1,courtno FROM sd_TennisResult where gameMemberIDX1 in (" & oneIdx & "," & twoIdx& "," & treeIdx & ") and delYN = 'N' and courtno > 0"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			Do Until rs.eof
				'단장님 확인 8월 16일 (순위를 각각 하므로 불필요하다고 함)
				'SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = " & rs("courtno")  '코트해제
				'Call db.execSQLRs(SQL , null, ConStr)
				SQL = "update sd_TennisResult Set stateno = 1,courtno=0  where resultIDX = " & rs("resultIDX")
				Call db.execSQLRs(SQL , null, ConStr)
			rs.movenext
			loop


		End if

	ELSEIF CDbl(sd_TennisMemberCnt) = 2  Then
		
		SQL = " SELECT Count(*) as Cnt FROM sd_TennisResult "
		SQL = SQL & " where gameMemberIDX1 = '" & oneIdx &"' or gameMemberIDX1 = '" & twoIdx &"' or gameMemberIDX1 = '" & treeIdx &"' and delYN = 'N'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
		
		ResultCnt = rs(0)
		IF CDbl(ResultCnt) = 0 Then
			insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,winResult,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno "
			insertvalue = " "&oneIdx&","&twoIdx&",0,0,getdate(),'"&winner&"','운영자','"&Preresult&"','"&tidx&"',"&gamekey3&",'"&gamekeyname&"',"&levelkey& "," &jono 
			SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
			Call db.execSQLRs(SQL , null, ConStr)	

		Else '코트 해제

			SQL = " SELECT resultIDX,gameMemberIDX1,courtno FROM sd_TennisResult where gameMemberIDX1 in ('" & oneIdx & "','" & twoIdx & "') and delYN = 'N' and courtno > 0"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			Do Until rs.eof
				'단장님 확인 8월 16일 (순위를 각각 하므로 불필요하다고 함)
				'SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = " & rs("courtno")  '코트해제
				'Call db.execSQLRs(SQL , null, ConStr)
				SQL = "update sd_TennisResult Set courtno=0  where resultIDX = " & rs("resultIDX")
				Call db.execSQLRs(SQL , null, ConStr)
			rs.movenext
			loop

		END IF
	END IF


	'같은 조 멤버 조회 (예선 리그)
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strwhere = " a.gubun = 1 and a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelkey & " and a.tryoutgroupno = " & jono & " and DelYN = 'N'"
	strAfield = " a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX, a.userName as aname , a.teamAna as aATN, a.teamBNa as aBTN,a.rankpoint "
	strBfield = " b.partnerIDX, b.userName as bname, b.teamANa as bATN , b.teamBNa as bBTN,b.rankpoint,a.gamekey1,a.gamekey2,a.gamekey3,t_win,t_lose,t_rank, a.PlayerIDX,a.rndno1,a.rndno2"
	strfield = strAfield &  ", " & strBfield
	SQL = "select "& strfield &" from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere

	'Response.Write  "SQL 설명 : 같은 조 맴버 조회하기  " & "</br>"	
	'Response.Write SQL &"<br>"
	'Response.END

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rs.RecordCount

	If Not rs.EOF Then 
		arrRS = rs.getrows()
	End If

	'player1IDX = 1682
	'rankno = 1
	IF IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
			gno =			arrRS(0,ar)
			sortno =		arrRS(1,ar)
			p1idx =			arrRS(2,ar)
			p1name =		arrRS(3,ar)
			p1team1 =		arrRS(4,ar)
			p1team2 =		arrRS(5,ar)
			p1rpoint =		arrRS(6,ar)
			p2idx =			arrRS(7,ar)
			p2name =		arrRS(8,ar)
			p2team1 =		arrRS(9,ar)
			p2team2 =		arrRS(10,ar)
			p2rpoint =	arrRS(11,ar)
			key1  =	arrRS(12,ar)
			key2  =	arrRS(13,ar)
			key3  =	arrRS(14,ar)
			win = arrRS(15,ar)
			lose = arrRS(16,ar)
			rank = arrRS(17,ar)
			p1PlayerIdx = arrRS(18,ar)
			rndno1 = arrRS(19,ar)
			rndno2 = arrRS(20,ar)

			'나의 값은 rank 업데이트 
			'동일한 값 변경시 
			'Response.write "플레이어 idx" &p1PlayerIdx &"</br>"
			
			If CDbl(player1IDX) = CDbl(p1idx) Then
				plyaerRank = 0 
				
				'대상의 랭크가 다를경우 교체해준다.
				IF (CDbl(rankno) <> CDbl(rank)) Then
					'Response.write "랭크 교체" & "</br>"
					
					SQL = "Update sd_TennisMember Set t_rank = " & rankno & "  where gamememberIDX = " & player1IDX

					Call db.execSQLRs(SQL , null, ConStr)	

					'나의 이전 랭크가 1위거나 2위 인경우 
					If CDbl(rank) = 1 Or CDbl(rank) = 2 Then
						'Response.write "나의 이전 랭크가 1위거나 2위 인경우 " & "</br>"
						'Response.write "플레이어 아이디: " &p1PlayerIdx & "</br>"
						
						SQL = "select a.gameMemberIDX from sd_TennisMember as a inner JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX "
						SQL = SQL & " where a.gubun in (3, 2) and a.GameTitleIDX = " & tidx & " and a.gamekey3 = "  & levelkey & " and a.tryoutgroupno = "&jono&" and DelYN = 'N' and a.PlayerIDX = " & p1PlayerIdx
						'Response.Write  "SQL 설명 : 내 본선 기록 지우기  " & "</br>"	
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						Do Until rs.eof			
							delidx = rs(0)
							'Response.write "delidx" & delidx&"</br>"
							SQL = "delete from " & strtable & " where gamememberIDX = " & delidx
							'Response.Write SQL &"<br>"
							Call db.execSQLRs(SQL , null, ConStr)

							SQL = "delete from " & strtablesub  & " where gamememberIDX = " & delidx
							'Response.Write SQL &"<br>"
							Call db.execSQLRs(SQL , null, ConStr)
						rs.movenext
						loop
					END IF 

					IF CDbl(rankno) = 1 Or CDbl(rankno) = 2 Then
							insertfield  = " gubun,Round,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,rankpoint,t_win,t_lose,t_rank,tryoutgroupno,tryoutsortNo,rndno1,rndno2,place "
							selectfield = " "&TOURNSET&","&STARTROUND&" ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,rankpoint,t_win,t_lose,t_rank,tryoutgroupno,tryoutsortNo,IsNull(rndno1,0),IsNull(rndno2,0),place "
							SQL = "SET NOCOUNT ON  insert into "&strtable&" ("&insertfield&")  Select "&selectfield&" from "&strtable&" where gamememberIDX = " & player1IDX & " SELECT @@IDENTITY"
							Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
							midx = rs(0)
							'파트너 insert
							insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa,rankpoint "
							selectfield = " "&midx&",PlayerIDX,userName,TeamANa,TeamBNa,rankpoint "
							SQL = "insert into "&strtablesub&" ("&insertfield&")  Select "&selectfield&" from "&strtablesub&" where gamememberIDX = " & player1IDX
							'Response.Write SQL &"<br>"
							'Response.Write "<br>"
							Call db.execSQLRs(SQL , null, ConStr)	
							'Response.write "새로 생긴 아이디" & midx & "</br>"
					End IF

					plyaerRank = rankno
				ELSE
					'Response.write "랭크가 같아서 교체 안됨" & "</br>"
					plyaerRank = rankno
				End IF


				'바뀐 나의 랭크와 같은 대상을 찾는다. 바뀐 나의 랭크가 0인 경우는 찾을 필요 없다. 
				If CDbl(rankno) = 1 Or CDbl(rankno) = 2 Then
					SQL = "select a.PlayerIDX, a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX, a.userName as aname , a.teamAna as aATN, a.teamBNa as aBTN,a.rankpoint , b.partnerIDX, b.userName as bname, b.teamANa as bATN , b.teamBNa as bBTN,b.rankpoint,a.gamekey1,a.gamekey2,a.gamekey3,t_win,t_lose,t_rank "
					SQL = SQL & " from sd_TennisMember as a "
					SQL = SQL & " inner JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX"
					SQL = SQL & " where a.gubun = 1 and a.GameTitleIDX =  " & tidx & " and a.gamekey3 = "  & levelkey & " and a.tryoutgroupno = "&jono&" and DelYN = 'N' and t_rank = " & plyaerRank & " and a.gameMemberIDX != " & player1IDX
					'Response.Write  "SQL 설명 : 같은 대상 맴버 찾기  " & "</br>"	
					'Response.Write SQL &"<br>"
					'Response.Write "<br>"

					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

					Do Until rs.eof				
						rGameMemberIDX = rs(3)
						rPlayerIdx = rs(0)

						SQL = "Update sd_TennisMember Set t_rank = 0  where gamememberIDX = " & rGameMemberIDX
						'Response.Write  "SQL 설명 : 랭크가 같았던 녀석의 rank를 0으로 낮추는 작업  " & "</br>"	
						'Response.Write SQL &"<br>"
						'Response.Write "<br>"
						Call db.execSQLRs(SQL , null, ConStr)	

						SQL = "select a.gameMemberIDX from sd_TennisMember as a inner JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX "
						SQL = SQL & " where a.gubun in (3, 2) and a.GameTitleIDX = " & tidx & " and a.gamekey3 = "  & levelkey & " and a.tryoutgroupno = "&jono&" and DelYN = 'N' and a.PlayerIDX = " & rPlayerIdx
						'Response.Write  "SQL 설명 :  랭크가 같았던 녀석 본선 기록 지우기  " & "</br>"	
						'Response.Write SQL &"<br>"

						Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr)

							Do Until rs2.eof			
								delidx2 = rs2(0)
								'Response.write "delidx" & delidx&"</br>"
								SQL = "delete from " & strtable & " where gamememberIDX = " & delidx2
								'Response.Write SQL &"<br>"
								Call db.execSQLRs(SQL , null, ConStr)
			
								SQL = "delete from " & strtablesub  & " where gamememberIDX = " & delidx2
								'Response.Write SQL &"<br>"
								Call db.execSQLRs(SQL , null, ConStr)
							rs2.movenext
							loop
					
						rs.movenext
					loop
				ELSEIF CDbl(rankno) = 3 Then
					SQL = "select a.PlayerIDX, a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX, a.userName as aname , a.teamAna as aATN, a.teamBNa as aBTN,a.rankpoint , b.partnerIDX, b.userName as bname, b.teamANa as bATN , b.teamBNa as bBTN,b.rankpoint,a.gamekey1,a.gamekey2,a.gamekey3,t_win,t_lose,t_rank "
					SQL = SQL & " from sd_TennisMember as a "
					SQL = SQL & " inner JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX"
					SQL = SQL & " where a.gubun = 1 and a.GameTitleIDX =  " & tidx & " and a.gamekey3 = "  & levelkey & " and a.tryoutgroupno = "&jono&" and DelYN = 'N' and t_rank = " & plyaerRank & " and a.gameMemberIDX != " & player1IDX
					'Response.Write  "SQL 설명 : 같은 대상 맴버 찾기  " & "</br>"	
					'Response.Write SQL &"<br>"
					'Response.Write "<br>"
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					Do Until rs.eof				
						rGameMemberIDX = rs(3)
						SQL = "Update sd_TennisMember Set t_rank = 0  where gamememberIDX = " & rGameMemberIDX
						'Response.Write  "SQL 설명 : 랭크가 같았던 녀석의 rank를 0으로 낮추는 작업  " & "</br>"	
						'Response.Write SQL &"<br>"
						'Response.Write "<br>"
						Call db.execSQLRs(SQL , null, ConStr)	
						rs.movenext
					loop
				END IF

			End If
		Next
	End IF

	


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>