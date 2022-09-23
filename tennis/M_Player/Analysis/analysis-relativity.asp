<!-- #include file="../include/config.asp" -->
<!-- google chart -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- fusionchart api -->
<script src="../js/library/fusioncharts.js"></script>
<script src="../js/library/fusioncharts.theme.fint.js"></script>
<script src="../js/library/fusioncharts.charts.js"></script>
<script>
  function detailShow1(){
    $('.detail-table.table-1').fadeIn();
    console.log('detail1');
    return;
  }
  function detailShow2(){
    $('.detail-table.table-2').fadeIn();
    console.log('detail2');
    return;
  }
/* 좌우기술 득점 */
FusionCharts.ready(function () {
    var budgetChart = new FusionCharts({
        type: 'radar',
        renderAt: 'gain-relativity-chart',
        width: '100%',
        height: '320',
        dataFormat: 'json',
        dataSource: {
            "chart": {
                // "caption": "Budget analysis",
                // "subCaption": "Current month",
                "captionFontSize": "14",
                "subcaptionFontSize": "14",
                // "numberPrefix":"$",
                "baseFontColor" : "#333333",
                "baseFont" : "Helvetica Neue,Arial",
                "subcaptionFontBold": "0",
                "paletteColors": "#008ee4,#6baa01",
                "bgColor" : "#ffffff",
                "radarfillcolor": "#ffffff",
                "showBorder" : "0",
                "showShadow" : "0",
                "showCanvasBorder": "0",
                "legendBorderAlpha": "0",
                "legendShadow": "0",
                "divLineAlpha": "10",
                "usePlotGradientColor": "0",
                "numberPreffix": "$",
                "legendBorderAlpha": "0",
                "legendShadow": "0",
                "legendItemFontSize": "14",
                "labelBgColor" : "#e7eff5",
                "labelBorderColor" : "#adbfcd",
                "labelBorderRadius" : "4",
                "labelBorderPadding" : "6",
                "clickURL" : "javascript:detailShow1();",
            },
            "categories": [
                {
                    "category": [
                        { "label": "손기술" },
                        { "label": "발기술" },
                        { "label": "허리기술" },
                        { "label": "누우며 메치기" },
                        { "label": "되치기" },
                        { "label": "굳히기" },
                    ]
                }
            ],
            "dataset": [
                {
                    "seriesname": "우측기술",
                    "data": [
                        { "value": "19" },
                        { "value": "16" },
                        { "value": "14" },
                        { "value": "10" },
                        { "value": "20" }
                    ]
                },
                {
                    "seriesname": "좌측기술",
                    "data": [
                        { "value": "30" },
                        { "value": "25" },
                        { "value": "11" },
                        { "value": "30" },
                        { "value": "27" }
                    ]
                }
            ]
        }
    }).render();
});

/* 좌우 기술 실점 */
FusionCharts.ready(function () {
    var budgetChart = new FusionCharts({
        type: 'radar',
        renderAt: 'lost-relativity-chart',
        width: '100%',
        height: '320',
        dataFormat: 'json',
        dataSource: {
            "chart": {
                // "caption": "Budget analysis",
                // "subCaption": "Current month",
                "captionFontSize": "14",
                "subcaptionFontSize": "14",
                // "numberPrefix":"$",
                "baseFontColor" : "#333333",
                "baseFont" : "Helvetica Neue,Arial",
                "subcaptionFontBold": "0",
                "paletteColors": "#008ee4,#6baa01",
                "bgColor" : "#ffffff",
                "radarfillcolor": "#ffffff",
                "showBorder" : "0",
                "showShadow" : "0",
                "showCanvasBorder": "0",
                "legendBorderAlpha": "0",
                "legendShadow": "0",
                "divLineAlpha": "10",
                "usePlotGradientColor": "0",
                "legendBorderAlpha": "0",
                "legendShadow": "0",
                "legendItemFontSize": "14",
                "labelFontSize": "14",
                "labelBgColor" : "#e7eff5",
                "labelBorderColor" : "#adbfcd",
                "labelBorderRadius" : "4",
                "labelBorderPadding" : "6",
                "clickURL" : "javascript:detailShow2();",
            },
            "categories": [
                {
                    "category": [
                        { "label": "손기술" },
                        { "label": "발기술" },
                        { "label": "허리기술" },
                        { "label": "누우며 메치기" },
                        { "label": "되치기" },
                        { "label": "굳히기" },
                    ]
                }
            ],
            "dataset": [
                {
                    "seriesname": "우측기술",
                    "data": [
                        { "value": "19" },
                        { "value": "16" },
                        { "value": "14" },
                        { "value": "10" },
                        { "value": "20" }
                    ]
                },
                {
                    "seriesname": "좌측기술",
                    "data": [
                        { "value": "30" },
                        { "value": "25" },
                        { "value": "11" },
                        { "value": "30" },
                        { "value": "27" }
                    ]
                }
            ]
        }
    }).render();
});
</script>
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>선수분석</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: record-menu -->
  <div class="record-menu stat-menu">
    <div class="big-cat">
      <ul class="menu-list clearfix">
        <li>
          <a href="#" class="btn">대회득실점</a>
        </li>
        <li>
          <a href="#" class="btn on">상대성</a>
        </li>
        <li>
          <a href="#" class="btn">전적</a>
        </li>
      </ul>
    </div>
    <div class="menu-list mid-cat">
      <ul class="rank-mid clearfix" style="display: block;">
        <li><a href="#" class="on">좌우기술 득점</a></li>
        <li><a href="#">좌우기술 실점</a></li>
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
  <div class="state-cont relativity">
    <!-- S: stat-chart -->
    <section class="stat-chart train-place">
      <div class="chart-tab tabList flex">
        <a href="#" class="on">좌우기술 득점</a>
        <a href="#">좌우기술 실점</a>
      </div>
      <div class="chart-title">
        <h3>좌,우측 기술 득점</h2>
        <p>2016-07-27~2016-08-03</p>
      </div>
      <!-- S: 좌우기술 득점-->
      <div class="relativity-chart">
        <div id="gain-relativity-chart"></div>
        <!-- <div class="chart-guide">
          <ul class="flex">
            <li><a href="#">우측기술</a></li>
            <li><a href="#">좌측기술</a></li>
          </ul>
        </div> -->
      </div>
      <!-- E: 좌우기술 득점-->
      <!-- S: detail-table -->
      <div class="detail-table table-1 point-table">
        <h3>손기술</h3>
        <!-- S: 좌우기술별 득실점 표 -->
        <table class="skill-part">
          <thead>
            <tr>
              <th rowspan="2">기술명</th>
              <th colspan="3" class="get-point">득점</th>
            </tr>
            <tr>
              <td>좌측</td>
              <td>우측</td>
              <td class="gain-total">합계</td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>업어치기</th>
              <td>3</td>
              <td>3</td>
              <td>3</td>
            </tr>
            <tr>
              <th>양소매 업어치기</th>
              <td>3</td>
              <td>3</td>
              <td>3</td>
            </tr>
            <tr>
              <th>한소매 업어치기</th>
              <td>4</td>
              <td>4</td>
              <td>4</td>
            </tr>
            <tr>
              <th>외깃 업어치기</th>
              <td>2</td>
              <td>2</td>
              <td>2</td>
            </tr>
            <tr>
              <th>한팔 업어치기</th>
              <td class="big-gain">57</td>
              <td class="big-gain">30</td>
              <td class="big-gain">27</td>
            </tr>
            <tr>
              <th>한팔 빗당겨치기</th>
              <td>1</td>
              <td>1</td>
              <td>1</td>
            </tr>
            <tr>
              <th>빗당겨치기</th>
              <td>3</td>
              <td>2</td>
              <td>1</td>
            </tr>
            <tr>
              <th>어깨로 매치기</th>
              <td>1</td>
              <td>1</td>
              <td>1</td>
            </tr>
            <tr>
                <th>기타 손기술</th>
                <td>1</td>
                <td>1</td>
                <td>1</td>
            </tr>
            <tr>
                <th>밭다리</th>
                <td>3</td>
                <td>3</td>
                <td>2</td>
            </tr>
            <tr>
                <th>안다리</th>
                <td>3</td>
                <td>3</td>
                <td>2</td>
            </tr>
            <tr>
                <th>발뒤축 걸기</th>
                <td>4</td>
                <td>4</td>
                <td>5</td>
            </tr>
            <tr>
                <th>안뒤축 걸기</th>
                <td>5</td>
                <td>2</td>
                <td>2</td>
            </tr>
          </tbody>
        </table>
        <!-- E: 좌우기술별 득실점 표 -->
      </div>
      <!-- E: detail-table -->
    </section>
    <!-- S: 좌우기술 실점 -->
    <section class="stat-chart train-place">
      <div class="chart-title">
          <h3>좌,우측 기술 실점</h2>
          <p>2016-07-27~2016-08-03</p>
      </div>
      <!-- S: 좌우기술 실점-->
      <div class="relativity-chart">
          <div id="lost-relativity-chart"></div>
          <!-- <div class="chart-guide">
            <ul class="flex">
              <li><a href="#">우측기술</a></li>
              <li><a href="#">좌측기술</a></li>
            </ul>
          </div> -->
        </div>
        <!-- E: 좌우기술 실점-->
        <!-- S: detail-table -->
      <div class="detail-table table-2 point-table lost">
        <h3>손기술</h3>
        <!-- S: 좌우기술별 득실점 표 -->
        <table class="skill-part">
          <thead>
            <tr>
              <th rowspan="2">기술명</th>
              <th colspan="3" class="get-point">실점</th>
            </tr>
            <tr>
              <td>좌측</td>
              <td>우측</td>
              <td class="gain-total">합계</td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>업어치기</th>
              <td>3</td>
              <td>3</td>
              <td>3</td>
            </tr>
            <tr>
              <th>양소매 업어치기</th>
              <td>3</td>
              <td>3</td>
              <td>3</td>
            </tr>
            <tr>
              <th>한소매 업어치기</th>
              <td>4</td>
              <td>4</td>
              <td>4</td>
            </tr>
            <tr>
              <th>외깃 업어치기</th>
              <td>2</td>
              <td>2</td>
              <td>2</td>
            </tr>
            <tr>
              <th>한팔 업어치기</th>
              <td class="big-lost">57</td>
              <td class="big-lost">30</td>
              <td class="big-lost">27</td>
            </tr>
            <tr>
              <th>한팔 빗당겨치기</th>
              <td>1</td>
              <td>1</td>
              <td>1</td>
            </tr>
            <tr>
              <th>빗당겨치기</th>
              <td>3</td>
              <td>2</td>
              <td>1</td>
            </tr>
            <tr>
              <th>어깨로 매치기</th>
              <td>1</td>
              <td>1</td>
              <td>1</td>
            </tr>
            <tr>
                <th>기타 손기술</th>
                <td>1</td>
                <td>1</td>
                <td>1</td>
            </tr>
            <tr>
                <th>밭다리</th>
                <td>3</td>
                <td>3</td>
                <td>2</td>
            </tr>
            <tr>
                <th>안다리</th>
                <td>3</td>
                <td>3</td>
                <td>2</td>
            </tr>
            <tr>
                <th>발뒤축 걸기</th>
                <td>4</td>
                <td>4</td>
                <td>5</td>
            </tr>
            <tr>
                <th>안뒤축 걸기</th>
                <td>5</td>
                <td>2</td>
                <td>2</td>
            </tr>
          </tbody>
        </table>
        <!-- E: 좌우기술별 득실점 표 -->
      </div>
      <!-- E: detail-table -->
    </section>
    <!-- E: 좌우기술 실점 -->
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
