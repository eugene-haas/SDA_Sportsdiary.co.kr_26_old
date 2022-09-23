<%
'#############################################

'리그테이블 생성

'#############################################
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If

	If hasown(oJSONoutput, "LNO") = "ok" Then
		lno = oJSONoutput.LNO 'levelno
	End If

	If hasown(oJSONoutput, "TNO") = "ok" Then
		tno = oJSONoutput.TNO '참가수
	End If


	
	Set db = new clsDBHelper

	'리그 테이블 insert 

	SQL = "Select gameMemberidx,team,teamnm,starttype,tryoutgroupno,tryoutsortno,gbidx,gametitleidx,levelno,gubun,sidonm from sd_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&lno&"' and delyn = 'N' order by tryoutsortno "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Call rsdrow(rs)
'Response.end

	arrT = rs.GetRows()
	Call drowLeage(arrT, "ok")

	SQL = "update sd_gameMember set gubun = '1' where gametitleidx =  '"&tidx&"' and levelno = '"&lno&"' and delyn = 'N' "
	Call db.execSQLRs(SQL , null, ConStr)

	'Call oJSONoutput.Set("result", 0 )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>