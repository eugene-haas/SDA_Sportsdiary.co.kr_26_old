<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
  if (obj.hasOwnProperty(prop) == true){
    return "ok";
  }
  else{
    return "notok";
  }
}
</script>
<%

Response.ContentType = "text/html"
Response.AddHeader "Content-Type", "text/html;charset=utf-8"
Response.CodePage = "65001"
Response.CharSet = "utf-8"

'득점자 배점,감점

Dim LSQL ,SSQL
Dim LRs ,SRs
Dim strjson
Dim strjson_sum

Dim i

Dim oJSONoutput_SUM
Dim oJSONoutput

Dim CMD  
Dim GameDay 
Dim StadiumNumber
Dim PlayType
Dim IngType
Dim SchUserName

Dim SRs_Data
Dim DRs_Data

Dim GameEndGubun

Dim strjson_dtl

REQ = Request("Req")
'REQ = "{""CMD"":4,""tGameTitleIDX"":""BF242F3A46C5952F1DF14D02620F1AB7"",""tGameDay"":""2018-05-12"",""tStadiumIDX"":""2C8A53B33C9D84DEB970F5A46AEF583C"",""tStadiumNumber"":"""",""tSearchName"":""""}"
Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
      GameTitleIDX = ""
      DEC_GameTitleIDX = ""
    Else
      GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
    End If
End if  

If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = ""
      DEC_GameDay = ""
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(crypt.DecryptStringENC(oJSONoutput.tGameDay))    
    End If
End if  

If hasown(oJSONoutput, "tStadiumIDX") = "ok" then
    If ISNull(oJSONoutput.tStadiumIDX) Or oJSONoutput.tStadiumIDX = "" Then
      StadiumIDX = ""
      DEC_StadiumIDX = ""
    Else
      StadiumIDX = fInject(oJSONoutput.tStadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))    
    End If
End if  

If hasown(oJSONoutput, "tStadiumNumber") = "ok" then
    If ISNull(oJSONoutput.tStadiumNumber) Or oJSONoutput.tStadiumNumber = "" Then
      StadiumNumber = ""
      DEC_StadiumNumber = ""
    Else
      StadiumNumber = fInject(oJSONoutput.tStadiumNumber)
      DEC_StadiumNumber = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumNumber))    
    End If
End if  


If hasown(oJSONoutput, "PlayType") = "ok" then
    If ISNull(oJSONoutput.PlayType) Or oJSONoutput.PlayType = "" Then
      PlayType = ""
      DEC_PlayType = ""
    Else
      PlayType = fInject(oJSONoutput.PlayType)
      DEC_PlayType = fInject(crypt.DecryptStringENC(oJSONoutput.PlayType))    
    End If
End if  

If hasown(oJSONoutput, "IngType") = "ok" then
    If ISNull(oJSONoutput.IngType) Or oJSONoutput.IngType = "" Then
      IngType = ""
      DEC_IngType = ""
    Else
      IngType = fInject(oJSONoutput.IngType)
      DEC_IngType = fInject(crypt.DecryptStringENC(oJSONoutput.IngType))    
    End If
End if  

If hasown(oJSONoutput, "tSearchName") = "ok" then
    If ISNull(oJSONoutput.tSearchName) Or oJSONoutput.tSearchName = "" Then
      SchUserName = ""
      DEC_SchUserName = ""
    Else
      SchUserName = fInject(oJSONoutput.tSearchName)
      DEC_SchUserName = fInject(crypt.DecryptStringENC(oJSONoutput.tSearchName))    
    End If
End if  

 strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"

'조건별 경기진행순서 불러온다

LSQL = " SELECT CCC.GameTitleIDX, CCC.GameLevelDtlIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
LSQL = LSQL & "   CCC.TeamGbNM, CCC.LevelNM, CCC.GameTypeNM,"
LSQL = LSQL & "   CCC.LResult, CCC.LResultType, CCC.LResultNM, CCC.LJumsu, CCC.LResultDtl,"
LSQL = LSQL & "   CCC.RResult, CCC.RResultType, CCC.RResultNM, CCC.RJumsu, CCC.RResultDtl,"
LSQL = LSQL & "   CCC.GameStatus, CCC.[ROUND], CCC.Sex,"
LSQL = LSQL & "   CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
LSQL = LSQL & "   CCC.LPlayer1, CCC.LPlayer2, CCC.Rplayer1, CCC.Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
LSQL = LSQL & "   CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType, LevelJooName,CCC.MaxRound,CCC.GameType"
LSQL = LSQL & " FROM "
LSQL = LSQL & " ("
LSQL = LSQL & "   SELECT "
LSQL = LSQL & "   BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
LSQL = LSQL & "   BBB.TeamGbNM, BBB.LevelNM, BBB.GameTypeNM,"
LSQL = LSQL & "   BBB.LResult, BBB.LResultType, BBB.LResultNM, BBB.LJumsu, BBB.LResultDtl,"
LSQL = LSQL & "   BBB.RResult, BBB.RResultType, BBB.RResultNM, BBB.RJumsu, BBB.RResultDtl,"
LSQL = LSQL & "   BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
LSQL = LSQL & "   ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
LSQL = LSQL & "   GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName, LevelJooName,BBB.MaxRound,BBB.GameType,"
LSQL = LSQL & "   LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2"
LSQL = LSQL & "   FROM"
LSQL = LSQL & "   ("
LSQL = LSQL & "     SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
LSQL = LSQL & "     AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
LSQL = LSQL & "     AA.LResult, AA.LResultType, AA.LResultNM, AA.LJumsu, AA.LResultDtl,"
LSQL = LSQL & "     AA.RResult, AA.RResultType, AA.RResultNM, AA.RJumsu, AA.RResultDtl,"
LSQL = LSQL & "     AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName, AA.LevelJooName,AA.MaxRound,AA.GameType,"
LSQL = LSQL & "     CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
LSQL = LSQL & "     CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
LSQL = LSQL & "     CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
LSQL = LSQL & "     CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
LSQL = LSQL & "     CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
LSQL = LSQL & "     CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
LSQL = LSQL & "     CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
LSQL = LSQL & "     CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2"
LSQL = LSQL & "     FROM"
LSQL = LSQL & "     ("
LSQL = LSQL & "         SELECT A.GameTitleIDX, A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
LSQL = LSQL & "         KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
LSQL = LSQL & "         KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
LSQL = LSQL & "         E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu, E.ResultDtl AS LResultDtl,"
LSQL = LSQL & "         F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu, F.ResultDtl AS RResultDtl,"
LSQL = LSQL & "         KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
LSQL = LSQL & "         A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName,"
LSQL = LSQL & "     (SELECT max(round) FROM KoreaBadminton.dbo.tblTourneyTeam g WHERE g.DelYN = 'N' and  g.GameLevelDtlidx = a.GameLevelDtlidx ) as MaxRound,"
LSQL = LSQL & "     C.GameType"
LSQL = LSQL & "         ,STUFF(("
LSQL = LSQL & "             SELECT  DISTINCT (  "
LSQL = LSQL & "               SELECT  '|'   + UserName "
LSQL = LSQL & "               FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "               WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & "               AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & "               AND DelYN = 'N'"
LSQL = LSQL & "               FOR XML PATH('')  "
LSQL = LSQL & "               )  "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & "             WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "             AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & "             AND DelYN = 'N'"
LSQL = LSQL & "             ),1,1,'') AS LPlayers"
LSQL = LSQL & "         ,STUFF(("
LSQL = LSQL & "             SELECT  DISTINCT (  "
LSQL = LSQL & "               SELECT  '|'   + UserName "
LSQL = LSQL & "               FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "               WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & "               AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & "               AND DelYN = 'N'"
LSQL = LSQL & "               FOR XML PATH('')  "
LSQL = LSQL & "               )  "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & "             WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "             AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & "             AND DelYN = 'N'"
LSQL = LSQL & "             ),1,1,'') AS RPlayers"
LSQL = LSQL & " "
LSQL = LSQL & "         ,STUFF((    "
LSQL = LSQL & "             SELECT  DISTINCT (  "
LSQL = LSQL & "               SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "               FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "               WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & "               AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & "               AND DelYN = 'N'"
LSQL = LSQL & "               FOR XML PATH('')  "
LSQL = LSQL & "               )  "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & "             WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "             AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & "             AND DelYN = 'N'"
LSQL = LSQL & "             ),1,1,'') AS LTeams"
LSQL = LSQL & "         ,STUFF((    "
LSQL = LSQL & "             SELECT  DISTINCT (  "
LSQL = LSQL & "               SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "               FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "               WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & "               AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & "               AND DelYN = 'N'"
LSQL = LSQL & "               FOR XML PATH('')  "
LSQL = LSQL & "               )  "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & "             WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "             AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & "             AND DelYN = 'N'"
LSQL = LSQL & "             ),1,1,'') AS RTeams"
LSQL = LSQL & "         FROM tblTourney A"
LSQL = LSQL & "         INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
LSQL = LSQL & "         INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
LSQL = LSQL & "           LEFT JOIN ("
LSQL = LSQL & "             SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
LSQL = LSQL & "             FROM KoreaBadminton.dbo.tblGameResult"
LSQL = LSQL & "             WHERE DelYN = 'N'"
LSQL = LSQL & "             GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
LSQL = LSQL & "             ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
LSQL = LSQL & "           LEFT JOIN ("
LSQL = LSQL & "             SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
LSQL = LSQL & "             FROM KoreaBadminton.dbo.tblGameResult"
LSQL = LSQL & "             WHERE DelYN = 'N'"
LSQL = LSQL & "             GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
LSQL = LSQL & "             ) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = B.TeamGameNum AND F.GameNum = B.GameNum AND F.TourneyGroupIDX = B.TourneyGroupIDX    "
LSQL = LSQL & "         WHERE A.DelYN = 'N'"
LSQL = LSQL & "         AND B.DelYN = 'N'"
LSQL = LSQL & "         AND C.DelYN = 'N'"
LSQL = LSQL & "         AND D.DelYN = 'N'"
LSQL = LSQL & "         AND A.ORDERBY < B.ORDERBY"
LSQL = LSQL & "         AND A.GameDay = '" & GameDay & "'"
LSQL = LSQL & "         AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"

If StadiumNumber <> "" Then
  LSQL = LSQL & "     AND ISNULL(A.StadiumNum,'') = '" & StadiumNumber & "'"
End If

LSQL = LSQL & "         AND A.TeamGameNum = '0'"
LSQL = LSQL & "     ) AS AA"
LSQL = LSQL & "     WHERE GameLevelDtlIDX IS NOT NULL"
LSQL = LSQL & " "
LSQL = LSQL & "     UNION ALL"
LSQL = LSQL & " "
LSQL = LSQL & "     SELECT A.GameTitleIDX, A.GameLevelDtlidx, A.TeamGameNum, '0' AS GameNum, A.TeamGb, A.Level, ISNULL(A.Team,'') AS LTourneyGroupIDX, ISNULL(B.Team,'') AS RTourneyGroupIDX,"
LSQL = LSQL & "     KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
LSQL = LSQL & "     KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
LSQL = LSQL & "     E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu, E.ResultDtl AS RResultDtl,"
LSQL = LSQL & "     F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu, F.ResultDtl AS RResultDtl, "
LSQL = LSQL & "     KoreaBadminton.dbo.FN_GroupGameStatus(A.GameLevelDtlidx, A.TeamGameNum) AS GameStatus, A.[ROUND], dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
LSQL = LSQL & "     A.TurnNum, C.PlayLevelType, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName,"
LSQL = LSQL & "     (SELECT max(round) FROM KoreaBadminton.dbo.tblTourneyTeam g WHERE g.DelYN = 'N' and  g.GameLevelDtlidx = a.GameLevelDtlidx ) as MaxRound,"
LSQL = LSQL & "     C.GameType,"
LSQL = LSQL & "     '' AS LPlayer1,"
LSQL = LSQL & "     '' AS LPlayer2,"
LSQL = LSQL & "     '' AS RPlayer1,"
LSQL = LSQL & "     '' AS RPlayer2,"
LSQL = LSQL & "     KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM1, "
LSQL = LSQL & "     '' AS LTeamNM2,"
LSQL = LSQL & "     KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS LTeamNM2,"
LSQL = LSQL & "     '' AS LTeamNM2"
LSQL = LSQL & "     FROM tblTourneyTeam A"
LSQL = LSQL & "     INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
LSQL = LSQL & "     INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "     INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
LSQL = LSQL & "     LEFT JOIN ("
LSQL = LSQL & "       SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, ResultDtl, Jumsu"
LSQL = LSQL & "       FROM KoreaBadminton.dbo.tblGroupGameResult"
LSQL = LSQL & "       WHERE DelYN = 'N'"
LSQL = LSQL & "       ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
LSQL = LSQL & "     LEFT JOIN ("
LSQL = LSQL & "       SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, ResultDtl, Jumsu"
LSQL = LSQL & "       FROM KoreaBadminton.dbo.tblGroupGameResult"
LSQL = LSQL & "       WHERE DelYN = 'N'"
LSQL = LSQL & "       ) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = B.TeamGameNum AND F.Team + F.TeamDtl = B.Team + B.TeamDtl"
LSQL = LSQL & "     WHERE A.DelYN = 'N'"
LSQL = LSQL & "     AND B.DelYN = 'N'"
LSQL = LSQL & "     AND C.DelYN = 'N'"
LSQL = LSQL & "     AND D.DelYN = 'N'"
LSQL = LSQL & "     AND A.ORDERBY < B.ORDERBY"
LSQL = LSQL & "     AND A.GameDay = '" & GameDay & "'"
LSQL = LSQL & "     AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
If StadiumNumber <> "" Then
  LSQL = LSQL & "     AND ISNULL(A.StadiumNum,'') = '" & StadiumNumber & "'"
End If
LSQL = LSQL & "     AND A.GameLevelDtlIDX IS NOT NULL"
LSQL = LSQL & "   ) AS BBB"
LSQL = LSQL & " ) AS CCC"
LSQL = LSQL & " WHERE CCC.GameLevelDtlIDX IS NOT NULL"
LSQL = LSQL & " AND CCC.GameTitleIDX = '" & DEC_GameTitleIDX & "'"

If PlayType <> "" Then
    LSQL = LSQL & " AND CCC.PlayLevelType = '" & DEC_PlayType & "'"
End If

'If DEC_IngType <> "ALL" AND IngType <> "" Then
'    LSQL = LSQL & " AND CCC.GameStatus = '" & DEC_IngType & "'"
'End If


If SchUserName <> "" Then
    LSQL = LSQL & " AND (CCC.LPlayers LIKE '%" & SchUserName & "%' CCC AA.RPlayers LIKE '%" & SchUserName & "%')"
End If

LSQL = LSQL & " AND (CCC.GameStatus <> 'GameEnd'"
LSQL = LSQL & " AND CCC.LResult IS NULL "
LSQL = LSQL & " AND CCC.RResult IS NULL) "

'If StadiumIDX <> "" Then
'    LSQL = LSQL & " AND CCC.StadiumIDX = '" & DEC_StadiumIDX & "'"
'End If
LSQL = LSQL & "  ORDER BY CONVERT(BIGINT,ISNULL(CCC.TurnNum,0)), CONVERT(BIGINT,TeamGameNum), CONVERT(BIGINT,GameNum)"

'Response.WRite lsql
Set LRs = Dbcon.Execute(LSQL)

%>

    <table class="match-order">
      <tr>
        <th>경기번호</th>
        <th>코트번호</th>
        <th>단체전 오더등록</th>
        <th>종목</th>
        <th>대진표</th>
        <th colspan="2">팀1</th>
        <th>점수</th>
        <th colspan="2">팀2</th>
        <th>점수</th>
        <th>승패결과</th>
        <th>그외판정</th>
      </tr>
<%

If Not (LRs.Eof Or LRs.Bof) Then
    i = 0
    Do Until LRs.Eof
    If LRs("GameStatus") <> "" AND ISNULL(LRs("GameStatus")) = false Then
        GameEndGubun = LRs("GameStatus")
    Else
        GameEndGubun = "GameEmpty"
    End If
  
    'Response.Write "Round" & LRs("Round") & "<br>"
    'Response.Write "MaxRound" & LRs("MaxRound") & "<br>"
    'A_GameType= LRs("GameType")
    'A_MaxRound = LRs("MaxRound")
    'A_Round = LRs("Round")
'
    'IF A_GameType ="B0040002" Then
    '  Max_Gang = 1
    '  for j=1 to A_MaxRound
    '    Max_Gang = Max_Gang * 2
    '  next
    '  Response.Write "<br>"
    '  Response.Write "A_MaxRound" & A_MaxRound & "<br>"
    '  Response.Write "A_Round" & A_Round & "<br>"
    '  Response.Write "Max_Gang" & Max_Gang & "<br>"
    '  redim Arr(A_MaxRound) 
    '  Result_Gang = 0
    '  for i = 1 to Ubound(Arr) 
    '    if i = cdbl(1) Then
    '      Arr(i) = Max_Gang
    '    ELSE
    '      Arr(i) = Arr(i - 1) / 2
    '    End IF
    '    
    '    if cdbl(A_Round) = cdbl(i) Then
    '      Response.Write "Arr(i)" & Arr(i) & "<br>"
    '      Result_Gang = Arr(i)
    '    Exit For
    '    END IF
    '  next
    '  If Result_Gang = 4 Then
    '    Result_RoundNM = "준결승"
    '  ElseIf Result_Gang = 2 then
    '    Result_RoundNM = "결승"
    '  Else
    '    Result_RoundNM = Cstr(Result_Gang) & "강"
    '  End If
    '  Response.Write "Result_RoundNM" & Result_RoundNM & "<br>"
    'End IF
    
    
%>
      <tr>
        <td>
          <span><%=LRs("TempNum")%></span>
        </td>
        <td>
          <span><%=LRs("StadiumNum")%></span>
        </td>
        <td>
          <%If LRs("GroupGameGb") = "B0030002" Then%>
            <a href="#" class="order-btn blue_btn" data-toggle="modal" data-target=".group-order" onclick="popup_GameOrder_Group('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=LRs("TeamGameNum")%>','<%=LRs("GameNum")%>');">출전선수 오더</a>
          <%End If%>
        </td>
        <td>
          <span>
          <%=LRs("Sex") & LRs("GameTypeNM") & " " & LRs("TeamGbNM") & " " & LRs("LevelNM") & " " & LRs("LevelJooName") & LRs("LevelJooNum") %>
          </span>
        </td>
        <td>
          <span>
          <%
            If LRs("PlayLevelType") = "B0100001" Then
                Response.Write " 예선" & LRs("LevelDtlJooNum")&"조"
            ElseIf LRs("PlayLevelType") = "B0100002" Then
                Response.Write " 본선" & "-" & LRs("TeamGameNum")
            Else
                Response.Write "-"
            End If          
          %>          
          </span>
        </td>
        
        <%
          '해당선수가 있으면 선수표시
          If LRs("LTourneyGroupIDX") <>  "" AND LRs("LTourneyGroupIDX") <>  "0" Then
        %>      
          <td class="team">
            <span class="cut-el"><%=LRs("LTeam1")%></span>
          </td>
          <td>
            <span><%=LRs("LPlayer1")%></span> / 
            <span><%=LRs("LPlayer2")%></span>
          </td>
          <td>
            <span><%=LRs("LJumsu")%></span>
          </td>        
        <%Else%>
          <td>
            <span>-</span>
          </td>
          <td>
            <span>
              <%If LRs("Round") = "1" Then%>
                <!--BYE-->
              <%End If%>
            </span>
          </td>  
          <td>
            <span><%=LRs("LJumsu")%></span>
          </td>                    
        <%End If%>


        <td class="team">
          <span class="cut-el"><%=LRs("RTeam1")%></span>
        </td>
        <td>
          <span><%=LRs("RPlayer1")%></span>/ 
          <span><%=LRs("RPlayer2")%></span>
        </td>
        <td>
          <span><%=LRs("RJumsu")%></span>
        </td>        
        <%
          btncolor_win = ""
          btncolor_anowin = ""

          '경기결과가 있으면
          If LRs("LResult") <> "" AND LRs("RResult") <> "" Then
            '그외경기결과로 처리되었다면..
            If LRs("LResultDtl") <> "" OR LRs("RResultDtl") <> "" Then
              btncolor_win = "gray_btn"
            Else
              btncolor_win = "red_btn"
            End If
          Else
            btncolor_win = "gray_btn"
          End If

          '경기결과가 있으면
          If LRs("LResult") <> "" AND LRs("RResult") <> "" Then
            '그외경기결과로 처리되었다면..
            If LRs("LResultDtl") <> "" OR LRs("RResultDtl") <> "" Then
              btncolor_anowin = "blue_btn"
            Else
              btncolor_anowin = "gray_btn"
            End If
          Else
            btncolor_anowin = "gray_btn"
          End If          
          
        %>
        <td>
          <%If GameEndGubun = "GameIng" Then%>
            <%If LRs("GroupGameGb") = "B0030001" Then%>
              <a href="#" onclick="OnResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC("1")%>','')" class="<%=btncolor_win%>" data-toggle="modal" data-target=".live-score">경기중</a>
            <%Else%>
              <a href="#" onclick="OnGroupResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC("1")%>','')" class="<%=btncolor_win%>" data-toggle="modal" data-target=".winner-sign">경기중</a>
            <%End If%>
          <%Else%>
            <%If LRs("GroupGameGb") = "B0030001" Then%>
              <a href="#" onclick="OnResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC("1")%>','')" class="<%=btncolor_win%>" data-toggle="modal" data-target=".live-score">선택</a>
            <%Else%>
              <a href="#" onclick="OnGroupResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC("1")%>','')" class="<%=btncolor_win%>" data-toggle="modal" data-target=".winner-sign">선택</a>
            <%End If%>
          <%End If%>
        </td>
        <td>
          <%If GameEndGubun = "GameIng" Then%>
            <a href="#" onclick="OnAnotherResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>')" class="<%=btncolor_anowin%>" data-toggle="modal" data-target=".etc-judge">경기중</a>
          <%Else%>
            <a href="#" onclick="OnAnotherResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>')" class="<%=btncolor_anowin%>" data-toggle="modal" data-target=".etc-judge">선택</a>
          <%End If%>
        </td>
        
      </tr>
      
<%

        
        LRs.MoveNext
    Loop
End If
%>
    </table>
<%
Set LRs = Nothing
DBClose()
'Response.Write  "LSQL" & LSQL & "<BR/>"  
%>