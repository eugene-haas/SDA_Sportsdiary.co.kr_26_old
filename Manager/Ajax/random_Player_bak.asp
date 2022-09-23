<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'16,20,42
	totcnt        = Request("totcnt")
	gametitleidx  = Request("gametitleidx")
	RGameLevelIDX = Request("RGameLevelIDX")

	
	
	chkSQL = " EXEC Sportsdiary.dbo.View_GameLot "
  chkSQL = chkSQL & " @GTitleIDX = '" & GameTitleIDX & "' "
  chkSQL = chkSQL & ",@RGLevelIDX = '" & RGameLevelIDX & "' "
'Response.Write chkSQL
		Set CRs = Dbcon.Execute(ChkSQL)
%>
	

<%
	Response.Write CRs(0)
%>