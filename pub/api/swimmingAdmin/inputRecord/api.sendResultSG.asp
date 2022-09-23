<%
'#############################################
'수구기록 저장및 실적 저장
'#############################################



	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "LIDX") = "ok" Then  'lidx
		lidx = oJSONoutput.LIDX
	End if
	If hasown(oJSONoutput, "LNO") = "ok" Then  'levelno
		lno = oJSONoutput.LNO
	End if





	Set db = new clsDBHelper

	SQL = "select titlecode,gametitlename,gamearea,RCOK1,RCOK2,b.CDA,a.gametitleidx,b.levelno,games from sd_gameTitle as a inner join  tblrgamelevel as b on a.gametitleidx = b.gametitleidx where a.delyn='N'  and b.RGameLevelidx = " & lidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	titlecode = rs(0)
	titlename = rs(1)
	gamearea = rs(2)
	savestate = rs(3) 'RCOK1 저장상태
	CDA = rs(5)
	tidx = rs(6)
	levelno = rs(7)
	games = Left(rs(8),10)

	If savestate = "Y" Then
		'삭제 (delyn = 'Y')
		SQL = "update tblRecord Set DelYN = 'Y'  where RgameLevelidx =  " & Lidx
		Call db.execSQLRs(SQL , null, ConStr)
	End if

	SQL = "select count(*),max(tabletype) as tabletype from sd_gameMember where  delyn = 'N' and  gametitleidx = '"&tidx&"' and levelno = '"&levelno&"' " '출전선수수(팀수)  --tabletype N L T 설정전, 리그, 토너먼트
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	attcnt = rs(0)
	savetabletype = rs(1)

	if savetabletype = "T"  or ( savetabletype = "N" and CDbl(attcnt) > 4 ) then
		gametype = "토너먼트"
		rndstr = "(Case When tryouttotalorder > 0 and tryouttotalorder < 3 Then 'E29000' when tryouttotalorder > 2 and tryouttotalorder < 5 then 'E27000' when tryouttotalorder > 4  Or tryouttotalorder < 9 then 'E26000' else '' end ) "
	Else
		gametype = "리그"
		rndstr = "'E29000'"
	End if
	'E26000	E2	준준준결승	다이빙/수구
	'E27000	E2	준준결승	다이빙/수구
	'E29000	E2	결승	다이빙/수구




	insertfld = " gametitleidx,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,playerIDX,UserName,Birthday,Sex,sidoCode,sido,gameDate "
	insertfld = insertfld & ",Team,TeamNm,userClass,rctype,gamearea,gameResult,gameOrder,rane,gubun,levelno,Roundstr,RgameLevelidx,RCNO,midx "
	'#####
	SelectSQL = "Select "
	SelectSQL = SelectSQL & "a.gametitleidx, '"&titlecode&"' as titleCode, '"&titlename&"' as titlename,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM, b.ksportsno,b.playeridx,b.username "
	SelectSQL = SelectSQL & ",(select top 1 birthday from tblPlayer where playeridx = b.playeridx) as birthday ,b.sex "
	SelectSQL = SelectSQL & ",(select top 1 sido from tblSidoInfo where sidonm = a.sidonm) as sido "
	SelectSQL = SelectSQL & ",a.sidonm, '"&games&"' as gameDate ,b.team,b.teamnm,b.userclass, 'R08' as rctype "
	SelectSQL = SelectSQL & ",'"&gamearea&"' as gamearea, a.tryoutresult, a.tryouttotalorder, a.tryoutsortno,a.ITgubun,a.levelno " 'tryoutresult 승수
	SelectSQL = SelectSQL & ","&rndstr&" as Roundstr,'"&lidx&"' as lidx , '1' as rcno,a.gameMemberIDX  "
	SelectSQL = SelectSQL & " from sd_gameMember as a  inner Join sd_gameMember_partner as b On a.gamememberidx = b.gamememberidx and b.delyn = 'N' "
	SelectSQL = SelectSQL & " where a.GameTitleIDX = '"&tidx&"' and a.levelno = '"&lno&"' and a.delyn = 'N'  "


'Response.write SelectSQL
'Response.end

	'tblRecord 저장
	SQL = "insert Into tblRecord ("&insertfld&")  ("&SelectSQL&")"
	Call db.execSQLRs(SQL , null, ConStr)

	'##############################################################################################################
	jinjinTbl = "KoreaBadminton_Info.dbo.tblSWRESULT" '진진테이블

	'이전 실적을 지우고 gametitleidx(tidx), rgamelevelidx (lidx)
	SQL = "Delete from " & jinjinTbl  & " where tidx = '"&tidx&"' and lidx = '"&lidx&"' "
	Call db.execSQLRs(SQL , null, ConStr)


	fld = " 'SW', kskey,titlecode, team, cdbnm + ' ' + cdcnm, roundstr + ' '+ gameOrder+'위', gameresult,CDA , levelno,'"&attcnt&"','"&gametype&"', 'Y' , roundstr ,'"&tidx&"' ,'"&lidx&"' "
	SelectSQL = " select "&fld&" from tblRecord where  delyn = 'N'  and  gametitleidx='"&tidx&"' and  levelno='"&levelno&"' "
	insertFld = "PCLASS_CD,PERSON_NO,TO_CD,TEAM_CD,DETAIL_CLASS_NM,RESULTRANK   ,RECORD,  CLASS_CD,DETAIL_CLASS_CD,PLAYER_CNT,MA_TYPE,PLAY_YN,RH_CD,tidx,lidx "
	SQL = "insert Into "&jinjinTbl&" ("&insertfld&")  ("&SelectSQL&")"
	Call db.execSQLRs(SQL , null, ConStr)



	'저장완료 flag 업데이트
	SQL = "update tblRGameLevel Set RCOK1 = 'Y'  where RgameLevelidx =  " & Lidx  'tblRGameLevel에 (저장완료 업데이트)
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
