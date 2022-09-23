<%
'######################
'대분류 생성
'######################
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx = oJSONoutput.IDX
	End if	

	If hasown(oJSONoutput, "GB") = "ok" then
		sgb = oJSONoutput.GB
	Else
		Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End	
	End If

		If hasown(oJSONoutput, "GBSUB") = "ok" then
		sgbsub = oJSONoutput.GBSUB
	End if

	Set db = new clsDBHelper
	'중복값확인
	SQL = "select tidx from K_titleList where title = '"&sgb&"'  and (subtitle = '"&sgbsub&"')"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof then
		Call oJSONoutput.Set("result", "2" ) '중복
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End	
	End if


	'생성
	SQL = " insert into K_titleList (title,subtitle) values ('"&sgb&"', '"&sgbsub&"')" 
	Call db.execSQLRs(SQL , null, ConStr)

	SQL = "Select title from K_titleList where delYN = 'N' group by title order by title"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End If

	SQL = "Select tidx,subtitle from K_titleList where delYN = 'N' and title = '"&sgb&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrSub = rs.GetRows()
	End If

	If idx <> "" then
		sfield = "SportsGb,SportsGbSub,GameTitle,GameType,Sido,zipcode,addr,Stadium,GameYear,GameS,GameE,Gamedatecnt,GameHost,GameOrganize"
		sfield = sfield & ",VOD1,VOD2,VOD3,VOD4,VOD5,m_videoDate,h_videoDate,ip"
		SQL = "Select top 1 GIDX,"&sfield&" from K_gameinfo where delYN = 'N' and GIDX =" & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof then
			GameTitle = rs("GameTitle")
			gametype = rs("GameType")
		End if
	End if


	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/ksports/ul01.asp" -->