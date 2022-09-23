
   /* ==================================================================================
         gAryGameUser에 연동대회 상위 Rank Info를 채운다. 
         gArySeedUser에 대회 신청 여부를 채운다. 

         gAryGameUser와 gArySeedUser는 대회 자체가 틀리므로 playType이 단/복식 유무에 따라 
         memIdx를 1개 혹은 같은 GroupId의 memberIdx 2개를 비교하여 같은지를 확인한다. 

         gAryGameUser - fUse, SeedNo, Ranking, GameRequestGroupIDX, GameRequestPlayerIDX, MemberIDX, MemberName,
                        Team, TeamName, PrevTeam, PrevTeamName
         gArySeedUser - '0' As GameRanking, '0' As ReqGame, TourneyGroupIDX, MemberIDX, UserName, SEX, TEAM, TEAMNM
      ================================================================================== */
      function FillRankInfoToAryReq(rAryReq, rArySeed, playType)
      {
         var len = 0, i = 0, rIdx = 0, idx = 0, sIdx1 = 0, sIdx2 = 0; 
         if(rAryReq == null) return;          

         if(playType == "B0020001") { // 단식 
            len = rAryReq.length; 
            for(i=0; i<len; i++)
            {
               rIdx = checkSeedInfo(rArySeed, rAryReq[i][6])
               if(rIdx != -1) 
               {
                  // Ranking , Ranking 획득시 팀 정보 셋팅 
                  rAryReq[i][2] = rArySeed[rIdx][0]; 
                  rAryReq[i][10] = rArySeed[rIdx][6];
                  rAryReq[i][11] = rArySeed[rIdx][7];
               }
            }
         }
         else {                        // 복식 
            len = rAryReq.length/2; 
            for(i=0; i<len; i++)
            {
               idx = i * 2; 
               rIdx = checkSeedInfoDbl(rArySeed, rAryReq[idx][6], rAryReq[idx+1][6])
               if(rIdx != -1)
               {
                  if( rAryReq[idx][6] == rArySeed[rIdx][3])
                  {
                     sIdx1 = rIdx, sIdx2 = rIdx+1; 
                  }
                  else {
                     sIdx1 = rIdx+1, sIdx2 = rIdx; 
                  }

                  // Ranking , Ranking 획득시 팀 정보 셋팅 
                  rAryReq[idx][2] = rArySeed[sIdx1][0]; 
                  rAryReq[idx][10] = rArySeed[sIdx1][6];
                  rAryReq[idx][11] = rArySeed[sIdx1][7];

                  rAryReq[idx+1][2] = rArySeed[sIdx2][0]; 
                  rAryReq[idx+1][10] = rArySeed[sIdx2][6];
                  rAryReq[idx+1][11] = rArySeed[sIdx2][7];
               }
            }
         }
      }

   /* ==================================================================================
         단식 - rArySeed에서 memIdx를 인자로 받아 이번대회 출전 여부를 체크한다. 
      ================================================================================== */
      function checkSeedInfo(rArySeed, memIdx)
      {
         var len = 0, i = 0; 
         if(rArySeed == null) return -1; 

         len = rArySeed.length; 
         for(i = 0; i<len; i++)
         {
            if(rArySeed[i][0] && rArySeed[i][3] == memIdx)     // Ranking Data가 있고 memIdx가 같다면 같은 사람
            {
               rArySeed[i][1] = 1         // 이번 대회에 출전한다. 
               return i; 
            }
         }

         return -1; 
      }

   /* ==================================================================================
         복식 - rArySeed에서 memIdx1, memIdx2를 인자로 받아 이번대회 출전 여부를 체크한다. 
      ================================================================================== */
      function checkSeedInfoDbl(rArySeed, memIdx1, memIdx2)
      {
         var len = 0, i = 0, idx1; 
         if(rArySeed == null) return -1; 

         len = rArySeed.length/2; 
         for(i = 0; i<(len); i++)
         {
            idx1 = i * 2;
            if(rArySeed[idx1][0])
            {
               if( (rArySeed[idx1][3] == memIdx1 && rArySeed[idx1+1][3] == memIdx2) || 
                   (rArySeed[idx1+1][3] == memIdx2 && rArySeed[idx1][3] == memIdx1)  ) {
                  rArySeed[idx1][1] = 1         // 이번 대회에 출전한다. 
                  rArySeed[idx1+1][1] = 1         
                  return idx1; 
               }
            }
         }

         return -1; 
      }

   /* ==================================================================================
         gArySeedUser에 Medal값을 채운다 .
         '0' As GameRanking, '0' As ReqGame, TourneyGroupIDX, MemberIDX, UserName, SEX, TEAM, TEAMNM

         aryMedal  -  TourneyGroupIDX, GameMedalIDX
      ================================================================================== */
      function FillSeedMedal(nRank, rArySeed, rAryMedal)
      {
         var len = 0, i = 0, medalOrder = 0; 
         if(rArySeed == null) return; 
   
         len = rArySeed.length; 
         for(i = 0; i<len; i++)
         {
            medalOrder = findMedalInfo(rAryMedal, rArySeed[i][2])
            if(medalOrder && nRank >= medalOrder) rArySeed[i][0] = medalOrder
         }
      }

   /* ==================================================================================
         gArySeedUser에 Rank값을 채운다 .
         '0' As GameRanking, '0' As ReqGame, TourneyGroupIDX, MemberIDX, UserName, SEX, TEAM, TEAMNM
      ================================================================================== */
      function FillSeedRank(nRank ,rArySeed, rAryRank8, rAryRank4)
      {
         var len = 0, i = 0; 
         if(rArySeed == null) return; 
         if(nRank <= 4) return; 
   
         len = rArySeed.length; 

         if(nRank <= 8)
         {
            // 기본 8강 
            for(i = 0; i<len; i++) rArySeed[i][0] = 8

            // 4강 셋팅 
            for(i = 0; i<len; i++)
            {
               if(findRankInfo(rAryRank4, rArySeed[i][2])) rArySeed[i][0] = 4
            }
         }
         else if(nRank <= 16)
         {
            // 기본 16강 
            for(i = 0; i<len; i++) rArySeed[i][0] = 16

            // 8강 셋팅 
            for(i = 0; i<len; i++)
            {
               if(findRankInfo(rAryRank8, rArySeed[i][2])) rArySeed[i][0] = 8
            }

            // 4강 셋팅 
            for(i = 0; i<len; i++)
            {
               if(findRankInfo(rAryRank4, rArySeed[i][2])) rArySeed[i][0] = 4
            }
         }
      }

   /* ==================================================================================         
         groupIdx를 인자로 받아 , rAryRank에 해당 groupIdx가 있는지 찾는다.        
          L_TourneyGroupIDX, R_TourneyGroupIDX
      ================================================================================== */
      function findRankInfo(rAryRank, groupIdx)
      {
         var i = 0, len = 0;
         if(rAryRank == null) return 0; 

         len = rAryRank.length; 
         for(i=0; i<len; i++)
         {
            if(rAryRank[i][0] == groupIdx || rAryRank[i][1] == groupIdx ) return 1; 
         }
         return 0; 
      }

   /* ==================================================================================
         groupIdx를 인자로 받아 , aryMedal에 해당 groupIdx가 있는지 찾는다.       
          TourneyGroupIDX, GameMedalIDX
      ================================================================================== */
      function findMedalInfo(aryMedal, groupIdx)
      {
         var i = 0, len = 0;
         if(aryMedal == null) return 0; 

         len = aryMedal.length; 
         for(i=0; i<len; i++)
         {
            if(aryMedal[i][0] == groupIdx ) return aryMedal[i][1]; 
         }
         return 0; 
      }
   
// **********************************************************************************
//       Message Box
// **********************************************************************************

/* ==================================================================================
      Ranker Infomation 
   ================================================================================== */
function MsgBoxRanker(strPlayer, strTeam, strKind, strOrder)
{
   var strPopup = "    \
      <p class='p-name'>Place_Player</p>    \
      <p class='p-temper'>Place_Team</p>    \
      <p class='p-temper'>Place_Kind</p>  \
      <p class='p-ranking'>Place_Order</p>  \
      <a href='#' class='btn ok-btn' onClick=\"onClickMsg1_OK();\">확인</a>    \
      ";

   strPopup = utx.strReplaceAll(strPopup, "Place_Player", strPlayer);
   strPopup = utx.strReplaceAll(strPopup, "Place_Team", strTeam);
   strPopup = utx.strReplaceAll(strPopup, "Place_Kind", strKind);
   strPopup = utx.strReplaceAll(strPopup, "Place_Order", strOrder);

   ctx.writeHtmlToDiv("msg_box1", strPopup);
   msgbox_show("modal-one");
}

/* ==================================================================================
      Entry Confirm
   ================================================================================== */
function MsgBoxConfirm(nCntUser, nRound)
{
   var strPopup = "    \
      <p class='p-txt'>전체 엔트리 : <span>Place_CntUser명</span></p>   \
      <p class='p-txt'>강수 : <span>Place_Round강</span></p>   \
      <p class='b-txt'>저장하시겠습니까?</p>   \
      <div class='btn-box'>   \
         <a href='#' class='btn ok-btn' onClick=\"onClickMsg2_Cancel();\">취소</a>   \
         <a href='#' class='btn ok-btn' onClick=\"onClickMsg2_OK();\">확인</a>   \
      </div>    \
      ";

   strPopup = utx.strReplaceAll(strPopup, "Place_CntUser", nCntUser);
   strPopup = utx.strReplaceAll(strPopup, "Place_Round", nRound);

   ctx.writeHtmlToDiv("msg_box2", strPopup);
   msgbox_show("modal-tow");
}


/* ==================================================================================
      Entry Confirm
   ================================================================================== */
function MsgBoxSeedList(arySeed, playType)
{
   var strPopup = " ", strUser = "", strAttend = "<li>", strNotAttend = "<li class='red-font'>";
   var i = 0, len = 0;
   len = arySeed.length; 

   for(i=0; i<len; i++)
   {
      if(arySeed[i][0] != 0) {
         strPopup += (arySeed[i][1] == 1) ? strAttend : strNotAttend;   
         
         if(arySeed[i][0] <= 3){
            strPopup += utx.strPrintf("<span class='number'>{0}위 </span>", arySeed[i][0]);
         }
         else {
            strPopup += utx.strPrintf("<span class='number'>{0}강 </span>", arySeed[i][0]);
         }

         if(playType == "B0020001")       // 단식 
         {
            strUser = utx.strPrintf("{0}({1})", arySeed[i][4], arySeed[i][7]);
         }
         else {                           // 복식 
            strUser = utx.strPrintf("{0}({1})/{2}({3})", arySeed[i][4], arySeed[i][7], arySeed[i+1][4], arySeed[i+1][7]);
            i++; 
         }

         strPopup += utx.strPrintf("<span class='name'>{0}</span>", strUser);
         strPopup += "</li>"
      }
   }


   strPopup += "    \
      <div class='btn-box'>   \
         <a href='#' class='btn ok-btn' onClick=\"onClickMsg3_OK();\">확인</a>   \
      </div>    \
      ";

   ctx.writeHtmlToDiv("msg_box3", strPopup);
   msgbox_show("modal-three");
}

/* ==================================================================================
      선수 찾기 
   ================================================================================== */
function MsgBoxSearchPlayer(nPos)
{
   var strPopup = " "
   msgbox_show("modal-four");
}

/* ==================================================================================
      Message Box Modal Show 
================================================================================== */
function msgbox_show(id_msgbox)
{
   if(!($(".modal-warp").hasClass("on"))){
      $("."+id_msgbox).addClass("on").css("display","block");
      $(".fixed-bg").addClass("on").css("display","block");
   }
}

/* ==================================================================================
     Message Box Modal Hide
================================================================================== */
function msgbox_hide(id_msgbox)
{
   $(".modal-warp").removeClass("on").css("display","none");
   $("."+id_msgbox).removeClass("on").css("display","none");
   $(".fixed-bg").removeClass("on").css("display","none");
}

// **********************************************************************************
//       참가자 리스트 
// **********************************************************************************

/* ==================================================================================
   Test Func - 참가신청 리스트 
   aryReqUser Field  -  fUse, SeedNo, Ranking, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, 
                        MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName
   ================================================================================== */   
function ApplyList(aryReq, playType)
{
   var i = 0, len = aryReq.length, strTeam = "", cntTotal = 0, cntTeam = 0;
   var strHtml = "", strSeedMark = "s_related"; 

   for(i = 0; i<len; i++)
   {
      if(strTeam != aryReq[i][9])      // Team Name - entrybox row start 
      {
         // 이전팀의 cnt를 Display하고 row를 마무리 한다. 
         if( strTeam != "")
         {
            strHtml += utx.strPrintf(" </div>  </div> <div class='entryBox__col'>	<span>{0}</span> </div>  </div>", cntTeam );
            cntTotal += cntTeam;
         }

         strTeam = aryReq[i][9];
         strHtml += utx.strPrintf("<div class='entryBox__row'> <div class='entryBox__col'> <span>{0}</span> </div>"
                        , strTeam); 
         
         strHtml += "<div class='entryBox__col'> <div class='entry'> "            
         cntTeam = 0;                
      }

      if(playType == "B0020001") {  // 단식 
         strHtml += utx.strPrintf("<button class='entry__item {0}' onClick=\"onClickRankerInfo('{1}');\">	<p>{2}</p>", 
              ((aryReq[i][2]) ? strSeedMark : ""), aryReq[i][6], aryReq[i][7]) ;
      }
      else {                        // 복식             
         strHtml += utx.strPrintf("<button class='entry__item {0}' onClick=\"onClickRankerInfoDbl('{1}', '{2}');\">	<p>{3}</p> <p>{4}</p>", 
                     ((aryReq[i][2]) ? strSeedMark : ""), aryReq[i][6], aryReq[i+1][6], aryReq[i][7], aryReq[i+1][7]);
                     i++; 
      }
      
      strHtml += utx.strPrintf("<input type='text' id = 'ed_seed{0}' class='entry__input' maxlength='4' value='' onClick=\"onClickEditRankerInfo()\"> </button>", aryReq[i][4]); 
      cntTeam++; 
   }

   // 이전팀의 cnt를 Display하고 row를 마무리 한다. 
   if( strTeam != "")
   {
      strHtml += utx.strPrintf(" </div>  </div> <div class='entryBox__col'>	<span>{0}</span> </div>  </div>", cntTeam );
      cntTotal += cntTeam;
   }

   ctx.writeHtmlToDiv("div_entry_body", strHtml);
   ctx.setSpanText("sp_entry_total", cntTotal); 
}

// **********************************************************************************
//       Tournament
// **********************************************************************************

/* ==================================================================================
   make Tonament div - 예선전 토너먼트 생성시 사용 
   container tournament obj - 
================================================================================== */   
function createDivForTonament(id_parent, id_div)
{
   var strHtml = utx.strPrintf("<div id='{0}' class='bottom-list div_QTournament'> </div>", id_div );
   ctx.appendHtmlToDiv(id_parent, strHtml);
}

/* ==================================================================================
   make Tonament - div id를 입력받아 tonament Object을 생성하고 , 반환한다. 
================================================================================== */   
function makeTournament(id_div)
{
   var tournament = new Tournament();

   tournament.setOption({
      blockBoardWidth: 180, // integer board 너비
      blockBranchWidth: 30, // integer 트리 너비
      blockHeight : 50, // integer 블럭 높이(board 간 간격 조절)
      branchWidth : 2, // integer 트리 두께
      branchColor : '#dddddd', // string 트리 컬러
      roundOf_textSize : 10, // integer 배경 라운드 텍스트 크기
      scale : 1, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
      board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
         el:document.getElementById(id_div) // element must have id
      });


   tournament.setStyle('#'+id_div);

   tournament.boardInner = function(data){
      if(data && data.bDblPlay == 1) return boardInner_Double(data);
      return boardInner_single(data);
   }      
   return tournament;
}

/* ==================================================================================
   draw Tonament - tonament Object, round, data를 입력받아 tonament를 그린다. 
================================================================================== */ 
function drawTournament(objT, round, matchData)
{
   objT.draw({
      limitedStartRoundOf: round, //16    integer(짝수)  default:0 전체, 그리기 시작할 라운드 ex)8강 부터
      limitedEndRoundOf: round, //8       integer(짝수)  default:0 전체, 그리기 끝날 라운드 ex)4강 까지
      roundOf:round,
      data: {
         round_1 : matchData
      },
   });
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
   var l_fill, r_fill; 
   var l_no, r_no; 
   var matchNo = 0; 

   if(data){
      matchNo = data.matchNo;

      l_player  = data.l_player;
      l_team    = data.l_team;
      r_player  = data.r_player;
      r_team    = data.r_team;

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
      '<p onClick="onSelMatch('+l_no+');" class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
         '<span class="lotteryMatch__seedWrap">'+l_no+'</span>',
         '<span class="lotteryMatch__playerWrap">',
            '<span class="lotteryMatch__playerInner">',
               '<span class="lotteryMatch__player [ _player1 ]">'+l_player+'</span>',
               '<span class="lotteryMatch__belong [ _belong1 ]">'+l_team+'</span>',
            '</span>',
         '</span>',
      '</p>',
      '<p onClick="onSelMatch('+r_no+');" class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
         '<span class="lotteryMatch__seedWrap">'+r_no+'</span>',
         '<span class="lotteryMatch__playerWrap">',
            '<span class="lotteryMatch__playerInner">',
            '<span class="lotteryMatch__player [ _player1 ]">'+r_player+'</span>',
               '<span class="lotteryMatch__belong [ _belong1 ]">'+r_team+'</span>',
            '</span>',
         '</span>',
      '</p>'
   ].join('');
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
   var l_sel, r_sel;
   var l_fill, r_fill; 
   var l_no, r_no; 
   var matchNo = 0; 

   if(data){
      matchNo = data.matchNo;

      aryl_player  = (data.l_player.indexOf(',') == -1) ? [data.l_player, ""] : data.l_player.split(',');
      aryl_team    = (data.l_team.indexOf(',') == -1)   ? [data.l_team, ""]   : data.l_team.split(',');
      aryr_player  = (data.r_player.indexOf(',') == -1) ? [data.r_player, ""] : data.r_player.split(',');
      aryr_team    = (data.r_team.indexOf(',') == -1)   ? [data.r_team, ""]   : data.r_team.split(',');

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
      '<p onClick="onSelMatch('+l_no+');" class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
         '<span class="lotteryMatch__seedWrap">'+l_no+'</span>',
         '<span class="lotteryMatch__playerWrap">',
            '<span class="lotteryMatch__playerInner">',
               '<span class="lotteryMatch__player [ _player1 ]">'+aryl_player[0]+'</span>',
               '<span class="lotteryMatch__belong [ _belong1 ]">'+aryl_team[0]+'</span>',
            '</span>',
            '<span class="lotteryMatch__playerInner">',
               '<span class="lotteryMatch__player [ _player2 ]">'+aryl_player[1]+'</span>',
               '<span class="lotteryMatch__belong [ _belong2 ]">'+aryl_team[0]+'</span>',
            '</span>',
         '</span>',
      '</p>',
      '<p onClick="onSelMatch('+r_no+');" class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
         '<span class="lotteryMatch__seedWrap">'+r_no+'</span>',
         '<span class="lotteryMatch__playerWrap">',
            '<span class="lotteryMatch__playerInner">',
            '<span class="lotteryMatch__player [ _player1 ]">'+aryr_player[0]+'</span>',
               '<span class="lotteryMatch__belong [ _belong1 ]">'+aryr_team[1]+'</span>',
            '</span>',
            '<span class="lotteryMatch__playerInner">',
               '<span class="lotteryMatch__player [ _player2 ]">'+aryr_player[0]+'</span>',
               '<span class="lotteryMatch__belong [ _belong2 ]">'+aryr_team[1]+'</span>',
            '</span>',
         '</span>',
      '</p>'
   ].join('');
   return html;      
}

/* ==================================================================================
   Debug Func - 참가신청 User Info
   gAryGameUser Field  -  fUse, SeedNo, Ranking, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, 
                        MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName
   ================================================================================== */ 
   function printAryGameUser(rAryReq)
   {
      var i = 0, len = 0, strLog;
      if( rAryReq == null ) return; 
      len = rAryReq.length; 

      console.log("=======================================================================");
      console.log("======================= printAryGameUser ============================");
      for(i=0; i<len; i++)
      {
         strLog = utx.strPrintf("fUse = {0}, SeedNo = {1}, Ranking = {2}, PlayerOrder = {3}, GameRequestGroupIDX = {4}, GameRequestPlayerIDX = {5}", 
                     rAryReq[i][0], rAryReq[i][1], rAryReq[i][2], rAryReq[i][3], rAryReq[i][4], rAryReq[i][5]);

         strLog += utx.strPrintf("MemberIDX = {0}, MemberName = {1}, Team = {2}, TeamName = {3}, PrevTeam = {4}, PrevTeamName = {5}", 
                     rAryReq[i][6], rAryReq[i][7], rAryReq[i][8], rAryReq[i][9], rAryReq[i][10], rAryReq[i][11]);
         console.log(strLog);
      }
      console.log("=======================================================================");
   }

/* ==================================================================================
   Debug Func - 연동대회 Ranker Info
   gArySeedUser Field  - GameRanking, ReqGame, TourneyGroupIDX, MemberIDX, UserName, SEX, TEAM, TEAMNM
   ================================================================================== */ 
   function printArySeedUser(rArySeed)
   {
      var i = 0, len = 0, strLog;
      if( rArySeed == null ) return; 
      len = rArySeed.length; 

      console.log("=======================================================================");
      console.log("======================= printArySeedUser ============================");
      for(i=0; i<len; i++)
      {
         strLog = utx.strPrintf("GameRanking = {0}, ReqGame = {1}, TourneyGroupIDX = {2}, MemberIDX = {3}, UserName = {4}, SEX = {5}, TEAM = {6}, TEAMNM = {7}", 
         rArySeed[i][0], rArySeed[i][1], rArySeed[i][2], rArySeed[i][3], rArySeed[i][4], rArySeed[i][5], rArySeed[i][6], rArySeed[i][7]);

         console.log(strLog);
      }
      console.log("=======================================================================");
   }

/* ==================================================================================
   Debug Func - Medal User Info
   gAryMedalUser Field  -  TourneyGroupIDX, GameMedalIDX
   ================================================================================== */ 
   function printAryMedalUser(rAryMedal)
   {
      var i = 0, len = 0, strLog;
      if( rAryMedal == null ) return; 
      len = rAryMedal.length; 

      console.log("=======================================================================");
      console.log("======================= printAryMedalUser ============================");
      for(i=0; i<len; i++)
      {
         strLog = utx.strPrintf("TourneyGroupIDX = {0}, GameMedalIDX = {1}", rAryMedal[i][0], rAryMedal[i][1]);
         console.log(strLog);
      }
      console.log("=======================================================================");
   }

/* ==================================================================================
   Debug Func - 8 Round Ranker Info
   gAryRank8Info Field  -   L_TourneyGroupIDX, R_TourneyGroupIDX  - Left Team , Right Team Group Idx
   ================================================================================== */ 
   function printAryRank8Info(rAryRank8)
   {
      var i = 0, len = 0, strLog;
      if( rAryRank8 == null ) return; 
      len = rAryRank8.length; 

      console.log("=======================================================================");
      console.log("======================= printAryRank8Info ============================");
      for(i=0; i<len; i++)
      {
         strLog = utx.strPrintf("L_TourneyGroupIDX, R_TourneyGroupIDX", rAryRank8[i][0], rAryRank8[i][1]);
         console.log(strLog);
      }
      console.log("=======================================================================");
   }

/* ==================================================================================
   Debug Func - 4 Round Ranker Info
   gAryRank4Info Field  -   L_TourneyGroupIDX, R_TourneyGroupIDX  - Left Team , Right Team Group Idx
   ================================================================================== */ 
   function printAryRank4Info(rAryRank4)
   {
      var i = 0, len = 0, strLog;
      if( rAryRank4 == null ) return; 
      len = rAryRank4.length; 

      console.log("=======================================================================");
      console.log("======================= printAryRank4Info ============================");
      for(i=0; i<len; i++)
      {
         strLog = utx.strPrintf("L_TourneyGroupIDX, R_TourneyGroupIDX", rAryRank4[i][0], rAryRank4[i][1]);
         console.log(strLog);
      }
      console.log("=======================================================================");
   }

/* ==================================================================================
      Ranker Info가 있을 경우 strPlayer,strTeam,strOrder를 한 문자열로 반환한다.  - 단식  
   ================================================================================== */ 
   function GetRankerInfo(rAryReq, memIdx)
   {
      var i = 0, len = 0, strInfo = "", strTeam, strOrder, strPlayer;
      if( rAryReq == null ) return; 
      len = rAryReq.length; 

      for(i=0; i<len; i++)
      {
         if(rAryReq[i][6] == memIdx){
            if( rAryReq[i][2] == "0" ) return ""; 

            strPlayer = rAryReq[i][7]; 
            strTeam = (rAryReq[i][8] == rAryReq[i][10]) ? rAryReq[i][9] : utx.strPrintf("{0} (前 {1})", rAryReq[i][9], rAryReq[i][11] );
            strOrder = (rAryReq[i][2] <= 3) ? utx.strPrintf("{0} 위", rAryReq[i][2]) : utx.strPrintf("{0} 강", rAryReq[i][2]);        
            strInfo = utx.strPrintf("{0},{1},{2}", strPlayer, strTeam, strOrder);
            return strInfo; 
         }         
      }   

      return ""; 
   }


   /* ==================================================================================
      Ranker Info가 있을 경우 strPlayer,strTeam,strOrder를 한 문자열로 반환한다.  - 복식 
   ================================================================================== */ 
   function GetRankerInfoDbl(rAryReq, memIdx)
   {
      var i = 0, len = 0, strInfo = "", strTeam, strTeam1, strTeam2, strOrder, strPlayer;
      if( rAryReq == null ) return; 
      len = rAryReq.length; 

      for(i=0; i<len-1; i++)
      {
         if(rAryReq[i][6] == memIdx){
            if( rAryReq[i][2] == "0" ) return ""; 

            strPlayer = utx.strPrintf("{0}/{1}", rAryReq[i][7], rAryReq[i+1][7]); 
            strTeam1 = (rAryReq[i][8] == rAryReq[i][10]) ? rAryReq[i][9] : utx.strPrintf("{0} (前 {1})", rAryReq[i][9], rAryReq[i][11] );
            strTeam2 = (rAryReq[i+1][8] == rAryReq[i+1][10]) ? rAryReq[i+1][9] : utx.strPrintf("{0} (前 {1})", rAryReq[i+1][9], rAryReq[i+1][11] );
            strTeam = utx.strPrintf("{0}/{1}", strTeam1, strTeam2); 

            strOrder = (rAryReq[i][2] <= 3) ? utx.strPrintf("{0} 위", rAryReq[i][2]) : utx.strPrintf("{0} 강", rAryReq[i][2]);            
            strInfo = utx.strPrintf("{0},{1},{2}", strPlayer, strTeam, strOrder);
            return strInfo; 
         }
      } 
      return ""; 
   }


/* ==================================================================================
      운영자가 입력한 Seed Number가 valid한지 체크한다. 
      중복값 or 1부터 시작한 값이 중간에 빠진값이 있으면 안된다. Sort한후 체크 
      호출하기 전에 sort가 되어 있어야 한다. 
      rArySeedNo : groupIdx, SeedNo 
   ================================================================================== */ 
   function checkSeedValid(rArySeedNo)
   {
      var i = 0, len = 0; 
      if(rArySeedNo == undefined || rArySeedNo == null) return false; 
      len = rArySeedNo.length; 

      for(i=0; i<len; i++)
      {
         if(rArySeedNo[i][1] != (i+1)) return false; 
      }
      return true; 
   }

/* ==================================================================================
      운영자가 입력한 Seed Number를 게임신청 리스트에 적용한다. 
      rAryReq    : fUse, SeedNo, Ranking, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, 
                     MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName
      rArySeedNo : groupIdx, SeedNo 
   ================================================================================== */ 
   function ApplySeedNoToReqAry(rAryReq, rArySeedNo)
   {
      var i = 0, len = 0, seedNo = -1, groupIdx = ""; 
      if(rAryReq == null || rArySeedNo == null) return false; 
      len = rAryReq.length; 

      for(i=0; i<len; i++)
      {
         groupIdx = rAryReq[i][4]
         seedNo = getSeedNo(rArySeedNo, groupIdx);
         if(seedNo != -1) rAryReq[i][1] = seedNo; 
      }
      return true; 
   }

/* ==================================================================================
      groupIdx를 입력받아 SeedNo를 반환한다. 
      rArySeedNo : groupIdx, SeedNo 
   ================================================================================== */
   function getSeedNo(rArySeedNo, groupIdx)
   {
      var i = 0, len = 0; 
      if(rArySeedNo == undefined || rArySeedNo == null) return false; 
      len = rArySeedNo.length; 

      for(i=0; i<len; i++)
      {
         if(rArySeedNo[i][0] == groupIdx) return rArySeedNo[i][1];
      }

      return -1; 
   }
