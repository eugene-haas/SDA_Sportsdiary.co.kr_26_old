<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'16,20,42
	gametitleidx = fInject(Request("gametitleidx"))
	teamgb  = fInject(Request("teamgb"))
	level = fInject(Request("level"))
	gametype = fInject(Request("gametype"))

	chkSQL = "SELECT GameType, Sex "
	chkSQL = chkSQL & " FROM tblRGameLevel"
	chkSQL = chkSQL & " WHERE DelYN = 'N'"
	chkSQL = chkSQL & " AND GameTitleIDX = '" & gametitleidx & "'"
	chkSQL = chkSQL & " AND GroupGameGb = '" & gametype & "'"
	chkSQL = chkSQL & " AND TeamGb = '" & teamgb & "'"
	chkSQL = chkSQL & " AND Level = '" & level & "'"

	Set CRs = Dbcon.Execute(ChkSQL)
%>

<%
  If CRs.bof OR CRs.Eof Then
		Response.Write "error"
	Else
		Response.Write CRs(0) & "|" & CRs(1)  
	End If
%>