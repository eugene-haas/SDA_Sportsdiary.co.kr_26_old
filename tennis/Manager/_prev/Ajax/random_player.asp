<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'16,20,42
	totcnt        = fInject(Request("totcnt"))
	gametitleidx  = fInject(Request("gametitleidx"))
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	seed          = fInject(Request("seed"))
'	gametitleidx  = "46"
'	RGameLevelIDX = "306"
'	seed          = "6318,6302"



	chkSQL = " EXEC Sportsdiary.dbo.View_GameLot "
  chkSQL = chkSQL & " @GTitleIDX = '" & GameTitleIDX & "' "
  chkSQL = chkSQL & ",@RGLevelIDX = '" & RGameLevelIDX & "' "
  chkSQL = chkSQL & ",@seed = '"&seed&"'"
'	Response.Write chkSQL
'	Response.End

		Set CRs = Dbcon.Execute(ChkSQL)
%>
	

<%
	Response.Write CRs(0)
%>