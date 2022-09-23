<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	strFieldName = " EnterType,Team,TeamNm,nation,sido,Sexno,groupnm,TeamRegDt,TeamMakeDt,jangname,readername,ZipCode,Address,TeamTel,SvcEndDt "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql &  "  FROM tblTeamInfo  "
	strSql = strSql &  " WHERE TeamIDX = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then

		e_EnterType = rs(0)
		e_Team = rs(1)
		e_TeamNm = rs(2)
		e_nation = rs(3)
		e_sido = rs(4)
		e_Sexno = rs(5)
		e_groupnm = rs(6)
		e_TeamRegDt = isNulldefault(rs(7),"")
		'e_TeamRegDt = Replace(e_TeamRegDt,"-","/") '년도만
		e_TeamMakeDt = isNulldefault(rs(8)," ")
		e_TeamMakeDt = Replace(e_TeamMakeDt,"-","/")
		e_jangname = rs(9)
		e_readername = rs(10)
		e_ZipCode = rs(11)
		e_Address = rs(12)
		e_TeamTel = rs(13)
		e_SvcEndDt = isNulldefault(rs(14),"")
		e_SvcEndDt = Replace(e_SvcEndDt,"-","/")
		e_idx = reqidx
	End if
	%><!-- #include virtual = "/pub/html/swimming/teamform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
