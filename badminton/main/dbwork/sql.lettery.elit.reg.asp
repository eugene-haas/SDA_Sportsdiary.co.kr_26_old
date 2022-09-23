<% 
'   ===============================================================================     
'    Purpose : badminton elit 추첨후 등록하는 쿼리
'    Make    : 2019.09.27
'    Author  :                                                       By Aramdry
'   ===============================================================================    

%>

<% 

'   **********************************************************************************
'   **********************************************************************************
'       * 베드민턴 대진표 

'   ===============================================================================     
'      Elite 대진표 -   GameTitleIdx를 입력받아 tblGameTitle에 자동 대진 셋팅 Flag를 셋팅한다. 
'   =============================================================================== 
    Function getSqlSetAutoTonament(gTitleIdx)       

        Dim strField, strTable, strWhere, strGroupBy

    If(gTitleIdx <> "" ) Then       
         strSql =          "Update tblGameTitle  "
         strSql = strSql & "Set NotAutoGameNumYN = 'N' "         
         strSql = strSql & sprintf(" Where DelYN = 'N' And GameTitleIDX = '{0}'", Array(gTitleIdx))
      End If 

        getSqlSetAutoTonament = strSql
    End Function   

'   ===============================================================================     
'      Elite 대진표 -   GameTitleIdx를 입력받아 tblGameTitle에 자동 대진 셋팅 Flag를 Reset한다. 
'   =============================================================================== 
    Function getSqlResetAutoTonament(gTitleIdx)       

        Dim strField, strTable, strWhere, strGroupBy

    If(gTitleIdx <> "" ) Then       
         strSql =          "Update tblGameTitle  "
         strSql = strSql & "Set NotAutoGameNumYN = 'Y' "         
         strSql = strSql & sprintf(" Where DelYN = 'N' And GameTitleIDX = '{0}'", Array(titleIdx))
      End If 

        getSqlResetAutoTonament = strSql
    End Function   


'   ===============================================================================     
'      Elite 대진표 -   GameTitleIdx를 입력받아 GameLevel을 구한다.
'   =============================================================================== 
    Function getSqlEliteGameLevel(gTitleIdx)       
		Dim strSql

		If( gTitleIdx <> "") Then 
			strSql = strSql & "  with cte_level As ( "
			strSql = strSql & "  	Select [Level], LevelNm From tblLevelInfo Where DelYN = 'N' "
			strSql = strSql & "  ) "
			strSql = strSql & "  Select GameTitleIDX, GameLevelidx, Sex, TeamGb, PlayType, GroupGameGb, "
			strSql = strSql & "  		( Select LevelNm From cte_level Where [Level] = L.[Level]) As level_name "
			strSql = strSql & "  	From tblGameLevel As L With (NoLock) 	 "
			strSql = strSql & strPrintf("  	Where DelYN='N'  and GameTitleIDX = '{0}' Order By GameLevelidx ", Array(gTitleIdx))
		End If

        getSqlEliteGameLevel = strSql
    End Function   

'   ===============================================================================     
'      Elite 대진표 -   GameTitleIdx, GameLevelIDX를 입력받아 경기에 참가 신청한 Player 정보를 구한다. 
'     사용유무, 시드 No, 연동대회 Ranking, 팀내 선수순위, 참가신청 GroupIdx, 참가신청 Player Idx, ... 
'     fUse, SeedNo, Ranking, PrevTeam, PrevTeamName는 추후 클라이언트에서 채워질 정보다. 

'     (ROW_NUMBER() Over(Partition By Team Order By WriteDate)) 팀별로 입력순서에 의한 Ordering 
'        => 이렇게 함으로서 Team별로 1,2,3..  순위로 데이터를 구한다. 
'     ROW_NUMBER() Over(Partition By P.gamerequestgroupidx ORDER BY M.Sex  ) As Idx 를 뽑고 
'     ORDER BY gamerequestgroupidx, Idx를 하는 이유는 남녀 혼합팀일 경우 , 
'     남자를 먼저 표시해 줘야 한다는 요구 사항때문 
'   =============================================================================== 
    Function getSqlEliteReqPlayer(gTitleIdx, gLevelIdx)       

      Dim strSql		
    ' ================================================================================================        
	 	If( gTitleIdx <> "" And gLevelIdx <> "") Then 
			strSql = 			" With cte_user As (  "
			strSql = strSql & " 	SELECT ROW_NUMBER() Over(Partition By P.gamerequestgroupidx ORDER BY M.Sex  ) As Idx,  "
			strSql = strSql & " 			0 AS fUse, 0 AS teamNo, 0 AS SeedNo, 0 AS Ranking,  "
			strSql = strSql & " 			( Dense_rank() OVER( ORDER BY P.gamerequestgroupidx) ) AS dataOrder,  "
			strSql = strSql & " 			( Dense_rank() OVER( partition BY P.team ORDER BY P.gamerequestgroupidx) ) AS PlayerOrder,  "
			strSql = strSql & " 			P.gamerequestgroupidx, P.gamerequestplayeridx, P.memberidx, P.membername,  "
			strSql = strSql & " 			P.team, P.teamname, 0 AS PrevTeam, 0 AS PrevTeamName , M.Sex "
			strSql = strSql & " 	FROM   tblgamerequestplayer As P  WITH (nolock)  "
			strSql = strSql & " 	Inner Join tblMember As M On P.memberidx = M.memberidx And M.DelYN = 'N' "
			strSql = strSql & " 	WHERE  P.delyn = 'N'  "
			strSql = strSql & sprintf(" AND P.gametitleidx = '{0}' AND P.gamelevelidx = '{1}'  ", Array(gTitleIdx, gLevelIdx))
			strSql = strSql & " )   "

			strSql = strSql & " Select fUse, teamNo, seedNo, ranking, dataOrder, playerOrder,  "
			strSql = strSql & " 		GameRequestGroupIDX, GameRequestPlayerIDX, MemberIdx, MemberName,  "
			strSql = strSql & " 		Team, TeamName, prevTeam, prevTeamName "
			strSql = strSql & " From cte_user ORDER BY gamerequestgroupidx, Idx "
		End If 

      getSqlEliteReqPlayer = strSql
    End Function  

'	Function getSqlEliteReqPlayer(gTitleIdx, gLevelIdx)       
'
'        Dim strField, strField1, strField2, strTable, strWhere, strGroupBy
'
'    ' ================================================================================================        
'        strField1 = "0 As fUse, 0 As teamNo, 0 As SeedNo, 0 As Ranking, (Dense_Rank() Over(Order By GameRequestGroupIDX)) As dataOrder, (Dense_Rank() Over(Partition By Team Order By GameRequestGroupIDX)) As PlayerOrder," 
'        strField2 = "GameRequestGroupIDX, GameRequestPlayerIDX, MemberIDX, MemberName, Team, TeamName, 0 As PrevTeam, 0 As PrevTeamName"
'        strField = strPrintf("{0} {1}", Array(strField1, strField2)) 
'
'        strTable = "tblGameRequestPlayer With (NoLock)"
'        strWhere  = strPrintf("DelYN='N'  And GameTitleIDX = '{0}' And GameLevelIDX = '{1}'", Array(gTitleIdx, gLevelIdx))
'    
'        If( gTitleIdx <> "" And gLevelIdx <> "") Then 
'            strSql = strPrintf("Select {0} From {1} Where {2} Order By GameRequestGroupIDX", Array(strField, strTable, strWhere))  
'        End If
'
'        getSqlEliteReqPlayer = strSql
'    End Function 

'   ===============================================================================     
'      Elite 대진표 -   GameTitleIdx, GameLevelIDX를 입력받아 경기에 참가 신청한 team 정보를 구한다. 
'     사용유무, 시드 No, 연동대회 Ranking, 팀내 선수순위, 참가신청 GroupIdx, 참가신청 Player Idx, MemberIdx, MemberName, Team, TeamName, 연동대회 입상시 Team, 연동대회 입상시 TeamName
'     fUse, teamNo, SeedNo, Ranking, dataOrder, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName
'     fUse, SeedNo, Ranking, PrevTeam, PrevTeamName는 추후 클라이언트에서 채워질 정보다. 

'     (ROW_NUMBER() Over(Partition By Team Order By WriteDate)) 팀별로 입력순서에 의한 Ordering 
'        => 이렇게 함으로서 Team별로 1,2,3..  순위로 데이터를 구한다. 
'   =============================================================================== 
    Function getSqlEliteReqTeam(gTitleIdx, gLevelIdx)       

        Dim strField, strField1, strField2, strTable, strWhere, strGroupBy

    ' ================================================================================================        
        strField1 = "0 As fUse, 0 As teamNo, 0 As SeedNo, 0 As Ranking, (Dense_Rank() Over(Order By GameRequestTeamIDX)) As dataOrder, (ROW_NUMBER() Over(Partition By Team Order By WriteDate)) As PlayerOrder," 
        strField2 = "GameRequestTeamIDX, GameRequestTeamIDX, "
        strField3 = "TeamDtl, TeamName, "
        strField4 = "Team, TeamName, 0 As PrevTeam, 0 As PrevTeamName"
        strField = strPrintf("{0} {1} {2} {3}", Array(strField1, strField2, strField3, strField4)) 

        strTable = "tblGameRequestTeam As A With (NoLock)"
        strWhere  = strPrintf("DelYN='N'  And GameTitleIDX = '{0}' And GameLevelIDX = '{1}'", Array(gTitleIdx, gLevelIdx))
    
        If( gTitleIdx <> "" And gLevelIdx <> "") Then 
            strSql = strPrintf("Select {0} From {1} Where {2} Order By A.GameRequestTeamIDX", Array(strField, strTable, strWhere))  
        End If

        getSqlEliteReqTeam = strSql
    End Function  


'   ===============================================================================     
'      Elite 대진표 -   GameTitleIdx, Sex, TeamGb, PlayType, GroupGameGb를 입력받아 GameLevelIDX를 구한다. 
'   =============================================================================== 
    Function getSqlEliteAssociateGameLevel(gTitleIdx, cSex, cTeamGB, cPlayType, cGroupGameGB)       

        Dim strField, strTable, strWhere, strGroupBy

    ' ================================================================================================        
        strField = "GameLevelidx"
        strTable = "tblGameLevel With (NoLock)"
        strWhere1  = strPrintf("DelYN='N'  and GameTitleIDX = '{0}' And Sex = '{1}'", Array(gTitleIdx, cSex))
        strWhere2  = strPrintf("And TeamGb = '{0}' And PlayType = '{1}' And GroupGameGB = '{2}'", Array(cTeamGB, cPlayType, cGroupGameGB))

        strWhere = strPrintf("{0} {1}", Array(strWhere1, strWhere2))
    
        If( gTitleIdx <> "") Then 
            strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))  
        End If

        getSqlEliteAssociateGameLevel = strSql
    End Function  

'   ===============================================================================     
'      Elite 대진표 -   GameTitleIDX, GameLevelIdx를 가지고 메달 선수 (공동 3위까지 구하는 정보)를 구한다
'   =============================================================================== 
    Function getSqlEliteMedalPlayer(gTitleIdx, gLevelIdx)       

      Dim strField, strTable, strWhere, strGroupBy, subTable

   ' ================================================================================================  
      ' sub query for inner join table       
      strField = "IGM.TourneyGroupIDX, max(IGM.GameMedalIDX) As GameMedalIDX"
      strTable = "tblGameMedal As IGM With (NoLock)"
      strWhere  = strPrintf("IGM.DelYn = 'N' AND IGM.GameTitleIDX = '{0}' AND IGM.GameLevelIDX = '{1}'", _ 
            Array(gTitleIdx, gLevelIdx))

      subTable = strPrintf("Select {0} From {1} Where {2} Group By IGM.TourneyGroupIDX", Array(strField, strTable, strWhere))  

   ' ================================================================================================        
        strField = "GM.TourneyGroupIDX, GM.GameRanking, TP.MemberIDX, TP.UserName, TP.SEX, TP.TEAM"
        strTable1 = "tblGameMedal As GM With (NoLock)"
        strTable2 = strPrintf("Inner Join ({0}) As SGM On GM.GameMedalIDX = SGM.GameMedalIDX", Array(subTable))
        strTable3 = "Inner Join tblTourneyPlayer As TP On GM.TourneyGroupIDX = TP.TourneyGroupIDX And TP.DelYN = 'N'"
        strTable = strPrintf("{0} {1} {2}", Array(strTable1, strTable2, strTable3))        
    
        If( gTitleIdx <> "" And gLevelIdx <> "" ) Then 
            strSql = strPrintf("Select {0} From {1} Order By  GM.GameRanking", Array(strField, strTable))  
        End If

        getSqlEliteMedalPlayer = strSql
    End Function 

'   ===============================================================================     
'      Elite 대진표 -   GameTitleIDX, GameLevelIdx, strRank를 가지고 상위Ranker 정보를 구한다
'      연동대회 Game Ranking , 현게임 신청여부, GroupIdx, MemberIdx, 선수이름, 성별, 팀, 팀 이름
'      '0' As GameRanking, '0' As ReqGame, TourneyGroupIDX, MemberIDX, UserName, SEX, TEAM, TEAMNM
'   =============================================================================== 
    Function getSqlEliteRankPlayer(gTitleIdx, gLevelIdx, strRank)       

        Dim strField, strTable, strWhere, strGroupBy

    ' ================================================================================================        
        strField = "'0' As GameRanking, '0' As ReqGame, TP.TourneyGroupIDX, TP.MemberIDX, TP.UserName, TP.SEX, TP.Team, TI.TeamNm"
        strTable1 = "tblGameOperate  As GOP With (NoLock)"
        strTable2 = "Inner Join tblTourneyPlayer As TP With (NoLock) On TP.DelYN = 'N' And (GOP.L_TourneyGroupIDX = TP.TourneyGroupIDX Or GOP.R_TourneyGroupIDX = TP.TourneyGroupIDX)"
        strTable3 = "Inner Join tblTeamInfo As TI With (NoLock) On TI.DelYN = 'N' And TI.Team = TP.Team"
        strTable = strPrintf("{0} {1} {2}", Array(strTable1, strTable2, strTable3))

        strWhere1  = "GOP.DelYn = 'N' AND PlayLevelType = 'B0100002'"
        strWhere2  = strPrintf("And GOP.GameTitleIDX = '{0}' AND GOP.GameLevelIDX = '{1}' And GOP.NowRoundName = '{2}'", _ 
               Array(gTitleIdx, gLevelIdx, strRank))    

         strWhere = strPrintf("{0} {1}", Array(strWhere1, strWhere2))    
    
        If( gTitleIdx <> "") Then 
            strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))  
        End If

        getSqlEliteRankPlayer = strSql
    End Function 

'   ===============================================================================     
'      Elite 대진표 -   GameTitleIDX, GameLevelIdx, strRank를 가지고 8강, 4강 정보를 구한다
'   =============================================================================== 
    Function getSqlEliteRankInfo(gTitleIdx, gLevelIdx, strRank)       

        Dim strField, strTable, strWhere, strGroupBy

    ' ================================================================================================        
        strField = "L_TourneyGroupIDX, R_TourneyGroupIDX"
        strTable = "tblGameOperate  As GOP With (NoLock)"
        strWhere1  = "GOP.DelYn = 'N' AND PlayLevelType = 'B0100002'"
        strWhere2  = strPrintf("And GOP.GameTitleIDX = '{0}' AND GOP.GameLevelIDX = '{1}' And GOP.NowRoundName = '{2}'", _ 
               Array(gTitleIdx, gLevelIdx, strRank))    

         strWhere = strPrintf("{0} {1}", Array(strWhere1, strWhere2))          
    
        If( gTitleIdx <> "") Then 
            strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))  
        End If

        getSqlEliteRankInfo = strSql
    End Function 

'   ===============================================================================     
'        GameLevelDtl을 Insert한다.       
'        gameGb: 본선, 예선  , gameType : 리그, 토너먼트 
'   =============================================================================== 
   Function getSqlInsertGameLvDtl(titleIdx, levelIdx, gameGb, gameType, totRound, jooNum, jooRank ) 
      Dim strSql

      If(titleIdx <> "" And levelIdx<> "" And gameGb<> "" And gameType<> "" And totRound<> "" And jooRank<> "") Then       
         strSql =          "Set NoCount On "
         strSql = strSql & "Insert Into tblGameLevelDtl "
         strSql = strSql & "(GameTitleIDX, GameLevelidx, PlayLevelType, GameType, FullGameYN, "
         strSql = strSql & " StadiumNum, TotRound, EnterType, EntryCnt, LevelJooNum, JooRank, MaxPoint) "
         strSql = strSql & sprintf(" values ('{0}', '{1}', '{2}', '{3}', '{4}', ", _
                     Array(titleIdx, levelIdx, gameGb, gameType, "N"))
         strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}')", _
                     Array(0, totRound, "E", 0, jooNum, jooRank, 0)) 
         strSql = strSql & " Select @@Identity As Seq "
      End If 

      getSqlInsertGameLvDtl = strSql 
   End Function 

'   ===============================================================================     
'        titleIdx, LvIdx를 가지고 GameLevelDtl를 Select한다. 
'   =============================================================================== 
   Function getSqlSelectGameLvDtl(titleIdx, LvIdx ) 
      Dim strSql

      If(titleIdx <> "" And LvIdx<> "") Then       
         strSql =          " Select GLD.GameTitleIDX, GL.GameLevelIdx, GLD.GameLevelDtlIdx, GLD.PlayLevelType, GL.TeamGb, GL.GroupGameGb,  "
         strSql = strSql & "        GL.Level, GLD.LevelDtlName, GL.Sex, GLD.TotRound,  "
         strSql = strSql & " Case  "
         strSql = strSql & "    When GLD.TotRound = 512 Then '9' "
         strSql = strSql & "    When GLD.TotRound = 256 Then '8' "
         strSql = strSql & "    When GLD.TotRound = 128 Then '7' "
         strSql = strSql & "    When GLD.TotRound = 64 Then '6' "
         strSql = strSql & "    When GLD.TotRound = 32 Then '5' "
         strSql = strSql & "    When GLD.TotRound = 16 Then '4' "
         strSql = strSql & "    When GLD.TotRound = 8 Then '3' "
         strSql = strSql & "    When GLD.TotRound = 4 Then '2' "
         strSql = strSql & "    When GLD.TotRound = 2 Then '1' "
         strSql = strSql & "    Else '0' "
         strSql = strSql & " End As CntRound "
         strSql = strSql & " From tblGameLevelDtl As GLD "
         strSql = strSql & " Inner Join tblGameLevel As GL "
         strSql = strSql & " On GL.GameLevelidx = GLD.GameLevelidx "
         strSql = strSql & sprintf(" Where GLD.GameTitleIdx = '{0}' And GLD.GameLevelIdx = '{1}'", _
                              Array(titleIdx, LvIdx))
         strSql = strSql & " And GLD.DelYN = 'N' And GL.DelYN = 'N' "
      End If 

      getSqlSelectGameLvDtl = strSql 
   End Function 

'   ===============================================================================     
'        Level Idx를 이용하여 tblGameLevel로 부터 gameLevelInfo를 얻는다. 
'        groupGameGb, playType, enterType
'   =============================================================================== 
   Function getSqlLevelInfo(levelIdx) 
      Dim strSql

      If(levelIdx <> "") Then       
         strSql =          "Select Top 1 GL.GroupGameGb, GL.EnterType, GL.PlayType "
         strSql = strSql & "From tblGameLevel As GL  With (NoLock)  "
         strSql = strSql & sprintf(" Where GL.DelYN = 'N' And GL.GameLevelIdx = '{0}'", Array(levelIdx))
      End If 

      getSqlLevelInfo = strSql 
   End Function 

'   ===============================================================================     
'        GameRequestTouney을 Insert한다.       
'        requestIdx: requestGroupIdx / requestTeamIdx  , GroupGameGb : 개인전/단체전, levelDtlIdx
'        Bye나 Q는 추가하지 않는다. 0 : Bye, Q1, Q2 : Q 
'   =============================================================================== 
   Function getSqlInsertRequestTourney( titleIdx, LvIdx, levelDtlIdx, requestIdx, GroupGameGb) 
      Dim strSql, IsBye, IsQ
      IsBye = 0
      IsQ = 0
      If(requestIdx = "0") Then IsBye = 1 End If 
      If(Instr(requestIdx, "Q") > 0) Then IsQ = 1 End If 
      

      If(titleIdx <> "" And LvIdx <> "" And requestIdx <> "" And GroupGameGb<> "" And levelDtlIdx<> "" And IsBye = 0 And IsQ = 0) Then       
         strSql =          "Set NoCount On "
         strSql = strSql & "Insert Into tblGameRequestTouney "
         strSql = strSql & "(GameTitleIDX, GameLevelIDX, GameLevelDtlIdx, RequestIdx, GroupGameGb) "
         strSql = strSql & sprintf(" values ('{0}', '{1}', '{2}', '{3}', '{4}')", _ 
                     Array(titleIdx, LvIdx, levelDtlIdx, requestIdx, GroupGameGb))
      End If 

      getSqlInsertRequestTourney = strSql 
   End Function 

'   ===============================================================================     
'        tblTourneyGroup에 Insert한다. 
'   =============================================================================== 
   Function getSqlInsertTourneyGroup( titleIdx, levelDtlIdx, teamGb, lv, lvDtlName, TourneyGroupNum) 
      Dim strSql      

      If(titleIdx <> "" And levelDtlIdx <> "" And teamGb <> ""  ) Then       
         strSql =          "Set NoCount On "
         strSql = strSql & "Insert Into tblTourneyGroup "
         strSql = strSql & "(GameTitleIDX, GameLevelDtlidx, TeamGb, Level, LevelDtlName, TourneyGroupNum, Team, TeamDtl) "
         strSql = strSql & sprintf(" values ('{0}', '{1}', '{2}', '{3}', '{4}', '{5}', {6}, '{7}');", _ 
                     Array(titleIdx, levelDtlIdx, teamGb, lv, lvDtlName, TourneyGroupNum, "NULL", "0"))
         strSql = strSql & "Select @@Identity As Seq;"
      End If 

      getSqlInsertTourneyGroup = strSql 
   End Function 

'   ===============================================================================     
'        tblTourneyPlayer에 Insert한다. 
'   =============================================================================== 
   Function getSqlInsertTourneyPlayer( titleIdx, levelDtlIdx, teamGb, lv, lvDtlName, GroupIdx, sex, reqGroupIdx) 
      Dim strSql      

      If(titleIdx <> "" And levelDtlIdx <> "" And teamGb <> "" ) Then       
         strSql =          "Set NoCount On "
         strSql = strSql & "Insert Into tblTourneyPlayer "
         strSql = strSql & "(TourneyGroupIDX, GameTitleIDX, GameLevelDtlidx, TeamGb, Level, LevelDtlName, Sex, "
         strSql = strSql & " MemberIDX, UserName, MemberNum, CourtPosition, Team, TeamDtl, Team_Origin) "
         strSql = strSql & sprintf("Select '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', ", _
                     Array(GroupIdx, titleIdx, levelDtlIdx, teamGb, lv, lvDtlName, sex ))
         strSql = strSql & " A.MemberIdx, A.MemberName, 0, NULL, A.Team, A.TeamDtl, A.Team_Origin"
         strSql = strSql & " From  tblGameRequestPlayer As A "
         strSql = strSql & " Inner Join  tblGameRequestTouney As B "
         strSql = strSql & " ON B.RequestIDX = A.GameRequestGroupIDX "
         strSql = strSql & " Where A.DelYN = 'N' And  B.DelYN = 'N' And B.GroupGameGb = 'B0030001' "  ' 개인전
         strSql = strSql & sprintf(" AND B.GameLevelDtlIDX = '{0}' AND A.GameRequestGroupIDX = '{1}'",  _
                     Array(levelDtlIdx, reqGroupIdx ))
      End If 

      getSqlInsertTourneyPlayer = strSql 
   End Function 

'   ===============================================================================     
'        tblTourney에 Insert한다. 
'   =============================================================================== 
   Function getSqlInsertTourney( titleIdx, lvIdx, levelDtlIdx, teamGb, GroupGameGb, lv, lvDtlName, _
                                 reqGroupIdx, GroupIdx, TourneyNum, nRound, teamGameNum, GameNum, ORDERBY, _
                                 byeYN, QVal, nSeed, GameNo ) 
      Dim strSql      

      If(titleIdx <> "" And levelDtlIdx <> "" And teamGb <> ""  ) Then       
         strSql =          "Set NoCount On "
         strSql = strSql & "Insert Into tblTourney "
         strSql = strSql & "(GameTitleIDX, GameLevelIDX, GameLevelDtlidx, TeamGb, GroupGameGb, Level,LevelDtlName, "
         strSql = strSql & " RequestIDX, TourneyGroupIDX,TourneyNum, Round, TeamGameNum, GameNum, ORDERBY, "
         strSql = strSql & " ByeYN, Qualifier,SeedNum, KR_DPGamenum ) "
         strSql = strSql & sprintf("Values( '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', ", _
                     Array(titleIdx, lvIdx, levelDtlIdx, teamGb, GroupGameGb, lv, lvDtlName ))
         strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', ", _
                     Array(reqGroupIdx, GroupIdx, TourneyNum, nRound, teamGameNum, GameNum, ORDERBY  ))
         strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}') ", _
                     Array(byeYN, QVal, nSeed, GameNo ))
      End If 

      getSqlInsertTourney = strSql 
   End Function 

'   ===============================================================================     
'        tblTourneyTeam에 Insert한다. 
'   =============================================================================== 
   Function getSqlInsertTourneyTeam( titleIdx, lvIdx, levelDtlIdx, teamGb, lv, lvDtlName, _
                                     reqGroupIdx, TourneyTeamNum, nRound, teamGameNum, ORDERBY, byeYN, QVal, nSeed, GameNo ) 
      Dim strSql, emptyTeamNm, emptyTeam, emptyTeamDtl      

      If(titleIdx <> "" And levelDtlIdx <> "" And teamGb <> "" ) Then       
         If(reqGroupIdx = "0") Or (reqGroupIdx = "") Then             
            emptyTeamNm    = Null
            emptyTeam      = Null
            emptyTeamDtl   = "0"
            strSql =          "Set NoCount On "
            strSql = strSql & "Insert Into tblTourneyTeam "
            strSql = strSql & "(GameTitleIDX, GameLevelIDX, GameLevelDtlidx, TeamGb, Level,LevelDtlName, "
            strSql = strSql & " RequestIDX, TourneyTeamNum, Round, TeamGameNum, ORDERBY, "
            strSql = strSql & " ByeYN, Qualifier,SeedNum, KR_DPGamenum, "
            strSql = strSql & " TeamName, Team, TeamDtl ) "
            strSql = strSql & sprintf("Values( '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', ", _
                        Array(titleIdx, lvIdx, levelDtlIdx, teamGb, lv, lvDtlName ))
            strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}', '{4}', ", _
                        Array(reqGroupIdx, TourneyTeamNum, nRound, teamGameNum, ORDERBY ))
            strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}') ", _ 
                        Array(byeYN, QVal, nSeed, GameNo, emptyTeamNm, emptyTeam, emptyTeamDtl ))
         Else 
            strSql =          "Set NoCount On "
            strSql = strSql & "Insert Into tblTourneyTeam "
            strSql = strSql & "(GameTitleIDX, GameLevelIDX, GameLevelDtlidx, TeamGb, Level,LevelDtlName, "
            strSql = strSql & " RequestIDX, TourneyTeamNum, Round, TeamGameNum, ORDERBY, "
            strSql = strSql & " ByeYN, Qualifier,SeedNum, KR_DPGamenum,  "
            strSql = strSql & " TeamName, Team, TeamDtl ) "
            strSql = strSql & sprintf("Select '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', ", _
                        Array(titleIdx, lvIdx, levelDtlIdx, teamGb, lv, lvDtlName ))
            strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}', '{4}', ", _
                        Array(reqGroupIdx, TourneyTeamNum, nRound, teamGameNum, ORDERBY ))
            strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}', ", Array(byeYN, QVal, nSeed, GameNo ))
            strSql = strSql & "B.TeamNm, A.Team, A.TeamDtl "
            strSql = strSql & "From tblGameRequestGroup As A "
            strSql = strSql & "Inner Join tblTeamInfo As B "
            strSql = strSql & "On A.Team = B.Team "
            strSql = strSql & "Where A.DelYN = 'N' And B.DelYN = 'N' "
            strSql = strSql & sprintf("And A.GameRequestTeamIDX = '{0}'", Array(reqGroupIdx))
         End If 
      End If        

      getSqlInsertTourneyTeam = strSql 
   End Function 

''   ===============================================================================     
''        tblTourney에 Insert한다. 
''   =============================================================================== 
'   Function getSqlInsertTourney( titleIdx, lvIdx, levelDtlIdx, teamGb, GroupGameGb, lv, lvDtlName, _
'                                 reqGroupIdx, GroupIdx, TourneyNum, nRound, teamGameNum, GameNum, ORDERBY, _
'                                 byeYN, QVal, nSeed ) 
'      Dim strSql      
'
'      If(titleIdx <> "" And levelDtlIdx <> "" And teamGb <> "" And lv <> "" ) Then       
'         strSql =          "Set NoCount On "
'         strSql = strSql & "Insert Into tblTourney "
'         strSql = strSql & "(GameTitleIDX, GameLevelIDX, GameLevelDtlidx, TeamGb, GroupGameGb, Level,LevelDtlName, "
'         strSql = strSql & " RequestIDX, TourneyGroupIDX,TourneyNum, Round, TeamGameNum, GameNum, ORDERBY, "
'         strSql = strSql & " ByeYN, Qualifier,SeedNum ) "
'         strSql = strSql & sprintf("Values( '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', ", _
'                     Array(titleIdx, lvIdx, levelDtlIdx, teamGb, GroupGameGb, lv, lvDtlName ))
'         strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', ", _
'                     Array(reqGroupIdx, GroupIdx, TourneyNum, nRound, teamGameNum, GameNum, ORDERBY  ))
'         strSql = strSql & sprintf(" '{0}', '{1}', '{2}') ", _
'                     Array(byeYN, QVal, nSeed ))
'      End If 
'
'      getSqlInsertTourney = strSql 
'   End Function 
'
''   ===============================================================================     
''        tblTourneyTeam에 Insert한다. 
''   =============================================================================== 
'   Function getSqlInsertTourneyTeam( titleIdx, lvIdx, levelDtlIdx, teamGb, lv, lvDtlName, _
'                                     reqGroupIdx, TourneyTeamNum, nRound, teamGameNum, ORDERBY, byeYN, QVal, nSeed ) 
'      Dim strSql, emptyTeamNm, emptyTeam, emptyTeamDtl      
'
'      If(titleIdx <> "" And levelDtlIdx <> "" And teamGb <> "" ) Then       
'         If(reqGroupIdx = "0") Or (reqGroupIdx = "") Then             
'            emptyTeamNm    = Null
'            emptyTeam      = Null
'            emptyTeamDtl   = "0"
'            strSql =          "Set NoCount On "
'            strSql = strSql & "Insert Into tblTourneyTeam "
'            strSql = strSql & "(GameTitleIDX, GameLevelIDX, GameLevelDtlidx, TeamGb, Level,LevelDtlName, "
'            strSql = strSql & " RequestIDX, TourneyTeamNum, Round, TeamGameNum, ORDERBY, "
'            strSql = strSql & " ByeYN, Qualifier,SeedNum,  "
'            strSql = strSql & " TeamName, Team, TeamDtl ) "
'            strSql = strSql & sprintf("Values( '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', ", _
'                        Array(titleIdx, lvIdx, levelDtlIdx, teamGb, lv, lvDtlName ))
'            strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}', '{4}', ", _
'                        Array(reqGroupIdx, TourneyTeamNum, nRound, teamGameNum, ORDERBY ))
'            strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}', '{4}', '{5}') ", _ 
'                        Array(byeYN, QVal, nSeed, emptyTeamNm, emptyTeam, emptyTeamDtl ))
'         Else 
'            strSql =          "Set NoCount On "
'            strSql = strSql & "Insert Into tblTourneyTeam "
'            strSql = strSql & "(GameTitleIDX, GameLevelIDX, GameLevelDtlidx, TeamGb, Level,LevelDtlName, "
'            strSql = strSql & " RequestIDX, TourneyTeamNum, Round, TeamGameNum, ORDERBY, "
'            strSql = strSql & " ByeYN, Qualifier,SeedNum,  "
'            strSql = strSql & " TeamName, Team, TeamDtl ) "
'            strSql = strSql & sprintf("Select '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', ", _
'                        Array(titleIdx, lvIdx, levelDtlIdx, teamGb, lv, lvDtlName ))
'            strSql = strSql & sprintf(" '{0}', '{1}', '{2}', '{3}', '{4}', ", _
'                        Array(reqGroupIdx, TourneyTeamNum, nRound, teamGameNum, ORDERBY ))
'            strSql = strSql & sprintf(" '{0}', '{1}', '{2}', ", Array(byeYN, QVal, nSeed ))
'            strSql = strSql & "B.TeamNm, A.Team, A.TeamDtl "
'            strSql = strSql & "From tblGameRequestGroup As A "
'            strSql = strSql & "Inner Join tblTeamInfo As B "
'            strSql = strSql & "On A.Team = B.Team "
'            strSql = strSql & "Where A.DelYN = 'N' And B.DelYN = 'N' "
'            strSql = strSql & sprintf("And A.GameRequestTeamIDX = '{0}'", Array(reqGroupIdx))
'         End If 
'      End If        
'
'      getSqlInsertTourneyTeam = strSql 
'   End Function 


'   ===============================================================================     
'        titleIdx, LvIdx를 가지고 tblGameRequestTouney의 데이터를 지워준다. 
'   =============================================================================== 
   Function getSqlDelRequestTourney( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then       
         strSql =          "Update tblGameRequestTouney  "
         strSql = strSql & "Set DelYN = 'Y' , EditDate = Getdate() "         
         strSql = strSql & sprintf(" Where DelYN = 'N' And GameTitleIDX = '{0}' And GameLevelIdx = '{1}'", _ 
                     Array(titleIdx, LvIdx))
      End If 

      getSqlDelRequestTourney = strSql 
   End Function

'   ===============================================================================     
'        titleIdx, LvIdx를 가지고 tblGameLevelDtl의 데이터를 지워준다. 
'   =============================================================================== 
   Function getSqlDelLevelDtl( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then       
         strSql =          "Update tblGameLevelDtl  "
         strSql = strSql & "Set DelYN = 'Y' , EditDate = Getdate() "         
         strSql = strSql & sprintf(" Where DelYN = 'N' And GameTitleIDX = '{0}' And GameLevelIdx = '{1}'", _ 
                     Array(titleIdx, LvIdx))
      End If 

      getSqlDelLevelDtl = strSql 
   End Function

'   ===============================================================================     
'        titleIdx, LvIdx를 가지고 tblTourney의 데이터를 지워준다. 
'   =============================================================================== 
   Function getSqlDelTourney( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then       
         strSql =          "Update tblTourney  "
         strSql = strSql & "Set DelYN = 'Y' , EditDate = Getdate() "         
         strSql = strSql & sprintf(" Where DelYN = 'N' And GameTitleIDX = '{0}' And GameLevelIdx = '{1}'", _ 
                     Array(titleIdx, LvIdx))
      End If 

      getSqlDelTourney = strSql 
   End Function

'   ===============================================================================     
'        titleIdx, LvIdx를 가지고 tblTourneyTeam의 데이터를 지워준다. 
'   =============================================================================== 
   Function getSqlDelTourneyTeam( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then       
         strSql =          "Update tblTourneyTeam  "
         strSql = strSql & "Set DelYN = 'Y' , EditDate = Getdate() "         
         strSql = strSql & sprintf(" Where DelYN = 'N' And GameTitleIDX = '{0}' And GameLevelIdx = '{1}'", _ 
                     Array(titleIdx, LvIdx))
      End If 

      getSqlDelTourneyTeam = strSql 
   End Function

'   ===============================================================================     
'        titleIdx, LvIdx를 가지고 tblTourneyGroup의 데이터를 지워준다. 
'   =============================================================================== 
   Function getSqlDelTourneyGroup( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then       
         strSql =          "Update tblTourneyGroup  "
         strSql = strSql & "Set DelYN = 'Y' , EditDate = Getdate() "        
         strSql = strSql & "From tblTourneyGroup As A "
         strSql = strSql & "Inner Join tblGameLevelDtl As B "
         strSql = strSql & "On A.GameLevelDtlIdx = B.GameLevelDtlidx"
         strSql = strSql & sprintf(" Where A.DelYN = 'N' And B.DelYN = 'N' And B.GameTitleIDX = '{0}' And B.GameLevelIdx = '{1}'", _ 
                     Array(titleIdx, LvIdx))
      End If 

      getSqlDelTourneyGroup = strSql 
   End Function

'   ===============================================================================     
'        titleIdx, LvIdx를 가지고 tblTourneyPlayer의 데이터를 지워준다. 
'   =============================================================================== 
   Function getSqlDelTourneyPlayer( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then       
         strSql =          "Update tblTourneyPlayer  "
         strSql = strSql & "Set DelYN = 'Y' , EditDate = Getdate() "        
         strSql = strSql & "From tblTourneyPlayer As A "
         strSql = strSql & "Inner Join tblGameLevelDtl As B "
         strSql = strSql & "On A.GameLevelDtlIdx = B.GameLevelDtlidx"
         strSql = strSql & sprintf(" Where A.DelYN = 'N' And B.DelYN = 'N' And B.GameTitleIDX = '{0}' And B.GameLevelIdx = '{1}'", _ 
                     Array(titleIdx, LvIdx))
      End If

      getSqlDelTourneyPlayer = strSql 
   End Function

'   ===============================================================================     
'        titleIdx, LvIdx를 가지고 tblGameOperate의 데이터를 지워준다. 
'   =============================================================================== 
   Function getSqlDelGameOperate( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then       
         strSql =          "Update tblGameOperate  "
         strSql = strSql & "Set DelYN = 'Y' , EditDate = Getdate() "        
         strSql = strSql & "From tblGameOperate As A "
         strSql = strSql & sprintf(" Where A.DelYN = 'N' And A.GameTitleIDX = '{0}' And A.GameLevelIdx = '{1}'", _ 
                     Array(titleIdx, LvIdx))
      End If

      getSqlDelGameOperate = strSql 
   End Function


'   ===============================================================================     
'        titleIdx, LvIdx를 가지고 tblTourneyGroup의 데이터를 지워준다. 
'   =============================================================================== 
   Function getSqlDelTourneyGroup_arTest( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then       
         strSql =          "Update tblTourneyGroup_arTest  "
         strSql = strSql & "Set DelYN = 'Y' , EditDate = Getdate() "        
         strSql = strSql & "From tblTourneyGroup_arTest As A "
         strSql = strSql & "Inner Join tblGameLevelDtl As B "
         strSql = strSql & "On A.GameLevelDtlIdx = B.GameLevelDtlidx"
         strSql = strSql & sprintf(" Where A.DelYN = 'N' And B.DelYN = 'N' And B.GameTitleIDX = '{0}' And B.GameLevelIdx = '{1}'", _ 
                     Array(titleIdx, LvIdx))
      End If 

      getSqlDelTourneyGroup_arTest = strSql 
   End Function

'   ===============================================================================     
'        titleIdx, LvIdx를 가지고 tblTourneyPlayer의 데이터를 지워준다. 
'   =============================================================================== 
   Function getSqlDelTourneyPlayer_arTest( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then       
         strSql =          "Update tblTourneyPlayer_arTest  "
         strSql = strSql & "Set DelYN = 'Y' , EditDate = Getdate() "        
         strSql = strSql & "From tblTourneyPlayer_arTest As A "
         strSql = strSql & "Inner Join tblGameLevelDtl As B "
         strSql = strSql & "On A.GameLevelDtlIdx = B.GameLevelDtlidx"
         strSql = strSql & sprintf(" Where A.DelYN = 'N' And B.DelYN = 'N' And B.GameTitleIDX = '{0}' And B.GameLevelIdx = '{1}'", _ 
                     Array(titleIdx, LvIdx))
      End If

      getSqlDelTourneyPlayer_arTest = strSql 
   End Function

'   ===============================================================================     
'        Elite(복식) - 참가신청 참가자 
'   =============================================================================== 
   Function getSqlReqPlayerDbl( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then      			
			' --------------------- 복식 
			' GameTitleIDX, GameLevelIDX를 가지고 tblGameRequestPlayer에서 참가 신청 명단을 얻는다. 
			' 이때 tblMember를 Inner Join하여 신청자의 성별을 얻는다. 
			' 이때 Row_number를 이용하여 사용자를 정렬한다. 
			' 	- Partition BY P.GameRequestGroupIDX 로 Group을 잡고 그 안에서 Order By P.team 팀별로 정렬한다. 
			strSql = 			" WITH cte_teamUser As (		 "
			strSql = strSql & " 		Select Dense_Rank() Over(Order By GameRequestGroupIDX) As UIdx, AA.* From ( "
			strSql = strSql & " 			Select Row_number() Over(Partition BY P.GameRequestGroupIDX Order By P.team ) AS Idx,  "
			strSql = strSql & " 					P.GameRequestGroupIDX, P.GameRequestPlayerIDX,  "
			strSql = strSql & " 					P.memberIdx, P.memberName, P.team, P.teamName, M.Sex "
			strSql = strSql & " 			From   tblGameRequestPlayer As P WITH (nolock)  "
			strSql = strSql & " 			Inner Join tblMember As M On M.memberIdx = P.memberIdx And M.DelYN = 'N'  "
			strSql = strSql & sprintf(" Where P.DelYN = 'N'AND P.GameTitleIDX = '{0}' AND P.GameLevelIDX = '{1}' ", Array(titleIdx, LvIdx))
			strSql = strSql & " 		) As AA		  "
			strSql = strSql & " ) "

			' 	cte_teamUser에서 얻은 참가 신청 명단은  GameRequestGroupIDX별로 Team 순으로 정렬되어 있다.  
			' 	여기서 Self Join을 이용하여 고유팀을 추려낸다. Group By U1.Team, U2.Team 
			' 	이때 Row_Number() Over(Order By U1.Team, U2.Team) As teamNo 로 teamNo를 생성한다.  
			strSql = strSql & " , cte_team As (  "
			strSql = strSql & " 	Select Row_Number() Over(Order By minIdx) As teamNo, AA.cntTeam, AA.Team1, AA.Team2  "
			strSql = strSql & " 		From ( "
			strSql = strSql & " 				Select Min(U1.UIdx) As minIdx, Count(U1.UIdx) As cntTeam,  "
			strSql = strSql & " 				U1.Team As Team1, U2.Team As Team2 "
			strSql = strSql & " 				From cte_teamUser As U1  "
			strSql = strSql & " 				Inner Join cte_teamUser As U2 On U1.GameRequestGroupIDX = U2.GameRequestGroupIDX And U2.Idx = U1.Idx + 1 "
			strSql = strSql & " 				Group By U1.Team , U2.Team "
			strSql = strSql & " 		) As AA  "
			strSql = strSql & " ) "

			'	cte_teamUser를 Inner Join으로 self Join하여 각 파트너의 Team, Sex를 얻는다.  
			'	이때 파트너와 성별이 같은지 확인하여 SameSex = 0 , 1을 셋팅한다.  
			'	cte_team을 Inner Join하여 나와 파트너의 team을 확인하여 teamNo를 셋팅한다.  
			strSql = strSql & " , cte_userTmp As ( "
			strSql = strSql & " 	Select U1.* , U2.Team As Team2, T.teamNo, T.cntTeam,  "
			strSql = strSql & " 	U2.Sex As Sex2,  "
			strSql = strSql & " 	Case When (U1.Sex = U2.Sex) Then 1 Else 0 End As SameSex "
			strSql = strSql & " 	From cte_teamUser As U1 "
			strSql = strSql & " 	Inner Join cte_teamUser As U2 On U1.GameRequestGroupIDX = U2.GameRequestGroupIDX And U1.Idx != U2.Idx "
			'strSql = strSql & " 	Inner Join cte_team As T On ( (T.Team1 = U1.Team Or T.Team1 = U2.Team) And (T.Team2 = U1.Team Or T.Team2 = U2.Team) ) "
			strSql = strSql & " 	Inner Join cte_team As T On ( (T.Team1 = U1.Team And T.Team2 = U2.Team) Or (T.Team1 = U2.Team And T.Team2 = U1.Team) )  "
			strSql = strSql & " ) "

			'	cte_userTmp에서 얻은 정보를 이용하여 좀더 명확한 user 정보를 꾸린다 . 
			'	GameRequestGroupIDX를 정렬하여 dataOrder를 셋팅, (Dense_Rank() Over(Order by GameRequestGroupIDX)) 
			'	teamNo로 Grouping하여 그안에서 GameRequestGroupIDX를 정렬하여 PlayerOrder를 셋팅 - (Dense_Rank() Over(Partition By teamNo Order By GameRequestGroupIdx))  
			strSql = strSql & " , cte_user As ( "
			strSql = strSql & " 	Select  0 As fUse, teamNo, 0 As seedNo, 0 As Ranking,  "
			strSql = strSql & " 	(Dense_Rank() Over(Order by GameRequestGroupIDX)) As dataOrder,  "
			strSql = strSql & " 	(Dense_Rank() Over(Partition By teamNo Order By GameRequestGroupIdx)) As PlayerOrder,  "
			strSql = strSql & " 	GameRequestGroupIDX, GameRequestPlayerIDX, memberIdx, memberName, team, teamName,  "
			strSql = strSql & " 	0 As prevTeam, 0 As prevTeamName, cntTeam, Sex, sameSex	 "
			strSql = strSql & " From cte_userTmp "
			strSql = strSql & " ) "

			'	cte_user에서 얻은 정보를 이용하여 좀더 명확한 user 정보를 꾸린다  
			'	참가자 명단을 각 팀별 1장, 2장 .. 순으로 뽑기 위하여  
			'	PlayerOrder, GameRequestGroupIdx로 Grouping을 한 후 ,  
			'	성별이 같을때는 GameRequestPlayerIDX로 정렬을 하고  
			'	성별이 다를때는 Sex로 정렬을 한다.  
			'		Row_Number() Over( Partition By PlayerOrder, GameRequestGroupIdx Order By GameRequestGroupIdx) 
			strSql = strSql & " Select *, Row_Number() Over( Partition By U.PlayerOrder, GameRequestGroupIdx  "
			strSql = strSql & " 								Order By  "
			strSql = strSql & " 									Case When sameSex = 0 Then Sex End,  "
			strSql = strSql & " 									Case When sameSex = 1 Then GameRequestPlayerIDX End "
			strSql = strSql & " 									 "
			strSql = strSql & " 							) As UserIdx "
			strSql = strSql & " From cte_user As U  "
   	End If

      getSqlReqPlayerDbl = strSql 
   End Function

'   ===============================================================================     
'        Elite(단식) - 참가신청 참가자 
'   =============================================================================== 
   Function getSqlReqPlayer( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then      
			  
			'	--------------------- 단식 
			'	GameTitleIDX, GameLevelIDX를 가지고 tblGameRequestPlayer에서 참가 신청 명단을 얻는다. 				
			strSql = strSql & " WITH cte_teamUser As ( "
			strSql = strSql & " 		Select Row_Number() Over(Order By GameRequestGroupIDX) As uIdx,  "
			strSql = strSql & " 					GameRequestGroupIDX, GameRequestPlayerIDX,  "
			strSql = strSql & " 					memberIdx, memberName, team, teamName "
			strSql = strSql & " 			From   tblGameRequestPlayer As P WITH (nolock)  "
			strSql = strSql & sprintf(" Where DelYN = 'N'AND GameTitleIDX = '{0}' AND GameLevelIDX = '{1}') ", Array(titleIdx, LvIdx))

			'	cte_teamUser로 부터 고유팀을 추려낸다. Group By Team  "
			'	이때Row_Number() Over(Order By Team) As TeamNo, Count(Team) As cntTeam 로 teamNo, team별 player Count 를 생성한다. 			 "
			strSql = strSql & " , cte_team As ( "
			strSql = strSql & " 	Select Row_Number() Over(Order By minIdx) As teamNo, * From ( "
			strSql = strSql & " 		Select Min(uIdx) As minIdx, Count(Team) As cntTeam, Team   "
			strSql = strSql & " 		From cte_teamUser Group By Team  "
			strSql = strSql & " 	) As AA  "
			strSql = strSql & " ) "

			'	cte_teamUser에서 얻은 정보를 이용하여 좀더 명확한 user 정보를 꾸린다 . "
			'	GameRequestGroupIDX를 정렬하여 dataOrder를 셋팅, (Dense_Rank() Over(Order by GameRequestGroupIDX)) "
			'	teamNo로 Grouping하여 그안에서 GameRequestGroupIDX를 정렬하여 PlayerOrder를 셋팅 - (Dense_Rank() Over(Partition By T.teamNo Order By U.GameRequestGroupIDX)) "
			'	cte_team을 조인하여 teamNo, cntTeam을 구한다. 			 "
			strSql = strSql & " , cte_user As ( "
			strSql = strSql & " 	Select 0 As fUse, T.teamNo, 0 As seedNo, 0 As Ranking ,  "
			strSql = strSql & " 	(Dense_Rank() Over(Order By U.GameRequestGroupIDX )) As dataOrder,  "
			strSql = strSql & " 	(Dense_Rank() Over(Partition By T.teamNo Order By U.GameRequestGroupIDX)) As playerOrder,  "
			strSql = strSql & " 	GameRequestGroupIDX, GameRequestPlayerIDX, memberIdx, memberName, U.team, U.teamName,  "
			strSql = strSql & " 	0 As prevTeam, 0 As prevTeamName, T.cntTeam	, 0 As Sex, 0 As sameSex "
			strSql = strSql & " 	From cte_teamUser As U "
			strSql = strSql & " 	Inner Join cte_team As T On U.Team = T.Team  "
			strSql = strSql & " ) "

			'	cte_user에서 얻은 정보를 이용하여 좀더 명확한 user 정보를 꾸린다  "
			'	참가자 명단을 각 팀별 1장, 2장 .. 순으로 뽑기 위하여  "
			'	PlayerOrder로 Grouping을 한 후 , GameRequestGroupIdx로 정렬한다.  "
			'		Row_Number() Over( Partition By U.PlayerOrder Order By U.GameRequestGroupIdx )			 "
			strSql = strSql & " Select U.*, Row_Number() Over( Partition By U.PlayerOrder Order By U.GameRequestGroupIdx ) As UserIdx "
			strSql = strSql & " From cte_user As U  "
		End If

      getSqlReqPlayer = strSql 
   End Function

'   ===============================================================================     
'        Elite(단체전) - 참가신청 참가자 
'   =============================================================================== 
   Function getSqlReqTeam( titleIdx, LvIdx) 
      Dim strSql

      If(titleIdx <> "" And LvIdx <> "") Then     			  
			'	--------------------- 단체전 (개인전 단식과 비슷) 
			'	GameTitleIDX, GameLevelIDX를 가지고 tblGameRequestTeam에서 참가 신청 명단을 얻는다. 			
			strSql = strSql & " ;With cte_teamUser As ( "
			strSql = strSql & " 		Select Row_Number() Over(Order By GameRequestTeamIDX) As tIdx,  "
			strSql = strSql & " 				GameRequestTeamIDX,TeamDtl, TeamName, Team        "
			strSql = strSql & " 		FROM   tblGameRequestTeam AS A WITH (nolock)  "			
			strSql = strSql & sprintf(" Where DelYN = 'N'AND GameTitleIDX = '{0}' AND GameLevelIDX = '{1}' ) ", Array(titleIdx, LvIdx))
			'strSql = strSql & " )  "

			'	cte_teamUser로 부터 고유팀을 추려낸다. Group By Team  "
			'	이때Row_Number() Over(Order By Team) As TeamNo, Count(Team) As cntTeam 로 teamNo, team별 player Count 를 생성한다.  "
			strSql = strSql & " , cte_team As ( "
			strSql = strSql & " 		Select Row_Number() Over(Order By minIdx) As teamNo,  "
			strSql = strSql & " 			* From ( "
			strSql = strSql & " 			Select Min(tIdx) As minIdx,  "
			strSql = strSql & " 				Count(*) As cntTeam, Team  "
			strSql = strSql & " 				From cte_teamUser Group By Team  "
			strSql = strSql & " 		) AA  "
			strSql = strSql & " ) "

			'	cte_teamUser에서 얻은 정보를 이용하여 좀더 명확한 user 정보를 꾸린다 . "
			'	GameRequestTeamIDX를 정렬하여 dataOrder를 셋팅, (Dense_Rank() Over(Order By U.GameRequestTeamIDX )) "
			'	teamNo로 Grouping하여 그안에서 GameRequestTeamIDX를 정렬하여 PlayerOrder를 셋팅 - (Dense_Rank() Over(Partition By T.teamNo Order By U.GameRequestTeamIDX)) "
			'	cte_team을 조인하여 teamNo, cntTeam을 구한다.  "
			strSql = strSql & " , cte_user As ( "
			strSql = strSql & " 		Select 0 As fUse, T.teamNo, 0 As seedNo, 0 As Ranking ,  "
			strSql = strSql & " 			(Dense_Rank() Over(Order By U.GameRequestTeamIDX )) As dataOrder,  "
			strSql = strSql & " 			(Dense_Rank() Over(Partition By T.teamNo Order By U.GameRequestTeamIDX)) As playerOrder,  "
			strSql = strSql & " 			U.GameRequestTeamIDX As GameRequestTeamIDX, U.GameRequestTeamIDX As GameRequestTeamIDX2, U.TeamDtl, U.TeamName As TeamName1, U.Team , U.TeamName ,  "
			strSql = strSql & " 			0 As prevTeam, 0 As prevTeamName, T.cntTeam, 0 As Sex, 0 As sameSex	 "
			strSql = strSql & " 			From cte_teamUser As U  "
			strSql = strSql & " 			Inner Join cte_team As T On U.Team = T.Team  "
			strSql = strSql & " ) "
			
			strSql = strSql & " Select *, Row_Number() Over(Partition By playerOrder Order By GameRequestTeamIDX) As UserIdx "
			strSql = strSql & " 	From cte_user  "
   	End If

      getSqlReqTeam = strSql 
   End Function

%> 

<%
'		/*
'			--------------------- 복식 
'			GameTitleIDX, GameLevelIDX를 가지고 tblGameRequestPlayer에서 참가 신청 명단을 얻는다. 
'			이때 tblMember를 Inner Join하여 신청자의 성별을 얻는다. 
'			이때 Row_number를 이용하여 사용자를 정렬한다. 
'			   - Partition BY P.GameRequestGroupIDX 로 Group을 잡고 그 안에서 Order By P.team 팀별로 정렬한다. 
'		*/
'		WITH cte_teamUser As (		
'				Select Dense_Rank() Over(Order By GameRequestGroupIDX) As UIdx, AA.* From (
'					Select Row_number() Over(Partition BY P.GameRequestGroupIDX Order By P.team ) AS Idx, 
'							P.GameRequestGroupIDX, P.GameRequestPlayerIDX, 
'							P.memberIdx, P.memberName, P.team, P.teamName, M.Sex
'					 From   tblGameRequestPlayer As P WITH (nolock) 
'					 Inner Join tblMember As M On M.memberIdx = P.memberIdx And M.DelYN = 'N' 
'					 Where P.DelYN = 'N'AND P.GameTitleIDX = '1582' AND P.GameLevelIDX = '13082'
'				) As AA		 
'		)
'		
'		/*
'			cte_teamUser에서 얻은 참가 신청 명단은  GameRequestGroupIDX별로 Team 순으로 정렬되어 있다. 
'			여기서 Self Join을 이용하여 고유팀을 추려낸다. Group By U1.Team, U2.Team
'			이때 Row_Number() Over(Order By U1.Team, U2.Team) As teamNo 로 teamNo를 생성한다. 
'		*/
'		
'		
'		, cte_team As ( 
'			Select Row_Number() Over(Order By minIdx) As teamNo, AA.cntTeam, AA.Team1, AA.Team2 
'				From (
'						Select Min(U1.UIdx) As minIdx, Count(U1.UIdx) As cntTeam, 
'						U1.Team As Team1, U2.Team As Team2
'						From cte_teamUser As U1 
'						Inner Join cte_teamUser As U2 On U1.GameRequestGroupIDX = U2.GameRequestGroupIDX And U2.Idx = U1.Idx + 1
'						Group By U1.Team , U2.Team
'				) As AA 
'		)
'		
'		
'		/*
'			cte_teamUser를 Inner Join으로 self Join하여 각 파트너의 Team, Sex를 얻는다. 
'			이때 파트너와 성별이 같은지 확인하여 SameSex = 0 , 1을 셋팅한다. 
'			cte_team을 Inner Join하여 나와 파트너의 team을 확인하여 teamNo를 셋팅한다. 
'		*/
'		, cte_userTmp As (
'			Select U1.* , U2.Team As Team2, T.teamNo, T.cntTeam, 
'			U2.Sex As Sex2, 
'			Case When (U1.Sex = U2.Sex) Then 1 Else 0 End As SameSex
'			From cte_teamUser As U1
'			Inner Join cte_teamUser As U2 On U1.GameRequestGroupIDX = U2.GameRequestGroupIDX And U1.Idx != U2.Idx
'			Inner Join cte_team As T On ( (T.Team1 = U1.Team Or T.Team1 = U2.Team) And (T.Team2 = U1.Team Or T.Team2 = U2.Team) )
'		)
'		
'		/*
'			cte_userTmp에서 얻은 정보를 이용하여 좀더 명확한 user 정보를 꾸린다 .
'			GameRequestGroupIDX를 정렬하여 dataOrder를 셋팅, (Dense_Rank() Over(Order by GameRequestGroupIDX))
'			teamNo로 Grouping하여 그안에서 GameRequestGroupIDX를 정렬하여 PlayerOrder를 셋팅 - (Dense_Rank() Over(Partition By teamNo Order By GameRequestGroupIdx)) 
'		*/
'		, cte_user As (
'			Select  0 As fUse, teamNo, 0 As seedNo, 0 As Ranking, 
'			(Dense_Rank() Over(Order by GameRequestGroupIDX)) As dataOrder, 
'			(Dense_Rank() Over(Partition By teamNo Order By GameRequestGroupIdx)) As PlayerOrder, 
'			GameRequestGroupIDX, GameRequestPlayerIDX, memberIdx, memberName, team, teamName, 
'			0 As prevTeam, 0 As prevTeamName, cntTeam, Sex, sameSex	
'		From cte_userTmp
'		)
'		
'		/*
'			cte_user에서 얻은 정보를 이용하여 좀더 명확한 user 정보를 꾸린다 
'			참가자 명단을 각 팀별 1장, 2장 .. 순으로 뽑기 위하여 
'			PlayerOrder, GameRequestGroupIdx로 Grouping을 한 후 , 
'			성별이 같을때는 GameRequestPlayerIDX로 정렬을 하고 
'			성별이 다를때는 Sex로 정렬을 한다. 
'				Row_Number() Over( Partition By PlayerOrder, GameRequestGroupIdx Order By GameRequestGroupIdx)
'		*/
'		Select *, Row_Number() Over( Partition By U.PlayerOrder, GameRequestGroupIdx 
'										Order By 
'											Case When sameSex = 0 Then Sex End, 
'											Case When sameSex = 1 Then GameRequestPlayerIDX End
'											  
'								   ) As UserIdx
'		From cte_user As U 
'		
'		
'		
'		/*  
'			--------------------- 단식 
'			GameTitleIDX, GameLevelIDX를 가지고 tblGameRequestPlayer에서 참가 신청 명단을 얻는다. 	
'		*/
'		WITH cte_teamUser As (
'				Select Row_Number() Over(Order By GameRequestGroupIDX) As uIdx, 
'		                GameRequestGroupIDX, GameRequestPlayerIDX, 
'		                memberIdx, memberName, team, teamName
'		         From   tblGameRequestPlayer As P WITH (nolock) 
'		         Where DelYN = 'N'AND GameTitleIDX = '1591' AND GameLevelIDX = '9061')
'		
'		/*
'			cte_teamUser로 부터 고유팀을 추려낸다. Group By Team 
'			이때Row_Number() Over(Order By Team) As TeamNo, Count(Team) As cntTeam 로 teamNo, team별 player Count 를 생성한다. 
'		*/
'		, cte_team As (
'			Select Row_Number() Over(Order By minIdx) As teamNo, * From (
'				Select Min(uIdx) As minIdx, Count(Team) As cntTeam, Team  
'				From cte_teamUser Group By Team 
'			) As AA 
'		)
'		
'		
'		
'		/*
'			cte_teamUser에서 얻은 정보를 이용하여 좀더 명확한 user 정보를 꾸린다 .
'			GameRequestGroupIDX를 정렬하여 dataOrder를 셋팅, (Dense_Rank() Over(Order by GameRequestGroupIDX))
'			teamNo로 Grouping하여 그안에서 GameRequestGroupIDX를 정렬하여 PlayerOrder를 셋팅 - (Dense_Rank() Over(Partition By T.teamNo Order By U.GameRequestGroupIDX))
'			cte_team을 조인하여 teamNo, cntTeam을 구한다. 
'		*/
'		, cte_user As (
'			Select 0 As fUse, T.teamNo, 0 As seedNo, 0 As Ranking , 
'			(Dense_Rank() Over(Order By U.GameRequestGroupIDX )) As dataOrder, 
'			(Dense_Rank() Over(Partition By T.teamNo Order By U.GameRequestGroupIDX)) As playerOrder, 
'			GameRequestGroupIDX, GameRequestPlayerIDX, memberIdx, memberName, U.team, U.teamName, 
'			0 As prevTeam, 0 As prevTeamName, T.cntTeam	, 0 As Sex, 0 As sameSex
'		
'			From cte_teamUser As U
'			Inner Join cte_team As T On U.Team = T.Team 
'		)
'		
'		/*
'			cte_user에서 얻은 정보를 이용하여 좀더 명확한 user 정보를 꾸린다 
'			참가자 명단을 각 팀별 1장, 2장 .. 순으로 뽑기 위하여 
'			PlayerOrder로 Grouping을 한 후 , GameRequestGroupIdx로 정렬한다. 
'				Row_Number() Over( Partition By U.PlayerOrder Order By U.GameRequestGroupIdx )
'		*/
'		Select U.*, Row_Number() Over( Partition By U.PlayerOrder Order By U.GameRequestGroupIdx ) As UserIdx
'		From cte_user As U 


'		/*  
'			--------------------- 단체전 (개인전 단식과 비슷) 
'			GameTitleIDX, GameLevelIDX를 가지고 tblGameRequestTeam에서 참가 신청 명단을 얻는다. 
'		*/
'		;With cte_teamUser As (
'			Select Row_Number() Over(Order By GameRequestTeamIDX) As tIdx, 
'				   GameRequestTeamIDX,TeamDtl, TeamName, Team       
'			FROM   tblGameRequestTeam AS A WITH (nolock) 
'			WHERE  delyn = 'N' AND GameTitleIDX = '1591' AND GameLevelIDX = '11329' 
'		) 
'		
'		/*
'			cte_teamUser로 부터 고유팀을 추려낸다. Group By Team 
'			이때Row_Number() Over(Order By Team) As TeamNo, Count(Team) As cntTeam 로 teamNo, team별 player Count 를 생성한다. 
'		*/
'		, cte_team As (
'			Select Row_Number() Over(Order By minIdx) As teamNo, 
'				* From (
'				Select Min(tIdx) As minIdx, 
'					Count(*) As cntTeam, Team 
'					From cte_teamUser Group By Team 
'			) AA 
'		)
'		
'		/*
'			cte_teamUser에서 얻은 정보를 이용하여 좀더 명확한 user 정보를 꾸린다 .
'			GameRequestTeamIDX를 정렬하여 dataOrder를 셋팅, (Dense_Rank() Over(Order By U.GameRequestTeamIDX ))
'			teamNo로 Grouping하여 그안에서 GameRequestTeamIDX를 정렬하여 PlayerOrder를 셋팅 - (Dense_Rank() Over(Partition By T.teamNo Order By U.GameRequestTeamIDX))
'			cte_team을 조인하여 teamNo, cntTeam을 구한다. 
'		*/
'		, cte_user As (
'			Select 0 As fUse, T.teamNo, 0 As seedNo, 0 As Ranking , 
'			(Dense_Rank() Over(Order By U.GameRequestTeamIDX )) As dataOrder, 
'			(Dense_Rank() Over(Partition By T.teamNo Order By U.GameRequestTeamIDX)) As playerOrder, 
'			 U.GameRequestTeamIDX As GameRequestTeamIDX, U.GameRequestTeamIDX As GameRequestTeamIDX2, U.TeamDtl, U.TeamName As TeamName1, U.Team , U.TeamName , 
'			 0 As prevTeam, 0 As prevTeamName, T.cntTeam, 0 As Sex, 0 As sameSex	
'			From cte_teamUser As U 
'			Inner Join cte_team As T On U.Team = T.Team 
'		)
'		
'		Select *, Row_Number() Over(Partition By playerOrder Order By GameRequestTeamIDX) As UserIdx
'			From cte_user 
%>