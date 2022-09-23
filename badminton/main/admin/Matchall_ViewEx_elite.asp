<!-- #include virtual = "/dev/config.asp"-->
<!-- #include virtual = "/classes/JSON_2.0.4.asp" -->
<!-- #include virtual = "/classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual = "/classes/json2.asp" -->

<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->
<!-- #include virtual = "/pub/fn/badmt/res/res.pubcode.asp" -->
<!-- #include virtual = "/pub/fn/badmt/res/res.teamGB.asp" -->
<!-- #include virtual = "/pub/fn/badmt/res/res.lvInfo.asp" -->
<!-- #include virtual = "/pub/fn/badmt/fn.rule.asp" -->
<!-- #include virtual = "/pub/fn/badmt/fn.util.rule.asp" -->
<!-- #include virtual = "/pub/fn/fn.utiletc.asp" -->
<!-- #include virtual = "/pub/fn/badmt/fn.elite.order.printer.asp" -->

<%
'   ===============================================================================
'     GameInfo -> Idx,GameLevelDtlidx,Sex,PlayType,TeamGb,Level,LevelJooName,GameType,
'                  0,        1       , 2 ,    3   ,   4  ,   5 ,      6,         7
'                 LevelJooNum,LevelJooNumDtl,LevelDtlName,PlayLevelType,GroupGameGb,TotRound
'                    8,           9,            10,             11,       12,         13
'
'      PlayerCnt -> PlayerCnt	GameLevelDtlidx
'      League Jumsu ->     Idx,	GameLevelDtlidx,	L_MemberNames,	L_MemberIDXs,	L_TeamNames,	L_Teams,	L_TeamDtl,	R_MemberNames,	R_MemberIDXs,
'                           0         1                 2              3             4              5        6              7           8
'                          R_TeamNames,	R_Teams,	R_TeamDtl,	L_SetJumsu,	L_MatchJumsu,	R_SetJumsu,	R_MatchJumsu,	L_Result,	EnterType,
'                               9            10       11            12          13             14           15      16          17
'													 GameOrder,	GameDay,	GameTime
'															 18,       19,        20
'
'      Game Info ->       Idx, GameLevelDtlidx, Sex,	PlayType, TeamGb, Level, LevelJooName, GameType,
'                          0          1          2       3        4        5        6            7
'                          LevelJooNum, LevelJooNumDtl, LevelDtlName, PlayLevelType, GroupGameGb, TotRound, EnterType
'                               8            9              10            11             12          13        14
'
'      League User ->      Idx, GamelevelDtlIDX, Player1, Player2, memIdx1, memIdx2, Team1, Team2, cTeam1, cTeam2
'                           0           1           2        3        4        5        6      7      8       9
'                           TeamDtl1, TeamDtl2, OrderBy
'                              10        11        12
'
'      Tournament Info ->  Idx, GameLevelDtlidx, GameNum, TourneyGroupIDX, OrderBy, Round,
'                            0          1           2            3            4       5
'                           LByeYN, LQualifier, LSeedNum, RByeYN, RQualifier, RSeedNum, LJumsu, LDtlJumsu, RJumsu, RDtlJumsu
'                              6         7          8       9        10          11       12        13        14      15
'                           LPlayer1, LTeam1, LPlayer2, LTeam2, RPlayer1, RTeam1, RPlayer2, RTeam2
'                              16       17       18       19       20       21       22       23
'   ===============================================================================
%>

<%
	'   ===============================================================================
	'       아마추어 대진표 보기시 특정 행동을 한다.   AmaTimeOnly = 1
	'       1. 리그일 경우 점수 대신 , 게임 시간, l_player vs r_player를 출력한다.
	'				2. 리그와 토너먼트를 출력식 무조건 1페이지에 1개씩 출력한다.
	'				3. 프린트 리그 , 프린트 토너먼트 버튼을 생성한다.
	'				4. 프린트 리그 버튼을 눌렀을 경우 , 토너먼트를 제외한 리그만 가로로 출력한다.
	'				5. 프린트 토너먼트 버튼을 눌렀을 경우 , 리그를 제외한 토너먼트만 세로로 출력한다.
	'   ===============================================================================

   ' tempnum - tblgameoperate
	GameTitleIDX 		= fInject(crypt.DecryptStringENC(Request("GameTitleIDX")))
	GameLevelIDX 		= fInject(crypt.DecryptStringENC(Request("GameLevelIDX")))
	GameLevelDtlIDX = fInject(crypt.DecryptStringENC(Request("GameLevelDtlIDX")))
	AmaTimeOnly 		= fInject(Request("AmaTimeOnly"))			' 아무 추어 승점표시 대시 게임 시간 표시
	IsAma 					= fInject(Request("IsAma"))						' 아마 추어 일경우 승패득실차 없음

	If(AmaTimeOnly <> "") Then
		AmaTimeOnly = CDbl(AmaTimeOnly)
	Else
		AmaTimeOnly = 0
	End If

	If(IsAma <> "") Then
		IsAma = CDbl(IsAma)
	Else
		IsAma = 0
	End If

	'AmaTimeOnly = 1

	strUserAgent = Request.ServerVariables("HTTP_USER_AGENT")         ' log용 - http agent info - browser, os 구분
	strBrowser = etcGetAgentBrowser(strUserAgent)
%>

<%
'   ===============================================================================
'      DB Query
'   ===============================================================================
   sTartTimer = Timer()

'   ===============================================================================
'      Game Level Dtl Idx Array를 얻는다.
'   ===============================================================================
   Function getSqlDtlIdx(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX)
      Dim strSql

      strSql = "SELECT GameLevelDtlidx "
      strSql = strSql & " FROM tblGameLevelDtl "
      strSql = strSql & " WHERE DelYN = 'N' "

      If GameLevelIDX <> "" Then
         strSql = strSql & sprintf(" AND GameLevelIDX = '{0}'", Array(GameLevelIDX))
      ElseIf GameLevelDtlIDX <> "" Then
         strSql = strSql & sprintf(" AND GameLevelDtlIDX = '{0}'", Array(GameLevelDtlIDX))
      ElseIf GameTitleIDX <> "" Then
         strSql = strSql & sprintf(" AND GameTitleIDX = '{0}'", Array(GameTitleIDX))
      End If

      If(GameTitleIDX = "" And GameLevelIDX = "" And GameLevelDtlIDX = "") Then strSql = "" End If
      getSqlDtlIdx = strSql
   End Function

'   ===============================================================================
'      Game Level Dtl Idx Array를 얻는다.  - Sub Query용 , Tonament/ League구분
'   ===============================================================================
   Function getSubSqlDtlIdx(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX, GameType, GroupGameGb)
      Dim strSql

      strSql = "SELECT GameLevelDtlidx "
      strSql = strSql & " FROM tblGameLevelDtl As A  "
      strSql = strSql & " Inner Join tblGameLevel As B On A.GameLevelidx = B.GameLevelidx  "

      If GameType <> "" And GroupGameGb <> "" Then
         strSql = strSql & sprintf(" WHERE A.DelYN = 'N' And B.DelYN = 'N' And A.GameType = '{0}' And B.GroupGameGb = '{1}'", Array(GameType, GroupGameGb))
      ElseIf GroupGameGb <> "" Then
         strSql = strSql & sprintf(" WHERE A.DelYN = 'N' And B.DelYN = 'N' And B.GroupGameGb = '{0}'", Array(GroupGameGb))
      ElseIf GameType <> "" Then
         strSql = strSql & sprintf(" WHERE A.DelYN = 'N' And B.DelYN = 'N' And A.GameType = '{0}'", Array(GameType))
      End If

      If GameLevelIDX <> "" Then
         strSql = strSql & sprintf(" AND A.GameLevelIDX = '{0}'", Array(GameLevelIDX))
      ElseIf GameLevelDtlIDX <> "" Then
         strSql = strSql & sprintf(" AND A.GameLevelDtlIDX = '{0}'", Array(GameLevelDtlIDX))
      ElseIf GameTitleIDX <> "" Then
         strSql = strSql & sprintf(" AND A.GameTitleIDX = '{0}'", Array(GameTitleIDX))
      End If

      If(GameTitleIDX = "" And GameLevelIDX = "" And GameLevelDtlIDX = "") Then strSql = "" End If
      getSubSqlDtlIdx = strSql
   End Function

'   ===============================================================================
'      Game Title Name을 얻는다.
'   ===============================================================================
   Function getSqlTitleInfo(GameLevelDtlIDX)
      Dim strSql

      strSql = "SELECT A.GameTitleName "
      strSql = strSql & " FROM tblGameTitle As A "
      strSql = strSql & " Inner Join tblGameLevelDtl As B "
      strSql = strSql & " On A.GameTitleIdx = B.GameTitleIdx"
      strSql = strSql & sprintf(" WHERE A.DelYN = 'N' And B.DelYN = 'N' And B.GameLevelDtlidx = '{0}' ", Array(GameLevelDtlIDX))

      If(GameLevelDtlIDX = "") Then strSql = "" End If
      getSqlTitleInfo = strSql
   End Function

'   ===============================================================================
'      Game Info을 얻는다.
'   ===============================================================================
   Function getrSqlGameInfoEx(sqlLvDtlIdx)
      Dim strSql

      strSql = "Select ROW_NUMBER() Over(Order By GameLevelDtlidx) As Idx, GameLevelDtlidx, "
      strSql = strSql & " A.Sex, A.PlayType, A.TeamGb, A.Level, A.LevelJooName, B.GameType, "
      'strSql = strSql & " A.LevelJooNum, B.LevelJooNum AS LevelJooNumDtl,  B.LevelDtlName, "
	  strSql = strSql & " A.LevelJooNum, ISNULL(B.LevelJooNum_SubNM,B.LevelJooNum) AS LevelJooNumDtl,  B.LevelDtlName, "
      strSql = strSql & " B.PlayLevelType, A.GroupGameGb, B.TotRound AS TotRound, A.EnterType"
      strSql = strSql & " FROM tblGameLevel As A "
      strSql = strSql & " INNER JOIN tblGameLevelDtl B ON B.GameLevelidx = A.GameLevelIDX "
      strSql = strSql & " WHERE A.DelYN = 'N' AND B.DelYN = 'N' "
      strSql = strSql & sprintf(" AND B.GameLevelDtlidx In ({0}) ", Array(sqlLvDtlIdx))

      If(sqlLvDtlIdx = "") Then strSql = "" End If
      getrSqlGameInfoEx = strSql
   End Function

'   ===============================================================================
'      참가선수 카운팅을 얻는다.
'   ===============================================================================
   Function getrSqlCountPlayerEx(subSql_person, subSql_group)
      Dim strSql

      strSql = "SELECT * From  ("
      strSql = strSql & "     SELECT COUNT(*) AS PlayerCnt, GameLevelDtlidx"
      strSql = strSql & "      FROM "
      strSql = strSql & "      ("
      strSql = strSql & "          SELECT GameLevelDtlidx, TourneyGroupIDX "
      strSql = strSql & "          FROM tblTourney "
      strSql = strSql & "          WHERE DelYN = 'N' AND [Round] = '1' "
      strSql = strSql & sprintf("  AND GameLevelDtlidx In ({0}) ", Array(subSql_person))
		strSql = strSql & "          And TourneyGroupIDX > 0 "
      strSql = strSql & "          GROUP BY GameLevelDtlidx, TourneyGroupIDX"
      strSql = strSql & "      ) AS AA Group By GameLevelDtlidx	"

      strSql = strSql & " Union All	"

      strSql = strSql & "     SELECT COUNT(*) AS PlayerCnt, GameLevelDtlidx"
      strSql = strSql & "      FROM "
      strSql = strSql & "      ("
      strSql = strSql & "          SELECT GameLevelDtlidx, Team, TeamDtl"
      strSql = strSql & "          FROM tblTourneyTeam "
      strSql = strSql & "          WHERE DelYN = 'N' AND [Round] = '1' "
			strSql = strSql & "          And (Team Is Not Null And Team <> '') "
      strSql = strSql & sprintf("  AND GameLevelDtlidx In ({0}) ", Array(subSql_group))		
      strSql = strSql & "          GROUP BY GameLevelDtlidx, Team, TeamDtl"
      strSql = strSql & "      ) AS AA Group By GameLevelDtlidx	"
      strSql = strSql & "  ) As A Order By GameLevelDtlidx"


      If(subSql_person = "" Or subSql_group = "" ) Then strSql = "" End If
      getrSqlCountPlayerEx = strSql
   End Function

'   ===============================================================================
'      Game Tournament Info을 얻는다.
'   ===============================================================================
   Function getrSqlTournamentInfoEx(subSql_person, subSql_group)
      Dim strSql

      ' --------------------------------------------------------------------------------------------
      ' 공통 cte 구문
      ' 해당 게임에 있는 GroupIdx를 중복없이 구한다. (Group By 사용)
      strSql = strSql & " ;with cte_group As ( "
      strSql = strSql & "    Select GameLevelDtlidx, TourneyGroupIDX From tblTourney  "
      strSql = strSql & sprintf(" Where DelYN = 'N' AND GameLevelDtlidx In ({0}) ", Array(subSql_person))
      strSql = strSql & "    Group By GameLevelDtlidx, TourneyGroupIDX "
      strSql = strSql & " ) "

      ' 해당 게임에 있는 Player를 GameGroupIdx를 가지고 구한다.
      ' 단식 복식을 구분하기 위해 playType을 추가한다.
      strSql = strSql & " , cte_player As ( "
      strSql = strSql & "    Select ROW_NUMBER() Over (Order By TourneyPlayerIDX) As Idx,  "
      strSql = strSql & "    (Select playType From tblGameLevel As A Inner Join tblGameLevelDtl As B On A.GameLevelidx = B.GameLevelidx  "
      strSql = strSql & "       Where A.DelYN = 'N' And B.DelYN = 'N' And B.GameLevelDtlidx = P.GameLevelDtlidx) As PlayType,  "
      strSql = strSql & "    TourneyGroupIDX, UserName,  "
      strSql = strSql & "    Team, 	  "
      strSql = strSql & "    TeamDtl ,  "
      strSql = strSql & "    Case  "
      strSql = strSql & "       When TeamDtl <> '0' Then (Select A.TeamNm From tblTeamInfo As A Where DelYN = 'N' And A.Team = P.Team) + Cast(TeamDtl As VarChar) "
      strSql = strSql & "       Else (Select A.TeamNm From tblTeamInfo As A Where DelYN = 'N' And A.Team = P.Team)  "
      strSql = strSql & "    End As TeamName  "
      strSql = strSql & "    From tblTourneyPlayer As P Where DelYN = 'N' And TourneyGroupIDX In (Select TourneyGroupIDX From cte_group)  "
      strSql = strSql & " ) "

      ' 단식/복식을 구분하여 사용자 정보를 얻는다.
      strSql = strSql & " , cte_playerInfo As ( "
      strSql = strSql & "    Select A.TourneyGroupIDX,  "
      strSql = strSql & "          A.UserName As UserName1, A.Team As Team1, A.TeamDtl As TeamDtl1 , A.TeamName As TeamName1,  "
      strSql = strSql & "          IsNull(B.UserName, '') As UserName2, IsNull(B.Team, '') As Team2, IsNull(B.TeamDtl, '') As TeamDtl2 , IsNull(B.TeamName, '') As TeamName2  "
      strSql = strSql & "       From cte_player As A  "
      strSql = strSql & "          Inner Join cte_player As B  "
      strSql = strSql & "          On B.Idx = (A.Idx + 1) And A.TourneyGroupIDX = B.TourneyGroupIDX Where A.PlayType = 'B0020002' And B.PlayType = 'B0020002'			 			  "

      strSql = strSql & "    Union All  "

      strSql = strSql & "    Select A.TourneyGroupIDX,  "
      strSql = strSql & "          A.UserName As UserName1, A.Team As Team1, A.TeamDtl As TeamDtl1 , A.TeamName As TeamName1,  "
      strSql = strSql & "          '' As UserName2, '' As Team2, '' As TeamDtl2 , '' As TeamName2  "
      strSql = strSql & "       From cte_player As A Where A.PlayType = 'B0020001' "

      strSql = strSql & "     Union All         "

      ' TourneyGroupIDX = 0일때 처리를 위해서 임시 값을 넣는다. ( Null 처리 ) - Bye 일때 표시를 위해서
      strSql = strSql & "     Select 0 As TourneyGroupIDX, '' As UserName1, '' As Team1, '' As TeamDtl1 , '' As TeamName1,  "
      strSql = strSql & "           '' As UserName2, '' As Team2, '' As TeamDtl2 , '' As TeamName2 "
      strSql = strSql & " ) "

      ' Game 정보를 구한다.
      strSql = strSql & " , cte_tourney As ( "
      strSql = strSql & " Select 	 "
      strSql = strSql & "        "
      strSql = strSql & "       GameLevelDtlidx, GameNum, TourneyGroupIDX,OrderBy, Round, ByeYN, Qualifier, SeedNum  From tblTourney As A  "
      strSql = strSql & sprintf(" Where A.DelYN = 'N' AND A.GameLevelDtlidx In ({0}) ", Array(subSql_person))
      strSql = strSql & " ) "

      ' 구해진 Game 정보 2개를 합산하여 1개의 정보로 만든다. ( 1Game - L Player, R Player Info )
      strSql = strSql & " , cte_tourInfo As ( "
      strSql = strSql & " Select A.GameLevelDtlidx, A.GameNum, A.TourneyGroupIDX,A.OrderBy, A.Round,  "
      strSql = strSql & "       A.TourneyGroupIDX As LTourneyGroupIDX, A.ByeYN As LByeYN, A.Qualifier As LQualifier, A.SeedNum As LSeedNum, 		 "
      strSql = strSql & "       B.TourneyGroupIDX As RTourneyGroupIDX, B.ByeYN As RByeYN, B.Qualifier As RQualifier, B.SeedNum As RSeedNum "
      strSql = strSql & "       From cte_tourney As A  "
      strSql = strSql & "       Inner Join cte_tourney As B On B.ORDERBY = A.ORDERBY + 1 And B.GameNum = A.GameNum And A.GameLevelDtlidx = B.GameLevelDtlidx "
      strSql = strSql & " )  "

      ' 단체전 - Team Info를 구한다.
      strSql = strSql & ", cte_team As ( "
      strSql = strSql & "   Select ROW_NUMBER() Over(Partition By GameLevelDtlidx Order By TourneyTeamIDX) As Idx,  "
      strSql = strSql & "      GameLevelDtlidx, TeamGameNum, TourneyTeamIDX, '' As UserName,  Team, TeamDtl , "
      strSql = strSql & "   Orderby, Round, ByeYN, Qualifier,SeedNum,    "
      strSql = strSql & "   Case          "
      strSql = strSql & "      When TM.TeamDtl <> '0' Then (Select A.TeamNm From tblTeamInfo As A Where DelYN = 'N' And A.Team = TM.Team) + Cast(TM.TeamDtl As VarChar)        "
      strSql = strSql & "      Else (Select A.TeamNm From tblTeamInfo As A Where DelYN = 'N' And A.Team = TM.Team)       "
      strSql = strSql & "   End As TeamName "
      strSql = strSql & "    "
      strSql = strSql & "   From tblTourneyTeam As TM  "
      strSql = strSql & sprintf(" Where DelYN = 'N' AND GameLevelDtlidx In ({0}) ", Array(subSql_group))
      strSql = strSql & ") "

      ' 단체전 - 구해진 Team Info를 2개를 합산하여 1개의 정보로 만든다. ( 1Game - L Player, R Player Info )
      strSql = strSql & ", cte_teamInfo As ( "
      strSql = strSql & "   Select A.GameLevelDtlidx, A.TeamGameNum, A.TourneyTeamIDX, A.OrderBy, A.Round, "
      strSql = strSql & "      A.ByeYN As LByeYN, A.Qualifier As LQualifier, A.SeedNum As LSeedNum,  "
      strSql = strSql & "      B.ByeYN As RByeYN, B.Qualifier As RQualifier, B.SeedNum As RSeedNum,  "
      strSql = strSql & "      A.Team As LTeam, A.TeamDtl As LTeamDtl , A.TeamName As LTeamName,   "
      strSql = strSql & "      B.Team As RTeam, B.TeamDtl As RTeamDtl , B.TeamName As RTeamName "
      strSql = strSql & "      From cte_team As A  "
      strSql = strSql & "      Inner Join cte_team As B On A.TeamGameNum = B.TeamGameNum And B.Idx = A.Idx + 1 "
			strSql = strSql & "      And A.round = B.round And A.GameLevelDtlidx = B.GameLevelDtlidx "
      strSql = strSql & ") "

      ' --------------------------------------------------------------------------------------------
      ' 개인전

      ' 1개로 합쳐진 Game 정보에 Player정보(Name, Team), 점수등을 합친다.
      strSql = strSql & "Select ROW_NUMBER() Over(Partition By GamelevelDtlIDX Order By Cast(A.GameOrder As Int)) As Idx, * From ( "
      strSql = strSql & "     Select  A.GameLevelDtlidx, A.GameNum, A.TourneyGroupIDX,A.OrderBy, A.Round,   "
      strSql = strSql & "           A.LByeYN, IsNull(A.LQualifier, 0) As LQualifier, A.LSeedNum,  "
      strSql = strSql & "           A.RByeYN, IsNull(A.RQualifier, 0) As RQualifier, A.RSeedNum, "
      strSql = strSql & "           IsNull(O.L_MatchJumsu, 0) As LJumsu, IsNull(O.L_SetJumsu, 0) As LDtlJumsu,  "
      strSql = strSql & "           IsNull(O.R_MatchJumsu, 0) As RJumsu, IsNull(O.R_SetJumsu, 0) As RDtlJumsu,  "
      strSql = strSql & "           IsNull(P1.UserName1, '') As LPlayer1, IsNull(P1.TeamName1, '') As LTeam1,  "
      strSql = strSql & "           IsNull(P1.UserName2, '') As LPlayer2, IsNull(P1.TeamName2, '') As LTeam2,  "
      strSql = strSql & "           IsNull(P2.UserName1, '') As RPlayer1, IsNull(P2.TeamName1, '') As RTeam1,  "
      strSql = strSql & "           IsNull(P2.UserName2, '') As RPlayer2, IsNull(P2.TeamName2, '') As RTeam2 , A.GameNum As GameOrder"
      strSql = strSql & "     From cte_tourInfo As A  "
      strSql = strSql & "        Inner Join tblGameOperate As O On O.GameLevelDtlIDX = A.GameLevelDtlidx And O.GameNum = A.GameNum "
      strSql = strSql & "        Inner Join cte_playerInfo As P1 On P1.TourneyGroupIDX = A.LTourneyGroupIDX "
      strSql = strSql & "        Inner Join cte_playerInfo As P2 On P2.TourneyGroupIDX = A.RTourneyGroupIDX  "
      strSql = strSql & "        Where O.DelYN = 'N' "

      strSql = strSql & "   Union All "
      ' --------------------------------------------------------------------------------------------
      ' 단체전

      strSql = strSql & "     Select A.GameLevelDtlidx, A.TeamGameNum, A.TourneyTeamIDX, A.OrderBy, A.Round, "
      strSql = strSql & "           A.LByeYN, IsNull(A.LQualifier, 0) As LQualifier, A.LSeedNum, "
      strSql = strSql & "           A.RByeYN, IsNull(A.RQualifier, 0) As RQualifier, A.RSeedNum, "
      strSql = strSql & "           IsNull(O.L_MatchJumsu, 0) As LJumsu, IsNull(O.L_SetJumsu, 0) As LDtlJumsu, "
      strSql = strSql & "           IsNull(O.R_MatchJumsu, 0) As RJumsu, IsNull(O.R_SetJumsu, 0) As RDtlJumsu, "
      strSql = strSql & "           '' As LPlayer1, IsNull(A.LTeamName, '') As LTeam1, "
      strSql = strSql & "           '' As LPlayer2, '' As LTeam2, "
      strSql = strSql & "           '' As RPlayer1, IsNull(A.RTeamName, '') As RTeam1, "
      strSql = strSql & "           '' As RPlayer2, '' As RTeam2, A.TeamGameNum As GameOrder "
      strSql = strSql & "     From cte_teamInfo As A  "
      strSql = strSql & "     Left Join tblGameOperate As O On O.GameLevelDtlIDX = A.GameLevelDtlidx And O.TeamGameNum = A.TeamGameNum "
      strSql = strSql & "     And O.GameNum = 0 And O.DelYN = 'N' "
      strSql = strSql & "  ) As A "



      If(subSql_person = "" And subSql_group = "") Then strSql = "" End If
      getrSqlTournamentInfoEx = strSql
   End Function

'   ===============================================================================
'      Game League Info을 얻는다.
'   ===============================================================================
   Function getrSqlLeagueInfoEx(subSql_person, subSql_group)
      Dim strSql

      ' 해당 게임에 있는 GroupIdx를 중복없이 구한다. (Group By 사용)
      strSql = strSql & ";with cte_group As ("
      strSql = strSql & "   Select GameLevelDtlidx, TourneyGroupIDX From tblTourney "
      strSql = strSql & sprintf("   Where DelYN = 'N' And GameLevelDtlidx In ( ({0}) ) ", Array(subSql_person))
      strSql = strSql & "   Group By GameLevelDtlidx, TourneyGroupIDX"
      strSql = strSql & ")"

      ' 해당 게임에 있는 Player를 GameGroupIdx를 가지고 구한다.
      ' 단식 복식을 구분하기 위해 playType을 추가한다.
      strSql = strSql & ", cte_player As ("
      strSql = strSql & "   Select ROW_NUMBER() Over (Order By TourneyPlayerIDX) As Idx, "
      strSql = strSql & "   (Select playType From tblGameLevel As A Inner Join tblGameLevelDtl As B On A.GameLevelidx = B.GameLevelidx "
      strSql = strSql & "      Where A.DelYN = 'N' And B.DelYN = 'N' And B.GameLevelDtlidx = P.GameLevelDtlidx) As PlayType, "
      strSql = strSql & "   TourneyGroupIDX, MemberIDX, UserName, "
      strSql = strSql & "   Sex, "
      strSql = strSql & "   Case "
      strSql = strSql & "      When Sex = 'Man' Then '남자'"
      strSql = strSql & "      When Sex = 'WoMan' Then '여자'"
      strSql = strSql & "      When Sex = 'Mix' Then '혼합'"
      strSql = strSql & "   End As SexName, "
      strSql = strSql & "   Team, 	 "
      strSql = strSql & "   TeamDtl , "
      strSql = strSql & "   Case "
      strSql = strSql & "      When TeamDtl <> '0' Then (Select A.TeamNm From tblTeamInfo As A Where DelYN = 'N' And A.Team = P.Team) + Cast(TeamDtl As VarChar)"
      strSql = strSql & "      Else (Select A.TeamNm From tblTeamInfo As A Where DelYN = 'N' And A.Team = P.Team) "
      strSql = strSql & "   End As TeamName "
      strSql = strSql & "   From tblTourneyPlayer As P Where DelYN = 'N' And TourneyGroupIDX In (Select TourneyGroupIDX From cte_group) "
      strSql = strSql & ")"

      ' 단식/복식을 구분하여 사용자 정보를 얻는다.
      strSql = strSql & ", cte_playerInfo As ("
      strSql = strSql & "   Select A.TourneyGroupIDX, "
      strSql = strSql & "         A.MemberIDX As MemberIdx1, A.UserName As UserName1, A.Sex As Sex1, A.SexName As SexName1, A.Team As Team1, A.TeamDtl As TeamDtl1 , A.TeamName As TeamName1, "
      strSql = strSql & "         IsNull(B.MemberIDX, '') As MemberIdx2, IsNull(B.UserName, '') As UserName2, IsNull(B.Sex, '') As Sex2, IsNull(B.SexName, '') As SexName2, "
      strSql = strSql & "         IsNull(B.Team, '') As Team2, IsNull(B.TeamDtl, '') As TeamDtl2 , IsNull(B.TeamName, '') As TeamName2 "
      strSql = strSql & "      From cte_player As A "
      strSql = strSql & "         Inner Join cte_player As B "
      strSql = strSql & "         On B.Idx = (A.Idx + 1) And A.TourneyGroupIDX = B.TourneyGroupIDX Where A.PlayType = 'B0020002' And B.PlayType = 'B0020002'			 			 "

      strSql = strSql & "   Union All "

      strSql = strSql & "   Select A.TourneyGroupIDX, "
      strSql = strSql & "         A.MemberIDX As MemberIdx1, A.UserName As UserName1, A.Sex As Sex1, A.SexName As SexName1, A.Team As Team1, A.TeamDtl As TeamDtl1 , A.TeamName As TeamName1, "
      strSql = strSql & "         '' As MemberIdx2, '' As UserName2, '' As Sex2, '' As SexName2, '' As Team2, '' As TeamDtl2 , '' As TeamName2 "
      strSql = strSql & "      From cte_player As A Where A.PlayType = 'B0020001'"

      strSql = strSql & "     Union All         "

      ' TourneyGroupIDX = 0일때 처리를 위해서 임시 값을 넣는다. ( Null 처리 ) - Bye 일때 표시를 위해서
      strSql = strSql & "     Select 0 As TourneyGroupIDX, '' As MemberIdx1, '' As UserName1, '' As Sex1, '' As SexName1, '' As Team1, '' As TeamDtl1 , '' As TeamName1 ,   "
      strSql = strSql & "           '' As MemberIdx2, '' As UserName2, '' As Sex2, '' As SexName2, '' As Team2, '' As TeamDtl2 , '' As TeamName2 "
      strSql = strSql & ")"

      strSql = strSql & "Select ROW_NUMBER() Over(Partition By GamelevelDtlIDX Order By OrderBy) As Idx,   *     From ( "
      strSql = strSql & "     Select A.GamelevelDtlIDX, B.UserName1 As Player1, B.UserName2 As Player2, B.MemberIdx1 As  memIdx1, B.MemberIdx2 As  memIdx2, "
      strSql = strSql & "        B.TeamName1 As Team1, B.TeamName2 As Team2, B.Team1 As cTeam1, B.Team2 As cTeam2, B.TeamDtl1 As TeamDtl1,B.TeamDtl2 As TeamDtl2, "
			strSql = strSql & "        A.OrderBy "
      strSql = strSql & "        From "
      strSql = strSql & "           ("
      strSql = strSql & "              Select GamelevelDtlIDX, TourneyGroupIDX, Min(OrderBy) As OrderBy  From tblTourney As A "
      strSql = strSql & sprintf("            WHERE A.DelYN = 'N'  AND A.GameLevelDtlidx In ( ({0}) ) ", Array(subSql_person))
      strSql = strSql & "            Group By GamelevelDtlIDX, TourneyGroupIDX"
      strSql = strSql & "           ) As A "
      strSql = strSql & "           Inner Join cte_playerInfo As B "
      strSql = strSql & "           On A.TourneyGroupIDX = B.TourneyGroupIDX"

      strSql = strSql & "   Union All "

      ' 팀전이면..
      strSql = strSql & "     Select GamelevelDtlIDX, '' AS Player1, '' AS Player2, '' AS memIdx1, '' AS memIdx2,		 "
			strSql = strSql & "      Case "
			strSql = strSql & "     	When TeamDtl <> '0' Then (Select TI.TeamNm From tblTeamInfo As TI Where DelYN = 'N' And A.Team = TI.Team) + Cast(TeamDtl As VarChar) "
			strSql = strSql & "     	Else (Select TI.TeamNm From tblTeamInfo As TI Where DelYN = 'N' And A.Team = TI.Team) "
			strSql = strSql & "     End As Team1, '' As Team2, Team As cTeam1, '' As cTeam2, TeamDtl As TeamDtl1, '' As TeamDtl2,  "
			strSql = strSql & "     Min(OrderBy) As OrderBy	 "
			strSql = strSql & "     From tblTourneyTeam As A "
			strSql = strSql & sprintf(" WHERE A.DelYN = 'N'  AND A.GameLevelDtlidx In ( ({0}) ) ", Array(subSql_group))
			strSql = strSql & "     Group By GamelevelDtlIDX, Team, TeamDtl "
      strSql = strSql & "  ) As A "

   If(subSql_person = "" And subSql_group = "") Then strSql = "" End If
      getrSqlLeagueInfoEx = strSql
   End Function

'   ===============================================================================
'      Game League 점수를 얻는다.
'   ===============================================================================
   Function getrSqlLeagueJumsuEx(sqlLvDtlIdx)
      Dim strSql

      strSql = "Select ROW_NUMBER() Over(Partition By GameLevelDtlidx Order By GameOrder) As Idx, *"
      strSql = strSql & "  From ("
      strSql = strSql & "           Select GameLevelDtlidx, L_MemberNames,	L_MemberIDXs, L_TeamNames, L_Teams, L_TeamDtl,"
      strSql = strSql & "              R_MemberNames, R_MemberIDXs, R_TeamNames, R_Teams, R_TeamDtl, "
      strSql = strSql & "              L_SetJumsu	,L_MatchJumsu,	R_SetJumsu,R_MatchJumsu, L_Result, TGT.EnterType, "
			strSql = strSql & "              GameNum As GameOrder, TGO.GameDay, TGO.GameTime "
      strSql = strSql & "              From tblGameOperate As TGO WITH(NOLOCK)"
      strSql = strSql & "           Inner Join tblGameTitle TGT WITH(NOLOCK) On TGT.GametitleIDX = TGO.GametitleIDX And TGT.DelYN = 'N'"
      strSql = strSql & sprintf("      WHERE TGO.DelYN = 'N' AND TGO.GameLevelDtlIDX  In ({0}) ", Array(sqlLvDtlIdx))
      strSql = strSql & "           And TGO.GameType = 'B0040001' "
      strSql = strSql & "           AND ((GroupGameGB = 'B0030001' AND TeamGameNum = '0')) "

      strSql = strSql & "           Union All	"

      strSql = strSql & "           Select GameLevelDtlidx, L_MemberNames,	L_MemberIDXs, L_TeamNames, L_Teams, L_TeamDtl,"
      strSql = strSql & "              R_MemberNames, R_MemberIDXs, R_TeamNames, R_Teams, R_TeamDtl, "
      strSql = strSql & "              L_SetJumsu	,L_MatchJumsu,	R_SetJumsu,R_MatchJumsu, L_Result, TGT.EnterType, "
			strSql = strSql & "              TeamGameNum As GameOrder, TGO.GameDay, TGO.GameTime "
      strSql = strSql & "           From tblGameOperate As TGO WITH(NOLOCK)"
      strSql = strSql & "           Inner Join tblGameTitle TGT WITH(NOLOCK) On TGT.GametitleIDX = TGO.GametitleIDX And TGT.DelYN = 'N'"
      strSql = strSql & sprintf("      WHERE TGO.DelYN = 'N' AND TGO.GameLevelDtlIDX In ({0}) ", Array(sqlLvDtlIdx))
      strSql = strSql & "              And TGO.GameType = 'B0040001' "
      strSql = strSql & "              AND ((GroupGameGB = 'B0030002' AND GameNum = '0')) "
      strSql = strSql & "  ) As A"

      If(sqlLvDtlIdx = "") Then strSql = "" End If
      getrSqlLeagueJumsuEx = strSql
   End Function
%>

<%
'   ===============================================================================
'      Util Function
'   ===============================================================================
   Dim CNT_RESULT_INFO, CNT_GAMEPER_INFO, cntQTournament, cntPrint
   CNT_RESULT_INFO = 6              ' 게임 결과 정보 : 승, 패, 득, 실, 차 , 순위
   CNT_GAMEPER_INFO = 3             ' 각 게임마다 정보 : LScore, RScore, Result
   cntQTournament  = 0              ' 토너먼트 예선전은 2게임 마다 1장씩 프린트 해야 한다. 그때 사용하는 변수
   cntPrint = 0                     ' print count - 프린트 할 갯수가 몇개인가?

'   ===============================================================================
'      순위를 구하기 위한 배열을 구한다 .
'      Rank, Order, Player1, Player2, memIdx1, memIdx2, Team1, Team2, cTeam1, cTeam2, TeamDtl, 승패득실차
'      PlayerInfo + aryInfo
'      승, 패, 득, 실, 차에서
'      패, 실은 적은 값이 더 큰값이므로 sort를 할때 하나의 룰로 만들기 위해 값을 보정한다.
'      패 = 1000 - 패, 실 = 1000 - 실 : 패, 실이 적으면 보정값은 커진다.
'   ===============================================================================
   Function GetAryResultInfo(rAryPlayer, rAryInfo)
      Dim ai, ul, aryGameInfo, info_kind
      info_kind = 16

      ul = UBound(rAryPlayer,2)
      ReDim aryGameInfo(info_kind, ul)

      For ai = 0 To ul
         aryGameInfo(0,ai) = -1
         aryGameInfo(1,ai) = ai+1
         aryGameInfo(2,ai) = rAryPlayer(2,ai)
         aryGameInfo(3,ai) = rAryPlayer(3,ai)
         aryGameInfo(4,ai) = rAryPlayer(4,ai)
         aryGameInfo(5,ai) = rAryPlayer(5,ai)
         aryGameInfo(6,ai) = rAryPlayer(6,ai)
         aryGameInfo(7,ai) = rAryPlayer(7,ai)
         aryGameInfo(8,ai) = rAryPlayer(8,ai)
         aryGameInfo(9,ai) = rAryPlayer(9,ai)
         aryGameInfo(10,ai) = rAryPlayer(10,ai)

         aryGameInfo(11,ai)  = rAryInfo(ul+1,ai)                     '승
     '    aryGameInfo(12,ai) = rAryInfo(ul+2,ai)         '패
         If( IsNull(rAryInfo(ul+2,ai)) ) Then
            aryGameInfo(12,ai) = 0
         Else
            aryGameInfo(12,ai) = 1000 - CDbl(rAryInfo(ul+2,ai))         '패
         End If
         aryGameInfo(13,ai) = rAryInfo(ul+3,ai)                      '득

         If( IsNull(rAryInfo(ul+4,ai)) ) Then
            aryGameInfo(14,ai) = 0
         Else
            aryGameInfo(14,ai) = 1000 - CDbl(rAryInfo(ul+4,ai))         '실
         End If
      '   aryGameInfo(14,ai) = 1000 - CDbl(rAryInfo(ul+4,ai))         '실

         aryGameInfo(15,ai) = rAryInfo(ul+5,ai)                      '차
      Next

      GetAryResultInfo = aryGameInfo
   End Function

   Function ApplyRanking(rAryInfo, rAryResult, pos_rank)
      Dim key, ai, ul, IsDesc, sortDataType, rKey

      key = 1                 ' order key
      sortDataType = 2        ' key가 가리키는 데이터가 숫자이다. 숫자 비교
      IsDesc = 0

      ' order에 의해 sort한다.
      Call Sort2DimAryEx(rAryResult, key, sortDataType, IsDesc)

      ul = UBOUND(rAryInfo, 2)

      key = 1                 ' rank key
      For ai=0 To ul
         rAryInfo(pos_rank, ai) = rAryResult(0, ai)
      Next

   End Function

'   ===============================================================================
'    리그전 - 개인전/팀전 경기 결과를 배열에 담는다.
'     같은 번호는 대각선 값이다. 이값은 비어있다.
'        대각선 위에 있는 값은 Index가 정상 / 대각선 아래에 있는 값은 Index를 뒤집는다. ( 같은 정보를 역으로 뿌려주기 때문 )
'     rAryLeague
'      0-6, L_MemberNames,	L_MemberIDXs, L_TeamNames, L_Teams, L_TeamDtl,  R_MemberNames, R_MemberIDXs,
'      7-15 R_TeamNames, R_Teams, R_TeamDtl,  L_SetJumsu	,L_MatchJumsu,	R_SetJumsu,R_MatchJumsu, L_Result, EnterType
'     rAryPlayer
'       0-9  GamelevelDtlIDX	Player1	Player2	memIdx1	memIdx2	Team1	Team2	cTeam1	cTeam2	TeamDtl
'
'     Score Text LScore, RScore, Result,
'     Reverse일경우 LScore 와 RScore를 바꾸고 , 결과도 바꾼다.
'     점수 * Cnt_rAryPlayer + 승패득실차순위 + (LScore,RScore,Result)*Cnt_rAryPlayer
'   ===============================================================================
   Function SetLeagueGameInfo(rAryLeague, rAryPlayer, rAryInfo, IsTeamGame)
      Dim ai, aj , ul, ul2, infoIdx , idx1, idx2, strScore, bReverse
      Dim pos_base, pos_info, pos_result, game_result, l_score,r_score, entry_type
      Dim cnt_win, cnt_lose, win_score, lose_score, diff_score, order, is_reverse
			Dim gameTime, aryTime
      ul = UBound(rAryPlayer,2)
      ul2 = UBound(rAryInfo,1)
      is_reverse = false

'      strLog = " ------------------------- SetLeagueGameInfo <br>"
'      response.write strLog

		strLog = sprintf("IsTeamGame = {0}", Array(IsTeamGame))
		' ' ' Call TraceLog(SPORTS_LOG1,strLog)
		' ' ' Call TraceLog2Dim(SPORTS_LOG1, rAryLeague, "****SetLeagueGameInfo -- rAryLeague")
		' ' ' Call TraceLog2Dim(SPORTS_LOG1, rAryPlayer, "****SetLeagueGameInfo -- rAryPlayer")

      For ai = 0 To ul
         For aj = 0 To ul
            bReverse = false
            If( ai <> aj ) Then              ' 같은 번호는 대각선 값이다. 이값은 비어있다.
               If( ai > aj ) Then            ' 대각선 위에 있는 값은 Index가 정상
                  idx1 = aj
                  idx2 = ai
                  bReverse = true
               Else                          ' 대각선 아래에 있는 값은 Index를 뒤집는다. ( 같은 정보를 역으로 뿌려주기 때문 )
                  idx1 = ai
                  idx2 = aj
               End If

               If( IsTeamGame = 0 ) Then

                  infoIdx = uxFindPersonGameInfo(rAryLeague, rAryPlayer(4,idx1), rAryPlayer(8,idx1), rAryPlayer(5,idx1), rAryPlayer(9,idx1), _
                                 rAryPlayer(4,idx2), rAryPlayer(8,idx2), rAryPlayer(5,idx2), rAryPlayer(9,idx2), is_reverse )
               Else
                  infoIdx = uxFindTeamGameInfo(rAryLeague, rAryPlayer(8,idx1), rAryPlayer(10,idx1), rAryPlayer(8,idx2), rAryPlayer(10,idx2), is_reverse )
               End If

               ' Score Text LScore, RScore, Result,
               ' Reverse일경우 LScore 와 RScore를 바꾸고 , 결과도 바꾼다.
               ' 점수 * Cnt_rAryPlayer + 승패득실차순위 + (LScore,RScore,Result)*Cnt_rAryPlayer

               ' game_result, l_score,r_score, entry_type
               If(infoIdx <> -1) Then ' 정보를 찾았다. 셋팅을 하자.
                  pos_base = ul + CNT_RESULT_INFO + 1
                  pos_info = pos_base + (aj * CNT_GAMEPER_INFO)
                  entry_type = rAryLeague(15,infoIdx)

                  If( IsNull(rAryLeague(14,infoIdx)) ) Then
                     game_result = -1
                  Else
                     game_result = IsResultWin(rAryLeague(14,infoIdx))
                  End If

                  if(entry_type = "A") Then ' ama이면  score를 L_SetJumsu	,R_SetJumsu로 사용
                     If(IsTeamGame = 1) Then
                        l_score = rAryLeague(11,infoIdx)
                        r_score = rAryLeague(13,infoIdx)
                     Else
                        l_score = rAryLeague(10,infoIdx)
                        r_score = rAryLeague(12,infoIdx)
                     End If
                  Else                      ' elite이면 score를 L_MatchJumsu,	R_MatchJumsu로 사용
                     l_score = rAryLeague(11,infoIdx)
                     r_score = rAryLeague(13,infoIdx)
                  End If

                  If( bReverse = true ) Then       ' 정보를 역으로 바꾸어 저장한다.
                     strScore = strPrintf("{0} - {1}", Array(r_score, l_score))
                     rAryInfo(aj, ai) = strScore
                     rAryInfo(pos_info, ai)     = r_score                        ' LScore
                     rAryInfo(pos_info+1, ai)   = l_score                        ' RScore
                     rAryInfo(pos_info+2, ai)   = Reverse0And1(game_result)      ' Result
                  Else
                     strScore = strPrintf("{0} - {1}", Array(l_score, r_score))
                     rAryInfo(aj, ai) = strScore
                     rAryInfo(pos_info, ai)     = l_score                        ' LScore
                     rAryInfo(pos_info+1, ai)   = r_score                        ' RScore
                     rAryInfo(pos_info+2, ai)   = game_result                    ' Result
                  End If

									' 아마추어 대회이고 , 게임 성적이 둘다 없으면 게임 시작 전이라 가정하고 게임 시간을 뿌려준다.
									If(entry_type = "A") And (AmaTimeOnly = 1)Then
										gameTime	= rAryLeague(18,infoIdx)
										l_player  = rAryLeague(0,infoIdx)
										r_player  = rAryLeague(5,infoIdx)

										l_player = Replace(l_player, "|", ",")
										r_player = Replace(r_player, "|", ",")
										strScore = sprintf("{0}|{1}|{2}", Array(gameTime, l_player, r_player))
										rAryInfo(aj, ai) = strScore
									End If
               End If
            Else
               rAryInfo(aj, ai) = "-"
               rAryInfo(ul+1, ai) = -1
            End If
         Next
      Next

      ' 승,패,득,실,차,순위 계산
      pos_result = ul+1
      For ai = 0 To ul
         cnt_win     = 0
         cnt_lose    = 0
         win_score   = 0
         lose_score  = 0
         diff_score  = 0

         pos_base = ul + CNT_RESULT_INFO + 1
         For aj = pos_base To ul2  step CNT_GAMEPER_INFO
            l_score        = rAryInfo(aj, ai)                        ' LScore
            r_score        = rAryInfo(aj+1, ai)                      ' RScore
            game_result    = rAryInfo(aj+2, ai)                      ' Result

            If( game_result <> -1 And game_result <> "") Then
               If(game_result = 1) Then
                  cnt_win     =  cnt_win + 1
               ElseIf(game_result = 0) Then
                  cnt_lose    =  cnt_lose + 1
               End If

               win_score      = win_score + l_score
               lose_score     = lose_score + r_score
            End If
         Next
         diff_score = win_score - lose_score

         rAryInfo(pos_result, ai)      = cnt_win         ' 승
         rAryInfo(pos_result+1, ai)    = cnt_lose        ' 패
         rAryInfo(pos_result+2, ai)    = win_score       ' 득
         rAryInfo(pos_result+3, ai)    = lose_score      ' 실
         rAryInfo(pos_result+4, ai)    = diff_score      ' 차
      Next
   End function

   Function printInfo(rAryInfo)
      Dim ai, aj , ul, ul2, strInfo
      ul = UBound(rAryInfo,2)
      ul2 = UBound(rAryInfo,1)

      strLog = " ------------------------- printInfo  <br>"
      response.write strLog

      strInfo = ""

      For ai = 0 To ul
         strInfo = ""
         For aj = 0 To ul2
            strInfo = strPrintf("{0} ({1},{2})", Array(strInfo, aj, rAryInfo(aj, ai)))
         Next
         response.write strInfo & "<br>"
      Next

      strLog = " ------------------------- printInfo  <br>"
      response.write strLog
   End Function

'   ===============================================================================
'      AryGameInfo를 받아서 Game Info String을 구한다.
'    Sex, PlayType, TeamGb, Level, LevelJooName, GameType, LevelJooNum, LevelJooNumDtl, LevelDtlName, PlayLevelType, GroupGameGb, TotRound
'   ===============================================================================
   Function getGameInfoStr(rAryGInfo)
      Dim strSex, strPlayType, strTeamGb, strLevel, strLevelJoo, strLevelJooNum, strLevelJooNumDtl
      Dim playLvType, lvJooNum, lvJooNumDtl, strPlayLvType, strInfo

      strSex               = rxPubGetName(rAryGInfo(2))
      strPlayType          = rxPubGetName(rAryGInfo(3))
      strTeamGb            = rxTeamGBGetName(rAryGInfo(4))
      strLevel             = rxLevelName(rAryGInfo(5))
      strLevelJoo          = rxPubGetName(rAryGInfo(6))
      lvJooNum             = rAryGInfo(8)
      lvJooNumDtl          = rAryGInfo(9)

      playLvType           = rAryGInfo(11)
      strPlayLvType        = "본선"
      If(playLvType = "B0100001") Then
         strPlayLvType = sprintf("예선 {0}조", Array(lvJooNumDtl))
      End If

      strInfo = sprintf("[{0}{1} {2} {3} {4}{5} {6}]", Array(strSex, strPlayType, strTeamGb, strLevel, strLevelJoo, lvJooNum, strPlayLvType))
      getGameInfoStr = strInfo
   End Function

'   ===============================================================================
'      참가선수(팀) string을 구한다.
'   ===============================================================================
   Function getCntPlayerStr(cntPlayer, groupGameGb)
      Dim strInfo
      If(groupGameGb = "B0030001") Then
         strInfo = sprintf("참가선수: {0}명", Array(cntPlayer))
      Else
         strInfo = sprintf("참가선수: {0}팀", Array(cntPlayer))
      End If
      getCntPlayerStr = strInfo
   End Function

'   ===============================================================================
'      포함하고 있는 SubAry Count를 반환한다.
'   ===============================================================================
   Function CntSubAry(rAry)
      Dim Idx, ub, cntAry
      cntAry = 0

      If(IsArray(rAry)) Then
         ub = UBound(rAry, 2)
         cntAry = 1

         ReDim aryTmp(2, ub)

         For Idx = 0 To ub
            If(Idx <> 0) And (rAry(0, Idx) = "1") Then
               cntAry = cntAry + 1
            End If
         Next
      End If

      CntSubAry = cntAry
   End Function

'   ===============================================================================
'      엘리트 이고 League일 경우 - 헤더에 승,패,득,실,차,순위 를 추가해 준다.
'   ===============================================================================
	Function MakeHeader(rAryLeague, GroupGameGb, EnterType)
		Dim ub, cb, Idx, add_col, aryHdr, aryAdd, k
		aryAdd = Array("승", "패", "득", "실", "승점", "순위")

		add_col = UBound(aryAdd) + 1

		ub = UBound(rAryLeague, 2)
		cb = ub

		If(EnterType = "E") Then cb = ub + add_col End If

		ReDim aryHdr(cb)

		For Idx = 0 To ub
			If(GroupGameGb = "B0030001") Then 		' 개인전
				If(rAryLeague(3,Idx) <> "") And (Not IsNull(rAryLeague(3,Idx)) ) Then
					aryHdr(Idx) = sprintf("{0},{1}|{2},{3}", _
						Array(TeamGBtoSimple(aryTmp(2,Idx)), TeamGBtoSimple(aryTmp(6,Idx)), TeamGBtoSimple(aryTmp(3,Idx)), TeamGBtoSimple(aryTmp(7,Idx)) ))
				Else
					aryHdr(Idx) = sprintf("{0},{1}", Array(TeamGBtoSimple(aryTmp(2,Idx)), TeamGBtoSimple(aryTmp(6,Idx)) ))
				End If
			Else
				aryHdr(Idx) = sprintf("{0}", Array(TeamGBtoSimple(aryTmp(6,Idx)) ))
			End If
		Next

		If(EnterType = "E") Then
			k = 0
			For Idx = ub+1 To cb
				aryHdr(Idx) = aryAdd(k)
				k = k + 1
			Next
		End If

		MakeHeader = aryHdr
	End Function

'   ===============================================================================
'      header Text Format = p1_name,p1_team|p2_name,p2_team
'      header Text에서 p1_name, p1_team, p2_name, p2_team을 분리해 낸다.
'   ===============================================================================
	Function ExtractHeader(strHeader, p1_name, p1_team, p2_name, p2_team)
		p1_name = ""
		p1_team = ""
		p2_name = ""
		p2_team = ""

		If( InStr(strHeader, "|") ) Then
			aryPlayer = Split(strHeader, "|")
			If( InStr(aryPlayer(0), ",") ) Then
				aryData = Split(aryPlayer(0), ",")
				p1_name = aryData(0)
				p1_team = aryData(1)
			Else
				p1_name = aryPlayer(0)
				p1_team	= ""
			End If

			If( InStr(aryPlayer(1), ",") ) Then
				aryData = Split(aryPlayer(1), ",")
				p2_name = aryData(0)
				p2_team = aryData(1)
			Else
				p2_name = aryPlayer(1)
				p2_team	= ""
			End If
		Else
			If( InStr(strHeader, ",") ) Then
				aryData = Split(strHeader, ",")
				p1_name = aryData(0)
				p1_team = aryData(1)
			Else
				p1_name = strHeader
				p1_team	= ""
			End If
		End If
	End Function

'   ===============================================================================
'      header Text Format = p1_name,p1_team|p2_name,p2_team
'      header Text에서 p1_name, p1_team, p2_name, p2_team을 분리해 낸다.
'   ===============================================================================
  Function GetTourneyDisplayType(rAryInfo)
		Dim viewType, IsDbl, nRound, playType, Idx, ub
		Dim round32D, round64D, round64S, round128S

		round32D 	= 		0
		round64D 	= 		0
		round64S 	= 		0
		round128S = 		0
		IsDbl		 	= 		0
		viewType	= 		0

		ub = UBound(rAryInfo, 2)

		For Idx = 0 To ub
			playType    = rAryInfo(3, Idx)
			nRound      = rAryInfo(13, Idx)
			nRound			= CDbl(nRound)

			IsDbl = 0 
			If(playType = "B0020002") Then IsDbl = 1	End If


			If(IsDbl = 1) And (nRound = 32) 	Then round32D = 1 End If
			If(IsDbl = 1) And (nRound = 64) 	Then round64D = 1 End If
			If(IsDbl = 0) And (nRound = 64) 	Then round64S = 1 End If
			If(IsDbl = 0) And (nRound = 128) 	Then round128S = 1 End If
		Next

		If(round128S = 0 And round64S = 0 And round64D = 0 And round32D = 1) Then
			viewType = 1
		ElseIf(round128S = 0 And round64S = 0 And round64D = 1 And round32D = 0) Then
			viewType = 2
		ElseIf(round128S = 0 And round64S = 0 And round64D = 1 And round32D = 1) Then
			viewType = 3
		ElseIf(round128S = 0 And round64S = 1 And round64D = 0 And round32D = 0) Then
			viewType = 4
		ElseIf(round128S = 0 And round64S = 1 And round64D = 0 And round32D = 1) Then
			viewType = 5
		ElseIf(round128S = 0 And round64S = 1 And round64D = 1 And round32D = 0) Then
			viewType = 6
		ElseIf(round128S = 0 And round64S = 1 And round64D = 1 And round32D = 1) Then
			viewType = 7
		ElseIf(round128S = 1 And round64S = 0 And round64D = 0 And round32D = 0) Then
			viewType = 8
		ElseIf(round128S = 1 And round64S = 0 And round64D = 0 And round32D = 1) Then
			viewType = 9
		ElseIf(round128S = 1 And round64S = 0 And round64D = 1 And round32D = 0) Then
			viewType = 10
		ElseIf(round128S = 1 And round64S = 0 And round64D = 1 And round32D = 1) Then
			viewType = 11
		ElseIf(round128S = 1 And round64S = 1 And round64D = 0 And round32D = 0) Then
			viewType = 12
		ElseIf(round128S = 1 And round64S = 1 And round64D = 0 And round32D = 1) Then
			viewType = 13
		ElseIf(round128S = 1 And round64S = 1 And round64D = 1 And round32D = 0) Then
			viewType = 14
		ElseIf(round128S = 1 And round64S = 1 And round64D = 1 And round32D = 1) Then
			viewType = 15
		End If

		GetTourneyDisplayType = viewType
	End Function

	Function GetPlayerCnt(rAryCnt, lvDtlIdx)
		Dim player_cnt, Idx, ub

		player_cnt  = 0

		If( IsArray(rAryCnt)) Then
			ub = UBound(rAryCnt, 2)

			'Call webLog(lvDtlIdx)
			'Call webLog2Dim(rAryCnt, "GetPlayerCnt --rAryCnt " )
			'response.end

			For Idx = 0 To ub
				If(CStr(rAryCnt(1, Idx)) = CStr(lvDtlIdx)) Then
					player_cnt = rAryCnt(0, Idx)
					Exit For
				End If
			Next
		End If

		GetPlayerCnt = player_cnt
	End Function

	Function GetAryGameInfo(rAryInfo, lvDtlIdx)
		Dim aryInfo, Idx, ub, ub2, aryTmp

		If( IsArray(rAryInfo)) Then
			ub = UBound(rAryInfo, 2)
			ub2 = UBound(rAryInfo, 1)

			ReDim aryInfo(ub2)

			For Idx = 0 To ub
				If( CStr(rAryInfo(1, Idx)) = CStr(lvDtlIdx) ) Then
					For k = 0 To ub2
						aryInfo(k) = rAryInfo(k,Idx)
					Next

					Exit For
				End If
			Next
		End If

		'strLog = sprintf("GetAryGameInfo --rAryInfo, lvDtlIdx = {0}", array(lvDtlIdx))
		'Call webLog1Dim(aryInfo, 10, strLog )

		GetAryGameInfo = aryInfo
	End Function
%>

<%
'   ===============================================================================
'      Data Process
'   ===============================================================================
   Dim aryLvDtlIdx, aryGameInfo, aryCntPlayer, aryTournament, aryLeague, aryLeagueJumsu

   Dim aryFullGameInfo, aryFullCntPlayer, aryFullTournament, aryFullLeague, aryFullLeagueJumsu
   Dim errNo , gameTitleName, subSql_person, subSql_group
   Dim ub, Idx
   errNo = 0

   '   ===============================================================================
   '      Get Array LevelDtlIdx
   '   ===============================================================================
   strSql = getSqlDtlIdx(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX)
   subSql = strSql
   strLog = strPrintf("GameTitleIDX  = {0}, GameLevelIDX  = {1}, GameLevelDtlIDX  = {2}", Array(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX))
   ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog)
   strLog = strPrintf("getSqlDtlIdx Sql  = {0}", Array(strSql))
   ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog)
   If(strSql <> "") Then
      Set rs = Dbcon.Execute(strSql)
      If Not(rs.Eof Or rs.Bof) Then
         aryLvDtlIdx = rs.GetRows()
         rs.Close
      Else
         errNo = 1
      End If
   Else
      errNo = 2
   End If

   If(errNo <> 0) Then
      Response.Write "ERR:[0]등록된종목없음"
		Response.END
   End If


   '   ===============================================================================
   '      Get Game Title Name
   '   ===============================================================================
   strSql = getSqlTitleInfo(aryLvDtlIdx(0,0))
   strLog = strPrintf("getSqlTitleInfo Sql  = {0}", Array(strSql))
   ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog)
   If(strSql <> "") Then
      Set rs = Dbcon.Execute(strSql)
      If Not(rs.Eof Or rs.Bof) Then
         gameTitleName = rs("GameTitleName")
         rs.Close
      End If
   End If

   '   ===============================================================================
   '      Get Game Info - gameinfo, tonament info, league info
   '   ===============================================================================
   Dim gameLvDtlIdx , groupGameGb, gameType, cntPlayer, playLvType
   Dim cntTournament, cntLeague

   cntTournament = 0
   cntLeague = 0

   ub = UBound(aryLvDtlIdx, 2)

   '   ===============================================================================
   '      한방 쿼리 - Get Player Count
   '   ===============================================================================
   subSql_person = getSubSqlDtlIdx(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX, "", "B0030001")      ' 개인전
   subSql_group  = getSubSqlDtlIdx(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX, "", "B0030002")      ' 단체전
   strSql = getrSqlCountPlayerEx(subSql_person, subSql_group)
   strLog = strPrintf("getrSqlCountPlayerEx Sql  = {0}", Array(strSql))
   'Call TraceLog(SPORTS_LOG1, strLog)

   If(strSql <> "") Then
      Set rs = Dbcon.Execute(strSql)
      If Not(rs.Eof Or rs.Bof) Then
            aryFullCntPlayer = rs.GetRows()
         rs.Close
      End If
   End If

   '   ===============================================================================
   '      한방 쿼리 - Get GameInfo
   '   ===============================================================================
   strSql = getrSqlGameInfoEx(subSql)
   strLog = strPrintf("getrSqlGameInfoEx Sql  = {0}", Array(strSql))
   ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog)
   If(strSql <> "") Then
      Set rs = Dbcon.Execute(strSql)
      If Not(rs.Eof Or rs.Bof) Then
            aryFullGameInfo = rs.GetRows()
         rs.Close
      End If
   End If

   '   ===============================================================================
   '      한방 쿼리 - League 점수
   '   ===============================================================================
   subSql = getSubSqlDtlIdx(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX, "B0040001", "")      ' 리그
   strSql = getrSqlLeagueJumsuEx(subSql)
   strLog = strPrintf("getrSqlLeagueJumsuEx Sql  = {0}", Array(strSql))
   ' ' Call TraceLog(SPORTS_LOG1, strLog)
   If(strSql <> "") Then
      Set rs = Dbcon.Execute(strSql)
      If Not(rs.Eof Or rs.Bof) Then
         aryFullLeagueJumsu  = rs.GetRows()
         rs.Close
      End If
   End If

   '   ===============================================================================
   '      한방 쿼리 - League User
   '   ===============================================================================
   subSql_person = getSubSqlDtlIdx(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX, "B0040001", "B0030001")      ' 리그 - 개인전
   subSql_group  = getSubSqlDtlIdx(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX, "B0040001", "B0030002")      ' 리그 - 단체전

   strSql = getrSqlLeagueInfoEx(subSql_person, subSql_group)
   strLog = strPrintf("getrSqlLeagueInfoEx Sql  = {0}", Array(strSql))
   ' ' Call TraceLog(SPORTS_LOG1, strLog)

   If(strSql <> "") Then
      Set rs = Dbcon.Execute(strSql)
      If Not(rs.Eof Or rs.Bof) Then
         aryFullLeague  = rs.GetRows()
         rs.Close
      End If
   End If

   'response.end



   '   ===============================================================================
   '      한방 쿼리 - Tournament User
   '   ===============================================================================
   subSql_person = getSubSqlDtlIdx(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX, "B0040002", "B0030001")      ' 토너먼트 - 개인전
   subSql_group  = getSubSqlDtlIdx(GameTitleIDX, GameLevelIDX, GameLevelDtlIDX, "B0040002", "B0030002")      ' 토너먼트 - 단체전
   strSql = getrSqlTournamentInfoEx(subSql_person, subSql_group)

   strLog = strPrintf("getrSqlTournamentInfoEx Sql  = {0}", Array(strSql))
'   ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog)
   If(strSql <> "") Then
      Set rs = Dbcon.Execute(strSql)
      If Not(rs.Eof Or rs.Bof) Then
         aryFullTournament  = rs.GetRows()
         rs.Close
      End If
   End If

	 ' response.end

   '   ===============================================================================
   '      한방 쿼리데이터를 개별 Array로 분리 한다.
   '   ===============================================================================
   eQueryTimer = Timer()
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">

  <script type="text/javascript" src="/js/jquery-1.12.2.min.js"></script>
  <script type="text/javascript" src="/dev/dist/Common_Js.js" ></script>
  <script type="text/javascript" src="/js/CommonAjax.js?ver=1.0"></script>
  <script type="text/javascript" src="/js/bdadmin.js"></script>
  <script type="text/javascript" src="/pub/js/etc/tournament_modify/tournament.js"></script>
  <script type="text/javascript" src="/pub/js/etc/utx.js<%=UTX_JSVER%>"></script>
  <script type="text/javascript" src="/pub/js/etc/bmx.js<%=BMX_JSVER%>"></script>
  <script type="text/javascript" src="/pub/js/etc/ctx.js<%=CTX_JSVER%>"></script>
  <script type="text/javascript" src="/pub/js/badmt/bmutx.js<%=BMUTX_JSVER%>"></script>

  <script type="text/javascript" src="/js/GameTitleMenu/LotteryElite.js?ver=1.1.7"></script>

  <link rel="stylesheet" href="/css/lib/jquery-ui.min.css">
   <link rel="stylesheet" href="/css/lib/bootstrap-datepicker.css">
   <link rel="stylesheet" type="text/css" href="/css/bootstrap.css">
   <link rel="stylesheet" type="text/css" href="/css/fontawesome-all.css">
   <link rel="stylesheet" type="text/css" href="/css/style.css">
   <link rel="stylesheet" href="/pub/js/etc/tournament_modify/tournament.css">

   <!-- sd_admin.css -->
   <link rel="stylesheet" type="text/css" href="/css/admin/admin.d.style.css">

   <style>
		*{margin:0;padding:0;}
		html{width:210mm;height:100%;font-family:Calibri, Arial, Helvetica, sans-serif;background-color:white;}

		body{width:210mm;}
		table{border-collapse:collapse;}
		li{list-style:none;}
		.wrapper{width:100%;padding-top:3mm;box-sizing:border-box;}

		.header{position:relative;text-align:left;border-bottom:.5mm solid #333;box-sizing:border-box;}
		.header>.title{font-size:10pt;font-weight:bold;}
		.header>.moreInfo{position:relative;margin-bottom:1mm;}
		.header>.moreInfo>.team{max-width:117mm;font-weight:700;font-size:10pt;margin:auto;margin-right:5mm;}
		.header>.moreInfo>.attend{font-size:9pt;font-weight:700;}
		.header>.moreInfo>.attend>span{font-weight:400;text-decoration:underline;}

		.main{width:100%;}

		.footer{position:relative;height:15mm;border-top:2px solid #333;padding-top:2mm;overflow:hidden;box-sizing:border-box;}
		.footer>.bot_logo{float:left;}
		.footer>.bot_logo>img{height:12mm;}
		.footer>.print_date{float:right;}
    .footer>.print_date>img{height:12mm;}
    .main.tournamentTree{margin-left:0px;}
   </style>

	<style type="text/css" media="print" id = "id_print_cust">
		/* @page port {size: portrait;}
		@page land {size: landscape;}
		.portrait {page: port;}
		.landscape {page: land;} */

		/* @media print{
			@page {
				size: landscape
			} */


		}
	</style>



<style>
	html,body{height:100%;}
	html, body, div, ul, li, dl, dd, p, h1, h2, h3, h4, h5, h6, span, table, tr, td, th{padding:0;margin:0;}
	li{list-style:none;}
	input,select{height:35px;line-height:35px;border:1px solid #ddd;padding:5px;}

	.lotteryElite .content-warp .btn-box{display:table;width:100%;margin-top:10px;text-align:right;}
	.lotteryElite .content-warp .btn-box a{line-height:35px;background:#2f6fc1;color:#fff;min-width:100px;padding:0 15px;font-size:14px;text-align:center;border-radius:3px;margin:0 3px;}

	.lotteryElite{min-width:1200px;}
	.lotteryElite .top-title{background: #0f335b;line-height:50px;text-align:center;color:#fff;font-size:18px;font-family: 'NanumGothicB';}
	.lotteryElite .content-warp{display:table;width:100%;padding:15px;max-width:1600px;margin:auto;min-width:1200px;}
	.lotteryElite .left-con{float:left;width:49%;}

	.lotteryElite .left-con .title{position:relative;line-height:40px;background:#2f6fc1;color:#fff;text-align:center;font-size:16px;font-family:'NanumGothicB';}
	.lotteryElite .left-con .title__inp{background-color:#2f6fc1;color:#fff;height:40px;border:2px solid #2f6fc1;outline:none;padding-left:10px;padding-right:60px;}
	.lotteryElite .left-con .title__inp:focus{background-color:#fff;color:#000;}
	.lotteryElite .left-con .title__inp::placeholder{color:#fae05a;}
	.lotteryElite .left-con .title__inp:focus::placeholder{color:#bdbdbd;}
	.lotteryElite .left-con .title__inp~.dropdown-menu{width:100%;color:#000;padding:0 10px;}
	.lotteryElite .left-con .title__inp:focus~.title__toggle{display:none;}
	.lotteryElite .left-con .title__toggle{position:absolute;width:60px;padding:0 5px;box-sizing:border-box;right:0;top:0;font-size:12px;background:none;border:0;}

	.lotteryElite .left-con .top-search{position:relative;background:#dbe1e8;display:table;width:100%;padding:15px;display:block;border: 1px solid #ccc;border-bottom:0;}
	.lotteryElite .left-con .top-search.on{display:none;}
	.lotteryElite .left-con .top-search .in-se-list{float:left;width:49%;box-sizing: border-box;}
	.lotteryElite .left-con .top-search .in-se-list li{padding:0 5px;box-sizing: border-box;margin-bottom:5px;display:table;width:100%;}
	.lotteryElite .left-con .top-search .in-se-list li:last-child{margin-bottom:0;}
	.lotteryElite .left-con .top-search .in-se-list li .l-name{float:left;width:30%;line-height:35px;color:#333;font-size:14px;font-family: 'NanumGothicB';}
	.lotteryElite .left-con .top-search .in-se-list li .r-con{float:left;width:70%;}
	.lotteryElite .left-con .top-search .in-se-list li .r-con input{width:100%;background:#fff;}
	.lotteryElite .left-con .top-search .in-se-list li .r-con input~.dropdown-menu{width:100%;}
	.lotteryElite .left-con .top-search .in-se-list li .r-con select{width:100%;background:#fff;}


	.lotteryElite .left-con .top-search .r-ranking-box{float:left;width:49%;box-sizing: border-box;margin-left:2%;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab{font-size:16px;font-family:'NanumGothicB';line-height:35px;background:#758290;color:#fff;text-align:center;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__radio.s_igno{position:relative;top:3px;margin-left:5px;cursor:pointer;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__menu{margin:10px 5px 10px 0px;cursor:pointer;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__panel{display:none;border-top:1px solid #fff;margin:0 10px;padding:10px 0;font-size:14px;overflow:hidden;}
	.lotteryElite .left-con .top-search .r-ranking-box #AssignAuto:checked ~ .tab__panel.s_auto{display:block;}
	.lotteryElite .left-con .top-search .r-ranking-box #AssignCheck:checked ~ .tab__panel.s_check{display:block;}
	.lotteryElite .left-con .top-search .r-ranking-box #AssignMenual:checked ~ .tab__panel.s_menual{display:block;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__panel label{float:left;display:block;width:29%;margin:0 0 0 3%;line-height:24px;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__panel label span{display:inline-block;width:70%;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__panel label input{position:relative;top:4px;}

	.lotteryElite .left-con .middle-btns{width:100%;margin-top:10px;}
	.lotteryElite .left-con .middle-btns button{width:50%;height:30px;background-color:#2F6FC1;color:#fff;border:0;}
	.lotteryElite .left-con .middle-btns button.s_active{background-color:#ff8300;}

	.lotteryElite .left-con .bottom-list{padding:15px;background:#f2f2f2;background:#fffaf5;overflow:auto;border: 1px solid #ccc;}

	.lotteryElite .right-con{float:left;width:49%;margin-left:2%;}
	.lotteryElite .right-con .searching{position:relative;}
	.lotteryElite .right-con .searching__input{padding-left:30px;}
	.lotteryElite .right-con .searching__del{position:absolute;width:30px;left:0;top:0;bottom:0;margin:auto;font-size:14px;color:#ddd;background:none;border:none;}
	.lotteryElite .right-con .searching__del:hover{color:#333;}

	.lotteryElite .right-con .entryBox{border: 1px solid #758290;margin-top:10px;display:inline-block;width:100%;text-align:center;}
	.lotteryElite .right-con .entryBox__header,
	.lotteryElite .right-con .entryBox__footer{background:#758290;color:#fff;font-family:'NanumGothicB';width:100%;line-height:41px;}
	.lotteryElite .right-con .entryBox__body{overflow:auto;max-height:714px;height:100%;}
	.lotteryElite .right-con .entryBox__row{display:table;width:100%;border-bottom:1px solid #ddd;}
	.lotteryElite .right-con .entryBox__col{float:left;overflow:hidden;}
	.lotteryElite .right-con .entryBox__header .entryBox__col:nth-child(1){width:20%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__header .entryBox__col:nth-child(2){width:65%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__header .entryBox__col:nth-child(3){width:15%;}
	/* .lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1){width:20%;border-right:1px solid #eee; line-height:112px;} */
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1){width:20%;border-right:1px solid #eee;height:112px;display:flex;align-items:center;}
  .lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1)>span{margin:auto;}
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(2){width:65%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(3){width:15%;line-height:102px;}
	.lotteryElite .right-con .entryBox__footer .entryBox__row{border-bottom:0;}
	.lotteryElite .right-con .entryBox__footer .entryBox__col:nth-child(1){width:85%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__footer .entryBox__col:nth-child(2){width:15%;}
	.lotteryElite .right-con .entry{width:100%;padding:16px 10px;white-space:nowrap;overflow:auto;line-height:normal;text-align:left;}
	.lotteryElite .right-con .entry__item{text-align:center;display:inline-block;width:70px;background:#dbe1e8;border-radius:3px;padding:5px;border:0;margin:1px;}
	.lotteryElite .right-con .entry__item.s_related{background:#ff8300;color:#fff;font-family:'NanumGothicB';user-select: none;cursor:pointer;}
	.lotteryElite .right-con .entry__item.s_related input{color:#333;}
	.lotteryElite .right-con .entry__item.s_selected{border:1px dashed #dbe1e8;background:#f5f5f5;color:#bdbdbd;}
	.lotteryElite .right-con .entry__input{max-width:60px;line-height:26px;height:26px;border:0;margin-top:5px;text-align:center;}
	.lotteryElite .right-con .entry__matchNo{height:26px; line-height:26px;}


	.modal-warp{display:none;}
	.modal-warp.on{position:fixed;top:50%;left:0;right:0;margin:auto;width:100%;background:#fff;padding:20px; -webkit-box-shadow: 0px 0px 10px;-moz-box-shadow: 0px 0px 10px;box-shadow: 0px 0px 10px;border-radius:3px;}
	.fixed-bg.on{position:fixed;width:100%;height:100%;background:#000;top:0;left:0;opacity:0.8;}

	.modal-warp.modal-one{text-align:center;max-width:300px;margin-top:-78px;}
	.modal-warp.modal-one .p-name{color:#387cb0;font-family:'NanumGothicB';font-size:16px;}
	.modal-warp.modal-one .p-ranking{font-size:20px;font-family:'NanumGothicB';color:#333;margin:15px 0;  }
	.modal-warp.modal-one .btn{min-width:80px;}
	.modal-warp.modal-tow{text-align:center;max-width:300px;margin-top:-78px;}
	.modal-warp.modal-tow select{width:100%;margin-bottom:10px;}
	.modal-warp.modal-tow .p-txt span{font-family:'NanumGothicB';}
	.modal-warp.modal-tow .b-txt{margin-top:15px;}
	.modal-warp.modal-tow .btn-box .btn{min-width:80px;}
	.modal-warp.modal-three{text-align:center;max-width:300px;margin-top:-78px;}
	.modal-warp.modal-three .btn-box{margin-top:10px;}
	.modal-warp.modal-three .btn-box .btn{min-width:80px;}
	.modal-warp.modal-three .red-font{color:#e60000;}

	.modal-warp.modal-four{text-align:center;max-width:300px;margin-top:-78px;}
	.modal-warp.modal-four .btn-box{margin-top:10px;}

	::-webkit-scrollbar {
		width: 4px;
		height:10px;
		background: none;
	}
	::-webkit-scrollbar-thumb {
	    background: #ddd;
	    opacity: .4;
	}
	::-webkit-scrollbar-track {
	    background: none;
	}
	.bg-title{background:#758290;}
</style>
<style>

	.lotteryMatch{ position:absolute; width:100%; height:44px; margin:auto; box-sizing:border-box; overflow:hidden;
		border-color:#f2f2f2; border-style:solid;
		display:flex;
		opacity:0.5;
	}
  .tour_single .lotteryMatch{height:22px;}
	.lotteryMatch.s_selected{border:2px solid #ff8300;}
	.lotteryMatch.s_duplicate{border:2px solid #2db23c;}

	/* !@# */
	.lotteryMatch.s_filled{opacity:1;}

	.lotteryMatch_first{ bottom:50%;
		/* border-width:0 0 1px 0; */
		/* border-radius:4px 4px 0 0; */
	}
	.lotteryMatch_second{ top:50%;
		/* border-width:1px 0 0 0; */
		/* border-radius:0 0 4px 4px; */
	}

  .lotteryMatch_first .lotteryMatch__seedWrap{ bottom:50%;
    border-style:solid;
    border-width:1px 1px 1px 1px;
    /* border-radius:4px 0px 0 0; */
    border-color:#ccc;
  }
  .lotteryMatch_second .lotteryMatch__seedWrap{ top:50%;
    border-style:solid;
    border-width:0px 1px 1px 1px;
    /* border-radius:0 0 0px 4px; */
    border-color:#ccc;
  }
  .lotteryMatch_first .lotteryMatch__playerWrap{ bottom:50%;
    border-style:solid;
    border-width:1px 1px 1px 0;
    border-color:#ccc;
    /* border-radius:0 4px 0 0px; */
  }

.lotteryMatch__score{width:30px;text-align:center;border:1px solid #ccc;border-left:none;}
.tournament__block.tournament__block_3 .lotteryMatch__playerWrap,
.tournament__block.tournament__block_4 .lotteryMatch__playerWrap,
.tournament__block.tournament__block_5 .lotteryMatch__playerWrap,
.tournament__block.tournament__block_6 .lotteryMatch__playerWrap{width:89%;border-left:1px solid #ccc;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;}

  .lotteryMatch_second .lotteryMatch__score{border-top:none;}
  .lotteryMatch_second .lotteryMatch__playerWrap{ top:50%;
    border-style:solid;
    border-width:0px 1px 1px 0;
    border-color:#ccc;
    /* border-radius:0 0 4px 0px; */
  }

	.lotteryMatch__seedWrap1{
		display:block;
		width:16%;
		height:100%; text-align:left; text-indent:5px; font-size:13px; letter-spacing:-0.05em; line-height:26px;
	}
	.lotteryMatch__seedWrap{
		flex:none;
		display:block;
    /* width:15%; */
    width:28px;
		height:100%; text-align:left; text-align:center;text-indent:-2px; font-size:13px; letter-spacing:-0.05em; line-height:26px;
		background-color:#dbe1e8;
  }
  .lotteryMatch__seedWrap.f_span{padding:0 5px 0 0;box-sizing:border-box;width:38px;border:none;/* border-bottom:1px solid #ccc; */font-size:12px;text-align:right;}
	.lotteryMatch__playerWrap{
		display:flex;flex-direction:column;justify-content:center;
    /* width:64%; */
    width:calc(100% - 86px);
		height:100%;padding:0 4px;box-sizing:border-box;text-align:left;
		background-color:#b3c1d1;
		background-color:#b6c3d2;
		flex:none;
  }
	.lotteryMatch__playerInner{
		width:100%;display:block;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;
	}
	.lotteryMatch__player{display:inline;font-size:13px;font-weight:700;line-height:18px;}
  .lotteryMatch__belong{display:inline;font-size:12px;line-height:18px;}
  .vs64 .lotteryMatch__player{font-size:15px;}
  .vs64 .lotteryMatch__belong{font-size:14px;}

  .bocsic.modal-warp{max-width:400px;}

  /* @media print{ */
    .lotteryMatch{border:1px solid #ccc;border:none;}
    .lotteryMatch+.lotteryMatch{border-top:none;}
    .lotteryMatch__seedWrap, .lotteryMatch__playerWrap{background-color:transparent;}
    .round_line, .round_line+.tournament__round{margin-top:-1px;}
    /* } */
    .tournament_info{margin-top:10px;border-bottom: 2px solid #333;}
    .tournament_info~.tournament_info{margin-top:20px;}
    .tournament_info h3{font-size:15px;font-weight:bold;}
    .tournament_info p{}
    .tournament_info strong{}
    .tournament_info span{margin-left:20px;text-decoration:underline;}
</style>
	 <!-- league -->
	 <style>
		 .main.league{margin:2mm 0 5mm 0mm;padding:0 3mm;position:relative;display:flex;align-items:center;box-sizing:border-box;}
		 .main.league>div{width:100%;}
		 .main.league table{width:100%;}
		 .main.league table th{min-width:9mm;height:12mm;text-align:center;border:.1mm solid #333;font-size:11pt;line-height:1.2;padding:0;line-height:1.2;vertical-align:middle;border-top-color:#333;font-family:Calibri, Arial, Helvetica, sans-serif;}
		 .main.league table td{height:12mm;text-align:center;border:.1mm solid #333;font-size:14pt;font-family:Calibri, Arial, Helvetica, sans-serif;vertical-align:middle;}
     .sil{width:10mm;}
     *{font-family:Calibri, Arial, Helvetica, sans-serif!important;}
     .main.league .line_area .table td>div{font-size:11pt;}

     .main.league .league_first{width:22mm;}
     .main.league .league_etc{width:9mm;}
     .main.league .league_cnt{width:20mm;}
     .main.league .league_cnt4{width:19mm;}
     .main.league .league_cnt5{width:19mm;}
     .main.league .league_cnt6{width:19mm;}
     .main.league .league_cnt7{width:19mm;}
     .main.league .league_cnt8{width:19mm;}
     .main.league .league_etc_cell{padding:0;font-size:11pt;}
	 </style>

	 <style>
      .print_div{margin:15px 0;text-align:right;}
      .print_btn{margin-left:10px;padding:0;display:inline-block;height:30px;width:100px;text-align:center;line-height:2;}
      body.leage{width:297mm;}
      body.leage .print_League{margin:auto;width:80%;}
	 </style>

  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <title><%=gameTitleName%></title>
</head>

   <script>
      /* ==================================================================================
            Script Util Function
            GameTitleIDX	GameLevelDtlidx	TeamGameNum	GameNum	LResultType	LJumsu	LJumsuDtl	RJumsu	RJumsuDtl
               0                  1                 2       3           4        5         6         7          8
            ROUND	GroupGameGb	LevelJooNum	LevelDtlJooNum	LevelDtlName	LevelJooName
               9       10         11              12           13            14
            LPlayer1	LPlayer2	RPlayer1	RPlayer2	LTeam1	LTeam2
               15        16       17       18     19       20
            RTeam1	RTeam2	LTeamDtl	RTeamDtl	MaxRound	GameType	LByeYN	RByeYN	FullGameYN
               21       22       23       24       25       26        27      28        29
            TourneyCnt	ORDERBY	LQualifier	RQualifier	LSeedNum	RSeedNum
               30          31         32          33         34       35
         ================================================================================== */

      /* ===================================================================================
           n이 2의 몇승인지를 구한다.
       =================================================================================== */
      function getRoot2(n)
      {
         var i = 0, rest, seed = 2, maxLoop = 100, fLoop = 1;
         var n, cnt = 0

         while(fLoop)
         {
            rest = n / seed;
            cnt++;
            if(rest > 1) n = rest;
            else fLoop = 0
            maxLoop --;
            if(maxLoop == 0) fLoop = 0;
         }

         return cnt;
      }

      function displayTonament(id_div, strUserData, playType, PlayLevelType, GroupGameGb, MaxRound, viewType)
      {
         var strLog, aryUser;
         var nScale = 1, nBlockHeight = 48, nBranchWidth = 30, nBoardWidth = 240, nFirstBoarderGap = 30;
         strLog = utx.strPrintf("displayTonament id_div = {0}, playType = {1}, PlayLevelType = {2}, GroupGameGb = {3}, MaxRound = {4}", id_div, playType, PlayLevelType, GroupGameGb, MaxRound);
         // console.log(strLog);
         //// console.log(strUserData);

         aryUser = utx.Get2DAryFromStr(strUserData, "|", ",");

         var aryData, i = 0, len = 0, obj, IsDblPlay = 1, round = 0, round_kind = 0, cur_round = 0;
         var IsFinal = 1, IsDblRound64 = 0;              // 본선
         aryData = new Array();

         len = aryUser.length;
         round_kind = getRoot2(Number(MaxRound));
         round = Math.pow(2,round_kind);

         strLog = utx.strPrintf("round_kind = {0}, round = {1}", round_kind, round);
         // console.log(strLog);

         for(i = 0; i<round_kind; i++)
         {
            aryData[i] = new Array();
         }

         if(!playType || playType == undefined  || playType == "B0020001") IsDblPlay = 0;        // 단식
         if(PlayLevelType == undefined || PlayLevelType == "B0100001") IsFinal = 0;     // 예선
         if(IsDblPlay == 1 && round == 64) IsDblRound64 = 1;             // 64강

         if(IsDblRound64 == 1) {

            var abc = 3;
         }

         var order = 0, prev_round = 0;
         for(i = 0; i<len; i++)
         {
            cur_round = Number(aryUser[i][5])-1;            // ROUND(5)

            // block 앞에 넣는 번호 , Round가 바뀌면 초기화 한다.
            if(cur_round != prev_round)
            {
               prev_round = cur_round;
            }

            obj = fillUserInfo(cur_round, order, aryUser[i], GroupGameGb, IsDblPlay, IsDblRound64, IsFinal );
            aryData[cur_round].push(obj);
            order++;
         }

         var base = 2;
         for(i = round_kind-1; i > cur_round; i--)
         {
            MakeEmptyData(aryData[i], base);
            base *= 2;
         }

			nScale = 1;
			var retObj = {};
			retObj.nBlockHeight = 0;
			retObj.nBranchWidth = 0;
			retObj.nBoardWidth = 0;
			retObj.nScale = 0;
			retObj.viewType = viewType;

			getTournamentEnv(round, retObj, IsDblPlay);
			
         if(IsDblPlay == 1) f_tournament = makeTournamentDouble(id_div, retObj.nScale, retObj.nBlockHeight, retObj.nBoardWidth, retObj.nBoardWidth + retObj.nFirstBoarderGap, retObj.nBranchWidth);
         else f_tournament = makeTournamentSingle(id_div, retObj.nScale, retObj.nBlockHeight, retObj.nBoardWidth, retObj.nBoardWidth + retObj.nFirstBoarderGap, retObj.nBranchWidth);

         drawTournament(f_tournament, round, round_kind, aryData);

      }

/* ===================================================================================
		1. 단식 128강 					1000
		2. 단식 64강 						0100
		3. 복식 64강 						0010
		4. 복식 32강 						0001

		1		0001		round32D == 1
		2		0010		round64D == 1
		3		0011		round64D == 1 && round32D == 1
		4		0100		round64S == 1
		5		0101		round64S == 1 && round32D == 1
		6		0110		round64S == 1 && round64D == 1
		7		0111		round64S == 1 && round64D == 1 && round32D == 1
		8		1000		round128S == 1
		9		1001		round128S == 1 && round32D == 1
		10	1010		round128S == 1 && round64D == 1
		11	1011		round128S == 1 && round64D == 1 && round32D == 1
		12	1100		round128S == 1 && round64S == 1
		13	1101		round128S == 1 && round64S == 1 && round32D == 1
		14	1110		round128S == 1 && round64S == 1 && round64D == 1
		15	1111		round128S == 1 && round64S == 1 && round64D == 1 && round32D == 1



		15가지 Case   (4 * 4) - 1 = 15가지
		   복식 32강 , 복식 64강 , 단식 64강, 단식 128강
			    1,          2,          3,         4
	=================================================================================== */
	function getTournamentEnv(round, retObj, IsDblPlay) {
		var round32D = 0, round64D = 0, round64S = 0, round128S = 0;
		var viewType = 0;

		viewType = retObj.viewType;

		// Default Setting
		retObj.nScale = 1;
		if(IsDblPlay == 1)
		{
			retObj.nBlockHeight = 48, retObj.nBranchWidth = 30, retObj.nBoardWidth = 240;
			retObj.nFirstBoarderGap = 30; 
			if(round == 16) {
				retObj.nBranchWidth = 20;
				retObj.nBoardWidth  = 200;				
			}
		}
		else
		{
			retObj.nBlockHeight = 24, retObj.nBranchWidth = 20, retObj.nBoardWidth = 170;
			retObj.nFirstBoarderGap = 30; 
		}

		if(viewType == 1) {					// case 1		0001		round32D == 1   ok
			if(IsDblPlay == 1 && round == 32) {
				retObj.nBlockHeight = 43;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 170;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.80;
			}
		}
		else if(viewType == 2) {			// case 2		0010		round64D == 1   ok
			if(IsDblPlay == 1 &&  round == 64) {
				retObj.nBlockHeight = 49;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 180;
				retObj.nFirstBoarderGap = 70; 
				retObj.nScale = 0.97;
			}
		}
		else if(viewType == 3) {			// case 3		0011		round64D == 1 && round32D == 1
			if(IsDblPlay == 1 && round == 64) {						// round64D
				retObj.nBlockHeight = 49;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 180;
				retObj.nFirstBoarderGap = 70; 
				retObj.nScale = 0.97;
			}
			else if(IsDblPlay == 1 && round == 32) {			// round32D
				retObj.nBlockHeight = 46;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 176;
				retObj.nFirstBoarderGap = 50; 
			}
		}
		else if(viewType == 4) {			// case 4		0100		round64S == 1
			if(IsDblPlay == 0 &&  round == 64) {
				retObj.nBlockHeight = 22;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 160;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 1;
			}
		}
		else if(viewType == 5) {			// case 5		0101		round64S == 1 && round32D == 1
			if(IsDblPlay == 0 && round == 64) {						// round64S
				retObj.nBlockHeight = 21;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 150;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.90;
			}
			else if(IsDblPlay == 1 && round == 32) {			// round32D
				retObj.nBlockHeight = 46;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 176;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.84;
			}
		}
		else if(viewType == 6) {			// case 6		0110		round64S == 1 && round64D == 1
			if(IsDblPlay == 0 && round == 64) {						// round64S
				retObj.nBlockHeight = 22;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 160;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
			else if(IsDblPlay == 1 && round == 64) {			// round64D
				retObj.nBlockHeight = 48;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 165;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
		}
		else if(viewType == 7) {			// case 7		0111		round64S == 1 && round64D == 1 && round32D == 1
			if(IsDblPlay == 0 && round == 64) {							// round64S
				retObj.nBlockHeight = 22;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 150;
				retObj.nFirstBoarderGap = 50; 
			}
			else if(IsDblPlay == 1 && round == 64) {			  // round64D
				retObj.nBlockHeight = 48;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 170;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
			else if(IsDblPlay == 1 && round == 32) {				// round32D
				retObj.nBlockHeight = 46;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 176;
				retObj.nFirstBoarderGap = 50; 
			}
		}

		else if(viewType == 8) {			// case 8		1000		round128S == 1  ok
			if(IsDblPlay == 0 &&  round == 128) {
				retObj.nBlockHeight = 25;
				retObj.nBranchWidth = 3;
				retObj.nBoardWidth  = 150;
				retObj.nFirstBoarderGap = 50; 
			   retObj.nScale = 0.90;
			}
		}
		else if(viewType == 9) {			// case 9		1001		round128S == 1 && round32D == 1
			if(IsDblPlay == 0 && round == 128) {							// round128S
				retObj.nBlockHeight = 25;
				retObj.nBranchWidth = 3;
				retObj.nBoardWidth  = 150;
				retObj.nFirstBoarderGap = 50; 
			   retObj.nScale = 0.90;
			}
			else if(IsDblPlay == 1 && round == 32) {				// round32D
				retObj.nBlockHeight = 44;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 176;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.96;
			}
		}
		else if(viewType == 10) {			// case 10	1010		round128S == 1 && round64D == 1
			if(IsDblPlay == 0 && round == 128) {						// round128S
				retObj.nBlockHeight = 24; 
				retObj.nBranchWidth = 5;  
				retObj.nBoardWidth  = 150;
				retObj.nFirstBoarderGap = 50; 	
				retObj.nScale = 0.99;		   
			}
			else if(IsDblPlay == 1 && round == 64) {				// round64D
				retObj.nBlockHeight = 48;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 170;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
		}
		else if(viewType == 11) {			// case 11	1011		round128S == 1 && round64D == 1 && round32D == 1
			if(IsDblPlay == 0 && round == 128) {						// round128S
				retObj.nBlockHeight = 24; 
				retObj.nBranchWidth = 5;  
				retObj.nBoardWidth  = 150;
				retObj.nFirstBoarderGap = 50; 	
				retObj.nScale = 0.99;	
			}
			else if(IsDblPlay == 1 && round == 64) {				// round64D
				retObj.nBlockHeight = 48;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 170;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
			else if(IsDblPlay == 1 && round == 32) {				// round32D
				retObj.nBlockHeight = 44;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 176;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.98;
			}
		}
		else if(viewType == 12 ) {			// case 12	1100		round128S == 1 && round64S == 1
			if(IsDblPlay == 0 &&  round == 128) {						// round128S
				retObj.nBlockHeight = 24; 
				retObj.nBranchWidth = 5;  
				retObj.nBoardWidth  = 150;
				retObj.nFirstBoarderGap = 50; 	
				retObj.nScale = 0.99;	
			}
			else if(IsDblPlay == 0 && round == 64) {				// round64S
				retObj.nBlockHeight = 23;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 160;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
		}
		else if(viewType == 13) {			// case 13	1101		round128S == 1 && round64S == 1 && round32D == 1
			if(IsDblPlay == 0 &&  round == 128) {						// round128S
				retObj.nBlockHeight = 24; 
				retObj.nBranchWidth = 5;  
				retObj.nBoardWidth  = 150;
				retObj.nFirstBoarderGap = 50; 	
				retObj.nScale = 0.99;	
			}
			else if(IsDblPlay == 0 && round == 64) {				// round64S
				retObj.nBlockHeight = 23;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 160;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
			else if(IsDblPlay == 1 && round == 32) {				// round32D
				retObj.nBlockHeight = 46;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 176;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.97;
			}
		}
		else if(viewType == 14) {			// case 14	1110		round128S == 1 && round64S == 1 && round64D == 1
			if(IsDblPlay == 0 &&  round == 128) {						// round128S
				retObj.nBlockHeight = 24; 
				retObj.nBranchWidth = 5;  
				retObj.nBoardWidth  = 150;
				retObj.nFirstBoarderGap = 50; 	
				retObj.nScale = 0.99;	
			}
			else if(IsDblPlay == 0 && round == 64) {				// round64S
				retObj.nBlockHeight = 23;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 160;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
			else if(IsDblPlay == 1 && round == 64) {				// round64D
				retObj.nBlockHeight = 48;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 170;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
		}
		else if(viewType == 15) {			// case 15	1111		round128S == 1 && round64S == 1 && round64D == 1 && round32D == 1
			if(IsDblPlay == 0 &&  round == 128) {						// round128S
				retObj.nBlockHeight = 24; 
				retObj.nBranchWidth = 5;  
				retObj.nBoardWidth  = 150;
				retObj.nFirstBoarderGap = 50; 	
				retObj.nScale = 0.99;	
			}
			else if(IsDblPlay == 0 && round == 64) {				// round64S
				retObj.nBlockHeight = 23;
				retObj.nBranchWidth = 5;
				retObj.nBoardWidth  = 160;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
			else if(IsDblPlay == 1 && round == 64) {				// round64D
				retObj.nBlockHeight = 48;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 170;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.99;
			}
			else if(IsDblPlay == 1 && round == 32) {				// round32D
				retObj.nBlockHeight = 46;
				retObj.nBranchWidth = 10;
				retObj.nBoardWidth  = 176;
				retObj.nFirstBoarderGap = 50; 
				retObj.nScale = 0.97;
			}
		}
	}



/* ==================================================================================
      tournament에 사용할 data object을 만든다.
   ================================================================================== */
   function fillUserInfo(cur_round, Idx, info, GroupGameGb, IsDblPlay, IsDblRound64, IsFinal)
   {
      var obj = {};
      var l_player1, l_player2, l_team1, l_team2, l_teamDtl, l_Q;
      var r_player1, r_player2, r_team1, r_team2, r_teamDtl, r_Q;
      var round = 0;

      round = info[5];        // Round(5)   : 제일 처음이 1

      obj.matchNo    =  (round == 1) ? Idx : -1;
      obj.bDblPlay   =  IsDblPlay;
      obj.bDblRound64 = IsDblRound64;
      obj.bFinal     =  IsFinal;
      obj.l_fill     =  true;
      obj.l_sel      =  false;
      obj.r_fill     =  true;
      obj.r_sel      =  false;
      obj.l_score    =  (info[12] == null || info[12] == ' ') ? 0 : info[12];        // LJumsu(12)
      obj.r_score    =  (info[14] == null || info[14] == ' ') ? 0 : info[14];        // RJumsu(14)
      obj.l_seedNo   =  Number(info[8]);                   // LSeedNum(8)
      obj.r_seedNo   =  Number(info[11]);                   // RSeedNum(11)

      obj.l_Q        =  Number(info[7]);                       // LQualifier(7)
      obj.r_Q        =  Number(info[10]);                       // RQualifier(10)

      // short name replace
      l_player1   = (info[16] == null) ? "" : bmx.TeamGBtoSimple(info[16]);     // LPlayer1(16)
      l_player2   = (info[18] == null) ? "" : bmx.TeamGBtoSimple(info[18]);     // LPlayer2(18)
      l_team1     = (info[17] == null) ? "" : bmx.TeamGBtoSimple(info[17]);      // LTeam1(17)
      l_team2     = (info[19] == null) ? "" : bmx.TeamGBtoSimple(info[19]);      // LTeam2(19)

      r_player1   = (info[20] == null) ? "" : bmx.TeamGBtoSimple(info[20]);     // RPlayer1(20)
      r_player2   = (info[22] == null) ? "" : bmx.TeamGBtoSimple(info[22]);     // RPlayer1(22)
      r_team1     = (info[21] == null) ? "" : bmx.TeamGBtoSimple(info[21]);      // RTeam1(21)
      r_team2     = (info[23] == null) ? "" : bmx.TeamGBtoSimple(info[23]);      // RTeam2(23)

      // Bye position
      if(info[6] == 'Y') {      // LByeYN(6)
         obj.l_player   =  "BYE";
         obj.l_team     =  "";
      }
      else
      {
         if(l_player1 != "" && l_player1 != null)  { // player가 있다.
            if(l_player1 == l_player2) obj.l_player   =  l_player1;
            else obj.l_player   =  (IsDblPlay == 0)? l_player1 : utx.strPrintf("{0},{1}",l_player1, l_player2);
            obj.l_team     =  (IsDblPlay == 0)? l_team1 : utx.strPrintf("{0},{1}",l_team1, l_team2);
         }
         else if( (l_player1 == "" || l_player1 == null) && (l_team1 != "" && l_team1 != null) )
         {
            if(l_team1 == l_team2) obj.l_player   =  l_team1;
            else obj.l_player  =  (IsDblPlay == 0)? l_team1 : utx.strPrintf("{0},{1}",l_team1, l_team2);
            obj.l_team     =  "";
         }
         else if( (l_player1 == "" || l_player1 == null) && (l_team1 == "" || l_team1 == null) )
         {
            if(obj.l_Q > 0) obj.l_player  = utx.strPrintf("※예선 {0}조",obj.l_Q);
            else obj.l_player  = "";
            obj.l_team     =  "";
         }
      }

      // Bye position
      if(info[9] == 'Y') {      // RByeYN(9)
         obj.r_player   =  "BYE";
         obj.r_team     =  "";
      }
      else
      {
         if(r_player1 != "" && r_player1 != null)  { // player가 있다.
            if(r_player1 == r_player2) obj.r_player   =  r_player1;
            else obj.r_player   =  (IsDblPlay == 0)? r_player1 : utx.strPrintf("{0},{1}",r_player1, r_player2);
            obj.r_team     =  (IsDblPlay == 0)? r_team1 : utx.strPrintf("{0},{1}",r_team1, r_team2);
         }
         else if( (r_player1 == "" || r_player1 == null) && (r_team1 != "" && r_team1 != null) )
         {
            if(r_team1 == r_team2) obj.r_player   =  r_team1;
            else obj.r_player  =  (IsDblPlay == 0)? r_team1 : utx.strPrintf("{0},{1}",r_team1, r_team2);
            obj.r_team     =  "";
         }
         else if( (r_player1 == "" || r_player1 == null) && (r_team1 == "" || r_team1 == null) )
         {
            if(obj.r_Q > 0) obj.r_player  = utx.strPrintf("※예선 {0}조",obj.r_Q);
            else obj.r_player  = " ";
            obj.r_team     =  "";
         }
      }
      return obj;
   }

      /* ==================================================================================
         draw Tonament - tonament Object, round, data를 입력받아 tonament를 그린다.
      ================================================================================= */
      function drawTournament(objT, round, round_kind, rAryData)
      {
         var roundData = {};

         var i = 0, key = "";
         for(var i = 0; i< round_kind; i++)
         {
            key = utx.strPrintf("round_{0}", i+1);
            roundData[key] = rAryData[i];
         }

         //round = round / 2;

         objT.draw({
            limitedStartRoundOf: 0, //16    integer(짝수)  default:0 전체, 그리기 시작할 라운드 ex)8강 부터
            limitedEndRoundOf: 0, //8       integer(짝수)  default:0 전체, 그리기 끝날 라운드 ex)4강 까지
            roundOf:round,
            data: roundData,
         });
      }

/* ==================================================================================
   make Tonament - div id를 입력받아 tonament Object을 생성하고 , 반환한다.
   ================================================================================== */
function makeTournamentDouble(id_div, nScale, nBlockHeight, nBoardWidth, nFirstBoardWidth, nBranchWidth)
{
  var tournament = new Tournament();
  tournament.setOption({
    blockBoardWidth: nBoardWidth, // integer board 너비
	 blockBoardWidthFirst: nFirstBoardWidth, // integer board 너비
    blockBranchWidth: nBranchWidth, // integer 트리 너비
   //  blockBoardWidth: 180, // integer board 너비
   //  blockBranchWidth: 30, // integer 트리 너비
   //  blockHeight : 48, // integer 블럭 높이(board 간 간격 조절)
    blockHeight : nBlockHeight, // integer 블럭 높이(board 간 간격 조절)
    branchWidth : 1, // integer 트리 두께
    //branchColor : '#dddddd', // string 트리 컬러
    branchColor : '#ccc', // string 트리 컬러
    roundOf_textSize : 10, // integer 배경 라운드 텍스트 크기
    scale : nScale, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
    //scale : 0.5, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
    board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
    el:document.getElementById(id_div) // element must have id
  });

   tournament.setStyle('#'+id_div);
   $("#"+id_div).addClass("tour_double")
      tournament.boardInner = function(data){
      return boardInner_Double(data);
   }
  return tournament;
}

function makeTournamentSingle(id_div, nScale, nBlockHeight, nBoardWidth, nFirstBoardWidth, nBranchWidth)
{
   var tournament = new Tournament();
   tournament.setOption({
      blockBoardWidth: nBoardWidth, // integer board 너비
		blockBoardWidthFirst: nFirstBoardWidth, // integer board 너비
      blockBranchWidth: nBranchWidth, // integer 트리 너비
      // blockBoardWidth: 180, // integer board 너비
      // blockBranchWidth: 30, // integer 트리 너비
      // blockHeight : 24, // integer 블럭 높이(board 간 간격 조절)
      blockHeight : nBlockHeight, // integer 블럭 높이(board 간 간격 조절)
      branchWidth : 1, // integer 트리 두께
      //branchColor : '#dddddd', // string 트리 컬러
      branchColor : '#ccc', // string 트리 컬러
      roundOf_textSize : 10, // integer 배경 라운드 텍스트 크기
      scale : nScale, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
   //   scale : 1, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
      board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
      el:document.getElementById(id_div) // element must have id
   });

   tournament.setStyle('#'+id_div);
   $("#"+id_div).addClass("tour_single")
   tournament.boardInner = function(data){
      return boardInner_single(data);
   }
  return tournament;
}


/* ==================================================================================
	   data set-  tonament block - single game
	   dat를 입력받아 싱글 게임일때 block을 그린다.
	================================================================================== */
	function boardInner_single(data)
	{
		var l_player, l_team;
		var r_player, r_team;
		var l_sel, r_sel;
		var l_score, r_score;
		var l_fill, r_fill;
		var l_no, r_no;
		var l_Qstr, r_Qstr;
		var matchNo = 0;
		var fExpandInfo = true;		
		// var str_bwf_info	= "BWSF";
		// var l_bwf_info	= "BWSF";
		// var r_bwf_info	= "BWSF";

		var l_bwf_info	= "";
		var r_bwf_info	= "";

		if(data){
		   matchNo = data.matchNo;

		   l_player  = data.l_player;
		   l_team    = data.l_team;
		   r_player  = data.r_player;
		   r_team    = data.r_team;
		   l_score   = data.l_score;
		   r_score   = data.r_score;

		   l_Qstr    = '';
		   r_Qstr    = '';

			if(data.l_seedNo != 0) l_bwf_info	= utx.sprintf("{0}", bmx.getStrSeed(data.l_seedNo));
			if(data.l_Q != 0) l_bwf_info	= utx.sprintf("Q{0}", data.l_Q);

			if(data.r_seedNo != 0) r_bwf_info	= utx.sprintf("{0}", bmx.getStrSeed(data.r_seedNo));
			if(data.r_Q != 0) r_bwf_info	= utx.sprintf("Q{0}", data.r_Q);

		   l_fill = data.l_fill ? 's_filled' : '';
		   r_fill = data.r_fill ? 's_filled' : '';

		   l_sel = data.l_sel ? 's_selected' : '';
		   r_sel = data.r_sel ? 's_selected' : '';

		   // 재고.....
		   l_no = (matchNo * 2) + 1;
		   r_no = (matchNo * 2 + 1) + 1;

		   if(data.hasOwnProperty('QGroupNo'))
		   {
		      l_no = data.QGroupNo + "_" + l_no;
		      r_no = data.QGroupNo + "_" + r_no;
		   }
		}

		var html = "";
			if(data.matchNo != -1) {
					html = [
					'<p class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
						(data.matchNo != -1) ? '<span class="lotteryMatch__seedWrap f_span">'+l_bwf_info+'</span><span class="lotteryMatch__seedWrap"><span>'+l_no+'</span><span>'+l_Qstr+'</span></span>': '',
						'<span class="lotteryMatch__playerWrap">',
							'<span class="lotteryMatch__playerInner">',
								'<span class="lotteryMatch__player [ _player1 ]">'+l_player+'</span>',
								'<span class="lotteryMatch__belong [ _belong1 ]">'+l_team+'</span>',
							'</span>',
						'</span>',
						'<span class="lotteryMatch__score">'+l_score+'</span>',
					'</p>',
					'<p class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
						(data.matchNo != -1) ? '<span class="lotteryMatch__seedWrap f_span">'+r_bwf_info+'</span><span class="lotteryMatch__seedWrap"><span>'+r_no+'</span><span>'+r_Qstr+'</span></span>': '',
						'<span class="lotteryMatch__playerWrap">',
							'<span class="lotteryMatch__playerInner">',
								'<span class="lotteryMatch__player [ _player1 ]">'+r_player+'</span>',
								'<span class="lotteryMatch__belong [ _belong1 ]">'+r_team+'</span>',
							'</span>',
						'</span>',
						'<span class="lotteryMatch__score">'+r_score+'</span>',
					'</p>'
				].join('');
			}
			else {
				html = [
					'<p class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
						(data.matchNo != -1) ? '<span class="lotteryMatch__seedWrap f_span"></span><span class="lotteryMatch__seedWrap"><span>'+l_no+'</span><span>'+l_Qstr+'</span></span>': '',
						'<span class="lotteryMatch__playerWrap">',
							'<span class="lotteryMatch__playerInner">',
								'<span class="lotteryMatch__player [ _player1 ]">'+l_player+'</span>',
								'<span class="lotteryMatch__belong [ _belong1 ]">'+l_team+'</span>',
							'</span>',
						'</span>',
						'<span class="lotteryMatch__score">'+l_score+'</span>',
					'</p>',
					'<p class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
						(data.matchNo != -1) ? '<span class="lotteryMatch__seedWrap f_span"></span><span class="lotteryMatch__seedWrap"><span>'+r_no+'</span><span>'+r_Qstr+'</span></span>': '',
						'<span class="lotteryMatch__playerWrap">',
							'<span class="lotteryMatch__playerInner">',
								'<span class="lotteryMatch__player [ _player1 ]">'+r_player+'</span>',
								'<span class="lotteryMatch__belong [ _belong1 ]">'+r_team+'</span>',
							'</span>',
						'</span>',
						'<span class="lotteryMatch__score">'+r_score+'</span>',
					'</p>'
				].join('');
			}

		return html;
	}

/* ==================================================================================
   data set-  tonament block - double game
   data를 입력받아 복식 게임일때 block을 그린다.
================================================================================== */
   function boardInner_Double(data)
   {
      var aryl_player, aryl_team;
      var aryr_player, aryr_team;
      var l_score, r_score;
      var l_sel, r_sel;
      var l_fill, r_fill;
      var l_no, r_no;
      var l_Qstr, r_Qstr;
      var matchNo = 0;
      var IsRound64 = 0
      var vs64="";
		var fExpandInfo = true;
		// var str_bwf_info	= "BWSF";
		// var l_bwf_info	= "BWSF";
		// var r_bwf_info	= "BWSF";
		var l_bwf_info	= "";
		var r_bwf_info	= "";

      aryl_player  = [" ", " "];
      aryl_team  = [" ", " "];
      aryr_player  = [" ", " "];
      aryr_team  = [" ", " "];

      if(data != undefined){
         matchNo = data.matchNo;
         IsRound64 = data.bDblRound64;
         if(IsRound64 == 1)
         {
            var abc = 1;
            vs64="vs64";
            var strLog = utx.sprintf("data.l_player = {0}, data.l_player = {1}, IsRound64 = {2}", data.l_player, data.r_player, IsRound64);
            // console.log(strLog);
         }

         if(data.l_player == "" || data.l_player == undefined) aryl_player  = [" ", " "];
         else aryl_player  = (data.l_player.indexOf(',') == -1) ? [data.l_player, " "] : data.l_player.split(',');

         if(data.l_team == "" || data.l_team == undefined) aryl_team  = [" ", " "];
         else aryl_team  = (data.l_team.indexOf(',') == -1)   ? [data.l_team, " "]   : data.l_team.split(',');

         if(data.r_player == "" || data.r_player == undefined) aryr_player  = [" ", " "];
         else aryr_player  = (data.r_player.indexOf(',') == -1) ? [data.r_player, " "] : data.r_player.split(',');

         if(data.r_team == "" || data.r_team == undefined) aryr_team  = [" ", " "];
         else aryr_team  = (data.r_team.indexOf(',') == -1)   ? [data.r_team, " "]   : data.r_team.split(',');

         l_score   = data.l_score;
         r_score   = data.r_score;

         l_Qstr    = '';
         r_Qstr    = '';

			if(data.l_seedNo != 0) l_bwf_info	= utx.sprintf("{0}", bmx.getStrSeed(data.l_seedNo));
			if(data.l_Q != 0) l_bwf_info	= utx.sprintf("Q{0}", data.l_Q);

			if(data.r_seedNo != 0) r_bwf_info	= utx.sprintf("{0}", bmx.getStrSeed(data.r_seedNo));
			if(data.r_Q != 0) r_bwf_info	= utx.sprintf("Q{0}", data.r_Q);

         l_fill = data.l_fill ? 's_filled' : '';
         r_fill = data.r_fill ? 's_filled' : '';

         l_sel = data.l_sel ? 's_selected' : '';
         r_sel = data.r_sel ? 's_selected' : '';

         // 재고.....
         l_no = (matchNo * 2) + 1;
         r_no = (matchNo * 2 + 1) + 1;

         if(data.hasOwnProperty('QGroupNo'))
         {
            l_no = data.QGroupNo + "_" + l_no;
            r_no = data.QGroupNo + "_" + r_no;
         }
      }

      var html = [
         '<p class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + ' '+vs64+'" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
            (matchNo != -1) ? '<span class="lotteryMatch__seedWrap f_span">'+l_bwf_info+'</span><span class="lotteryMatch__seedWrap"><span>'+l_no+'</span><span>'+l_Qstr+'</span></span>' : '',
            '<span class="lotteryMatch__playerWrap">',
               '<span class="lotteryMatch__playerInner">',
                  '<span class="lotteryMatch__player [ _player1 ]">'+aryl_player[0]+'</span>',
                  '<span class="lotteryMatch__belong [ _belong1 ]">'+aryl_team[0]+'</span>',
               '</span>',
               '<span class="lotteryMatch__playerInner">',
                  '<span class="lotteryMatch__player [ _player2 ]">'+aryl_player[1]+'</span>',
                  '<span class="lotteryMatch__belong [ _belong2 ]">'+aryl_team[1]+'</span>',
               '</span>',
            '</span>',
            '<span class="lotteryMatch__score">'+l_score+'</span>',
         '</p>',
         '<p class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + ' '+vs64+'" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
            (matchNo != -1) ? '<span class="lotteryMatch__seedWrap f_span">'+r_bwf_info+'</span><span class="lotteryMatch__seedWrap"><span>'+r_no+'</span><span>'+r_Qstr+'</span></span>' : '',
            '<span class="lotteryMatch__playerWrap">',
               '<span class="lotteryMatch__playerInner">',
               '<span class="lotteryMatch__player [ _player1 ]">'+aryr_player[0]+'</span>',
                  '<span class="lotteryMatch__belong [ _belong1 ]">'+aryr_team[0]+'</span>',
               '</span>',
               '<span class="lotteryMatch__playerInner">',
                  '<span class="lotteryMatch__player [ _player2 ]">'+aryr_player[1]+'</span>',
                  '<span class="lotteryMatch__belong [ _belong2 ]">'+aryr_team[1]+'</span>',
               '</span>',
            '</span>',
            '<span class="lotteryMatch__score">'+r_score+'</span>',
         '</p>'
      ].join('');
      return html;
   }
   </script>

   <body>
	 		<% If Idx = 0  And AmaTimeOnly = 1 Then %>
				<div class = "print_div">
						<a href="#" id="btnPrintLeague" class="btn print_btn" onclick="OnClickPrintLeague();" > Print 리그</a>
						<a href="#" id="btnPrintTourney" class="btn print_btn" onclick="OnClickPrintTourney();" > Print 토너먼트</a>
				</div>
			<% End If %>

      <div>
      <%
         ub = UBound(aryLvDtlIdx, 2)

         Dim strGInfo, strPlayerCnt, nPlayerCnt, strTonament, bPageBreak
         Dim aryInfo, len_colum, cnt_player, IsTeamGame, aryResult, aryHeader, aryGInfo
         Dim useHistory, pos_rank, MaxRound, nQPerPage, col_league, gameEnterType
				 Dim keyLvDtlIdx, strHeader, p1_name, p1_team, p2_name, p2_team
				 Dim TonamentFinal
				 Dim E_PER_TONAMENT_S,  E_PER_TONAMENT_D
				 Dim classTeam, classAddInfo, classFirstCell, classEtcCell

				 E_PER_TONAMENT_S = 9						' 단식 예선은 프린트시 한 페이지당 9개씩
				 E_PER_TONAMENT_D = 6						' 복식 예선은 프린트시 한 페이지당 6개씩

				 classTeam 				= "league_cnt"		' 리그 구성원의 width는 일정해야 한다. (5명 이상부터 각각 특정 크기로 셋팅 css)
				 classAddInfo 		= "league_etc"		' 승,패,득,실,차,순위의 width는 일정한 크기로 작아야 한다.
				 classFirstCell		= "league_first"	' 제일 처음 cell width
				 classEtcCell		  = "league_etc_cell"

         cntTournament = 0
         cntLeague = 0
         cntQ = 0
         bPageBreak = false
         nQPerPage = 8              ' 단식
				 TonamentFinal = false

				 'Call webLog2Dim(aryFullGameInfo, "body --aryFullGameInfo " )



				 viewType = GetTourneyDisplayType(aryFullGameInfo)

				 strLog = strPrintf("Level Idx Cnt = {0} viewType = {1}, AmaTimeOnly = {2}", Array(ub, viewType, AmaTimeOnly))
         	 ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog)

				 %> 
				 	<script> var strDebug = '<%=strLog%>';   console.log(strDebug); </script>
				 <%

         For Idx = 0 To ub

					'If(Idx > 1) Then
					'   Exit For
					'End If
					bPageBreak     = false
'					If(AmaTimeOnly = 1) Then bPageBreak = true End If
					keyLvDtlIdx		 = aryLvDtlIdx(0, Idx)
					nPlayerCnt     = GetPlayerCnt(aryFullCntPlayer, keyLvDtlIdx)
					aryGInfo		 	 = GetAryGameInfo(aryFullGameInfo, keyLvDtlIdx)

					'strLog = sprintf("body --aryGInfo {0}, lvDtlIdx = {1}", array(Idx, keyLvDtlIdx))
					'Call webLog1Dim(aryGInfo, 10, strLog )

					playType       = aryGInfo(3)
					gameType       = aryGInfo(7)
					playLvType     = aryGInfo(11)
					groupGameGb    = aryGInfo(12)
					MaxRound       = aryGInfo(13)
					gameEnterType  = aryGInfo(14)

					strGInfo       = getGameInfoStr(aryGInfo)
					strPlayerCnt   = getCntPlayerStr(nPlayerCnt, groupGameGb)

					strLog = strPrintf("Idx = {0}, gameType = {1}, playLvType = {2}, groupGameGb = {3}, nPlayerCnt = {4}, cntTournament = {5}, cntLeague = {6}, playType = {7}", _
											Array(Idx, gameType, playLvType, groupGameGb, nPlayerCnt, cntTournament,cntLeague, playType ))

					'' ' ' ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog)

					%>

					<%
						If gameType = "B0040002" Then       ' 토너먼트 이면
								'   ===============================================================================
								'      토너먼트를 그린다.
								'   ===============================================================================
								aryTournament = extractAryFromAry(aryFullTournament, keyLvDtlIdx, 1, 0)
								If( playLvType = "B0100001") Then      ' 예선
									cntQ = cntQ + 1
									If( playType = "B0020001") Then          ' 단식
											nQPerPage = E_PER_TONAMENT_S
									ElseIf( playType = "B0020002") Then      ' 복식
											nQPerPage = E_PER_TONAMENT_D
									End If
									If ( (cntQ > 1) And (cntQ Mod nQPerPage = 1) ) Or (TonamentFinal = true) Then bPageBreak = true End If

									TonamentFinal = false
								Else                                   ' 본선
									cntQ = 0
									If(Idx <> 0) Then bPageBreak = true End If
									TonamentFinal = true
								End If

								nRound = CDbl(maxRound)
								IsDbl = 0
								If(playType = "B0020002") Then IsDbl = 1	End If
								'viewType = 15
								%>								

								<% 'If IsDbl = 1 And (nRound = 32) Then 									' 1		For Test%>
								<% 'If IsDbl = 1 And (nRound = 64) Then 									' 2		For Test%>
								<% 'If IsDbl = 1 And (nRound = 32 Or nRound = 64) Then 	' 3		For Test%>
								<% 'If IsDbl = 0 And (nRound = 64) Then 									' 4		For Test%>

								<% 'If (IsDbl = 0 And nRound = 64) Or (IsDbl = 1 And nRound = 32) Then 	' 5		For Test%>
								<% 'If (IsDbl = 0 And nRound = 64) Or (IsDbl = 1 And nRound = 64) Then 	' 6		For Test%>
								<% 'If (IsDbl = 0 And nRound = 64) Or (IsDbl = 1 And (nRound = 32 Or nRound = 64)) Then 	' 7		For Test%>
								<% 'If IsDbl = 0 And (nRound = 128) Then 	' 8		For Test%>

								<% 'If (IsDbl = 0 And nRound = 128) Or (IsDbl = 1 And nRound = 32) Then 	' 9		For Test%>
								<% 'If (IsDbl = 0 And nRound = 128) Or (IsDbl = 1 And nRound = 64) Then 	' 10		For Test%>
								<% 'If (IsDbl = 0 And nRound = 128) Or (IsDbl = 1 And (nRound = 32 Or nRound = 64)) Then 	' 11		For Test%>
								<% 'If IsDbl = 0 And (nRound = 128 Or nRound = 64) Then 	' 12		For Test%>

								<% 'If (IsDbl = 0 And (nRound = 128 Or nRound = 64)) Or (IsDbl = 1 And nRound = 32) Then 	' 13		For Test%>
								<% 'If (IsDbl = 0 And (nRound = 128 Or nRound = 64)) Or (IsDbl = 1 And nRound = 64)  Then 	' 14		For Test%>
								<% 'If (IsDbl = 0 And (nRound = 128 Or nRound = 64)) Or (IsDbl = 1 And (nRound = 32 Or nRound = 64)) Then 	' 15		For Test%>

								
								<div class="wrapper <%If(AmaTimeOnly = 1) Then %>print_Tourney<%End If%>"
										<%If(bPageBreak = true) Then %> style= "page-break-before: always;" <%End If%> >
									<div class="header">    <!-- S: header -->
											<h1 class="title"><%=GameTitleName%></h1>                            <!-- 제100회 전국체육대회 -->
											<div class="moreInfo">
												<span class="team"> <%=strGInfo%> </span>                         <!-- [남자 고등부 본선] -->
												<span class="attend"> <span> <%=strPlayerCnt%> </span></span>     <!-- 참가선수: 16팀 -->
												<% If Idx = 0  And AmaTimeOnly = 1 Then %>
													<!-- <a href="#" id="btnPrintLeague" class="btn print_btn" onclick="OnClickPrintLeague();" > Print 리그</a>
													<a href="#" id="btnPrintTourney" class="btn print_btn" onclick="OnClickPrintTourney();" > Print 토너먼트</a> -->
												<% End If %>
											</div>
									</div>

									<div class="main tournamentTree">
											<div id="div_Tournament_<%=Idx%>" class="bottom-list cls_Tournament"> </div>
											<%
												strTonament = uxGetStrFrom2DimAry(aryTournament, "|", ",")
											%>

											<%If strTonament <> "" Then %>
												<script> displayTonament("div_Tournament_<%=Idx%>", '<%=strTonament%>', '<%=PlayType%>', '<%=playLvType%>', '<%=groupGameGb%>', '<%=maxRound%>', '<%=viewType%>'); </script>
											<% End If %>
									</div>
								</div>               <!-- E: wrapper -->								

								<% 'End If 				' For Test%>
								<%
						Else                                   ' 리그이면
							'   ===============================================================================
							'      리그를 그린다.
							'   ===============================================================================
							If(AmaTimeOnly = 1) Then bPageBreak = true End If

							aryLeague = extractAryFromAry(aryFullLeague, keyLvDtlIdx, 1, 0)
							aryLeagueJumsu = extractAryFromAry(aryFullLeagueJumsu, keyLvDtlIdx, 1, 2)
							
							' ' ' Call TraceLog2Dim(SPORTS_LOG1, aryLeagueJumsu, "aryLeagueJumsu")

							' ' ' Call TraceLog2Dim(SPORTS_LOG1, aryLeague, "aryLeague")


							If(IsArray(aryLeague)) Then
								aryTmp = aryLeague
								col_league = UBound(aryTmp, 2)

								' 리그 사이즈에 따라 각 Cell의 width를 조정한다. - (아마추어일때 제외)
								If(gameEnterType = "E") Then
									If(col_league > 3) Then
										classTeam = sprintf("league_cnt{0}", Array(col_league+1))
									Else
										classTeam = "league_cnt"
									End If
								End If

								aryHeader = MakeHeader(aryTmp, GroupGameGb, gameEnterType)
								ub2 = UBound(aryHeader)

								' ' ' Call TraceLog1Dim(SPORTS_LOG1, aryHeader, 1, "aryHeader")

								cnt_player = col_league + 1
								pos_rank   = cnt_player + CNT_RESULT_INFO -1
								' 점수 * ub2 + 승패득실차순위 + (LScore,RScore,Result)*ub2
								len_colum = cnt_player + CNT_RESULT_INFO + (cnt_player * CNT_GAMEPER_INFO) - 1

								aryInfo    = null
								aryResult  = null
								ReDim aryInfo(len_colum, cnt_player-1)

								If GroupGameGb = "B0030001" Then          '개인전일때
									IsTeamGame = 0
									useHistory = 0
								Else
									IsTeamGame = 1
									useHistory = 1
								End If

								strLog = sprintf("GroupGameGb = {0}, IsTeamGame = {1}, EnterType = {2}", Array(GroupGameGb, IsTeamGame, EnterType))
								' ' ' Call TraceLog(SPORTS_LOG1, strLog)

								If(IsArray(aryLeagueJumsu)) Then
									Call SetLeagueGameInfo(aryLeagueJumsu, aryLeague, aryInfo, IsTeamGame)

									' ' ' Call TraceLog2Dim(SPORTS_LOG1, aryInfo, "****aryInfo")

									aryResult = GetAryResultInfo(aryLeague, aryInfo)

									' ' ' Call TraceLog2Dim(SPORTS_LOG1, aryResult, "****aryResult")

									useHistory = 1
									Call uxMakeRankForPrint(aryResult, aryLeagueJumsu, IsTeamGame, useHistory)
									Call ApplyRanking(aryInfo, aryResult, pos_rank)
								End If
							End If
						%>
								<div class="wrapper <%If(AmaTimeOnly = 1) Then %>print_League<%End If%>"
												<%If(bPageBreak = true) Then %> style= "page-break-before: always;" <%End If%> >
									<div class="header">    <!-- S: header -->
											<h1 class="title"><%=GameTitleName%></h1>                            <!-- 제100회 전국체육대회 -->
											<div class="moreInfo">
												<span class="team"> <%=strGInfo%> </span>                         <!-- [남자 고등부 본선] -->
												<span class="attend"> <span> <%=strPlayerCnt%> </span></span>     <!-- 참가선수: 16팀 -->
											</div>
									</div>                  <!-- E: header -->
						<% If(IsArray(aryLeague)) Then  %>
									<div class="main league">  <!-- S: main -->
											<div class="line_area">    <!-- S: line_area -->
												<table class="table">
														<tbody>
															<tr>
																	<th class="team <%=classFirstCell%>">구분</th>
																	<%
																		'해당되는 선수수만큼 Loop
																		For k = 0 To ub2
																			strHeader = aryHeader(k)
																			If(k <= col_league) Then
																				Call ExtractHeader(strHeader, p1_name, p1_team, p2_name, p2_team)
																			End If
																	%>
																	<% If(k <= col_league) Then %>
																		<th class="playerTH <%=classTeam%>">
																			<div class="player">
																				<span class="name"> <%=p1_name%>
																					<% If p1_team <> "" Then %> <font style="font-size:13px">(<%=p1_team%>)</font> <% End If %>
																				</span>
																			</div>
																			<% If p2_name <> "" Then %>
																				<div class="player">
																					<span class="name"> <%=p2_name%>
																						<% If p2_team <> "" Then %> <font style="font-size:13px">(<%=p2_team%>)</font> <% End If %>
																					</span>
																				</div>
																			<% End If %>
																		</th>
																	<% Else %>
																		<th class="playerTH <%=classAddInfo%>">
																			<div class="player">
																				<span class="name"> <%=strHeader%> </span>
																			</div>
																		</th>
																	<% End If %>
																	<%
																		Next
																	%>
															</tr>

															<%
																	leagueGameNum = 0
																	For k = 0 To col_league
																	strHeader = aryHeader(k)
																	Call ExtractHeader(strHeader, p1_name, p1_team, p2_name, p2_team)
															%>

															<tr>
																	<% ' ========================== 선수명 ==================================== %>
																	<th>
																		<div class="number">
																				<!--<span class="round"><%=k+1%></span>-->
																		</div>
																		<div class="player">
																			<span class="name"> <%=p1_name%>
																				<% If p1_team <> "" Then %> <font style="font-size:13px">(<%=p1_team%>)</font> <% End If %>
																			</span>
																		</div>
																		<% If p2_name <> "" Then %>
																		<div class="player">
																			<span class="name"> <%=p2_name%>
																				<% If p2_team <> "" Then %> <font style="font-size:13px">(<%=p2_team%>)</font> <% End If %>
																			</span>
																		</div>
																		<% End If %>
																	</th>
																		<% If(AmaTimeOnly = 1) Then %>
																			<%
																				For m = 0 To ub2
																					strTimeInfo = aryInfo(m,k)

																					If(InStr(strTimeInfo, "|") > 0) Then
																						aryTimeInfo = Split(strTimeInfo, "|")
																			%>
																						<td >
																							<div> <%=aryTimeInfo(0)%> </div>
																							<div > <%=aryTimeInfo(1)%> </div>
																							<div> Vs </div>
																							<div > <%=aryTimeInfo(2)%> </div>
																						</td>
																				<% Else %>
																						<td >	<%=strTimeInfo%> </td>
																				<% End If %>
																			<% Next %>
																		<% Else %>
																				<%	For m = 0 To ub2 %>
																					<%If m > col_league Then %>
																						<td  class="<%=classEtcCell%>">	<%=aryInfo(m,k)%> </td>
																					<% Else %>
																						<td >	<%=aryInfo(m,k)%> </td>
																					<% End If %>
																				<% Next %>
																		<% End If %>
																	<% ' ========================== 선수명 ==================================== %>
															</tr>
															<% Next %>
														</tbody>
												</table>
											</div>   <!-- E: line_area -->
									</div>    <!-- E: main -->
								</div>               <!-- E: wrapper -->
						<%

								cntLeague = cntLeague + 1
						End If               ' If(IsArray(aryLeague))
					End If               ' If gameType = "B0040002"

				%>
				</div>               <!-- E: wrapper -->
				<%
        Next
      %>
      </div>
   </body>
</html>

<script>
	/* ===================================================================================
			class .print_Tourney, .print_btn를 프린트시 제외한다.
			프린트를 가로로 출력한다.
		=================================================================================== */
  function OnClickPrintLeague() {
		// console.log("OnClickPrintLeague");
		var strCss = '@media print{	@page { size: landscape } .print_btn { display:none; } .print_Tourney { display:none; }';
		ctx.setElementText("id_print_cust", strCss);
    document.body.classList.add("leage");

		window.print();
	}

	/* ===================================================================================
			class .print_League, .print_btn를 프린트시 제외한다.
			프린트를 세로로 출력한다.
		=================================================================================== */
	function OnClickPrintTourney() {
		// console.log("OnClickPrintTourney");
		var strCss = '@media print{	.print_League { display:none; } .print_btn { display:none; } ';
		ctx.setElementText("id_print_cust", strCss);

		window.print();
	}
</script>

<%
   endTimer = Timer()

   strLog = sprintf("Seperate Query Time = {0}, Program Time = {1}", Array(eQueryTimer-sTartTimer, endTimer-sTartTimer))
   ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog)
%>
