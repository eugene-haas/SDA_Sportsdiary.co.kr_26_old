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
  //iPlayerIDX = '1347';
  //alert(iPlayerIDX);

  var clicksearch1 = 0;
  var clicksearch2 = 0;

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

  function table_ajax(sub_type) {

    var iDate = document.getElementById('isvYear');
    var iSDate = iDate.value + "-01-01";
    var iEDate = iDate.value + "-12-31";
    var iGameTitleIDX = document.getElementById('iMatchTitle');

    var strAjaxUrl = "../Ajax/stat-match-point.asp";

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
          if (sub_type == "pluspoint") {
            $('#sub_table1').html(retDATA);
          }
          else {
            $('#sub_table2').html(retDATA);
          }
        } else {
          $('#sub_table1').html("");
          $('#sub_table2').html("");
        }
      }, error: function (xhr, status, error) {
        if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
      }
    });

  }

  // 훈련장소
  function chart_view() {

    if (isearch_val() == false) {

    }
    else {

      clicksearch1 = 0;
      clicksearch2 = 0;

      // totalpoint, pluspoint, minuspoint
      // ichart, itable, itable1

      $('#itotalpoint').addClass('on');
      $('#ipluspoint').removeClass('on');
      $('#iminuspoint').removeClass('on');

      $('#ichart').show();
      $('#itable').hide();
      $('#itable1').hide();

      var iDate = document.getElementById('isvYear');
      var iSDate = iDate.value + "-01-01";
      var iEDate = iDate.value + "-12-31";
      var iGameTitleIDX = document.getElementById('iMatchTitle');

      //$('#SDate1').text(SDate);
      //$('#EDate1').text(EDate);
      //iPlayerIDX

      var strJsonUrl = "../Json/stat-match-point.asp?SDate=" + iSDate + "&EDate=" + iEDate + "&iPlayerIDX=" + iPlayerIDX + "&GameTitleIDX=" + iGameTitleIDX.value;
      FusionCharts.ready(function () {
        var demographicsChart = new FusionCharts({
          type: 'msbar3d',
          renderAt: 'match-total-chart',
          width: '100%',
          height: '360',
          dataFormat: 'jsonurl',
          dataSource: strJsonUrl
        }).render();
      });

      //검색창 닫기
      click_close();
      $('.bg-inst').hide();
      //$('#during_date').html($('#SDate').val() + "~" + $('#EDate').val());
      //$('#during_date1').html($('#SDate').val() + "~" + $('#EDate').val());
      //$('#during_date2').html($('#SDate').val() + "~" + $('#EDate').val());

      //차트부분 보이기
      $('#chart_view').show();

    }

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

  //검색창 닫기
  function click_tab(type) {

    // totalpoint, pluspoint, minuspoint
    // ichart, itable, itable1

    if (type == "pluspoint") {
      $('#itotalpoint').removeClass('on');
      $('#ipluspoint').addClass('on');
      $('#iminuspoint').removeClass('on');

      $('#ichart').hide();
      $('#itable').show();
      $('#itable1').hide();

      if (clicksearch1 == 0) {
        table_ajax('pluspoint');
      }

      clicksearch1 = 1;

    }
    else if (type == "minuspoint") {
      $('#itotalpoint').removeClass('on');
      $('#ipluspoint').removeClass('on');
      $('#iminuspoint').addClass('on');

      $('#ichart').hide();
      $('#itable').hide();
      $('#itable1').show();

      if (clicksearch2 == 0) {
        table_ajax('minuspoint');
      }

      clicksearch2 = 1;

    }
    else {
      $('#itotalpoint').addClass('on');
      $('#ipluspoint').removeClass('on');
      $('#iminuspoint').removeClass('on');

      $('#ichart').show();
      $('#itable').hide();
      $('#itable1').hide();
    }

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
    '===========================================================================================================
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
      <!--<li>
          <a href="../Stats/stat-present.asp" class="btn counsel">연습경기</a>
        </li>-->
      <li> <a href="javascript:onSubmitStat('../Stats/stat-match-point.asp');" class="btn counsel on">대회득실점</a> </li>
      <li> <a href="javascript:onSubmitStat('../Stats/stat-relativity-get.asp');" class="btn counsel">상대성</a> </li>
      <!--
      <li> <a href="../Stats/stat-match-point.asp" class="btn counsel on">대회득실점</a> </li>
      <li> <a href="../Stats/stat-relativity-get.asp" class="btn counsel">상대성</a> </li>
      <li> <a href="../Stats/stat-record.asp" class="btn counsel">전적</a> </li>
      -->
      <!--//<li>
          <a href="../Stats/weight-in-record.asp" class="btn">대회별 계체기록</a>
        </li>-->
    </ul>
  </div>
  <div class="mid-cat">
    <ul class="rank-mid menu-list clearfix">
      <li><a href="javascript:onSubmitStat('../Stats/stat-match-point.asp');" class="on">점수별</a></li>
      <li><a href="javascript:onSubmitStat('../Stats/stat-match-skill.asp');">기술별</a></li>
      <li><a href="javascript:onSubmitStat('../Stats/stat-match-time.asp');">시간대별</a></li>
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
<div class="state-cont" id="chart_view" style="display:none;">
  <div class="chart-tab container clearfix"> <a href="javascript:click_tab('totalpoint');" class="on" id="itotalpoint">전체</a> <a href="javascript:click_tab('pluspoint');" id="ipluspoint">득점</a> <a href="javascript:click_tab('minuspoint');" id="iminuspoint">실점</a> </div>
  <!-- S: 전체 차트 -->
  <div id="ichart">
    <section class="stat-chart train-place">
      <div class="chart-title">
        <h3>점수별 전체 득실점</h3>
        <!--<p id="during_date">2017-02-14~2017-02-20</p>-->
      </div>
      <div class="relativity-chart">
        <!--<p class="unit">k(단위):1,000</p>-->
        <div id="match-total-chart"></div>
        <div class="chart-guide" style="display:none;">
          <ul class="flex">
            <li><a href="#">득점</a></li>
            <li><a href="#">실점</a></li>
          </ul>
        </div>
      </div>
    </section>
  </div>
  <!-- E: 전체 차트 -->
  <!-- S: 득점 -->
  <div id="itable">
    <section class="stat-chart train-place">
      <div class="chart-title">
        <h3>점수별 기술구사</h3>
        <!--<p id="during_date1">2017-02-14~2017-02-20</p>-->
      </div>
      <div class="point-gain-chart container" id="sub_table1"> </div>
      <p class="no-apply-txt">※지도는 기술이 아니므로 기술구사 득실점 횟수에 반영되지 않습니다.</p>
    </section>
  </div>
  <!-- E: 득점 -->
  <!-- S: 실점 -->
  <div id="itable1">
    <section class="stat-chart train-place">
      <div class="chart-title">
        <h3>점수별 기술구사</h3>
        <!--<p id="during_date2">2017-02-14~2017-02-20</p>-->
      </div>
      <div class="point-lost-chart container" id="sub_table2"> </div>
      <p class="no-apply-txt">※지도는 기술이 아니므로 기술구사 득실점 횟수에 반영되지 않습니다.</p>
    </section>
  </div>
  <!-- E: 실점 -->
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
