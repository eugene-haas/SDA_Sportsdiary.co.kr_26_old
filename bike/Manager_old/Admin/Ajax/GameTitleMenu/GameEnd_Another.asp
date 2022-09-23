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
'단체전 경기결과 입력

REQ = Request("Req")

'REQ = "{""CMD"":21,""GameLevelDtlIDX"":""D699A4D046D9389A5B28ACBEC4075BBD"",""TeamGameNum"":""F8D449933BF718DD0EB197EE474475BB"",""GameNum"":""D3510D3EEF159089CEE3710534553C12"",""AnthTourneyGroupIDX1"":""AC45210D0BA2C0D1F5EB82EBD179A648"",""AnthTourneyGroupIDX2"":"""",""AnthResult"":""233504FABCD7A56DB391510A1249F8A4"",""AnthResultDtl"":""E211C5007C3241839974DE53D61E1932""}"
Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "GameLevelDtlIDX") = "ok" then
    If ISNull(oJSONoutput.GameLevelDtlIDX) Or oJSONoutput.GameLevelDtlIDX = "" Then
      GameLevelDtlIDX = ""
      DEC_GameLevelDtlIDX = ""
    Else
      GameLevelDtlIDX = fInject(oJSONoutput.GameLevelDtlIDX)
      DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameLevelDtlIDX))
    End If
  Else  
    GameLevelDtlIDX = ""
    DEC_GameLevelDtlIDX = ""
End if	

If hasown(oJSONoutput, "GameRound") = "ok" then
    If ISNull(oJSONoutput.GameRound) Or oJSONoutput.GameRound = "" Then
      GameRound = ""
      DEC_GameRound = ""
    Else
      GameRound = fInject(oJSONoutput.GameRound)
      DEC_GameRound = fInject(crypt.DecryptStringENC(oJSONoutput.GameRound))    
    End If
  Else  
    GameRound = ""
    DEC_GameRound = ""
End if	

If hasown(oJSONoutput, "TeamGameNum") = "ok" then
    If ISNull(oJSONoutput.TeamGameNum) Or oJSONoutput.TeamGameNum = "" Then
      TeamGameNum = ""
      DEC_TeamGameNum = ""
    Else
      TeamGameNum = fInject(oJSONoutput.TeamGameNum)
      DEC_TeamGameNum = fInject(crypt.DecryptStringENC(oJSONoutput.TeamGameNum))    
    End If
  Else  
    TeamGameNum = ""
    DEC_TeamGameNum = ""
End if	

If hasown(oJSONoutput, "GameNum") = "ok" then
    If ISNull(oJSONoutput.GameNum) Or oJSONoutput.GameNum = "" Then
      GameNum = ""
      DEC_GameNum = ""
    Else
      GameNum = fInject(oJSONoutput.GameNum)
      DEC_GameNum = fInject(crypt.DecryptStringENC(oJSONoutput.GameNum))    
    End If
  Else  
    GameNum = ""
    DEC_GameNum = ""
End if	

If hasown(oJSONoutput, "AnthTourneyGroupIDX1") = "ok" then
    If ISNull(oJSONoutput.AnthTourneyGroupIDX1) Or oJSONoutput.AnthTourneyGroupIDX1 = "" Then
      AnthTourneyGroupIDX1 = ""
      DEC_AnthTourneyGroupIDX1 = ""
    Else
      AnthTourneyGroupIDX1 = fInject(oJSONoutput.AnthTourneyGroupIDX1)
      DEC_AnthTourneyGroupIDX1 = fInject(crypt.DecryptStringENC(oJSONoutput.AnthTourneyGroupIDX1))    
    End If
  Else  
    AnthTourneyGroupIDX1 = ""
    DEC_AnthTourneyGroupIDX1 = ""
End if	

If hasown(oJSONoutput, "AnthTourneyGroupIDX2") = "ok" then
    If ISNull(oJSONoutput.AnthTourneyGroupIDX2) Or oJSONoutput.AnthTourneyGroupIDX2 = "" Then
      AnthTourneyGroupIDX2 = ""
      DEC_AnthTourneyGroupIDX2 = ""
    Else
      AnthTourneyGroupIDX2 = fInject(oJSONoutput.AnthTourneyGroupIDX2)
      DEC_AnthTourneyGroupIDX2 = fInject(crypt.DecryptStringENC(oJSONoutput.AnthTourneyGroupIDX2))    
    End If
  Else  
    AnthTourneyGroupIDX2 = ""
    DEC_AnthTourneyGroupIDX2 = ""
End if	

If hasown(oJSONoutput, "AnthResult") = "ok" then
    If ISNull(oJSONoutput.AnthResult) Or oJSONoutput.AnthResult = "" Then
      AnthResult = ""
      DEC_AnthResult = ""
    Else
      AnthResult = fInject(oJSONoutput.AnthResult)
      DEC_AnthResult = fInject(crypt.DecryptStringENC(oJSONoutput.AnthResult))    
    End If
  Else  
    AnthResult = ""
    DEC_AnthResult = ""
End if	

If hasown(oJSONoutput, "AnthResultDtl") = "ok" then
    If ISNull(oJSONoutput.AnthResultDtl) Or oJSONoutput.AnthResultDtl = "" Then
      AnthResultDtl = ""
      DEC_AnthResultDtl = ""
    Else
      AnthResultDtl = fInject(oJSONoutput.AnthResultDtl)
      DEC_AnthResultDtl = fInject(crypt.DecryptStringENC(oJSONoutput.AnthResultDtl))    
    End If
  Else  
    AnthResultDtl = ""
    DEC_AnthResultDtl = ""
End if	



LSQL = " SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
LSQL = LSQL & " AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
LSQL = LSQL & " AA.LResult, AA.LResultType, AA.LResultNM, AA.LJumsu,"
LSQL = LSQL & " AA.RResult, AA.RResultType, AA.RResultNM, AA.RJumsu,"
LSQL = LSQL & " AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName, AA.LevelJooName, AA.SignData, AA.GameLevelIDX, AA.JooRank,"
LSQL = LSQL & " AA.TourneyGroupIDX AS Win_TourneyGroupIDX, AA.LGroupJumsu, AA.RGroupJumsu, AA.LDtlJumsu, AA.RDtlJumsu,"
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
LSQL = LSQL & "     SELECT A.GameTitleIDX, A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
LSQL = LSQL & "     KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
LSQL = LSQL & "     KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
LSQL = LSQL & "     E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu,"
LSQL = LSQL & "     F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu,"
LSQL = LSQL & "     E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
LSQL = LSQL & "     KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS SexNM, D.Sex,"
LSQL = LSQL & "     A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName, G.SignData, D.GameLevelIDX, ISNULL(D.JooRank,0) AS JooRank,"
LSQL = LSQL & " 		KoreaBadminton.dbo.FN_WinGroupIDX(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS TourneyGroupIDX,"
LSQL = LSQL & " 		KoreaBadminton.dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, A.TourneyGroupIDX) AS LGroupJumsu, "
LSQL = LSQL & " 		KoreaBadminton.dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, B.TourneyGroupIDX) AS RGroupJumsu, "
LSQL = LSQL & " 		KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, A.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS LDtlJumsu, "
LSQL = LSQL & " 		KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, B.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS RDtlJumsu "
LSQL = LSQL & " "
LSQL = LSQL & "     ,STUFF(("
LSQL = LSQL & "     		SELECT  DISTINCT (  "
LSQL = LSQL & "     			SELECT  '|'   + UserName "
LSQL = LSQL & "     			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "     			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " "
LSQL = LSQL & " 				AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 				AND DelYN = 'N'"
LSQL = LSQL & " "
LSQL = LSQL & "     			FOR XML PATH('')  "
LSQL = LSQL & "     			)  "
LSQL = LSQL & "     		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & "     		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "     		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " "
LSQL = LSQL & " 			AND DelYN = 'N'"
LSQL = LSQL & " "
LSQL = LSQL & "     		),1,1,'') AS LPlayers"
LSQL = LSQL & "     ,STUFF(("
LSQL = LSQL & "     		SELECT  DISTINCT (  "
LSQL = LSQL & "     			SELECT  '|'   + UserName "
LSQL = LSQL & "     			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "     			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " "
LSQL = LSQL & " 				AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 				AND DelYN = 'N'"
LSQL = LSQL & " "
LSQL = LSQL & "     			FOR XML PATH('')  "
LSQL = LSQL & "     			)  "
LSQL = LSQL & "     		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & "     		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "     		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & " "
LSQL = LSQL & " 			AND DelYN = 'N'"
LSQL = LSQL & " "
LSQL = LSQL & "     		),1,1,'') AS RPlayers"
LSQL = LSQL & " "
LSQL = LSQL & "     ,STUFF((		"
LSQL = LSQL & "     		SELECT  DISTINCT (  "
LSQL = LSQL & "     			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "     			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "     			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " "
LSQL = LSQL & " 				AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 				AND DelYN = 'N'"
LSQL = LSQL & " "
LSQL = LSQL & "     			FOR XML PATH('')  "
LSQL = LSQL & "     			)  "
LSQL = LSQL & "     		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & "     		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "     		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " "
LSQL = LSQL & " 			AND DelYN = 'N'"
LSQL = LSQL & " "
LSQL = LSQL & "     		),1,1,'') AS LTeams"
LSQL = LSQL & "     ,STUFF((		"
LSQL = LSQL & "     		SELECT  DISTINCT (  "
LSQL = LSQL & "     			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "     			FROM    KoreaBadminton.dbo.tblTourneyPlayer " 
LSQL = LSQL & "     			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " "
LSQL = LSQL & " 				AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 				AND DelYN = 'N'"
LSQL = LSQL & " "
LSQL = LSQL & "     			FOR XML PATH('')  "
LSQL = LSQL & "     			)  "
LSQL = LSQL & "     		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & "     		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "     		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & " "
LSQL = LSQL & " 			AND DelYN = 'N'"
LSQL = LSQL & " "
LSQL = LSQL & "     		),1,1,'') AS RTeams"
LSQL = LSQL & " "
LSQL = LSQL & "     FROM tblTourney A"
LSQL = LSQL & "     INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
LSQL = LSQL & "     INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "     INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
LSQL = LSQL & "     	LEFT JOIN ("
LSQL = LSQL & "     		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
LSQL = LSQL & "     		FROM KoreaBadminton.dbo.tblGameResult"
LSQL = LSQL & "     		WHERE DelYN = 'N'"
LSQL = LSQL & "     		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
LSQL = LSQL & "     		) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
LSQL = LSQL & "     	LEFT JOIN ("
LSQL = LSQL & "     		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
LSQL = LSQL & "     		FROM KoreaBadminton.dbo.tblGameResult"
LSQL = LSQL & "     		WHERE DelYN = 'N'"
LSQL = LSQL & "     		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
LSQL = LSQL & "     		) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = B.TeamGameNum AND F.GameNum = B.GameNum AND F.TourneyGroupIDX = B.TourneyGroupIDX    			"
LSQL = LSQL & "     	LEFT JOIN ("
LSQL = LSQL & "     		SELECT GameLevelDtlidx, TeamGameNum, GameNum, SignData"
LSQL = LSQL & "     		FROM KoreaBadminton.dbo.tblGameSign"
LSQL = LSQL & "     		WHERE DelYN = 'N' "
LSQL = LSQL & "     		) AS G ON G.GameLevelDtlidx = A.GameLevelDtlidx AND G.TeamGameNum = A.TeamGameNum AND G.GameNum = A.GameNum  			          "
LSQL = LSQL & "     WHERE A.DelYN = 'N'"
LSQL = LSQL & "     AND B.DelYN = 'N'"
LSQL = LSQL & "     AND C.DelYN = 'N'"
LSQL = LSQL & "     AND D.DelYN = 'N'"
LSQL = LSQL & "     AND A.ORDERBY < B.ORDERBY"
LSQL = LSQL & " 	AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & "     AND A.TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & "     AND A.GameNum = '" & DEC_GameNum & "'"
LSQL = LSQL & " ) AS AA"
LSQL = LSQL & " WHERE GameLevelDtlIDX IS NOT NULL"


Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Do Until LRs.Eof

	  	GameTitleIDX = LRs("GameTitleIDX")
      TeamGb = LRs("TeamGb")
      Sex = LRs("Sex")
      Level = LRs("Level")
      LevelDtlName = LRs("LevelDtlName")
      GroupGameGb = LRs("GroupGameGb")
      GameLevelIDX = LRs("GameLevelIDX")
      PlayLevelType = LRs("PlayLevelType")
      JooRank = LRs("JooRank")
      LevelJooNum = LRs("LevelJooNum")
      GameRound = LRs("Round")

      LTourneyGroupIDX = LRs("LTourneyGroupIDX")
      RTourneyGroupIDX = LRs("RTourneyGroupIDX")      

      LRs.MoveNext
    Loop

End If

LRs.Close


Call oJSONoutput.Set("GroupGameGb", GroupGameGb )


'경기결과 카운트 불러오기
LSQL = "SELECT COUNT(*) AS ResultCnt"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameResult"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND GameNum = '" & DEC_GameNum & "'"



Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    RsCnt = LRs("ResultCnt")

End If

LRs.Close

 
'경기결과가 있으면 UPDATE
If Cint(RsCnt) > 0 Then

CSQL = " UPDATE KoreaBadminton.dbo.tblGameResult SET"
CSQL = CSQL & " DelYN = 'Y'"
CSQL = CSQL & " WHERE DelYN = 'N'"
CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"

Dbcon.Execute(CSQL)


End If


CSQL = "UPDATE KoreaBadminton.dbo.tblTourney SET"
CSQL = CSQL & " EndHour = '" & AddZero(Hour(Now)) & "',"
CSQL = CSQL & " EndMinute = '" & AddZero(Minute(Now)) & "'"
CSQL = CSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"
CSQL = CSQL & " AND ISNULL(EndHour,'') = ''"

Dbcon.Execute(CSQL)


WinCode_Left2 = "B8"


'좌팀 승
If AnthTourneyGroupIDX1 = "" Then

    CSQL = "INSERT KoreaBadminton.dbo.tblGameResult"
    CSQL = CSQL & " ("
    CSQL = CSQL & " GameLevelDtlidx, GameTitleIDX, TeamGb, Sex, GroupGameGb, "
    CSQL = CSQL & " Level, LevelDtlName, Round, TeamGameNum, GameNum, "
    CSQL = CSQL & " TourneyGroupIDX, Result, Jumsu, Team, TeamDtl, "
    CSQL = CSQL & " StadiumNumber"
    CSQL = CSQL & " )"
    CSQL = CSQL & " VALUES"
    CSQL = CSQL & " ("
    CSQL = CSQL & " '" & DEC_GameLevelDtlIDX & "', '" & GameTitleIDX & "', '" & TeamGb & "', '" & Sex & "', '" & GroupGameGb & "',"
    CSQL = CSQL & " '" & Level & "', '" & LevelDtlName & "', '" & GameRound & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "',"
    CSQL = CSQL & " '" & LTourneyGroupIDX & "', KoreaBadminton.dbo.FN_ResultReturn('WIN', '" & DEC_AnthResult & "'), '0', '', '',"
    CSQL = CSQL & " ''"
    CSQL = CSQL & " )"

    Dbcon.Execute(CSQL)

    WIN_TourneyGroupIDX = TourneyIDX1

'좌팀 패
Else

    CSQL = "INSERT KoreaBadminton.dbo.tblGameResult"
    CSQL = CSQL & " ("
    CSQL = CSQL & " GameLevelDtlidx, GameTitleIDX, TeamGb, Sex, GroupGameGb, "
    CSQL = CSQL & " Level, LevelDtlName, Round, TeamGameNum, GameNum, "
    CSQL = CSQL & " TourneyGroupIDX, Result, ResultDtl, Jumsu, Team, TeamDtl, "
    CSQL = CSQL & " StadiumNumber"
    CSQL = CSQL & " )"
    CSQL = CSQL & " VALUES"
    CSQL = CSQL & " ("
    CSQL = CSQL & " '" & DEC_GameLevelDtlIDX & "', '" & GameTitleIDX & "', '" & TeamGb & "', '" & Sex & "', '" & GroupGameGb & "',"
    CSQL = CSQL & " '" & Level & "', '" & LevelDtlName & "', '" & GameRound & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "',"
    CSQL = CSQL & " '" & LTourneyGroupIDX & "', KoreaBadminton.dbo.FN_ResultReturn('LOSE', '" & DEC_AnthResult & "'), '" & DEC_AnthResultDtl & "', '0', '', '',"
    CSQL = CSQL & " ''"
    CSQL = CSQL & " )"

    Dbcon.Execute(CSQL)

End If



'우팀 승
If AnthTourneyGroupIDX2 = "" Then

    CSQL = "INSERT KoreaBadminton.dbo.tblGameResult"
    CSQL = CSQL & " ("
    CSQL = CSQL & " GameLevelDtlidx, GameTitleIDX, TeamGb, Sex, GroupGameGb, "
    CSQL = CSQL & " Level, LevelDtlName, Round, TeamGameNum, GameNum, "
    CSQL = CSQL & " TourneyGroupIDX, Result, Jumsu, Team, TeamDtl, "
    CSQL = CSQL & " StadiumNumber"
    CSQL = CSQL & " )"
    CSQL = CSQL & " VALUES"
    CSQL = CSQL & " ("
    CSQL = CSQL & " '" & DEC_GameLevelDtlIDX & "', '" & GameTitleIDX & "', '" & TeamGb & "', '" & Sex & "', '" & GroupGameGb & "',"
    CSQL = CSQL & " '" & Level & "', '" & LevelDtlName & "', '" & GameRound & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "',"
    CSQL = CSQL & " '" & RTourneyGroupIDX & "', KoreaBadminton.dbo.FN_ResultReturn('WIN', '" & DEC_AnthResult & "'), '0', '', '',"
    CSQL = CSQL & " ''"
    CSQL = CSQL & " )"

    Dbcon.Execute(CSQL)

    WIN_TourneyGroupIDX = TourneyIDX2

'우팀 패
Else

    CSQL = "INSERT KoreaBadminton.dbo.tblGameResult"
    CSQL = CSQL & " ("
    CSQL = CSQL & " GameLevelDtlidx, GameTitleIDX, TeamGb, Sex, GroupGameGb, "
    CSQL = CSQL & " Level, LevelDtlName, Round, TeamGameNum, GameNum, "
    CSQL = CSQL & " TourneyGroupIDX, Result, ResultDtl, Jumsu, Team, TeamDtl, "
    CSQL = CSQL & " StadiumNumber"
    CSQL = CSQL & " )"
    CSQL = CSQL & " VALUES"
    CSQL = CSQL & " ("
    CSQL = CSQL & " '" & DEC_GameLevelDtlIDX & "', '" & GameTitleIDX & "', '" & TeamGb & "', '" & Sex & "', '" & GroupGameGb & "',"
    CSQL = CSQL & " '" & Level & "', '" & LevelDtlName & "', '" & GameRound & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "',"
    CSQL = CSQL & " '" & RTourneyGroupIDX & "', KoreaBadminton.dbo.FN_ResultReturn('LOSE', '" & DEC_AnthResult & "'), '" & DEC_AnthResultDtl & "', '0', '', '',"
    CSQL = CSQL & " ''"
    CSQL = CSQL & " )"

    Dbcon.Execute(CSQL)

End If



Area_TourneyGroupIDX = TourneyIDX1

'현재경기의 대진표 위치값 구하기 GrNum : 현재대진표 위치값
'4의배수숫자마다 1씩 증가하여 그룹화
LSQL = "SELECT ASCNum"
LSQL = LSQL & " FROM"
LSQL = LSQL & " 	 ("
LSQL = LSQL & " 	 SELECT ROW_NUMBER() OVER ( ORDER BY ORDERBY ASC) ASCNum, tourneynum, TeamGameNum, GameNum, TourneyGroupIDX"
LSQL = LSQL & " 	 FROM KoreaBadminton.dbo.tblTourney"
LSQL = LSQL & " 	 WHERE DelYN = 'N'"
LSQL = LSQL & " 	 AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " 	 AND [ROUND] = '" & GameRound & "'"
LSQL = LSQL & " 	 ) AS A"
LSQL = LSQL & " WHERE TourneyGroupIDX = '" & Area_TourneyGroupIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND GameNum = '" & DEC_GameNum & "'"

Set LRs = Dbcon.Execute(LSQL)

i = 0

If Not (LRs.Eof Or LRs.Bof) Then

    GrNum = LRs("ASCNum")

End If

LRs.Close


If CDbl(GrNum) Mod 2 = 1 Then
	GrNum = CDbl(GrNum) +1
End If

NextGrNum = Fix(CDbl(GrNum) /2) 

LSQL = "SELECT TourneyIDX"
LSQL = LSQL & " FROM"
LSQL = LSQL & " 	 ("
LSQL = LSQL & " 	 SELECT ROW_NUMBER() OVER ( ORDER BY ORDERBY ASC) ASCNum, TourneyIDX"
LSQL = LSQL & " 	 FROM KoreaBadminton.dbo.tblTourney"
LSQL = LSQL & " 	 WHERE DelYN = 'N'"
LSQL = LSQL & " 	 AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " 	 AND [ROUND] = '" & Cint(GameRound + 1)  & "'"
LSQL = LSQL & " 	 ) AS A"
LSQL = LSQL & " WHERE ASCNum = '" & NextGrNum & "'"

Set LRs = Dbcon.Execute(LSQL)

i = 0

If Not (LRs.Eof Or LRs.Bof) Then

    Next_TourneyIDX = LRs("TourneyIDX")

End If

LRs.Close


If WIN_TourneyGroupIDX = "" Then
    WIN_TourneyGroupIDX = "0"
ENd If

CSQL = "UPDATE tblTourney SET "
CSQL = CSQL & " TourneyGroupIDX = '" & WIN_TourneyGroupIDX & "', "
CSQL = CSQL & " TourneyNum = '" & WIN_TourneyNum & "'"
CSQL = CSQL & " WHERE TourneyIDX = '" & Next_TourneyIDX & "'"
Dbcon.Execute(CSQL)
  
 '경기 수 구하기
 LSQL = "SELECT MAX(CONVERT(BIGINT,GameNum)) AS MaxGameNum"
 LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney"
 LSQL = LSQL & " WHERE DelYN = 'N'"
 LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
 Set LRs = Dbcon.Execute(LSQL)
 If Not (LRs.Eof Or LRs.Bof) Then
     MaxGameNum = LRs("MaxGameNum")
 End If
 LRs.Close

 '끝난경기수 구하기
 LSQL = "SELECT COUNT(*) AS EndGameCnt"
 LSQL = LSQL & " FROM "
 LSQL = LSQL & " ("
 LSQL = LSQL & " SELECT GameLevelDtlidx, TeamGameNum, GameNum"
 LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameResult "
 LSQL = LSQL & " WHERE DelYN = 'N'"
 LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
 LSQL = LSQL & " GROUP BY GameLevelDtlidx, TeamGameNum, GameNum"
 LSQL = LSQL & " ) AS A"
 Set LRs = Dbcon.Execute(LSQL)
 If Not (LRs.Eof Or LRs.Bof) Then
     EndGameCnt = LRs("EndGameCnt")
 End If
 LRs.Close

If Cint(EndGameCnt) => Cint(MaxGameNum) Then
    '실적넣기
    LSQL = "dbo.Insert_tblMedal '" & DEC_GameLevelDtlIDX & "'"
    Dbcon.Execute(LSQL)
End If

Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()  


  
%>