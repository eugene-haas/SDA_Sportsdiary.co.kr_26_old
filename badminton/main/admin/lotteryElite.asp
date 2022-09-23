<!-- #include virtual = "/pub/charset.asp" -->
<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.pubcode.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.teamGB.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.lvInfo.asp" -->  

<% 	  
'   ===============================================================================     
'     ary position  - 
'      fUse : user 할당 유무 
'      pos_kind : position 종류 - normal, seed, bye/Q (Qualification)
'      pos_val   : normal - -1(사용안함) , seed position val (1, 2, 3.. ), bye/Q position val (1, 2, 3)
'
'     복식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'             0,    1 ,   2     ,    3   ,    4                 ,    5  ,      6  ,    7  ,   8  ,    9  ,   10 ,   11  ,   12  ,  13   
'     단식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser, user, cTeam, team
'              0 ,  1 ,    2    ,    3   ,    4                 ,   5   ,       6 ,   7  ,   8 ,   9
'     ary user - 
'      fUse, teamNo, SeedNo, Ranking, dataOrder, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName
'        0 ,   1   ,   2   ,    3   ,    4     ,     5      ,        6           ,      7              ,    8     ,      9    ,   10,   11    ,    12    ,   13             
'      fUse : user 할당 유무 
'      seed : seed Number
'
'     ary Team Info 
'        fUse, teamKind, teamOrder, cTeam, team, seedCnt, userCnt
'          0 ,   1     ,     2    ,   3  ,   4 ,   5    ,    6
'   ===============================================================================   

'   ===============================================================================   
'        Function parameter description 
' 
'           IsDblGame : 복식 게임인가? 
'   ===============================================================================   
%>

<%
'       엔트리 List 만들기		
'         	1. 게임 참여 신청자 List를 얻는다. - Team별 입력순 sort      - aryReqUser		
'               - Team별 입력순 sort는 각팀의 1, 2, 3... 위 순으로 정렬된 데이터를 의미한다. 		
'            2. 연동대회 상위 입상자 List를 얻는다.    - 최소 16강 이상 유저 선택    - aryRanker		
'            3. 연동대회 메달 수상자 List를 얻는다.    - 1,2,3위 수상자                     - aryMedal		
'            4. 8강, 4강 입상자 Info를 얻는다.   - aryRank4, aryRank8		
'            5. 2, 3의 데이터가 있을 경우 aryRanker에 aryMedal 정보를 Merge한다.		
'            6. 2,4의 데이터가 있을 경우 aryRanker에 aryRank4, aryRank8 정보를 Merge한다. 		
'            7. aryRanker의 정보에서 현재 유저가 선택한 순위를 남기고 데이터를 제거한다. 		
'            8. aryReqUser에 aryRanker데이터를 Merge한다. 		
'            9. 이때 aryReqUser에는 연동대회 상위 입상자 정보가 추가 되고 		
'               aryRanker에는 이번 대회에 참가 신청을 한 User의 정보가 추가된다. 		
'            10. 9번에서 완성된 aryRanker정보가 시드 배정자 리스트이다. 		
'                  
'            11. aryReqUser Field 		
'                  fUse, teamNo, SeedNo, Ranking, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, MemberIDX, MemberName, 		
'                  Team, TeamName, PrevTeam, PrevTeamName		
'                  ( 사용유무, team No, 시드 No, 연동대회 Ranking, 팀내 선수순위, 참가신청 GroupIdx, 참가신청 Player Idx, MemberIdx, MemberName, Team, TeamName, 		
'                     연동대회 입상시 Team, 연동대회 입상시 TeamName)		
'                  
'            12. aryRanker Field 		
'                  '0' As GameRanking, '0' As ReqGame, TourneyGroupIDX, MemberIDX, UserName, SEX, TEAM, TEAMNM		
'                  연동대회 Game Ranking , 현게임 신청여부, GroupIdx, MemberIdx, 선수이름, 성별, 팀, 팀 이름		
'                  
'            13. aryMedal Field		
'                  TourneyGroupIDX, GameMedalIDX  - Group Idx, Medal 순위		
'                  
'            14. aryRank4, aryRank8		
'                  L_TourneyGroupIDX, R_TourneyGroupIDX  - Left Team , Right Team Group Idx		
'                  
'         aryRanker, aryRank4 Merge			
'         aryRanker, aryRank8 Merge	
'            1. aryRank4 / aryRank8의 L_TourneyGroupIDX, R_TourneyGroupIDX와 aryRanker의 Group Idx를 비교한다 .		
'            2. 같을 경우 4강/8강 , 틀리면 16강이다. 		
'                  
'         aryRanker, aryMedal Merge			
'            1. aryMedal의 TourneyGroupIDX와 aryRanker의 Group Idx를 비교한다 .		
'            2. 같을 경우 aryMedal의  GameMedalIDX가 순위다. 		
'                  
'         aryReqUser, aryRanker Merge			
'            1. aryReqUser  MemberIDX, aryRanker의 MemberIDX를 비교한다. 		
'               - 단식일 경우 aryReqUser  MemberIDX, aryRanker의 MemberIDX가 같을 경우 연동대회 상위 Ranker이다. 		
'               - 복식일 경우 팀원 2명의  MemberIDX를 비교하여 둘다 같을 경우 같을 경우 연동대회 상위 Ranker이다. 		
'            2. 비교 결과 연동대회 상위 Ranker일 경우 		
'               - aryReqUser의 Ranking, 연동대회 Team, TeamName에 aryRanker의 정보를 입력한다. 		
'               - aryRanker의 ReqGame에 Set 1을 한다 .		
'                  
'         List Display			
'            1. 연동대회의 정보가 셋팅된 aryReqUser의 정보를 기반으로 List를 셋팅한다. 		
'            2. aryReqUser는 Team 단위로 정렬되어 있다. 		
'            3. Team 정보를 추출하여 소속명에 출력한다 .		
'            4. 엔트리에 팀원을 추가해 준다. 		
'            5. 팀원중에 연동대회 상위 Ranker가 있을 경우 , 칼라링을 한다. 		
'            6. 팀원 Cell을 Double Click시 상위 Ranker일 경우만 연동대회 이력을 MsgBox로 보여준다. 		
'                  - 이때 현재 팀과 이전팀이 틀릴 경우 -> 경남대학교 (前 용인대학교) 로 표시해 준다. 		
'            7. 팀원 Cell을 선택하고 Seed를 적어 주고 다음 버튼을 누를 경우 일괄적으로 aryReqUser에 Seed정보가 반영된다. 		
'            8. 합계 항목은 각 팀별로 팀원의 숫자를 적어준다. 		
'            9. 전체 엔트리 합계는 모든 신청한 인원의 숫자를 적어준다. 		
'                  
'         시드배정자 리스트 버튼			
'            1. aryRanker의 정보를 바탕으로 메시지 박스를 나타낸다. 		
'            2. 단식일 경우 -> 순위 Player(Team)		
'               복식일 경우 -> 순위 Player1,Player2(Team1/Team2) 로 표시 		
'            3. 현 대회에 신청하지 않았을 경우 coloring 한다. 		
'                  
'            본선 Tournament만 있다.   cntUser <= round		
'         cntUser <= round			
'            1.  참가 신청자가 Tournament 강수보다 작거나 같을 경우 예선조는 없다. 		
'            2. Bye자리가 존재할수 있다. 		
'            3. Seed가 존재할수 있다. 		
'                  
'                  
'         참가자 배정 - 1			
'            1. Bye가 있을 경우 Bye를 배정한다. 		
'            2. 토너먼트 강수를 반으로 나눈다.  A part / B part		
'            3. A, B Part중 인원이 적은 쪽 부터 인원을 배분한다. 		
'            4. 각팀에서 인원은 한번에 1명씩 뽑아서 A Or B Part에 배정한다. 		
'            5. 모든팀에서 인원 할당이 끝나야 다시 할당 할수 있다. 		
'            6. Seed를 우선적으로 배정한다. 		
'            7. 각팀의 인원을 배정할때  A part / B part에서 팀별 인원수를 관리한다. 		
'            8. 각팀의 인원을 배정할때  A part / B part중 해당팀의 인원이 적은 쪽으로 인원을 배정한다. 		
'                  
'                  
'            9. 본선의 Tonament인원 = 강수 - Bye수		
'                  
'         참가자 배정 - 2			
'            1. Bye를 먼저 할당한다. 		
'            2. Seed를 먼저 할당한다. 		
'            3. A Part / B Part 각각 아래 루틴을 따른다. 		
'            4.  강수에 따른 Block을 구한다.  ( Search Block )		
'            5. team별로 인원수를 sort한다. (cntTUser)		
'            6. 평균 team 인원수를 구한다. (cntAve)		
'            7. cntAve보다 큰 팀을 우선적으로 배분한다. 		
'            8. cntAve보다 큰 팀을 다 배분한 후 작은 팀을 배분한다. 		
'            9. 작은팀 배분은 각 팀을 골고루 석어 가면서 배분한다. 		
'                  
'                  
'            본선 Tournament + 예선조    cntUser >  round		
'         cntUser <= round			
'            1.  참가 신청자가 Tournament 강수보다 클경우 Bye는 없다		
'            2. 예선조가 존재한다. 		
'            3. Seed가 존재할수 있다. 		
'                  
'                  
'         참가자 배정 - 1			
'            1. 예선조 갯수를 구한다. cntQGoup		
'            2. 예선조 3명 있는 갯수를 구한다. cntQG3Person		
'            3. 예선조 인원수를 구한다.  cntQ = cntQGoup * 4		
'            4. 본선 인원을 구한다. cntTour = round - cntQGoup		
'            5. 토너먼트 강수를 반으로 나눈다.  A part / B part		
'            6. A Part Seed 갯수를 구한다. cntSeedA		
'            7. B Part Seed 갯수를 구한다. cntSeedB		
'            8. A Part 인원수를 구한다. cntUserA = (round - cntQGoup) / 2		
'            9. B Part 인원수를 구한다. cntUserB = (round - cntQGoup) - cntUserA		
'            10. 예선조 인원수를 구한다. cntUserQ = cntUser - (cntUserA + cntUserB)		
'                  
'                  
'         참가자 배정 -2			
'            1. A part , B part의 구분값을 구한다.        halfRound = round / 2		
'            2. Seed를 우선 배분한다.		
'            3. Seed Num < halfRound = A part Else B part		
'            4. A, B Part중 인원이 적은 쪽 부터 인원을 배분한다. 		
'            5. 각팀에서 인원은 한번에 1명씩 뽑아서 A Or B Part에 배정한다. 		
'            6. 모든팀에서 인원 할당이 끝나야 다시 할당 할수 있다. 		
'            7. Seed를 우선적으로 배정한다. 		
'            8. 각팀의 인원을 배정할때  A part / B part에서 팀별 인원수를 관리한다. 		
'            9. 각팀의 인원을 배정할때  A part / B part중 해당팀의 인원이 적은 쪽으로 인원을 배정한다. 		
'            10. A part / B part에 인원이 배정된 후 나머지 인원이 Q part에 배정된다. 		
'                  
'         참가자 배정 -3			
'            ( 예선조 인원 배정 )	1. Bye를 먼저 배정한다.		
'               -  기본적으로 4명 1Group에서 Bye는 1개다		
'               -  Bye가 있는 예선조는 최대 3개 조이다.		
'               - Bye는 뒤에 조부터 채워진다. 		
'               - 예선조 인원이 3명 미만일때 예선조는 1개 조이다. 		
'               - 예선조 인원이 7명 미만일때 예선조는 2개조이다. 		
'               - 예선조 7명 ( 1조 : 4명 , 2조 : 3명 ), 예선조 6명 ( 1조 : 3명 , 2조 : 3명 ), 예선조 5명 ( 1조 : 3명 , 2조 : 2명 )		
'                  
'            2. team별로 인원수를 sort한다. (cntTUser)		
'            3. 평균 team 인원수를 구한다. (cntAve)		
'            4. cntAve보다 큰 팀을 우선적으로 배분한다. 		
'            5. cntAve보다 큰 팀을 다 배분한 후 작은 팀을 배분한다. 		
'            6. 작은팀 배분은 각 팀을 골고루 석어 가면서 배분한다. 		
'                  
'         참가자 배정 -4			
'            ( Tonament 인원 배정 )	1. Seed를 먼저 배정한다. 		
'            2. 예선조를 먼저 배정한다. 		
'               - 강수에 따른 Block을 구한후 Block단위로 예선조를 할당한다. 		
'               - 예선조는 A part / B part로 번갈아 배분한다. 		
'               - Seed가 없는 곳에 예선조를 먼저 배분한다. 		
'            3. A Part / B Part 각각 아래 루틴을 따른다. 		
'            4.  강수에 따른 Block을 구한다.  ( Search Block )		
'            5. team별로 인원수를 sort한다. (cntTUser)		
'            6. 평균 team 인원수를 구한다. (cntAve)		
'            7. cntAve보다 큰 팀을 우선적으로 배분한다. 		
'            8. cntAve보다 큰 팀을 다 배분한 후 작은 팀을 배분한다. 		
'            9. 작은팀 배분은 각 팀을 골고루 석어 가면서 배분한다. 		
'            10. 중복 체크를 할 경우 해당 Block에 예선조가 포함 되어 있으면 해당하는 예선조 인원도 가져와서 중복 체크를 한다. 	


'            혼합팀	
'               A1, A2, A3, A4, A5, A6, A7, A8, A9, A10
'               A1, A2, A3, B4, B5, B6, C7, C8, A9, A10
'               
'               B1, B2, B3, B4, B5, B6, B7, B8, B9, B10
'               B1, B2, B3,  A4, A5, A6, B7, B8, B9, B10
'               
'               C1, C2, C3, C4, C5, C6, C7, C8, C9, C10
'               C1, C2, C3, C4, C5, C6, A7, A8, C9, C10
'               
'               상기와 같이 데이터가 꾸려 질 경우 
'               팀은 총 5개, A, AB, AC, B, C이 며, 팀내 선수 번호(1장.. )는 해당팀으로만 꾸려진다.  
'               A팀의 경우 A1, A2, A3,  A9, A10는 A팀 이지만.. 
'               A4, A5, A6, 는 AB 팀
'               A7, A8,는 AC팀 이므로 
'               각 팀내 선수 번호는 다음과 같다. 
'               A1, A2, A3, A9, A10   => 1, 2, 3, 4, 5
'               A4, A5, A6 => 1, 2, 3
'               A7, A8 => 1, 2 
'               B1, B2, B3,B7, B8, B9, B10 => 1, 2, 3, 4, 5, 6, 7
'               C1, C2, C3, C4, C5, C6, C9, C10  => 1, 2, 3, 4, 5, 6, 7, 8
'               
'               만약 AB팀이 혼합팀이고  A: 여자 , B가 남자일 경우 남자를 우선 배치한다. 
'               "즉  A4, A5, A6   =>   B4, B5, B6 순으로 나타나야 한다. 
'                    B4, B5, B6        A4, A5, A6"
'              
'              시드배치	
'              	시드를 먼저 배치한다. 
'              	1. 1,2위 위치는 고정 
'              	2. 3/4 위치는 그 안에서 랜덤
'              	3. 5/8위치는 그 안에서 랜덤
'              	4. 9/16위치는 그 안에서 랜덤. 
'              	5. 시드 위치 랜덤은 현재 설정된 Seed갯수 안에서 위의 1,2,3,4룰을 적용한다. 
'              	6. 2,3,4 룰에서 팀이 겹칠 경우 해당 팀끼리 랜덤으로 위치 선정, 나머지 끼리 랜덤으로 위치 선정한다. 
%>

<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>배드민턴 관리자</title>
<script type="text/javascript" src="/js/jquery-1.12.2.min.js"></script>
<link rel="stylesheet" href="/css/lib/jquery.timepicker.min.css">
<script type="text/javascript" src="/js/library/jquery.timepicker.min.js"></script>

<link rel="stylesheet" href="/css/lib/jquery-ui.min.css">
<link rel="stylesheet" href="/css/lib/bootstrap-datepicker.css">
<link rel="stylesheet" type="text/css" href="/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/css/fontawesome-all.css">
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css">

<link rel="stylesheet" type="text/css" href="/css/lotteryElite_setGameNum.css">

<!-- sd_admin.css -->
<link rel="stylesheet" type="text/css" href="/css/admin/admin.d.style.css">

<script type="text/javascript" src="/js/library/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="/js/jquery-migrate-1.4.1.min.js"></script>
<script type="text/javascript" src="/js/library/selectivizr-min.js"></script>
<script type="text/javascript" src="/js/library/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/library/jquery.easing.min.js"></script>
<script type="text/javascript" src="/js/library/bootstrap.min.js"></script>
<script src="/js/library/placeholders.min.js"></script>
<script type="text/javascript" src="/js/library/datepicker-ko.js"></script>
<script type="text/javascript" src="/dev/dist/Common_Js.js" ></script>
<script type="text/javascript" src="/js/CommonAjax.js?ver=1.0"></script>
<script type="text/javascript" src="/js/bdadmin.js"></script>
<!-- <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script> -->
<script type="text/javascript" src="/pub/js/etc/tournament_modify/tournament.js"></script>
<script type="text/javascript" src="/pub/js/etc/utx.js<%=UTX_JSVER%>"></script>
<script type="text/javascript" src="/pub/js/etc/ctx.js<%=CTX_JSVER%>"></script>
<script type="text/javascript" src="/pub/js/etc/bmx.js<%=BMX_JSVER%>"></script>
<script type="text/javascript" src="/js/admin/LotteryElite.js?ver=1.1.11"></script>  

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
	.lotteryElite .right-con .entryBox__header .entryBox__col:nth-child(2){width:73.5%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__header .entryBox__col:nth-child(3){width:6.5%;}
	/* .lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1){width:20%;border-right:1px solid #eee; line-height:112px;} */
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1){width:20%;/* border-right:1px solid #eee; */height:112px;display:flex;align-items:center;}
  .lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1)>span{margin:auto;}
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(2){min-height:112px;display: flex;align-items: center;
  width:74%;border-right:1px solid #eee;border-left:1px solid #eee;}
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(3){width:6%;line-height:102px;}
	.lotteryElite .right-con .entryBox__footer .entryBox__row{border-bottom:0;}
	.lotteryElite .right-con .entryBox__footer .entryBox__col:nth-child(1){width:93.5%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__footer .entryBox__col:nth-child(2){width:6.5%;}
	.lotteryElite .right-con .entry{width:100%;padding:16px 10px;/* white-space:nowrap; */overflow:auto;line-height:normal;text-align:left;}
	.lotteryElite .right-con .entry__item{text-align:center;display:inline-block;width:95px;background:#dbe1e8;border-radius:3px;padding:5px 0 3px;border:0;margin:1px;}
	.lotteryElite .right-con .entry__item.s_related{background:#ff8300;color:#fff;font-family:'NanumGothicB';user-select: none;cursor:pointer;}
	.lotteryElite .right-con .entry__item.s_related input{color:#333;}
	.lotteryElite .right-con .entry__item.s_selected{border:1px dashed #dbe1e8;background:#f5f5f5;color:#bdbdbd;}
	.lotteryElite .right-con .entry__input{max-width:89px;line-height:26px;height:26px;border:0;margin-top:5px;text-align:center;}
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

  .btn-box-addp{position:relative;}
  .seed_info{position:absolute;left:0;top:0;line-height:35px;font-size:18px;font-weight:bold;}
  .seed_info span{font-size:inherit;font-weight:inherit;color:#2f6fc1;}

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
		border-color:#f2f2f2; /* border-style:solid; */
		display:flex;
    opacity:0.5;
    cursor:pointer;
	}
	.lotteryMatch.s_duplicate .lotteryMatch__seedWrap,
  .lotteryMatch.s_duplicate .lotteryMatch__playerWrap{border:2px solid #2db23c;}
	.lotteryMatch.s_duplicate .lotteryMatch__seedWrap{border-right:none;}
  .lotteryMatch.s_duplicate .lotteryMatch__playerWrap{border-left:none;}
	.lotteryMatch.s_selected .lotteryMatch__seedWrap,
  .lotteryMatch.s_selected .lotteryMatch__playerWrap{border:2px solid #ff8300;}
	.lotteryMatch.s_selected .lotteryMatch__seedWrap{border-right:none;}
  .lotteryMatch.s_selected .lotteryMatch__playerWrap{border-left:none;}

	/* !@# */
	.lotteryMatch.s_filled{opacity:1;}

	.lotteryMatch_first{ bottom:50%;
		/* border-width:0 0 1px 0; */
		border-radius:4px 4px 0 0;
	}
	.lotteryMatch_second{ top:50%;
		/* border-width:1px 0 0 0; */
		border-radius:0 0 4px 4px;
	}

	.lotteryMatch_first .lotteryMatch__seedWrap{ bottom:50%;
    border-style:solid;
		border-width:0 0 1px 0;
		border-radius:4px 0 0 0;
    border-color:#f2f2f2;
	}
	.lotteryMatch_second .lotteryMatch__seedWrap{ top:50%;
    border-style:solid;
		border-width:1px 0 0 0;
		border-radius:0 0 0 4px;
    border-color:#f2f2f2;
	}
	.lotteryMatch_first .lotteryMatch__playerWrap{ bottom:50%;
    border-style:solid;
		border-width:0 0 1px 0;
    border-color:#f2f2f2;
	}
	.lotteryMatch_second .lotteryMatch__playerWrap{ top:50%;
    border-style:solid;
		border-width:1px 0 0 0;
    border-color:#f2f2f2;
	}

	.lotteryMatch__seedWrap1{
		display:block;
		width:16%;
		height:100%; text-align:left; text-indent:5px; font-size:13px; letter-spacing:-0.05em; line-height:26px;
	}
	.lotteryMatch__seedWrap{
		display:block;
		width:20%;
		height:100%; text-align:left; text-indent:5px; font-size:13px; letter-spacing:-0.05em; line-height:26px;
		background-color:#dbe1e8;
	}
	.lotteryMatch__playerWrap{
		display:flex;flex-direction:column;justify-content:center;
		width:64%;
		height:100%;padding:0 4px;box-sizing:border-box;text-align:left;
		background-color:#b3c1d1;
		background-color:#b6c3d2;
	}
	.lotteryMatch__playerInner{
		width:100%;display:block;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;
	}
	.lotteryMatch__player{display:inline;font-size:13px;font-weight:700;line-height:18px;}
	.lotteryMatch__belong{display:inline;font-size:12px;line-height:18px;}

  .bocsic.modal-warp{max-width:400px;}

	.tournament__block{z-index:0;}
	#pid_BYE{cursor:default;}
</style>

<script>
   /* ==================================================================================         
      전역 변수 
      참여 인원 정보, 연동대회 상위입상자 정보를 저장하기 위한 전역 배열 
   ================================================================================== */
   var gAryGameUser = null;            // 대회 참여자 정보 
   var gArySeedUser = null;            // 연동대회 상위 입상자 정보 
   var gAryRank8Info = null;           // 연동대회 8강 입상자 정보 - gArySeedUser에 통합 된다. 
   var gAryRank4Info = null;           // 연동대회 4강 입상자 정보 - gArySeedUser에 통합 된다. 
   var gAryMedalUser = null;           // 연동대회 Medal 입상자 정보 - gArySeedUser에 통합 된다. 
   var gPlayType = "";                 // 단식/복식 유무 저장 
   var gGroupGameGB = "";              // Group GameGb - 개인전/단체전 유무 저장 
   var gSelGameKind = "";              // 선택한 게임 종별 
   var gDisplayList = false;           // 우측 List를 뿌렸는지 유무 
   var gAryMUser = null;               // 수동 입력시 사용 - Player 이름순 배열 
   var gAryMTeamUser = null;           // 수동 입력시 사용 - Team - Player 이름순 배열 
   var gAryPos = null;                 // Tonament 참가자 배치 Position Array 
   var gAryQPos = null;                 // 예선조 참가자 배치 Position Array  	
   var gAryMenual = null;              // 수동배정일 경우 auto complete에 들어갈 배열값. 
	var gAryGameNo = null; 					// Tournament Game Num을 셋팅한다. 
	var gAryQGameNo = null; 				// 예선 Tournament Game Num을 셋팅한다. 

   var gSelID = "";                    // 본선, 혹은 예선 Selected id 
   var gSelPart = "";                  // E_PART_Q, E_PART_F 사용 
   var gSelManual = false;             // Manual Assign (수동배정)이 선택 되었는가? 
	var gSelQPos	= 0; 						// 수동 배정시 0: 일반 학생, 1: 예선조 배정
	var gSelQScrollPos = 0;					// 수동 배정시 div_QTournament_body scroll 값
	var gQGroupNum = 0;
   var E_POS_NORMAL, E_POS_SEED, E_POS_BYE, E_POS_Q, E_POS_FIRST, E_POS_MANUAL;
   var E_RESET_LV1, E_RESET_LV2, E_RESET_ALL;
   var E_PART_Q, E_PART_F;             // 예선, 본선 
   

   E_POS_NORMAL            = 0;               // 일반 자리 
   E_POS_SEED              = 1;               // Seed 자리 
   E_POS_BYE               = 2;               // Bye 자리 
   E_POS_Q                 = 3;               // 예선전 조 자리 
   E_POS_FIRST             = 4;               // 1장 자리 
   E_POS_MANUAL            = 5;               // 수동 배정 자리 

   E_RESET_LV1            = 1;               // ( 토너먼트 자리)
   E_RESET_LV2            = 2;               // ( 토너먼트 자리) + ( List 자리) 
   E_RESET_ALL            = 3;               // 대회 셋팅 자리 + ( 토너먼트 자리) + ( List 자리) 

   E_PART_Q                = 0;               // 예선
   E_PART_F                = 1;               // 본선

</script>

<form name="frmPopup">
   <input type="hidden" name="pos">
   <input type="hidden" name="q_pos">
	<input type="hidden" name="game_num">
   <input type="hidden" name="q_game_num">
   <input type="hidden" name="playType">
   <input type="hidden" name="groupGameGb">
   <input type="hidden" name="gameInfo">
</form>

<form name="frmPlace">
   <input type="hidden" name="pos">
   <input type="hidden" name="q_pos">
   <input type="hidden" name="reqUser">
</form>

<div class="lotteryElite">
	<!-- s: top-title -->
	<div class="top-title">
		배드민턴 엘리트 대진추첨
	</div>
	<!-- e: top-title -->
	<!-- s: content-warp -->
	<div class="content-warp">
		<!-- s: left-con -->
		<div class="left-con">
			<div class="title">

				<input type="text" id = "edit_GameTitle" class="title__inp" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" placeholder="※ 대회명을 입력해주세요" autocomplete="off"/>
            <input type="hidden" name="hide_GameTitleIdx" id="hide_GameTitleIdx" value="<%=crypt_ReqGameTitleIdx%>">
				<button class="title__toggle [ _toggleTitle ]">펼치기</button>
			</div>

			<!-- s: top-search -->
			<div class="top-search">

					<!-- s: in-se-list -->
					<ul class="in-se-list">
							<li>
								<span class="l-name">종별</span>
								<span class="r-con">
									<select id = "sel_GameKind"  onchange="onSelGameKind()">
										<option value="0">:: 종별을 선택하세요 ::</option>
										<!-- <option value="1">남대부</option> -->
									</select>
								</span>
							</li>
							<li>
								<span class="l-name">엔트리</span>
								<span class="r-con">
									<input type="text" id = "txt_entrycnt" placeholder="자동값 불러오기" autocomplete="off"/>
								</span>
							</li>
							<li>
								<span class="l-name">연동대회</span>
								<span class="r-con dropdown">
									<input type="text" id = "edit_AssoGameTitle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" placeholder="직접 입력" autocomplete="off"/>                           
                           <input type="hidden" name="hide_AssoGameTitleIdx" id="hide_AssoGameTitleIdx" value="0">
								</span>
							</li>

							<li>
								<span class="l-name">강수</span>
								<span class="r-con">
									<select id = "sel_round">
										<option value="0">::강수선택::</option>
										<option value="4">4강</option>
										<option value="8">8강</option>
										<option value="16">16강</option>
										<option value="32">32강</option>
										<option value="64">64강</option>
										<option value="128">128강</option>
										<option value="256">256강</option>
									</select>
								</span>
							</li>

                     <li>
								<span class="l-name">Test 인원</span>
								<span class="r-con">
									<input type="text" id = "txt_reducecnt" placeholder="엔트리 인원을 줄입니다." autocomplete="off"/>                           
								</span> 
							</li>

						</ul>
					<!-- e: in-se-list -->

					<!-- s: r-ranking-box -->
					<div class="r-ranking-box">
						<!-- <p class="p-name">연동 순위 선택</p> -->
						<div class="tab">
							<input type="radio" id="AssignAuto" name="Assign" class="tab__radio s_igno [ _assign ]" value="auto" checked />
							<label for="AssignAuto" class="tab__menu s_auto"><span>자동배정</span></label>

							<input type="radio" id="AssignCheck" name="Assign" class="tab__radio s_igno [ _assign ]" value="check"/>
							<label for="AssignCheck" class="tab__menu s_check"><span>선택배정</span></label>

							<input type="radio" id="AssignMenual" name="Assign" class="tab__radio s_igno [ _assign ]" value="menual"/>
							<label for="AssignMenual" class="tab__menu s_menual"><span>수동배정</span></label>

							<p class="tab__panel s_auto">
								단식 8강 / 복식 4강, 시드 자동
							</p>

							<div class="tab__panel s_check">
								<label for="ranking1">
									<span>1위</span>
									<input type="checkbox" value="1" class = "cls_chkRank" id = "chk_rank1" onClick="onChkRank(this)" />
								</label>
								<label for="ranking2">
									<span>2위</span>
									<input type="checkbox" value="2"  class = "cls_chkRank" id = "chk_rank2" onClick="onChkRank(this)"/>
								</label>
								<label for="ranking3">
									<span>3위</span>
									<input type="checkbox" value="3"  class = "cls_chkRank" id = "chk_rank3" onClick="onChkRank(this)"/>
								</label>
								<label for="ranking4">
									<span>공동3위</span>
									<input type="checkbox" value="4"  class = "cls_chkRank" id = "chk_rank4" onClick="onChkRank(this)"/>
								</label>
								<label for="ranking5">
									<span>8강</span>
									<input type="checkbox" value="5"  class = "cls_chkRank" id = "chk_rank5" onClick="onChkRank(this)"/>
								</label>
								<label for="ranking6">
									<span>16강</span>
									<input type="checkbox" value="6"  class = "cls_chkRank" id = "chk_rank6" onClick="onChkRank(this)"/>
								</label>
							</div>

							<p class="tab__panel s_menual">
								수동 배정
							</p>

						</div>
					</div>
					<!-- e: r-ranking-box -->


				<div class="btn-box">
					<a href="#" class="blue-btn" onclick = "onBtnApply();">적용</a>
				</div>

			</div>
			<!-- e: top-search -->

			<div class="middle-btns">
				<button id = "btn_QTournament" onclick = "onBtnQTournament();">예선</button><button id = "btn_FTournament"class="s_active" onclick = "onBtnFTournament();">본선</button>
			</div>

         <!-- s: bottom-list  예선전 tournament-->
         <div id="div_QTournament_body" class="bottom-list cls_QTournament">                     
               <!-- 예선 대진표자리 -->
         </div>

         <!-- s: bottom-list  본선 tournament-->
         <div id="div_FTournament" class="bottom-list cls_FTournament">
				   대진표자리
			</div>

         
			<!-- e: bottom-list  -->

			<div class="btn-box btm-btn-box">         
				<a href="#"  onclick = "onBtnInit();">초기화</a>
				<a href="#"  onclick = "onBtnUserPlace();">배치확인</a>
				<a href="#"  onclick = "onBtnPreview();">미리보기</a>
            <a href="http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/OperateNew.asp" target="_blank">대진표 확인</a>
				<a href="#"  onclick = "onBtnSetGameNum();">게임번호 설정</a>
				<a href="#"  onclick = "onBtnComplete();">최종 완료</a>
			</div>
		</div>
		<!-- e: left-con -->

		<!-- 수동 -->
		<!-- s: right-con -->
		<div class="right-con">

			<div>

				<div class="searching">
					<input type="text" class="searching__input" placeholder="선수명, 소속명을 검색하세요" />
					<button class="searching__del">X</button>
				</div>

			</div>

			<!-- s: list-box -->
			<div class="entryBox">

				<div class="entryBox__header">

					<div class="entryBox__row">
						<div class="entryBox__col"> <span>소속명</span> </div>
						<div class="entryBox__col"> <span>엔트리</span> </div>
						<div class="entryBox__col"> <span>합계</span> </div>
					</div>

				</div>

				<div class="entryBox__body">
					<div class="entryBox__body" id="div_entry_body">
						
					</div>
				</div>

				<div class="entryBox__footer">
					<div class="entryBox__row">
						<div class="entryBox__col">
							<span>전체 엔트리 합계</span>
						</div>
						<div class="entryBox__col">
							<span id = "sp_entry_total">10</span>
						</div>
					</div>
				</div>

			</div>
			<!-- e: list-box -->

			<div class="btn-box-addp">
        <p class="seed_info" >최대 Seed 갯수 : <span id = "idsp_maxSeed">0개</span></p>             
				<div class="btn-box btm-btn-box">
               <label for="applySeed">
                  <span>시드 랜덤적용</span>
                  <input type="checkbox" value="1" class = "cls_chkSeed" id = "chk_applySeed" onClick="onChkApplySeed('chk_applySeed')" />
               </label>
					<a href="#" class="modal-btn-three" onclick = "onBtnSeedList();">시드배정자 리스트</a>
					<a href="#" class="modal-btn-tow"  onclick = "onBtnNext();">다음</a>
				</div>
			</div>
			<!-- e: right-con -->
			</div>

		</div>
		<!-- e: right-con -->

	</div>
	<!-- e: content-warp -->
</div>

<div class="fixed-bg"></div>

<!-- s: modal-one -->
<div class="modal-warp modal-one"   id = "msg_box1"></div>
<div class="modal-warp modal-tow"   id = "msg_box2"></div>
<div class="modal-warp modal-three" id = "msg_box3"></div>
<div class="modal-warp modal-four" id = "msg_box4" ></div>

<!-- s: modal-four -->
<div class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Modal title</h4>
      </div>
      <div class="modal-body">
        <p>One fine body&hellip;</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- e: modal-four -->
<div class="set-game-num_modal_wrap">
	<div class="set-game-num_modal">
		<div class="set-game-num_modal__header">
			<span id = "sp_set_num_title">엘리트대진추첨테스트대회2 - 남고단(개인전) 128강</span>
			<div class="set-game-num_modal__header__btn-box">
				<button type="button" name="button" onclick="onSaveManualGameNum()">저장</button>
				<button type="button" name="button" onclick="oncancelSGNumModal()">취소</button>
			</div>
		</div>
		<div id="div_SGNumTournament" class="cls_SGNumTournament">
			대진표자리

		</div>
	</div>
</div>

<!-- content height setting -->
<script>

	var $windowHeight = $(window).height(); /* 윈도창 높이 */
	var $bottomlistHeight = $(".lotteryElite .content-warp .left-con .bottom-list");
	var $toptitleHeight = $(".lotteryElite .top-title").outerHeight(true);
	var $topsearchHeight =$(".lotteryElite .content-warp .left-con .top-search").outerHeight(true);
	var $btnbtnboxHeight =$(".btm-btn-box").outerHeight(true);
	var $rtableHeight = $(".entryBox__body");
	$bottomlistHeight.css("height", $windowHeight - $toptitleHeight - $btnbtnboxHeight - $topsearchHeight - 110);
	$rtableHeight.css("height", $windowHeight -254);

	var $topSearchbox = $(".lotteryElite .content-warp .left-con .top-search");
	$('._toggleTitle').click(function(){
		if(!($topSearchbox.hasClass("on"))){
			$topSearchbox.addClass("on");
			$(this).addClass("on").text("펼치기");
			$bottomlistHeight.css("height", $windowHeight - $toptitleHeight - $btnbtnboxHeight - 110);
		}else{
			$topSearchbox.removeClass("on")
			$(this).removeClass("on").text("닫기")
			$bottomlistHeight.css("height", $windowHeight - $toptitleHeight - $btnbtnboxHeight - $topsearchHeight - 110);
		}
	});

</script>

<script>
   // **********************************************************************************
   //       control init
   // **********************************************************************************  
   ////////////명령어////////////
   CMD_ELITEGAMEKIND = 1;        
   CMD_SEARCHGAMETITLE = 13;
   CMD_ELITESEEDPLAYER = 20;        // Get Seed Player   - 연동 대회 우수 선수 조회 
   CMD_ELITEGAMEPLAYER = 21;        // Get Elite Player  - 대회 선수 조회 
   CMD_ELITEMAKETOURNAMENT = 30;    // make Elite Tournament Info - 엘리트 선수 토너먼트를 연산한다. 
   CMD_ELITEREGINFO = 40;           //  Elite Tonament Info를 등록한다. 

   ////////////명령어////////////

   gAryMUser = [
      "김밥",
      "김치",
      "김치찌개",
      "김치김밥",
      "김밥천국",
      "참치김밥",
      "김밥나라"
   ];

   gAryMTeamUser = [
      "김밥2",
      "김치2",
      "김치찌개2",
      "김치김밥2",
      "김밥천국2",
      "참치김밥2",
      "김밥나라2"
   ];

    $(document).ready(function () {
      var bOnlyEndGame = 0; 
      initSearchControl("edit_GameTitle", "hide_GameTitleIdx", bOnlyEndGame );

      // 연관게임 검색은 종료된 게임만 대상으로 한다. 
      bOnlyEndGame = 1; 
      initSearchControl("edit_AssoGameTitle", "hide_AssoGameTitleIdx", bOnlyEndGame );
      //      initAssociationGameTitle(); 

      // 수동 입력시 사용하는 입력박스 연동 . 
      $("#txt_manual_search").autocomplete({source: gAryMUser});

      // 기본적으로 본선대진표가 보여진다. 
      ctx.showElementEx("cls_QTournament", false);
      ctx.showElementEx("cls_FTournament", true);
      gSelPart = E_PART_F;

      // 기본적으로 시드 배정은 랜덤이다. 
      ctx.setCheckboxVal('chk_applySeed', true); 

      // ctx.showElementEx("cls_QTournament", true);
      // ctx.showElementEx("cls_FTournament", false);

    });

/* ==================================================================================
      웹페이지 종료, 리프레쉬 할때 호출 
      - 생성한 객체 ( tonament Object )을 제거한다.  
   ================================================================================== */ 
   window.onbeforeunload = function() {
			console.log("Window closed");
			gAryPos = null; 
			gAryQPos = null; 
   }

/* ==================================================================================         
      대회선택, 연동대회 선택시 autocomplete를 구현하기 위한 함수 
      연동대회 일때만 제한 조건이 있다 - 종료 대회만 bEndGame를 이용하여 구분한다. 
   ================================================================================== */
   function initSearchControl(id_ctrl, id_val, bEndGame) 
   {
      var recentYear = 2;        // 최근 2년 데이터만 보여준다. 

   $( "#"+id_ctrl ).autocomplete({
      source : function( request, response ) {
         $.ajax(
         {
               type: 'post',                  
               url: "../ajax/searchGameTitle.asp",              
               dataType: "json",
               data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHGAMETITLE, "SVAL":request.term, "ENDGAME":bEndGame, "RECENTYEAR":recentYear}) },
              
               success: function(data) {
                  //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                  response(
                     $.map(data, function(item) {
                           return {
                              label: item.gameTitleName + "(" + item.gameS + "~" + item.gameE + ")" + ", 번호 : " + item.uidx,
                              value: item.gameTitleName,
                              tidx : item.uidx,
                              gameTitleName : item.gameTitleName,
                              crypt_tidx : item.crypt_uidx
                           }
                     })
                  );
               }
         }
         );
      },
         //조회를 위한 최소글자수
      minLength: 1,
      select: function( event, ui ) {

         console.log(ui.item.gameTitleName); 
         var obj = {}
         obj.CMD = CMD_SEARCHGAMETITLE;
         obj.tIdx = ui.item.tidx;
         obj.crypt_tIdx = ui.item.crypt_tidx;
         obj.tGameTitleName = ui.item.gameTitleName;
         $("#"+id_val).val(obj.crypt_tIdx);
         // OnGameTitleChanged(obj.crypt_tIdx);
         // sel_LevelList();
         if(bEndGame != 1){
            SearchEliteGameKind(obj.crypt_tIdx);
         }         
      }, 

         focus:function(event, ui){return false;} //한글입력시 포커스이동하면 서제스트가 삭제되므로 focus처리
      });     
   } 

/* ==================================================================================         
      선택 대회의 종별을 구하기 위한 Req
   ================================================================================== */
   function SearchEliteGameKind(enc_tIdx)
   {
      var packet = {};
      console.log("SearchEliteGameKind");

      var Url ="../ajax/lotteryElite_GameKind.asp"
      packet.CMD = CMD_ELITEGAMEKIND;
      packet.ENCTIDX = enc_tIdx;

      SendPacket(Url, packet);
   }

/* ==================================================================================         
      연관 대회, 종별에 해당하는 상위 입상자 인원을 구하기 위한 Req
   ================================================================================== */
   function SearchSeedPlayer(rank)
   {
      var packet = {};
      var sel_val, assoTitleIdx, cSex, cTeamGB, cPlayType, cGroupGameGB, aryVal;
      var Url ="../ajax/lotteryElite_SeedPlayer.asp"

      sel_val = ctx.getSelectVal("sel_GameKind");  
      gSelGameKind = ctx.getSelectText("sel_GameKind");
      
      aryVal = sel_val.split(",");
      if(aryVal.length != 6)
      {
         alert("종별 데이터에 문제가 있습니다.");
         return; 
      }

      cSex           = aryVal[2];
      cTeamGB        = aryVal[3];
      cPlayType      = aryVal[4];
      cGroupGameGB   = aryVal[5];

      assoTitleIdx = ctx.getHiddenVal("hide_AssoGameTitleIdx");

      console.log("SearchSeedPlayer");
     
      packet.CMD           = CMD_ELITESEEDPLAYER;
      packet.ENCTIDX       = assoTitleIdx;
      packet.RANK          = rank; 
      packet.SEX           = cSex; 
      packet.TEAMGB        = cTeamGB; 
      packet.PTYPE         = cPlayType; 
      packet.GROUPGGB      = cGroupGameGB; 

      SendPacket(Url, packet);
   }

/* ==================================================================================         
      선택한 대회, 종별에 해당하는 참여 신청 인원을 구하기 위한 Req
   ================================================================================== */
   function SearchElitePlayer(cTitleIdx, cLevelIdx, cPlayType, cGroupGameGB)
   {
      var packet = {};
      console.log("SearchElitePlayer");

      var Url ="../ajax/lotteryElite_GamePlayer.asp"
      packet.CMD = CMD_ELITEGAMEPLAYER;
      packet.TIDX = cTitleIdx;
      packet.LVIDX = cLevelIdx;
      packet.PLAYTYPE = cPlayType;
      packet.GROUPGGB = cGroupGameGB; 

      SendPacket(Url, packet);
   }

   
</script>

<script>
   // **********************************************************************************
   //       Ajax Receive
   // **********************************************************************************  
   function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
      switch(CMD) {
         case CMD_ELITEGAMEKIND: onRcvEliteGameKind(dataType, htmldata, jsondata); break; 
         case CMD_ELITEGAMEPLAYER: onRcvEliteGamePlayer(dataType, htmldata, jsondata); break; 
         case CMD_ELITESEEDPLAYER: onRcvEliteSeedPlayer(dataType, htmldata, jsondata); break; 
         case CMD_ELITEMAKETOURNAMENT: onRcvEliteMakeTournament(dataType, htmldata, jsondata); break; 
         case CMD_ELITEREGINFO: onRcvEliteReqInfo(dataType, htmldata, jsondata); break; 
      }
   }

/* ==================================================================================         
      대회명을 입력하고 해당 대회에 있는 종별 리스트를 구하여 Select Box에 넣는다. 
   ================================================================================== */
   function onRcvEliteGameKind(dataType, htmldata, jsonObj)
   {
      console.log("onRcvEliteGameKind jsonObj = " + jsonObj);
      var res = ""; 
      if(utx.isObjEmpty(jsonObj)) return; 

      if(utx.hasownEx(jsonObj, "result")) res = jsonObj.result;
      if(res == "100") {
         alert("종별을 구할수 없습니다.");
         return; 
      }
      
      if(dataType == "html")
      {
         $("#sel_GameKind").html(htmldata);                
      }
   }

/* ==================================================================================         
      연동대회 선택시 Seed 배정을 위한 상위 입상자에 대한 정보를 구한다. 
      1. 상위 입상자 정보를 구한다. 
          - Medal 정보 / Round 정보가 분리 되어 존재 한다. 
      2. League일 때는 Medal 정보만 유효하다. 
      3. League가 아닐때는 Round정보를 셋팅하고, 그후 Medal 정보를 셋팅한다. 
   ================================================================================== */
   function onRcvEliteSeedPlayer(dataType, htmldata, jsonObj)
   {
      console.log("onRcvEliteSeedPlayer jsonObj = " + jsonObj);
      var res = "", nRank = 0, nLeague = 0, playType = "" ; 
      if(utx.isObjEmpty(jsonObj)) return; 

      if(utx.hasownEx(jsonObj, "result")) res = jsonObj.result;

      var strErr = "";
      switch(res) {
         case 100: strErr = "연동대회 시드 진출자를 구할수 없습니다.\n관리자에 문의해 주세요!"; break; 
         case 101: strErr = "연동대회 종별이 2개 이상있습니다.\n관리자에 문의해 주세요!"; break; 
         case 102: strErr = "연동대회 상위 Ranker를 구하는데 문제가 발생했습니다.\n관리자에 문의해 주세요!"; break; 
      }

      if(res != "1") {
         alert(strErr);
         return; 
      }
      
      if(utx.hasownEx(jsonObj, "RANKPLAYER")) gArySeedUser = JSON.parse(jsonObj.RANKPLAYER);
      if(utx.hasownEx(jsonObj, "MEDAL")) gAryMedalUser = JSON.parse(jsonObj.MEDAL);
      if(utx.hasownEx(jsonObj, "RANK8")) gAryRank8Info = JSON.parse(jsonObj.RANK8);
      if(utx.hasownEx(jsonObj, "RANK4")) gAryRank4Info = JSON.parse(jsonObj.RANK4);
      if(utx.hasownEx(jsonObj, "RANK")) nRank = Number(jsonObj.RANK);
      if(utx.hasownEx(jsonObj, "LEAGUE")) nLeague = Number(jsonObj.LEAGUE);
      if(utx.hasownEx(jsonObj, "PTYPE")) playType = jsonObj.PTYPE;
      
      if(gArySeedUser != null && gAryMedalUser != null)
      {       
         // League가 아닐 경우만 Rank를 채운다. 
         if(nLeague == 0) FillSeedRank(nRank ,gArySeedUser, gAryRank8Info, gAryRank4Info); 
         FillSeedMedal(nRank, gArySeedUser, gAryMedalUser);
         FillRankInfoToAryReq(gAryGameUser, gArySeedUser, playType); 

         // Rank Info를 Ranking에 의하여 sort한다. 
         utx.sort2DimAry(gArySeedUser, 0, 2); 

         printAryGameUser(gAryGameUser); 
         printArySeedUser(gArySeedUser); 
         printAryMedalUser(gAryMedalUser); 
         printAryRank8Info(gAryRank8Info); 
         printAryRank4Info(gAryRank4Info); 


         // utx.printInfo2DAry(gAryGameUser, "prev reduce gAryGameUser");
         gAryGameUser = reduceAryUser(gAryGameUser);          // For Test
         // utx.printInfo2DAry(gAryGameUser, "after reduce gAryGameUser");
			
			utx.sort2DimAry(gAryGameUser, 1, 2); 
         if(!ApplyList(gAryGameUser, playType)) return;          
      }
   }

/* ==================================================================================         
      종별 선택시 해당 종별에 참여신청을 한 인원을 구한다. 
      참여 인원을 json data로 받아 전역 변수 gAryGameUser에 저장하고, 
      엔트리 Count를 셋팅한다. ( 단식 = 배열 크기 , 복식 = 배열 크기 / 2)
   ================================================================================== */
   function onRcvEliteGamePlayer(dataType, htmldata, jsonObj)
   {
      console.log("onRcvEliteGamePlayer jsonObj = " + jsonObj);
      var res = ""; 
      var entryCnt = 0; 
      if(utx.isObjEmpty(jsonObj)) return; 

      if(utx.hasownEx(jsonObj, "result")) res = jsonObj.result;
      if(res == "100") {
         // 엔트리 Count
         ctx.setTextboxVal("txt_entrycnt", entryCnt);
         alert("참여신청 인원이 없습니다.");
         return; 
      }
      
      if(utx.hasownEx(jsonObj, "PLAYER")) gAryGameUser = JSON.parse(jsonObj.PLAYER);
      if(utx.hasownEx(jsonObj, "PLAYTYPE")) gPlayType = jsonObj.PLAYTYPE

      if(gAryGameUser != null)
      {
         var len = gAryGameUser.length; 
         var strLog = ""; 
         var entryCnt = (bmx.IsDoublePlay(gPlayType)) ? len/2  : len; 

         // 엔트리 Count
         ctx.setTextboxVal("txt_entrycnt", entryCnt);

         //// utx.printInfo2DAry(gAryGameUser, "onRcvEliteGamePlayer");
      }
   }

   /* ==================================================================================         
      대회명을 입력하고 해당 대회에 있는 종별 리스트를 구하여 Select Box에 넣는다. 
   ================================================================================== */
   function onRcvEliteMakeTournament(dataType, htmldata, jsonObj)
   {
      console.log("onRcvEliteGameKind jsonObj = " + jsonObj);
      var res = "", strPos = "", strQPos = ""; 
      if(utx.isObjEmpty(jsonObj)) return; 

      if(utx.hasownEx(jsonObj, "result")) res = jsonObj.result;
      if(utx.hasownEx(jsonObj, "POSARY")) strPos = jsonObj.POSARY;
      if(utx.hasownEx(jsonObj, "QPOSARY")) strQPos = jsonObj.QPOSARY;

      if(res == "100") {
         alert("대회 신청자 정보를 구할수 없습니다.");
         return; 
      }

      if(strQPos != "") {         
         gAryQPos =  utx.Get2DAryFromStr(strQPos, "|", ",");      
         createQTournament(gAryQPos);
      }

      if(strPos != "") {          
         gAryPos =  utx.Get2DAryFromStr(strPos, "|", ",");   
         createTournament(gAryPos);
      }
   }

/* ==================================================================================         
      토너먼트 결과를 DB에 저장한다. 
   ================================================================================== */
   function onRcvEliteReqInfo(dataType, htmldata, jsonObj)
   {
      console.log("onRcvEliteReqInfo jsonObj = " + jsonObj);
      var res = "", strPos = "", strQPos = ""; 
      if(utx.isObjEmpty(jsonObj)) return; 

      if(utx.hasownEx(jsonObj, "result")) res = jsonObj.result;

      if(res == "100") {
         alert("DB에 등록하지 못했습니다.");
         return; 
      }
      alert("DB에 등록하였습니다.");
   }

</script>

<script>
   // **********************************************************************************
   //       Event Function 
   // **********************************************************************************

   /* ==================================================================================
         게임 종별을 선택한다. 
         종별 선택시 해당 종별에 참여신청을 한 인원을 구한다. 
      ================================================================================== */
   function onSelGameKind()
   {
      var sel_val, cTitleIdx, cLevelIdx, cSex, cTeamGB, cPlayType, cGroupGameGB, aryVal;
      sel_val = ctx.getSelectVal("sel_GameKind");  
      
      aryVal = sel_val.split(",");
      if(aryVal.length != 6)
      {
         alert("종별 데이터에 문제가 있습니다.");
         return; 
      }

      cTitleIdx      = aryVal[0];
      cLevelIdx      = aryVal[1];
      cSex           = aryVal[2];
      cTeamGB        = aryVal[3];
      cPlayType      = aryVal[4];
      cGroupGameGB   = aryVal[5];

      gGroupGameGB   = cGroupGameGB;

      var strLog = utx.strPrintf("onSelGameKind sel_val = {0}, titleIdx = {1}, levelIdx = {2}, cSex = {3}, cTeamGB = {4}, cPlayType = {5}, cGroupGameGB = {6}", 
                     sel_val, cTitleIdx, cLevelIdx, cSex, cTeamGB, cPlayType, cGroupGameGB);
      
      console.log(strLog);     

      gDisplayList = false; 
      ResetDisplaySet(E_RESET_ALL);
      
      SearchElitePlayer(cTitleIdx, cLevelIdx, cPlayType, cGroupGameGB);     
      // ResetDisplaySet(E_RESET_ALL);
      // ResetDisplaySet(3);
   }

/* ==================================================================================
      선택한 게임, 종별로 참여 인원을 구하고, 
      option (연동대회를 지정하여 상위 입상자 수를 지정 한 후) 
      우측 리스트에 참여 인원을 보여준다. 
      - 수동 배정일 경우 연동대회의 값이 무시된다. 
      - 자동 배정일 경우 Rank값은 단식 8강 / 복식 4강 - 연동대회에서 입상자를 구한다. 
      - 선택 배정일 경우 선택한 Rank를 적용한다. - 연동대회에서 입상자를 구한다. 
      - Seed를 적용할 경우 Seed를 찾고 , Ajax 호출 Recv한 후 우측 리스트에 참여 명단을 적용한다. 
      - Seed를 적용하지 않을 경우 바로 우측 리스트에 참여 명단을 적용한다. 
   ================================================================================== */
   function onBtnApply()
   {
      var sel_assign, sel_rank = 0, bSearchSeed = true, sel_title, sel_kind;
      var cnt_selKind = ctx.getSelectItemCnt("sel_GameKind");

      // var cnt_selKind = $('select#sel_GameKind option').length;
      
      sel_title = ctx.getTextboxVal("edit_GameTitle");
      sel_kind = ctx.getSelectVal("sel_GameKind");
      sel_assign = ctx.getRadioVal("Assign");

      gSelManual = false; 

      if(sel_title == "") {
         alert("대회명을 입력하셔야 합니다."); 
         return; 
      }

      if(cnt_selKind == 1) {
         alert("종별데이터가 없습니다. 대회명을 확인해 보세요"); 
         return; 
      }

      if(sel_kind == "0") {
         alert("종별을 선택하셔야 합니다."); 
         return; 
      }

      if(gAryGameUser == null) {
         alert("대회 참가자 정보가 없습니다. 대회명을 확인해 보세요"); 
         return; 
      }

      if(gGroupGameGB == "B0030002") bSearchSeed = false;   // 단체전일때 연동대회 검색은 하지 않는다. 

      if(sel_assign == "auto")               // 자동 배정일 경우 Rank값은 단식 8강 / 복식 4강 - 연동대회에서 입상자를 구한다. 
      {
         sel_rank = (bmx.IsDoublePlay(gPlayType)) ? 4 : 8;      
      }
      else if(sel_assign == "check")         // 선택 배정일 경우 선택한 Rank를 적용한다. - 연동대회에서 입상자를 구한다.
      {
         sel_rank = getCheckedRank(); 
         if(sel_rank == 0)
         {
            alert("연동대회의 Seed에 적용할 값을 선택해 주세요!");
            return; 
         }   
      }
      else if(sel_assign == "menual")        // 수동 배정일 경우 연동대회의 값이 무시된다.
      {
         bSearchSeed = false;    
         gSelManual = true; 

         ManualApplyList(gAryGameUser, gPlayType); 

			// utx.printInfo2DAry(gAryGameUser, "onBtnApply manual");
         return; 
      }

      var strAssocGame = ctx.getTextboxVal("edit_AssoGameTitle"); 

      // Seed를 적용할 경우 Seed를 찾고 , Ajax 호출 Recv한 후 리스트에 적용하고 
      if( bSearchSeed == true && strAssocGame != "")
      {         
         SearchSeedPlayer(sel_rank);
      }
      else {    

         if(gGroupGameGB == "B0030001")         // 개인전 
         {
            gAryGameUser = reduceAryUser(gAryGameUser);  
			  
				utx.sort2DimAry(gAryGameUser, 1, 2); 				
            if(!ApplyList(gAryGameUser, gPlayType)) return; 
         }
         else if(gGroupGameGB == "B0030002")    // 단체전 
         {				
				utx.sort2DimAry(gAryGameUser, 1, 2); 				
            if(!ApplyTeamList(gAryGameUser, gPlayType)) return; 
         }
      }

      gDisplayList = true; 

      var strLog = utx.strPrintf("sel_assign = {0}, sel_rank = {1}", sel_assign, sel_rank);
      console.log(strLog);

      ResetDisplaySet(E_RESET_LV1);

      var bReset = false; 
      writeSeedInfo(bReset);

		// utx.printInfo2DAry(gAryGameUser, "onBtnApply");

	}
	
   /* ==================================================================================
         초기화 버튼 
      ================================================================================== */
   function onBtnInit()
   { 
      onSelGameKind();
   }

	/* ==================================================================================
         배치확인 버튼 
      ================================================================================== */
   function onBtnUserPlace()
   { 
		var strPos, strQPos, strReqUser, url; 

      url = "./lotteryElite_placeConfirm.asp"
      strPos =  utx.GetStrFrom2DAry(gAryPos, "|", ",");   
      strQPos =  utx.GetStrFrom2DAry(gAryQPos, "|", ",");
		strReqUser =  utx.GetStrFrom2DAry(gAryGameUser, "|", ",");		

		// utx.printInfo2DAry(gAryGameUser, "onBtnUserPlace");
		console.log(strReqUser); 

		open_place(url, strPos, strQPos, strReqUser);
   }

   /* ==================================================================================
         미리보기 버튼 
      ================================================================================== */
   function onBtnPreview()
   {      
      var strPos, strQPos, url, strGInfo, strGTitle, strGKind, strGameNum, strQGameNum;
		var aryGameNum, aryQGameNum, IsQFinal = 0;

		// Tournament Game Num을 생성한다.
		if(gAryGameNo == null) aryGameNum = ApplyTournamentGameNum(gAryPos);
		else aryGameNum = gAryGameNo;

		strGameNum = GetStrFrom1DAry(aryGameNum, ",");

		if(gAryQPos != null) {       

			IsQFinal = IsFinalQTournament(gAryQPos);  
			// 예선조 Tournament Game Num을 생성한다.
			if(IsQFinal) aryQGameNum = [1];
			else aryQGameNum = ApplyQTournamentGameNum(gAryQPos);

			strQGameNum = GetStrFrom1DAry(aryQGameNum, ",");
      }
		
		utx.printInfo2DAry(gAryPos, "gAryPos"); 
		utx.printInfo2DAry(gAryQPos, "gAryQPos"); 


      url = "./lotteryElite_print.asp"
      strPos =  utx.GetStrFrom2DAry(gAryPos, "|", ",");   
      strQPos =  utx.GetStrFrom2DAry(gAryQPos, "|", ",");
      strGKind = ctx.getSelectText("sel_GameKind"); 
      strGTitle   = ctx.getTextboxVal("edit_GameTitle"); 
      strGInfo = utx.sprintf("{0},{1},{2}", strGTitle, strGKind, gSelManual ? 1 : 0); 

		open_print(url, strPos, strQPos, strGameNum, strQGameNum, gPlayType, gGroupGameGB, strGInfo);
			
			var strLog = utx.sprintf("onBtnPreview() strGTitle = {0}, strGKind = {1}, gSelManual = {2}", strGTitle, strGKind, gSelManual); 
			console.log(strLog); 
   }

	 function onBtnSetGameNum(){
		 var strGKind, strGTitle, strGInfo, strLevel, strGameType;
		 $('.set-game-num_modal_wrap').fadeIn(200);
		 $('body').addClass('t_modal');

		 var round = gAryPos.length;

		strGKind = ctx.getSelectText("sel_GameKind");
      strGTitle   = ctx.getTextboxVal("edit_GameTitle");		// 여고단 (개인전)
		strLevel = utx.getBlockData(strGKind, "", "(");
		strGameType = utx.getBlockData(strGKind, "(", ")");

    //  strGInfo = utx.sprintf("{0} - {1} {2}강 ({3})", strGTitle, strLevel, round, strGameType);
	   strGInfo = utx.sprintf("{0} - {1} <strong>{2}강</strong>", strGTitle, strGKind, round);

		ctx.writeHtmlToSpan("sp_set_num_title", strGInfo);
		 createSetNumTournament(gAryPos);
	 }

	 /* ==================================================================================
          Save Game Num
       ================================================================================== */
	function onSaveManualGameNum(){
		var cntSet = 0, id_edit = "", id_edit_base = "eliteMatch_", i = 0, gameNum = 0;
		var aryTmp = null;

		cntSet = gAryPos.length - 1;
		gAryGameNo = [];

		for(i = 0; i< cntSet; i++) {
			id_edit = utx.sprintf("{0}{1}", id_edit_base, i);
			gameNum = ctx.getTextboxVal(id_edit);
			gameNum = (gameNum == "") ? 0 : parseInt(gameNum); // 값이 없으면 0으로 셋팅한다.

			if(gameNum < 0 || gameNum > cntSet) {
				gAryGameNo = null;
				ctx.focusElement(id_edit);
				alert("게임 번호가 없거나, 게임 번호 값이 잘못되었습니다");
				return;
			}

			gAryGameNo.push(gameNum);
		}

		aryTmp = utx.copy1DAry(gAryGameNo);
		utx.sortAry(aryTmp, 2, 0);

		for(i=0; i<cntSet-1; i++) {
			if(aryTmp[i] > 0 && aryTmp[i+1] != aryTmp[i] + 1) {
				gAryGameNo = null;
				alert("게임 번호가 중복되었습니다. 다시 확인하세요");
				return;
			}
		}

		$('.set-game-num_modal_wrap').fadeOut(200);
		$('body').removeClass('t_modal');
		ctx.writeHtmlToDiv("div_SGNumTournament", "");               // 좌측 본선 토너먼트
 	}

	/* ==================================================================================
          oncancelSGNumModal 버튼
       ================================================================================== */
	function oncancelSGNumModal(){
 		 $('.set-game-num_modal_wrap').fadeOut(200);
 		 $('body').removeClass('t_modal');
		
		ctx.writeHtmlToDiv("div_SGNumTournament", "");               // 좌측 본선 토너먼트
   }

   /* ==================================================================================
         대회 운영페이지 Link - 최종 완료후 DB 저장 확인   대회정보 > 대회운영 > 경기운영관리 > 해당 게임 검색 > 해당 팀 확인 
      ================================================================================== */
   function onBtnGameOperatePage()
   {  
      var strPos, strQPos, url, strGInfo, strGTitle, strGKind; 

      url = "./OperateNew.asp"
     
      var frmPop= document.frmPopup;      
      window.open('',"pop_print");  

      frmPop.method = "Post";
      frmPop.action = url;
      frmPop.submit(); 
   }

   /* ==================================================================================
         최종완료 버튼 
      1. 예선조의 갯수를 찾는다. 
      2. 예선조가 있을 경우 인원은 무조건 4명씩 각 조는 |로 구분 , 각조의 인원은 ,로 구분
         2-1. 예선조가 1개조만 있고 bye가 2개면 인원은 2명 - 이때는 결선
      3. 본선의 강수를 찾는다. 
      4. 본선의 인원은 ,로 구분 
      ================================================================================== */
   function onBtnComplete()
   {      
      var strPos = "", strQPos = "", strInfo = "", strSeed = "", strSeedInfo = "";
		var strGameNo = "", strQGameNo = ""; 
      var nQSize = 4, nRound = 0, nQGroup = 0, IsQFinal = 0;

      console.log("onBtnComplete");
      // MsgBoxSearchPlayer(0);
      if(gSelManual == true)
      {
         if(!IsCompleteAssignManual(gAryPos)) {
            alert("수동배정이 완료되지 않았습니다.\r\n최종완료를 할수 없습니다.");
            return; 
         }
      }

      nRound = gAryPos.length; 
      strPos =  GetStrPlayerCode(gAryPos, nRound, "|", ",");   
      strSeedInfo = GetStrSeedInfo(gAryPos);

		// Tournament Game Num을 생성한다. 
		if(gAryGameNo == null) gAryGameNo = ApplyTournamentGameNum(gAryPos); 
		strGameNo = GetStrFrom1DAry(gAryGameNo, ","); 

      if(gAryQPos != null) {
         nQGroup = (gAryQPos.length) / nQSize;       
         strQPos =  GetStrPlayerCode(gAryQPos, nQSize, "|", ",");   
         IsQFinal = IsFinalQTournament(gAryQPos);

			// 예선조 Tournament Game Num을 생성한다. 
			if(gAryQGameNo == null) 
			{
				if(IsQFinal) gAryQGameNo = [1]; 
				else gAryQGameNo = ApplyQTournamentGameNum(gAryQPos); 
				strQGameNo = GetStrFrom1DAry(gAryQGameNo, ","); 
			}
      }

		gAryQGameNo = null; 
		gAryGameNo = null; 

      reqComplete(strPos, strQPos, strSeedInfo, strGameNo, strQGameNo, nRound, nQGroup, IsQFinal); 

      strInfo = utx.sprintf("onBtnComplete - nRound = {0}, nQGroup = {1}", nRound, nQGroup); 
      console.log(strInfo); 
      console.log("strPos =" + strPos); 
      console.log("strQPos =" + strQPos);  

   }

   /* ==================================================================================
         seed Info, order Info를 가지고 tournament Info를 request한다. ( ajax call )
      ================================================================================== */
   function reqComplete(strPos, strQPos, strSeedInfo, strGameNo, strQGameNo, nRound, nQGroup, IsQFinal)
   {
      var sel_val, cTitleIdx, cLevelIdx, cSex, cTeamGB, cPlayType, cGroupGameGB, aryVal;
      sel_val = ctx.getSelectVal("sel_GameKind");  
      
      aryVal = sel_val.split(",");
      if(aryVal.length != 6)
      {
         alert("종별 데이터에 문제가 있습니다.");
         return; 
      }

      cTitleIdx      = aryVal[0];
      cLevelIdx      = aryVal[1];
      cSex           = aryVal[2];
      cTeamGB        = aryVal[3];
      cPlayType      = aryVal[4];
      cGroupGameGB   = aryVal[5];
      var packet = {};
      console.log("reqComplete"); 

      var Url ="../ajax/lotteryElite_RegInfo.asp"
      packet.CMD = CMD_ELITEREGINFO;
      packet.TIDX = cTitleIdx;
      packet.LVIDX = cLevelIdx;
      packet.QFINAL = IsQFinal;
      packet.POSINFO = strPos;
      packet.QPOSINFO = strQPos;      
		packet.GAMENO = strGameNo; 
		packet.QGAMENO = strQGameNo; 
      packet.SEEDINFO = strSeedInfo;
      packet.ROUND = nRound;
      packet.QGROUP = nQGroup;

      SendPacket(Url, packet);
   }

   /* ==================================================================================
      aryPos에서 GroupIdx를 string으로 만들어 반환한다. 
      ================================================================================== */
   function GetStrPlayerCode(rAryPos, sBlock, sep1, sep2)
   {
      var i = 0, nMax = 0, strCodes, cntBye, strVal

      nMax = rAryPos.length; 
      // 4자리이고, bye가 2개면 결승으로 바꾼다. - 예선조 
      if(nMax == 4) {
         if(rAryPos[1][2] ==  E_POS_BYE && rAryPos[2][2] ==  E_POS_BYE)
         {
            strCodes = utx.sprintf("{0}{1}{2}", rAryPos[0][4], sep2, rAryPos[3][4]);
            return strCodes; 
         } 
      }


      for(i = 0; i< nMax; i++) {         
         if(rAryPos[i][2] == E_POS_BYE) strVal = "0"
         else if(rAryPos[i][2] == E_POS_Q) strVal = utx.sprintf("Q{0}", rAryPos[i][3])
         else strVal = utx.sprintf("{0}", rAryPos[i][4])

         if(i == 0) {
            strCodes = utx.sprintf("{0}", strVal); 
         }
         else {            
            if(i < nMax && !( i % sBlock)) {
               strCodes = utx.sprintf("{0}{1}{2}", strCodes, sep1, strVal); 
            }
            else {
               strCodes = utx.sprintf("{0}{1}{2}", strCodes, sep2,strVal);   
            }
         }
      }
      return strCodes; 
   }

   /* ==================================================================================
      aryPos에서 Seed를 string으로 만들어 반환한다. (pos, seedNum)
      ================================================================================== */
   function GetStrSeedInfo(rAryPos)
   {
      var i = 0, nMax = 0, strCodes, cntBye, strVal

      nMax = rAryPos.length; 

      for(i = 0; i< nMax; i++) {         
         if(rAryPos[i][2] == E_POS_SEED) 
         {
            if(strCodes == undefined)
               strCodes = utx.sprintf("{0},{1}", i, rAryPos[i][3])
            else 
               strCodes = utx.sprintf("{0}|{1},{2}", strCodes, i, rAryPos[i][3])
         }
      }
      return strCodes; 
   }

	/* ==================================================================================
      1D Array를 입력받아 sep를 구분자로 된 string을 반환한다. 
      ================================================================================== */
   function GetStrFrom1DAry(rAry, sep)
   {
      var i = 0,len = 0, strData = ''; 

      len = rAry.length; 

      for(i = 0; i< len; i++) {                  
         if(strData == "")
				strData = utx.sprintf("{0}", rAry[i]);
			else 
				strData = utx.sprintf("{0}{1}{2}", strData, sep, rAry[i])
      }
      return strData; 
   }


   /* ==================================================================================
         시드 배정자 리스트 버튼 
      ================================================================================== */
   function onBtnSeedList()
   {     
      if(gSelManual)
      {
         alert("수동배정에서는 사용할 수 없습니다."); 
         return; 
      }      

      if(gArySeedUser == null)
      {
         alert("연동대회 정보가 없습니다."); 
         return;
      }
      MsgBoxSeedList(gArySeedUser, gPlayType);
   }

   /* ==================================================================================
         다음 버튼 
         엔트리 리스트에 적용된 SeedNo를 gAryGameUser에 적용한다. 
         1. class name = "entry__input"으로 정의된 child array를 구한다. 
         2. "ed_seed" + groupIdx로 되어 있는 ctrl_id에서 groupIdx를 추출한다. 
         3. ctrl_id로 edit box에 입력된 seed No가 있을 경우에만 arySeedNo에 [groupIdx, seedNo] push한다. 
         4. 입력된 SeedNo의 valid Check를 한다. (중복값 or 1부터 순서대로 ++ 인지 체크 )
         5. SeedNo valid check를 위해 seedN를 기준으로 2차원 배열 sort를 한다. 
         6. sort후 valid check한다. 
         7. 운영자가 입력한 Seed Number를 게임신청 리스트에 적용한다. 
      ================================================================================== */
   function onBtnNext()
   {      
      if(gSelManual)
      {
         alert("수동배정에서는 사용할 수 없습니다."); 
         return; 
      }

      console.log("onBtnComplete");

			// var child_eds = $("#div_entry_body").find(".entry__input"); 
		var IsDesc = 0, key = 5, keyType = 2;
      var child_eds = ctx.getChildAllByCID("div_entry_body", "entry__input");
      var ctrl_id = "", groupIdx = "", seedNo = "", len = child_eds.length; 
      var arySeedNo = new Array(); 
      var aryCheck = new Array(); 
      var strSeedInfo = "", strTeamOrder = "", stgLog = "";
      var selRound = ctx.getSelectVal("sel_round");
      var nCnt = 0, userCnt = gAryGameUser.length;
      var key, keyType, IsDesc; 
      var IsRandomSeed = ctx.IsSelectCheckbox('chk_applySeed');
		var useSeed = 1;
			
      selRound = Number(selRound); 

      if(selRound == 0) 
      {
         alert("토너먼트 강수를 선택하셔야 합니다.");
         return; 
      }

      if(gDisplayList == false)
      {
         alert("종별 선택후 적용을 눌러 우측화면에 List를 Display해야 합니다."); 
         return; 
      }

      console.log("sel Round = " + selRound); 


      for(var i = 0; i<len; i++)
      {
         ctrl_id = child_eds[i].id;
         groupIdx = utx.getBlockData(ctrl_id, "ed_seed");
         seedNo = ctx.getTextboxVal(ctrl_id);
         if(seedNo == "") seedNo = "0";
         else 
         {
            aryCheck.push(seedNo); 
            arySeedNo.push([groupIdx, seedNo, 0, 0, 0]); 
         }
      }

      len = arySeedNo.length; 
      utx.sort2DimAry(arySeedNo, 1); 
		var seedCnt = aryCheck.length;

      if(!checkSeedValid(arySeedNo)) 
      {
         alert("SeedNo에 중복값이 있거나 연속된 숫자로 할당되어 있지 않습니다.\nSeed값을 다시 확인해 주세요!!"); 
         return; 
      }

      if(seedCnt == 0)
      {
         var ret = confirm('시드를 설정하지 않았습니다. 계속 진행하시겠습니까?');
         if(ret == false) return; 
			useSeed = 0; 
      }

      bmx.IsDoublePlay(gPlayType);
      nCnt = (bmx.IsDoublePlay(gPlayType)) ? (userCnt / 2) : userCnt; 
      if(nCnt > selRound) nCnt = selRound;      // 예선전이 있을 경우 Round로 Seed갯수를 구한다. 

      if(bmx.IsValidSeedCnt(selRound, seedCnt) == false)
      {
         strLog = utx.sprintf("시드를 {0}개 설정하셨습니다. \r\n참여인원이 {1}명인 토너먼트에서는 시드를 최대 {2}개까지 설정할수 있습니다.\r\n",
                     seedCnt,  nCnt, bmx.getSeedCnt(selRound));
         alert(strLog);
         return; 
      }

		if(useSeed == 1) {
			if(IsRandomSeed) {
				console.log("onBtnNext Apply RandomSeed... "); 
				// utx.printInfo2DAry(arySeedNo, "onBtnNext() prev  - arySeedNo");  
				applyTeamOrderToArraySeed(gAryGameUser, arySeedNo); 
				applyTeamCountToArraySeed(arySeedNo);
				//// utx.printInfo2DAry(arySeedNo, "applyTeamOrderToArraySeed  - arySeedNo");  

				mixSeedPos(gAryGameUser, arySeedNo); 

				// utx.printInfo2DAry(arySeedNo, "mixSeedPos  - arySeedNo");  
			}

			// make seedInfo 
			len = arySeedNo.length; 

			for(i = 0; i < len; i++)
			{
				if(strSeedInfo == "") strSeedInfo = utx.sprintf("{0},{1}", arySeedNo[i][0], i+1);
				else strSeedInfo = utx.sprintf("{0}|{1},{2}", strSeedInfo, arySeedNo[i][0], i+1);
			}
		
			ApplySeedNoToReqAry2(gAryGameUser, arySeedNo);
		}

      //console.log(strSeedInfo); 
      reqMakeTournament(strSeedInfo, selRound, userCnt); 

      // reset select id
      SetSelTourBlock(gSelID, "");
      gSelID = "";

      ResetDisplaySet(E_RESET_LV1);

		// 초기화 
		gAryGameNo = null; 				// Tournament Game Num을 셋팅한다. 
		gAryQGameNo = null; 				// 예선 Tournament Game Num을 셋팅한다. 
	 }

/* ==================================================================================
			운영자가 입력한 Seed Number를 랜덤하게 섞는다. - 공정성을 위해서 
			1, 2등은 고정 
			3, 4 등 / 5, 6, 7, 8 등 / 9, 10, 11, 12, 13, 14, 15, 16 등은 각 그룹별로 랜덤하게 서로 섞는다. 			
	 ================================================================================== */
function mixSeedPos(rAryUser, rArySeedNo) {
	var aryTmp = []; 
   var i, cnt, sIdx, eIdx; 
   var s_pos, e_pos, s_pos2, e_pos2, same_cnt, loop_flag, loop_max, loop_cnt;
   var aryUser, key, keyType, IsDesc 
   

   //printInfo1DAry(rArySeedNo, "mixSeedPos - mixSeedPos"); 
   //// utx.printInfo2DAry(rAryUser, "mixSeedPos - rAryUser"); 

	//console.log(" -------------------------------  In mixSeedPos")
	cnt = rArySeedNo.length; 
	if(cnt < 4) return; 					// 1, 2등은 고정 	3명만 있어도 고정이다. 	

	for(i = 0; i<cnt; i++) {
		aryTmp[i] = new Array(); 
		aryTmp[i][0] = 0
		aryTmp[i][1] = rArySeedNo[i][0]
      aryTmp[i][2] = rArySeedNo[i][1]
      aryTmp[i][3] = rArySeedNo[i][2]
      aryTmp[i][4] = rArySeedNo[i][3]
      aryTmp[i][5] = rArySeedNo[i][4]		
	}

	if(cnt == 4) {
		s_pos = 2; 
		e_pos = 3; 
		proc_mix(rArySeedNo, aryTmp, s_pos, e_pos); 
	}
	else if(cnt < 9)
	{
		s_pos = 2; 
		e_pos = 3; 
		proc_mix(rArySeedNo, aryTmp, s_pos, e_pos); 
      
      s_pos = 4; 
      e_pos = cnt-1; 
      
      same_cnt = rArySeedNo[s_pos][3]; 

      // 동일 팀이 있으면 그 팀끼리 Random하게 돌린다. 
      if(same_cnt > 1) {         

         loop_flag = 1, loop_max = 10, loop_cnt = 0; 
         s_pos2 = s_pos;
         while(same_cnt > 1) {            
            e_pos2 = s_pos2 + same_cnt-1; 

            proc_mix(rArySeedNo, aryTmp, s_pos2, e_pos2); 

            s_pos2 = e_pos2 + 1; 
            if(s_pos2 > e_pos) same_cnt = 0; 
            else same_cnt = rArySeedNo[s_pos2][3];     
            loop_cnt ++; 

            if(loop_cnt > loop_max) same_cnt = 0; 
         }

            // 동일팀 작업후 남은 팀이 있다. 
         if(e_pos2 < e_pos) {       
            s_pos = e_pos2 + 1; 
            proc_mix(rArySeedNo, aryTmp, s_pos, e_pos); 
         }
      }
      else {		
         proc_mix(rArySeedNo, aryTmp, s_pos, e_pos); 
      }
	}
	else if(cnt < 17)
	{
		s_pos = 2; 
		e_pos = 3; 
		proc_mix(rArySeedNo, aryTmp, s_pos, e_pos); 

		s_pos = 4; 
      e_pos = 7; 
      
      same_cnt = rArySeedNo[s_pos][3]; 
      // 동일 팀이 있으면 그 팀끼리 Random하게 돌린다. 
      if(same_cnt > 1) {         

         loop_flag = 1, loop_max = 10, loop_cnt = 0; 
         s_pos2 = s_pos;
         while(same_cnt > 1) {            
            e_pos2 = s_pos2 + same_cnt-1; 

            proc_mix(rArySeedNo, aryTmp, s_pos2, e_pos2); 

            s_pos2 = e_pos2 + 1; 
            if(s_pos2 > e_pos) same_cnt = 0; 
            else same_cnt = rArySeedNo[s_pos2][3];     
            loop_cnt ++; 
            
            if(loop_cnt > loop_max) same_cnt = 0; 
         }

            // 동일팀 작업후 남은 팀이 있다. 
         if(e_pos2 < e_pos) {       
            s_pos = e_pos2 + 1; 
            proc_mix(rArySeedNo, aryTmp, s_pos, e_pos); 
         }
      }
      else {		
         proc_mix(rArySeedNo, aryTmp, s_pos, e_pos); 
      }

		s_pos = 8; 
		e_pos = cnt-1; 
		same_cnt = rArySeedNo[s_pos][3]; 
      // 동일 팀이 있으면 그 팀끼리 Random하게 돌린다. 
      if(same_cnt > 1) {         

         loop_flag = 1, loop_max = 10, loop_cnt = 0; 
         s_pos2 = s_pos;
         while(same_cnt > 1) {            
            e_pos2 = s_pos2 + same_cnt-1; 

            proc_mix(rArySeedNo, aryTmp, s_pos2, e_pos2); 

            s_pos2 = e_pos2 + 1; 
            if(s_pos2 > e_pos) same_cnt = 0; 
            else same_cnt = rArySeedNo[s_pos2][3];     
            loop_cnt ++; 
            
            if(loop_cnt > loop_max) same_cnt = 0; 
         }

         // 동일팀 작업후 남은 팀이 있다. 
         if(e_pos2 < e_pos) {       
            s_pos = e_pos2 + 1; 
            proc_mix(rArySeedNo, aryTmp, s_pos, e_pos); 
         }
      }
      else {		
         proc_mix(rArySeedNo, aryTmp, s_pos, e_pos); 
      }
	}

  return true;
}

/* ==================================================================================
			랜덤하게 seed를 섞는다. 
	================================================================================== */
function proc_mix(rArySeed, rAryTmp, s_pos, e_pos)
{
	var cnt = (e_pos - s_pos) + 1; 
	var rNum = 0, v_pos = 0, v_cnt = 0; 

	for(var i = s_pos; i <= e_pos; i++){
		rNum = (utx.getRandomInt(0, cnt--)); 
		v_cnt = 0; 
		
		for(var j = s_pos; j<= e_pos; j++)
		{
			if(rAryTmp[j][0] == 0) {
				if(rNum == v_cnt) {
					v_pos = j; 
					rAryTmp[j][0] = 1; 
					break; 
				}
				v_cnt++; 
			}			
		}

      rArySeed[i][0] = rAryTmp[v_pos][1]
      rArySeed[i][1] = rAryTmp[v_pos][2]
      rArySeed[i][2] = rAryTmp[v_pos][3]
      rArySeed[i][3] = rAryTmp[v_pos][4]
      rArySeed[i][4] = rAryTmp[v_pos][5]
	}
}

/* ==================================================================================
		arySeedNo에 teamOrder를 적용한다. 
	================================================================================== */
function applyTeamOrderToArraySeed(rAryUser, rArySeedNo) {
   var len, i = 0, groupIdx, teamOrder;
   var key, keyType, IsDesc; 

   len = rArySeedNo.length; 

   for(i = 0; i < len; i++) {
      groupIdx = rArySeedNo[i][0];
      teamOrder = findTeamOrder(rAryUser, groupIdx); 
      rArySeedNo[i][2] = teamOrder;     
   }   
}

/* ==================================================================================
		arySeedNo에 teamCount를 적용하고, 5/8, 9/16을 TeamCount로 부분 정렬한다. 
	================================================================================== */
function applyTeamCountToArraySeed(rArySeedNo) {
   var len, i = 0, groupIdx, teamOrder = -1;
   var key, keyType, IsDesc; 
   var cnt = 0, s_pos = -1, e_pos = -1; 
   var sb = 0, eb = 0;

   len = rArySeedNo.length; 

   // 5~8 사이 sort 
   if(len > 5) {
      sb = 4; 
      eb = (len > 8) ? 8 : len;

      key = 2; 
      keyType = 2;
      IsDesc = 0;       
      utx.sortPart2DimAry(rArySeedNo, key, sb, eb-1, keyType, IsDesc); 

      s_pos = -1, e_pos = -1; 
      cnt = 0; 
      teamOrder = -1;
      for(i = sb; i < eb; i++) {      
         if(teamOrder != rArySeedNo[i][2]) {
            if(s_pos == -1) s_pos = i; 
            else {
               e_pos = i - 1; 
               setTeamCntInBlock(rArySeedNo, s_pos, e_pos, cnt); 
               s_pos = i; 
            }
            cnt = 1; 

            teamOrder = rArySeedNo[i][2];
         }
         else cnt++;       
      }  
      e_pos = i - 1; 
      setTeamCntInBlock(rArySeedNo, s_pos, e_pos, cnt);  
   }

   // 9~16 사이 sort 
   if(len > 9) {
      sb = 8; 
      eb = len;

      key = 2; 
      keyType = 2;
      IsDesc = 0;       
      utx.sortPart2DimAry(rArySeedNo, key, sb, eb-1, keyType, IsDesc); 

      s_pos = -1, e_pos = -1; 
      cnt = 0; 
      teamOrder = -1; 

      for(i = sb; i < eb; i++) {      
         if(teamOrder != rArySeedNo[i][2]) {
            if(s_pos == -1) s_pos = i; 
            else {
               e_pos = i - 1; 
               setTeamCntInBlock(rArySeedNo, s_pos, e_pos, cnt); 
               s_pos = i; 
            }
            cnt = 1; 

            teamOrder = rArySeedNo[i][2];
         }
         else cnt++;       
      }   

      e_pos = i - 1; 
      setTeamCntInBlock(rArySeedNo, s_pos, e_pos, cnt);       
   }
}

function setTeamCntInBlock(rArySeedNo, sPos, ePos, cntTeam) {
   var i = 0; 

   for(i = sPos; i <= ePos; i++) {
      rArySeedNo[i][3] = cntTeam; 
   }
}

/* ==================================================================================
		groupIdx를 입력받아 aryUser에서 TeamOrder를 얻는다. 
	================================================================================== */
function findTeamOrder(rAryUser, groupIdx) {
   var i = 0, len = 0, teamOrder = 0

   len = rAryUser.length; 

   for (i = 0; i<len; i++) {
      if(rAryUser[i][6] == groupIdx) {
         teamOrder = rAryUser[i][1];
         break; 
      }
   }

   return teamOrder;
}


	 
	 /* ==================================================================================
      운영자가 입력한 Seed Number를 게임신청 리스트에 적용한다. 
      rAryReq    : fUse, teamNo, SeedNo, Ranking, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, 
                     MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName
      rArySeedNo : groupIdx, SeedNo 
   ================================================================================== */
   function ApplySeedNoToReqAry2(rAryReq, rArySeedNo) {
      var i = 0,
         len = 0,
         seedNo = -1,
         groupIdx = "";
      if (rAryReq == null || rArySeedNo == null) return false;
      len = rAryReq.length;

      for (i = 0; i < len; i++) {
         groupIdx = rAryReq[i][6]
         seedNo = getSeedNo2(rArySeedNo, groupIdx);
         if (seedNo != -1) rAryReq[i][2] = seedNo;
      }
      return true;
   }

/* ==================================================================================
      groupIdx를 입력받아 SeedNo를 반환한다. 
      rArySeedNo : groupIdx, SeedNo 
   ================================================================================== */
   function getSeedNo2(rArySeedNo, groupIdx) {
      var i = 0,
         len = 0;
      if (rArySeedNo == undefined || rArySeedNo == null) return false;
      len = rArySeedNo.length;

      for (i = 0; i < len; i++) {
         if (rArySeedNo[i][0] == groupIdx) return rArySeedNo[i][1];
      }

      return -1;
   }

   /* ==================================================================================
         seed Info, order Info를 가지고 tournament Info를 request한다. ( ajax call )
      ================================================================================== */
   function reqMakeTournament(strSeedInfo, nRound, userCnt)
   {
      var sel_val, cTitleIdx, cLevelIdx, cSex, cTeamGB, cPlayType, cGroupGameGB, aryVal;
      sel_val = ctx.getSelectVal("sel_GameKind");  
      
      aryVal = sel_val.split(",");
      if(aryVal.length != 6)
      {
         alert("종별 데이터에 문제가 있습니다.");
         return; 
      }

      cTitleIdx      = aryVal[0];
      cLevelIdx      = aryVal[1];
      cSex           = aryVal[2];
      cTeamGB        = aryVal[3];
      cPlayType      = aryVal[4];
      cGroupGameGB   = aryVal[5];

      var strLog = utx.strPrintf("onSelGameKind sel_val = {0}, titleIdx = {1}, levelIdx = {2}, cSex = {3}, cTeamGB = {4}, cPlayType = {5}, cGroupGameGB = {6}", 
                     sel_val, cTitleIdx, cLevelIdx, cSex, cTeamGB, cPlayType, cGroupGameGB);
      
      console.log(strLog);     
      
      
      var packet = {};
      console.log("reqMakeTournament  GameTitleMenu/lotteryElite_MakeTournament_test.asp");

      var Url ="../ajax/lotteryElite_MakeTournament.asp"
      packet.CMD = CMD_ELITEMAKETOURNAMENT;
      packet.TIDX = cTitleIdx;
      packet.LVIDX = cLevelIdx;
      packet.PLAYTYPE = cPlayType;  
      packet.SEEDINFO = strSeedInfo;
      packet.ROUND = nRound;
      packet.USERCNT = userCnt;
      packet.GROUPGGB = cGroupGameGB;

      SendPacket(Url, packet);
   }

   
   /* ==================================================================================
         예선 버튼 
      ================================================================================== */
   function onBtnQTournament()
   {      
      console.log("onBtnQTournament");
      ctx.addClassElement("btn_QTournament", "s_active");
      ctx.removeClassElement("btn_FTournament", "s_active");

      ctx.showElementEx("cls_QTournament", true);
      ctx.showElementEx("cls_FTournament", false);

      // reset select id
      SetSelTourBlock(gSelID, "");
      gSelID = "";

      gSelPart = E_PART_Q;
   }

   /* ==================================================================================
         본선 버튼 
      ================================================================================== */
   function onBtnFTournament()
   {      
      console.log("onBtnFTournament");
      ctx.addClassElement("btn_FTournament", "s_active");
      ctx.removeClassElement("btn_QTournament", "s_active");

      ctx.showElementEx("cls_QTournament", false);
      ctx.showElementEx("cls_FTournament", true);

      // reset select id
      SetSelTourBlock(gSelID, "");
      gSelID = "";

      gSelPart = E_PART_F;
   }

   /* ==================================================================================
         시드 랜덤 적용 Check Box 
      ================================================================================== */
      function onChkApplySeed(ctrl_id)
      {         
         // if(ctx.IsSelectCheckbox(ctrl_id)) ctx.setCheckboxVal(ctrl_id, false); 
         // else ctx.setCheckboxVal(ctrl_id, true); 

         var strLog = utx.sprintf("onChkApplySeed {0} = {1}" , ctrl_id, ctx.IsSelectCheckbox(ctrl_id) ? "Check" : "UnCheck"); 
         console.log(strLog); 
      }

   /* ==================================================================================
         Check Box 선택시 이전 체크를 모두 지우고 , 
         현재 체크된 Check Box id 보다 작거나 같은 모든 check Box를 check한다.  - 기획팀 요구사항 
      ================================================================================== */
      function onChkRank(ctrl)
      {
         var ctrl_id = "", id_base = "chk_rank"; 
         clearCheckRank();

         for(var i = 0; i<ctrl.value; i++)
         {
            ctrl_id = id_base + (i+1);
            ctx.setCheckboxVal(ctrl_id, true);
         }
         console.log("checked " + ctrl.id + ", " + ctrl.value);
      }

   /* ==================================================================================
         같은 class id로 되어 있는 CheckBox의 체크상태를 모두 지운다.  
      ================================================================================== */
      function clearCheckRank()
      {
         ctx.setCheckboxValCID("cls_chkRank", false);
      }

   /* ==================================================================================
         선택배정에서 Check값을 가지고 Rank를 결정한다. 
         check box id는 chk_rank (1~6) 6개 이다. 
      ================================================================================== */
   function getCheckedRank()
   {
      var ctrl_id = "", id_base = "chk_rank"; 
      var sel_rank = 0, sel = 0; 

      for(var i = 6; i > 0; i--)  
      {
         ctrl_id = id_base + (i);
         if(ctx.IsSelectCheckbox(ctrl_id))
         {
            sel = i; 
            break;  
         }
      }

      switch(sel)
      {
         case 1: sel_rank = 1; break; 
         case 2: sel_rank = 2; break; 
         case 3: sel_rank = 3; break; 
         case 4: sel_rank = 4; break; 
         case 5: sel_rank = 8; break; 
         case 6: sel_rank = 16; break; 
      }

      return sel_rank; 
   }

   function onClickMsg1_OK()
   {
      console.log("onClickMsg1_OK");
      msgbox_hide("modal-one");
   }

   function onClickMsg2_OK()
   {
      console.log("onClickMsg2_OK");
      msgbox_hide("modal-tow");
   }

   function onClickMsg2_Cancel()
   {
      console.log("onClickMsg2_Cancel");
      msgbox_hide("modal-tow");
   }

   function onClickMsg3_OK()
   {
      console.log("onClickMsg3_OK");
      msgbox_hide("modal-three");
   }

   function onClickMsg4_OK(nPos)
   {
      var strLog ; 
      var strUser, strGroupIdx, QNum, nSeed = 0;

      strUser = ctx.getTextboxVal("txt_manual_search"); 
		// strGroupIdx = utx.getBlockData(strUser, "-", "");
		strGroupIdx = utx.getBlockData(strUser, "#", "");

		if(ctx.IsSelectCheckbox('check_seed')) nSeed = ctx.getTextboxVal('check_seed_txt'); 

      strLog = utx.sprintf("onClickMsg4_OK - {0} {1} {2}", nPos, strUser, strGroupIdx); 
      console.log(strLog);

      msgbox_hide("modal-four");

		if(gSelQPos != 1) {		// 1: 예선조 배정 설정이 되어 있지 않으면
      if(strUser == "" || strGroupIdx == "") return; 
		}

		if(gSelPart == E_PART_Q) {
			applyMenualSel(gAryQPos, gAryGameUser, strGroupIdx, nPos);
      	createQTournament(gAryQPos);
			$('#div_QTournament_body').scrollTop(gSelQScrollPos);
		}
		else {		// 본선에는 수동 배정시 0: 일반 학생, 1: 예선조 배정
			if(gSelQPos == 0) {
				applyMenualSel(gAryPos, gAryGameUser, strGroupIdx, nPos, nSeed);
			}
			else {
				QNum = ctx.getSelectVal('select_search');
				applyMenualQSel(gAryPos, gAryGameUser, QNum, nPos);
			}
      	createTournament(gAryPos);

			gSelQPos = 0;
		}


   }

	function onChangeInput(type){
		gSelQPos = type;

		if (type == 0) {
			$("#txt_manual_search").show();
			$("#check_seed_box").show();
			$("#select_search").hide();
			$("#check_seed").attr('checked', false);
			$("#check_seed_txt").val('').attr('disabled', true);
		} else {
			$("#select_search").show();
			$("#txt_manual_search").hide();
			$("#check_seed_box").hide();
		}
	}
	function onChangeCheckbox(e){
		if (e.target.checked) {
			$("#check_seed_txt").attr('disabled', false);
		} else {
			$("#check_seed_txt").val('').attr('disabled', true);
		}
   }

/* ==================================================================================
      선택배정에서 Check값을 가지고 Rank를 결정한다. 
      check box id는 chk_rank (1~6) 6개 이다. 
   ================================================================================== */
   function onSelRadioSearchKind(selKind)
   {
      ctx.setTextboxVal("txt_manual_search", "");
      if(selKind == 1) {
         ctx.showElement("txt_manual_search", true); 
         ctx.showElement("sel_QGroup", false); 
         $("#txt_manual_search").autocomplete({source: gAryMUser});
      }
      else if(selKind == 2) {
         ctx.showElement("txt_manual_search", true); 
         ctx.showElement("sel_QGroup", false); 
         $("#txt_manual_search").autocomplete({source: gAryMTeamUser});
      }
      else if(selKind == 3) {         
         ctx.showElement("txt_manual_search", false); 
         ctx.showElement("sel_QGroup", true); 
         ctx.setSelectVal("sel_QGroup", "Q0"); 
      }
   }

   /* ==================================================================================
         엔트리 리스트 - Ranker Info Display - Single - 
      ================================================================================== */
   function onClickRankerInfo(memIdx)
   {      
      // this.event.stopPropagation(); 
     // this.stopPropagation(); 
      var strLog = utx.strPrintf("onClickRankerInfo memIdx = {0}", memIdx); 
      console.log(strLog);      

      var strInfo, strPlayer, strTeam, strOrder, aryInfo; 
      strInfo = GetRankerInfo(gAryGameUser, memIdx); 
      if(strInfo == "") return; 

      aryInfo = strInfo.split(","); 
      strPlayer = aryInfo[0]; 
      strTeam = aryInfo[1]; 
      strOrder = aryInfo[2]; 

      MsgBoxRanker(strPlayer, strTeam, gSelGameKind, strOrder);
   }

   function onClickEditRankerInfo()
   {
      this.event.stopPropagation();      
   }

   /* ==================================================================================
         엔트리 리스트 - Ranker Info Display - Double
      ================================================================================== */
   function onClickRankerInfoDbl(memIdx1, memIdx2)
   {      
      var strLog = utx.strPrintf("onClickRankerInfoDbl memIdx1 = {0}, memIdx2 = {1}", memIdx1, memIdx2); 
      console.log(strLog);
      
      var strInfo, strPlayer, strTeam, strOrder, aryInfo; 
      strInfo = GetRankerInfoDbl(gAryGameUser, memIdx1); 
      if(strInfo == "") return; 

      aryInfo = strInfo.split(","); 
      strPlayer = aryInfo[0]; 
      strTeam = aryInfo[1]; 
      strOrder = aryInfo[2]; 

      MsgBoxRanker(strPlayer, strTeam, gSelGameKind, strOrder);
   }

</script>

<script>
   // **********************************************************************************
   //       
   // **********************************************************************************   

   /* ==================================================================================
      tonament block select시 호출 

      예선조 / 본선조 에서 위치 교환
      1. 현재 Tournament List가 예선조인지 본선인지를 구분 - gSelPart (E_PART_Q, E_PART_F)
      2. 이전 선택값과 현재 선택값으로 선택 데이터 추출 - gSelID, sel_id
      2-1. 선택 id에서 실질적인 구분값 추출 - Q 이면 QGroupNo, 일반cell이면 playerCode
      2-2. QGroupNo를 가지고 정보를 추출    - ary에서의 Idx
      2-3. playerCode를 가지고 정보를 추출    - ary에서의 Idx
      3. 교환을 할 것인지 묻는 confirm box
      4. 교환을 한다고 선택 하면 ary에서 상호 데이터 swap
      5. tournament 다시 생성
   ================================================================================== */ 
   function onSelMatch(sel_no, sel_spVal, sel_pCode, sel_id)
   {
      if(gSelManual == true) 
      {
         return onSelMatchManual(sel_no, sel_spVal, sel_pCode, sel_id);
      }
      
      var strLog, ret, nQGroup = -1; 

      strLog = utx.sprintf("sel_no = {0}, sel_spVal = {1}, sel_pCode = {2}, sel_id = {3}", sel_no, sel_spVal, sel_pCode, sel_id)
      console.log(strLog);      

      // Bye는 swap을 하지 않는다. 
      if(sel_pCode == "BYE") {
         alert("Bye는 교환을 할수 없습니다."); 
         return; 
      }

      // Seed는 swap을 하지 않는다. / Q일 경우 예선조 Info MsgBox를 띄운다. 
      if(sel_spVal != "" && sel_spVal != " ") {
         if(sel_spVal.indexOf("Q") == -1) {
				if(confirm("시드를 선택하셨습니다. 교환하시겟습니까?") == false) return; 
            // alert("시드는 교환을 할수 없습니다."); 
            // return; 
         }
         else {
            nQGroup = utx.getBlockData(sel_spVal, "Q", ""); 
            MsgBoxQList(gAryQPos, nQGroup, gPlayType); 
         }
      }      

      if(gSelID != "")
      {
         // 동일한 Cell은 교환하지 않는다. 
         if(gSelID == sel_id){
            //alert("자기자신과는 교환을 할수 없습니다."); 
            return; 
         }
         
         ret = swapUser(gSelID, sel_id);
         // reset select id
         SetSelTourBlock(gSelID, "");
         gSelID = "";
         if(ret == 1){                        
            return; 
         } 
         else {
            return; 
         }
      } 
      SetSelTourBlock(gSelID, sel_id);
      gSelID = sel_id;    
      
      return true; 
   }

   /* ==================================================================================
      tonament block select시 호출 

      예선조 / 본선조 에서 위치 교환
      1. 현재 Tournament List가 예선조인지 본선인지를 구분 - gSelPart (E_PART_Q, E_PART_F)
      2. 이전 선택값과 현재 선택값으로 선택 데이터 추출 - gSelID, sel_id
      2-1. 선택 id에서 실질적인 구분값 추출 - Q 이면 QGroupNo, 일반cell이면 playerCode
      2-2. QGroupNo를 가지고 정보를 추출    - ary에서의 Idx
      2-3. playerCode를 가지고 정보를 추출    - ary에서의 Idx
      3. 교환을 할 것인지 묻는 confirm box
      4. 교환을 한다고 선택 하면 ary에서 상호 데이터 swap
      5. tournament 다시 생성
   ================================================================================== */ 
   function onSelMatchManual(sel_no, sel_spVal, sel_pCode, sel_id)
   {
      var strLog, ret; 

      strLog = utx.sprintf("sel_no = {0}, sel_spVal = {1}, sel_pCode = {2}, sel_id = {3}", sel_no, sel_spVal, sel_pCode, sel_id)
      console.log(strLog);      

      if(sel_pCode == "BYE") return; 
      
		gSelQScrollPos = $('#div_QTournament_body').scrollTop();


      SetSelTourBlock(gSelID, sel_id);
      gSelID = sel_id; 
      
      ctx.setTextboxVal("txt_manual_search", ""); 
      MsgBoxSearchPlayerEx(sel_no);
      // 수동 입력시 사용하는 입력박스 연동 . 
      $("#txt_manual_search").autocomplete({source: gAryMenual});
      
		// 수동 입력시 사용하는 Select 연동 .
		$("#select_search option").remove();
		var strOption;
		for(i=0; i<gQGroupNum; i++)
		{
			strOption = utx.sprintf("<option value='{0}'>예선 {1}조</option>",(i+1), (i+1));
			// $("#select_search").append("<option value='"+(i+1) + "'>" + (i+1) + "</option>");
			$("#select_search").append(strOption);
		}

      return true; 
   }


   /* ==================================================================================
      Tournament user swap
   ================================================================================== */ 
   function swapUser(sel1, sel2)
   {
      var sel_Idx1, sel_Idx2, playerCode1, playerCode2;
      var strLog; 

      playerCode1 = utx.getBlockData(sel1, "pid_", "");
      playerCode2 = utx.getBlockData(sel2, "pid_", "");

      strLog = utx.sprintf("swapUser sel1 = {0}, playerCode1 = {1}, sel2 = {2}, playerCode2 = {3}", sel1, playerCode1, sel2, playerCode2);
      console.log(strLog);

      if(gSelPart == E_PART_Q){              // 예선을 선택 하고 있다면.. 
         return swapQUser(playerCode1, playerCode2);
      }
      else if(gSelPart == E_PART_F){         // 본선을 선택하고 있다면.. 
         return swapTUser(playerCode1, playerCode2);
      }      
   }

   /* ==================================================================================
      본선 Tournament user swap
   ================================================================================== */ 
   function swapTUser(playerCode1, playerCode2)
   {
      var nQNo = 0, nSel1 = 0, nSel2 = 0, IsDblPlay; 
      var strInfo1, strInfo2, strConfirm;

      IsDblPlay = bmx.IsDoublePlay(gPlayType);

      if(playerCode1.indexOf("qno_") != -1)
      {
         nQNo = utx.getBlockData(playerCode1, "qno_", "");
         nSel1 = GetIdxAryPosWithQNo(gAryPos, nQNo);
      }
      else nSel1 = GetIdxAryPos(gAryPos, playerCode1);

      if(playerCode2.indexOf("qno_") != -1)
      {
         nQNo = utx.getBlockData(playerCode2, "qno_", "");
         nSel2 = GetIdxAryPosWithQNo(gAryPos, nQNo);
      }
      else nSel2 = GetIdxAryPos(gAryPos, playerCode2);

      if(IsDblPlay == 1){
         if(gAryPos[nSel1][2] == E_POS_Q) strInfo1 = utx.sprintf("Q ({0}조)", gAryPos[nSel1][3]);
         else strInfo1 = utx.sprintf("{0}({1})/{2}({3})", gAryPos[nSel1][7], gAryPos[nSel1][11], gAryPos[nSel1][9], gAryPos[nSel1][13]);

         if(gAryPos[nSel2][2] == E_POS_Q) strInfo2 = utx.sprintf("Q ({0}조)", gAryPos[nSel2][3]);
         else strInfo2 = utx.sprintf("{0}({1})/{2}({3})", gAryPos[nSel2][7], gAryPos[nSel2][11], gAryPos[nSel2][9], gAryPos[nSel2][13]);
      }
      else {
         if(gAryPos[nSel1][2] == E_POS_Q) strInfo1 = utx.sprintf("Q ({0}조)", gAryPos[nSel1][3]);
         else strInfo1 = utx.sprintf("{0}({1})", gAryPos[nSel1][7], gAryPos[nSel1][9]);

         if(gAryPos[nSel2][2] == E_POS_Q) strInfo2 = utx.sprintf("Q ({0}조)", gAryPos[nSel2][3]);
         else strInfo2 = utx.sprintf("{0}({1})", gAryPos[nSel2][7], gAryPos[nSel2][9]);
      }

      strConfirm = utx.sprintf("{0} 와 {1}의 위치를\r\n바꾸시겠습니까?\r\n예선조 승자가 있을 경우 예선조까지 고려하시기 바랍니다.", strInfo1, strInfo2);

      if(confirm(strConfirm))
      {
         utx.SwapRows(gAryPos, nSel1, nSel2);
         createTournament(gAryPos);
         return 1; 
      }
      return 0; 
   }

   /* ==================================================================================
      예선 Tournament user swap
   ================================================================================== */ 
   function swapQUser(playerCode1, playerCode2)
   {
      var nQNo = 0, nSel1 = 0, nSel2 = 0, IsDblPlay; 
      var strInfo1, strInfo2, strConfirm;

      IsDblPlay = bmx.IsDoublePlay(gPlayType);

      nSel1 = GetIdxAryPos(gAryQPos, playerCode1);
      nSel2 = GetIdxAryPos(gAryQPos, playerCode2);

      if(IsDblPlay == 1){
         strInfo1 = utx.sprintf("{0}({1})/{2}({3})", gAryQPos[nSel1][7], gAryQPos[nSel1][11], gAryQPos[nSel1][9], gAryQPos[nSel1][13]);
         strInfo2 = utx.sprintf("{0}({1})/{2}({3})", gAryQPos[nSel2][7], gAryQPos[nSel2][11], gAryQPos[nSel2][9], gAryQPos[nSel2][13]);
      }
      else {
         strInfo1 = utx.sprintf("{0}({1})", gAryQPos[nSel1][7], gAryQPos[nSel1][9]);
         strInfo2 = utx.sprintf("{0}({1})", gAryQPos[nSel2][7], gAryQPos[nSel2][9]);
      }

      strConfirm = utx.sprintf("{0} 와 {1} 의\r\n위치를 바꾸시겠습니까?\r\n본선 토너먼트까지 고려하시기 바랍니다.", strInfo1, strInfo2);

      if(confirm(strConfirm))
      {
         utx.SwapRows(gAryQPos, nSel1, nSel2);
         createQTournament(gAryQPos);
         return 1; 
      }
      return 0; 
   }

   /* ==================================================================================
      player Code를 가지고 aryPos에서 해당 Idx를 찾는다. 
   ================================================================================== */ 
   function GetIdxAryPos(rAryPos, playerCode)
   {
      var i, len = 0; 

      if(!utx.Is2DArray(rAryPos)) return -1;  
      len = rAryPos.length; 

      for(i = 0; i < len; i++)
      {
         if(rAryPos[i][4] == playerCode) return i; 
      }

      return -1; 
   }

   /* ==================================================================================
      Q No를 가지고 aryPos에서 해당 Idx를 찾는다. 
   ================================================================================== */ 
   function GetIdxAryPosWithQNo(rAryPos, nQNo)
   {
      var i, len = 0; 

      if(!utx.Is2DArray(rAryPos)) return -1;  
      len = rAryPos.length; 

      for(i = 0; i < len; i++)
      {
         if(rAryPos[i][3] == nQNo) return i; 
      }

      return -1; 
   }

/* ==================================================================================
      aryQPos을 받아서 예선 토너먼트를 생성한다. 
   ================================================================================== */
   function createQTournament(rAryPos)
   {    
      var i, j, nQGroup, nQGroupSize = 4, IsDblPlay = 1, len = 0;
      var id_base = "div_QTournament", id_divQ, id_divQInfo, id_parent = "div_QTournament_body";
      var tournamentQ = null, roundQ = 4, strQGroup = "";
      var aryData, nOrder = 0, IsFinal = 0; 

      reset2DAryField(rAryPos, 0, "0"); 
      //// utx.printInfo2DAry(rAryPos, "In createQTournament");

      aryData = new Array(); 
      IsDblPlay = bmx.IsDoublePlay(gPlayType);

      len = rAryPos.length; 
      nQGroup = len / nQGroupSize; 

      ctx.writeHtmlToDiv(id_parent, "");     
      
      for(i = 0; i< nQGroup; i++)
      {
         id_divQInfo = utx.strPrintf("{0}_info{1}", id_base, i+1);
         id_divQ = utx.strPrintf("{0}{1}", id_base, i+1);
         createDivForTonament(id_parent, id_divQ, id_divQInfo);
         strQInfo = GetStrGInfoQSub(i+1); 
         ctx.appendHtmlToDiv(id_divQInfo, strQInfo);
         aryData[i] = new Array(); 
      }

      // 예선조가 1개 이고,  인원이 2명이면 예선조를 결승으로 바꾼다. 
      IsFinal = IsFinalQTournament(rAryPos);
      if(IsFinal) {
         roundQ = 2; 

         if(gGroupGameGB == "B0030001")         // 개인전 
         {
            obj = fillUserInfo(0, rAryPos[0], rAryPos[3], IsDblPlay);
         }
         else if(gGroupGameGB == "B0030002")    // 단체전 
         {
            obj = fillTeamUserInfo(0, rAryPos[0], rAryPos[3], IsDblPlay);
         }
         aryData[nOrder].push(obj) 
      }
      else {
         for(i = 0; i< len; i+=2)
         {
            if(i && i%nQGroupSize == 0) nOrder++;

            if(gGroupGameGB == "B0030001")         // 개인전 
            {
               obj = fillUserInfo(i, rAryPos[i], rAryPos[i+1], IsDblPlay);
            }
            else if(gGroupGameGB == "B0030002")    // 단체전 
            {
               obj = fillTeamUserInfo(i, rAryPos[i], rAryPos[i+1], IsDblPlay);
            }
            aryData[nOrder].push(obj)           
         }
      }

      for(i = 0; i< nQGroup; i++)
      {
         id_divQ = utx.strPrintf("{0}{1}", id_base, i+1);
         tournamentQ = makeTournament2(id_divQ, roundQ, IsDblPlay);
         drawTournament2(tournamentQ, roundQ, roundQ, roundQ, aryData[i]);
      }
   }

/* ==================================================================================
      예선조가 결승인지를 체크 / // 예선조가 1개 이고,  인원이 2명이면 예선조를 결승으로 바꾼다. 
   ================================================================================== */ 
   function IsFinalQTournament(rAryQ)
   {
      var IsFinal = 0, nQGroupSize = 4, len = 0;
      len = rAryQ.length;

      // 예선조가 1개 이고,  인원이 2명이면 예선조를 결승으로 바꾼다. 
      if(len == nQGroupSize) 
      {
         if(rAryQ[1][2] ==  E_POS_BYE && rAryQ[2][2] ==  E_POS_BYE)
         {
            IsFinal = 1; 
         }        
      }

      return IsFinal; 
   }

/* ==================================================================================
      각 예선전 Sub Title String을 얻는다. 
   ================================================================================== */ 
   function GetStrGInfoQSub(nQOrder)
   {
      var strQInfo; 
      var strInfo = utx.sprintf("<p><strong>[예선 {0}조] </strong></p>", nQOrder);
      return strInfo; 
   }

/* ==================================================================================
      aryPos을 받아서 본선 토너먼트를 생성한다. 
   ================================================================================== */
   function createTournament(rAryPos) 
   {
      var aryData, i = 0, len = 0, obj, IsDblPlay = 1, round = 0, round_kind = 0, cur_round = 0;
      var f_tournament;
      aryData = new Array();      

      round = rAryPos.length; 
      IsDblPlay = bmx.IsDoublePlay(gPlayType);

      reset2DAryField(rAryPos, 0, "0"); 
      if(gSelManual == false) checkDuplicateTeam(rAryPos); 

      //// utx.printInfo2DAry(rAryPos, "In createTournament");

      for(i = 0; i< round; i+=2)
      {         
         if(gGroupGameGB == "B0030001")         // 개인전 
         {
            obj = fillUserInfo(i, rAryPos[i], rAryPos[i+1], IsDblPlay);
         }
         else if(gGroupGameGB == "B0030002")    // 단체전 
         {
            obj = fillTeamUserInfo(i, rAryPos[i], rAryPos[i+1], IsDblPlay);
         }
         aryData.push(obj)  
      }

      f_tournament = makeTournament2("div_FTournament", round, IsDblPlay);
      drawTournament2(f_tournament, round, round, round, aryData);
   }


/* ==================================================================================
   make Tonament - div id를 입력받아 tonament Object을 생성하고 , 반환한다.
================================================================================== */
function makeTournament2(id_div, round, IsDblPlay) {
	 var tournament = new Tournament();
	 var nScale = 1, nBlockHeight = 48, pos_info = 0;
	 var nFirstBoarderGap = 0, nBoardWidth = 0;

	 if(IsDblPlay == 1)
      {
         nBlockHeight = 48;
			nFirstBoarderGap = 320, nBoardWidth = 60;
      }
      else
      {
         nBlockHeight = 48;
			nFirstBoarderGap = 320, nBoardWidth = 60;
		}

    tournament.setOption({
		  blockBoardWidth: nBoardWidth, // integer board 너비
		  blockBoardWidthFirst: nFirstBoarderGap, // integer board 너비
        blockBranchWidth: 30, // integer 트리 너비
        blockHeight : nBlockHeight, // integer 블럭 높이(board 간 간격 조절)
        branchWidth: 2, // integer 트리 두께
        branchColor: '#dddddd', // string 트리 컬러
        // branchColor : '#000000', // string 트리 컬러
        roundOf_textSize: 14, // integer 배경 라운드 텍스트 크기
        scale: nScale, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
        board: true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
        el: document.getElementById(id_div) // element must have id
    });


    tournament.setStyle('#' + id_div);

    tournament.boardInner = function(data) {
        if (data && data.bDblPlay == 1) return boardInner_Double(data);
        return boardInner_single(data);
    }
    return tournament;
}


/* ==================================================================================
      4개 cell단위로 중복 체크  ( teamOrder중복을 체크한다.  중복이면 fUse = 1 로 set)
   ================================================================================== */
   function checkDuplicateTeam(rAry){
      var i = 0, len = 0, szBlock = 4; 

      if(!utx.Is2DArray(rAry)) return; 

      len = rAry.length; 
      for(i=0; i<len; i += szBlock)
      {
         checkBlockTeam(rAry, i, szBlock); 
      }
   }

   function checkBlockTeam(rAry, sp, szBlock)
   {
      var j = 0, i = 0, ep = sp + szBlock, val;
      var strLog = "", q_pos = -1, q_group = -1; 

      //strLog = utx.sprintf("------------ checkBlockTeam ---------- ({0}, {1}", sp, szBlock); 
      //console.log(strLog); 

      // compare Q cell 
      for(i=sp; i<ep; i++){
         if(rAry[i][2] == E_POS_Q) {
            q_pos = i; 
            q_group = rAry[i][3]; 
         }
      }

      if(q_pos != -1) {
         for(i=sp; i<ep; i++){
            if(i != q_pos)
            {
               val = rAry[i][5]; 
               if(checkQGroup(q_group, val)) {
                  if(rAry[q_pos][0] != 1) rAry[q_pos][0] = 1; 
                  rAry[i][0] = 1;   
               }
            }
         }
      }

      // compare normal cell 
      for(i=sp; i<ep-1; i++){
         val = rAry[i][5]; 
         for(j = i+1; j < ep; j++)
         {
            //strLog = utx.sprintf("({0}, {1}", i, j); 
            //console.log(strLog); 
            if(rAry[j][0] != 1 && rAry[i][2] != E_POS_BYE && val == rAry[j][5])     // Bye가 아니고 TeamOrder가 중복 된다면.. 
            {
               if(rAry[i][0] != 1) rAry[i][0] = 1; 
               rAry[j][0] = 1; 
            }
         }
      }

      //strLog = "------------ checkBlockTeam ---------- "; 
      //console.log(strLog); 
   }

/* ==================================================================================
      Q Group의 Team code도 체크한다. 
   ================================================================================== */
   function checkQGroup(nQGroup, teamCode){
      var i = 0, len = 0, sp = 0, ep = 0; 

      if(!utx.Is2DArray(gAryQPos)) return; 

      len = gAryQPos.length; 
      sp = (nQGroup-1) * 4; 
      ep = sp + 4; 

      for(i=sp; i<ep; i++)
      {
         if(gAryQPos[i][5] == teamCode) return true; 
      }

      return false; 
   }


/* ==================================================================================
      reset ary field - nPos 번째 filed를 val 로 Reset한다. 
   ================================================================================== */
   function reset2DAryField(rAry, nPos, resetVal){
      var i = 0, len = 0; 

      if(!utx.Is2DArray(rAry)) return; 

      len = rAry.length; 
      for(i=0; i<len; i++)
      {
         if(rAry[i][nPos] == undefined) return; 
         rAry[i][nPos] = resetVal; 
      }
   }

/* ==================================================================================
      tournament에 사용할 data object을 만든다.
   ================================================================================== */
   function fillTeamUserInfo(Idx, l_info, r_info, IsDblPlay)
   {
      var obj = {};

      // i, i+1을 합쳐서 하나의 Obj을 만들므로 기본 셋팅은 i%2=0에서 한번만
      obj.matchNo    =  Idx / 2;
      obj.bDblPlay   =  IsDblPlay;
      obj.l_fill     =  true;
      obj.l_sel      =  false;
      obj.l_dup      =  false;
      obj.r_fill     =  true;
      obj.r_sel      =  false;
      obj.r_dup      =  false;
      obj.l_pcode    = l_info[4];
      obj.r_pcode    = r_info[4];
      obj.l_spVal    =  " ";
      obj.r_spVal    =  " ";

      if(l_info[0] == 1) obj.l_dup = true;
      if(r_info[0] == 1) obj.r_dup = true;

      // Bye position
      if(l_info[2] == E_POS_BYE) {
         obj.l_player   =  "BYE";
         obj.l_team     =  "";
         obj.l_pcode    = "BYE";
      }
      else if(l_info[2] == E_POS_MANUAL) {      // Manual pos
         obj.l_player   =  " ";
         obj.l_team     =  "";
         obj.l_pcode    = utx.sprintf("E_POS_MANUAL_{0}", Idx);
      }
      else if(l_info[2] == E_POS_Q) {
         obj.l_player   =  "Q";
         obj.l_team     =  utx.sprintf("({0}조)", l_info[3]);
         obj.l_pcode    = utx.sprintf("qno_{0}", l_info[3]);

         obj.l_spVal    =  utx.sprintf("Q{0}", l_info[3]);
      }
      else
      {
         if(l_info[2] == E_POS_SEED) obj.l_spVal      =  getStrSeed(l_info[3]);
         obj.l_player   =  (IsDblPlay == 0)? l_info[7] : utx.sprintf("{0},{1}",l_info[7], l_info[9]);
         obj.l_team     =  (IsDblPlay == 0)? bmx.GetSimpleTeamName(l_info[9]) : utx.sprintf("{0},{1}",bmx.GetSimpleTeamName(l_info[11]), bmx.GetSimpleTeamName(l_info[13]));

         obj.l_player = bmx.GetSimpleTeamName(l_info[9]);
         obj.l_player = (utx.getBlockData(obj.l_player, "", "/") == "") ? obj.l_player : utx.getBlockData(obj.l_player, "", "/");
			
         if (l_info[6] != "" && l_info[6] != "0") obj.l_player = utx.sprintf("{0}-{1}", obj.l_player, l_info[6]);

         obj.l_team     =  "";
      }

      // Bye position
      if(r_info[2] == E_POS_BYE) {
         obj.r_player   =  "BYE";
         obj.r_team     =  "";
         obj.r_pcode    = "BYE";
      }
      else if(r_info[2] == E_POS_MANUAL) {     // Manual pos
         obj.r_player   =  " ";
         obj.r_team     =  "";
         obj.r_pcode    =  utx.sprintf("E_POS_MANUAL_{0}", Idx+1);
      }
      else if(r_info[2] == E_POS_Q) {
         obj.r_player   =  "Q";
         obj.r_team     =  utx.sprintf("({0}조)", r_info[3]);
         obj.r_pcode    = utx.sprintf("qno_{0}", r_info[3]);

         obj.r_spVal    =  utx.sprintf("Q{0}", r_info[3]);
      }
      else
      {
         if(r_info[2] == E_POS_SEED) obj.r_spVal      =  getStrSeed(r_info[3]);
         obj.r_player = bmx.GetSimpleTeamName(r_info[9]);
         obj.r_player = utx.getBlockData(obj.r_player, "", "/");

			obj.r_player = (utx.getBlockData(obj.r_player, "", "/") == "") ? obj.r_player : utx.getBlockData(obj.r_player, "", "/");
         if (r_info[6] != "" && r_info[6] != "0") obj.r_player = utx.sprintf("{0}-{1}", obj.r_player, r_info[6]);

         obj.r_team     =  "";
      }
      return obj;
   }

/* ==================================================================================
      tournament에 사용할 data object을 만든다. 
   ================================================================================== */
   function fillUserInfo(Idx, l_info, r_info, IsDblPlay)
   {
      var obj = {}; 

      // i, i+1을 합쳐서 하나의 Obj을 만들므로 기본 셋팅은 i%2=0에서 한번만       
      obj.matchNo    =  Idx / 2;
      obj.bDblPlay   =  IsDblPlay;               
      obj.l_fill     =  true;		 	
      obj.l_sel      =  false;         
      obj.l_dup      =  false; 
      obj.r_fill     =  true;
      obj.r_sel      =  false;
      obj.r_dup      =  false; 
      obj.l_pcode    = l_info[4];
      obj.r_pcode    = r_info[4];      
      obj.l_spVal    =  " ";    
      obj.r_spVal    =  " ";

      if(l_info[0] == 1) obj.l_dup = true; 
      if(r_info[0] == 1) obj.r_dup = true; 

      // Bye position 
      if(l_info[2] == E_POS_BYE) {
         obj.l_player   =  "BYE";
         obj.l_team     =  "";             
         obj.l_pcode    = "BYE";         
      }
      else if(l_info[2] == E_POS_MANUAL) {      // Manual pos
         obj.l_player   =  " ";
         obj.l_team     =  "";    
         obj.l_pcode    = utx.sprintf("E_POS_MANUAL_{0}", Idx);
      }
      else if(l_info[2] == E_POS_Q) {
         obj.l_player   =  "Q";
         obj.l_team     =  utx.sprintf("({0}조)", l_info[3]);          
         obj.l_pcode    = utx.sprintf("qno_{0}", l_info[3]);

         obj.l_spVal    =  utx.sprintf("Q{0}", l_info[3]);    
      }
      else
      {
         if(l_info[2] == E_POS_SEED) obj.l_spVal      =  getStrSeed(l_info[3]);  
         obj.l_player   =  (IsDblPlay == 0)? l_info[7] : utx.sprintf("{0},{1}",l_info[7], l_info[9]);
         obj.l_team     =  (IsDblPlay == 0)? bmx.GetSimpleTeamName(l_info[9]) : utx.sprintf("{0},{1}",bmx.GetSimpleTeamName(l_info[11]), bmx.GetSimpleTeamName(l_info[13]));      
         
         // obj.l_team     =  (IsDblPlay == 0)? l_info[9] : utx.sprintf("{0},{1}",l_info[11], l_info[13]);    
      }

      // Bye position 
      if(r_info[2] == E_POS_BYE) {
         obj.r_player   =  "BYE";
         obj.r_team     =  "";   
         obj.r_pcode    = "BYE";         
      }
      else if(r_info[2] == E_POS_MANUAL) {     // Manual pos
         obj.r_player   =  " ";
         obj.r_team     =  "";    
         obj.r_pcode    =  utx.sprintf("E_POS_MANUAL_{0}", Idx+1);
      }
      else if(r_info[2] == E_POS_Q) {
         obj.r_player   =  "Q";
         obj.r_team     =  utx.sprintf("({0}조)", r_info[3]);            
         obj.r_pcode    = utx.sprintf("qno_{0}", r_info[3]);

         obj.r_spVal    =  utx.sprintf("Q{0}", r_info[3]); 
      }
      else
      {
         if(r_info[2] == E_POS_SEED) obj.r_spVal      =  getStrSeed(r_info[3]);  
         obj.r_player   =  (IsDblPlay == 0)? r_info[7] : utx.sprintf("{0},{1}",r_info[7], r_info[9]);
         // obj.r_team     =  (IsDblPlay == 0)? r_info[9] : utx.sprintf("{0},{1}",r_info[11], r_info[13]);
         obj.r_team     =  (IsDblPlay == 0)? bmx.GetSimpleTeamName(r_info[9]) : utx.sprintf("{0},{1}",bmx.GetSimpleTeamName(r_info[11]), bmx.GetSimpleTeamName(r_info[13]));      
      }
      return obj; 
	 }

/* ==================================================================================
      Tournament Cell선택시 select 표시를 한다. 
   ================================================================================== */
   function SetSelTourBlock(prev_id, sel_id)
   {
      if(prev_id != "") ctx.removeClassElement(prev_id, 's_selected');

      if(sel_id != "") ctx.addClassElement(sel_id, 's_selected');
   }

/* ==================================================================================
      For Test - 예선 Tonament를 가변적으로 테스트 하기 위해서 만들었다. 
      Entry Count보다 적은 수를 입력하면 그 인원수로 List및 Tournament를 만든다. 
   ================================================================================== */
   function reduceAryUser(rAryUser)
   {
      var userCnt, modCnt, IsDblPlay, nMax;
      var i, len, aryUser;

      userCnt = Number(ctx.getTextboxVal("txt_entrycnt"));
      modCnt = Number(ctx.getTextboxVal("txt_reducecnt"));

      if(modCnt == 0 || modCnt >= userCnt ) return rAryUser;       
      
      IsDblPlay = bmx.IsDoublePlay(gPlayType);
      nMax = (IsDblPlay == 1) ? modCnt * 2 : modCnt; 

      aryUser = new Array(nMax); 

      for(i = 0; i<nMax; i++)
      {
         aryUser[i] = [];
         utx.CopyRows(rAryUser, aryUser, i, i);
      }

      // utx.printInfo2DAry(aryUser, "reduceAryUser");

      return aryUser; 
   }

/* ==================================================================================
      미리 보기를 누를 경우 새창으로 띄워준다. For Print
   ================================================================================== */
   function open_print(url, arg1, arg2, arg3, arg4, arg5, arg6, arg7){
      var frmPop= document.frmPopup;      
      window.open('',"pop_print");  

      frmPop.method = "Post";
      frmPop.action = url;
      frmPop.target = 'pop_print'; //window,open()의 두번째 인수와 같아야 하며 필수다.  
      frmPop.pos.value = arg1;
      frmPop.q_pos.value = arg2;  
		frmPop.game_num.value = arg3;
      frmPop.q_game_num.value = arg4;
      frmPop.playType.value = arg5;
      frmPop.groupGameGb.value = arg6;
      frmPop.gameInfo.value = arg7;
      frmPop.submit();  
   }

/* ==================================================================================
      배치확인을 누를 경우 새창으로 띄워준다. For Print
   ================================================================================== */
   function open_place(url, arg1, arg2, arg3){
      var frmPop= document.frmPlace;      
      window.open('',"pop_place");  

      frmPop.method = "Post";
      frmPop.action = url;
      frmPop.target = 'pop_place'; //window,open()의 두번째 인수와 같아야 하며 필수다.  
      frmPop.pos.value = arg1;
      frmPop.q_pos.value = arg2;  
      frmPop.reqUser.value = arg3;  
      frmPop.submit();  
   }

/* ==================================================================================
      수동 배정 버튼을 눌렀을 때 수행한다.  - 본선만 진행한다. 
      1. 적용 버튼을 누를때 대회명, 종별, 강수는 선택 되어 있어야 한다. 
      2. 적용 버튼을 누르면 자동으로 빈 배열 aryPos, aryQPos을 생성한다 
         2-1. aryPos, aryQPos에 빈 배열값 E_POS_MANUAL을 할당 한다 .
         2-2. aryPos, aryQPos에 Bye가 존재할 경우 Bye를 셋팅한다. 
         2-3. 데이터 입력 박스에 적용할 aryData를 aryReq에서 추출하여 만든다. 
         2-4. aryData를 autoComplete에 적용한다. 
   ================================================================================== */
   function ManualApplyList(rAryGameUser, gPlayType)
   {
      var nMaxUser, nUserCnt, IsDblPlay, selRound;
		var nMaxQGroup, nQGroup, nDiff, strMsg, nQRow, nCol;
		var nTourUser, nQUser

      selRound = Number(ctx.getSelectVal("sel_round"));  
      IsDblPlay = bmx.IsDoublePlay(gPlayType);

      gAryPos = null;                 // Tonament 참가자 배치 Position Array      
		
      nUserCnt = rAryGameUser.length; 
      nUserCnt = (IsDblPlay == 1) ? (nUserCnt) / 2 : (nUserCnt); 
      
      // if(nUserCnt > selRound) {
        //  strMsg = "수동 배정은 본선만 진행합니다. ";
        //  alert(strMsg); 
        //  return; 
      // }

      if(selRound == 0) 
      {
         alert("토너먼트 강수를 선택하셔야 합니다.");
         return; 
      }

		ResetDisplaySet(E_RESET_LV1);

		// 선택한 강수보다 참가신청수가 많으면 예선전을 만든다.
		if(nUserCnt > selRound) {
			nDiff = nUserCnt - selRound;
			nQGroup = (nDiff % 3) ? Math.floor(nDiff/3) + 1 : Math.floor(nDiff/3);

			nTourUser = selRound - nQGroup;
			nQUser = nUserCnt - nTourUser;

			gQGroupNum = nQGroup;

			//. rAryQPos을 구한다.
			gAryQPos = makeEmptyQAryPos(nQGroup, IsDblPlay);
			applyByeToQPos(gAryQPos, nQUser);
			createQTournament(gAryQPos);
		}
			
			if(nUserCnt > selRound) nUserCnt = selRound; 

      gAryPos = makeEmptyAryPos(selRound, IsDblPlay); 
      applyByeToPos(gAryPos, nUserCnt); 

      createTournament(gAryPos); 
      gAryMenual = createAryMenual(rAryGameUser, IsDblPlay); 

		len = gAryMenual.length;
		var strLog = utx.sprintf("gAryMenual len = {0}, selRound = {1}, nQGroup = {2}", len, selRound, nQGroup);
		console.log(strLog);


		// 초기화 
		gAryGameNo = null; 					// Tournament Game Num을 셋팅한다. 
		gAryQGameNo = null; 				// 예선 Tournament Game Num을 셋팅한다. 
   }

/* ==================================================================================
      수동입력시 에디트 박스에 나타나는 User이름 배열 
   ================================================================================== */
   function createAryMenual(rAryGameUser, IsDblPlay) {
      var i , len, pos, step = 1, strData, aryMenual; 
      len = rAryGameUser.length;
      if(IsDblPlay == 1) step = 2;       
      aryMenual = []; 

			// utx.printInfo2DAry(rAryGameUser, "createAryMenual - rAryGameUser"); 

			if(gGroupGameGB == "B0030002")    // 단체전 
			{
				for(i = 0; i< len; i += step)
				{
					strData = utx.sprintf("{0}({1})#{2}", rAryGameUser[i][9], rAryGameUser[i][8], rAryGameUser[i][6]);
					aryMenual.push(strData); 
				}
			}
			else {
				for(i = 0; i< len; i += step)
				{
					if(IsDblPlay == 1) {
							strData = utx.sprintf("{0}({1})/{2}({3})#{4}",
								rAryGameUser[i][9], rAryGameUser[i][11], rAryGameUser[i+1][9], rAryGameUser[i+1][11], rAryGameUser[i][6]);
					}
					else {
							strData = utx.sprintf("{0}({1})#{2}", rAryGameUser[i][9], rAryGameUser[i][11], rAryGameUser[i][6]);
					}
					aryMenual.push(strData); 
				}
			}
      
			// utx.printInfo2DAry(rAryGameUser, "createAryMenual - rAryGameUser");
			// utx.printInfo2DAry(aryMenual, "aryMenual - rAryGameUser");


      return aryMenual; 
   }

/* ==================================================================================
      수동 배정용 빈 배열을 만든다. 
   ================================================================================== */
   function makeEmptyAryPos(nRow, IsDblPlay) {
      var aryPos, i = 0, nCol;
      nCol = (IsDblPlay == 1) ? 14 : 10; 

      aryPos = new Array(nRow);

      // fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder
      for(i=0; i<nRow; i++)
      {
         aryPos[i] = new Array(nCol);
         aryPos[i][0] = 0; 
         aryPos[i][1] = i+1; 
         aryPos[i][2] = E_POS_MANUAL; 
         aryPos[i][3] = 0; 
         aryPos[i][4] = 0; 
         aryPos[i][5] = 0; 
      }
      return aryPos; 
   }

/* ==================================================================================
      예선전 - 수동 배정용 빈 배열을 만든다.
   ================================================================================== */
   function makeEmptyQAryPos(nQGroup, IsDblPlay) {
      var aryPos, i = 0, nCol, nRow = 0;
		nCol = (IsDblPlay == 1) ? 14 : 10;
		nRow = nQGroup * 4

      aryPos = new Array(nRow);

      for(i=0; i<nRow; i++)
      {
         aryPos[i] = new Array(nCol);
         aryPos[i][0] = 0;
         aryPos[i][1] = i+1;
         aryPos[i][2] = E_POS_MANUAL;
         aryPos[i][3] = 0;
         aryPos[i][4] = 0;
         aryPos[i][5] = 0;
      }
      return aryPos;
   }

/* ==================================================================================
      aryPos에 Bye를 적용한다. 
   ================================================================================== */
   function applyByeToPos(rAryPos, nUser)
   {
      var aryBye, i, len; 

      aryBye = getAryBye(nUser); 
      if(aryBye == null) return; 

      var strLog = ""; 
      for(var prop in aryBye)
      {
         if(strLog == "") strLog = utx.sprintf("{0} = {1}", i, aryBye[prop]);
         else strLog = utx.sprintf("{0},{1}", strLog, aryBye[prop]);
      }
      console.log(strLog);

      len = rAryPos.length; 
      for(i = 0; i< len; i++)
      {
         if(IsByePos(aryBye, i+1)) {
            rAryPos[i][2] = E_POS_BYE; 
         }
      }
   }

/* ==================================================================================
      예선전 aryQPos에 Bye를 적용한다.
   ================================================================================== */
   function applyByeToQPos(rAryPos, nQUser)
   {
		var szBlock = 4, nQMod = 0;

		if(nQUser <= 4) {
			SetByeInQBlock(rAryPos, 0, nQUser);
		}
		else if(nQUser <= 8) {
			if(nQUser == 7) {			// QCnt = 7 이면 Q1 = 3, Q2 = 4
				SetByeInQBlock(rAryPos, 0, 3);
			}
			else if(nQUser == 6) {			// QCnt = 6 이면 Q1 = 3, Q2 = 3
				SetByeInQBlock(rAryPos, 0, 3);
				SetByeInQBlock(rAryPos, szBlock, 3);
			}
			else if(nQUser == 5) {			// QCnt = 5 이면 Q1 = 2, Q2 = 3
				SetByeInQBlock(rAryPos, 0, 2);
				SetByeInQBlock(rAryPos, szBlock, 3);
			}
		}
		else if(nQUser <= 12) {
			if(nQUser == 11) {			// QCnt = 11 이면 Q1 = 3, Q2 = 4, Q3 = 4
				SetByeInQBlock(rAryPos, 0, 3);
			}
			else if(nQUser == 10) {			// QCnt = 10 이면 Q1 = 3, Q2 = 3, Q3 = 4
				SetByeInQBlock(rAryPos, 0, 3);
				SetByeInQBlock(rAryPos, szBlock, 3);
			}
			else if(nQUser == 9) {			// QCnt = 9 이면 Q1 = 3, Q2 = 3, Q3 = 3
				SetByeInQBlock(rAryPos, 0, 3);
            SetByeInQBlock(rAryPos, szBlock, 3);
            SetByeInQBlock(rAryPos, 2*szBlock, 3);
			}
		}
		else {
			nQMod = nQUser % szBlock;
			if(nQMod = 3) {			// QCnt Mod 4 = 3 이면  Q1 = 3
				SetByeInQBlock(rAryPos, 0, 3);
			}
			else if(nQMod = 2) {			// QCnt Mod 4 = 2 이면  Q1 = 3, Q2 = 3
				SetByeInQBlock(rAryPos, 0, 3);
				SetByeInQBlock(rAryPos, szBlock, 3);
			}
			else if(nQMod = 1) {			// QCnt Mod 4 = 1 이면  Q1 = 3, Q2 = 3, Q3= 3
				SetByeInQBlock(rAryPos, 0, 3);
            SetByeInQBlock(rAryPos, szBlock, 3);
            SetByeInQBlock(rAryPos, 2*szBlock, 3);
			}
		}
	}

	/* ==================================================================================
			rAryPos에 sp로부터 bye position을 셋팅한다. nUser에 따라
			sp: start pos
		================================================================================== */
   function SetByeInQBlock(rAryPos, sp, nUser)
   {
		if(nUser == 1) {											//  data: 1 / bye: 2, 3, 4
			rAryPos[sp+1][2] = E_POS_BYE;
			rAryPos[sp+2][2] = E_POS_BYE;
			rAryPos[sp+3][2] = E_POS_BYE;
		}
		else if(nUser == 2) {									// data: 1, 4 / bye: 2, 3
			rAryPos[sp+1][2] = E_POS_BYE;
			rAryPos[sp+2][2] = E_POS_BYE;
		}
		else if(nUser == 3) {									// data: 1, 3, 4 / bye: 2
			rAryPos[sp+1][2] = E_POS_BYE;
		}
	}




/* ==================================================================================
      nPos이 Bye 위치인지 여부를 검사한다. 
   ================================================================================== */
   function IsByePos(rAryBye, nPos)
   {
      var i = 0, len = 0; 

      if(rAryBye == undefined || rAryBye == null) return false; 
      len = rAryBye.length; 

      for(i=1; i<len; i++){
         if(rAryBye[i] == nPos) return true; 
      }

      return false; 
   }

/* ==================================================================================
      2차원 배열 row 크기를 반환한다. 
   ================================================================================== */
   function Get2DRow(ary)
   {
      if(!utx.Is2DArray(ary)) return 0;
      return ary.length; 
   }

/* ==================================================================================
      2차원 배열 column 크기를 반환한다. 
   ================================================================================== */
   function Get2DCol(ary)
   {
      var len = 0; 
      if(!utx.Is2DArray(ary)) return 0;
      if(ary[0] instanceof Array) len = ary[0].length; 
      else if(ary[0] instanceof Object) len = utx.countPropertyInObj(ary[0]); 
      return len; 
   }

/* ==================================================================================
      예선조 갯수를 반환한다. 
   ================================================================================== */
   function getQGroupCnt(nUser, nRound) {
      var nDiff, nQCnt

      nDiff = nUser - nRound; 
      if(nDiff <= 0) nQCnt = 0; 
      else nQCnt = (nDiff % 3) ? Math.floor(nDiff / 3) + 1 : Math.floor(nDiff / 3);

      return nQCnt; 
   }

/* ==================================================================================
      수동배정 - 선택한 user 값을 aryPos에 셋팅한다. 
   ================================================================================== */
   function applyMenualSel(rAryPos, rAryGameUser, strGroupIdx, nPos, nSeed){
      var IsDblPlay, i, len, len2, pos, userIdx; 
      IsDblPlay = bmx.IsDoublePlay(gPlayType);

      // 이미 셋팅한 값이 있으면 지운다. 
      len = rAryPos.length; 
      for(i = 0; i<len; i++)
      {
         // Reset Data 
         if(rAryPos[i][4] == strGroupIdx) {     
            rAryPos[i][0] = 0; 
            rAryPos[i][1] = i+1; 
            rAryPos[i][2] = E_POS_MANUAL; 
            rAryPos[i][3] = 0; 
            rAryPos[i][4] = 0; 
            rAryPos[i][5] = 0; 
         }
      }

      //     복식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
      //     단식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser, user, cTeam, team
      // 값을 셋팅 
      userIdx = GetUserIdx(rAryGameUser, strGroupIdx);    

      pos = nPos -1; 
      rAryPos[pos][0] = 1; 
      rAryPos[pos][1] = nPos; 

		if(nSeed != undefined && nSeed != 0) {
			rAryPos[pos][2] = E_POS_SEED;
      	rAryPos[pos][3] = nSeed;	
		}
		else {
      rAryPos[pos][2] = E_POS_NORMAL; 
      rAryPos[pos][3] = -1; 
		}
      rAryPos[pos][4] = strGroupIdx; 
      rAryPos[pos][5] = 0; 
      
      if(IsDblPlay == 1) {
         rAryPos[pos][6] = rAryGameUser[userIdx][8]; 
         rAryPos[pos][7] = rAryGameUser[userIdx][9]; 
         rAryPos[pos][8] = rAryGameUser[userIdx+1][8]; 
         rAryPos[pos][9] = rAryGameUser[userIdx+1][9]; 
         rAryPos[pos][10] = rAryGameUser[userIdx][10]; 
         rAryPos[pos][11] = rAryGameUser[userIdx][11]; 
         rAryPos[pos][12] = rAryGameUser[userIdx+1][10]; 
         rAryPos[pos][13] = rAryGameUser[userIdx+1][11]; 
      }
      else {
         rAryPos[pos][6] = rAryGameUser[userIdx][8]; 
         rAryPos[pos][7] = rAryGameUser[userIdx][9]; 
         rAryPos[pos][8] = rAryGameUser[userIdx][10]; 
         rAryPos[pos][9] = rAryGameUser[userIdx][11]; 
      }
   }
   
  /* ==================================================================================
      수동배정 - 선택한 user 값을 aryPos에 셋팅한다.
   ================================================================================== */
   function applyMenualQSel(rAryPos, rAryGameUser, QNum, nPos){
      var IsDblPlay, i, len, len2, pos, userIdx;
      IsDblPlay = bmx.IsDoublePlay(gPlayType);

      //     복식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
      //     단식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser, user, cTeam, team
      // 값을 셋팅

      pos = nPos -1;
      rAryPos[pos][0] = 1;
      rAryPos[pos][1] = nPos;
      rAryPos[pos][2] = E_POS_Q;
      rAryPos[pos][3] = QNum;
      rAryPos[pos][4] = 0;
      rAryPos[pos][5] = 0;
   }


  /* ==================================================================================
      GroupIdx를 받아서 aryUser로 부터 Idx를 반환한다.  
   ================================================================================== */ 
   function GetUserIdx(rAryUser, strGroupIdx) {
      var i = 0, len = 0; 
      len = rAryUser.length; 

      for(i=0; i<len; i++)
      {
         if(rAryUser[i][6] == strGroupIdx) return i; 
      }
      return -1; 
   }

   /* ==================================================================================
      Display Area의 화면 / Data를 Reset
   ================================================================================== */  
   function ResetDisplaySet(resetLv) {
      if(resetLv == undefined) resetLv = E_RESET_LV1; 
      var bReset = true;

      // 데이터 초기화 
      if(resetLv >= E_RESET_LV1 )
      {
         ctx.writeHtmlToDiv("div_QTournament_body", "");          // 좌측 예선 토너먼트 
         ctx.writeHtmlToDiv("div_FTournament", "");               // 좌측 본선 토너먼트 
      }

      if(resetLv >= E_RESET_LV2 )
      {
         ctx.writeHtmlToDiv("div_entry_body", "");                // 우측 엔트리 리스트 
         ctx.setSpanText("sp_entry_total", "");                   // 우측 엔트리 리스트 Total Count
          
         writeSeedInfo(bReset);
      }

      if(resetLv == E_RESET_ALL )                                 // 대회 셋팅 자리 + ( 토너먼트 자리) + ( List 자리) 
      {
         ctx.setRadioVal("Assign", 0, true);                      // 라디오 선택 - 자동/선택/수동 배정 
         ctx.setTextboxVal("edit_AssoGameTitle", "");             // 연동대회 
         ctx.setSelectVal("sel_round", "0");                      // 강수 
         ctx.setTextboxVal("txt_reducecnt", "");                  // Test 인원
         onBtnFTournament();
         writeSeedInfo(bReset);

         gAryPos = null; 
         gAryQPos = null; 
      }
   }

   /* ==================================================================================
         수동 배정일 경우 배정의 완료 유무 체크 
      ================================================================================== */ 
   function IsCompleteAssignManual(rAryPos) {
      var i = 0, len = 0; 
      len = rAryPos.length; 

      for(i=0; i<len; i++)
      {
         if(rAryPos[i][2] == E_POS_MANUAL) return false; 
      }
      return true; 
   }

   /* ==================================================================================
         최대 Seed Info String 반환 
      ================================================================================== */ 
   function writeSeedInfo(bReset) {
      var strInfo, selRound;
      var userCnt, nCnt

      if(bReset == 'undefined') bReset = false; 
      if(bReset == true) {      
         strInfo = " 0개"; 
      }
      else {
         // userCnt = gAryGameUser.length;			
         // nCnt = (bmx.IsDoublePlay(gPlayType)) ? (userCnt / 2) : userCnt;
			selRound = Number(ctx.getSelectVal("sel_round"));
         strInfo = utx.sprintf(" {0}개",bmx.getSeedCnt(selRound));
      }

      ctx.setElementText("idsp_maxSeed", strInfo);
   }


   /* ==================================================================================
      teamOrder를 셋팅 
      혼합팀이면서 팀이 서로 틀릴경우 team_a1/team_b1 와 team_b1/team_a1은 서로 같은 팀이다. 
      이는 문자열로 비교가 불가 하므로 teamOrder를 생성하여 같은 팀임을 만들어 준다. 
      단식이거나 , 복식이라도 팀명이 서로 같으면 문자열 비교로 TeamOrder를 만들어 준다. 
   ================================================================================== */
function makeTeamOrder2(rAryReq, playType) {
    if (IsDoublePlay(playType)) return makeTeamOrderDbl2(rAryReq, playType);

    var i = 0,
        len = rAryReq.length,
        aryTmp;
    var fLoop = 1,
        cntLoop = 0,
        loopMax = 1000,
        idx = 0;
    var team1 = 0,
        team2 = 0,
        ret = 0,
        steam = -1,
        teamKind  = 0
        teamOrder = 0;

    aryTmp = new Array();

    while (fLoop) {
        if (steam == -1) {
            // team을 구할수 없으면 다 copy한 거다. 
            ret = GetNextTeam(rAryReq);
            if (ret == -1) {
                fLoop = 0;
                continue;
            }
            team1 = rAryReq[ret][10];
            teamKind++;
            teamOrder = 0; 
        }
        
        steam = GetSameTeam(rAryReq, team1);
        if (steam == -1) continue;
        teamOrder ++; 

        aryTmp[idx] = utx.cloneObject(rAryReq[steam]);
        aryTmp[idx][1] = teamKind;
        aryTmp[idx][5] = teamOrder;
        rAryReq[steam][0] = 1; // 사용했다는 표시를 한다. 
        idx++;

        if (cntLoop > loopMax) // 문제가 있지만 무한 루프 빠지지 않게 이쯤에서 끝내자. 
        {
            fLoop = 0;
            continue;
        }

        cntLoop++;
    }

    // rAryReq에 aryTmp를 Deep Copy하자. 
    for (i = 0; i < len; i++) {
        rAryReq[i] = utx.cloneObject(aryTmp[i]);
    }

    aryTmp = null;
}

/* =================================================================================== 
   - aryReq에서 복식 팀을 추출하여 같은 팀이 있는지 전체 배열을 대상으로 비교를 한다. 
   - aryReq에 팀이 중간에 혼합되어 들어 갈수 있기 때문에 팀별로 재 정렬이 필요하다. 
   - 같은팀을 모두 찾으면 다시 팀을 추출하여 반복한다. 

      복식일 경우 혼합팀 유무를 확인한다. 
      1. List에서 혼합팀이 존재할 경우 별도의 List에 삽입한다. 
      2. aryReq와 같은 크기의 배열을 잡는다. aryReqTmp
      3. aryReqTmp에 aryReq로 부터 한 팀씩 데이터를 추출한다. 
      4. aryReqTmp에 copy된 리스트는 mark를 한다. 
      5. aryReq에서 mark가 되지 않은 Team을 모든 인원이 소모될때까지 복사한다. 
      6. aryReqTmp에 정렬된 데이터를 aryReq로 copy한다. 

      aryReq->aryReqTmp copy시 고려사항
      1. aryReq에 나타나는 Team 순서로 copy가 이루어 져야 한다. 
      2. aryReq에 Team내의 선수 순서도 바뀌면 안된다. 
      3. 복식일 경우 단일팀, 혼합팀이 혼재할 경우 단일팀을 먼저 복사한다 .
      4. 단일팀 복사후 , 바로 다음팀으로 혼합팀을 복사한다. 
   =================================================================================== */

function makeTeamOrderDbl2(rAryReq, playType) {
    var i = 0,
        len = rAryReq.length,
        aryTmp;
    var fLoop = 1,
        cntLoop = 0,
        loopMax = 1000,
        idx = 0;
    var team1 = 0,
        team2 = 0,
        ret = 0,
        steam = -1,
        teamKind = 0;
        teamOrder = 0;
   var fix_team1, fix_team2, uIdx1, uIdx2, sex1, sex2; 


    aryTmp = new Array();

    while (fLoop) {
        if (steam == -1) {
            // team을 구할수 없으면 다 copy한 거다. 
            ret = GetNextTeam(rAryReq);
            if (ret == -1) {
                fLoop = 0;
                continue;
            }
            team1 = rAryReq[ret][10];
            team2 = rAryReq[ret + 1][10];
            teamKind++;
            teamOrder = 0; 
            fix_team1 = ""
            fix_team2 = ""
        }

        steam = GetSameTeamDbl2(rAryReq, team1, team2);
        if (steam == -1) continue;

         if(fix_team1 == "") fix_team1 = team1; 
         if(fix_team2 == "") fix_team2 = team2; 
        teamOrder++; 

        //복식이니까 2개씩 복사한다. 
        aryTmp[idx] = utx.cloneObject(rAryReq[steam]);
        aryTmp[idx + 1] = utx.cloneObject(rAryReq[steam + 1]);
        aryTmp[idx][1] = teamKind;
        aryTmp[idx + 1][1] = teamKind;
        aryTmp[idx][5] = teamOrder;
        aryTmp[idx + 1][5] = teamOrder;

        rAryReq[steam][0] = 1; // 사용했다는 표시를 한다. 
        rAryReq[steam + 1][0] = 1;
        idx += 2;

        if (cntLoop > loopMax) // 문제가 있지만 무한 루프 빠지지 않게 이쯤에서 끝내자. 
        {
            fLoop = 0;
            continue;
        }

        cntLoop++;
    }

    // rAryReq에 aryTmp를 Deep Copy하자. 
    for (i = 0; i < len; i++) {
        rAryReq[i] = utx.cloneObject(aryTmp[i]);
    }

    aryTmp = null;
}

/* =================================================================================== 
      복식/혼합 팀 일경우 같은 팀 인지 확인하는 function rAryReqUser Field 상단 참조 
      team1, team2를 인자로 받아 비교한다.       
   =================================================================================== */
function GetSameTeamDbl2(rAryReq, team1, team2) {
    var i = 0,len = rAryReq.length;

    for (i = 0; i < len; i += 2) // 복식이니까 2개씩 증가 
    {
        if (rAryReq[i][0] == 0) // 할당하지 않았다. 여기서 찾자 
        {
            // team1, team2가 앞뒤로 바뀌어도 같은 팀으로 처리한다. 
            if ((rAryReq[i][10] == team1 && rAryReq[i + 1][10] == team2) || (rAryReq[i][10] == team2 && rAryReq[i + 1][10] == team1)) {
                return i; // 찾았다. return 
            }
        }
    }

    return -1;
}

/* =================================================================================== 
      토너먼트 전 강수의 게임 번호를 구한다. 
		' Bye가 있으면 skip (GameNo = 0)
		' 전체 게임의 갯수는 round - 1개 이다.   
		' 첫 round 게임 갯수는 : round/ 2, 나머지 게임 갯수는 (round/2) - 1    
		' 첫 round에서만 bye갯수를 세면 뒤에는 해당 번호의 증가이다. 
   =================================================================================== */
function ApplyTournamentGameNum(rAryPos) {
    var i = 0, gameNo = 0, remainCnt = 0, aryGameNo = []; 
	 var len = rAryPos.length;
	 	 
	 remainCnt = (len/2) - 1; 		// 첫 round 게임 갯수는 : round/ 2, 나머지 게임 갯수는 (round/2) - 1

	// 첫번째 라운드에서 게임 번호를 셋팅한다. ( Bye값은 1 Round에만 존재한다. )
    for (i = 0; i < len; i += 2) // 게임은 2 Group씩 이니까 2개씩 증가 
    {
        if (rAryPos[i][2] == E_POS_BYE || rAryPos[i+1][2] == E_POS_BYE) // Bye이면 GameNum = 0
        {
            aryGameNo.push(0); 
        }
		  else aryGameNo.push(++gameNo); 
    }

	 // 나머지 게임 번호를 셋팅한다 .
	 for(i=0; i<remainCnt; i++)
	 {
		 aryGameNo.push(++gameNo); 
	 }

    return aryGameNo;
}

/* =================================================================================== 
      예선전 토너먼트 전 강수의 게임 번호를 구한다. 
		' Bye가 있으면 skip (GameNo = 0)
		' 예선전의 게임 번호는 모든 예선전을 하나의 경기로 생각하고 번호를 매긴다. 
		' 전체 게임의 갯수는 round/2 + (round/2)/2 개 이다. 
   =================================================================================== */
function ApplyQTournamentGameNum(rAryQPos) {
    var i = 0, gameNo = 0, remainCnt = 0, aryGameNo = []; 
	 var len = rAryQPos.length;
	 	 
	 remainCnt = (len/2) / 2; 		// 첫 round 게임 갯수는 : round/ 2, 나머지 게임 갯수는 (round/2)/2	 

	// 첫번째 라운드에서 게임 번호를 셋팅한다. ( Bye값은 1 Round에만 존재한다. )
    for (i = 0; i < len; i += 2) // 게임은 2 Group씩 이니까 2개씩 증가 
    {
        if (rAryQPos[i][2] == E_POS_BYE || rAryQPos[i+1][2] == E_POS_BYE) // Bye이면 GameNum = 0
        {
            aryGameNo.push(0); 
        }
		  else aryGameNo.push(++gameNo); 
    }

	 // 나머지 게임 번호를 셋팅한다 .
	 for(i=0; i<remainCnt; i++)
	 {
		 aryGameNo.push(++gameNo); 
	 }

    return aryGameNo;
}

</script>



<script>
   // **********************************************************************************
   //
   // **********************************************************************************


/* ==================================================================================
      round depth를 구한다.
   ================================================================================== */
	function getRoundDepth(round) {
		var i = 0, base = 2, f_loop = 1, loop_max = 20, round_depth = 0, loop_cnt = 1;

		while(f_loop) {
			round = round / base;
			round_depth++;
			if(round == 1) {
				f_loop = 0;
			}

			loop_cnt++;
			if(loop_cnt > loop_max) {
				f_loop = 0;
			}
		}

		return round_depth;
	}

/* ==================================================================================
      aryPos을 받아서 본선 토너먼트를 생성한다.
   ================================================================================== */
   function createSetNumTournament(rAryPos)
   {
      var aryData, i = 0, len = 0, obj, IsDblPlay = 1, round = 0, round_depth = 0, cur_round = 0;
      var setNum_tournament, strInfo, cntUser, nScale = 1, nBlockHeight = 48, pos_info = 0;
		var nFirstBoarderGap = 0, nBoardWidth = 0;
      aryData = new Array();

		round = rAryPos.length;
		round_depth = getRoundDepth(round);

      IsDblPlay = bmx.IsDoublePlay(gPlayType);

		utx.printInfo2DAry(rAryPos, "In createTournament");

		for(i = 0; i<round_depth; i++)
      {
         aryData[i] = new Array();
      }

      for(i = 0; i< round; i+=2)
      {
         if(gGroupGameGB == "B0030001")         // 개인전
         {
            obj = fillUserInfoSetNum(i, rAryPos[i], rAryPos[i+1], IsDblPlay);
         }
         else if(gGroupGameGB == "B0030002")    // 단체전
         {
            obj = fillTeamUserInfoSetNum(i, rAryPos[i], rAryPos[i+1], IsDblPlay);
         }

         aryData[0].push(obj)
		}

		var empty_round = round / 2;
		pos_info = round / 2;
		for(i = 1; i < round_depth; i++)
      {
			pos_info = MakeSetNumEmptyData(aryData[i], empty_round, pos_info);
			empty_round = empty_round / 2;
      }

      if(IsDblPlay == 1)
      {
         nBlockHeight = 48;
			nFirstBoarderGap = 320, nBoardWidth = 60;

         setNum_tournament = makeSetNumTournamentDouble("div_SGNumTournament", nScale, nBlockHeight,nBoardWidth, nFirstBoarderGap );
      }
      else
      {
         nBlockHeight = 48;
			nFirstBoarderGap = 320, nBoardWidth = 60;

         setNum_tournament = makeSetNumTournamentSingle("div_SGNumTournament", nScale, nBlockHeight, nBoardWidth, nFirstBoarderGap);
		}

      drawSetNumTournament(setNum_tournament, round, round_depth, aryData);
	}

	/* ==================================================================================
		draw Tonament - tonament Object, round, data를 입력받아 tonament를 그린다.
	================================================================================== */
   function drawSetNumTournament(objT, round, round_kind, rAryData)
   {
      var roundData = {};

      var i = 0, key = "";
      for(var i = 0; i< round_kind; i++)
      {
         key = utx.strPrintf("round_{0}", i+1);
         roundData[key] = rAryData[i];
      }


      objT.draw({
         limitedStartRoundOf: 0, //16    integer(짝수)  default:0 전체, 그리기 시작할 라운드 ex)8강 부터
         limitedEndRoundOf: 0, //8       integer(짝수)  default:0 전체, 그리기 끝날 라운드 ex)4강 까지
         roundOf:round,
         data: roundData,
      });
   }

	function MakeSetNumEmptyData(rAryEmpty, empty_round, pos_info)
   {
      var i = 0;

      for(i=0; i<empty_round; i += 2)
      {
         rAryEmpty.push({
            matchNo: pos_info++,
            l_player:'', l_team:'',
            r_player:'', r_team:'',
         });
		}

		return pos_info;
   }


/* ==================================================================================
      tournament에 사용할 data object을 만든다.
   ================================================================================== */
   function fillTeamUserInfoSetNum(Idx, l_info, r_info, IsDblPlay)
    {
      var obj = {};

      // i, i+1을 합쳐서 하나의 Obj을 만들므로 기본 셋팅은 i%2=0에서 한번만
      obj.matchNo    =  Idx / 2;
      obj.bDblPlay   =  IsDblPlay;
      obj.l_fill     =  true;
      obj.l_sel      =  false;
      obj.l_dup      =  false;
      obj.r_fill     =  true;
      obj.r_sel      =  false;
      obj.r_dup      =  false;
      obj.l_pcode    = l_info[4];
      obj.r_pcode    = r_info[4];
      obj.l_spVal    =  " ";
      obj.r_spVal    =  " ";
      obj.l_firstMan    =  0;
		obj.r_firstMan    =  0;
		obj.l_order    =  0;
		obj.r_order    =  0;
		obj.round_1		= 1;

      if(l_info[0] == 1) obj.l_dup = true;
      if(r_info[0] == 1) obj.r_dup = true;

      // Bye position
      if(l_info[2] == E_POS_BYE) {
         obj.l_player   =  "BYE";
         obj.l_team     =  "";
         obj.l_pcode    = "BYE";
      }
      else if(l_info[2] == E_POS_MANUAL) {      // Manual pos
         obj.l_player   =  " ";
         obj.l_team     =  "";
         obj.l_pcode    = utx.sprintf("E_POS_MANUAL_{0}", Idx);
      }
      else if(l_info[2] == E_POS_Q) {
         obj.l_player   =  "Q";
         obj.l_team     =  utx.sprintf("({0}조)", l_info[3]);
         obj.l_pcode    = utx.sprintf("qno_{0}", l_info[3]);

         obj.l_spVal    =  utx.sprintf("Q{0}", l_info[3]);
      }
      else
        {
         if(l_info[2] == E_POS_SEED) obj.l_spVal      =  getStrSeed(l_info[3]);
         if(l_info[2] == E_POS_FIRST) obj.l_firstMan      =  1;
         obj.l_player   =  (IsDblPlay == 0)? l_info[7] : utx.sprintf("{0},{1}",l_info[7], l_info[9]);
         obj.l_team     =  (IsDblPlay == 0)? bmx.GetSimpleTeamName(l_info[9]) : utx.sprintf("{0},{1}",bmx.GetSimpleTeamName(l_info[11]), bmx.GetSimpleTeamName(l_info[13]));

         obj.l_player = bmx.GetSimpleTeamName(l_info[9]);
         obj.l_player = utx.getBlockData(obj.l_player, "", "/");
         if (l_info[6] != "" && l_info[6] != "0") obj.l_player = utx.sprintf("{0}-{1}", obj.l_player, l_info[6]);

         obj.l_team     =  "";
            }

      // Bye position
      if(r_info[2] == E_POS_BYE) {
         obj.r_player   =  "BYE";
         obj.r_team     =  "";
         obj.r_pcode    = "BYE";
      }
      else if(r_info[2] == E_POS_MANUAL) {     // Manual pos
         obj.r_player   =  " ";
         obj.r_team     =  "";
         obj.r_pcode    =  utx.sprintf("E_POS_MANUAL_{0}", Idx+1);
        }
      else if(r_info[2] == E_POS_Q) {
         obj.r_player   =  "Q";
         obj.r_team     =  utx.sprintf("({0}조)", r_info[3]);
         obj.r_pcode    = utx.sprintf("qno_{0}", r_info[3]);

         obj.r_spVal    =  utx.sprintf("Q{0}", r_info[3]);
    }
      else
      {
         if(r_info[2] == E_POS_SEED) obj.r_spVal      =  getStrSeed(l_info[3]);
         if(l_info[2] == E_POS_FIRST) obj.r_firstMan      =  1;
         obj.r_player = bmx.GetSimpleTeamName(r_info[9]);
         obj.r_player = utx.getBlockData(obj.r_player, "", "/");
         if (r_info[6] != "" && r_info[6] != "0") obj.r_player = utx.sprintf("{0}-{1}", obj.r_player, r_info[6]);

         obj.r_team     =  "";
      }
      return obj;
}

/* ==================================================================================
      tournament에 사용할 data object을 만든다.
   ================================================================================== */
   function fillUserInfoSetNum(Idx, l_info, r_info, IsDblPlay)
   {
      var obj = {};

      // i, i+1을 합쳐서 하나의 Obj을 만들므로 기본 셋팅은 i%2=0에서 한번만
      obj.matchNo    =  Idx / 2;
      obj.bDblPlay   =  IsDblPlay;
      obj.l_fill     =  true;
      obj.l_sel      =  false;
      obj.r_fill     =  true;
      obj.r_sel      =  false;
      obj.l_pcode    = l_info[4];
      obj.r_pcode    = r_info[4];
      obj.l_spVal    =  " ";
      obj.r_spVal    =  " ";
      obj.l_firstMan    =  0;
      obj.r_firstMan    =  0;
		obj.l_order    =  (IsDblPlay == 0)? l_info[10] : l_info[14];
		obj.r_order    =  (IsDblPlay == 0)? r_info[10] : r_info[14];
		obj.round_1		= 1;

      // Bye position
      if(l_info[2] == E_POS_BYE) {
         obj.l_player   =  "BYE";
         obj.l_team     =  "";
         obj.l_pcode    = "BYE";
            }
      else if(l_info[2] == E_POS_MANUAL) {      // Manual pos
         obj.l_player   =  " ";
         obj.l_team     =  "";
         obj.l_pcode    = utx.sprintf("E_POS_MANUAL_{0}", Idx);
        }
      else if(l_info[2] == E_POS_Q) {
         obj.l_player   =  "Q";
         obj.l_team     =  utx.sprintf("({0}조)", l_info[3]);
         obj.l_pcode    = utx.sprintf("qno_{0}", l_info[3]);

         obj.l_spVal    =  utx.sprintf("Q{0}", l_info[3]);
      }
      else
      {
         if(l_info[2] == E_POS_SEED) obj.l_spVal      =  getStrSeed(l_info[3]);
         if(l_info[2] == E_POS_FIRST) obj.l_firstMan      =  1;
         obj.l_player   =  (IsDblPlay == 0)? l_info[7] : utx.sprintf("{0},{1}",l_info[7], l_info[9]);
         obj.l_team     =  (IsDblPlay == 0)? bmx.GetSimpleTeamName(l_info[9]) : utx.sprintf("{0},{1}",bmx.GetSimpleTeamName(l_info[11]), bmx.GetSimpleTeamName(l_info[13]));

         // obj.l_team     =  (IsDblPlay == 0)? l_info[9] : utx.sprintf("{0},{1}",l_info[11], l_info[13]);
      }

      // Bye position
      if(r_info[2] == E_POS_BYE) {
         obj.r_player   =  "BYE";
         obj.r_team     =  "";
         obj.r_pcode    = "BYE";
      }
      else if(r_info[2] == E_POS_MANUAL) {     // Manual pos
         obj.r_player   =  " ";
         obj.r_team     =  "";
         obj.r_pcode    =  utx.sprintf("E_POS_MANUAL_{0}", Idx+1);
      }
      else if(r_info[2] == E_POS_Q) {
         obj.r_player   =  "Q";
         obj.r_team     =  utx.sprintf("({0}조)", r_info[3]);
         obj.r_pcode    = utx.sprintf("qno_{0}", r_info[3]);

         obj.r_spVal    =  utx.sprintf("Q{0}", r_info[3]);
      }
      else
        {
         if(r_info[2] == E_POS_SEED) obj.r_spVal      =  getStrSeed(r_info[3]);
         if(r_info[2] == E_POS_FIRST) obj.r_firstMan      =  1;
         obj.r_player   =  (IsDblPlay == 0)? r_info[7] : utx.sprintf("{0},{1}",r_info[7], r_info[9]);
         // obj.r_team     =  (IsDblPlay == 0)? r_info[9] : utx.sprintf("{0},{1}",r_info[11], r_info[13]);
         obj.r_team     =  (IsDblPlay == 0)? bmx.GetSimpleTeamName(r_info[9]) : utx.sprintf("{0},{1}",bmx.GetSimpleTeamName(r_info[11]), bmx.GetSimpleTeamName(r_info[13]));
      }
      return obj;
        }



/* ==================================================================================
   make Tonament - div id를 입력받아 tonament Object을 생성하고 , 반환한다.
================================================================================== */
function makeSetNumTournamentDouble(id_div, nScale, nBlockHeight, nBoardWidth, nFirstBoardWidth)
{
  var tournament = new Tournament();
  tournament.setOption({
    blockBoardWidth: nBoardWidth, // integer board 너비
	 blockBoardWidthFirst: nFirstBoardWidth, // integer board 너비
    blockBranchWidth: 30, // integer 트리 너비
   //  blockHeight : 48, // integer 블럭 높이(board 간 간격 조절)
    blockHeight : nBlockHeight, // integer 블럭 높이(board 간 간격 조절)
    branchWidth : 1, // integer 트리 두께
    //branchColor : '#dddddd', // string 트리 컬러
    branchColor : '#888888', // string 트리 컬러
    roundOf_textSize : 14, // integer 배경 라운드 텍스트 크기
    scale : nScale, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
    //scale : 0.5, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
    board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
    el:document.getElementById(id_div) // element must have id
  });

   tournament.setStyle('#'+id_div);
   $("#"+id_div).addClass("tour_double")
   tournament.boardInner = function(data){
      if(data && data.bDblPlay == 1) return boardInner_setNumDouble(data);
      return boardInner_setNumSingle(data);
   }
  return tournament;
    }

function makeSetNumTournamentSingle(id_div, nScale, nBlockHeight, nBoardWidth, nFirstBoardWidth)
{
   var tournament = new Tournament();
   tournament.setOption({
      blockBoardWidth: nBoardWidth, // integer board 너비
	 	blockBoardWidthFirst: nFirstBoardWidth, // integer board 너비
      blockBranchWidth: 20, // integer 트리 너비
      // blockHeight : 24, // integer 블럭 높이(board 간 간격 조절)
      blockHeight : nBlockHeight, // integer 블럭 높이(board 간 간격 조절)
      branchWidth : 1, // integer 트리 두께
      //branchColor : '#dddddd', // string 트리 컬러
      branchColor : '#ccc', // string 트리 컬러
      roundOf_textSize : 14, // integer 배경 라운드 텍스트 크기
      scale : nScale, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
   //   scale : 1, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
      board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
      el:document.getElementById(id_div) // element must have id
   });

   tournament.setStyle('#'+id_div);
   $("#"+id_div).addClass("tour_single")
   tournament.boardInner = function(data){
      if(data && data.bDblPlay == 1) return boardInner_setNumDouble(data);
      return boardInner_setNumSingle(data);
   }
  return tournament;
    }


/* ==================================================================================
   data set-  tonament block - single game
   dat를 입력받아 싱글 게임일때 block을 그린다.
================================================================================== */
function boardInner_setNumSingle(data)
{
  sindou=0;
   var l_player, l_team;
   var r_player, r_team;
   var l_sel, r_sel;
   var l_fill, r_fill;
   var l_no, r_no;
   var l_spVal, r_spVal;
   var l_firstMan, r_firstMan;
   var l_pcode, r_pcode;
   var matchNo = 0;
   var r_param, l_param;
   var l_param_id, r_param_id;
	 var l_id, r_id;
	 var l_order, r_order;
	 var round_1 = 0;

   if(data){
		matchNo = data.matchNo;
		round_1 = data.round_1;

      l_player  = data.l_player;
      l_team    = data.l_team;
      l_spVal   = data.l_spVal;
      l_firstMan   = data.l_firstMan;
		l_pcode   = data.l_pcode;
		l_order   = data.l_order;

      r_player  = data.r_player;
      r_team    = data.r_team;
      r_spVal   = data.r_spVal;
      r_firstMan   = data.r_firstMan;
		r_pcode   = data.r_pcode;
		r_order   = data.r_order;


      l_fill = data.l_fill ? 's_filled' : '';
      r_fill = data.r_fill ? 's_filled' : '';

      l_sel = data.l_sel ? 's_selected' : '';
			r_sel = data.r_sel ? 's_selected' : '';

			if(gSelManual == false) {		// 수동 배정이 아닐때만 보여준다.
				if(l_order != ' ') l_player = utx.sprintf("{0}-({1})", l_player, l_order);			// for test
				if(r_order != ' ') r_player = utx.sprintf("{0}-({1})", r_player, r_order);			// for test
			}

      if(l_firstMan == 1) l_player = utx.sprintf("* {0}", l_player);
      if(r_firstMan == 1) r_player = utx.sprintf("* {0}", r_player);

      // 재고.....
      l_no = (matchNo * 2) + 1;
      r_no = (matchNo * 2 + 1) + 1;

      l_id = utx.sprintf("\"pid_{0}\"", l_pcode);
      r_id = utx.sprintf("\"pid_{0}\"", r_pcode);

      l_param_id = utx.sprintf("pid_{0}", l_pcode);
      r_param_id = utx.sprintf("pid_{0}", r_pcode);

      l_param = utx.sprintf("'{0}','{1}','{2}','{3}'", l_no, l_spVal, l_pcode, l_param_id);
      r_param = utx.sprintf("'{0}','{1}','{2}','{3}'", r_no, r_spVal, r_pcode, r_param_id);
   }

	var html = '';

	if(round_1) {
    	html = [
			'<p id = '+l_id+' class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
				'<span class="lotteryMatch__seedWrap"><span>'+l_no+'</span></span>',
				'<span class="lotteryMatch__playerWrap">',
					'<span class="lotteryMatch__playerInner">',
						'<span class="lotteryMatch__player [ _player1 ]">'+l_player+'</span>',
						'<span class="lotteryMatch__belong [ _belong1 ]">'+l_team+'</span>',
					'</span>',
				'</span>',
        '<span class="lotteryMatch__matchNo"><input class="cls_matchNum" type="number" id="eliteMatch_'+matchNo+'"></span>',
			'</p>',
			'<p id = '+r_id+' class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
				'<span class="lotteryMatch__seedWrap"><span>'+r_no+'</span></span>',
				'<span class="lotteryMatch__playerWrap">',
					'<span class="lotteryMatch__playerInner">',
					'<span class="lotteryMatch__player [ _player1 ]">'+r_player+'</span>',
						'<span class="lotteryMatch__belong [ _belong1 ]">'+r_team+'</span>',
					'</span>',
				'</span>',
        '<span class="lotteryMatch__matchNo"></span>',
			'</p>'
		].join('');
	}
	else {
		html = [
			'<p id = '+l_id+' class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
        '<span class="lotteryMatch__matchNo"><input class="cls_matchNum" type="number" id="eliteMatch_'+matchNo+'"></span>',
			'</p>',
			'<p id = '+r_id+' class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
        '<span class="lotteryMatch__matchNo"></span>',
			'</p>'
		].join('');
	}

   return html;
}

/* ==================================================================================
      선수 찾기
   ================================================================================== */
function MsgBoxSearchPlayerEx(nPos) {
    var strPopup = utx.sprintf(" <div>  \
	 	선수명 / 소속 검색 <br>    \
	 	<input id='radio_search0' onclick='onChangeInput(0)' name='search_type' checked style='position:relative;top:4px;' type='radio'/>\
		<label for='radio_search0' style='margin:0 10px 0 5px;'>일반선택</label> \
		<input id='radio_search1' onclick='onChangeInput(1)' name='search_type' style='position:relative;top:4px;' type='radio'/>\
		<label for='radio_search1' style='margin:0 0 0 5px;'>Q선택</label> <br><br>\
		<input type='text' id = 'txt_manual_search'/>\
		<select style='display:none;' id='select_search'>\
			<option></option>\
		</select>   \
		<div id='check_seed_box'>\
			<input type='checkbox' onchange='onChangeCheckbox(event)' id = 'check_seed' style='position:relative;top:3px;margin:15px 0 4px 0;'/>\
			<label for='check_seed' style='margin:0 0 0 5px;'>Seed 추가</label>\
			<input style='width:171px;' type='number' id = 'check_seed_txt' disabled='true'/>\
		</div>\
	 <br></div>   \
	<div class='btn-box'>   \
		<a href='#' class='btn ok-btn' onClick='onClickMsg4_OK({0})';>확인</a> \
   </div>   ", nPos);
    ctx.writeHtmlToDiv("msg_box4", strPopup);
    setTimeout(function() {
        $("#txt_manual_search").focus();
    }, 600);
    msgbox_show("modal-four");
}


/* ==================================================================================
   data set-  tonament block - double game
   data를 입력받아 복식 게임일때 block을 그린다.
================================================================================== */
function boardInner_setNumDouble(data)
{
  sindou=1;
   var aryl_player, aryl_team;
   var aryr_player, aryr_team;
   var l_sel, r_sel;
   var l_fill, r_fill;
   var l_no, r_no;
   var l_spVal, r_spVal;
   var l_firstMan, r_firstMan;
   var l_pcode, r_pcode;
   var matchNo = 0;
   var r_param, l_param;
   var l_id, r_id;
	var l_param_id, r_param_id;
	var l_order, r_order;
	var round_1 = 0;

   if(data){
		matchNo = data.matchNo;
		round_1 = data.round_1;

      aryl_player  = (data.l_player.indexOf(',') == -1) ? [data.l_player, ""] : data.l_player.split(',');
      aryl_team    = (data.l_team.indexOf(',') == -1)   ? [data.l_team, ""]   : data.l_team.split(',');
      aryr_player  = (data.r_player.indexOf(',') == -1) ? [data.r_player, ""] : data.r_player.split(',');
      aryr_team    = (data.r_team.indexOf(',') == -1)   ? [data.r_team, ""]   : data.r_team.split(',');

      l_spVal        = data.l_spVal;
      l_firstMan     = data.l_firstMan;
			l_pcode        = data.l_pcode;
			l_order   		 = data.l_order;

      r_spVal        = data.r_spVal;
      r_firstMan     = data.r_firstMan;
			r_pcode        = data.r_pcode;
			r_order   		 = data.r_order;

      l_fill = data.l_fill ? 's_filled' : '';
      r_fill = data.r_fill ? 's_filled' : '';

      l_sel = data.l_sel ? 's_selected' : '';
			r_sel = data.r_sel ? 's_selected' : '';

			if(gSelManual == false) {		// 수동 배정이 아닐때만 보여준다.
				if(l_order != ' ') aryl_player[0] = utx.sprintf("{0}-({1})", aryl_player[0], l_order);			// for test
				if(r_order != ' ') aryr_player[0] = utx.sprintf("{0}-({1})", aryr_player[0], r_order);			// for test
			}

      if(l_firstMan == 1) {
            aryl_player[0] = utx.sprintf("* {0}", aryl_player[0]);
            aryl_player[1] = utx.sprintf("* {0}", aryl_player[1]);
      }
      if(r_firstMan == 1) {
            aryr_player[0] = utx.sprintf("* {0}", aryr_player[0]);
            aryr_player[1] = utx.sprintf("* {0}", aryr_player[1]);
      }

      // 재고.....
      l_no = (matchNo * 2) + 1;
      r_no = (matchNo * 2 + 1) + 1;

      l_id = utx.sprintf("\"pid_{0}\"", l_pcode);
      r_id = utx.sprintf("\"pid_{0}\"", r_pcode);

      l_param_id = utx.sprintf("pid_{0}", l_pcode);
      r_param_id = utx.sprintf("pid_{0}", r_pcode);

      l_param = utx.sprintf("'{0}','{1}','{2}','{3}'", l_no, l_spVal, l_pcode, l_param_id);
      r_param = utx.sprintf("'{0}','{1}','{2}','{3}'", r_no, r_spVal, r_pcode, r_param_id);
   }

	var html = '';
	if(round_1) {
   	html = [
			'<p id = '+l_id+' class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
				'<span class="lotteryMatch__seedWrap"><span>'+l_no+'</span></span>',
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
        '<span class="lotteryMatch__matchNo"><input class="cls_matchNum" type="number" id="eliteMatch_'+matchNo+'"></span>',
			'</p>',
			'<p id = '+r_id+' class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
				'<span class="lotteryMatch__seedWrap"><span>'+r_no+'</span></span>',
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
        '<span class="lotteryMatch__matchNo"></span>',
			'</p>'
		].join('');
	}
	else {
		html = [
			'<p id = '+l_id+' class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
				'<span class="lotteryMatch__seedWrap1">'+l_spVal+'</span>',
				'<span class="lotteryMatch__seedWrap">'+l_no+'</span>',
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
			'</p>',
			'<p id = '+r_id+' class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
				'<span class="lotteryMatch__seedWrap1">'+r_spVal+'</span>',
				'<span class="lotteryMatch__seedWrap">'+r_no+'</span>',
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
			'</p>'
		].join('');
	}
   return html;
}

</script>
