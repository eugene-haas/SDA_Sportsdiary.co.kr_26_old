<%
'#############################################

'참가자격제한 입력수정
'만들어두고 대회만들때 선택할꺼이므로 무한이 만들어도 된다.
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 
		idx = oJSONoutput.IDX
	End If
	
	If hasown(oJSONoutput, "F1_0") = "ok" Then '검색1번 선수말, 1,2
		gubun = oJSONoutput.F1_0
	End if
	If hasown(oJSONoutput, "F1_1") = "ok" then	 '검색조건 년도 2019
		findyear = oJSONoutput.F1_1
	End if
	
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set sList = oJSONoutput.PARR

		'p1 = sList.Get(0) '년도
		p1 = sList.Get(0) '종목
		p2 = sList.Get(1) '클레스
		p3 = sList.Get(2) '해당범위 위/아래
		p4 = sList.Get(3) '무감점횟수 ..이상
		p5 = sList.Get(4) '조건선택 and or
		p6 = sList.Get(5) '입상실적 ..이상
		'제한사항
		p7 = sList.Get(6) '참가여부 가능 불가능
		p8 = sList.Get(7) '종목
		p9 = sList.Get(8) '클레스
	End if

	If hasown(oJSONoutput, "HK") = "ok" Then '말종류
		mkf = oJSONoutput.HK '마종 혼혈, 국산, 외산 MKF 없을때 N
	End If
	

	Set db = new clsDBHelper 

	updatefield = " chkyear= '"&findyear&"',Teamgbnm='"&p1&"',  chkHkind='"&mkf&"'   ,chkClass='"&p2&"',updown='"&p3&"',zeropointcnt='"&p4&"',chkandor='"&p5&"',prizecnt='"&p6&"',attokYN='"&p7&"',limitTeamgbnm='"&p8&"',limitchkClass='"&p9&"',writedate = getdate() "
	SQL = "update  tblLimitAtt Set   " & updatefield & " where seq = " & idx
	Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
