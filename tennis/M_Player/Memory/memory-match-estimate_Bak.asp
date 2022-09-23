<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- #include file="../include/config_chart.asp" -->
<!-- E: config -->
<!--Load the AJAX API-->
<!-- <script src="https://www.gstatic.com/charts/loader.js"></script> -->
<script>
  function detailShow(){
    $('.detail-table').fadeIn();
  }
    FusionCharts.ready(function(){
    var salesChart = new FusionCharts({
        type: 'scrollline2d',
        dataFormat: 'json',
        renderAt: 'chart',
        width: '100%',
        height: '230',
        dataSource: {
            "chart": {
                // "caption": "Sales Trends",
                // "subCaption": "(FY 2012 to FY 2013)",
                // "xAxisName": "Month",
                // "yAxisName": "Revenue",
                "showValues": "1",
                "valueFontSize" : "14",
                "valueBgColor" : "#e7eff5",
                "valueBorder" : "1",
                "valueBorderColor" : "#adbfcd",
                "valueBorderRadius" : "4",
                "valueBorderPadding" : "2",
                "baseFontSize": "12",
                // "numberSuffix": "kg",
                "showBorder": "0",
                "showShadow": "0",
                "bgColor": "#ffffff",
                "paletteColors": "#a5dcff",
                "showCanvasBorder": "2",
                "showCanvasBorderColor" : "#ff0000",
                "anchorBorderThickness" : "3",
                "anchorRadius" : "4",
                "showAxisLines": "0",
                "showAlternateHGridColor": "0",
                "divlineAlpha": "100",
                "divlineThickness": "1",
                "divLineIsDashed": "1",
                "divLineDashLen": "1",
                "divLineGapLen": "1",
                "lineThickness": "2",
                "flatScrollBars": "1",
                "scrollheight": "10",
                "numVisiblePlot": "12",
                "showHoverEffect":"1",
                "clickURL" : "javascript:detailShow();",
            },
            "categories": [
                {
                    "category": [
                        { "label": "16-12-18" },
                        { "label": "16-12-19" },
                        { "label": "16-12-20" },
                        { "label": "16-12-21" },
                        { "label": "16-12-22" },
                    ]
                }
            ],
            "dataset": [
                {
                    "data": [
                        { "value": "32" },
                        { "value": "31" },
                        { "value": "36" },
                        { "value": "29" },
                        { "value": "31" },
                    ]
                }
            ]
        }
    }).render();
});
</script>
<body>
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>메모리</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->
  <!-- S: memory-menu -->
  <div class="record-menu memory-menu">
    <div class="big-cat">
      <ul class="menu-list clearfix">
        <li>
          <a href="#" class="btn on">나의평가표</a>
        </li>
        <li>
          <a href="#" class="btn">잘된점 모아보기</a>
        </li>
        <li>
          <a href="#" class="btn">보완점 모아보기</a>
        </li>
        <li>
          <a href="#" class="btn">나의일기 모아보기</a>
        </li>
        <li>
          <a href="#" class="btn">지도자상담 모아보기</a>
        </li>
      </ul>
    </div>
    <!-- S: 나의 평가표 서브메뉴 -->
    <div class="menu-list mid-cat flex">
      <ul class="rank-mid clearfix" style="display: block;">
        <li><a href="">훈련평가표</a></li>
        <li><a href="" class="on">대회평가표</a></li>
      </ul>
      <!-- S: 잘된점 모아보기 서브메뉴 -->
      <ul class="rank-mid clearfix" style="display: none;">
        <li><a href="" class="on">훈련일지</a></li>
        <li><a href="">대회일지</a></li>
        <li><a href="">즐겨찾기</a></li>
      </ul>
      <!-- E: 잘된점 모아보기 서브메뉴 -->
      <!-- S: 보완점 모아보기 서브메뉴 -->
      <ul class="rank-mid clearfix" style="display: none;">
        <li><a href="" class="on">훈련일지</a></li>
        <li><a href="">대회일지</a></li>
        <li><a href="">즐겨찾기</a></li>
      </ul>
      <!-- E: 보완점 모아보기 서브메뉴 -->
      <!-- S: 나의일기 모아보기 서브메뉴 -->
      <ul class="rank-mid clearfix" style="display: none;">
        <li><a href="" class="on">훈련일지</a></li>
        <li><a href="">대회일지</a></li>
        <li><a href="">즐겨찾기</a></li>
      </ul>
      <!-- E: 나의일기 모아보기 서브메뉴 -->
      <!-- S: 지도자상담 모아보기 서브메뉴 -->
      <ul class="rank-mid clearfix" style="display: none;">
        <li><a href="" class="on">훈련일지</a></li>
        <li><a href="">대회일지</a></li>
        <li><a href="">즐겨찾기</a></li>
      </ul>
      <!-- E: 지도자상담 모아보기 서브메뉴 -->
    </div>
    <!-- E: 나의 평가표 서브메뉴 -->
    <div class="menu-list small-cat flex"></div>
  </div>
  <!-- E: memory-menu -->
  <!-- S: tail -->
  <div class="tail memory-tail">
    <a href="#"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" alt="닫기"></a>
  </div>
  <!-- E: tail -->
  <!-- E: record-input -->
  <!-- S: estimate -->
  <div class="estimate container">
    <!-- S: estimate-box -->
    <div class="estimate-box">
      <h2>대회평가</h2>
        <p>2016-07-27~2016-08-03</p>
        <!-- S: chart-list -->
        <div class="chart-list">
          <div id="chart"></div>
        </div>
        <!-- E: chart-list -->
        <p class="orangy">*추이 그래프 점수를 클릭하시면 상세 평가내용을<br>보실 수 있습니다.</p>
        <!-- S: detail-table -->
      <div class="detail-table row">
        <h3>2016.06.25</h3>
        <table class="navy-top-table">
          <thead>
            <tr>
              <th rowspan="2">평가 내용</th>
              <th colspan="3">만족도</th>
            </tr>
            <tr>
              <th>상</th>
              <th>중</th>
              <th>하</th>
            </tr>
            <tbody>
              <tr>
                <td><label for="tranin-question01">1.훈련의 목표와 의도에 맞게 훈련이 되었나요?</label></td>
                <td><input type="radio" id="tranin-question01-1" name="tranin-question01" checked /></td>
                <td><input type="radio" id="tranin-question01-2" name="tranin-question01" /></td>
                <td><input type="radio" id="tranin-question01-3" name="tranin-question01" /></td>
              </tr>
              <tr>
                <td><label for="tranin-question02">2.체력적인 만족도는?</label></td>
                <td><input type="radio" id="tranin-question02-1" name="tranin-question02" checked /></td>
                <td><input type="radio" id="tranin-question02-2" name="tranin-question02" /></td>
                <td><input type="radio" id="tranin-question02-3" name="tranin-question02" /></td>
              </tr>
              <tr>
                <td><label for="tranin-question03">3.기술적인 만족도는?</label></td>
                <td><input type="radio" id="tranin-question03-1" name="tranin-question03" checked /></td>
                <td><input type="radio" id="tranin-question03-2" name="tranin-question03" /></td>
                <td><input type="radio" id="tranin-question03-3" name="tranin-question03" /></td>
              </tr>
              <tr>
                <td><label for="tranin-question04">4.훈련의 양이 충분했나요?</label></td>
                <td><input type="radio" id="tranin-question04-1" name="tranin-question04" checked /></td>
                <td><input type="radio" id="tranin-question04-2" name="tranin-question04" /></td>
                <td><input type="radio" id="tranin-question04-3" name="tranin-question04" /></td>
              </tr>
              <tr>
                <td><label for="tranin-question05">5.훈련의 질에 만족하나요?</label></td>
                <td><input type="radio" id="tranin-question05-1" name="tranin-question05" checked /></td>
                <td><input type="radio" id="tranin-question05-2" name="tranin-question05" /></td>
                <td><input type="radio" id="tranin-question05-3" name="tranin-question05" /></td>
              </tr>
              <tr>
                <td><label for="tranin-question06">6.준비운동,정리운동은 잘 했나요?</label></td>
                <td><input type="radio" id="tranin-question06-1" name="tranin-question06" checked /></td>
                <td><input type="radio" id="tranin-question06-2" name="tranin-question06" /></td>
                <td><input type="radio" id="tranin-question06-3" name="tranin-question06" /></td>
              </tr>
              <tr>
                <td><label for="tranin-question07">7.훈련에 집중할 수 있는 환경이였나요?</label></td>
                <td><input type="radio" id="tranin-question07-1" name="tranin-question07" checked /></td>
                <td><input type="radio" id="tranin-question07-2" name="tranin-question07" /></td>
                <td><input type="radio" id="tranin-question07-3" name="tranin-question07" /></td>
              </tr>
              <tr>
                <td><label for="tranin-question08">8.식사,수면,휴식 등 자기관리가 잘 되었나요?</label></td>
                <td><input type="radio" id="tranin-question08-1" name="tranin-question08" checked /></td>
                <td><input type="radio" id="tranin-question08-2" name="tranin-question08" /></td>
                <td><input type="radio" id="tranin-question08-3" name="tranin-question08" /></td>
              </tr>
              <tr>
                <td><label for="tranin-question09">9.최고의 선수가 되겠다는 의지가 강했나요?</label></td>
                <td><input type="radio" id="tranin-question09-1" name="tranin-question09" checked /></td>
                <td><input type="radio" id="tranin-question09-2" name="tranin-question09" /></td>
                <td><input type="radio" id="tranin-question09-3" name="tranin-question09" /></td>
              </tr>
              <tr>
                <td><label for="tranin-question10">10.스스로 최선을 다했다고 생각하나요?</label></td>
                <td><input type="radio" id="tranin-question10-1" name="tranin-question10" checked /></td>
                <td><input type="radio" id="tranin-question10-2" name="tranin-question10" /></td>
                <td><input type="radio" id="tranin-question10-3" name="tranin-question10" /></td>
              </tr>
            </tbody>
          </thead>
        </table>
        <!-- E : 훈련평가 -->
      </div>
      <!-- E: detail-table -->
      </div>
      <!-- E: estimate-box -->
  </div>
  <!-- E: estimate -->
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
