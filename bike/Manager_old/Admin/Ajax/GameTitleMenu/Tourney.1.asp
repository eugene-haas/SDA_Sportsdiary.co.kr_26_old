<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
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
Dim GameLevelDtlidx 
Dim strRound
Dim GroupGameGb

Dim NextstrRound


Dim strjson_dtl

CMD = Request("CMD")
GameLevelDtlIDX = Request("GameLevelDtlIDX")
strRound = Request("strRound")


If strRound = "" OR IsNumeric(strRound) = false Then
    Response.Write ""
    Response.End
End If

NextstrRound = Cint(strRound) + 1


'대회정보
DEC_GameLevelDtlIDX = fInject(GameLevelDtlIDX)


'INSERT 시, 이용 할 대회 정보 SELECT
LSQL = "SELECT A.GameTitleIDX, A.TeamGb, A.Sex, B.Level, B.LevelDtlName, A.GroupGameGb"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameLevel A"
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelidx = B.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"



Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
    GroupGameGb = LRs("GroupGameGb")
End If

LRs.Close



'클릭한 라운드의 대진표 불러오기(왼쪽대진표)

LSQL = " SELECT AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
LSQL = LSQL & " AA.TempNum, AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
LSQL = LSQL & " AA.Result, AA.ResultType, AA.ResultNM, AA.Jumsu,"

LSQL = LSQL & " AA.GameStatus, AA.[ROUND], AA.TourneyGroupIDX AS Win_TourneyGroupIDX, AA.LGroupJumsu, AA.RGroupJumsu, AA.LDtlJumsu, AA.RDtlJumsu,"
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2"
LSQL = LSQL & " FROM"
LSQL = LSQL & " ("
LSQL = LSQL & " SELECT A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, ISNULL(A.TourneyGroupIDX,'') AS LTourneyGroupIDX, ISNULL(B.TourneyGroupIDX,'') AS RTourneyGroupIDX, "
LSQL = LSQL & " ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), ISNULL(A.TeamGameNum,'0'), CONVERT(Bigint,ISNULL(A.GameNum,'0')) ASC) AS TempNum,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
LSQL = LSQL & " E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, KoreaBadminton.dbo.FN_WinGroupIDX(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS TourneyGroupIDX,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, A.TourneyGroupIDX) AS LGroupJumsu, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, B.TourneyGroupIDX) AS RGroupJumsu, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, A.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS LDtlJumsu, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, B.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS RDtlJumsu "

LSQL = LSQL & " "
LSQL = LSQL & " ,STUFF(("
LSQL = LSQL & "		    SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + UserName "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "             WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & " 		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " 		),1,1,'') AS LPlayers"
LSQL = LSQL & " ,STUFF(("
LSQL = LSQL & "		    SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + UserName "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "             WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & " 		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & " 		),1,1,'') AS RPlayers"

LSQL = LSQL & " ,STUFF((		"
LSQL = LSQL & "         SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "             WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & " 		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " 		),1,1,'') AS LTeams"
LSQL = LSQL & " ,STUFF((		"
LSQL = LSQL & "         SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "             WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & " 		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & " 		),1,1,'') AS RTeams"
			

LSQL = LSQL & " FROM tblTourney A"
LSQL = LSQL & " INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
LSQL = LSQL & "     LEFT JOIN ("
LSQL = LSQL & " 	    SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
LSQL = LSQL & " 	    FROM KoreaBadminton.dbo.tblGameResult"
LSQL = LSQL & " 	    WHERE DelYN = 'N'"
LSQL = LSQL & "         GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
LSQL = LSQL & " 	    ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND C.DelYN = 'N'"
LSQL = LSQL & " AND D.DelYN = 'N'"
LSQL = LSQL & " AND A.ORDERBY < B.ORDERBY"
LSQL = LSQL & " AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND A.ROUND = '" & strRound & "'"
LSQL = LSQL & " ) AS AA"
LSQL = LSQL & " WHERE GameLevelDtlIDX IS NOT NULL"



Set LRs = Dbcon.Execute(LSQL)


If Not (LRs.Eof Or LRs.Bof) Then

    Set oJSONoutput = jsArray()

    Do Until LRs.Eof

        Set oJSONoutput(NULL) = jsObject()


'LSQL = " SELECT AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
'LSQL = LSQL & " AA.TempNum, AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
'LSQL = LSQL & " AA.Result, AA.ResultType, AA.ResultNM, AA.Jumsu,"

'LSQL = LSQL & " AA.GameStatus, AA.[ROUND], AA.TourneyGroupIDX AS Win_TourneyGroupIDX, AA.LGroupJumsu, AA.RGroupJumsu,"
'LSQL = LSQL & " CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
'LSQL = LSQL & " CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
'LSQL = LSQL & " CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
'LSQL = LSQL & " CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
'LSQL = LSQL & " CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
'LSQL = LSQL & " CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
'LSQL = LSQL & " CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
'LSQL = LSQL & " CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2"


        oJSONoutput(NULL)("GameLevelDtlIDX") = LRs("GameLevelDtlIDX")
        oJSONoutput(NULL)("TeamGameNum") = LRs("TeamGameNum")
        oJSONoutput(NULL)("GameNum") = LRs("GameNum")
        oJSONoutput(NULL)("LTourneyGroupIDX") = LRs("LTourneyGroupIDX")
        oJSONoutput(NULL)("RTourneyGroupIDX") = LRs("RTourneyGroupIDX")
        oJSONoutput(NULL)("LPlayer1") = LRs("LPlayer1")
        oJSONoutput(NULL)("LPlayer2") = LRs("LPlayer2")
        oJSONoutput(NULL)("RPlayer1") = LRs("RPlayer1")
        oJSONoutput(NULL)("RPlayer2") = LRs("RPlayer2")
        oJSONoutput(NULL)("LTeam1") = LRs("LTeam1")
        oJSONoutput(NULL)("LTeam2") = LRs("LTeam2")
        oJSONoutput(NULL)("RTeam1") = LRs("RTeam1")
        oJSONoutput(NULL)("RTeam2") = LRs("RTeam2")
        oJSONoutput(NULL)("STRRound") = LRs("Round")
        oJSONoutput(NULL)("Result") = LRs("Result")
        oJSONoutput(NULL)("ResultType") = LRs("ResultType")
        oJSONoutput(NULL)("Win_TourneyGroupIDX") = LRs("Win_TourneyGroupIDX")
        oJSONoutput(NULL)("GroupGameGb") = GroupGameGb
        oJSONoutput(NULL)("LDtlJumsu") = LRs("LDtlJumsu")
        oJSONoutput(NULL)("RDtlJumsu") = LRs("RDtlJumsu")
        
        
        

        LRs.MoveNext
    Loop

    strjson_dtl = toJSON(oJSONoutput)

Else
End If




Set oJSONoutput_SUM = jsArray()
Set oJSONoutput_SUM = jsObject()


oJSONoutput_SUM("CMD") = CMD
oJSONoutput_SUM("TYPE") = "JSON"
oJSONoutput_SUM("RESULT") = strjson_dtl

strjson_sum = toJSON(oJSONoutput_SUM)

Response.Write strjson_sum


Set LRs = Nothing
DBClose()
  
%>