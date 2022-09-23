
   /* ==================================================================================      
      aryReqUser Field  -  fUse, teamNo, SeedNo, Ranking, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, 
                        MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName
   ================================================================================== */   

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
               rIdx = checkSeedInfo(rArySeed, rAryReq[i][8])
               if(rIdx != -1) 
               {
                  // Ranking , Ranking 획득시 팀 정보 셋팅 
                  rAryReq[i][3] = rArySeed[rIdx][0]; 
                  rAryReq[i][12] = rArySeed[rIdx][6];
                  rAryReq[i][13] = rArySeed[rIdx][7];
               }
            }
         }
         else {                        // 복식 
            len = rAryReq.length/2; 
            for(i=0; i<len; i++)
            {
               idx = i * 2; 
               rIdx = checkSeedInfoDbl(rArySeed, rAryReq[idx][8], rAryReq[idx+1][8])
               if(rIdx != -1)
               {
                  if( rAryReq[idx][8] == rArySeed[rIdx][3])
                  {
                     sIdx1 = rIdx, sIdx2 = rIdx+1; 
                  }
                  else {
                     sIdx1 = rIdx+1, sIdx2 = rIdx; 
                  }

                  // Ranking , Ranking 획득시 팀 정보 셋팅 
                  rAryReq[idx][3] = rArySeed[sIdx1][0]; 
                  rAryReq[idx][12] = rArySeed[sIdx1][6];
                  rAryReq[idx][13] = rArySeed[sIdx1][7];

                  rAryReq[idx+1][3] = rArySeed[sIdx2][0]; 
                  rAryReq[idx+1][12] = rArySeed[sIdx2][6];
                  rAryReq[idx+1][13] = rArySeed[sIdx2][7];
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
   Test Func - 참가신청 리스트 rAryReqUser Field 상단 참조 
   ================================================================================== */   
   function ApplyList(rAryReq, playType)
   {
      var i = 0, len = rAryReq.length, strTeam = "", strTeam2 = "", cntTotal = 0, cntTeam = 0, teamOrder = 0;
      var strHtml = "", strSeedMark = "s_related"; 
      var bMixTeam = false; 
   
      for(i = 0; i<len; i++)
      {
         if(teamOrder != rAryReq[i][1])      // Team Name - entrybox row start 
         {
            // 이전팀의 cnt를 Display하고 row를 마무리 한다. 
            if( strTeam != "")
            {
               strHtml += utx.strPrintf(" </div>  </div> <div class='entryBox__col'>	<span>{0}</span> </div>  </div>", cntTeam );
               cntTotal += cntTeam;
            }
   
            teamOrder = rAryReq[i][1]; 
            strTeam = rAryReq[i][11];
            bMixTeam = false;
            
            if(IsDoublePlay(playType))
            {
               strTeam2 = rAryReq[i+1][11];
               if(strTeam != strTeam2) bMixTeam = true;
            }
   
            if(bMixTeam == true){
               strHtml += utx.strPrintf("<div class='entryBox__row'> <div class='entryBox__col'> <span>{0}<br>{1}</span> </div>"
                              , strTeam, strTeam2);   
            }
            else
            {
               strHtml += utx.strPrintf("<div class='entryBox__row'> <div class='entryBox__col'> <span>{0}</span> </div>"
                              , strTeam); 
            }
            
            strHtml += "<div class='entryBox__col'> <div class='entry'> "            
            cntTeam = 0;                
         }
   
         if(IsDoublePlay(playType)) {  // 복식 
            strHtml += utx.strPrintf("<button class='entry__item {0}' onClick=\"onClickRankerInfoDbl('{1}', '{2}');\">	<p>{3}</p> <p>{4}</p>", 
                        ((rAryReq[i][3]) ? strSeedMark : ""), rAryReq[i][8], rAryReq[i+1][8], rAryReq[i][9], rAryReq[i+1][9]);
                        i++;   
         }
         else {                        // 단식                      
            strHtml += utx.strPrintf("<button class='entry__item {0}' onClick=\"onClickRankerInfo('{1}');\">	<p>{2}</p>", 
                          ((rAryReq[i][3]) ? strSeedMark : ""), rAryReq[i][8], rAryReq[i][9]) ;
         }
         
         strHtml += utx.strPrintf("<input type='text' id = 'ed_seed{0}' class='entry__input' maxlength='4' value='' onClick=\"onClickEditRankerInfo()\"> </button>", rAryReq[i][6]); 
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

   function clearList()
   {
      ctx.writeHtmlToDiv("div_entry_body", "");
      ctx.setSpanText("sp_entry_total", ""); 
   }
   
/* ==================================================================================
      복식 이면서 혼합 게임인지 확인 - aryReqUser Field 상단 참조 
   ================================================================================== */   
   function IsMixGame(rAryReq, playType)
   {
      var len = 0, i = 0, bMixGame = false;

      if(!IsDoublePlay(playType)) return false; 

      len = rAryReq.length;
      for(i = 0; i<len; i++)
      {
         if(rAryReq[i][10] != rAryReq[i+1][10])
         {
            bMixGame = true; 
            break; 
         }
         i++; 
      }

      return bMixGame; 
   }
/* ==================================================================================
      teamOrder를 셋팅 
      혼합팀이면서 팀이 서로 틀릴경우 team_a1/team_b1 와 team_b1/team_a1은 서로 같은 팀이다. 
      이는 문자열로 비교가 불가 하므로 teamOrder를 생성하여 같은 팀임을 만들어 준다. 
      단식이거나 , 복식이라도 팀명이 서로 같으면 문자열 비교로 TeamOrder를 만들어 준다. 
   ================================================================================== */ 
   function makeTeamOrder(rAryReq, playType)
   {
      if(IsMixGame(rAryReq, playType)) return makeTeamOrderMix(rAryReq, playType);
   
      var i = 0, len = rAryReq.length, strTeam = "", teamOrder = 0;
      
      for(i = 0; i<len; i++)
      {
         if(strTeam != rAryReq[i][10])      // Team Name - entrybox row start 
         {
            teamOrder++; 
            strTeam = rAryReq[i][10];
         }
         rAryReq[i][1] = teamOrder; 
      }
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

   function makeTeamOrderMix(rAryReq, playType)
   {
      var i = 0, len = rAryReq.length, aryTmp;
      var fLoop = 1, cntLoop = 0, loopMax = 1000, idx = 0;
      var team1 = 0, team2 = 0, ret = 0, steam = -1, tOrder = 0; 
      
      aryTmp = new Array();
   
      while(fLoop)
      {
         if(steam == -1) {
            // team을 구할수 없으면 다 copy한 거다. 
            ret = GetNextTeam(rAryReq);
            if(ret == -1) {
               fLoop = 0; 
               continue; 
            }
            team1 = rAryReq[ret][10];
            team2 = rAryReq[ret+1][10];
            tOrder ++; 
         }
         
         steam = GetSameTeam(rAryReq, team1, team2);
         if(steam == -1) continue; 
   
         //복식이니까 2개씩 복사한다. 
         aryTmp[idx]       = utx.cloneObject(rAryReq[steam]);
         aryTmp[idx+1]     = utx.cloneObject(rAryReq[steam+1]);      
         aryTmp[idx][1]    = tOrder; 
         aryTmp[idx+1][1]  = tOrder; 
   
         rAryReq[steam][0]    = 1;      // 사용했다는 표시를 한다. 
         rAryReq[steam+1][0]  = 1; 
         idx += 2;       
   
         if(cntLoop > loopMax)      // 문제가 있지만 무한 루프 빠지지 않게 이쯤에서 끝내자. 
         {
            fLoop = 0; 
            continue; 
         }
   
         cntLoop++;       
      }
   
      // rAryReq에 aryTmp를 Deep Copy하자. 
      for(i=0; i<len; i++)
      {
         rAryReq[i] = utx.cloneObject(aryTmp[i]);
      } 
   
      aryTmp = null; 
   }
   
   /* =================================================================================== 
         복식/혼합 팀 일경우 같은 팀 인지 확인하는 function rAryReqUser Field 상단 참조 
         team1, team2를 인자로 받아 비교한다.       
      =================================================================================== */
      function GetSameTeam(rAryReq, team1, team2)
      {
         var i = 0, len = rAryReq.length; 
   
         for(i=0; i<len; i+=2)      // 복식이니까 2개씩 증가 
         {
            if(rAryReq[i][0] == 0)   // 할당하지 않았다. 여기서 찾자 
            {
               // team1, team2가 앞뒤로 바뀌어도 같은 팀으로 처리한다. 
               if( (rAryReq[i][10] == team1 && rAryReq[i+1][10] == team2) || (rAryReq[i][10] == team2 && rAryReq[i+1][10] == team1) )
               {
                  return i;                  // 찾았다. return 
               }
            }         
         }
   
         return -1; 
      }
   
   /* =================================================================================== 
         rAryReq를 입력받아 사용 가능한 팀 Idx를 Return한다. rAryReqUser Field 상단 참조 
         더이상 사용가능한 팀이 없을때 return -1
      =================================================================================== */
      function GetNextTeam(rAryReq)
      {
         var i = 0, len = rAryReq.length; 
   
         for(i=0; i<len; i++) 
         {
            if(rAryReq[i][0] == 0) return i;
         }
   
         return -1; 
      }
   
/* =================================================================================== 
   playType - Single Game / Double Game ( 단식/복식 유무 )
   =================================================================================== */
   IsDoublePlay = function(playType) {
   return (playType == "B0020002");
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
      // branchColor : '#000000', // string 트리 컬러
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
function drawTournament(objT, round, sRound, eRound, matchData)
{
   objT.draw({
      limitedStartRoundOf: sRound, //16    integer(짝수)  default:0 전체, 그리기 시작할 라운드 ex)8강 부터
      limitedEndRoundOf: eRound, //8       integer(짝수)  default:0 전체, 그리기 끝날 라운드 ex)4강 까지
      roundOf:round,
      data: {
         round_1 : matchData
      },
   });
}   


   emptyData64 = new Array();
   emptyData32 = new Array();
   emptyData16 = new Array();
   emptyData8  = new Array();
   emptyData4  = new Array();
   emptyData2  = new Array();

   MakeEmptyData(emptyData64, 64); 
   MakeEmptyData(emptyData32, 32); 
   MakeEmptyData(emptyData16, 16); 
   MakeEmptyData(emptyData8, 8); 
   MakeEmptyData(emptyData4, 4); 
   MakeEmptyData(emptyData2, 2); 

   function MakeEmptyData(rAryEmpty, round)
   {
      var i = 0, max = round / 2; 

      for(i=0; i<max; i++)
      {
         rAryEmpty.push({
            matchNo:i,
            l_player:'', l_team:'', 
            r_player:'', r_team:'',
         });
      }
   }

/* ==================================================================================
   draw Tonament - tonament Object, round, data를 입력받아 tonament를 그린다. 
================================================================================== */ 
function drawTournament2(objT, round, sRound, eRound, matchData)
{
   objT.draw({
      limitedStartRoundOf: sRound, //16    integer(짝수)  default:0 전체, 그리기 시작할 라운드 ex)8강 부터
      limitedEndRoundOf: eRound, //8       integer(짝수)  default:0 전체, 그리기 끝날 라운드 ex)4강 까지
      roundOf:round,
      data: {
         round_1 : matchData,
         round_2 : emptyData64,
         round_3 : emptyData32,
         round_4 : emptyData16,
         round_5 : emptyData8,
         round_6 : emptyData4,
         round_7 : emptyData2,
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
   function printAryGameUser(rAryReq, strTitle)
   {
      var i = 0, len = 0, strLog;
      if( rAryReq == null ) return; 
      len = rAryReq.length; 

      if(strTitle == undefined) strTitle = "printAryGameUser";

      strLog = utx.strPrintf("======================= {0} ============================", strTitle)
      console.log(strLog);

      for(i=0; i<len; i++)
      {
         strLog = utx.strPrintf("fUse = {0}, teamNo = {1}, SeedNo = {2}, Ranking = {3}, dataOrder = {4}, PlayerOrder = {5}, GameRequestGroupIDX = {6}, GameRequestPlayerIDX = {7}, ", 
                     rAryReq[i][0], rAryReq[i][1], rAryReq[i][2], rAryReq[i][3], rAryReq[i][4], rAryReq[i][5], rAryReq[i][6], rAryReq[i][7]);

         strLog += utx.strPrintf("MemberIDX = {0}, MemberName = {1}, Team = {2}, TeamName = {3}, PrevTeam = {4}, PrevTeamName = {5}", 
                     rAryReq[i][8], rAryReq[i][9], rAryReq[i][10], rAryReq[i][11], rAryReq[i][12], rAryReq[i][13]);
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
         if(rAryReq[i][8] == memIdx){
            if( rAryReq[i][3] == "0" ) return ""; 

            strPlayer = rAryReq[i][9]; 
            strTeam = (rAryReq[i][10] == rAryReq[i][12]) ? rAryReq[i][11] : utx.strPrintf("{0} (前 {1})", rAryReq[i][11], rAryReq[i][13] );
            strOrder = (rAryReq[i][3] <= 3) ? utx.strPrintf("{0} 위", rAryReq[i][3]) : utx.strPrintf("{0} 강", rAryReq[i][3]);        
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
         if(rAryReq[i][8] == memIdx){
            if( rAryReq[i][3] == "0" ) return ""; 

            strPlayer = utx.strPrintf("{0}/{1}", rAryReq[i][9], rAryReq[i+1][9]); 
            strTeam1 = (rAryReq[i][10] == rAryReq[i][12]) ? rAryReq[i][11] : utx.strPrintf("{0} (前 {1})", rAryReq[i][11], rAryReq[i][13] );
            strTeam2 = (rAryReq[i+1][10] == rAryReq[i+1][12]) ? rAryReq[i+1][11] : utx.strPrintf("{0} (前 {1})", rAryReq[i+1][11], rAryReq[i+1][13] );
            strTeam = utx.strPrintf("{0}/{1}", strTeam1, strTeam2); 

            strOrder = (rAryReq[i][3] <= 3) ? utx.strPrintf("{0} 위", rAryReq[i][3]) : utx.strPrintf("{0} 강", rAryReq[i][3]);            
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
      rAryReq    : fUse, teamNo, SeedNo, Ranking, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, 
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
         groupIdx = rAryReq[i][6]
         seedNo = getSeedNo(rArySeedNo, groupIdx);
         if(seedNo != -1) rAryReq[i][2] = seedNo; 
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

/* ==================================================================================
      rAryReq를 입력받아 dataOrder string을 반환한다. 
      만약 data order 순서가 변경되었으면 string을 만들어서 반환하고, 
      그렇지 않으면 ""를 반환한다. 
   ================================================================================== */
   function getStrDataOrder(rAryReq)
   {
      var i = 0, len = 0, strInfo = "", nOrder = 0; 
      var bChangeOrder = false;           // data order가 변경 되었다. 
      if(rAryReq == undefined || rAryReq == null) return strInfo; 
      len = rAryReq.length; 

      for(i=0; i<len; i++)
      {
         if(nOrder > rAryReq[i][4]) bChangeOrder = true; 
         nOrder = rAryReq[i][4];
         if(i == 0) strInfo = utx.sprintf("{0}",nOrder);
         else strInfo = utx.sprintf("{0},{1}",strInfo, nOrder);
      }

      if(bChangeOrder == false) strInfo = "";

      return strInfo; 
   }
