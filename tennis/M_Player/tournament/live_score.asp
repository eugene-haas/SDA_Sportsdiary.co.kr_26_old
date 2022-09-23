<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<link rel="stylesheet" href="../css/tennis_style.css">
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
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대진표</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub sub-main -->
  <div class="sub sub-main tourney live-score h-fix">
    <!-- S: tourney-title -->
    <div class="tourney-title">
      <h3 id="tourney_title">2017 K-SWISS 배 전국 동호인 테니스 대회</h3>
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

    <!-- S: tn_live_tab -->
    <div class="tn_live_tab">
      <!-- S: btn_list btn_2 -->
      <div class="btn_list btn_2">
        <ul class="flex">
          <li>
            <a href="./tourney.asp" class="btn btn-normal">전체</a>
          </li>
          <li>
            <a href="./live_score.asp" class="btn btn-normal btn-live-score on"><span class="ic_deco live">LIVE</span>LIVE SCORE <span class="ic_deco"><i class="fa fa-wifi"></i></span></a>
          </li>
        </ul>
      </div>
      <!-- E: btn_list btn_2 -->
    </div>
    <!-- E: tn_live_tab -->

    <!-- S: banner banner_md -->
    <div class="banner banner_md">
      <div class="img_box">
        <img src="http://img.sportsdiary.co.kr/sdapp/public/banner_md@3x.png" alt="광고영역">
      </div>
    </div>
    <!-- E: banner banner_md -->


    <!-- S: bg_court -->
    <div class="bg_court">
      <!-- S: court -->
      <div class="court clearfix">
        <!-- S: court_header -->
        <div class="court_header clearfix">
          <h3>Court 11 <span class="round">(8강)</span></h3>
          <p class="play_divn">
            <span>개인전</span>
            <span>오픈부</span>
            <span>본선-복식</span>
          </p>
        </div>
        <!-- E: court_header -->

        <!-- S: score_board -->
        <div class="score_board">
          <!-- S: board_table -->
          <ul class="tn_board_table clearfix">
            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                  <span class="serve ic_deco">
                    <img src="http://img.sportsdiary.co.kr/sdapp/liveScore/ball@3x.png" alt="서브">
                  </span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts">0</div>
              <div class="num y">7</div>
              <div class="num">4</div>
              <div class="num y">7</div>
              <div class="num"></div>
              <div class="num y"></div>
            </li>

            <li class="set_line">
              <div class="board_header"></div>
              <div class="pts">PTS</div>
              <div class="num">1</div>
              <div class="num">2</div>
              <div class="num">3</div>
              <div class="num">4</div>
              <div class="num">5</div>
            </li>

            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts on">15</div>
              <div class="num">5</div>
              <div class="num y">6</div>
              <div class="num">6 <span class="tie">(11)</span></div>
              <div class="num y"></div>
              <div class="num"></div>
            </li>

            <li class="duration">
              <div class="board_header"></div>
              <div class="win"></div>
              <div class="num">46'</div>
              <div class="num">29'</div>
              <div class="num">55'</div>
              <div class="num"></div>
              <div class="num"></div>
            </li>
          </ul>
          <!-- E: board_table -->
        </div>
        <!-- E: score_board -->
      </div>
      <!-- E: court -->


      <!-- S: court -->
      <div class="court clearfix">
        <!-- S: court_header -->
        <div class="court_header clearfix">
          <h3>Court 11 <span class="round">(8강)</span></h3>
          <p class="play_divn">
            <span>개인전</span>
            <span>오픈부</span>
            <span>본선-복식</span>
          </p>
        </div>
        <!-- E: court_header -->

        <!-- S: score_board -->
        <div class="score_board">
          <!-- S: board_table -->
          <ul class="tn_board_table clearfix">
            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                  <span class="serve ic_deco">
                    <img src="http://img.sportsdiary.co.kr/sdapp/liveScore/ball@3x.png" alt="서브">
                  </span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts">0</div>
              <div class="num y">7</div>
              <div class="num">4</div>
              <div class="num y">7</div>
              <div class="num"></div>
              <div class="num y"></div>
            </li>

            <li class="set_line">
              <div class="board_header"></div>
              <div class="pts">PTS</div>
              <div class="num">1</div>
              <div class="num">2</div>
              <div class="num">3</div>
              <div class="num">4</div>
              <div class="num">5</div>
            </li>

            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts on">15</div>
              <div class="num">5</div>
              <div class="num y">6</div>
              <div class="num">6 <span class="tie">(11)</span></div>
              <div class="num y"></div>
              <div class="num"></div>
            </li>

            <li class="duration">
              <div class="board_header"></div>
              <div class="win"></div>
              <div class="num">46'</div>
              <div class="num">29'</div>
              <div class="num">55'</div>
              <div class="num"></div>
              <div class="num"></div>
            </li>
          </ul>
          <!-- E: board_table -->
        </div>
        <!-- E: score_board -->
      </div>
      <!-- E: court -->

      <!-- S: court -->
      <div class="court clearfix">
        <!-- S: court_header -->
        <div class="court_header clearfix">
          <h3>Court 11 <span class="round">(8강)</span></h3>
          <p class="play_divn">
            <span>개인전</span>
            <span>오픈부</span>
            <span>본선-복식</span>
          </p>
        </div>
        <!-- E: court_header -->

        <!-- S: score_board -->
        <div class="score_board">
          <!-- S: board_table -->
          <ul class="tn_board_table clearfix">
            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                  <span class="serve ic_deco">
                    <img src="http://img.sportsdiary.co.kr/sdapp/liveScore/ball@3x.png" alt="서브">
                  </span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts">0</div>
              <div class="num y">7</div>
              <div class="num">4</div>
              <div class="num y">7</div>
              <div class="num"></div>
              <div class="num y"></div>
            </li>

            <li class="set_line">
              <div class="board_header"></div>
              <div class="pts">PTS</div>
              <div class="num">1</div>
              <div class="num">2</div>
              <div class="num">3</div>
              <div class="num">4</div>
              <div class="num">5</div>
            </li>

            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts on">15</div>
              <div class="num">5</div>
              <div class="num y">6</div>
              <div class="num">6 <span class="tie">(11)</span></div>
              <div class="num y"></div>
              <div class="num"></div>
            </li>

            <li class="duration">
              <div class="board_header"></div>
              <div class="win"></div>
              <div class="num">46'</div>
              <div class="num">29'</div>
              <div class="num">55'</div>
              <div class="num"></div>
              <div class="num"></div>
            </li>
          </ul>
          <!-- E: board_table -->
        </div>
        <!-- E: score_board -->
      </div>
      <!-- E: court -->

      <!-- S: court -->
      <div class="court clearfix">
        <!-- S: court_header -->
        <div class="court_header clearfix">
          <h3>Court 11 <span class="round">(8강)</span></h3>
          <p class="play_divn">
            <span>개인전</span>
            <span>오픈부</span>
            <span>본선-복식</span>
          </p>
        </div>
        <!-- E: court_header -->

        <!-- S: score_board -->
        <div class="score_board">
          <!-- S: board_table -->
          <ul class="tn_board_table clearfix">
            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                  <span class="serve ic_deco">
                    <img src="http://img.sportsdiary.co.kr/sdapp/liveScore/ball@3x.png" alt="서브">
                  </span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts">0</div>
              <div class="num y">7</div>
              <div class="num">4</div>
              <div class="num y">7</div>
              <div class="num"></div>
              <div class="num y"></div>
            </li>

            <li class="set_line">
              <div class="board_header"></div>
              <div class="pts">PTS</div>
              <div class="num">1</div>
              <div class="num">2</div>
              <div class="num">3</div>
              <div class="num">4</div>
              <div class="num">5</div>
            </li>

            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts on">15</div>
              <div class="num">5</div>
              <div class="num y">6</div>
              <div class="num">6 <span class="tie">(11)</span></div>
              <div class="num y"></div>
              <div class="num"></div>
            </li>

            <li class="duration">
              <div class="board_header"></div>
              <div class="win"></div>
              <div class="num">46'</div>
              <div class="num">29'</div>
              <div class="num">55'</div>
              <div class="num"></div>
              <div class="num"></div>
            </li>
          </ul>
          <!-- E: board_table -->
        </div>
        <!-- E: score_board -->
      </div>
      <!-- E: court -->

      <!-- S: court -->
      <div class="court clearfix">
        <!-- S: court_header -->
        <div class="court_header clearfix">
          <h3>Court 11 <span class="round">(8강)</span></h3>
          <p class="play_divn">
            <span>개인전</span>
            <span>오픈부</span>
            <span>본선-복식</span>
          </p>
        </div>
        <!-- E: court_header -->

        <!-- S: score_board -->
        <div class="score_board">
          <!-- S: board_table -->
          <ul class="tn_board_table clearfix">
            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                  <span class="serve ic_deco">
                    <img src="http://img.sportsdiary.co.kr/sdapp/liveScore/ball@3x.png" alt="서브">
                  </span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts">0</div>
              <div class="num y">7</div>
              <div class="num">4</div>
              <div class="num y">7</div>
              <div class="num"></div>
              <div class="num y"></div>
            </li>

            <li class="set_line">
              <div class="board_header"></div>
              <div class="pts">PTS</div>
              <div class="num">1</div>
              <div class="num">2</div>
              <div class="num">3</div>
              <div class="num">4</div>
              <div class="num">5</div>
            </li>

            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts on">15</div>
              <div class="num">5</div>
              <div class="num y">6</div>
              <div class="num">6 <span class="tie">(11)</span></div>
              <div class="num y"></div>
              <div class="num"></div>
            </li>

            <li class="duration">
              <div class="board_header"></div>
              <div class="win"></div>
              <div class="num">46'</div>
              <div class="num">29'</div>
              <div class="num">55'</div>
              <div class="num"></div>
              <div class="num"></div>
            </li>
          </ul>
          <!-- E: board_table -->
        </div>
        <!-- E: score_board -->
      </div>
      <!-- E: court -->

      <!-- S: court -->
      <div class="court clearfix">
        <!-- S: court_header -->
        <div class="court_header clearfix">
          <h3>Court 11 <span class="round">(8강)</span></h3>
          <p class="play_divn">
            <span>개인전</span>
            <span>오픈부</span>
            <span>본선-복식</span>
          </p>
        </div>
        <!-- E: court_header -->

        <!-- S: score_board -->
        <div class="score_board">
          <!-- S: board_table -->
          <ul class="tn_board_table clearfix">
            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                  <span class="serve ic_deco">
                    <img src="http://img.sportsdiary.co.kr/sdapp/liveScore/ball@3x.png" alt="서브">
                  </span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts">0</div>
              <div class="num y">7</div>
              <div class="num">4</div>
              <div class="num y">7</div>
              <div class="num"></div>
              <div class="num y"></div>
            </li>

            <li class="set_line">
              <div class="board_header"></div>
              <div class="pts">PTS</div>
              <div class="num">1</div>
              <div class="num">2</div>
              <div class="num">3</div>
              <div class="num">4</div>
              <div class="num">5</div>
            </li>

            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts on">15</div>
              <div class="num">5</div>
              <div class="num y">6</div>
              <div class="num">6 <span class="tie">(11)</span></div>
              <div class="num y"></div>
              <div class="num"></div>
            </li>

            <li class="duration">
              <div class="board_header"></div>
              <div class="win"></div>
              <div class="num">46'</div>
              <div class="num">29'</div>
              <div class="num">55'</div>
              <div class="num"></div>
              <div class="num"></div>
            </li>
          </ul>
          <!-- E: board_table -->
        </div>
        <!-- E: score_board -->
      </div>
      <!-- E: court -->

      <!-- S: court -->
      <div class="court clearfix">
        <!-- S: court_header -->
        <div class="court_header clearfix">
          <h3>Court 11 <span class="round">(8강)</span></h3>
          <p class="play_divn">
            <span>개인전</span>
            <span>오픈부</span>
            <span>본선-복식</span>
          </p>
        </div>
        <!-- E: court_header -->

        <!-- S: score_board -->
        <div class="score_board">
          <!-- S: board_table -->
          <ul class="tn_board_table clearfix">
            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                  <span class="serve ic_deco">
                    <img src="http://img.sportsdiary.co.kr/sdapp/liveScore/ball@3x.png" alt="서브">
                  </span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts">0</div>
              <div class="num y">7</div>
              <div class="num">4</div>
              <div class="num y">7</div>
              <div class="num"></div>
              <div class="num y"></div>
            </li>

            <li class="set_line">
              <div class="board_header"></div>
              <div class="pts">PTS</div>
              <div class="num">1</div>
              <div class="num">2</div>
              <div class="num">3</div>
              <div class="num">4</div>
              <div class="num">5</div>
            </li>

            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <span class="player">최보라</span>
                  <span class="team">강서어택, 제1 한강지구부대</span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <span class="player">김선영</span>
                  <span class="team">강서어택, 제2 한강지구부대</span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <!-- <div class="win" rowspan="2">
                <div class="img_box">
                  <img src="../images/modal/win_crown@3x.png" alt="win">
                </div>
              </div> -->
              <!-- E: win -->
              <div class="pts on">15</div>
              <div class="num">5</div>
              <div class="num y">6</div>
              <div class="num">6 <span class="tie">(11)</span></div>
              <div class="num y"></div>
              <div class="num"></div>
            </li>

            <li class="duration">
              <div class="board_header"></div>
              <div class="win"></div>
              <div class="num">46'</div>
              <div class="num">29'</div>
              <div class="num">55'</div>
              <div class="num"></div>
              <div class="num"></div>
            </li>
          </ul>
          <!-- E: board_table -->
        </div>
        <!-- E: score_board -->
      </div>
      <!-- E: court -->

    </div>
    <!-- E: bg_court -->

  </div>
  <!-- E: sub sub-main board -->


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
