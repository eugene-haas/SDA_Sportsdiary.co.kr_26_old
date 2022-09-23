<%
	'request
	strSportsGb = oJSONoutput.SportsGb
	gidx = oJSONoutput.GIDX '대회 인덱스
	strTeamGb = oJSONoutput.TeamGb
	lineall = oJSONoutput.LNALL '모두 (전체 0 ) 라인추가 no 추가 안함 yes 추가

	Set db = new clsDBHelper

	'개인전 단식 
	'개인전 복식
	'단체전 복식
	strSql = "SELECT  left(TeamGb,3) as teamGb  "
	strSql = strSql &  "  FROM tblRGameLevel "
	strSql = strSql &  " WHERE GameTitleIDX = " & gidx & "  AND DelYN = 'N'  group by left(TeamGb,3) "
'Response.write strsql
'Response.end
	
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)

	If lineall = "setmenu" Then '필요메뉴 구성
		'단식부
		'나머지개인전 복식
		'단체전
		boo = array(0,0,0)
		Do Until rs.eof 
			teamnm = rs("TeamGb")
			Select Case teamnm
			Case  "200"  : boo(0) = 1 '단식부
			Case  "202"  : boo(2) = 1
			Case  Else : boo(1) = 1
			End Select
		rs.movenext
		Loop

		jsonstr = "[ "& boo(0) & "," & boo(1) & "," & boo(2) & "]"
		Response.Write CStr(jsonstr)	

	Else 

		teamgb = strTeamGb & "00"
		teamgbnext = CDbl(teamgb) + 100

		strSql = "SELECT  a.TeamGbNm, a.Level,b.LevelNm  "
		strSql = strSql &  "  FROM tblRGameLevel as a left join tblLevelInfo as b  ON a. level = b.level "
		strSql = strSql &  " WHERE a.GameTitleIDX = " & gidx & " and a.TeamGb > " & teamgb & " and a.TeamGb < " & teamgbnext
		strSql = strSql &  " AND a.DelYN = 'N'"
		strSql = strSql &  " ORDER BY a.TeamGbNm ASC" 'TeamGbSort

		'Response.write strsql
		'Response.end
		
		Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
		rscnt =  rs.RecordCount

		If lineall = "yes" Then
			ReDim JSONarr(rscnt)
		else
			ReDim JSONarr(rscnt-1)
		End if

		i = 0
		Do Until rs.eof

			If i = 0 And lineall = "yes" Then
				Set rsarr = jsObject() 
				rsarr("TeamGb") = "0"
				rsarr("TeamGbNm") = "모두"
				Set JSONarr(i) = rsarr
				i= i + 1
			End If
			
			Set rsarr = jsObject() 
			rsarr("TeamGb") = rs("level")
			If rs("levelNm") = "" Or isNull(rs("levelNm")) = true Then
			rsarr("TeamGbNm") = rs("TeamGbNm") 
			else
			rsarr("TeamGbNm") = rs("TeamGbNm") & " (" & rs("levelNm") & ")"
			End if
			Set JSONarr(i) = rsarr

		i = i + 1
		rs.movenext
		Loop
		jsonstr = toJSON(JSONarr)

		'jsonstr = "{""BOO"":[ "& boo(0) & "," & boo(1) & "," & boo(2) & "], ""TM"":" & jsonstr & "}"
		'response.ContentType="text/plain"	
		Response.Write CStr(jsonstr)
	End if

	db.Dispose
	Set db = Nothing
%>