<!-- #include file="../include/config.asp" -->
<!-- google chart -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- fusionchart api -->
<script src="../js/library/fusioncharts.js"></script>
<script src="../js/library/fusioncharts.theme.fint.js"></script>
<script src="../js/library/fusioncharts.charts.js"></script>
<script>
/* 좌우기술 득점 */
FusionCharts.ready(function () {
    var budgetChart = new FusionCharts({
        type: 'radar',
        renderAt: 'gain-relativity-chart',
        width: '100%',
        height: '360',
        dataFormat: 'json',
        dataSource: {
            "chart": {
                "caption": "Budget analysis",
                "subCaption": "Current month",
                "captionFontSize": "14",
                "subcaptionFontSize": "14",
                "numberPrefix":"$",
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
                "legendShadow": "0"
            },
            "categories": [
                {
                    "category": [
                        { "label": "Marketing" },
                        { "label": "Product Management" },
                        { "label": "Customer Service" },
                        { "label": "Human Resource" },
                        { "label": "Sales & Distribution" }
                    ]
                }
            ],
            "dataset": [
                {
                    "seriesname": "Allocated Budget",
                    "data": [
                        { "value": "19000" },
                        { "value": "16500" },
                        { "value": "14300" },
                        { "value": "10000" },
                        { "value": "9800" }
                    ]
                },
                {
                    "seriesname": "Actual Cost",
                    "data": [
                        { "value": "6000" },
                        { "value": "9500" },
                        { "value": "11900" },
                        { "value": "8000" },
                        { "value": "9700" }
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
        height: '360',
        dataFormat: 'json',
        dataSource: {
            "chart": {
                "caption": "Budget analysis",
                "subCaption": "Current month",
                "captionFontSize": "14",
                "subcaptionFontSize": "14",
                "numberPrefix":"$",
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
                "legendShadow": "0"
            },
            "categories": [
                {
                    "category": [
                        { "label": "Marketing" },
                        { "label": "Product Management" },
                        { "label": "Customer Service" },
                        { "label": "Human Resource" },
                        { "label": "Sales & Distribution" }
                    ]
                }
            ],
            "dataset": [
                {
                    "seriesname": "Allocated Budget",
                    "data": [
                        { "value": "19000" },
                        { "value": "16500" },
                        { "value": "14300" },
                        { "value": "10000" },
                        { "value": "9800" }
                    ]
                },
                {
                    "seriesname": "Actual Cost",
                    "data": [
                        { "value": "6000" },
                        { "value": "9500" },
                        { "value": "11900" },
                        { "value": "8000" },
                        { "value": "9700" }
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
          <a href="#" class="btn">연습경기</a>
        </li>
        <li>
          <a href="#" class="btn">대회득실점</a>
        </li>
        <li>
          <a href="#" class="btn on">상대성</a>
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
  </div>`
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
      <div class="chart-title">
        <h3>좌,우측 기술 득점</h2>
        <p>2016-07-27~2016-08-03</p>
      </div>
      <!-- S: 좌우기술 득점-->
      <div class="relativity-chart">
        <div id="gain-relativity-chart"></div>
        <div class="chart-guide">
          <ul class="flex">
            <li><a href="#">우측기술</a></li>
            <li><a href="#">좌측기술</a></li>
          </ul>
        </div>
      </div>
      <!-- E: 좌우기술 득점-->
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
            <div class="chart-guide">
              <ul class="flex">
                <li><a href="#">우측기술</a></li>
                <li><a href="#">좌측기술</a></li>
              </ul>
            </div>
          </div>
          <!-- E: 좌우기술 실점-->
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
