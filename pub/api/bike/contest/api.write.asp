<%
'######################
'등록
'######################
	datareq = True

	If hasown(oJSONoutput, "SGB") = "ok" then
		sgb = oJSONoutput.SGB
	Else
		datareq = False
	End If
	If hasown(oJSONoutput, "TITLE") = "ok" then
		title = oJSONoutput.TITLE
	Else
		datareq = False
	End If
	If hasown(oJSONoutput, "GTYPE") = "ok" then
		gtype = oJSONoutput.GTYPE
	Else
		datareq = False
	End if
	'##############################
	If hasown(oJSONoutput, "SIDO") = "ok" then
		sido = oJSONoutput.SIDO
	Else
		datareq = False
	End if
	If hasown(oJSONoutput, "ZIPCODE") = "ok" then
		zipcode = oJSONoutput.ZIPCODE
	Else
		datareq = False
	End if
	If hasown(oJSONoutput, "ADDR") = "ok" then
		addr = oJSONoutput.ADDR
	Else
		datareq = False
	End if
	If hasown(oJSONoutput, "STADIUM") = "ok" then
		stadium = oJSONoutput.STADIUM
	Else
		datareq = False
	End if
	'##############################
	If hasown(oJSONoutput, "GameS") = "ok" then
		games = oJSONoutput.GameS
	Else
		datareq = False
	End if
	If hasown(oJSONoutput, "GameE") = "ok" then
		gamee = oJSONoutput.GameE
	Else
		datareq = False
	End if


	If hasown(oJSONoutput, "GameAS") = "ok" then
		gameas = oJSONoutput.GameAS
	Else
		datareq = False
	End if
	If hasown(oJSONoutput, "GameAE") = "ok" then
		gameae = oJSONoutput.GameAE
	Else
		datareq = False
	End if


	If hasown(oJSONoutput, "HOST") = "ok" then
		gamehost = oJSONoutput.HOST
	Else
		datareq = False
	End if
	'##############################


	If datareq = False then
		Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End
	End If


	Set db = new clsDBHelper

	'중복값확인

	'중복값확인

	'생성
	If gamee <> "" and games <> "" then
	gamecnt = CDate(gamee) - CDate(games) + 1
	yy = year(games)
	Else
	gamecnt = 0
	yy = year(date)
	End if

	'타이틀 코드 구하기
	SQL = "select titleCode,hostTitle from sd_bikeTitleCode where hostTitle = '"&sgb&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	titlecode = rs(0)


	insertfield = "gametitlename,games,gamee,gameyear,gamearea,entertype,hostname,organize, titlecode, zipcode,sido,addr  ,GameRcvDateS,GameRcvDateE "
	fieldvalue = "'"&title&"','"&games&"','"&gamee&"','"&yy&"','"&Stadium&"','"&gtype&"','"&gamehost&"','"&org&"','"&titlecode&"' ,  '"&zipcode&"','"&sido&"','"&addr&"' , '"&gameas&"','"&gameae&"' "
	SQL = " insert into sd_bikeTitle ("&insertfield&") values ("&fieldvalue&")"



	Call db.execSQLRs(SQL , null, ConStr)

	'############
	SQL = "Select top 1 titleIDX,"&insertfield&",cfg from sd_bikeTitle where delYN = 'N' order by titleIDX desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	Do Until rs.eof
		b_idx = rs("titleIDX")
		b_entertype = rs("entertype")
		b_title = rs("gametitlename")
		b_GameS = Replace(Left(rs("GameS"),10),"-",".")
		b_GameE = Replace(Left(rs("GameE"),10),"-",".")
		b_titleCode = rs("titleCode")
		b_sido = rs("Sido")
		b_zipcode = rs("zipcode")
		b_addr = rs("addr")
		b_gamearea = rs("cfg") 'NNN'
		b_hostname = rs("hostname")


		%><!-- #include virtual = "/pub/html/bike/list.contest2.asp" --><%
	  rs.movenext
	  Loop
	  Set rs = Nothing

	db.Dispose
	Set db = Nothing
%>
