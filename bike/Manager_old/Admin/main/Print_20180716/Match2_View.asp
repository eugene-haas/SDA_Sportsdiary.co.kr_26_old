<!-- #include file="../../dev/dist/config.asp"-->
<%
  GameLevelDtlidx = fInject(crypt.DecryptStringENC(Request("GameLevelDtlidx")))

  'GameTitleIDx = "44"  
  'TeamGb       = "21001"
  'Level        = "21001002"
  'GroupGameGb  = "sd040001"

	'GameLevelDtlidx = "1335"

	'1535
	'1552


  '대회정보 선택==========================================================================================
	TSQL = "SELECT GameTitleName,"
	TSQL = TSQL & " KoreaBadminton.dbo.FN_NameSch(A.Sex, 'PubCode') AS SexName,"
	TSQL = TSQL & " KoreaBadminton.dbo.FN_NameSch(A.PlayType, 'PubCode') AS PlayTypeName,"
	TSQL = TSQL & " KoreaBadminton.dbo.FN_NameSch(A.TeamGb, 'TeamGb') AS TeamGbName,"
	TSQL = TSQL & " KoreaBadminton.dbo.FN_NameSch(A.Level, 'Level') AS LevelName,"
	TSQL = TSQL & " KoreaBadminton.dbo.FN_NameSch(A.LevelJooName,'PubCode') AS LevelJooName, A.LevelJooNum, B.LevelJooNum AS LevelJooNumDtl,  B.LevelDtlName, GameLevelDtlIDX, "
	TSQL = TSQL & " KoreaBadminton.dbo.FN_NameSch(B.GameType,'PubCode') AS GameTypeName, "
	TSQL = TSQL & " KoreaBadminton.dbo.FN_NameSch(B.PlayLevelType,'PubCode') AS PlayLevelTypeName,"
	TSQL = TSQL & " KoreaBadminton.dbo.FN_NameSch(A.GroupGameGb,'PubCode') AS GroupGameGbName,"
	TSQL = TSQL & " GroupGameGb,"
	TSQL = TSQL & " B.PlayLevelType,"
	TSQL = TSQL & " A.GameType"
	TSQL = TSQL & " FROM tblGameTitle C"
	TSQL = TSQL & " INNER JOIN tblGameLevel A ON A.GameTitleIDX = C.GameTitleIDX"
	TSQL = TSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLevelidx = A.GameLevelIDX"
	TSQL = TSQL & " WHERE A.DelYN = 'N'"
	TSQL = TSQL & " AND B.DelYN = 'N'"
	TSQL = TSQL & " AND C.DelYN = 'N'"
	TSQL = TSQL & " AND B.GameLevelDtlidx = '" & GameLevelDtlidx & "'"

  Set TRs = Dbcon.Execute(TSQL)

  If Not(TRs.Eof Or TRs.Bof) Then 
    GameTitleName 		= TRs("GameTitleName")
    SexName         	= TRs("SexName")
    PlayTypeName      = TRs("PlayTypeName")
		TeamGbName				= TRs("TeamGbName")
		LevelName					= TRs("LevelName")
		LevelJooName			= TRs("LevelJooName")
		LevelJooNum				= TRs("LevelJooNum")
		LevelJooNumDtl		= TRs("LevelJooNumDtl")
		LevelDtlName			= TRs("LevelDtlName")
		GameTypeName			= TRs("GameTypeName")
		PlayLevelTypeName	= TRs("PlayLevelTypeName")
		PlayLevelType			= TRs("PlayLevelType")
		GroupGameGbName		= TRs("GroupGameGbName")
		GroupGameGb				= TRs("GroupGameGb")
		GameType					= TRs("GameType")
  End If 
  '대회정보 선택==========================================================================================

  '참가선수 카운팅========================================================================================
		'개인전
		If GroupGameGb = "B0030001" Then 

			CSQL = "SELECT COUNT(*) AS PlayerCnt"
			CSQL = CSQL & " FROM "
			CSQL = CSQL & " ("
			CSQL = CSQL & " SELECT TourneyGroupIDX "
			CSQL = CSQL & " FROM tblTourney "
			CSQL = CSQL & " WHERE DelYN = 'N'"
			CSQL = CSQL & " AND GameLevelDtlidx = '" & GameLevelDtlidx & "'"
			CSQL = CSQL & " AND ISNULL(TourneyGroupIDX,'0') <> '0'"
			CSQL = CSQL & " AND [Round] = '1'"
			CSQL = CSQL & " GROUP BY TourneyGroupIDX"
			CSQL = CSQL & " ) AS AA			"

		Else 
		'단체전

			CSQL = "SELECT COUNT(*) AS PlayerCnt"
			CSQL = CSQL & " FROM "
			CSQL = CSQL & " ("
			CSQL = CSQL & " SELECT Team, TeamDtl"
			CSQL = CSQL & " FROM tblTourneyTeam "
			CSQL = CSQL & " WHERE DelYN = 'N'"
			CSQL = CSQL & " AND GameLevelDtlidx = '" & GameLevelDtlidx & "'"
			CSQL = CSQL & " AND ISNULL(Team,'') <> ''"
			CSQL = CSQL & " AND [Round] = '1'"
			CSQL = CSQL & " GROUP BY Team, TeamDtl"
			CSQL = CSQL & " ) AS AA"

		End If 


  Set CRs = Dbcon.Execute(CSQL)

	If Not(CRs.Eof Or CRs.Bof) Then 
  	PlayerCnt = CRs("PlayerCnt")
	End If
  '참가선수 카운팅========================================================================================
  

NowYear = Year(Now())
NowMonth = AddZero(Month(Now()))
NowDay = AddZero(Day(Now()))
NowHour = AddZero(Hour(Now))
NowMinute = AddZero(Minute(Now))
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <title><%=GroupGameNm%>_<%=TeamGbNm%>_<%=LevelNm%></title>
  <link rel="stylesheet" href="../../css/style_print.css">
</head>
<body>
  <!-- S: header -->
  <div class="header">
    <div class="attend">[경기대진표] <span>참가선수: <%=PlayerCnt%><%If GroupGameGb = "B0030001" Then%>명<%Else%>팀<%End If%></span></div>
    <div class="title">
      <h1><%=GameTitleName%></h1>
      <!--<p class="date"><%=GameS%> ~ <%=GameE%> / <%=GameArea%>&nbsp; &nbsp;</p>-->
      <p class="team" style="height:64px;line-height:64px;">
        <%=SexName & PlayTypeName & " " &  TeamGbName & " " & LevelName & " " & LevelJooName & LevelJooNum & " "%>
        <%
          if PlayLevelType = "B0100001" Then
            Response.Write "예선" & LevelJooNumDtl & "조"
          ElseIf PlayLevelType = "B0100002" Then
            Response.Write "본선"
          Else
            Response.Write "-"
          End If
        %>			
			</p> 
    </div>
  </div>

  <!-- E: header -->
  <!-- S: main -->
  <div class="main clearfix match2">
    <!-- S: left_side -->
		<%
				'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				'좌측선수정보셀렉트=========================================================

				LSQL = "EXEC tblGameTourneyChart_Searched '" & GameLevelDtlidx & "', '1', 'L' ,'HALF'"


				Set LRs = Dbcon.Execute(LSQL)               
				
				If Not(LRs.Eof Or LRs.Bof) Then 
					Do Until LRs.Eof 
						WriteDate = LRs("WriteDate")

						L_Team1 = LRs("Team1")
						L_Team2 = LRs("Team2")

						L_Player1 = LRs("Player1")
						L_Player2 = LRs("Player2")

						L_TeamDtl = LRs("TeamDtl")
						
						LRs.MoveNext
					Loop 
				End If              
		%>
    <div class="left_side jc-center">
      <table>
        <tr>
          <td><!--<span class="player_school"><%=L_Team1 & L_TeamDtl%></span>-->
						<%
							If GroupGameGb = "B0030001" Then
								Response.Write L_Player1 & "(" & L_Team1 & ")"

								If L_Player2 <> "" AND NOT ISNULL(L_Player2) Then
									Response.Write "," & L_Player2 & "(" & L_Team2 & ")"
								End If
							Else
								Response.Write L_Team1
							End If
						%>
					</td>
        </tr>
      </table>
    </div>
    <!-- E: left_side -->
    <!-- S: line_area -->
    <div class="line_area">
      <img src="../../Images/print/line_match2.png" alt>
    </div>
    <!-- E: line_area -->
    <!-- S: right_side -->
		<%
			RSQL = "EXEC tblGameTourneyChart_Searched '" & GameLevelDtlidx & "', '1', 'R' ,'HALF'"
			
			Set RRs = Dbcon.Execute(RSQL)               

			If Not(RRs.Eof Or RRs.Bof) Then 
				Do Until RRs.Eof 
						WriteDate = RRs("WriteDate")

						R_Team1 = RRs("Team1")
						R_Team2 = RRs("Team2")

						R_Player1 = RRs("Player1")
						R_Player2 = RRs("Player2")

						R_TeamDtl = RRs("TeamDtl")

					RRs.MoveNext
				Loop 
			End If 
		%>
    <div class="right_side jc-center">
      <table>
        <tr>
          <td>
						<%
							If GroupGameGb = "B0030001" Then
								Response.Write R_Player1 & "(" & R_Team1 & ")"

								If R_Player2 <> "" AND NOT ISNULL(R_Player2) Then
									Response.Write "," & R_Player2 & "(" & R_Team2 & ")"
								End If
							Else
								Response.Write R_Team1
							End If
						%>
						<!--<span class="player_school"><%=R_Team1%></span>-->
					</td>
        </tr>
      </table>
    </div>
    <!-- E: right_side -->
  </div>
  <!-- E: main -->
  <!-- S: footer -->
  <div class="footer">
    <div class="bot_logo">
		<img src="../../Images/print/logo_badminton.png" alt="대한배드민턴협회">
    </div>
    <div class="print_date">
      Report Created : <%=WriteDate%><!--<%=NowYear%>년 <%=NowMonth%>월 <%=NowDay%>일 <%=NowHour%>:<%=NowMinute%>-->
    </div>
  </div>
  <!-- E: footer -->
</body>
</html>