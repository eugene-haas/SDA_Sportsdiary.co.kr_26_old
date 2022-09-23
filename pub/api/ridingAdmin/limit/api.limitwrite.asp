<%
'#############################################

'참가자격제한 입력
'만들어두고 대회만들때 선택할꺼이므로 무한이 만들어도 된다.
'#############################################
	'request
	If hasown(oJSONoutput, "F1_0") = "ok" Then '검색1번 선수말, 1,2
		gubun = oJSONoutput.F1_0
	End if
	If hasown(oJSONoutput, "F1_1") = "ok" then	 '검색조건 년도 2019
		findyear = oJSONoutput.F1_1
	End if
	
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set sList = oJSONoutput.PARR

		'p1 = sList.Get(0) '년도
		p2 = sList.Get(0) '종목
		p3 = sList.Get(1) '클레스
		p4 = sList.Get(2) '해당범위 위/아래
		p5 = sList.Get(3) '무감점횟수 ..이상
		p6 = sList.Get(4) '조건선택 and or
		p7 = sList.Get(5) '입상실적 ..이상
		'제한사항
		p8 = sList.Get(6) '참가여부 가능 불가능
		p9 = sList.Get(7) '종목
		p10 = sList.Get(8) '클레스
	End if

	If hasown(oJSONoutput, "HK") = "ok" Then '말종류
		mkf = oJSONoutput.HK '마종 혼혈, 국산, 외산 MKF 없을때 N
	End if


	Set db = new clsDBHelper 


	insertfield = " gubun,chkyear,Teamgbnm,  chkHkind   ,chkClass,updown,zeropointcnt,chkandor,prizecnt,attokYN,limitTeamgbnm,limitchkClass,writedate "
	insertvalue = " "&gubun&", '"&findyear&"','"&p2&"','"&mkf&"','"&p3&"','"&p4&"','"&p5&"','"&p6&"','"&p7&"','"&p8&"','"&p9&"','"&p10&"',getdate() "

	SQL = "INSERT INTO tblLimitAtt ( "&insertfield&" ) VALUES ( "&insertvalue&" ) "
	Call db.execSQLRs(SQL , null, ConStr)



  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>