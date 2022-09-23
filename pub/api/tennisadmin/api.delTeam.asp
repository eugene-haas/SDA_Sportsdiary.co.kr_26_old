<%
'#############################################
'팀참여 취소 (예선)
'#############################################
'Response.end

  idx = oJSONoutput.IDX 'tblRGameLevel idx
  tidx = oJSONoutput.TitleIDX 
  title = oJSONoutput.Title
  teamnm = oJSONoutput.TeamNM
  areanm = oJSONoutput.AreaNM
  stateNo = oJSONoutput.StateNo
  S3KEY = oJSONoutput.S3KEY
  P1 = oJSONoutput.P1
  JONO = oJSONoutput.JONO
  midx = oJSONoutput.GAMEMEMBERIDX
  PLAYERIDX = oJSONoutput.PLAYERIDX
  PLAYERIDXSub = oJSONoutput.PLAYERIDXSub
  EndGroup = oJSONoutput.EndGroup
  pos = oJSONoutput.POS

	Set db = new clsDBHelper

	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "

	'gubun 이 0인것만 지우자.
	SQL = "DELETE From "&strtable&" From "&strtable&" As a Left Join "&strtablesub&" As b On a.gameMemberIDX = b.gameMemberIDX Where a.gameMemberIDX = " & midx & " and a.gubun = 0 " 
	Call db.execSQLRs(SQL , null, ConStr)

	'지우고 나면 조에 선수가 없다면 이조보다 아래인 모든 인원의 조번호를 땅기자.
	SQL = "Select tryoutgroupno  from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "&S3KEY&" and gubun in (0,1) and tryoutgroupno = " & jono
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		SQL = "update sd_TennisMember Set tryoutgroupno  = tryoutgroupno -1 where GameTitleIDX = "&tidx&" and gamekey3 = "&S3KEY&" and gubun in (0,1) and tryoutgroupno > " & jono
		Call db.execSQLRs(SQL , null, ConStr)

		'조수업데이트  lastjoono , joocnt update
		SQL = "update tblRGameLevel set lastjoono = lastjoono -1 , joocnt = joocnt - 1  where DelYN = 'N' and  RGameLevelidx = " & idx
		Call db.execSQLRs(SQL , null, ConStr)
	End if

	'참가팀 카운트 업데이트
	SQL = "Update tblRGameLevel Set attmembercnt = (SELECT count(*) as attCnt FROM tblGameRequest where  GameTitleIDX = " & tidx & " and Level = " & S3KEY & " and DelYN = 'N' ) where RGameLevelIdx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)


	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>