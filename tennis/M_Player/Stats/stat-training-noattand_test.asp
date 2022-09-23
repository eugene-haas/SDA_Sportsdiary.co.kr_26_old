<!-- #include file="../include/config.asp" -->
<%
  '검색 시작일
  SDate = Request("SDate")
  '검색 종료일
  EDate = Request("EDate")

  SType = Request("SType")


  If SDate="" Then 
    SDate = Left(DateAdd("w",-6,now()),10)
  End If 

  If EDate = "" Then 
    EDate = Left(now(),10)
  End If 

  '검색 기간 설정이 되어 있지 않다면 기본 오늘 날짜~1주일전
%>
<script src="../js/library/fusioncharts.js"></script>
<script src="../js/library/fusioncharts.theme.fint.js"></script>
<script src="../js/library/fusioncharts.charts.js"></script>
<script>
//해당기간의 총 훈련 합계


function chart_view(){
  //json통신 url

  FusionCharts.ready(function () {
      var strJsonUrl = "../Json/stat-training-noattand_request.asp";
      var demographicsChart = new FusionCharts({
          type: 'pie3d',
          renderAt: 'chart-container',
          width: '100%',
          height: '360',
          dataFormat: 'jsonurl',
          dataSource: strJsonUrl

      });

      demographicsChart.render();
  });
  //차트부분 보이기
  click_close();
  $('#during_date').html($('#SDate').val()+"~"+$('#EDate').val());
  $('#attand_text').html("훈련 참여일 : 40일");
  $('#noattand_text').html("훈련 불참일 : 10일<span class='redy'>(총 훈련일의 20%)</span>");
  $('#chart_view').show();
}

//검색창 닫기
function click_close(){
   $("#sbox").slideToggle( "slow", function() {
     $('#click_close').hide();
     $('#click_open').show();

    // Animation complete.
  });
}


//검색창 열기
function click_open(){
  $("#sbox").slideDown( "slow", function() {
    $('#click_close').show();
    $('#click_open').hide();
    // Animation complete.
  });
}


</script>
<body>
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>나의 통계</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->
  <!-- S: record-menu -->
  <div class="record-menu stat-menu">
    <div class="big-cat">
      <ul class="menu-list clearfix">
        <li>
          <a href="../Stats/stat-training-attand.asp" class="btn estimate on">훈련참석정보</a>
        </li>
        <li>
          <a href="../Stats/stat-ptrain-place.asp" class="btn goodth">공식훈련</a>
        </li>
        <li>
          <a href="../Stats/stat-strain-place.asp" class="btn badth">개인훈련</a>
        </li>
        <li>
          <a href="../Stats/stat-injury-dist.asp" class="btn my-diary">부상정보</a>
        </li>
        <li>
          <a href="../Stats/stat-gauge.asp" class="btn counsel">체력측정결과</a>
        </li>
        <li>
          <a href="../Stats/stat-record.asp" class="btn counsel">전적</a>
        </li>
        <li>
          <a href="../Stats/stat-present.asp" class="btn counsel">연습경기</a>
        </li>
        <li>
          <a href="../Stats/stat-match-point.asp" class="btn counsel">대회득실점</a>
        </li>
        <li>
          <a href="../Stats/stat-relativity-get.asp" class="btn counsel">상대성</a>
        </li>
        <!--//<li>
          <a href="../Stats/weight-in-record.asp" class="btn">대회별 계체기록</a>
        </li>-->
      </ul>
    </div>
    <div class="menu-list mid-cat">
      <ul class="record-mid clearfix" style="display: block;">
        <li><a href="../Stats/stat-training-attand.asp" >훈련참석</a></li>
        <li><a href="../Stats/stat-training-noattand.asp" class="on">훈련불참</a></li>
      </ul>
    </div>
    <div class="menu-list small-cat flex"></div>
  </div>
  <!-- E: record-menu -->
  <!-- S: record-input -->
  <form name="s_frm" method="post">
  <div class="record-input" id="sbox">
    <!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 선택 -->
      <dl class="clearfix term-sel">
        <dt>기간선택</dt>
        <!--<dd class="on">-->
        <dd id="search_date">
          <select name="search_date">
            <option value="1week">최근 1주일</option>
            <option value="1month">최근 1달</option>
            <option value="1year">최근 1년</option>
          </select>
        </dd>
      </dl>
      <!-- E: 기간 선택 -->
      <!-- S: 기간 조회 -->
      <dl class="clearfix term-srch">
        <dt>기간조회</dt>
        <!--<dd class="on">-->
        <dd>        
          <span><input type="date" name="SDate" id="SDate" value="<%=SDate%>"></span>
        </dd>
        <dd class="flow">
          <span>~</span>
        </dd>
        <!--<dd class="on">-->
        <dd>
          <span><input type="date" name="EDate" id="EDate" value="<%=EDate%>"></span>
        </dd>

      </dl>
      <!-- E: 기간 조회 -->
    </div>
    <!-- E: sel-list -->
    <div class="btn-list">
      <a href="javascript:click_close();" class="btn-left btn">닫기</a>
      <a href="javascript:chart_view();" class="btn-right btn">조회</a>
    </div>
  </div>
  </form>
  <!-- S: tail -->
  <div class="tail">
    <a href="javascript:click_open();"><img src="../images/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a>
    <a href="javascript:click_close();" ><img src="../images/record/open-tail@3x.png" id="click_close" alt="닫기"></a>    
  </div>
  <!-- E: tail -->
  <!-- E: record-input -->
  <!-- S: state-cont -->
  <div class="state-cont" id="chart_view" style="display:none;">
    <div class="stat-title">
      <h2>훈련참석 현황</h2>
      <ul>
        <li id="attand_text">훈련 참여일 : 41일</li>
        <li id="noattand_text">훈련 불참일 : 8일<span class="redy">(총 훈련일의 16%)</span></li>
      </ul>
    </div>
    <!-- S: stat-chart -->
    <section class="stat-chart">
      <div class="chart-title">
        <h3>훈련참석 유형 분포</h2>
        <p id="during_date"></p>
      </div>
      <div id="chart-container"></div>
    </section>
    <!-- E: stat-chart -->
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