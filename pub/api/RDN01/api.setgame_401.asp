<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<%
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################

	'리셋버튼 동작 

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then 
		tidx = oJSONoutput.TIDX
	End If

	Set db = new clsDBHelper 



		'delete from tblteamgbinfo where cd_type = 3
		SQL = "delete from tblgamerequest_temp Where gametitleidx = '" & tidx & "'"
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "delete from tblgamerequest_r Where requestIDX in (select requestIDX from tblGameRequest where gametitleidx = " & tidx & " ) "  '릴레이에 사용하는거 같음 우선 여기라도 넣어두자 
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "delete from tblgamerequest  Where gametitleidx = " & tidx
		Call db.execSQLRs(SQL , null, ConStr)

		'SQL = "delete from tblRgameLevel Where gametitleidx = " & tidx '생성부삭제? 날짜를 고쳐서 넣었을수 있으니 이건 생략
		'Call db.execSQLRs(SQL , null, ConStr)


		SQL = "delete from sd_tennisMember_partner Where gameMemberIDX in (select gameMemberIDX from sd_tennisMember where gametitleidx  = " & tidx & " ) "
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "delete from sd_tennisMember Where gametitleidx = " & tidx
		Call db.execSQLRs(SQL , null, ConStr)

	

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing

%>

