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

  function pad(num) {
    num = num + '';
    return num.length < 2 ? '0' + num : num;
  }

  function dateToYYYYMMDD(date, status) {
    if (status == "M") {
      return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate() - 1);
    }
    else if (status == "Y") {
      return date.getFullYear() + '-' + pad(date.getMonth() + 2) + '-' + pad(date.getDate() - 1);
    }
    else if (status == "W") {
      return date.getFullYear() + '-' + pad(date.getMonth() + 2) + '-' + pad(date.getDate() - 6);
    }
  }

  var currDate = new Date();
  var tMon = currDate.getFullYear() + '-' + pad(currDate.getMonth() + 1) + '-' + pad(currDate.getDate());

  $(document).ready(function () {
    $('#search_date_id').change(function () {

      var search_date_id = $("#search_date_id option:selected").val();
      if (search_date_id == "1month") {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 1));
        var prevMon = dateToYYYYMMDD(prevDate, 'M');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
        //alert(prevMon);
      }
      else if (search_date_id == "1year") {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 13));
        var prevMon = dateToYYYYMMDD(prevDate, 'Y');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
        //alert(prevMon);
      }
      else {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 1));
        var prevMon = dateToYYYYMMDD(prevDate, 'W');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
      }

    });
  });

  function chart_view(sub_type, click) {

    if (sub_type == "uniform") {
      $('#iuniform').addClass("btn-right btn on");
      $('#ifitness').removeClass("btn-left btn on");
      $('#ifitness').addClass("btn-left btn");
    }
    else {
      $('#ifitness').addClass("btn-left btn on");
      $('#iuniform').removeClass("btn-right btn on");
      $('#iuniform').addClass("btn-right btn");
    }

    //sub_type = fitness,uniform
    //json통신 url parameter
    var SDate = $('#SDate').val();
    var EDate = $('#EDate').val();
    var strJsonUrl = "../Json/stat-strain-type.asp?SDate=" + SDate + "&EDate=" + EDate + "&Sub_Type=" + sub_type;

    FusionCharts.ready(function () {
      var fusioncharts = new FusionCharts({
        type: 'bar2d',
        renderAt: 'type-chart',
        width: '100%',
        height: '360',
        dataFormat: 'jsonurl',
        dataSource: strJsonUrl
      }
    );
      fusioncharts.render();
    });

    if (click == "ck") {

    }
    else {
      //검색창 닫기
      click_close();
    }

    //차트부분 보이기
    $('#chart_view').show();
    $('#during_date').html($('#SDate').val() + "~" + $('#EDate').val());

  }

  //검색창 닫기
  function click_close() {
    $("#sbox").slideToggle("slow", function () {
      $('#click_close').hide();
      $('#click_open').show();
    });
  }


  //검색창 열기
  function click_open() {
    $("#sbox").slideDown("slow", function () {
      $('#click_close').show();
      $('#click_open').hide();
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
          <a href="../Stats/stat-training-attand.asp" class="btn estimate">훈련참석정보</a>
        </li>
        <li>
          <a href="../Stats/stat-ptrain-place.asp" class="btn goodth">공식훈련</a>
        </li>
        <li>
          <a href="../Stats/stat-strain-place.asp" class="btn badth on">개인훈련</a>
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
        <!--<li>
          <a href="../Stats/stat-present.asp" class="btn counsel">연습경기</a>
        </li>-->
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
    <div class="mid-cat">
      <ul class="rank-mid menu-list clearfix">
        <li><a href="../Stats/stat-strain-place.asp">훈련장소</a></li>
        <li><a href="../Stats/stat-strain-time.asp">훈련시간</a></li>
        <li><a href="../Stats/stat-strain-type.asp" class="on">훈련종류</a></li>
      </ul>
    </div>
  </div>
  <!-- E: record-menu -->

  <!-- S: record-input -->
  <form name="s_frm" method="post">
    <input type="text" hidden="hidden" value="" class="on_val">
  <input type="text" hidden="hidden" value="" class="active_val">
  <div class="record-input" id="sbox">
    <!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 선택 -->
      <dl class="clearfix term-sel">
        <dt>기간선택</dt>
        <!--<dd class="on">-->
        <dd id="search_date">
          <select name="search_date" id="search_date_id">
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
  <!-- E: record-input -->

  <!-- S: tail -->
  <div class="tail">
    <a href="javascript:click_open();"><img src="../images/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a>
    <a href="javascript:click_close();" ><img src="../images/record/open-tail@3x.png" id="click_close" alt="닫기"></a>    
  </div>
  <!-- E: tail -->

  <!-- S: state-cont -->
  <div class="state-cont" id="chart_view" style="display:none;">
    <!-- S: 훈련 시간 stat-chart -->
    <section class="stat-chart train-place">
      <div class="chart-title">
        <h3>훈련종류 분포</h2>
        <p id="during_date">2016-07-27~2016-08-03</p>
      </div>
      <div class="btn-list">
        <a href="javaScript:chart_view('fitness','ck');" class="btn-left btn on" id="ifitness">체력훈련</a>
        <a href="javaScript:chart_view('uniform','ck');" class="btn-right btn" id="iuniform">도복 훈련</a>
      </div>
      <div id="type-chart"></div>
    </section>
    <!-- E: 훈련 시간 stat-chart -->
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