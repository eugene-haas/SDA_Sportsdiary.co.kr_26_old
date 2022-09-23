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
    <!-- S: 스코어보드 scoreboard -->
    <div class="scoreboard">
      <!-- S: table -->
      <table class="table">
        <thead>
          <tr>
            <td class="another_result" colspan="2">
              <a href="#" class="btn btn_gray" data-toggle="modal" data-target=".another_result">그 외 판정결과 선택</a>
            </td>
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
              <a href="#" class="btn btn_player on">
                <div class="name">최보라</div>
                <div class="club">(안동,부산)</div>
              </a>
            </th>
            <th class="chk_serve">
              <a href="#" class="btn btn_serve on">
                <span class="img_box">
                  <img src="./images/tournerment/score/ball_on@3x.png" alt>
                </span>
              </a>
            </th>
            <td class="win" rowspan="2">
              <a href="#" class="btn set1">20</a>
            </td>
            <td class="now" rowspan="2">
              <a href="#" class="btn set2">-</a>
            </td>
            <td rowspan="2">
              <a href="#" class="btn set3">-</a>
            </td>
            <td rowspan="2">
              <a href="#" class="btn set4">-</a>
            </td>
            <td rowspan="2">
              <a href="#" class="btn set5">-</a>
            </td>
          </tr>
          <tr class="team team_a">
            <th>
              <a href="#" class="btn btn_player">
                <div class="name">김미연</div>
                <div class="club">(안동,부산)</div>
              </a>
            </th>
            <th class="chk_serve">
              <a href="#" class="btn btn_serve">
                <span class="img_box">
                  <img src="./images/tournerment/score/ball_off@3x.png" alt>
                </span>
              </a>
            </th>
          </tr>
          <!-- E: 팀A -->

          <!-- S: 팀B -->
          <tr class="team team_b">
            <th>
              <a href="#" class="btn btn_player on">
                <div class="name">박선영</div>
                <div class="club">(구리)</div>
              </a>
            </th>
            <th class="chk_serve">
              <a href="#" class="btn btn_serve">
                <span class="img_box">
                  <img src="./images/tournerment/score/ball_off@3x.png" alt>
                </span>
              </a>
            </th>
            <td class="win" rowspan="2">
              <a href="#" class="btn set1">20</a>
            </td>
            <td class="now" rowspan="2">
              <a href="#" class="btn set2">-</a>
            </td>
            <td rowspan="2">
              <a href="#" class="btn set3">-</a>
            </td>
            <td rowspan="2">
              <a href="#" class="btn set4">-</a>
            </td>
            <td rowspan="2">
              <a href="#" class="btn set5">-</a>
            </td>
          </tr>
          <tr class="team team_b">
            <th>
              <a href="#" class="btn btn_player on">
                <div class="name">김가희</div>
                <div class="club">(구리,새빛천)</div>
              </a>
            </th>
            <th class="chk_serve">
              <a href="#" class="btn btn_serve">
                <span class="img_box">
                  <img src="./images/tournerment/score/ball_off@3x.png" alt>
                </span>
              </a>
            </th>
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
      <div class="btn_list clearfix">
        <!-- S: cock_count -->
        <div class="cock_count btn">
          <!-- S: img_box -->
          <div class="img_box">
            <img src="./images/tournerment/score/cock@3x.png" alt>
          </div>
          <!-- E: img_box -->
          <!-- S: count -->
          <div class="count">
            11
          </div>
          <!-- E: count -->
          <ul class="up_down">
            <li>
              <a href="#" class="btn btn_up">
                <i class="fa fa-caret-up" aria-hidden="true"></i>
              </a>
            </li>
            <li>
              <a href="#" class="btn btn_down">
                <i class="fa fa-caret-down" aria-hidden="true"></i>
              </a>
            </li>
          </ul>
        </div>
        <!-- E: cock_count -->
        <a href="#" class="btn btn_end">경기종료</a>
      </div>
      <!-- E: 버튼 -->
    </div>
    <!-- E: 점수 버튼 point_btn -->
  </div>
  <!-- E: main -->

  <!-- S: modal another_result -->
  <!-- #include file="./include/modal_another_result.asp" -->
  <!-- E: modal another_result -->

  <script src="./js/main.js"></script>
</body>
</html>