<%
'#############################################
'결승 라운드 참가자로 만든다.
'#############################################
	'request
	idx = oJSONoutput.IDX 'tblRGameLevel idx
	tidx = oJSONoutput.TitleIDX
	title = oJSONoutput.Title
	teamnm = oJSONoutput.TeamNM
	areanm = oJSONoutput.AreaNM
	levelno = oJSONoutput.LevelNo
	in_midx = oJSONoutput.midx

	Set db = new clsDBHelper

	SQL = "select max(sortNo) from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "&levelno&" and DelYN = 'N' and Round = 1 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	maxSortno = rs(0)
	sortno = CDbl(maxSortno) + 1

If in_midx = "0" Then 'bye
	'최종 라운드 1라운드 멤버 등록
	insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round,SortNo "
	selectfield = "2,GameTitleIDX,0,'부전',gamekey1,gamekey2,"&levelno&","&Left(levelno,5)&",'"&teamnm&"',1,"&sortno&"  "
	selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gubun in (2,3) and GameTitleIDX = "&tidx&" and teamGb= " & Left(levelno,5)
	SQL = "insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" "
	Call db.execSQLRs(SQL , null, ConStr)	
else
	'최종 라운드 1라운드 멤버 등록
	insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,Round,SortNo "
	selectfield = "2 ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,"&levelno&","&Left(levelno,5)&",TeamANa,TeamBNa,tryoutgroupno,key3name,1,"&sortno&"  "
	selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & in_midx

	SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	midx = rs(0)

	'파트너 insert
	insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
	selectfield =  " "&midx&",PlayerIDX,userName,TeamANa,TeamBNa "
	SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & in_midx
	Call db.execSQLRs(SQL , null, ConStr)
End if


	Set rs = Nothing
	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>