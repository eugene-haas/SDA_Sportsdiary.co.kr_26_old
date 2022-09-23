<%
'#############################################


'#############################################
	'request
	titleidx = oJSONoutput.TitleIDX
	title = oJSONoutput.Title
	groupgb = oJSONoutput.GroupGameGb
	teamgb = oJSONoutput.TeamGb
	levelgb = oJSONoutput.LevelGb
	versusgb = oJSONoutput.VersusGb
	gamedate = oJSONoutput.GameDate
	gametime = oJSONoutput.GameTime
	'courtcnt = oJSONoutput.COURTCNT
	courtcnt = 0

	startsc = 	oJSONoutput.StartSC
	lastrnd = 	oJSONoutput.LastRnd

	boo = oJSONoutput.GroupNm 
	teamgbnm = oJSONoutput.TeamNm
	levelnm = oJSONoutput.LevelNm
	entrycnt = oJSONoutput.EntryCnt
	bigo = oJSONoutput.bigo


	If hasown(oJSONoutput, "fee") = "ok" then
		fee =   oJSONoutput.fee '참가비
	Else
		fee = 0
	End If
	If hasown(oJSONoutput, "fund") = "ok" then
		fund =   oJSONoutput.fund '기금
	Else
		fund = 0
	End If
	If hasown(oJSONoutput, "LastRchk") = "ok" then
		LastRchk =   oJSONoutput.LastRchk		'최종라운드에서 랭킹강수를 구하기 위해 필요한 정보
	Else
		LastRchk = 1
	End if	


	transsmy = oJSONoutput.TRANSSMY '변형요강 Y
	attw = oJSONoutput.ATTW '참가신청허용
	atte = oJSONoutput.ATTE '참가신청수정허용
	attd = oJSONoutput.ATTD '참가신청삭제허용
	joocnt = oJSONoutput.JOOCNT '예선편성할 조수
	cfg = transsmy & attw & atte & attd 

	chk1 = Left(cfg,1)
	chk2 = Mid(cfg,2,1)
	chk3 = Mid(cfg,3,1)
	chk4 = Mid(cfg,4,1)
	If chk1 = "Y" Then
		chk1 = "[변형요강]"
	Else
		chk1 = "[일반요강]"		
	End if
	

	Select Case  versusgb
	Case "sd043003"
		gametypestr = "리그&gt;토너먼트"
	Case "sd043002"
		gametypestr = "토너먼트"
	End Select 
	Set db = new clsDBHelper
	

	'중복검사
	SQL = "select RGameLevelidx,DelYN,attmembercnt,chkJooRull from tblRGameLevel where DelYN='N' and SportsGb = 'tennis' and GameTitleIDX = "&titleidx&" and TeamGb = '"&teamgb&"' and Level = '"&levelgb&"'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then

		SQL = "select ISNULL(max(TeamGbSort),0) from tblRGameLevel where GameTitleIDX = "&titleidx
		Set rsCnt = db.ExecSQLReturnRS(SQL , null, ConStr)
		teamGbSortCnt = rsCnt(0)

		'인서트	
		sortno = teamGbSortCnt + 1
		insertfield = " SportsGb,GameTitleIDX,TeamGb,TeamGbNm,TeamGbSort,Level,GameType,GameDay,GameTime,startScore,EndRound,EntryCntGame,courtcnt,bigo,cfg,JooCnt , fee,fund,LastRchk "
		insertvalue = " 'tennis',"&titleidx&",'"&teamgb&"','"&teamgbnm&"',"&sortno&",'"&levelgb&"','"&versusgb&"','"&gamedate&"','"&gametime&"',"&startsc&","&lastrnd&","&entrycnt&"," & courtcnt&",'"&bigo&"', '"&cfg&"',"&joocnt& "," & fee & "," & fund & "," & LastRchk& "  "  

		SQL = "SET NOCOUNT ON INSERT INTO tblRGameLevel ( "&insertfield&" ) VALUES " 
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs2(0)

		SQL = "select chkJooRull from tblRGameLevel where DelYN='N' and SportsGb = 'tennis' and RGameLevelidx = "&idx
		Set rs3 = db.ExecSQLReturnRS(SQL , null, ConStr)
		rChkJooRull = rs3("chkJooRull")
		attcnt = 0
		DelYN= "N"
	Else
		DelYN = rs("DelYN")
		idx = rs("RGameLevelidx")
		attcnt = rs("attmembercnt")
		rChkJooRull = rs("chkJooRull")
		If DelYN = "Y" Then
			SQL = "update tblRGameLevel  Set  DelYN = 'N' where SportsGb = 'tennis' and GameTitleIDX = "&titleidx&" and TeamGb = '"&teamgb&"' and Level = '"&levelgb&"'"
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	End if

	setrnkpt = "N" '포인트 적용을 했는지 여부


%>

	<!-- #include virtual = "/pub/html/tennisAdmin/gameinfolevellist.asp" -->

<%
  Set rs = Nothing
	Set rs2 = Nothing
  db.Dispose
  Set db = Nothing
%>