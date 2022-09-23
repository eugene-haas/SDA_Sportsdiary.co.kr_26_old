<%
	
	title = oJSONoutput.TITLE
	idx = oJSONoutput.TitleIDX

	fstr = oJSONoutput.FSTR ' 개인전, 단체전
	teamGb = oJSONoutput.TEAMGB '선택한 부 
	LevelGb = oJSONoutput.LEVELGB ' 부의 지역 
	

	'Response.Write "fstr : " & fstr & "<Br>"
	'Response.Write "teamGb : " & teamGb & "<Br>"
	'Response.Write "LevelGb : " & LevelGb & "<Br>"

	Set db = new clsDBHelper

    SQL =  " select "
    SQL = SQL & " (case  when '"&LevelGb&"'='최종라운드' then '"&teamGb&"'+'007' else case when NewLevel+1 = '"&teamGb&"'+'007' then NewLevel+2 else NewLevel+1 end  end) as NewLevel"
    SQL = SQL & " ,(case  when '"&LevelGb&"'='최종라운드' then 7 else case when NewOrderBy+1 = 7 then NewOrderBy+2 else NewOrderBy+1 end  end ) as NewOrderBy"
    SQL = SQL & " from ( "
    SQL = SQL & " select Max(Level) as NewLevel, Max(Orderby)  as NewOrderBy "
    SQL = SQL & " from tblLevelInfo "
    SQL = SQL & " where SportsGb = 'tennis' and  DelYN = 'N' and TeamGb = '" & teamGb &"' "
    SQL = SQL & " )a "

	'Response.Write "SQL : " & SQL & "<Br>"

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	Do Until rs.eof
    MaxLevelGb = rs("NewLevel") 'p1
    MaxOrderBy = rs("NewOrderBy")
  rs.movenext
  Loop

	IF(ISNULL(MaxOrderBy)= True) Then
		MaxOrderBy = 1
	End IF

	IF(ISNULL(MaxLevelGb)= True) Then
		MaxLevelGb = teamGb & "001"
	END IF

  'Response.Write "MaxOrderBy : " & MaxOrderBy & "<BR>"
  'Response.Write "MaxLevelGb : " & MaxLevelGb & "<BR>"
	
  IF LevelGb <> "" THEN

		SQL = "select Count(*) from tblLevelINfo where SportsGb = 'tennis' and LevelNm = '" & LevelGb & "' and TeamGb = '" & teamGb & "' and DelYN = 'N'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'Response.Write "SQL : " & SQL& "<BR>"
		'Response.End
		If Not rs.EOF Then 
		 LevelCnt =	rs(0)
		End If

		IF Cdbl(LevelCnt) = 0  Then
			SQL = " insert into tblLevelInfo " 
			SQL = SQL & " (SportsGb,TeamGb, Level, Sex, LevelNm, Orderby) "
			SQL = SQL & " values ('tennis','" & teamGb & "','" & MaxLevelGb & "','Man','" & LevelGb & "'," & MaxOrderBy & ")"
			Call db.execSQLRs(SQL , null, ConStr)
		End IF

	END IF
  'Response.Write "SQL : " & SQL& "<BR>"
	'Response.End

	If  fstr = "tn001001" then
	SQL = "select sex,PTeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('200', '201') and DelYN = 'N' order by Orderby asc"
	Else
	SQL = "select sex,TeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis'  and PTeamGb in ('202') and DelYN = 'N' order by Orderby asc"
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End If

	'else
	SQL = "select Level,LevelNm,Orderby  from tblLevelINfo where SportsGb = 'tennis' and TeamGb = '" & teamGb & "' and DelYN = 'N' order by Orderby asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS2 = rs.GetRows()
	End If

	'Response.Write "SQL : " & SQL& "<BR>"
	'Response.End

	db.Dispose
	Set db = Nothing

	fstr2 = teamGb
%>
<!-- #include virtual = "/pub/html/swimAdmin/gameinfoLevelFormLine1.asp" -->