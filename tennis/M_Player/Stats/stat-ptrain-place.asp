<!-- #include file="../include/config.asp" -->
<%
  dim SDate : SDate = Request("SDate")  '검색 시작일
  dim EDate : EDate = Request("EDate")  '검색 종료일
  dim search_date : search_date   = fInject(Request("search_date"))
  dim SType : SType = Request("SType")

  PlayerIDX = Request.Cookies("PlayerIDX")
  'PlayerIDX = decode(PlayerIDX,0)

  MemberIDX = Request.Cookies("MemberIDX")
  'MemberIDX = decode(MemberIDX,0)

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
<script type="text/javascript">

  var iPlayerIDX = '<%=PlayerIDX%>';
  var iMemberIDX = '<%=MemberIDX%>';

  function pad(num) {
    num = num + '';
    return num.length < 2 ? '0' + num : num;
  }

  function dateToYYYYMMDD(date, status) {
    if (status == "M") {
      //return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate() - 1);
    return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate() + 1);
    }
    else if (status == "W") {
      return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate());;
    }
  }

  var currDate = new Date();
  var tMon = currDate.getFullYear() + '-' + pad(currDate.getMonth() + 1) + '-' + pad(currDate.getDate());

  $(document).ready(function () {
    var search_date = '<%=search_date%>';
    if(search_date!="") {
      $("select[name='search_date'] option[value='"+search_date+"']").attr("selected", "selected");
    }

    $('#search_date_id').change(function () {

      var search_date_id = $("#search_date_id option:selected").val();
      if (search_date_id == "1month") {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 1));
        var prevMon = dateToYYYYMMDD(prevDate, 'M');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
        //alert(prevMon);
      }
      else if (search_date_id == "3month") {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 3));
        var prevMon = dateToYYYYMMDD(prevDate, 'M');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
        //alert(prevMon);
      }
      else if (search_date_id == "6month") {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 6));
        var prevMon = dateToYYYYMMDD(prevDate, 'M');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
        //alert(prevMon);
      }
      else if (search_date_id == "1year") {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 12));
        var prevMon = dateToYYYYMMDD(prevDate, 'M');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
        //alert(prevMon);
      }
      else if (search_date_id == "2year") {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 24));
        var prevMon = dateToYYYYMMDD(prevDate, 'M');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
        //alert(prevMon);
      }
      else if (search_date_id == "3year") {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 36));
        var prevMon = dateToYYYYMMDD(prevDate, 'M');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
        //alert(prevMon);
      }
      else if (search_date_id == "5year") {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 60));
        var prevMon = dateToYYYYMMDD(prevDate, 'M');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
        //alert(prevMon);
      }
      else if (search_date_id == "10year") {
        var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 120));
        var prevMon = dateToYYYYMMDD(prevDate, 'M');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
        //alert(prevMon);
      }
      else {
        var prevDate = new Date(new Date().setDate(new Date().getDate()-6));
        var prevMon = dateToYYYYMMDD(prevDate, 'W');
        $('#SDate').val(prevMon);
        $('#EDate').val(tMon);
      }

    });
  });

  // 훈련장소
  function chart_view() {

    //json통신 url parameter
    var SDate = $('#SDate').val();
    var EDate = $('#EDate').val();

    $('#SDate1').text(SDate);
    $('#EDate1').text(EDate);

    var strJsonUrl = "../Json/stat-ptrain-place.asp?SDate=" + SDate + "&EDate=" + EDate + "&MemberIDX=" + iMemberIDX;
    FusionCharts.ready(function () {
        var demographicsChart = new FusionCharts({
            type: 'pie3d',
            renderAt: 'place-chart',
            width: '100%',
            height: '220',
            dataFormat: 'jsonurl',
            dataSource: strJsonUrl
        });

        demographicsChart.render();
    });

    //검색창 닫기
    click_close();
    $('.bg-inst').hide();
    $('#during_date').html($('#SDate').val() + "~" + $('#EDate').val());

    //차트부분 보이기
    $('#chart_view').show();
  }


  //검색창 닫기
  function click_close(){
     $("#sbox").slideToggle( "slow", function() {
       $('#click_close').hide();
       $('#click_open').show();
    });
  }


  //검색창 열기
  function click_open(){
    $("#sbox").slideDown( "slow", function() {
      $('#click_close').show();
      $('#click_open').hide();
    });
  }

  function onSubmit(valUrl){
    $('form[name=s_frm]').attr('action', valUrl);
    $('form[name=s_frm]').submit();
  }
</script>
<body class="lack-bg">
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
      <li> <a href="javascript:onSubmit('../Stats/stat-training-attand.asp');" class="btn estimate">훈련참석정보</a> </li>
      <li> <a href="javascript:onSubmit('../Stats/stat-ptrain-place.asp');" class="btn goodth on">공식훈련</a> </li>
      <li> <a href="javascript:onSubmit('../Stats/stat-strain-place.asp');" class="btn badth">개인훈련</a> </li>
      <li> <a href="javascript:onSubmit('../Stats/stat-injury-dist.asp');" class="btn my-diary">부상정보</a> </li>
      <li> <a href="javascript:onSubmit('../Stats/stat-gauge.asp');" class="btn counsel">체력측정결과</a> </li>
      <li> <a href="javascript:onSubmit('../Stats/stat-record.asp');" class="btn counsel">전적</a> </li>
      <!--
        <li>
          <a href="../Stats/stat-present.asp" class="btn counsel">연습경기</a>
        </li>
        -->
      <li> <a href="javascript:onSubmit('../Stats/stat-match-point.asp');" class="btn counsel">대회득실점</a> </li>
      <li> <a href="javascript:onSubmit('../Stats/stat-relativity-get.asp');" class="btn counsel">상대성</a> </li>
      <!--//<li>
          <a href="../Stats/weight-in-record.asp" class="btn">대회별 계체기록</a>
        </li>-->
    </ul>
  </div>
  <div class="mid-cat">
    <ul class="rank-mid menu-list clearfix">
      <li><a href="javascript:onSubmit('../Stats/stat-ptrain-place.asp');" class="on">훈련장소</a></li>
      <li><a href="javascript:onSubmit('../Stats/stat-ptrain-time.asp');">훈련시간</a></li>
      <li><a href="javascript:onSubmit('../Stats/stat-ptrain-type.asp');">훈련종류</a></li>
    </ul>
  </div>
</div>
<!-- E: record-menu -->
<!-- S: include intro-bg -->
<!-- #include file = "./intro-bg.asp" -->
<!-- E: include intro-bg -->
<!-- S: record-input -->
<form name="s_frm" method="post">
  <input type="hidden"  class="on_val" id="on_val" name="on_val" />
  <input type="hidden"  class="active_val"  id="active_val" name="active_val"  />
  <div class="record-input bg-ipt" id="sbox">
    <!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 선택 -->
      <dl class="clearfix push-term-sel">
        <dt>기간선택</dt>
        <!--<dd class="on">-->
        <dd id="search_date">
          <select name="search_date" id="search_date_id">
            <option value="1week">최근 1주일</option>
            <option value="1month">최근 1개월</option>
            <option value="3month">최근 3개월</option>
            <option value="6month">최근 6개월</option>
            <option value="1year">최근 1년</option>
            <option value="2year">최근 2년</option>
            <option value="3year">최근 3년</option>
            <option value="5year">최근 5년</option>
            <option value="10year">최근 10년</option>
          </select>
        </dd>
      </dl>
      <!-- E: 기간 선택 -->
      <!-- S: 기간 조회 -->
      <dl class="clearfix term-srch">
        <dt>기간조회</dt>
        <!--<dd class="on">-->
        <dd> <span>
          <input type="date" name="SDate" id="SDate" value="<%=SDate%>">
          </span> </dd>
        <dd class="flow"> <span>~</span> </dd>
        <!--<dd class="on">-->
        <dd> <span>
          <input type="date" name="EDate" id="EDate" value="<%=EDate%>">
          </span> </dd>
      </dl>
      <!-- E: 기간 조회 -->
    </div>
    <!-- E: sel-list -->
    <div class="btn-list"> <a href="#" class="btn-left btn btn-close">닫기</a> <a href="javascript:chart_view();" class="btn-right btn">조회</a> </div>
  </div>
</form>
<!-- E: record-input -->
<!-- S: tail -->
<div class="tail bg-tail">
  <!--<div class="tail short-tail">-->
  <a href="javascript:click_open();"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a> <a href="#" ><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" alt="닫기"></a> </div>
<!-- E: tail -->
<!-- S: state-cont -->
<div class="state-cont" id="chart_view" style="display:none;">
  <!-- S: 훈련 장소 stat-chart -->
  <section class="stat-chart train-place">
    <div class="chart-title">
      <h3>훈련장소 유형</h3>
      <p id="during_date"><span id="SDate1">2017-02-14</span>~<span id="EDate1">2017-02-20</span></p>
    </div>
    <div id="place-chart"></div>
    <div id="place-chart2"></div>
  </section>
  <!-- E: 훈련 장소 stat-chart -->
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
