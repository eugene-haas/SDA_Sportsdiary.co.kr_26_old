<!-- S: config -->
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

'  response.Write "SDate="&request("SDate")&"<br>"
'  response.Write "on_val="&request("on_val")&"<br>"
'  response.Write "active_val="&request("active_val")&"<br>"

  '검색 기간 설정이 되어 있지 않다면 기본 오늘 날짜~1주일전
%>
<!-- #include file="../include/config_chart.asp" -->
<!-- E: config -->
<!--Load the AJAX API-->
<!-- <script src="https://www.gstatic.com/charts/loader.js"></script> -->
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
      return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate());
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

  function chart_view() {

    $('#sub_chart_total').hide();

    //json통신 url parameter
    var SDate = $('#SDate').val();
    var EDate = $('#EDate').val();
    var strJsonUrl = "../Json/memory-match-estimate.asp?SDate=" + SDate + "&EDate=" + EDate + "&iPlayerIDX=" + iMemberIDX;

    FusionCharts.ready(function () {
      var demographicsChart = new FusionCharts({
        type: 'scrollline2d',
        renderAt: 'chart',
        width: '100%',
        height: '230',
        dataFormat: 'jsonurl',
        dataSource: strJsonUrl
      }).render();
    });

    //검색창 닫기
    click_close();
    $('.bg-inst').hide();
    //차트부분 보이기
    $('#chart_view').show();
    $('#during_date').html($('#SDate').val() + "~" + $('#EDate').val());

  }

  function chart_sub(date, gmidx) {

    //alert(date + "," + gmidx);

    sub_type = date.replace(/-/g, ".");

    $('#sub_chart_total').show();

    var strAjaxUrl = "../Ajax/memory-match-estimate.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        iDate: sub_type,
        iGmIDX: gmidx
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#sub_table').html(retDATA);
        } else {
          $('#sub_table').html("");
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });


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

  function onSubmit(valUrl){
    $('form[name=s_frm]').attr('action', valUrl);
    $('form[name=s_frm]').submit();
  }
</script>
<body class="lack-bg">

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>메모리</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

<!-- S: memory-menu -->
<div class="record-menu memory-menu">
  <div class="big-cat">
    <ul class="menu-list clearfix">
      <li> <a href="javascript:onSubmit('../Memory/memory-estimate.asp');" class="btn on">나의평가표</a> </li>
      <li> <a href="javascript:onSubmit('../Memory/memory-good.asp');" class="btn">잘된점 모아보기</a> </li>
      <li> <a href="javascript:onSubmit('../Memory/memory-bad.asp');" class="btn">보완점 모아보기</a> </li>
      <li> <a href="javascript:onSubmit('../Memory/memory-diary.asp');" class="btn">나의일기 모아보기</a> </li>
      <li> <a href="javascript:onSubmit('../Memory/memory-councel.asp');" class="btn">지도자상담 모아보기</a><span id="SUBCOUNCEL" style="display:none" class="ic-new">N</span> </li>
    </ul>
  </div>
  <!-- S: 나의 평가표 서브메뉴 -->
  <div class="menu-list mid-cat flex">
    <ul class="rank-mid clearfix" style="display: block;">
      <li><a href="javascript:onSubmit('../Memory/memory-estimate.asp');">훈련평가표</a></li>
      <li><a href="javascript:onSubmit('../Memory/memory-match-estimate.asp');" class="on">대회평가표</a></li>
    </ul>
  </div>
  <!-- E: 나의 평가표 서브메뉴 -->
  <div class="menu-list small-cat flex"></div>
</div>
<!-- E: memory-menu -->
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
<div class="tail bg-tail"> <a href="javascript:click_open();"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a> <a href="#" ><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" alt="닫기"></a> </div>
<!-- E: tail -->
<!-- S: estimate -->
<div class="estimate container" id="chart_view" style="display:none;">
  <!-- S: estimate-box -->
  <!-- S: chart-list -->
  <div class="estimate-box">
    <h2>대회평가</h2>
    <p id="during_date">2016-07-27~2016-08-03</p>
    <!-- S: chart-list -->
    <div class="chart-list">
      <div id="chart"></div>
    </div>
    <p class="orangy">*추이 그래프 점수를 누르시면 상세 평가내용을<br>
      보실 수 있습니다.</p>
  </div>
  <!-- E: chart-list -->
  <!-- S: detail-table -->
  <div class="detail-table row" id="sub_chart_total">
    <div id="sub_table"></div>
  </div>
  <!-- E: detail-table -->
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
