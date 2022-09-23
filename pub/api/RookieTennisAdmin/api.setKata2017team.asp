<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
'Response.End



nkey =oJSONoutput.NKEY

Set db = new clsDBHelper



'################################################################
'If CDbl(nkey) < 9000 then
'nkey = 9497
'End if

'nkey


If CDbl(nkey) = 0 Or CDbl(nkey) = 1  Then
	SQL = "select top 1 playeridx,UserName,Team,TeamNm,Team2,team2nm from tblplayer where playeridx > 0 and DelYN = 'N' and Team = Team2 and Team <> '' and TeamNm <> Team2Nm order by playeridx asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
Else
	SQL = "select top 1 playeridx,UserName,Team,TeamNm,Team2,team2nm from tblplayer where playeridx > "&nkey&" and DelYN = 'N' and Team = Team2 and Team <> '' and TeamNm <> Team2Nm order by playeridx asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
End If


If rs.eof Then
	oJSONoutput.NKEY = "끝"
else
	pidx = rs(0)
	team2nm = rs("team2nm")


	SQL = "select top 1 team,teamnm from tblTeamInfo where teamnm = '"&team2nm&"' "
	Set rsc = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rsc.RecordCount

	If CDbl(rscnt) > 0 Then
		SQL1 = "update tblplayer set Team2 = '"& rsc(0) &"' where PlayerIDX= " & pidx
		Call db.execSQLRs(SQL1 , null, ConStr)
	End if

	pinfo = uname & " " & uphone & " 팀키바로잡기 -" & sql1 &"<br>"
	oJSONoutput.NKEY = pidx

End if


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

Response.write pinfo & "<br>"




db.Dispose
Set db = Nothing
%>