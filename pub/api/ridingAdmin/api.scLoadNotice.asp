<%
'#############################################

'내용 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then
		r_idx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	SQL = "SELECT top 1  gametime, gametimeend , noticetitle from sd_tennisMember where gamememberidx = " & r_idx & " and gubun = 100 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		

	If Not rs.eof Then
		e_idx = r_idx
		e_gubun = 100
		e_noticestart = rs("gametime")
		e_noticeend = rs("gametimeend")
		e_noticetitle = rs("noticetitle")
	End if

	%><!-- #include virtual = "/pub/html/riding/scform.asp" --><%

	db.Dispose
	Set db = Nothing
%>

