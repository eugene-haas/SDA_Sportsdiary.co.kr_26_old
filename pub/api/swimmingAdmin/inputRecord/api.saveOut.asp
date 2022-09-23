<%
'#############################################
'사유 실격등
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

	If hasown(oJSONoutput, "INVAL") = "ok" Then  'a b c 또는 공백
		inval = oJSONoutput.INVAL
	Else
		inval = "000000" ' 여섯자리 숫자로 저장
	End if	
	
	Set db = new clsDBHelper 
	SQL = " select gametitleidx,gbidx,  gubunam,gubunpm,gameno,gameno2,cda     from tblRGameLevel where RgameLevelidx = " & lidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		tidx = rs(0)
		gbidx = rs(1)
		gubunam = rs(2)
		gubunpm = rs(3)
		gameno = rs(4)
		gameno2 = rs(5)
		CDA = rs(6)
	End if

	SQL = " select starttype,tryoutgroupno,roundno from SD_gameMember where gameMemberIDX = " & midx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		starttype = rs(0)
		tryoutgroupno = rs(1)
		roundno = rs(2)
	End if


	'신기록검색 
	
	'첮주자기록 조회


	'개인결과 저장
	Select Case  CStr(gno)
	Case CStr(gameno)  ' 오전경기
		
		If gubunam = "1" then'예선
			SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"',tryouttotalorder =null,tryoutorder = null  where gamememberidx = " & midx
			Call db.execSQLRs(SQL , null, ConStr)
			updatetype = "A" 
		Else'결승
			Select Case CStr(starttype)
			Case "3"  '시작이 결승으로 한거라면
				SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"',tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx
				updatetype = "A" 
			Case "1"  '결승경기라면
				SQL = "update SD_gameMember Set  gameresult = '"&inval&"',gameOrder=null  where gamememberidx = " & midx
				updatetype = "B" 
			End Select 
			Call db.execSQLRs(SQL , null, ConStr)
		End If
		
	Case CStr(gameno2) '오후경기

		If gubunpm = "1" then'예선
			SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"',tryouttotalorder =null,tryoutorder = null  where gamememberidx = " & midx
			updatetype = "A" 
			Call db.execSQLRs(SQL , null, ConStr)

		Else'결승

			Select Case Cstr(starttype)
			Case "3"  '시작이 결승으로 한거라면
				SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"',tryouttotalorder =null,tryoutorder = null   where gamememberidx = " & midx
				updatetype = "A" 
			Case "1"  '결승경기라면
				SQL = "update SD_gameMember Set gameresult =  '"&inval&"',gameOrder=null  where gamememberidx = " & midx
				updatetype = "B" 
			End Select 
			Call db.execSQLRs(SQL , null, ConStr)

		End if
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
		'경영인경우
		If CDA = "D2" then
			wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"' and "&gnofld&" = "&groupno&" and "&resultfld&" > 0 and "&resultfld&" < 'a'  " '업데이트 대상

			Selecttbl = "( SELECT "&orderfld&",RANK() OVER (Order By "&resultfld&" asc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A."&orderfld&" = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
		Else
			wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"' and "&gnofld&" = "&groupno&" and "&resultfld&" > 0 and "&resultfld&" < 'a'  " '업데이트 대상

			Selecttbl = "( SELECT tryouttotalorder, "&orderfld&",RANK() OVER (Order By "&resultfld&" desc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.tryouttotalorder = A.RowNum,  A."&orderfld&" = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)
		End if

		'다이빙/아티스틱인경우



	'Call oJSONoutput.Set("CDA", SQL )
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
