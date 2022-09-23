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

  var clicksearch = 0;

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

  function table_ajax() {

    var iDate = document.getElementById('isvYear');
    var iSDate = iDate.value + "-01-01";
    var iEDate = iDate.value + "-12-31";
    var iGameTitleIDX = document.getElementById('iMatchTitle');

    var strAjaxUrl = "../Ajax/stat-win-sub.asp";
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

  }

  function iMovieLink(link1, link2) {
    //alert(link1 + "," + link2);

    //alert(iSDate + "," + iPlayerIDX + "," + iEDate + "," + iGameTitleIDX.value);
    //alert(iPlayerIDX);

    if (link2 == "sd040001") {
      var strAjaxUrl = "../Ajax/stat-DetailScore-Sch.asp";
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          iPlayerIDX: iPlayerIDX,
          iGameScoreIDX: link1,
          iGroupGameGbName: link2
        },
        success: function (retDATA) {
          if (retDATA) {
            //alert(retDATA);
            $('#detailScore').html(retDATA);
            $('.film-modal').filmTab('.film-modal');
            $('.groups-res').filmTab('.groups-res');
          } else {
            $('#detailScore').html("");
          }
        }, error: function (xhr, status, error) {
          if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
        }
      });
    }
    else {
      var strAjaxUrl = "../Ajax/stat-DetailScore-Sch-Team.asp";

      //alert(strAjaxUrl);

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          iPlayerIDX: iPlayerIDX,
          iGameScoreIDX: link1,
          iGroupGameGbName: link2
        },
        success: function (retDATA) {
          if (retDATA) {
            //alert(retDATA);
            $('#detailScore_Team').html(retDATA);
            $('.film-modal').filmTab('.film-modal');
            $('.groups-res').filmTab('.groups-res');
          } else {
            $('#detailScore_Team').html("");
          }
        }, error: function (xhr, status, error) {
          if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
        }
      });
    }


  }

  function chart_view() {

    if (isearch_val() == false) {
      //alert("false");
    }
    else {

      clicksearch = 0;

      var iDate = document.getElementById('isvYear');
      var iSDate = iDate.value + "-01-01";
      var iEDate = iDate.value + "-12-31";
      var iGameTitleIDX = document.getElementById('iMatchTitle');

      var oiDataYN = "";

      var oiData =
                  [
                    ["Element", "갯수", { role: "style" }]
                    //["금메달", 3, "#ffc21e"],
                    //["은메달", 1, "#bababa"],
                    //["동메달", 1, "#caae90"]
                  ];

      var strAjaxUrl = "../Ajax/stat-win.asp";

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
        async: false,
        success: function (retDATA) {
          if (retDATA) {

            oiDataYN = "Y";

            var dataarry = retDATA.split("^");

            var idacnt = 0;
            var imedalcnt = 3; //금,은,동 차트 x축 갯수

            for (var i = 1; i < Number(dataarry[1]) + 1; i++) {

              var arriData_1 = new Array();
              arriData_1.push(dataarry[2 + idacnt], Number(dataarry[3 + idacnt]), dataarry[4 + idacnt]);
              oiData.push(arriData_1);

              idacnt = idacnt + imedalcnt;
            }


          } else {
            oiDataYN = "N";
            $("#chart_view").css("display", "none");
            alert("조건에 맞는 데이터 값이 없습니다.");
          }
        }, error: function (xhr, status, error) {
          if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
        }
      });

      if (oiDataYN == "Y") {

        google.charts.load("current", { packages: ['corechart'] });
        google.charts.setOnLoadCallback(drawChart);
        function drawChart() {
          var data = google.visualization.arrayToDataTable(oiData);

          var view = new google.visualization.DataView(data);
          view.setColumns([0, 1,
                           {
                             calc: "stringify",
                             sourceColumn: 1,
                             type: "string",
                             role: "annotation"
                           },
                           2]);

          var options = {
            // title: "Density of Precious Metals, in g/cm^3",
            width: '100%',
            height: 240,
            min: 3,
            vAxis: { format: '0' },
            bar: { groupWidth: "95%" },
            legend: { position: "none" },
          };
          var chart = new google.visualization.ColumnChart(document.getElementById("term-chart"));
          chart.draw(view, options);
        }

        table_ajax();


        //검색창 닫기
        click_close();
        $('.bg-inst').hide();

        //차트부분 보이기
        $('#chart_view').show();

        $('#during_date').html($('#SDate').val() + "~" + $('#EDate').val());

      }
      else {

        //document.getElementById("term-chart").innerHTML = "";
        //검색창 닫기
        click_close();

      }

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
			response.Write "	$('#iMatchTitle').val('"&Request("iMatchTitle")&"');"
			response.Write "	chart_view();"
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
      <li> <a href="javascript:onSubmitStat('../Stats/stat-record.asp');" class="btn counsel on">전적</a> </li>
      <li> <a href="javascript:onSubmitStat('../Stats/stat-match-point.asp');" class="btn counsel">대회득실점</a> </li>
      <li> <a href="javascript:onSubmitStat('../Stats/stat-relativity-get.asp');" class="btn counsel">상대성</a> </li>
      <!--
      <li> <a href="../Stats/stat-match-point.asp" class="btn counsel">대회득실점</a> </li>
      <li> <a href="../Stats/stat-relativity-get.asp" class="btn counsel">상대성</a> </li>
      <li> <a href="../Stats/stat-record.asp" class="btn counsel on">전적</a> </li>
      -->
      <!--//<li>
          <a href="../Stats/weight-in-record.asp" class="btn">대회별 계체기록</a>
        </li>-->
    </ul>
  </div>
  <div class="mid-cat">
    <ul class="rank-mid menu-list clearfix">
      <li><a href="../Stats/stat-record.asp">선수 프로필</a></li>
      <li><a href="javascript:onSubmitStat('../Stats/stat-win.asp');" class="on">입상현황</a></li>
      <li><a href="javascript:onSubmitStat('../Stats/stat-film.asp');">대회영상모음</a></li>
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
            <!-- <select name="iMatchTitle" id="iMatchTitle" onChange="javascript:iMatch_chg();"> -->
            <select name="iMatchTitle" id="iMatchTitle" onChange="">
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
<!-- S: main stat-record -->
<div class="main stat-record stat-win-chart" id="chart_view" style="display: none;">
  <!-- S: term-record-chart -->
  <div class="term-record-chart">
    <h3>기간별 입상내역</h3>
    <div id="term-chart"></div>
  </div>
  <!-- E: term-record-chart -->
  <!-- S: detail-win -->
  <section class="detail-win">
    <h3><a href=".match-summary" data-toggle="collapse">상세 입상현황보기<span class="deco-icon"><img src="http://img.sportsdiary.co.kr/sdapp/stats/detail-caret@3x.png" alt></span></a></h3>
    <ul class="match-summary collapse" id="sub_table1">
    </ul>
  </section>
  <!-- E: detail-win -->
  <!-- E: 대회기록 best-win -->
</div>
<!-- E: main stat-record -->
<!-- S: footer -->
<div class="footer light-footer">
  <!-- S: bottom-menu -->
  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- E: bottom-menu -->
</div>
<!-- E: footer -->
<!-- S: 영상보기 모달 modal -->
<div class="modal fade film-modal" id="show-score" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false">
  <div class="modal-backdrop fade in"></div>
  <div id="detailScore" style="display:block;"> </div>
</div>
<!-- S: 단체전 영상보기 모달 modal -->
<div class="modal fade round-res in groups-res" id="groupround-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="false">
  <div class="modal-backdrop fade in"></div>
  <div class="modal-dialog" id="detailScore_Team"> </div>
  <!-- modal-dialog -->
</div>
<!-- E: 단체전 영상보기 모달 modal -->

<a href="#" data-target="#ana-medal-list" data-toggle="modal" class="init_btn"></a>
<!-- S: Modal 입상현황 팝업 -->
<div class="modal fade in confirm-modal record-notice" id="ana-medal-list" tabindex="-1" role="dialog" aria-hidden="true" style="display:none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">알림</h4>
      </div>
      <div class="modal-body">
        <div class="modal-notice">
          <div class="ic-medal"> <span class="golden">금메달</span> <span class="silver">은메달</span> <span class="bronze">동메달</span> </div>
          경기결과를 클릭하시면<br />
          해당 경기 영상을 보실 수 있습니다. </div>
      </div>
      <form name="notice_form">
        <div class="modal-footer">
          <label class="img-replace" onClick="inputExc($(this));">
            <input id="chk_day_STAT" type="checkbox" />
            <span>오늘 하루 보지 않기</span> </label>
          <button type="button" class="btn btn-default" data-dismiss="modal" onClick="closePop('STAT');">닫기</button>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- E: Modal 입상현황 팝업 -->
<!-- S: bot-config -->
<!-- #include file= "../include/bot_config.asp" -->
<!-- E: bot-config -->
<script type="text/javascript">
    // 알림 모달
    if (getCookie("STAT") != "done"){
      $('.init_btn').click();
    }
    $('.detail-win h3 a').click(function(){
      $(this).toggleClass('on');
    });

    var iNowYear = new Date();
    //alert(iNowYear.getFullYear());
    $('#iyear').val(iNowYear.getFullYear());
    iYear_chg(iNowYear.getFullYear());

  </script>
</body>
