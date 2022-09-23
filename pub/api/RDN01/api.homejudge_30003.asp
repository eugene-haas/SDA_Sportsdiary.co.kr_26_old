<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'저정 심판등록
'#############################################

	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '심판등급, 종목, tblWebmember.seq 3개받음
	End if
	
	'{""CMD"":30001,""SENDPRE"":""kor_"",""PARR"":[""2020"",""강택"",""6638"",""KANG TEAK"",""ATE0003139"",""강원도승마협회"",""200312004851"",""M"",""19871006"",""마장마술""]}
	Set db = new clsDBHelper 
		tablename = "tblPlayer"

		For i = 0 To oJSONoutput.PARR.length-1 '받은거 기준 (입력값 준비)   '심판등급, 종목, tblWebmember.seq 3개받음
			Select Case i
			Case 0
				Ajudgelevel	= reqArr.Get(i)
			Case 1
				CDBNM	= reqArr.Get(i)
			Case 2
				e_pidx	= reqArr.Get(i)
			End Select 
		next

		updatefield = "  Ajudgelevel = '"&Ajudgelevel&"', CDBNM = '"&CDBNM&"'  "
		strSql = "update  "&tablename&" Set   " & updatefield & " where playeridx = " & e_pidx
		Call db.execSQLRs(strSQL , null, ConStr)
		

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>