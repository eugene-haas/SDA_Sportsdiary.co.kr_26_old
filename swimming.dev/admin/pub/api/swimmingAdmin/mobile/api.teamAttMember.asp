<%
'#############################################
'팀 참가신청 목록
'#############################################
	Set db = new clsDBHelper

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = fInject(oJSONoutput.TIDX)
	End if
	If hasown(oJSONoutput, "TEAM") = "ok" then
		team = isnulldefault(fInject(oJSONoutput.TEAM),"")
	End if




	fld = " (case when itgubun = 'I' then P1_username else b.username end) as unm, itgubun,cdcnm "
	If team = "" Then
	SQL = "select "&fld&" from tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and a.DelYN = 'N'  and a.P1_team is null   order by a.p1_username"
	else
	SQL = "select "&fld&" from tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and a.DelYN = 'N'  and a.P1_team = '"&team&"'   order by a.p1_username"
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)





	If rs.eof Then
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	else
		arrK = rs.GetRows()
	End if	

	Set rs = Nothing
	db.Dispose
	Set db = Nothing	



%>




	<%
	If IsArray(arrK) Then
		For ari = LBound(arrK, 2) To UBound(arrK, 2)
			a_pname = arrK(0, ari)
			a_itgubun = arrK(1,ari)
			a_cdcnm = arrK(2,ari)
			
			Response.write "<div>"& a_pname &  " | " & a_cdcnm &  "</div>"

		Next 
	End if
	%>
