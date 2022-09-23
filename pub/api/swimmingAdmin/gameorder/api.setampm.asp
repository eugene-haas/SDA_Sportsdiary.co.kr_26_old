<%
'#############################################

'경기 기본 시간 설정

'#############################################
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GDATE") = "ok" Then
		gdate = oJSONoutput.GDATE
	End If
	If hasown(oJSONoutput, "AM") = "ok" Then
		amtm = oJSONoutput.AM
	End If
	If hasown(oJSONoutput, "PM") = "ok" Then
		pmtm = oJSONoutput.PM
	End If

	Set db = new clsDBHelper


	'등록된 동일날짜가 있는지 검사 (등록하로 온거임 수정하로 온게 아니고)
	SQL = "select idx from sd_gameStartAMPM where tidx = '"&tidx&"' and gamedate = '"&gdate&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		'등록된 날짜가 이미 존재한다.
		Call oJSONoutput.Set("result", 5 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	'업다면 저장
	SQL = "insert into sd_gameStartAMPM (tidx, gamedate, am,pm) values ('"&tidx&"','"&gdate&"','"&amtm&"','"&pmtm&"')"
	Call db.execSQLRs(SQL , null, ConStr)

	'경기 날짜순서대로 번호 생성
	SQL = "UPDATE A  SET A.gameno = A.RowNum FROM ( Select gameno , RANK() OVER (Order By gamedate asc) AS RowNum from SD_gameStartAMPM where tidx = '"&tidx&"' ) AS A "
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>