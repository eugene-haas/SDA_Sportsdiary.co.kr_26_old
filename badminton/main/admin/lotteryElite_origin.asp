<!-- #include virtual = "/pub/charset.asp" -->
<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.pubcode.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.teamGB.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.lvInfo.asp" -->  

<%
   Dim strName1, strName2, strName3
   Dim strSName1, strSName2, strSName3

   playType = rxPubGetName("B0020001")
   TeamGb = rxTeamGBGetName("15001")
   Level = rxLevelName("16001002")

   Sex = rxPubGetName("Man")
   GroupGameGb = rxPubGetName("B0030001")
   LevelJooName = rxPubGetName("B0110001") 

   strLog = strPrintf("playType = {0}, TeamGb = {1}, Level = {2}<br>", Array(playType, TeamGb, Level) )
   response.write strLog

   strLog = strPrintf("Sex = {0}, GroupGameGb = {1}, LevelJooName = {2}<br>", Array(Sex, GroupGameGb, LevelJooName) ) 
   response.write strLog
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
<script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>
<script type="text/javascript" src="/pub/js/etc/utx.js<%=UTX_JSVER%>"></script>
<script type="text/javascript" src="/pub/js/etc/ctx.js<%=CTX_JSVER%>"></script>
<script type="text/javascript" src="/pub/js/etc/bmx.js<%=BMX_JSVER%>"></script>
<script type="text/javascript" src="/js/GameTitleMenu/LotteryElite.js?ver=1.1.7"></script>  

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
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1){width:20%;/* border-right:1px solid #eee; */height:112px;display:flex;align-items:center;}
  .lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1)>span{margin:auto;}
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(2){min-height:112px;display: flex;align-items: center;
  width:65%;border-right:1px solid #eee;border-left:1px solid #eee;}
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(3){width:15%;line-height:102px;}
	.lotteryElite .right-con .entryBox__footer .entryBox__row{border-bottom:0;}
	.lotteryElite .right-con .entryBox__footer .entryBox__col:nth-child(1){width:85%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__footer .entryBox__col:nth-child(2){width:15%;}
	.lotteryElite .right-con .entry{width:100%;padding:16px 10px;/* white-space:nowrap; */overflow:auto;line-height:normal;text-align:left;}
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
		border-color:#f2f2f2; /* border-style:solid; */
		display:flex;
    opacity:0.5;
    cursor:pointer;
	}
	.lotteryMatch.s_selected{border:2px solid #ff8300;}
	.lotteryMatch.s_duplicate{border:2px solid #2db23c;}

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
		border-radius:4px 4px 0 0;
    border-color:#f2f2f2;
	}
	.lotteryMatch_second .lotteryMatch__seedWrap{ top:50%;
    border-style:solid;
		border-width:1px 0 0 0;
		border-radius:0 0 4px 4px;
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
   var gPlayType = "";
   var gSelGameKind = "";              // 선택한 게임 종별 
   var gDisplayList = false;           // 우측 List를 뿌렸는지 유무 
   var gAryMUser = null;               // 수동 입력시 사용 - Player 이름순 배열 
   var gAryMTeamUser = null;           // 수동 입력시 사용 - Team - Player 이름순 배열 
   var gAryPos = null;                 // Tonament 참가자 배치 Position Array 
   var gAryQPos = null;                 // 예선조 참가자 배치 Position Array  
   var gAryMenual = null;              // 수동배정일 경우 auto complete에 들어갈 배열값. 

   var gSelID = "";                    // 본선, 혹은 예선 Selected id 
   var gSelPart = "";                  // E_PART_Q, E_PART_F 사용 
   var gSelManual = false;             // Manual Assign (수동배정)이 선택 되었는가? 
   var E_POS_NORMAL, E_POS_SEED, E_POS_BYE, E_POS_Q, E_POS_MANUAL;
   var E_PART_Q, E_PART_F;             // 예선, 본선 
   

   E_POS_NORMAL            = 0;               // 일반 자리 
   E_POS_SEED              = 1;               // Seed 자리 
   E_POS_BYE               = 2;               // Bye 자리 
   E_POS_Q                 = 3;               // 예선전 조 자리 
   E_POS_MANUAL            = 4;               // 수동 배정 자리 

   E_PART_Q                = 0;               // 예선
   E_PART_F                = 1;               // 본선

</script>

<form name="frmPopup">
   <input type="hidden" name="pos">
   <input type="hidden" name="q_pos">
   <input type="hidden" name="playType">
   <input type="hidden" name="gameInfo">
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
				<a href="#"  onclick = "onBtnPreview();">미리보기</a>
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

			<div>
				<div class="btn-box btm-btn-box">
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
   CMD_ELITEMAKETOURNAMENT = 30;        // make Elite Tournament Info - 엘리트 선수 토너먼트를 연산한다. 
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

      // ctx.showElementEx("cls_QTournament", true);
      // ctx.showElementEx("cls_FTournament", false);

    });

/* ==================================================================================
      웹페이지 종료, 리프레쉬 할때 호출 
      - 생성한 객체 ( tonament Object )을 제거한다.  
   ================================================================================== */ 
   window.onbeforeunload = function() {
      console.log("Window closed");
      f_tournament = null; 

      var i = 0, len = aryQ_tournament.length; 

      for(i=0; i<len; i++)
      {
         aryQ_tournament[i] = null; 
      }
      aryQ_tournament.splice(0, len);
      aryQ_tournament = null;       
   }

/* ==================================================================================         
      대회선택, 연동대회 선택시 autocomplete를 구현하기 위한 함수 
      연동대회 일때만 제한 조건이 있다 - 종료 대회만 bEndGame를 이용하여 구분한다. 
   ================================================================================== */
   function initSearchControl(id_ctrl, id_val, bEndGame) 
   {
   $( "#"+id_ctrl ).autocomplete({
      source : function( request, response ) {
         $.ajax(
         {
               type: 'post',
               url: "../../Ajax/GameTitleMenu/searchGameTitle.asp",
               dataType: "json",
               data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHGAMETITLE, "SVAL":request.term, "ENDGAME":bEndGame}) },
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

      var Url ="../../ajax/GameTitleMenu/lotteryElite_GameKind.asp"
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
      var Url ="../../ajax/GameTitleMenu/lotteryElite_SeedPlayer.asp"

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
   function SearchElitePlayer(cTitleIdx, cLevelIdx, cPlayType)
   {
      var packet = {};
      console.log("SearchElitePlayer");

      var Url ="../../ajax/GameTitleMenu/lotteryElite_GamePlayer.asp"
      packet.CMD = CMD_ELITEGAMEPLAYER;
      packet.TIDX = cTitleIdx;
      packet.LVIDX = cLevelIdx;
      packet.PLAYTYPE = cPlayType;

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


         utx.printInfo2DAry(gAryGameUser, "prev reduce gAryGameUser");
         gAryGameUser = reduceAryUserForTest(gAryGameUser);          // For Test
         utx.printInfo2DAry(gAryGameUser, "after reduce gAryGameUser");

         makeTeamOrder(gAryGameUser, playType);
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

         utx.printInfo2DAry(gAryGameUser, "onRcvEliteGamePlayer");
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

      if(strPos != "") {          
         gAryPos =  utx.Get2DAryFromStr(strPos, "|", ",");   
         createTournament(gAryPos);
      }

      if(strQPos != "") {         
         gAryQPos =  utx.Get2DAryFromStr(strQPos, "|", ",");      
         createQTournament(gAryQPos);
      }
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

      var strLog = utx.strPrintf("onSelGameKind sel_val = {0}, titleIdx = {1}, levelIdx = {2}, cSex = {3}, cTeamGB = {4}, cPlayType = {5}, cGroupGameGB = {6}", 
                     sel_val, cTitleIdx, cLevelIdx, cSex, cTeamGB, cPlayType, cGroupGameGB);
      
      console.log(strLog);     

      gDisplayList = false; 
      clearList();
      SearchElitePlayer(cTitleIdx, cLevelIdx, cPlayType);     
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

         utx.printInfo2DAry(gAryGameUser, "prev reduce gAryGameUser");
         gAryGameUser = reduceAryUserForTest(gAryGameUser);          // For Test
         utx.printInfo2DAry(gAryGameUser, "after reduce gAryGameUser");
         ManualApplyList(gAryGameUser, gPlayType); 
         return; 
      }

      var strAssocGame = ctx.getTextboxVal("edit_AssoGameTitle"); 

      // Seed를 적용할 경우 Seed를 찾고 , Ajax 호출 Recv한 후 리스트에 적용하고 
      if( bSearchSeed == true && strAssocGame != "")
      {         
         SearchSeedPlayer(sel_rank);
      }
      else {    
         utx.printInfo2DAry(gAryGameUser, "prev reduce gAryGameUser");
         gAryGameUser = reduceAryUserForTest(gAryGameUser);          // For Test
         utx.printInfo2DAry(gAryGameUser, "after reduce gAryGameUser");
         makeTeamOrder(gAryGameUser, gPlayType);
         printAryGameUser(gAryGameUser);              
         if(!ApplyList(gAryGameUser, gPlayType)) return; 
      }

      gDisplayList = true; 

      var strLog = utx.strPrintf("sel_assign = {0}, sel_rank = {1}", sel_assign, sel_rank);
      console.log(strLog);

      ctx.writeHtmlToDiv("div_QTournament_body", "");    
      ctx.writeHtmlToDiv("div_FTournament", "");
   }

   /* ==================================================================================
         초기화 버튼 
      ================================================================================== */
   function onBtnInit()
   {      
      var strPlayer, strTeam, strOrder;

      strPlayer = "Aramdry";
      strTeam = "주)위드라인";
      strOrder = "1위";
      MsgBoxRanker(strPlayer, strTeam, strOrder);
   }

   /* ==================================================================================
         미리보기 버튼 
      ================================================================================== */
   function onBtnPreview()
   {      
      // var nCntUser, nRound;

      // nCntUser = 120;
      // nRound = 64;
      // MsgBoxConfirm(nCntUser, nRound);  edit_GameTitle  sel_GameKind

      var strPos, strQPos, url, strGInfo, strGTitle, strGKind; 

      url = "./lotteryElite_print.asp"
      strPos =  utx.GetStrFrom2DAry(gAryPos, "|", ",");   
      strQPos =  utx.GetStrFrom2DAry(gAryQPos, "|", ",");
      strGKind = ctx.getSelectText("sel_GameKind"); 
      strGTitle   = ctx.getTextboxVal("edit_GameTitle"); 
      strGInfo = utx.sprintf("{0},{1}", strGTitle, strGKind); 

      open_print(url, strPos, strQPos, gPlayType, strGInfo);
   }

   /* ==================================================================================
         최종완료 버튼 
      ================================================================================== */
   function onBtnComplete()
   {      
      console.log("onBtnComplete");
      MsgBoxSearchPlayer(0);
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
      var child_eds = ctx.getChildAllByCID("div_entry_body", "entry__input");
      var ctrl_id = "", groupIdx = "", seedNo = "", len = child_eds.length; 
      var arySeedNo = new Array(); 
      var aryCheck = new Array(); 
      var strSeedInfo = "", strOrderInfo = "", strTeamOrder = "", stgLog = "";
      var selRound = ctx.getSelectVal("sel_round");
      var nCnt = 0, userCnt = gAryGameUser.length; 
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
            arySeedNo.push([groupIdx, seedNo]); 

            if(strSeedInfo == "") strSeedInfo = utx.sprintf("{0},{1}", groupIdx, seedNo); 
            else strSeedInfo = utx.sprintf("{0}|{1},{2}", strSeedInfo, groupIdx, seedNo); 
         }

         strLog = utx.strPrintf("idx = {0}, id = {1}, val = {2}", (i+1), ctrl_id, ctx.getTextboxVal(ctrl_id)); 
         console.log(strLog); 
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
      }

      bmx.IsDoublePlay(gPlayType);
      nCnt = (bmx.IsDoublePlay(gPlayType)) ? (userCnt / 2) : userCnt; 
      if(nCnt > selRound) nCnt = selRound;      // 예선전이 있을 경우 Round로 Seed갯수를 구한다. 

      if(bmx.IsValidSeedCnt(nCnt, seedCnt) == false)
      {
         strLog = utx.sprintf("시드를 {0}개 설정하셨습니다. \r\n참여인원이 {1}명인 토너먼트에서는 시드를 최대 {2}개까지 설정할수 있습니다.\r\n",
                     seedCnt,  nCnt, bmx.getSeedCnt(nCnt)); 
         alert(strLog);
         return; 
      }

     ApplySeedNoToReqAry(gAryGameUser, arySeedNo);
     printAryGameUser(gAryGameUser); 

      strOrderInfo = getStrDataOrder(gAryGameUser);
      strTeamOrder = getStrTeamOrder(gAryGameUser); 

      //console.log(strSeedInfo); 
      reqMakeTournament(strOrderInfo, strSeedInfo, strTeamOrder, selRound, userCnt); 

      // reset select id
      SetSelTourBlock(gSelID, "");
      gSelID = "";

      ctx.writeHtmlToDiv("div_QTournament_body", "");    
      ctx.writeHtmlToDiv("div_FTournament", "");    
   }

   /* ==================================================================================
         seed Info, order Info를 가지고 tournament Info를 request한다. ( ajax call )
      ================================================================================== */
   function reqMakeTournament(strOrderInfo, strSeedInfo, strTeamOrder, nRound, userCnt)
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
      console.log("reqMakeTournament");

      var Url ="../../ajax/GameTitleMenu/lotteryElite_MakeTournament.asp"
      packet.CMD = CMD_ELITEMAKETOURNAMENT;
      packet.TIDX = cTitleIdx;
      packet.LVIDX = cLevelIdx;
      packet.PLAYTYPE = cPlayType;
      packet.ORDERINFO = strOrderInfo;
      packet.TEAMORDER = strTeamOrder;
      packet.SEEDINFO = strSeedInfo;
      packet.ROUND = nRound;
      packet.USERCNT = userCnt;

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

      var strUser, strGroupIdx; 
      strUser = ctx.getTextboxVal("txt_manual_search"); 
      strGroupIdx = utx.getBlockData(strUser, "-", ""); 

      strLog = utx.sprintf("onClickMsg4_OK - {0} {1} {2}", nPos, strUser, strGroupIdx); 
      console.log(strLog);

      msgbox_hide("modal-four");

      if(strUser == "" || strGroupIdx == "") return; 
      applyMenualSel(gAryPos, gAryGameUser, strGroupIdx, nPos);

      createTournament(gAryPos);
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

      // this.event.stopPropagation(); 
     // this.stopPropagation(); 
      
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
      
      var strLog, ret; 

      strLog = utx.sprintf("sel_no = {0}, sel_spVal = {1}, sel_pCode = {2}, sel_id = {3}", sel_no, sel_spVal, sel_pCode, sel_id)
      console.log(strLog);      

      if(sel_pCode == "BYE") return; 

      if(gSelID != "")
      {         
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
      
      SetSelTourBlock(gSelID, sel_id);
      gSelID = sel_id; 
      
      ctx.setTextboxVal("txt_manual_search", ""); 
      MsgBoxSearchPlayer(sel_no);
      // 수동 입력시 사용하는 입력박스 연동 . 
      $("#txt_manual_search").autocomplete({source: gAryMenual});
      
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

      utx.printInfo2DAry(rAryPos, "In createQTournament");

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
      if(len == nQGroupSize) 
      {
         if(rAryPos[1][2] ==  E_POS_BYE && rAryPos[2][2] ==  E_POS_BYE)
         {
            IsFinal = 1; 
            roundQ = 2; 
            obj = fillUserInfo(0, rAryPos[0], rAryPos[3], IsDblPlay);
            aryData[nOrder].push(obj) 
         }        
      }
      
      if(!IsFinal)
      {
         for(i = 0; i< len; i+=2)
         {
            if(i && i%nQGroupSize == 0) nOrder++;
            obj = fillUserInfo(i, rAryPos[i], rAryPos[i+1], IsDblPlay);
            aryData[nOrder].push(obj)           
         }
      }

      for(i = 0; i< nQGroup; i++)
      {
         id_divQ = utx.strPrintf("{0}{1}", id_base, i+1);
         tournamentQ = makeTournament(id_divQ);
         drawTournament2(tournamentQ, roundQ, roundQ, roundQ, aryData[i]);
      }
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

      utx.printInfo2DAry(rAryPos, "In createTournament");

      for(i = 0; i< round; i+=2)
      {
         obj = fillUserInfo(i, rAryPos[i], rAryPos[i+1], IsDblPlay);
         aryData.push(obj)  
      }

      f_tournament = makeTournament("div_FTournament");
      drawTournament2(f_tournament, round, round, round, aryData);
   }

/* ==================================================================================
      tournament에 사용할 data object을 만든다. 
   ================================================================================== */
   function fillUserInfo(Idx, l_info, r_info, IsDblPlay)
   {
      var obj = {}; 
      var nMax = 8; 

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
         if(l_info[2] == E_POS_SEED) obj.l_spVal      =  l_info[3];    
         obj.l_player   =  (IsDblPlay == 0)? l_info[7] : utx.sprintf("{0},{1}",l_info[7], l_info[9]);
         obj.l_team     =  (IsDblPlay == 0)? getSimpleTeamName(l_info[9], nMax) : utx.sprintf("{0},{1}",getSimpleTeamName(l_info[11], nMax), getSimpleTeamName(l_info[13], nMax));      
         
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
         if(r_info[2] == E_POS_SEED) obj.r_spVal      =  r_info[3];  
         obj.r_player   =  (IsDblPlay == 0)? r_info[7] : utx.sprintf("{0},{1}",r_info[7], r_info[9]);
         // obj.r_team     =  (IsDblPlay == 0)? r_info[9] : utx.sprintf("{0},{1}",r_info[11], r_info[13]);
         obj.r_team     =  (IsDblPlay == 0)? getSimpleTeamName(r_info[9], nMax) : utx.sprintf("{0},{1}",getSimpleTeamName(r_info[11], nMax), getSimpleTeamName(r_info[13], nMax));      
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
   function reduceAryUserForTest(rAryUser)
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

      utx.printInfo2DAry(aryUser, "reduceAryUserForTest");

      return aryUser; 
   }

/* ==================================================================================
      미리 보기를 누를 경우 새창으로 띄워준다. For Print
   ================================================================================== */
   function open_print(url, arg1, arg2, arg3, arg4){
      var frmPop= document.frmPopup;      
      window.open('',"pop_print");  

      frmPop.method = "Post";
      frmPop.action = url;
      frmPop.target = 'pop_print'; //window,open()의 두번째 인수와 같아야 하며 필수다.  
      frmPop.pos.value = arg1;
      frmPop.q_pos.value = arg2;  
      frmPop.playType.value = arg3;  
      frmPop.gameInfo.value = arg4; 
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
      var nMaxQGroup, nQGroup, strMsg, nQRow, nCol; 
      selRound = Number(ctx.getSelectVal("sel_round"));  
      IsDblPlay = bmx.IsDoublePlay(gPlayType);

      gAryPos = null;                 // Tonament 참가자 배치 Position Array      

      nUserCnt = rAryGameUser.length; 
      nUserCnt = (IsDblPlay == 1) ? (nUserCnt) / 2 : (nUserCnt); 
      
      if(nUserCnt > selRound) {
         strMsg = "수동 배정은 본선만 진행합니다. ";
         alert(strMsg); 
         return; 
      }

      if(selRound == 0) 
      {
         alert("토너먼트 강수를 선택하셔야 합니다.");
         return; 
      }

      // 데이터 초기화 
      ctx.writeHtmlToDiv("div_entry_body", "");                // 우측 엔트리 리스트 
      ctx.setSpanText("sp_entry_total", "");                   // 우측 엔트리 리스트 Total Count
      ctx.writeHtmlToDiv("div_QTournament_body", "");          // 좌측 예선 토너먼트 
      ctx.writeHtmlToDiv("div_FTournament", "");               // 좌측 본선 토너먼트 

      gAryPos = makeEmptyAryPos(selRound, IsDblPlay); 
      applyByeToPos(gAryPos, nUserCnt); 

      createTournament(gAryPos); 
      gAryMenual = createAryMenual(rAryGameUser, IsDblPlay); 
      
      // // 수동 입력시 사용하는 입력박스 연동 . 
      // $("#txt_manual_search").autocomplete({source: gAryMenual});
   }

/* ==================================================================================
      수동입력시 에디트 박스에 나타나는 User이름 배열 
   ================================================================================== */
   function createAryMenual(rAryGameUser, IsDblPlay) {
      var i , len, pos, step = 1, strData, aryMenual; 
      len = rAryGameUser.length;
      if(IsDblPlay == 1) step = 2;       
      aryMenual = []; 

      for(i = 0; i< len; i += step)
      {
         if(IsDblPlay == 1) {
            strData = utx.sprintf("{0}({1})/{2}({3})-{4}", 
               rAryGameUser[i][9], rAryGameUser[i][11], rAryGameUser[i+1][9], rAryGameUser[i+1][11], rAryGameUser[i][6]);
         }
         else {
            strData = utx.sprintf("{0}({1})-{2}", rAryGameUser[i][9], rAryGameUser[i][11], rAryGameUser[i][6]);
         }
         aryMenual.push(strData); 
      }

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
   function applyMenualSel(rAryPos, rAryGameUser, strGroupIdx, nPos){
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
      rAryPos[pos][2] = E_POS_NORMAL; 
      rAryPos[pos][3] = -1; 
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
   
   function GetUserIdx(rAryUser, strGroupIdx) {
      var i = 0, len = 0; 
      len = rAryUser.length; 

      for(i=0; i<len; i++)
      {
         if(rAryUser[i][6] == strGroupIdx) return i; 
      }
      return -1; 
   }

   
   function getSimpleTeamName(strTeam)
   {
      var nMax = 8, bReduceMark = false; 
      if(strTeam.indexOf("여자중학교") != -1)         strTeam.replace("여자중학교","여중");
      else if(strTeam.indexOf("여자고등학교") != -1)  strTeam.replace("여자고등학교","여고");
      else if(strTeam.indexOf("여자대학교") != -1)    strTeam.replace("여자대학교","여대");
      else if(strTeam.indexOf("남자중학교") != -1)    strTeam.replace("남자중학교","남중");
      else if(strTeam.indexOf("남자고등학교") != -1)  strTeam.replace("남자고등학교","남고");
      else if(strTeam.indexOf("남자대학교") != -1)    strTeam.replace("남자대학교","남대");
      else if(strTeam.indexOf("체육중학교") != -1)    strTeam.replace("체육중학교","체중");
      else if(strTeam.indexOf("체육고등학교") != -1)  strTeam.replace("체육고등학교","체고");
      else if(strTeam.indexOf("체육대학교") != -1)    strTeam.replace("체육대학교","체대");
      else if(strTeam.indexOf("초등학교") != -1)      strTeam.replace("초등학교","초");
      else if(strTeam.indexOf("중학교") != -1)        strTeam.replace("중학교","중");
      else if(strTeam.indexOf("고등학교") != -1)      strTeam.replace("고등학교","고");      
      else if(strTeam.indexOf("대학교") != -1)        strTeam.replace("대학교","대");
      else {
         strTeam = utx.reduceStr(strTeam, nMax, bReduceMark);  
      }

      return strTeam; 
   }


</script>