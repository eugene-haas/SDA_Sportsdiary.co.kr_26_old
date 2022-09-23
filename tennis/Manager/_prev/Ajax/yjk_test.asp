<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'16,20,42
	totcnt        = Request("totcnt")
	gametitleidx  = Request("gametitleidx")
	RGameLevelIDX = Request("RGameLevelIDX")
	
	'chkSQL = "select UserName from SportsDiary.dbo.tblrplayermaster  where gametitleidx='"&GameTitleIDX&"' and RgameLevelIDX='"&RGameLevelIDX&"' Order By newid()"
	
	chkSQL = " EXEC Sportsdiary.dbo.View_GameLot "
  chkSQL = chkSQL & " @GTitleIDX = '" & GameTitleIDX & "' "
  chkSQL = chkSQL & ",@RGLevelIDX = '" & RGameLevelIDX & "' "
	
	
'	Response.Write (chkSQL)
	
	Set CRs = Dbcon.Execute(ChkSQL)


	'If Not (CRs.Eof Or CRs.Bof) Then 
	'	  i = 1
	'		result = ""
	'		Do Until CRs.Eof 
	'			result = result&CRs(0)
%>
	

<%
		'			i = i + 1
		'		CRs.MoveNext
		'	Loop 
		Response.Write CRs(0)
	'End If 
%>