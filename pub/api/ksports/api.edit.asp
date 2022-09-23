<%
'######################
'수정항목불러오기
'######################
	datareq = True
	
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx = oJSONoutput.IDX
	Else
		datareq = False
	End If

	If datareq = False then
		Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End	
	End If


	Set db = new clsDBHelper

	SQL = "Select title from K_titleList where delYN = 'N' group by title order by title "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End If



	SQL = "Select idx,name from K_openList where delYN = 'N' and gubun = 1"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrH = rs.GetRows()
	End If

	SQL = "Select idx,name from K_openList where delYN = 'N' and gubun = 2"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrO = rs.GetRows()
	End If

	sfield = "SportsGb,SportsGbSub,GameTitle,GameType,Sido,zipcode,addr,Stadium,GameYear,GameS,GameE,Gamedatecnt,GameHost,GameOrganize"
	sfield = sfield & ",VOD1,VOD2,VOD3,VOD4,VOD5,VOD6,m_videoDate,h_videoDate,ip   ,e_videoDate,c_videoDate,d_videoDate,x_videoDate"
	SQL = "Select top 1 GIDX,"&sfield&" from K_gameinfo where GIDX =" & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	k_shotcnt = 0
	If Not rs.eof then
		idx = rs("GIDX")
		sgb = rs("SportsGb")


		SQL = "Select tidx,subtitle from K_titleList where delYN = 'N' and title = '"&sgb&"' "
		Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rss.EOF Then 
			arrSub = rss.GetRows()
		End If

		sgbsub = rs("SportsGbSub")
		GameTitle = rs("GameTitle")
		gametype = rs("GameType")
		sido = rs("Sido")
		zipcode = rs("zipcode")
		gameaddr = rs("addr")
		stadium = rs("Stadium")
		GameYear = rs("GameYear")

		GameS = Left(rs("GameS"),10)
		GameE = Left(rs("GameE"),10)
		Gamedatecnt = rs("Gamedatecnt")
		newname = rs("GameHost")
		newname2 = rs("GameOrganize")
		VOD1 = rs("VOD1")
		VOD2 = rs("VOD2")
		VOD3 = rs("VOD3")
		VOD4 = rs("VOD4")
		VOD5 = rs("VOD5")
		VOD6 = rs("VOD6")
		k_mvod = rs("m_videoDate")
		k_hvod = rs("h_videoDate")

		k_evod = rs("e_videoDate")
		k_cvod = rs("c_videoDate")
		k_dvod = rs("d_videoDate")
		k_xvod = rs("x_videoDate")

		k_ip = rs("ip")

		emode ="e"

		If k_mvod <> "" Then
			k_shotcnt = CDbl(ubound(Split(k_mvod,","))) + 1
		End If
		If k_hvod <> "" Then
			k_shotcnt = CDbl(k_shotcnt) +CDbl(ubound(Split(k_hvod,","))) + 1
		End if							

		If k_evod <> "" Then
			k_shotcnt = CDbl(k_shotcnt) +CDbl(ubound(Split(k_evod,","))) + 1
		End if						
		If k_cvod <> "" Then
			k_shotcnt = CDbl(k_shotcnt) +CDbl(ubound(Split(k_cvod,","))) + 1
		End if						
		If k_dvod <> "" Then
			k_shotcnt = CDbl(k_shotcnt) +CDbl(ubound(Split(k_dvod,","))) + 1
		End if						
		If k_xvod <> "" Then
			k_shotcnt = CDbl(k_shotcnt) +CDbl(ubound(Split(k_xvod,","))) + 1
		End if						



		k_VOD = k_VOD1& k_VOD2 & k_VOD3 & k_VOD4 & k_VOD5
	End if

	db.Dispose
	Set db = Nothing
%>						


<!-- #include virtual = "/pub/html/ksports/inputform.asp" -->