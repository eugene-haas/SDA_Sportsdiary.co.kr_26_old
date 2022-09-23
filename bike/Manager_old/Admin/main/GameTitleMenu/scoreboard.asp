
<!-- #include virtual = "/pub/header.bm.asp" -->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->


<%
  Response.CharSet="utf-8"
  Session.codepage="65001"
  Response.codepage="65001"
  Response.ContentType="text/html;charset=utf-8"

	Set db = new clsDBHelper
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="author" content="administrator1" />
	<meta name="company" content="Microsoft Corporation" />
<title>스코어지</title>
</head>


<style type="text/css">
.no-spinners {
  height:100%;width:100%;border:0px;
  outline:none;
  text-align:center;
  padding:0px;
  margin:0px;

  -moz-appearance:textfield;
}

.no-spinners::-webkit-outer-spin-button,
.no-spinners::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}	
</style>


<%
	DEC_GameLevelDtlIDX = Request("GameLevelDtlIDX")
	DEC_TeamGameNum = Request("TeamGameNum") 
	DEC_GameNum = Request("GameNum")  
	DEC_IsPrint = Request("IsPrint")  
	DEC_StadiumNum = Request("StadiumNum")  
%>

<%
		titleSQL = "(select top 1 gametitlename from tblGameTitle where gametitleidx = CCC.GameTitleIDX ) as gametitle "
		LSQL = " SELECT "& titleSQL &", CCC.GameTitleIDX, CCC.GameLevelDtlIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
		LSQL = LSQL & " 	CCC.TeamGbNM, CCC.LevelNM, CCC.PlayTypeNM,"
		LSQL = LSQL & " 	CCC.LResult, CCC.LResultType, CCC.LResultNM, CCC.LJumsu, CCC.LResultDtl,"
		LSQL = LSQL & " 	CCC.RResult, CCC.RResultType, CCC.RResultNM, CCC.RJumsu, CCC.RResultDtl,"
		LSQL = LSQL & " 	CCC.GameStatus, CCC.[ROUND] AS GameRound, CCC.Sex,"
		LSQL = LSQL & " 	CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
		LSQL = LSQL & " 	CCC.LPlayer1, ISNULL(CCC.LPlayer2,'') AS LPlayer2, CCC.Rplayer1, ISNULL(CCC.Rplayer2,'') AS Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
		LSQL = LSQL & " 	CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType, LevelJooName,"
		LSQL = LSQL & " 	CCC.Win_TourneyGroupIDX, CCC.LGroupJumsu, CCC.RGroupJumsu, CCC.LDtlJumsu, CCC.RDtlJumsu, CCC.MaxPoint, "			

		LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(CCC.Sex, 'PubCode') AS SexName,"
		LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(CCC.PlayType, 'PubCode') AS PlayTypeName,"
		LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(CCC.TeamGb, 'TeamGb') AS TeamGbName,"
		LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(CCC.Level, 'Level') AS LevelName,"
		LSQL = LSQL & " CCC.LevelJooNum AS LevelJooNumDtl,"
		LSQL = LSQL & " LPlayerIDX1, LPlayerIDX2, RPlayerIDX1, RPlayerIDX2"

		LSQL = LSQL & " FROM "
		LSQL = LSQL & " ("
		LSQL = LSQL & " 	SELECT "
		LSQL = LSQL & " 	BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
		LSQL = LSQL & " 	BBB.TeamGbNM, BBB.LevelNM, BBB.PlayTypeNM,"
		LSQL = LSQL & " 	BBB.LResult, BBB.LResultType, BBB.LResultNM, BBB.LJumsu, BBB.LResultDtl,"
		LSQL = LSQL & " 	BBB.RResult, BBB.RResultType, BBB.RResultNM, BBB.RJumsu, BBB.RResultDtl,"			
		LSQL = LSQL & " 	BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
		LSQL = LSQL & " 	ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
		LSQL = LSQL & " 	GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName, LevelJooName, BBB.PlayType,"
		LSQL = LSQL & " 	LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2,"
		LSQL = LSQL & " 	LPlayerIDX1, LPlayerIDX2, RPlayerIDX1, RPlayerIDX2,"
		LSQL = LSQL & " 	BBB.Win_TourneyGroupIDX, BBB.LGroupJumsu, BBB.RGroupJumsu, BBB.LDtlJumsu, BBB.RDtlJumsu, BBB.MaxPoint "			
		LSQL = LSQL & " 	FROM"
		LSQL = LSQL & " 	("
		LSQL = LSQL & " 		SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
		LSQL = LSQL & " 		AA.TeamGbNM, AA.LevelNM, AA.PlayTypeNM,"
		LSQL = LSQL & " 		AA.LResult, AA.LResultType, AA.LResultNM, AA.LJumsu,"
		LSQL = LSQL & " 		AA.RResult, AA.RResultType, AA.RResultNM, AA.RJumsu,"
		LSQL = LSQL & " 		AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.PlayType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName, AA.LevelJooName, AA.MaxPoint, AA.LResultDtl, AA.RResultDtl,"
		LSQL = LSQL & " 		AA.TourneyGroupIDX AS Win_TourneyGroupIDX, AA.LGroupJumsu, AA.RGroupJumsu, AA.LDtlJumsu, AA.RDtlJumsu,"
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LPlayerIDXs) > 0 THEN LEFT(LPlayerIDXs,CHARINDEX('|',LPlayerIDXs)-1) ELSE LPlayerIDXs END  AS LPlayerIDX1, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LPlayerIDXs) > 0 THEN RIGHT(LPlayerIDXs,CHARINDEX('|',REVERSE(LPlayerIDXs))-1) ELSE '' END  AS LPlayerIDX2, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RPlayerIDXs) > 0 THEN LEFT(RPlayerIDXs,CHARINDEX('|',RPlayerIDXs)-1) ELSE RPlayerIDXs END AS RPlayerIDX1, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RPlayerIDXs) > 0 THEN RIGHT(RPlayerIDXs,CHARINDEX('|',REVERSE(RPlayerIDXs))-1) ELSE '' END  AS RPlayerIDX2, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2"
		LSQL = LSQL & " 		FROM"
		LSQL = LSQL & " 		("
		LSQL = LSQL & " 		    SELECT A.GameTitleIDX, A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
		LSQL = LSQL & " 		    KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
		LSQL = LSQL & " 		    KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS PlayTypeNM,"
		LSQL = LSQL & " 		    E.Result AS LResult, E.ResultDtl AS LResultDtl, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu,"
		LSQL = LSQL & " 		    F.Result AS RResult, F.ResultDtl AS RResultDtl, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu,"
		LSQL = LSQL & " 		    E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
		LSQL = LSQL & " 		    KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
		LSQL = LSQL & " 		    A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, D.PlayType, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName, C.MaxPoint,"
		LSQL = LSQL & " 				KoreaBadminton.dbo.FN_WinGroupIDX(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS TourneyGroupIDX,"
		LSQL = LSQL & " 				KoreaBadminton.dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, A.TourneyGroupIDX) AS LGroupJumsu, "
		LSQL = LSQL & " 				KoreaBadminton.dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, B.TourneyGroupIDX) AS RGroupJumsu, "
		LSQL = LSQL & " 				KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, A.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS LDtlJumsu, "
		LSQL = LSQL & " 				KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, B.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS RDtlJumsu "

		LSQL = LSQL & " 		    ,STUFF(("
		LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
		LSQL = LSQL & " 		    			SELECT  '|'   + UserName "
		LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
		LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "

		LSQL = LSQL & " 						AND GameLevelDtlidx = AAA.GameLevelDtlidx"
		LSQL = LSQL & " 						AND DelYN = 'N'"

		LSQL = LSQL & " 		    			FOR XML PATH('')  "
		LSQL = LSQL & " 		    			)  "
		LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"

		LSQL = LSQL & " 					AND DelYN = 'N'"

		LSQL = LSQL & " 		    		),1,1,'') AS LPlayers"

		LSQL = LSQL & " 		    ,STUFF(("
		LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
		LSQL = LSQL & " 		    			SELECT  '|'   + CONVERT(VARCHAR(10),MemberIDX) "
		LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
		LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "

		LSQL = LSQL & " 						AND GameLevelDtlidx = AAA.GameLevelDtlidx"
		LSQL = LSQL & " 						AND DelYN = 'N'"

		LSQL = LSQL & " 		    			FOR XML PATH('')  "
		LSQL = LSQL & " 		    			)  "
		LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"

		LSQL = LSQL & " 					AND DelYN = 'N'"

		LSQL = LSQL & " 		    		),1,1,'') AS LPlayerIDXs"

		LSQL = LSQL & " 		    ,STUFF(("
		LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
		LSQL = LSQL & " 		    			SELECT  '|'   + UserName "
		LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
		LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "

		LSQL = LSQL & " 						AND GameLevelDtlidx = AAA.GameLevelDtlidx"
		LSQL = LSQL & " 						AND DelYN = 'N'"

		LSQL = LSQL & " 		    			FOR XML PATH('')  "
		LSQL = LSQL & " 		    			)  "
		LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"

		LSQL = LSQL & " 					AND DelYN = 'N'"

		LSQL = LSQL & " 		    		),1,1,'') AS RPlayers"

		LSQL = LSQL & " 		    ,STUFF(("
		LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
		LSQL = LSQL & " 		    			SELECT  '|'   + CONVERT(VARCHAR(10),MemberIDX) "
		LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
		LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "

		LSQL = LSQL & " 						AND GameLevelDtlidx = AAA.GameLevelDtlidx"
		LSQL = LSQL & " 						AND DelYN = 'N'"

		LSQL = LSQL & " 		    			FOR XML PATH('')  "
		LSQL = LSQL & " 		    			)  "
		LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"

		LSQL = LSQL & " 					AND DelYN = 'N'"

		LSQL = LSQL & " 		    		),1,1,'') AS RPlayerIDXs"

		LSQL = LSQL & " "
		LSQL = LSQL & " 		    ,STUFF((		"
		LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
		LSQL = LSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
		LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer " 
		LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "

		LSQL = LSQL & " 						AND GameLevelDtlidx = AAA.GameLevelDtlidx"
		LSQL = LSQL & " 						AND DelYN = 'N'"

		LSQL = LSQL & " 		    			FOR XML PATH('')  "
		LSQL = LSQL & " 		    			)  "
		LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"

		LSQL = LSQL & " 					AND DelYN = 'N'"

		LSQL = LSQL & " 		    		),1,1,'') AS LTeams"
		LSQL = LSQL & " 		    ,STUFF((		"
		LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
		LSQL = LSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
		LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
		LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "

		LSQL = LSQL & " 						AND GameLevelDtlidx = AAA.GameLevelDtlidx"
		LSQL = LSQL & " 						AND DelYN = 'N'"

		LSQL = LSQL & " 		    			FOR XML PATH('')  "
		LSQL = LSQL & " 		    			)  "
		LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"

		LSQL = LSQL & " 					AND DelYN = 'N'"

		LSQL = LSQL & " 		    		),1,1,'') AS RTeams"
		LSQL = LSQL & " "
		LSQL = LSQL & " 		    FROM tblTourney A"
		LSQL = LSQL & " 		    INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
		LSQL = LSQL & " 		    INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
		LSQL = LSQL & " 		    	LEFT JOIN ("
		LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
		LSQL = LSQL & " 		    		FROM KoreaBadminton.dbo.tblGameResult"
		LSQL = LSQL & " 		    		WHERE DelYN = 'N'"
		LSQL = LSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
		LSQL = LSQL & " 		    		) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
		LSQL = LSQL & " 		    	LEFT JOIN ("
		LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
		LSQL = LSQL & " 		    		FROM KoreaBadminton.dbo.tblGameResult"
		LSQL = LSQL & " 		    		WHERE DelYN = 'N'"
		LSQL = LSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
		LSQL = LSQL & " 		    		) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = B.TeamGameNum AND F.GameNum = B.GameNum AND F.TourneyGroupIDX = B.TourneyGroupIDX    "			
		LSQL = LSQL & " 		    	LEFT JOIN ("
		LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum "
		LSQL = LSQL & " 		    		FROM KoreaBadminton.dbo.tblGameSign"
		LSQL = LSQL & " 		    		WHERE DelYN = 'N' "
		LSQL = LSQL & " 		    		) AS G ON G.GameLevelDtlidx = A.GameLevelDtlidx AND G.TeamGameNum = A.TeamGameNum AND G.GameNum = A.GameNum  "			          
		LSQL = LSQL & " 		    WHERE A.DelYN = 'N'"
		LSQL = LSQL & " 		    AND B.DelYN = 'N'"
		LSQL = LSQL & " 		    AND C.DelYN = 'N'"
		LSQL = LSQL & " 		    AND D.DelYN = 'N'"
		LSQL = LSQL & " 		    AND A.ORDERBY < B.ORDERBY"
		LSQL = LSQL & " 			AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
		LSQL = LSQL & " 		    AND A.TeamGameNum = '" & DEC_TeamGameNum & "'"
		LSQL = LSQL & " 		    AND A.GameNum = '" & DEC_GameNum & "'"
		LSQL = LSQL & " 		) AS AA"
		LSQL = LSQL & " 		WHERE GameLevelDtlIDX IS NOT NULL"
		LSQL = LSQL & " 	) AS BBB"
		LSQL = LSQL & " ) AS CCC"
		LSQL = LSQL & " WHERE CCC.GameLevelDtlIDX IS NOT NULL"       
		Set rs = db.ExecSQLReturnRS(LSQL , null, ConStr)
	'기본정보

	'Response.Write "LSQL" & LSQL
	'Call rsdrow(rs)
	'Response.End
	
	

	If Not rs.EOF Then 

		rsloopcnt = Rs.Fields.Count-1
		ReDim fieldarr(rsloopcnt)
		For i = 0 To rsloopcnt
			fieldarr(i) = Rs.Fields(i).name
		Next
	
		arrRS = rs.getrows()
	Else
		Response.END
	End If
	Set rs = Nothing

	Set game = JSON.Parse("{}")
	Set tpoint1 = JSON.Parse("{}")
	Set tpoint2 = JSON.Parse("{}")

	If IsArray(arrRS) Then

		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
				For i=0 To rsloopcnt
					Call game.Set( fieldarr(i),  arrRS( i ,ar) )
				Next 
		Next

		'각팀의 두번째 선수가 없으면 단식, 그외 복식
		If game.Lplayer2 = "" Or game.Rplayer2 = "" Then
			GameType = "Solo"
		Else
			Gametype = "Dual"
		End If
		
	End if

	SQL = "SELECT ISNULL(SUM(SetPoint1),0) AS SetPoint1,		"
	SQL = SQL & "    ISNULL(SUM(SetPoint2),0) AS SetPoint2,	"
	SQL = SQL & "    ISNULL(SUM(SetPoint3),0) AS SetPoint3,	"
	SQL = SQL & "    ISNULL(SUM(SetPoint4),0) AS SetPoint4,	"
	SQL = SQL & "    ISNULL(SUM(SetPoint5),0) AS SetPoint5	"
	SQL = SQL & "    FROM	"
	SQL = SQL & "     (		"
	SQL = SQL & "     SELECT CASE WHEN SetNum = '1' THEN Jumsu ELSE 0 END AS SetPoint1,	"
	SQL = SQL & "     CASE WHEN SetNum = '2' THEN Jumsu ELSE 0 END AS SetPoint2,	"
	SQL = SQL & "     CASE WHEN SetNum = '3' THEN Jumsu ELSE 0 END AS SetPoint3,	"
	SQL = SQL & "     CASE WHEN SetNum = '4' THEN Jumsu ELSE 0 END AS SetPoint4,	"
	SQL = SQL & "     CASE WHEN SetNum = '5' THEN Jumsu ELSE 0 END AS SetPoint5	"
	SQL = SQL & "     FROM KoreaBadminton.dbo.tblTourney A	"
	SQL = SQL & "     LEFT JOIN KoreaBadminton.dbo.tblGameResultDtl B ON B.TourneyGroupIDX = A.TourneyGroupIDX AND B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum	"
	SQL = SQL & "     WHERE A.DelYN = 'N'	"
	SQL = SQL & "     AND B.DelYN = 'N'	"
	SQL = SQL & "     AND B.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'	"
	SQL = SQL & "     AND B.TeamGameNum = '" & DEC_TeamGameNum & "'	"
	SQL = SQL & "     AND B.GameNum = '" & DEC_GameNum & "'	"

	SQLL = SQL & "     AND B.TourneyGroupIDX = '" & game.LTourneyGroupIDX & "'	 ) as c"
	Set rs = db.ExecSQLReturnRS(SQLL , null, ConStr)

	If Not rs.EOF Then 
		rsloopcnt = Rs.Fields.Count-1
		ReDim fieldarr(rsloopcnt)
		For i = 0 To rsloopcnt
			  fieldarr(i) = Rs.Fields(i).name
		Next
		arrRS = rs.getrows()
	End If
	Set rs = Nothing

	If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
			For i=0 To rsloopcnt
				Call tpoint1.Set( fieldarr(i),  arrRS( i ,ar) )
			Next 
	Next
	End if

	SQLR = SQL & "     AND B.TourneyGroupIDX = '" & game.RTourneyGroupIDX & "' ) as c	"
	Set rs = db.ExecSQLReturnRS(SQLR , null, ConStr)

	If Not rs.EOF Then 
		rsloopcnt = Rs.Fields.Count-1
		ReDim fieldarr(rsloopcnt)
		For i = 0 To rsloopcnt
			  fieldarr(i) = Rs.Fields(i).name
		Next
		arrRS = rs.getrows()
	End If
	Set rs = Nothing

	If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
			For i=0 To rsloopcnt
				Call tpoint2.Set( fieldarr(i),  arrRS( i ,ar) )
			Next 
	Next
	End if

	SQL =  "SELECT ISNULL(MAX(Set1_RcvMember),'') AS Set1_RcvMember, ISNULL(MAX(Set1_RcvTourneyGroupIDX),'') AS Set1_RcvTourneyGroupIDX, ISNULL(MAX(Set1_ServeMemberIDX),'') AS Set1_ServeMemberIDX, ISNULL(MAX(Set1_ServeTourneyGroupIDX),'') AS Set1_ServeTourneyGroupIDX,"
	SQL = SQL & " ISNULL(MAX(Set2_RcvMember),'') AS Set2_RcvMember, ISNULL(MAX(Set2_RcvTourneyGroupIDX),'') AS Set2_RcvTourneyGroupIDX, ISNULL(MAX(Set2_ServeMemberIDX),'') AS Set2_ServeMemberIDX, ISNULL(MAX(Set2_ServeTourneyGroupIDX),'') AS Set2_ServeTourneyGroupIDX,"
	SQL = SQL & " ISNULL(MAX(Set3_RcvMember),'') AS Set3_RcvMember, ISNULL(MAX(Set3_RcvTourneyGroupIDX),'') AS Set3_RcvTourneyGroupIDX, ISNULL(MAX(Set3_ServeMemberIDX),'') AS Set3_ServeMemberIDX, ISNULL(MAX(Set3_ServeTourneyGroupIDX),'') AS Set3_ServeTourneyGroupIDX"
	SQL = SQL & " FROM"
	SQL = SQL & " ("
	SQL = SQL & " SELECT CASE WHEN SetNum = '1' THEN RcvMemberIDX ELSE '' END AS Set1_RcvMember,"
	SQL = SQL & " CASE WHEN SetNum = '1' THEN RcvTourneyGroupIDX ELSE '' END AS Set1_RcvTourneyGroupIDX,"
	SQL = SQL & " CASE WHEN SetNum = '1' THEN ServeMemberIDX ELSE '' END AS Set1_ServeMemberIDX,"
	SQL = SQL & " CASE WHEN SetNum = '1' THEN ServeTourneyGroupIDX ELSE '' END AS Set1_ServeTourneyGroupIDX,"
	SQL = SQL & " CASE WHEN SetNum = '2' THEN RcvMemberIDX ELSE '' END AS Set2_RcvMember,"
	SQL = SQL & " CASE WHEN SetNum = '2' THEN RcvTourneyGroupIDX ELSE '' END AS Set2_RcvTourneyGroupIDX,"
	SQL = SQL & " CASE WHEN SetNum = '2' THEN ServeMemberIDX ELSE '' END AS Set2_ServeMemberIDX,"
	SQL = SQL & " CASE WHEN SetNum = '2' THEN ServeTourneyGroupIDX ELSE '' END AS Set2_ServeTourneyGroupIDX,"
	SQL = SQL & " CASE WHEN SetNum = '3' THEN RcvMemberIDX ELSE '' END AS Set3_RcvMember,"
	SQL = SQL & " CASE WHEN SetNum = '3' THEN RcvTourneyGroupIDX ELSE '' END AS Set3_RcvTourneyGroupIDX,"
	SQL = SQL & " CASE WHEN SetNum = '3' THEN ServeMemberIDX ELSE '' END AS Set3_ServeMemberIDX,"
	SQL = SQL & " CASE WHEN SetNum = '3' THEN ServeTourneyGroupIDX ELSE '' END AS Set3_ServeTourneyGroupIDX"
	SQL = SQL & " FROM tblGameProgress "
	SQL = SQL & " WHERE DelYN = 'N'"
	SQL = SQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
	SQL = SQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
	SQL = SQL & " AND GameNum = '" & DEC_GameNum & "'"
	SQL = SQL & " ) AS A"


	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		Set1_RcvMember = rs("Set1_RcvMember")
		Set1_RcvTourneyGroupIDX = rs("Set1_RcvTourneyGroupIDX")
		Set1_ServeMemberIDX = rs("Set1_ServeMemberIDX")
		Set1_ServeTourneyGroupIDX = rs("Set1_ServeTourneyGroupIDX")

		Set2_RcvMember = rs("Set2_RcvMember")
		Set2_RcvTourneyGroupIDX = rs("Set2_RcvTourneyGroupIDX")
		Set2_ServeMemberIDX = rs("Set2_ServeMemberIDX")
		Set2_ServeTourneyGroupIDX = rs("Set2_ServeTourneyGroupIDX")

		Set3_RcvMember = rs("Set3_RcvMember")
		Set3_RcvTourneyGroupIDX = rs("Set3_RcvTourneyGroupIDX")
		Set3_ServeMemberIDX = rs("Set3_ServeMemberIDX")
		Set3_ServeTourneyGroupIDX = rs("Set3_ServeTourneyGroupIDX")
		
	End If


	Set rs = Nothing

	

'/////////////////@@@@@@@@@@@@@

	'//기록 항목 
		'SQL =  "SELECT CASE WHEN AAAA.TourneyGroupIDx = '"& game.LTourneyGroupIDX &"' AND AAAA.ServerIDX = '"& game.LPlayerIDX1 &"' THEN Nu_Jumsu ELSE '' END AS LPoint_1, dbo.FN_NameSch('"& game.LPlayerIDX1 &"','MemberIDX') AS Member1,	"
		'SQL = SQL & "CASE WHEN AAAA.TourneyGroupIDx = '"& game.LTourneyGroupIDX &"' AND AAAA.ServerIDX = '"& game.LPlayerIDX2 &"' THEN Nu_Jumsu ELSE '' END AS LPoint_2, dbo.FN_NameSch('"& game.LPlayerIDX2 &"','MemberIDX') AS Member2,	"
		'SQL = SQL & "CASE WHEN AAAA.TourneyGroupIDx = '"& game.RTourneyGroupIDX &"' AND AAAA.ServerIDX = '"& game.RPlayerIDX1 &"' THEN Nu_Jumsu ELSE '' END AS RPoint_1,dbo.FN_NameSch('"& game.RPlayerIDX1 &"','MemberIDX') AS Member3,	"
		'SQL = SQL & "CASE WHEN AAAA.TourneyGroupIDx = '"& game.RTourneyGroupIDX &"' AND AAAA.ServerIDX = '"& game.RPlayerIDX2 &"' THEN Nu_Jumsu ELSE '' END AS RPoint_2, dbo.FN_NameSch('"& game.RPlayerIDX2 &"','MemberIDX') AS Member4,	"
		'SQL = SQL & "AAAA.RecieveMemberIDX, AAAA.ServeMemberIDX, dbo.FN_NameSch(ServerIDX,'MemberIDX') AS ServeMemberNM, TourneyGroupIDx, RecieveMemberIDX,  SetNum, GameResultDtlIDx	"
		'SQL = SQL & "FROM	"
		'SQL = SQL & "	(	"
		'SQL = SQL & "	SELECT AAA.ServerIDX, dbo.FN_NameSch(AAA.ServerIDX,'MemberIDX') AS ServerName, AAA.GameResultDtlIDx,	"
		'SQL = SQL & "	AAA.NU_JumSu, AAA.TourneyGroupIDX, AAA.RecieveMemberIDX, AAA.ServeMemberIDX, AAA.SetNum	"
		'SQL = SQL & "	FROM 	"
		'SQL = SQL & "		(	"
		'SQL = SQL & "         SELECT AA.NextServeMemberIDX AS ServerIDX,	"
		'SQL = SQL & "			   AA.NU_JumSu, AA.TourneyGroupIDX, AA.GameResultDtlIDx, AA.RecieveMemberIDX, AA.ServeMemberIDX, AA.SetNum	"
		'SQL = SQL & "		FROM	"
		'SQL = SQL & "			(	"
		'SQL = SQL & "			SELECT B.TourneyGroupIDX,"
		'SQL = SQL & " 			CASE WHEN A.SpecialtyGb <> '' THEN dbo.FN_NameSch(A.SpecialtyGb,'PubSub') ELSE CONVERT(VARCHAR(8),SUM(CONVERT(INT,A.Jumsu))) END AS NU_JumSu,  "
		'SQL = SQL & " 			B.GameResultDtlIDx, "
		'SQL = SQL & "			CASE WHEN B.TourneyGroupIDX = B.ServeTourneyGroupIDX THEN 'S' ELSE 'R' END AS STRWIN,	"
		'SQL = SQL & "			dbo.FN_NameSch(B.Pst_MemberIDX_LL,'MemberIDX') AS MemberNameLL, B.Pst_MemberIDX_LL,	"
		'SQL = SQL & "			dbo.FN_NameSch(B.Pst_MemberIDX_LR,'MemberIDX') AS MemberNameLR, B.Pst_MemberIDX_LR,	"
		'SQL = SQL & "			dbo.FN_NameSch(B.Pst_MemberIDX_RL,'MemberIDX') AS MemberNameRL, B.Pst_MemberIDX_RL,	"
		'SQL = SQL & "			dbo.FN_NameSch(B.Pst_MemberIDX_RR,'MemberIDX') AS MemberNameRR, B.Pst_MemberIDX_RR,	"
		'SQL = SQL & "			B.ServeMemberIDX, B.RecieveMemberIDX, B.Pst_TourneyGroupIDX_L, B.Pst_TourneyGroupIDX_R, B.NextServeMemberIDX, A.SetNum	"
		'SQL = SQL & "			FROM KoreaBadminton.dbo.tblGameResultDtl A	"
		'SQL = SQL & "			INNER JOIN KoreaBadminton.dbo.tblGameResultDtl B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.Gamenum AND B.SetNum = A.SetNum AND B.GameResultDtlIDx >= A.GameResultDtlIDx  AND A.TourneyGroupIDX = B.TourneyGroupIDX "
		'SQL = SQL & "			WHERE A.DelYN = 'N'	"
		'SQL = SQL & "			AND B.DelYN = 'N'	"
		'SQL = SQL & "			AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "' AND A.TeamGameNum = '" & DEC_TeamGameNum & "' AND A.GameNum = '" & DEC_GameNum & "'"
		'
		'SQL = SQL & " 			AND A.SetNum IN ('1','2','3')	"
		'
		'SQL = SQL & "			GROUP BY B.TourneyGroupIDX, B.GameResultDtlIDx, B.Pst_MemberIDX_LL, B.Pst_MemberIDX_LR, 	"
		'SQL = SQL & "            B.Pst_MemberIDX_RR, B.Pst_MemberIDX_RL, B.ServeTourneyGroupIDX, B.ServeMemberIDX, B.RecieveMemberIDX, B.ServeMemberIDX, B.RecieveMemberIDX, B.Pst_TourneyGroupIDX_L, B.Pst_TourneyGroupIDX_R, B.NextServeMemberIDX, A.SetNum	"
		'SQL = SQL & "			) AS AA	"
		'SQL = SQL & "		) AS AAA	"
		'SQL = SQL & "	) AS AAAA	"
		'SQL = SQL & "	ORDER BY AAAA.SetNum, AAAA.GameResultDtlIDx	"


		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'//기록 항목 
'Call rsdrow(rs)
'테스트로 찍어봄.. .지우자.



	'//기록 항목 
		SQL =  "SELECT CASE WHEN AAAA.TourneyGroupIDx = '"& game.LTourneyGroupIDX &"' AND AAAA.ServerIDX = '"& game.LPlayerIDX1 &"' THEN Nu_Jumsu ELSE '' END AS LPoint_1, dbo.FN_NameSch('"& game.LPlayerIDX1 &"','MemberIDX') AS Member1,	"
		SQL = SQL & "CASE WHEN AAAA.TourneyGroupIDx = '"& game.LTourneyGroupIDX &"' AND AAAA.ServerIDX = '"& game.LPlayerIDX2 &"' THEN Nu_Jumsu ELSE '' END AS LPoint_2, dbo.FN_NameSch('"& game.LPlayerIDX2 &"','MemberIDX') AS Member2,	"
		SQL = SQL & "CASE WHEN AAAA.TourneyGroupIDx = '"& game.RTourneyGroupIDX &"' AND AAAA.ServerIDX = '"& game.RPlayerIDX1 &"' THEN Nu_Jumsu ELSE '' END AS RPoint_1,dbo.FN_NameSch('"& game.RPlayerIDX1 &"','MemberIDX') AS Member3,	"
		SQL = SQL & "CASE WHEN AAAA.TourneyGroupIDx = '"& game.RTourneyGroupIDX &"' AND AAAA.ServerIDX = '"& game.RPlayerIDX2 &"' THEN Nu_Jumsu ELSE '' END AS RPoint_2, dbo.FN_NameSch('"& game.RPlayerIDX2 &"','MemberIDX') AS Member4,	"
		SQL = SQL & "AAAA.RecieveMemberIDX, AAAA.ServeMemberIDX, dbo.FN_NameSch(ServerIDX,'MemberIDX') AS ServeMemberNM, TourneyGroupIDx, RecieveMemberIDX,  SetNum, GameResultDtlIDx	"
		SQL = SQL & "FROM	"
		SQL = SQL & "	(	"
		SQL = SQL & "	SELECT AAA.ServerIDX, dbo.FN_NameSch(AAA.ServerIDX,'MemberIDX') AS ServerName, AAA.GameResultDtlIDx,	"
		SQL = SQL & "	AAA.NU_JumSu, AAA.TourneyGroupIDX, AAA.RecieveMemberIDX, AAA.ServeMemberIDX, AAA.SetNum	"
		SQL = SQL & "	FROM 	"
		SQL = SQL & "		(	"
		SQL = SQL & "         SELECT AA.NextServeMemberIDX AS ServerIDX,	"
		SQL = SQL & "			   AA.NU_JumSu, AA.TourneyGroupIDX, AA.GameResultDtlIDx, AA.RecieveMemberIDX, AA.ServeMemberIDX, AA.SetNum	"
		SQL = SQL & "		FROM	"
		SQL = SQL & "			(	"
		SQL = SQL & "			SELECT B.TourneyGroupIDX, B.GameResultDtlIDx,	"
		SQL = SQL & "			CASE WHEN A.SpecialtyGb <> '' THEN dbo.FN_NameSch(A.SpecialtyGb,'PubSub') ELSE CONVERT(VARCHAR(8),SUM(CONVERT(INT,B.Jumsu))) END AS NU_Jumsu,"
		SQL = SQL & "			CASE WHEN B.TourneyGroupIDX = B.ServeTourneyGroupIDX THEN 'S' ELSE 'R' END AS STRWIN,	"
		SQL = SQL & "			dbo.FN_NameSch(B.Pst_MemberIDX_LL,'MemberIDX') AS MemberNameLL, B.Pst_MemberIDX_LL,	"
		SQL = SQL & "			dbo.FN_NameSch(B.Pst_MemberIDX_LR,'MemberIDX') AS MemberNameLR, B.Pst_MemberIDX_LR,	"
		SQL = SQL & "			dbo.FN_NameSch(B.Pst_MemberIDX_RL,'MemberIDX') AS MemberNameRL, B.Pst_MemberIDX_RL,	"
		SQL = SQL & "			dbo.FN_NameSch(B.Pst_MemberIDX_RR,'MemberIDX') AS MemberNameRR, B.Pst_MemberIDX_RR,	"
		SQL = SQL & "			B.ServeMemberIDX, B.RecieveMemberIDX, B.Pst_TourneyGroupIDX_L, B.Pst_TourneyGroupIDX_R, B.NextServeMemberIDX, A.SetNum	"
		SQL = SQL & "			FROM KoreaBadminton.dbo.tblGameResultDtl A	"

		SQL = SQL & "			INNER JOIN KoreaBadminton.dbo.tblGameResultDtl B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.Gamenum "
		SQL = SQL & " 				AND B.SetNum = A.SetNum AND B.GameResultDtlIDx >= A.GameResultDtlIDx  AND A.TourneyGroupIDX = B.TourneyGroupIDX "
		SQL = SQL & "				AND A.SpecialtyGb = B.SpecialtyGb "		
		SQL = SQL & "			WHERE A.DelYN = 'N'	"
		SQL = SQL & "			AND B.DelYN = 'N'	"
		SQL = SQL & "			AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "' AND A.TeamGameNum = '" & DEC_TeamGameNum & "' AND A.GameNum = '" & DEC_GameNum & "'"
		
		SQL = SQL & " 			AND A.SetNum IN ('1','2','3')	"
		
		SQL = SQL & "			GROUP BY B.TourneyGroupIDX, B.GameResultDtlIDx, B.Pst_MemberIDX_LL, B.Pst_MemberIDX_LR, 	"
		SQL = SQL & "            B.Pst_MemberIDX_RR, B.Pst_MemberIDX_RL, B.ServeTourneyGroupIDX, B.ServeMemberIDX, B.RecieveMemberIDX, B.ServeMemberIDX, B.RecieveMemberIDX,"
		SQL = SQL & " 			 B.Pst_TourneyGroupIDX_L, B.Pst_TourneyGroupIDX_R, B.NextServeMemberIDX, A.SetNum, A.SpecialtyGb	"
		SQL = SQL & "			) AS AA	"
		SQL = SQL & "		) AS AAA	"
		SQL = SQL & "	) AS AAAA	"
		SQL = SQL & "	ORDER BY AAAA.SetNum, AAAA.GameResultDtlIDx	"


		'REsponse.WRite SQL
		'REsponse.END
		
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'//기록 항목 
  'Response.Write "SQL" & SQL & "<BR>"
	If Not rs.EOF Then 
		arrRS2 = rs.getrows()
	End if
	Set rs = Nothing


'Call rsdrow(rs)
'Response.end
	'//jaax send obj
	Set snedobj = JSON.Parse("{}")
	Call snedobj.Set( "DEC_GameLevelDtlIDX",  DEC_GameLevelDtlIDX )
	Call snedobj.Set( "DEC_TeamGameNum",  DEC_TeamGameNum )
	Call snedobj.Set( "DEC_GameNum",  DEC_GameNum )
	Call snedobj.Set( "LTourneyGroupIDX",  game.LTourneyGroupIDX )
	Call snedobj.Set( "RTourneyGroupIDX",  game.RTourneyGroupIDX )
	Call snedobj.Set( "SetNum",  1 )
	strjson = JSON.stringify(snedobj)
	IF DEC_IsPrint ="0" Then
		tpoint1.SetPoint1 = "0"
		tpoint2.SetPoint1 = "0"
		tpoint1.SetPoint2= "0"
		tpoint2.SetPoint2= "0"
		tpoint1.SetPoint3= "0"
		tpoint2.SetPoint3= "0"
	End IF

%>


  <table border="0" cellpadding="0" cellspacing="0" id="sheet0" class="sheet0">
    <col class="col0">
    <col class="col1">
    <col class="col2">
    <col class="col3">
    <col class="col4">
    <col class="col5">
    <col class="col6">
    <col class="col7">
    <col class="col8">
    <col class="col9">
    <col class="col10">
    <col class="col11">
    <col class="col12">
    <col class="col13">
    <col class="col14">
    <col class="col15">
    <col class="col16">
    <col class="col17">
    <col class="col18">
    <col class="col19"
    <col class="col20">
    <col class="col21">
    <col class="col22">
    <col class="col23">
    <col class="col24">
    <col class="col25">
    <col class="col26">
    <col class="col27">
    <col class="col28">
    <col class="col29">
    <col class="col30">
    <col class="col31">
    <col class="col32">
    <col class="col33">
    <col class="col34">
    <col class="col35">
    <col class="col36">
    <col class="col37">
    <col class="col38">
    <col class="col39">
    <col class="col40">
    <col class="col41">
    <col class="col42">
    <col class="col43">
    <tbody>
      <tr class="row0">
        <td class="column0">&nbsp;</td>
        <td class="column1">&nbsp;</td>
        <td class="column2">&nbsp;</td>
        <td class="column3">&nbsp;</td>
        <td class="column4">&nbsp;</td>
        <td class="column5">&nbsp;</td>
        <td class="column6">&nbsp;</td>
        <td class="column7">&nbsp;</td>
        <td class="column8">&nbsp;</td>
        <td class="column9">&nbsp;</td>
        <td class="column10">&nbsp;</td>
        <td class="column11">&nbsp;</td>
        <td class="column12">&nbsp;</td>
        <td class="column13">&nbsp;</td>
        <td class="column14">&nbsp;</td>
        <td class="column15">&nbsp;</td>
        <td class="column16">&nbsp;</td>
        <td class="column17">&nbsp;</td>
        <td class="column18">&nbsp;</td>
        <td class="column19">&nbsp;</td>
        <td class="column20">&nbsp;</td>
        <td class="column21">&nbsp;</td>
        <td class="column22">&nbsp;</td>
        <td class="column23">&nbsp;</td>
        <td class="column24">&nbsp;</td>
        <td class="column25">&nbsp;</td>
        <td class="column26">&nbsp;</td>
        <td class="column27">&nbsp;</td>
        <td class="column28">&nbsp;</td>
        <td class="column29">&nbsp;</td>
        <td class="column30">&nbsp;</td>
        <td class="column31">&nbsp;</td>
        <td class="column32">&nbsp;</td>
        <td class="column33">&nbsp;</td>
        <td class="column34">&nbsp;</td>
        <td class="column35">&nbsp;</td>
        <td class="column36">&nbsp;</td>
        <td class="column37">&nbsp;</td>
        <td class="column38">&nbsp;</td>
        <td class="column39">&nbsp;</td>
        <td class="column40">&nbsp;</td>
        <td class="column41">&nbsp;</td>
        <td class="column42">&nbsp;</td>
        <td class="column43">&nbsp;</td>
      </tr>
      <tr class="row1">
        <td class="column0">&nbsp;</td>
        <td class="column1 style39 s style39" colspan="8" style="font-weight: bold;font-size: 18pt;font-family: '맑은 고딕'"><%=game.gametitle%>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</td>
        <td class="column9">&nbsp;</td>
        <td class="column10">&nbsp;</td>
        <td class="column11">&nbsp;</td>
        <td class="column12">&nbsp;</td>
        <td class="column13">&nbsp;</td>
        <td class="column14">&nbsp;</td>
        <td class="column15">&nbsp;</td>
        <td class="column16">&nbsp;</td>
        <td class="column17">&nbsp;</td>
        <td class="column18">&nbsp;</td>
        <td class="column19">&nbsp;</td>
        <td class="column20">&nbsp;</td>
        <td class="column21">&nbsp;</td>
        <td class="column22">&nbsp;</td>
        <td class="column23">&nbsp;</td>
        <td class="column24">&nbsp;</td>
        <td class="column25">&nbsp;</td>
        <td class="column26">&nbsp;</td>
        <td class="column27">&nbsp;</td>
        <td class="column28">&nbsp;</td>
        <td class="column29">&nbsp;</td>
        <td class="column30">&nbsp;</td>
        <td class="column31">&nbsp;</td>
        <td class="column32">&nbsp;</td>
        <td class="column33 style19 s style19" colspan="3" style="font-size: 11pt;font-family: '맑은 고딕';">Court:<%=DEC_StadiumNum%></td>
        <td class="column36 style7 n style7" colspan="6" style="font-size: 16pt;font-family: '맑은 고딕';font-weight: bold; text-align: left;"><!--5--></td>
        <td class="column42">&nbsp;</td>
        <td class="column43">&nbsp;</td>
      </tr>
      <tr class="row2">
        <td class="column0">&nbsp;</td>
        <td class="column1">&nbsp;</td>
        <td class="column2">&nbsp;</td>
        <td class="column3">&nbsp;</td>
        <td class="column4">&nbsp;</td>
        <td class="column5">&nbsp;</td>
        <td class="column6">&nbsp;</td>
        <td class="column7">&nbsp;</td>
        <td class="column8 style3 null"></td>
        <td class="column9">&nbsp;</td>
        <td class="column10">&nbsp;</td>
        <td class="column11">&nbsp;</td>
        <td class="column12">&nbsp;</td>
        <td class="column13">&nbsp;</td>
        <td class="column14">&nbsp;</td>
        <td class="column15">&nbsp;</td>
        <td class="column16">&nbsp;</td>
        <td class="column17">&nbsp;</td>
        <td class="column18">&nbsp;</td>
        <td class="column19 style41 s style41" colspan="4" style="font-size: 13pt;font-weight: bold;text-align: center;font-family: '맑은 고딕">Score</td>
        <td class="column23">&nbsp;</td>
        <td class="column24">&nbsp;</td>
        <td class="column25">&nbsp;</td>
        <td class="column26">&nbsp;</td>
        <td class="column27">&nbsp;</td>
        <td class="column28">&nbsp;</td>
        <td class="column29">&nbsp;</td>
        <td class="column30">&nbsp;</td>
        <td class="column31">&nbsp;</td>
        <td class="column32">&nbsp;</td>
        <td class="column33 style19 s style19" colspan="3" style="font-size: 11pt;">Umpire:</td>
        <td class="column36 style7 s style7" colspan="6" style="font-size: 16pt;font-family: '맑은 고딕';font-weight: bold; "><!--Ho Hee Shen (SGP)Ho Hee Shen (SGP)--></td>
        <td class="column42">&nbsp;</td>
        <td class="column43">&nbsp;</td>
      </tr>
      <tr class="row3">
        <td class="column0">&nbsp;</td>
        <td class="column1 style20 s" style="font-size: 11pt;font-family: '맑은 고딕'; height: 34px;">Event:<tr><th>Event :</th><td><%Response.Write game.Sex & game.PlayTypeName & " " & game.TeamGbNM & " " & game.LevelName & " " & game.LevelJooName & " " &  game.LevelJooNum %>&nbsp;</td>
        <td class="column2 style7 s style7" colspan="4" style="font-size: 21px;font-family: '맑은 고딕';font-weight: bold;">&nbsp;<!--MS--></td>
        <td class="column6 style16 null"></td>
        <td class="column7 style17 null"></td>
        <td class="column8 style8 null"></td>
        <td class="column9">&nbsp;</td>
        <td class="column10 style15 s" style="border-top: 2px solid #000; border-left: 2px solid #000; border-bottom: 2px solid #000;font-size: 16px;text-align: center; font-weight: bold; font-family: '맑은 고딕'; text-align: center;">L</td>
        <td class="column11 style21 s style23" colspan="7" style="font-size: 14pt;font-family: '맑은 고딕';font-weight: bold; border-top: 2px solid #000; border-left: 2px solid #000; border-right: 2px solid #000; border-bottom: 1px solid #000;">&nbsp;&nbsp;<%=game.LPlayer1%></td>
        <td class="column18">&nbsp;</td>
        <td class="column19 style67 s style69" colspan="4" style="border-top: 2px solid #000;border-left: 2px solid #000;border-right: 2px solid #000;border-bottom: 1px solid #000;font-size: 12pt;font-weight: bold; mso-number-format:'@'; text-align: center;">
				
				<%=tpoint1.SetPoint1%> : <%=tpoint2.SetPoint1%></td>
        <td class="column23">&nbsp;</td>
        <td class="column24 style28 s style30" colspan="7" style="font-size: 14pt;font-family: '맑은 고딕';font-weight: bold; border-left: 2px solid #000; border-top: 2px solid #000; border-right: 2px solid #000; border-bottom: 1px solid #000; mso-number-format:'@'; background-color: #ddd;">&nbsp;&nbsp;<%=game.RPlayer1%></td>
        <td class="column31 style37 s" style="font-size: 11pt;font-family: '맑은 고딕';font-weight: bold;background-color: #ddd;border-right: 2px solid #000; border-top: 2px solid #000;  border-bottom: 2px solid #000; text-align: center;">R</td>
        <td class="column32">&nbsp;</td>
        <td class="column33 style19 s style19" colspan="3" style="font-size: 11pt;font-family: '맑은 고딕'; ">Service Judge:</td>
        <td class="column36 style7 s style7" colspan="6" style="font-size: 16pt;font-family: '맑은 고딕';font-weight: bold; "><!--Deepak Thapa (NEP)--></td>
        <td class="column42">&nbsp;</td>
        <td class="column43">&nbsp;</td>
      </tr>
      <tr class="row4">
        <td class="column0 style5 s"></td>
        <td class="column1 style20 s" style="font-size: 11pt; height: 34px;">No.<%=game.GameNum%></td>
        <td class="column2 style7 s style7" colspan="4" style="font-size: 21px;font-family: '맑은 고딕'; font-weight: bold; ">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</td>
        <td class="column6 style16 null"></td>
        <td class="column7 style17 null"></td>
        <td class="column8 style8 null"></td>
        <td class="column9">&nbsp;</td>
        <td class="column10">&nbsp;</td>
        <td class="column11 style12 null style14" colspan="7" style="font-size: 14pt;font-family: '맑은 고딕'; font-weight: bold;  height: 20px;border-left: 2px solid #000; border-right: 2px solid #000; border-bottom: 1px solid #000;">&nbsp;&nbsp;<%=game.LPlayer2%></td>
        <td class="column18">&nbsp;</td>
        <td class="column19 style70 s style72" colspan="4" style="mso-number-format:'@';font-size: 12pt;font-weight: bold;border-right: 2px solid #000;border-left: 2px solid #000;text-align: center; border-bottom: 1px solid #000; height: 30px;"><%=tpoint1.SetPoint2%> : <%=tpoint2.SetPoint2%></td>
        <td class="column23">&nbsp;</td>
        <td class="column24 style31 null style33" colspan="7" style="font-size: 14pt;font-family: '맑은 고딕'; font-weight: bold; background-color: #ddd; border-left: 2px solid #000; border-right: 2px solid #000; border-top: 0px solid #000;">&nbsp;&nbsp;<%=game.RPlayer2%></td>
        <td class="column31">&nbsp;</td>
        <td class="column32">&nbsp;</td>
        <td class="column33 style19 s style19" colspan="3" style="font-family: '맑은 고딕';font-size: 11pt;">Start match:</td>
        <td class="column36 style40 n style40" colspan="6" style="font-size: 16pt;font-family: '맑은 고딕'; font-weight: bold; mso-number-format:'@'"><!--20:28--></td>
        <td class="column42">&nbsp;</td>
        <td class="column43">&nbsp;</td>
      </tr>
      <tr class="row5">
        <td class="column0">&nbsp;</td>
        <td class="column1 style20 s" style="font-family: '맑은 고딕';font-size: 11pt;height: 34px;">Date: <%=year(game.gameday)%></td>
        <td class="column2 style9 s style9" colspan="4" style="font-size: 16pt;font-family: '맑은 고딕';font-weight: bold; ">&nbsp;<!--2017-11-28--></td>
        <!-- <td class="column6 style18 null"></td> -->
        <td class="column7 style3 s" colspan="2" style="font-size: 11pt;font-family: '맑은 고딕';">Time:</td>
        <td class="column8 style38 s style38" colspan="2" style="font-size: 21px;font-family: '맑은 고딕'; font-weight: bold; ">&nbsp;<!--19:30--></td>
        <td class="column10">&nbsp;</td>
        <td class="column11 style25 s style27" colspan="7" style="font-size: 12pt;font-family: '맑은 고딕';font-weight: bold;border-left: 2px solid #000;border-right: 2px solid #000;border-bottom: 2px solid #000;">&nbsp;&nbsp;<%=game.LTeam1%></td>
        <td class="column18">&nbsp;</td>
        <td class="column19 style73 s style75" colspan="4" style="mso-number-format:'@'; font-size: 12pt; font-weight: bold; text-align: center; border-bottom: 2px solid #000; border-left: 2px solid #000; border-right: 2px solid #000;"><%=tpoint1.SetPoint3%> : <%=tpoint2.SetPoint3%></td>
        <td class="column23">&nbsp;</td>
        <td class="column24 style34 s style36" colspan="7" style="font-size: 12pt;font-family: '맑은 고딕';font-weight: bold;border-left: 2px solid #000;border-bottom: 2px solid #000;border-right: 2px solid #000;border-top: 1px solid #000;background-color: #ddd;">&nbsp;&nbsp;<%=game.RTeam1%></td>
        <td class="column31">&nbsp;</td>
        <td class="column32">&nbsp;</td>
        <td class="column33 style19 s style19" colspan="3" style="font-size: 11pt;">End match:</td>
        <td class="column36 style40 n style40" colspan="6" style="font-size: 16pt;font-family: '맑은 고딕'; font-weight: bold; mso-number-format:'@'"><!--21:25--></td>
        <td class="column42">&nbsp;</td>
        <td class="column43">&nbsp;</td>
      </tr>
      <tr class="row6">
        <td class="column0">&nbsp;</td>
        <td class="column1">&nbsp;</td>
        <td class="column2">&nbsp;</td>
        <td class="column3">&nbsp;</td>
        <td class="column4">&nbsp;</td>
        <td class="column5">&nbsp;</td>
        <td class="column6">&nbsp;</td>
        <td class="column7">&nbsp;</td>
        <td class="column8">&nbsp;</td>
        <td class="column9">&nbsp;</td>
        <td class="column10">&nbsp;</td>
        <td class="column11">&nbsp;</td>
        <td class="column12">&nbsp;</td>
        <td class="column13">&nbsp;</td>
        <td class="column14">&nbsp;</td>
        <td class="column15">&nbsp;</td>
        <td class="column16">&nbsp;</td>
        <td class="column17">&nbsp;</td>
        <td class="column18">&nbsp;</td>
        <td class="column19 style1 null"></td>
        <td class="column20 style1 null"></td>
        <td class="column21 style1 null"></td>
        <td class="column22 style1 null"></td>
        <td class="column23">&nbsp;</td>
        <td class="column24">&nbsp;</td>
        <td class="column25">&nbsp;</td>
        <td class="column26">&nbsp;</td>
        <td class="column27">&nbsp;</td>
        <td class="column28">&nbsp;</td>
        <td class="column29">&nbsp;</td>
        <td class="column30">&nbsp;</td>
        <td class="column31">&nbsp;</td>
        <td class="column32">&nbsp;</td>
        <td class="column33 style19 s style19" colspan="3" style="font-size: 11pt;">Duration:</td>
        <td class="column36 style7 n style7" colspan="6" style="font-size: 16pt;font-family: '맑은 고딕'; font-weight: bold; mso-number-format:'@'"><!--57--></td>
        <td class="column42">&nbsp;</td>
        <td class="column43">&nbsp;</td>
      </tr>
      <tr class="row7">
        <td class="column0">&nbsp;</td>
        <td class="column1 style11 s style11" colspan="10" style="font-size: 12pt;font-family: '맑은 고딕';font-weight: bold;"><!--TournamentStats-->  </td>
        <td class="column11">&nbsp;</td>
        <td class="column12">&nbsp;</td>
        <td class="column13">&nbsp;</td>
        <td class="column14">&nbsp;</td>
        <td class="column15">&nbsp;</td>
        <td class="column16">&nbsp;</td>
        <td class="column17">&nbsp;</td>
        <td class="column18">&nbsp;</td>
        <td class="column19">&nbsp;</td>
        <td class="column20">&nbsp;</td>
        <td class="column21">&nbsp;</td>
        <td class="column22">&nbsp;</td>
        <td class="column23">&nbsp;</td>
        <td class="column24">&nbsp;</td>
        <td class="column25">&nbsp;</td>
        <td class="column26 style10 s style10" colspan="2" style="font-size: 11pt;font-family: '맑은 고딕';">Shuttles:</td>
        <td class="column28 style24 n" style="font-size: 16pt;font-family: '맑은 고딕'; font-weight: bold; mso-number-format:'@'"><!--14--></td>
        <td class="column29">&nbsp;</td>
        <td class="column30">&nbsp;</td>
        <td class="column31">&nbsp;</td>
        <td class="column32">&nbsp;</td>
        <td class="column33">&nbsp;</td>
        <td class="column34">&nbsp;</td>
        <td class="column35">&nbsp;</td>
        <td class="column36">&nbsp;</td>
        <td class="column37">&nbsp;</td>
        <td class="column38">&nbsp;</td>
        <td class="column39">&nbsp;</td>
        <td class="column40">&nbsp;</td>
        <td class="column41">&nbsp;</td>
        <td class="column42">&nbsp;</td>
        <td class="column43">&nbsp;</td>
      </tr>




    <%
      Function scoreSheet(ByVal reqsetno)

				IF DEC_IsPrint = "0" Then
					scoreSheet =  "----"
				ELSE
        Dim left1,left2, right1,right2,rstdtlidx, setno,left1arr,left2arr,right1arr,right2arr, rstdtlidxarr, i , j



        If IsArray(arrRS2) Then
        i = 1
        j  =1

        For ar = LBound(arrRS2, 2) To UBound(arrRS2, 2) 
        
            left1 = arrRS2( 0 ,ar)      ' L_Player1 Point
            left2 = arrRS2( 2 ,ar)      ' L_Player2 Point
            right1 = arrRS2( 4 ,ar)     ' R_Player1 Point
            right2 = arrRS2( 6 ,ar)     ' R_Player2 Point
            rstdtlidx = arrRS2( 14 ,ar) ' GameResultDtlIdx Point
            setno = arrRS2( 13 ,ar) ' SetNo

            If CDbl(setno) = (reqsetno) Then

							If left1arr = "" Then
									If left1 = "" then
										left1arr = left1arr & ",0,"
									Else
										left1arr = left1arr & ",0," & i
										i = i + 1
									End If

									If left2 = "" then					
										left2arr = left2arr & ",0,"
									Else
										left2arr = left2arr & ",0," & i
										i = i + 1
									End If

									If right1 = "" then	
										right1arr = right1arr & ",0,"
									Else
										right1arr = right1arr & ",0," & j
										j = j + 1
									End if	

									If right2 = "" then	
										right2arr = right2arr & ",0,"
									Else
										right2arr = right2arr & ",0," & j
										j = j + 1
									End if				

									If rstdtlidx = "" then
										rstdtlidxarr = rstdtlidxarr & ",,"
									Else
										rstdtlidxarr = rstdtlidxarr &  ",," & rstdtlidx 
													
									End If										
							Else
									If left1 = "" then
										left1arr = left1arr & ","
									Else
										left1arr = left1arr & "," & i
										i = i + 1
									End If

									If left2 = "" then					
										left2arr = left2arr & ","
									Else
										left2arr = left2arr & "," & i
										i = i + 1
									End If

									If right1 = "" then	
										right1arr = right1arr & ","
									Else
										right1arr = right1arr & "," & j
										j = j + 1
									End if	

									If right2 = "" then	
										right2arr = right2arr & ","
									Else
										right2arr = right2arr & "," & j
										j = j + 1
									End if				

									If rstdtlidx = "" then
										rstdtlidxarr = rstdtlidxarr & ","
									Else
										rstdtlidxarr = rstdtlidxarr &  "," & rstdtlidx 
													
									End If										
							End If


						




            End if



        Next
        End If
        	scoreSheet = left1arr & "-" & left2arr & "-" & right1arr & "-" & right2arr & "-" & rstdtlidxarr
				END IF 
      End Function 

			
    %>
<%'###################################################################%>	
		

			<%For n = 1 To 6
        Select Case n
        Case 1,2
					
          setdata =  scoreSheet(1)	
          Call snedobj.Set( "SetNum",  1 )
        Case 3,4
          setdata =  scoreSheet(2)
          Call snedobj.Set( "SetNum",  2 )
        Case 5,6
          setdata =  scoreSheet(3)
          Call snedobj.Set( "SetNum",  3 )
        End Select 
        'Response.Write "setdata : " &  setdata & "<br/>"
				marr = Split(setdata, "-")

			%>
					<tr class="row13">
            <td class="column0">&nbsp;</td>
            <td class="column1 style55 s style57" colspan="5" style="font-size:12pt; font-family: '맑은고딕'; font-weight: bold; border-left:2px solid #000; border-top:2px solid #000; border-right:2px solid #000; border-bottom:1px solid #000;">&nbsp;<%=game.LPlayer1%></td>
					  <%

              left1 = Split(marr(0), ",")
              rstdtlidx_1 = Split(marr(4), ",")

              For i = 0 To 35
                If n Mod 2 = 1 Then '홀수줄이라면
                  If i <= ubound(left1)  then
                    If left1(i) = "" Then
                      left1val = ""	
                    Else
                      left1val = left1(i)
                    End If

                    rstdtlidxval_1 = rstdtlidx_1(i)
                  End if
                Else
                  If i + 36 <= ubound(left1)  then
                    If left1(i+36) = "" Then
                      left1val = ""	
                    Else
                      left1val = left1(i+36)
                    End If

                    rstdtlidxval_1 = rstdtlidx_1(i+36)
                  End if					  
                End if
                Call snedobj.Set( "TourneyGroupIDX",  game.LTourneyGroupIDX )
                Call snedobj.Set( "GameResultDtlIDX",  rstdtlidxval_1 )
                Call snedobj.Set( "MemberIDX",  game.LPlayerIDX1 )
						    strjson = JSON.stringify(snedobj)						
					  %>

					  <%
                If (i = 0 Or i = 1) AND n Mod 2 = 1 Then

                  If n = 1 OR n = 2 Then
                    If game.LTourneyGroupIDX = Cstr(Set1_RcvTourneyGroupIDX) AND game.LPlayerIDX1 = Cstr(Set1_RcvMember) Then
                      left1val = "R"
                    ElseIf game.LTourneyGroupIDX = Cstr(Set1_ServeTourneyGroupIDX) AND game.LPlayerIDX1 = Cstr(Set1_ServeMemberIDX) Then
                      left1val = "S"
                    End If
                  ElseIf n = 3 OR n = 4 Then
                    If game.LTourneyGroupIDX = Cstr(Set2_RcvTourneyGroupIDX) AND game.LPlayerIDX1 = Cstr(Set2_RcvMember) Then
                      left1val = "R"
                    ElseIf game.LTourneyGroupIDX = Cstr(Set2_ServeTourneyGroupIDX) AND game.LPlayerIDX1 = Cstr(Set2_ServeMemberIDX) Then
                      left1val = "S"
                    End If						
                  ElseIf n = 5 OR n = 6 Then
                    If game.LTourneyGroupIDX = Cstr(Set3_RcvTourneyGroupIDX) AND game.LPlayerIDX1 = Cstr(Set3_RcvMember) Then
                      left1val = "R"
                    ElseIf game.LTourneyGroupIDX = Cstr(Set3_ServeTourneyGroupIDX) AND game.LPlayerIDX1 = Cstr(Set3_ServeMemberIDX) Then
                      left1val = "S"
                    End If						
                  End If

									If i = 0 AND (left1val = "S" OR left1val = "R") Then
										If GameType = "Solo" And left1val = "R" Then
											left1val = "" 
										End if										
									ElseIf i = 1 AND (left1val = "S" OR left1val = "R") Then
										left1val = "0"
									Else
										left1val = ""
									End If
									

									''해당경기가 단식이면 R표시 안보이게
									'If GameType = "Solo" Then
									'	If left1val = "R" Then
									'		left1val = ""
									'	End If
									'End If							


                End If

								If i = 0 Then
									str_border = "border-right:2px solid #000;"
								Else
									str_border = "border-right:1px solid #000;"
								End If

								
								IF DEC_IsPrint = "0" Then
									left1val = ""
								END IF
					  %>					  
              <td class="column style" style="font-size: 12pt;text-align: center;width: 37px;height: 29px;border-top:2px solid #000; <%=str_border%> border-bottom:1px solid #000;"><%=left1val%></td>
					  <%
  					  left1val = ""
					    rstdtlidxval_1 = ""
					  next%>

            <td class="column42">&nbsp;</td>
            <td class="column43">&nbsp;</td>
					</tr>

          <tr class="row14">
            <td class="column0" style="font-size: 12pt;">&nbsp;</td>
            <td class="column1 style25 null style58" colspan="5" style="font-size: 12pt;font-weight: bold; border-left:2px solid #000; border-right:2px solid #000; border-bottom:1px solid #000; height: 29px;text-align: left;">&nbsp;<%=game.LPlayer2%></td>
					  <%
					 left2 = Split(marr(1), ",")
					 rstdtlidx_2 = Split(marr(4), ",")


					  For i = 0 To 35
					  If n Mod 2 = 1 Then '홀수줄이라면
						  If i <= ubound(left2)  then
							  If left2(i) = "" Then
								left2val = ""	
							  Else
								left2val = left2(i)
							  End If

							  rstdtlidxval_2 = rstdtlidx_2(i)
						  End if
					  Else
						  If i + 36 <= ubound(left2)  then
							  If left2(i+36) = "" Then
								left2val = ""	
							  Else
								left2val = left2(i+36)
							  End If

							  rstdtlidxval_2 = rstdtlidx_2(i+36)
						  End if					  
					  End if

						Call snedobj.Set( "TourneyGroupIDX",  game.LTourneyGroupIDX )
						Call snedobj.Set( "GameResultDtlIDX",  rstdtlidxval_2 )
						Call snedobj.Set( "MemberIDX",  game.LPlayerIDX2 )
						strjson = JSON.stringify(snedobj)							  
					  %>					  

					  <%
					  	If (i = 0 Or i = 1) AND n Mod 2 = 1 Then
								If n = 1 OR n = 2 Then
									If game.LTourneyGroupIDX = Cstr(Set1_RcvTourneyGroupIDX) AND game.LPlayerIDX2 = Cstr(Set1_RcvMember) Then
										left2val = "R"
									ElseIf game.LTourneyGroupIDX = Cstr(Set1_ServeTourneyGroupIDX) AND game.LPlayerIDX2 = Cstr(Set1_ServeMemberIDX) Then
										left2val = "S"
									End If
								ElseIf n = 3 OR n = 4 Then
									If game.LTourneyGroupIDX = Cstr(Set2_RcvTourneyGroupIDX) AND game.LPlayerIDX2 = Cstr(Set2_RcvMember) Then
										left2val = "R"
									ElseIf game.LTourneyGroupIDX = Cstr(Set2_ServeTourneyGroupIDX) AND game.LPlayerIDX2 = Cstr(Set2_ServeMemberIDX) Then
										left2val = "S"
									End If						
								ElseIf n = 5 OR n = 6 Then
									If game.LTourneyGroupIDX = Cstr(Set3_RcvTourneyGroupIDX) AND game.LPlayerIDX2 = Cstr(Set3_RcvMember) Then
										left2val = "R"
									ElseIf game.LTourneyGroupIDX = Cstr(Set3_ServeTourneyGroupIDX) AND game.LPlayerIDX2 = Cstr(Set3_ServeMemberIDX) Then
										left2val = "S"
									End If						
								End If

								If i = 0 AND (left2val = "S" OR left2val = "R") Then
									left2val = left2val 
								ElseIf i = 1 AND (left2val = "S" OR left2val = "R") Then
									left2val = "0"
								Else
									left2val = ""
								End If
									
							End If
		
							If i = 0 Then
								str_border = "border-right:2px solid #000;"
							Else
								str_border = "border-right:1px solid #000;"
							End If		

							IF DEC_IsPrint = "0" Then
								left2val = ""
							END IF
					  %>	

						<td class="column style" style="font-size: 12pt;text-align: center;width: 37px;height: 29px;border-top:0px solid #000; <%=str_border%> solid #000; border-bottom:1px solid #000;"><%=left2val%></td>
					  <%
              left2val = ""
              rstdtlidxval_2 = ""
            next
            %>
            <td class="column42">&nbsp;</td>
            <td class="column43">&nbsp;</td>
					</tr>



					<tr class="row15">
					  <td class="column0">&nbsp;</td>
            <td class="column1 style59 s style61" colspan="5" style="background-color: #ddd;font-size:12pt; font-family: '맑은고딕'; font-weight: bold; border-left:2px solid #000; border-right:2px solid #000;  border-bottom:1px solid #000;">&nbsp;<%=game.RPlayer1%></td>
					 <%
					 right1 = Split(marr(2), ",")
					 rstdtlidx_3 = Split(marr(4), ",")

					  For i = 0 To 35
					  If n Mod 2 = 1 Then '홀수줄이라면
						  If i <= ubound(right1)  then
							  If right1(i) = "" Then
								right1val = ""	
							  Else
								right1val = right1(i)
							  End If

							  rstdtlidxval_3 = rstdtlidx_3(i)
						  End if
					  Else
						  If i + 36 <= ubound(right1)  then
							  If right1(i+36) = "" Then
								right1val = ""	
							  Else
								right1val = right1(i+36)
							  End If

							  rstdtlidxval_3 = rstdtlidx_3(i+36)
						  End if					  
					  End if

						Call snedobj.Set( "TourneyGroupIDX",  game.RTourneyGroupIDX )
						Call snedobj.Set( "GameResultDtlIDX",  rstdtlidxval_3 )
						Call snedobj.Set( "MemberIDX",  game.RPlayerIDX1 )
						strjson = JSON.stringify(snedobj)						  
					  %>	
					  <%
					  	If (i = 0 Or i = 1) AND n Mod 2 = 1 Then
								If n = 1 OR n = 2 Then
									If game.RTourneyGroupIDX = Cstr(Set1_RcvTourneyGroupIDX) AND game.RPlayerIDX1 = Cstr(Set1_RcvMember) Then
										right1val = "R"
									ElseIf game.RTourneyGroupIDX = Cstr(Set1_ServeTourneyGroupIDX) AND game.RPlayerIDX1 = Cstr(Set1_ServeMemberIDX) Then
										right1val = "S"
									End If
								ElseIf n = 3 OR n = 4 Then
									If game.RTourneyGroupIDX = Cstr(Set2_RcvTourneyGroupIDX) AND game.RPlayerIDX1 = Cstr(Set2_RcvMember) Then
										right1val = "R"
									ElseIf game.RTourneyGroupIDX = Cstr(Set2_ServeTourneyGroupIDX) AND game.RPlayerIDX1 = Cstr(Set2_ServeMemberIDX) Then
										right1val = "S"
									End If						
								ElseIf n = 5 OR n = 6 Then
									If game.RTourneyGroupIDX = Cstr(Set3_RcvTourneyGroupIDX) AND game.RPlayerIDX1 = Cstr(Set3_RcvMember) Then
										right1val = "R"
									ElseIf game.RTourneyGroupIDX = Cstr(Set3_ServeTourneyGroupIDX) AND game.RPlayerIDX1 = Cstr(Set3_ServeMemberIDX) Then
										right1val = "S"
									End If						
								End If

								If i = 0 AND (right1val = "S" OR right1val = "R") Then
									
									If GameType = "Solo" And right1val = "R" Then
										right1val = "" 
									End if																				
									
								ElseIf i = 1 AND (right1val = "S" OR right1val = "R") Then
									right1val = "0"
								Else
									right1val = ""
								End If
																
							End If
							
							If i = 0 Then
								str_border = "border-right:2px solid #000;"
							Else
								str_border = "border-right:1px solid #000;"
							End If		

							IF DEC_IsPrint = "0" Then
								right1val = ""
							END IF

					  %>						  	

						<td class="column style" style="background-color: #ddd;font-size: 12pt;text-align: center;width: 37px;height: 29px;border-top:0px solid #000; <%=str_border%> border-bottom:1px solid #000;"><%=right1val%></td>

					 
					  <%
					  right1val = ""
					  rstdtlidxval_3 = ""
					  next%>
            <td class="column42">&nbsp;</td>
            <td class="column43">&nbsp;</td>
					</tr>




					<!-- E : 10행 -->
          <tr class="row16">
					  <td class="column0">&nbsp;</td>
            <td class="column1 style62 null style64" colspan="5" style="background-color: #ddd;text-align: left;height: 29px;font-size: 12pt;font-weight: bold; border-left:2px solid #000; border-right:2px solid #000; border-bottom:2px solid #000;">&nbsp;<%=game.RPlayer2%></td>
					 <%
					 right2 = Split(marr(3), ",")
					 rstdtlidx_4 = Split(marr(4), ",")

					  For i = 0 To 35
					  If n Mod 2 = 1 Then '홀수줄이라면
						  If i <= ubound(right2)  then
							  If right2(i) = "" Then
								right2val = ""	
							  Else
								right2val = right2(i)
							  End If

							  rstdtlidxval_4 = rstdtlidx_4(i)
						  End if
					  Else
						  If i + 36 <= ubound(right2)  then
							  If right2(i+36) = "" Then
								right2val = ""	
							  Else
								right2val = right2(i+36)
							  End If

							  rstdtlidxval_4 = rstdtlidx_4(i+36)
						  End if	
					  End if
						Call snedobj.Set( "TourneyGroupIDX",  game.RTourneyGroupIDX )
						Call snedobj.Set( "GameResultDtlIDX",  rstdtlidxval_4 )
						Call snedobj.Set( "MemberIDX",  game.RPlayerIDX2 )
						strjson = JSON.stringify(snedobj)							  
					  %>		
					  <%
					  	If (i = 0 Or i = 1) AND n Mod 2 = 1 Then
								If n = 1 OR n = 2 Then
									If game.RTourneyGroupIDX = Cstr(Set1_RcvTourneyGroupIDX) AND game.RPlayerIDX2 = Cstr(Set1_RcvMember) Then
										right2val = "R"
									ElseIf game.RTourneyGroupIDX = Cstr(Set1_ServeTourneyGroupIDX) AND game.RPlayerIDX2 = Cstr(Set1_ServeMemberIDX) Then
										right2val = "S"
									End If
								ElseIf n = 3 OR n = 4 Then
									If game.RTourneyGroupIDX = Cstr(Set2_RcvTourneyGroupIDX) AND game.RPlayerIDX2 = Cstr(Set2_RcvMember) Then
										right2val = "R"
									ElseIf game.RTourneyGroupIDX = Cstr(Set2_ServeTourneyGroupIDX) AND game.RPlayerIDX2 = Cstr(Set2_ServeMemberIDX) Then
										right2val = "S"
									End If						
								ElseIf n = 5 OR n = 6 Then
									If game.RTourneyGroupIDX = Cstr(Set3_RcvTourneyGroupIDX) AND game.RPlayerIDX2 = Cstr(Set3_RcvMember) Then
										right2val = "R"
									ElseIf game.RTourneyGroupIDX = Cstr(Set3_ServeTourneyGroupIDX) AND game.RPlayerIDX2 = Cstr(Set3_ServeMemberIDX) Then
										right2val = "S"
									End If						
								End If


								If i = 0 AND (right2val = "S" OR right2val = "R") Then

									If GameType = "Solo" And right2val = "R" Then
										right2val = "" 
									End if					

								ElseIf i = 1 AND (right2val = "S" OR right2val = "R") Then
									right2val = "0"
								Else
									right2val = ""
								End If
																					
							End If

							If i = 0 Then
								str_border = "border-right:2px solid #000;"
							Else
								str_border = "border-right:1px solid #000;"
							End If		

							IF DEC_IsPrint = "0" Then
								right2val = ""
							END IF
					  %>	

              <td class="column style" style="background-color: #ddd;font-size: 12pt;text-align: center;width: 37px;height: 29px;border-top:0px solid #000; <%=str_border%> border-bottom:2px solid #000;"><%=right2val%></td>

					  <%
					  right2val = ""
					  rstdtlidxval_4 = ""					  
					  next%>
            <td class="column42">&nbsp;</td>
            <td class="column43">&nbsp;</td>
					</tr>
					<tr>
            <td colspan="41" class="td_blank">
            </td>
          </tr>
			<%next%>




    
      <tr class="row39">
        <td class="column0">&nbsp;</td>
        <td class="column1 style6 null"></td>
        <td class="column2 style6 null"></td>
        <td class="column3 style6 null"></td>
        <td class="column4 style6 null"></td>
        <td class="column5 style6 null"></td>
        <td class="column6 style6 null"></td>
        <td class="column7 style6 null"></td>
        <td class="column8 style6 null"></td>
        <td class="column9 style6 null"></td>
        <td class="column10 style6 null"></td>
        <td class="column11 style6 null"></td>
        <td class="column12 style6 null"></td>
        <td class="column13 style6 null"></td>
        <td class="column14 style6 null"></td>
        <td class="column15 style6 null"></td>
        <td class="column16 style6 null"></td>
        <td class="column17 style6 null"></td>
        <td class="column18 style6 null"></td>
        <td class="column19 style6 null"></td>
        <td class="column20 style65 s style65" colspan="11" style="font-size: 14pt;font-family: '맑은 고딕';font-weight: bold;">Umpire :</td>
        <td class="column31 style65 s style65" colspan="11" style="font-size: 14pt;font-family: '맑은 고딕';font-weight: bold;">Referee:</td>
        <td class="column42">&nbsp;</td>
        <td class="column43">&nbsp;</td>
      </tr>
			<tr>
        <td></td>
        <td colspan="41" style="border-top: 1px solid #000;"></td>
        <td></td>
      </tr>
      <tr>
        <td></td>
        <td colspan="41" height="100"  align="center"><B><font size="11">BADMINTON KOREA ASSOCIATION</font></B></td>
        <td></td>
      </tr>      
    </tbody>
  </table>


  

<%

	'Response.Buffer = True
	'Response.ContentType = "application/vnd.ms-excel"
	'Response.CacheControl = "public"
	'Response.AddHeader "Content-disposition","attachment;filename=score.xls"
%>