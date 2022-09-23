<!-- #include file="../include/config.asp" -->
<!-- #include file="../include/tn_config.asp" -->
<!-- fusionchart api -->
<script src="../js/library/fusioncharts.js"></script>
<script src="../js/library/fusioncharts.theme.fint.js"></script>
<script src="../js/library/fusioncharts.charts.js"></script>
<script type="text/javascript">
  FusionCharts.ready(function() {
    FusionCharts.register('theme', {
       name: 'fire',
        theme: {
          base: {
            chart: {
              paletteColors: '#FF4444, #FFBB33, #99CC00, #33B5E5, #AA66CC',
              baseFontColor: '#36474D',
              baseFont: 'Helvetica Neue,Arial',
              captionFontSize: '14',
              subcaptionFontSize: '14',
              subcaptionFontBold: '0',
              showBorder: '0',
              bgColor: '#ffffff',
              showShadow: '0',
              canvasBgColor: '#ffffff',
              canvasBorderAlpha: '0',
              useplotgradientcolor: '0',
              useRoundEdges: '0',
              showPlotBorder: '0',
              showAlternateHGridColor: '0',
              showAlternateVGridColor: '0',
              toolTipBorderThickness: '0',
              toolTipBgColor: '#99CC00',
              toolTipBgAlpha: '90',
              toolTipBorderRadius: '2',
              toolTipPadding: '5',
              legendBgAlpha: '0',
              legendBorderAlpha: '0',
              legendShadow: '0',
              legendItemFontSize: '14',
              divlineAlpha: '100',
              divlineColor: '#36474D',
              divlineThickness: '1',
              divLineIsDashed: '1',
              divLineDashLen: '1',
              divLineGapLen: '1',
              showHoverEffect: '1',
              valueFontSize: '14',
              showXAxisLine: '1',
              xAxisLineThickness: '1',
              xAxisLineColor: '#36474D'
            }
          },
          mscolumn2d: {
            chart: {
              valueFontColor: '#FFFFFF', //overwrite base value
              valueBgColor: '#000000',
              valueBgAlpha: '30',
              placeValuesInside: '1',
              rotateValues: '0'
            }
          }
        }
    });

  var revenueChart = new FusionCharts({
    type: 'mscolumn2d',
    renderAt: 'scoreTotal',
    width: '100%',
    height: '240',
    dataFormat: 'json',
    dataSource: {
      "data": [{
        "label": "Venezuela",
        "value": "290"
      }, {
        "label": "Saudi",
        "value": "260"
      }, {
        "label": "Canada",
        "value": "180"
      }, {
        "label": "Iran",
        "value": "140"
      }, {
        "label": "Russia",
        "value": "115"
      }, {
        "label": "UAE",
        "value": "100"
      }, {
        "label": "US",
        "value": "30"
      }, {
        "label": "China",
        "value": "30"
      }]
    }
  }).render();
});
</script>

<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>회원정보</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: main -->
  <div class="main user_info">
    <!-- S: banner -->
    <div class="banner banner_md pack">
      <img src="http://img.sportsdiary.co.kr/sdapp/public/banner_md@3x.png" alt>
    </div>
    <!-- E: banner -->

    <!-- S: prof -->
    <div class="prof flex">
      <div class="profile-img">
        <img src="http://img.sportsdiary.co.kr/sdapp/gnb/profile@3x.png" alt>
      </div>

      <!-- S: prof-list -->
      <div class="prof-list">
        <h3>김우람<span class="en-name">Kim Woo Ram</span></h3>

        <dl class="prof-belong clearfix">
          <dt>소속</dt>
          <dd>
            <ul>
              <li>위드라인고등학교</li>
            </ul>
          </dd>
        </dl>

        <dl class="clearfix">
          <dt>생년월일</dt>
          <dd>99.01.01</dd>
        </dl>

        <dl class="clearfix">
          <dt>키</dt>
          <dd>173cm</dd>
        </dl>

        <dl class="clearfix">
          <dt>사용손</dt>
          <dd>왼손</dd>
        </dl>

        <dl class="clearfix">
          <dt>복식 리턴 포지션</dt>
          <dd>백 사이드</dd>
        </dl>

        <dl class="clearfix">
          <dt>백핸드 타입</dt>
          <dd>양손 투핸드</dd>
        </dl>

        <dl class="multi_dd clearfix">
          <dt>다득점 기술</dt>
          <dd>서비스</dd>
          <dd>퍼스트 서브</dd>
          <dd>F.스트로크</dd>
        </dl>

      </div>
      <!-- E: prof-list -->
    </div>
    <!-- E: prof -->


    <!-- S: record -->
    <div class="record">
      <h3>전적 <span class="orangy">* 통산전적은 2017년부터 기록됩니다.</span></h3>
      <dl class="pack clearfix">
        <dt>통산전적(승률)</dt>
        <dd>0전 0승 0패(0%)</dd>
      </dl>
      <dl class="pack clearfix">
        <dt>올 시즌 전적(승률)</dt>
        <dd>14전 10승 4패(89%)</dd>
      </dl>
    </div>
    <!-- E: record -->

    <!-- S: record recent_result -->
    <div class="record recent_result">
      <h3>최근 입상이력 <span class="orangy">* 최근 입상 순으로 반영됩니다.(단체전 포함)</span></h3>
      <p class="no_data">조회된 데이터가 없습니다.</p>
      <dl class="pack clearfix">
        <dt>2017년</dt>
        <dd>[GA그룹]2017 테니스사랑배 전국 동호인테니스대회</dd>
        <dd class="win">[오픈부]우승</dd>
        <dd>[GA그룹]2017 테니스사랑배 전국 동호인테니스대회</dd>
        <dd class="win">[오픈부]우승</dd>
        <dd>[GA그룹]2017 테니스사랑배 전국 동호인테니스대회</dd>
        <dd class="win">[오픈부]우승</dd>
      </dl>
    </div>
    <!-- E: record recent_result -->

    <!-- S: 최근 경기기록/영상 -->
    <div class="record recent_film_record">
      <h3>최근 경기기록/영상</h3>
      <div class="stat-film-title">
        <h3>[GA그룹] 2017 테니스사랑배 전국 동호인 테니스대회 <span>대회기간: 2017-08-17 ~ 2017-08-20</span></h3>
        <p class="list-info pack">
          <span>개인전</span>
          <span>오픈부</span>
          <span>우승</span>
        </p>
      </div>

      <!-- S: stat-list -->
      <div class="stat-list">

        <!-- S: one_line -->
        <dl>
          <!-- S: title -->
          <dt class="clearfix">
            <span>결승</span>
            <a href="#" class="show-film">
              <img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt="대회영상보기">
            </a>
          </dt>
          <!-- E: title -->

          <!-- S: content -->
          <dd>
            <ul>
              <li class="clearfix">
                <p class="me">
                  <span class="player_1">이희선</span> <span class="belong">한포인트,강촌</span> <br>
                  <span class="player_2">장선우</span> <span class="belong">경주계림, 울산</span>
                </p>
                <p class="vs">VS</p>
                <p class="you">
                  <span class="player_1">장선우</span> <span class="belong">건우회</span> <br>
                  <span class="player_2">정민우</span> <span class="belong">대구탑,달구벌</span>
                </p>
              </li>
            </ul>
          </dd>
          <!-- E: content -->
        </dl>
        <!-- E: one_line -->

        <!-- S: one_line -->
        <dl>
          <!-- S: title -->
          <dt class="clearfix">
            <span>준결승</span>
            <a href="#" class="show-film">
              <img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt="대회영상보기">
            </a>
          </dt>
          <!-- E: title -->

          <!-- S: content -->
          <dd>
            <ul>
              <li class="clearfix">
                <p class="me">
                  <span class="player_1">이희선</span> <span class="belong">한포인트,강촌</span> <br>
                  <span class="player_2">장선우</span> <span class="belong">경주계림, 울산</span>
                </p>
                <p class="vs">VS</p>
                <p class="you">
                  <span class="player_1">장선우</span> <span class="belong">건우회</span> <br>
                  <span class="player_2">정민우</span> <span class="belong">대구탑,달구벌</span>
                </p>
              </li>
            </ul>
          </dd>
          <!-- E: content -->
        </dl>
        <!-- E: one_line -->

        <!-- S: one_line -->
        <dl>
          <!-- S: title -->
          <dt class="clearfix">
            <span>8강</span>
            <a href="#" class="show-film">
              <img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt="대회영상보기">
            </a>
          </dt>
          <!-- E: title -->

          <!-- S: content -->
          <dd>
            <ul>
              <li class="clearfix">
                <p class="me">
                  <span class="player_1">이희선</span> <span class="belong">한포인트,강촌</span> <br>
                  <span class="player_2">장선우</span> <span class="belong">경주계림, 울산</span>
                </p>
                <p class="vs">VS</p>
                <p class="you">
                  <span class="player_1">장선우</span> <span class="belong">건우회</span> <br>
                  <span class="player_2">정민우</span> <span class="belong">대구탑,달구벌</span>
                </p>
              </li>
            </ul>
          </dd>
          <!-- E: content -->
        </dl>
        <!-- E: one_line -->

      </div>
      <!-- E: stat-list -->
    </div>
    <!-- E: 최근 경기기록/영상 -->


    <!-- S: 대회기록 -->
    <section class="record best-win">
      <h3>대회기록</h3>
      <h4>기술별 득실점</h4>
      <!-- S: between-chart -->
      <div class="between-chart container" id="iSkillResult">
        <div id="ihtmldivSkill">

          <ul class="chart-title flex">
            <li>득점</li>
            <li><기술별></li>
            <li>실점</li>
          </ul>

          <!-- S: 퍼스트 서브 -->
          <ul class="skill-list flex">
            <li>
              <span>4/80(5%)</span>
              <span class="fill b" style="width: 5%;"></span>
              <span class="mask"></span>
            </li>
            <li>퍼스트 서브</li>
            <li>
              <span>0/2(0%)</span>
              <span class="fill y" style="width: 0%"></span>
              <span class="mask"></span>
            </li>
          </ul>
          <!-- E: 퍼스트 서브 -->

          <!-- S: 세컨 서브 -->
          <ul class="skill-list flex">
            <li>
              <span>1/80(1%)</span>
              <span class="fill b" style="width: 1%;"></span>
              <span class="mask"></span>
            </li>
            <li>세컨 서브</li>
            <li>
              <span>1/2(50%)</span>
              <span class="fill y" style="width: 50%"></span>
              <span class="mask"></span>
            </li>
          </ul>
          <!-- E: 세컨 서브 -->

          <!-- S: F.스트로크 -->
          <ul class="skill-list flex">
            <li>
              <span>5/18(28%)</span>
              <span class="fill b" style="width: 28%;"></span>
              <span class="mask"></span>
            </li>
            <li>F.스트로크</li>
            <li>
              <span>0/8(0%)</span>
              <span class="fill y" style="width: 0%"></span>
              <span class="mask"></span>
            </li>
          </ul>
          <!-- E: F.스트로크 -->

          <!-- S: B.스트로크 -->
          <ul class="skill-list flex">
            <li>
              <span>1/80(1%)</span>
              <span class="fill b" style="width: 1%;"></span>
              <span class="mask"></span>
            </li>
            <li>B.스트로크</li>
            <li>
              <span>0/2(0%)</span>
              <span class="fill y" style="width: 0%"></span>
              <span class="mask"></span>
            </li>
          </ul>
          <!-- E: B.스트로크 -->

          <!-- S: F.발리 -->
          <ul class="skill-list flex">
            <li>
              <span>1/80(1%)</span>
              <span class="fill b" style="width: 1%;"></span>
              <span class="mask"></span>
            </li>
            <li>F.발리</li>
            <li>
              <span>0/2(0%)</span>
              <span class="fill y" style="width: 0%"></span>
              <span class="mask"></span>
            </li>
          </ul>
          <!-- E: F.발리 -->

          <!-- S: B.발리 -->
          <ul class="skill-list flex">
            <li>
              <span>1/80(1%)</span>
              <span class="fill b" style="width: 1%;"></span>
              <span class="mask"></span>
            </li>
            <li>B.발리</li>
            <li>
              <span>0/2(0%)</span>
              <span class="fill y" style="width: 0%"></span>
              <span class="mask"></span>
            </li>
          </ul>
          <!-- E: B.발리 -->

          <!-- S: F.리턴 -->
          <ul class="skill-list flex">
            <li>
              <span>1/80(1%)</span>
              <span class="fill b" style="width: 1%;"></span>
              <span class="mask"></span>
            </li>
            <li>F.리턴</li>
            <li>
              <span>0/2(0%)</span>
              <span class="fill y" style="width: 0%"></span>
              <span class="mask"></span>
            </li>
          </ul>
          <!-- E: F.리턴 -->

          <!-- S: B.리턴 -->
          <ul class="skill-list flex">
            <li>
              <span>1/80(1%)</span>
              <span class="fill b" style="width: 1%;"></span>
              <span class="mask"></span>
            </li>
            <li>B.리턴</li>
            <li>
              <span>0/2(0%)</span>
              <span class="fill y" style="width: 0%"></span>
              <span class="mask"></span>
            </li>
          </ul>
          <!-- E: B.리턴 -->

          <!-- S: 스매싱 -->
          <ul class="skill-list flex">
            <li>
              <span>1/80(1%)</span>
              <span class="fill b" style="width: 1%;"></span>
              <span class="mask"></span>
            </li>
            <li>스매싱</li>
            <li>
              <span>1/2(50%)</span>
              <span class="fill y" style="width: 50%"></span>
              <span class="mask"></span>
            </li>
          </ul>
          <!-- E: 스매싱 -->

          <!-- S: 기타 -->
          <ul class="skill-list flex">
            <li>
              <span>2/80(3%)</span>
              <span class="fill b" style="width: 1%;"></span>
              <span class="mask"></span>
            </li>
            <li>기타</li>
            <li>
              <span>0/2(0%)</span>
              <span class="fill y" style="width: 0%"></span>
              <span class="mask"></span>
            </li>
          </ul>
          <!-- E: 기타 -->
        </div>
      </div>
      <!-- E: between-chart -->

      <!-- S: score_total_chart -->
      <div class="score_total_chart pack">
        <h4>스코어별 전체 득실점</h4>
        <!-- S: 스코어별 차트 -->
        <div id="scoreTotal"></div>
        <!-- E: 스코어별 차트 -->

        <!-- S: set_list -->
        <ul class="set_list">
          <li>
            <a href="#" class="btn btn-dark-blue">1set</a>
          </li>
          <li>
            <a href="#" class="btn btn-dark-blue">2set</a>
          </li>
          <li>
            <a href="#" class="btn btn-dark-blue">3set</a>
          </li>
        </ul>
        <!-- E: set_list -->

        <p class="guide_txt orangy">* 복식의 경우 파트너를 포함한 팀의 득실점 데이터로 합산되어 나타납니다.</p>
      </div>
      <!-- E: score_total_chart -->

    </section>
    <!-- E: 대회기록 -->

    <!-- S: btn_list -->
    <div class="btn_list pt_req pack">
      <a href="#" class="btn btn-full btn-orange"><span class="ic_deco"><i class="fa fa-volume-up"></i></span>파트너 신청을 요청합니다!</a>
    </div>
    <!-- E: btn_list -->

  </div>
  <!-- E: main -->

  <!-- S: bot_config -->
  <!-- #include file = "../include/bot_config.asp" -->
  <!-- E: bot_config -->
</body>
