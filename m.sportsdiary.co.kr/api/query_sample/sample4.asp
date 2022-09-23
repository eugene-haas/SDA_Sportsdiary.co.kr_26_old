
<%
	'=================================================================================
	'  Purpose  : 	App 대회 일정
	'  Author   : 												By Aramdry
	'=================================================================================

%>

<% 
   
   '=================================================================================
   '  GameType		
   '     sd043001	리그
   '     sd043002	토너먼트
   '     sd043004	5인(토너먼트+리그)
   '     sd043005	국가대표최종평가전
   '     sd043006	4인(3,4위전)
   '        
   '  UnearnWin		
   '     sd042001	일반전
   '     sd042002	부전승
   '        
   '  LeftRightGb		
   '     sd030001	왼쪽
   '     sd030002	오른쪽

   ' Result
   '    sd019001	승(한판)
   '    sd019002	승(절반)
   '    sd019003	승(유효)
   '    sd019004	승(지도)
   '    sd019005	승(반칙)
   '    sd019006	승(부전)
   '    sd019007	패(한판)
   '    sd019008	패(절반)
   '    sd019009	패(유효)
   '    sd019010	패(지도)
   '    sd019011	패(반칙)
   '    sd019012	패(부전)
   '    sd019015	승(우세1)
   '    sd019016	패(우세1)
   '    sd019021	불참
   '    sd019022	승(기권)
   '    sd019023	패(기권)
   '    sd019024	무승부
   '    sd019013	승(실격)
   '    sd019014	패(실격)
   '    sd019017	승(우세2)
   '    sd019018	패(우세2)
   '    sd019019	승(우세3)
   '    sd019020	패(우세3)
   '    sd019025	승(개체)
   '    sd019026	패(개체)
   '================================================================================= 

%>


<% 
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : 
   '           GameType별 대회 예제 뽑는 쿼리 
   '================================================================================= 

   Select * From tblRGameLevel Where DelYN = 'N' And SportsGb = 'judo' And GameType = 'sd043001' Order By GameTitleIDX Desc

   Select * From tblRGameLevel Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 8223

   Select * From tblGameTitle Where DelYN = 'N' And SportsGb = 'judo' And GameTitleIDX = 183 

   Select * From tblLevelInfo Where DelYN = 'N' And SportsGb = 'judo' And Level = '11002001'

   Select * From tblTeamGbInfo Where DelYN = 'N' And SportsGb = 'judo' And TeamGb = '51001'

   ' ********************************************************************************************
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043001	리그 개인전 (sd040001)
   '           Player List :  UnearnWin, LeftRightGb
   '================================================================================= 
   ;with cte_result As (
      Select * From tblRGameResult Where DelYN = 'N' And SportsGb = 'judo' 
                  And RGameLevelidx = 8223
   )

   -- 경기 결과로 부터 각 선수의 점수, 결과 , 승패값을 구한다. 
   , cte_info As (
      Select RGameLevelidx, GameNum, PlayerIdx, Jumsu, win_code 
         From (
         Select RGameLevelidx, GameNum, LPlayerIdx As PlayerIdx, LJumsu As Jumsu,  		
            Case When LPlayerResult Is Null Or LPlayerResult = '' Then -1 
               When LPlayerResult Not In ('sd019024', 'sd019021') Then 1 
               Else 0 End As win_code
            From cte_result
         Union 
         Select RGameLevelidx, GameNum, RPlayerIdx As PlayerIdx, RJumsu As Jumsu, 
            Case When RPlayerResult Is Null Or RPlayerResult = '' Then -1 
               When RPlayerResult Not In ('sd019024', 'sd019021') Then 1 
               Else 0 End As win_code
            From cte_result
         ) As C 
   )

   -- 승패 코드로 부터 승, 패 카운트를 구한다. 
   , cte_merge As (
      Select PlayerIdx, Cast(Jumsu As int) As score, 
         Case When win_code = 1 Then 1 Else 0 End As win_cnt, 
         Case When win_code = -1 Then 1 Else 0 End As lose_cnt, 
         Case When win_code = 0 Then 1 Else 0 End As draw_cnt 
         From cte_info 	
   )

   -- 각 선수마다 점수, 승, 패 카운트의 누적 합을 구하고, 이를 이용해 순위를 구한다. 
   , cte_game_info As (
      Select ROW_NUMBER() Over(Order By s_win_cnt Desc, s_score Desc) As ranking, PlayerIdx, s_score, s_win_cnt, s_lose_cnt
         From (
            Select PlayerIdx, Sum(score) As s_score, Sum(win_cnt) As s_win_cnt, Sum(lose_cnt) As s_lose_cnt   
               From cte_merge
               Group By PlayerIdx
         ) As C 
   )

   -- 리그에 출전한 선수 정보를 표시한다 
   Select P.RPlayerIDX, P.PlayerIDX, P.UserName, 
      Case When P.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win,
      Case When P.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left, 
      P.WeightFailYN As Absence, P.Team, 
		Case When P.TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ P.TeamDtl End As TeamNm, 
		I.s_score, I.s_win_cnt, I.s_lose_cnt, I.ranking
         From tblRPlayer As P
         Left Join tblTeamInfo As T On T.Team = P.Team 
      Inner Join cte_game_info As I On I.PlayerIdx = P.PlayerIDX
         Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = 8223
         And T.DelYN = 'N' And T.SportsGb = 'judo'
      Order By P.RPlayerIDX

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043001	리그 개인전 (sd040001)
   '           Game List :  
   '================================================================================= 
   -- 경기 결과 Text를 구한다. 
   ;with cte_result As (
      Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
   )

   -- 출전 선수 정보를 구한다. 
   , cte_player As (
      Select P.PlayerIDX, P.UserName, P.Team, 	  
	  Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
      From tblRPlayer As P
      Left Join tblTeamInfo As T On T.Team = P.Team 
      Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = 320
      And T.DelYN = 'N' And T.SportsGb = 'judo'
   )

   -- 경기 정보를 구한다. 
   , cte_info As (
      Select PlayerResultIdx, RGameLevelidx, NowRoundNM, NowRound, GroupGameNum, GameNum, LPlayerIDX, RPlayerIDX, LResult, RResult, 
         Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then 10
					 When LResult = 'sd019024' Then 0
					 Else 1 End 
			 When LResult Is Null And RResult Is Null Then 10
		 Else 2 End As winPart, 

		 Case When Len(LResult) > 1 Then 
			Case When LResult = 'sd019021' Then '불참'
			     When LResult = 'sd019024' Then '무승부'				 
				 Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End 
		    When LResult Is Null And RResult Is Null Then '무승부'
		 Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin, 
		 MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, 
		 Case When RECORD_VIDEO_SEQ > 0 Then 2
			  When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1
			  Else 0 End As VIDEO_FLAG
         From tblPlayerResult
         Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 320			
   ) 

   -- 경기 정보 + 출전 선수 정보를 Display한다 .
   -- DISPLAY_POS: 2: 리그 
   Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.NowRound, I.GroupGameNum, I.GameNum, 2 As DISPLAY_POS, 
      I.LPlayerIDX, IsNull(L.UserName, '') As LUserName, IsNull(L.Team, '')As LTeam, IsNull(L.TeamNm, '')As LTeamNm,
      I.RPlayerIDX, IsNull(R.UserName, '') As RUserName, IsNull(R.Team, '')As RTeam, IsNull(R.TeamNm, '')As RTeamNm,
      I.LResult, I.RResult, I.winPart, 
      Case When I.winPart In (0, 10) Then strWin
           Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin, 
		IsNull(MediaLink, '') As MediaLink,RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG
      From cte_info As I 
      Left Join cte_player As L On L.PlayerIDX = I.LPlayerIDX
      Left Join cte_player As R On R.PlayerIDX = I.RPlayerIDX
      Order By Cast(GameNum As Int) Desc
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043001	리그 단체전 (sd040002)
   '           Player List :  UnearnWin, LeftRightGb
   '================================================================================= 
   ;with cte_result As (
      Select * From tblRgameGroup Where DelYN = 'N' And SportsGb = 'judo' 
                  And RGameLevelidx = 9319
   )

   -- 경기 결과로 부터 각 팀의 점수, 결과 , 승패값을 구한다. 
   , cte_info As (
      Select RGameLevelidx, GameNum, Team, Jumsu, win_code 
         From (
         Select RGameLevelidx, GameNum, LTeam As Team, 
			Case When LResult Not In ('sd019024', 'sd019021', 'sd019012') Then LJumsu Else 0 End As Jumsu,  		
            Case When LResult Is Null Or LResult = '' Then -1 
               When LResult Not In ('sd019024', 'sd019021') Then 1 
               Else 0 End As win_code
            From cte_result
         Union 
         Select RGameLevelidx, GameNum, RTeam As Team, 
			Case When RResult Not In ('sd019024', 'sd019021', 'sd019012') Then RJumsu Else 0 End As Jumsu,  		
            Case When RResult Is Null Or RResult = '' Then -1 
               When RResult Not In ('sd019024', 'sd019021') Then 1 
               Else 0 End As win_code
            From cte_result
         ) As C 
   )

   -- 승패 코드로 부터 승, 패 카운트를 구한다. 
   , cte_merge As (
      Select Team, Cast(Jumsu As float) As score, 
         Case When win_code = 1 Then 1 Else 0 End As win_cnt, 
         Case When win_code = -1 Then 1 Else 0 End As lose_cnt, 
         Case When win_code = 0 Then 1 Else 0 End As draw_cnt 
         From cte_info 	
   )

   -- 각 팀마다 점수, 승, 패 카운트의 누적 합을 구하고, 이를 이용해 순위를 구한다. 
   , cte_game_info As (
      Select ROW_NUMBER() Over(Order By s_win_cnt Desc, s_score Desc) As ranking, Team, s_score, s_win_cnt, s_lose_cnt
         From (
            Select Team, Sum(score) As s_score, Sum(win_cnt) As s_win_cnt, Sum(lose_cnt) As s_lose_cnt   
               From cte_merge
               Group By Team
         ) As C 
   )
   
   -- 리그에 출전한 팀 정보를 표시한다 
   Select G.RGameGroupSchoolIdx, G.SchIDX, G.SchoolName, 
		Case When G.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win, 
		Case When G.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left,
		G.WeightFailYN As Absence, G.Team, 
      Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm, 
      I.s_score, I.s_win_cnt, I.s_lose_cnt, I.ranking
         From tblrgamegroupschool As G
		 Left Join tblTeamInfo As T On T.Team = G.Team 
		 Inner Join cte_game_info As I On I.Team = G.Team 
      Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = 9319
      And T.DelYN = 'N' And T.SportsGb = 'judo'
      Order By G.RGameGroupSchoolIdx
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043001	리그 단체전 (sd040002)
   '           Game List :  
   '================================================================================= 
   -- 경기 결과 Text를 구한다. 
   ;with cte_result As (
      Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
   )

   -- 출전 팀 정보를 구한다. 
   , cte_team As (
      Select G.RGameGroupSchoolIdx, G.Team, G.TeamDtl, 
	  Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
     From tblrgamegroupschool As G
      Left Join tblTeamInfo As T On T.Team = G.Team 
      Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = 9319
      And T.DelYN = 'N' And T.SportsGb = 'judo'
   )

   -- 경기 정보를 구한다. 
   , cte_info As (
      Select PlayerResultIdx, RGameLevelidx, NowRoundNM, NowRound, GroupGameNum, GameNum, LTeam, LTeamDtl, RTeam, RTeamDtl, LResult, RResult, 
         Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then 10
					 When LResult = 'sd019024' Then 0
					 Else 1 End 
			 When LResult Is Null And RResult Is Null Then 10
		 Else 2 End As winPart, 

		 Case When Len(LResult) > 1 Then 
			Case When LResult = 'sd019021' Then '불참'
			     When LResult = 'sd019024' Then '무승부'				 
				 Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End 
		    When LResult Is Null And RResult Is Null Then '무승부'
		 Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin, 
		 MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, 
		 Case When RECORD_VIDEO_SEQ > 0 Then 2
			  When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1
			  Else 0 End As VIDEO_FLAG
         From tblPlayerResult
         Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 9319	
		 And GameNum = 0
   ) 

   -- 경기 정보 + 출전 선수 정보를 Display한다 .
   -- DISPLAY_POS: 2: 리그 
   Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.NowRound, I.GroupGameNum , I.GameNum, 2 As DISPLAY_POS,  
      '' As LPlayerIdx, '' As LPlayerName, I.LTeam, IsNull(L.TeamNm, '') As LTeamNm, 
	  '' As RPlayerIdx, '' As RPlayerName, I.RTeam, IsNull(R.TeamNm, '') As RTeamNm,
      I.LResult, I.RResult, I.winPart, 
      Case When I.winPart In (0, 10) Then strWin
           Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin, 
		IsNull(MediaLink, '') As MediaLink,  RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG
      From cte_info As I 
      Left Join cte_team As L On L.Team = I.LTeam And L.TeamDtl = I.LTeamDtl
      Left Join cte_team As R On R.Team = I.RTeam And R.TeamDtl = I.RTeamDtl
      Order By Cast(GroupGameNum As Int) Desc
   
   ' ********************************************************************************************
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043002	토너먼트 개인전 (sd040001)
   '           Player List :  UnearnWin, LeftRightGb
   '================================================================================= 
   Select P.RPlayerIDX, P.PlayerIDX, P.UserName, 
		Case When P.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win,
		Case When P.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left, 
		P.WeightFailYN As Absence, P.Team, 
		Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
      From tblRPlayer As P
      Left Join tblTeamInfo As T On T.Team = P.Team 
      Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = 9223
      And T.DelYN = 'N' And T.SportsGb = 'judo'
      Order By P.RPlayerIDX

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043002	토너먼트 개인전 (sd040001)
   '           Game List :  
   '================================================================================= 
   -- 경기 결과 Text를 구한다. 
   ;with cte_result As (
      Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
   )

   -- 출전 선수 정보를 구한다. 
   , cte_player As (
      Select P.PlayerIDX, P.UserName, P.Team,
		Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
      From tblRPlayer As P
      Left Join tblTeamInfo As T On T.Team = P.Team 
      Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = 9223
      And T.DelYN = 'N' And T.SportsGb = 'judo'
   )

   -- 경기 정보를 구한다. 
   , cte_info As (
      Select PlayerResultIdx, RGameLevelidx, NowRoundNM, NowRound, GroupGameNum, GameNum, LPlayerIDX, RPlayerIDX, LResult, RResult, 
         Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then 10
					 When LResult = 'sd019024' Then 0
					 Else 1 End 
			 When LResult Is Null And RResult Is Null Then 10
		 Else 2 End As winPart, 

		 Case When Len(LResult) > 1 Then 
			Case When LResult = 'sd019021' Then '불참'
			     When LResult = 'sd019024' Then '무승부'				 
				 Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End 
		    When LResult Is Null And RResult Is Null Then '무승부'
		 Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin, 
		 MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, 
		 Case When RECORD_VIDEO_SEQ > 0 Then 2
			  When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1
			  Else 0 End As VIDEO_FLAG
         From tblPlayerResult
         Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 9223			
   ) 

   -- 경기 정보 + 출전 선수 정보를 Display한다 .
   -- DISPLAY_POS: 1: 토너먼트 
   Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.NowRound, I.GroupGameNum, I.GameNum, 1 As DISPLAY_POS, 
      I.LPlayerIDX, IsNull(L.UserName, '') As LUserName, IsNull(L.Team, '')As LTeam, IsNull(L.TeamNm, '')As LTeamNm,
      I.RPlayerIDX, IsNull(R.UserName, '') As RUserName, IsNull(R.Team, '')As RTeam, IsNull(R.TeamNm, '')As RTeamNm,
      I.LResult, I.RResult, I.winPart, 
      Case When I.winPart In (0, 10) Then strWin
           Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin, 
	  IsNull(MediaLink, '') As MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG
      From cte_info As I 
      Left Join cte_player As L On L.PlayerIDX = I.LPlayerIDX
      Left Join cte_player As R On R.PlayerIDX = I.RPlayerIDX
      Order By Cast(GameNum As Int) Desc


   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043002	토너먼트 단체전 (sd040002)
   '           Player List :  UnearnWin, LeftRightGb
   '=================================================================================    
   Select G.RGameGroupSchoolIdx, G.SchIDX, G.SchoolName, 
		Case When G.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win, 
		Case When G.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left,
		G.WeightFailYN As Absence, G.Team, 
      Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
      From tblrgamegroupschool As G
      Left Join tblTeamInfo As T On T.Team = G.Team 
      Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = 9252
      And T.DelYN = 'N' And T.SportsGb = 'judo'
      Order By G.RGameGroupSchoolIdx

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043002	토너먼트 단체전 (sd040002)
   '           Game List :  
   '================================================================================= 
   -- 단체전 경기 상세
      -- 경기 결과 Text를 구한다. 
      ;with cte_result As (
         Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
      )

      -- 출전 팀 정보를 구한다. 
      , cte_team As (
         Select G.RGameGroupSchoolIdx, G.SchIDX, G.SchoolName, G.UnearnWin, G.LeftRightGb, G.Team, G.TeamDtl, 
		 Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
         From tblrgamegroupschool As G
         Left Join tblTeamInfo As T On T.Team = G.Team 
         Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = 9252
         And T.DelYN = 'N' And T.SportsGb = 'judo'      
      )

      -- 경기 정보를 구한다. 
      , cte_info As (
         Select PlayerResultIdx, RGameLevelidx, [round], 
         Case When NowRoundNM Is Null Then dbo.fn_strRound(9252, [round]) Else NowRoundNM End As NowRoundNM, 
         GroupGameNum, GameNum, LTeam, LTeamDtl, RTeam, RTeamDtl, LResult, RResult, 
			Case When Len(LResult) > 1 Then 
					Case When LResult = 'sd019021' Then 10
						 When LResult = 'sd019024' Then 0
						 Else 1 End 
				 When LResult Is Null And RResult Is Null Then 10
			 Else 2 End As winPart, 

			 Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then '불참'
					 When LResult = 'sd019024' Then '무승부'				 
					 Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End 
				When LResult Is Null And RResult Is Null Then '무승부'
			 Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin, 

			MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, 
			Case When RECORD_VIDEO_SEQ > 0 Then 2
			  When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1
			  Else 0 End As VIDEO_FLAG
            From tblPlayerResult
            Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 9252		
         And GameNum = 0
      ) 

      -- 경기 정보 + 출전 선수 정보를 Display한다 .
	  -- DISPLAY_POS: 1: 토너먼트 
      Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.GroupGameNum, I.GameNum, I.[round], 1 As DISPLAY_POS, 
		   '' As LPlayerIdx, '' As LPlayerName, I.LTeam, IsNull(L.TeamNm, '') As LTeamNm, 
			'' As RPlayerIdx, '' As RPlayerName, I.RTeam, IsNull(R.TeamNm, '') As RTeamNm,
		  I.LResult, I.RResult, I.winPart, 
		  Case When I.winPart In (0, 10) Then strWin
			   Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin, 
		  IsNull(MediaLink, '') As MediaLink,  RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG
         From cte_info As I 
         Left Join cte_team As L On L.Team = I.LTeam And L.TeamDtl = I.LTeamDtl
         Left Join cte_team As R On R.Team = I.RTeam And R.TeamDtl = I.RTeamDtl
         Order By Cast(GroupGameNum As Int) Desc

   ' ********************************************************************************************
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043004	5인(토너먼트+리그) 개인전 (sd040001)
   '           Player List :  UnearnWin, LeftRightGb
   '================================================================================= 
   Select P.RPlayerIDX, P.PlayerIDX, P.UserName, 
      Case When P.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win,
      Case When P.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left, 
      P.WeightFailYN As Absence, P.Team, 
      Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
         From tblRPlayer As P
         Left Join tblTeamInfo As T On T.Team = P.Team 
         Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = 8957
         And T.DelYN = 'N' And T.SportsGb = 'judo'
         Order By P.RPlayerIDX

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043004	5인(토너먼트+리그) 개인전 (sd040001)
   '           Game List :  
   '================================================================================= 
   -- 경기 결과 Text를 구한다. 
   ;with cte_result As (
      Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
   )

   -- 출전 선수 정보를 구한다. 
   , cte_player As (
      Select P.PlayerIDX, P.UserName, P.Team, 
		Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
      From tblRPlayer As P
      Left Join tblTeamInfo As T On T.Team = P.Team 
      Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = 8957
      And T.DelYN = 'N' And T.SportsGb = 'judo'
   )

   -- 경기 정보를 구한다. 
   , cte_info As (
      Select PlayerResultIdx, RGameLevelidx, NowRoundNM, NowRound, GroupGameNum, GameNum, LPlayerIDX, RPlayerIDX, LResult, RResult, 
         Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then 10
					 When LResult = 'sd019024' Then 0
					 Else 1 End 
			 When LResult Is Null And RResult Is Null Then 10
		 Else 2 End As winPart, 

		 Case When Len(LResult) > 1 Then 
			Case When LResult = 'sd019021' Then '불참'
			     When LResult = 'sd019024' Then '무승부'				 
				 Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End 
		    When LResult Is Null And RResult Is Null Then '무승부'
		 Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin, 
		 MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, 
		 Case When RECORD_VIDEO_SEQ > 0 Then 2
			  When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1
			  Else 0 End As VIDEO_FLAG
         From tblPlayerResult
         Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 8957			
   ) 

   -- 경기 정보 + 출전 선수 정보를 Display한다 .
   -- DISPLAY_POS : 11:좌측 토너먼트, 12:우측 리그, 13:결승, 14:3,4위전
   Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.NowRound, I.GroupGameNum, I.GameNum, 
	  Case When GameNum = 1 Then 11 
		   When GameNum In (2, 3, 4) Then 12 
		   When GameNum = 5 Then 13
		   When GameNum = 6 Then 14 End As DISPLAY_POS, 
      I.LPlayerIDX, IsNull(L.UserName, '') As LUserName, IsNull(L.Team, '')As LTeam, IsNull(L.TeamNm, '')As LTeamNm,
      I.RPlayerIDX, IsNull(R.UserName, '') As RUserName, IsNull(R.Team, '')As RTeam, IsNull(R.TeamNm, '')As RTeamNm,
      I.LResult, I.RResult, I.winPart, 
      Case When I.winPart In (0, 10) Then strWin
           Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin, 
	  IsNull(MediaLink, '') As MediaLink,RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG	  
      From cte_info As I 
      Left Join cte_player As L On L.PlayerIDX = I.LPlayerIDX
      Left Join cte_player As R On R.PlayerIDX = I.RPlayerIDX
      Order By Cast(GameNum As Int) Desc

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043004	5인(토너먼트+리그) 단체전 (sd040002)
   '           Player List :  UnearnWin, LeftRightGb
   '=================================================================================    
   Select G.RGameGroupSchoolIdx, G.SchIDX, G.SchoolName,
      Case When G.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win, 
      Case When G.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left,
      G.WeightFailYN As Absence, G.Team, 
      Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
         From tblrgamegroupschool As G
         Left Join tblTeamInfo As T On T.Team = G.Team 
         Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = 6570
         And T.DelYN = 'N' And T.SportsGb = 'judo'
         Order By G.RGameGroupSchoolIdx

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043004	5인(토너먼트+리그) 단체전 (sd040002)
   '           Game List :  
   '================================================================================= 
   

   -- 단체전 경기 상세
      -- 경기 결과 Text를 구한다. 
      ;with cte_result As (
         Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
      )

      -- 출전 팀 정보를 구한다. 
      , cte_team As (
         Select G.RGameGroupSchoolIdx, G.SchIDX, G.SchoolName, G.UnearnWin, G.LeftRightGb, G.Team, G.TeamDtl, 
		 Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
         From tblrgamegroupschool As G
         Left Join tblTeamInfo As T On T.Team = G.Team 
         Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = 6570
         And T.DelYN = 'N' And T.SportsGb = 'judo'      
      )

      -- 경기 정보를 구한다. 
      , cte_info As (
         Select PlayerResultIdx, RGameLevelidx, [round] As NowRound, 
         Case When NowRoundNM Is Null Then dbo.fn_strRound(6570, [round]) Else NowRoundNM End As NowRoundNM, 
         GroupGameNum, GameNum, LTeam, LTeamDtl, RTeam, RTeamDtl, LResult, RResult, 
            Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then 10
					 When LResult = 'sd019024' Then 0
					 Else 1 End 
			 When LResult Is Null And RResult Is Null Then 10
		 Else 2 End As winPart, 

		 Case When Len(LResult) > 1 Then 
			Case When LResult = 'sd019021' Then '불참'
			     When LResult = 'sd019024' Then '무승부'				 
				 Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End 
		    When LResult Is Null And RResult Is Null Then '무승부'
		 Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin, 
			MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, 
			Case When RECORD_VIDEO_SEQ > 0 Then 2
			  When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1
			  Else 0 End As VIDEO_FLAG
            From tblPlayerResult
            Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 6570		
         And GameNum = 0
      ) 


      -- 경기 정보 + 출전 선수 정보를 Display한다 .
	  -- DISPLAY_POS : 11:좌측 토너먼트, 12:우측 리그, 13:결승, 14:3,4위전
      Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.NowRound, I.GroupGameNum, I.GameNum,
		 Case When GroupGameNum = 1 Then 11 
		   When GroupGameNum In (2, 3, 4) Then 12 
		   When GroupGameNum = 5 Then 13
		   When GroupGameNum = 6 Then 14 End As DISPLAY_POS, 
         '' As LPlayerIdx, '' As LPlayerName, I.LTeam, IsNull(L.TeamNm, '') As LTeamNm, 
		'' As RPlayerIdx, '' As RPlayerName, I.RTeam, IsNull(R.TeamNm, '') As RTeamNm,
         I.LResult, I.RResult, I.winPart, 
		 Case When I.winPart In (0, 10) Then strWin
           Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin,          
		IsNull(MediaLink, '') As MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG
         From cte_info As I 
         Left Join cte_team As L On L.Team = I.LTeam And L.TeamDtl = I.LTeamDtl
         Left Join cte_team As R On R.Team = I.RTeam And R.TeamDtl = I.RTeamDtl
         Order By Cast(GroupGameNum As Int) Desc

   ' ********************************************************************************************
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043005	국가대표최종평가전 개인전 (sd040001)
   '           Player List :  UnearnWin, LeftRightGb
   '================================================================================= 
   Select P.RPlayerIDX, P.PlayerIDX, P.UserName,
		Case When P.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win,
		Case When P.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left, 
		P.WeightFailYN As Absence, P.Team, 
		Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
      From tblRPlayer As P
      Left Join tblTeamInfo As T On T.Team = P.Team 
      Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = 1369
      And T.DelYN = 'N' And T.SportsGb = 'judo'
      Order By P.RPlayerIDX

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043005	국가대표최종평가전 개인전 (sd040001)
   '           Game List :  
   '================================================================================= 
   -- 경기 결과 Text를 구한다. 
   ;with cte_result As (
      Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
   )

   -- 출전 선수 정보를 구한다. 
   , cte_player As (
      Select P.PlayerIDX, P.UserName, P.Team,  
		Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
      From tblRPlayer As P
      Left Join tblTeamInfo As T On T.Team = P.Team 
      Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = 1369
      And T.DelYN = 'N' And T.SportsGb = 'judo'
   )

   -- 경기 정보를 구한다. 
   , cte_info As (
      Select PlayerResultIdx, RGameLevelidx, NowRoundNM, NowRound, GroupGameNum, GameNum, LPlayerIDX, RPlayerIDX, LResult, RResult, 
         Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then 10
					 When LResult = 'sd019024' Then 0
					 Else 1 End 
			 When LResult Is Null And RResult Is Null Then 10
		 Else 2 End As winPart, 

		 Case When Len(LResult) > 1 Then 
			Case When LResult = 'sd019021' Then '불참'
			     When LResult = 'sd019024' Then '무승부'				 
				 Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End 
		    When LResult Is Null And RResult Is Null Then '무승부'
		 Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin, 
		 MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, 
		 Case When RECORD_VIDEO_SEQ > 0 Then 2
			  When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1
			  Else 0 End As VIDEO_FLAG
         From tblPlayerResult
         Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 1369			
   ) 

   -- 경기 정보 + 출전 선수 정보를 Display한다 .
   -- 국가대표 선발전 -  DISPLAY_POS: 21: 대진 , 22: 패자 부활전 , 23: 패자 부활전 결승 , 24: 1,2위 결승, 25 : 1,2위 결승 재경기
   Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.NowRound, I.GroupGameNum, I.GameNum, 
	  Case When I.GameNum In ('1', '2', '3', '4', '5', '6', '7') Then 21
	       When I.GameNum In ('8', '9', '10', '11', '12') Then 22
		   When I.GameNum In ('13') Then 23
		   When I.GameNum In ('14') Then 24
		   When I.GameNum In ('15') Then 25
	  End As DISPLAY_POS, 
      I.LPlayerIDX, IsNull(L.UserName, '') As LUserName, IsNull(L.Team, '')As LTeam, IsNull(L.TeamNm, '')As LTeamNm,
      I.RPlayerIDX, IsNull(R.UserName, '') As RUserName, IsNull(R.Team, '')As RTeam, IsNull(R.TeamNm, '')As RTeamNm,
      I.LResult, I.RResult, I.winPart, 
      Case When I.winPart In (0, 10) Then strWin
           Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin, 
	  IsNull(MediaLink, '') As MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG
      From cte_info As I 
      Left Join cte_player As L On L.PlayerIDX = I.LPlayerIDX
      Left Join cte_player As R On R.PlayerIDX = I.RPlayerIDX
      Order By Cast(GameNum As Int) Desc

   ' ********************************************************************************************
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043006	4인(3,4위전) 개인전 (sd040001)
   '           Player List :  UnearnWin, LeftRightGb
   '================================================================================= 
   Select P.RPlayerIDX, P.PlayerIDX, P.UserName, 
		Case When P.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win,
		Case When P.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left, 
		P.WeightFailYN As Absence, P.Team, 
		Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
      From tblRPlayer As P
      Left Join tblTeamInfo As T On T.Team = P.Team 
      Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = 8146
      And T.DelYN = 'N' And T.SportsGb = 'judo'
      Order By P.RPlayerIDX

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043006	4인(3,4위전) 개인전 (sd040001)
   '           Game List :  
   '================================================================================= 
   
   -- 경기 결과 Text를 구한다. 
   ;with cte_result As (
      Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
   )

   -- 출전 선수 정보를 구한다. 
   , cte_player As (
      Select P.PlayerIDX, P.UserName, P.Team,  
		Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
      From tblRPlayer As P
      Left Join tblTeamInfo As T On T.Team = P.Team 
      Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = 8146
      And T.DelYN = 'N' And T.SportsGb = 'judo'
   )

   -- 경기 정보를 구한다. 
   , cte_info As (
      Select PlayerResultIdx, RGameLevelidx, NowRoundNM, NowRound, GroupGameNum, GameNum, LPlayerIDX, RPlayerIDX, LResult, RResult, 
         Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then 10
					 When LResult = 'sd019024' Then 0
					 Else 1 End 
			 When LResult Is Null And RResult Is Null Then 10
		 Else 2 End As winPart, 

		 Case When Len(LResult) > 1 Then 
			Case When LResult = 'sd019021' Then '불참'
			     When LResult = 'sd019024' Then '무승부'				 
				 Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End 
		    When LResult Is Null And RResult Is Null Then '무승부'
		 Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin, 

		 IsNull(MediaLink, '') As MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, 
		 Case When RECORD_VIDEO_SEQ > 0 Then 2
			  When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1
			  Else 0 End As VIDEO_FLAG
         From tblPlayerResult
         Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 8146			
   ) 

   -- 경기 정보 + 출전 선수 정보를 Display한다 .
   -- 4인(3,4위전) DISPLAY_POS: 31: 토너먼트 4강  , 32: 패자 부활전 결승 
   Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.NowRound, I.GroupGameNum, I.GameNum, 
	  Case When I.GameNum In ('1', '2', '3') Then 31 
		   When I.GameNum In ('4') Then 32
	  End As DISPLAY_POS, 
      I.LPlayerIDX, IsNull(L.UserName, '') As LUserName, IsNull(L.Team, '')As LTeam, IsNull(L.TeamNm, '')As LTeamNm,
      I.RPlayerIDX, IsNull(R.UserName, '') As RUserName, IsNull(R.Team, '')As RTeam, IsNull(R.TeamNm, '')As RTeamNm,
      I.LResult, I.RResult, I.winPart, 
	  Case When I.winPart In (0, 10) Then strWin
           Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin, 
           IsNull(MediaLink, '') As MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG
      From cte_info As I 
      Left Join cte_player As L On L.PlayerIDX = I.LPlayerIDX
      Left Join cte_player As R On R.PlayerIDX = I.RPlayerIDX
      Order By Cast(GameNum As Int) Desc

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043006	4인(3,4위전) 단체전 (sd040002)
   '           Player List :  UnearnWin, LeftRightGb
   '=================================================================================    
   Select G.RGameGroupSchoolIdx, G.SchIDX, G.SchoolName, 
		Case When G.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win, 
		Case When G.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left,
		G.WeightFailYN As Absence, G.Team, 
      Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
      From tblrgamegroupschool As G
      Left Join tblTeamInfo As T On T.Team = G.Team 
      Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = 7734
      And T.DelYN = 'N' And T.SportsGb = 'judo'
      Order By G.RGameGroupSchoolIdx

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043006	4인(3,4위전) 단체전 (sd040002)
   '           Game List :  
   '================================================================================= 
   -- 단체전 경기 상세
      -- 경기 결과 Text를 구한다. 
      ;with cte_result As (
         Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
      )

      -- 출전 팀 정보를 구한다. 
      , cte_team As (
         Select G.RGameGroupSchoolIdx, G.SchIDX, G.SchoolName, G.UnearnWin, G.LeftRightGb, G.Team, G.TeamDtl, 
		 Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
         From tblrgamegroupschool As G
         Left Join tblTeamInfo As T On T.Team = G.Team 
         Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = 7734
         And T.DelYN = 'N' And T.SportsGb = 'judo'      
      )

      -- 경기 정보를 구한다. 
      , cte_info As (
         Select PlayerResultIdx, RGameLevelidx, [round] As NowRound, 
			 Case When NowRoundNM Is Null Then dbo.fn_strRound(7734, [round]) Else NowRoundNM End As NowRoundNM, 
			 GroupGameNum, GameNum, LTeam, LTeamDtl, RTeam, RTeamDtl, LResult, RResult, 
			Case When Len(LResult) > 1 Then 
					Case When LResult = 'sd019021' Then 10
						 When LResult = 'sd019024' Then 0
						 Else 1 End 
				 When LResult Is Null And RResult Is Null Then 10
			 Else 2 End As winPart, 

			 Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then '불참'
					 When LResult = 'sd019024' Then '무승부'				 
					 Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End 
				When LResult Is Null And RResult Is Null Then '무승부'
			 Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin, 

			MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, 
			Case When RECORD_VIDEO_SEQ > 0 Then 2
			  When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1
			  Else 0 End As VIDEO_FLAG
            From tblPlayerResult
            Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 7734		
         And GameNum = 0
      ) 


      -- 경기 정보 + 출전 선수 정보를 Display한다 .
	  -- DISPLAY_POS: 1: 토너먼트 
      Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.NowRound, I.GroupGameNum, I.GameNum, 
		  Case When I.GroupGameNum In ('1', '2', '3') Then 31 
			   When I.GroupGameNum In ('4') Then 32
		  End As DISPLAY_POS, 
		  '' As LPlayerIdx, '' As LPlayerName, I.LTeam, IsNull(L.TeamNm, '') As LTeamNm, 
		'' As RPlayerIdx, '' As RPlayerName, I.RTeam, IsNull(R.TeamNm, '') As RTeamNm,
		  I.LResult, I.RResult, I.winPart, 
		  Case When I.winPart In (0, 10) Then strWin
			   Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin, 
		  IsNull(MediaLink, '') As MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG
         From cte_info As I 
         Left Join cte_team As L On L.Team = I.LTeam And L.TeamDtl = I.LTeamDtl
         Left Join cte_team As R On R.Team = I.RTeam And R.TeamDtl = I.RTeamDtl
         Order By Cast(GroupGameNum As Int) Desc


   ' ********************************************************************************************
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : 단체전 (sd040001) - 경기선택
   '            단체전 팀 정보및 승패 , 세부 경기 승패 Count 
   '================================================================================= 
   -- 단체전 경기 상세
      -- 경기 결과 Text를 구한다. 
      ;with cte_result As (
         Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
      )

      -- 출전 팀 정보를 구한다. 
      , cte_team As (
         Select G.Team, G.TeamDtl, 
		 Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm
         From tblrgamegroupschool As G
         Left Join tblTeamInfo As T On T.Team = G.Team 
         Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = 7734
         And T.DelYN = 'N' And T.SportsGb = 'judo'    
      )

      -- 경기 정보를 구한다. 
      , cte_info As (
         Select 
         GroupGameNum, GameNum, LTeam, LTeamDtl, RTeam, RTeamDtl, LResult, RResult, 

			Case When Len(LResult) > 1 Then 
					Case When LResult = 'sd019021' Then 10
						 When LResult = 'sd019024' Then 0
						 Else 1 End 
				When LResult Is Null And RResult Is Null Then 10
				Else 2 End As winPart, 

			MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, 
			Case When RECORD_VIDEO_SEQ > 0 Then 2
			  When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1
			  Else 0 End As VIDEO_FLAG
            From tblPlayerResult
            Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 7734		
         And GameNum = 0 And GroupGameNum = 3
      ) 

	   -- 세부 경기 정보를 구한다. 
   , cte_detail As (
      Select GroupGameNum, GameNum, LPlayerIDX, RPlayerIDX, LResult, RResult, 
         Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then 10
					 When LResult = 'sd019024' Then 0
					 Else 1 End 
			 When LResult Is Null And RResult Is Null Then 10
		 Else 2 End As winPart
         From tblPlayerResult
         Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 7734			
		 And GroupGameNum = '3' And GameNum Not In ('0')
   ) 

   -- 세부 경기 승패 숫자를 구한다. 
   , cte_detail_cnt As (
		Select GroupGameNum, 
			Count(winPart) As cnt_total, 
			Count(Case When winPart = 1 Then 1 End) As cnt_left, 
			Count(Case When winPart = 2 Then 1 End) As cnt_right, 
			Count(Case When winPart In (0, 10) Then 1 End) As cnt_draw			
			From cte_detail
			Group By GroupGameNum
   )

      -- 경기 정보 + 출전 선수 정보를 Display한다 .
      Select 
		  IsNull(L.TeamNm, '') As LTeamNm, IsNull(R.TeamNm, '') As RTeamNm,
		  I.LResult, I.RResult, I.winPart, C.cnt_total, C.cnt_left, C.cnt_right, C.cnt_draw, 
		  MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG
         From cte_info As I 
         Left Join cte_team As L On L.Team = I.LTeam And L.TeamDtl = I.LTeamDtl
         Left Join cte_team As R On R.Team = I.RTeam And R.TeamDtl = I.RTeamDtl     
		 Inner Join cte_detail_cnt As C On I.GroupGameNum = C.GroupGameNum

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : 단체전 (sd040001) - 경기선택
   '            단체전 - 세부 경기 결과 
   '=================================================================================
-- 경기 결과 Text를 구한다. 
   ;with cte_result As (
      Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%'
   )

   -- 출전 선수 정보를 구한다. 
   , cte_player As (	
      Select PlayerIDX, UserName, Team, TeamDtl
      From tblRPlayer
      Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 7734
	  Group By PlayerIDX, UserName, Team, TeamDtl
   )

    , cte_player_info As (	
      Select P.PlayerIDX, P.UserName, 
		Case When P.TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ P.TeamDtl End As TeamNm
      From cte_player As P
      Inner Join tblTeamInfo As T On T.Team = P.Team 
      Where T.DelYN = 'N' And T.SportsGb = 'judo'
	  
   )

   -- 경기 정보를 구한다. 
   , cte_info As (
      Select GameNum, LPlayerIDX, RPlayerIDX, LResult, RResult, 
         Case When Len(LResult) > 1 Then 
				Case When LResult = 'sd019021' Then 10
					 When LResult = 'sd019024' Then 0
					 Else 1 End 
			 When LResult Is Null And RResult Is Null Then 10
		 Else 2 End As winPart, 

		 Case When Len(LResult) > 1 Then 
			Case When LResult = 'sd019021' Then '불참'
			     When LResult = 'sd019024' Then '무승부'				 
				 Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End 
		    When LResult Is Null And RResult Is Null Then '무승부'
		 Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin
         From tblPlayerResult
         Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 7734			
		 And GroupGameNum = '3' And GameNum Not In ('0')
   ) 

   -- 경기 정보 + 출전 선수 정보를 Display한다 .   
   Select 
      IsNull(L.UserName, '') As LUserName, IsNull(L.TeamNm, '') As LTeamNm,
      IsNull(R.UserName, '') As RUserName, IsNull(R.TeamNm, '') As RTeamNm, 
      I.LResult, I.RResult, I.winPart, 
	  Case When I.winPart In (0, 10) Then strWin
           Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin
      From cte_info As I 
      Left Join cte_player_info As L On L.PlayerIDX = I.LPlayerIDX
      Left Join cte_player_info As R On R.PlayerIDX = I.RPlayerIDX
      Order By Cast(GameNum As Int) 

   ' ********************************************************************************************
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : 개인전 (sd040001) - 경기선택   '            
   '=================================================================================      
   Select * From tblRGameResultDtl 
      Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 7825 And GameNum = 1
      
   Select * From tblRGameResult 
      Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = 7825 And GameNum = 1

   Select * From tblPubCode
      Where DelYN = 'N' And SportsGb = 'judo' And PubCode like 'sd0230%'

   Select * From tblPubCode_spec
      Where DelYN = 'N' And SportsGb = 'judo' And PubCode like 'sp0030%'
 
%>
