<%
'request
	If hasown(oJSONoutput, "PNO") = "ok" then
		pno = oJSONoutput.pno
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	
'request


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

	Set db = new clsDBHelper

	SMSMsg = "[스포츠다이어리]인증번호 ["&tempAuth&"] 를 입력해 주세요."

	insertfield = " (SSUBJECT ,NSVCTYPE,NADDRTYPE,SADDRS ,NCONTSTYPE,SCONTS,SFROM,DTSTARTTIME	)"
	insertvalue = "('"&SMSMsg&"',3,0,'"&Replace(pno,"-","")&"',0,'"&SMSMsg&"','18000523',GETDATE() ) "
	SQL = "Insert into T_SEND " & insertfield & " values " & insertvalue
	Call db.execSQLRs(SQL , null, I_ConStr)

	
	'타입 석어서 보내기
	Call oJSONoutput.Set("tempno", tempAuth )
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>

