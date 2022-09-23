<!-- #include virtual = "/dev/config.asp"-->
<!-- #include virtual = "/classes/JSON_2.0.4.asp" -->
<!-- #include virtual = "/classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual = "/classes/json2.asp" -->

<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->

<%
'    룰 - .          by Aramdry  2019.04.11
'
'    득점	    득점팀을 구분하고 (TourneyGroupIDX)
'                서브를 가진 팀에서 득점을 하면 서브를 가진 선수에 득점을 올려주고
'                리시브를 가진 팀에서 득점을 하면
'                현재점수가 홀수면 코트 왼쪽서브,
'                현재점수가 짝수면 코트 오른쪽서브, 서브권을 갖는 사람한테 득점을 올려준다.
'                서브시에 승점을 하면 player의 위치가 바뀐다.
'                현재점수가 홀수면 코트 왼쪽서브,
'                현재점수가 짝수면 코트 오른쪽서브,
'
'    반칙 	    반칙팀을 구분하고 (Miss_TourneyGroupIDX) 반칙팀에서 서브 / 리시브를 가진 선수에 반칙을 올려준다.
'                반칙이 연속일 경우 1,2 선수를 기준으로
'                1에 반칙이 있으면 2pos에 반칙을 .. 그후에는 1,2,1,2,1,2, 순으로 찍는다.
'                2에 반칙이 있으면 다음번 1pos에 반칙을 표시 2, 1, 2, 1, 2, 1,2 순으로 찍는다.
'
'    챌린지     반칙(Misconduct)와 같은 카테고리로 저장 되지만 Display방식은 다르다.
'               1. 챌린지 신청팀의 첫번째 선수의 Line에 표시
'					 2. 챌린지와 반칙이 겹칠경우 , 반칙의 cell과 챌린지의 cell은 겹치지 않고 ,
'					    다음 cell에 표시
'					 3. 챌린지는 챌린지의 룰로 , 반칙은 반칙의 룰로
'					 4. 반칙이 연속중에 챌린지가 있을 경우, 챌린지 까지 반칙을 기존 룰로 찍고,
'					    다음칸에 챌린지를 찍고,
'						 다음칸에 다시 반칙을 찾아서 찍는다.
'
'    표시	    득점다음에 반칙 / 반칙 다음에 득점이 발생할 경우 다음칸에 표시를 한다.
'                반칙이 연속될 경우 1,2,1,2, 순이거나 2,1,2,1,2,1 순으로 표시를 한다.
'
'    반칙중 	    강퇴나 기권이 있을 경우 DIS / RET 는 2칸 혹은 3칸에 표시하고 경기가 종료 된다. (종료 표시는 Dis에? )
'    강퇴 / 기권표시
'
'    듀스 	    20 / 20 점수를 찍고 , 다음칸에 듀스 표시를 한다.
'	            이후 득점, 반칙을 듀스 표시 다음칸에 표시한다.
'
'    서브/리시브 표시	각 세트의 처음 점수가 났을때 서브, 리시브를 가진 유저의 팀이 각각 S(서버), R(리시브)이다.
%>

<%
  Response.CharSet="utf-8"
  Session.codepage="65001"
  Response.codepage="65001"
  Response.ContentType="text/html;charset=utf-8"

	Set db = new clsDBHelper

	DEC_GameLevelDtlIDX = crypt.DecryptStringENC(Request("GameLevelDtlIDX"))
	DEC_TeamGameNum = Request("TeamGameNum")
	DEC_GameNum = Request("GameNum")
	DEC_IsPrint = Request("IsPrint")
	DEC_StadiumNum = Request("StadiumNum")

%>

<%
    Dim aryTeamInfo(4, 2), aryDRS, aryScore
    Dim MARK_DUAL, MARK_END, MARK_ENDPOINT, setMax, bDoubleGame
	 Dim MARKNAME_CHALLENGE_WIN, MARKNAME_CHALLENGE_LOSE
    Dim startGameTime, endGameTime, shuttleCnt, winner_L, winner_R , nWinner
    Dim startTimer, endTimer
    Dim colMax                      ' 한 테이블 최대 표시 Column
    Dim colNextStart                ' 다음 테이블 start column position
    Dim pos_keyword1, pos_keyword2  ' 스코어 시트 상단의 Player 이름 옆에 L, R로 표시된다.
    Dim posL_TourneyGroupIDX, posR_TourneyGroupIDX  ' position group idx
	 Dim last_jumsu_posL, last_jumsu_posR		' 챌린저 표시 위해 : 각팀의 첫번째 선수에 표시한다.
	 Dim challenge_pos

    startTimer = Timer()

	 MARKNAME_CHALLENGE_WIN		= "CW"
	 MARKNAME_CHALLENGE_LOSE	= "CL"

    MARK_DUAL   = -2          ' 듀스
    MARK_END    = -3          ' Game End - End Mark And 점수 Bold
    MARK_ENDPOINT = -4        ' End Point Bold ( End Mark는 한번뿐이 사용할수 없어서 점수가 0번 위치에 있을때만 bold )
                              ' 모든 위치에서 마지막 점수를 Bold처리하기 위해 추가 하였다.
    setMax      = 3
    bDoubleGame = 0
    colMax = 36               ' 45 => 36으로 변경        2019.06.05
    colNextStart = colMax + 1    '

	 last_jumsu_posL 	= 0		' 0점일 경우 챌린저는 각 팀의 첫번째에 표시한다.
	 last_jumsu_posR	= 2
%>

<%
      ' print 출력 Update - 2019.07.10  by aramdry
'      CSQL = "UPDATE tblGameOperate SET PrintYN = 'Y'"
'      CSQL = CSQL & " WHERE DelYN = 'N'"
'      CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "' "
'      CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "' "
'      CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "' "
'      Call db.execSQLRs(CSQL , null, ConStr)

        '협회 엘리트경기번호규칙 계산
'        ORDERSQL = "SELECT GameLevelDtlIDX, TeamGameNum, GameNum, TempNum"
'        ORDERSQL = ORDERSQL & " FROM "
'        ORDERSQL = ORDERSQL & " ("
'        ORDERSQL = ORDERSQL & " 	SELECT ROW_NUMBER() OVER(PARTITION BY GameLevelDtlIDX ORDER BY CONVERT(INT,TeamGameNum), CONVERT(INT,GameNum) ASC) TempNum, GameLeveldtlIDX, TEamgameNum, GameNum, ByeYN"
'        ORDERSQL = ORDERSQL & " 	FROM"
'        ORDERSQL = ORDERSQL & " 	("
'        ORDERSQL = ORDERSQL & " 	select GameLeveldtlIDX, TEamgameNum, GameNum, CASE WHEN L_ByeYN = 'Y' OR R_ByeYN = 'Y' THEN 'Y' ELSE 'N' END AS ByeYN"
'        ORDERSQL = ORDERSQL & " 	from tblgameOperate WHERE GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "' AND DelYN = 'N'"
'        ORDERSQL = ORDERSQL & " 	AND ((GroupGameGB = 'B0030002' AND GameNum = '0') OR (GroupGameGB = 'B0030001' AND TeamGameNum = '0'))"
'        ORDERSQL = ORDERSQL & " 	) AS A"
'        ORDERSQL = ORDERSQL & " 	WHERE ByeYN = 'N'"
'        ORDERSQL = ORDERSQL & " ) AS BB"
'        ORDERSQL = ORDERSQL & " WHERE TeamGameNum = '" & DEC_TeamGameNum & "' AND GameNum = '" & DEC_GameNum & "'"


		  	ORDERSQL = " Select GameTitleIDX, GameLevelDtlIDX, StadiumIDX, StadiumNum, TurnNum, Board_StadiumNum, Board_TempNum, TeamGameNum, GameNum , TempNum , L_KR_DPGameNum, PlayLevelType "
			ORDERSQL = ORDERSQL & " 	From tblGameOperate  "
			ORDERSQL = ORDERSQL & " 	Where GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "' AND DelYN = 'N' "
			ORDERSQL = ORDERSQL & " 	And ((GroupGameGB = 'B0030002' AND GameNum = '0') Or (GroupGameGB = 'B0030001')) "
			ORDERSQL = ORDERSQL & " 	And (L_ByeYN = 'N' And R_ByeYN = 'N') "
			ORDERSQL = ORDERSQL & " 	And TeamGameNum = '" & DEC_TeamGameNum & "' AND GameNum = '" & DEC_GameNum & "'"



			Set ORDERRs = db.ExecSQLReturnRS(ORDERSQL , null, ConStr)
        If Not ORDERRs.EOF Then
            'ByeCnt_arr = ORDERRs.getrows()
            Display_GameNum = ORDERRs("L_KR_DPGameNum")
				PlayLevelType = ORDERRs("PlayLevelType")
				Display_CourtNum = ORDERRs("Board_StadiumNum")

				If(PlayLevelType = "B0100001") Then 
					Display_GameNum = sprintf("Q-{0}", Array(Display_GameNum))
				End If 
        End If
        ORDERRs.Close
        set ORDERRs = nothing

		strLog = sprintf("ORDERSQL = {0}", Array(ORDERSQL))
	 	' Call TraceLog(SPORTS_LOG1, strLog)

		titleSQL = "(select top 1 gametitlename from tblGameTitle where gametitleidx = CCC.GameTitleIDX ) as gametitle "
        GameGBSQL = "(select top 1 GameGb from tblGameTitle where gametitleidx = CCC.GameTitleIDX ) as GameGb "
        subSqlEngL1 = "(Select top 1 UserEnName From tblMember Where MemberIDX = LPlayerIDX1) As LPlayerEngName1"
        subSqlEngL2 = "(Select top 1 UserEnName From tblMember Where MemberIDX = LPlayerIDX2) As LPlayerEngName2"
        subSqlEngR1 = "(Select top 1 UserEnName From tblMember Where MemberIDX = RPlayerIDX1) As RPlayerEngName1"
        subSqlEngR2 = "(Select top 1 UserEnName From tblMember Where MemberIDX = RPlayerIDX2) As RPlayerEngName2"
        subSqlEngTeamL1 = "(Select top 1 TeamEnNm From tblTeamInfo Where Team = LTeamCode1) As LTeamEngName1"
        subSqlEngTeamL2 = "(Select top 1 TeamEnNm From tblTeamInfo Where Team = LTeamCode2) As LTeamEngName2"
        subSqlEngTeamR1 = "(Select top 1 TeamEnNm From tblTeamInfo Where Team = RTeamCode1) As RTeamEngName1"
        subSqlEngTeamR2 = "(Select top 1 TeamEnNm From tblTeamInfo Where Team = RTeamCode2) As RTeamEngName2"


		LSQL = " SELECT "& titleSQL &", CCC.GameTitleIDX, CCC.GameLevelDtlIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
		LSQL = LSQL & " 	CCC.TeamGbNM, CCC.LevelNM, CCC.PlayTypeNM,"
		LSQL = LSQL & " 	CCC.LResult, CCC.LResultType, CCC.LResultNM, CCC.LJumsu, CCC.LResultDtl,"
		LSQL = LSQL & " 	CCC.RResult, CCC.RResultType, CCC.RResultNM, CCC.RJumsu, CCC.RResultDtl,"
		LSQL = LSQL & " 	CCC.GameStatus, CCC.[ROUND] AS GameRound, CCC.Sex,"
		LSQL = LSQL & " 	CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
		LSQL = LSQL & " 	CCC.LPlayer1, ISNULL(CCC.LPlayer2,'') AS LPlayer2, CCC.Rplayer1, ISNULL(CCC.Rplayer2,'') AS Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
		LSQL = LSQL & " 	CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType, LevelJooName,"
		LSQL = LSQL & " 	CCC.Win_TourneyGroupIDX, CCC.LGroupJumsu, CCC.RGroupJumsu, CCC.LDtlJumsu, CCC.RDtlJumsu, CCC.MaxPoint, "

		LSQL = LSQL & " dbo.FN_NameSch(CCC.Sex, 'PubCode') AS SexName,"
		LSQL = LSQL & " dbo.FN_NameSch(CCC.PlayType, 'PubCode') AS PlayTypeName,"
		LSQL = LSQL & " dbo.FN_NameSch(CCC.TeamGb, 'TeamGb') AS TeamGbName,"
		LSQL = LSQL & " dbo.FN_NameSch(CCC.Level, 'Level') AS LevelName,"
		LSQL = LSQL & " CCC.LevelJooNum AS LevelJooNumDtl,"
'		LSQL = LSQL & " LPlayerIDX1, LPlayerIDX2, RPlayerIDX1, RPlayerIDX2, LTeamCode1, LTeamCode2, RTeamCode1, RTeamCode2, dbo.FN_NameSch(CheifIDX,'CheifIDX') AS CheifName, dbo.FN_NameSch(CheifSubIDX,'CheifIDX') AS CheifSubName,"

      LSQL = LSQL & " LPlayerIDX1, LPlayerIDX2, RPlayerIDX1, RPlayerIDX2, LTeamCode1, LTeamCode2, RTeamCode1, RTeamCode2, "
      LSQL = LSQL & " (Select CheifName From tblGameCheif As GCF Where GCF.DelYN = 'N' And GCF.GameTitleIDX = CCC.GameTitleIDX And GCF.CheifIdx = CCC.CheifIDX) AS CheifName, "
      LSQL = LSQL & " (Select CheifName From tblGameCheif As GCF Where GCF.DelYN = 'N' And GCF.GameTitleIDX = CCC.GameTitleIDX And GCF.CheifIdx = CCC.CheifSubIDX) AS CheifSubName,"

        LSQL = LSQL & strPrintf("{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7},  ", _
                        Array(subSqlEngL1, subSqlEngL2, subSqlEngR1, subSqlEngR2, subSqlEngTeamL1, subSqlEngTeamL2, subSqlEngTeamR1, subSqlEngTeamR2))
        LSQL = LSQL & GameGBSQL         ' 국제 경기 / 국내경기 구분

        LSQL = LSQL & " ,LteamDtl, RTeamDtl"
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
        LSQL = LSQL & " 	LTeamCode1, LTeamCode2, RTeamCode1, RTeamCode2,"
		LSQL = LSQL & " 	BBB.Win_TourneyGroupIDX, BBB.LGroupJumsu, BBB.RGroupJumsu, BBB.LDtlJumsu, BBB.RDtlJumsu, BBB.MaxPoint, BBB.CheifIDX, BBB.CheifSubIDX, BBB.LTeamDtl, BBB.RTeamDtl "
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
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2,"

        LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LTeamCodes) > 0 THEN LEFT(LTeamCodes,CHARINDEX('|',LTeamCodes)-1) ELSE LTeamCodes END AS LTeamCode1, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LTeamCodes) > 0 THEN RIGHT(LTeamCodes,CHARINDEX('|',REVERSE(LTeamCodes))-1) ELSE '' END AS LTeamCode2, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RTeamCodes) > 0 THEN LEFT(RTeamCodes,CHARINDEX('|',RTeamCodes)-1) ELSE RTeamCodes END AS RTeamCode1, "
		LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RTeamCodes) > 0 THEN RIGHT(RTeamCodes,CHARINDEX('|',REVERSE(RTeamCodes))-1) ELSE '' END AS RTeamCode2,"

		LSQL = LSQL & " 		CheifIDX,"
		LSQL = LSQL & " 		CheifSubIDX, LTeamDtl, RTeamDtl"
		LSQL = LSQL & " 		FROM"
		LSQL = LSQL & " 		("
		LSQL = LSQL & " 		    SELECT A.GameTitleIDX, A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
		LSQL = LSQL & " 		    dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
		LSQL = LSQL & " 		    dbo.FN_NameSch(D.PlayType,'PubCode') AS PlayTypeNM,"
		LSQL = LSQL & " 		    E.Result AS LResult, E.ResultDtl AS LResultDtl, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu,"
		LSQL = LSQL & " 		    F.Result AS RResult, F.ResultDtl AS RResultDtl, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu,"
		LSQL = LSQL & " 		    E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
		LSQL = LSQL & " 		    dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
		LSQL = LSQL & " 		    A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, D.PlayType, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName, C.MaxPoint,"
		LSQL = LSQL & " 				dbo.FN_WinGroupIDX(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS TourneyGroupIDX,"
		LSQL = LSQL & " 				dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, A.TourneyGroupIDX) AS LGroupJumsu, "
		LSQL = LSQL & " 				dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, B.TourneyGroupIDX) AS RGroupJumsu, "
		LSQL = LSQL & " 				dbo.FN_1GameWinPoint(A.GameLevelDtlidx, A.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS LDtlJumsu, "
		LSQL = LSQL & " 				dbo.FN_1GameWinPoint(A.GameLevelDtlidx, B.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS RDtlJumsu "

		LSQL = LSQL & " 		    ,STUFF(("
		LSQL = LSQL & " 		    		SELECT  '|'   + UserName "
		LSQL = LSQL & " 		    		FROM    dbo.tblTourneyPlayer AAA  With (Nolock) "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
		LSQL = LSQL & " 					AND DelYN = 'N'"
        LSQL = LSQL & " 					FOR XML PATH('')  "

		LSQL = LSQL & " 		    		),1,1,'') AS LPlayers"

		LSQL = LSQL & " 		    ,STUFF(("
		LSQL = LSQL & " 		    		SELECT  '|'   + CONVERT(VARCHAR(10),MemberIDX) "
		LSQL = LSQL & " 		    		FROM    dbo.tblTourneyPlayer AAA  With (Nolock) "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
		LSQL = LSQL & " 					AND DelYN = 'N'"
        LSQL = LSQL & " 					FOR XML PATH('')  "
		LSQL = LSQL & " 		    		),1,1,'') AS LPlayerIDXs"

		LSQL = LSQL & " 		    ,STUFF(("
		LSQL = LSQL & " 		    		SELECT  '|'   + UserName "
		LSQL = LSQL & " 		    		FROM    dbo.tblTourneyPlayer AAA  With (Nolock) "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
		LSQL = LSQL & " 					AND DelYN = 'N'"
        LSQL = LSQL & " 		    		FOR XML PATH('')  "

		LSQL = LSQL & " 		    		),1,1,'') AS RPlayers"

		LSQL = LSQL & " 		    ,STUFF(("
		LSQL = LSQL & " 		    		SELECT  '|'   + CONVERT(VARCHAR(10),MemberIDX) "
		LSQL = LSQL & " 		    		FROM    dbo.tblTourneyPlayer AAA  With (Nolock) "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
		LSQL = LSQL & " 					AND DelYN = 'N'"
        LSQL = LSQL & " 		    		FOR XML PATH('')  "
		LSQL = LSQL & " 		    		),1,1,'') AS RPlayerIDXs"

		LSQL = LSQL & " "
		LSQL = LSQL & " 		    ,STUFF((		"
		LSQL = LSQL & " 		    		SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
		LSQL = LSQL & " 		    		FROM    dbo.tblTourneyPlayer AAA  With (Nolock) "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
		LSQL = LSQL & " 					AND DelYN = 'N'"
        LSQL = LSQL & " 		    		FOR XML PATH('')  "
		LSQL = LSQL & " 		    		),1,1,'') AS LTeams"

		LSQL = LSQL & " 		    ,STUFF((		"
		LSQL = LSQL & " 		    		SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
		LSQL = LSQL & " 		    		FROM    dbo.tblTourneyPlayer AAA  With (Nolock) "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
		LSQL = LSQL & " 					AND DelYN = 'N'"
        LSQL = LSQL & " 		    			FOR XML PATH('')  "
		LSQL = LSQL & " 		    		),1,1,'') AS RTeams"

        LSQL = LSQL & " "
		LSQL = LSQL & " 		    ,STUFF((		"
		LSQL = LSQL & " 		    		SELECT  '|'   + Team"
		LSQL = LSQL & " 		    		FROM    dbo.tblTourneyPlayer AAA  With (Nolock) "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
		LSQL = LSQL & " 					AND DelYN = 'N'"
        LSQL = LSQL & " 		    		FOR XML PATH('')  "
		LSQL = LSQL & " 		    		),1,1,'') AS LTeamCodes "

		LSQL = LSQL & " 		    ,STUFF((		"
		LSQL = LSQL & " 		    		SELECT  '|'   + Team"
		LSQL = LSQL & " 		    		FROM    dbo.tblTourneyPlayer AAA  With (Nolock) "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
		LSQL = LSQL & " 					AND DelYN = 'N'"
        LSQL = LSQL & " 		    			FOR XML PATH('')  "
		LSQL = LSQL & " 		    		),1,1,'') AS RTeamCodes, "

		LSQL = LSQL & " 		    STUFF((		"
		LSQL = LSQL & " 		    		SELECT  '|'   + Teamdtl"
		LSQL = LSQL & " 		    		FROM    dbo.tblTourneyPlayer AAA  With (Nolock) "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
		LSQL = LSQL & " 					AND DelYN = 'N'"
        LSQL = LSQL & " 		    			FOR XML PATH('')  "
		LSQL = LSQL & " 		    		),1,1,'') AS LTeamDtl, "

		LSQL = LSQL & " 		    STUFF((		"
		LSQL = LSQL & " 		    		SELECT  '|'   + Teamdtl"
		LSQL = LSQL & " 		    		FROM    dbo.tblTourneyPlayer AAA  With (Nolock) "
		LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
		LSQL = LSQL & " 					AND DelYN = 'N'"
        LSQL = LSQL & " 		    			FOR XML PATH('')  "
		LSQL = LSQL & " 		    		),1,1,'') AS RTeamDtl, "


		LSQL = LSQL & " 				A.CheifIDX, A.CheifSubIDX"
		LSQL = LSQL & " 		    FROM tblTourney A With (Nolock)"
		LSQL = LSQL & " 		    INNER JOIN tblTourney B With (Nolock) ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
		LSQL = LSQL & " 		    INNER JOIN tblGameLevelDtl C With (Nolock) ON C.GameLevelDtlidx = A.GameLevelDtlidx"
		LSQL = LSQL & " 		    INNER JOIN tblGameLevel D With (Nolock) ON D.GameLevelidx = C.GameLevelidx"
		LSQL = LSQL & " 		    	LEFT JOIN ("
		LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
		LSQL = LSQL & " 		    		FROM dbo.tblGameResult With (Nolock)"
		LSQL = LSQL & " 		    		WHERE DelYN = 'N'"
		LSQL = LSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
		LSQL = LSQL & " 		    		) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
		LSQL = LSQL & " 		    	LEFT JOIN ("
		LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
		LSQL = LSQL & " 		    		FROM dbo.tblGameResult With (Nolock)"
		LSQL = LSQL & " 		    		WHERE DelYN = 'N'"
		LSQL = LSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, ResultDtl, Jumsu"
		LSQL = LSQL & " 		    		) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = B.TeamGameNum AND F.GameNum = B.GameNum AND F.TourneyGroupIDX = B.TourneyGroupIDX    "
		LSQL = LSQL & " 		    	LEFT JOIN ("
		LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum "
		LSQL = LSQL & " 		    		FROM dbo.tblGameSign With (Nolock)"
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
	rs.Close

	Set game = JSON.Parse("{}")

	If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
				For i=0 To rsloopcnt
					Call game.Set( fieldarr(i),  arrRS( i ,ar) )
				Next
		Next
	End if

'    ===============================================================================
'    GameResult Query
'   ===============================================================================
    'SQL = "SELECT "
    'SQL = SQL & "SetNum, "			        ' Set Number
    'SQL = SQL & "Jumsu, "			        ' 획득 점수 ( 누적 아님 )
    'SQL = SQL & "NowGameDeuceYN, "		    ' 듀스 여부
    'SQL = SQL & "IsNull( (Select PubSubName From tblPubcode With (NoLock) Where PubCode = SpecialtyGb) , '') As WarningMark, "  ' 반칙 약어 ( W, F, R, O, I , DIS, RET, C, S)
    'SQL = SQL & "ServeMemberIDX, "		    '서브넣은 선수 IDX,
    'SQL = SQL & "RecieveMemberIDX, "	    '리시브받은 선수 IDX
    'SQL = SQL & "Miss_MemberIDX, "		    '반칙한 선수
    'SQL = SQL & "TourneyGroupIDX, "	        ' 득점팀 IDX
    'SQL = SQL & "Miss_TourneyGroupIDX, "	'반칙한 팀 IDX
    'SQL = SQL & "Convert(varchar(23), WriteDate,20) AS WriteDate "	            'wirte time  - 여기서 게임 종료 시간을 추출한다. ( 제일 마지막 입력시간 - 1점 만 해당 )
    'SQL = SQL & "FROM tblgameresultdtl "
    'SQL = SQL & strPrintf("WHERE delYN = 'N' AND GameLeveldtlIDX = '{0}' AND TeamGameNum = '{1}' AND GameNum = '{2}' ", _
    '    Array(DEC_GameLevelDtlIDX, DEC_TeamGameNum, DEC_GameNum))
    'SQL = SQL & "Order By WriteDate"
    'Response.Write SQL

    SQL = "SELECT SetNum, Jumsu, NowGameDeuceYN,"
    SQL = SQL & " WarningMark,"
    SQL = SQL & " ServeMemberIDX, RecieveMemberIDX, Miss_MemberIDX, "
    SQL = SQL & " TourneyGroupIDX, Miss_TourneyGroupIDX, WriteDate,"
    SQL = SQL & " GameResultDtlIDX, ORDERBY"
    SQL = SQL & " FROM"
    SQL = SQL & " ("
    SQL = SQL & "     SELECT SetNum, Jumsu, NowGameDeuceYN, "
    SQL = SQL & "     IsNull( (Select PubSubName From tblPubcode With (NoLock) Where PubCode = SpecialtyGb) , '') As WarningMark, "
    SQL = SQL & "     ServeMemberIDX, RecieveMemberIDX, Miss_MemberIDX, "
    SQL = SQL & "     TourneyGroupIDX, Miss_TourneyGroupIDX, Convert(varchar(23), WriteDate,20) AS WriteDate,"
    SQL = SQL & "     GameResultDtlIDX, 0 AS ORDERBY"
    SQL = SQL & "     FROM tblgameresultdtl "

    SQL = SQL & strPrintf(" WHERE delYN = 'N' AND Jumsu <> '0' AND GameLeveldtlIDX = '{0}' AND TeamGameNum = '{1}' AND GameNum = '{2}'", Array(DEC_GameLevelDtlIDX, DEC_TeamGameNum, DEC_GameNum))

    SQL = SQL & "     UNION ALL"

    SQL = SQL & "     SELECT A.SetNum, '0' AS Jumsu, 'N' AS NowGameDeuceYN, "
    SQL = SQL & "     IsNull( (Select PubSubName From tblPubcode With (NoLock) Where PubCode = MissConductCode) , '') As WarningMark,"
    SQL = SQL & "     B.ServememberIDX, B.RecieveMemberIDX, A.MemberIDX AS Miss_MemberIDX,"
    SQL = SQL & "     B.TourneyGroupIDX, A.TourneyGroupIDX AS Miss_TourneyGroupIDX, CONVERT(varchar(23), A.WriteDate,20) AS WriteDate,"
    SQL = SQL & "     A.GameResultDtlIDX, ORDERBY"
    SQL = SQL & "     FROM tblMissConduct A"
    SQL = SQL & "     INNER JOIN tblgameresultdtl B ON A.GameLeveldtlIDX = B.GameLeveldtlIDX AND B.GameResultDtlIDX = A.GameResultDtlIDX"

    SQL = SQL & strPrintf(" WHERE A.DelYN = 'N' AND B.DelYN = 'N' AND B.Jumsu <> '0' AND A.GameLeveldtlIDX = '{0}' AND A.TeamGameNum = '{1}' AND A.GameNum = '{2}'", Array(DEC_GameLevelDtlIDX, DEC_TeamGameNum, DEC_GameNum))

    SQL = SQL & " ) AS AA"
    SQL = SQL & " ORDER BY GameResultDtlIDX ASC, ORDERBY ASC "

    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    If Not rs.EOF Then
        aryDRS = rs.getRows()
    End if
    rs.Close

'    ===============================================================================
'        position info query
'   ===============================================================================
      SQL = "SELECT Pst_TourneyGroupIDX_L,Pst_TourneyGroupIDX_R "
      SQL = SQL & " FROM tblgameresultdtl"
      SQL = SQL & strPrintf(" WHERE DelyN = 'N' AND GameLeveldtlIDX = '{0}' AND TeamGameNum = '{1}' AND GameNum = '{2}' AND SetNum = '1' AND Jumsu = '0'", _
                     Array(DEC_GameLevelDtlIDX, DEC_TeamGameNum, DEC_GameNum))

      Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

      pos_keyword1 = "L"
      pos_keyword2 = "R"

      If Not rs.EOF Then
         posL_TourneyGroupIDX = rs("Pst_TourneyGroupIDX_L")
         posR_TourneyGroupIDX = rs("Pst_TourneyGroupIDX_R")

         strLog = strPrintf("pos = ({0}, {1}, LTourney = ({2},{3})", _
               Array(posL_TourneyGroupIDX, posR_TourneyGroupIDX, game.LTourneyGroupIDX, game.RTourneyGroupIDX))

         If(CStr(posL_TourneyGroupIDX) = CStr(game.LTourneyGroupIDX)) Then
            pos_keyword1 = "L"
            pos_keyword2 = "R"
         Else
            pos_keyword1 = "R"
            pos_keyword2 = "L"
         End If
      End if
      rs.Close
'    ===============================================================================
'    Game Player Info
'   ===============================================================================
    aryTeamInfo(0,0) = game.LTourneyGroupIDX
    aryTeamInfo(1,0) = game.LTourneyGroupIDX
    aryTeamInfo(2,0) = game.RTourneyGroupIDX
    aryTeamInfo(3,0) = game.RTourneyGroupIDX

    aryTeamInfo(0,1) = game.LPlayerIDX1
    aryTeamInfo(1,1) = game.LPlayerIDX2
    aryTeamInfo(2,1) = game.RPlayerIDX1
    aryTeamInfo(3,1) = game.RPlayerIDX2

'    ===============================================================================
'    Game Type - Single / Double
'   ===============================================================================
    If(game.LPlayerIDX2 <> "") Then bDoubleGame = 1 End If

'    ===============================================================================
'    Game Set Score
'   ===============================================================================
    If( IsArray (aryDRS) ) Then
        aryScore = getSetScore(aryDRS)
    End If

'   ===============================================================================
'    		Game Result - Get Winner
'   ===============================================================================
	SQL = 		" Select O.L_Result, P.PubType As LResult, O.GameStatus From  tblgameOperate As O WITH(NOLOCK) "
	SQL = SQL & " 	Inner Join tblPubcode As P On P.DelYN = 'N' And P.PubCode = L_Result  "
	SQL = SQL & " 	Where O.DelYN = 'N' And O.GameStatus = 'GameEnd' "
	SQL = SQL & strPrintf(" 	And O.GameLevelDtlIDX = '{0}' And TeamGameNum = '{1}' And GameNum = '{2}' ", _
						Array(DEC_GameLevelDtlIDX, DEC_TeamGameNum, DEC_GameNum))

	nWinner = 0
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.EOF Then
      	If(rs("LResult") = "WIN") Then
		  		nWinner = 1
			ElseIf(rs("LResult") = "LOSE") Then
				nWinner = -1
			End If
    End if
    rs.Close

'    ===============================================================================
'    Game Winner
'   ===============================================================================
    If( IsArray (aryScore) ) Then
	 		If(nWinner = 0) Then
        		nWinner = getWinner(aryScore)
			End If

        If(nWinner > 0) Then
            winner_L = "s_win"
        ElseIf(nWinner < 0) Then
            winner_R = "s_win"
        End If
    End If

'    ===============================================================================
'    Game ShuttleCock Count
'   ===============================================================================
    SQL = "Select Count(ShuttlecockCountIDX) AS ShuttlCnt From tblShuttlecockCount With (Nolock) "
    SQL = SQL & strPrintf("Where DelYN = 'N' And GameLevelDtlIDX = '{0}'  AND TeamGameNum = '{1}'  AND GameNum = '{2}'", _
            Array(DEC_GameLevelDtlIDX, DEC_TeamGameNum, DEC_GameNum))

    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    If Not rs.EOF Then
        shuttleCnt = rs("ShuttlCnt")
    End If
    rs.Close

'    ===============================================================================
'    Game Start Time
'   ===============================================================================
    SQL = "Select Convert(varchar(23), WriteDate,20) AS startTime From tblGameProgress "
    SQL = SQL & strPrintf("WHERE DelYN = 'N' And SetNum = '1' AND GameLevelDtlIDX = '{0}'  AND TeamGameNum = '{1}'  AND GameNum = '{2}'", _
            Array(DEC_GameLevelDtlIDX, DEC_TeamGameNum, DEC_GameNum))

    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    If Not rs.EOF Then
        startGameTime = rs("startTime")
    End If
    rs.Close

'    ===============================================================================
'    Game End Time
'   ===============================================================================
    If( IsArray (aryDRS) ) Then
        endGameTime = getEndTime(aryDRS)
    End If

'    ===============================================================================
'    Game Type - 국내 / 국제 경기
'   ===============================================================================
    If( game.GameGb = "B0010002") Then setMax = 5 End If  '국제대회

    '한일대항전 5세트->3세트변경 임시처리
    setMax = 3

    endTimer = Timer()

    strLog = strPrintf("Srore Query Process Time = {0}", Array(endTimer - startTimer))

'    ===============================================================================
'    Game Team Display - 복식일 경우 팀이 틀리면 2개의 팀을 표시한다.
'   ===============================================================================
%>

<%
'   ===============================================================================
   '   Sub Function

   '   ===============================================================================
   '       게임 구분에 필요한 단어들을 입력받아 축약어를 만든다.
   '       여대복 (개인전)
   '   ===============================================================================
   Function GetShortKindName(strSex, strTeamGB, strPlayType, GameNum)
      Dim shSex, shTeamGb, shPlayType, strShort
      If(strSex <> "") Then shSex = Mid(strSex, 1, 1) End If
      If(strTeamGB <> "") Then shTeamGb = Mid(strTeamGB, 1, 1) End If
      If(strPlayType <> "") Then shPlayType = Mid(strPlayType, 1, 1) End If

      strShort = strPrintf("{0}{1}{2}-{3}", Array(shSex, shTeamGb, shPlayType, AppendZero(GameNum,2)))
      GetShortKindName = strShort
   End Function

'   ===============================================================================
'        TeamName 2개를 입력받아 같으면 1개 , 틀리면 team1/team2로 만들어 반환한다.
'   ===============================================================================
   Function getTeamName(team1, team2)
         Dim TeamName
         If( team1 = "" Or team2 = "" ) Then
            If( team1 <> "" ) Then
               TeamName = team1
            Else
               TeamName = team2
            End If
         Else
            If(team1 = team2) Then
               TeamName = team1
            Else
               If( team1 <> "" And team2 <> "") Then
                  TeamName = strPrintf("{0} / {1}", Array(team1, team2))
               Else
                  TeamName = team1
               End If
            End If
         End If

         getTeamName = TeamName
    End Function

'    Function getTeamName(team1, team2)
'         Dim TeamName
'         If(team1 = team2) Then
'            TeamName = team1
'         Else
'            TeamName = strPrintf("{0} / {1}", Array(team1, team2))
'         End If
'
'         getTeamName = TeamName
'    End Function

'   ===============================================================================
'        startTime, endTime을 입력받아 분단위로 그차이를 반환한다.
'   ===============================================================================
    Function getDuration(strSTime, strETime)
         Dim diffTime, sTime, eTime

         sTime = CDate(strSTime)
         eTime = CDate(strETime)
         DiffTime = DateDiff("n", sTime, eTime)

         getDuration = diffTime
    End Function

'   ===============================================================================
'       날짜 문자열 (2019-06-04 17:42:11)을 입력받아 시:분으로 문자열을 반환한다.
'   ===============================================================================
    Function getShortTime(strTime)
      getShortTime = etcGetBlockData(strTime, " ", ":")
    End Function

'   ===============================================================================
'        Player MemberIdx를 입력받아 Player 순서를 반환한다.
'   ===============================================================================
    Function getPlayerPosEx(memIdx)
        Dim p_order, pai, t_memIdx
        p_order = -1
        t_memIdx = CStr(memIdx)

        For pai = 0 To 3
            If( aryTeamInfo(pai,1) = t_memIdx ) Then
                p_order = pai
                Exit For
            End If
        Next

        getPlayerPosEx = p_order
    End Function

'   ===============================================================================
'        Player MemberIdx, winTeamGroupIdx를 입력받아 getDataIdx 순서를 반환한다.
'        서브를 가진 팀에서 득점을 하면 서브를 가진 선수에 득점을 올려주고
'        리시브를 가진 팀에서 득점을 하면
'                현재점수가 홀수면 코트 왼쪽서브,
'                현재점수가 짝수면 코트 오른쪽서브, 서브권을 갖는 사람한테 득점을 올려준다.
'                서브시에 승점을 하면 player의 위치가 바뀐다.
'   ===============================================================================
    Function getScorePos(serveIdx, receiveIdx, winGroupIdx, prevPos, tscore_L, tscore_R, ByRef toggle_L, ByRef toggle_R)
        Dim p_order, pai, t_order1, t_order2, t_score, t_order_serve

        p_order = -1

        ' 이긴 팀을 구한다.
        t_order1 = getTeamPos(winGroupIdx)
        t_order2 = getTeamPosByPos(prevPos)

        ' 서브 팀을 구한다. - 해당 팀의 선수를 toggle하기 위해서
        t_order_serve = getTeamPosEx(serveIdx)

        ' 서브 팀에서 승점을 하면 팀원은 위치를 바꾼다.
        if(t_order_serve = t_order1) Then
            If( t_order_serve = 0 ) Then
                If( toggle_L = 0 ) Then
                    toggle_L = 1
                Else
                    toggle_L = 0
                End If
            Else
                If( toggle_R = 0 ) Then
                    toggle_R = 1
                Else
                    toggle_R = 0
                End If
            End If
        End If

        ' 승점을 딴 팀이 계속 승점을 따고 있으면 이전에 득점한 선수에 점수를 올려준다.
        If(t_order1 = t_order2) Then
            getScorePos = prevPos
            Exit Function
        End If


        For pai = 0 To 3    ' 승점을 서브권에서 따면
            If( aryTeamInfo(pai,0) = CStr(winGroupIdx) And aryTeamInfo(pai,1) = CStr(serveIdx) ) Then
                p_order = pai
                Exit For      ' 승점을 리스브 권에서 따면
            ElseIf( aryTeamInfo(pai,0) = CStr(winGroupIdx) And aryTeamInfo(pai,1) = CStr(receiveIdx)  ) Then
                If( t_order1 = 0 ) Then
                    t_score = tscore_L + 1

                    If( toggle_L = 1 ) Then       ' 선수의 위치가 바뀌었다면
                        If( t_score Mod 2 = 0 ) Then '현재점수가 짝수면 코트 오른쪽 득점
                            p_order = 0
                        Else                         ' 현재점수가 홀수면 코트 왼쪽 득점
                            p_order = 1
                        End If
                    Else
                        If( t_score Mod 2 = 0 ) Then '현재점수가 짝수면 코트 오른쪽 득점
                            p_order = 1
                        Else                         ' 현재점수가 홀수면 코트 왼쪽 득점
                            p_order = 0
                        End If
                    End If
                Else
                    t_score = tscore_R + 1

                    If( toggle_R = 1 ) Then       ' 선수의 위치가 바뀌었다면
                        If( t_score Mod 2 = 0 ) Then '현재점수가 짝수면 코트 오른쪽 득점
                            p_order = 2
                        Else                         ' 현재점수가 홀수면 코트 왼쪽 득점
                            p_order = 3
                        End If
                    Else
                        If( t_score Mod 2 = 0 ) Then '현재점수가 짝수면 코트 오른쪽 득점
                            p_order = 3
                        Else                         ' 현재점수가 홀수면 코트 왼쪽 득점
                            p_order = 2
                        End If
                    End If
                End If

                Exit For
            End If
        Next

        getScorePos = p_order
    End Function

'   ===============================================================================
'        Player MemberIdx, winTeamGroupIdx를 입력받아 getDataIdx 순서를 반환한다.
'   ===============================================================================
    Function getScorePosSingle(serveIdx, receiveIdx, winGroupIdx)
        Dim p_order, pai
        p_order = -1

        For pai = 0 To 3
            If( aryTeamInfo(pai,0) = CStr(winGroupIdx) And (aryTeamInfo(pai,1) = CStr(serveIdx) Or aryTeamInfo(pai,1) = CStr(receiveIdx)  )) Then
                p_order = pai
                Exit For
            End If
        Next

        getScorePosSingle = p_order
    End Function

'   ===============================================================================
'        Player MemberIdx를 입력받아 Team 순서를 반환한다.
'   ===============================================================================
    Function getTeamPosEx(memIdx)
       Dim t_order, tai, t_memIdx
        t_order = -1

        t_memIdx = CStr(memIdx)
        For tai = 0 To 3
            If( aryTeamInfo(tai,1) = t_memIdx ) Then
                If( tai < 2 ) Then
                    t_order = 0
                Else
                    t_order = 1
                End If
                Exit For
            End If
        Next

        getTeamPosEx = t_order
    End Function

'   ===============================================================================
'        GroupIdx를 입력받아 Team 순서를 반환한다.
'   ===============================================================================
    Function getTeamPos(groupIdx)
       Dim t_order, tai
        t_order = -1

        For tai = 0 To 3
            If( aryTeamInfo(tai,0) = CStr(groupIdx) ) Then
                If( tai < 2 ) Then
                    t_order = 0
                Else
                    t_order = 1
                End If
                Exit For
            End If
        Next

        getTeamPos = t_order
    End Function

'   ===============================================================================
'      player position을 입력받아 Team position을 구한다.
'   ===============================================================================
    Function getTeamPosByPos(pos)
        Dim t_order

        t_order = -1
        pos = CDbl(pos)
        If(pos > 0 And pos < 4) Then
            if(pos < 2) Then
                t_order = 0
            Else
                t_order = 1
            End If
        End If
        getTeamPosByPos = t_order
    End Function

'   ===============================================================================
'        Game End Time을 얻는다.
'   ===============================================================================
    Function getEndTime(rAry)
        Dim endTime
        Dim ai, aul
        Dim tWriteTime

        aul = UBound(rAry, 2)
        curSet = 1
        score_L = 0
        score_R = 0

        For ai = 0 To aul
            tWriteTime = rAry(9, ai)
            tScore = rAry(1, ai)                    ' Jumsu
            '   ===============================================================================
            '    Jumsu가 1일 경우 점수를 나눈다. ( 승점팀의 Serve/Receive Member 기준 )
            If(tScore = 1) Then
                endTime = tWriteTime
            End If
        Next

        getEndTime =  endTime
    End Function


'   ===============================================================================
'        Set Score Array를 넘겨받아 승자를 반환한다.

'   ===============================================================================
    Function getWinner(rAry)
        Dim nWinner, ai, aul

        If( Not IsArray(rAry) ) Then
            getWinner = 0
        End If

        aul = UBound(rAry, 2)
        nWinner = 0

        For ai = 0 To aul
            If(rAry(0,ai) > rAry(1,ai)) Then
                nWinner = nWinner + 1
            ElseIf(rAry(0,ai) < rAry(1,ai)) Then
                nWinner = nWinner - 1
            End If
        Next

        getWinner = nWinner
    End Function
'   ===============================================================================
'        각 Set Score를 얻는다.
'       SetNum, Jumsu, NowGameDeuceYN, WarningMark, ServeMemberIDX, RecieveMemberIDX, Miss_MemberIDX,
'       TourneyGroupIDX, Miss_TourneyGroupIDX
'   ===============================================================================
    Function getSetScore(rAry)
        Dim rAryScore(2, 5)
        Dim ai, aul, curSet
        Dim score_L, score_R, opScore_L, opScore_R, useOpScore, nTeamPos
        Dim tnSet,tScore, tServeIdx, tReceiveIdx, tWinGroupIdx

        useOpScore = 1

        If( Not IsArray(rAry)) Then
            getScoreInfo = rAryScore
            Exit Function
        End If

        aul = UBound(rAry, 2)
        curSet = 1
        score_L = 0
        score_R = 0

        For ai = 0 To aul
            tnSet = rAry(0, ai)
            tScore = rAry(1, ai)                    ' Jumsu
            tServeIdx = rAry(4, ai)                 ' ServeMemberIDX
            tReceiveIdx = rAry(5, ai)               ' RecieveMemberIDX
            tWinGroupIdx = rAry(7, ai)              ' TourneyGroupIDX

            If(curSet <> tnSet) Then
                rAryScore(0, curSet-1) = score_L
                rAryScore(1, curSet-1) = score_R

                curSet = tnSet
                score_L = 0
                score_R = 0
            End If

            '   ===============================================================================
            '    3. Jumsu가 1일 경우 점수를 나눈다. ( 승점팀의 Serve/Receive Member 기준 )
            If(tScore = 1) Then
                nTeamPos = getTeamPos(tWinGroupIdx)

                If(nTeamPos = 0) Then   ' Left score
                    score_L = score_L + 1
                    score_tmp = score_L
                Else            ' Right score
                    score_R = score_R + 1
                    score_tmp = score_R
                End If

                useOpScore = 0
            End If
        Next

        ' 제일 마지막 스코어
        rAryScore(0, curSet-1) = score_L
        rAryScore(1, curSet-1) = score_R

        getSetScore =  rAryScore
    End Function

'   ===============================================================================
'       Set Number를 입력받아 Data를 얻는다.
'       Server / Receive 표시
'       점수 누적 표시
'       Miss Mark 표시
'       SetNum, Jumsu, NowGameDeuceYN, WarningMark, ServeMemberIDX, RecieveMemberIDX, Miss_MemberIDX,
'       TourneyGroupIDX, Miss_TourneyGroupIDX

'    구현
'    * . 4개의 Data 배열을 만들어서 4개의 <tr>의 <td>를 채운다.
'    * . 위에서 부터 1, 2, 3, 4 ( Left1, Left2, Right1, Right2 ) 의 값으로 위치를 관리한다.
'    1. SetNum을 기준으로 데이터를 나눈다.
'    2. Jumsu가 1일 경우 점수를 나눈다. ( 승점팀의 Serve/Receive Member 기준 )
'    득점	    득점팀을 구분하고 (TourneyGroupIDX)
'                서브를 가진 팀에서 득점을 하면 서브를 가진 선수에 득점을 올려주고
'                리시브를 가진 팀에서 득점을 하면
'                현재점수가 홀수면 코트 왼쪽서브,
'                현재점수가 짝수면 코트 오른쪽서브, 서브권을 갖는 사람한테 득점을 올려준다.
'
'                nServe, nReceive position은 무조건 오른쪽이다.
'                서브시에 승점을 하면 player의 위치가 바뀐다.
'                현재점수가 홀수면 코트 왼쪽서브,
'                현재점수가 짝수면 코트 오른쪽서브,
'
'    3. Jumsu가 1일 경우 듀스를 체크한다. ( 듀스 표시는 4개의 td에 영향을 미치므로 4개의 배열에 표시 -2)
'    4. Jumsu가 0일 경우 반칙을 나눈다. ( 반칙팀의 Serve/Receive Member 기준 )
'    5. 반칙일 경우 반칙 표시를 한 후 해당 pos을 저장한다. ( ex) 배열 1 의 pos = 7 )
'    6. 반칙일 경우 해당 팀에 연속으로 반칙이 선언되었을 경우 , ( 1, 2, 1, 2, ... ) or (2, 1, 2, 1, 2, 1 )
'       식으로 값을 저장한다.
'    7. 반칙이 'DIS'(강퇴) or 'RET'(기권)일 경우 ( 강퇴/기권 표시는 4개의 td에 영향을 미치므로 4개의 배열에 표시 -3)
'    8. 각 세트의 처음 점수가 났을때 서브, 리시브를 가진 유저의 팀이 각각 S(서버), R(리시브)이다.
'    9. 최종점수 표시	앞에서 한칸 띄고 , 0,3의 위치(양 끝)에 최종 점수를 적고 종료 표시를 한다.
'   ===============================================================================
    Function getScoreInfo(nSet, rAry)
        Dim aryCon
        Dim aryPrevMiss(2)              ' 0 : group order, 1 : player order
        Dim score_L, score_R, score_tmp ' left score , right score
        Dim sIdx, eIdx                  ' set range
        Dim pos                         ' array position
        Dim ai, aul, aj
        Dim tnSet,tScore, tDeuce, tMark, tServeIdx, tReceiveIdx, tMissIdx, tWinGroupIdx, tMissGroupIdx
        Dim tMemIdxLL, tMemIdxLR, tMemIdxRL, tMemIdxRR
        Dim nServe, nReceive, nScorePos, nTeamPos, nMissPlayerPos, nMissTeamPos
        Dim nPrevScorePos, toggle_L, toggle_R, nLeftFist, nRightFirst    ' toggle_L, toggle_R 선수의 위치가 바뀌었다. (서브권 있는상태에서 승점시 적용)

        If( Not IsArray(rAry)) Then
            getScoreInfo = ""
            Exit Function
        End If

        ReDim aryCon(100, 4)
        '   ===============================================================================
        '    1. SetNum을 기준으로 데이터를 나눈다.
        sIdx = -1
        eIdx = -1
        nPrevScorePos = -1
        aul = UBound(rAry, 2)

        For ai = 0 To aul
            tnSet = rAry(0, ai)                     ' SetNum
            If( tnSet = nSet ) Then
                If(sIdx = -1) Then sIdx = ai End If
            Else
                If(sIdx <> -1) Then
                    eIdx = ai -1
                    Exit For
                End If
            End If
        Next

        If(sIdx = -1) Then
            getScoreInfo = ""
            Exit Function
        End If

        If( sIdx <> -1 And eIdx = -1 ) Then eIdx = aul End If

        '   ===============================================================================
        '    2. Data Block을 가지고 연산을 진행한다.

        '   ===============================================================================
        '    Initial variable
        pos = 0      ' array Index를 초기화 한다.
        score_L = 0
        score_R = 0
        toggle_L = 0
        toggle_R = 0

        aryPrevMiss(0) = -1
        aryPrevMiss(1) = -1
        '   ===============================================================================

'            Call getRowsDrow (rAry)
        For ai = sIdx To eIdx
            tScore = rAry(1, ai)                    ' Jumsu
            tDeuce = rAry(2, ai)                    ' NowGameDeuceYN
            tMark = rAry(3, ai)                     ' WarningMark
            tServeIdx = rAry(4, ai)                 ' ServeMemberIDX
            tReceiveIdx = rAry(5, ai)               ' RecieveMemberIDX
            tMissIdx = rAry(6, ai)                  ' Miss_MemberIDX
            tWinGroupIdx = rAry(7, ai)              ' TourneyGroupIDX
            tMissGroupIdx = rAry(8, ai)             ' Miss_TourneyGroupIDX

            If(pos = 0) Then        ' 제일 처음이면 S, R 표시를 한다. , team의 멤버의 위치 바뀜도 체크한다.
                nServe = getPlayerPosEx(tServeIdx)
                nReceive = getPlayerPosEx(tReceiveIdx)

                ' nServe, nReceive position은 무조건 오른쪽이다. 이 값을 가지고 toggle_L, toggle_R을 초기화 한다.
                ' 일단 nServe를 가지고 왼쪽 팀과 오른쪽 팀을 구한다.
                If( nServe < 2 ) Then ' 서브권이 왼쪽 팀 / Receive가 오른쪽
                    If(nServe = 0) Then toggle_L = 1 End If ' 서브가 오른쪽이므로 토글 되었다.
                    If(nReceive = 2) Then toggle_R = 1 End If ' 리시브가 오른쪽이므로 토글 되었다.
                Else                    ' 서브권이 오른쪽 팀 / Receive가 왼쪽
                    If(nServe = 2) Then toggle_R = 1 End If
                    If(nReceive = 0) Then toggle_L = 1 End If
                End If

                For aj = 0 To 3
                    If(aj = nServe) Then
                        aryCon(pos, aj) = "S"
                        aryCon(pos+1, aj) = "0"
                    ElseIf(aj = nReceive) Then
                        aryCon(pos, aj) = "R"
                        aryCon(pos+1, aj) = "0"
                    Else
                        aryCon(pos, aj) = ""
                        aryCon(pos+1, aj) = ""
                    End If
                Next
                pos = pos + 1
                pos = pos + 1

            End If
            '   ===============================================================================
            '    3. Jumsu가 1일 경우 점수를 나눈다. ( 승점팀의 Serve/Receive Member 기준 )
            If(tScore = 1) Then
'                nScorePos = getScorePos(tServeIdx, tReceiveIdx, tWinGroupIdx, nPrevScorePos, score_L, score_R, tMemIdxLL, tMemIdxLR, tMemIdxRL, tMemIdxRR)

                If(bDoubleGame = 1) Then
                    nScorePos = getScorePos(tServeIdx, tReceiveIdx, tWinGroupIdx, nPrevScorePos, score_L, score_R, toggle_L, toggle_R)
                Else
                    nScorePos = getScorePosSingle(tServeIdx, tReceiveIdx, tWinGroupIdx)
                End If

                ' 이전에 승점한 선수를 기억한다. ( 연속 득점시 이전 선수에 득점 표시 )
                nPrevScorePos = nScorePos

                If(nScorePos = 0 Or nScorePos = 1) Then   ' Left score
                    score_L = score_L + 1
                    score_tmp = score_L
				'		  last_jumsu_posL	= nScorePos		' 제일 마지막 점수 표시 위치를 기억한다. (챌린지 표시 위치)
                Else            ' Right score
                    score_R = score_R + 1
                    score_tmp = score_R
				'		  last_jumsu_posR	= nScorePos		' 제일 마지막 점수 표시 위치를 기억한다. (챌린지 표시 위치)
                End If

                For aj = 0 To 3
                    If(aj = nScorePos) Then
                        aryCon(pos, aj) = score_tmp
                    Else
                        aryCon(pos, aj) = ""
                    End If
                Next
                '   ===============================================================================
                '    Jumsu가 1일 경우 듀스를 체크한다. ( 듀스 표시는 4개의 td에 영향을 미치므로 4개의 배열에 표시 -2)
                If(tDeuce = "Y") Then
                    pos = pos + 1

                    For aj = 0 To 3
                        aryCon(pos, aj) = MARK_DUAL
                        If(aj = 0) Then
                            aryCon(pos, aj) = MARK_DUAL
                        Else
                            aryCon(pos, aj) = ""
                        End If
                    Next
                End If

                '   ===============================================================================
                '    이전에 저장했던 반칙 Pos을 초기화 한다.
                aryPrevMiss(0) = -1
                aryPrevMiss(1) = -1
            '   ===============================================================================
            '    Jumsu가 0일 경우 반칙을 나눈다. ( 반칙팀의 Serve/Receive Member 기준 )
            ElseIf(tScore = 0) Then
					'   ===============================================================================
					'    Challenge Check
					if(tMark = "CW") Or (tMark = "CL") Then
						nMissTeamPos = getTeamPosEx(tMissIdx)
                	If(nMissTeamPos = 0) Then 		' Left Team
						 	challenge_pos = last_jumsu_posL
						Else
							challenge_pos = last_jumsu_posR
						End If

						For aj = 0 To 3
							If(aj = challenge_pos) Then
								aryCon(pos, aj) = tMark
							Else
								aryCon(pos, aj) = ""
							End If
						Next

					'   ===============================================================================
					'    이전에 저장했던 반칙 Pos을 초기화 한다.
						aryPrevMiss(0) = -1
						aryPrevMiss(1) = -1
					'   ===============================================================================

					'   ===============================================================================
					'    MisConduct Check
					Else
						nMissTeamPos = getTeamPosEx(tMissIdx)
						nMissPlayerPos = getPlayerPosEx(tMissIdx)

						'   ===============================================================================
						'    반칙일 경우 해당 팀에 연속으로 반칙이 선언되었을 경우 , ( 1, 2, 1, 2, ... ) or (2, 1, 2, 1, 2, 1 )
						'       식으로 값을 저장한다.
						If(aryPrevMiss(0) = nMissTeamPos) Then
							If( (aryPrevMiss(1) Mod 2) = 0 ) Then
									nMissPlayerPos = aryPrevMiss(1) + 1
									pos = pos -1        ' 연속으로 Miss표시를 하기 위해 pos을 하나 뒤로 간다.
									aryCon(pos, nMissPlayerPos) = tMark
							Else                    ' 연속으로 Miss가 나왔으나 다음 칸에 표시한다.
									For aj = 0 To 3
										nMissPlayerPos = aryPrevMiss(1) - 1
										If(aj = nMissPlayerPos) Then
											aryCon(pos, aj) = tMark
										Else
											aryCon(pos, aj) = ""
										End If
									Next
							End If
						Else                        ' Miss가 나왔으므로 Miss를 표시한다.
							For aj = 0 To 3
									If(aj = nMissPlayerPos) Then
										aryCon(pos, aj) = tMark
									Else
										aryCon(pos, aj) = ""
									End If
							Next
						End If

						'반칙이 'DIS'(강퇴) or 'RET'(기권)일 경우 2칸에 표시 해야 함으로 pos을 하나더 이동한다.
						If( tMark = "DIS" Or tMark = "RET" ) Then
							pos = pos + 1
						End If

						aryPrevMiss(0) = nMissTeamPos
						aryPrevMiss(1) = nMissPlayerPos
					End If
            End If

            pos = pos + 1

            If( pos <> 0 And pos Mod colNextStart = 0 ) Then
                For aj = 0 To 3
                    aryCon(pos, aj) = ""
                Next
                pos = pos + 1
            End If
        Next

        '   ===============================================================================
        ' 최종점수 표시	앞에서 한칸 띄고 , 0,3의 위치(양 끝)에 최종 점수를 적고 종료 표시를 한다.
        ' 예외표시 ) 게임이 pos = 44에서 끝나고 pos = 46에서 최종점수를 표시하면 한칸 밑으로 떨어져서 표시 되어야 한다.
        ' pos = 46에 MARK_END 를 pos=47에 최종 점수를 표시한다 .
        If (pos = colMax) Then pos = colNextStart End If

        For aj = 0 To 3
            If(aj = 0) Then
                aryCon(pos, aj) = MARK_END   ' end를 알리는 Flag다. 이 다음에 최종 점수를 찍고 종료한다.
            Else
                aryCon(pos, aj) = MARK_ENDPOINT
            End If
        Next

        pos = pos + 1
        For aj = 0 To 3
            If(aj = 0) Then
                aryCon(pos, aj) = score_L
            ElseIf(aj = 3) Then
                aryCon(pos, aj) = score_R
            Else
                aryCon(pos, aj) = ""
            End If
        Next
        getScoreInfo = aryCon
    End Function

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="ko">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>스코어지_VER1.0</title>

    <style>
      *{margin:0;padding:0;}
  		html{height:100%;font-family:Calibri, Arial, Helvetica, sans-serif;background-color:white;}
      body{width:297mm;height:200mm;}
  		table{border-collapse:collapse;}
  		li{list-style:none;}

      .sheet_header{margin-bottom:4mm;font-size:0;}
  		.sheet_header .inputList{display:inline-block;width:20%;vertical-align:top;}
  		.sheet_header .inputList li{border-bottom:0.1mm solid #000;padding-top:1mm;}
      .sheet_header .inputList li>span{display:inline-block;font-size:9pt;top:-4mm;}
      .sheet_header .inputList li>span:nth-of-type(2n){min-width:22mm;}

      .sheet_header .VS{display:inline-block;width:60%;margin-top:6mm;text-align:center;font-size:0;vertical-align:top;}
      .VS>*{display:inline-block;font-size:0;vertical-align:top;}
      .VS__players{font-size:15pt;}

      .VS__playersPosition{display:inline-block;width:5.5mm;height:8mm;border:0.5mm solid #000;text-align:center;font-size:11pt;line-height:6.5mm;box-sizing:border-box;}
      .VS__playersPosition.s_L{border-right:0;}
      .VS__playersPosition.s_R{border-left:0;background-color:#eee;}

      .VS__playersInner{position:relative;width:48mm;border:0.5mm solid #000;font-size:10.5pt;font-weight:700;box-sizing:border-box;}
      .VS__playersInner.s_R{background-color:#eee;}
      .VS__playersInner>span{display:flex;align-items:center;height:7mm;padding:0 1mm;}
      .VS__playersInner>span+span{border-top:0.1mm solid #000;}
      .VS__playersInner>span:last-child{font-size:9pt;letter-spacing:-0.06em;}

      .VS__playersInner.s_win::after{content:'';position:absolute;width:50mm;height:32mm;border-radius:50%;border:1px solid #000;}
      .VS__playersInner.s_L::after{top:-6mm;left:-0.5mm;}
      .VS__playersInner.s_R::after{top:-6mm;right:-0.5mm;}

      .VS__setScores{position:relative;width:30mm;margin:0 5mm;font-size:12pt;text-align:center;border:0.5mm solid #000;}
      .VS__setScores>span{display:flex;align-items:center;justify-content:center;height:7mm;}
      .VS__setScores>span + span{border-top:0.1mm solid #000;}

      .VS__point{width:49%;}
      .VS__point.s_L{text-align:right;padding-right:0.7mm;}
      .VS__point.s_R{text-align:left;padding-left:0.7mm;}
      .VS__pointColon{}
      .VS__setScores>p{position:absolute;top:-3.5mm;width:12mm;left:0;right:0;margin:auto;background-color:#fff;font-size:12pt;font-weight:700;}


      .sheet_sheet{margin-top:5px;}
      .sheet_sheet table{text-align:center;width:100%;font-size:9pt;}
      .sheet_sheet th{text-align:left;padding:0 1mm;max-width:147.469px;overflow:hidden;text-overflow:ellipsis;}
      .sheet_sheet td{position:relative;min-width:6.5mm;max-width:6.5mm;width:6.5mm;height:5.5mm;font-size:11pt;}

      .sheet_sheet tr:nth-of-type(4n){background-color:#eee;}
      .sheet_sheet tr:nth-of-type(4n-1){background-color:#eee;}

      .sheet_sheet th{border:0.1mm solid #666;}
      .sheet_sheet td{border:0.1mm solid #666;}
      .sheet_sheet tr>:nth-child(2){border-right:0.6mm solid #000;}
      .sheet_sheet tr:nth-of-type(4n-1){border-top:0.6mm solid #000;}
      .sheet_sheet table{border:0.6mm solid #000;}
		.sheet_sheet .s_endPoint{font-weight:bold;}
		.sheet_sheet .s_challenge{font-weight:bold;}
      .sheet_sheet .s_cross::after{content:'';position:absolute;left:12px;top:0;width:1px;height:23mm;transform:rotate(17deg);border-left:1px solid #000;box-sizing:border-box;}
      .sheet_sheet .s_end::after{content:'';position:absolute;top:0;left:50%;width:14mm;height:22.5mm;transform:translateX(-50%);border-radius:50%;border:2px solid #000;box-sizing:border-box;}
      .sheet_sheet .s_end::before{content:'';position:absolute;top:63px;bottom:0;left:50%;width:14mm;margin:auto;height:1px;transform:translateX(-50%) rotate(-18deg);border-top:2px solid #000;box-sizing:border-box;}

      .sheet_footer{display:flex;justify-content:center;margin-top:5mm;}
  		.sheet_footer .association{width:40%;text-align:center;margin-top:5mm;font-size:16pt;}
  		.sheet_footer .inputList{width:30%;}
  		.sheet_footer .inputList li{border-bottom:0.1mm solid #000;font-size:11pt;}

    </style>


    <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/textFit/textFit.min.js"></script>
    <script>
      document.addEventListener('DOMContentLoaded', function (){
        textFit(document.getElementsByClassName('textFitName'), {detectMultiLine:false, maxFontSize: 14 });
        textFit(document.getElementsByClassName('textFitBelong'), {detectMultiLine:false, maxFontSize: 12 });
        textFit(document.getElementsByClassName('textFitName2'), {detectMultiLine:false, maxFontSize: 12 });
      })
    </script>
	</head>
  <body>
  <div>
    <div class="sheet_header">
      <ul class="inputList">
        <li><span>Event :</span><span><%=game.gametitle%></span></li>
        <li><span>Round :</span><span><%=game.Sex & game.PlayTypeName & " " & game.TeamGbNM & " " & game.LevelName & " " & game.LevelJooName & " " &  game.LevelJooNum %></span></li>
        <!--<li><span>Match No :</span><span><%=GetShortKindName(game.Sex, game.TeamGbNM, game.PlayTypeName, DEC_GameNum )%></span></li>-->
        <li><span>Match No :</span><span><%=GetShortKindName(game.Sex, game.TeamGbNM, game.PlayTypeName, Display_GameNum )%></span></li>
        <li><span>Date :</span><span><%=game.GameDay%></span></li>
        <li><span>Court :</span><span><%=Display_CourtNum%></span></li>
		  <!-- <li><span>Court :</span><span><%=game.StadiumNum%></span></li> -->
      </ul>

      <div class="VS">
        <span class="VS__playersPosition s_L"><%=pos_keyword1%></span>

        <%If( game.GameGb = "B0010002")  Then       '국제대회  ( 영문표시 )%>
            <span class="VS__playersInner <%=winner_L%> s_L">
              <span class="textFitName"><%=game.LPlayerEngName1%></span>
              <span class="textFitName"><%=game.LPlayerEngName2%></span>
              <span class="textFitBelong"><%=getTeamName(game.LTeamEngName1, game.LTeamEngName2)%>
              <%
                If Left(game.LteamDtl,1) <> "0" Then
                    Response.Write Left(game.LteamDtl,1)
                End If
              %>
              </span>
            </span>
        <%Else%>
            <span class="VS__playersInner <%=winner_L%> s_L">
              <span class="textFitName"><%=game.LPlayer1%></span>
              <span class="textFitName"><%=game.LPlayer2%></span>
              <span class="textFitBelong"><%=getTeamName(game.LTeam1, game.LTeam2)%>
              <%
                If Left(game.LteamDtl,1) <> "0" Then
                    Response.Write Left(game.LteamDtl,1)
                End If
              %>
              </span>
            </span>
        <%End If%>
        <div class="VS__setScores">
          <p>Score</p>
            <% If (IsArray(aryScore)) Then %>
                <span><span class="VS__point s_L"><%=aryScore(0,0)%></span> <span class="VS__pointColon">:</span> <span class="VS__point s_R"><%=aryScore(1,0)%></span></span>
                <span><span class="VS__point s_L"><%=aryScore(0,1)%></span> <span class="VS__pointColon">:</span> <span class="VS__point s_R"><%=aryScore(1,1)%></span></span>
                <span><span class="VS__point s_L"><%=aryScore(0,2)%></span> <span class="VS__pointColon">:</span> <span class="VS__point s_R"><%=aryScore(1,2)%></span></span>

                <%  If( setMax = 5 ) Then %>
                    <span><span class="VS__point s_L"><%=aryScore(0,3)%></span> <span class="VS__pointColon">:</span> <span class="VS__point s_R"><%=aryScore(1,3)%></span></span>
                    <span><span class="VS__point s_L"><%=aryScore(0,4)%></span> <span class="VS__pointColon">:</span> <span class="VS__point s_R"><%=aryScore(1,4)%></span></span>
                <% End If%>
            <%Else%>
                <span> : </span>
                <span> : </span>
                <span> : </span>
                <%  If( setMax = 5 ) Then %>
                    <span> : </span>
                    <span> : </span>
                <% End If%>
            <%End If%>
        </div>

        <%If( game.GameGb = "B0010002")  Then       '국제대회  ( 영문표시 )%>
            <span class="VS__playersInner <%=winner_R%> s_R">
              <span class="textFitName"><%=game.RPlayerEngName1%></span>
              <span class="textFitName"><%=game.RPlayerEngName2%></span>
              <span class="textFitBelong"><%=getTeamName(game.RTeamEngName1, game.RTeamEngName2)%>
              <%
                If Left(game.RteamDtl,1) <> "0" Then
                    Response.Write Left(game.RteamDtl,1)
                End If
              %>
              </span>
            </span>
        <%Else%>
            <span class="VS__playersInner <%=winner_R%> s_R">
              <span class="textFitName"><%=game.RPlayer1%></span>
              <span class="textFitName"><%=game.RPlayer2%></span>
              <span class="textFitBelong"><%=getTeamName(game.RTeam1, game.RTeam2)%>
              <%
                If Left(game.RteamDtl,1) <> "0" Then
                    Response.Write Left(game.RteamDtl,1)
                End If
              %>
              </span>
            </span>
        <%End If%>
        <span class="VS__playersPosition s_R"><%=pos_keyword2%></span>
      </div>

      <ul class="inputList">
        <li><span>Umpire :</span><span><%=game.CheifName%></span></li>
        <li><span>Service Judge :</span><span><%=game.CheifSubName%></span></li>
        <li><span>Start match :</span><span><%=getShortTime(startGameTime)%></span></li>
        <li><span>End match :</span><span><%=getShortTime(endGameTime)%></span></li>
        <li><span>Duration :</span><span><%=getDuration(startGameTime, endGameTime)%></span></li>
        <li><span>Shuttles :</span><span><%=shuttleCnt%></span></li>
      </ul>
    </div>

    <%
'    ===============================================================================
'    구현
'    * . 4개의 Data 배열을 만들어서 4개의 <tr>의 <td>를 채운다.
'    * . 위에서 부터 1, 2, 3, 4 ( Left1, Left2, Right1, Right2 ) 의 값으로 위치를 관리한다.
'    1. SetNum을 기준으로 데이터를 나눈다.
'    2. Jumsu가 1일 경우 점수를 나눈다. ( 승점팀의 Serve/Receive Member 기준 )
'    3. Jumsu가 1일 경우 듀스를 체크한다. ( 듀스 표시는 4개의 td에 영향을 미치므로 4개의 배열에 표시 -2)
'    4. Jumsu가 0일 경우 반칙을 나눈다. ( 반칙팀의 Serve/Receive Member 기준 )
'    5. 반칙일 경우 반칙 표시를 한 후 해당 pos을 저장한다. ( ex) 배열 1 의 pos = 7 )
'    6. 반칙일 경우 해당 팀에 연속으로 반칙이 선언되었을 경우 , ( 1, 2, 1, 2, ... ) or (2, 1, 2, 1, 2, 1 )
'       식으로 값을 저장한다.
'	  7. Jumsu가 0일 경우 챌린지를 체코한다. ( CW, CL - 점수 표시의 같은 라인에 표시한다.  )
'    7. 반칙이 'DIS'(강퇴) or 'RET'(기권)일 경우 ( 강퇴/기권 표시는 4개의 td에 영향을 미치므로 4개의 배열에 표시 -3)
'    8. 각 세트의 처음 점수가 났을때 서브, 리시브를 가진 유저의 팀이 각각 S(서버), R(리시브)이다.
'    9. 스코어 시트는 기본 1셋트당 2개의 Table로 구성된다.
'    10. 3셋트면 6개의 테이블이 보이되, 경기가 1개의 Table안에서 끝날경우 바로 이어서 다음 경기의 Sheet가 보여야 한다.
'   ===============================================================================
    '#####################################################################
    Dim aryConData, nSet, aryData, basePos, endSet, addColSpan, endPoint
    Dim nGameEnd, bDisplayScore
        nSet = 1
        basePos = 0
        cntSheet = 1
        nGameEnd = 0                ' score sheet 45개 전에 끝나면 1행만 보이게..
        bDisplayScore = 0           ' score sheet score data Display를 한 적이 있다면 빈 데이터일때 행을 제거

        For n = 0 To (setMax*2)-1
            If( n Mod 2 = 0) Then
                aryConData = getScoreInfo(nSet, aryDRS)
                nSet = nSet + 1
                basePos = 0
                endSet = 0          ' Game End - End Mark and End Point Bold ( 0번째 td만 적용됨 )
                endPoint = 0        ' Game End Point Bold (1, 2,3 td에 적용위해 추가 )
                addColSpan = ""
            End If

            If( Not IsArray(aryConData) And bDisplayScore = 1) Then
               n = n + 2
            Else
%>
               <div class="sheet_sheet" <%if cntSheet mod 6 = 0 AND setMax > 3 then%> style="page-break-after:always;" <%end if%>>
                     <table id="sheet5" class="sheet5">
                        <tbody>
                        <%
                        '#####################################################################
                        ' table row 4개 고정(복식 고려)
                           For row= 0 To 3
                           If( game.GameGb = "B0010002")  Then       '국제대회  ( 영문표시 )
                                 Select Case row
                                    Case 0
                                       dorwplayer = strPrintf("{0}", Array(game.LPlayerEngName1))
                                    Case 1
                                       dorwplayer = ""
                                       If( game.LPlayerEngName2 <> "" ) Then
                                             dorwplayer = strPrintf("{0}", Array(game.LPlayerEngName2))
                                       End If
                                    Case 2
                                       dorwplayer = strPrintf("{0}", Array(game.RPlayerEngName1))
                                    Case 3
                                       dorwplayer = ""
                                       If( game.RPlayerEngName2 <> "" ) Then
                                             dorwplayer = strPrintf("{0}", Array(game.RPlayerEngName2))
                                       End If
                                 End Select
                           Else                             ' 국내 대회 ( 한글표시 )
                                 Select Case row
                                    Case 0
                                       dorwplayer = strPrintf("{0}", Array(game.LPlayer1))
                                    Case 1
                                       dorwplayer = ""
                                       If( game.LPlayer2 <> "" ) Then
                                             dorwplayer = strPrintf("{0}", Array(game.LPlayer2))
                                       End If
                                    Case 2
                                       dorwplayer = strPrintf("{0}", Array(game.RPlayer1))
                                    Case 3
                                       dorwplayer = ""
                                       If( game.RPlayer2 <> "" ) Then
                                             dorwplayer = strPrintf("{0}", Array(game.RPlayer2))
                                       End If
                                 End Select
                           End If
                        %>
                           <tr class="row<%=row%>">
                                 <th class="textFitName2"><%=dorwplayer%></th>
                                 <%
                                    If( Not IsArray(aryConData) ) Then
                                       ' row => 테이블 td 수만큼 루프(고정)
                                       For i = 0 To colMax
                                       %>
                                             <td class="<%=classname%>">     <!-- S, R 표기 & 점수 -->

                                             </td>
                                       <%
                                       Next
                                    Else
                                          bDisplayScore = 1
                                       ' row => 테이블 td 수만큼 루프(고정)
                                       For i = 0 To colMax
                                             '--------------------------------------------------------------------
                                             ' mark display
                                             If( aryConData(basePos + i, row) = MARK_DUAL) Then
                                                classname = "s_cross"
                                                aryConData(basePos + i, row) = ""
                                             End If

															' Check Challenge
															If(aryConData(basePos + i, row) = MARKNAME_CHALLENGE_WIN) Or _
															  (aryConData(basePos + i, row) = MARKNAME_CHALLENGE_LOSE) Then
															  		classname = "s_challenge"
															End If

                                             If( endSet = 1) Then
                                                classname = "s_end  s_endPoint"
                                                endSet = 0
                                                If( basePos + i < colMax ) Then
                                                   nGameEnd = 1
                                                End If
                                             End If

                                             If( endPoint = 1) Then
                                                classname = "s_endPoint"
                                                endPoint = 0
                                             End If

                                             If( aryConData(basePos + i, row) = MARK_END) Then
                                                endSet = 1
                                                aryConData(basePos + i, row) = ""
                                             End If

                                             If( aryConData(basePos + i, row) = MARK_ENDPOINT) Then
                                                endPoint = 1
                                                aryConData(basePos + i, row) = ""
                                             End If
                                             '--------------------------------------------------------------------

                                             '--------------------------------------------------------------------
                                             ' DIS, RET 일 경우 colspan="2"
                                             If( aryConData(basePos + i, row) = "DIS" Or aryConData(basePos + i, row) = "RET" ) Then
                                    %>          <td colspan="2">                <!-- S, R 표기 & 점수 -->
                                                   <%=aryConData(basePos + i, row)%>
                                                   <% i = i+1 %>
                                                </td>
                                       <%  Else  %>
                                                <td class="<%=classname%>">     <!-- S, R 표기 & 점수 -->
                                                   <%=aryConData(basePos + i, row)%>
                                                </td>
                                       <%  End If
                                             classname = ""
                                       Next

                                          If(nGameEnd = 1) Then
                                             n = n+1
                                             nGameEnd = 0
                                          End If
                                    End If

                           %></tr><%
                                 Next
                                 basePos = colNextStart  %>
                        </tbody>
                     </table>
               </div>
      <%
               cntSheet = cntSheet + 1
            End If
            Next
'    ===============================================================================
'       셋트 수 * Table 만큼 Display 해야 하는데..   그리고 남은 갯수만큼 빈 Table을 그린다.
'    ===============================================================================
            Dim restSheet
            restSheet = (setMax*2) - (cntSheet-1)

            If( restSheet ) Then
               For n = 1 To (restSheet)
      %>
                  <div class="sheet_sheet" <%if cntSheet mod 6 = 0 AND setMax > 3 then%> style="page-break-after:always;" <%end if%>>
                        <table id="sheet5" class="sheet5">
                           <tbody>
                           <%
                           '#####################################################################
                           ' table row 4개 고정(복식 고려)
                              For row= 0 To 3
                              If( game.GameGb = "B0010002")  Then       '국제대회  ( 영문표시 )
                                 Select Case row
                                    Case 0
                                       dorwplayer = strPrintf("{0}", Array(game.LPlayerEngName1))
                                    Case 1
                                       dorwplayer = ""
                                       If( game.LPlayerEngName2 <> "" ) Then
                                             dorwplayer = strPrintf("{0}", Array(game.LPlayerEngName2))
                                       End If
                                    Case 2
                                       dorwplayer = strPrintf("{0}", Array(game.RPlayerEngName1))
                                    Case 3
                                       dorwplayer = ""
                                       If( game.RPlayerEngName2 <> "" ) Then
                                             dorwplayer = strPrintf("{0}", Array(game.RPlayerEngName2))
                                       End If
                                 End Select
                           Else                             ' 국내 대회 ( 한글표시 )
                                 Select Case row
                                    Case 0
                                       dorwplayer = strPrintf("{0}", Array(game.LPlayer1))
                                    Case 1
                                       dorwplayer = ""
                                       If( game.LPlayer2 <> "" ) Then
                                             dorwplayer = strPrintf("{0}", Array(game.LPlayer2))
                                       End If
                                    Case 2
                                       dorwplayer = strPrintf("{0}", Array(game.RPlayer1))
                                    Case 3
                                       dorwplayer = ""
                                       If( game.RPlayer2 <> "" ) Then
                                             dorwplayer = strPrintf("{0}", Array(game.RPlayer2))
                                       End If
                                 End Select
                           End If
                           %>
                              <tr class="row<%=row%>">
                                    <th class="textFitName2"><%=dorwplayer%></th>
                                    <%
                                       For i = 0 To colMax
                                    %>   <td class="">  </td>
                                    <%
                                       Next
                                    %>
                              </tr>
                           <%
                              Next %>
                           </tbody>
                        </table>
                     </div>
                  <%
                  cntSheet = cntSheet + 1
               Next
            End If
      %>


    <div class="sheet_footer">
      <ul class="inputList">
        <li><span>Umpire's Signature</span></li>
      </ul>
      <div class="association">
        BADMINTON KOREA ASSOCIATION
      </div>
      <ul class="inputList">
        <li><span>Referre's Signature</span></li>
      </ul>

    </div>
  </div>
</body>
</html>


<%
    endTimer = Timer()

    strLog = strPrintf("Srore Modify Process Time = {0}", Array(endTimer - startTimer))

    Set game = Nothing
    Set rs = Nothing

	Call db.Dispose
    Set db = Nothing
%>

<%
'  Response.END
 ' Response.Buffer = True
 ' Response.ContentType = "application/vnd.ms-excel"
 ' Response.CacheControl = "public"
 ' Response.AddHeader "Content-disposition","attachment;filename=score.xls"
%>
