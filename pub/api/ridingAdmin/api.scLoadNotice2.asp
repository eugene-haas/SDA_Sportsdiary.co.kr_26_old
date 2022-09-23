<%
'#############################################

'내용 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then
		r_idx = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "SNO") = "ok" Then
		r_sno = oJSONoutput.SNO
	End If
	If hasown(oJSONoutput, "GNO") = "ok" Then 'gameno
		r_gno = oJSONoutput.GNO
	End If
	If hasown(oJSONoutput, "NOIDX") = "ok" Then
		r_noidx = oJSONoutput.NOIDX
	End if	

'gameinput_area


	Set db = new clsDBHelper
	SQL = "SELECT top 1  idx, sdatetime , edatetime , noticetitle, sortno from tblGameNotice where RgameLevelIDX = " & r_idx & " and sortno =  " & r_sno


	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		

	If Not rs.eof Then
		e_idx = r_idx
		e_noidx = rs("idx")
		e_sno = r_sno
		e_noticestart = rs("sdatetime")
		e_noticeend = rs("edatetime")
		e_noticetitle = rs("noticetitle")
	End if

	%><!-- #include virtual = "/pub/html/riding/orderform.asp" --><%

	db.Dispose
	Set db = Nothing
%>

