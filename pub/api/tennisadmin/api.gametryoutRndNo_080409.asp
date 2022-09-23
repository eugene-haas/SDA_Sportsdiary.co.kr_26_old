<%

'#############################################

'예선대진표에서 시드(체크박스)변경 시, 상태 UPDATE

'#############################################
	'request

	STR = oJSONoutput.STR
	RNDNO = oJSONoutput.RNDNO
	jono = oJSONoutput.JONO '조번호 (예선/순위결정 작업때 사용)
	tIdx = oJSONoutput.TitleIDX
	gamekey3 = oJSONoutput.S3KEY '게임종목 키
	levelkey = gamekey3
	gamekey3 = Left(gamekey3,5)

	'Response.Write "STR : " & STR & " <br>"
	'Response.Write "RNDNO : " & RNDNO & " <br>"
	'Response.Write "jono : " & jono & " <br>"
	'Response.Write "tIdx : " & tIdx & " <br>"
	'Response.Write "levelkey : " & levelkey & " <br>"


	Set db = new clsDBHelper

	strTableName = " sd_TennisMember "
	strFieldName = " GameTitleIDX, TeamGb, gamekey3, tryoutgroupno, playeridx,rndno1,rndno2 "
	strWhere = " DelYN = 'N' and GameTitleIDX = "&tidx&" and gamekey3 = "& levelkey & " and tryoutgroupno = " & jono 
	strSql = "SELECT top 1 " & strFieldName
	strSql = strSql &  "  FROM  " & strTableName
	strSql = strSql &  " WHERE " & strWhere
	'Response.Write strSql
	'Response.END
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		 

	If Not rs.eof Then
		str_rndno1 = rs("rndno1")
		str_rndno2 = rs("rndno2")
	Else
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End
	End If
	'Response.Write "str_rndno1 : " & str_rndno1 & " <br>"
	'Response.Write "str_rndno2 : " & str_rndno2 & " <br>"
	

	If str_rndno1 = "" Then
	If STR = "1" and Cdbl(str_rndno1) <> Cdbl(RNDNO) Then
	strSql = " Update sd_TennisMember SET "
	strSql = strSql & " SortNo = '0' "
	strSql = strSql & " WHERE gubun in (2, 3)"
	strSql = strSql & " AND GameTitleIDX = '" & tIdx & "'"
	strSql = strSql & " AND gamekey3 = '" & levelkey & "'"
	strSql = strSql & " AND DelYN = 'N'"
	strSql = strSql & " AND Round= '1'"
	'Response.Write strSql
	Call db.execSQLRs(strSql , null, ConStr)
	End If
	End If

	If str_rndno2= "" Then
	If STR = "2"  and CDBL(str_rndno2) <> CDBL(RNDNO)Then
	strSql = " Update sd_TennisMember SET "
	strSql = strSql & " SortNo = '0' "
	strSql = strSql & " WHERE gubun in (2, 3)"
	strSql = strSql & " AND GameTitleIDX = '" & tIdx & "'"
	strSql = strSql & " AND gamekey3 = '" & levelkey & "'"
	strSql = strSql & " AND DelYN = 'N'"
	strSql = strSql & " AND Round= '1'"
	'Response.Write strSql
	Call db.execSQLRs(strSql , null, ConStr)
	End If
	End If

	'Gubun 3일때 
	strSql = " SELECT tryoutgroupno, COUNT(*) AS Cnt"
	strSql = strSql & " FROM sd_TennisMember "
	strSql = strSql & " WHERE GameTitleIDX = '" & tIdx & "' "
	strSql = strSql & " AND gamekey3 = '" & levelkey & "'"
	strSql = strSql & " AND tryoutgroupno = '" & jono & "'"
	strSql = strSql & " AND DelYN = 'N'"
	strSql = strSql & " AND GUBUN = '3'"
	strSql = strSql & " AND Round= '1'"
	strSql = strSql & " GROUP BY tryoutgroupno"
	'Response.Write strSql & "<br>"
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)

	If Not rs.eof Then
		If CDbl(rs("Cnt")) > 0 Then
			'Call oJSONoutput.Set("result", 3 )
			'strjson = JSON.stringify(oJSONoutput)
			'Response.Write strjson
			'Response.END
		End If
	End If

	'해당 조가 아니면서 예선전인 얘의 rndno가 있는지 확인
	strSql = " SELECT tryoutgroupno, COUNT(*) AS Cnt"
	strSql = strSql & " FROM sd_TennisMember "
	strSql = strSql & " WHERE GameTitleIDX = '" & tIdx & "' "
	strSql = strSql & " AND gamekey3 = '" & levelkey & "'"
	strSql = strSql & " AND tryoutgroupno <> '" & jono & "'"
	strSql = strSql & " AND DelYN = 'N'"
	strSql = strSql & " AND gubun in (0, 1)"
	If STR = "1" Then
		strSql = strSql & " AND rndno1 = '" & RNDNO & "' AND rndno1 <> 0"
	Else
		strSql = strSql & " AND rndno2 = '" & RNDNO & "' AND rndno2 <> 0"
	End If

	strSql = strSql & " GROUP BY tryoutgroupno"
	'Response.Write strSql & "<br>"
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		 

	If Not rs.eof Then
		If CDbl(rs("Cnt")) > 0 Then
			Prv_tryoutgroupno = rs("tryoutgroupno")
			'Response.Write "Prv_tryoutgroupno:" & Prv_tryoutgroupno & "<br>"
		End If
	End If

	If STR = "1" Then
		updatevalue = " rndno1 = '" & RNDNO & "'"
		updatevalue_0 = " rndno1 = '0'"
	Else
		updatevalue = " rndno2 = '" & RNDNO & "'"
		updatevalue_0 = " rndno2 = '0'"
	End If

	strSql = " Update sd_TennisMember Set  " & updatevalue  
	strSql = strSql & " WHERE GameTitleIDX = '" & tIdx & "'"
	strSql = strSql & " AND gamekey3 = '" & levelkey & "'"
	strSql = strSql & " AND tryoutgroupno = '" & jono & "'"
	strSql = strSql & " AND  gubun in (0, 1)"
	'Response.Write strSql & "<br>"
	Call db.execSQLRs(strSql , null, ConStr)
	'Response.End
	If Prv_tryoutgroupno <> "" Then
		strSql = " Update sd_TennisMember Set " & updatevalue_0
		strSql = strSql & " WHERE GameTitleIDX = '" & tIdx & "'"
		strSql = strSql & " AND gamekey3 = '" & levelkey & "'"
		strSql = strSql & " AND tryoutgroupno = '" & Prv_tryoutgroupno & "'"
		strSql = strSql & " AND gubun in (0, 1)"

		Call db.execSQLRs(strSql , null, ConStr)
	End If


	strSql = " Update sd_TennisMember SET "
	strSql = strSql & updatevalue
	strSql = strSql & " WHERE gubun in (2, 3)"
	strSql = strSql & " AND GameTitleIDX = '" & tIdx & "'"
	strSql = strSql & " AND gamekey3 = '" & levelkey & "'"
	strSql = strSql & " AND tryoutgroupno = '" & jono & "'"
	strSql = strSql & " AND DelYN = 'N'"

	Call db.execSQLRs(strSql , null, ConStr)

	If Prv_tryoutgroupno <> "" Then
		strSql = " Update sd_TennisMember SET "
		strSql = strSql & updatevalue_0
	
		strSql = strSql & " WHERE gubun in (2, 3)"
		strSql = strSql & " AND GameTitleIDX = '" & tIdx & "'"
		strSql = strSql & " AND gamekey3 = '" & levelkey & "'"
		strSql = strSql & " AND tryoutgroupno = '" & Prv_tryoutgroupno & "'"
		strSql = strSql & " AND DelYN = 'N'"
		strSql = strSql & " AND DelYN = 'N'"
		strSql = strSql & " AND " & updatevalue

		Call db.execSQLRs(strSql , null, ConStr)
	End If


	

  db.Dispose
  Set db = Nothing

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>
