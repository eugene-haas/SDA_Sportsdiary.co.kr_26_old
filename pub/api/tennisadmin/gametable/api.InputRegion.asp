<%
  
  idx = oJSONoutput.IDX
  tidx = oJSONoutput.TitleIDX
  gamekey3 = oJSONoutput.S3KEY '게임종목 키
	levelkey = gamekey3
	gamekey3 = Left(gamekey3,5)
  'endGroup = oJSONoutput.EndGroup
  joRegion = oJSONoutput.JOREGION
  regions = Split(joRegion,"%")
  
  Set db = new clsDBHelper

  for each a in regions
    regionValue = Split(a,"^")
    groupNo = regionValue(0) 
    region = regionValue(1)

	
	'SQL = "update sd_tennismember set place = '"&region&"' where gametitleidx = "&tidx&" and gamekey3= "&levelkey&" and tryoutgroupno = "& groupNo & " and gubun > 1"
	SQL = "update sd_tennismember set place = '"&region&"' where gametitleidx = "&tidx&" and gamekey3= "&levelkey&" and tryoutgroupno = "& groupNo 
	Call db.execSQLRs(SQL , null, ConStr)
	
	SQL = " select a.gamememberIDX "
	SQL = SQL & " from sd_TennisMember as a "
    SQL = SQL & " LEFT JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX"
    'SQL = SQL & " where a.GameTitleIDX = "& tidx  &" and a.gamekey3 = " & levelkey & " and a.tryoutgroupno = "& groupNo &" and a.gubun in (1) and a.DelYN = 'N' "
	SQL = SQL & " where a.GameTitleIDX = "& tidx  &" and a.gamekey3 = " & levelkey & " and a.tryoutgroupno = "& groupNo &" and a.DelYN = 'N' "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	Do Until rs.eof
		delidx2 = rs(0)
		subSQL = "update sd_TennisMember Set place = '" & region & "'  where gamememberIDX = " & delidx2
		Call db.execSQLRs(subSQL , null, ConStr)
	rs.movenext
	Loop

  next
  
  db.Dispose
	Set db = Nothing
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  

%>