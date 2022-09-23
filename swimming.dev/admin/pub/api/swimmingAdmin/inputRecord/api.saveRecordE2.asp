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
		inval = Replace(oJSONoutput.INVAL,".","")
	Else
		inval = "00000" ' 다섯자리 숫자로 저장 min값이 될수 있다 (바꾸자)
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
			If cda = "F2" And inval = "00000" Then
				inval = "000000"
			End if
			cdanm = rs(7)
			cdb = rs(8)
			cdbnm = rs(9)
			cdc = rs(10)
			cdcnm = rs(11)

			levelno = rs(12)
			sex = rs(13)
			itgubun = rs(14) '개인, 단체 I , T
			gbidx = rs(15)
			titlecode = rs(16)
		End If

		SQL = " select starttype,tryoutgroupno,roundno from SD_gameMember where gameMemberIDX = " & midx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			starttype = rs(0)
			tryoutgroupno = rs(1)
			roundno = rs(2)
		End if

	'####################################################################################

	'결과테이블에 넣을시기도 결정해야한다. 승인여부 플레그를 만들자.
	'순위가 있으므로 조심해서 최종 실적전송에서 넣는게 맞을꺼 같다.   2안:	'순위 0 으로 넣는게 좋을꺼같다 나중에순위만 업데이트? 아니면 

	'결과 저장

		'제입력이 있으므로 항목모두는 업데이트 되어야한다.
		sinWheres = " ,G1korSinPre = '"&KorSinPre&"',G1korSin = '"&newKorSin&"' ,G1gameSinPre = '"&GameSinPre&"' ,G1gameSin = '"&newGameSin&"' ,G1firstmemberSin = '"&newFirstSin&"' " 
		SQL = "update SD_gameMember Set tryoutresult  = '"&inval&"' "&sinWheres&"  where gamememberidx = " & midx
		updatetype = "A" 
		Call db.execSQLRs(SQL , null, ConStr)


	'(경기번호) 부별 순위 산정
		resultfld = "tryoutresult"
		gnofld = "tryoutgroupno"
		groupno = tryoutgroupno
		orderfld = "tryoutOrder"


		wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"'  and "&resultfld&" > 0  and tryoutresult < 'a'  " '업데이트 대상
		Selecttbl = "( SELECT tryouttotalorder, RANK() OVER (Order By tryoutresult desc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
		SQL = "UPDATE A  SET A.tryouttotalorder = A.RowNum FROM " & selecttbl
		Call db.execSQLRs(SQL , null, ConStr)


	'조순위 산정
'		wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"' and "&gnofld&" = "&groupno&" and "&resultfld&" > 0 and "&resultfld&" < 'a'  " '업데이트 대상
'
'		Selecttbl = "( SELECT "&orderfld&",RANK() OVER (Order By "&resultfld&" asc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
'		SQL = "UPDATE A  SET A."&orderfld&" = A.RowNum FROM " & selecttbl
'		Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>