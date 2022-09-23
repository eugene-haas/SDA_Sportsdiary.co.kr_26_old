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
  Dim PlayLevelType	: PlayLevelType		= fInject(Request("PlayLevelType"))
	
	Dim DEC_GameTitleIDX	: DEC_GameTitleIDX 		= crypt.DecryptStringENC(GameTitleIDX)
	Dim DEC_GameDay		    : DEC_GameDay 		    = GameDay
	Dim DEC_StadiumIDX		: DEC_StadiumIDX 		= crypt.DecryptStringENC(StadiumIDX)
  Dim DEC_StadiumNumber	: DEC_StadiumNumber     = StadiumNumber
	Dim DEC_Searchkeyword	: DEC_Searchkeyword		= Searchkeyword
  Dim DEC_PlayLevelType   : DEC_PlayLevelType     = PlayLevelType


    LSQL = "SELECT GameTitleName"
    LSQL = LSQL & " FROM  tblGameTitle"
    LSQL = LSQL & " WHERE GameTitleIDX = " &  DEC_GameTitleIDX
    'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL
    Set LRs = DBCon.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        tGameTitleName = LRs("GameTitleName")
        LRs.MoveNext
        Loop
    End If
    LRs.close

    'LSQL = " SELECT CCC.GameTitleIDX, CCC.GameLevelDtlIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
    'LSQL = LSQL & "   CCC.TeamGbNM, CCC.LevelNM, CCC.GameTypeNM,"
    'LSQL = LSQL & "   CCC.LResult, CCC.LResultType, CCC.LResultNM, CCC.LJumsu, CCC.LResultDtl,"
    'LSQL = LSQL & "   CCC.RResult, CCC.RResultType, CCC.RResultNM, CCC.RJumsu, CCC.RResultDtl,"
    'LSQL = LSQL & "   CCC.GameStatus, CCC.[ROUND], CCC.Sex,"
    'LSQL = LSQL & "   CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
    'LSQL = LSQL & "   CCC.LPlayer1, CCC.LPlayer2, CCC.Rplayer1, CCC.Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
    'LSQL = LSQL & "   CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType, LevelJooName"
    'LSQL = LSQL & " FROM "
    'LSQL = LSQL & " ("
    'LSQL = LSQL & "   SELECT "
    'LSQL = LSQL & "   BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
    'LSQL = LSQL & "   BBB.TeamGbNM, BBB.LevelNM, BBB.GameTypeNM,"
    'LSQL = LSQL & "   BBB.LResult, BBB.LResultType, BBB.LResultNM, BBB.LJumsu, BBB.LResultDtl,"
    'LSQL = LSQL & "   BBB.RResult, BBB.RResultType, BBB.RResultNM, BBB.RJumsu, BBB.RResultDtl,"
    'LSQL = LSQL & "   BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
    'LSQL = LSQL & "   ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
    'LSQL = LSQL & "   GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName, LevelJooName,"
    'LSQL = LSQL & "   LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2"
    'LSQL = LSQL & "   FROM"
    'LSQL = LSQL & "   ("
    'LSQL = LSQL & "     SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
    'LSQL = LSQL & "     AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
    'LSQL = LSQL & "     AA.LResult, AA.LResultType, AA.LResultNM, AA.LJumsu, AA.LResultDtl,"
    'LSQL = LSQL & "     AA.RResult, AA.RResultType, AA.RResultNM, AA.RJumsu, AA.RResultDtl,"
    'LSQL = LSQL & "     AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName, AA.LevelJooName,"
    'LSQL = LSQL & "     CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
    'LSQL = LSQL & "     CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
    'LSQL = LSQL & "     CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
    'LSQL = LSQL & "     CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
    'LSQL = LSQL & "     CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
    'LSQL = LSQL & "     CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
    'LSQL = LSQL & "     CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
    'LSQL = LSQL & "     CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2"
    'LSQL = LSQL & "     FROM"
    'LSQL = LSQL & "     ("
    'LSQL = LSQL & "         SELECT A.GameTitleIDX, A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
    'LSQL = LSQL & "         KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
    'LSQL = LSQL & "         KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
    'LSQL = LSQL & "         E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu, E.ResultDtl AS LResultDtl,"
    'LSQL = LSQL & "         F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu, F.ResultDtl AS RResultDtl,"
    'LSQL = LSQL & "         KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
    'LSQL = LSQL & "         A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName"
    'LSQL = LSQL & "         ,STUFF(("
    'LSQL = LSQL & "             SELECT  DISTINCT (  "
    'LSQL = LSQL & "               SELECT  '|'   + UserName "
    'LSQL = LSQL & "               FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    'LSQL = LSQL & "               WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    'LSQL = LSQL & "               AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    'LSQL = LSQL & "               AND DelYN = 'N'"
    'LSQL = LSQL & "               FOR XML PATH('')  "
    'LSQL = LSQL & "               )  "
    'LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    'LSQL = LSQL & "             WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    'LSQL = LSQL & "             AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
    'LSQL = LSQL & "             AND DelYN = 'N'"
    'LSQL = LSQL & "             ),1,1,'') AS LPlayers"
    'LSQL = LSQL & "         ,STUFF(("
    'LSQL = LSQL & "             SELECT  DISTINCT (  "
    'LSQL = LSQL & "               SELECT  '|'   + UserName "
    'LSQL = LSQL & "               FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    'LSQL = LSQL & "               WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    'LSQL = LSQL & "               AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    'LSQL = LSQL & "               AND DelYN = 'N'"
    'LSQL = LSQL & "               FOR XML PATH('')  "
    'LSQL = LSQL & "               )  "
    'LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    'LSQL = LSQL & "             WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    'LSQL = LSQL & "             AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
    'LSQL = LSQL & "             AND DelYN = 'N'"
    'LSQL = LSQL & "             ),1,1,'') AS RPlayers"
    'LSQL = LSQL & " "
    'LSQL = LSQL & "         ,STUFF((    "
    'LSQL = LSQL & "             SELECT  DISTINCT (  "
    'LSQL = LSQL & "               SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
    'LSQL = LSQL & "               FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    'LSQL = LSQL & "               WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    'LSQL = LSQL & "               AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    'LSQL = LSQL & "               AND DelYN = 'N'"
    'LSQL = LSQL & "               FOR XML PATH('')  "
    'LSQL = LSQL & "               )  "
    'LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    'LSQL = LSQL & "             WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    'LSQL = LSQL & "             AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
    'LSQL = LSQL & "             AND DelYN = 'N'"
    'LSQL = LSQL & "             ),1,1,'') AS LTeams"
    'LSQL = LSQL & "         ,STUFF((    "
    'LSQL = LSQL & "             SELECT  DISTINCT (  "
    'LSQL = LSQL & "               SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
    'LSQL = LSQL & "               FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    'LSQL = LSQL & "               WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    'LSQL = LSQL & "               AND GameLevelDtlidx = AAA.GameLevelDtlidx"
    'LSQL = LSQL & "               AND DelYN = 'N'"
    'LSQL = LSQL & "               FOR XML PATH('')  "
    'LSQL = LSQL & "               )  "
    'LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    'LSQL = LSQL & "             WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    'LSQL = LSQL & "             AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
    'LSQL = LSQL & "             AND DelYN = 'N'"
    'LSQL = LSQL & "             ),1,1,'') AS RTeams"
    'LSQL = LSQL & " "
    'LSQL = LSQL & "         FROM tblTourney A"
    'LSQL = LSQL & "         INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
    'LSQL = LSQL & "         INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
    'if PlayLevelType <> "" Then
    'LSQL = LSQL & "     AND C.PlayLevelType = '" & PlayLevelType & "'"
    'End IF
    'LSQL = LSQL & "         INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
    'LSQL = LSQL & "           LEFT JOIN ("
    'LSQL = LSQL & "             SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
    'LSQL = LSQL & "             FROM KoreaBadminton.dbo.tblGameResult"
    'LSQL = LSQL & "             WHERE DelYN = 'N'"
    'LSQL = LSQL & "             GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
    'LSQL = LSQL & "             ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
    'LSQL = LSQL & "           LEFT JOIN ("
    'LSQL = LSQL & "             SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
    'LSQL = LSQL & "             FROM KoreaBadminton.dbo.tblGameResult"
    'LSQL = LSQL & "             WHERE DelYN = 'N'"
    'LSQL = LSQL & "             GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
    'LSQL = LSQL & "             ) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = B.TeamGameNum AND F.GameNum = B.GameNum AND F.TourneyGroupIDX = B.TourneyGroupIDX    "
    'LSQL = LSQL & "         WHERE A.DelYN = 'N'"
    'LSQL = LSQL & "         AND B.DelYN = 'N'"
    'LSQL = LSQL & "         AND C.DelYN = 'N'"
    'LSQL = LSQL & "         AND D.DelYN = 'N'"
    'LSQL = LSQL & "         AND A.ORDERBY < B.ORDERBY"
    'LSQL = LSQL & "         AND A.GameDay = '" & GameDay & "'"
    'LSQL = LSQL & "         AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
'
    'If StadiumNumber <> "" Then
    'LSQL = LSQL & "     AND ISNULL(A.StadiumNum,'') = '" & StadiumNumber & "'"
    'End If
'
    'LSQL = LSQL & "         AND A.TeamGameNum = '0'"
    'LSQL = LSQL & "     ) AS AA"
    'LSQL = LSQL & "     WHERE GameLevelDtlIDX IS NOT NULL"
    'LSQL = LSQL & " "
    'LSQL = LSQL & "     UNION ALL"
    'LSQL = LSQL & " "
    'LSQL = LSQL & "     SELECT A.GameTitleIDX, A.GameLevelDtlidx, A.TeamGameNum, '0' AS GameNum, A.TeamGb, A.Level, ISNULL(A.Team,'') AS LTourneyGroupIDX, ISNULL(B.Team,'') AS RTourneyGroupIDX,"
    'LSQL = LSQL & "     KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
    'LSQL = LSQL & "     KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
    'LSQL = LSQL & "     E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu, E.ResultDtl AS RResultDtl,"
    'LSQL = LSQL & "     F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu, F.ResultDtl AS RResultDtl, "
    'LSQL = LSQL & "     KoreaBadminton.dbo.FN_GroupGameStatus(A.GameLevelDtlidx, A.TeamGameNum) AS GameStatus, A.[ROUND], dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
    'LSQL = LSQL & "     A.TurnNum, C.PlayLevelType, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName,"
    'LSQL = LSQL & "     '' AS LPlayer1,"
    'LSQL = LSQL & "     '' AS LPlayer2,"
    'LSQL = LSQL & "     '' AS RPlayer1,"
    'LSQL = LSQL & "     '' AS RPlayer2,"
    'LSQL = LSQL & "     KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM1, "
    'LSQL = LSQL & "     '' AS LTeamNM2,"
    'LSQL = LSQL & "     KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS LTeamNM2,"
    'LSQL = LSQL & "     '' AS LTeamNM2"
    'LSQL = LSQL & "     FROM tblTourneyTeam A"
    'LSQL = LSQL & "     INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
    'LSQL = LSQL & "     INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
    'if PlayLevelType <> "" Then
    'LSQL = LSQL & "     AND C.PlayLevelType = '" & PlayLevelType & "'"
    'End IF
    'LSQL = LSQL & "     INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
    'LSQL = LSQL & "     LEFT JOIN ("
    'LSQL = LSQL & "       SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, ResultDtl, Jumsu"
    'LSQL = LSQL & "       FROM KoreaBadminton.dbo.tblGroupGameResult"
    'LSQL = LSQL & "       WHERE DelYN = 'N'"
    'LSQL = LSQL & "       ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
    'LSQL = LSQL & "     LEFT JOIN ("
    'LSQL = LSQL & "       SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, ResultDtl, Jumsu"
    'LSQL = LSQL & "       FROM KoreaBadminton.dbo.tblGroupGameResult"
    'LSQL = LSQL & "       WHERE DelYN = 'N'"
    'LSQL = LSQL & "       ) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = B.TeamGameNum AND F.Team + F.TeamDtl = B.Team + B.TeamDtl"
    'LSQL = LSQL & "     WHERE A.DelYN = 'N'"
    'LSQL = LSQL & "     AND B.DelYN = 'N'"
    'LSQL = LSQL & "     AND C.DelYN = 'N'"
    'LSQL = LSQL & "     AND D.DelYN = 'N'"
    'LSQL = LSQL & "     AND A.ORDERBY < B.ORDERBY"
    'LSQL = LSQL & "     AND A.GameDay = '" & GameDay & "'"
    'LSQL = LSQL & "     AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
    'If StadiumNumber <> "" Then
    'LSQL = LSQL & "     AND ISNULL(A.StadiumNum,'') = '" & StadiumNumber & "'"
    'End If
'
    'LSQL = LSQL & "     AND A.GameLevelDtlIDX IS NOT NULL"
    'LSQL = LSQL & "   ) AS BBB"
    'LSQL = LSQL & " ) AS CCC"
    'LSQL = LSQL & " WHERE CCC.GameLevelDtlIDX IS NOT NULL"
    'LSQL = LSQL & " AND CCC.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
'
    'If PlayType <> "" Then
    '    LSQL = LSQL & " AND CCC.PlayLevelType = '" & DEC_PlayType & "'"
    'End If
'
    ''If DEC_IngType <> "ALL" AND IngType <> "" Then
    ''    LSQL = LSQL & " AND CCC.GameStatus = '" & DEC_IngType & "'"
    ''End If
'
'
    'If SchUserName <> "" Then
    '    LSQL = LSQL & " AND (CCC.LPlayers LIKE '%" & SchUserName & "%' CCC AA.RPlayers LIKE '%" & SchUserName & "%')"
    'End If
'
    'LSQL = LSQL & " AND ((CCC.GameStatus = 'GameEnd') "
    'LSQL = LSQL & " OR (CCC.LResult <> '' AND CCC.RResult <> ''))"
'
    ''If StadiumIDX <> "" Then
    ''    LSQL = LSQL & " AND CCC.StadiumIDX = '" & DEC_StadiumIDX & "'"
    ''End If
    'LSQL = LSQL & "  ORDER BY CONVERT(BIGINT,ISNULL(CCC.TurnNum,0)), CONVERT(BIGINT,TeamGameNum), CONVERT(BIGINT,GameNum)"

    'Response.Write "LSQL " & LSQL & "<BR>"
    DEC_TempNum = ""
    DEC_Searchkeyword =""
    DEC_Searchkey = ""
    DEC_GroupGameGb = ""
    LSQL = " EXEC tblGameTourney_Searched_STR '" & DEC_GameTitleIDX & "', '" & GameDay & "', '" & DEC_StadiumIDX &"' ,'"  & StadiumNumber &"','" & "GameEnd" & "','" & PlayLevelType & "' ,'" & DEC_TempNum & "'  ,'" & DEC_Searchkey & "'  ,'"  & DEC_Searchkeyword & "','" & DEC_GroupGameGb & "'"
    'Response.WRite lsql
    Set CRs = Dbcon.Execute(LSQL)

    If Not(CRs.Eof Or CRs.Bof) Then 
%>
    <span style="vertical-align: middle;text-align: center; font-size: 20pt;"><%=tGameTitleName%>-경기진행결과</span>
    <table border="1">
    <tr>
        <td>경기번호</td>
        <td>코트번호</td>
        <td>종목</td>
        <td>경기타입</td>
        <td>대진표</td>
        <td colspan="2">팀1</td>
        <td >점수</td>
        <td colspan="2">팀2</td>
        <td >점수</td>
    </tr>
        
<% 
        Do Until CRs.Eof
          A_TourneyCnt = CRs("TourneyCnt")
          A_LTeamDtl = CRs("LTeamDtl")
          A_RTeamDtl = CRs("RTeamDtl")
          A_GroupGameGb = CRs("GroupGameGb") 
          A_TempNum = CRs("TempNum")
          A_StadiumNum = CRs("StadiumNum")
          A_GameType= CRs("GameType")
          A_MaxRound = CRs("MaxRound")
          A_Round = CRs("Round")
          A_ResultGangSu = GetGangSu(A_GameType, A_MaxRound,A_Round)

%>      
        <tr>
            <td><%=CRs("TempNum")%></td>
            <td><%=CRs("StadiumNum")%></td>
           
            <td><%=CRs("Sex") & CRs("PlayTypeNM") & " " & CRs("TeamGbNM") & " " & CRs("LevelNM") & " " & CRs("LevelJooName") & CRs("LevelJooNum") & " "%> </td>
            <td>
              <%=CRs("GameTypeNM")%>
            </td>
            
            <td>
            <%
              If CRs("PlayLevelType") = "B0100001" Then
                Response.Write "예선 " & CRs("LevelDtlJooNum") & "조"
              ElseIf CRs("PlayLevelType") = "B0100002" Then
                IF A_ResultGangSu = "" Then
                  Response.Write " 본선" 
                Else
                  Response.Write " 본선" & "-" & A_ResultGangSu
                ENd iF
              Else
                Response.Write "-"
              End If  
            %>
            </td>

            <%
          '해당선수가 있으면 선수표시
          If CRs("LTourneyGroupIDX") <>  "" AND CRs("LTourneyGroupIDX") <>  "0" Then
        %>      
        <td class="team">
          <span class="cut-el"><%=CRs("LTeam1")%>
          <% IF A_LTeamDtl <> "0" Then Response.Write "-" & A_LTeamDtl End IF%>
          </span>
        </td>
        <td>
          <span><%=CRs("LResultType")%></span> 
        </td>
        <td><%=CRs("LJumsu")%></td>
        <%Else%>
        <td>
          <span>-</span>
        </td>
        <td>
          <span>
            <%If CRs("Round") = "1" Then%>
              <!--BYE-->
            <%End If%>
          </span>
        </td>    
        <td><%=CRs("LJumsu")%></td>   
        <%End If%>


        <td class="team">
          <span class="cut-el"><%=CRs("RTeam1")%>
          <% IF A_RTeamDtl <> "0" Then Response.Write "-" & A_RTeamDtl End IF%>
          </span>
        </td>
        <td>
        <span><%=CRs("RResultType")%></span> 
        <!--
          <span><%=CRs("RPlayer1")%></span>/ 
          <span><%=CRs("RPlayer2")%></span>
        -->
        </td>
        <td><%=CRs("RJumsu")%></td>
  
        </tr>
<%
            CRs.MoveNext
          Loop
%>

    </table>
<%
    End If

    'Response.Write "CSQL" & CSQL & "<BR/><BR/><BR/><BR/>"
    'Response.Write "DEC_PlayLevelType" & DEC_PlayLevelType & "<BR/><BR/><BR/><BR/>"
    'Response.End

    Response.Buffer = True
    Response.Buffer = True
    Response.ContentType = "application/vnd.ms-excel"
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-disposition","attachment;filename=" & DEC_GameDay & "경기진행순서.xls"
    Response.AddHeader "Content-disposition","attachment;filename=" & DEC_GameDay & "경기진행순서.xls"
%>

