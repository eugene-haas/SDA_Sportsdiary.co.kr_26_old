<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'조건을 검사해서 참가신청한다.
'#############################################
	'request
	attpidx = oJSONoutput.Get("PIDX") '참가선수 (본인 또는 대리인이 신청한 내역)
	hidx = oJSONoutput.Get("HIDX") '참가말
	hnm = oJSONoutput.Get("HNM") '참가말명
	pubcode = oJSONoutput.Get("PUBCODE") '부코드'
	levelidx = oJSONoutput.Get("LEVELIDX")
	gubuntype = oJSONoutput.Get("GUBUNTYPE") '신청구분 return  시켜 재호출시킨다.
	relayteam = oJSONoutput.Get("RELAYTEAMNM") '릴레이 팀명칭

	Select Case Left(gubuntype ,1)
	Case "1" : atttype = "A"
	Case "2" : atttype = "B"
	Case "3" : atttype = "C"
	End Select

	''로그인 체크
	 If login = False Then
	 	Call oJSONoutput.Set("result", "9" )
	 	strjson = JSON.stringify(oJSONoutput)
	 	Response.Write strjson
	 	Response.end
	 End if

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
        levelno = levelinfoarr(8)
        levelnm = levelinfoarr(9)
        ridingclass = levelinfoarr(10)
        ridingclasshelp = levelinfoarr(11)



		pubinfoarr = getPubInfo(pubcode)
		engcode = pubinfoarr(1)
        pubname = pubinfoarr(2)

		if TeamGb <> "20208" Then '릴레이코스경기제외  3인 1마로 말중복만 검색하자.
			'제외할말 인덱스들___________________________________________'
			htopidxs = MaxHorseToPerson(tidx,gbidx,horselimit,"H")
			'제외할말 인덱스들'
			ptohidxs = MaxPersonToHorse(tidx,gbidx,horselimit,"H")

			if htopidxs <> "" Then
				exceptidxs = htopidxs
				if ptohidxs <> "" Then
					exceptidxs = exceptidxs & "," & htopidxs
				end if
			Else
				exceptidxs = ptohidxs
			end if

			if exceptidxs <> "" Then
				if instr(exceptidxs, hidx) > 0 Then
					Call oJSONoutput.Set("result", "21" ) '선수나 말이 참가 조건에 충족하지 않습니다.
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					response.end
				end if
			end if

			'제외할선수 인덱스들__________________________________________'
			htopidxs = MaxHorseToPerson(tidx,gbidx,horselimit,"P")
			'제외할선수 인덱스들'
			ptohidxs = MaxPersonToHorse(tidx,gbidx,horselimit,"P")

			if htopidxs <> "" Then
				exceptidxs = htopidxs
				if ptohidxs <> "" Then
					exceptidxs = exceptidxs & "," & htopidxs
				end if
			Else
				exceptidxs = ptohidxs
			end if

			if exceptidxs <> "" Then
				if instr(exceptidxs, attpidx) > 0 Then
					Call oJSONoutput.Set("result", "21" ) '선수나 말이 참가 조건에 충족하지 않습니다.
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					response.end
				end if
			end if
		end if
	'기승제한$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


	'참가자격제한$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		chkidxsarr = setLimitRule(teamgbnm,classno,wherehorsetype,"H") '제외 또는 포함할 말 인덱스를 구한다.
		chkidxs = chkidxsarr(0)
		attokYN = chkidxsarr(1)

		if chkidxs = "" Then
			boochkwhere = ""
		Else
			select case attokYN
			case "" '조건이 없을때'
					'조합에 충족
			case "Y"
				if instr(chkidxs, hidx) > 0 Then
					'조합에 충족
				else
					Call oJSONoutput.Set("result", "21" ) '선수나 말이 참가 조건에 충족하지 않습니다.
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					response.end
				end if
			case "N"
				if instr(chkidxs, hidx) > 0 Then
					Call oJSONoutput.Set("result", "21" ) '선수나 말이 참가 조건에 충족하지 않습니다.
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					response.end
				end if
			end select
		end if


		'_____________________________________________________________
		chkidxsarr = setLimitRule(teamgbnm,classno,wherehorsetype,"P")  '제외 또는 포함할 선수 인덱스를 구한다.
		chkidxs = chkidxsarr(0)
		attokYN = chkidxsarr(1)

		if chkidxs = "" Then
			boochkwhere = ""
		Else
			select case attokYN
			case "" '조건이 없을때 (생성안한경우)
					'조합에 충족
			case "Y"
				if TeamGb = "20208" Then '릴레이코스경기   3인 1마로 말중복만 검색하자.
					attidxrelay = split(attpidx,",")
					if instr(chkidxs, attidxrelay(0)) > 0 and instr(chkidxs, attidxrelay(1)) > 0 and instr(chkidxs, attidxrelay(2)) > 0 Then
						'조합에 충족
					else
						Call oJSONoutput.Set("result", "21" ) '선수나 말이 참가 조건에 충족하지 않습니다.
						strjson = JSON.stringify(oJSONoutput)
						Response.Write strjson
						response.end
					end if
				Else
					if instr(chkidxs, attpidx) > 0 Then
						'조합에 충족
					else
						Call oJSONoutput.Set("result", "21" ) '선수나 말이 참가 조건에 충족하지 않습니다.
						strjson = JSON.stringify(oJSONoutput)
						Response.Write strjson
						response.end
					end if
				end if

			case "N"
				if TeamGb = "20208" Then '릴레이코스경기   3인 1마로 말중복만 검색하자.
					attidxrelay = split(attpidx,",")
					if instr(chkidxs, attidxrelay(0)) > 0 or instr(chkidxs, attidxrelay(1)) > 0 or instr(chkidxs, attidxrelay(2)) > 0 Then
						Call oJSONoutput.Set("result", "21" ) '선수나 말이 참가 조건에 충족하지 않습니다.
						strjson = JSON.stringify(oJSONoutput)
						Response.Write strjson
						response.end
				end if
				Else
					if instr(chkidxs, attpidx) > 0 Then
						Call oJSONoutput.Set("result", "21" ) '선수나 말이 참가 조건에 충족하지 않습니다.
						strjson = JSON.stringify(oJSONoutput)
						Response.Write strjson
						response.end
					end if
				end if
			end select
		end if

	'참가자격제한$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	'참가신청내역 조회 (사용자 + 말 검사)$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		' tblgamerequest (참가신청)
		' tblgamerequest_r (릴레이선수)
		'attpidx + hidx
		if TeamGb = "20208" Then '릴레이코스경기   3인 1마로 말중복만 검색하자.
		strWhere = " a.gametitleidx = '"&tidx&"' and  gbIDX = '"&gbidx&"' and (a.P1_PlayerIDX in ("&attpidx&") or b.playeridx in ("&attpidx&")) and (a.P2_PlayerIDX = '"&hidx&"' ) "
		Else
		strWhere = " a.gametitleidx = '"&tidx&"' and  gbIDX = '"&gbidx&"' and (a.P1_PlayerIDX = '"&attpidx&"' or b.playeridx = '"&attpidx&"') and (a.P2_PlayerIDX = '"&hidx&"' ) "
		end if
		SQL = "SELECT  a.RequestIDX from tblGameRequest as a left join tblGameRequest_r as b On a.RequestIDX = b.RequestIDX and b.DelYN = 'N' where " & strWhere
		Set rs = db.ExecSQLReturnRS(SQL,null, ConStr)
		if rs.eof Then
			'패스
		Else
			Call oJSONoutput.Set("result", "21" ) '선수나 말이 참가 조건에 충족하지 않습니다.
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			response.end
		end if
	'참가신청내역 조회 (사용자 + 말 검사)$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




	'다 통과 했다면 참가 신청 시키자 (결제 정보 에도 넣고)
	'att_username,att_userphone,att_paymentDt,att_paymentNm,att_paymentType 결제자 정보
	a_username = session_uid
	a_userphone = session_upno
	a_paymentdt = ""
	a_paymentnm = session_unm '입금자명
	a_paymenttype = "N" 'C ,P, B 카드 폰, 무통장 결제안됨으로 넣는다.


	call attendInsert(tidx,gbidx,attpidx,pubcode,engcode,pubname,hidx,teamgb,levelno,TeamGbNm ,a_username,a_userphone,a_paymentdt,a_paymentnm,a_paymenttype,relayteam, atttype)
	'복합마술은 마장마술만 불러오므로 장애물도 불러서 넣어주어야한다.

	if teamgb = "20103" then '복합마술이라면
		'받아온  gbidx는 마장마술 입니다. 장애물 gbidx를 찾아서 동일하게 인서트 하여야 합니다.
		SQL = "select  a.GbIDX from tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx where gametitleidx = "&tidx&" and b.TeamGb = '20103' and a.pubcode="&pubcode&" and  b.ridingclass like '%장애물'"
		Set rs = db.ExecSQLReturnRS(SQL,null, ConStr)

		jang_gibidx = rs(0)
		call attendInsert(tidx,jang_gibidx,attpidx,pubcode,engcode,pubname,hidx,teamgb,levelno,TeamGbNm ,a_username,a_userphone,a_paymentdt,a_paymentnm,a_paymenttype,relayteam ,atttype)
	end if


	'결제정보저장은 이거 앞에서 하고 호출해야한다.



	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>
