<%
'#############################################
' 라운드별 심판별 입력값 저장
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	roundno = oJSONoutput.Get("RNO") '라운드
	judgeno = oJSONoutput.Get("JNO") '심판위치번호
	cdc =  oJSONoutput.Get("CDC") 

	setval = oJSONoutput.Get("SETVAL")
	If isnumeric(setval) = False Then
		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson		
		Response.end
	End if

	
	setval = CDbl(Replace(setval,".",""))
	If setval = "" then
		setval = 0
	End If
	If Len(setval) = 1 Then
		setval = setval & "0"
	End if
	
	CDA = "F2" '아티스틱

	Set db = new clsDBHelper


		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)
		cdc = booinfo(4)

		'저장 테크니컬 
		onesimsa = judgeCnt / 3 * 2 '한번만 심사하는 싶나

		


		Select Case CDC 
		Case "04","06","12"
			Select Case CStr(roundno)
			Case "1" 
			If judgeno  <= onesimsa then
				SQL = "Update sd_gameMember_roundRecord set jumsu"&judgeno&" = "&setval&" where  midx  = "&midx&"  and gameround in (1,2,3,4,5)  "				
				Call db.execSQLRs(SQL , null, ConStr)
			else
				SQL = "Update sd_gameMember_roundRecord set jumsu"&judgeno&" = "&setval&" where  midx  = "&midx&"  and gameround = "&roundno&"  "
				Call db.execSQLRs(SQL , null, ConStr)
			End If
			Case Else
				SQL = "Update sd_gameMember_roundRecord set jumsu"&judgeno&" = "&setval&" where  midx  = "&midx&"  and gameround = "&roundno&"  "
				Call db.execSQLRs(SQL , null, ConStr)			
			End Select 

		Case else
			SQL = "Update sd_gameMember_roundRecord set jumsu"&judgeno&" = "&setval&" where  midx  = "&midx&"  and gameround = "&roundno&"  "
			Call db.execSQLRs(SQL , null, ConStr)
		End select

'	Call oJSONoutput.Set("Dcdc", cdc )
'	Call oJSONoutput.Set("라운드번호", roundno )
'	Call oJSONoutput.Set("judgeno", judgeno )
'	Call oJSONoutput.Set("onesimsa", onesimsa ) '한번만 심사하는 싶나
'	Call oJSONoutput.Set("sql", sql )

		'결과체크및 결과반영 순위생성 totalscore 다시계산해서 넣는다.
		Call setGameResut(lidx, midx, roundno, db, ConStr)

  refreeno = judgeno '종료되었다면 Y 심판번호위치
	Call setBooEnd(grouplevelidx,lidxs,lidx,midx,judgeCnt,refreeno,roundno, db, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
