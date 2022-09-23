<%
'#############################################

'참가자 리스트 요청

'#############################################
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If

	If hasown(oJSONoutput, "GAMENO") = "ok" Then
		gameno = oJSONoutput.GAMENO
	End If

	If hasown(oJSONoutput, "JOONO") = "ok" Then
		joono = oJSONoutput.JOONO
	End If


	Set db = new clsDBHelper




	wherestr = " where a.GameTitleIDX = "&tidx&" and (a.gameno = '"&gameno&"' or a.gameno2 = '"&gameno&"' ) "
	SQL = "select top 1 starttype from tblRGameLevel as a inner join sd_gameMember as b on a.GameTitleIDX  = b.gametitleidx and a.GbIDX = b.gbIDX and a.DelYN = 'N' and b.DelYN = 'N' "
	SQL = SQL & " inner join sd_gameMember_partner as c On b.gamememberidx = c.gamememberidx and c.delYN = 'N' " & wherestr & "  "

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		starttype = rs(0)
	End if


	fld = " a.gametitlename,CDBNM,CDCNM,sexno "

	'fld = fld & ",case when (b.gameno = '"&gameno&"' and b.gubunam = '1') or (b.gameno2 = '"&gameno &"' and gubunam = '1' ) then '예선' when (b.gameno = '"&gameno&"' and gubunam = '3') or (b.gameno2 = '"&gameno &"' and gubunam = '3') then '결승' end"
	'수정 	예선 결승 구분 gubunam , gubunpm 각 1예선 3결승
	fld = fld & ",case when (b.gameno = '"&gameno&"' and b.gubunam = '1') or (b.gameno2 = '"&gameno &"' and gubunpm = '1' ) then '예선' else '결승' end"

	fld = fld & ",(case when (b.gameno = '"&gameno&"') then tryoutgamestarttime when (b.gameno2 = '"&gameno &"') then finalgamestarttime end) as starttm"
	fld = fld & ",ITGUBUN, b.cdc, a.titlecode "

	'공통정보 따로 가져오기
	SQL = "Select top 1 "&fld&" from sd_gameTitle as a INNER JOIN tblRGameLevel as b ON a.gametitleIDX = b.gametitleIDX and a.delYN = 'N' and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and (b.gameno = '"&gameno&"' or b.gameno2 = '"&gameno&"') "

	
'	Response.write sql
'	Response.end
	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		gametitle = rs(0)
		cdbnm = rs(1)
		cdcnm = rs(2)
		sexno = rs(3)
		If starttype = "3" Then
			gubun = "결승"
		else
			gubun = rs(4)
		End if
		starttime = rs(5)
		itgubun = rs(6)
		cdc = rs(7)
		titlecode = rs(8)

		Call oJSONoutput.Set("TITLE", gametitle )
		Call oJSONoutput.Set("CDB", cdbnm )
		Call oJSONoutput.Set("CDC", cdcnm )
		Call oJSONoutput.Set("GAMESEX", sexno )
		Call oJSONoutput.Set("GN", gubun )
		Call oJSONoutput.Set("STARTTM", starttime )
		Call oJSONoutput.Set("IORT", ITgubun )

		'####################
		'R01	대회유년
		'R02	대회초등
		'R03	대회중등
		'R04	대회고등
		'R05	대회대학
		'R06	대회일반

		'R07	한국기록
		'R08	일반-참가기록

	Function getRcode(rstr)
		If InStr(rstr, "유년") > 0 Then
			getRcode = "R01"
		ElseIf InStr(rstr, "초등") > 0 Then
			getRcode = "R02"
		ElseIf InStr(rstr, "중등") > 0 Then
			getRcode = "R03"
		ElseIf InStr(rstr, "고등") > 0 Then
			getRcode = "R04"
		ElseIf InStr(rstr, "대학") > 0 Then
			getRcode = "R05"
		ElseIf InStr(rstr, "일반") > 0 Then
			getRcode = "R06"
		End if
	End Function
	rcode = getRcode(cdbnm)

		'한국기록 //한국기록:양재훈(강원도청, 2019광주세계수영선수권대회, 2019) 00:22.26
			SQL = "select top 1 username,teamnm,titlename,gamedate,gameresult from tblRecord  where rctype= 'R07' and cdc = '"&cdc&"' and Sex= '"&sexno&"' and delYN = 'N'  order by rcIDX desc "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If not rs.eof Then
				knm = rs("username")
				kteamnm = rs("teamnm")
				ktitle = rs("titlename")
				kyear = Left(rs("gamedate"),4)
				krc = rs("gameresult")
			End if

			Call oJSONoutput.Set("KNM", knm )
			Call oJSONoutput.Set("KTEAMNM", kteamnm )
			Call oJSONoutput.Set("KTITLE", ktitle )
			Call oJSONoutput.Set("KYEAR", kyear )
			Call oJSONoutput.Set("KRC", krc )

		'대회기록 //대회기록:길현중(목운초등학교, 2018MBC배전국수영대회(경영), 2018) 00:28.61
			SQL = "select top 1 username,teamnm,titlename,gamedate,gameresult from tblRecord  where titlecode = '"&titlecode&"' and rctype= '"&rcode&"' and cdc = '"&cdc&"' and Sex= '"&sexno&"' and delYN = 'N' order by rcIDX desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'select top 1 username,teamnm,titlename,gamedate,gameresult from tblRecord  where titlecode = '' and rctype= 'R04' and cdc = '01' and Sex= '1' and delYN = 'N' order by rcIDX desc
'Response.write sql

			If not rs.eof Then
				gnm = rs("username")
				gteamnm = rs("teamnm")
				gtitle = rs("titlename")
				gyear = Left(rs("gamedate"),4)
				grc = rs("gameresult")
			End if

			Call oJSONoutput.Set("GNM", gnm )
			Call oJSONoutput.Set("GTEAMNM", gteamnm )
			Call oJSONoutput.Set("GTITLE", gtitle )
			Call oJSONoutput.Set("GYEAR", gyear )
			Call oJSONoutput.Set("GRC", grc )
		'###################################################

	Else
		Call oJSONoutput.Set("result", 99 ) '조회정보 없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	End if


	Select Case  ITgubun

	'MIDX gameMemberIDX + A(am) OR B(pm)
	Case "I" '개인전

		fld = " ( cast(b.gameMemberIDX as varchar)  + case when (a.gameno = '"&gameno&"') then 'A' when (a.gameno2 = '"&gameno &"') then 'B' end) as MIDX"
		fld = fld & "   ,b.username as NAME,b.TeamNm as TEAM,b.sex as SEX,sidonm as SIDO,userClass as GRADE "

		fld = fld & ",(case when (a.gameno = '"&gameno&"' and a.gubunam = '1') or  (a.gameno2 = '"&gameno&"' and a.gubunpm = '1') or (b.starttype = 3) then tryoutgroupno  else roundNo  end) as JOO "
		fld = fld & ", (case when (a.gameno = '"&gameno&"' and a.gubunam = '1') or  (a.gameno2 = '"&gameno&"' and a.gubunpm = '1') or (b.starttype = 3) then tryoutsortNo  else sortno end ) as RANE  "
		fld = fld & ", '1' as ODRNO "
		fld = fld & ",(case when (a.gameno = '"&gameno&"') then isnull(tryoutResult,'') when (a.gameno2 = '"&gameno &"') then isnull(gameResult,'') end) as GAMERESULT"

		wherestr = " where a.GameTitleIDX = "&tidx&" and (a.gameno = '"&gameno&"' or a.gameno2 = '"&gameno&"') "
		SQL = ";with tbl as ( Select "&fld&" from tblRGameLevel as a inner join sd_gameMember as b on a.GameTitleIDX  = b.gametitleidx and a.GbIDX = b.gbIDX and a.DelYN = 'N' and b.DelYN = 'N' " & wherestr & " )  "
		SQL = SQL & " select * from tbl where Joo = '"&joono&"'  order by RANE , ODRNO "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		list = jsonTors_arr(rs)
		Set list = JSON.Parse( join(array(list)) )

		Call oJSONoutput.Set("LIST", list )
		Call oJSONoutput.Set("result", 0 )



	Case "T" '단체전
		'MIDX gameMemberIDX + partnerIDX +  A(am) OR B(pm)
		'기존룰
		if rullorigin = true then

						fld = " ( cast(b.gameMemberIDX as varchar) + '_' + cast(c.partnerIDX as varchar)  + case when (a.gameno = '"&gameno&"') then 'A' when (a.gameno2 = '"&gameno &"') then 'B' end) as MIDX"
						fld = fld & "   ,c.username as NAME, c.TeamNm as TEAM, c.sex as SEX, sidonm as SIDO, c.userClass as GRADE "
						fld = fld & ",(case when (a.gameno = '"&gameno&"' and a.gubunam = '1') or  (a.gameno2 = '"&gameno&"' and a.gubunpm = '1') or (b.starttype = 3) then tryoutgroupno  else roundNo  end) as JOO "
						fld = fld & ",(case when (a.gameno = '"&gameno&"') then isnull(gameresultA,'') when (a.gameno2 = '"&gameno &"') then isnull(gameresultB,'') end) as GAMERESULT"


						'수정 	예선 결승 구분 gubunam , gubunpm 각 1예선 3결승 레인번호 표출안되서 수정 2020-11-13
						fld = fld & ", (case when (a.gameno = '"&gameno&"' and a.gubunam = '1') or  (a.gameno2 = '"&gameno&"' and a.gubunpm = '1') or (b.starttype = 3) then tryoutsortNo  else sortno end ) as RANE  "
						fld = fld & ", c.odrno as ODRNO "

						wherestr = " where a.GameTitleIDX = "&tidx&" and (a.gameno = '"&gameno&"' or a.gameno2 = '"&gameno&"')  "

						SQL = ";with tbl as (Select "&fld&" from tblRGameLevel as a inner join sd_gameMember as b on a.GameTitleIDX  = b.gametitleidx and a.GbIDX = b.gbIDX and a.DelYN = 'N' and b.DelYN = 'N' "
						SQL = SQL & " inner join sd_gameMember_partner as c On b.gamememberidx = c.gamememberidx and c.delYN = 'N' " & wherestr & " ) "


						SQL = SQL & " select * from tbl where Joo = '"&joono&"' order by RANE , ODRNO"
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		else '계측기가 개인룰처럼 해놔서 짜증나서 바꿈 210329 

				fld = " ( cast(b.gameMemberIDX as varchar) + '_4444' + case when (a.gameno = '"&gameno&"') then 'A' when (a.gameno2 = '"&gameno &"') then 'B' end) as MIDX"
				fld = fld & "   ,b.username as NAME,b.TeamNm as TEAM,b.sex as SEX,sidonm as SIDO,userClass as GRADE "
				fld = fld & ",(case when (a.gameno = '"&gameno&"' and a.gubunam = '1') or  (a.gameno2 = '"&gameno&"' and a.gubunpm = '1') or (b.starttype = 3) then tryoutgroupno  else roundNo  end) as JOO "
				fld = fld & ", (case when (a.gameno = '"&gameno&"' and a.gubunam = '1') or  (a.gameno2 = '"&gameno&"' and a.gubunpm = '1') or (b.starttype = 3) then tryoutsortNo  else sortno end ) as RANE  "
				fld = fld & ", '1' as ODRNO "
				fld = fld & ",(case when (a.gameno = '"&gameno&"') then isnull(tryoutResult,'') when (a.gameno2 = '"&gameno &"') then isnull(gameResult,'') end) as GAMERESULT"

				wherestr = " where a.GameTitleIDX = "&tidx&" and (a.gameno = '"&gameno&"' or a.gameno2 = '"&gameno&"') "
				SQL = ";with tbl as ( Select "&fld&" from tblRGameLevel as a inner join sd_gameMember as b on a.GameTitleIDX  = b.gametitleidx and a.GbIDX = b.gbIDX and a.DelYN = 'N' and b.DelYN = 'N' " & wherestr & " )  "
				SQL = SQL & " select * from tbl where Joo = '"&joono&"'  order by RANE , ODRNO "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		end if

		'Response.write sql 
		'Response.end


		listarr = jsonTors_arr(rs)
		Set list = JSON.Parse( join(array(listarr)) )
		Call oJSONoutput.Set("LIST", list )
		Call oJSONoutput.Set("result", 0 )

	End Select


	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
