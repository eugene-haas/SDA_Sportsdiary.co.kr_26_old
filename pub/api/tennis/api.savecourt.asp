<%
    'mx.SendPacket('enterscore', {'CMD':mx.CMD_SAVECOURT,'SCIDX':score.jsondata.SCIDX,'C1':cidx1,'C2':cidx2,'C3':cidx3, 'C4':cidx4, 'LT':leftresult,'RT':rightresult,'SV':serveno })		
	idx = oJSONoutput.SCIDX
	'인덱스
	court1 = oJSONoutput.C1 '1코트 플레이어 인덱스
	court2 = oJSONoutput.C2
	court3 = oJSONoutput.C3  '단식이라면 값이 0
	court4 = oJSONoutput.C4 ' 단식이라면 값이 0

	gameno = oJSONoutput.GAMENO
	serve = oJSONoutput.SERVE
	serve2 = oJSONoutput.SERVE2
	recive2 = oJSONoutput.RECIVE2
'	pos = oJSONoutput.POS '1번유저 위치 left right


	recive = 0
	'처음 저장
	strTableName = " sd_TennisResult "
	strWhere = "  where  resultIDX = " & idx
	SQL = "UPDATE " & strTableName &" Set  court1playerIDX = "&court1&" , court2playerIDX = "&court2& " ,court3playerIDX = "&court3&" , court4playerIDX = "&court4

	If gameno = "1" And CDbl(serve) > 0 Then
		SQL = "UPDATE " & strTableName &" Set  court1playerIDX = "&court1&" , court2playerIDX = "&court2& " ,court3playerIDX = "&court3&" , court4playerIDX = "&court4
	End If

	If gameno = "2" And CDbl(serve2) > 0 Then
		If court1 = serve2 Or court3 = serve2 Then '서브 반대편 애들을 서브 위치에서 순서잡아서 변경
			SQL = "UPDATE " & strTableName &" Set  court1playerIDX = "&court2&" , court3playerIDX = "&court4 & ", secondrecive = " & recive2
			recive = "left" '리시브 조정위치
		Else
			SQL = "UPDATE " & strTableName &" Set  court2playerIDX = "&court1&" , court4playerIDX = "&court3 & ", secondrecive = " & recive2
			recive = "right" '리시브 조정위치
		End if
	End If


	gubun = 1
	If CDbl(court3) = 0 Then
		gubun = 0
	End if

	leftetc = oJSONoutput.LT	'왼쪽 기타판정
	rightetc = oJSONoutput.RT

	courtno = oJSONoutput.CTNO '코트번호
	courtkind = oJSONoutput.CTKD '코트종류
	
	

	'#################################
	Set db = new clsDBHelper
	'SQL = SQL & " , leftetc = "&leftetc&" , rightetc = "&rightetc&",courtmode=1 ,courtno= "&courtno&",courtkind="&courtkind & rc12up & rc34up & strWhere
	SQL = SQL & " , leftetc = "&leftetc&" , rightetc = "&rightetc&",courtmode=1 ,courtkind="&courtkind & rc12up & rc34up & strWhere

	If request("t") = "t" Then
		Response.write SQL
		Response.end
	End if	
	
	Call db.execSQLRs(SQL , null, ConStr)



	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("GN", gubun ) '0단식

	Call oJSONoutput.Set("RCPOS", recive )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 