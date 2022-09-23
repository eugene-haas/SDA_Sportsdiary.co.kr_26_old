<%
	gameLevelIDX= oJSONoutput.IDX
	gameTitleIDX= oJSONoutput.TitleIDX
	attachCnt = oJSONoutput.T_ATTCNT
	nowRound = oJSONoutput.T_NOWRD
	trRoundID= oJSONoutput.T_RDID
	gamekey3 = oJSONoutput.S3KEY
	areanm = oJSONoutput.AreaNM

	Call oJSONoutput.Set("RESET", "notok" )
	Call oJSONoutput.Set("ONEMORE", "notok" )

	Set db = new clsDBHelper

	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "


	If hasown(oJSONoutput, "roundSel") = "ok" then
		roundsel = oJSONoutput.roundSel 'select 라운드
		if roundsel ="" then 
			oJSONoutput.roundSel = 0
			roundsel=0
		end if 
	Else
		Call oJSONoutput.Set("roundSel", 0 )
		roundsel=0
	End if





lastroundcheck = Right(gamekey3,3)

tn_last_rd = false
'If lastroundcheck = "007" Then
If lastroundcheck = "007" And  areanm = "최종라운드"  Then
	tn_last_rd = true
End if

If tn_last_rd = False Then
	'예선총명수로 참가자 명수 확정
	strWhere = " GameTitleIDX = "&gameTitleIDX&" and gamekey3 = "& gamekey3 & " and gubun in (0, 1)  and DelYN = 'N' "
	SQL = "select  max(tryoutgroupno) as maxgno,COUNT(*) as gcnt  from "&strtable&" where "&strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		attmembercnt = rs("gcnt")					'총참가자
		maxgno = rs("maxgno")						'설정된 마지막조
		tcnt  = CDbl(maxgno) * 2			'토너먼트 참가 인원
	End if

else
	strWhere = " GameTitleIDX = "&gameTitleIDX&" and gamekey3 = "& gamekey3 & " and gubun in (2, 3)  and DelYN = 'N' and round = 1"
	SQL = "select  COUNT(*)  from "&strtable&" where "&strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		tcnt  = rs(0)
	End if
End If

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

	If tn_last_rd = False Then
	'###################################
    jooidx = CStr(gameTitleIDX) & CStr(gamekey3) '생성된 추첨룰이 있다면
    SQL = "Select top 1 orderno,sortno,joono,mxjoono,idx     ,gang,round from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
	If Not rs.eof Then
        drowCnt=rs("gang")
        depthCnt = rs("round")
	End if
	'###################################	
	End if

      If CDbl(gamekey3) = 20104001 And CDbl(gameTitleIDX) = 32 Then
        drowCnt=128
        depthCnt = 8
      End If


	'동운배 신인부 예외처리
		If CDbl(gamekey3) = 20104006 And CDbl(gameTitleIDX) = 4 Then
		drowCnt=128
		depthCnt = 8
		maxgno =  1080
		End If

		If CDbl(gamekey3) = 20104002 And CDbl(gameTitleIDX) = 4 Then
		drowCnt=64
		depthCnt = 7
		maxgno = 1048
		End If
	'동운배 신인부 예외처리



	'상위 라운드진출되었다면 재편성 막음 (결과값이 생겼으므로)
		'		If CDbl(depthCnt) = CDbl(nowRound) Then
		'			nextrd = nowRound
		'		else
		'			nextrd = CDbl(nowRound) + 1
		'		End if
		'
		'		SQL = "SELECT COUNT(*)  FROM sd_TennisMember where GameTitleIDX = '" & gameTitleIDX & "' and gamekey3 = " & gamekey3 & " and round = '" & nextrd & "' and DelYN = 'N' and gubun in (2,3)"
		'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'		
		'		If CDbl(rs(0)) > 0 and CDbl(nowRound) > 1 Then
		'			Call oJSONoutput.Set("result", 1002 )
		'			strjson = JSON.stringify(oJSONoutput)
		'			Response.Write strjson
		'
		'			db.Dispose
		'			Set db = Nothing
		'			Response.end		
		'		End if
	'상위 라운드진출되었다면 재편성 막음 (결과값이 생겼으므로)


	'현재 편성정보
	SQL = "SELECT max(gubun)  FROM sd_TennisMember where GameTitleIDX = " & gameTitleIDX & " and gamekey3 = " & gamekey3 & " and round = " & nowRound & " and DelYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	tourngubun = rs(0)
	If isNull(tourngubun) Then
		tourngubun = 2
	End If


'Response.write tourngubun


	'###
	Select Case CDbl(tourngubun)
	Case 2 '편성완료 > 부전승자 생성 

		strWhere = " GameTitleIDX = "&gameTitleIDX&" and gamekey3 = "& gamekey3 & " and gubun in (2,3)  and Round = "&nowRound
		SQL = "SELECT sortno FROM sd_TennisMember  WHERE delYN = 'N' and " & strWhere & " order by sortNO asc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrSt = rs.getrows()
		End If	

		nextDowcnt = drowCnt
		For i = 2 To nowRound 
			nextDowcnt =  Fix(nextDowcnt/ 2)
		next
		'2 -> 3 업데이트 
		SQL = "Update sd_TennisMember Set gubun = 3, areaChanging = 'N' where  GameTitleIDX = '" & gameTitleIDX & "' and  gamekey3 = " & gamekey3 & " and round = " & nowRound
		Call db.execSQLRs(SQL , null, ConStr)	

		'추첨룰 가져오기 (최종라운드는 추첨룰이없다)
		If tn_last_rd = False then
			
			jooidx = CStr(gameTitleIDX) & CStr(gamekey3) '생성된 추첨룰이 있다면
			SQL = "Select orderno,sortno,joono,mxjoono,idx     ,gang,round from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
			Set rsrndno = db.ExecSQLReturnRS(SQL , null, ConStr)			

			'If rsrndno.eof then
			'SQL = "select orderno,sortno,joono,mxjoono,idx    ,gang,round   from sd_TennisKATARull where mxjoono = " & maxgno '마지막조번호
			'Set rsrndno = db.ExecSQLReturnRS(SQL , null, ConStr)
			'End if

			If Not rsrndno.EOF Then 
				arrRND = rsrndno.GetRows()
			End If

			'1. 1 Round 빈자리의 Sort 번호 중 하나 들어옵니다. 
			'추첨룰 가져오기
			If nowRound = "1" Then '1라운드만 부전승 생성
			If IsArray(arrRND) Then
				For i = LBound(arrRND, 2) To UBound(arrRND, 2) 
					r_orderno = arrRND(0, i) 
					r_sortno = arrRND(1, i) 
					r_joono  = arrRND(2, i) 


					IF CDbl(r_orderno) = 0 Then
						'부전승
						insertfield = " gubun,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round,SortNo"
						selectfield = "3 ,GameTitleIDX,'부전',gamekey1,gamekey2,gamekey3,TeamGb,key3name,1," & r_sortno 
						selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gubun in (0,1) and GameTitleIDX = "&gameTitleIDX&" and gamekey3= " & gamekey3
						SQL = "insert into "&strtable&" ("&insertfield&")  "&selectSQL&" "
						Call db.execSQLRs(SQL , null, ConStr)	
					ENd IF
				next
			End If
			End if
		Else
		
		End if
		'추첨룰 가져오기	


		'빈소팅 번호 찾기
		reDim temsortnoarr(nextDowcnt)
		tempi= 0
		For i = 1 To nextDowcnt
			tempsortno = tempno(arrST, i) '공통함수에 req 페이지에 존재
			If tempsortno > 0 then
				temsortnoarr(tempi) = tempsortno
				tempi = tempi + 1
			End if
		next	
		'빈소팅 번호 찾기

		If temsortnoarr(0) <> "" Then '빈곳이 없는경우
		For n = 0 To ubound(temsortnoarr)
			If temsortnoarr(n) = "" Or isNull(temsortnoarr(n)) = True Then
				Exit For
			Else
					'selectfield = TOURNSTART &  ",1,GameTitleIDX,'--',gamekey1,gamekey2,gamekey3,TeamGb,key3name," & nowRound & ", " & temsortnoarr(n)
					'selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where Round= 1 and gubun in (2,3) and GameTitleIDX = "&gameTitleIDX&" and gamekey3= " & gamekey3
					'SQL = "SET NOCOUNT ON  insert into "&strtable&" ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
					'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					
					insertfield = " gubun,playerIDX,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round,sortno "
					selectfield = TOURNSTART &  ",1,"&gameTitleIDX&",'--','tn001001',"&Left(gamekey3,3)&","&gamekey3&","&Left(gamekey3,5)&",''," & nowRound & ", " & temsortnoarr(n)
					SQL = "insert into "&strtable&" ("&insertfield&")  values ("&selectfield&")"
					Call db.execSQLRs(SQL , null, ConStr)	

			End if
		Next
		End if

		'부전 -- 두개의 중복 소팅번호가 있다면 --를 지워라
		'If user_ip = "118.33.86.240" then
			
			SQL = "select a.gameMemberIDX from sd_TennisMember  a  inner join ( "
			SQL = SQL & " Select round,SortNo ,COUNT(*) a,GameTitleIDX ,gamekey3 from sd_TennisMember " 
			SQL = SQL & " where Round= "&nowRound&" and GameTitleIDX = "&gameTitleIDX&" and gamekey3= "&gamekey3&"  and PlayerIDX in (0,1) group  by round,SortNo,GameTitleIDX ,gamekey3 having COUNT(*)>=2  "
			SQL = SQL & ") b  on a.GameTitleIDX = b.GameTitleIDX  and a.gamekey3 = b.gamekey3  and a.Round = b.Round  and a.SortNo = b.SortNo  and a.PlayerIDX= 1 "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			
			If Not rs.eof then
				xx = 1
				Do Until rs.eof
					If xx = 1 then
					delwhere = rs(0)
					Else
					delwhere = delwhere & "," & rs(0)
					End if
				xx = xx + 1
				rs.movenext
				loop
				

				SQL = "Delete From sd_TennisMember Where gameMemberIDX In ("&delwhere&") and playerIDX = 1 and  Round= "&nowRound&" and GameTitleIDX = "&gameTitleIDX&" and gamekey3= "&gamekey3
				Call db.execSQLRs(SQL , null, ConStr)	
			End If
			
		'End if
		'부전 -- 두개의 중복 소팅번호가 있다면 --를 지워라
		oJSONoutput.ONEMORE = "ok"


	Case 3 '재편성 > 부전승자 삭제
		'3 -> 2 업데이트 
		SQL = "Update sd_TennisMember Set gubun = 2, areaChanging = 'N' where  GameTitleIDX = '" & gameTitleIDX & "' and  gamekey3 = " & gamekey3 & " and round = " & nowRound
		Call db.execSQLRs(SQL , null, ConStr)	

		'부전승 삭제
		strWhere = " a.GameTitleIDX = " & gameTitleIDX & " and  a.gamekey3 = " & gamekey3 & " and a.round in (0, " & nowRound & ") and a.playerIDX in (0,1)  "
		SQL = "DELETE From sd_TennisMember From sd_TennisMember As a Left Join sd_TennisMember_partner As b On a.gameMemberIDX = b.gameMemberIDX Where " & strWhere
		Call db.execSQLRs(SQL , null, ConStr)		
	End Select 


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%>
