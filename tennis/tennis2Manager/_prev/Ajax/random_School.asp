<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'16,20,42
	totcnt        = fInject(Request("totcnt"))
	gametitleidx  = fInject(Request("gametitleidx"))
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	seed          = fInject(Request("seed"))
	
	
	chkSQL = " EXEC Sportsdiary.dbo.View_GameLot_Team "
  chkSQL = chkSQL & " @GTitleIDX = '" & GameTitleIDX & "' "
  chkSQL = chkSQL & ",@RGLevelIDX = '" & RGameLevelIDX & "' "
  chkSQL = chkSQL & ",@Seed = '" & seed & "' "
'Response.Write chkSQL
		Set CRs = Dbcon.Execute(ChkSQL)
%>
	

<%
	Response.Write CRs(0)
%>