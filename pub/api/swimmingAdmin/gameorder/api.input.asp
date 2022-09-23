<%
'#############################################
'
'#############################################

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "BASEDATE") = "ok" Then
		fidx = oJSONoutput.BASEDATE
	End If
	If hasown(oJSONoutput, "GUBUN") = "ok" Then
		gubun = oJSONoutput.GUBUN '1예선 3 본선
	End If
	If hasown(oJSONoutput, "AMPM") = "ok" Then
		ampm = oJSONoutput.AMPM '오전에 넣을건지 오후에 넣을건지 'am' or 'pm'
	End If


	If hasown(oJSONoutput, "CDC") = "ok" Then
		cdc = oJSONoutput.CDC '상세종목코드
	End If
	If hasown(oJSONoutput, "LIDX") = "ok" Then
		lidx = oJSONoutput.LIDX
	End If

	'등록형태 정하기
		If cdc = "" Then
			'개별등록
			intype = 1
		Else
			'종목 전부서 등록 (예선, 결승으로 시작하는애들 모두 등록해야는데)
			intype = 2
		End If



	Set db = new clsDBHelper

	'날짜 정보 가져오기
		SQL = "select idx,gamedate,am,pm,selectflag,gameno from sd_gameStartAMPM where idx = "& fidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			gamedate = rs(1)
			gamedate = Replace(gamedate,"/","-")
			am = rs(2)
			pm = rs(3)
			dayno = rs(5) '경기 날짜 순서 번호 (경기번호 조합에 쓴다)
		End If

	'편성여부확인
		infld = "(select top 1 starttype from sd_gameMember where delyn='N' and GameTitleIDX = a.GameTitleIDX and CDC = a.CDC and gbIDX = a.gbidx) as starttype  "
		infld2 = "(select top 1 max(gubun) from sd_gameMember where delyn='N' and GameTitleIDX = a.GameTitleIDX and CDC = a.CDC and gbIDX = a.gbidx) as ranesetok  "

		If intype = 2 Then
			If ampm = "am" then

			SQL = "select a.tryoutgamedate,a.finalgamedate,a.gbidx,a.cdc,a.RgameLevelidx,"&infld&",gubunam,gubunpm,"&infld2&" from tblRGameLevel as a inner join tblTeamGbInfo as b on a.CDB = b.cd_boo and b.cd_type='2' WHERE a.delyn='N' and a.GameTitleIDX = "&tidx&" AND a.CDA = 'D2' AND (a.CDC = "&cdc&") and a.gubunam = 0 ORDER BY b.Orderby, a.Sexno " ' gubunam = 0 편성안된아이들만

			Else

			SQL = "select a.tryoutgamedate,a.finalgamedate,a.gbidx,a.cdc,a.RgameLevelidx,"&infld&",gubunam,gubunpm,"&infld2&" from tblRGameLevel as a inner join tblTeamGbInfo as b on a.CDB = b.cd_boo and b.cd_type='2' WHERE a.delyn='N' and a.GameTitleIDX = "&tidx&" AND a.CDA = 'D2' AND (a.CDC = "&cdc&") and a.gubunpm = 0 ORDER BY b.Orderby, a.Sexno " ' gubunam = 0 편성안된아이들만
			End If

		else
			'개별등록
			If ampm = "am" then
			SQL = "select a.tryoutgamedate,a.finalgamedate,a.gbidx,a.cdc,a.RgameLevelidx,"&infld&",gubunam,gubunpm,"&infld2&" from tblRGameLevel as a where  a.delyn='N' and a.RgameLevelidx =  " & lidx

			Else
			SQL = "select a.tryoutgamedate,a.finalgamedate,a.gbidx,a.cdc,a.RgameLevelidx,"&infld&",gubunam,gubunpm,"&infld2&" from tblRGameLevel as a where  a.delyn='N' and a.RgameLevelidx =  " & lidx
			End if

		End if

'Response.write sql
'Response.end

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




		If Not rs.EOF Then
			ar = rs.GetRows()
		End If

		If IsArray(ar) Then
			For ari = LBound(ar, 2) To UBound(ar, 2)
				amdate = isNulldefault(ar(0, ari),"")
				pmdate = isNulldefault(ar(1, ari),"")
				gbidx = ar(2, ari)
				cdc = ar(3, ari) '경기종목코드 100m ...의
				starttype = ar(5, ari) ' 1, 3 예선 여부
				gubunam =  ar(6, ari)
				gubunpm = ar(7, ari)
				ranesetok = ar(8, ari)

				'Select Case ampm
				'Case "am" '오전
					If ( amdate <> "" And CStr(gubunam) = CStr(gubun) ) Or ( pmdate <> ""  And CStr(gubunpm) = CStr(gubun) )  Then

						'오전 이미 등록되어있음
						Call oJSONoutput.Set("result", 6 )
						strjson = JSON.stringify(oJSONoutput)
						Response.Write strjson
						Response.end
					End if
			Next
		End if


		If ranesetok = "0" Then
			''결승시작인데 예선을 만들라고 하면 안됨.
			Call oJSONoutput.Set("result", 12 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if


		If IsArray(ar) Then
			For ari = LBound(ar, 2) To UBound(ar, 2)
				gbidx = ar(2, ari)
				cdc = ar(3, ari) '경기종목코드 100m ...의
				lidx = ar(4, ari)
				starttype = ar(5, ari) ' 1, 3 예선 여부





	Select Case ampm
	Case "am" '오전 ############################################################################
		If starttype = "3" And gubun = "1" Then '결승시작인데 예선을 만들라고 하면 안됨.

			''결승시작인데 예선을 만들라고 하면 안됨.
			Call oJSONoutput.Set("result", 11 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end


		Else

			daygameorderno = "(Select top 1  RANK() OVER (Order By Rgamelevelidx asc) AS RowNum from tblRGameLevel where delyn='N' and tryoutgamedate = '"&gamedate&"' and gametitleidx = " & tidx & " and CDA = 'D2' order by 1 desc) "
			SQL = "select top 1 tryoutgamestarttime,"&daygameorderno&",tryoutgameingS from tblRGameLevel where delyn='N' and  tryoutgamedate = '"&gamedate&"' and gametitleidx = " & tidx & " and CDA = 'D2'  order by tryoutgamestarttime desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rs.eof Then
				starttime = am
				orderno = 1
			Else
				starttime = rs(0)
				orderno = CDbl(rs(1)) + 1
				ingsec = rs(2) '사전에 넣을때 분으로 만듬...

				starttime = getNextStartTime(starttime, ingsec)
			End If

			'조수###########
				'SQL = "select max(tryoutgroupno) from SD_gameMember where delYN = 'N' and gubun ='1'  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' "	 'gubun = 1 예선 3 본선
				SQL = "select CEILING(CONVERT(float , count(gamememberidx))/8) from SD_gameMember where delYN = 'N' and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' "	 'gubun = 1 예선 3 본선
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Cdbl(rs(0)) = 0 then
					joocnt = 1
				Else
					joocnt = rs(0)
				End if
			'조수###########

			'진행 초수 가져오기
				SQL = "SELECT top 1  gametimeSS FROM tblTeamGbInfo Where   (cd_type = 1) AND (PTeamGb = 'D2') and teamgb = '"&CDC&"' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				ingsec = rs(0)
			'진행 초수 가져오기

			'경기번호
				gameno = dayno & addZero(orderno)

			'총 진행시간구하기
			'조 * 종목초 + (조 * 1분씩)
				totalsec = (joocnt * 60) + (joocnt * ingsec) '분으로 떨어지도록 조정해서 넣자.

				plusval = 60 - (totalsec Mod 60)
				totalsec = CDbl(totalsec) + CDbl(plusval)

			'마지막에 시간을 생성해서 시작 시간 정보 넣기 (날짜와)
				SQL = "update tblRGameLevel Set gubunam="&gubun&" ,tryoutgamedate = '"&gamedate&"' ,tryoutgamestarttime = '"&starttime&"' ,tryoutgameingS = '"&totalsec&"',gameno= '"&gameno&"',joono='"&joocnt&"' where RgameLevelidx =  " & lidx
				Call db.execSQLRs(SQL , null, ConStr)


			'오후꺼 전부 마지막 번호부터 들어가도록 업데이트 gameno2
			SQL = "UPDATE A SET A.gameno2 = A.NUM FROM ( SELECT gameno2, (ROW_NUMBER() OVER(ORDER BY finalgamestarttime asc)+"&gameno&") as NUM from tblRGameLevel where delyn = 'N' and finalgamedate = '"&gamedate&"' and gametitleidx = "&tidx&"  ) A "
			Call db.execSQLRs(SQL , null, ConStr)

		End if


	Case "pm" '오후 ############################################################################
		If starttype = "3" And gubun = "1" Then '결승시작인데 예선을 만들라고 하면 안됨.

			''결승시작인데 예선을 만들라고 하면 안됨.
			Call oJSONoutput.Set("result", 11 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.End
		End if

		'마지막 번호를 가져오는게 아니고 갯수를 가져오는이유는 순서대로 번호가 만들어졌다고 가정해서 그렇게 작업했다고 생각됨 중간에 들어와서 헛갈려서 다시보다가..생각이 이렇게 정리되었다.

		daygameorderno = "(Select top 1  RANK() OVER (Order By Rgamelevelidx asc) AS RowNum from tblRGameLevel where  delyn='N' and  tryoutgamedate = '"&gamedate&"' and gametitleidx = " & tidx & " and CDA = 'D2' order by 1 desc) " '오전 갯수

		daygameorderno2 = "(Select top 1  RANK() OVER (Order By Rgamelevelidx asc) AS RowNum from tblRGameLevel where  delyn='N' and  finalgamedate = '"&gamedate&"' and gametitleidx = " & tidx & " and CDA = 'D2' order by 1 desc) " '오후 갯수

 		SQL = "select top 1 finalgamestarttime,"&daygameorderno&","&daygameorderno2&",finalgameingS from tblRGameLevel where finalgamedate = '"&gamedate&"' and gametitleidx = " & tidx & " and CDA = 'D2'  order by finalgamestarttime desc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then '일딴 본선에 아무것도 없다면
			starttime = pm
			'예선등록 갯수 카운트
			SQL = "Select top 1  RANK() OVER (Order By Rgamelevelidx asc) AS RowNum from tblRGameLevel where delyn='N' and tryoutgamedate = '"&gamedate&"'  and gametitleidx = " & tidx & " and CDA = 'D2' order by 1 desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rs.eof then
				orderno = 1
			Else
				orderno = CDbl(rs(0)) + 1
			End if
		Else
			starttime = rs(0)
			orderno = CDbl(  isnulldefault(rs(1),0)  ) +  CDbl( isnulldefault(rs(2),0) ) + 1
			ingsec = rs(3) '사전에 넣을때 분으로 만듬...

			starttime = getNextStartTime(starttime, ingsec)
		End If

		'조수###########
			'8명이하 결승경기로 생성
			'모든 종목 400m 이상은 결승만 있음..
			'SQL = "select max(roundno) from SD_gameMember where delYN = 'N' and gubun ='1'  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' "	 'gubun = 1 예선 3 본선(경영은 예선본선 같이 다있어서) 1만
			SQL = "select CEILING(CONVERT(float , count(gamememberidx))/8) from SD_gameMember where delYN = 'N' and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' and starttype = '3' "	 'gubun = 1 예선 3 본선
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Cdbl(rs(0)) = 0 then
				joocnt = 1
			Else
				joocnt = rs(0)
			End if

		'진행 초수 가져오기
			SQL = "SELECT top 1  gametimeSS FROM tblTeamGbInfo Where   (cd_type = 1) AND (PTeamGb = 'D2') and teamgb = '"&CDC&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			ingsec = rs(0)

		'경기번호
			gameno = dayno & addZero(orderno)




		'총 진행시간구하기
		'조 * 종목초 + (조 * 1분씩)
			totalsec = (joocnt * 60) + (joocnt * ingsec) '분으로 떨어지도록 조정해서 넣자.

			plusval = 60 - (totalsec Mod 60)
			totalsec = CDbl(totalsec) + CDbl(plusval)

		'마지막에 시간을 생성해서 시작 시간 정보 넣기 (날짜와)
			SQL = "update tblRGameLevel Set gubunpm = "&gubun&", finalgamedate = '"&gamedate&"' ,finalgamestarttime = '"&starttime&"' ,finalgameingS = '"&totalsec&"',gameno2= '"&gameno&"',joono2='"&joocnt&"' where RgameLevelidx =  " & lidx
			Call db.execSQLRs(SQL , null, ConStr)



	End Select
	'========================================================================
			Next
		End if






	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
