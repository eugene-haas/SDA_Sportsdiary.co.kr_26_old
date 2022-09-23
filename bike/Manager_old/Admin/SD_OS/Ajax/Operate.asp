<!--#include file="../Library/config.asp"-->
<!--#include file="../Library/JSON_2.0.4.asp" -->
<!--#include file="../Library/JSON_UTIL_0.1.1.asp" -->
<!--#include file="../Library/json2.asp" -->
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
'REQ = "{""CMD"":2,""GameDay"":""2018-03-31"",""StadiumIDX"":""9A7490F11E123AAEBD5E2335806B4D48"",""StadiumNumber"":"""",""PlayType"":""D096EC5BB8B02F96118B096392C18758"",""IngType"":""45E500538E0FD452A763FA5041E332C2"",""SchUserName"":""""}"

Set oJSONoutput = JSON.Parse(REQ)


If hasown(oJSONoutput, "GameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.GameTitleIDX) Or oJSONoutput.GameTitleIDX = "" Then
      GameTitleIDX = ""
      DEC_GameTitleIDX = ""
    Else
      GameTitleIDX = fInject(oJSONoutput.GameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameTitleIDX))    
    End If
End if	

If hasown(oJSONoutput, "GameDay") = "ok" then
    If ISNull(oJSONoutput.GameDay) Or oJSONoutput.GameDay = "" Then
      GameDay = ""
      DEC_GameDay = ""
    Else
      GameDay = fInject(oJSONoutput.GameDay)
      DEC_GameDay = fInject(crypt.DecryptStringENC(oJSONoutput.GameDay))    
    End If
End if	

If hasown(oJSONoutput, "StadiumIDX") = "ok" then
    If ISNull(oJSONoutput.StadiumIDX) Or oJSONoutput.StadiumIDX = "" Then
      StadiumIDX = ""
      DEC_StadiumIDX = ""
    Else
      StadiumIDX = fInject(oJSONoutput.StadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.StadiumIDX))    
    End If
End if	

If hasown(oJSONoutput, "StadiumNumber") = "ok" then
    If ISNull(oJSONoutput.StadiumNumber) Or oJSONoutput.StadiumNumber = "" Then
      StadiumNumber = ""
      DEC_StadiumNumber = ""
    Else
      StadiumNumber = fInject(oJSONoutput.StadiumNumber)
      DEC_StadiumNumber = fInject(crypt.DecryptStringENC(oJSONoutput.StadiumNumber))    
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

If hasown(oJSONoutput, "SchUserName") = "ok" then
    If ISNull(oJSONoutput.SchUserName) Or oJSONoutput.SchUserName = "" Then
      SchUserName = ""
      DEC_SchUserName = ""
    Else
      SchUserName = fInject(oJSONoutput.SchUserName)
      DEC_SchUserName = fInject(crypt.DecryptStringENC(oJSONoutput.SchUserName))    
    End If
End if	

 strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"

'조건별 경기진행순서 불러온다

LSQL = " SELECT CCC.GameTitleIDX, CCC.GameLevelDtlIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
LSQL = LSQL & " 	CCC.TeamGbNM, CCC.LevelNM, CCC.GameTypeNM,"
LSQL = LSQL & " 	CCC.Result, CCC.ResultType, CCC.ResultNM, CCC.Jumsu,"
LSQL = LSQL & " 	CCC.GameStatus, CCC.[ROUND], CCC.Sex,"
LSQL = LSQL & " 	CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
LSQL = LSQL & " 	CCC.LPlayer1, CCC.LPlayer2, CCC.Rplayer1, CCC.Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
LSQL = LSQL & " 	CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType, LevelJooName"
LSQL = LSQL & " FROM "
LSQL = LSQL & " ("
LSQL = LSQL & " 	SELECT "
LSQL = LSQL & " 	BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
LSQL = LSQL & " 	BBB.TeamGbNM, BBB.LevelNM, BBB.GameTypeNM,"
LSQL = LSQL & " 	BBB.Result, BBB.ResultType, BBB.ResultNM, BBB.Jumsu,"
LSQL = LSQL & " 	BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
LSQL = LSQL & " 	ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
LSQL = LSQL & " 	GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName, LevelJooName,"
LSQL = LSQL & " 	LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2"
LSQL = LSQL & " 	FROM"
LSQL = LSQL & " 	("
LSQL = LSQL & " 		SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
LSQL = LSQL & " 		AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
LSQL = LSQL & " 		AA.Result, AA.ResultType, AA.ResultNM, AA.Jumsu,"
LSQL = LSQL & " 		AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName, AA.LevelJooName,"
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
LSQL = LSQL & " 		    E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
LSQL = LSQL & " 		    KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
LSQL = LSQL & " 		    A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName"
LSQL = LSQL & " 		    ,STUFF(("
LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
LSQL = LSQL & " 		    			SELECT  '|'   + UserName "
LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " 			            AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 			            AND DelYN = 'N'"
LSQL = LSQL & " 		    			FOR XML PATH('')  "
LSQL = LSQL & " 		    			)  "
LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " 		            AND AAA.DelYN = 'N'"
LSQL = LSQL & " 		    		),1,1,'') AS LPlayers"
LSQL = LSQL & " 		    ,STUFF(("
LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
LSQL = LSQL & " 		    			SELECT  '|'   + UserName "
LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " 			            AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 			            AND DelYN = 'N'"
LSQL = LSQL & " 		    			FOR XML PATH('')  "
LSQL = LSQL & " 		    			)  "
LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & " 		            AND AAA.DelYN = 'N'"
LSQL = LSQL & " 		    		),1,1,'') AS RPlayers"
LSQL = LSQL & " "
LSQL = LSQL & " 		    ,STUFF((		"
LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
LSQL = LSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " 			            AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 			            AND DelYN = 'N'"
LSQL = LSQL & " 		    			FOR XML PATH('')  "
LSQL = LSQL & " 		    			)  "
LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " 		            AND AAA.DelYN = 'N'"
LSQL = LSQL & " 		    		),1,1,'') AS LTeams"
LSQL = LSQL & " 		    ,STUFF((		"
LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
LSQL = LSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " 			            AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 			            AND DelYN = 'N'"
LSQL = LSQL & " 		    			FOR XML PATH('')  "
LSQL = LSQL & " 		    			)  "
LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & " 		            AND AAA.DelYN = 'N'"
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
LSQL = LSQL & " 		    WHERE A.DelYN = 'N'"
LSQL = LSQL & " 		    AND B.DelYN = 'N'"
LSQL = LSQL & " 		    AND C.DelYN = 'N'"
LSQL = LSQL & " 		    AND D.DelYN = 'N'"
LSQL = LSQL & " 		    AND A.ORDERBY < B.ORDERBY"
LSQL = LSQL & " 		    AND A.GameDay = '" & GameDay & "'"
LSQL = LSQL & " 		    AND A.TeamGameNum = '0'"
LSQL = LSQL & " 		) AS AA"
LSQL = LSQL & " 		WHERE GameLevelDtlIDX IS NOT NULL"
LSQL = LSQL & " "
LSQL = LSQL & " 		UNION ALL"
LSQL = LSQL & " "
LSQL = LSQL & " 		SELECT A.GameTitleIDX, A.GameLevelDtlidx, A.TeamGameNum, '0' AS GameNum, A.TeamGb, A.Level, ISNULL(A.Team,'') AS LTourneyGroupIDX, ISNULL(B.Team,'') AS RTourneyGroupIDX,"
LSQL = LSQL & " 		KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
LSQL = LSQL & " 		KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
LSQL = LSQL & " 		E.Result AS Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
LSQL = LSQL & " 		KoreaBadminton.dbo.FN_GroupGameStatus(A.GameLevelDtlidx, A.TeamGameNum) AS GameStatus, A.[ROUND], dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
LSQL = LSQL & " 		A.TurnNum, C.PlayLevelType, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName,"
LSQL = LSQL & " 		'' AS LPlayer1,"
LSQL = LSQL & " 		'' AS LPlayer2,"
LSQL = LSQL & " 		'' AS RPlayer1,"
LSQL = LSQL & " 		'' AS RPlayer2,"
LSQL = LSQL & " 		KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM1, "
LSQL = LSQL & " 		'' AS LTeamNM2,"
LSQL = LSQL & " 		KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS LTeamNM2,"
LSQL = LSQL & " 		'' AS LTeamNM2"
LSQL = LSQL & " 		FROM tblTourneyTeam A"
LSQL = LSQL & " 		INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
LSQL = LSQL & " 		INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & " 		INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
LSQL = LSQL & " 		LEFT JOIN ("
LSQL = LSQL & " 			SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
LSQL = LSQL & " 			FROM KoreaBadminton.dbo.tblGroupGameResult"
LSQL = LSQL & " 			WHERE DelYN = 'N'"
LSQL = LSQL & " 			) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
LSQL = LSQL & " 		WHERE A.DelYN = 'N'"
LSQL = LSQL & " 		AND B.DelYN = 'N'"
LSQL = LSQL & " 		AND A.ORDERBY < B.ORDERBY"
LSQL = LSQL & " 		AND A.GameDay = '" & GameDay & "'"
If StadiumNumber <> "" Then
    LSQL = LSQL & "         AND A.StadiumNum = '" & StadiumNumber & "'"
End IF
LSQL = LSQL & "         AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
LSQL = LSQL & " 		AND A.GameLevelDtlIDX IS NOT NULL"
LSQL = LSQL & " 	) AS BBB"
LSQL = LSQL & " ) AS CCC"
LSQL = LSQL & " WHERE CCC.GameLevelDtlIDX IS NOT NULL"
LSQL = LSQL & " AND CCC.GameTitleIDX = '" & DEC_GameTitleIDX & "'"

If PlayType <> "" Then
    LSQL = LSQL & " AND CCC.PlayLevelType = '" & DEC_PlayType & "'"
End If

'If StadiumNumber <> "" Then
'    LSQL = LSQL & " AND CCC.StadiumNum = '" & StadiumNumber & "'"
'End If

If DEC_IngType <> "ALL" AND IngType <> "" Then
    LSQL = LSQL & " AND CCC.GameStatus = '" & DEC_IngType & "'"
End If

If SchUserName <> "" Then
    LSQL = LSQL & " AND ("
    LSQL = LSQL & "       CCC.LPlayer1 LIKE '%" & SchUserName & "%'"
    LSQL = LSQL & "       OR CCC.LPlayer2 LIKE '%" & SchUserName & "%'"
    LSQL = LSQL & "       OR CCC.RPlayer1 LIKE '%" & SchUserName & "%'"
    LSQL = LSQL & "       OR CCC.RPlayer2 LIKE '%" & SchUserName & "%'"            
    LSQL = LSQL & "     )"
End If

'If StadiumIDX <> "" Then
'    LSQL = LSQL & " AND CCC.StadiumIDX = '" & DEC_StadiumIDX & "'"
'End If



LSQL = LSQL & "  ORDER BY CONVERT(BIGINT,ISNULL(CCC.TurnNum,0)), CONVERT(BIGINT,TeamGameNum), CONVERT(BIGINT,GameNum)"



Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    i = 0

    Do Until LRs.Eof
   
    If LRs("GameStatus") <> "" AND ISNULL(LRs("GameStatus")) = false Then
        GameEndGubun = LRs("GameStatus")
    Else
        GameEndGubun = "GameEmpty"
    End If
 

%>
    <%
        'S: 개인전일때
        If LRs("GroupGameGb") = "B0030001" Then
    %>
        <!-- S: list -->
        <%If GameEndGubun = "GameEnd" Then%>
        <ul class="list end">
        <%Else%>
        <ul class="list">
        <%End If%>
          <li>
            <!-- S: up_floor -->
            <div class="up_floor">
              <span class="num"><%=LRs("TempNum")%></span>
              <span class="cont"><!--1조 / -->
              <%=LRs("GameNum")%>경기 
              [
              <%=LRs("Sex") & LRs("GameTypeNM") & " " & LRs("TeamGbNM") & " " & LRs("LevelNM") & " " & LRs("LevelJooName") & LRs("LevelJooNum") %>
              <%
                If LRs("PlayLevelType") = "B0100001" Then
                    Response.Write " 예선" & LRs("LevelDtlJooNum")&"조"
                ElseIf LRs("PlayLevelType") = "B0100002" Then
                    Response.Write " 본선"
                Else
                    Response.Write "-"
                End If
              
              %>
              ] 코트:<%=LRs("StadiumNum")%></span>
            </div>
            <!-- E: up_floor -->

            <!-- S: down_floor -->
            <div class="down_floor clearfix">
              <ul class="clearfix">
                <%If LRs("LTourneyGroupIDX") <>  "" AND LRs("LTourneyGroupIDX") <>  "0" Then%>
                    <%If LRs("LPlayer1") <> "" AND LRs("LPlayer1") <> "0" Then%>
                    <li>
                        <div class="name"><%=LRs("LPlayer1")%></div>
                        <div class="club">(<%=LRs("LTeam1")%>)</div>
                    </li>
                    <%End If%>
                    <%If LRs("LPlayer2") <>  "" AND LRs("LPlayer2") <>  "0" Then%>
                    <li>
                        <div class="name"><%=LRs("LPlayer2")%></div>
                        <div class="club">(<%=LRs("LTeam2")%>)</div>
                    </li>
                    <%End If%>
                <%Else %>
                    <li>
                        <div class="name">
                         <%If LRs("Round") = "1" Then%>
                            BYE
                         <%End If%>
                        </div>
                    </li>
                <%End If %>
              </ul>
         
                    <div class="vs">VS</div>
  
              <ul class="clearfix">
                <%If LRs("RTourneyGroupIDX") <>  "" AND LRs("RTourneyGroupIDX") <>  "0" Then%>
                    <%If LRs("RPlayer1") <>  "" AND LRs("RPlayer1") <>  "0" Then%>
                    <li>
                        <div class="name"><%=LRs("RPlayer1")%></div>
                        <div class="club">(<%=LRs("RTeam1")%>)</div>
                    </li>
                    <%End If%>
                    <%If LRs("RPlayer2") <>  "" AND LRs("RPlayer2") <>  "0" Then%>
                    <li>
                        <div class="name"><%=LRs("RPlayer2")%></div>
                        <div class="club">(<%=LRs("RTeam2")%>)</div>
                    </li>
                    <%End If%>
                <%Else%>
                    <li>
                        <div class="name">
                         <%If LRs("Round") = "1" Then%>
                            BYE
                         <%End If%>
                        </div>
                    </li>
                <%End If%>
              </ul>
         
            </div>
            <!-- E: down_floor -->
          </li>
          <li>
            <%If LRs("LTourneyGroupIDX") <> "" AND LRs("RTourneyGroupIDX") <> "" Then %>
                <%If GameEndGubun = "GameEnd" Then%>
                <a onclick="sch_GameResult('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%If LRs("LTourneyGroupIDX") = "" Then Response.Write "" ELSE Response.Write crypt.EncryptStringENC(LRs("LTourneyGroupIDX")) End If%>','<%If LRs("RTourneyGroupIDX") = "" Then Response.Write "" ELSE Response.Write crypt.EncryptStringENC(LRs("RTourneyGroupIDX")) End If%>','<%=crypt.EncryptStringENC(LRs("GroupGameGb"))%>')" class="btn btn_result" data-toggle="modal" data-target=".detail_result">결과</a>
                <%ElseIf GameEndGubun = "GameIng" Then %>
                <!--<a onclick="sch_SetResult('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%If LRs("LTourneyGroupIDX") = "" Then Response.Write "" ELSE Response.Write crypt.EncryptStringENC(LRs("LTourneyGroupIDX")) End If%>','<%If LRs("RTourneyGroupIDX") = "" Then Response.Write "" ELSE Response.Write crypt.EncryptStringENC(LRs("RTourneyGroupIDX")) End If%>')" class="btn btn_play" data-toggle="modal" data-target=".end_game">경기중</a>-->
                <a onclick="cli_enterscore('<%=crypt.EncryptStringENC(LRs("GameTitleIDX"))%>','<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC(LRs("GroupGameGb"))%>')" class="btn btn_gray">경기중</a>
                <%Else%>
                <a onclick="cli_enterscore('<%=crypt.EncryptStringENC(LRs("GameTitleIDX"))%>','<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC(LRs("GroupGameGb"))%>')" class="btn btn_gray">입력</a>
                <%End If%>
            <%End If%>
          </li>
        </ul>
        <!-- E: list -->
   <%
        'E: 개인전일때

        'S: 단체전 일때
        Else
    %>

        <!-- S: list -->
        <%If GameEndGubun = "GameEnd" Then%>
        <ul class="list end">
        <%Else%>
        <ul class="list">
        <%End If%>
          <li>
            <!-- S: up_floor -->
            <div class="up_floor">
              <span class="num"><%=LRs("TempNum")%></span>
              <span class="cont">
              <!--1조 / <%=LRs("TeamGameNum")%>경기 [<%=LRs("Sex") & " " & LRs("TeamGbNM") & " " & LRs("LevelNM") & " " & LRs("GameTypeNM")%>]</span>-->
              <%=LRs("TeamGameNum")%>경기 
              [
              <%=LRs("Sex") & LRs("GameTypeNM") & " " & LRs("TeamGbNM") & " " & LRs("LevelNM") & " " & LRs("LevelJooName") & LRs("LevelJooNum") %>
              <%
                If LRs("PlayLevelType") = "B0100001" Then
                    Response.Write " 예선" & LRs("LevelDtlJooNum")&"조"
                ElseIf LRs("PlayLevelType") = "B0100002" Then
                    Response.Write " 본선"
                Else
                    Response.Write "-"
                End If
              
              %>
              ] 코트:<%=LRs("StadiumNum")%></span>
              
            </div>
            <!-- E: up_floor -->

            <!-- S: down_floor -->
            <div class="down_floor clearfix">
              <ul class="clearfix">
                    <li>
                        <div class="name"><%=LRs("LTeam1")%></div>
                    </li>
              </ul>
         
              <div class="vs">VS</div>
  
              <ul class="clearfix">
                    <li>
                        <div class="name"><%=LRs("RTeam1")%></div>

                    </li>
              </ul>
         
            </div>
            <!-- E: down_floor -->
          </li>
          <li>
            <%If LRs("LTeam1") <> "" OR LRs("RTeam1") <> "" Then %>
                <%If GameEndGubun = "GameEnd" Then%>
                <a onclick="sch_GroupGameResult('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC(LRs("GroupGameGb"))%>','<%=crypt.EncryptStringENC("View")%>')" class="btn btn_result" data-toggle="modal" data-target=".detail-score">결과</a>
                <%ElseIf GameEndGubun = "GameIng" Then %>
                <a onclick="cli_enterscore('<%=crypt.EncryptStringENC(LRs("GameTitleIDX"))%>','<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC(LRs("GroupGameGb"))%>')" class="btn btn_gray">경기중</a>
                <%Else%>
                <a onclick="cli_enterscore('<%=crypt.EncryptStringENC(LRs("GameTitleIDX"))%>','<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC(LRs("GroupGameGb"))%>')" class="btn btn_gray">입력</a>
                <%End If%>
            <%Else%>

                <%=LRs("LTeam1")%><Br>
                <%=LRs("LTeam2")%><Br>
                <%=LRs("RTeam1")%><Br>
                <%=LRs("RTeam2")%><Br>
            <%End If%>
          </li>
        </ul>
        <!-- E: list -->

<%
        End If
        
        LRs.MoveNext
    Loop
End If

'Set oJSONoutput_SUM = jsArray()
'Set oJSONoutput_SUM = jsObject()


'oJSONoutput_SUM("CMD") = CMD
'oJSONoutput_SUM("TYPE") = "JSON"
'oJSONoutput_SUM("Tourney") = strjson_dtl

'oJSONoutput_SUM("SSQL") = SSQL

'strjson_sum = toJSON(oJSONoutput_SUM)

'Response.Write strjson_sum

Set LRs = Nothing
DBClose()
  
%>