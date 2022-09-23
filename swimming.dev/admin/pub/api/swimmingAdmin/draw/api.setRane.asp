<%
'#############################################
'
'#############################################
	
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then '대상
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" Then '대상
		gbidx = oJSONoutput.GBIDX
	End if	

	If hasown(oJSONoutput, "STARTTYPE") = "ok" Then '시작방법 예선 시작, 결승 시작 1,3
		starttype = oJSONoutput.Get("STARTTYPE")
	End if	


	Set db = new clsDBHelper 

	'다시누르면 리셋되어야할꺼 같다.
	SQL = "update sd_gameMember set tryoutgroupno=0,tryoutsortNo = 0 where gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' and delyn = 'N' "
	Call db.execSQLRs(SQL , null, ConStr)



	'조수 , 총명수 
	  '레인수 가져오기
	  SQL = "select ranecnt from sd_gametitle where gametitleidx = " & tidx
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	  raneCnt = rs(0) '레인수

	  fld = " gameMemberIDX,bestOrder,tryoutgroupno,tryoutsortNo,CDC,CDA "   'tryoutgroupno,tryoutsortNo,
	  SQL = "select "&fld&" from SD_gameMember where delYN = 'N' and gubun = 1 and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  order by bestOrder asc"

	  
	  
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	  If Not rs.EOF Then
			arrR = rs.GetRows()
			attcnt = CDbl(UBound(arrR, 2)) + 1 '참가명수
			joocnt = Ceil_a(attcnt / raneCnt) '조수
			cdc = arrR(4,0)
			f_cda = arrR(5,0)
			SQL = " select top 1 gametimess from tblTeamGbInfo where cd_type= 1 and PTeamGb='D2'  and teamgb= '"&cdc&"' " '설정된 게임시간 가져오기
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If rs.eof Then
				gametimess = 0
			else
				gametimess = rs(0)
			End if
	  End If




	'경영이 아니라면#################
	If f_cda <> "D2" Then

		Selecttbl = "( SELECT gubun,tryoutgroupno,startType,tryoutsortNo,RANK() OVER (Order By gameMemberidx asc) AS RowNum FROM SD_gameMember where delYN = 'N' and gubun = 1 and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' ) AS A "
		SQL = "UPDATE A  SET A.gubun='1',A.tryoutgroupno = '1', A.startType='3',A.tryoutsortNo = A.RowNum FROM " & Selecttbl '참고 * 아티스틱 스위밍/ 다이빙은 결승 경기만 진행 함 * 단 한 번의 경기로 끝남. 이라고 써있음
		Call db.execSQLRs(SQL , null, ConStr)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	End if
	'경영이 아니라면#################


	'Call getRowsDrow(arrR)
	'Response.end


	'조수만큼 배열(레인수) 만들기
	'조마다 동일하게 들어갈 갯수 구하기
	'버림(참가자명수 / 조수) = 동일명수
	'참가자명수 mod 조수 = 나머지분배명수(조수)
	

	'새로 배열할 공간 만들기
	ReDim JOO(joocnt)

	'만든 공간에 순서에 따라 값 넣기
	sameno = Fix(attcnt / joocnt)  '균등배분 숫자.
	namergi = attcnt Mod joocnt '나머지숫자의 조까지만 더하기...



	If starttype = "1" Then
		'조마다 역순으로 한명씩 배분 하고 나머지 위에서 부터 배분..
		If IsArray(arrR) Then 
			For ari = LBound(arrR, 2) To UBound(arrR, 2) - namergi '나누어 떨어지는 명수 가지만 우선 넣자.
				'midx =  arrR(0,ari)  'midx
				'odrno = arrR(1,ari) '순서번호
				'joono = arrR(2,ari) '조번호(넣을곳)
				'raneno = arrR(3,ari) '레인번호(넣을곳)

				For j = ubound(JOO) To 1 Step -1
					arrR(2, ari) = j
					ari = ari + 1
				Next
				ari = ari - 1
			Next
		End If
		
		'Call getRowsDrow(arrR)
		'Response.end


		'나머지 안채워진값에 순서값 1,2,3 ...조
		If IsArray(arrR) Then 
			i = namergi

			For ari = LBound(arrR, 2) To UBound(arrR, 2) 
					If arrR(2, ari) = 0 then
						arrR(2, ari) = i
						i = i - 1
					End if
			Next
		End If

	Else

		'경승시작 끝조부터 기록순으로 명수만큼 잘라서 넣기 (조먼저 생성하고나서)
		'21.3.23 조건이 없었는데 생김  결승일때 순서

		'1.조수를 알수 있다.
		'2.균등배분된 명수를 확인해야한다.
		'3.나머지를 통해서 더들어가는 조를 알수 있다.

		endjoo = joocnt '뒷조부터
		jooplusmember = 1

		If IsArray(arrR) Then 
			For ari = LBound(arrR, 2) To UBound(arrR, 2)

				If jooplusmember <= CDbl(joocnt - namergi)  Then
					plusno = 0
				Else
					plusno = 1
				End If
				jooplusmember = jooplusmember + 1

				For x = 1 To Cdbl(sameno + plusno) '균등분배 선수들
					arrR(2, ari) = endjoo
					ari = ari + 1
				Next


				endjoo = endjoo - 1
				ari = ari - 1
			Next
		End If


	End if
	
	
	'Call getRowsDrow(arrR)
	'Response.end
	


	'조별로 소팅
	'jArr = arraySort (arrR, 2, "Number", "desc" ) 
	
	
	'조번호 업데이트 
	SQL = ""
	If IsArray(arrR) Then 
	For ari = LBound(arrR, 2) To UBound(arrR, 2) 
			midx =  arrR(0,ari)  'midx
			joono = arrR(2,ari) '조번호(넣을곳)
			
			'CDC 값을 모두 정의할까? 쿼리로 가져오자
			'8명이하 결승경기로 생성 ---------------------중요
			'모든종목 400m 이상은 결승만 있음..---------------------중요
			
			'If CDbl(attcnt) <= CDbl(raneCnt) Or CDbl(gametimeSS) >= 320 Then
			'수동으로 전환됨 (21.3.23)
			If starttype = "3" Then
			SQL = SQL & " update sd_gameMember set tryoutgroupno = '"&joono&"',startType='3'  where gamememberidx = '"&midx&"' "	'결승으로 생성 starttype = 3 이면 tryout 이 결승인거다.
			else
			SQL = SQL & " update sd_gameMember set tryoutgroupno = '"&joono&"',startType='1'  where gamememberidx = '"&midx&"' "
			End if
	Next
	End if
	Call db.execSQLRs(SQL , null, ConStr)






	If CDbl(attcnt) <= CDbl(raneCnt) Or CDbl(gametimeSS) >= 320 Then
		SQL = "select "&fld&" from SD_gameMember where delYN = 'N' and gubun=1 and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  order by tryoutgroupno, bestOrder asc"
	else
		SQL = "select "&fld&" from SD_gameMember where delYN = 'N' and gubun=1 and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  order by tryoutgroupno, bestOrder asc"
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	'Call getRowsDrow(arrR) '############################################################

	SQL = ""
	'레인번호 순서대로 넣기

		'레인수 8 또는 10이 있다 10은 정의되어 있지 않다.
		If CDbl(raneCnt) = 8 then
			ranearr = Array(4,5,3,6,2,7,1,8)
		Else
			ranearr = Array(4,5,3,6,2,7,1,8,9,10)
		End if

		i = 0
		For jno = 1 To joocnt '조번호 루프(일딴 조번호는 들어가 있으니)
			If IsArray(arrR) Then
				For ari = LBound(arrR, 2) To UBound(arrR, 2) 
					midx =  arrR(0,ari)  'midx
					gno = arrR(2,ari)
	
					If jno >0 And pregno <> gno Then
						i = 0
					End if
					
					SQL = SQL & " update sd_gameMember set tryoutsortNo = '"&ranearr(i)&"'  where gamememberidx = '"&midx&"' "		'starttype = 3 이면 이걸로 결승부터 시작하는지 판단
					i = i + 1

				pregno = gno
				Next 
			End if
		Next 



	Call db.execSQLRs(SQL , null, ConStr)

	'Call getRowsDrow(arrR)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>