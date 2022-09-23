<%
'#############################################
'
'#############################################
	
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 
		idx = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "RIDX") = "ok" Then 
		ridx = oJSONoutput.RIDX
	End if	


	Set db = new clsDBHelper 

	'중복검사?

	SQL = "select gameMemberIDX from sd_gameMember where delyn = 'N' and requestIDX = " & ridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
	midx = rs(0)

	SQL = "Insert into sd_gameMember_partner (gameMemberIDx,  ksportsno    ,playeridx,username,odrno,sex,team,teamnm,userclass,sido,requestIDX ,capno ) "
	ordernoq = " ( select case when max(odrno) is null then 1 else max(odrno) + 1 end from sd_gamemember_partner where requestidx = "&ridx&") as ordno  "
	SQL = SQL & " (SELECT "&midx&",  kskey  , playeridx,username,"&ordernoq&",sex,team,teamnm,userclass,'',requestidx,capno   FROM tblGameRequest_r  WHERE delyn = 'N' and seq = " & idx & ")" 
	Call db.execSQLRs(SQL , null, ConStr)



	'시작 맴버로 지정됨 표시
	SQL = "update tblGameRequest_r set startMember = 'Y' where seq = " & idx
	Call db.execSQLRs(SQL , null, ConStr)



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>