<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	strFieldName = " Team,TeamNm,sido,sidonm,leader_key,leader_nm,ZipCode,Address1,address2,phone "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql &  "  FROM tblTeamInfo  "
	strSql = strSql &  " WHERE TeamIDX = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then
		e_idx = reqidx
		e_Team  = rs(0)
		e_TeamNm = rs(1)
		e_sido = rs(2)
		e_sidonm = rs(3)
		e_leader_key = rs(4)
		e_leader_nm = rs(5)
		e_ZipCode = rs(6)
		e_Address1 = rs(7)
		e_address2 = rs(8)
		e_phone = rs(9)
	End if
	%><!-- #include virtual = "/pub/html/riding/Teaminfoform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
