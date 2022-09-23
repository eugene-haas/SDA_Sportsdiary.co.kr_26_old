<%

	TeamIDX = oJSONoutput.TeamIDX


	Set db = new clsDBHelper

	strSql = "SELECT top 1  TeamIDX,Team,TeamNm,sido,TeamTel,ZipCode,Address,AddrDtl,TeamLoginPwd   "
	strSql = strSql &  "  FROM tblTeamInfo  "
	strSql = strSql &  " WHERE TeamIDX = " & TeamIDX
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then
		TeamIDX = rs("TeamIDX")
		Team = rs("Team")
		TeamNm = rs("TeamNm")
		sido = rs("sido")
		TeamTel = rs("TeamTel")
		ZipCode = rs("ZipCode")
		Address = rs("Address")
		AddrDtl = rs("AddrDtl")
		TeamLoginPwd = rs("TeamLoginPwd")
	End if

	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/tennisAdmin/Teaminfoform.asp" -->