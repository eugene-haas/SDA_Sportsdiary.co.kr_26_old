<%
'#############################################
'종목 합치기
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX 
	End If
	If hasown(oJSONoutput, "FINDYEAR") = "ok" then
		nowgameyear= oJSONoutput.FINDYEAR 
	End If
	If hasown(oJSONoutput, "TM") = "ok" then
		settime= oJSONoutput.TM 
		timestr = setTimeFormat(settime)
	End If

	'Response.write Left(timestr,5) & "$$"

	SQL = "Update tblRGameLevel Set gametime = '"&Left(timestr,5)&"' where gametitleidx = " & tidx
	Call db.execSQLRs(SQL , null, ConStr)

  
  '리스트의 쿼리에 nowgameyear   'tidx필요########################
  %><!-- #include virtual = "/pub/html/riding/gameorderlist.asp" --><%

  db.Dispose
  Set db = Nothing
%>
