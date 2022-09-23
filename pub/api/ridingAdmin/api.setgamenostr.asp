<%
'#############################################

'종목 전체 업데이트

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx= oJSONoutput.IDX
	End if

	If hasown(oJSONoutput, "GHANGEGNO") = "ok" then
		cgno= oJSONoutput.GHANGEGNO
	End if

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX
	End if

	Set db = new clsDBHelper


	SQL = "Select top 1 gamenostr,GbIDX,gametitleidx from tblRGameLevel where RGameLevelidx = " & r_idx 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	i_gno = rs("gamenostr")
	i_gbIDX = rs("gbIDX")
	i_tidx = rs("gametitleidx")


	SQL = "Update tblRGameLevel Set gamenostr = '" & cgno & "' where delYN= 'N' and gametitleidx = "& i_tidx &" and  gbIDX = '" & i_gbIDX & "' "
	Call db.execSQLRs(SQL , null, ConStr)


  'tidx  가 있어야한다.
  %><!-- #include virtual = "/pub/html/riding/gameinfolevellist.asp" --><%

  db.Dispose
  Set db = Nothing
%>
