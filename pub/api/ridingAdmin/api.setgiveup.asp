<%
'#############################################
'기권 실격저장
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX 
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		gbidx= oJSONoutput.GBIDX 
	End If
	If hasown(oJSONoutput, "IDX") = "ok" Then 'gamememberidx
		r_idx= oJSONoutput.IDX 
	End If
	If hasown(oJSONoutput, "RIDX") = "ok" then
		r_ridx= oJSONoutput.RIDX
	End If
	If hasown(oJSONoutput, "SAYOU") = "ok" then
		r_sayou= oJSONoutput.SAYOU
	End If

	If hasown(oJSONoutput, "CHKTYPE") = "ok" then
		r_chktype= oJSONoutput.CHKTYPE '진행중에 넘어왔는지 확인 (ING)
	End If



	'W인경우 (마장마술에서) 뒤에 시간 앞으로 자동조정...? 기권들 빼고 시간조정
	'마장마술인 경우 출전순서부여간 되어있는지 확인
	'gbidx 로 묶인 게임 정보 
	tblnm = "SD_tennisMember as a inner join tblTeamGbInfo as b  ON a.gamekey3 = b.teamgbidx "
	SQL = "Select a.teamGb,a.key3name,a.tryoutsortno,a.gametime,a.tryoutresult,a.pubcode,a.round,b.ridingclass , b.ridingclasshelp,a.playeridx  from  "&tblnm&" where a.gameMemberIDX = " & r_idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrNo = rs.GetRows()
		If IsArray(arrNo)  Then
			o_teamgb = arrNo(0, 0)
			o_gbname = arrNo(1, 0)
			o_sortno =  arrNo(2, 0)
			o_gametime =  arrNo(3, 0)
			o_result = arrNo(4,0) '이전결과
			o_pubcode = arrNo(5,0)
			o_roundno = arrNo(6,0)
			o_class = arrNo(7,0)
			o_classhelp = arrNo(8,0)
			o_pidx = arrNo(9,0) '선수인덱스
		End if
	End If
	rs.close

	If o_teamgb = "20101" Or ( o_teamgb = "20103" And InStr(o_class, "마장마술") > 0   )   Then '복합마술 마장마술
		majang = true
	Else
		majang = false		
	End if



	'@@@@@@@@@@@@@@@@@@@@@@@@	
		'tryoutresult, tryoutdocYN
		If r_sayou = "" then
			SQL = "Update SD_tennisMember Set tryoutresult = 0,boo_orderno=0,total_order=0  where gameMemberIDX = " & r_idx
			Call db.execSQLRs(SQL , null, ConStr)
		Else

			'사유소팅순서 구하기 fn_riding.asp
			orderno = getSayooSortno(r_sayou)

			SQL = "Update SD_tennisMember Set tryoutresult = '"& LCase(r_sayou) &"',boo_orderno="&orderno&",total_order="&orderno&"  where gameMemberIDX = " & r_idx
			Call db.execSQLRs(SQL , null, ConStr)
		End if
		
		

		'진행중이 아니라면
		If r_chktype <> "ING" Then '심사입력에서 넘어온경우는 아님...
			If majang = True And LCase(r_sayou) = "w" Then '다음 출전 순서 부터 당김....

				'위에값을 아래로 붙여넣기
				SQL = "update T Set T.agametime = T.bgametime from  "
				SQL = SQL & " (Select  a.tryoutsortno,a.gametime as agametime, b.gametime as bgametime From SD_tennisMember As a inner Join SD_tennisMember As b "
				SQL = SQL & " On a.gametitleidx = b.gametitleidx and a.gamekey3 = b.gamekey3 and a.tryoutsortno = b.tryoutsortno + 1 "
				SQL = SQL & " where a.gametitleidx = "&tidx&" and a.delYN = 'N' and a.gamekey3 = '"&gbidx&"' and a.tryoutsortno >  "&o_sortno&"  and a.gubun < 100) as T "
				Call db.execSQLRs(SQL , null, ConStr)

			End If
			
			If majang = True And LCase(r_sayou) = "" And o_result = "w"  Then '시간원복 (출전시간표 다시실행시키자.)
				'복원하려면 출전순서가 다시 부여됩니다. 그래도 하시겠습니까.?? 1안 
				'2안

				'아래에서 위로 붙여넣기
				SQL = "update T Set T.agametime = T.bgametime from  "
				SQL = SQL & " (Select  a.tryoutsortno,a.gametime as agametime, b.gametime as bgametime From SD_tennisMember As a inner Join SD_tennisMember As b "
				SQL = SQL & " On a.gametitleidx = b.gametitleidx and a.gamekey3 = b.gamekey3 and a.tryoutsortno = b.tryoutsortno - 1 "
				SQL = SQL & " where a.gametitleidx = "&tidx&" and a.delYN = 'N' and a.gamekey3 = '"&gbidx&"' and a.tryoutsortno >  "&o_sortno&" and a.gubun < 100 ) as T "
				Call db.execSQLRs(SQL , null, ConStr)
				

				'마장마술 시간간격구하기 fn_ridgin.asp
				plusn = getGameTime(o_class)

				'마지막꺼는...따로 처리해야함..
				'마지막꺼 인덱스를 그냥 구하자.
				SQL = "select top 1 gameMemberIDX from SD_tennisMember where gametitleidx = "&tidx&" and delYN = 'N' and gamekey3 = '"&gbidx&"' and gubun < 100  order by tryoutsortno desc "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.eof then
				SQL = "update SD_tennisMember set gametime = DATEADD(minute, "&plusn&", gametime)  where gameMemberIDX = " & rs(0)
				Call db.execSQLRs(SQL , null, ConStr)
				End if


				oJSONoutput.SAYOU = "W" '다시 reload 하려면
			End if
		End if



		'gameresult, docYN
		If r_sayou = "" then
			SQL = "Update tblGameRequest Set gameresult = 0 where RequestIDX = " & r_ridx '기권실격 0기본 ERWD
			Call db.execSQLRs(SQL , null, ConStr)
		Else

			SQL = "Update tblGameRequest Set gameresult = '"& LCase(r_sayou) &"' where RequestIDX = " & r_ridx
			Call db.execSQLRs(SQL , null, ConStr)
		End if


		If r_chktype = "ING" Then '심사입력에서 넘어온경우 집계 다시 호출 ( ByRef db, ByVal tidx, ByVal  gbidx, ByVal pubcode, ByVal rdno, ByVal orderType)
			'랭킹집계 A_1 도
			ordertype = GetOrderType( o_classHelp, o_teamgb, o_class)
'			Response.write ordertype
			Call orderUpdate( db, tidx, gbidx,  o_pubcode, o_roundno, ordertype) 'pubcode 0 으로 보내면 검색해서 각각 적용 A, A_1
		End if






	'#########################################################################################
	'복합마술인 경우 선택되지 않은 다른 경기도 변경해주어야한다.
	'#########################################################################################
	If o_teamgb = "20103"  And ssssss = "개별처리하기로함 사용하지 않음" Then
		If majang = True then
			majang = False
		End if

		'두번째 처리할때 필요한 값들 
		'midx, gbidx 
		SQL = "select gamememberidx,gamekey3,requestidx from sd_tennismember where gametitleidx = "& tidx &" and teamgb = '20103'  and  playeridx = "& o_pidx &" and gameMemberIDX <> " & r_idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		r_idx2 = rs(0)
		gbidx2 = rs(1)
		r_ridx2 = rs(2)

		'tryoutresult, tryoutdocYN
		If r_sayou = "" then
			SQL = "Update SD_tennisMember Set tryoutresult = 0,boo_orderno=0,total_order=0 where gamememberidx = " & r_idx2
			Call db.execSQLRs(SQL , null, ConStr)
		Else

			'사유소팅순서 구하기 fn_riding.asp
			orderno = getSayooSortno(r_sayou)

			SQL = "Update SD_tennisMember Set tryoutresult = '"& LCase(r_sayou) &"',boo_orderno="&orderno&",total_order="&orderno&"  where gamememberidx = " & r_idx2
			Call db.execSQLRs(SQL , null, ConStr)
		End if
		
		

		'진행중이 아니라면
		If r_chktype <> "ING" Then '심사입력에서 넘어온경우는 아님...
			If majang = True And LCase(r_sayou) = "w" Then '다음 출전 순서 부터 당김....

				'위에값을 아래로 붙여넣기
				SQL = "update T Set T.agametime = T.bgametime from  "
				SQL = SQL & " (Select  a.tryoutsortno,a.gametime as agametime, b.gametime as bgametime From SD_tennisMember As a inner Join SD_tennisMember As b "
				SQL = SQL & " On a.gametitleidx = b.gametitleidx and a.gamekey3 = b.gamekey3 and a.tryoutsortno = b.tryoutsortno + 1 "
				SQL = SQL & " where a.gametitleidx = "&tidx&" and a.delYN = 'N' and a.gamekey3 = '"&gbidx2&"' and a.tryoutsortno >  "&o_sortno&"  and a.gubun < 100) as T "
				Call db.execSQLRs(SQL , null, ConStr)

			End If
			
			If majang = True And LCase(r_sayou) = "" And o_result = "w"  Then '시간원복 (출전시간표 다시실행시키자.)
				'복원하려면 출전순서가 다시 부여됩니다. 그래도 하시겠습니까.?? 1안 
				'2안

				'아래에서 위로 붙여넣기
				SQL = "update T Set T.agametime = T.bgametime from  "
				SQL = SQL & " (Select  a.tryoutsortno,a.gametime as agametime, b.gametime as bgametime From SD_tennisMember As a inner Join SD_tennisMember As b "
				SQL = SQL & " On a.gametitleidx = b.gametitleidx and a.gamekey3 = b.gamekey3 and a.tryoutsortno = b.tryoutsortno - 1 "
				SQL = SQL & " where a.gametitleidx = "&tidx&" and a.delYN = 'N' and a.gamekey3 = '"&gbidx2&"' and a.tryoutsortno >  "&o_sortno&" and a.gubun < 100 ) as T "
				Call db.execSQLRs(SQL , null, ConStr)
				
				'마장마술 시간간격구하기 fn_ridgin.asp
				plusn = getGameTime(o_class)

				'마지막꺼는...따로 처리해야함..
				'마지막꺼 인덱스를 그냥 구하자.
				SQL = "select top 1 gameMemberIDX from SD_tennisMember where gametitleidx = "&tidx&" and delYN = 'N' and gamekey3 = '"&gbidx2&"' and gubun < 100  order by tryoutsortno desc "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.eof then
				SQL = "update SD_tennisMember set gametime = DATEADD(minute, "&plusn&", gametime)  where gameMemberIDX = " & rs(0)
				Call db.execSQLRs(SQL , null, ConStr)
				End if

				oJSONoutput.SAYOU = "W" '다시 reload 하려면
			End if
		End if



		'gameresult, docYN
		If r_sayou = "" then
			SQL = "Update tblGameRequest Set gameresult = 0 where RequestIDX = " & r_ridx2 '기권실격 0기본 ERWD
			Call db.execSQLRs(SQL , null, ConStr)
		Else

			SQL = "Update tblGameRequest Set gameresult = '"& LCase(r_sayou) &"' where RequestIDX = " & r_ridx2
			Call db.execSQLRs(SQL , null, ConStr)
		End if


		If r_chktype = "ING" Then '심사입력에서 넘어온경우 집계 다시 호출 ( ByRef db, ByVal tidx, ByVal  gbidx, ByVal pubcode, ByVal rdno, ByVal orderType)
			'랭킹집계 A_1 도
			ordertype = GetOrderType( o_classHelp, o_teamgb, o_class)
			Call orderUpdate( db, tidx, gbidx2,  o_pubcode, o_roundno, ordertype) 'pubcode 0 으로 보내면 검색해서 각각 적용 A, A_1
		End if
	
	End if
	'#########################################################################################



  
  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
