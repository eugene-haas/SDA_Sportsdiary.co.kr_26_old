
<%
	'=================================================================================
	'  Purpose  : 	App 참가신청 현황
	'  Author   : 												By Aramdry
	'=================================================================================

%>

    <% 
   '=================================================================================
   '  Purpose  : 참가신청 현황
   '     시도 정보 구분 
   '=================================================================================   
   Select * From tblSidoInfo Where DelYN = 'N' And SportsGb = 'judo'

   '=================================================================================
   '  Purpose  : 참가신청 현황
   '    팀 정보 구분 
   '=================================================================================   
   Select * From tblTeamInfo Where DelYN = 'N' 

   '=================================================================================
   '  Purpose  : 참가신청 현황
   '    팀구분 정보 구분 
   '=================================================================================   
   Select * From tblTeamGbInfo Where DelYN = 'N' 

   '=================================================================================
   '  Purpose  : 참가신청 현황
   '    레벨(체급) 구분 정보 구분 
   '=================================================================================   
   Select * From tblLevelInfo Where DelYN = 'N' 

   '=================================================================================
   '  Purpose  : 참가신청 현황
   '    종별 게임 구분 
   '=================================================================================   
   Select * From tblRGameLevel Where DelYN = 'N' And GameTitleIDX = 245

   '=================================================================================
   '  Purpose  : 참가신청 현황
   '    참가신청자 구분 
   '=================================================================================   
   Select * From tblRPlayerMaster Where DelYN = 'N' And GameTitleIDX = 245

   '=================================================================================
   '  Purpose  : 참가신청 현황 - 팀별 구분 
   '    참가신청자 명단에서 팀, 출전 선수 숫자를 시도 별로 구분하여 구한다.  
   '=================================================================================   
   -- 참가 신청 명단에서 Team을 추출하고 , 해당 팀에 속한 선수 숫자를 구한다. 
   ;with cte_req_team As (
   Select Team, TeamDtl, count(Team) as cnt_player From tblRPlayerMaster 	
      Where DelYN = 'N' And GameTitleIDX = 245
      Group By Team, TeamDtl 
   )

   -- 추출한 Team에 팀 이름, 시도 정보를 추가한다. 
   , cte_info As (
      Select  R.Team, T.TeamNm, R.TeamDtl, cnt_player, T.sido, S.SidoNm 
      From cte_req_team As R 
      Inner Join tblTeamInfo As T On T.DelYN = 'N' And T.Team = R.Team 	
      Inner Join tblSidoInfo As S On S.DelYN = 'N' And S.SportsGb = 'judo' And S.Sido = T.sido
   )

   -- 시도 별로 단체를 재 정렬 한다. 
   Select ROW_NUMBER() Over(Partition By sido Order By TeamNm) As Idx, 
      Team, TeamNm, TeamDtl, sido, SidoNm  , cnt_player
      From cte_info

   
   '=================================================================================
   '  Purpose  : 참가신청 현황 - 팀별 구분 
   '    특정 팀에 속한 선수 List를 구한다. 
   '=================================================================================  
   -- 참가 신청 명단에서 Team을 추출하고 , 해당 팀에 속한 선수 숫자를 구한다. 
   Select T.TeamNm, Count(RPlayerMasterIdx) As cnt_player 
      From tblRPlayerMaster As R
      Inner Join tblTeamInfo As T On T.DelYN = 'N' And T.Team = R.Team 
      Where R.DelYN = 'N' And R.GameTitleIDX = 245
      And R.Team = 'ju02832' 
      Group By TeamNm 

   -- 참가 신청 명단에서 Team을 추출하고 , 해당 팀에 속한 선수 숫자를 구한다. 
   Select PlayerIdx, UserName 
      From tblRPlayerMaster
      Where DelYN = 'N' And GameTitleIDX = 245
      And Team = 'ju02832' 


   '=================================================================================
   '  Purpose  : 참가신청 현황 - 종별 구분 
   '    참가신청자 명단에서 출전 선수 숫자를 종별로 구분하여 구한다.  
   '================================================================================= 
   -- 종별 대회 List, 참가 인원 
   -- 단체전일 경우 참가한 단체수로 참가 인원을 대체함. 

   -- 참가신청 리스트에서 대회 종별 참가 선수 count를 구한다. 
   ;with cte_req_game As (
      Select RGameLevelIDX,  Count(RGameLevelIDX) As cnt_player
         From tblRPlayerMaster Where DelYN = 'N' And GameTitleIDX = 245
         Group By RGameLevelIDX
   )

   -- 단체전일 경우 참가 신청 팀에서 참가 신청팀 count를 구한다. 
   , cte_req_group As (
      Select RGameLevelIDX, Count(RGameGroupSchoolMasterIdx) As cnt_player
      From tblRGameGroupSchoolMaster 
      Where DelYN = 'N' And SportsGb = 'judo' And GameTitleIDX = 245
      Group By RGameLevelIDX
   )

   -- 단체전일 경우 참가한 단체수로 참가 인원을 대체함. 
   , cte_req_merge As (
      Select S.RGameLevelIDX, 
         Case When (G.cnt_player Is Not Null) Then G.cnt_player Else S.cnt_player End As cnt_player
         From cte_req_game As S 
         Left Join cte_req_group As G On S.RGameLevelIDX = G.RGameLevelIDX
   )

   -- 대회 종별 참가 선수및 code값을 문자값으로 변환한다. 
   , cte_info As (
   Select L.RGameLevelIDX,  L.TeamGb, T.TeamGbNm, L.Level , L.GroupGameGb, P.PubName As GroupGameGbName, IsNull(R.cnt_player, 0) As cnt_player, 
      IsNull( (Select LevelNm From tblLevelInfo Where DelYN = 'N' And SportsGb = 'judo' And Level = L.Level), '') As LevelNm
      From tblRGameLevel As L 
      Left Join cte_req_merge As R On R.RGameLevelIDX = L.RGameLevelidx
      Inner Join tblTeamGbInfo As T On T.TeamGb = L.TeamGb
      Inner Join tblPubCode As P On P.PubCode = L.GroupGameGb	
      Where L.DelYN = 'N' And L.GameTitleIDX = 245
      And T.DelYN = 'N' And T.SportsGb = 'judo'
      And P.DelYN = 'N' And P.SportsGb = 'judo'
   )

   -- 종별 이름을 merge한다. 
   Select RGameLevelIDX,  LevelNm, 
      Case When Len(LevelNm) > 1 Then (GroupGameGbName + ' : ' + TeamGbNm + '(' + LevelNm + ')') 
         Else (GroupGameGbName + ' : ' + TeamGbNm) End As RGameName, 
         cnt_player, TeamGb, TeamGbNm, Level , LevelNm, GroupGameGb, GroupGameGbName
      From cte_info 
      Order By RGameLevelIDX


   '=================================================================================
   '  Purpose  : 참가신청 현황 - 종별 구분 
   '    종별 대회 참가자 List - Team별로 sort
   '================================================================================= 
   -- 종별 대회 참가자 List - Team별로 sort
   Select ROW_NUMBER() Over(Partition By P.Team Order By P.UserName) As Idx, 
         P.PlayerIDX, P.UserName, P.Team , T.TeamNm
         From tblRPlayerMaster As P 
         Inner Join tblTeamInfo As T On T.DelYN = 'N' And T.Team = P.Team 		
         Where P.DelYN = 'N' And P.GameTitleIDX = 245
         And P.RGameLevelIDX = 9320

   
         

%>