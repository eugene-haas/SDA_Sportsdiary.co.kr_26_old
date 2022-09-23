<%
'#############################################
'기권 문서제출
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX 
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		gbidx= oJSONoutput.GBIDX 
	End If
	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx= oJSONoutput.IDX 
	End If
	If hasown(oJSONoutput, "RIDX") = "ok" then
		r_ridx= oJSONoutput.RIDX
	End If
	If hasown(oJSONoutput, "SAYOUDOC") = "ok" then
		r_sayou= oJSONoutput.SAYOUDOC
	End If


	SQL = "select teamgb,playeridx from sd_tennismember where gamememberidx = " & r_idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof then
		teamgb = rs(0) '복합마술 20103 (복합마술은 단체전이 없다 하나만 체크하면 된다)
		pidx = rs(1) '선수
	End if



	'@@@@@@@@@@@@@@@@@@@@@@@@	
		'tryoutresult, tryoutdocYN
		If r_sayou = "" then
			SQL = "Update SD_tennisMember Set tryoutdocYN = null where gameMemberIDX = " & r_idx
		Else
			SQL = "Update SD_tennisMember Set tryoutdocYN = '"& r_sayou &"' where gameMemberIDX = " & r_idx
		End if
		Call db.execSQLRs(SQL , null, ConStr)

		'gameresult, docYN
		If r_sayou = "" then
			SQL = "Update tblGameRequest Set docYN = null where RequestIDX = " & r_ridx
		Else
			SQL = "Update tblGameRequest Set docYN = '"& r_sayou &"' where RequestIDX = " & r_ridx
		End if
		Call db.execSQLRs(SQL , null, ConStr)


	'#########################################################################################
	'복합마술인 경우 선택되지 않은 다른 경기도 변경해주어야한다.
	'#########################################################################################
	If teamgb = "20103"  Then

		SQL = "select gameMemberIDX , requestidx from sd_tennismember where gametitleidx = "& tidx &" and teamgb = '20103'  and  playeridx = "& pidx &" and gameMemberIDX <> " & r_idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof then
		r_idx2 = rs(0)
		r_ridx2 = rs(1)
		End if


		If r_sayou = "" then
			SQL = "Update SD_tennisMember Set tryoutdocYN = null where gameMemberIDX = " & r_idx2
		Else
			SQL = "Update SD_tennisMember Set tryoutdocYN = '"& r_sayou &"' where gameMemberIDX = " & r_idx2
		End if
		Call db.execSQLRs(SQL , null, ConStr)

		'gameresult, docYN
		If r_sayou = "" then
			SQL = "Update tblGameRequest Set docYN = null where RequestIDX = " & r_ridx2
		Else
			SQL = "Update tblGameRequest Set docYN = '"& r_sayou &"' where RequestIDX = " & r_ridx2
		End if
		Call db.execSQLRs(SQL , null, ConStr)

	End if
	'#########################################################################################


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
