<%
'######################
'출전부서
'######################
	If hasown(oJSONoutput, "MYCHOICE") = "ok" then
		ntrp = oJSONoutput.MYCHOICE
	End If

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End If

	Set db = new clsDBHelper


	Select Case ntrp
	Case "1.0","1.5","2.0"

			SQL = " select b.GameType, b.TeamGb,case left(b.cfg,1) when 'Y' then b.TeamGbNm +'(B)' else b.TeamGbNm end  TeamGbNm,c.Level,c.LevelNm "
			SQL = SQL &"  ,case when isnull(c.LevelNm,'')='' then '' when c.LevelNm='없음' then '' else c.LevelNm end LevelNm "
			SQL = SQL &"  ,GameDay,GameTime,EntryCntGame"
			SQL = SQL &" ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt ,b.cfg"
			SQL = SQL &" ,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d"
			SQL = SQL &"  from tblRGameLevel b  "
			SQL = SQL &"  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "
			SQL = SQL &"  left join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' "

			If Cookies_sdSex	 = "Man" then
				SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&tidx&"' and c.LevelNm not like '%최종%'  and  b.TeamGb = '20104' "
			Else
				SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&tidx&"' and c.LevelNm not like '%최종%'  and  b.TeamGb = '20101' "
			End If

			SQL = SQL &"  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,b.cfg  "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.EOF Then
				arrA = rs.GetRows()
			End if

	Case "2.5","3.0"

			SQL = " select b.GameType, b.TeamGb,case left(b.cfg,1) when 'Y' then b.TeamGbNm +'(B)' else b.TeamGbNm end  TeamGbNm,c.Level,c.LevelNm "
			SQL = SQL &"  ,case when isnull(c.LevelNm,'')='' then '' when c.LevelNm='없음' then '' else c.LevelNm end LevelNm "
			SQL = SQL &"  ,GameDay,GameTime,EntryCntGame"
			SQL = SQL &" ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt ,b.cfg"
			SQL = SQL &" ,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d"
			SQL = SQL &"  from tblRGameLevel b  "
			SQL = SQL &"  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "
			SQL = SQL &"  left join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' "

			If Cookies_sdSex	 = "Man" then
				SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&tidx&"' and c.LevelNm not like '%최종%'  and  b.TeamGb = '20105' "
			Else
				SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&tidx&"' and c.LevelNm not like '%최종%'  and  b.TeamGb = '20102' "
			End If

			SQL = SQL &"  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,b.cfg  "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.EOF Then
				arrA = rs.GetRows()
			End if
	End Select 


	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/swimAdmin/common/html.choiceboo.asp" -->