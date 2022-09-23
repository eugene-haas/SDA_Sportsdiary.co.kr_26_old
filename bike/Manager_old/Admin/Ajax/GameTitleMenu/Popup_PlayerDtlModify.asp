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
	Dim LSQL
	Dim LRs
	Dim strjson
	Dim strjson_sum

	Dim oJSONoutput_SUM
	Dim oJSONoutput

	Dim CMD  
	Dim GameTitleIDX 	

  REQ = Request("Req")
  'REQ = "{""CMD"":20,""tGameLevelDtlIDX"":""D699A4D046D9389A5B28ACBEC4075BBD"",""tTeamGameNum"":""F8D449933BF718DD0EB197EE474475BB"",""tGameNum"":""D3510D3EEF159089CEE3710534553C12"",""tSetNum"":""D3510D3EEF159089CEE3710534553C12"",""tTourneyGroupIDX"":""AC45210D0BA2C0D1F5EB82EBD179A648""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameLevelDtlIDX") = "ok" then
    GameLevelDtlIDX = fInject(oJSONoutput.tGameLevelDtlIDX)
    DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIDX))
  Else  
    GameLevelDtlIDX = ""
    DEC_GameLevelDtlIDX = ""
  End if	

	If hasown(oJSONoutput, "tTeamGameNum") = "ok" then
    If ISNull(oJSONoutput.tTeamGameNum) Or oJSONoutput.tTeamGameNum = "" Then
      TeamGameNum = ""
      DEC_TeamGameNum = ""
    Else
      TeamGameNum = fInject(oJSONoutput.tTeamGameNum)
      DEC_TeamGameNum = fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGameNum))    
    End If
  Else  
    TeamGameNum = ""
    DEC_TeamGameNum = ""
	End if	

	If hasown(oJSONoutput, "tGameNum") = "ok" then
    If ISNull(oJSONoutput.tGameNum) Or oJSONoutput.tGameNum = "" Then
      GameNum = ""
      DEC_GameNum = ""
    Else
      GameNum = fInject(oJSONoutput.tGameNum)
      DEC_GameNum = fInject(crypt.DecryptStringENC(oJSONoutput.tGameNum))    
    End If
  Else  
    GameNum = ""
    DEC_GameNum = ""
	End if	

  If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    If ISNull(oJSONoutput.tGroupGameGb) Or oJSONoutput.tGroupGameGb = "" Then
      GroupGameGb = ""
      DEC_GroupGameGb = ""
    Else
      GroupGameGb = fInject(oJSONoutput.tGroupGameGb)
      DEC_GroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))    
    End If
  Else  
    GroupGameGb = ""
    DEC_GroupGameGb = ""
	End if	    

  Function Ceil(ByVal intParam)  
    Ceil = -(Int(-(intParam)))  
  End Function  


  LSQL = " SELECT CCC.GameTitleIDX, CCC.GameLevelDtlIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
  LSQL = LSQL & " 	CCC.TeamGbNM, CCC.LevelNM, CCC.GameTypeNM,"
  LSQL = LSQL & " 	CCC.LResult, CCC.LResultType, CCC.LResultNM, CCC.LJumsu,"
  LSQL = LSQL & " 	CCC.RResult, CCC.RResultType, CCC.RResultNM, CCC.RJumsu,"
  LSQL = LSQL & " 	CCC.GameStatus, CCC.[ROUND] AS GameRound, CCC.Sex,"
  LSQL = LSQL & " 	CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
  LSQL = LSQL & " 	CCC.LPlayer1, CCC.LPlayer2, CCC.Rplayer1, CCC.Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
  LSQL = LSQL & " 	CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType, LevelJooName,"
  LSQL = LSQL & " 	CCC.Win_TourneyGroupIDX, CCC.LGroupJumsu, CCC.RGroupJumsu, CCC.LDtlJumsu, CCC.RDtlJumsu, CCC.MaxPoint, CCC.SignData,"			

  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(CCC.Sex, 'PubCode') AS SexName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(CCC.PlayType, 'PubCode') AS PlayTypeName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(CCC.TeamGb, 'TeamGb') AS TeamGbName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(CCC.Level, 'Level') AS LevelName,"
  LSQL = LSQL & " CCC.LevelJooNum AS LevelJooNumDtl"

  LSQL = LSQL & " FROM "
  LSQL = LSQL & " ("
  LSQL = LSQL & " 	SELECT "
  LSQL = LSQL & " 	BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
  LSQL = LSQL & " 	BBB.TeamGbNM, BBB.LevelNM, BBB.GameTypeNM,"
  LSQL = LSQL & " 	BBB.LResult, BBB.LResultType, BBB.LResultNM, BBB.LJumsu,"
  LSQL = LSQL & " 	BBB.RResult, BBB.RResultType, BBB.RResultNM, BBB.RJumsu,"			
  LSQL = LSQL & " 	BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
  LSQL = LSQL & " 	ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
  LSQL = LSQL & " 	GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName, LevelJooName, BBB.PlayType,"
  LSQL = LSQL & " 	LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2,"
  LSQL = LSQL & " 	BBB.Win_TourneyGroupIDX, BBB.LGroupJumsu, BBB.RGroupJumsu, BBB.LDtlJumsu, BBB.RDtlJumsu, BBB.MaxPoint, BBB.SignData"			
  LSQL = LSQL & " 	FROM"
  LSQL = LSQL & " 	("
  LSQL = LSQL & " 		SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
  LSQL = LSQL & " 		AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
  LSQL = LSQL & " 		AA.LResult, AA.LResultType, AA.LResultNM, AA.LJumsu,"
  LSQL = LSQL & " 		AA.RResult, AA.RResultType, AA.RResultNM, AA.RJumsu,"
  LSQL = LSQL & " 		AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.PlayType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName, AA.LevelJooName, AA.MaxPoint,"
  LSQL = LSQL & " 		AA.TourneyGroupIDX AS Win_TourneyGroupIDX, AA.LGroupJumsu, AA.RGroupJumsu, AA.LDtlJumsu, AA.RDtlJumsu, AA.SignData,"
  LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
  LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
  LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
  LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
  LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
  LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
  LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
  LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2"
  LSQL = LSQL & " 		FROM"
  LSQL = LSQL & " 		("
  LSQL = LSQL & " 		    SELECT A.GameTitleIDX, A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
  LSQL = LSQL & " 		    KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
  LSQL = LSQL & " 		    KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
  LSQL = LSQL & " 		    E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu,"
  LSQL = LSQL & " 		    F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu,"
  LSQL = LSQL & " 		    E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
  LSQL = LSQL & " 		    KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
  LSQL = LSQL & " 		    A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, D.PlayType, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName, C.MaxPoint, G.SignData,"
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
  LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
  LSQL = LSQL & " 		    		FROM KoreaBadminton.dbo.tblGameResult"
  LSQL = LSQL & " 		    		WHERE DelYN = 'N'"
  LSQL = LSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
  LSQL = LSQL & " 		    		) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
  LSQL = LSQL & " 		    	LEFT JOIN ("
  LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
  LSQL = LSQL & " 		    		FROM KoreaBadminton.dbo.tblGameResult"
  LSQL = LSQL & " 		    		WHERE DelYN = 'N'"
  LSQL = LSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
  LSQL = LSQL & " 		    		) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = B.TeamGameNum AND F.GameNum = B.GameNum AND F.TourneyGroupIDX = B.TourneyGroupIDX    "			
  LSQL = LSQL & " 		    	LEFT JOIN ("
  LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, SignData"
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

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
    LPlayer1 = LRs("LPlayer1")
    LPlayer2 = LRs("LPlayer2")
    RPlayer1 = LRs("RPlayer1")
    RPlayer2 = LRs("RPlayer2")
    LTeam1 = LRs("LTeam1")
    LTeam2 = LRs("LTeam2")
    RTeam1 = LRs("RTeam1")
    RTeam2 = LRs("RTeam2")
    LTourneyGroupIDX = LRs("LTourneyGroupIDX")
    RTourneyGroupIDX = LRs("RTourneyGroupIDX")

    LResultType = LRs("LResultType")
    RResultType = LRs("RResultType")

    SignData = LRs("SignData")
    GameRound = LRs("GameRound")

    StadiumName = LRs("StadiumName")

    SexName = LRs("SexName")
    PlayTypeName = LRs("PlayTypeName")
    TeamGbName = LRs("TeamGbName")
    LevelName = LRs("LevelName")
    LevelJooName = LRs("LevelJooName")
    LevelJooNum = LRs("LevelJooNum")
    LevelJooNumDtl = LRs("LevelJooNumDtl")
    PlayLevelType = LRs("PlayLevelType")

    '최대 랠리포인트
    MaxPoint = LRs("MaxPoint")
  End If

  LRs.Close

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.Write "LSQL : " & LSQL & "<BR/>"
  
%>
        <!-- S: modal-body -->
        <div class="modal-body">
         <!-- S: content-title -->
          <h3 class="content-title">
            <span>스코어 입력TEST</span>
          </h3>
          <!-- E: content-title -->

          <!-- S: 마크업 -->
          <!-- s: 게임 -->
          <div class="game ">
            <table cellspacing="0" cellpadding="0">
              <tr>
                <th>
                  <span>게임</span>
                </th>
                <td>
                    <a href="#" id="DP_PointChk_1" name="DP_WinnerPointChk" onclick="onPointCheckClick(this,'1','11','<%=GameLevelDtlIDX%>','<%=TeamGameNum%>','<%=GameNum%>')">
                      <span>11</span>
                    </a>        
                    <a href="#" id="DP_PointChk_2" name="DP_WinnerPointChk" onclick="onPointCheckClick(this,'2','17','<%=GameLevelDtlIDX%>','<%=TeamGameNum%>','<%=GameNum%>')">
                      <span>17</span>
                    </a>       
                    <a href="#" id="DP_PointChk_3" name="DP_WinnerPointChk" onclick="onPointCheckClick(this,'3','21','<%=GameLevelDtlIDX%>','<%=TeamGameNum%>','<%=GameNum%>')">
                      <span>21</span>
                    </a>       
                    <a href="#" id="DP_PointChk_4" name="DP_WinnerPointChk" onclick="onPointCheckClick(this,'4','25','<%=GameLevelDtlIDX%>','<%=TeamGameNum%>','<%=GameNum%>')">
                      <span>25</span>
                    </a>       
                    <a href="#" id="DP_PointChk_5" name="DP_WinnerPointChk" onclick="onPointCheckClick(this,'5','30','<%=GameLevelDtlIDX%>','<%=TeamGameNum%>','<%=GameNum%>')">
                      <span>30</span>
                    </a>                                                                                                                                                
                </td>
              </tr>
            </table>
          </div>
          <!-- e: 게임 -->
          <!-- s: 점수 -->
          <div class="score ">
            <table cellspacing="0" cellpadding="0">
              <%
                arnum = 0

                For i = 1 To Ceil(MaxPoint / 5)
              %>
              <tr>
                <%If i = 1 Then%>
                  <th rowspan="6">
                    <span>점수</span>
                  </th>
                <%End If%>
                <td>
                  <%
                    For j = 1 To 5
                      If arnum <= MaxPoint Then
                  %>
                        <a href="#" id="DP_PointChk_<%=arnum + 6%>" name="DP_PointChk" onclick="onPointCheckClick(this,'<%=arnum + 6%>','<%=arnum%>','<%=GameLevelDtlIDX%>','<%=TeamGameNum%>','<%=GameNum%>')">
                          <span><%=arnum%></span>
                        </a>                  
                  <%
                      End If

                      arnum = arnum + 1
                    Next
                  %>
                </td>
              </tr>
              <%
                Next
              %>
            </table>
          </div>
          <!-- e: 점수 -->
          <!-- E: 마크업 -->
        </div>
        <!-- E: modal-body -->
        <!-- S: order-footer -->
        <div class="order-footer">
          <ul class="btn-list clearfix">
            <li><a href="#" class="btn btn-default" data-dismiss="modal">닫기</a></li>
            <li><a href="#" class="btn btn-red" data-dismiss="modal">확인</a></li>
          </ul>
        </div>
        <!-- E: order-footer -->
<%

Set LRs = Nothing
DBClose()
  
%>