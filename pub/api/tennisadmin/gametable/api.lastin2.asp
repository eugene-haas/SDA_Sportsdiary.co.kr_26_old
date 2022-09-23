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

	'멤버 등록
	insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,Round,SortNo "
	selectfield = "0 ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,"&levelno&","&Left(levelno,5)&",TeamANa,TeamBNa,0,key3name,0,0  "
	selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & in_midx

	SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	midx = rs(0)

	'파트너 insert
	insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
	selectfield =  " "&midx&",PlayerIDX,userName,TeamANa,TeamBNa "
	SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & in_midx
	Call db.execSQLRs(SQL , null, ConStr)


	Set rs = Nothing
	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>