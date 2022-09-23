<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'16,20,42
	totcnt        = fInject(Request("totcnt"))
	gametitleidx  = fInject(Request("gametitleidx"))
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	seed          = fInject(Request("seed"))
	GameType      = fInject(Request("GameType"))
	totplayer     = fInject(Request("PlayerCnt"))
	'대회강수
'	totcnt = "64"
	'대회번호
'	Gametitleidx  = "52"
	'체급번호
'	RGameLevelIDX = "481"
	'해당체급 총참가자수
'	totplayer = "64"

	

	chkSQL = " EXEC Sportsdiary.dbo.View_GameRandom2 "
  chkSQL = chkSQL & " @SportsGb = '"&Request.Cookies("SportsGb")&"' "
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
