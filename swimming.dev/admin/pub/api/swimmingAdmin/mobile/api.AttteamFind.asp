<%
'#############################################
'
'#############################################
	'request
	If hasown(oJSONoutput, "SVAL") = "ok" then
		sval = oJSONoutput.SVAL
	End if

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End if

	Set db = new clsDBHelper


	fld = " p1_team as team ,max(p1_teamnm) as teamnm ,COUNT(*) as cnt,max(a.gametitleidx) as tidx "
	SQL = "select top 20 "&fld&" from  tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and a.DelYN = 'N' and b.delYN = 'N'  where a.GameTitleIDX = "&tidx&" and p1_teamnm like '"&sval &"%'  group by a.P1_team order by a.P1_team"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>