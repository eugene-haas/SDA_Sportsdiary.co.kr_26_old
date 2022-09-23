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


	fld = " (case when max(itgubun) = 'I' then p1_playeridx  else b.playeridx   end) as pidx  ,(case when max(itgubun) = 'I' then max(P1_UserName)  else max(b.username)  end) as unm  , max(p1_team) as team ,max(p1_teamnm) as tnm, max(a.gametitleidx) as tidx "

	SQL = "  ;with attplayer as  "
	SQL = SQL & "( select top 10 "&fld&" from  tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N'  where a.GameTitleIDX = "&tidx&" and (p1_username like '"&sval &"%' or b.username like '"&sval&"%') and a.DelYN = 'N'  group by p1_playeridx, b.playeridx order by unm )"
	SQL = SQL & "  select * from attplayer group by pidx,unm,team,tnm,tidx "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	Response.write jsonTors_arr(rs)

	db.Dispose
	Set db = Nothing
%>