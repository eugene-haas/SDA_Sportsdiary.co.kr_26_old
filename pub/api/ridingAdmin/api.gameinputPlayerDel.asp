<%
'#############################################

'#############################################
	'request
	idx = oJSONoutput.IDX
	titleidx = oJSONoutput.TitleIDX
	title = oJSONoutput.Title
	teamidx = oJSONoutput.TeamIDX  '인덱스
	levelno = oJSONoutput.LevelNo
	
	Set db = new clsDBHelper

	SQL = "Select P1_PlayerIDX, P2_PlayerIDX from tblGameRequest where RequestIDX = " & idx & " and DelYN='N'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof  then
		p1player = rs(0)
		p2player = rs(1)
		p1player = CDbl(p1player)
		p2player = CDbl(p2player)
	Else
		Call oJSONoutput.Set("result", "4" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.End			
	End if

	'Response.write "db:"&p1player & "," & p2player &"</br>"
	'response.End

	SQL = "SELECT Count(*) as Cnt FROM sd_TennisMember where (PlayerIDX = " & p1player & " or PlayerIDX = " & p2player & ") and gamekey3 = "& levelno &" and GameTitleIDX =  "&titleidx &" and DelYN = 'N'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	MemberCnt = rs(0) 
	'Response.write "MemberCnt:"&MemberCnt&"</br>"
	'response.End
	IF MemberCnt <> 0 Then
		'타입 석어서 보내기
		Call oJSONoutput.Set("result", "5" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.End
	End if


	subq = " (select top 1 gamememberidx from sd_TennisMember where PlayerIDX = " & p1player & " and gamekey3 = "& levelno &" and GameTitleIDX =  "&titleidx &" and DelYN = 'N' ) "
	SQL = "DELETE From sd_TennisMember From sd_TennisMember As a Left Join sd_TennisMember_partner As b On a.gameMemberIDX = b.gameMemberIDX Where a.gameMemberIDX = " & subq
	Call db.execSQLRs(SQL , null, ConStr)
	
	
	strSql = "update  tblGameRequest Set   DelYN = 'Y' where RequestIDX = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing

'response.write strSQL
%>


<!-- #include virtual = "/pub/html/riding/gameinfoPlayerForm.asp" -->
