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
    localStorage.setItem("EnterType", "E");

    //console.log($("#game-type").val());

</script>
<head>
<meta name="viewport" content="width=device-width, minimum-scale=1, initial-scale=1">
</head>
<body onLoad="onLoad()" id="AppBody">
  <!--<a href="#" data-target="#show-tourney-pop" data-toggle="modal" class="init_btn"></a>-->

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대진표</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
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
                    <img src="../../WebTournament/www/images/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onclick="mov_enterscore(this);" data-id="13" data-whatever="01">13</a>
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
                    <img src="../../WebTournament/www/images/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onclick="mov_enterscore(this);" data-id="14" data-whatever="01">14</a>
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
                    <img src="../../WebTournament/www/images/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onclick="mov_enterscore(this);" data-id="15" data-whatever="01">15</a>
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
    </div>

  <!-- S: tennis-tourney-wrap -->
  <div class="tennis-tourney-wrap">
  <!-- S: tennis tourney -->
  <div class="tennis-tourney clearfix">
  <!--style="transform : scale3d(0.75, 0.75, 0.75);"-->
  <!-- S: left-side -->
  <div class="left-side clearfix">
    <!-- S: match-list -->
    <div id="match_list_left" class="match-list">
      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">백동균</span>
            <span class="player-school">인천서흥초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">김영석</span>
            <span class="player-school">위드라인고등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">김정모</span>
            <span class="player-school">내성초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">김영석</span>
            <span class="player-school">위드라인고등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">홍재희</span>
            <span class="player-school">도천초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">김용범</span>
            <span class="player-school">소룡초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">이동욱</span>
            <span class="player-school">명덕초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">김용범</span>
            <span class="player-school">소룡초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">이동욱</span>
            <span class="player-school">명덕초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">한성수</span>
            <span class="player-school">명덕초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">이재준</span>
            <span class="player-school">동남초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">김영서기</span>
            <span class="player-school">동남초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">진도현</span>
            <span class="player-school">신금초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name small-name">LICHANGMING</span>
            <span class="player-school">탑동초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">박준영</span>
            <span class="player-school">문선초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">문동현</span>
            <span class="player-school">다문초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">차민호</span>
            <span class="player-school">인천남촌초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">정세민</span>
            <span class="player-school">신금초등학교</span>
          </div>
           <div class="player-info">
            <span class="player-name">김영세민</span>
            <span class="player-school">신금초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">유정훈</span>
            <span class="player-school">서울응암초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
           <div class="player-info">
            <span class="player-name">김건우</span>
            <span class="player-school">석수초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">강성현</span>
            <span class="player-school">납읍초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">조성모</span>
            <span class="player-school">청계초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">김단야빈</span>
            <span class="player-school">장양초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">최건아</span>
            <span class="player-school">옥천장야초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">박태원</span>
            <span class="player-school">흥덕초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">이태원</span>
            <span class="player-school">흥덕두리초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">박태원</span>
            <span class="player-school">흥덕초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">이태원</span>
            <span class="player-school">흥덕두리초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">최건아</span>
            <span class="player-school">옥천장야초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">박태원</span>
            <span class="player-school">흥덕초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">이태원</span>
            <span class="player-school">흥덕두리초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">박태원</span>
            <span class="player-school">흥덕초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">이태원</span>
            <span class="player-school">흥덕두리초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">최건아</span>
            <span class="player-school">옥천장야초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">최건아</span>
            <span class="player-school">옥천장야초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">최건아</span>
            <span class="player-school">옥천장야초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

    </div>
    <!-- E: match-list -->

    <!-- S: Round-1 -->
    <div id="round_01_left" class="round-1">
      <div class="line-div">
        <img src="../../WebTournament/www/images/tournerment/01_L_top.png" alt="">
        <a onClick="editscore(this)" data-toggle="modal" data-id="1" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">1.</a>
      </div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="2" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">2.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="3" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">3.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="4" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">4.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="5" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">5.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="6" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">6.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="7" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">7.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_L_center.png" alt=""></div>
    </div>
    <!-- E: Round-1 -->
    <!-- S: Winner-1 -->
    <!-- <div  id="winner_01_left" class="winner-1">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner empty">김영석 (&nbsp;<span class="skill">승(한판)(10)</san>) <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner empty">김영석 (&nbsp;<span class="skill">승(한판)(10)</san>) <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner empty">김영석 (&nbsp;<span class="skill">승(한판)(10)</san>) <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner empty">김영석 (&nbsp;<span class="skill">승(한판)(10)</san>) <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-1 -->
    <!-- S: Round-2 -->
    <div id="round_02_left" class="round-2">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="14" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">14.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="15" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">15.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="16" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">16.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="17" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">17.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="18" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">18.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="19" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">19.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="20" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">20.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="21" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">21.</a></div>
    </div>
    <!-- E: Round-2 -->
    <!-- S: Winner-2 -->
    <!-- <div id="winner_02_left" class="winner-2">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-2 -->
    <!-- S: Round-3 -->
    <div id="round_03_left" class="round-3">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/03_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="30" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">30.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/03_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="31" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">31.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/03_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="32" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">32.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/03_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="33" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">33.</a></div>
    </div>
    <!-- E: Round-3 -->
    <!-- S: Winner-3 -->
    <!-- <div id="winner_03_left" class="winner-3">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-3 -->
    <!-- S: Round-4 -->
    <div id="round_04_left" class="round-4">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/04_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="38" data-whatever="04" role="button" class="btn btn-danger btn-look time-out">38.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/04_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="39" data-whatever="04" role="button" class="btn btn-danger btn-look time-out">39.</a></div>
    </div>
    <!-- E: Round-4 -->
    <!-- S: Winner-4 -->
    <!-- <div id="winner_04_left" class="winner-4">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-4 -->
    <!-- S: Round-5 -->
    <div id="round_05_left" class="round-5">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/05_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="42" data-whatever="05" role="button" class="btn btn-danger btn-look time-out">42.</a></div>
    </div>
    <!-- E: Round-5 -->
    <!-- S: Winner-5 -->
    <!-- <div id="winner_05_left" class="winner-5">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-5 -->
    <!-- S: Round-6 -->
    <div id="round_06_left" class="round-6" style="display: none;">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/06_L_basic.png" alt=""> <a href="enter-score.html" role="button" class="btn btn-primary btn-look">50</a> </div>
    </div>
    <!-- E: Round-6 -->
    <!-- S: Winner-6 -->
    <!-- <div id="winner_06_left" class="winner-6">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-6 -->
    <!-- S: final-match -->
    <div class="final-match">
      <!-- S: final-div -->
      <div id="final_div" class="final-div">
        <div class="line-div"><a onClick="editscore(this)" role="button" class="final-match-box winner" data-id="44" data-toggle="modal">
          <p><span class="final-player">오상우</span> 승</p>
          <!--<p><span>승(절반)</span>(1)<i class='fa fa-plus' aria-hidden='true'></i></p>-->
          </a> <img src="../../WebTournament/www/images/tournerment/7_win_R.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="44" data-whatever="06" role="button" class="btn btn-danger btn-look time-out">44.</a></div>
      </div>
      <!-- E: final-div -->
    </div>
    <!-- E: final-match -->
  </div>
  <!-- E: left-side -->
  <!-- S: right-side -->
  <div class="right-side">
    <!-- S: match-list -->
    <div id="match_list_right" class="match-list">

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">이성우</span>
            <span class="player-school">진선미유도관</span>
          </div>
          <div class="player-info">
            <span class="player-name">양현진</span>
            <span class="player-school">옥천초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <div class="team-match">
          <div class="player-info">
            <span class="player-name">이규민</span>
            <span class="player-school">북삼초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">이규민</span>
            <span class="player-school">북삼초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <div class="team-match">
          <div class="player-info">
            <span class="player-name">박성수</span>
            <span class="player-school">옥천초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">은지원</span>
            <span class="player-school">인천삼산초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">황재환</span>
            <span class="player-school">대구성동초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">박성수</span>
            <span class="player-school">옥천초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">박성수</span>
            <span class="player-school">옥천초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <div class="team-match">
          <div class="player-info">
            <span class="player-name">박성수</span>
            <span class="player-school">옥천초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">박규도</span>
            <span class="player-school">부안초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">배범준</span>
            <span class="player-school">대구태현초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">우영수</span>
            <span class="player-school">신금초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">도영수</span>
            <span class="player-school">신은동초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">유재승</span>
            <span class="player-school">가산초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->


      <!-- S: match -->
      <div class="no-match">
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">윤승빈</span>
            <span class="player-school">신철원초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">윤승빈</span>
            <span class="player-school">신철원초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">함다빈</span>
            <span class="player-school">남수원초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">신우진</span>
            <span class="player-school">다문초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">함다빈</span>
            <span class="player-school">남수원초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">신우진</span>
            <span class="player-school">다문초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">김재욱</span>
            <span class="player-school">솔샘초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

     <!-- S: match -->
     <div class="match">
      <!-- S: team-match -->
      <div class="team-match clearfix">
        <div class="player-info">
          <span class="player-name">송유성</span>
          <span class="player-school">영해초등학교</span>
        </div>
        <div class="player-info">
          <span class="player-name">유건아</span>
          <span class="player-school">부안초등학교</span>
        </div>
      </div>
      <!-- E: team-match -->
     </div>
     <!-- E: match -->

     <!-- S: match -->
     <div class="match">
      <!-- S: team-match -->
      <div class="team-match clearfix">
        <div class="player-info">
          <span class="player-name">송유성</span>
          <span class="player-school">영해초등학교</span>
        </div>
        <div class="player-info">
          <span class="player-name">유건아</span>
          <span class="player-school">부안초등학교</span>
        </div>
      </div>
      <!-- E: team-match -->
     </div>
     <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">염형준</span>
            <span class="player-school">서울응암초등학교</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">이희성</span>
            <span class="player-school">인천남촌초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">윤효원</span>
            <span class="player-school">인천신현북초등학</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="match">
        <!-- S: team-match -->
        <div class="team-match clearfix">
          <div class="player-info">
            <span class="player-name">이희성</span>
            <span class="player-school">인천남촌초등학교</span>
          </div>
          <div class="player-info">
            <span class="player-name">윤효원</span>
            <span class="player-school">인천신현북초등학</span>
          </div>
        </div>
        <!-- E: team-match -->
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <div class="team-match">
          <div class="player-info">
            <span class="player-name">박한민</span>
            <span class="player-school">납읍초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

      <!-- S: match -->
      <div class="no-match">
        <div class="team-match">
          <div class="player-info">
            <span class="player-name">오상우</span>
            <span class="player-school">제주서초등학교</span>
          </div>
        </div>
      </div>
      <!-- E: match -->


      <!-- S: match -->
      <div class="no-match">
        <div class="team-match">
          <div class="player-info">
            <span class="player-name">오한빈</span>
            <span class="player-school">인천신현북초등학</span>
          </div>
        </div>
      </div>
      <!-- E: match -->

    </div>
    <!-- E: match-list -->
    <!-- S: round-1 -->
    <div id="round_01_right" class="round-1">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="8" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">8.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="9" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">9.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="10" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">10.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="11" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">11.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="12" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">12.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="13" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">13.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_center.png" alt=""></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/01_R_center.png" alt=""></div>
    </div>
    <!-- E: round-1 -->
    <!-- S: Winner-1 -->
    <!-- <div id="winner_01_right" class="winner-1">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner empty">김영석 (&nbsp;<span class="skill">승(한판)(10)</san>) <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner empty">김영석 (&nbsp;<span class="skill">승(한판)(10)</san>) <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner empty">김영석 (&nbsp;<span class="skill">승(한판)(10)</san>) <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner empty">김영석 (&nbsp;<span class="skill">승(한판)(10)</san>) <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner empty">김영석 (&nbsp;<span class="skill">승(한판)(10)</san>) <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner empty">김영석 (&nbsp;<span class="skill">승(한판)(10)</san>) <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-1 -->
    <!-- S: Round-2 -->
    <div id="round_02_right" class="round-2">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="22" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">22.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="23" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">23.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="24" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">24.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="25" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">25.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="26" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">26.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="27" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">27.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="28" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">28.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/02_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="29" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">29.</a></div>
    </div>
    <!-- E: Round-2 -->
    <!-- S: Winner-2 -->
    <!-- <div id="winner_02_right" class="winner-2">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-2 -->
    <!-- S: Round-3 -->
    <div id="round_03_right" class="round-3">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/03_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="34" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">34.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/03_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="35" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">35.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/03_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="36" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">36.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/03_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="37" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">37.</a></div>
    </div>
    <!-- E: Round-3 -->
    <!-- S: Winner-3 -->
    <!-- <div id="winner_03_right" class="winner-3">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-3 -->
    <!-- S: Round-4 -->
    <div id="round_04_right" class="round-4">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/04_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="40" data-whatever="04" role="button" class="btn btn-danger btn-look time-out">40.</a></div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/04_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="41" data-whatever="04" role="button" class="btn btn-danger btn-look time-out">41.</a></div>
    </div>
    <!-- E: Round-4 -->
    <!-- S: Winner-4 -->
    <!-- <div id="winner_04_right" class="winner-4">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(8)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-4 -->
    <!-- S: Round-5 -->
    <div id="round_05_right" class="round-5">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/05_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="43" data-whatever="05" role="button" class="btn btn-danger btn-look time-out">43.</a></div>
    </div>
    <!-- E: Round-5 -->
    <!-- S: Winner-5 -->
    <!-- <div id="winner_05_right" class="winner-5">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-5 -->
    <!-- S: Round-6 -->
    <div id="round_06_right" class="round-6" style="display: none;">
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/06_R_basic.png" alt=""> <a href="enter-score.html" role="button" class="btn btn-primary btn-look">50</a> </div>
      <div class="line-div"> <img src="../../WebTournament/www/images/tournerment/06_R_basic.png" alt=""> <a href="enter-score.html" role="button" class="btn btn-primary btn-look">50</a> </div>
    </div>
    <!-- E: Round-6 -->
    <!-- S: Winner-6 -->
    <!-- <div id="winner_06_right" class="winner-6">
        <a href="#" role="button" data-toggle="modal" data-target="#round-res" class="winner"><span class="skill">승(한판)(10)</span><i class="fa fa-plus" aria-hidden="true"></i></a>
      </div> -->
    <!-- E: Winner-6 -->
  </div>
  <!-- E: right-side -->
</div>
  <!-- E: tennis tourney -->
  </div>
  <!-- E: tennis tourney wrap -->

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
          <div class="film-box panel" id ="DP_GameVideo" style="display: none;">
            <!-- S: guide-txt -->
            <div class="guide-txt show-film-guide">
              ※ 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
            </div>
            <!-- E: guide-txt -->
            <!--<iframe  width="100%" height="160" src="https://www.youtube.com/embed/CtVHss3U3WA" frameborder="0" allowfullscreen=""></iframe>-->
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
            <span class="ic-deco"><img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt=""/>  </span>영상보기</button>

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
          <h2><span class="left-arrow"><img src="../../webtournament/www/../../WebTournament/www/images/tournerment/tourney/yellow-larr.png" alt></span><span id="DP_WinGroup">송도고(27.5점) 승</span><span class="right-arrow"><img src="../../webtournament/www/../../WebTournament/www/images/tournerment/tourney/yellow-rarr.png" alt></span></h2>
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
          <div class="film-box panel" id="DP_GroupGameVideo" style="display: none;">
          </div>

          <!-- E: 영상보기 film-box -->
           <!-- S: modal footer -->
           <div class="modal-footer">
              <div class="btn-list flex">
                <button type="button" onClick="changegroup_btn();" id="btn_groupmovie" class="btn btn-orange btn-film" style="display: block;">
                <span class="ic-deco"><img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt="" /></span>영상보기</button>
                <a href="#" onClick="changegroup_btn();" id="btn_grouplog" role="button" class="btn btn-orange btn-record" style="display:none">기록보기</a>
                <a href="#" role="button" class="btn btn-close btn-ins btn-default" data-dismiss="modal">닫기</a>
             </div>
           </div>
           <!--E: modal-footer -->
        </div>
       <!-- E: modal-body -->
      </div><!-- modal-content -->
    </div>
    <!-- modal-dialog -->
  </div>
  <!-- E: 단체전 영상보기 모달 modal -->


  <script>
    $('.init_btn').click();
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
