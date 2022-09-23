<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper
	tblnm = "tblPlayer"
	chkfld = "playerIDX"

	strFieldName = " userType,UserName,UserPhone,    Ajudgelevel,Kef1,Kef2,Kef3,Kef4,FEI1,FEI2,FEI3,FEI4,FEI5,FEI6,FEI7,FEI8,FEI9    "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql &  "  FROM "&tblnm&"  "
	strSql = strSql &  " WHERE "&chkfld&" = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then
		e_idx = reqidx

		e_userType = rs(0)
		e_UserName = rs(1)
		e_UserPhone = rs(2)
		e_Ajudgelevel = rs(3)
		e_Kef1 = rs(4)
		e_Kef2 = rs(5)
		e_Kef3 = rs(6)
		e_Kef4 = rs(7)
		e_FEI1 = rs(8)
		e_FEI2 = rs(9)
		e_FEI3 = rs(10)
		e_FEI4 = rs(11)
		e_FEI5 = rs(12)
		e_FEI6 = rs(13)
		e_FEI7 = rs(14)
		e_FEI8 = rs(15)
		e_FEI9 = rs(16)
		

	End if
	%><!-- #include virtual = "/pub/html/riding/rForm.asp" --><%

	db.Dispose
	Set db = Nothing
%>
