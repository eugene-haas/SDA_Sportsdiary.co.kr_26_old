<head>
  <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
  <link rel="stylesheet" href="../../../pub/css/tennisAdmin.css">
  <link rel="stylesheet" href="../../../pub/css/tennis/style.css">
  <link rel="stylesheet" href="./css/_tourney.css">
  <link rel="stylesheet" href="./css/_tourney_round.css">
  <link rel="stylesheet" href="./css/_tourney_league.css">
</head>
  
  <!-- S: modal_tourney -->
  <div class="modal fade modal_tourney">
    <!-- S: modal-dialog -->
    <div class="modal-dialog modal-lg">
      <!-- S: modal-content -->
      <div class="modal-content">
        <!-- S: modal-header -->
        <div class="modal-header">
          <h1>대진표</h1>
          <a href="#" class="btn btn_close" data-dismiss="modal">닫기
            <!-- <img src="../../../front/dist/imgs/public/close_x_s.png" alt="닫기"> -->
          </a>
        </div>
        <!-- E: modal-header -->
        <!-- S: modal-body -->
        <div class="modal-body">
          <form>
            <!-- S: sub sub-main -->
            <div class="sub sub-main tourney container-fluid">
             
              <!-- S: tourney-title -->
              <h2 class="stage-title" id="GameTitleName"></h2>
              <!-- 
                d-day 에 before: 경기전
                d-day 에 playing: 경기중
                d-day 에 day_count: D-1, D-2, D-3... D-N
                d-day 에 end: 경기종료
              -->

              <p class="date"><span class="d-day" id="day_status">경기전</span>
              <span class="date_txt" id="date_txt">2017.04.10(월) ~ 12(수)</span></p>
              <!-- S: input-select -->
              <div class="input-select ent-sel">
                <!-- S: tab-menu -->
                <div class="enter-type tab-menu">
                  <ul class="clearfix">
                    <li class="game-type">
                      <select id="GroupGameGb"  onchange="tourney_GroupGameGb_Change();"></select> 
                    </li>
                    <li class="type-sel">
                      <select id="TeamGb" class="srch-sel" data-native-menu="false" onchange="tourney_TeamGb_Change();"></select>
                    </li>
                    <li class="type-sel">
                      <select>
                        <option>예선</option>
                        <option>본선</option>
                      </select>
                    </li>
                    <li> <a href="javascript:tourney_Modal_Search();" class="btn btn-srch">조회</a> </li>
                  </ul>
                </div>
                <!-- E: tab-menu -->
                <p class="user_guide redy">※ 대진표는 대회참가신청 및 대진추첨이 완료된 대회만 확인 가능합니다.</p>
              </div>
              <!-- E: input-select -->

              <!-- S: srch_intro -->
              <div class="srch_intro">
                <p>해당 대회의 대진표를 확인해보세요.</p>
              </div>
              <!-- E: srch_intro -->

              <!-- S: 본선 리그 표 -->
              <div class="tourney tourn preli">
                <!-- S: preli-table -->
                <div class="preli-table">
                  <table class="table table-striped">
                    <thead>
                      <tr>
                        <th>그룹</th>
                        <th style="width: 120px;">지역(코트)</th>
                        <th colspan="2">1번</th>
                        <th colspan="2">2번</th>
                        <th colspan="2">3번</th>
                        <th>상세보기</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>제1조</td>
                        <td>구리</td>
                        <td class="pass">
                          <div>
                            <span class="result">1위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">이명화</span>
                          <span class="belong">구양회</span>
                        </td>
                        <td class="pass">
                          <div>
                            <span class="result">1위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">임연채</span>
                          <span class="belong">정사모,토요회</span>
                        </td>
                        <td class="pass">
                          <div>
                            <span class="result">2위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">박인숙</span>
                          <span class="belong">의정부여성연맹</span>
                        </td>
                        <td class="pass">
                          <div>
                            <span class="result">2위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">황덕순</span>
                          <span class="belong">분당플러스,양지한양</span>
                        </td>
                        <td>
                          <div>
                            <span class="result">3위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">전보경</span>
                          <span class="belong">대전정,충남어머니</span>
                        </td>
                        <td>
                          <div>
                            <span class="result">3위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">이자영</span>
                          <span class="belong">장미,서울클럽</span>
                        </td>
                        <td>
                          <a href="#" class="btn btn-finish">상세스코어</a>
                        </td>
                      </tr>
                      <tr>
                        <td>제1조</td>
                        <td>구리</td>
                        <td class="pass">
                          <div>
                            <span class="result">1위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">이명화</span>
                          <span class="belong">구양회</span>
                        </td>
                        <td class="pass">
                          <div>
                            <span class="result">1위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">임연채</span>
                          <span class="belong">정사모,토요회</span>
                        </td>
                        <td class="pass">
                          <div>
                            <span class="result">2위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">박인숙</span>
                          <span class="belong">의정부여성연맹</span>
                        </td>
                        <td class="pass">
                          <div>
                            <span class="result">2위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">황덕순</span>
                          <span class="belong">분당플러스,양지한양</span>
                        </td>
                        <td>
                          <div>
                            <span class="result">3위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">전보경</span>
                          <span class="belong">대전정,충남어머니</span>
                        </td>
                        <td>
                          <div>
                            <span class="result">3위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">이자영</span>
                          <span class="belong">장미,서울클럽</span>
                        </td>
                        <td>
                          <a href="#" class="btn btn-finish">상세스코어</a>
                        </td>
                      </tr>
                      <tr>
                        <td>제1조</td>
                        <td>구리</td>
                        <td class="pass">
                          <div>
                            <span class="result">1위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">이명화</span>
                          <span class="belong">구양회</span>
                        </td>
                        <td class="pass">
                          <div>
                            <span class="result">1위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">임연채</span>
                          <span class="belong">정사모,토요회</span>
                        </td>
                        <td class="pass">
                          <div>
                            <span class="result">2위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">박인숙</span>
                          <span class="belong">의정부여성연맹</span>
                        </td>
                        <td class="pass">
                          <div>
                            <span class="result">2위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">황덕순</span>
                          <span class="belong">분당플러스,양지한양</span>
                        </td>
                        <td>
                          <div>
                            <span class="result">3위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">전보경</span>
                          <span class="belong">대전정,충남어머니</span>
                        </td>
                        <td>
                          <div>
                            <span class="result">3위</span>
                            <span class="point"></span>
                          </div>
                          <span class="player">이자영</span>
                          <span class="belong">장미,서울클럽</span>
                        </td>
                        <td>
                          <a href="#" class="btn btn-finish">상세스코어</a>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <!-- S: preli-table -->

                <!-- S: preli-league -->
                <div class="preli-league">
                  <table>
                    <thead>
                      <tr>
                        <th>제1조</th>
                        <th>
                          <span class="round">1</span>
                          <p>
                            <span class="player">이명화</span>
                            <span class="belong">(구양회,)</span>
                          </p>
                          <p>
                            <span class="player">임연채</span>
                            <span class="belong">(정사모,토요회)</span>
                          </p>
                        </th>
                        <th>
                          <span class="round">2</span>
                          <p>
                            <span class="player">박인숙</span>
                            <span class="belong">(구양회,)</span>
                          </p>
                          <p>
                            <span class="player">황덕순</span>
                            <span class="belong">(정사모,토요회)</span>
                          </p>
                        </th>
                        <th>
                          <p class="tit">승패(점수)</p>
                        </th>
                        <th>
                          <p class="tit">순위</p>
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <th>
                          <span class="round">1</span>
                          <p>
                            <span class="player">이명화</span>
                            <span class="belong">(구양회,)</span>
                          </p>
                          <p>
                            <span class="player">임연채</span>
                            <span class="belong">(정사모,토요회)</span>
                          </p>
                        </th>
                        <td>
                          <p class="no-match">
                            <img src="../../front/dist/imgs/tournerment/league/cross_line.png" alt>
                          </p>
                        </td>
                        <td>
                          <p class="team">
                            <span class="player1">이명화</span>
                            ,
                            <span class="player2">임연채</span>
                          </p>
                          <p class="v-s">vs</p>
                          <p class="team">
                            <span class="player3">박인숙</span>
                            ,
                            <span class="player4">황덕순</span>
                          </p>
                          <!-- <a href="#" class="btn btn-ready">스코어입력</a> -->
                        </td>
                        <td class="win-lose">
                          <span class="record-box">0승0무0패</span>
                          <span class="point">1</span>
                        </td>
                        <td class="order">-</td>
                      </tr>
                      <tr>
                        <th>
                          <span class="round">1</span>
                          <p>
                            <span class="player">이명화</span>
                            <span class="belong">(구양회,)</span>
                          </p>
                          <p>
                            <span class="player">임연채</span>
                            <span class="belong">(정사모,토요회)</span>
                          </p>
                        </th>
                        <td>
                          <p class="no-match">
                            <img src="../../front/dist/imgs/tournerment/league/cross_line.png" alt>
                          </p>
                        </td>
                        <td>
                          <p class="team">
                            <span class="player1">이명화</span>
                            ,
                            <span class="player2">임연채</span>
                          </p>
                          <p class="v-s">vs</p>
                          <p class="team">
                            <span class="player3">박인숙</span>
                            ,
                            <span class="player4">황덕순</span>
                          </p>
                          <!-- <a href="#" class="btn btn-ready">스코어입력</a> -->
                        </td>
                        <td class="win-lose">
                          <span class="record-box">0승0무0패</span>
                          <span class="point">1</span>
                        </td>
                        <td class="order">-</td>
                      </tr>
                    </tbody>
                  </table>

                  <!-- S: btn-list -->
                  <div class="btn-list">
                    <a href="#" class="btn btn-show-list">예선 조 목록 보기</a>
                  </div>
                  <!-- E: btn-list -->
                </div>
                <!-- E: preli-league -->

              </div>
              <!-- E: 본선 리그 표 -->


              <!-- S: 예선 각 강수별 라운드 표시 -->
              <div class="tourney round_part tourn">
                <!-- S: game_number -->
                <div class="game_number">
                  <ul class="clearfix">
                    <li>
                      <a href="#" class="btn btn_white on">128</a>
                    </li>
                    <li>
                      <a href="#" class="btn btn_white">64</a>
                    </li>
                    <li>
                      <a href="#" class="btn btn_white">32</a>
                    </li>
                    <li>
                      <a href="#" class="btn btn_white">16</a>
                    </li>
                    <li>
                      <a href="#" class="btn btn_white">8</a>
                    </li>
                    <li>
                      <a href="#" class="btn btn_white">4</a>
                    </li>
                    <li>
                      <a href="#" class="btn btn_white">결승</a>
                    </li>
                  </ul>
                </div>
                <!-- E: game_number -->

                <!-- S: game_tourn -->
                <div class="game_tourn clearfix">
                  <!-- S: left_side -->
                  <div class="left_side">
                    <!-- S: match -->
                    <div class="match">
                      <!-- S: team_list -->
                      <div class="team_list">
                        <!-- S: table -->
                        <table class="table down_line">
                          <tbody><tr class="team team_a win">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                            <td class="seed">
                              <a href="#" class="btn_a">승</a>
                              <a href="#" class="btn_a">취소</a>
                              <select>
                                <option>1번 종료</option>
                                <option>2번 종료</option>
                                <option>3번 종료</option>
                                <option>4번 종료</option>
                                <option>5번 종료</option>
                                <option>6번 종료</option>
                                <option>7번 종료</option>
                                <option>8번 종료</option>
                              </select>
                            </td>
                            <td class="point">-</td>
                          </tr>
                          <tr class="team team_a">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                            <td class="seed">
                              <a href="#" class="btn_a">승</a>
                              <a href="#" class="btn_a">취소</a>
                              <select>
                                <option>1번 종료</option>
                                <option>2번 종료</option>
                                <option>3번 종료</option>
                                <option>4번 종료</option>
                                <option>5번 종료</option>
                                <option>6번 종료</option>
                                <option>7번 종료</option>
                                <option>8번 종료</option>
                              </select>
                            </td>
                            <td class="point">-</td>
                          </tr>
                        </tbody>
                        </table>
                        <!-- E: table -->
                      </div>
                      <!-- E: team_list -->
                    </div>
                    <!-- E: match -->

                    <!-- S: match -->
                    <div class="match">
                      <!-- S: team_list -->
                      <div class="team_list">
                        <!-- S: table -->
                        <table class="table up_line">
                          <tbody><tr class="team team_a">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                            <td class="seed">
                              <a href="#" class="btn_a">승</a>
                              <a href="#" class="btn_a">취소</a>
                              <select>
                                <option>1번 종료</option>
                                <option>2번 종료</option>
                                <option>3번 종료</option>
                                <option>4번 종료</option>
                                <option>5번 종료</option>
                                <option>6번 종료</option>
                                <option>7번 종료</option>
                                <option>8번 종료</option>
                              </select>
                            </td>
                            <td class="point">-</td>
                          </tr>
                          <tr class="team team_b win">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                            <td class="seed">
                              <a href="#" class="btn_a">승</a>
                              <a href="#" class="btn_a">취소</a>
                              <select>
                                <option>1번 종료</option>
                                <option>2번 종료</option>
                                <option>3번 종료</option>
                                <option>4번 종료</option>
                                <option>5번 종료</option>
                                <option>6번 종료</option>
                                <option>7번 종료</option>
                                <option>8번 종료</option>
                              </select>
                            </td>
                            <td class="point">-</td>
                          </tr>
                        </tbody></table>
                        <!-- E: table -->
                      </div>
                      <!-- E: team_list -->
                    </div>
                    <!-- E: match -->

                    <!-- S: no_match -->
                    <div class="no_match">
                      <!-- S: team_list -->
                      <div class="team_list">
                        <!-- S: table -->
                        <table class="table down_line">
                          <tbody>
                            <tr class="team team_a win">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                            <td class="seed">
                              <a href="#" class="btn_a">승</a>
                              <a href="#" class="btn_a">취소</a>
                              <select>
                                <option>1번 종료</option>
                                <option>2번 종료</option>
                                <option>3번 종료</option>
                                <option>4번 종료</option>
                                <option>5번 종료</option>
                                <option>6번 종료</option>
                                <option>7번 종료</option>
                                <option>8번 종료</option>
                              </select>
                            </td>
                            <td class="point">-</td>
                          </tr>
                        </tbody>
                        </table>
                        <!-- E: table -->
                      </div>
                      <!-- E: team_list -->
                    </div>
                    <!-- E: no_match -->

                    <!-- S: match -->
                    <div class="match">
                      <!-- S: team_list -->
                      <div class="team_list">
                        <!-- S: table -->
                        <table class="table up_line">
                          <tbody><tr class="team team_a win">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                            <td class="seed">
                              <a href="#" class="btn_a">승</a>
                              <a href="#" class="btn_a">취소</a>
                              <select>
                                <option>1번 종료</option>
                                <option>2번 종료</option>
                                <option>3번 종료</option>
                                <option>4번 종료</option>
                                <option>5번 종료</option>
                                <option>6번 종료</option>
                                <option>7번 종료</option>
                                <option>8번 종료</option>
                              </select>
                            </td>
                            <td class="point">-</td>
                          </tr>
                          <tr class="team team_b">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                            <td class="seed">
                              <a href="#" class="btn_a">승</a>
                              <a href="#" class="btn_a">취소</a>
                              <select>
                                <option>1번 종료</option>
                                <option>2번 종료</option>
                                <option>3번 종료</option>
                                <option>4번 종료</option>
                                <option>5번 종료</option>
                                <option>6번 종료</option>
                                <option>7번 종료</option>
                                <option>8번 종료</option>
                              </select>
                            </td>
                            <td class="point">-</td>
                          </tr>
                        </tbody></table>
                        <!-- E: table -->
                      </div>
                      <!-- E: team_list -->
                    </div>
                    <!-- E: match -->

                    <!-- S: no_match -->
                    <div class="no_match">
                      <!-- S: team_list -->
                      <div class="team_list">
                        <!-- S: table -->
                        <table class="table down_line">
                          <tbody>
                            <tr class="team team_a win">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                            <td class="seed">
                              <a href="#" class="btn_a">승</a>
                              <a href="#" class="btn_a">취소</a>
                              <select>
                                <option>1번 종료</option>
                                <option>2번 종료</option>
                                <option>3번 종료</option>
                                <option>4번 종료</option>
                                <option>5번 종료</option>
                                <option>6번 종료</option>
                                <option>7번 종료</option>
                                <option>8번 종료</option>
                              </select>
                            </td>
                            <td class="point">-</td>
                          </tr>
                        </tbody>
                        </table>
                        <!-- E: table -->
                      </div>
                      <!-- E: team_list -->
                    </div>
                    <!-- E: no_match -->

                    <!-- S: no_match -->
                    <div class="no_match">
                      <!-- S: team_list -->
                      <div class="team_list">
                        <!-- S: table -->
                        <table class="table up_line">
                          <tbody>
                            <tr class="team team_a win">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                            <td class="seed">
                              <a href="#" class="btn_a">승</a>
                              <a href="#" class="btn_a">취소</a>
                              <select>
                                <option>1번 종료</option>
                                <option>2번 종료</option>
                                <option>3번 종료</option>
                                <option>4번 종료</option>
                                <option>5번 종료</option>
                                <option>6번 종료</option>
                                <option>7번 종료</option>
                                <option>8번 종료</option>
                              </select>
                            </td>
                            <td class="point">-</td>
                          </tr>
                        </tbody>
                        </table>
                        <!-- E: table -->
                      </div>
                      <!-- E: team_list -->
                    </div>
                    <!-- E: no_match -->
                  </div>
                  <!-- E: left_side -->

                  <!-- S: right_side -->
                  <div class="right_side">
                    <!-- S: match -->
                    <div class="match">
                      <!-- S: team_list -->
                      <div class="team_list">
                        <!-- S: table -->
                        <table class="table up_line">
                          <tbody><tr class="team team_a">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                          </tr>
                          <tr class="team team_b">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                          </tr>
                        </tbody></table>
                        <!-- E: table -->
                      </div>
                      <!-- E: team_list -->
                    </div>
                    <!-- E: match -->

                    <!-- S: match -->
                    <div class="match">
                      <!-- S: team_list -->
                      <div class="team_list">
                        <!-- S: table -->
                        <table class="table up_line">
                          <tbody><tr class="team team_a">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                          </tr>
                          <tr class="team team_b">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                          </tr>
                        </tbody></table>
                        <!-- E: table -->
                      </div>
                      <!-- E: team_list -->
                    </div>
                    <!-- E: match -->

                    <!-- S: match -->
                    <div class="match">
                      <!-- S: team_list -->
                      <div class="team_list">
                        <!-- S: table -->
                        <table class="table up_line">
                          <tbody><tr class="team team_a">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                          </tr>
                          <tr class="team team_b">
                            <td class="player">
                              <!-- S: up_floor -->
                              <div class="up_floor">
                                <span class="name">홍윤택</span>
                                <span class="club">(수원,시청)</span>
                              </div>
                              <!-- E: up_floor -->

                              <!-- S: down_floor -->
                              <div class="down_floor">
                                <span class="name">정의종</span>
                                <span class="club">(수원,하나로)</span>
                              </div>
                              <!-- E: down_floor -->
                            </td>
                          </tr>
                        </tbody></table>
                        <!-- E: table -->
                      </div>
                      <!-- E: team_list -->
                    </div>
                    <!-- E: match -->
                  </div>
                  <!-- E: right_side -->
                </div>
                <!-- E: game_tourn -->
              </div>
              <!-- E: 예선 각 강수별 라운드 표시 -->

              <!-- S: medal-tab -->
              <ul class="medal-tab tourney-result" id="DP_MedalList">
                <li>
                  <span class="medal-img">
                    <img src="../../front/dist/imgs/tournerment/golden-medal.png" alt="금" width="39" height="56">
                  </span>
                  <p>
                    <span class="player-name">최훈</span>
                    <span class="player-school">(경민고등학교)</span>
                  </p>
                </li>
                <li>
                  <span class="medal-img">
                    <img src="../../front/dist/imgs/tournerment/silver-medal.png" alt="은" width="39" height="56">
                  </span>
                  <p>
                    <span class="player-name" id="">김영훈</span>
                    <span class="player-school">(서울체육고등학교)</span>
                  </p>
                </li>
                <li>
                  <span class="medal-img">
                    <img src="../../front/dist/imgs/tournerment/bronze-medal.png" alt="동" width="39" height="56">
                  </span>
                  <p>
                    <span class="player-name" id="">최민서</span>
                    <span class="player-school">(원광고등학교)</span>
                  </p>
                </li>
                <li>
                  <span class="medal-img">
                    <img src="../../front/dist/imgs/tournerment/bronze-medal.png" alt="동" width="39" height="56">
                  </span>
                  <p>
                    <span class="player-name" id="">장선우</span>
                    <span class="player-school">(주문진고등학교)</span>
                  </p>
                </li>
              </ul>
              <!-- E: medal-tab -->
              <!-- S: tab-panel -->
              <div class="tourney-img" style="display: block;" id="DP_tourney">
                <!--tab-panel tourney-img-->
                 <div class="btn-guide">
                  <ul>
                    <li>
                      <p id="sexLevelCheck"> ※ 체급을 선택해주세요. </p>
                    </li>
                  </ul>
                </div> 
                <!-- S: tourney-mode -->
                <div class="tourney-mode tourney-result" >
                  <!-- S: tourney-->
                  <div class="tourney h-fix clearfix">

                    <!-- S: sample-tourney -->
                    <div class="sample-tourney">
                      <div class="tourney-mode tourney-result">
                        <!-- S: tourney-->
                        <div class="tourney h-fix clearfix" style="height: 2300px;">
                          <!--style="transform : scale(0.6);"-->
                          <!-- S: left-side -->
                          <div class="left-side clearfix">
                            <!-- S: match-list -->
                            <div id="match_list_left" class="match-list">
                              <div class="match">
                                <div class="player-info"> <span class="player-name">최현성</span> <span class="player-school">우석고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">황준성</span> <span class="player-school">부산체육고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">강상욱</span> <span class="player-school">부산체육고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">이상준</span> <span class="player-school">주문진고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">남궁영</span> <span class="player-school">용문고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">정병훈</span> <span class="player-school">비봉고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">장헌서</span> <span class="player-school">삼천포중앙고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">김형근</span> <span class="player-school">송도고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">류도현</span> <span class="player-school">경민고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">최민서</span> <span class="player-school">원광고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">송요섭</span> <span class="player-school">경신고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">장병준</span> <span class="player-school">덕원고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">전도훈</span> <span class="player-school">송도고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">정호용</span> <span class="player-school">경신고등학교</span> </div>
                              </div>
                              <div class="no-match">
                                <div class="player-info"><span class="player-name">김재민</span><span class="player-school">울산스포츠과학고등학교</span></div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">김근영</span> <span class="player-school">도개고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">한승권</span> <span class="player-school">명석고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">이승우</span> <span class="player-school">주문진고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">김정우</span> <span class="player-school">비봉고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">이창환</span> <span class="player-school">경남체육고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">김민수</span> <span class="player-school">삼천포중앙고등학교</span> </div>
                              </div>
                              <div class="no-match">
                                <div class="player-info"><span class="player-name">최훈</span><span class="player-school">경민고등학교</span></div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">이승재</span> <span class="player-school">비봉고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">김우진</span> <span class="player-school">경민고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">손채형</span> <span class="player-school">덕원고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">박시형</span> <span class="player-school">경민고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">강성민</span> <span class="player-school">충북체육고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">이수현</span> <span class="player-school">금곡고등학교</span> </div>
                              </div>
                              <div class="no-match">
                                <div class="player-info"><span class="player-name">이지민</span><span class="player-school">경신고등학교</span></div>
                              </div>
                            </div>
                            <!-- E: match-list -->
                            <!-- S: Round-1 -->
                            <div id="round_01_left" class="round-1">
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="1" data-whatever="01" role="button" class="btn btn-danger btn-look no-movie-clip">1</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="2" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">2</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="3" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">3</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="4" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">4</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="5" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">5</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="6" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">6</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="7" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">7</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_center.png" alt=""></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="8" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">8</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="9" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">9</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="10" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">10</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_center.png" alt=""></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="11" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">11</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="12" data-whatever="01" role="button" class="btn btn-danger btn-look no-movie-clip">12</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="13" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">13</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_L_center.png" alt=""></div>
                            </div>
                            <!-- E: Round-1 -->
                            <!-- S: Round-2 -->
                            <div id="round_02_left" class="round-2">
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="26" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">26</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="27" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">27</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="28" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">28</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="29" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">29</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="30" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">30</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="31" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">31</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="32" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">32</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="33" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">33</a></div>
                            </div>
                            <!-- E: Round-2 -->
                            <!-- S: Round-3 -->
                            <div id="round_03_left" class="round-3">
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/03_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="42" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">42</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/03_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="43" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">43</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/03_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="44" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">44</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/03_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="45" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">45</a></div>
                            </div>
                            <!-- E: Round-3 -->
                            <!-- S: Round-4 -->
                            <div id="round_04_left" class="round-4">
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/04_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="50" data-whatever="04" role="button" class="btn btn-danger btn-look time-out">50</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/04_L_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="51" data-whatever="04" role="button" class="btn btn-danger btn-look time-out">51</a></div>
                            </div>
                            <!-- E: Round-4 -->
                            <!-- S: Round-5 -->
                            <div id="round_05_left" class="round-5">
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/05_L_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="54" data-whatever="05" role="button" class="btn btn-danger btn-look time-out">54</a></div>
                            </div>
                            <!-- E: Round-5 -->
                            <!-- S: Round-6 -->
                            <div id="round_06_left" class="round-6" style="display: none;"></div>
                            <!-- E: Round-6 -->
                            <!-- S: final-match -->
                            <div class="final-match">
                              <!-- S: final-div -->
                              <div id="final_div" class="final-div">
                                <div class="line-div"><a onClick="editscore(this)" role="button" class="final-match-box winner" data-id="56" data-toggle="modal">
                                  <p><span class="final-player">최훈</span> 승</p>
                                  <!--<p><span>승(절반)</span>(1)<i class='fa fa-plus' aria-hidden='true'></i></p>-->
                                  </a> <img src="../../../front/dist/imgs/tournerment/7_win_L.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="56" data-whatever="06" role="button" class="btn btn-danger btn-look time-out">56</a></div>
                              </div>
                              <!-- E: final-div -->
                            </div>
                            <!-- E: final-match -->
                          </div>
                          <!-- E: left-side -->
                          <!-- S: right-side -->
                          <div class="right-side clearfix">
                            <!-- S: match-list -->
                            <div id="match_list_right" class="match-list">
                              <div class="match">
                                <div class="player-info"> <span class="player-name">홍의민</span> <span class="player-school">비봉고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">김태호</span> <span class="player-school">충남체육고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">김신종</span> <span class="player-school">경민고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">황진승</span> <span class="player-school">충북체육고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">이동현</span> <span class="player-school">보성고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">장선우</span> <span class="player-school">주문진고등학교</span> </div>
                              </div>
                              <div class="no-match">
                                <div class="player-info"><span class="player-name">김민서</span><span class="player-school">송도고등학교</span></div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name"><strike>박주형</strike></span> <span class="player-school"><strike>경민고등학교</strike></span> </div>
                                <div class="player-info"> <span class="player-name"><strike>이석준</strike></span> <span class="player-school"><strike>대성고등학교</strike></span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name"><strike>배민규</strike></span> <span class="player-school"><strike>충남체육고등학교</strike></span> </div>
                                <div class="player-info"> <span class="player-name"><strike>안재민</strike></span> <span class="player-school"><strike>동지고등학교</strike></span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">손근융</span> <span class="player-school">금호공업고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">김성준</span> <span class="player-school">삼천포중앙고등학교</span> </div>
                              </div>
                              <div class="no-match">
                                <div class="player-info"><span class="player-name">황영권</span><span class="player-school">명석고등학교</span></div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">한정윤</span> <span class="player-school">부산체육고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">심현섭</span> <span class="player-school">우석고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">김성훈</span> <span class="player-school">비봉고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">정인석</span> <span class="player-school">부산체육고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">김선종</span> <span class="player-school">삼천포중앙고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">배덕희</span> <span class="player-school">청석고등학교</span> </div>
                              </div>
                              <div class="no-match">
                                <div class="player-info"><span class="player-name">배승권</span><span class="player-school">금호공업고등학교</span></div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">이태준</span> <span class="player-school">경기체육고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">정해민</span> <span class="player-school">충남체육고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">김영훈</span> <span class="player-school">서울체육고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">이종호</span> <span class="player-school">경민고등학교</span> </div>
                              </div>
                              <div class="match">
                                <div class="player-info"> <span class="player-name">김규중</span> <span class="player-school">송도고등학교</span> </div>
                                <div class="player-info"> <span class="player-name">박천영</span> <span class="player-school">용문고등학교</span> </div>
                              </div>
                              <div class="no-match">
                                <div class="player-info"><span class="player-name">조영민</span><span class="player-school">경신고등학교</span></div>
                              </div>
                            </div>
                            <!-- E: match-list -->
                            <!-- S: round-1 -->
                            <div id="round_01_right" class="round-1">
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="14" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">14</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="15" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">15</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="16" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">16</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_center.png" alt=""></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_basic.png" alt=""> <a role="button" class="btn btn-danger btn-look handy" data-id="17" data-whatever="01" onClick="editscore(this);">17</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_basic.png" alt=""> <a role="button" class="btn btn-danger btn-look handy" data-id="18" data-whatever="01" onClick="editscore(this);">18</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="19" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">19</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_center.png" alt=""></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="20" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">20</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="21" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">21</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="22" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">22</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_center.png" alt=""></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="23" data-whatever="01" role="button" class="btn btn-danger btn-look no-movie-clip">23</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="24" data-whatever="01" role="button" class="btn btn-danger btn-look no-movie-clip">24</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="25" data-whatever="01" role="button" class="btn btn-danger btn-look time-out">25</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/01_R_center.png" alt=""></div>
                            </div>
                            <!-- E: round-1 -->
                            <!-- S: Round-2 -->
                            <div id="round_02_right" class="round-2">
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="34" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">34</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="35" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">35</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_R_basic.png" alt=""> <a role="button" class="btn btn-primary btn-look" onClick="mov_enterscore(this);" data-id="36" data-whatever="02">36</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="37" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">37</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="38" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">38</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="39" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">39</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="40" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">40</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/02_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="41" data-whatever="02" role="button" class="btn btn-danger btn-look time-out">41</a></div>
                            </div>
                            <!-- E: Round-2 -->
                            <!-- S: Round-3 -->
                            <div id="round_03_right" class="round-3">
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/03_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="46" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">46</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/03_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="47" data-whatever="03" role="button" class="btn btn-danger btn-look no-movie-clip">47</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/03_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="48" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">48</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/03_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="49" data-whatever="03" role="button" class="btn btn-danger btn-look time-out">49</a></div>
                            </div>
                            <!-- E: Round-3 -->
                            <!-- S: Round-4 -->
                            <div id="round_04_right" class="round-4">
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/04_R_top.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="52" data-whatever="04" role="button" class="btn btn-danger btn-look time-out">52</a></div>
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/04_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="53" data-whatever="04" role="button" class="btn btn-danger btn-look time-out">53</a></div>
                            </div>
                            <!-- E: Round-4 -->
                            <!-- S: Round-5 -->
                            <div id="round_05_right" class="round-5">
                              <div class="line-div"> <img src="../../../front/dist/imgs/tournerment/05_R_bottom.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="55" data-whatever="05" role="button" class="btn btn-danger btn-look time-out">55</a></div>
                            </div>
                            <!-- E: Round-5 -->
                            <!-- S: Round-6 -->
                            <div id="round_06_right" class="round-6" style="display: none;"></div>
                            <!-- E: Round-6 -->
                          </div>
                          <!-- E: right-side -->
                        </div>
                        <!-- E: tourney-->
                      </div>
                    </div>
                    <!-- E: sample-tourney -->
                  </div>
                  <!-- E: tourney-->
                </div>
                <!-- E: tourney-mode -->
              </div>
              <!-- E: tab-panel -->
              <!-- S: tourney-list -->
              <div class="tourney-list" id="DP_ResultReport" style="display: none;"></div>
              <!--tourney-list-->
              <!-- E: tourney-list -->
              <!-- S: container -->
              <div class="container">
                <!-- S: list_league -->
                <div id="list_league" class="list_league"></div>
                <!-- E: list_league -->
                <div class="natfinal_tourney" id="DP_natfinal_tourney" style="display: none;">
                  <!-- S: guide-txt -->
                  <div class="guide-txt show-film-guide"> ※ 경기 영상은 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다. </div>
                  <!-- E: guide-txt -->
                  <div class="btn-guide">
                    <ul>
                      <li>
                        <p id="btnlookCheck_natfinal"> <span><a class="btn btn-look no-movie-clip"></a></span> <span>영상미등록</span> <span><a class="btn btn-look time-out"></a></span> <span>영상등록완료</span> </p>
                        <p id="sexLevelCheck_natfinal"> ※ 체급을 선택해주세요. </p>
                      </li>
                    </ul>
                  </div>
                  <!-- S: 최종평가전(승자)-->
                  <div class="tourney 01 t-1 h-fix">
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
                  <div class="tourney 02 t-2 h-fix" id="DP_natfinal_02">
                    <h2 class="tourney_tit"><span class="txt">패자부활전</span></h2>
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
                  <div class="tourney 03 t-3 h-fix" id="DP_natfinal_03">
                    <h2 class="tourney_tit"><span class="txt">패자부활전 결승</span></h2>
                    <!-- S: left-side -->
                    <div class="left-side clearfix">
                      <!-- S: match-list -->
                      <div id="match_list_left_natfinal_03" class="match-list">
                        <div class="no-match">
                          <div class="player-info"> <span class="player-name" id="LPlayerName_natfinal_03">
                            <!--허송림-->
                            </span> <span class="player-school" id="LSchoolName_natfinal_03">
                            <!--서울체육고등학교-->
                            </span> </div>
                        </div>
                      </div>
                      <!-- E: match-list -->
                      <!-- S: final-match -->
                      <div class="final-match">
                        <!-- S: final-div -->
                        <div id="final_div_natfinal_03" class="final-div">
                          <div class="line-div" id="LineButton_natfinal_03"> <img src="../../front/dist/imgs/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onClick="mov_enterscore(this);" data-id="13" data-whatever="01">13</a> </div>
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
                        <div class="no-match">
                          <div class="player-info"> <span class="player-name" id="RPlayerName_natfinal_03">
                            <!--박예진-->
                            </span> <span class="player-school" id="RSchoolName_natfinal_03">
                            <!--서울체육고등학교-->
                            </span> </div>
                        </div>
                      </div>
                      <!-- E: match-list -->
                    </div>
                    <!-- E: right-side -->
                  </div>
                  <!-- E: 최종평가전(패자부활전 부전)-->
                  <!-- E: 최종평가전(결승)-->
                  <div class="tourney 03 t-4 h-fix" id="DP_natfinal_04">
                    <h2 class="tourney_tit"><span class="txt">1,2위 결승</span></h2>
                    <!-- S: left-side -->
                    <div class="left-side clearfix">
                      <!-- S: match-list -->
                      <div id="match_list_left_natfinal_04" class="match-list">
                        <div class="no-match">
                          <div class="player-info"> <span class="player-name" id="LPlayerName_natfinal_04">
                            <!--허송림-->
                            </span> <span class="player-school" id="LSchoolName_natfinal_04">
                            <!--서울체육고등학교-->
                            </span> </div>
                        </div>
                      </div>
                      <!-- E: match-list -->
                      <!-- S: final-match -->
                      <div class="final-match">
                        <!-- S: final-div -->
                        <div id="final_div_natfinal_04" class="final-div">
                          <div class="line-div" id="LineButton_natfinal_04"> <img src="../../front/dist/imgs/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onClick="mov_enterscore(this);" data-id="14" data-whatever="01">14</a> </div>
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
                        <div class="no-match">
                          <div class="player-info"> <span class="player-name" id="RPlayerName_natfinal_04">
                            <!--박예진-->
                            </span> <span class="player-school" id="RSchoolName_natfinal_04">
                            <!--서울체육고등학교-->
                            </span> </div>
                        </div>
                      </div>
                      <!-- E: match-list -->
                    </div>
                    <!-- E: right-side -->
                  </div>
                  <!-- E: 최종평가전(결승)-->
                  <!-- E: 최종평가전(결승재경기)-->
                  <div class="tourney 03 t-5 h-fix" id="DP_natfinal_05">
                    <h2 class="tourney_tit"><span class="txt">1,2위 결승 재경기</span></h2>
                    <!-- S: left-side -->
                    <div class="left-side clearfix">
                      <!-- S: match-list -->
                      <div id="match_list_left_natfinal_05" class="match-list">
                        <div class="no-match">
                          <div class="player-info"> <span class="player-name" id="LPlayerName_natfinal_05">
                            <!--허송림-->
                            </span> <span class="player-school" id="LSchoolName_natfinal_05">
                            <!--서울체육고등학교-->
                            </span> </div>
                        </div>
                      </div>
                      <!-- E: match-list -->
                      <!-- S: final-match -->
                      <div class="final-match">
                        <!-- S: final-div -->
                        <div id="final_div_natfinal_05" class="final-div">
                          <div class="line-div" id="LineButton_natfinal_05"> <img src="../../front/dist/imgs/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onClick="mov_enterscore(this);" data-id="15" data-whatever="01">15</a> </div>
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
                        <div class="no-match">
                          <div class="player-info"> <span class="player-name" id="RPlayerName_natfinal_05">
                            <!--박예진-->
                            </span> <span class="player-school" id="RSchoolName_natfinal_05">
                            <!--서울체육고등학교-->
                            </span> </div>
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
              <!-- E: container -->
            </div>
            <!-- E: sub sub-main board -->
          </form>
        </div>
        <!-- E: modal-body -->
      </div>
      <!-- E: modal-content -->
    </div>
    <!-- E: modal-dialog -->
  </div>
  <!-- E: modal_tourney -->