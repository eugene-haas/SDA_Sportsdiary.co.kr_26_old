<%

'#############################################

'예선대진표에서 시드(체크박스)변경 시, 상태 UPDATE

'#############################################
	'request

	orderno = oJSONoutput.Get("STR")
	rnd_novalue = oJSONoutput.Get("RNDNO")
	jono = oJSONoutput.Get("JONO") '조번호 (예선/순위결정 작업때 사용)
	tIdx = oJSONoutput.Get("TitleIDX")
	gamekey3 = oJSONoutput.Get("S3KEY") '게임종목 키
	levelkey = gamekey3
	gamekey3 = Left(gamekey3,5)


	Set db = new clsDBHelper

	strTableName = " sd_TennisMember "
	strWhere = " GameTitleIDX = " & tIdx & "  AND gamekey3 = " & levelkey & " and  DelYN = 'N' " 

	strFieldName = " GameTitleIDX, TeamGb, gamekey3, tryoutgroupno, playeridx,rndno1,rndno2 "
	strSQL = "SELECT top 1 " & strFieldName &  "  FROM  " & strTableName &  " WHERE " & strWhere &  " and tryoutgroupno = " & jono 
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		 

	'예선이든 본선이든 조번호를 가진필드가 존재한다면
	If Not rs.eof Then
		str_rndno1 = rs("rndno1")
		str_rndno2 = rs("rndno2")
	Else
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End
	End If


	'본선에서 랜덤값을 부여하기 위해 sortno 를 0으로 만든다.
	If str_rndno1 = "" Then
		If orderno = "1" and Cdbl(str_rndno1) <> Cdbl(rnd_novalue) Then '1등자리 들어가있늘랜덤번호 <> 보낸랜덤번호가 다르다면  -> 1라운드의 소팅번호를 0으로 초기화?
		strSql = " Update sd_TennisMember SET SortNo = 0  WHERE gubun in (2, 3) and " & strWhere & " AND Round= 1 "
		Call db.execSQLRs(strSql , null, ConStr)
		End If
	End If

	If str_rndno2= "" Then
		If orderno = "2"  and CDBL(str_rndno2) <> CDBL(rnd_novalue)Then
		strSql = " Update sd_TennisMember SET  SortNo = 0 WHERE gubun in (2, 3) and " & strWhere & " AND Round= 1 "
		Call db.execSQLRs(strSql , null, ConStr)
		End If
	End If

	'해당 조가 아니면서 예선전인 얘의 rndno가 있는지 확인 ( 동일 랜덤값이 있는지 확인)
	strSql = " SELECT tryoutgroupno, COUNT(*) AS Cnt  FROM sd_TennisMember  WHERE  " & strWhere & " AND tryoutgroupno <> " & jono & " AND gubun in (0, 1) "
	If orderno = "1" Then
		strSql = strSql & " AND rndno1 = " & rnd_novalue & " AND rndno1 > 0"
	Else
		strSql = strSql & " AND rndno2 = " & rnd_novalue & " AND rndno2 > 0"
	End If
	strSql = strSql & " GROUP BY tryoutgroupno"
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		 

	If Not rs.eof Then
		If CDbl(rs("Cnt")) > 0 Then
			Prv_tryoutgroupno = rs("tryoutgroupno")
		End If
	End If

	If orderno = "1" Then
		updatevalue = " rndno1 = '" & rnd_novalue & "'"
		updatevalue_0 = " rndno1 = '0'"
	Else
		updatevalue = " rndno2 = '" & rnd_novalue & "'"
		updatevalue_0 = " rndno2 = '0'"
	End If

	strSql = " Update sd_TennisMember Set  " & updatevalue & " WHERE " & strWhere & " AND tryoutgroupno = " & jono & " AND  gubun in (0, 1) "
	Call db.execSQLRs(strSql , null, ConStr)

	If Prv_tryoutgroupno <> "" Then
		strSql = " Update sd_TennisMember Set " & updatevalue_0 & " WHERE " & strWhere & " AND tryoutgroupno = " & Prv_tryoutgroupno & " AND gubun in (0, 1)"
		Call db.execSQLRs(strSql , null, ConStr)
	End If


	strSql = " Update sd_TennisMember SET " & updatevalue & " WHERE " & strWhere & " and gubun in (2, 3)  AND tryoutgroupno = " & jono
	Call db.execSQLRs(strSql , null, ConStr)

	If Prv_tryoutgroupno <> "" Then
		strSql = " Update sd_TennisMember SET " & updatevalue_0 & " WHERE " & strWhere & " and gubun in (2, 3)  AND tryoutgroupno = " & Prv_tryoutgroupno & " AND " & updatevalue
		Call db.execSQLRs(strSql , null, ConStr)
	End If

  db.Dispose
  Set db = Nothing

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>
