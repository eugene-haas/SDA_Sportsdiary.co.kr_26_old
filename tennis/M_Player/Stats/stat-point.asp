<!-- #include file="../include/config.asp" -->
<!-- google chart -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- fusionchart api -->
<script src="../js/library/fusioncharts.js"></script>
<script src="../js/library/fusioncharts.theme.fint.js"></script>
<script src="../js/library/fusioncharts.charts.js"></script>
<script>
/**/
FusionCharts.ready(function () {
    var topStores = new FusionCharts({
        type: 'bar2d',
        renderAt: 'point-total-chart',
        width: '100%',
        height: '360',
        dataFormat: 'json',
        dataSource: {
            "chart": {
                // "caption": "Top 5 Stores by Sales",
                // "subCaption": "Last month",
                "yAxisName": "Sales (In USD)",
                "numberPrefix": "$",
                "paletteColors": "#0075c2",
                "bgColor": "#ffffff",
                "showBorder": "0",
                "showCanvasBorder": "0",
                "usePlotGradientColor": "0",
                "plotBorderAlpha": "10",
                "placeValuesInside": "1",
                "valueFontColor": "#ffffff",
                "showAxisLines": "1",
                "axisLineAlpha": "25",
                "divLineAlpha": "10",
                "alignCaptionWithCanvas": "0",
                "showAlternateVGridColor": "0",
                "captionFontSize": "14",
                "subcaptionFontSize": "14",
                "subcaptionFontBold": "0",
                "toolTipColor": "#ffffff",
                "toolTipBorderThickness": "0",
                "toolTipBgColor": "#000000",
                "toolTipBgAlpha": "80",
                "toolTipBorderRadius": "2",
                "toolTipPadding": "5"
            },

            "data": [
                {
                    "label": "한판",
                    "value": "880000"
                },
                {
                    "label": "절반",
                    "value": "730000"
                },
                {
                    "label": "유효",
                    "value": "590000"
                },
                {
                    "label": "지도",
                    "value": "520000"
                },
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
        <a href="#" class="on">전체</a>
        <a href="#">득점</a>
        <a href="#">실점</a>
      </div>
      <div class="chart-title">
        <h3>전체 득실점</h2>
        <p>2016-07-27~2016-08-03</p>
      </div>
      <!-- S: 랭킹 그래프 -->
      <div class="point-chart">
        <div id="point-total-chart"></div>
        <div class="chart-guide">
          <ul class="flex">
            <li>득점</li>
            <li>실점</li>
          </ul>
        </div>
      </div>
      <!-- E: 랭킹 그래프 -->
    </section>
    <!-- E: stat-chart -->

    <!-- S: point-gain -->
    <section class="point-gain">
      <div class="chart-title">
        <h3>점수별 기술구사</h2>
        <p>2016-07-27~2016-08-03</p>
      </div>
      <!-- S: 점수별 득실점 득점 -->
      <div class="point-gain-chart container">
        <table>
          <thead>
            <tr>
              <th>기술명</th>
              <th>한판</th>
              <th>절반</th>
              <th>유효</th>
              <th>지도</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>업어치기</th>
              <td>5</td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>양소매 업어치기</th>
              <td></td>
              <td>17</td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>한소매 업어치기</th>
              <td>21</td>
              <td></td>
              <td></td>
              <td>30</td>
            </tr>
            <tr>
              <th>외깃 업어치기</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>한팔 업어치기</th>
              <td></td>
              <td></td>
              <td>17</td>
              <td></td>
            </tr>
            <tr>
              <th>한팔 빗당겨치기</th>
              <td></td>
              <td>19</td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>빗당겨치기</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>어깨로 매치기</th>
              <td></td>
              <td></td>
              <td>21</td>
              <td></td>
            </tr>
            <tr>
              <th>기타 손기술</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>밭다리</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>안다리</th>
              <td></td>
              <td></td>
              <td></td>
              <td>2</td>
            </tr>
            <tr>
              <th>밭뒤축 걸기</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>안뒤축 걸기</th>
              <td>10</td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>안뒤축 후리기</th>
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
            </tr>
            <tr>
              <th>허벅다리 걸기</th>
              <td></td>
              <td></td>
              <td>22</td>
              <td></td>
            </tr>
            <tr>
              <th>모두 걸기</th>
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
            </tr>
            <tr>
              <th>허리띄기</th>
              <td></td>
              <td></td>
              <td>2</td>
              <td></td>
            </tr>
            <tr>
              <th>허리후리기</th>
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
              <td>11</td>
            </tr>
            <tr>
              <th>뒤안아 매치기</th>
              <td></td>
              <td></td>
              <td></td>
              <td>30</td>
            </tr>
            <tr>
              <th>기타 허리기술</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>배대뒤치기</th>
              <td>21</td>
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
            </tr>
            <tr>
              <th>기타 누으며 메치기</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>누르기</th>
              <td></td>
              <td>4</td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>조르기</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>꺽기</th>
              <td></td>
              <td></td>
              <td>6</td>
              <td></td>
            </tr>
            <tr>
              <th>되치기</th>
              <td></td>
              <td>26</td>
              <td></td>
              <td></td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- E: 점수별 득실점 득점 -->
    </section>
    <!-- E: point-gain -->

    <!-- S: point-lost -->
    <section class="point-lost">
      <div class="chart-title">
        <h3>점수별 기술구사</h2>
        <p>2016-07-27~2016-08-03</p>
      </div>
      <!-- S: 점수별 득실점 실점 -->
      <div class="point-lost-chart container">
        <table>
          <thead>
            <tr>
              <th>기술명</th>
              <th>한판</th>
              <th>절반</th>
              <th>유효</th>
              <th>지도</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>업어치기</th>
              <td>5</td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>양소매 업어치기</th>
              <td></td>
              <td>17</td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>한소매 업어치기</th>
              <td>21</td>
              <td></td>
              <td></td>
              <td>30</td>
            </tr>
            <tr>
              <th>외깃 업어치기</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>한팔 업어치기</th>
              <td></td>
              <td></td>
              <td>17</td>
              <td></td>
            </tr>
            <tr>
              <th>한팔 빗당겨치기</th>
              <td></td>
              <td>19</td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>빗당겨치기</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>어깨로 매치기</th>
              <td></td>
              <td></td>
              <td>21</td>
              <td></td>
            </tr>
            <tr>
              <th>기타 손기술</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>밭다리</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>안다리</th>
              <td></td>
              <td></td>
              <td></td>
              <td>2</td>
            </tr>
            <tr>
              <th>밭뒤축 걸기</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>안뒤축 걸기</th>
              <td>10</td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>안뒤축 후리기</th>
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
            </tr>
            <tr>
              <th>허벅다리 걸기</th>
              <td></td>
              <td></td>
              <td>22</td>
              <td></td>
            </tr>
            <tr>
              <th>모두 걸기</th>
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
            </tr>
            <tr>
              <th>허리띄기</th>
              <td></td>
              <td></td>
              <td>2</td>
              <td></td>
            </tr>
            <tr>
              <th>허리후리기</th>
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
              <td>11</td>
            </tr>
            <tr>
              <th>뒤안아 매치기</th>
              <td></td>
              <td></td>
              <td></td>
              <td>30</td>
            </tr>
            <tr>
              <th>기타 허리기술</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>배대뒤치기</th>
              <td>21</td>
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
            </tr>
            <tr>
              <th>기타 누으며 메치기</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>누르기</th>
              <td></td>
              <td>4</td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>조르기</th>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <th>꺽기</th>
              <td></td>
              <td></td>
              <td>6</td>
              <td></td>
            </tr>
            <tr>
              <th>되치기</th>
              <td></td>
              <td>26</td>
              <td></td>
              <td></td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- E: 점수별 득실점 실점 -->
    </section>
    <!-- E: point-lost -->
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
