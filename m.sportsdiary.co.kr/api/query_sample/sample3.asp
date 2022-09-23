
<%
	'=================================================================================
	'  Purpose  : 	App 대회 일정
	'  Author   : 												By Aramdry
	'=================================================================================

%>

    <% 
   '=================================================================================
   '  Purpose  : 	App 대회 일정
   '     대회 날짜 List
   '=================================================================================   
   -- 종별에서 대회 날짜를 뽑는다. 
   Select GameDay 
      From tblRGameLevel 
      Where DelYN = 'N' And SportsGb = 'judo' And GameTitleIDX = 245
      Group By GameDay

   '=================================================================================
   '  Purpose  : 	App 대회 일정
   '     대회 날짜를 입력받아 대회 일정을 뽑는다. 개인전/단체전 구분 
   '=================================================================================   
   -- 종별에서 대회 날짜를 입력받아 대회 일정을 뽑는다. - 개인전 
   ;with cte_info_single As (
      Select 
         L.GroupGameGb, '개인전' As GroupGameGbNm, 
         L.RGameLevelIDX,  L.TeamGb, T.TeamGbNm, L.Level , I.LevelNm
         From tblRGameLevel As L
         Inner Join tblTeamGbInfo As T On T.TeamGb = L.TeamGb    
         Inner Join tblLevelInfo As I On I.Level = L.Level
         Where L.DelYN = 'N' And L.SportsGb = 'judo' And L.GameTitleIDX = 245
         And T.DelYN = 'N' And T.SportsGb = 'judo'
         And I.DelYN = 'N' And I.SportsGb = 'judo'
         And L.GameDay = '2021-07-20'
         And L.GroupGameGb = 'sd040001'			-- 개인전 
   )

   -- 종별에서 대회 날짜를 입력받아 대회 일정을 뽑는다. - 단체전 
   , cte_info_group As (
      Select 
         L.GroupGameGb, '단체전' As GroupGameGbNm, 
         L.RGameLevelIDX,  L.TeamGb, T.TeamGbNm, L.Level , 
         IsNull( (Select LevelNm From tblLevelInfo Where DelYN = 'N' And SportsGb = 'judo' And Level = L.Level), '') As LevelNm
         From tblRGameLevel As L
         Inner Join tblTeamGbInfo As T On T.TeamGb = L.TeamGb    
         Where L.DelYN = 'N' And L.SportsGb = 'judo' And L.GameTitleIDX = 245
         And T.DelYN = 'N' And T.SportsGb = 'judo'		
         And L.GameDay = '2021-07-20'
         And L.GroupGameGb = 'sd040002'			-- 단체전
   )

   , cte_info_merge As (
      Select GroupGameGb, GroupGameGbNm, RGameLevelIDX, TeamGb, TeamGbNm, Level , LevelNm 
         From cte_info_single 
      Union 
      Select GroupGameGb, GroupGameGbNm, RGameLevelIDX, TeamGb, TeamGbNm, Level , LevelNm 
         From cte_info_group 
   )

   -- 개인전/단체전 , TeamGb으로 구분하고 Level로 sort하여 List를 꾸린다. 
   -- Idx == 1인 값이 해당 대회의 종별이다. 
   Select ROW_NUMBER() Over( Partition By GroupGameGb, TeamGb Order By Level) As Idx,  
         GroupGameGb, GroupGameGbNm, RGameLevelIDX, TeamGb, TeamGbNm, Level , LevelNm 
      from cte_info_merge
      Order By GroupGameGb

   
  '=================================================================================
   '  Purpose  : 	App 대진표 - 검색조건
   '     개인전/단체전 구분 
   '=================================================================================         
   Select 	L.GroupGameGb, P.PubName As GroupGameGbName
		From tblRGameLevel As L
		Inner Join tblPubCode As P On P.PubCode = L.GroupGameGb	
		Where L.DelYN = 'N' And L.SportsGb = 'judo' And L.GameTitleIDX = 245
		And P.DelYN = 'N' And P.SportsGb = 'judo'
		Group By L.GroupGameGb, P.PubName

   '=================================================================================
   '  Purpose  : 	App 대진표 - 검색조건
   '     개인전/단체전 구분 -> 종별 구분 
   '=================================================================================         
   Select  L.GroupGameGb, L.TeamGb, T.TeamGbNm
		From tblRGameLevel As L
		Inner Join tblTeamGbInfo As T On T.TeamGb = L.TeamGb    
		Where L.DelYN = 'N' And L.SportsGb = 'judo' And L.GameTitleIDX = 245
		And T.DelYN = 'N' And T.SportsGb = 'judo'
		And L.GroupGameGb = 'sd040001'			-- 개인전 
		Group By L.GroupGameGb, L.TeamGb, T.TeamGbNm

   '=================================================================================
   '  Purpose  : 	App 대진표 - 검색조건
   '     개인전/단체전 구분 -> 종별 구분 -> Level 구분 
   '=================================================================================         
   -- 종별에서 대회 날짜를 입력받아 대회 일정을 뽑는다. - 개인전 
   ;with cte_info_single As (
      Select 
         L.GroupGameGb, '개인전' As GroupGameGbNm, 
         L.RGameLevelIDX,  L.TeamGb, T.TeamGbNm, L.Level , I.LevelNm
         From tblRGameLevel As L
         Inner Join tblTeamGbInfo As T On T.TeamGb = L.TeamGb    
         Inner Join tblLevelInfo As I On I.Level = L.Level
         Where L.DelYN = 'N' And L.SportsGb = 'judo' And L.GameTitleIDX = 245
         And T.DelYN = 'N' And T.SportsGb = 'judo'
         And I.DelYN = 'N' And I.SportsGb = 'judo'		
         And L.GroupGameGb = 'sd040001'			-- 개인전 
   )

   -- 종별에서 대회 날짜를 입력받아 대회 일정을 뽑는다. - 단체전 
   , cte_info_group As (
      Select 
         L.GroupGameGb, '단체전' As GroupGameGbNm, 
         L.RGameLevelIDX,  L.TeamGb, T.TeamGbNm, L.Level , 
         IsNull( (Select LevelNm From tblLevelInfo Where DelYN = 'N' And SportsGb = 'judo' And Level = L.Level), '') As LevelNm
         From tblRGameLevel As L
         Inner Join tblTeamGbInfo As T On T.TeamGb = L.TeamGb    
         Where L.DelYN = 'N' And L.SportsGb = 'judo' And L.GameTitleIDX = 245
         And T.DelYN = 'N' And T.SportsGb = 'judo'				
         And L.GroupGameGb = 'sd040002'			-- 단체전
   )

   , cte_info_merge As (
      Select GroupGameGb, GroupGameGbNm, RGameLevelIDX, TeamGb, TeamGbNm, Level , LevelNm 
         From cte_info_single 
      Union 
      Select GroupGameGb, GroupGameGbNm, RGameLevelIDX, TeamGb, TeamGbNm, Level , LevelNm 
         From cte_info_group 
   )

   -- 개인전/단체전 , TeamGb으로 구분하고 Level로 sort하여 List를 꾸린다.    
   Select ROW_NUMBER() Over( Partition By GroupGameGb, TeamGb Order By Level) As Idx,  
         GroupGameGb, GroupGameGbNm, RGameLevelIDX, TeamGb, TeamGbNm, Level , LevelNm 
      from cte_info_merge
      Order By GroupGameGb

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표 보기 
   '     해당 대진표의 대회 결과 List 
   '=================================================================================  
   -- 해당 종별에 대한 결과 List
   Select * 
      From tblPlayerResult 
      Where DelYN = 'N' And SportsGb = 'judo'	
      And GameTitleIDX = 245
      And RGameLevelidx = 9222
      Order By Cast(GameNum As int) 

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표 보기 
   '     해당 대진표의 대회 결과 상세 List 
   '=================================================================================  
   -- 해당 종별에 대한 대회 결과 상세 List 
   Select * 
	From tblRGameResultDtl 
	Where DelYN = 'N' And SportsGb = 'judo'	
	And GameTitleIDX = 245
	And RGameLevelidx = 9222
	Order By Cast(GameNum As int)

   '=================================================================================
   '  Purpose  : 	App 대진표 - 유도 기술 
   '     유도 기술명 
   '=================================================================================  
   Select * From tblPubCode_Spec Where DelYN = 'N' And SportsGb = 'judo'

   '=================================================================================
   '  Purpose  : 	App 대진표 - 유도 점수 구분 (한판, 절반 ... )   
   '=================================================================================  
   Select * From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And PubCode like 'sd02300%'


   '=================================================================================
   '  Purpose  : 	App 대진표 - -- 대회 종별 결과 순위 
   '=================================================================================  
   -- 대회 종별 결과 순위 
   Select * 
      From tblGameScore 
      Where DelYN = 'N' And SportsGb = 'judo'	
      And GameTitleIDX = 245
      And RGameLevelidx = 9222

   '=================================================================================
   '  Purpose  : 	App 대진표 - -- 대회 종별 단체전 경기 결과 
   '=================================================================================  
   -- 대회 종별 단체전 경기 결과 
   Select * 
      From tblrgamegroupschool 
      Where DelYN = 'N' And SportsGb = 'judo'	
      And GameTitleIDX = 245


   '=================================================================================
   '  Purpose  : 	App 대진표 - 결과 순위 
   '=================================================================================  
   Select P.UserName, T.TeamNm, S.GameRanking
      From tblGameScore As S 
	  Inner Join tblPlayer As P On P.PlayerIDX = S.PlayerIDX
	  Inner Join tblTeamInfo As T On T.DelYN = 'N' And T.Team = S.Team 
      Where S.DelYN = 'N' And S.SportsGb = 'judo'	
	  And P.DelYN = 'N' And P.SportsGb = 'judo'	
      And GameTitleIDX = 245
      And RGameLevelidx = 9214
	  Order By S.GameRanking


   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표 
   '=================================================================================     
   ;with cte_rgame As (
   Select * 
         From tblPlayerResult As R 	  
         Where DelYN = 'N' And SportsGb = 'judo'	
         And GameTitleIDX = 245
         And RGameLevelidx = 9214
   ) 

   , cte_player_info As (
      Select PlayerIDX, UserName  
         From tblPlayer
         Where DelYN = 'N' And SportsGb = 'judo'	
         And PlayerIDX In (Select LPlayerIdx From cte_rgame) Or PlayerIDX In (Select RPlayerIdx From cte_rgame)
   )

   , cte_team_info As (
      Select Team, TeamNm
         From tblTeamInfo
         Where DelYN = 'N' And SportsGb = 'judo'	
         And Team In (Select LTeam From cte_rgame) Or Team In (Select RTeam From cte_rgame)
   )

   select PlayerResultIdx, RGameLevelidx, NowRound, GameNum, 
      LPlayerIDX, (Select UserName From cte_player_info Where PlayerIDX = LPlayerIDX) As LPlayerName, 
      RPlayerIDX, (Select UserName From cte_player_info Where PlayerIDX = RPlayerIDX) As RPlayerName, 
      LTeam , (Select TeamNm From cte_team_info Where Team = LTeam) As LTeamNm, 
      RTeam , (Select TeamNm From cte_team_info Where Team = RTeam) As RTeamNm
      From cte_rgame

