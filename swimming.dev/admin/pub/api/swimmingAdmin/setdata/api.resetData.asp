<%
'#############################################
'밀어넣은 데이터 삭제 (gameMember 데이터는? 나중에 생성하니 일딴 고민해보자
'#############################################
	
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then 
		tidx = oJSONoutput.TIDX
	End If

	Set db = new clsDBHelper 


		'delete from tblteamgbinfo where cd_type = 3
		SQL = "delete from tblgamerequest_temp Where gametitleidx = " & tidx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "delete from tblgamerequest_r Where requestIDX in (select requestIDX from tblGameRequest where gametitleidx = " & tidx & " ) " 
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "delete from tblgamerequest  Where gametitleidx = " & tidx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "delete from tblRgameLevel Where gametitleidx = " & tidx
		Call db.execSQLRs(SQL , null, ConStr)


		SQL = "delete from sd_gameMember_partner Where gameMemberIDX in (select gameMemberIDX from sd_gameMember where gametitleidx  = " & tidx & " ) "
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "delete from sd_gameMember Where gametitleidx = " & tidx
		Call db.execSQLRs(SQL , null, ConStr)

		'sd_gameMember 
		'sd_gameMember_partner 

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>