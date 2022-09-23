<%
'######################
'����
'######################
	datareq = True
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx = oJSONoutput.IDX
	Else
		datareq = False
	End If

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
		Call oJSONoutput.Set("result", "1" ) '��������  ����
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End
	End If

	Set db = new clsDBHelper

	'titleCode ���ϱ�
	SQL = " SELECT titleCode FROM sd_bikeTitleCode WHERE hostTitle =  '"&sgb&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	titleCode = rs("titleCode")

	'update
	updateTable = " sd_bikeTitle "
	updatefield = " titleCode = '"&titleCode&"', GameTitleName = '"&title&"', EnterType = '"&gtype&"', sido = '"&sido&"', zipcode = '"&zipcode&"', hostname = '"&gamehost&"', "
	updatefield = updatefield & " addr = '"&addr&"', GameArea = '"&stadium&"', GameS = '"&games&"', GameE = '"&gamee&"', GameRcvDateS = '"&gameas&"', GameRcvDateE = '"&gameae&"'  "
	updateWhere = " titleIDX = " & idx
	SQL = "UPDATE "&updateTable&" SET "&updatefield&" WHERE "&updateWhere&"  "
	Call db.ExecSQL(SQL , null, ConStr)


	'������ ����Ʈ �׸���
	SQL = "Select titleIDX,"&updatefield&",cfg from sd_bikeTitle where delYN = 'N' AND titleIDX = "& idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

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

	db.dispose()
	Set db = nothing
%>

<!-- #include virtual = "/pub/html/bike/list.contest2.asp" -->
