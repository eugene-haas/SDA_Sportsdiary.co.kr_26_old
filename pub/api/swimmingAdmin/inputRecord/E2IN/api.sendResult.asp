<%
'#############################################
'결과저장및 실적관리를 결과를 저장한다.
'#############################################
	
	'request
		lidx = oJSONoutput.get("LIDX")	'종목키
		itgubun = oJSONoutput.get("ITGUBUN") 'I T 개인 단체
	
		rndstr = "결승"	
		ampmprestr = "tryout"
		rcstr = "tryout"
		rcstr2 = "tryout"
		firstRCfld = "G1firstRC"
		rcno = 2 'tryout 저장인지 결승저장인지 구분값
		rcOK = "RCOK2" 'tblRGameLevel에 (저장완료 업데이트)
		firstRCfld = "G2firstRC"
	
	'insert select 
	'개인경기 참가자 넣기
	Set db = new clsDBHelper 


	SQL = "select titlecode,gametitlename,gamearea,RCOK2,b.CDA,a.gametitleidx,b.levelno from sd_gameTitle as a inner join  tblrgamelevel as b on a.gametitleidx = b.gametitleidx and a.delyn='N' and b.delyn = 'N' where b.RGameLevelidx = " & lidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	titlecode = rs(0)
	titlename = rs(1)
	gamearea = rs(2)
	savestate = rs(3) 'rcok 저장여부확인용
	CDA = "E2"
	tidx = rs(5)
	levelno = rs(6)

	If savestate = "Y" Then
		'삭제 (delyn = 'Y')
		SQL = "update tblRecord Set DelYN = 'Y'  where RgameLevelidx =  " & Lidx & " and RCNO = '"&rcno&"' " '1,2 저장또는 결승인지 구분값 
		Call db.execSQLRs(SQL , null, ConStr)		
	End if


	'CDA E2
	If itgubun = "T" Then 'R08 실제로 신기록 승이나나면 이값을 변경해주어야한다. [rcType] '이건 승인에서 처리해줘야하고 (대회기록은 그대로 유지 한국신기록은 대회코드를 달리해서 하나더 복사해서 넣어야한다.)
		'starttype 이 모두 3이므로 순위필드는 tryoutsortno


		'맴버별로 소팅순서를 만든다... 4명까지만 일딴은..ㅡㅡ+ 나머진 버릴까 8명으로 테이블 수정
		SQL = " UPDATE A  SET A.odrno = A.RowNum FROM "
		SQL = SQL & " (SELECT odrno,ROW_NUMBER() OVER (partition by a.gamememberidx ORDER BY b.partneridx asc) AS RowNum  "
		SQL = SQL & " FROM sd_gameMember as a inner join  sd_gameMember_partner as b  "
		SQL = SQL & " ON a.gameMemberIDX = b.gameMemberIDX and b.delyn = 'N' where a.DelYN = 'N' and b.odrno = 0 and a.gametitleidx = "&tidx&") as A "
		Call db.execSQLRs(SQL , null, ConStr)


		insertfld = " gametitleidx,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,playerIDX,UserName,Birthday,Sex,sidoCode,sido,gameDate "
		insertfld = insertfld & ",Team,TeamNm,userClass,rctype,gamearea,gameResult,gameOrder,rane,gubun,levelno,Roundstr,RgameLevelidx,RCNO,  firstRC "
		insertfld = insertfld & ",kskey2,kskey3,kskey4,playerIDX2,playerIDX3,playerIDX4,UserName2,UserName3,UserName4  "
		
		selectfld = "a.gametitleidx, '"&titlecode&"', '"&titlename&"',a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,  c.ksportsno,c.playeridx,c.username  "
		selectfld = selectfld & " ,(select top 1 birthday from tblPlayer where playeridx = c.playeridx),a.sex,(select top 1 sido from tblSidoInfo where sidonm = a.sidonm),a.sidonm, b."&ampmprestr&"gamedate "
		selectfld = selectfld & ",a.team,a.teamnm,a.userclass, 'R08' ,'"&gamearea&"', a."&rcstr2&"result, a."&rcstr2&"totalorder, a."&rcstr&"sortno,a.ITgubun,a.levelno, '"&rndstr&"',b.RgameLevelidx, '"&rcno&"',"&firstRCfld&" "

		'4명이 넘는다 어떻게 처리하냐...~~~~
		selectfld = selectfld & ",(select ksportsno from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '2')" ' odrno 참가순서번호(계영기준)
		selectfld = selectfld & ",(select ksportsno from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '3')"
		selectfld = selectfld & ",(select ksportsno from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '4')"
		'selectfld = selectfld & ",(select ksportsno from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '5')" '아티스틱인경우 최대 8 이건다이빙이니까...
		'selectfld = selectfld & ",(select ksportsno from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '6')"
		'selectfld = selectfld & ",(select ksportsno from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '7')"
		'selectfld = selectfld & ",(select ksportsno from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '8')"								

		selectfld = selectfld & ",(select PlayerIDX from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '2')"
		selectfld = selectfld & ",(select PlayerIDX from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '3')"
		selectfld = selectfld & ",(select PlayerIDX from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '4')"

		selectfld = selectfld & ",(select username from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '2')"
		selectfld = selectfld & ",(select username from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '3')"
		selectfld = selectfld & ",(select username from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '4')"

		SelectSQL =" select  "&selectfld&" from sd_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx "
		SelectSQL = SelectSQL & " inner Join sd_gameMember_partner as c On a.gamememberidx = c.gamememberidx 	"
		SelectSQL = SelectSQL & " where  b.RgameLevelidx =  '"&Lidx&"' and a.delyn = 'N' and c.delYn = 'N' and c.odrno = '1' "		

	Else
		insertfld = " gametitleidx,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,playerIDX,UserName,Birthday,Sex,sidoCode,sido,gameDate "
		insertfld = insertfld & ",Team,TeamNm,userClass,rctype,gamearea,gameResult,gameOrder,rane,gubun,levelno,Roundstr,RgameLevelidx,RCNO "
		selectfld = "a.gametitleidx, '"&titlecode&"', '"&titlename&"',a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,a.ksportsno,a.playeridx,a.username,(select top 1 birthday from tblPlayer where playeridx = a.playeridx),a.sex,(select top 1 sido from tblSidoInfo where sidonm = a.sidonm),a.sidonm, b."&ampmprestr&"gamedate "
		selectfld = selectfld & ",a.team,a.teamnm,a.userclass, 'R08' ,'"&gamearea&"', a."&rcstr2&"result, a."&rcstr2&"totalorder, a."&rcstr&"sortno,a.ITgubun,a.levelno, '"&rndstr&"',b.RgameLevelidx, '"&rcno&"' "
		
		SelectSQL =" select  "&selectfld&" from sd_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx where  b.RgameLevelidx =  '"&Lidx&"' and a.delyn = 'N' "	
		SelectSQL = SelectSQL & " and a.gubun in (1,3) and  a.starttype =3 and a.tryoutsortno > 0 "
	End if

	'tblRecord 저장
	SQL = "insert Into tblRecord ("&insertfld&")  ("&SelectSQL&")"
	Call db.execSQLRs(SQL , null, ConStr)

'#######################################################
'체육회 전송 잠정 보류로 일시 적으로 막아둠 내부 레코드만 저장 21.03.19 동현메니져 요청 by baek 
'If dhtest = True then

			'실적전송을 하여야하는 경우 : 결승만
			jinjinTbl = "KoreaBadminton_Info.dbo.tblSWRESULT" '진진테이블

			'이전 실적을 지우고 gametitleidx(tidx), rgamelevelidx (lidx)
			'RETURL_YN = 'A' 인증완료되어서 더이상 저장불가.
			SQL = "Select RETURN_YN from " & jinjinTbl  & " where tidx = '"&tidx&"' and lidx = '"&lidx&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				returnyn = rs(0)
				If returnyn = "A" Then '수정불가 인증처리됨
					Call oJSONoutput.Set("result", 99 )
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end
				End if
			End if
			SQL = "Delete from " & jinjinTbl  & " where tidx = '"&tidx&"' and lidx = '"&lidx&"' "
			Call db.execSQLRs(SQL , null, ConStr)


			'진진실적 테이블 저장 (위에 저장된 tblRecord로 저장하자)
			If itgubun = "T" Then
				'1번순서넣고 ,2번순서 넣고 3번순서 넣고 4번순서 넣자.

				newrec = ""' "대회신기록.."
				attcnt = "select count(*) from sd_gameMember where  delyn = 'N' and  gametitleidx = '"&tidx&"' and levelno = '"&levelno&"' " '출전선수수(팀수)
				memberseq =  " select '00' + cast(count(*)+1 as varchar) from "&jinjinTbl&" where  tidx = '"&tidx&"'  and  PERSON_NO= a.kskey"
				gametype = "기록경기" '토너먼트, 리그전

				RCD_1 =  "E21000"
				RCD_2 = "E29000"
				loopcnt = 2

				For n = 1 To loopcnt '단체 이고
					If n = 1 Then
						keyno = ""
					Else
						keyno = n
					End if

					'CDA "E2"
					fld = " 'SW', kskey"&keyno&", titlecode, team, cdbnm + ' ' + cdcnm, roundstr + ' '+ gameOrder+'위', left(gameresult,3)+'.'+right(gameresult,2), '"&newrec&"',CDA , levelno,("&attcnt&"),'"&gametype&"', 'Y' , case when roundstr = '예선' then '"&RCD_1&"' else '"&RCD_2&"' end ,'"&tidx&"' ,'"&lidx&"'  ,("&memberseq&keyno&") "

					SelectSQL = " select "&fld&" from tblRecord where  delyn = 'N'  and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and  (cast(playerIDX as varchar) + gameresult) in ( "
					SelectSQL = SelectSQL & "  select (cast(playerIDX as varchar) + max(gameresult)) from tblRecord where  delyn = 'N' and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and gameResult  > 0 and gameResult < 'a' group by playerIDX  )"

					insertFld = "PCLASS_CD,PERSON_NO,TO_CD,TEAM_CD,DETAIL_CLASS_NM,RESULTRANK   ,RECORD, NEW_REC_NM, CLASS_CD,DETAIL_CLASS_CD,PLAYER_CNT,MA_TYPE,PLAY_YN,RH_CD,tidx,lidx ,MemberSEQ"
					SQL = "insert Into "&jinjinTbl&" ("&insertfld&")  ("&SelectSQL&")"
					Call db.execSQLRs(SQL , null, ConStr)
				next

			Else
				'RCNO 필드구분 tryout , result 1,2
				newrec = ""' "대회신기록"
				attcnt = "select count(*) from sd_gameMember where  delyn = 'N' and  gametitleidx = '"&tidx&"' and levelno = '"&levelno&"' " '출전선수수(팀수)
				gametype = "기록경기" '토너먼트, 리그전
				memberseq =  " select '00' + cast(count(*)+1 as varchar) from "&jinjinTbl&" where  tidx = '"&tidx&"'  and  PERSON_NO= a.kskey  "

				'CDA "E2"
					RCD_1 =  "E21000"
					RCD_2 = "E29000"

					fld = " 'SW', kskey, titlecode, team, cdbnm + ' ' + cdcnm, roundstr + ' '+ gameOrder+'위', left(gameresult,3)+'.'+right(gameresult,2), '"&newrec&"',CDA , levelno,("&attcnt&"),'"&gametype&"', 'N' , '"&RCD_2&"' ,'"&tidx&"' ,'"&lidx&"' ,("&memberseq&") "

					SelectSQL = " select "&fld&" from tblRecord as a where  delyn = 'N' and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and  (cast(playerIDX as varchar) + gameresult) in ( "
					SelectSQL = SelectSQL & "  select (cast(playerIDX as varchar) + max(gameresult)) from tblRecord where  delyn = 'N' and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and gameResult  > 0 and gameResult < 'a' group by playerIDX  )"				

				'player_YN = 개인 N 단체 Y
				'player_CTN = 종목별 참가수

				insertFld = "PCLASS_CD,PERSON_NO,TO_CD,TEAM_CD,DETAIL_CLASS_NM,RESULTRANK   ,RECORD, NEW_REC_NM, CLASS_CD,DETAIL_CLASS_CD,PLAYER_CNT,MA_TYPE,PLAY_YN,RH_CD,tidx,lidx , MemberSEQ"
				SQL = "insert Into "&jinjinTbl&" ("&insertfld&")  ("&SelectSQL&")"
				Call db.execSQLRs(SQL , null, ConStr)
				'Response.write SQL & "<br>"
				'Response.write SelectSQL
				'Response.end
			end if

	

'체육회 전송 잠정 보류로 일시 적으로 막아둠 내부 레코드만 저장 21.03.19 동현메니져 요청 by baek 
'End if
'#######################################################


	'저장완료 flag 업데이트
	SQL = "update tblRGameLevel Set RCOK2 = 'Y'  where RgameLevelidx =  " & Lidx
	Call db.execSQLRs(SQL , null, ConStr)		
	

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>