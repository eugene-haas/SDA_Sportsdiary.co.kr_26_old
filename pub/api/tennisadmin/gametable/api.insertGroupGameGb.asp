<%
	fstr = oJSONoutput.FSTR
	title = oJSONoutput.TITLE
	idx = oJSONoutput.TitleIDX
	groupGameGb = oJSONoutput.GROUPGAMEGB

	Set db = new clsDBHelper

	If  fstr = "tn001001" then
    SQL = "select Max(TeamGb) + 1 as NewTeamGb , Max(Orderby) + 1 as NewOrderBy"
    SQL = SQL & " from tblTeamGbInfo "
    SQL = SQL & " where SportsGb = 'tennis' and  PTeamGb in ('200','201') and DelYN = 'N' "
  Else
    SQL = "select Max(TeamGb) + 1 as NewTeamGb, Max(Orderby) + 1 as NewOrderBy "
    SQL = SQL & " from tblTeamGbInfo "
    SQL = SQL & " where SportsGb = 'tennis' and  PTeamGb in ('202') and DelYN = 'N' "
  End If

  'Response.Write "SQL : " & SQL& "<BR>"

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	Do Until rs.eof
    MaxTeamGb = rs("NewTeamGb") 'p1
    MaxOrderBy = rs("NewOrderBy")
  rs.movenext
  Loop
  'Response.Write "MaxOrderBy : " & MaxOrderBy & "<BR>"
  'Response.Write "MaxTeamGb : " & MaxTeamGb & "<BR>"
  
  SQL = " insert into tblTeamGbInfo " 
  SQL = SQL & " (SportsGb,Sex,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,EnterType,Orderby) "
  SQL = SQL & " values ('tennis','Man',201,'개인복식',"&MaxTeamGb&",'"&groupGameGb&"','A'," & MaxOrderBy & ")"
  'Response.Write "SQL : " & SQL& "<BR>"
	Call db.execSQLRs(SQL , null, ConStr)

	If  fstr = "tn001001" then
	SQL = "select sex,PTeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('200', '201') and DelYN = 'N' order by Orderby asc"
	Else
	SQL = "select sex,TeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis'  and PTeamGb in ('202') and DelYN = 'N' order by Orderby asc"
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End If

	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/tennisAdmin/gameinfoLevelFormLine1.asp" -->