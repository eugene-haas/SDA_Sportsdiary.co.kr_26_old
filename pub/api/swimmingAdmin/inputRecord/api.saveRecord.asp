<%
'#############################################
'대회기록저장
'#############################################
	
	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx = oJSONoutput.MIDX
	End If
	If hasown(oJSONoutput, "LIDX") = "ok" Then 
		lidx = oJSONoutput.LIDX
	End if	
	If hasown(oJSONoutput, "GNO") = "ok" Then 
		gno = oJSONoutput.GNO
	End if	

	If hasown(oJSONoutput, "INVAL") = "ok" Then 
		inval = oJSONoutput.INVAL
		
		If CDbl(Len(inval)) <> 6 Then
			Call oJSONoutput.Set("result", 0 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	Else
		inval = "000000" ' 여섯자리 숫자로 저장 min값이 될수 있다 (바꾸자)
	End if	

	'계영첫주자기록
	If hasown(oJSONoutput, "FIRSTINVAL") = "ok" Then 
		firstinval = oJSONoutput.FIRSTINVAL
		If firstinval = "" Then
			firstinval = "000000" ' 여섯자리 숫자로 저장 min값이 될수 있다 (바꾸자)
		End if
	Else
			firstinval = "000000" ' 여섯자리 숫자로 저장 min값이 될수 있다 (바꾸자)
	End if	

	
	Set db = new clsDBHelper 


	'대회의 정보(기본정보)
		fld = " b.gametitleidx,b.gbidx,b.gubunam,b.gubunpm,b.gameno,b.gameno2,b.cda,b.cdanm,b.cdb,b.cdbnm,b.cdc,b.cdcnm     ,b.levelno,b.sexno,b.ITgubun,b.gbidx,   a.titlecode "
		SQL = "Select "&fld&"   from sd_gametitle as a inner join tblRGameLevel as b on a.gametitleidx = b.gametitleidx  where b.RgameLevelidx = " & lidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			tidx = rs(0)
			gbidx = rs(1)
			gubunam = rs(2) '예선 결승
			gubunpm = rs(3)
			gameno = rs(4) '오전게임진행번호
			gameno2 = rs(5) '오후게임진행번호
			cda = rs(6)
			cdanm = rs(7)
			cdb = rs(8)
			cdbnm = rs(9)
			cdc = rs(10)
			cdcnm = rs(11)

			levelno = rs(12)
			sex = rs(13)
			Select Case sex
			Case "1" : sexstr = "남자"
			Case "2" : sexstr = "여자"
			Case "3" : sexstr = "혼성"
			End Select
			itgubun = rs(14) '개인, 단체 I , T
			gbidx = rs(15)
			titlecode = Trim(rs(16))  'NR 0001 NR로 시작하면 대회기록을 체크하지 않는다.
			codepre = LCase(Left(titlecode,2))
		End If
	
	'대회구분 구하기
		If InStr(cdbnm,"유년")  Then
			gamegubun = "대회유년"
		End If
		If InStr(cdbnm,"초등")  Then			
			gamegubun = "대회초등"
		End If
		If InStr(cdbnm,"중등") Or InStr(cdbnm,"중학")  Then
			gamegubun = "대회중등"
		End If
		If InStr(cdbnm,"고등")  Then			
			gamegubun = "대회고등"
		End If
		If InStr(cdbnm,"대학")  Then			
			gamegubun = "대회대학"
		End If
		If InStr(cdbnm,"일반")  Then			
			gamegubun = "대회일반"
		End if
		'한국기록
		'일반-참가기록

	sexno = 1
	SQL = " select starttype,tryoutgroupno,roundno,sex from SD_gameMember where gameMemberIDX = " & midx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		starttype = rs(0)
		tryoutgroupno = rs(1)
		roundno = rs(2)
		sexno = rs(3)
	End if



	'외국인번호
	If sexno = "5" Or sexno = "7" Then
		sexno = 1
	End If
	If sexno = "6" Or sexno = "8" Then
		sexno = 2
	End If

	'신기록검색 ####################################################################################

		'한국신기록
		'SQL = "Select min(gameResult) from tblrecord where delyn = 'N' and titleCode = '201904395' and CDA = 'D2' and CDC = '"&CDC&"' and gameResult > 0 and sex = '"&sexno&"'  and gameResult < 'a' "
		SQL = "Select min(gameResult) from tblrecord where delyn = 'N' and rctype = 'R07' and CDA = 'D2' and CDC = '"&CDC&"' and gameResult > 0 and sex = '"&sexno&"'  and gameResult < 'a' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

		newKorSin = ""
		prekorsin = ""
		newKorTie = ""


		If isNull(rs(0)) = true Then
			newKorSin = inval
			prekorsin = rs(0)
			newKorTie = ""
		Else
			If CDbl(inval) > 0 And CDbl(rs(0)) > CDbl(inval) Then '상태 실격인지 확인해야한다
				newKorSin = inval
				prekorsin = rs(0)
				newKorTie = ""
			ElseIf CDbl(inval) > 0 And CDbl(rs(0)) = CDbl(inval) Then
				'타이기록
				newKorSin = ""
				prekorsin = ""
				newKorTie = inval
			Else
				newKorSin = ""
				prekorsin = ""
				newKorTie = ""
			End if
		End If


		newGameSin = ""
		pregamesin = ""
		newGameTie = ""

		If codepre = "nr" Then
			'패스
		else
			'대회신기록
			strWhere = " titlecode = '"&titlecode&"' and  levelno = '"&levelno&"'  and delyn = 'N' and rctype in ('R01','R02','R03','R04','R05','R06')  and gameResult > 0 and gameResult < 'a' "
			SQL = "select min(gameresult) from tblrecord where "&strWhere
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
			'Call oJSONoutput.Set("sql", sql )

			If isNull(rs(0)) = true Then
				newGameSin = inval
				pregamesin = rs(0)
				newGameTie = ""
			Else
				If CDbl(inval) > 0 And CDbl(rs(0)) > CDbl(inval) Then
					newGameSin = inval
					pregamesin = rs(0)
					newGameTie = ""
				ElseIf CDbl(inval) > 0 And CDbl(rs(0)) = CDbl(inval) Then
					'타이기록
					newGameSin = ""
					pregamesin = ""
					newGameTie = inval
				Else
					newGameSin = ""
					pregamesin = ""
					newGameTie = ""
				End if
			End If
		End if
		

		'G1firstRC				'(예선/본선) as a 첫주자기록 (단체)
		'G2firstRC				'(본선) as b 첫주자기록 (단체)

		'G1korSin				'a 한국신기록
		'G1gameSin				'a 대회신기록
		'G1firstmemberSin		'a 첫주자신기록(단체)

		'G2KorSin				'b 한국신기록
		'G2gameSin				'b 대회신기록 
		'G2firstmemberSin		'b 첫주자신기록 (단체)


		'첫주자기록 조회 (단체 - 계영)
		If InStr(cdcnm,"계영") then
			strWhere = " titlecode = '"&titlecode&"' and  levelno = '"&levelno&"'  and delyn = 'N'   and firstRC > 0  "
			SQL = "select min(firstRC) from tblrecord where "&strWhere
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

			If isNull(rs(0)) = true Then
				newFirstSin = firstinval
			Else
				If isnumeric(firstinval) = True then
					If CDbl(firstinval) > 0 And CDbl(rs(0)) > CDbl(firstinval) Then
						newFirstSin = firstinval
					Else
						newFirstSin = ""
					End If
				Else
					firstinval = "000000"
					newFirstSin = ""				
				End if
			End If
		End if


	'신기록검색 ####################################################################################

	'결과테이블에 넣을시기도 결정해야한다. 승인여부 플레그를 만들자.
	'순위가 있으므로 조심해서 최종 실적전송에서 넣는게 맞을꺼 같다.   2안:	'순위 0 으로 넣는게 좋을꺼같다 나중에순위만 업데이트? 아니면 

	'개인결과 저장
	Select Case  CStr(gno)
	Case CStr(gameno)  ' 오전경기

		'제입력이 있으므로 항목모두는 업데이트 되어야한다.
		If InStr(cdcnm,"계영") then
			If firstinval <> "000000" then
			firstRC = " ,G1firstRC = '"&firstinval&"'  "
			End if
		End if
		sinWheres = " ,G1korSinPre = '"&prekorsin&"',G1korSin = '"&newKorSin&"' ,G1gameSinPre = '"&pregamesin&"' ,G1gameSin = '"&newGameSin&"' ,G1firstmemberSin = '"&newFirstSin&"' " & firstRC
		sinWheres = sinWheres & " ,G1korTie = '"&newKorTie&"',G1gameTie = '"&newGameTie&"'  "

		If gubunam = "1" then'예선
			'SQL = "update SD_gameMember Set tryoutOrder = '1' , tryouttotalorder = '1' , tryoutresult  = '11'  where gamememberidx = " & midx
			SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"' "&sinWheres&"  where gamememberidx = " & midx
			Call db.execSQLRs(SQL , null, ConStr)
			updatetype = "A" 
		Else'결승
			Select Case CStr(starttype)
			Case "3"  '시작이 결승으로 한거라면
				'SQL = "update SD_gameMember Set tryoutOrder = '1' , tryouttotalorder = '1' , tryoutresult  = '"&inval&"'   where gamememberidx = " & midx
				SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"' "&sinWheres&"  where gamememberidx = " & midx
				updatetype = "A" 
			Case "1"  '결승경기라면
				'SQL = "update SD_gameMember Set gameOrder = '2' , gameresult = '"&inval&"'  where gamememberidx = " & midx
				SQL = "update SD_gameMember Set  gameresult = '"&inval&"' "&sinWheres&" where gamememberidx = " & midx
				updatetype = "B" 
			End Select 
			Call db.execSQLRs(SQL , null, ConStr)
		End If
		
	Case CStr(gameno2) '오후경기

		If gubunpm = "1" then'예선 (변수명 보고 착각하지 말기 오전에 경기 (예선 본선 구분)
			If InStr(cdcnm,"계영") then
				firstRC = " ,G1firstRC = '"&firstinval&"'  "
			End if
			sinWheres =  " ,G1korSinPre = '"&prekorsin&"' ,G1korSin = '"&newKorSin&"' ,G1gameSinPre = '"&pregamesin&"' ,G1gameSin = '"&newGameSin&"' ,G1firstmemberSin = '"&newFirstSin&"' " & firstRC
			sinWheres = sinWheres & " ,G1korTie = '"&newKorTie&"',G1gameTie = '"&newGameTie&"'  "

			SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"' "&sinWheres&"  where gamememberidx = " & midx
			updatetype = "A" 
			Call db.execSQLRs(SQL , null, ConStr)

		Else'결승

			Select Case Cstr(starttype)
			Case "3"  '시작이 결승으로 한거라면
			If InStr(cdcnm,"계영") then
				firstRC = " ,G1firstRC = '"&firstinval&"'  "
			End if
			sinWheres =  " ,G1korSinPre = '"&prekorsin&"' ,G1korSin = '"&newKorSin&"' ,G1gameSinPre = '"&pregamesin&"' ,G1gameSin = '"&newGameSin&"' ,G1firstmemberSin = '"&newFirstSin&"' " & firstRC
			sinWheres = sinWheres & " ,G1korTie = '"&newKorTie&"',G1gameTie = '"&newGameTie&"'  "

				SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"' "&sinWheres&"  where gamememberidx = " & midx
				updatetype = "A" 
			Case "1"  '결승경기라면
				If InStr(cdcnm,"계영") then
					firstRC = " ,G2firstRC = '"&firstinval&"'  "
				End if
				sinWheres =  " ,G2korSinPre = '"&prekorsin&"' ,G2korSin = '"&newKorSin&"' ,G2gameSinPre = '"&pregamesin&"' ,G2gameSin = '"&newGameSin&"' ,G2firstmemberSin = '"&newFirstSin&"' " & firstRC
				sinWheres = sinWheres & " ,G2korTie = '"&newKorTie&"',G2gameTie = '"&newGameTie&"'  "

				SQL = "update SD_gameMember Set gameresult =  '"&inval&"' "&sinWheres&"  where gamememberidx = " & midx
				updatetype = "B" 
			End Select 
			Call db.execSQLRs(SQL , null, ConStr)
		End If
		
	End select 
	



	'(경기번호) 부별 순위 산정
		If updatetype = "A"  Then
			resultfld = "tryoutresult"
			gnofld = "tryoutgroupno"
			groupno = tryoutgroupno
			orderfld = "tryoutOrder"
		Else
			resultfld = "gameresult"
			gnofld = "roundno"
			groupno = roundno
			orderfld = "gameOrder"
		End if

		If updatetype = "A"  Then
			wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"'  and "&resultfld&" > 0  and tryoutresult < 'a'  " '업데이트 대상
			Selecttbl = "( SELECT tryouttotalorder, RANK() OVER (Order By tryoutresult asc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.tryouttotalorder = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
		End if

	'조순위 산정
		wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"' and "&gnofld&" = "&groupno&" and "&resultfld&" > 0 and "&resultfld&" < 'a'  " '업데이트 대상

		Selecttbl = "( SELECT "&orderfld&",RANK() OVER (Order By "&resultfld&" asc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A."&orderfld&" = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>