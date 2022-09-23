<%
'#############################################
'
'#############################################
	
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 
		idx = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "RIDX") = "ok" Then 
		ridx = oJSONoutput.RIDX
	End if	


	Set db = new clsDBHelper 

	'sd_gamemember_parter 에 있는지 검사

	'아니면 정보 가져오기

	SQL = "select gameMemberIDX from sd_gameMember where delyn = 'N' and requestIDX = " & ridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
	midx - rs(0)


	SQL = "Insert into sd_gameMember_partner (gameMemberIDx,playeridx,username,orderno,sex,team,teamnm,userclass,sido,requestIDX ) "
	
	SQL = SQL & " (SELECT "&midx&",playeridx,username,orderno,sex,team,teamnm   FROM tblGameRequest_r  WHERE delyn = 'N' and seq = " & idx & ")" 

	SQL = "select p1_team,p1_teamnm from tblGameRequest where delyn = 'N' and requestIDX = " & ridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	teamcode = rs(0)
	teamnm = rs(1)



	fld = " seq,requestIDX,playeridx,username,payOK,paynum,team,teamnm,userClass "
	strSql = "SELECT " & fld & "   FROM tblGameRequest_r  WHERE delyn = 'N' and seq = " & idx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	
	
	If Not rs.EOF Then
		ar = rs.GetRows()
	End If


	If IsArray(ar) Then 

			
		For a = LBound(ar, 2) To UBound(ar, 2)
			If a = 0 then
				attpidxStr = ar(2, a)
			Else
				attpidxStr = attpidxStr &","& ar(2, a)
			End if
		Next

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
			'SQL = "update SD_gameMember Set tryoutOrder = '1' , tryouttotalorder = '1' , tryoutresult  = '11'  where gamememberidx = " & midx
			SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"'  where gamememberidx = " & midx
			Call db.execSQLRs(SQL , null, ConStr)
			updatetype = "A" 
		Else'결승
			Select Case CStr(starttype)
			Case "3"  '시작이 결승으로 한거라면
				'SQL = "update SD_gameMember Set tryoutOrder = '1' , tryouttotalorder = '1' , tryoutresult  = '"&inval&"'   where gamememberidx = " & midx
				SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"'   where gamememberidx = " & midx
				updatetype = "A" 
			Case "1"  '결승경기라면
				'SQL = "update SD_gameMember Set gameOrder = '2' , gameresult = '"&inval&"'  where gamememberidx = " & midx
				SQL = "update SD_gameMember Set  gameresult = '"&inval&"'  where gamememberidx = " & midx
				updatetype = "B" 
			End Select 
			Call db.execSQLRs(SQL , null, ConStr)
		End If
		
	Case CStr(gameno2) '오후경기

		If gubunpm = "1" then'예선
			SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"'  where gamememberidx = " & midx
			updatetype = "A" 
			Call db.execSQLRs(SQL , null, ConStr)

		Else'결승

			Select Case Cstr(starttype)
			Case "3"  '시작이 결승으로 한거라면
				SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"'   where gamememberidx = " & midx
				updatetype = "A" 
			Case "1"  '결승경기라면
				SQL = "update SD_gameMember Set gameresult =  '"&inval&"'  where gamememberidx = " & midx
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