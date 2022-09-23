<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'백승훈
'기록관 저장  제기록시 제시작 시간 추가 gamestop = ''
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	idx = oJSONoutput.SCIDX
	starth = oJSONoutput.H
	startm = oJSONoutput.M
	rcname = oJSONoutput.RC '기록관 이름

	startdate = Date & " " & starth & ":" & startm & ":00"
	
	Set db = new clsDBHelper

	strTableName = " sd_TennisResult "

	SQL = "select top 1 gamestart,gamestop,gamerestart from "&strTableName&" where  resultIDX = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'
'Response.write sql
'Response.end

	gamestart = rs("gamestart")
	gamestop = rs("gamestop")
	gamerestart = rs("gamerestart")

	If gamestart = "" then
		setfield = " gamestart = '"&startdate&"' ,  recorderName = '"&rcname&"', stateno = 2 " 'stateno 0 진행전, 2진행중, 1 완료
	Else
		setfield = " gamerestart = getdate() ,  recorderName = '"&rcname&"', stateno = 2 "		
	End if

	SQL = "UPDATE " & strTableName &" Set  "&setfield&"  where  resultIDX = " & idx
	Call db.execSQLRs(SQL , null, ConStr)



	Call oJSONoutput.Set("RNM", recorderName ) '심판명칭
	Call oJSONoutput.Set("result", "0" )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%>