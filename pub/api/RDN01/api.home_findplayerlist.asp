<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'선수목록 검색
'#############################################
	'request
	svalue = oJSONoutput.get("SS") '검색단어  선수
	levelidx = oJSONoutput.get("LEVELIDX")
	'attpidx = oJSONoutput.get("PIDX")	'선수검색이다.

	'참가가능 룰체크 함수들
	%><!-- #include virtual = "/pub/fn/riding/fn.attendCheckRull.asp" --><%


	If CStr(Len(svalue)) < 1 Then
		Response.end
	End if

	Set db = new clsDBHelper

	'기승제한$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		levelinfoarr =  GameLevelInfo(levelidx)
		gbidx = levelinfoarr(0)
		tidx = levelinfoarr(1)
		horselimit = levelinfoarr(2)
		playerlimit	 = levelinfoarr(3)
		teamgbnm	 = levelinfoarr(4)
		classno	 = levelinfoarr(5)
		wherehorsetype	 = levelinfoarr(6)

		'제외할 인덱스들'
		htopidxs = isnulldefault(MaxHorseToPerson(tidx,gbidx,playerlimit,"P"),"")
		'제외할 인덱스들'
		ptohidxs = isnulldefault(MaxPersonToHorse(tidx,gbidx,playerlimit,"P"),"")

		if htopidxs <> "" Then
			exceptidxs = htopidxs
			if ptohidxs <> "" Then
				exceptidxs = exceptidxs & "," & htopidxs
			end if
		Else
			exceptidxs = ptohidxs
		end if

		if exceptidxs <> "" Then
			exceptidxwhere = " and playeridx not in ("&exceptidxs&")"
		end if
	'기승제한$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	'참가자격제한$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		chkidxsarr = setLimitRule(teamgbnm,classno,wherehorsetype,"P")
		chkidxs = isnulldefault(chkidxsarr(0),"")
		attokYN = isnulldefault(chkidxsarr(1),"")

		if chkidxs = "" Then
			boochkwhere = ""
		Else
			select case attokYN
			case "" '조건이 없을때'
				boochkwhere = " "
			case "Y"
				boochkwhere = " and playeridx in ("&chkidxs&")"
			case "N"
				boochkwhere = " and playeridx not in ("&chkidxs&")"
			end select
		end if
	'참가자격제한$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

		'말정보 tblPlayer
		SQL = "Select top 10 playeridx,ksportsno,username from tblPlayer where nowyear = '"&year(date)&"' and DelYN= 'N' and usertype='P' and username like '%" & svalue & "%' " & exceptidxwhere & boochkwhere ''& exceptattidxwhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrH = rs.GetRows()
		End If




	db.Dispose
	Set db = Nothing

	if IsArray(arrH) then
	n = 1
	For ari = LBound(arrH, 2) To UBound(arrH, 2)
		hidx = arrH(0,ari)
		ksportsno = arrH(1,ari)
		hname = arrH(2,ari)

		response.write "<tr  onclick=""mx.setPlayerInfo(this,'"&hidx&"','"&ksportsno&"','"&hname&"','"&levelidx&"')""><th>"&hname&"</th><td>"&ksportsno&"</td></tr>"
	Next
	end if
%>
