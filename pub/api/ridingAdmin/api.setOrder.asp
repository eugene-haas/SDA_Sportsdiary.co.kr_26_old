<%
'#############################################
'출전순서 부여
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX 
	End If
	If hasown(oJSONoutput, "FINDYEAR") = "ok" then
		nowgameyear= oJSONoutput.FINDYEAR 
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		gbidx = oJSONoutput.GBIDX 
	End If	

	'timestr = setTimeFormat(settime)

	If kgame = "" Then
		SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		kgame = rs("kgame") 'YN 체전여부 
	End if


	'시작 
	'종목이 마장마술인지 파악
	'if 마장마술 then
		' 시작 시간파악  
			' 중복확인 
			'말이름 , 사람이름 겹치지 않도록 분배
			'다른 마장마술 설정된것중에 시간이 곂치지 안도록 처리?? 이거는 ㅡㅡ+ 오늘 날짜인 마장마술이 있는지검사 부터.
		' class 별로 적용 분 + 해서 시간 넣기  
		' 순서대로 번호 넣어주기
	'else
		'경기순서 넣어주기
	'end if


	'gbidx 로 묶인 게임 정보 
	strTableName2 = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfieldA = " a.RGameLevelidx,  b.levelno,b.TeamGbNm,b.ridingclass,b.ridingclasshelp ,a.GameDay,a.GameTime,a.gametimeend,  b.teamgb  " 
	strFieldName2 = strfieldA 
	strWhere2 = " a.GameTitleIDX = "&tidx&" and a.gbIDX = '"&gbidx&"' and a.DelYN = 'N' and b.DelYN = 'N' "

	SQL = "Select top 1 "&strFieldName2&" from "&strTableName2&" where " & strWhere2
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'646	20101001	마장마술	b	h	2019-03-19	09:00	20:30


	If Not rs.EOF Then
		arrNo = rs.GetRows()
		If IsArray(arrNo)  Then
			o_ridx = arrNo(0, 0)
			o_levelno = arrNo(1, 0)
			o_levelnm = arrNo(2, 0) '복합마술 ..
			o_classnm = arrNo(3, 0) '클레스명 ...
			o_classhelp = arrNo(4, 0)
			o_gamedate = arrNo(5, 0)
			o_stime = arrNo(6, 0) & ":00"
			o_etime = arrNo(7, 0) & ":00"
			o_teamgb = arrNo(8,0) '팀코드  릴레이 20208 복합마술 20103
		End if
	End If

	o_s = o_gamedate & " " & o_stime '시작날짜 시간

	If o_levelnm = "마장마술" Or (o_levelnm = "복합마술" And InStr(o_classnm,"마장마술") > 0 )   Then '마장마술, 복합마술 마장마술
		majang = true
		gametype = "BMMM" '게임형태 복합마술 마장마술
		'시작시간은 o_stime
		'클레스명은 o_classnm

		'마장마술 시간간격구하기 fn_ridgin.asp
		plusn = getGameTime(o_classnm)
		
'		Select Case Left(LCase(o_classnm),1)
'		Case "s" :	plusn = 8 '8분
'		Case "a" :	plusn = 7 '7분
'		Case "b" :	plusn = 6 '6분
'		Case "c" :	plusn = 6 '6분
'		Case "d" :	plusn = 7 '7분
'		Case "f" :	plusn = 6 '6분
'		Case Else :	plusn = 6 '6분 (오류안나게)
'		End Select
		
	Else
		majang = false		
		gametype = "BMJM" '게임형태 복합마술 장애물
	End if
	
'	'Response.write "<span style='color:red;'>###########################################"
'	'Response.write "1. 마장마술/ 장애물 (순서는 랜덤입니다. ) round 를 0 	결과는 api.jReGame.asp 재경기 생성처럼 더해서 거기서 만들자.
'	'Response.write "############################################################"

	'릴레이는 단체명이므로 파트너가 없다..??

	If o_teamgb = "20208" Then '릴레이
	tblnm = " SD_tennisMember as a left join sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	else		
	tblnm = " SD_tennisMember as a Inner join sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	End if
	fldnm = "a.gameMemberIDX,a.playeridx,isnull(b.playeridx,0),a.username,isnull(b.username,0),a.tryoutresult ,a.gubun, a.tryoutsortno     ,ctbl.c ,htbl.hc , (ctbl.c + htbl.hc) as csum ,a.pubcode, a.pubname " 
	SQL = "Select "&fldnm&" from "&tblnm
	
	SQL = SQL & " left join (select playeridx, count(*)  as c  from sd_tennisMember where gametitleidx = "&tidx&" and delyn= 'N' and gamekey3 = '"&gbidx&"' and gubun < 100 and round = 1 group by playeridx ) as ctbl On a.PlayerIDX = ctbl.PlayerIDX "

	SQL = SQL & " left join (select tmp.playeridx as hidx, count(*)  as hc  from sd_tennisMember as tm Inner join sd_tennisMember_partner as tmp ON tm.gamememberidx = tmp.gamememberidx  where tm.gametitleidx = "&tidx&" and tm.delyn= 'N' and tm.gamekey3 = '"&gbidx&"' and tm.gubun < 100 and tm.round = 1 group by tmp.playeridx ) as htbl On b.PlayerIDX = htbl.hidx "

	SQL = SQL & " where a.gametitleidx = "&tidx&" and a.delYN = 'N' and a.gamekey3 = '"&gbidx&"' and a.gubun < 100 and a.round = 1 and a.playerIDX > 1   order by csum desc, ctbl.c desc, a.username ,htbl.hc desc,  b.username desc "	'바이와 공백제외(바이제외)
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




	rscnt = 0
	If Not rs.EOF Then
		rscnt = rs.RecordCount	'	o_cnt = UBound(arrK, 2) + 1  
		pubcode = rs("pubcode")
		pubname = rs("pubname")
		arrNo = rs.GetRows()
	End If
	rs.close	




'################################################
	Function chkName(ByRef arr, ByVal pnm)
		Dim fnresult, ar
		fnresult = true
		If IsArray(arr)  Then
			For ar = LBound(arr, 2) To UBound(arr, 2)
				If pnm = arr(3, ar)  Then
					fnresult = false
					Exit For 
				End if
			Next
		End If

		chkName = fnresult
	End function

	Redim arrMake (UBound(arrNo,1 ), UBound(arrNo, 2)) '새로 만들어질 DB
	Redim arrM3 (UBound(arrNo,1 ), 1) '3명이상의 중복인 친구들

	n = 0
	m = 0
	onepcnt = 0 '중복안된 사람 명수
	maxsamep = False '3명이상중복자 여부
	If IsArray(arrNo)  Then
		For ar = LBound(arrNo, 2) To UBound(arrNo, 2)
			
			pnm = arrNo(3, ar) 
			hnm = arrNo(4, ar)
			no = arrNo(8,ar)
			sumno = arrNo(10,ar)

			If no >2 Then
				maxsamep = True 
			End If

			If no = 1 Then
				onepcnt = onepcnt + 1
			End if
				

			If  chkName(arrMake, pnm) = True And sumno > 2 then
				If pre_hnm <> hnm then
					'넣었는데 이름 중복된거 있나 다시 확인
					For x = 0 To UBound(arrNo,1 ) 
						arrMake(x, n) = arrNo(x, ar)
					Next 
					pre_pnm = pnm
					pre_hnm = hnm
					n = n + 1
				else
					ReDim Preserve arrM3(UBound(arrNo,1 ), m)
					For y = 0 To UBound(arrNo,1 ) 
					arrM3(y, m) = arrNo(y, ar)
					Next 
					m = m + 1
				End if
			Else
				ReDim Preserve arrM3(UBound(arrNo,1 ), m)
				For y = 0 To UBound(arrNo,1 ) 
				arrM3(y, m) = arrNo(y, ar)
				Next 
				m = m + 1
			End if
		Next
	End if

	If maxsamep = True Then
		onepcnt = Fix(onepcnt/2)
	End If 


	'순서뒤집어서 한명 맴버 찍기####################
	arrOne = arraySort (arrM3, 8, "Text", "desc" ) 
	
	m = 0
	If IsArray(arrOne)  Then
		For ar = LBound(arrOne, 2) To UBound(arrOne, 2)
			
			pnm = arrOne(3, ar) 
			hnm = arrOne(4, ar)
			no = arrOne(8,ar)
			sumno = arrOne(10,ar)
			If no = 1 And ar <  onepcnt Then '1명짜리들 찍을 갯수만큼
					For x = 0 To UBound(arrOne,1 ) 
						arrMake(x, n) = arrOne(x, ar)
					Next 
					n = n + 1
			Else '넣은애들 빼고 다시 배열 생성
				ReDim Preserve arrM3(UBound(arrOne,1 ), m)
				For y = 0 To UBound(arrOne,1 ) 
				arrM3(y, m) = arrOne(y, ar)
				Next 
				m = m + 1
			End If
		Next
	End if

'Call getrowsdrow(arrm3)
'Response.end
	'3명이상 친구들 두번째 아이들 그리기###################
	pre_pnm = ""
	pre_hnm = ""
	If maxsamep = True Then

		arrOne = arraySort (arrM3, 3, "Text", "desc" ) 

		m = 0
		If IsArray(arrOne)  Then
			For ar = LBound(arrOne, 2) To UBound(arrOne, 2)
				
				pnm = arrOne(3, ar) 
				hnm = arrOne(4, ar)
				no = arrOne(8,ar)
				sumno = arrOne(10,ar)

				If no > 2 And  pre_pnm = pnm Then '3명이상일경우만
						If pre_hnm <> hnm then
							For x = 0 To UBound(arrOne,1 ) 
								arrMake(x, n) = arrOne(x, ar)
							Next 
							pre_hnm = hnm
							n = n + 1
						Else
							ReDim Preserve arrM3(UBound(arrOne,1 ), m)
							For y = 0 To UBound(arrOne,1 ) 
							arrM3(y, m) = arrOne(y, ar)
							Next 
							m = m + 1
						End if
				Else '넣은애들 빼고 다시 배열 생성
					ReDim Preserve arrM3(UBound(arrOne,1 ), m)
					For y = 0 To UBound(arrOne,1 ) 
					arrM3(y, m) = arrOne(y, ar)
					Next 
					m = m + 1
				End If

			pre_pnm = pnm
			Next
		End if



		'순서뒤집어서 한명 맴버 찍기####################
		arrOne = arraySort (arrM3, 8, "Text", "desc" ) 
		
		m = 0
		If IsArray(arrOne)  Then
			For ar = LBound(arrOne, 2) To UBound(arrOne, 2)
				
				pnm = arrOne(3, ar) 
				hnm = arrOne(4, ar)
				no = arrOne(8,ar)
				sumno = arrOne(10,ar)
				If no = 1 Then '1명짜리들 남은것들 찍기
						For x = 0 To UBound(arrOne,1 ) 
							arrMake(x, n) = arrOne(x, ar)
						Next 
						n = n + 1
				Else '넣은애들 빼고 다시 배열 생성
					ReDim Preserve arrM3(UBound(arrOne,1 ), m)
					For y = 0 To UBound(arrOne,1 ) 
					arrM3(y, m) = arrOne(y, ar)
					Next 
					m = m + 1
				End If
			Next
		End if

	End If

	'2찍고 
		arrOne = arraySort (arrM3, 4, "Text", "desc" ) '말로 소팅
		m = 0
		If IsArray(arrOne)  Then
			For ar = LBound(arrOne, 2) To UBound(arrOne, 2)
				
				pnm = arrOne(3, ar) 
				hnm = arrOne(4, ar)
				no = arrOne(8,ar)
				sumno = arrOne(10,ar)
				If no = 2 Then '1명짜리들 남은것들 찍기
					If pre_hnm <> hnm then	
						For x = 0 To UBound(arrOne,1 ) 
							arrMake(x, n) = arrOne(x, ar)
						Next
						pre_hnm = hnm
						n = n + 1
					Else
						ReDim Preserve arrM3(UBound(arrOne,1 ), m)
						For y = 0 To UBound(arrOne,1 ) 
						arrM3(y, m) = arrOne(y, ar)
						Next 
						m = m + 1
					End if
				Else '넣은애들 빼고 다시 배열 생성
					ReDim Preserve arrM3(UBound(arrOne,1 ), m)
					For y = 0 To UBound(arrOne,1 ) 
					arrM3(y, m) = arrOne(y, ar)
					Next 
					m = m + 1
				End If
			Next
		End if


	'그리고 남은애들 다찍으면 되지 않을까  (여기까지만 ㅡㅡ)
		arrOne = arraySort (arrM3, 8, "Text", "asc" ) 

		'Response.write n

		'Response.write UBound(arrMake,2 )
		'call GetRowsdrow(arrMake)
		'call GetRowsdrow(arrOne)
		'Response.end		
				
		m = 0
		If IsArray(arrOne)  Then
			For ar = LBound(arrOne, 2) To UBound(arrOne, 2)
				
				pnm = arrOne(3, ar) 
				hnm = arrOne(4, ar)
				no = arrOne(8,ar)
				sumno = arrOne(10,ar)
						For x = 0 To UBound(arrOne,1 ) 
							If  n <= UBound(arrMake,2 ) then
								arrMake(x, n) = arrOne(x, ar)
							End if
						Next 
						n = n + 1

			Next
		End if

'################################################

	Select Case o_teamgb
	Case "20208" '릴레이경기
	
		'총갯수가 8개 미만이라면 리그로 진행한다.
		If CDbl(rscnt) >= 8 Then '1라운드 갯수@@@@@@@@@@@@@@@@@
			tabletype = "tm"
			'갯수에 따라 강수를 결정한다.
			'bye 갯수를 확인하고 바이를 생성한다.
			If  CDbl(rscnt) =8 Then
				tnround = 8 '4, 3, 2, 1
				byecnt = 0
				emptyroundcnt  = 3 
			elseIf  CDbl(rscnt) >8 And CDbl(rscnt) <= 16 Then
				tnround = 16
				emptyroundcnt  = 4
				byecnt = tnround - CDbl(rscnt)
			ElseIf CDbl(rscnt) >16 And CDbl(rscnt) <= 32 Then
				tnround = 32
				emptyroundcnt  = 5
				byecnt = tnround - CDbl(rscnt)
			ElseIf CDbl(rscnt) >32 And CDbl(rscnt) <= 64 Then
				tnround = 64
				emptyroundcnt  = 6
				byecnt = tnround - CDbl(rscnt)
			ElseIf CDbl(rscnt) >64 And CDbl(rscnt) <= 128 Then
				tnround = 128
				emptyroundcnt  = 7
				byecnt = tnround - CDbl(rscnt)
			ElseIf CDbl(rscnt) >128 And CDbl(rscnt) <= 258 Then
				tnround = 256
				emptyroundcnt  = 8
				byecnt = tnround - CDbl(rscnt)
			End if
			
			'라운드 데이터가 있는지 확인한다.
			SQL = "select top 1 round from sd_TennisMember where round > 1 and delyn = 'N' and gametitleidx = "&tidx&" and gamekey3 = '"&gbidx&"' and gubun < 100 "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If rs.eof then
				'나머지 강에다 빈값을 만든다 (2라운드 부터 만든다)###############
				startrnd = tnround / 2 
				roundno = 2
				For x = 1 To emptyroundcnt - 1 '결승은 넣지 않는다. 
					For i = 1 To startrnd
						'인서트 시킨다.
						' inner join 해두어서 파트너까지 만들어야되는군   sortno 는 임의 순서를 생성하는데 쓰는거 같다 ...무얼써야할까 ☆☆☆☆
						insertfield = " round, tryoutsortno, gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name, pubcode,pubname"
						insertvalue = " "&roundno&","& i &", 1, "&tidx&", 0, '--', '202','"&o_levelno&"',"&gbidx&",'20208','릴레이코스경기','"&pubcode&"' , '"&pubname&"'  "
						SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						gamemidx = rs(0)	
						
						insertfield = " GameMemberIDX, PlayerIDX,userName "
						insertvalue = " "&gamemidx&", 0, '--'  "
						SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
						Call db.execSQLRs(SQL , null, ConStr)	
					Next 
				startrnd = startrnd / 2
				roundno = roundno + 1
				Next
			End if
			'나머지 강에다 빈값을 만든다 (2라운드 부터 만든다)###############			

			'업데이트 한다.
			If byecnt > 0 Then
				'바이값이 인서트 되었는지 확인
				SQL = "select top 1 round from sd_TennisMember where round = 1 and playeridx = 1 and delyn = 'N' and gametitleidx = "&tidx&" and gamekey3 = '"&gbidx&"' and gubun < 100 "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If rs.eof Then
					winflagupdate = "OK"
					For  i = 1 To byecnt
						' inner join 해두어서 파트너까지 만들어야되는군
						insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name, pubcode,pubname,winloseWL"
						insertvalue = " 1, "&tidx&", 1, 'BYE', '202','"&o_levelno&"',"&gbidx&",'20208','릴레이코스경기','"&pubcode&"' , '"&pubname&"' , 'L'  "
						SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						gamemidx = rs(0)	
						
						insertfield = " GameMemberIDX, PlayerIDX,userName "
						insertvalue = " "&gamemidx&", 1, 'bye의 말'  "
						SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
						Call db.execSQLRs(SQL , null, ConStr)	
					Next
				End If

				'바이에 배열값을 가져온다.
				SQL = "Select "&fldnm&" from "&tblnm
				SQL = SQL & " left join (select playeridx, count(*)  as c  from sd_tennisMember where gametitleidx = "&tidx&" and delyn= 'N' and gamekey3 = '"&gbidx&"' and gubun < 100 and round = 1 group by playeridx ) as ctbl On a.PlayerIDX = ctbl.PlayerIDX "
				SQL = SQL & " left join (select tmp.playeridx as hidx, count(*)  as hc  from sd_tennisMember as tm Inner join sd_tennisMember_partner as tmp ON tm.gamememberidx = tmp.gamememberidx  where tm.gametitleidx = "&tidx&" and tm.delyn= 'N' and tm.gamekey3 = '"&gbidx&"' and tm.gubun < 100 and tm.round = 1 group by tmp.playeridx ) as htbl On b.PlayerIDX = htbl.hidx "

				SQL = SQL & " where a.gametitleidx = "&tidx&" and a.delYN = 'N' and a.gamekey3 = '"&gbidx&"' and a.gubun < 100 and a.round=1 and a.playeridx = 1 "	
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If Not rs.EOF Then
					arrBYE = rs.GetRows()
				End If
				rs.close	


				'arrMake 에 추가한다. 짝수마다 넣어서....추가...
				'arrMake + arrBYE 하면서 부전승자 2라운드자 저장
				Redim newMake (UBound(arrNo,1 ), tnround - 1) '새로 만들어질 DB
				amcnt = 0 '부전승자진행카운트
				abyecnt = 0 '바이진행카운트
				sortno = 1 '2라운드 부전승 소팅번호
				updatewinidxstr ="" '승자플레그 업데이트할문자열
				For n = 0  To tnround - 1

					If CDbl(UBound(arrBYE,2))  >=  abyecnt then
						If n = 0 Or n  Mod 2 = 0 Then '홀수줄
							If amcnt < tnround/2 Then '라운드/2 이상 부전이 있을수 없다.****
							For x = 0 To UBound(arrMake,1 ) 
								newMake(x, n) = arrMake(x, amcnt)
							Next 
							End if
							'여기서 부전승처리=================이아이의 포지션은? abyecnt  + 1 승자처리도 해줘야겠군
								'2라운드에 넣자...(업데이트)
								SQL = "select top 1 GameMemberIDX from SD_tennisMember where round = 2 and tryoutsortno = " & sortno & " and playerIDX = 0 "
								Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

								If Not rs.EOF Then
									updatemidx = rs(0)

									If amcnt = 0 then
										updatewinidxstr = arrMake(0, amcnt)
									Else
										updatewinidxstr =  updatewinidxstr & "," & arrMake(0, amcnt)
									End if

									SQL = "select top 1  PlayerIDX,userName,TeamGb,key3name,TeamANa, requestIDX from SD_tennisMember where gameMemberIDX = "&arrMake(0, amcnt)
									Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

									setvalue = " round=2,tryoutsortno="&sortno&", gubun=1,GameTitleIDX="&tidx&",gamekey1='202',gamekey2='"&o_levelno&"',gamekey3="&gbidx&",pubcode='"&pubcode&"',pubname='"&pubname&"' "
									setvalue = setvalue & ", PlayerIDX="&rs(0)&",userName='"&rs(1)&"',TeamGb='"&rs(2)&"',key3name='"&rs(3)&"',TeamANa='"&rs(4)&"', requestIDX='"&rs(5)&"' "

									SQL = "update SD_tennisMember set  " & setvalue & " where  GameMemberIDX = " & updatemidx
									Call db.execSQLRs(SQL , null, ConStr)


									SQL = "select top 1  PlayerIDX,userName,Sex  from sd_TennisMember_partner where gameMemberIDX = "&arrMake(0, amcnt)
									Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

									setvalue = " GameMemberIDX="&updatemidx&",PlayerIDX="&rs(0)&",userName='"&rs(1)&"',Sex='"&rs(2)&"'  "
									SQL = "update sd_TennisMember_partner set  "&setvalue&"  where  GameMemberIDX = " & updatemidx
									Call db.execSQLRs(SQL , null, ConStr)
								End if
							'여기서 부전승처리=================
							sortno = sortno + 1
							amcnt = amcnt + 1

						Else '짝수줄 (바이생성자리)
							For x = 0 To UBound(arrBYE,1 ) 
								newMake(x, n) = arrBYE(x, abyecnt)
							Next 
							abyecnt = abyecnt + 1
						End If


					Else '나머지 넣기
						For x = 0 To UBound(arrMake,1 ) 
							newMake(x, n) = arrMake(x, amcnt)
						Next 
						amcnt = amcnt + 1
					End if
					
				next

				If winflagupdate = "OK" then
				'승자플레그 업데이트 (승수를 넣어준다 승수로 진출 라운드 수를 알수 있다)
				SQL = "update sd_TennisMember set winloseWL = 'W',t_win = 1  where  GameMemberIDX in ( " & updatewinidxstr & ") "
				Call db.execSQLRs(SQL , null, ConStr)				
				End if


				Redim arrMake (UBound(arrNo,1 ), tnround - 1) '새로 만들어질 DB
				For n = 0  To tnround - 1
					For x = 0 To UBound(newMake,1 ) 
						arrMake(x, n) = newMake(x, n)
					Next 
				Next

			End If '바이확인하고 넣어주는자리

		Else'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			tabletype = "leg"
			'리그로 진행
		End If

	End Select 


'Call GetRowsdrow(arrMake)
'Response.end



	nextdatetime = o_s
	n = 1
	If IsArray(arrMake)  Then
		For ar = LBound(arrMake, 2) To UBound(arrMake, 2)
			u_midx = arrMake(0, ar) '업데이트 키값
			u_pidx = arrMake(1, ar) '선수인덱스
			u_hidx = arrMake(2, ar) '말인덱스
			u_rt = isNullDefault(arrMake(5,ar),"") '상태 (기권 w 상태 파악을 위해서넣음)

			'nextdatetime = o_s 'o_gamedate & " " & getNextTime(o_s, plusn ) '날짜 시간, 간격 (kgame = 'N'  ) 체전이 아닌경우 gubun =  1로...설정

			If majang = True Then '마장마술 			
				If pre_u_rt = "w" Or ar = 0  Then '경기전 기권이라면 또는 시작
					nextdatetime = nextdatetime
				Else
				
					nextdatetime = o_gamedate & " " & getNextTime(nextdatetime, plusn ) '날짜 시간, 간격
				End if
				
				SQL = "update SD_tennisMember Set tryoutsortno = "&n&" , gametime = '"&nextdatetime&"', gubun = 1 where gameMemberIDX = " & u_midx
				Call db.execSQLRs(SQL , null, ConStr)		
			Else

				SQL = "update SD_tennisMember Set tryoutsortno = "&n&" , gubun = 1 where gameMemberIDX = " & u_midx
				Call db.execSQLRs(SQL , null, ConStr)

			End if
		n = n + 1
		Next
	End if



	'마장마술 생성된 마지막 시간을 앞의  출전순서 경기종료 시간으로 설정해준다.
	If majang = True Then
		nextdatetime =  getNextTime(nextdatetime, plusn ) '날짜 시간, 간격
		SQL = "update tblRGameLevel set gametimeend = '"&Left(nextdatetime,5)&"'  where gametitleidx ='"&tidx&"'  and gbidx = '"&gbidx&"' "
		Call db.execSQLRs(SQL , null, ConStr)
	End if


	If o_levelnm = "복합마술" Then

		'결과는 api.jReGame.asp 재경기 생성처럼 더해서 거기서 만들자.

	End if




  find_gbidx = gbidx
  'find_gbidx   'tidx필요
  %><!-- #include virtual = "/pub/html/riding/sclist.asp" --><%

  db.Dispose
  Set db = Nothing
%>
