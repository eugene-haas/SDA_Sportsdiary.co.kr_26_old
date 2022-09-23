<%
'#############################################
'최종경기결과저장
'#############################################
	'request
	If hasown(oJSONoutput, "KGAME") = "ok" Then '체전여부 A 두번복사여부
		r_kgame= oJSONoutput.Get("KGAME")
	End If

	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.Get("TIDX")
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.Get("GBIDX")
	End If


	If hasown(oJSONoutput, "TEAMGB") = "ok" Then 'gbidx2의 경기 형태 마장마술인지 아닌지 판다.... MM
		r_teamgb= oJSONoutput.Get("TEAMGB")
	End If




Set db = new clsDBHelper

	fld = "rcIDX"
	'1. 결과가 있는지 확인
	SQL = "select "& fld & " from tblGameRecord where tidx = '"&r_tidx&"'  and gbidx = '"&r_gbidx&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'2. 생성된거 삭제
	If Not rs.eof Then
	SQL = "delete from  tblGameRecord where tidx = '"&r_tidx&"'  and gbidx = '"&r_gbidx&"' "
	Call db.execSQLRs(SQL , null, ConStr)
	End if


	SQL = "select ridingclasshelp from tblTeamGbInfo where TeamGbIDX = '"&r_gbidx&"'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		select_f_classhelp = rs(0)
	End if


	'3. 인서트필드
	insertfld = "tidx,"
	insertfld =insertfld & "TO_CD,"
	insertfld =insertfld & "titlename,"
	insertfld =insertfld & "gbIDX,"
	insertfld =insertfld & "levelno,"
	insertfld =insertfld & "CDANM,"
	insertfld =insertfld & "CDBNM,"
	insertfld =insertfld & "CDCNM,"
	insertfld =insertfld & "CLASSNM,"
	insertfld =insertfld & "CLASSHELPNM,"
	insertfld =insertfld & "ksportsno,"
	insertfld =insertfld & "playerIDX,"
	insertfld =insertfld & "UserName,"
	insertfld =insertfld & "pidx,"
	insertfld =insertfld & "horseName,"
	insertfld =insertfld & "gameYear,"
	insertfld =insertfld & "gameDate,"
	insertfld =insertfld & "Team,"
	insertfld =insertfld & "TeamNm,"
	insertfld =insertfld & "booOrrder,"
	insertfld =insertfld & "gameOrder,"
	insertfld =insertfld & "pubcode,"
	insertfld =insertfld & "pubcodeNM,"
	insertfld =insertfld & "Roundstr,"
	insertfld =insertfld & "RgameLevelIDX,"
	insertfld =insertfld & "midx,"

	insertfld =insertfld & "deduction" '감점횟수 (무감점 체크항목)



'/////////////////////////////////////////////////////////////////////////////////////////
Select Case r_teamgb
Case "20101","20201" '마장마술

	'부명칭
	SQL = "select top 1 pubname from  SD_tennisMember	where GameTitleIDX = "&r_tidx&"  and gamekey3="&r_gbidx&" and gubun < 100  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	pubname = rs(0)

	'검색필드
	selectfld = "a.GameTitleIDX,"
	selectfld = selectfld & "c.titleCode,"
	selectfld = selectfld & "c.GameTitleName,"
	selectfld = selectfld & "a.gamekey3,"
	selectfld = selectfld & "d.levelno,"
	selectfld = selectfld & "d.pteamgbnm,"
	selectfld = selectfld & "d.teamgbnm,"
	selectfld = selectfld & "d.levelnm,"
	selectfld = selectfld & "d.ridingclass,"
	selectfld = selectfld & "d.ridingclasshelp,"
	selectfld = selectfld & "a.ksportsno,"
	selectfld = selectfld & "a.playeridx,"
	selectfld = selectfld & "a.username,"
	selectfld = selectfld & "b.playeridx,"
	selectfld = selectfld & "b.username,"
	selectfld = selectfld & "c.gameyear,"
	selectfld = selectfld & "a.gametime ,"
	selectfld = selectfld & "a.team,"
	selectfld = selectfld & "a.teamANa,"

	If r_teamgb = "20101" then
	selectfld = selectfld & "a.boo_orderno,"
	selectfld = selectfld & "a.total_order,"
	Else
	selectfld = selectfld & "a.total_order,"	'전체순위
	selectfld = selectfld & "a.group_order," '단체 순위
	End if

	selectfld = selectfld & "a.pubcode,"
	selectfld = selectfld & "a.pubname,"
	selectfld = selectfld & "a.round,"
	selectfld = selectfld & "(select top 1 RGameLevelidx from tblRGameLevel where GameTitleIDX = a.gametitleidx and GbIDX = a.gamekey3 and DelYN = 'N'),"
	selectfld = selectfld & "a.gamememberidx,"

	'감점'
	selectfld = selectfld & "a.off1 "


	sqlstr = "select "&selectfld&" from  SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx  "
	sqlstr = sqlstr & "	inner join sd_TennisTitle as c on a.GameTitleIDX = c.GameTitleIDX and c.DelYN = 'N' "
	sqlstr = sqlstr & "	inner join tblTeamGbInfo as d ON a.gamekey3= d.TeamGbIDX and  d.delyn = 'N' "
	sqlstr = sqlstr & "	where a.GameTitleIDX = "&r_tidx&"  and a.gamekey3="&r_gbidx&" and a.gubun < 100 and a.Round =1 "

	SQL = "insert Into tblGameRecord ("&insertfld&") "&sqlstr&" "
	Call db.execSQLRs(SQL , null, ConStr)



Case "20102","20202"  '장애물 (재경기시 본선순위에다가 반영한다 어떤게시작인지 찾자)

	'부명칭
	SQL = "select top 1 pubname from  SD_tennisMember	where GameTitleIDX = "&r_tidx&"  and gamekey3="&r_gbidx&" and gubun < 100  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	pubname = rs(0)

	'검색필드
	selectfld = "a.GameTitleIDX,"
	selectfld = selectfld & "c.titleCode,"
	selectfld = selectfld & "c.GameTitleName,"
	selectfld = selectfld & "a.gamekey3,"
	selectfld = selectfld & "d.levelno,"
	selectfld = selectfld & "d.pteamgbnm,"
	selectfld = selectfld & "d.teamgbnm,"
	selectfld = selectfld & "d.levelnm,"
	selectfld = selectfld & "d.ridingclass,"
	selectfld = selectfld & "d.ridingclasshelp,"
	selectfld = selectfld & "a.ksportsno,"
	selectfld = selectfld & "a.playeridx,"
	selectfld = selectfld & "a.username,"
	selectfld = selectfld & "b.playeridx,"
	selectfld = selectfld & "b.username,"
	selectfld = selectfld & "c.gameyear,"
	selectfld = selectfld & "a.gametime ,"
	selectfld = selectfld & "a.team,"
	selectfld = selectfld & "a.teamANa,"

	If r_teamgb = "20102" then
	selectfld = selectfld & "a.boo_orderno,"
	selectfld = selectfld & "a.total_order,"
	Else
	selectfld = selectfld & "a.total_order,"	'전체순위
	selectfld = selectfld & "a.group_order," '단체 순위
	End if

	selectfld = selectfld & "a.pubcode,"
	selectfld = selectfld & "a.pubname,"
	selectfld = selectfld & "a.round,"
	selectfld = selectfld & "(select top 1 RGameLevelidx from tblRGameLevel where GameTitleIDX = a.gametitleidx and GbIDX = a.gamekey3 and DelYN = 'N'),"
	selectfld = selectfld & "a.gamememberidx"

	'감점'
	selectfld = selectfld & "a.score_total " '무감점 체크용 0인것만 활용하면 될듯'


	sqlstr = "select "&selectfld&" from  SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx  "
	sqlstr = sqlstr & "	inner join sd_TennisTitle as c on a.GameTitleIDX = c.GameTitleIDX and c.DelYN = 'N' "
	sqlstr = sqlstr & "	inner join tblTeamGbInfo as d ON a.gamekey3= d.TeamGbIDX and  d.delyn = 'N' "
	sqlstr = sqlstr & "	where a.GameTitleIDX = "&r_tidx&"  and a.gamekey3="&r_gbidx&" and a.gubun < 100 and a.Round = 1  " ' 재경기 아닌것에다가...

	SQL = "insert Into tblGameRecord ("&insertfld&") "&sqlstr&" "
	Call db.execSQLRs(SQL , null, ConStr)


Case "20105", "20205" '지구력 ##########################################################################################

	'부명칭
	SQL = "select top 1 pubname from  SD_tennisMember	where GameTitleIDX = "&r_tidx&"  and gamekey3="&r_gbidx&" and gubun < 100  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	pubname = rs(0)


	'검색필드
	selectfld = "a.GameTitleIDX,"
	selectfld = selectfld & "c.titleCode,"
	selectfld = selectfld & "c.GameTitleName,"
	selectfld = selectfld & "a.gamekey3,"
	selectfld = selectfld & "d.levelno,"
	selectfld = selectfld & "d.pteamgbnm,"
	selectfld = selectfld & "d.teamgbnm,"
	selectfld = selectfld & "d.levelnm,"
	selectfld = selectfld & "d.ridingclass,"
	selectfld = selectfld & "d.ridingclasshelp,"
	selectfld = selectfld & "a.ksportsno,"
	selectfld = selectfld & "a.playeridx,"
	selectfld = selectfld & "a.username,"
	selectfld = selectfld & "b.playeridx,"
	selectfld = selectfld & "b.username,"
	selectfld = selectfld & "c.gameyear,"
	selectfld = selectfld & "a.gametime ,"
	selectfld = selectfld & "a.team,"
	selectfld = selectfld & "a.teamANa,"

	If r_teamgb = "20105" then
	selectfld = selectfld & " '',"
	selectfld = selectfld & "e.total_order,"
	Else
	selectfld = selectfld & " '',"
	selectfld = selectfld & "e.total_grouporder," '단체 순위
	End if

	selectfld = selectfld & "a.pubcode,"
	selectfld = selectfld & "a.pubname,"
	selectfld = selectfld & "a.round,"
	selectfld = selectfld & "(select top 1 RGameLevelidx from tblRGameLevel where GameTitleIDX = a.gametitleidx and GbIDX = a.gamekey3 and DelYN = 'N'),"
	selectfld = selectfld & "a.gamememberidx,"

	'감점 이란게 없으니 그냥 다통과되도록'
	selectfld = selectfld & "'0' "

	sqlstr = "select "&selectfld&" from  SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx  "
	sqlstr = sqlstr & "	inner join sd_TennisTitle as c on a.GameTitleIDX = c.GameTitleIDX and c.DelYN = 'N' "
	sqlstr = sqlstr & "	inner join tblTeamGbInfo as d ON a.gamekey3= d.TeamGbIDX and  d.delyn = 'N' "
	sqlstr = sqlstr & "	inner join sd_gameMember_geegoo as e ON a.gamememberidx= e.gamememberidx  "
	sqlstr = sqlstr & "	where a.GameTitleIDX = "&r_tidx&"  and a.gamekey3="&r_gbidx&" and a.gubun < 100  " ' 재경기 아닌것에다가...

	SQL = "insert Into tblGameRecord ("&insertfld&") "&sqlstr&" "
	Call db.execSQLRs(SQL , null, ConStr)



Case "20208" '릴레이코스트

	'부명칭
	SQL = "select top 1 pubname from  SD_tennisMember	where GameTitleIDX = "&r_tidx&"  and gamekey3="&r_gbidx&" and gubun < 100  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	pubname = rs(0)

	'검색필드
	selectfld = "a.GameTitleIDX,"
	selectfld = selectfld & "c.titleCode,"
	selectfld = selectfld & "c.GameTitleName,"
	selectfld = selectfld & "a.gamekey3,"
	selectfld = selectfld & "d.levelno,"
	selectfld = selectfld & "d.pteamgbnm,"
	selectfld = selectfld & "d.teamgbnm,"
	selectfld = selectfld & "d.levelnm,"
	selectfld = selectfld & "d.ridingclass,"
	selectfld = selectfld & "d.ridingclasshelp,"
	selectfld = selectfld & "a.ksportsno,"

	selectfld = selectfld & "e.pidx,"
	selectfld = selectfld & "e.pnm,"

	selectfld = selectfld & "b.playeridx,"
	selectfld = selectfld & "b.username,"
	selectfld = selectfld & "c.gameyear,"
	selectfld = selectfld & "a.gametime ,"
	selectfld = selectfld & "a.team,"
	selectfld = selectfld & "a.teamANa,"


	selectfld = selectfld & " '',"
	selectfld = selectfld & "a.total_order,"


	selectfld = selectfld & "a.pubcode,"
	selectfld = selectfld & "a.pubname,"
	selectfld = selectfld & "a.round,"
	selectfld = selectfld & "(select top 1 RGameLevelidx from tblRGameLevel where GameTitleIDX = a.gametitleidx and GbIDX = a.gamekey3 and DelYN = 'N'),"
	selectfld = selectfld & "a.gamememberidx,"

	'감점 이란게 없으니 그냥 다통과되도록'
	selectfld = selectfld & "'0' "

	sqlstr = "select "&selectfld&" from  SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx  "
	sqlstr = sqlstr & "	inner join sd_TennisTitle as c on a.GameTitleIDX = c.GameTitleIDX and c.DelYN = 'N' "
	sqlstr = sqlstr & "	inner join tblTeamGbInfo as d ON a.gamekey3= d.TeamGbIDX and  d.delyn = 'N' "

	'선수마다 각각 넣어줄꺼다.
	sqlstr = sqlstr & "	inner join sd_groupMember as e ON a.gameMemberIDX= e.gameMemberIDX  "

	sqlstr = sqlstr & "	where a.GameTitleIDX = "&r_tidx&"  and a.gamekey3="&r_gbidx&" and a.gubun < 100  " ' 재경기 아닌것에다가...

	SQL = "insert Into tblGameRecord ("&insertfld&") "&sqlstr&" "
	Call db.execSQLRs(SQL , null, ConStr)

	'gidxfld = ", (SELECT  STUFF(( select top 10 ','+ CAST(idx AS varchar) from sd_groupMember where gameMemberIDX = a.gameMemberIDX order by orderno for XML path('') ),1,1, '' ))  as gidx " '그룹소속선수들
	'pnmfld = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.gameMemberIDX order by orderno for XML path('') ),1,1, '' ) )  as pnm " '그룹소속선수들



Case "20103" '복합마술 ##############################################################################################

	'부명칭
	SQL = "select top 1 pubname from  SD_tennisMember	where GameTitleIDX = "&r_tidx&"  and gamekey3="&r_gbidx&" and gubun < 100 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	pubname = rs(0)

	selectfld = "a.GameTitleIDX,"
	selectfld = selectfld & "c.titleCode,"
	selectfld = selectfld & "c.GameTitleName,"
	selectfld = selectfld & "a.gamekey3,"
	selectfld = selectfld & "d.levelno,"
	selectfld = selectfld & "d.pteamgbnm,"
	selectfld = selectfld & "d.teamgbnm,"
	selectfld = selectfld & "d.levelnm,"
	selectfld = selectfld & "d.ridingclass,"
	selectfld = selectfld & "d.ridingclasshelp,"
	selectfld = selectfld & "a.ksportsno,"
	selectfld = selectfld & "a.playeridx,"
	selectfld = selectfld & "a.username,"
	selectfld = selectfld & "b.playeridx,"
	selectfld = selectfld & "b.username,"
	selectfld = selectfld & "c.gameyear,"
	selectfld = selectfld & "a.gametime ,"
	selectfld = selectfld & "a.team,"
	selectfld = selectfld & "a.teamANa,"
	selectfld = selectfld & "a.boo_orderno,"
	selectfld = selectfld & "a.total_order,"
	selectfld = selectfld & "a.pubcode,"
	selectfld = selectfld & "a.pubname,"
	selectfld = selectfld & "a.round,"
	selectfld = selectfld & "(select top 1 RGameLevelidx from tblRGameLevel where GameTitleIDX = a.gametitleidx and GbIDX = a.gamekey3 and DelYN = 'N'),"
	selectfld = selectfld & "a.gamememberidx,"

	'감점'
	selectfld = selectfld & "a.off1 + a.score_total " '0 만활용할꺼다 흠..'

	sqlstr = "select "&selectfld&" from  SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx  "
	sqlstr = sqlstr & "	inner join sd_TennisTitle as c on a.GameTitleIDX = c.GameTitleIDX and c.DelYN = 'N' "
	sqlstr = sqlstr & "	inner join tblTeamGbInfo as d ON a.gamekey3= d.TeamGbIDX and  d.delyn = 'N' "
	sqlstr = sqlstr & "	where a.GameTitleIDX = "&r_tidx&"  and a.gamekey3="&r_gbidx&" and a.gubun < 100 and a.Round =2 "

	SQL = "insert Into tblGameRecord ("&insertfld&") "&sqlstr&" "
	Call db.execSQLRs(SQL , null, ConStr)


 End Select '####################################################################################################################################################'


	'실적전송
	'실적내용이 있다면 지우고 다시 넣는다.
	'jinjinTbl = "KoreaBadminton_Info.dbo.tblESRESULT" '진진테이블

	' ,PCLASS_CD ----------------------> ES
	' ,TO_CD	----------------------> TIDX (대회코드)
	' ,PERSON_NO ------------------------> ksportsno
	' ,SEQ -------------------------------> 동일인이 대회에 참여한 횟수
	' ,DETAIL_CLASS_CD --------------------->  22 승마 (CLASS_CD)  9 일반부 (KIND_CD) 33 장애물 단체 A Class >> CLASS_CD+KIND_CD+BASE_CLASS_CD
	' ,DETAIL_CLASS_NM ---------------------> 장애물 단체 A Class
	' ,RESULTRANK ---------------------------> 1
	' ,CLASS_CD ----------------------------> 22 장애물
	' ,PLAYER_CNT --------------------------> 단체전 출전팀 수 , 개인전 출전선수 수
	' ,PLAY_YN -----------------------------> 단체전참가 여부 Y=참가,N=미참가,X=해당없음
	' ,RECORD
	' ,NEW_REC_NM
	' ,MA_TYPE
	' ,RH_CD
	' ,TEAM_CD ------------------------------>
	' ,tidx
	' ,lidx
	' ,writedate

	' 6	중등부		2
	' 7	고등부		3
	' 8	대학부		4
	' 9	일반부		5
	' A	동호인부   6
	' F	통합부		63
	' Y	초등부		1

	select case left(pubname,1)
	case "초" : kindcd = "Y"
	case "중" : kindcd = "6"
	case "고" : kindcd = "7"
	case "대" : kindcd = "8"
	case "일" : kindcd = "9"
	case "동" : kindcd = "A"
	case "통" : kindcd = "F"
	end select

  SQl = "Delete from KoreaBadminton_Info.dbo.tblESRESULT where TO_CD = '"&r_tidx&"' and gbidx = '"&r_gbidx&"'  "
  Call db.execSQLRs(SQL , null, ConStr)

  SEQCNT = " select count(*) from tblGameRecord as a where tidx = '"&r_tidx&"' and playeridx = a.playerIDX "
  DETAIL_CLASS_CD = " Select top 1 '22' + '"&kindcd&"' + CDB from tblKSpubcode as kspub where type = 'BCD' and CDA = a.CDANM and KINDNM = a.CDBNM and CLASSNM = a.CLASSNM "
  DETAIL_CLASS_NM = " Select top 1 CDBNM from tblKSpubcode as kspub where type = 'BCD' and CDA = a.CDANM and KINDNM = a.CDBNM and CLASSNM = a.CLASSNM "
  PLAYER_CNT = "select count(distinct playeridx) from tblGameRecord as a where tidx = '"&r_tidx&"' and gbidx = '"&r_gbidx&"' "
  PLAY_YN = " select case when count(*) >0 then 'Y' else 'N' end from tblGameRecord as a where tidx = '"&r_tidx&"' and playeridx = a.playerIDX and CDANM = '단체' "


  fld = " tidx,ksportsno, ("&SEQCNT&") , ("&DETAIL_CLASS_CD&") , ("&DETAIL_CLASS_NM&") , gameOrder, ("&PLAYER_CNT&"), ("&PLAY_YN&"),team,tidx,gbidx,RGameLevelidx "
  selectQ = " select "&fld&" from tblGameRecord as a where tidx = '"&r_tidx&"' and gbidx = '"&r_gbidx&"' "

  insertFLD = " TO_CD,PERSON_NO,SEQ,DETAIL_CLASS_CD,DETAIL_CLASS_NM,RESULTRANK,PLAYER_CNT,PLAY_YN,TEAM_CD,tidx,gbidx,lidx"
  SQL = "insert into KoreaBadminton_Info.dbo.tblESRESULT ("&insertFLD&") ("&selectQ&")"

  ' response.write sql
  ' response.end

  Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
