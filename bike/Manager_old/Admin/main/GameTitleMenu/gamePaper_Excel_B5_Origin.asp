<!-- #include file="../../dev/dist/config.asp"-->
<%

  Response.CharSet="utf-8"
  Session.codepage="65001"
  Response.codepage="65001"
  Response.ContentType="text/html;charset=utf-8"

  Dim GameTitleIDX	: GameTitleIDX 		= fInject(Request("GameTitleIDX"))
	Dim GameDay		    : GameDay 		    = fInject(Request("GameDay"))	
	Dim StadiumIDX		: StadiumIDX 		= fInject(Request("StadiumIDX"))
  Dim StadiumNum		: StadiumNumber 		= fInject(Request("StadiumNumber"))
	Dim SearchName	: SearchName		= fInject(Request("SearchName"))

  Dim DEC_GameTitleIDX	: DEC_GameTitleIDX 		= crypt.DecryptStringENC(GameTitleIDX)
	Dim DEC_GameDay		    : DEC_GameDay 		    = GameDay
	Dim DEC_StadiumIDX		: DEC_StadiumIDX 		= crypt.DecryptStringENC(StadiumIDX)
  Dim DEC_StadiumNumber	: DEC_StadiumNumber     = StadiumNumber
	Dim DEC_Searchkeyword	: DEC_Searchkeyword		= Searchkeyword
  
%>


<%
  Function GetSQL(ByVal DEC_GameDay, ByVal DEC_GameTitleIDX, ByVal DEC_StadiumIDX, ByVal DEC_StadiumNumber, ByVal DEC_Searchkeyword, ByVal DEC_SearchKey )
    CSQL = " SELECT CCC.GameTitleIDX, dbo.FN_NameSch(CCC.GameTitleIDX, 'GameTitleIDX') AS GameTitleNM, CCC.GameLevelDtlIDX,  CCC.TourneyIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
    CSQL = CSQL & " 	CCC.TeamGbNM, CCC.LevelNM, CCC.GameTypeNM,"
    CSQL = CSQL & " 	CCC.Result, CCC.ResultType, CCC.ResultNM, CCC.Jumsu,"
    CSQL = CSQL & " 	CCC.GameStatus, CCC.[ROUND], CCC.Sex,"
    CSQL = CSQL & " 	CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
    CSQL = CSQL & " 	CCC.LPlayer1, CCC.LPlayer2, CCC.Rplayer1, CCC.Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
    CSQL = CSQL & " 	CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType"
    CSQL = CSQL & " FROM "
    CSQL = CSQL & " ("
    CSQL = CSQL & " 	SELECT "
    CSQL = CSQL & " 	BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TourneyIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
    CSQL = CSQL & " 	BBB.TeamGbNM, BBB.LevelNM, BBB.GameTypeNM,"
    CSQL = CSQL & " 	BBB.Result, BBB.ResultType, BBB.ResultNM, BBB.Jumsu,"
    CSQL = CSQL & " 	BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
    CSQL = CSQL & " 	ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
    CSQL = CSQL & " 	GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName,"
    CSQL = CSQL & " 	LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2"
    CSQL = CSQL & " 	FROM"
    CSQL = CSQL & " 	("
    CSQL = CSQL & " 		SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TourneyIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
    CSQL = CSQL & " 		AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
    CSQL = CSQL & " 		AA.Result, AA.ResultType, AA.ResultNM, AA.Jumsu,"
    CSQL = CSQL & " 		AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName,"
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2"
    CSQL = CSQL & " 		FROM"
    CSQL = CSQL & " 		("
    CSQL = CSQL & " 		    SELECT A.GameTitleIDX, A.GameLevelDtlIDX,A.TourneyIDX as TourneyIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
    CSQL = CSQL & " 		    KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
    CSQL = CSQL & " 		    KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
    CSQL = CSQL & " 		    E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
    CSQL = CSQL & " 		    KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
    CSQL = CSQL & " 		    A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName"
    CSQL = CSQL & " 		    ,STUFF(("
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + UserName "
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    CSQL = CSQL & " 						  AND DelYN = 'N'"           
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
    CSQL = CSQL & " 					  AND DelYN = 'N'"         
    CSQL = CSQL & " 		    		),1,1,'') AS LPlayers"
    CSQL = CSQL & " 		    ,STUFF(("
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + UserName "
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    CSQL = CSQL & " 						  AND DelYN = 'N'"       
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
    CSQL = CSQL & " 					  AND DelYN = 'N'"             
    CSQL = CSQL & " 		    		),1,1,'') AS RPlayers"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		    ,STUFF((		"
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    CSQL = CSQL & " 						  AND DelYN = 'N'"       
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
    CSQL = CSQL & " 					  AND DelYN = 'N'"             
    CSQL = CSQL & " 		    		),1,1,'') AS LTeams"
    CSQL = CSQL & " 		    ,STUFF((		"
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    CSQL = CSQL & " 						  AND DelYN = 'N'"       
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
    CSQL = CSQL & " 					  AND DelYN = 'N'"             
    CSQL = CSQL & " 		    		),1,1,'') AS RTeams"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		    FROM tblTourney A"
    CSQL = CSQL & " 		    INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
    CSQL = CSQL & " 		    INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
    CSQL = CSQL & " 		    	LEFT JOIN ("
    CSQL = CSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
    CSQL = CSQL & " 		    		FROM KoreaBadminton.dbo.tblGameResult"
    CSQL = CSQL & " 		    		WHERE DelYN = 'N'"
    CSQL = CSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
    CSQL = CSQL & " 		    		) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
    CSQL = CSQL & " 		    WHERE A.DelYN = 'N'"
    CSQL = CSQL & " 		    AND B.DelYN = 'N'"
    CSQL = CSQL & " 		    AND C.DelYN = 'N'"
    CSQL = CSQL & " 		    AND D.DelYN = 'N'"
    CSQL = CSQL & " 		    AND A.ORDERBY < B.ORDERBY"
    CSQL = CSQL & " 		    AND A.GameDay = '" & DEC_GameDay & "'"
    CSQL = CSQL & " 		    AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
    CSQL = CSQL & " 		    AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"

    If DEC_StadiumNumber <> "" Then
      CSQL = CSQL & " 		    AND A.StadiumNum = '" & DEC_StadiumNumber & "'"
    End If
    
    CSQL = CSQL & " 		    AND A.TeamGameNum = '0'"
    CSQL = CSQL & " 		) AS AA"
    CSQL = CSQL & " 		WHERE GameLevelDtlIDX IS NOT NULL"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		UNION ALL"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		SELECT A.GameTitleIDX, A.GameLevelDtlidx, A.TourneyTeamIDX as TourneyIDX, A.TeamGameNum, '0' AS GameNum, A.TeamGb, A.Level, ISNULL(A.Team,'') AS LTourneyGroupIDX, ISNULL(B.Team,'') AS RTourneyGroupIDX,"
    CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
    CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
    CSQL = CSQL & " 		E.Result AS Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
    CSQL = CSQL & " 		KoreaBadminton.dbo.FN_GroupGameStatus(A.GameLevelDtlidx, A.TeamGameNum) AS GameStatus, A.[ROUND], dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
    CSQL = CSQL & " 		A.TurnNum, C.PlayLevelType, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName,"
    CSQL = CSQL & " 		'' AS LPlayer1,"
    CSQL = CSQL & " 		'' AS LPlayer2,"
    CSQL = CSQL & " 		'' AS RPlayer1,"
    CSQL = CSQL & " 		'' AS RPlayer2,"
    CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM1, "
    CSQL = CSQL & " 		'' AS LTeamNM2,"
    CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS LTeamNM2,"
    CSQL = CSQL & " 		'' AS LTeamNM2"
    CSQL = CSQL & " 		FROM tblTourneyTeam A"
    CSQL = CSQL & " 		INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
    CSQL = CSQL & " 		INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
    CSQL = CSQL & " 		LEFT JOIN ("
    CSQL = CSQL & " 			SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
    CSQL = CSQL & " 			FROM KoreaBadminton.dbo.tblGroupGameResult"
    CSQL = CSQL & " 			WHERE DelYN = 'N'"
    CSQL = CSQL & " 			) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
    CSQL = CSQL & " 		WHERE A.DelYN = 'N'"
    CSQL = CSQL & " 		AND B.DelYN = 'N'"
    CSQL = CSQL & " 		AND A.ORDERBY < B.ORDERBY"
    CSQL = CSQL & " 		AND A.GameDay = '" & DEC_GameDay & "'"
    CSQL = CSQL & " 		AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
    CSQL = CSQL & " 		AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"

    If DEC_StadiumNumber <> "" Then
      CSQL = CSQL & " 		    AND A.StadiumNum = '" & DEC_StadiumNumber & "'"
    End If
    
    CSQL = CSQL & " 		AND A.GameLevelDtlIDX IS NOT NULL"
    CSQL = CSQL & " 	) AS BBB"
    CSQL = CSQL & " ) AS CCC"
    CSQL = CSQL & " WHERE CCC.GameLevelDtlIDX IS NOT NULL"

    If DEC_SearchKey = "UserName" Then
      CSQL = CSQL & " AND (CCC.LPlayer1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.LPlayer2 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RPlayer1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RPlayer2 LIKE '%" & DEC_Searchkeyword & "%')"
    ElseIf DEC_SearchKey = "Team" Then
      CSQL = CSQL & " AND (CCC.LTeam1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.LTeam2 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RTeam1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RTeam2 LIKE '%" & DEC_Searchkeyword & "%')"
    End If

    GetSQL = CSQL
  End Function

  Function GetSQLTempNum(ByVal DEC_GameDay, ByVal DEC_GameTitleIDX, ByVal DEC_StadiumIDX, ByVal DEC_StadiumNumber, ByVal DEC_Searchkeyword, ByVal DEC_SearchKey, ByVal Param_TempNum)
    CSQL = " SELECT CCC.GameTitleIDX, dbo.FN_NameSch(CCC.GameTitleIDX, 'GameTitleIDX') AS GameTitleNM, CCC.GameLevelDtlIDX,  CCC.TourneyIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
    CSQL = CSQL & " 	CCC.TeamGbNM, CCC.LevelNM, CCC.GameTypeNM,"
    CSQL = CSQL & " 	CCC.Result, CCC.ResultType, CCC.ResultNM, CCC.Jumsu,"
    CSQL = CSQL & " 	CCC.GameStatus, CCC.[ROUND], CCC.Sex,"
    CSQL = CSQL & " 	CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
    CSQL = CSQL & " 	CCC.LPlayer1, CCC.LPlayer2, CCC.Rplayer1, CCC.Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
    CSQL = CSQL & " 	CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType"
    CSQL = CSQL & " FROM "
    CSQL = CSQL & " ("
    CSQL = CSQL & " 	SELECT "
    CSQL = CSQL & " 	BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TourneyIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
    CSQL = CSQL & " 	BBB.TeamGbNM, BBB.LevelNM, BBB.GameTypeNM,"
    CSQL = CSQL & " 	BBB.Result, BBB.ResultType, BBB.ResultNM, BBB.Jumsu,"
    CSQL = CSQL & " 	BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
    CSQL = CSQL & " 	ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
    CSQL = CSQL & " 	GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName,"
    CSQL = CSQL & " 	LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2"
    CSQL = CSQL & " 	FROM"
    CSQL = CSQL & " 	("
    CSQL = CSQL & " 		SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TourneyIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
    CSQL = CSQL & " 		AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
    CSQL = CSQL & " 		AA.Result, AA.ResultType, AA.ResultNM, AA.Jumsu,"
    CSQL = CSQL & " 		AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName,"
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
    CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2"
    CSQL = CSQL & " 		FROM"
    CSQL = CSQL & " 		("
    CSQL = CSQL & " 		    SELECT A.GameTitleIDX, A.GameLevelDtlIDX,A.TourneyIDX as TourneyIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
    CSQL = CSQL & " 		    KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
    CSQL = CSQL & " 		    KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
    CSQL = CSQL & " 		    E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
    CSQL = CSQL & " 		    KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
    CSQL = CSQL & " 		    A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName"
    CSQL = CSQL & " 		    ,STUFF(("
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + UserName "
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    CSQL = CSQL & " 						  AND DelYN = 'N'"           
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
    CSQL = CSQL & " 					  AND DelYN = 'N'"         
    CSQL = CSQL & " 		    		),1,1,'') AS LPlayers"
    CSQL = CSQL & " 		    ,STUFF(("
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + UserName "
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    CSQL = CSQL & " 						  AND DelYN = 'N'"       
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
    CSQL = CSQL & " 					  AND DelYN = 'N'"             
    CSQL = CSQL & " 		    		),1,1,'') AS RPlayers"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		    ,STUFF((		"
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    CSQL = CSQL & " 						  AND DelYN = 'N'"       
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
    CSQL = CSQL & " 					  AND DelYN = 'N'"             
    CSQL = CSQL & " 		    		),1,1,'') AS LTeams"
    CSQL = CSQL & " 		    ,STUFF((		"
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    CSQL = CSQL & " 						  AND DelYN = 'N'"       
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
    CSQL = CSQL & " 					  AND DelYN = 'N'"             
    CSQL = CSQL & " 		    		),1,1,'') AS RTeams"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		    FROM tblTourney A"
    CSQL = CSQL & " 		    INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
    CSQL = CSQL & " 		    INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
    CSQL = CSQL & " 		    	LEFT JOIN ("
    CSQL = CSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
    CSQL = CSQL & " 		    		FROM KoreaBadminton.dbo.tblGameResult"
    CSQL = CSQL & " 		    		WHERE DelYN = 'N'"
    CSQL = CSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
    CSQL = CSQL & " 		    		) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
    CSQL = CSQL & " 		    WHERE A.DelYN = 'N'"
    CSQL = CSQL & " 		    AND B.DelYN = 'N'"
    CSQL = CSQL & " 		    AND C.DelYN = 'N'"
    CSQL = CSQL & " 		    AND D.DelYN = 'N'"
    CSQL = CSQL & " 		    AND A.ORDERBY < B.ORDERBY"
    CSQL = CSQL & " 		    AND A.GameDay = '" & DEC_GameDay & "'"
    CSQL = CSQL & " 		    AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
    CSQL = CSQL & " 		    AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"

    If DEC_StadiumNumber <> "" Then
      CSQL = CSQL & " 		    AND A.StadiumNum = '" & DEC_StadiumNumber & "'"
    End If
    
    CSQL = CSQL & " 		    AND A.TeamGameNum = '0'"
    CSQL = CSQL & " 		) AS AA"
    CSQL = CSQL & " 		WHERE GameLevelDtlIDX IS NOT NULL"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		UNION ALL"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		SELECT A.GameTitleIDX, A.GameLevelDtlidx, A.TourneyTeamIDX as TourneyIDX, A.TeamGameNum, '0' AS GameNum, A.TeamGb, A.Level, ISNULL(A.Team,'') AS LTourneyGroupIDX, ISNULL(B.Team,'') AS RTourneyGroupIDX,"
    CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
    CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
    CSQL = CSQL & " 		E.Result AS Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
    CSQL = CSQL & " 		KoreaBadminton.dbo.FN_GroupGameStatus(A.GameLevelDtlidx, A.TeamGameNum) AS GameStatus, A.[ROUND], dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
    CSQL = CSQL & " 		A.TurnNum, C.PlayLevelType, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName,"
    CSQL = CSQL & " 		'' AS LPlayer1,"
    CSQL = CSQL & " 		'' AS LPlayer2,"
    CSQL = CSQL & " 		'' AS RPlayer1,"
    CSQL = CSQL & " 		'' AS RPlayer2,"
    CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM1, "
    CSQL = CSQL & " 		'' AS LTeamNM2,"
    CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS LTeamNM2,"
    CSQL = CSQL & " 		'' AS LTeamNM2"
    CSQL = CSQL & " 		FROM tblTourneyTeam A"
    CSQL = CSQL & " 		INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
    CSQL = CSQL & " 		INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
    CSQL = CSQL & " 		LEFT JOIN ("
    CSQL = CSQL & " 			SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
    CSQL = CSQL & " 			FROM KoreaBadminton.dbo.tblGroupGameResult"
    CSQL = CSQL & " 			WHERE DelYN = 'N'"
    CSQL = CSQL & " 			) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
    CSQL = CSQL & " 		WHERE A.DelYN = 'N'"
    CSQL = CSQL & " 		AND B.DelYN = 'N'"
    CSQL = CSQL & " 		AND A.ORDERBY < B.ORDERBY"
    CSQL = CSQL & " 		AND A.GameDay = '" & DEC_GameDay & "'"
    CSQL = CSQL & " 		AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
    CSQL = CSQL & " 		AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"

    If DEC_StadiumNumber <> "" Then
      CSQL = CSQL & " 		    AND A.StadiumNum = '" & DEC_StadiumNumber & "'"
    End If
    
    CSQL = CSQL & " 		AND A.GameLevelDtlIDX IS NOT NULL"
    CSQL = CSQL & " 	) AS BBB"
    CSQL = CSQL & " ) AS CCC"
    CSQL = CSQL & " WHERE CCC.GameLevelDtlIDX IS NOT NULL"
    CSQL = CSQL & " And (CCC.TempNum = '" & cdbl(Param_TempNum) + 1 & "' OR CCC.TempNum = '" & cdbl(Param_TempNum) + 2 & "')"

    If DEC_SearchKey = "UserName" Then
      CSQL = CSQL & " AND (CCC.LPlayer1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.LPlayer2 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RPlayer1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RPlayer2 LIKE '%" & DEC_Searchkeyword & "%')"
    ElseIf DEC_SearchKey = "Team" Then
      CSQL = CSQL & " AND (CCC.LTeam1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.LTeam2 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RTeam1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RTeam2 LIKE '%" & DEC_Searchkeyword & "%')"
    End If

    GetSQLTempNum = CSQL
  End Function
%>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>배드민턴 경기기록지</title>
</head>
<body>

<%
  'CSQL = " SELECT CCC.GameTitleIDX, dbo.FN_NameSch(CCC.GameTitleIDX, 'GameTitleIDX') AS GameTitleNM, CCC.GameLevelDtlIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
  'CSQL = CSQL & " 	CCC.TeamGbNM, CCC.LevelNM, CCC.GameTypeNM,"
  'CSQL = CSQL & " 	CCC.Result, CCC.ResultType, CCC.ResultNM, CCC.Jumsu,"
  'CSQL = CSQL & " 	CCC.GameStatus, CCC.[ROUND], CCC.Sex,"
  'CSQL = CSQL & " 	CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
  'CSQL = CSQL & " 	CCC.LPlayer1, CCC.LPlayer2, CCC.Rplayer1, CCC.Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
  'CSQL = CSQL & " 	CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType"
  'CSQL = CSQL & " FROM "
  'CSQL = CSQL & " ("
  'CSQL = CSQL & " 	SELECT "
  'CSQL = CSQL & " 	BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
  'CSQL = CSQL & " 	BBB.TeamGbNM, BBB.LevelNM, BBB.GameTypeNM,"
  'CSQL = CSQL & " 	BBB.Result, BBB.ResultType, BBB.ResultNM, BBB.Jumsu,"
  'CSQL = CSQL & " 	BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
  'CSQL = CSQL & " 	ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
  'CSQL = CSQL & " 	GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName,"
  'CSQL = CSQL & " 	LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2"
  'CSQL = CSQL & " 	FROM"
  'CSQL = CSQL & " 	("
  'CSQL = CSQL & " 		SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
  'CSQL = CSQL & " 		AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
  'CSQL = CSQL & " 		AA.Result, AA.ResultType, AA.ResultNM, AA.Jumsu,"
  'CSQL = CSQL & " 		AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName,"
  'CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
  'CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
  'CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
  'CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
  'CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
  'CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
  'CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
  'CSQL = CSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2"
  'CSQL = CSQL & " 		FROM"
  'CSQL = CSQL & " 		("
  'CSQL = CSQL & " 		    SELECT A.GameTitleIDX, A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
  'CSQL = CSQL & " 		    KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
  'CSQL = CSQL & " 		    KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
  'CSQL = CSQL & " 		    E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
  'CSQL = CSQL & " 		    KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
  'CSQL = CSQL & " 		    A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName"
  'CSQL = CSQL & " 		    ,STUFF(("
  'CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
  'CSQL = CSQL & " 		    			SELECT  '|'   + UserName "
  'CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
  'CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
  'CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
  'CSQL = CSQL & " 						  AND DelYN = 'N'"           
  'CSQL = CSQL & " 		    			FOR XML PATH('')  "
  'CSQL = CSQL & " 		    			)  "
  'CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
  'CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
  'CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
  'CSQL = CSQL & " 					  AND DelYN = 'N'"         
  'CSQL = CSQL & " 		    		),1,1,'') AS LPlayers"
  'CSQL = CSQL & " 		    ,STUFF(("
  'CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
  'CSQL = CSQL & " 		    			SELECT  '|'   + UserName "
  'CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
  'CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
  'CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
  'CSQL = CSQL & " 						  AND DelYN = 'N'"       
  'CSQL = CSQL & " 		    			FOR XML PATH('')  "
  'CSQL = CSQL & " 		    			)  "
  'CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
  'CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
  'CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
  'CSQL = CSQL & " 					  AND DelYN = 'N'"             
  'CSQL = CSQL & " 		    		),1,1,'') AS RPlayers"
  'CSQL = CSQL & " "
  'CSQL = CSQL & " 		    ,STUFF((		"
  'CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
  'CSQL = CSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
  'CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
  'CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
  'CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
  'CSQL = CSQL & " 						  AND DelYN = 'N'"       
  'CSQL = CSQL & " 		    			FOR XML PATH('')  "
  'CSQL = CSQL & " 		    			)  "
  'CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
  'CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
  'CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
  'CSQL = CSQL & " 					  AND DelYN = 'N'"             
  'CSQL = CSQL & " 		    		),1,1,'') AS LTeams"
  'CSQL = CSQL & " 		    ,STUFF((		"
  'CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
  'CSQL = CSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
  'CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
  'CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
  'CSQL = CSQL & " 						  AND GameLevelDtlidx = AAA.GameLevelDtlidx"
  'CSQL = CSQL & " 						  AND DelYN = 'N'"       
  'CSQL = CSQL & " 		    			FOR XML PATH('')  "
  'CSQL = CSQL & " 		    			)  "
  'CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
  'CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
  'CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
  'CSQL = CSQL & " 					  AND DelYN = 'N'"             
  'CSQL = CSQL & " 		    		),1,1,'') AS RTeams"
  'CSQL = CSQL & " "
  'CSQL = CSQL & " 		    FROM tblTourney A"
  'CSQL = CSQL & " 		    INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
  'CSQL = CSQL & " 		    INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
  'CSQL = CSQL & " 		    INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
  'CSQL = CSQL & " 		    	LEFT JOIN ("
  'CSQL = CSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
  'CSQL = CSQL & " 		    		FROM KoreaBadminton.dbo.tblGameResult"
  'CSQL = CSQL & " 		    		WHERE DelYN = 'N'"
  'CSQL = CSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
  'CSQL = CSQL & " 		    		) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
  'CSQL = CSQL & " 		    WHERE A.DelYN = 'N'"
  'CSQL = CSQL & " 		    AND B.DelYN = 'N'"
  'CSQL = CSQL & " 		    AND C.DelYN = 'N'"
  'CSQL = CSQL & " 		    AND D.DelYN = 'N'"
  'CSQL = CSQL & " 		    AND A.ORDERBY < B.ORDERBY"
  'CSQL = CSQL & " 		    AND A.GameDay = '" & DEC_GameDay & "'"
  'CSQL = CSQL & " 		    AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
  'CSQL = CSQL & " 		    AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
'
  'If DEC_StadiumNumber <> "" Then
  '  CSQL = CSQL & " 		    AND A.StadiumNum = '" & DEC_StadiumNumber & "'"
  'End If
  '
  'CSQL = CSQL & " 		    AND A.TeamGameNum = '0'"
  'CSQL = CSQL & " 		) AS AA"
  'CSQL = CSQL & " 		WHERE GameLevelDtlIDX IS NOT NULL"
  'CSQL = CSQL & " "
  'CSQL = CSQL & " 		UNION ALL"
  'CSQL = CSQL & " "
  'CSQL = CSQL & " 		SELECT A.GameTitleIDX, A.GameLevelDtlidx, A.TeamGameNum, '0' AS GameNum, A.TeamGb, A.Level, ISNULL(A.Team,'') AS LTourneyGroupIDX, ISNULL(B.Team,'') AS RTourneyGroupIDX,"
  'CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
  'CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
  'CSQL = CSQL & " 		E.Result AS Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
  'CSQL = CSQL & " 		KoreaBadminton.dbo.FN_GroupGameStatus(A.GameLevelDtlidx, A.TeamGameNum) AS GameStatus, A.[ROUND], dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
  'CSQL = CSQL & " 		A.TurnNum, C.PlayLevelType, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName,"
  'CSQL = CSQL & " 		'' AS LPlayer1,"
  'CSQL = CSQL & " 		'' AS LPlayer2,"
  'CSQL = CSQL & " 		'' AS RPlayer1,"
  'CSQL = CSQL & " 		'' AS RPlayer2,"
  'CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM1, "
  'CSQL = CSQL & " 		'' AS LTeamNM2,"
  'CSQL = CSQL & " 		KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS LTeamNM2,"
  'CSQL = CSQL & " 		'' AS LTeamNM2"
  'CSQL = CSQL & " 		FROM tblTourneyTeam A"
  'CSQL = CSQL & " 		INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
  'CSQL = CSQL & " 		INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
  'CSQL = CSQL & " 		INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
  'CSQL = CSQL & " 		LEFT JOIN ("
  'CSQL = CSQL & " 			SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
  'CSQL = CSQL & " 			FROM KoreaBadminton.dbo.tblGroupGameResult"
  'CSQL = CSQL & " 			WHERE DelYN = 'N'"
  'CSQL = CSQL & " 			) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
  'CSQL = CSQL & " 		WHERE A.DelYN = 'N'"
  'CSQL = CSQL & " 		AND B.DelYN = 'N'"
  'CSQL = CSQL & " 		AND A.ORDERBY < B.ORDERBY"
  'CSQL = CSQL & " 		AND A.GameDay = '" & DEC_GameDay & "'"
  'CSQL = CSQL & " 		AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
  'CSQL = CSQL & " 		AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
'
  'If DEC_StadiumNumber <> "" Then
  '  CSQL = CSQL & " 		    AND A.StadiumNum = '" & DEC_StadiumNumber & "'"
  'End If
  '
  'CSQL = CSQL & " 		AND A.GameLevelDtlIDX IS NOT NULL"
  'CSQL = CSQL & " 	) AS BBB"
  'CSQL = CSQL & " ) AS CCC"
  'CSQL = CSQL & " WHERE CCC.GameLevelDtlIDX IS NOT NULL"
'
  'If DEC_SearchKey = "UserName" Then
  '    CSQL = CSQL & " AND (CCC.LPlayer1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.LPlayer2 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RPlayer1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RPlayer2 LIKE '%" & DEC_Searchkeyword & "%')"
  'ElseIf DEC_SearchKey = "Team" Then
  '    CSQL = CSQL & " AND (CCC.LTeam1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.LTeam2 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RTeam1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RTeam2 LIKE '%" & DEC_Searchkeyword & "%')"
  'End If
  CSQL = GetSQL(DEC_GameDay, DEC_GameTitleIDX, DEC_StadiumIDX,DEC_StadiumNumber, DEC_Searchkeyword,DEC_SearchKey)
  'Response.Write "CSQL :" & CSQL & "<BR/>"
  const teamGroupGameGb = "B0030002"
  const personGroupGameGb = "B0030001"
  SET CRs = DBCon.Execute(CSQL)

  IF NOT (CRs.Eof Or CRs.Bof) Then
    arrayGamePaper = CRs.getrows()
  End If


%>
  <table style="font-family: '맑은 고딕';">
    <colgroup>
      <col width="80px;">
      <col width="80px;">
      <col width="80px;">
      <col width="80px;">
      <col width="80px;">
    </colgroup>
    <tbody>

    <%
      If IsArray(arrayGamePaper) Then
        For ar = LBound(arrayGamePaper, 2) To UBound(arrayGamePaper, 2)
          GameTitleIDX = arrayGamePaper(0, ar) 
          GameTitlenNm = arrayGamePaper(1, ar) 
          GameLevelDtlIDX = arrayGamePaper(2, ar) 
          TourneyIDX = arrayGamePaper(3, ar) 
          TeamGameNum = arrayGamePaper(4, ar) 
          GameNum = arrayGamePaper(5, ar) 
          TeamGb = arrayGamePaper(6, ar) 
          Level = arrayGamePaper(7, ar) 
          LTourneyGroupIDX = arrayGamePaper(8, ar) 
          RTourneyGroupIDX = arrayGamePaper(9, ar) 
          TeamGbNM = arrayGamePaper(10, ar) 
          LevelNM = arrayGamePaper(11, ar) 
          GameTypeNM = arrayGamePaper(12, ar) 
          Result = arrayGamePaper(13, ar) 
          ResultType = arrayGamePaper(14, ar) 
          ResultNM = arrayGamePaper(15, ar) 
          Jumsu = arrayGamePaper(16, ar) 
          GameStatus = arrayGamePaper(17, ar) 
          ROUNDS = arrayGamePaper(18, ar) 
          Sex = arrayGamePaper(19, ar) 
          TempNum = arrayGamePaper(20, ar) 
          TurnNum = arrayGamePaper(21, ar) 
          GroupGameGb = arrayGamePaper(22, ar) 
          LPlayer1 = arrayGamePaper(23, ar) 
          LPlayer2 = arrayGamePaper(24, ar) 
          Rplayer1 = arrayGamePaper(25, ar) 
          Rplayer2 = arrayGamePaper(26, ar) 
          LTeam1 = arrayGamePaper(27, ar) 
          LTeam2 = arrayGamePaper(28, ar) 
          RTeam1 = arrayGamePaper(29, ar) 
          RTeam2 = arrayGamePaper(30, ar) 
          StadiumNum = arrayGamePaper(31, ar) 
          StadiumIDX = arrayGamePaper(32, ar) 
          GameDay = arrayGamePaper(33, ar) 
          LevelJooNum = arrayGamePaper(34, ar) 
          LevelDtlJooNum = arrayGamePaper(35, ar) 
          LevelDtlName = arrayGamePaper(36, ar) 
          StadiumName = arrayGamePaper(37, ar) 
          PlayLevelType = arrayGamePaper(38, ar) 
    %>
      <tr style="height: 40pt;">
        <td colspan="3">
          <img style="width: 143px; height: 47px;" src="http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/logo/badminton.png" alt="대한배드민턴협회">
        </td>
        <td>
          <img style="width: 132px; height: 42px;" src="http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/logo/sd.png" alt="스포츠다이어리">
        </td>
      </tr>
      <tr style="height: 42pt;">
        <td style="font-size: 18pt; vertical-align: bottom;">No. <span style="font-weight: bold;font-size: 20pt;"><%=TempNum%></span></d>
        <td style="font-size: 14pt; vertical-align: bottom;"><%=Sex & GameTypeNM & " " & TeamGbNM & " " & LevelNM & LevelJooNum & " "%></td>
        <td style="font-size: 14pt; vertical-align: bottom;">
        <%
          If PlayLevelType = "B0100001" Then
            Response.Write "예선 " & LevelDtlJooNum & "조"
          ElseIf PlayLevelType = "B0100002" Then
            Response.Write "본선"
          Else
            Response.Write "-"
          End If  
        %>      
        
        </td>
        <td style="font-size: 14pt; vertical-align: bottom;"><span style="font-size: 14pt;font-weight: bold;"><%=StadiumNum%></span>코트
         <%
        IF GroupGameGb = teamGroupGameGb Then
            Response.Write TeamGameNum
        ELSE
            Response.Write GameNum
        End IF
        %>
        </span>경기

        </td>
        <!--
        <td style="font-size: 14pt; vertical-align: bottom;"><span style="font-size: 26pt;font-weight: bold;">
       
        
        </td>
        -->
      </tr>
      <tr style="height: 45pt;">
        <% if GroupGameGb = personGroupGameGb Then %>
        <td style="vertical-align: middle;text-align: center;border-bottom: 1px solid #000;border-top: thin solid #000;border-left: thin solid #000;border-right: thin solid #000;font-size: 16pt;">소 속</td>
        <% END IF%>
        <% if GroupGameGb = personGroupGameGb Then %>
        <td style="vertical-align: middle;text-align: center;border-bottom: 1px solid #000;border-top: thin solid #000;border-left: thin solid #000;border-right: thin solid #000;font-size: 16pt;" colspan="2">이 름</td>
        <%ELSE%>
        <td style="vertical-align: middle;text-align: center;border-bottom: 1px solid #000;border-top: thin solid #000;border-left: thin solid #000;border-right: thin solid #000;font-size: 16pt;" colspan="2">팀 명</td>
        <%End IF%>
        <td style="vertical-align: middle;text-align: center;border-bottom: 1px solid #000;border-top: thin solid #000;border-left: thin solid #000;border-right: thin solid #000;font-size: 16pt;">점 수</td>
        <td style="vertical-align: middle;text-align: center;border-bottom: 1px solid #000;border-top: thin solid #000;border-left: thin solid #000;border-right: thin solid #000;font-size: 16pt;">서 명</td>
      </tr>
      <tr style="height: 65.099pt;">
        <% if GroupGameGb = personGroupGameGb Then %>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;"><%=LTeam1%></td>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;" colspan="2"><%=LPlayer1%> / <%=LPlayer2%></td>
       <%ELSE%>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;" colspan="2"><%=LTeam1%></td>
        <% END IF%>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;"></td>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;"></td>
      </tr>
      <tr style="height: 65.099pt;">
        <% if GroupGameGb = personGroupGameGb Then %>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;"><%=RTeam1%></td>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;" colspan="2"><%=RPlayer1%> / <%=RPlayer2%></td>
        <%ELSE%>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;" colspan="2"><%=RTeam1%></td>
        <%END IF%>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000; width: 160px;"></td>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000; width: 160px"></td>
      </tr>
      <tr style="height: 44.1pt;">
        <td></td>
        <td colspan="3" style="font-weight: bold;font-size: 28pt;vertical-align: middle;text-align: center;"></td>
        <td></td>
      </tr>
      <%
        arrayGamePaperTempNum = null
        CSQLTempNum = GetSQLTempNum(DEC_GameDay, DEC_GameTitleIDX, DEC_StadiumIDX,DEC_StadiumNumber, DEC_Searchkeyword,DEC_SearchKey,TempNum)

        SET CRsTempNum = DBCon.Execute(CSQLTempNum)

        IF NOT (CRsTempNum.Eof and CRsTempNum.Bof) Then
          arrayGamePaperTempNum = CRsTempNum.getrows()
        End If

        arrayTempNumCnt = 0

        If IsArray(arrayGamePaperTempNum) Then
          For ar_TempNum = LBound(arrayGamePaperTempNum, 2) To UBound(arrayGamePaperTempNum, 2) 
            arrayTempNumCnt = arrayTempNumCnt + 1
            B_GameTitleIDX = arrayGamePaperTempNum(0, ar_TempNum) 
            B_GameTitlenNm = arrayGamePaperTempNum(1, ar_TempNum) 
            B_GameLevelDtlIDX = arrayGamePaperTempNum(2, ar_TempNum) 
            B_TourneyIDX = arrayGamePaperTempNum(3, ar_TempNum) 
            B_TeamGameNum = arrayGamePaperTempNum(4, ar_TempNum) 
            B_GameNum = arrayGamePaperTempNum(5, ar_TempNum) 
            B_TeamGb = arrayGamePaperTempNum(6, ar_TempNum) 
            B_Level = arrayGamePaperTempNum(7, ar_TempNum) 
            B_LTourneyGroupIDX = arrayGamePaperTempNum(8, ar_TempNum) 
            B_RTourneyGroupIDX = arrayGamePaperTempNum(9, ar_TempNum) 
            B_TeamGbNM = arrayGamePaperTempNum(10, ar_TempNum) 
            B_LevelNM = arrayGamePaperTempNum(11, ar_TempNum) 
            B_GameTypeNM = arrayGamePaperTempNum(12, ar_TempNum) 
            B_Result = arrayGamePaperTempNum(13, ar_TempNum) 
            B_ResultType = arrayGamePaperTempNum(14, ar_TempNum) 
            B_ResultNM = arrayGamePaperTempNum(15, ar_TempNum) 
            B_Jumsu = arrayGamePaperTempNum(16, ar_TempNum) 
            B_GameStatus = arrayGamePaperTempNum(17, ar_TempNum) 
            B_ROUNDS = arrayGamePaperTempNum(18, ar_TempNum) 
            B_Sex = arrayGamePaperTempNum(19, ar_TempNum) 
            B_TempNum = arrayGamePaperTempNum(20, ar_TempNum) 
            B_TurnNum = arrayGamePaperTempNum(21, ar_TempNum) 
            B_GroupGameGb = arrayGamePaperTempNum(22, ar_TempNum) 
            B_LPlayer1 = arrayGamePaperTempNum(23, ar_TempNum) 
            B_LPlayer2 = arrayGamePaperTempNum(24, ar_TempNum) 
            B_Rplayer1 = arrayGamePaperTempNum(25, ar_TempNum) 
            B_Rplayer2 = arrayGamePaperTempNum(26, ar_TempNum) 
            B_LTeam1 = arrayGamePaperTempNum(27, ar_TempNum) 
            B_LTeam2 = arrayGamePaperTempNum(28, ar_TempNum) 
            B_RTeam1 = arrayGamePaperTempNum(29, ar_TempNum) 
            B_RTeam2 = arrayGamePaperTempNum(30, ar_TempNum) 
            B_StadiumNum = arrayGamePaperTempNum(31, ar_TempNum) 
            B_StadiumIDX = arrayGamePaperTempNum(32, ar_TempNum) 
            B_GameDay = arrayGamePaperTempNum(33, ar_TempNum) 
            B_LevelJooNum = arrayGamePaperTempNum(34, ar_TempNum) 
            B_LevelDtlJooNum = arrayGamePaperTempNum(35, ar_TempNum) 
            B_LevelDtlName = arrayGamePaperTempNum(36, ar_TempNum) 
            B_StadiumName = arrayGamePaperTempNum(37, ar_TempNum) 
            B_PlayLevelType = arrayGamePaperTempNum(38, ar_TempNum) 

            if cdbl(arrayTempNumCnt) = 1 Then
              Response.Write " <tr style='height: 30pt;'>"
              if B_GroupGameGb = teamGroupGameGb Then 
                Response.Write "<td colspan='5' style='font-size: 18pt; vertical-align: middle; text-align: center;'>다음경기 "
                If B_PlayLevelType = "B0100001" Then
                  Response.Write "예선 " & B_LevelDtlJooNum & "조"
                ElseIf B_PlayLevelType = "B0100002" Then
                  Response.Write " 본선"  & "-" & B_TeamGameNum
                Else
                  Response.Write "-"
                End If  
                Response.Write "(" & B_LTeam1 & " / " & B_RTeam1 & ")  ▷ " & B_StadiumNum & "코트 " & B_TeamGameNum & " 경기 예정</td>"
              else
                Response.Write "<td colspan='5' style='font-size: 18pt; vertical-align: middle; text-align: center;'>다음경기 "
                If B_PlayLevelType = "B0100001" Then
                  Response.Write "예선 " & B_LevelDtlJooNum & "조"
                ElseIf B_PlayLevelType = "B0100002" Then
                  Response.Write " 본선"  & "-" & B_TeamGameNum
                Else
                  Response.Write "-"
                End If  
                Response.Write  "(" & B_RPlayer1 & " / " & B_RPlayer2 & ")  ▷ " & B_StadiumNum & "코트 " & B_GameNum & " 경기 예정</td>"
              End IF
              Response.Write "</tr>"
            End IF

          
            if cdbl(arrayTempNumCnt) = 2 Then
              Response.Write " <tr style='height: 30pt;'>"
              if B_GroupGameGb = teamGroupGameGb Then 
                Response.Write "<td colspan='5' style='font-size: 18pt; vertical-align: middle; text-align: center;'>다음경기 "
                 If B_PlayLevelType = "B0100001" Then
                  Response.Write "예선 " & B_LevelDtlJooNum & "조"
                ElseIf B_PlayLevelType = "B0100002" Then
                  Response.Write " 본선"  & "-" & B_TeamGameNum
                Else
                  Response.Write "-"
                End If  
                Response.Write "(" & B_LTeam1 & " / " & B_RTeam1 & ")  ▷ " & B_StadiumNum & "코트 " & B_TeamGameNum & " 경기 예정</td>"
              else
                Response.Write "<td colspan='5' style='font-size: 18pt; vertical-align: middle; text-align: center;'>다음경기 "
                If B_PlayLevelType = "B0100001" Then
                  Response.Write "예선 " & B_LevelDtlJooNum & "조"
                ElseIf B_PlayLevelType = "B0100002" Then
                  Response.Write " 본선"  & "-" & B_TeamGameNum
                Else
                  Response.Write "-"
                End If  
                Response.Write "(" & B_RPlayer1 & " / " & B_RPlayer2 & ")  ▷ " & B_StadiumNum & "코트 " & B_GameNum & " 경기 예정</td>"
              End IF
               Response.Write "</tr>"
            End IF
          NEXT
        END IF

        if(cdbl(arrayTempNumCnt) < 2 ) Then
          For i = arrayTempNumCnt To 1
            Response.Write " <tr style='height: 30pt;'>"
            Response.Write "<td colspan='5' style='font-size: 18pt; vertical-align: middle; text-align: center;'></td>"
            Response.Write "</tr>"
          Next
        End if
      %>

      <!--
      <tr style="height: 30pt;">
        <td colspan="5" style="font-size: 18pt; vertical-align: middle; text-align: center;">다음경기 (이은수 / 이미경) -> 12:30 ▷ 17코트 3경기 예정 (53)</td>
      </tr>
      <tr style="height: 30pt;">
        <td colspan="5" style="font-size: 18pt; vertical-align: middle; text-align: center;">다음경기 (이동욱 / 김연옥) -> 12:30 ▷ 16코트 3경기 예정 (52)</td>
      </tr>

      -->

      <%
          Next
        End If          
      %>  
   
    </tbody>
  </table>
</body>
</html>


<%
  DBClose()
%>


<%


  Response.Buffer = True
  Response.ContentType = "application/vnd.ms-excel"
  Response.CacheControl = "public"
  Response.AddHeader "Content-disposition","attachment;filename=score.xls"
%>

