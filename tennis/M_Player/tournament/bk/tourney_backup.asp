<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
GameTitleIDX  =   fInject(Request("GameTitleIDX"))
GameTitleName   =   fInject(Request("GameTitleName"))
%>    
<script src="../../webtournament/www/js/global.js"></script>
<script src="../js/tourney.js"></script>
<script type="text/javascript">
    var pageTitle = "대회일정";
  
    localStorage.setItem("GameTitleIDX", "<%=GameTitleIDX %>");
    localStorage.setItem("GameTitleName", "<%=GameTitleName %>")
    localStorage.setItem("SportsGb", "judo");

    <%If GameTitleIDX = "60" Then%>
    localStorage.setItem("EnterType", "A");
    <%Else%>
    localStorage.setItem("EnterType", "E");
    <%End If%>

    //console.log($("#game-type").val());
     
</script>
<head>
<meta name="viewport" content="width=device-width, minimum-scale=1, initial-scale=1">
</head>
<body onLoad="onLoad()" id="AppBody">
  <!--<a href="#" data-target="#show-tourney-pop" data-toggle="modal" class="init_btn"></a>-->
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>대진표</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->

  <!-- S: sub sub-main -->
  <div class="sub sub-main tourney h-fix">
    <!-- S: tourney-title -->
    <div class="tourney-title">
      <h3 id="tourney_title"></h3>
    </div>
    <!-- E: tourney-title -->
    <!-- S: tourney-sel -->
    <div class="tourney-sel">
      <ul class="clearfix">
        <li>
          <select  id="game-type" name="game-type" data-native-menu="false" >
            <option value="sd040001">개인전</option>
            <option value="sd040002">단체전</option>
          </select>
        </li>
        <li>
          <select id="TeamGb" data-native-menu="false"> 
           <option value="">소속구분</option>
          </select>
        </li>
        <li>
          <select name="SexLevel" id="SexLevel" data-native-menu="false">
          <option data-sex='' data-level='' value='' >체급</option>
          </select>
        </li>
        <li>
          <!--<a href="javascript:view_match();" class="btn-gray">검색</a>-->
          <button type="button" id="search" class="btn-gray">조회</button>

        </li>

      </ul>
    </div>
    <!-- E: tourney-sel -->
    <!-- S: tourney-info -->
    <div class="tourney-info">
      <p>
         
      </p>
    </div>
    <!-- E: tourney-info -->
    <!-- S: medal-list -->
    <div class="medal-list" id="DP_Medal">
      <ul class="clearfix scroll-x" id="DP_MedalList">
        
      </ul>
    </div>
    <!-- E: medal-list -->

    <!-- S: tn_live_tab -->
    <div class="tn_live_tab">
      <!-- S: btn_list btn_2 -->
      <div class="btn_list btn_2">
        <ul class="flex">
          <li>
            <a href="./tourney.asp" class="btn btn-normal on">전체</a>
          </li>
          <li>
            <a href="./live_score.asp" class="btn btn-normal btn-live-score"><span class="ic_deco live">LIVE</span>LIVE SCORE <span class="ic_deco"><i class="fa fa-wifi"></i></span></a>
          </li>
        </ul>
      </div>
      <!-- E: btn_list btn_2 -->
    </div>
    <!-- E: tn_live_tab -->

    <!-- S: banner banner_md -->
    <div class="banner banner_md">
      <div class="img_box">
        <img src="../images/public/banner_md@3x.png" alt="광고영역">
      </div>
    </div>
    <!-- E: banner banner_md -->


    <!-- S: show-btn -->
    <div class="show-btn">
      <ul class="flex">
        <li onclick="view_result('A');"><a href="#" class="tab-btn tourney-result result-search-list on" id="Btn_Tournament">대진표로 보기</a></li>
        <li onclick="view_result('B');"><a href="#" class="tab-btn result-report result-search-list" id="Btn_ResultList">리스트로 보기</a></li>
      </ul>
    </div>
    <!-- E: show-btn -->
    
    <!-- S: tourney-mode -->
    <div class="tourney-mode" id="DP_tourney">
      <!-- S: btn-guide -->
      <div class="btn-guide">
        <!-- S: guide-txt -->
        <div class="guide-txt show-film-guide">
          ※ 경기영상은 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
        </div>
        <!-- E: guide-txt -->
        <ul>
          <li>
            <p id="btnlookCheck">
              <span><a class="btn btn-look no-movie-clip"></a></span>
              <span>영상미등록</span>
              <span><a class="btn btn-look time-out"></a></span>
              <span>영상등록완료</span>
            </p>
            <p id="sexLevelCheck">
                ※ 체급을 선택해주세요.
            </p>
          </li>
        </ul>
      </div>
      <!-- E: btn-guide -->
      <!-- S: tourney-->
      <div class="tourney clearfix" id="DP_tourney_01">
        <!-- S: left-side -->
        <div class="left-side clearfix">
          <!-- S: match-list -->
         <div  id="match_list_left" class="match-list"></div>
          <!-- E: match-list -->
         
         <!-- S: Round-1 -->
         <div id="round_01_left" class="round-1"></div>
          <!-- E: Round-1 -->
        
          <!-- S: Round-2 -->
         <div id="round_02_left" class="round-2"></div>
          <!-- E: Round-2 -->
        
          <!-- S: Round-3 -->
         <div id="round_03_left" class="round-3"></div>
          <!-- E: Round-3 -->
        
          <!-- S: Round-4 -->
           <div id="round_04_left" class="round-4"></div>
          <!-- E: Round-4 -->
        
          <!-- S: Round-5 -->
          <div id="round_05_left" class="round-5"></div>
          <!-- E: Round-5 -->

          <!-- S: Round-6 -->
       <div id="round_06_left" class="round-6"></div>
          <!-- E: Round-6 -->

          <!-- S: final-match -->
          <div class="final-match">
            <!-- S: final-div -->
            <div id="final_div" class="final-div">
          
            </div>
            <!-- E: final-div -->
          </div>
          <!-- E: final-match -->
        </div>
        <!-- E: left-side -->
        
        <!-- S: right-side -->
        <div class="right-side clearfix">
          <!-- S: match-list -->
          <div id="match_list_right" class="match-list"></div>
          <!-- E: match-list -->
          <!-- S: round-1 -->
          <div id="round_01_right" class="round-1"></div>
          <!-- E: round-1 -->
        
          <!-- S: Round-2 -->
          <div id="round_02_right" class="round-2"></div>
          <!-- E: Round-2 -->
          
          <!-- S: Round-3 -->
           <div id="round_03_right" class="round-3"></div>
          <!-- E: Round-3 -->

          <!-- S: Round-4 -->
         <div id="round_04_right" class="round-4"></div>
          <!-- E: Round-4 -->
        
          <!-- S: Round-5 -->
           <div id="round_05_right" class="round-5"></div>
          <!-- E: Round-5 -->

          <!-- S: Round-6 -->
         <div id="round_06_right" class="round-6"></div>
          <!-- E: Round-6 -->

        </div>
        <!-- E: right-side -->
      </div>
      <!-- E: tourney-->
     <!-- E: hidden-main -->
     </div>
         <!-- S: tourney-list -->
     <div class="tourney-list result-report" id ="DP_ResultReport" >   </div>
    <!-- E: tourney-list -->
    
 </div> 
    <!-- E: tourney-mode -->
  <!-- E: sub sub-main board -->

  
    <div class="sub tourney container">
    <!-- S: list_league -->
    <div id="list_league" class="list_league" style="display:none;">
      <!--<p class="chk-weight-txt">※ 체급을 선택해주세요</p>-->
    </div>
    <!-- E: list_league -->

      <div class="natfinal_tourney tourney-mode" id="DP_natfinal_tourney" style="display:none">
      <!-- S: guide-txt -->
      <div class="guide-txt show-film-guide">
        ※ 경기 영상은 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
      </div>
      <!-- E: guide-txt -->
      <!-- S: btn-guide -->
      <div class="btn-guide">
        <ul>
          <li>
            <p id="btnlookCheck_natfinal">
              <span><a class="btn btn-look no-movie-clip"></a></span>
              <span>영상미등록</span>
              <span><a class="btn btn-look time-out"></a></span>
              <span>영상등록완료</span>
            </p>
            <p id="sexLevelCheck_natfinal">
                ※ 체급을 선택해주세요.
            </p>
          </li>
        </ul>
      </div>
      <!-- E: btn-guide -->

          <!-- S: 최종평가전(승자)-->
          <div class="tourney 01 t-1">
            <h2 class="tourney_tit"><span class="txt">대진</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div  id="match_list_left_natfinal_01" class="match-list" ></div>
              <!-- E: match-list -->
              
              <!-- S: Round-1 -->
              <div id="round_01_left_natfinal_01" class="round-1"></div>
              <!-- E: Round-1 -->
            
              <!-- S: Round-2 -->
              <div id="round_02_left_natfinal_01" class="round-2"></div>
              <!-- E: Round-2 -->
           
              <!-- S: Round-3 -->
              <div id="round_03_left_natfinal_01" class="round-3"></div>
              <!-- E: Round-3 -->
            
              <!-- S: Round-4 -->
              <div id="round_04_left_natfinal_01" class="round-4"></div>
              <!-- E: Round-4 -->
            
              <!-- S: Round-5 -->
              <div id="round_05_left_natfinal_01" class="round-5"></div>
              <!-- E: Round-5 -->

              <!-- S: Round-6 -->
              <div id="round_06_left_natfinal_01" class="round-6"></div>
              <!-- E: Round-6 -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_natfinal_01" class="final-div"></div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_natfinal_01" class="match-list"></div>
              <!-- E: match-list -->
              <!-- S: round-1 -->
              <div id="round_01_right_natfinal_01" class="round-1"></div>
              <!-- E: round-1 -->
            
              <!-- S: Round-2 -->
              <div id="round_02_right_natfinal_01" class="round-2"></div>
              <!-- E: Round-2 -->

              <!-- S: Round-3 -->
              <div id="round_03_right_natfinal_01" class="round-3"></div>
              <!-- E: Round-3 -->

              <!-- S: Round-4 -->
              <div id="round_04_right_natfinal_01" class="round-4"></div>
              <!-- E: Round-4 -->
            
              <!-- S: Round-5 -->
              <div id="round_05_right_natfinal_01" class="round-5"></div>
              <!-- E: Round-5 -->

              <!-- S: Round-6 -->
              <div id="round_06_right_natfinal_01" class="round-6"></div>
              <!-- E: Round-6 -->

            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 최종평가전(승자)-->

          <!-- S: 최종평가전(패자)-->
          <div class="tourney 02 t-2" id="DP_natfinal_02">
            <h2 class="tourney_tit"><span class="txt" id="DP_ElseGameName">패자부활전</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div  id="match_list_left_natfinal_02" class="match-list" ></div>
              <!-- E: match-list -->
              
              <!-- S: Round-1 -->
              <div id="round_01_left_natfinal_02" class="round-1"></div>
              <!-- E: Round-1 -->
            
              <!-- S: Round-2 -->
              <div id="round_02_left_natfinal_02" class="round-2"></div>
              <!-- E: Round-2 -->
           
              <!-- S: Round-3 -->
              <div id="round_03_left_natfinal_02" class="round-3"></div>
              <!-- E: Round-3 -->
            
              <!-- S: Round-4 -->
              <div id="round_04_left_natfinal_02" class="round-4"></div>
              <!-- E: Round-4 -->
            
              <!-- S: Round-5 -->
              <div id="round_05_left_natfinal_02" class="round-5"></div>
              <!-- E: Round-5 -->

              <!-- S: Round-6 -->
              <div id="round_06_left_natfinal_02" class="round-6"></div>
              <!-- E: Round-6 -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_natfinal_02" class="final-div"></div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_natfinal_02" class="match-list"></div>
              <!-- E: match-list -->
              <!-- S: round-1 -->
              <div id="round_01_right_natfinal_02" class="round-1"></div>
              <!-- E: round-1 -->
            
              <!-- S: Round-2 -->
              <div id="round_02_right_natfinal_02" class="round-2"></div>
              <!-- E: Round-2 -->

              <!-- S: Round-3 -->
              <div id="round_03_right_natfinal_02" class="round-3"></div>
              <!-- E: Round-3 -->

              <!-- S: Round-4 -->
              <div id="round_04_right_natfinal_02" class="round-4"></div>
              <!-- E: Round-4 -->
            
              <!-- S: Round-5 -->
              <div id="round_05_right_natfinal_02" class="round-5"></div>
              <!-- E: Round-5 -->

              <!-- S: Round-6 -->
              <div id="round_06_right_natfinal_02" class="round-6"></div>
              <!-- E: Round-6 -->

            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 최종평가전(패자)-->

          <!-- E: 최종평가전(패자부활전 부전)-->
          <div class="tourney 03 t-3" id="DP_natfinal_03">
            <h2 class="tourney_tit"><span class="txt">패자부활전 결승</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div id="match_list_left_natfinal_03" class="match-list">
                <div class="no-match">
                  <div class="player-info">
                    <span class="player-name" id="LPlayerName_natfinal_03"><!--허송림--></span>   
                    <span class="player-school" id="LSchoolName_natfinal_03"><!--서울체육고등학교--></span> 
                  </div>
                </div>
              </div>
              <!-- E: match-list -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_natfinal_03" class="final-div">
                  <div class="line-div" id="LineButton_natfinal_03"> 
                    <img src="images/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onclick="mov_enterscore(this);" data-id="13" data-whatever="01">13</a>
                  </div>
                </div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_natfinal_03" class="match-list">
                <div class="no-match"> <div class="player-info">
                  <span class="player-name" id="RPlayerName_natfinal_03"><!--박예진--></span>
                  <span class="player-school" id="RSchoolName_natfinal_03"><!--서울체육고등학교--></span>
                </div>
              </div>
            </div>
              <!-- E: match-list -->
            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 최종평가전(패자부활전 부전)-->

          <!-- E: 최종평가전(결승)-->
          <div class="tourney 03 t-4" id="DP_natfinal_04">
            <h2 class="tourney_tit"><span class="txt">1,2위 결승</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div id="match_list_left_natfinal_04" class="match-list">
                <div class="no-match">
                  <div class="player-info">
                    <span class="player-name" id="LPlayerName_natfinal_04"><!--허송림--></span>   
                    <span class="player-school" id="LSchoolName_natfinal_04"><!--서울체육고등학교--></span> 
                  </div>
                </div>
              </div>
              <!-- E: match-list -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_natfinal_04" class="final-div">
                  <div class="line-div" id="LineButton_natfinal_04"> 
                    <img src="images/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onclick="mov_enterscore(this);" data-id="14" data-whatever="01">14</a>
                  </div>
                </div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_natfinal_04" class="match-list">
                <div class="no-match"> <div class="player-info">
                  <span class="player-name" id="RPlayerName_natfinal_04"><!--박예진--></span>
                  <span class="player-school" id="RSchoolName_natfinal_04"><!--서울체육고등학교--></span>
                </div>
              </div>
            </div>
              <!-- E: match-list -->
            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 최종평가전(결승)-->

          <!-- E: 최종평가전(결승재경기)-->
          <div class="tourney 03 t-5" id="DP_natfinal_05">
            <h2 class="tourney_tit"><span class="txt">1,2위 결승 재경기</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div id="match_list_left_natfinal_05" class="match-list">
                <div class="no-match">
                  <div class="player-info">
                    <span class="player-name" id="LPlayerName_natfinal_05"><!--허송림--></span>   
                    <span class="player-school" id="LSchoolName_natfinal_05"><!--서울체육고등학교--></span> 
                  </div>
                </div>
              </div>
              <!-- E: match-list -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_natfinal_05" class="final-div">
                  <div class="line-div" id="LineButton_natfinal_05"> 
                    <img src="images/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onclick="mov_enterscore(this);" data-id="15" data-whatever="01">15</a>
                  </div>
                </div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_natfinal_05" class="match-list">
                <div class="no-match"> <div class="player-info">
                  <span class="player-name" id="RPlayerName_natfinal_05"><!--박예진--></span>
                  <span class="player-school" id="RSchoolName_natfinal_05"><!--서울체육고등학교--></span>
                </div>
              </div>
            </div>
              <!-- E: match-list -->
            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 최종평가전(결승재경기)-->



        <!-- E: tourney-->
      
      </div>

      <!-- S: 5명경기 IJF-->
      <div id="DP_ijf_tourney" class="IJF_tourney" style="display:none">
      <!-- S: guide-txt -->
      <div class="guide-txt show-film-guide">
        ※ 경기 영상은 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
      </div>
      <!-- E: guide-txt -->
      <!-- S: btn-guide -->
      <div class="btn-guide">
        <ul>
          <li>
            <p id="btnlookCheck_natfinal">
              <span><a class="btn btn-look no-movie-clip"></a></span>
              <span>영상미등록</span>
              <span><a class="btn btn-look time-out"></a></span>
              <span>영상등록완료</span>
            </p>
            <p id="sexLevelCheck_natfinal">
                ※ 체급을 선택해주세요.
            </p>
          </li>
        </ul>
      </div>
      <!-- E: btn-guide -->

          <!-- S: 5명 1,2위결정전-->
          <div class="tourney game-five">
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div class="match-list" id="match_list_left_ijf">

              </div>
              <!-- E: match-list -->
              
              
              <!-- S: Round-1 -->
              <div id="round_01_left_ijf" class="round-1">

              </div>
              <!-- E: Round-1 -->
            

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_1of5" class="final-div">
                 
                </div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side" id="list_league_game-five">
              
              <!-- S: match-list -->
             
              <!-- E: round-1 -->
            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 5명 1,2위결정전-->











          <!-- S: 5명 3위결정전-->
          <div class="tourney 03" id="DP_ijf_2nd">
            <h2 class="tourney_tit"><span class="txt" >3위결정전</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div id="match_list_left_ijf_2nd" class="match-list">
                <div class="no-match">
                  <div class="player-info">
                    <span class="player-name" id="LPlayerName_ijf_2nd"><!--허송림--></span>   
                    <span class="player-school" id="LSchoolName_ijf_2nd"><!--서울체육고등학교--></span> 
                  </div>
                </div>
              </div>
              <!-- E: match-list -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_ijf_2nd" class="final-div">
                  <div class="line-div" id="LineButton_ijf_2nd"> 
                    <img src="images/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onclick="mov_enterscore(this);" data-id="6" data-whatever="01">6</a>
                  </div>
                </div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_ijf_2nd" class="match-list">
                <div class="no-match"> <div class="player-info">
                  <span class="player-name" id="RPlayerName_ijf_2nd"><!--박예진--></span>
                  <span class="player-school" id="RSchoolName_ijf_2nd"><!--서울체육고등학교--></span>
                </div>
              </div>
            </div>
              <!-- E: match-list -->
            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 5명 3위결정전-->





      </div>
      <!-- E: 5명경기 IJF-->

    </div>

    
  <!-- S: modal show-tourney-pop -->
  <div class="modal fade in" id="show-tourney-pop" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title" id="myModalLabel">알림</h4>
        </div>
        <div class="modal-body">
        <ul class="flex">
          <li><a href="#">1</a></li>
          <li><a href="#">2</a></li>
          <li><a href="#">3</a></li>
          <li><a href="#" class="so">...</a></li>
        </ul>
        <p class="pop-guide">경기번호를 클릭하시면<br>해당 경기 영상을 보실 수 있습니다.</p>
        </div>
        <div class="modal-footer">
          <label><input type="checkbox"><span>오늘 하루 보지 않기</span></label>
          <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        </div>
      </div>
    </div>
  </div>
  <!-- E: modal show-tourney-pop -->

    <!-- S: 영상보기 모달 modal -->
  <div class="modal fade film-modal" id="show-score" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false"><div class="modal-backdrop fade in"></div>
  <!-- S: modal-dialog -->
  <div class="modal-dialog">
    <!-- S: modal-content -->
    <div class="modal-content">
      <div class="modal-header clearfix">
        <h3 class="center">상세 스코어</h3>
        <a href="#" data-dismiss="modal">&times;</a>
      </div>
      <!-- E: modal-content -->
      <!-- S: modal-body -->
      <div class="modal-body">
        <!-- S: pracice-score -->
         <div id="modal_score" class="pracice-score" style="width: 100%">
          <h4><span>한판승</span></h4>
            <!-- S: pop-point-display -->
            <div class="pop-point-display">
              <!-- S: display-board -->
              <div class="display-board clearfix">
                <!-- S: point-display -->
                <div class="point-display clearfix">
                  <ul class="point-title flex">
                    <li>선수</li> 
                    <li>한판</li>
                    <li>절반</li>
                    <!-- <li>유효</li> -->
                    <li>지도</li>
                    <li>반칙/실격/<br>부전/기권 승</li>
                  </ul>
                  <ul class="player-1-point player-point flex">
                    <li>
                      <a onClick="#"><span class="disp-none" id="DP_LWin"></span>
                      <span class="player-name" id="DP_Edit_LPlayer">홍길동</span>
                      <p class="player-school" id="DP_Edit_LSCName">충남체육고</p></a>
                      <p class="vs">vs</p>
                    </li>
                    <li class="tgClass">
                     <a class="" onClick="#" name="a_jumsugb"><span class="score" id="LJumsuGb1">0</span></a>
                    </li>
                    <li class="tgClass">
                      <a class="" onClick="#" name="a_jumsugb"><span class="score" id="LJumsuGb2">0</span></a>
                    </li>
                    <!-- <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3">0</span></a>
                    </li> -->
                    <li class="tgClass">
                      <a class="" onClick="#" name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb4">0</span></a>
                    </li>
                    <li>
                      <select class="select-win select-box" id="DP_L_GameResult">
                        <option value="">선택</option>
                        <option value="">반칙</option>
                        <option value="">실격</option>
                        <option value="">부전</option>
                        <option value="">기권</option>
                      </select>
                    </li>
                  </ul>
                  <ul class="player-2-point player-point flex">
                    <li>
                      <a onClick="#"><span class="disp-none" id="DP_RWin"></span>
                      <span class="player-name" id="DP_Edit_RPlayer">이의준</span>
                      <p class="player-school" id="DP_Edit_RSCName">서울명덕초</p></a>
                    </li>
                    <li class="tgClass">
                      <a class="" onClick="#" name="a_jumsugb"><span class="score" id="RJumsuGb1">0</span></a>
                    </li>
                    <li class="tgClass">
                      <a class="" onClick="#" name="a_jumsugb"><span class="score" id="RJumsuGb2">0</span></a>
                    </li>
                    <!-- <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
                    </li> -->
                    <li class="tgClass">
                      <a class="" onClick="#" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb4">0</span></a>
                    </li>
                    <li>
                      <select class="select-win select-box" id="DP_R_GameResult">
                        <option value="">선택</option>
                        <option value="">반칙</option>
                        <option value="">실격</option>
                        <option value="">부전</option>
                        <option value="">기권</option>
                      </select>
                    </li>
                  </ul>
                  <!-- E: point-display -->
                </div>
                <!-- E: point-display -->
                </div>
              <!-- E: display-board -->
            </div>
            <!-- E: pop-point-display -->
          </div>
          <!-- E: pracice-score -->
        </div>
        <!-- E: -->
        <!-- S: container -->
        <div class="container" >
          <!-- S: 기록보기 record-box -->
          <div  id="modal_container" class="record-box panel" style="display: block;">
            <!-- S: guide-txt -->
            <div class="guide-txt">
              ※상세 기술의 경우 현장 기록관의 주관적인 판단에 의해 기록되므로 약간의 시각차가 있을 수 있습니다.
            </div>
            <!-- E: guide-txt -->
            <h3>득실기록</h3>
            <ul class="plactice-txt" id="DP_result-list">
              
            </ul>
          </div>
          <!-- E: 기록보기 record-box -->
          <!-- S: 영상보기 film-box -->
          <div class="film-box panel clearfix" id ="DP_GameVideo" style="display: none;">
            <iframe id="player_Ifram_MediaLink" width="100%" height="160" src="" frameborder="0" allowfullscreen=""></iframe>
            <button id="btnrewind" onClick="rewind(5);" type="button" class="btn btn-orange btn-rewind" ><<</button>
            <button id="btnfastforward" onClick="fastforward(5);"type="button" class="btn btn-orange btn-fastforward">>></button>
          </div>
          <!-- E: 영상보기 film-box -->
        </div>
        <!-- E: container -->
      </div>
      <!-- E: modal-body -->
      <!-- S: modal-footer -->
      <div class="modal-footer">
        <!-- S: btn-list -->
        <div class="btn-list flex">
          <button onClick="change_btn();" id="btn_movie" type="button" class="btn btn-orange btn-film" style="display: block;">
            <span class="ic-deco"><img src="../images/stats/film-icon@3x.png" alt=""/>  </span>영상보기</button>

          <button onClick="change_btn();" id="btn_log" type="button" class="btn btn-orange btn-record"style="display: none;">기록보기</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        </div>
        <!-- E: btn-list -->
    </div>
    <!-- E: modal-footer -->
  </div>
  <!-- E: modal-dialog -->
</div>
  <!-- E: 영상보기 모달 modal -->

  
  
  <!-- S: 단체전 영상보기 모달 modal -->
  <div class="modal fade round-res in groups-res" id="groupround-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="false">
  <div class="modal-backdrop fade in"></div>
    <div class="modal-dialog" id="detailScore_Team">
      <div class="modal-content">
        <!-- S: modal-header -->
        <div class="modal-header chk-score">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title" id="modal-title">SCORE</h4>
        </div>
        <!-- E: modal-header -->
        <div class="modal-body group-modal">
          <h2><span class="left-arrow"><img src="../../webtournament/www/images/tournerment/tourney/yellow-larr.png" alt></span><span id="DP_WinGroup">송도고(27.5점) 승</span><span class="right-arrow"><img src="../../webtournament/www/images/tournerment/tourney/yellow-rarr.png" alt></span></h2>
          <!-- S: display-board -->
          <div class="display-board clearfix">
            <ul>
              <li class="win" id="DP_LSchoolName">송도고등학교</li>
              <li id="DP_LResult">3승0무2패(206.2)</li>
            </ul>
            <div class="v-s">
              VS
            </div>
            <ul class="away">
              <li  id="DP_RSchoolName">우석고등학교</li>
              <li id="DP_RResult">2승0무3패(200)</li>
            </ul>
          </div>
          <!-- E: display-board -->
          <!-- S:record -->
          <div class="record record-box" id="DP_GroupRecord">
             <div class="home-team" id="DP_LeftGroup">
               
             </div>
             <div class="away-team" id="DP_RightGroup">
         
             </div>
          </div>

          <!-- E: record --> 
          <!-- S: 영상보기 film-box -->
          <div class="film-box panel clearfix" id="DP_GroupGameVideo" style="display: none;">
            <button id="btnrewind_Group" onClick="rewind(5);" type="button" class="btn btn-orange btn-rewind"><<</button>
            <button id="btnfastforward_Group" onClick="fastforward(5);"type="button" class="btn btn-orange btn-fastforward">>></button> 
          </div>
          <!-- E: 영상보기 film-box -->
        </div>
       <!-- E: modal-body -->
        <!-- S: modal footer -->
        <div class="modal-footer">
            <div class="btn-list flex">
            <button type="button" onClick="changegroup_btn();" id="btn_groupmovie" class="btn btn-orange btn-film" style="display: block;">
            <span class="ic-deco"><img src="../images/stats/film-icon@3x.png" alt="" /></span>영상보기</button>
            <a href="javascript:;" onClick="changegroup_btn();" id="btn_grouplog" role="button" class="btn btn-orange btn-record" style="display:none">기록보기</a>
            <a href="javascript:;" role="button" class="btn btn-close btn-ins btn-default" data-dismiss="modal">닫기</a>
            </div>
        </div>
        <!--E: modal-footer -->
      </div>
      <!-- modal-content -->
    </div> 
    <!-- modal-dialog -->
  </div>
  <!-- E: 단체전 영상보기 모달 modal -->


  <!-- S: 테니스 상세스코어 모달 -->
  <!-- #include file="../include/modal/tn_score_record.asp" -->
  <!-- E: 테니스 상세스코어 모달 -->


  <script>
      $('.init_btn').click();
      $('.tn_modal').modal('show');
  </script>
  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>