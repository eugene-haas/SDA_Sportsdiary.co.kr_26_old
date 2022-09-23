<!-- #include file="../../dev/dist/config.asp"-->
<% 
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"

    Dim CMD             : CMD               = fInject(Request("CMD"))
	Dim GameTitleIDX	: GameTitleIDX 		= fInject(Request("GameTitleIDX"))
	Dim GameDay		    : GameDay 		    = fInject(Request("GameDay"))	
	Dim StadiumIDX		: StadiumIDX 		= fInject(Request("StadiumIDX"))
    Dim StadiumNum		: StadiumNum 		= fInject(Request("StadiumNum"))
	Dim SearchKey		: SearchKey			= fInject(Request("SearchKey"))
	Dim Searchkeyword	: Searchkeyword		= fInject(Request("Searchkeyword"))
	
	Dim DEC_GameTitleIDX	: DEC_GameTitleIDX 		= crypt.DecryptStringENC(GameTitleIDX)
	Dim DEC_GameDay		    : DEC_GameDay 		    = GameDay
	Dim DEC_StadiumIDX		: DEC_StadiumIDX 		= crypt.DecryptStringENC(StadiumIDX)
    Dim DEC_StadiumNum		: DEC_StadiumNum 		= StadiumNum
	Dim DEC_SearchKey		: DEC_SearchKey			= SearchKey
	Dim DEC_Searchkeyword	: DEC_Searchkeyword		= Searchkeyword


    CSQL = " SELECT CCC.GameTitleIDX, CCC.GameLevelDtlIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
    CSQL = CSQL & " 	CCC.TeamGbNM, CCC.LevelNM, CCC.GameTypeNM,"
    CSQL = CSQL & " 	CCC.Result, CCC.ResultType, CCC.ResultNM, CCC.Jumsu,"
    CSQL = CSQL & " 	CCC.GameStatus, CCC.[ROUND], CCC.Sex,"
    CSQL = CSQL & " 	CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
    CSQL = CSQL & " 	CCC.LPlayer1, CCC.LPlayer2, CCC.Rplayer1, CCC.Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
    CSQL = CSQL & " 	CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType"
    CSQL = CSQL & " FROM "
    CSQL = CSQL & " ("
    CSQL = CSQL & " 	SELECT "
    CSQL = CSQL & " 	BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
    CSQL = CSQL & " 	BBB.TeamGbNM, BBB.LevelNM, BBB.GameTypeNM,"
    CSQL = CSQL & " 	BBB.Result, BBB.ResultType, BBB.ResultNM, BBB.Jumsu,"
    CSQL = CSQL & " 	BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
    CSQL = CSQL & " 	ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
    CSQL = CSQL & " 	GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName,"
    CSQL = CSQL & " 	LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2"
    CSQL = CSQL & " 	FROM"
    CSQL = CSQL & " 	("
    CSQL = CSQL & " 		SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
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
    CSQL = CSQL & " 		    SELECT A.GameTitleIDX, A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
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
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
    CSQL = CSQL & " 		    		),1,1,'') AS LPlayers"
    CSQL = CSQL & " 		    ,STUFF(("
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + UserName "
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
    CSQL = CSQL & " 		    		),1,1,'') AS RPlayers"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		    ,STUFF((		"
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
    CSQL = CSQL & " 		    		),1,1,'') AS LTeams"
    CSQL = CSQL & " 		    ,STUFF((		"
    CSQL = CSQL & " 		    		SELECT  DISTINCT (  "
    CSQL = CSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
    CSQL = CSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
    CSQL = CSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
    CSQL = CSQL & " 		    			FOR XML PATH('')  "
    CSQL = CSQL & " 		    			)  "
    CSQL = CSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
    CSQL = CSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
    CSQL = CSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
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
    CSQL = CSQL & " 		    AND A.StadiumNum = '" & DEC_StadiumNum & "'"
    CSQL = CSQL & " 		    AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
    
    CSQL = CSQL & " 		    AND A.TeamGameNum = '0'"
    CSQL = CSQL & " 		) AS AA"
    CSQL = CSQL & " 		WHERE GameLevelDtlIDX IS NOT NULL"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		UNION ALL"
    CSQL = CSQL & " "
    CSQL = CSQL & " 		SELECT A.GameTitleIDX, A.GameLevelDtlidx, A.TeamGameNum, '0' AS GameNum, A.TeamGb, A.Level, ISNULL(A.Team,'') AS LTourneyGroupIDX, ISNULL(B.Team,'') AS RTourneyGroupIDX,"
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
    CSQL = CSQL & " 		AND A.StadiumNum = '" & DEC_StadiumNum & "'"
    
    CSQL = CSQL & " 		AND A.GameLevelDtlIDX IS NOT NULL"
    CSQL = CSQL & " 	) AS BBB"
    CSQL = CSQL & " ) AS CCC"
    CSQL = CSQL & " WHERE CCC.GameLevelDtlIDX IS NOT NULL"

    If DEC_SearchKey = "UserName" Then
        CSQL = CSQL & " AND (CCC.LPlayer1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.LPlayer2 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RPlayer1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RPlayer2 LIKE '%" & DEC_Searchkeyword & "%')"
    ElseIf DEC_SearchKey = "Team" Then
        CSQL = CSQL & " AND (CCC.LTeam1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.LTeam2 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RTeam1 LIKE '%" & DEC_Searchkeyword & "%' OR CCC.RTeam2 LIKE '%" & DEC_Searchkeyword & "%')"
    End If

    SET CRs = DBCon.Execute(CSQL)

    If Not(CRs.Eof Or CRs.Bof) Then 
%>
    <table border="1">
    	<tr>
            <td>대회명</td>
            <td>종목</td>
            <td>구분</td>
            <td>대진표번호</td>
            <td>경기장</td>
            <td>코트</td>
            <td>선수(좌)</td>
            <td>선수(우)</td>
            <td>진행상태</td>
        
<% 
        Do Until CRs.Eof
%>      
        <tr>
            <td><%=CRs("TempNum")%></td>
            <td><%=CRs("Sex") & CRs("GameTypeNM") & " " & CRs("TeamGbNM") & " " & CRs("LevelNM") & CRs("LevelJooNum") & " "%> 
            <%
              If CRs("PlayLevelType") = "B0100001" Then
                Response.Write "예선 " & CRs("LevelDtlJooNum") & "조"
              ElseIf CRs("PlayLevelType") = "B0100002" Then
                Response.Write "본선"
              Else
                Response.Write "-"
              End If  
            %>
            </td>
            <td>
            <% 
            If CRs("GroupGameGb") = "B0030001" Then
                Response.Write "개인전"  
            ElseIf CRs("GroupGameGb") = "B0030002" Then
                Response.Write "단체전"  
            Else
                Response.Write CRs("")
            End If            
            %>            
            
            
            </td>
            <td><%=CRs("GameNum")%></td>
            <td><%=CRs("StadiumName")%></td>
            <td><%=CRs("StadiumNum")%></td>
            <td><%=CRs("LPlayer1") & "(" & CRs("LTeam1") & ")," & CRs("LPlayer2") & "(" & CRs("LTeam2") & ")"%></td>
            <td><%=CRs("RPlayer1") & "(" & CRs("RTeam1") & ")," & CRs("RPlayer2") & "(" & CRs("RTeam2") & ")"%></td>
            <td>
            <% 
            If CRs("GameStatus") = "GameIng" Then
                Response.Write "진행중"  
            ElseIf CRs("GameStatus") = "GameEnd" Then
                Response.Write "경기완료"  
            ElseIf CRs("GameStatus") = "GameEmpty" Then
                Response.Write ""  
            Else
                Response.Write ""
            End If            
            %>
            </td>
        </tr>
<%
            CRs.MoveNext
          Loop
%>

    </table>
<%
    End If

    Response.Buffer = True
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-disposition","attachment;filename=경기진행순서.xls"
%>

