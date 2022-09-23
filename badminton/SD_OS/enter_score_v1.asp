<!DOCTYPE html>
<html lang="ko">
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta charset="UTF-8">
  <title>경기입력</title>
  <link rel="stylesheet" href="./css/bootstrap.css">
  <link rel="stylesheet" href="./css/bootstrap-theme.css">
  <link rel="stylesheet" href="./css/library/font-awesome.min.css">
  <link rel="stylesheet" href="./css/style.css">
  <link rel="stylesheet" href="./css/os.minton.css">
  <script src="./js/library/jquery-1.12.2.min.js"></script>
  <script src="./js/bootstrap.js"></script>
  <script src="./js/fastclick.js"></script>
  <script src="./js/app.js"></script>
  <script src="./js/global.js"></script>
  <script src="./js/init-app.js"></script>
</head>
<body>
  <!-- S: header -->
  <div class="header">
    <!-- S: back_btn -->
    <div class="back_btn">
      <a href="#" class="btn btn_back img_box">
        <img src="./images/tournerment/header/btn_back.png" alt="이전">
      </a>
    </div>
    <!-- E: back_btn -->

    <!-- S: match_tit -->
    <div class="match_tit">
      <!-- S: court -->
      <div class="court">
        11번 코트
      </div>
      <!-- E: court -->
      <!-- S: game_idx -->
      <div class="game_idx">
        <span>16강</span>
        <span>/</span>
        <span>1경기</span>
      </div>
      <!-- E: game_idx -->
    </div>
    <!-- E: match_tit -->
  </div>
  <!-- E: header -->

  <!-- S: main -->
  <div class="main enter_score">
    <!-- S: 선수 및 서브 선택 sel_player sel_serve -->
    <div class="sel_player sel_serve clearfix">
      <!-- S: team team_a -->
      <ul class="team team_a">
        <li>
          <a href="#" class="btn btn_white on">
            <span class="name">최보라</span>
            <span class="club">(안동, 부산)</span>
          </a>
          <a href="#" class="btn btn_serve on">
            <span class="img_box">
              <img src="../SD_OS/images/tournerment/score/ball_on@3x.png" alt>
            </span>
          </a>
        </li>
        <li>
          <a href="#" class="btn btn_white">
            <span class="name">김오래오래</span>
            <span class="club">(안동, 부산)</span>
          </a>
          <a href="#" class="btn btn_serve">
            <span class="img_box">
              <img src="../SD_OS/images/tournerment/score/ball_off@3x.png" alt>
            </span>
          </a>
        </li>
      </ul>
      <!-- E: team team_a -->

      <!-- S: team team_b -->
      <ul class="team team_b">
        <li>
          <a href="#" class="btn btn_serve">
            <span class="img_box">
              <img src="../SD_OS/images/tournerment/score/ball_off@3x.png" alt>
            </span>
          </a>
          <a href="#" class="btn btn_white">
            <span class="club">(안동, 부산, 아이슬란드)</span>
            <span class="name">이노무스키</span>
          </a>
        </li>
        <li>
          <a href="#" class="btn btn_serve">
            <span class="img_box">
              <img src="../SD_OS/images/tournerment/score/ball_off@3x.png" alt>
            </span>
          </a>
          <a href="#" class="btn btn_white">
            <span class="club">(안동)</span>
            <span class="name">김미연</span>
          </a>
        </li>
      </ul>
      <!-- E: team team_b -->
    </div>
    <!-- E: 선수 및 서브 선택 sel_player sel_serve -->

    <!-- S: 그외 판정결과 선택 sel_another_result -->
    <div class="sel_another_result">
      <ul class="clearfix">
        <li class="sel_box">
          <select>
            <option>그 외 판정결과 선택</option>
            <option>부전승</option>
            <option>기권승</option>
            <option>불참패</option>
          </select>
        </li>
        <li class="sel_box">
          <select>
            <option>그 외 판정결과 선택</option>
            <option>부전승</option>
            <option>기권승</option>
            <option>불참패</option>
          </select>
        </li>
      </ul>
    </div>
    <!-- E: 그외 판정결과 선택 sel_another_result -->

    <!-- S: 스코어보드 scoreboard -->
    <div class="scoreboard">
      <!-- S: table -->
      <table class="table">
        <thead>
          <tr>
            <td></td>
            <th class="set1">1</th>
            <th class="set2 now">2</th>
            <th class="set3">3</th>
            <th class="set4">4</th>
            <th class="set5">5</th>
          </tr>
        </thead>
        <tbody>
          <!-- S: 팀A -->
          <tr class="team team_a">
            <th>
              <div class="player">
                <span class="player_1">최보라</span>
                <span class="player_2">김미연</span>
              </div>
            </th>
            <td class="win">
              <a href="#" class="btn set1">20</a>
            </td>
            <td class="now">
              <a href="#" class="btn set2">-</a>
            </td>
            <td>
              <a href="#" class="btn set3">-</a>
            </td>
            <td>
              <a href="#" class="btn set4">-</a>
            </td>
            <td>
              <a href="#" class="btn set5">-</a>
            </td>
          </tr>
          <!-- E: 팀A -->

          <!-- S: 팀B -->
          <tr class="team team_b">
            <th>
              <div class="player">
                <span class="player_1">박선영</span>
                <span class="player_2">김가희</span>
              </div>
            </th>
            <td>
              <a href="#" class="btn set1">20</a>
            </td>
            <td class="now">
              <a href="#" class="btn set2">-</a>
            </td>
            <td>
              <a href="#" class="btn set3">-</a>
            </td>
            <td>
              <a href="#" class="btn set4">-</a>
            </td>
            <td>
              <a href="#" class="btn set5">-</a>
            </td>
          </tr>
          <!-- E: 팀B -->
        </tbody>
      </table>
      <!-- E: table -->
    </div>
    <!-- E: 스코어보드 scoreboard -->

    <!-- S: 점수 버튼 point_btn -->
    <div class="point_btn">
      <ul class="clearfix">
        <li>
          <a href="#" class="up">
            <span class="img_box">
              <img src="../SD_OS/images/tournerment/score/up_btn@3x.png" alt>
            </span>
          </a>
          <div class="show_point">1</div>
          <a href="#" class="down">
            <span class="img_box">
              <img src="../SD_OS/images/tournerment/score/down_btn@3x.png" alt>
            </span>
          </a>
        </li>
        <li class="dot">
          <span class="img_box">
            <img src="../SD_OS/images/tournerment/score/dot@3x.png" alt>
          </span>
        </li>
        <li>
          <a href="#" class="up">
            <span class="img_box">
              <img src="../SD_OS/images/tournerment/score/up_btn@3x.png" alt>
            </span>
          </a>
          <div class="show_point">1</div>
          <a href="#" class="down">
            <span class="img_box">
              <img src="../SD_OS/images/tournerment/score/down_btn@3x.png" alt>
            </span>
          </a>
        </li>
      </ul>

      <!-- S: 버튼 -->
      <div class="btn_list">
        <a href="#" class="btn btn_end">경기종료</a>
      </div>
      <!-- E: 버튼 -->
    </div>
    <!-- E: 점수 버튼 point_btn -->
  </div>
  <!-- E: main -->
  <script src="./js/main.js"></script>
</body>
</html>