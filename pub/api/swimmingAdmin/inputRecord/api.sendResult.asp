<%
'#############################################
'결과저장및 실적관리를 결과를 저장한다.
'#############################################


	
	'request
	If hasown(oJSONoutput, "GNO") = "ok" Then  '게임번호 gameno1 or gameno2
		gameno = oJSONoutput.GNO
	End If
	If hasown(oJSONoutput, "LIDX") = "ok" Then  '종목키
		lidx = oJSONoutput.LIDX
	End if	
	If hasown(oJSONoutput, "AMPM") = "ok" Then  '오전오후
		ampm = oJSONoutput.AMPM
	End if	
	If hasown(oJSONoutput, "GUBUN") = "ok" Then  'tblrgamelevel gubunam or gubunpm 예선은 1 결승 3
		gubunampm = oJSONoutput.GUBUN
	End if	
	If hasown(oJSONoutput, "ITGUBUN") = "ok" Then  'I T 개인 단체
		itgubun = oJSONoutput.ITGUBUN
	End if	

	If gubunampm = "1" Then 
		rndstr = "예선"
	Else
		rndstr = "결승"	
	End if

	If ampm = "am" Then
		ampmprestr = "tryout"
		rcstr = "tryout"
		rcstr2 = "tryout"
		rcOK = "RCOK1" 'tblRGameLevel에 (저장완료 업데이트)
		rcno = 1
		firstRCfld = "G1firstRC"
	Else
		ampmprestr = "final"
		

		'오류 수정 'starttype 3이라면 tryout========== sd_gameMember에 

			rcstr = "" 'starttype 3이라면 tryout
			rcstr2 = "game" 'starttype 3 이라면 tryout
	
			rcno = 2 'tryout 저장인지 결승저장인지 구분값
		'==================================



		rcOK = "RCOK2" 'tblRGameLevel에 (저장완료 업데이트)
		firstRCfld = "G2firstRC"
	End if

	'insert select 
	'개인경기 참가자 넣기

	Set db = new clsDBHelper 

	'오류 수정을 추가 21.03.22################
	SQL = "select top 1 starttype from sd_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx where  b.RgameLevelidx =  '"&lidx&"' and a.delyn = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	starttype = rs(0)

'Response.write sql

	If starttype = "3" Then
		rcstr = "tryout" 
		rcstr2 = "tryout" 
		rcno = 2 'tryout 저장인지 결승저장인지 구분값
	End if
	'오류 수정을 추가 21.03.22################



	SQL = "select titlecode,gametitlename,gamearea,RCOK1,RCOK2,b.CDA,a.gametitleidx,b.levelno from sd_gameTitle as a inner join  tblrgamelevel as b on a.gametitleidx = b.gametitleidx and a.delyn='N' and b.delyn = 'N' where b.RGameLevelidx = " & lidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	titlecode = rs(0)
	titlename = rs(1)
	gamearea = rs(2)
	If ampm = "am" Then
		savestate = rs(3)
	Else
		RCOK2 = rs(4)
		savestate = rs(4)
	End if
	CDA = rs(5)
	tidx = rs(6)
	levelno = rs(7)

	If savestate = "Y" Then
		'삭제 (delyn = 'Y')
		SQL = "update tblRecord Set DelYN = 'Y'  where RgameLevelidx =  " & Lidx & " and RCNO = '"&rcno&"' "
		Call db.execSQLRs(SQL , null, ConStr)		
	End if


	If itgubun = "T" Then 'R08 실제로 신기록 승이나나면 이값을 변경해주어야한다. [rcType] '이건 승인에서 처리해줘야하고 (대회기록은 그대로 유지 한국신기록은 대회코드를 달리해서 하나더 복사해서 넣어야한다.)

		'starttype 이 모두 3이므로 순위필드는 tryoutsortno

		insertfld = " gametitleidx,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,playerIDX,UserName,Birthday,Sex,sidoCode,sido,gameDate "
		insertfld = insertfld & ",Team,TeamNm,userClass,rctype,gamearea,gameResult,gameOrder,rane,gubun,levelno,Roundstr,RgameLevelidx,RCNO,  firstRC "
		insertfld = insertfld & ",kskey2,kskey3,kskey4,playerIDX2,playerIDX3,playerIDX4,UserName2,UserName3,UserName4  "

		
		selectfld = "a.gametitleidx, '"&titlecode&"', '"&titlename&"',a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,  c.ksportsno,c.playeridx,c.username  ,(select top 1 birthday from tblPlayer where playeridx = c.playeridx),a.sex,(select top 1 sido from tblSidoInfo where sidonm = a.sidonm),a.sidonm, b."&ampmprestr&"gamedate "
		Select Case cda 
		Case "D2"
		selectfld = selectfld & ",a.team,a.teamnm,a.userclass, 'R08' ,'"&gamearea&"', a."&rcstr2&"result, a."&rcstr2&"order, a."&rcstr&"sortno,a.ITgubun,a.levelno, '"&rndstr&"',b.RgameLevelidx, '"&rcno&"',"&firstRCfld&" "
		Case "E2","F2"
		selectfld = selectfld & ",a.team,a.teamnm,a.userclass, 'R08' ,'"&gamearea&"', a."&rcstr2&"result, a."&rcstr2&"totalorder, a."&rcstr&"sortno,a.ITgubun,a.levelno, '"&rndstr&"',b.RgameLevelidx, '"&rcno&"',"&firstRCfld&" "
		End Select 


		selectfld = selectfld & ",(select ksportsno from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '2')" ' odrno 참가순서번호(계영기준)
		selectfld = selectfld & ",(select ksportsno from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '3')"
		selectfld = selectfld & ",(select ksportsno from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and odrno = '4')"

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

		Select Case cda
		Case "D2"
		selectfld = selectfld & ",a.team,a.teamnm,a.userclass, 'R08' ,'"&gamearea&"', a."&rcstr2&"result, a."&rcstr2&"order, a."&rcstr&"sortno,a.ITgubun,a.levelno, '"&rndstr&"',b.RgameLevelidx, '"&rcno&"' "
		Case "E2","F2"
		selectfld = selectfld & ",a.team,a.teamnm,a.userclass, 'R08' ,'"&gamearea&"', a."&rcstr2&"result, a."&rcstr2&"totalorder, a."&rcstr&"sortno,a.ITgubun,a.levelno, '"&rndstr&"',b.RgameLevelidx, '"&rcno&"' "
		End Select 

		
		SelectSQL =" select  "&selectfld&" from sd_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx where  b.RgameLevelidx =  '"&Lidx&"' and a.delyn = 'N' "	
	End if


	If CDbl(rcno) = 2 Then '결승 (예선 > 결승으로 가는)
		If starttype = "3" Then
			SelectSQL = SelectSQL & " and a.gubun in (1,3) and  a.starttype =3 and a.tryoutsortno > 0 "
		else
			SelectSQL = SelectSQL & " and a.gubun in (1,3) and  a.starttype =1 and a.sortno > 0 "
		End if
	End if


'팀쿼리(계영)
	';with tblRC as (
	'select a.gametitleidx, 'JH2019' as tidx, '서울시 대회' as tname,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,    c.ksportsno,c.playeridx,c.username,
	'(select top 1 birthday from tblPlayer where playeridx = c.playeridx) as birthday,a.sex,
	'(select top 1 sido from tblSidoInfo where sidonm = a.sidonm) as sido,a.sidonm
	', b.tryoutgamedate ,a.team,a.teamnm,a.userclass, 'R08'as rttype ,'서울' as area, a.tryoutresult, a.tryoutorder,
	' a.tryoutsortno,a.ITgubun,a.levelno, '결승' as resultstr ,b.RgameLevelidx, '1' as savefld,a.G1firstRC                                     ,c.gameMemberIDX ,c.odrno
	' 
	' from sd_gameMember as a inner join tblRGameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx 
	' inner Join sd_gameMember_partner as c On a.gamememberidx = c.gamememberidx 
	' where b.RgameLevelidx = '4346' and a.delyn = 'N' and c.delYn = 'N'             
	' )
	' 
	' select *
	' ,(select ksportsno from tblRC where gameMemberIDX = r.gameMemberIDX and odrno = '2')
	',(select ksportsno from tblRC where gameMemberIDX = r.gameMemberIDX and odrno = '3')
	',(select ksportsno from tblRC where gameMemberIDX = r.gameMemberIDX and odrno = '4')
	' 
	' ,(select PlayerIDX from tblRC where gameMemberIDX = r.gameMemberIDX and odrno = '2')
	',(select PlayerIDX from tblRC where gameMemberIDX = r.gameMemberIDX and odrno = '3')
	',(select PlayerIDX from tblRC where gameMemberIDX = r.gameMemberIDX and odrno = '4') 
	' 
	',(select username from tblRC where gameMemberIDX = r.gameMemberIDX and odrno = '2') 
	',(select username from tblRC where gameMemberIDX = r.gameMemberIDX and odrno = '3') 
	',(select username from tblRC where gameMemberIDX = r.gameMemberIDX and odrno = '4') 
	'   from tblRC as r where r.odrno = '1'

	'Response.write SelectSQL
	'Response.end
'팀쿼리(계영)

	'tblRecord 저장
	SQL = "insert Into tblRecord ("&insertfld&")  ("&SelectSQL&")"
	Call db.execSQLRs(SQL , null, ConStr)

	' * tryoutsortno 순위(예선또는, 결승시작 순위)  sortno 순위 (예선,  결승이있을때 결승 순위) *


'Response.write starttype
'Response.end


'#######################################################
'체육회 전송 잠정 보류로 일시 적으로 막아둠 내부 레코드만 저장 21.03.19 동현메니져 요청 by baek 
'If dhtest = True then


	If gubunampm = "3"   Then '실적전송을 하여야하는 경우 : 결승만
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
				'attcnt = "select count(*) from tblRecord where delyn = 'N' and gametitleidx = '"&tidx&"' and RgameLevelidx = '"&lidx&"' and RCNO = '1' " '출전선수수(팀수)
				attcnt = "select count(*) from sd_gameMember where  delyn = 'N' and  gametitleidx = '"&tidx&"' and levelno = '"&levelno&"' " '출전선수수(팀수)
				memberseq =  " select '00' + cast(count(*)+1 as varchar) from "&jinjinTbl&" where  tidx = '"&tidx&"'  and  PERSON_NO= a.kskey"
				gametype = "기록경기" '토너먼트, 리그전

				Select Case CDA
				Case "D2"
					RCD_1 =  "D21000" '예선
					RCD_2 = "D29000"
					loopcnt = 4
				Case "E2"
					RCD_1 =  "E21000"
					RCD_2 = "E29000"
					loopcnt = 2
				Case "F2"
					RCD_1 =  "F21000"
					RCD_2 = "F29000"
					loopcnt = 2
				End Select 




				For n = 1 To loopcnt '계영이라면 이고
					If n = 1 Then
						keyno = ""
					Else
						keyno = n
					End if

					Select Case CDA
					Case "D2"
						fld = " 'SW', kskey"&keyno&", titlecode, team, cdbnm + ' ' + cdcnm, roundstr + ' '+ gameOrder+'위', left(gameresult,2)+':'+substring(gameresult,3,2)+'.'+right(gameresult,2), '"&newrec&"',CDA , levelno,("&attcnt&"),'"&gametype&"', 'Y' , case when roundstr = '예선' then '"&RCD_1&"' else '"&RCD_2&"' end ,'"&tidx&"' ,'"&lidx&"' ,("&memberseq&keyno&") "
					Case "E2"
						fld = " 'SW', kskey"&keyno&", titlecode, team, cdbnm + ' ' + cdcnm, roundstr + ' '+ gameOrder+'위', left(gameresult,3)+'.'+right(gameresult,2), '"&newrec&"',CDA , levelno,("&attcnt&"),'"&gametype&"', 'Y' , case when roundstr = '예선' then '"&RCD_1&"' else '"&RCD_2&"' end ,'"&tidx&"' ,'"&lidx&"'  ,("&memberseq&keyno&") "
					Case "F2"
						fld = " 'SW', kskey"&keyno&", titlecode, team, cdbnm + ' ' + cdcnm, roundstr + ' '+ gameOrder+'위', left(gameresult,2)+'.'+right(gameresult,4), '"&newrec&"',CDA , levelno,("&attcnt&"),'"&gametype&"', 'Y' , case when roundstr = '예선' then '"&RCD_1&"' else '"&RCD_2&"' end ,'"&tidx&"' ,'"&lidx&"'  ,("&memberseq&keyno&") "
					End Select 

					SelectSQL = " select "&fld&" from tblRecord where  delyn = 'N'  and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and  (cast(playerIDX as varchar) + gameresult) in ( "
					SelectSQL = SelectSQL & "  select (cast(playerIDX as varchar) + max(gameresult)) from tblRecord where  delyn = 'N' and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and gameResult  > 0 and gameResult < 'a' group by playerIDX  )"

					insertFld = "PCLASS_CD,PERSON_NO,TO_CD,TEAM_CD,DETAIL_CLASS_NM,RESULTRANK   ,RECORD, NEW_REC_NM, CLASS_CD,DETAIL_CLASS_CD,PLAYER_CNT,MA_TYPE,PLAY_YN,RH_CD,tidx,lidx ,MemberSEQ"
					SQL = "insert Into "&jinjinTbl&" ("&insertfld&")  ("&SelectSQL&")"
					Call db.execSQLRs(SQL , null, ConStr)
				next

			Else
				'RCNO 필드구분 tryout , result 1,2

				newrec = ""' "대회신기록"
				'attcnt = "select count(*) from tblRecord where  delyn = 'N' and  gametitleidx = '"&tidx&"' and RgameLevelidx = '"&lidx&"' and RCNO = '1' " '출전선수수(팀수)
				attcnt = "select count(*) from sd_gameMember where  delyn = 'N' and  gametitleidx = '"&tidx&"' and levelno = '"&levelno&"' " '출전선수수(팀수)
				gametype = "기록경기" '토너먼트, 리그전
				memberseq =  " select '00' + cast(count(*)+1 as varchar) from "&jinjinTbl&" where  tidx = '"&tidx&"'  and  PERSON_NO= a.kskey  "

				Select Case CDA
				Case "D2"
					RCD_1 =  "D21000" '예선
					RCD_2 = "D29000"

					fld = " 'SW', kskey, titlecode, team, cdbnm + ' ' + cdcnm, roundstr + ' '+ gameOrder+'위', left(gameresult,2)+':'+substring(gameresult,3,2)+'.'+right(gameresult,2), '"&newrec&"',CDA , levelno,("&attcnt&"),'"&gametype&"', 'N' , case when roundstr = '예선' then '"&RCD_1&"' else '"&RCD_2&"' end ,'"&tidx&"' ,'"&lidx&"' ,("&memberseq&") "

					SelectSQL = " select "&fld&" from tblRecord as a where  delyn = 'N' and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and  (cast(playerIDX as varchar) + gameresult) in ( "
					SelectSQL = SelectSQL & "  select (cast(playerIDX as varchar) + max(gameresult)) from tblRecord where  delyn = 'N' and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and gameResult  > 0 and gameResult < 'a' group by playerIDX  )"				
				
				Case "E2"
					RCD_1 =  "E21000"
					RCD_2 = "E29000"

					fld = " 'SW', kskey, titlecode, team, cdbnm + ' ' + cdcnm, roundstr + ' '+ gameOrder+'위', left(gameresult,3)+'.'+right(gameresult,2), '"&newrec&"',CDA , levelno,("&attcnt&"),'"&gametype&"', 'N' , '"&RCD_2&"' ,'"&tidx&"' ,'"&lidx&"' ,("&memberseq&") "

					SelectSQL = " select "&fld&" from tblRecord as a where  delyn = 'N' and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and  (cast(playerIDX as varchar) + gameresult) in ( "
					SelectSQL = SelectSQL & "  select (cast(playerIDX as varchar) + max(gameresult)) from tblRecord where  delyn = 'N' and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and gameResult  > 0 and gameResult < 'a' group by playerIDX  )"				


				Case "F2"
					RCD_1 =  "F21000"
					RCD_2 = "F29000"

					fld = " 'SW', kskey, titlecode, team, cdbnm + ' ' + cdcnm, roundstr + ' '+ gameOrder+'위', left(gameresult,2)+'.'+right(gameresult,4), '"&newrec&"',CDA , levelno,("&attcnt&"),'"&gametype&"', 'N' , '"&RCD_2&"','"&tidx&"' ,'"&lidx&"' ,("&memberseq&") "

					SelectSQL = " select "&fld&" from tblRecord as a where  delyn = 'N'  and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and  (cast(playerIDX as varchar) + gameresult) in ( "
					SelectSQL = SelectSQL & "  select (cast(playerIDX as varchar) + max(gameresult)) from tblRecord where  delyn = 'N' and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' and gameResult  > 0 and gameResult < 'a' group by playerIDX  )"				



				End Select 
			
				'player_YN = 개인 N 단체 Y
				'player_CTN = 종목별 참가수

				insertFld = "PCLASS_CD,PERSON_NO,TO_CD,TEAM_CD,DETAIL_CLASS_NM,RESULTRANK   ,RECORD, NEW_REC_NM, CLASS_CD,DETAIL_CLASS_CD,PLAYER_CNT,MA_TYPE,PLAY_YN,RH_CD,tidx,lidx , MemberSEQ"
				SQL = "insert Into "&jinjinTbl&" ("&insertfld&")  ("&SelectSQL&")"
				Call db.execSQLRs(SQL , null, ConStr)
				'Response.write SQL & "<br>"
				'Response.write SelectSQL
				'Response.end
			end if

	End if
'체육회 전송 잠정 보류로 일시 적으로 막아둠 내부 레코드만 저장 21.03.19 동현메니져 요청 by baek 
'End if
'#######################################################


	'저장완료 flag 업데이트
	SQL = "update tblRGameLevel Set " & rcOK & " = 'Y'  where RgameLevelidx =  " & Lidx
	Call db.execSQLRs(SQL , null, ConStr)		
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>