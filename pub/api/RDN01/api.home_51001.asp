<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'수정
'#############################################
	'request
	svalue = oJSONoutput.get("SS")
	levelidx = oJSONoutput.get("LEVELIDX")
	attpidx = oJSONoutput.get("PIDX")	'선수 아이디도 받자 공통으로 쓸려면 (본인선수 또는 지정한선수)

	'참가가능 룰체크 함수들
	%><!-- #include virtual = "/pub/fn/riding/fn.attendCheckRull.asp" --><%

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
		teamgb = levelinfoarr(7)

		'제외할말 인덱스들'
		htopidxs = isnulldefault(MaxHorseToPerson(tidx,gbidx,horselimit,"H"),"")
		'제외할말 인덱스들'
		ptohidxs = isnulldefault(MaxPersonToHorse(tidx,gbidx,horselimit,"H"),"")

		if htopidxs <> "" Then
			exceptidxs = htopidxs
			if ptohidxs <> "" Then
				exceptidxs = exceptidxs & "," & ptohidxs
			end if
		Else
			exceptidxs = ptohidxs
		end if

		if exceptidxs <> "" Then
			exceptidxwhere = " and playeridx not in ("&exceptidxs&")"
		end if

'response.write exceptidxwhere & "**"
	'기승제한$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	'참가자격제한$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		chkidxsarr = setLimitRule(teamgbnm,classno,wherehorsetype,"H")
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

	'참가신청내역 조회 (사용자 + 말이 동일한지 검사)$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		' tblgamerequest (참가신청)
		' tblgamerequest_r (릴레이선수)
		'attpidx 의 참가신청한 말이 있다면 빼자.



		'릴레이코스트처리
		if TeamGb = "20208" Then '릴레이코스경기   3인 1마로 말중복만 검색하자.
			strWhere = " a.gametitleidx = '"&tidx&"' and  gbIDX = '"&gbidx&"' and (a.P1_PlayerIDX in ("&attpidx&") or b.playeridx in ("&attpidx&")) group by P2_PlayerIDX for xml path('') "
			SQL = ""
			SQL = SQL & "select stuff("
			SQL = SQL & "("

			SQL = SQL & "SELECT  ',' + cast(P2_PlayerIDX as varchar) from tblGameRequest as a left join tblGameRequest_r as b On a.RequestIDX = b.RequestIDX and b.DelYN = 'N' where " & strWhere

			SQL = SQL & ") ,1,1,'' "
			SQL = SQL & ")"
		Else
			strWhere = " a.gametitleidx = '"&tidx&"' and  gbIDX = '"&gbidx&"' and (a.P1_PlayerIDX = '"&attpidx&"' or b.playeridx = '"&attpidx&"') group by P2_PlayerIDX for xml path('') "
			SQL = ""
			SQL = SQL & "select stuff("
			SQL = SQL & "("

			SQL = SQL & "SELECT  ',' + cast(P2_PlayerIDX as varchar) from tblGameRequest as a left join tblGameRequest_r as b On a.RequestIDX = b.RequestIDX and b.DelYN = 'N' where " & strWhere

			SQL = SQL & ") ,1,1,'' "
			SQL = SQL & ")"
		end if
		Set rs = db.ExecSQLReturnRS(SQL,null, ConStr)

		if rs.eof Then
			attidxs = ""
		Else
			attidxs = rs(0)
		end if

		if attidxs <> "" Then
			exceptattidxwhere = " and playeridx not in ("&attidxs&")"
		end if

	'참가신청내역 조회 (사용자 + 말이 동일한지 검사)$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

		'말정보 tblPlayer
		SQL = "Select top 10 playeridx,hpassport,username from tblPlayer where DelYN= 'N' and usertype='H' and username like '%" & svalue & "%' " & exceptidxwhere & boochkwhere & exceptattidxwhere
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
		hpassport = arrH(1,ari)
		hname = arrH(2,ari)

		response.write "<tr onclick=""mx.setHorseInfo(this,'"&hidx&"','"&hpassport&"','"&hname&"','"&levelidx&"')""><th>"&hname&"</th><td>"&hpassport&"</td></tr>"
	Next
	end if
%>
