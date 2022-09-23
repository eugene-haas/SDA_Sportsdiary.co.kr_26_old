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
                            "label": "5분대"
                        },
                        {
                            "label": "4분대"
                        },
                        {
                            "label": "3분대"
                        },
                        {
                            "label": "2분대"
                        },
                        {
                            "label": "1분대"
                        },
                        {
                            "label": "연장"
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
                        },
                        {
                            "value": "1"
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
          <a href="stat-training-attand.asp" class="btn">훈련참석정보</a>
        </li>
        <li>
          <a href="stat-ptrain-place.asp" class="btn">공식훈련</a>
        </li>
        <li>
          <a href="stat-strain-place.asp" class="btn">개인훈련</a>
        </li>
        <li>
          <a href="stat-injury-dist.asp" class="btn">부상정보</a>
        </li>
        <li>
          <a href="stat-gauge.asp" class="btn">체력측정결과</a>
        </li>
        <li>
          <a href="stat-record.asp" class="btn">전적</a>
        </li>
        <li>
          <a href="stat-present.asp" class="btn on">연습경기</a>
        </li>
        <li>
          <a href="stat-match-point.asp" class="btn">대회득실점</a>
        </li>
        <li>
          <a href="stat-train-relativity.asp" class="btn">상대성</a>
        </li>
      </ul>
    </div>
    <div class="mid-cat">
      <ul class="rank-mid menu-list clearfix">
        <li><a href="#">경기현황</a></li>
        <li><a href="#">점수별 득실점</a></li>
        <li><a href="#">기술별 득실점</a></li>
        <li><a href="#" class="on">시간대별 득실점</a></li>
        <li><a href="#">상대성</a></li>
      </ul>
    </div>
  </div>
  <!-- E: record-menu -->

  <!-- S: tail -->
  <div class="tail short-tail">
    <a href="#"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" alt="닫기"></a>
  </div>
  <!-- E: tail -->

  <!-- S: state-cont -->
  <div class="state-cont ">
    <!-- S: stat-chart -->
    <section class="stat-chart train-place">
      <div class="chart-tab flex">
        <a href="#" class="on">전체 득실점</a>
        <a href="#">시간대별 기술구사</a>
      </div>
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
        <!-- S: time-part-table -->
        <div class="time-part-table container">
            <!-- S: 시간대별별 득실점 표 -->
            <table class="time-part">
                <thead>
                    <tr>
                        <th>기술명</th>
                        <th>5분대</th>
                        <th>4분대</th>
                        <th>3분대</th>
                        <th>2분대</th>
                        <th>1분대</th>
                        <th>연장</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th>업어치기</th>
                        <td></td>
                        <td>9</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>양소매 업어치기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>한소매 업어치기</th>
                        <td></td>
                        <td></td>
                        <td>2</td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>외깃 업어치기</th>
                        <td></td>
                        <td></td>
                        <td>2</td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>한팔 업어치기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>빗당겨치기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>어깨로 매치기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>3</td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>기타 손기술</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>밭다리</th>
                        <td></td>
                        <td></td>
                        <td>2</td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>안다리</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>발뒤축 걸기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>안뒤축 걸기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>5</td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>안뒤축 후리기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>발목 받치기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                     </tr>
                     <tr>
                        <th>허벅다리 걸기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>모두 걸기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>기타 발기술</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>5</td>
                    </tr>
                    <tr>
                        <th>허리띄기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>허리후리기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>허리채기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>뒤안아 매치기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>기타 허리기술</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>배대뒤치기</th>
                        <td></td>
                        <td></td>
                        <td>12</td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>안오금띄기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>기타 누으며 메치기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>누르기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>조르기</th>
                        <td></td>
                        <td>5</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>꺽기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <th>되치기</th>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>8</td>
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>
            <!-- E: 시간대별별 득실점 표 -->
        </div>
        <!-- E: time-part-table -->
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
