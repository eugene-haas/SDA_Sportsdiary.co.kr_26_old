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

<script type="text/javascript">

  alert('<%=EDate %>');

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

  // 훈련시간 분포

  function chart_view() {
    //json통신 url parameter
    var SDate = $('#SDate').val();
    var EDate = $('#EDate').val();
    var strJsonUrl = "../Json/stat-strain-time.asp?SDate=" + SDate + "&EDate=" + EDate;


    FusionCharts.ready(function () {
      var demographicsChart = new FusionCharts({
        type: 'pie3d',
        renderAt: 'time-chart',
        width: '100%',
        height: '360',
        dataFormat: 'jsonurl',
        dataSource: strJsonUrl
      });
      demographicsChart.render();
    });

    //총훈련시간 Ajax 처리
    var strAjaxUrl = "../Ajax/stat-strain-time.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: SDate,
        EDate: EDate
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#train-time').html("총 훈련시간 <span>" + retDATA + "</span>");
        } else {
          $('#train-time').html("총 훈련시간 <span>0분</span>");
        }
      }, error: function (xhr, status, error) {
        if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
      }
    });

    //검색창 닫기
    click_close();
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
          <a href="../Stats/stat-training-attand.asp" class="btn estimate">훈련참석정보</a>
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
          <a href="../Stats/stat-match-point.asp" class="btn counsel">대회득실점</a>
        </li>
        <li>
          <a href="../Stats/stat-relativity-get.asp" class="btn counsel">상대성</a>
        </li>
        <!--//<li>
          <a href="../Stats/weight-in-record.asp" class="btn on">대회별 계체기록</a>
        </li>-->
      </ul>
    </div>
  </div>
  <!-- E: record-menu -->

  <!-- S: tail -->
  <div class="tail short-tail">
    <a href="#"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" alt="닫기"></a>
  </div>
  <!-- E: tail -->

  <!-- S: weight-in-recoard -->
  <div class="weight-in-recoard">
    <h3>2016년</h3>
    <dl class="match-weight-in">
      <dt>(5/5~5/8) 전국 체급별 선수권 대회</dt>
      <dd>
        <ul>
          <li><span class="ic-gray">체급</span> -63kg</li>
          <li><span class="ic-skyblue">계체기록</span> -61kg <span class="txt-skyblue">(통과)</span></li>
        </ul>
      </dd>
    </dl>
    <dl class="match-weight-in">
      <dt>(6/2~6/4) 2016 하계 전국 남,여 대학교 유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹</dt>
      <dd>
        <ul>
          <li><span class="ic-gray">체급</span> -63kg</li>
          <li><span class="ic-orange">계체기록</span> -61kg <span class="txt-orange">(탈락)</span></li>
        </ul>
      </dd>
    </dl>
    <dl class="match-weight-in">
      <dt>(6/2~6/4) 2016 하계 전국 남,여 대학교 유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹</dt>
      <dd>
        <ul>
          <li><span class="ic-gray">체급</span> -63kg</li>
          <li><span class="ic-orange">계체기록</span> -61kg <span class="txt-orange">(탈락)</span></li>
        </ul>
      </dd>
    </dl>
    <dl class="match-weight-in">
      <dt>(5/5~5/8) 전국 체급별 선수권 대회</dt>
      <dd>
        <ul>
          <li><span class="ic-gray">체급</span> -63kg</li>
          <li><span class="ic-skyblue">계체기록</span> -61kg <span class="txt-skyblue">(통과)</span></li>
        </ul>
      </dd>
    </dl>
    <dl class="match-weight-in">
      <dt>(6/2~6/4) 2016 하계 전국 남,여 대학교 유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹</dt>
      <dd>
        <ul>
          <li><span class="ic-gray">체급</span> -63kg</li>
          <li><span class="ic-orange">계체기록</span> -61kg <span class="txt-orange">(탈락)</span></li>
        </ul>
      </dd>
    </dl>
    <dl class="match-weight-in">
      <dt>(6/2~6/4) 2016 하계 전국 남,여 대학교 유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹</dt>
      <dd>
        <ul>
          <li><span class="ic-gray">체급</span> -63kg</li>
          <li><span class="ic-orange">계체기록</span> -61kg <span class="txt-orange">(탈락)</span></li>
        </ul>
      </dd>
    </dl>
    <dl class="match-weight-in">
      <dt>(5/5~5/8) 전국 체급별 선수권 대회</dt>
      <dd>
        <ul>
          <li><span class="ic-gray">체급</span> -63kg</li>
          <li><span class="ic-skyblue">계체기록</span> -61kg <span class="txt-skyblue">(통과)</span></li>
        </ul>
      </dd>
    </dl>
    <dl class="match-weight-in">
      <dt>(6/2~6/4) 2016 하계 전국 남,여 대학교 유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹</dt>
      <dd>
        <ul>
          <li><span class="ic-gray">체급</span> -63kg</li>
          <li><span class="ic-orange">계체기록</span> -61kg <span class="txt-orange">(탈락)</span></li>
        </ul>
      </dd>
    </dl>
    <dl class="match-weight-in">
      <dt>(6/2~6/4) 2016 하계 전국 남,여 대학교 유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹유도연맹</dt>
      <dd>
        <ul>
          <li><span class="ic-gray">체급</span> -63kg</li>
          <li><span class="ic-orange">계체기록</span> -61kg <span class="txt-orange">(탈락)</span></li>
        </ul>
      </dd>
    </dl>
  </div>
  <!-- E: weight-in-recoard -->

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
