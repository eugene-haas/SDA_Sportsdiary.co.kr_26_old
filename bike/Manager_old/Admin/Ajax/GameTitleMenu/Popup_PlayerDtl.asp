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
  'REQ = "{""CMD"":12,""tGameLevelDtlIDX"":""B905CA57110E063AAB13676B18043387"",""tTeamGameNum"":""BA8A3F4EEB3BD1BC6BDDCE9B834746BD"",""tGameNum"":""775A4EB13A5B7CE6E0E1AAB80606E49A""}"
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


  LSQL = " SELECT A.Team AS LTeam, A.TeamDtl AS LTeamDtl, B.Team AS RTeam, B.TeamDtl AS RTeamDtl,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM, "
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS RTeamNM,"

  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.Sex, 'PubCode') AS SexName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.PlayType, 'PubCode') AS PlayTypeName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.TeamGb, 'TeamGb') AS TeamGbName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.Level, 'Level') AS LevelName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.LevelJooName,'PubCode') AS LevelJooName, D.LevelJooNum, C.LevelJooNum AS LevelJooNumDtl, C.LevelDtlName, C.GameLevelDtlIDX, "
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(C.GameType,'PubCode') AS GameTypeName, "
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(C.PlayLevelType,'PubCode') AS PlayLevelTypeName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.GroupGameGb,'PubCode') AS GroupGameGbName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.StadiumIDX,'StadiumIDX') AS StadiumName,"
  LSQL = LSQL & " C.PlayLevelType,"
  LSQL = LSQL & " D.GameType, C.GameType AS GameTypeDtl, A.StadiumNum, C.TotRound, A.[ROUND] AS GameRound,"
  LSQL = LSQL & " E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultNM, E.Jumsu AS LJumsu, E.TotalPoint AS LTotalPoint,"
  LSQL = LSQL & " F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultNM, F.Jumsu AS RJumsu, F.TotalPoint AS RTotalPoint"

  LSQL = LSQL & " FROM tblTourneyTeam A"
  LSQL = LSQL & " INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
  LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
  LSQL = LSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
  LSQL = LSQL & " LEFT JOIN ("
  LSQL = LSQL & "   SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu, TotalPoint"
  LSQL = LSQL & "   FROM KoreaBadminton.dbo.tblGroupGameResult"
  LSQL = LSQL & "   WHERE DelYN = 'N'"
  LSQL = LSQL & "   ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
  LSQL = LSQL & " LEFT JOIN ("
  LSQL = LSQL & "   SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu, TotalPoint"
  LSQL = LSQL & "   FROM KoreaBadminton.dbo.tblGroupGameResult"
  LSQL = LSQL & "   WHERE DelYN = 'N'"
  LSQL = LSQL & "   ) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = A.TeamGameNum AND F.Team + F.TeamDtl = B.Team + B.TeamDtl "
  LSQL = LSQL & " WHERE A.DelYN = 'N'"
  LSQL = LSQL & " AND B.DelYN = 'N'"
  LSQL = LSQL & " AND A.ORDERBY < B.ORDERBY"
  LSQL = LSQL & " AND A.GameLevelDtlIDX  = '" & DEC_GameLevelDtlIDX & "'"
  LSQL = LSQL & " AND A.TeamGameNum = '" & DEC_TeamGameNum & "'"
 
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
    LTeam = LRs("LTeam")
    LTeamDtl = LRs("LTeamDtl")
    LTeamNM = LRs("LTeamNM")
    LResultNM = LRs("LResultNM")
    LTotalPoint = LRs("LTotalPoint")
    LJumsu = LRs("LJumsu")

    RTeam = LRs("RTeam")
    RTeamDtl = LRs("RTeamDtl")
    RTeamNM = LRs("RTeamNM")
    RResultNM = LRs("RResultNM")
    RTotalPoint = LRs("RTotalPoint")  
    RJumsu = LRs("RJumsu")

    SexName = LRs("SexName")
    PlayTypeName = LRs("PlayTypeName")
    TeamGbName = LRs("TeamGbName")
    LevelName = LRs("LevelName")
    LevelJooName = LRs("LevelJooName")
    LevelJooNum = LRs("LevelJooNum")
    LevelJooNumDtl = LRs("LevelJooNumDtl")
    PlayLevelType = LRs("PlayLevelType")
    GroupGameGbName = LRs("GroupGameGbName")
    StadiumNum = LRs("StadiumNum")
    TotRound = LRs("TotRound")
    GameRound = crypt.EncryptStringENC(LRs("GameRound"))

    StadiumName = LRs("StadiumName")
  End If

  LRs.Close

  '예선일떄..
  If PlayLevelType = "B0100001" Then
      StrLevelName = SexName & " " & PlayTypeName & " " & TeamGbName & " " & LevelName & " " & LevelJooName & " " & LevelJooNum & " " & LevelJooNumDtl & "조" 
  '본선일때
  Else
      StrLevelName = SexName & " " & PlayTypeName & " " & TeamGbName & " " & LevelName & " " & LevelJooName & " " & LevelJooNum
  End If

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.Write "LSQL : " & LSQL & "<BR/>"
  
%>
  <!-- S: modal-body -->
  <div class="modal-body">
   <!-- S: content-title -->
    <h3 class="content-title">
      <%=StadiumName%>
      <span class="redy">
        <%=StrLevelName%>
      </span>
      <span class="redy">
        <%
        If PlayLevelType = "B0100001" Then
            Response.Write " 예선" & LevelDtlJooNum & "조"
        ElseIf PlayLevelType = "B0100002" Then
            Response.Write " 본선"
        Else
            Response.Write "-"
        End If        
        %>      
      </span>
      <span class="redy"><%=StadiumNum%>번코트</span>
      <span class="redy"><%=DEC_TeamGameNum%>경기</span>
    </h3>
    <!-- E: content-title -->
    <!-- S: 마크업 -->
    <!-- s: 경기 점수 -->
    <div class="input-info">
      <table cellspacing="0" cellpadding="0">
        <tr>
          <th>
            <span><%=LTeamNM%></span>
          </th>
					<td class="rb_2">
            <%If LResultNM = "WIN" Then%>
						  <span class="red_font">WIN</span>
            <%Else%>
              <span>-</span>
            <%End If%>
					</td>
          <td>
            <%If LResultNM = "WIN" Then%>
              <a href="#" class="on">
                <span><%=LJumsu%></span>
              </a>
            <%Else%>
              <a href="#">
                <span><%=LJumsu%></span>
              </a>            
            <%End If%>

            <a href="#">
              <span>-</span>
            </a>
            <a href="#">
              <span>-</span>
            </a>
            <a href="#">
              <span>-</span>
            </a>
            <a href="#">
              <span>-</span>
            </a>
          </td>
        </tr>
        <tr class="blue-bg">
          <th>
            <span><%=RTeamNM%></span>
          </th>
					<td class="rb_2">
            <%If RResultNM = "WIN" Then%>
						  <span class="red_font">WIN</span>
            <%Else%>
              <span>-</span>
            <%End If%>
					</td>
          <td>
            <%If RResultNM = "WIN" Then%>
              <a href="#" class="on">
                <span><%=RJumsu%></span>
              </a>
            <%Else%>
              <a href="#">
                <span><%=RJumsu%></span>
              </a>            
            <%End If%>
            <a href="#">
              <span>-</span>
            </a>
            <a href="#">
              <span>-</span>
            </a>
            <a href="#">
              <span>-</span>
            </a>
            <a href="#">
              <span>-</span>
            </a>
          </td>
        </tr>
      </table>
    </div>
    <!-- e: 경기 점수 -->
    <!-- s: 점수 -->
    <div class="sign-list ">
      <table cellspacing="0" cellpadding="0">
        <tr class="th-border">
          <th>
            <span>NO</span>
          </th>
					<th>
            <span>선수명</span>
          </th>
					<th colspan="2">
            <span>결과</span>
          </th>
					<th>
            <span>경기</span>
          </th>
					<th colspan="2">
            <span>결과</span>
          </th>
					<th>
            <span>선수명</span>
          </th>
					<th>
            <span>승자서명</span>
          </th>
        </tr>
        <%
          LSQL = " SELECT CCC.GameTitleIDX, CCC.GameLevelDtlIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
          LSQL = LSQL & " 	CCC.TeamGbNM, CCC.LevelNM, CCC.GameTypeNM,"
          LSQL = LSQL & " 	CCC.LResult, CCC.LResultType, CCC.LResultNM, CCC.LJumsu,"
          LSQL = LSQL & " 	CCC.RResult, CCC.RResultType, CCC.RResultNM, CCC.RJumsu,"
          LSQL = LSQL & " 	CCC.GameStatus, CCC.[ROUND], CCC.Sex,"
          LSQL = LSQL & " 	CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
          LSQL = LSQL & " 	CCC.LPlayer1, CCC.LPlayer2, CCC.Rplayer1, CCC.Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
          LSQL = LSQL & " 	CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType, LevelJooName,"
          LSQL = LSQL & " 	CCC.Win_TourneyGroupIDX, CCC.LGroupJumsu, CCC.RGroupJumsu, CCC.LDtlJumsu, CCC.RDtlJumsu, CCC.SignData"			
          LSQL = LSQL & " FROM "
          LSQL = LSQL & " ("
          LSQL = LSQL & " 	SELECT "
          LSQL = LSQL & " 	BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
          LSQL = LSQL & " 	BBB.TeamGbNM, BBB.LevelNM, BBB.GameTypeNM,"
          LSQL = LSQL & " 	BBB.LResult, BBB.LResultType, BBB.LResultNM, BBB.LJumsu,"
          LSQL = LSQL & " 	BBB.RResult, BBB.RResultType, BBB.RResultNM, BBB.RJumsu,"			
          LSQL = LSQL & " 	BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
          LSQL = LSQL & " 	ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
          LSQL = LSQL & " 	GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName, LevelJooName,"
          LSQL = LSQL & " 	LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2,"
          LSQL = LSQL & " 	BBB.Win_TourneyGroupIDX, BBB.LGroupJumsu, BBB.RGroupJumsu, BBB.LDtlJumsu, BBB.RDtlJumsu, BBB.SignData"			
          LSQL = LSQL & " 	FROM"
          LSQL = LSQL & " 	("
          LSQL = LSQL & " 		SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
          LSQL = LSQL & " 		AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
          LSQL = LSQL & " 		AA.LResult, AA.LResultType, AA.LResultNM, AA.LJumsu,"
          LSQL = LSQL & " 		AA.RResult, AA.RResultType, AA.RResultNM, AA.RJumsu,"
          LSQL = LSQL & " 		AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName, AA.LevelJooName, AA.SignData,"
          LSQL = LSQL & " 		AA.TourneyGroupIDX AS Win_TourneyGroupIDX, AA.LGroupJumsu, AA.RGroupJumsu, AA.LDtlJumsu, AA.RDtlJumsu,"
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
          LSQL = LSQL & " 		    A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName, G.SignData,"
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
          LSQL = LSQL & " 		) AS AA"
          LSQL = LSQL & " 		WHERE GameLevelDtlIDX IS NOT NULL"
          LSQL = LSQL & " 	) AS BBB"
          LSQL = LSQL & " ) AS CCC"
          LSQL = LSQL & " WHERE CCC.GameLevelDtlIDX IS NOT NULL"    
          'Response.Write "LSQL : " & LSQL & "<BR/>"
          Set LRs = Dbcon.Execute(LSQL)

          i = 1

          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof        
        %>        
        <tr>
					<td width="40">
						<span>1</span>
					</td>
					<td width="80">
						<span><%=LRs("LPlayer1")%></span>
						<span><%=LRs("LPlayer2")%></span>
					</td>
          <%
            '해당경기의 승자가 있으면
            If LRs("Win_TourneyGroupIDX") <> "" Then
              '승자가 왼쪽팀이면 "승" 표시
              If LRs("LResultType") = "WIN" Then
          %>
            <td width="40" class="yellow-bg">
              <span class="font-bold">승</span>
            </td>            					
          <%
              Else
          %>
            <td width="40">
              <span class="font-bold">패</span>
            </td>					
          <%
              End If
            Else
          %>
            <td width="40">
              <span class="font-bold"></span>
            </td>			
          <%
            End If
          %>		
					<td width="40">
						<span><%=LRs("LDtlJumsu")%></span>
					</td>
					<td>
						<a href="#" class="modefid-btn" onclick="OnGroupResultDtlBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC("1")%>','')">수정</a>
					</td>
					<td width="40">
						<span><%=LRs("RDtlJumsu")%></span>
					</td>
          <%
            '해당경기의 승자가 있으면
            If LRs("Win_TourneyGroupIDX") <> "" Then
              '승자가 왼쪽팀이면 "승" 표시
              If LRs("RResultType") = "WIN" Then
          %>
            <td width="40" class="yellow-bg">
              <span class="font-bold">승</span>
            </td>            					
          <%
              Else
          %>
            <td width="40">
              <span class="font-bold">패</span>
            </td>					
          <%
              End If
            Else
          %>
            <td width="40">
              <span class="font-bold"></span>
            </td>			
          <%
            End If
          %>		
					<td width="80">
						<span><%=LRs("RPlayer1")%></span>
						<span><%=LRs("RPlayer2")%></span>
					</td>
					<td width="80">
						<img src="<%=LRs("SignData")%>" width="79" height="49" alt="">
					</td>
        </tr>
        <%
              LRs.MoveNext
            Loop 
          End If
        %>
				<tr class="bottom-bg">
					<th>
						<span></span>
					</th>
					<th>
            <%If LResultNM = "WIN" Then%>
              <span class="yellow-font">WIN</span>
            <%Else%>
              <span>-</span>
            <%End If%>            
					</th>
					<th>
						<span><%=LJumsu%></span>
					</th>
					<th>
						<span><%=LTotalPoint%></span>
					</th>
					<th>
						<span>합계</span>
					</th>
					<th>
						<span><%=RTotalPoint%></span>
					</th>
					<th>
						<span><%=RJumsu%></span>
					</th>
					<th>
						<span>
              <%If RResultNM = "WIN" Then%>
                <span class="yellow-font">WIN</span>
              <%Else%>
                <span>-</span>
              <%End If%>	            
            </span>
					</th>
					<th>
						<span></span>
					</th>
				</tr>
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
      <li><a href="#" class="btn btn-red" onclick="OnGroupResultCompleteClick('<%=GameLevelDtlIDX%>', '<%=TeamGameNum%>', '<%=GameNum%>', '<%=GameRound%>');">수정</a></li>
    </ul>
  </div>
  <!-- E: order-footer -->
<%

Set LRs = Nothing
DBClose()
  
%>