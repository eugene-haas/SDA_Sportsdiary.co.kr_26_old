<%
'######################
'등록
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
	If hasown(oJSONoutput, "SGBSUB") = "ok" then
		sgbsub = oJSONoutput.SGBSUB
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
	If hasown(oJSONoutput, "HOST") = "ok" then
		gamehost = oJSONoutput.HOST
	Else
		datareq = False
	End if	
	If hasown(oJSONoutput, "ORG") = "ok" then
		org = oJSONoutput.ORG
	Else
		datareq = False
	End if	
	'##############################
	If hasown(oJSONoutput, "VOD") = "ok" then
		vod = oJSONoutput.VOD
	Else
		datareq = False
	End if	

	If hasown(oJSONoutput, "EDATE") = "ok" then
		escdate = Replace(oJSONoutput.EDATE,Chr(34), "")
	End if	

	If hasown(oJSONoutput, "MDATE") = "ok" then
		mscdate = Replace(oJSONoutput.MDATE,Chr(34), "")
	End if	

	If hasown(oJSONoutput, "HDATE") = "ok" then
		hscdate = Replace(oJSONoutput.HDATE,Chr(34),"")
	End if	

	If hasown(oJSONoutput, "CDATE") = "ok" then
		cscdate = Replace(oJSONoutput.CDATE,Chr(34),"")
	End if	

	If hasown(oJSONoutput, "DDATE") = "ok" then
		dscdate = Replace(oJSONoutput.DDATE,Chr(34),"")
	End if	

	If hasown(oJSONoutput, "XDATE") = "ok" then
		xscdate = Replace(oJSONoutput.XDATE,Chr(34),"")
	End if	


	If datareq = False then
		Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End	
	End If


	Set db = new clsDBHelper
	'업데이트
	If gamee <> "" and games <> "" then
	gamecnt = CDate(gamee) - CDate(games) + 1
	yy = year(games)
	Else
	gamecnt = 0
	yy = year(date)
	End if

	
	updatefield = "SportsGb='"&sgb&"',SportsGbSub='"&sgbsub&"',GameTitle='"&title&"',GameType='"&gtype&"' "
	updatefield = updatefield & ",Sido='"&sido&"',zipcode='"&zipcode&"',addr='"&addr&"',Stadium='"&stadium&"' "
	updatefield = updatefield & ",GameYear='"&yy&"',GameS='"&games&"',GameE='"&gamee&"',Gamedatecnt='"&gamecnt&"',GameHost='"&gamehost&"',GameOrganize='"&org&"'"
	updatefield = updatefield & ",VOD1='"&Left(vod,1)&"',VOD2='"&Mid(vod,2,1)&"',VOD3='"&Mid(vod,3,1)&"',VOD4='"&Mid(vod,4,1)&"',VOD5='"&Mid(vod,5,1)&"',VOD6='"&Mid(vod,6,1)&"' "
	updatefield = updatefield & ",m_videoDate='"&mscdate&"',h_videoDate='"&hscdate&"',ip='"&USER_IP&"'"

	updatefield = updatefield & ",e_videoDate='"&escdate&"',c_videoDate='"&cscdate&"',d_videoDate='"&dscdate&"',x_videoDate='"&xscdate&"'      "

	SQL = " update K_gameinfo Set "&updatefield&" where GIDX = " & idx 
	Call db.execSQLRs(SQL , null, ConStr)




	'############
	sfield = "SportsGb,SportsGbSub,GameTitle,GameType,Sido,zipcode,addr,Stadium,GameYear,GameS,GameE,Gamedatecnt,GameHost,GameOrganize"
	sfield = sfield & ",VOD1,VOD2,VOD3,VOD4,VOD5,VOD6,m_videoDate,h_videoDate,ip   ,e_videoDate,c_videoDate,d_videoDate,x_videoDate "
	SQL = "Select top 1 GIDX,"&sfield&" from K_gameinfo where delYN = 'N' and GIDX =" & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	k_shotcnt = 0
	Do Until rs.eof
		k_idx = rs("GIDX")
		k_sgb = rs("SportsGb")
		k_sgbsub = rs("SportsGbSub")
		k_title = rs("GameTitle")
		k_gametype = rs("GameType")
		k_sido = rs("Sido")
		k_zipcode = rs("zipcode")
		k_addr = rs("addr")
		k_Stadium = rs("Stadium")
		k_GameYear = rs("GameYear")

		k_GameS = Replace(Left(rs("GameS"),10),"-",".")
		k_GameE = Replace(Left(rs("GameE"),10),"-",".")
		k_Gamedatecnt = rs("Gamedatecnt")
		k_GameHost = rs("GameHost")
		k_GameOrganize = rs("GameOrganize")
		k_VOD1 = rs("VOD1")
		k_VOD2 = rs("VOD2")
		k_VOD3 = rs("VOD3")
		k_VOD4 = rs("VOD4")
		k_VOD5 = rs("VOD5")
		k_VOD6 = rs("VOD6")
		k_mvod = rs("m_videoDate")
		k_hvod = rs("h_videoDate")

		k_evod = rs("e_videoDate")
		k_cvod = rs("c_videoDate")
		k_dvod = rs("d_videoDate")
		k_xvod = rs("x_videoDate")

		
		
		k_ip = rs("ip")


		
		
		
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


'		If k_evod <> "" Then
'			vodallstr = k_evod
'		End if
'		If k_mvod <> "" Then
'			If vodallstr = "" then
'				vodallstr = k_mvod
'			Else
'				vodallstr = vodallstr & "," & k_mvod
'			End if
'		End If
'		If k_hvod <> "" Then
'			If vodallstr = "" then
'				vodallstr = k_hvod
'			Else
'				vodallstr = vodallstr & "," & k_hvod
'			End if
'		End if
'		If k_cvod <> "" Then
'			If vodallstr = "" then
'				vodallstr = k_cvod
'			Else
'				vodallstr = vodallstr & "," & k_cvod
'			End if
'		End if
'		If k_dvod <> "" Then
'			If vodallstr = "" then
'				vodallstr = k_dvod
'			Else
'				vodallstr = vodallstr & "," & k_dvod
'			End if
'		End if
'		If k_xvod <> "" Then
'			If vodallstr = "" then
'				vodallstr = k_xvod
'			Else
'				vodallstr = vodallstr & "," & k_xvod
'			End if
'		End if
'
'		If vodallstr = "" Then
'			k_shotcnt = 0
'		else
'			arrData = Split(vodallstr,",")
'			arrTmp = FnDistinctData(arrData)
'			k_shotcnt = Ubound(arrTmp) + 1
'		End if



		k_VOD = k_VOD1& k_VOD2 & k_VOD3 & k_VOD4 & k_VOD5 & k_VOD6

		%><!-- #include virtual = "/pub/html/ksports/onelinelist.asp" --><%
	  rs.movenext
	  Loop
	  Set rs = Nothing

	db.Dispose
	Set db = Nothing
%>						
