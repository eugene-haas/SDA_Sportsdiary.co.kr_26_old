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

  function isearch_val() {

    var iSDatevalue = $('#SDate').val();
    //var iMatchvalue = $('#iMatchTitle').val();
    var iEDatevalue = $('#EDate').val();

    if (iSDatevalue == "") {
      alert("기간조회 시작 날짜를 넣어 주세요.\r\n  예) 2017-01-01");
      return false;
    }
    else if (iEDatevalue == "") {
      alert("기간조회 종료 날짜를 넣어 주세요.\r\n  예) 2017-01-01");
      return false;
    }
    else {
      return true;
    }

  }

  function iResult_Total() {

    var iSDate = "";
    var iEDate = "";
    var iGameTitleIDX = "";

    var strAjaxUrl = "../Ajax/stat-match-result-total.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: iSDate,
        EDate: iEDate,
        iPlayerIDX: iPlayerIDX,
        GameTitleIDX: iGameTitleIDX
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iResultTotal').html(retDATA);
        } else {
          $('#iResultTotal').html("");
        }
      }, error: function (xhr, status, error) {
        if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
      }
    });

  }

  function iResult_NowYear() {

    var iSDate = "";
    var iEDate = "";
    var iGameTitleIDX = "";

    var strAjaxUrl = "../Ajax/stat-match-result-nowyear.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: iSDate,
        EDate: iEDate,
        iPlayerIDX: iPlayerIDX,
        GameTitleIDX: iGameTitleIDX
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iResultNowYear').html(retDATA);
        } else {
          $('#iResultNowYear').html("");
        }
      }, error: function (xhr, status, error) {
        if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
      }
    });

  }

  function iGameResult() {

    var iSDate = "";
    var iEDate = "";
    var iGameTitleIDX = "";

    var strAjaxUrl = "../Ajax/stat-match-result-gameresult.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: iSDate,
        EDate: iEDate,
        iPlayerIDX: iPlayerIDX,
        GameTitleIDX: iGameTitleIDX.value
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iGameResult').html(retDATA);
        } else {
          $('#iGameResult').html("");
        }
      }, error: function (xhr, status, error) {
        if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
      }
    });

  }

  function iSkillResult() {

    var iSDate = "";
    var iEDate = "";
    var iGameTitleIDX = "";

    var strAjaxUrl = "../Ajax/stat-match-result-skillresult.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: iSDate,
        EDate: iEDate,
        iPlayerIDX: iPlayerIDX,
        GameTitleIDX: iGameTitleIDX.value
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iSkillResult').html(retDATA);
        } else {
          $('#iSkillResult').html("");
        }
      }, error: function (xhr, status, error) {
        if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
      }
    });

  }


  function chart_time() {

    var iSDate = "";
    var iEDate = "";
    var iGameTitleIDX = "";

    var strJsonUrl = "../Json/stat-record.asp?SDate=" + iSDate + "&EDate=" + iEDate + "&iPlayerIDX=" + iPlayerIDX + "&GameTitleIDX=" + iGameTitleIDX;

    FusionCharts.ready(function () {
      //Creating a new inline theme.
      //You can move this entire code block to a separate file, and load.
      FusionCharts.register('theme', {
        name: 'fire',
        theme: {
          base: {
            chart: {
              paletteColors: '#FF4444, #FFBB33',
              baseFontColor: '#36474D',
              baseFont: 'Helvetica Neue,Arial',
              captionFontSize: '14',
              subcaptionFontSize: '14',
              subcaptionFontBold: '0',
              showBorder: '0',
              bgColor: '#ffffff',
              showShadow: '0',
              canvasBgColor: '#ffffff',
              canvasBorderAlpha: '0',
              useplotgradientcolor: '0',
              useRoundEdges: '0',
              showPlotBorder: '0',
              showAlternateHGridColor: '0',
              showAlternateVGridColor: '0',
              toolTipBorderThickness: '0',
              toolTipBgColor: '#99CC00',
              toolTipBgAlpha: '90',
              toolTipBorderRadius: '2',
              toolTipPadding: '5',
              legendBgAlpha: '0',
              legendBorderAlpha: '0',
              legendShadow: '0',
              legendItemFontSize: '14',
              divlineAlpha: '100',
              divlineColor: '#36474D',
              divlineThickness: '1',
              divLineIsDashed: '1',
              divLineDashLen: '1',
              divLineGapLen: '1',
              showHoverEffect: '1',
              valueFontSize: '14',
              showXAxisLine: '1',
              xAxisLineThickness: '1',
              xAxisLineColor: '#36474D'
            }
          },
          mscolumn2d: {
            chart: {
              valueFontColor: '#FFFFFF', //overwrite base value
              valueBgColor: '#000000',
              valueBgAlpha: '30',
              placeValuesInside: '1',
              rotateValues: '0'
            }
          }
        }
      });

      var revenueChart = new FusionCharts({
        type: 'mscolumn2d',
        renderAt: 'time-record-chart',
        width: '100%',
        height: '240',
        dataFormat: 'jsonurl',
        dataSource: strJsonUrl
      }).render();
    });

  }

  // 훈련장소
  function chart_view() {

    if (isearch_val() == false) {

    }
    else {


      var iSDate = "";
      var iEDate = "";
      var iGameTitleIDX = "";

      var strAjaxUrl = "../Ajax/stat-record.asp";
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          SDate: iSDate,
          EDate: iEDate,
          iPlayerIDX: iPlayerIDX,
          GameTitleIDX: iGameTitleIDX
        },
        success: function (retDATA) {
          if (retDATA) {
            $('#sub_table1').html(retDATA);
          } else {
            $('#sub_table1').html("");
          }
        }, error: function (xhr, status, error) {
         if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
        }
      });

      iResult_Total();

      iResult_NowYear();

      iGameResult();

      iSkillResult();

      chart_time();


    }

  }

  chart_view();


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
          <a href="../Stats/stat-strain-place.asp" class="btn badth">개인훈련</a>
        </li>
        <li>
          <a href="../Stats/stat-injury-dist.asp" class="btn my-diary">부상정보</a>
        </li>
        <li>
          <a href="../Stats/stat-gauge.asp" class="btn counsel">체력측정결과</a>
        </li>
        <li>
          <a href="../Stats/stat-record.asp" class="btn counsel on">전적</a>
        </li>
        <li>
          <a href="../Stats/stat-match-point.asp" class="btn counsel">대회득실점</a>
        </li>
        <li>
          <a href="../Stats/stat-relativity-get.asp" class="btn counsel">상대성</a>
        </li>
        <!-- <li>
          <a href="../Stats/weight-in-record.asp" class="btn">대회별 계체기록</a>
        </li> -->
      </ul>
    </div>
    <div class="mid-cat">
      <ul class="rank-mid menu-list clearfix">
        <li><a href="../Stats/stat-record.asp" class="on">선수 프로필</a></li>
        <li><a href="../Stats/stat-win.asp">입상현황</a></li>
        <li><a href="../Stats/stat-film.asp">대회영상모음</a></li>
      </ul>
    </div>
  </div>
  <!-- E: record-menu -->

  <!-- S: tail -->
  <!--<div class="tail short-tail">
    <a href="#"><img src="../images/record/close-tail@3x.png" alt="닫기"></a>
  </div>-->
  <!-- E: tail -->
  
  <!-- S: main stat-record -->
  <div class="main stat-record">

    <!-- S: prof -->
    <div class="prof flex" id="sub_table1">

    </div>
    <!-- E: prof -->

    <div style="display: block;">

    <!-- S: 전적 record -->
      <section class="record">
        <h3>전적 <span class="record-info">＊통산전적은 2017년부터 기록됩니다.</span></h3>
        <dl class="clearfix">
          <dt>통산전적(승률)</dt>
          <!--<dd>200전 160승 40패(70.5%)</dd>-->
          <dd id="iResultTotal">0전 0승 0패(0%)</dd>
        </dl>
        <dl class="clearfix">
          <dt>올 시즌 전적(승률)</dt>
          <!--<dd>120전 90승 30패(76%)</dd>-->
          <dd id="iResultNowYear">0전 0승 0패(0%)</dd>
        </dl>
      </section>
      <!-- E: 전적 record -->

    <!-- S: 최근 경기이력 best-win -->
    <section class="record best-win">
      <h3>최근 입상이력 <span class="record-info">＊입상이력은 개인전만 반영됩니다.</span></h3>
      <dl class="clearfix" id="iGameResult">
        <dd>데이터가 없습니다.</dd>
      </dl>
    </section>
    <!-- E: 최근 경기이력 best-win -->


    <!-- S: 대회기록 best-win -->
    <section class="record best-win">
      <h3>대회기록</h3>
      <h4>기술별 득실점</h4>
      <!-- S: between-chart -->
      <div class="between-chart container" id="iSkillResult">
        데이터가 없습니다.
      </div>
      <!-- E: between-chart -->
      <p class="no-apply-txt">※지도는 기술이 아니므로 기술구사 득실점 횟수에 반영되지 않습니다.</p>

      <!-- S: time-record-chart -->
      <div class="time-record-chart">
        <h3>시간대별 득실점</h3>
        <div id="time-record-chart"></div>
      </div>
      <!-- E: time-record-chart -->
    </section>
    <!-- E: 대회기록 best-win -->

    </div>


  </div>
  <!-- E: main stat-record -->

  <!-- S: footer -->
  <div class="footer light-footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>