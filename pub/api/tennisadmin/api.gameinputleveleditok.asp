<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.IDX

	titleidx = oJSONoutput.TitleIDX
	title = oJSONoutput.Title
	groupgb = oJSONoutput.GroupGameGb
	teamgb = oJSONoutput.TeamGb
	levelgb = oJSONoutput.LevelGb
	okprop = hasown(oJSONoutput, LevelGb)
	courtcnt = 9 'oJSONoutput.COURTCNT

	versusgb = oJSONoutput.VersusGb
	gamedate = oJSONoutput.GameDate
	gametime = oJSONoutput.GameTime

	startsc = 	oJSONoutput.StartSC
	lastrnd = 	oJSONoutput.LastRnd

	boo = oJSONoutput.GroupNm 
	teamgbnm = oJSONoutput.TeamNm
	levelnm = oJSONoutput.LevelNm
	entrycnt = oJSONoutput.EntryCnt

    bigo= oJSONoutput.bigo

	transsmy = oJSONoutput.TRANSSMY '변형요강 Y
	attw = oJSONoutput.ATTW '참가신청허용
	atte = oJSONoutput.ATTE '참가신청수정허용
	attd = oJSONoutput.ATTD '참가신청삭제허용
	cfg = transsmy & attw & atte & attd 
	joocnt = oJSONoutput.JOOCNT '예선편성할 조수

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

	If Trim(joocnt) = "" Then
		joocnt = 32
	End if

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

		SQL = "Select joocnt,setrnkpt from tblRGameLevel where RGameLevelidx= " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			setrnkpt = rs("setrnkpt") '랭킹포인트 반영여부
		End if

		updatevalue = " GameTitleIDX = "&titleidx&", TeamGb = '"&teamgb&"',TeamGbNm = '"&teamgbnm&"',Level = '"&levelgb&"',GameType = '"&versusgb&"',GameDay='"&gamedate&"',GameTime = '"&gametime&"',startScore = "&startsc&",EndRound = "&lastrnd&", EntryCntGame =  " & entrycnt & ", cfg = '"&cfg&"',joocnt = "&joocnt&"  "
		updatevalue =updatevalue &" , bigo='"&bigo&"' , fee = " & fee & ", fund = " & fund & ", LastRchk = " & LastRchk

		SQL = " Update  tblRGameLevel Set  " & updatevalue & " where RGameLevelidx= " & idx
		Call db.execSQLRs(SQL , null, ConStr)
		
		SQL = "Select attmembercnt from tblRGameLevel where RGameLevelidx= " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		attcnt = rs("attmembercnt")
%>

<!-- #include virtual = "/pub/html/tennisAdmin/gameinfolevellist.asp" -->

<%
  db.Dispose
  Set db = Nothing
%>
