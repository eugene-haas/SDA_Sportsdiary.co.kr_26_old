<%
'#############################################

'리그테이블 생성

'#############################################
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If

	If hasown(oJSONoutput, "LNO") = "ok" Then
		gbidx = oJSONoutput.LNO 'levelno
	End If

	If hasown(oJSONoutput, "TNO") = "ok" Then
		tno = oJSONoutput.TNO '참가수
	End If


	

	Set db = new clsDBHelper


	'부전삭제
	SQL = "delete from sd_tennisMember where gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and delyn = 'N' and playeridx = 0 "
	Call db.execSQLRs(SQL , null, ConStr)
	'소팅번호 재설정
	Selecttbl = "( SELECT gubun,tryoutgroupno,tryoutsortNo,RANK() OVER (Order By gameMemberidx asc) AS RowNum FROM SD_tennisMember where gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and delyn = 'N'  ) AS A "
	SQL = "UPDATE A  SET A.tryoutgroupno = '1', A.tryoutsortNo = A.RowNum FROM " & Selecttbl '참고 *  대진표 한번으로 끝
	Call db.execSQLRs(SQL , null, ConStr)


	'리그 테이블 insert 
	fld = " a.gameMemberidx,a.playeridx,a.username,a.tryoutgroupno,a.tryoutsortno,a.gamekey3,a.gametitleidx,a.pubname   ,b.playeridx,b.username "
	SQL = "Select "&fld&" from sd_tennisMember as a left join  sd_tennisMember_partner as b on a.gameMemberidx = b.gameMemberidx  where a.gametitleidx =  '"&tidx&"' and a.gamekey3 = '"&gbidx&"' and a.delyn = 'N' order by a.tryoutsortno "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Call rsdrow(rs)
'Response.end

	arrT = rs.GetRows()
	Call drowLeage(arrT, "ok")

	SQL = "update sd_tennisMember set gubun = '2' where gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and delyn = 'N' "
	Call db.execSQLRs(SQL , null, ConStr)

	'Call oJSONoutput.Set("result", 0 )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>