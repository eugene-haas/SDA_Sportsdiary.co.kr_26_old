<!-- #include file="../../dev/dist/config.asp"-->
<%

  GameLevelDtlidx = fInject(crypt.DecryptStringENC(Request("GameLevelDtlidx")))
  
  'UnearmWin sd042001일반
  'UnearmWin sd04200부전일반
  'LeftRightGb sd033001 왼쪽
  'LeftRightGb sd033002 오른쪽

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
	TSQL = TSQL & " A.GameType,"
  TSQL = TSQL & " B.FullGameYN,"
  TSQL = TSQL & " B.GameType AS GameTypeDtl"
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
    FullGameYN        = TRs("FullGameYN")
    GameTypeDtl       = TRs("GameTypeDtl")
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


  '개인전 
  USQL = "tblGameTourneyChartLeague_Searched '" & GameLevelDtlidx & "'"



  Set URs = Dbcon.Execute(USQL)
  If Not(URs.Bof Or URs.Eof) Then

    Arr_Player = URs.Getrows()
    Cnt_Arr_Player = UBound(Arr_Player,2)

    WriteDate = Arr_Player(6,0)

    ReDim ReturnSTR(Cnt_Arr_Player)

    For i = 0 To Cnt_Arr_Player
      ReturnSTR(i) = Arr_Player(0,i) & "," & Arr_Player(1,i) & "," & Arr_Player(2,i) & "," & Arr_Player(3,i) & "," & Arr_Player(4,i) & "," & Arr_Player(5,i) 
    Next
  End If

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
  <%
    If PlayerCnt > 0 Then 

    '대진표의 높이
    Main_Width  = "1100"
    Main_Height = "750" 
  %>
  <div class="header">
    <div class="attend">[경기대진표] <span>참가선수: <%=UBOUND(Arr_Player,2) + 1%><%If GroupGameGb = "B0030001" Then%>명<%Else%>팀<%End If%></span></div>
    <div class="title">
      <h1><%=GameTitleName%></h1>
      <p class="date"><!--<%=GameS%> ~ <%=GameE%> / <%=GameArea%>-->&nbsp; &nbsp;</p>
      <p class="team">
        <%=SexName & PlayTypeName & " " &  TeamGbName & " " & LevelName & " " & LevelJooName & LevelJooNum & " "%>

        <%
          if PlayLevelType = "B0100001" Then
            Response.Write "예선" & LevelJooNumDtl & "조"
          ElseIf PlayLevelType = "B0100002" Then
            If GameTypeDtl  = "B0040001" AND FullGameYN = "Y" Then
              Response.Write "풀리그"
            Else
              Response.Write "본선"
            End If
          Else
            Response.Write "-"
          End If
        %>				      
      </p> 
    </div>
  </div>
  <%
    End If
  %>
  <!-- E: header -->
  <!-- S: main -->
  <div class="main clearfix league">
    <div class="line_area">
    <%
      If Cnt_Arr_Player <> "" Then  
    %>
      <table class="table">
        <tbody>
          <tr>
            <th class="team">구분</th>
            <%
              '해당되는 선수수만큼 Loop
              For i = 0 To Cnt_Arr_Player
            %>
            <th>
              <div class="number">
                <!--<span class="round"><%=i+1%></span>-->
              </div>
              <div class="player">
              <%If GroupGameGb = "B0030001" Then%>

                <span class="school"><%=Arr_Player(1,i)%>(<%=Arr_Player(3,i)%>)</span>
                <%If Arr_Player(2,i) <> "" AND Not ISNULL(Arr_Player(2,i)) Then%>
                <br>
                <span class="school"><%=Arr_Player(2,i)%>(<%=Arr_Player(4,i)%>)</span>
                <%End If%>
              <%Else%>
                <span class="name"><%=Arr_Player(3,i)%></span>
              <%End If%>
              </div>
            </th>
            <%
              Next
            %>
          </tr>
          <%
            For i = 0 To Cnt_Arr_Player
          %>  

          <tr>
            <th>
              <div class="number">
                <!--<span class="round"><%=i+1%></span>-->
              </div>
              <div class="school">
              <%If GroupGameGb = "B0030001" Then%>
                <span class="name"><%=Arr_Player(1,i)%></span>
                <span class="school">(<%=Arr_Player(3,i)%>)</span>
                <%If Arr_Player(2,i) <> "" AND Not ISNULL(Arr_Player(2,i)) Then%>
                <br>
                <span class="name"><%=Arr_Player(2,i)%>
                <span class="school">(<%=Arr_Player(4,i)%>)</span>
                <%End If%>
              <%Else%>
                <span class="name"><%=Arr_Player(3,i)%></span>
              <%End If%>
              </div>
            </th>

            <%
              For j = 0 To Cnt_Arr_Player 

                If i <> j  Then 
            %>

            <td>
                  <%If GroupGameGb = "B0030001" Then%>
                    <span><%=Arr_Player(1,i)%></span>
                    <span>VS</span>
                    <span><%=Arr_Player(1,j)%></span>
                  <%Else%>
                    <span><%=Arr_Player(3,i)%></span>
                    <span>VS</span>
                    <span><%=Arr_Player(3,j)%></span>
                  <%End If%>

                  <%
                    If i < j Then
                      ReturnSTR(i) = ReturnSTR(i) & "," & Count
                      ReturnSTR(j) = ReturnSTR(j) & "," & Count
                        
                  %>
                    <!--<BR>경기순번 : <%=Count%>-->
                  <%
                      Count = Count + 1
                    End If
                  %>
            </td>
            <%
                Else
            %>
            <td class="self">
              <img src="../../Images/print/line_league.png" alt>

            </td>
            <%
                End If
              Next
            %>
          </tr>
          <%
            Next
          %>
        </tbody>
      </table>
      <%
        End If
      %>
    </div>
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