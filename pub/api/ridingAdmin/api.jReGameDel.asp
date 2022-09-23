<%
'#############################################
'재경기삭제
'#############################################

	'request
	If hasown(oJSONoutput, "KGAME") = "ok" Then '체전여부 A 두번복사여부
		r_kgame= oJSONoutput.KGAME
	End If
	
	If hasown(oJSONoutput, "RDNO") = "ok" then'장애물 A 라운드 별 계산에 필요
		r_rdno= oJSONoutput.RDNO
	End If

	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End If

	delrdno = r_rdno  '지울 라운드번호

	Set db = new clsDBHelper 

	'파트너 지울 gamememberidx 구하기
	SQL = "delete from sd_TennisMember_partner where gamememberidx in (select gamememberidx from sd_tennisMember where gametitleidx = "&r_tidx&" and  gamekey3 = "&r_gbidx&"  and round = " & delrdno & ")"
	Call db.execSQLRs(SQL , null, ConStr)

	SQL = "delete from sd_TennisMember where gametitleidx = "&r_tidx&" and  gamekey3 = "&r_gbidx&"  and round = " & delrdno
	Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
