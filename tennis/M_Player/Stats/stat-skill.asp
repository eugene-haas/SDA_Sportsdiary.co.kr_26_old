<!-- #include file="../include/config.asp" -->
<!-- google chart -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- fusionchart api -->
<script src="../js/library/fusioncharts.js"></script>
<script src="../js/library/fusioncharts.theme.fint.js"></script>
<script src="../js/library/fusioncharts.charts.js"></script>
<script>
/* 전체 득실점 */
FusionCharts.ready(function () {
    var revenueChart = new FusionCharts({
        type: 'msbar3d',
        renderAt: 'skill-total-chart',
        width: '100%',
        height: '600',
        dataFormat: 'json',
        dataSource: {
            "chart": {
                // "caption": "Split of Sales by Product Category",
                // "subCaption": "In top 5 stores last month",
                "yAxisname": "Sales (In USD)",
                // "numberPrefix": "$",
                "paletteColors": "#0075c2,#1aaf5d",
                "bgColor": "#ffffff",
                "legendBorderAlpha": "0",
                "legendBgAlpha": "0",
                "legendShadow": "0",
                "placevaluesInside": "1",
                "valueFontColor": "#ffffff",
                "alignCaptionWithCanvas": "1",
                "showHoverEffect":"1",
                "canvasBgColor": "#ffffff",
                "captionFontSize": "14",
                "subcaptionFontSize": "14",
                "subcaptionFontBold": "0",
                "divlineColor": "#999999",
                "divLineIsDashed": "1",
                "divLineDashLen": "1",
                "divLineGapLen": "1",
                "showAlternateHGridColor": "0",
                "toolTipColor": "#ffffff",
                "toolTipBorderThickness": "0",
                "toolTipBgColor": "#000000",
                "toolTipBgAlpha": "80",
                "toolTipBorderRadius": "2",
                "toolTipPadding": "5"
            },
            "categories": [
                {
                    "category": [
                        {
                            "label": "업어치기"
                        },
                        {
                            "label": "한팔 업어치기"
                        },
                        {
                            "label": "양소매 업어치기"
                        },
                        {
                            "label": "한소매 업어치기"
                        },
                        {
                            "label": "외깃 업어치기"
                        },
                        {
                            "label": "빗당겨치기"
                        },
                        {
                            "label": "한팔 빗당겨치기"
                        },
                        {
                            "label": "어깨로 메치기"
                        },
                        {
                            "label": "허리띄기"
                        },
                        {
                            "label": "허리후리기"
                        },
                        {
                            "label": "허리채기"
                        },
                        {
                            "label": "뒤허리안아 메치기"
                        },
                        {
                            "label": "밭다리"
                        },
                        {
                            "label": "안다리"
                        },
                        {
                            "label": "발뒤축 걸기"
                        },
                        {
                            "label": "안뒤축걸기"
                        },
                        {
                            "label": "안뒤축 후리기"
                        },
                        {
                            "label": "발목받치기"
                        },
                        {
                            "label": "배대뒤치기"
                        },
                        {
                            "label": "안오금띄기"
                        },
                        {
                            "label": "기타 누으며메치기"
                        },
                        {
                            "label": "누르기"
                        },
                        {
                            "label": "꺽기"
                        },
                        {
                            "label": "손기술 되치기"
                        }
                    ]
                }
            ],
            "dataset": [
                {
                    // "seriesname": "Food Products",
                    "data": [
                        {
                            "value": "10"
                        },
                        {
                            "value": "15"
                        },
                        {
                            "value": "10"
                        },
                        {
                            "value": "5"
                        },
                        {
                            "value": "9"
                        },
                        {
                            "value": "5"
                        },
                        {
                            "value": "13"
                        },
                        {
                            "value": "5"
                        },
                        {
                            "value": "10"
                        },
                        {
                            "value": "3"
                        },
                        {
                            "value": "6"
                        },
                        {
                            "value": "9"
                        }
                    ]
                },
                {
                    // "seriesname": "Non-Food Products",
                    "data": [
                        {
                            "value": "10"
                        },
                        {
                            "value": "7"
                        },
                        {
                            "value": "3"
                        },
                        {
                            "value": "3"
                        },
                        {
                            "value": "7"
                        }
                    ]
                }
            ]
        }
    })
    .render();
});
</script>
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>나의 통계</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: record-menu -->
  <div class="record-menu stat-menu">
    <div class="big-cat">
      <ul class="menu-list clearfix">
        <li>
          <a href="#" class="btn">훈련참석정보</a>
        </li>
        <li>
          <a href="#" class="btn">공식훈련</a>
        </li>
        <li>
          <a href="#" class="btn">개인훈련</a>
        </li>
        <li>
          <a href="#" class="btn">부상정보</a>
        </li>
        <li>
          <a href="#" class="btn">체력측정결과</a>
        </li>
        <li>
          <a href="#" class="btn">전적</a>
        </li>
        <li>
          <a href="#" class="btn on">연습경기</a>
        </li>
        <li>
          <a href="#" class="btn">대회득실점</a>
        </li>
        <li>
          <a href="#" class="btn">상대성</a>
        </li>
      </ul>
    </div>
    <div class="mid-cat">
      <ul class="rank-mid menu-list clearfix">
        <li><a href="#">경기현황</a></li>
        <li><a href="#" class="on">점수별 득실점</a></li>
        <li><a href="#">기술별 득실점</a></li>
        <li><a href="#">시간대별 득실점</a></li>
        <li><a href="#">상대성</a></li>
      </ul>
    </div>
  </div>`
  <!-- E: record-menu -->

  <!-- S: tail -->
  <div class="tail short-tail">
    <a href="#"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" alt="닫기"></a>
  </div>
  <!-- E: tail -->

  <!-- S: state-cont -->
  <div class="state-cont ">
    <div class="chart-tab tab-2 clearfix">
      <a href="#" class="on">전체 득실점</a>
      <a href="#">좌우기술별 득실점</a>
    </div>
    <!-- S: stat-chart -->
    <section class="stat-chart train-place">
      <div class="chart-title">
        <h3>전체 득실점</h2>
        <p>2016-07-27~2016-08-03</p>
      </div>
      <!-- S: 전체 득실점 -->
      <div class="skill-chart">
        <div id="skill-total-chart"></div>
        <div class="chart-guide">
          <ul class="flex">
            <li><a href="#">득점</a></li>
            <li><a href="#">실점</a></li>
          </ul>
        </div>
      </div>
      <!-- E: 전체 득실점 -->
    </section>
    <!-- E: stat-chart -->
    <section class="stat-chart">
      <!-- S: 좌우기술별 득실점 -->
      <div class="skill-part-chart">
        <div class="chart-title">
          <h3>전체 득실점</h2>
          <p>2016-07-27~2016-08-03</p>
        </div>
        <!-- S: skill-part-table -->
        <div class="skill-part-table container">
            <!-- S: 좌우기술별 득실점 표 -->
            <table class="skill-part">
                <thead>
                    <tr>
                        <th colspan="3" class="get-point">득점</th>
                        <th rowspan="2">기술명</th>
                        <th colspan="3" class="lost-point">실점</th>
                    </tr>
                    <tr>
                        <td>좌측</td>
                        <td>우측</td>
                        <td class="gain-total">합계</td>
                        <td class="lost-total">합계</td>
                        <td>좌측</td>
                        <td>우측</td>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>3</td>
                        <td class="gain-total">4</td>
                        <th>업어치기</th>
                        <td class="lost-total">3</td>
                        <td>3</td>
                        <td>3</td>
                    </tr>
                    <tr>
                        <td class="big-point">21</td>
                        <td class="big-point">19</td>
                        <td class="gain-total">40</td>
                        <th>양소매 업어치기</th>
                        <td class="lost-total">3</td>
                        <td>3</td>
                        <td>3</td>
                    </tr>
                    <tr>
                        <td>5</td>
                        <td>4</td>
                        <td class="gain-total">9</td>
                        <th>한소매 업어치기</th>
                        <td class="lost-total">4</td>
                        <td>4</td>
                        <td>4</td>
                    </tr>
                    <tr>
                        <td class="big-point">25</td>
                        <td>4</td>
                        <td class="gain-total ext">27</td>
                        <th>외깃 업어치기</th>
                        <td class="lost-total">2</td>
                        <td>2</td>
                        <td>2</td>
                    </tr>
                    <tr>
                        <td>10</td>
                        <td>19</td>
                        <td class="gain-total">29</td>
                        <th>한팔 업어치기</th>
                        <td class="lost-total ext">57</td>
                        <td class="big-lost">30</td>
                        <td class="big-lost">27</td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>1</td>
                        <td class="gain-total">3</td>
                        <th>한팔 빗당겨치기</th>
                        <td class="lost-total">1</td>
                        <td>1</td>
                        <td>1</td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td class="big-point">35</td>
                        <td class="gain-total">29</td>
                        <th>빗당겨치기</th>
                        <td class="lost-total">3</td>
                        <td>2</td>
                        <td>1</td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>1</td>
                        <td class="gain-total">4</td>
                        <th>어깨로 매치기</th>
                        <td class="lost-total">1</td>
                        <td>1</td>
                        <td>1</td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>1</td>
                        <td class="gain-total">4</td>
                        <th>기타 손기술</th>
                        <td class="lost-total">1</td>
                        <td>1</td>
                        <td>1</td>
                    </tr>
                    <tr>
                        <td>7</td>
                        <td>3</td>
                        <td class="gain-total">10</td>
                        <th>밭다리</th>
                        <td class="lost-total">3</td>
                        <td>3</td>
                        <td>2</td>
                    </tr>
                    <tr>
                        <td>7</td>
                        <td>3</td>
                        <td class="gain-total">10</td>
                        <th>안다리</th>
                        <td class="lost-total">3</td>
                        <td>3</td>
                        <td>2</td>
                    </tr>
                    <tr>
                        <td class="big-point">25</td>
                        <td>4</td>
                        <td class="gain-total ext">29</td>
                        <th>발뒤축 걸기</th>
                        <td class="lost-total">4</td>
                        <td>4</td>
                        <td>5</td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>2</td>
                        <td class="gain-total">4</td>
                        <th>안뒤축 걸기</th>
                        <td class="lost-total">2</td>
                        <td>2</td>
                        <td>5</td>
                    </tr>
                </tbody>
            </table>
            <!-- E: 좌우기술별 득실점 표 -->
        </div>
        <!-- E: skill-part-table -->
      </div>
      <!-- E: 좌우기술별 득실점 -->
    </section>
  </div>
  <!-- E: state-cont -->
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
