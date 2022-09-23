<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'16,20,42
	totcnt        = fInject(Request("totcnt"))
	gametitleidx  = fInject(Request("gametitleidx"))
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	seed          = fInject(Request("seed"))
	GameType      = fInject(Request("GameType"))
	totplayer     = fInject(Request("totplayer"))
	'대회강수
	totcnt = "32"
	'대회번호
	Gametitleidx  = "49"
	'체급번호
	RGameLevelIDX = "465"
	'해당체급 총참가자수
	totplayer = "32"

	'totcnt = 32
	'Gametitleidx = 48
	'RGameLevelIDX = 440
	'seed = ""
	'GameType = sd040001
	'totplayer = 32

	'대회강수
	'totcnt = "4"
	'대회번호
	'Gametitleidx  = "48"
	'체급번호
	'RGameLevelIDX = "391"
	'해당체급 총참가자수
	'totplayer = "4"


	chkSQL = " EXEC Sportsdiary.dbo.View_GameRandom "
  chkSQL = chkSQL & " @SportsGb = 'judo' "
  chkSQL = chkSQL & ",@totcnt = '"&totcnt&"' "
  chkSQL = chkSQL & ",@GameTitleIDX = '" & GameTitleIDX & "' "
  chkSQL = chkSQL & ",@RGameLevelIDX = '" & RGameLevelIDX & "' "
  chkSQL = chkSQL & ",@seed = '"&seed&"'"
  chkSQL = chkSQL & ",@GameType = '"&GameType&"'"
  chkSQL = chkSQL & ",@totPlayer = '"&totplayer&"'"
	
	'Response.Write chkSQL
	'Response.End
	Set CRs2 = Dbcon.Execute(ChkSQL)		
	'Response.Write LPlayer&"<br>"
	'Response.Write LTeam&"<br>"
	'Response.Write RPlayer&"<br>"
	'Response.Write RTeam&"<br>"

	
	Response.Write CRs2(0)
'	Response.End

%>
