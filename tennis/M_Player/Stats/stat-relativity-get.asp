<!-- #include file="../include/config.asp" -->
<%
  '검색 시작일
  SDate = Request("SDate")
  '검색 종료일
  EDate = Request("EDate")

  SType = Request("SType")

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
<!-- google chart -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- fusionchart api -->
<script src="../js/library/fusioncharts.js"></script>
<script src="../js/library/fusioncharts.theme.fint.js"></script>
<script src="../js/library/fusioncharts.charts.js"></script>
<script type="text/javascript">

  var iPlayerIDX = '<%=PlayerIDX%>';
  var iMemberIDX = '<%=MemberIDX%>';

  //var clicksearch = 0;

  function iYear_chg(year) {

    var SDate = year;
    document.getElementById('isvYear').value = SDate;

    var strAjaxUrl = "../Ajax/analysis-Search-MatchTitle.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: SDate
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#sub_table').html(retDATA);
        } else {
          $('#sub_table').html("");
        }
      }, error: function (xhr, status, error) {
        if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
      }
    });

  }

  function isearch_val() {

    var iYearvalue = $('#iMatchTitle').val();

    if (iYearvalue == "") {
      alert("년도 부터 선택 해 주세요.");
      return false;
    }
    else {
      return true;
    }

  }

  function chart_view() {

    if (isearch_val() == false) {

    }
    else {

      //clicksearch = 0;

      $('#sub_chart_total').hide();


      var iDate = document.getElementById('isvYear');
      var iSDate = iDate.value + "-01-01";
      var iEDate = iDate.value + "-12-31";
      var iGameTitleIDX = document.getElementById('iMatchTitle');

      var strJsonUrl = "../Json/stat-relativity-get.asp?SDate=" + iSDate + "&EDate=" + iEDate + "&iPlayerIDX=" + iPlayerIDX + "&GameTitleIDX=" + iGameTitleIDX.value;

      FusionCharts.ready(function () {
        var demographicsChart = new FusionCharts({
          type: 'radar',
          renderAt: 'gain-relativity-chart',
          width: '100%',
          height: '320',
          dataFormat: 'jsonurl',
          dataSource: strJsonUrl
        }).render();
      });

      //검색창 닫기
      click_close();
      $('.bg-inst').hide();
      //차트부분 보이기
      $('#chart_view').show();
      //$('#during_date').html($('#SDate').val() + "~" + $('#EDate').val());

    }

  }

  function chart_sub(sub_type) {

    $('#sub_chart_total').show();

    var iDate = document.getElementById('isvYear');
    var iSDate = iDate.value + "-01-01";
    var iEDate = iDate.value + "-12-31";
    var iGameTitleIDX = document.getElementById('iMatchTitle');

    var strAjaxUrl = "../Ajax/stat-relativity-get.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: iSDate,
        EDate: iEDate,
        Sub_Type: sub_type,
        iPlayerIDX: iPlayerIDX,
        GameTitleIDX: iGameTitleIDX.value
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#sub_table_detail').html(retDATA);
        } else {
          $('#sub_table_detail').html("");
        }
      }, error: function (xhr, status, error) {
        if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
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

  function onSubmitStat(valURL){
    $('form[name=s_frm]').attr('action',valURL);
    $('form[name=s_frm]').submit();
  }

  $(document).ready(function(){
    <%
    '===========================================================================================================
    '페이지 이동시 검색조건이 있는 경우 selected
    '===========================================================================================================
    IF request("iyear")  <> "" Then response.Write "$('#iyear').val('"&request("iyear")&"');"
    '대회타이틀IDX
    IF request("iMatchTitle")  <> "" Then
      response.Write "$.when( $.ajax(iYear_chg('"&request("iyear")&"'))).then(function() {"
      response.Write "  $('#iMatchTitle').val('"&Request("iMatchTitle")&"');"
      response.Write "  chart_view();"
      response.Write "});"
    End IF
    %>
  });
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
      <li> <a href="../Stats/stat-training-attand.asp" class="btn estimate">훈련참석정보</a> </li>
      <li> <a href="../Stats/stat-ptrain-place.asp" class="btn goodth">공식훈련</a> </li>
      <li> <a href="../Stats/stat-strain-place.asp" class="btn badth">개인훈련</a> </li>
      <li> <a href="../Stats/stat-injury-dist.asp" class="btn my-diary">부상정보</a> </li>
      <li> <a href="../Stats/stat-gauge.asp" class="btn counsel">체력측정결과</a> </li>
      <li> <a href="javascript:onSubmitStat('../Stats/stat-record.asp');" class="btn counsel">전적</a> </li>
      <li> <a href="javascript:onSubmitStat('../Stats/stat-match-point.asp');" class="btn counsel">대회득실점</a> </li>
      <li> <a href="javascript:onSubmitStat('../Stats/stat-relativity-get.asp');" class="btn counsel on">상대성</a> </li>
      <!--
      <li> <a href="../Stats/stat-match-point.asp" class="btn counsel">대회득실점</a> </li>
      <li> <a href="../Stats/stat-relativity-get.asp" class="btn counsel on">상대성</a> </li>
      <li> <a href="../Stats/stat-record.asp" class="btn counsel">전적</a> </li>
      -->
      <!--//<li>
          <a href="../Stats/weight-in-record.asp" class="btn">대회별 계체기록</a>
        </li>-->
    </ul>
  </div>
  <div class="mid-cat">
    <ul class="rank-mid menu-list clearfix">
      <li><a href="javascript:onSubmitStat('../Stats/stat-relativity-get.asp');" class="on">좌우기술 득점</a></li>
      <li><a href="javascript:onSubmitStat('../Stats/stat-relativity-lost.asp');">좌우기술 실점</a></li>
    </ul>
  </div>
</div>
<!-- E: record-menu -->
<!-- S: include intro-bg -->
<!-- #include file = "./intro-bg.asp" -->
<!-- E: include intro-bg -->
<!-- S: record-input -->
<form name="s_frm" method="post">
  <input type="text" hidden="hidden" value="" class="on_val">
  <input type="text" hidden="hidden" value="" class="active_val">
  <input type="hidden" id="isvYear" name="isvYear" value="" />
  <div class="record-input bg-ipt" id="sbox">
    <!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 -->
      <dl class="clearfix push-term-sel">
        <dt>년도</dt>
        <dd>
          <select name="iyear" id="iyear" onChange="javascript:iYear_chg(this.options[this.selectedIndex].value);">
            <option value="2016" selected>2016년</option>
            <%

                Dim iYear, iYear_no
                iYear = Year(Now())
                iYear_no = iYear - 2016

                For i = 1 To iYear_no

              %>
            <option value="<%= 2016 + i %>"><%= 2016 + i %>년</option>
            <%

                Next

              %>
          </select>
        </dd>
      </dl>
      <!-- E: 기간 -->
      <!-- S: 대회명 -->
      <dl class="clearfix">
        <dt>대회명</dt>
        <dd>
          <div id="sub_table">
            <select name="iMatchTitle" id="iMatchTitle" onChange="javascript:iMatch_chg();">
              <option value="">::대회명을 선택하세요::</option>
            </select>
          </div>
        </dd>
      </dl>
      <!-- E: 대회명 -->
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
<div class="state-cont relativity" id="chart_view" style="display:none;">
  <!-- S: stat-chart -->
  <section class="stat-chart train-place">
    <div class="chart-title">
      <h3>좌,우측 기술 득점</h3>
      <!--<p id="during_date">2016-07-27~2016-08-03</p>-->
    </div>
    <!-- S: 좌우기술 득점-->
    <div id="gain-relativity-chart"></div>
    <!-- E: 좌우기술 득점-->
    <p class="orangy">*기술유형을 누르시면 상세현황을 보실 수 있습니다.</p>
    <!-- S: detail-table -->
    <div class="detail-table table-1 point-table" id="sub_chart_total">
      <div id="sub_table_detail"></div>
    </div>
    <!-- E: detail-table -->
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
<script type="text/javascript">
    var iNowYear = new Date();
    //alert(iNowYear.getFullYear());
    $('#iyear').val(iNowYear.getFullYear());
    iYear_chg(iNowYear.getFullYear());
  </script>
</body>
