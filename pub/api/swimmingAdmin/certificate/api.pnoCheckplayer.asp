<%
'request
	nm = oJSONoutput.Get("NM")
	pno = oJSONoutput.Get("PNO")
	certificatetype = oJSONoutput.Get("CTYPE")

	'request
	Set db = new clsDBHelper
	'년도에 등록된 코치인지 확인 한다. (엘리트만)
	SQL = "Select team,username,birthday,userphone,playeridx,kskey,nowyear from tblPlayer where delyn = 'N' and username = '"&nm&"' and userphone = '"&pno&"'  and EnterType = 'E' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



    If rs.EOF Then
		Call oJSONoutput.Set("result", "3" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		db.Dispose
		Set db = Nothing
		Response.end
    Else
		Dim targetinfo(6)
		targetinfo(0) = rs(0)
		targetinfo(1) = rs(1)
		targetinfo(2) = rs(2)
		targetinfo(3) = rs(3)
		targetinfo(4) = rs(4)
		targetinfo(5) = rs(5)
		targetinfo(6) = rs(6)

		'session("leaderinfo") = targetinfo

		Set mobj =  JSON.Parse("{}")
		Call mobj.Set("a", targetinfo(0) )
		Call mobj.Set("b", targetinfo(1) )
		Call mobj.Set("c", targetinfo(2) )	
		Call mobj.Set("d", targetinfo(3) )
		Call mobj.Set("e", targetinfo(4) )
		Call mobj.Set("f", targetinfo(5) )
		Call mobj.Set("g", targetinfo(6) )
		strmemberjson = JSON.stringify(mobj)
		strmemberjson = f_enc(strmemberjson)

		Response.Cookies("playerinfo") = strmemberjson
		Response.Cookies("playerinfo").domain = CHKDOMAIN

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

	SQL  = " INSERT INTO sms_88.dbo.t_send (sSubject,nSvcType,nAddrType,sAddrs,nContsType,sConts,sFrom,dtStartTime, sitecode , sUserID)  "
	SQL = SQL & " VALUES ('"& SMS_title &"', '"& sendType &"', 0, '"& pno &"', 0, '"& msg &"', '"& fromphone &"', GETDATE(), '"& sitecode &"'   , 'korswim') "
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("no", tempAuth ) '디버깅용

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>
