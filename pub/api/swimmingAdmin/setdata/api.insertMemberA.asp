<%
'#############################################
'temp 데이터를 request 테이블에 밀어넣는다.
'#############################################
	
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then 
		tidx = oJSONoutput.TIDX
	End If

	Set db = new clsDBHelper 

'-----------------------------------------------------------------------------------------------------------------------------
'개인전
'-----------------------------------------------------------------------------------------------------------------------------

		'개인경기 참가자 넣기
		insertFLD = " GameTitleIDX,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_ksportsno,P1_PlayerIDX,P1_UserName,P1_UserClass,P1_Team,P1_TeamNm,P1_UserPhone,P1_Birthday,P1_SEX,sido,sidonm,bestRC,ITgubun		,joo,rane  , entertype  "

		fld = " GameTitleIDX,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,pidx,username,userclass,team,teamnm,userphone,birthday,sex,sido,sidonm,bestRC,ITgubun		,joo,rane , 'A' "
		selectQ = "Select "&fld&" from tblGameRequest_TEMP where delyn = 'N' and ITgubun= 'I' and GameTitleIDX = " & tidx 
		Set rs = db.ExecSQLReturnRS(selectQ & " and gbidx is null" , null, ConStr)

		if not rs.eof then
				Call oJSONoutput.Set("result", 99 )
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				response.End
		else
			'call rsdrow(rs)
		end if

		SQL = "insert Into tblGameRequest ("&insertFLD&")  ("&selectQ&")"
		Call db.execSQLRs(SQL , null, ConStr)

		'tblGameRequest select 해서 넣자.  sd_gameMember 에 넣기
		fld = " GameTitleIDX,ITgubun,P1_ksportsno,P1_PlayerIDX,P1_UserName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_Team,P1_TeamNm,P1_UserClass,P1_SEX,sidonm,RequestIDX		,joo,rane,'1' ,'3' "
		minfld = " GameTitleIDX,Itgubun,ksportsno,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,sidonm,requestIDX  "
		selectQ = "Select "&fld&" from tblGameRequest where delyn = 'N' and ITgubun= 'I' and  P1_playeridx>0 and GameTitleIDX = " & tidx 

		SQL = "insert Into sd_gameMember ("&minfld&",tryoutgroupno,tryoutsortNo,gubun, starttype)  ("&selectQ&")" 'sd_gameMember 여긴 entertype 없음
		Call db.execSQLRs(SQL , null, ConStr)


'-----------------------------------------------------------------------------------------------------------------------------
'단체전
'-----------------------------------------------------------------------------------------------------------------------------

		'#######
				'CDC 값을 모두 정의할까? 쿼리로 가져오자
				'8명이하 결승경기로 생성 ---------------------중요
				'모든종목 400m 이상은 결승만 있음..---------------------중요
				'startType 이거 찾아서 일괄 업데이트 하는게 좋을까?

			'		If CDbl(attcnt) <= CDbl(raneCnt) Or CDbl(gametimeSS) >= 320 Then 
			'		SQL = SQL & " update sd_gameMember set tryoutgroupno = '"&joono&"',startType='3'  where gamememberidx = '"&midx&"' "	'결승으로 생성 starttype = 3 이면 tryout 이 결승인거다.
			'		else
			'		SQL = SQL & " update sd_gameMember set tryoutgroupno = '"&joono&"',startType='1'  where gamememberidx = '"&midx&"' "
			'		End If


			'			SQL = " select top 1 gametimess from tblTeamGbInfo where cd_type= 1 and PTeamGb='D2'  and teamgb= '"&cdc&"' " '설정된 게임시간 가져오기
			'			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			'			If rs.eof Then
			'				gametimess = 0
			'			else
			'				gametimess = rs(0)
			'			End if


			'==================================
			';with tbl as (
			'select a.levelno,max(b.gametimess)as gs ,COUNT(*) as cnt from sd_gameMember as a inner join tblTeamGbInfo as b 
			'on a.cdc = b.teamgb and a.delyn = 'N' and b.delyn = 'N' where a.GameTitleIDX = '87' and cd_type='1' and PTeamGb = 'D2'  group by a.levelno
			')

			'update sd_gameMember set startType= '3' where levelno in ( select levelno from tbl where cnt <= 8 and gs >= 320)
			'===================================
		'#######	

		'계영 팀 넣기 (팀단위로 넣어야함)
		fld = " "&tidx&",max(gbIDX),levelno,max(CDA),max(CDANM),max(CDB),max(CDBNM),max(CDC),max(CDCNM),'','0','단체','0',team,teamnm,Null,'0',max(sex),max(sido),max(sidonm),Null,'T' ,max(joo),max(rane) ,'A' "
		selectQ = "Select "&fld&" from tblGameRequest_TEMP where delyn = 'N' and ITgubun= 'T' and GameTitleIDX = " & tidx & " group by levelno,team,teamnm"
		Set rs = db.ExecSQLReturnRS(selectQ , null, ConStr)

		If Not rs.eof then
			SQL = "insert Into tblGameRequest ("&insertFLD&")  ("&selectQ&")"
			Call db.execSQLRs(SQL , null, ConStr)

			'단체명만 대진표에 넣기
			fld = " GameTitleIDX,ITgubun,P1_ksportsno,P1_PlayerIDX,P1_UserName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_Team,P1_TeamNm,P1_UserClass,P1_SEX,sidonm,RequestIDX		,joo,rane,'1' ,'3' "
			minfld = " GameTitleIDX,Itgubun,ksportsno,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,sidonm,requestIDX "
			selectQ = "Select "&fld&" from tblGameRequest where delyn = 'N' and ITgubun= 'T' and P1_playeridx='0' and GameTitleIDX = " & tidx 

			SQL = "insert Into sd_gameMember ("&minfld&",tryoutgroupno,tryoutsortNo,gubun,starttype)  ("&selectQ&")" 'sd_gameMember 여긴 entertype 없음
			Call db.execSQLRs(SQL , null, ConStr)		

			'계영참가자 넣기
			fld = " requestIDX,GameTitleIDX,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_team,P1_teamnm "
			SQL = "Select "&fld&" from tblGameRequest where delyn = 'N' and ITgubun='T' and GameTitleIDX = " & tidx & " order by levelno"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not (rs.Eof Or rs.Bof) Then
				ar = rs.GetRows()
			End If

			If IsArray(ar) Then 
			For a = LBound(ar, 2) To UBound(ar, 2)
					l_requestIDX= ar(0, a) 
					l_GameTitleIDX= ar(1, a) 
					l_gbIDX= ar(2, a) 
					l_levelno= ar(3, a) 
					l_CDA= ar(4, a) 
					l_CDANM= ar(5, a) 
					l_CDB= ar(6, a) 
					l_CDBNM= ar(7, a) 
					l_CDC= ar(8, a) 
					l_CDCNM= ar(9, a) 
					l_team= ar(10, a) 
					l_teamnm= ar(11, a) 

					insertFLD = " requestIDX,kskey,playeridx,username,userClass,team,teamnm,sex "
					fld = l_requestIDX & "  ,kskey,pidx, username,userclass,team,teamnm,sex "
					selectQ = "Select "&fld&" from tblGameRequest_TEMP where delyn = 'N' and ITgubun= 'T' and GameTitleIDX = " & tidx & " and levelno = '"&l_levelno&"' and team = '"&l_team&"' "
					SQL = "insert Into tblGameRequest_r ("&insertFLD&")  ("&selectQ&")"
					Call db.execSQLRs(SQL , null, ConStr)
			Next
			End If
		End if

	
		'startType 설정하기
'		SQL = ";with tbl as ( "
'		SQL = SQL & " select a.levelno,max(b.gametimess)as gs ,COUNT(*) as cnt from sd_gameMember as a INNER JOIN tblTeamGbInfo as b "
'		SQL = SQL & " ON a.cdc = b.teamgb and a.delyn = 'N' and b.delyn = 'N' where a.GameTitleIDX = '"&tidx&"' and cd_type='1' and PTeamGb = 'D2'  group by a.levelno )"
'		SQL = SQL & " update sd_gameMember set startType= '3' where GameTitleIDX = '"&tidx&"' and levelno in ( select levelno from tbl where cnt <= 8 or gs >= 320) "
'		Call db.execSQLRs(SQL , null, ConStr)


		'다등록했으면 템프 삭제(진짜지우는게 좋을꺼같은데) 이건 뒤에 삭제버튼으로
		SQL = "update tblGameRequest_TEMP set delyn = 'Y' where GameTitleIDX = " & tidx 
		Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>