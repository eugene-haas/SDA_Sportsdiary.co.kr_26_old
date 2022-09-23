<%
'#############################################
'결승 라운드 참가자로 만든다.
'#############################################
	'request
	idx = oJSONoutput.IDX 'tblRGameLevel idx
	tidx = oJSONoutput.TitleIDX
	title = oJSONoutput.Title
	teamnm = oJSONoutput.TeamNM
	areanm = oJSONoutput.AreaNM
	levelno = oJSONoutput.LevelNo
	in_midx = oJSONoutput.midx

	Call oJSONoutput.Set("mclose", 0 )

	Set db = new clsDBHelper

	strtable = " sd_TennisMember "
	strtablesub =" sd_TennisMember_partner "

	'삭제
	SQL = "DELETE From "&strtable&" From "&strtable&" As a Left Join "&strtablesub&" As b On a.gameMemberIDX = b.gameMemberIDX Where a.gameMemberIDX = " & in_midx
	Call db.execSQLRs(SQL , null, ConStr)

	
	'한명도 남아있지 않다면 
	SQL = "select count(*) from "&strtable&" where GameTitleIDX = "&tidx&" and gamekey3 = "&levelno&" and DelYN = 'N' and gubun in (0,1) "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If CDbl(rs(0)) = 0 Then
		SQL = "update tblRGameLevel set  lastroundmethod = 0 where  GameTitleIDX = "&tidx&" and level = '"&levelno&"' and DelYN = 'N' "
		Call db.execSQLRs(SQL , null, ConStr)
		oJSONoutput.mclose = 1
	End If
	'한명도 남아있지 않다면 

	Set rs = Nothing
	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>