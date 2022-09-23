
<%
	'=================================================================================
	'  Purpose  : 	App Main 화면 쿼리
	'  Author   : 												By Aramdry
	'=================================================================================

%>

    <% 
   '=================================================================================
   '  Purpose  : main page 대회 출력 
   ' 진행중 대회 + 종료 대회 1개 + 진행 예정 대회 
   '   종료 : 오늘 날짜를 기준으로 대회 종료날짜가 지났다. 
   '   진행중 : 오늘 날짜를 기준으로 대회 시작날짜는 지났고, 대회 종료 날짜는 남아 있다. 
   '   예정(D-19) : 오늘 날짜를 기준으로 대회 시작날짜가 남아 있다. 
   '   취소 : 대회명에 '취소'라는 문구가 들어가 있다. 
   '=================================================================================   
   -- main page 대회 출력 
   -- 진행중 대회 + 종료 대회 1개 + 진행 예정 대회 
   Declare @cur_date date
   Set @cur_date = GetDate(); 

   -- 대회리스트 - 최신순으로 30개를 뽑는다. 
   ;with cte_game As (
      Select Top 30 GameTitleIDX ,GameTitleName ,GameS ,GameE
         From tblGameTitle
         Where DelYN = 'N' And SportsGb = 'judo'
         AND ViewYN = 'Y'			--대회노출
         AND ViewState = '1'			--대회정보 달력에 노출	
         Order By GameE Desc
   )

   -- 최신 30개 대회에 GameS, GameE기준으로 오늘 날짜와의 차이를 구해서 저장한다. 
   , cte_game_check As (
      Select GameTitleIDX ,GameTitleName ,GameS ,GameE, 
         DateDiff(d, @cur_date, GameS) As d_day_s, DateDiff(d, @cur_date, GameE) As d_day_e 
      From cte_game
   )

   -- d_day_e < 0보다 작으면 대회가 종료 된 것이다. (종료된 대회를 최신순으로 해서 1개를 구한다. )
   , cte_game_end As (
      Select top 1 GameTitleIDX ,GameTitleName ,GameS ,GameE, d_day_s, d_day_e
      From cte_game_check
      Where d_day_e < 0
      Order By d_day_e Desc
   )

   -- d_day_e > 0보다 크면 대회가 진행 중이거나 예정이다. 
   , cte_game_cur As (
      Select top 4 GameTitleIDX ,GameTitleName ,GameS ,GameE, d_day_s, d_day_e
      From cte_game_check
      Where d_day_e > 0
      Order By d_day_s 
   )

   , cte_merge As (
      Select GameTitleIDX ,GameTitleName ,GameS ,GameE, d_day_s, d_day_e From cte_game_end
      Union 
      Select GameTitleIDX ,GameTitleName ,GameS ,GameE, d_day_s, d_day_e From cte_game_cur
   )

   -- 종료 : 오늘 날짜를 기준으로 대회 종료날짜가 지났다. 
   -- 진행중 : 오늘 날짜를 기준으로 대회 시작날짜는 지났고, 대회 종료 날짜는 남아 있다. 
   -- 예정(D-19) : 오늘 날짜를 기준으로 대회 시작날짜가 남아 있다. 
   -- 취소 : 대회명에 '취소'라는 문구가 들어가 있다. 
   Select GameTitleIDX ,GameTitleName ,GameS ,GameE, d_day_s, d_day_e , 
      Case When d_day_e < 0 Then '종료' 
         When d_day_s <= 0 And d_day_e >= 0 Then '진행중'
         When CHARINDEX('취소', GameTitleName) = 0 Then '취소'
         When CHARINDEX('무기한 연기', GameTitleName) = 0 Then '미정'
         Else 'D-' + Cast(d_day_s As varChar(10)) End As GameState
      From cte_merge 
      Order By GameS Desc

   '=================================================================================
   '  Purpose  : main page 대회 입상결과
   '     종료된 대회중 취소한 대회를 제외한 최신 3경기를 구한다. 
   '=================================================================================   
   -- main page 대회 출력 
   -- 종료된 대회중 취소한 대회를 제외한 최신 3경기를 구한다. 
   Declare @cur_date date
   Set @cur_date = GetDate(); 

   -- 대회리스트 - 종료 대회를 최신순으로 10개를 뽑는다. 
   ;with cte_game As (
      Select Top 10 GameTitleIDX ,GameTitleName ,GameS ,GameE
         From tblGameTitle
         Where DelYN = 'N' And SportsGb = 'judo'
         AND ViewYN = 'Y'			--대회노출
         AND ViewState = '1'			--대회정보 달력에 노출	
         And GameE < @cur_date		
         Order By GameE Desc
   )

   -- 최신 10개의 대회중 취소를 제외한 3개를 최신순으로 정렬한다. 
   Select Top 3 GameTitleIDX ,GameTitleName ,GameS ,GameE
      From cte_game
      Where CHARINDEX('취소', GameTitleName) = 0
      Order By GameE Desc

   '=================================================================================
   '  Purpose  : main page 공지사항
   '     공지사항 - 최신 공지 5개를 구한다 .
   '================================================================================= 
   -- 공지사항 
   Select NtcIDX, WriteDate, 
      Case When Notice = 'Y' Then '[필독]'+ Title Else Title End As Title
      From tblSvcNotice Where DelYN = 'N' And SportsGb = 'judo'
      Order By NtcIDX Desc

   -- 공지사항 top 5
   Select Top 5 NtcIDX, WriteDate, 
      Case When Notice = 'Y' Then '[필독]'+ Title Else Title End As Title
      From tblSvcNotice Where DelYN = 'N' And SportsGb = 'judo'
      Order By NtcIDX Desc


   '=================================================================================
   '  Purpose  : main page 대회 요강 페이지 
   '     대회 요강 
   '================================================================================= 
   Select top 10
      GameTitleIDX, GameTitleName, GameS, GameE, SidoDtl, GameArea , 
         (Select PubName From tblPubCode Where DelYN = 'N' And PubCode = 'sd053002') As Host, 
         GameRcvDateS, GameRcvDateE
      From tblGameTitle Where DelYN = 'N' 
      Order By GameTitleIDX Desc

   Select L.TeamGb, T.TeamGbNm From tblRGameLevel As L 
      Inner Join tblTeamGbInfo As T On T.DelYN = 'N' And T.TeamGb = L.TeamGb
      Where L.DelYN = 'N' And L.GameTitleIDX  = 254	
      Group By L.TeamGb, T.TeamGbNm
%>