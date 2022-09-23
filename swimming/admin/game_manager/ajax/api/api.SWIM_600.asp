<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->
<!-- #include virtual = "/game_manager/ajax/setReq.asp" -->

<%
'#############################################
'라운드 입력후 (다음)
'#############################################

	req_lidx = isNulldefault(oJSONoutput.Get("LIDX"),"") '직접호출할경우만(대회번호)
	req_ridx = isNulldefault(oJSONoutput.Get("RIDX"),"") '라운드인덱스
	req_midx = isNulldefault(oJSONoutput.Get("MIDX"),"")
	
	req_roundno = oJSONoutput.Get("RNO") '라운드번호
	req_setval = CDbl(Replace(oJSONoutput.Get("SETVAL"),".","")) '입력값

	If Len(req_setval) = 1 Then
		req_setval = req_setval & "0"
	End if


	If req_ridx = "" Then

		Set oCookies = JSON.Parse( join(array(Cookies_adminDecode)) )
		tidx = oCookies.Get("C_TIDX")
		cda = oCookies.Get("C_CDA") '종목
		jno = oCookies.Get("C_POSITIONNUM") '심판위치

		If cda = "E2" then
		lidx = 11377
		midx = 95403
		ridx = 681
		Else
		lidx = 12563
		midx = 101644
		ridx = 3576
		End if

'		Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
'		Call oJSONoutput.Set("servermsg", "채점하실 부를 선택해 주십시오." ) '서버에서 메시지 생성 전달
'		strjson = JSON.stringify(oJSONoutput)
'		Response.Write strjson
'		Response.end
	else
		lidx = req_lidx
		midx = req_midx
		ridx = req_ridx

		Set oCookies = JSON.Parse( join(array(Cookies_adminDecode)) )
		tidx = oCookies.Get("C_TIDX")
		cda = oCookies.Get("C_CDA") '종목
		jno = oCookies.Get("C_POSITIONNUM") '심판위치

		'Call oJSONoutput.Set("Cookies", oCookies ) 'test 값 확인에 사용
	End if

	Select Case CDA
	Case "E2" 
			Call oJSONoutput.Set("CDAE2", CDA )
			Server.Execute ("/pub/fn/fn.swjudge.asp")
		%><!-- #include virtual = "/pub/fn/fn.swjudge.asp" --><%
		Case "F2" 
			Call oJSONoutput.Set("CDAF2", CDA )
		%><!-- #include virtual = "/pub/fn/fn.swjudge.F2.asp" --><%
		End Select 


	Set db = new clsDBHelper


	'다이빙
	Select Case CDA
	Case "E2"

		'저장
		SQL = "Update sd_gameMember_roundRecord set jumsu"&jno&" = "&req_setval&" where  idx =  " & ridx
		'Call db.execSQLRs(SQL , null, ConStr)

		'결과체크및 결과반영 순위생성 totalscore 다시계산해서 넣는다.
		'Call setGameResut(lidx, midx, roundno, db, ConStr)


	Case "F2"

		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)
		cdc = booinfo(4)

		'저장 테크니컬 
		onesimsa = judgeCnt / 3 * 2		
		
		'저장
		Select Case CDC 
		Case "04","06","12"
			Select Case CStr(roundno)
			Case "1" 
			If jno  <= onesimsa then
				SQL = "Update sd_gameMember_roundRecord set jumsu"&jno&" = "&req_setval&" where  midx  = "&midx&"  and gameround in (1,2,3,4,5)  "				
				Call db.execSQLRs(SQL , null, ConStr)
			else
				SQL = "Update sd_gameMember_roundRecord set jumsu"&jno&" = "&req_setval&" where  idx =  " & ridx
				Call db.execSQLRs(SQL , null, ConStr)
			End If
			Case Else
				SQL = "Update sd_gameMember_roundRecord set jumsu"&jno&" = "&req_setval&" where  idx =  " & ridx
				Call db.execSQLRs(SQL , null, ConStr)			
			End Select 

		Case else
			SQL = "Update sd_gameMember_roundRecord set jumsu"&jno&" = "&req_setval&" where  idx =  " & ridx
			Call db.execSQLRs(SQL , null, ConStr)
		End select

		'결과체크및 결과반영 순위생성 totalscore 다시계산해서 넣는다.
		Call setGameResut(lidx, midx, roundno, db, ConStr)

	End Select 


	'종료확인==========================================
	booinfo = getBooInfo(lidx, db, ConStr, CDA)
	grouplevelidx = booinfo(0) 
	RoundCnt =  booinfo(1)
	judgeCnt =  booinfo(2)
	lidxs = booinfo(3)

	Call setBooEnd(grouplevelidx,lidxs,lidx,midx,judgeCnt,jno, db, ConStr)

'		 Call oJSONoutput.Set("끝", "끝" )

		' Call oJSONoutput.Set("그룹번호", grouplevelidx )
		' Call oJSONoutput.Set("CDA", cda )		
		' Call oJSONoutput.Set("심판번호", jno )


		Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
		Call oJSONoutput.Set("servermsg", jno ) '서버에서 메시지 생성 전달
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end




'종료확인==========================================


		Call oJSONoutput.Set("result", "0" ) '정상
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
%>

