<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then
		midx = oJSONoutput.MIDX
	End If
	If hasown(oJSONoutput, "CNGVAL") = "ok" Then
		cngval = oJSONoutput.CNGVAL
		If isnumeric(cngval) = False Then
			Call oJSONoutput.Set("result", 5 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	End If
	
	If hasown(oJSONoutput, "CNGVAL2") = "ok" Then
		cngval2 = oJSONoutput.CNGVAL2
		If isnumeric(cngval2) = False Then
			Call oJSONoutput.Set("result", 5 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	End If


	Set db = new clsDBHelper


	'starttype = 1 tryoutgroupno:예선 roundno:결승 starttype = 3 tryoutgroupno:결승
	'결승 starttype = 1 일때 경승으로 사용 (roundno) 그러므로 무조건 여따 넣으면 된다.

	SQL = "select gametitleidx,gbidx,tryoutgroupno,tryoutsortNo from SD_gameMember where gameMemberidx = " & midx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	tidx = rs(0)
	gbidx = rs(1)
	gno = rs(2)
	sno = rs(3)

	'대상이 있는지 검사.
	strwhere = " delyn = 'N' and gametitleidx = "&tidx&" and gbidx = "&gbidx&" and  tryoutgroupno = '"&cngval&"' and tryoutsortNo= '"&cngval2&"'  "
	SQL = "select gamememberidx from SD_gameMember where " & strwhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	If rs.eof Then '없어
		SQL = SQL & " update  SD_gameMember set tryoutgroupno = "&cngval&" ,tryoutsortNo= '"&cngval2&"'  where gameMemberidx = " & midx 
		Call db.execSQLRs(SQL , null, ConStr)
	Else ' 있어
		target_midx = rs(0)
		SQL = SQL & " update  SD_gameMember set tryoutgroupno = "&gno&" ,tryoutsortNo= '"&sno&"'  where gameMemberidx = " & target_midx  '바뀔아이
		SQL = SQL & " update  SD_gameMember set tryoutgroupno = "&cngval&" ,tryoutsortNo= '"&cngval2&"'  where gameMemberidx = " & midx 
		Call db.execSQLRs(SQL , null, ConStr)

	End if



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>