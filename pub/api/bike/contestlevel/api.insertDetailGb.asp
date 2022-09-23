<%
'######################
'중분류 생성,선택
'######################

	If hasown(oJSONoutput, "IDX") = "ok" then
		idx = oJSONoutput.IDX
	End if

	If hasown(oJSONoutput, "GB") = "ok" then
		stitle = oJSONoutput.GB
	Else
		Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.End
	End If

	If hasown(oJSONoutput, "GBSUB") = "ok" then
		ssubtitle = oJSONoutput.GBSUB
	End If

	If hasown(oJSONoutput, "GBDETAIL") = "ok" then
		sdetailtitle = oJSONoutput.GBDETAIL
	End if


	Set db = new clsDBHelper


	If CStr(CMD) = CStr(CMD_INSERTDETAILGB) then
		'중복값확인
		SQL = "select top 1 levelno,title from sd_titleList where title='"&stitle&"' and subtitle = '"&ssubtitle&"' and detailtitle = '"&sdetailtitle&"' order by levelno"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof then
			Call oJSONoutput.Set("result", "2" ) '중복
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Response.End
		End if

		'생성
		SQL = " insert into sd_titleList (title,subtitle,detailtitle) values ('"&stitle&"', '"&ssubtitle&"','"&sdetailtitle&"')"
		Call db.execSQLRs(SQL , null, ConStr)
	End if

	'############

	SQL = "Select levelno,title,subtitle,detailtitle from sd_titleList where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End If

    '부 리스트
    SQL = "Select idx,name from sd_openList where delYN = 'N' and gubun = 2"
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    If Not rs.EOF Then
        arrD = rs.GetRows()
    End If


	If idx <> "" Then '수정상태라면
'		sfield = "SportsGb,SportsGbSub,GameTitle,GameType,Sido,zipcode,addr,Stadium,GameYear,GameS,GameE,Gamedatecnt,GameHost,GameOrganize"
'		sfield = sfield & ",VOD1,VOD2,VOD3,VOD4,VOD5,m_videoDate,h_videoDate,ip"
'		SQL = "Select top 1 GIDX,"&sfield&" from K_gameinfo where delYN = 'N' and GIDX =" & idx
'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'		If Not rs.eof then
'			GameTitle = rs("GameTitle")
'			gametype = rs("GameType")
'		End if
	End if


	db.Dispose
	Set db = Nothing
%>

<!-- #include virtual = "/pub/html/bike/ul01_cl2.asp" -->
