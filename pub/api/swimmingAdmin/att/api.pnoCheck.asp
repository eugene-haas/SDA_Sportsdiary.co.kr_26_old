<%
'request
	If hasown(oJSONoutput, "NM") = "ok" then
		nm = oJSONoutput.NM
	End if
	If hasown(oJSONoutput, "PNO") = "ok" then
		pno = Replace(oJSONoutput.Get("PNO"),"-","")

		pno2 = Left(pno,3) & "-" & Mid(pno,4,4) & "-" & right(pno,4)
	End If
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.tidx
	End if



	'request
	Set db = new clsDBHelper

'	If USER_IP = "112.187.195.132" And pno = "01047093650" then
'		SQL  = " INSERT INTO SD_TENNIS.dbo.t_send (sSubject,nSvcType,nAddrType,sAddrs,nContsType,sConts,sFrom,dtStartTime, sitecode , sUserID)  "
'		SQL = SQL & " VALUES ('test', '3', 0, '"& pno &"', 0, 'test', '024204236', GETDATE(), '"& sitecode &"'   , 'korswim') "
'		Call db.execSQLRs(SQL , null, ConStr)	
'	End if
	
	
	
	
	
	'년도에 등록된 코치인지 확인 한다. (신청여부는?)
	SQL = "Select team,username,birthday,userphone,idx from tblReader where delyn = 'N' and username = '"&nm&"' and (userphone = '"&pno&"'  or userphone = '"&pno2&"'   ) and startyear = '"&year(now)&"' "
	'SQL = "Select team,username,birthday,userphone,idx from tblReader where delyn = 'N' and username = '백승훈' and userphone = '01047093650' and startyear = '"&year(now)&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    If rs.EOF Then
		'Call oJSONoutput.Set("sql", sql )
		Call oJSONoutput.Set("result", "3" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		db.Dispose
		Set db = Nothing
		Response.end
    Else
		Dim arrinfo(5)
		arrinfo(0) = rs(0)
		arrinfo(1) = rs(1)
		arrinfo(2) = rs(2)
		arrinfo(3) = rs(3)
		arrinfo(4) = tidx
		arrinfo(5) = rs(4)

		'session("leaderinfo") = arrinfo

		Set mobj =  JSON.Parse("{}")
		Call mobj.Set("a", arrinfo(0) )
		Call mobj.Set("b", arrinfo(1) )
		Call mobj.Set("c", arrinfo(2) )	
		Call mobj.Set("d", arrinfo(3) )
		Call mobj.Set("e", arrinfo(4) )
		Call mobj.Set("f", arrinfo(5) )
		strmemberjson = JSON.stringify(mobj)
'		strmemberjson = f_enc(strmemberjson)

		Response.Cookies("leaderinfo") = strmemberjson
		Response.Cookies("leaderinfo").domain = CHKDOMAIN
	

		'Response.write request.cookies("leaderinfo")
	
	End If


	Function rndno(seed, lenno)
		Dim tempAuth
		'랜덤값 만들기
		Randomize   ' 난수 발생기 초기화
		For i = 1 To lenno
			tempAuth = tempAuth &  Int((seed * Rnd) + 0) ' 1에서 seed까지 무작위 값 발생
		Next
		rndno = tempAuth
	End Function

	tempAuth =  rndno(10, 4)


	'세션으로 번호를 생성해 둔다. ( 인증번호 확인시 사용)
	session("chkrndno") = tempAuth


	SMS_title = "대한수영연맹"
	SMSMsg = "[대한수영연맹] 인증번호 ["&tempAuth&"] 를 입력해 주세요."




	msg = Replace(SMSMsg,"\n",vbLf)
	fromphone = "024204236"

	'sendType 7 LMS 3, MMS
	If sendType = "" Then
		sendType = 3
	End If
	

	'sUserID/sFrom    수영 : 아이디 /전화번호  korswim / 024204236

	'내부아이피 문자전송 제거
	If USER_IP <> "112.187.195.132" then
		SQL  = " INSERT INTO sms_88.dbo.t_send (sSubject,nSvcType,nAddrType,sAddrs,nContsType,sConts,sFrom,dtStartTime, sitecode , sUserID)  "
		SQL = SQL & " VALUES ('"& SMS_title &"', '"& sendType &"', 0, '"& pno &"', 0, '"& msg &"', '"& fromphone &"', GETDATE(), '"& sitecode &"'   , 'korswim') "
		Call db.execSQLRs(SQL , null, ConStr)
	End if

	Call oJSONoutput.Set("no", tempAuth ) '디버깅용

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>
