<!-- #include file="../include/config.asp" -->

<%

	EnterType =  Request.Cookies("EnterType")

%>

<!-- google chart -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- fusionchart api -->
<script src="../js/library/fusioncharts.js"></script>
<script src="../js/library/fusioncharts.theme.fint.js"></script>
<script src="../js/library/fusioncharts.charts.js"></script>
<script type="text/javascript">

	function iEnterType_chg() {

		var iyear = document.getElementById('iyear').value;
		iYear_chg(iyear);

	}

  var clicksearch = 0;

  //var Now = new Date();
  //var iYear = Now.getFullYear();

  var iUserData = "";
  var input_KeyWordYN = "0";
  var iPlayerIDX = "";
  var iSelUser = "0";

  // $('input.has-sub').dropdown();

  function input_KeyWord(word, idx) {
    var iinput = $("#fnd_KeyWord").val(word);
    iPlayerIDX = idx;
    //alert(iPlayerIDX);
    input_KeyWordYN = "1";
    iSelUser = "1";
    $('#hdPIDX').val(idx);
  }

  function iUser() {

    var iSDate = document.getElementById('isvYear');
    var iGameTitleIDX = document.getElementById('iMatchTitle');
    var fnd_KeyWord = $("#fnd_KeyWord").val();
    var itextno = fnd_KeyWord.length;

    var iEnterType = $("#iEnterType").val();

    if (itextno > 0) {
      var strAjaxUrl = "../Ajax/analysis-Search-UserName_Sch_A.asp";
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        async: false,
        data: {
          SDate: iSDate.value,
          GameTitleIDX: iGameTitleIDX.value,
          fnd_KeyWord: fnd_KeyWord,
          EnterType: iEnterType
        },
        success: function (retDATA) {
          iUserData = retDATA;
          //alert(iUserData);
          //return iUserData;
        },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
      });
    }

  }

  function iYear_chg(year) {

    iMatch_chg();

    var SDate = year;
    document.getElementById('isvYear').value = SDate;

    var iEnterType = document.getElementById('iEnterType').value;

    //alert(iEnterType)

    var strAjaxUrl = "../Ajax/analysis-Search-MatchTitle.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
      	SDate: SDate,
      	EnterType: iEnterType
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#sub_table').html(retDATA);
        } else {
          $('#sub_table').html("");
        }
      },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
    });

  }

  function iMatch_chg() {
    $("#fnd_KeyWord").val("");
    $("#group-list").html("");
  }

  function view_keyword() {

    var list = document.getElementById("group-list");
    var iSDate = document.getElementById('isvYear');
    var iGameTitleIDX = document.getElementById('iMatchTitle');
    var fnd_KeyWord = $("#fnd_KeyWord").val();
    var itextno = fnd_KeyWord.length;

    var iEnterType = $("#iEnterType").val();

    var strAjaxUrl = "../Ajax/analysis-Search-UserName_A.asp";

    if (itextno > 0) {

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          SDate: iSDate.value,
          GameTitleIDX: iGameTitleIDX.value,
          fnd_KeyWord: fnd_KeyWord,
          EnterType: iEnterType
        },
        success: function (retDATA) {

          $("#group-list").html(retDATA);

        },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
      });

    }
    else if (itextno == 0) {
      $("#group-list").html("");
    }

    //$('#fnd_KeyWord').val('');
    $('#hdPIDX').val('');

  }

  function isearch_val() {

    var iYearvalue = $('#iMatchTitle').val();
    //var iMatchvalue = $('#iMatchTitle').val();
    var iUservalue = $('#fnd_KeyWord').val();

    if (iYearvalue == "") {
      alert("년도 부터 선택 해 주세요.");
      return false;
    }
    else if (iUservalue == "") {
      alert("선수명을 입력 해 주세요.");
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

    //alert(iSDate + "," + iPlayerIDX + "," + iEDate + "," + iGameTitleIDX.value);
    //alert(iPlayerIDX);

    var strAjaxUrl = "../Ajax/analysis-win-sub.asp";
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
      },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
    });

  }

  function iMovieLink(link1, link2) {
    //alert(link1 + "," + link2);

    //alert(iSDate + "," + iPlayerIDX + "," + iEDate + "," + iGameTitleIDX.value);
    //alert(iPlayerIDX);
    history.pushState({ page: 1, name: '팝업' }, '', '?modal');

    if (link2 == "sd040001") {
      var strAjaxUrl = "../Ajax/analysis-DetailScore-Sch.asp";
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
        },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
      });
    }
    else {

      var strAjaxUrl = "../Ajax/analysis-DetailScore-Sch-Team.asp";

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
        },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
      });

    }

  }


  function chart_view() {

    //alert(input_KeyWordYN);

    //alert($('#isvYear').val());

    iUser();

    //alert(iUserData);

    var iUserDataT = iUserData.split("^");
    var iUserDataCnt = Number(iUserDataT[0]);

    //alert(iUserDataCnt+","+input_KeyWordYN);

    if (isearch_val() == false) {

      fn_nodata();
      //$('#fnd_KeyWord').val('');
      $('#hdPIDX').val('');

    }
    else if (iUserDataCnt == 0) {

      fn_nodata();
      //$('#fnd_KeyWord').val('');
      $('#hdPIDX').val('');
      alert("조회된 선수가 없습니다.");
      //$("#fnd_KeyWord").val("");
      //$("#fnd_KeyWord").focus();
      return;

    }
    else if (iUserDataCnt > 1 && input_KeyWordYN == "0" && iSelUser == "0") {

      fn_nodata();
      //$('#fnd_KeyWord').val('');
      $('#hdPIDX').val('');
      alert("같은 검색어로 검색된 선수가 두명 이상\r\n입니다. 선택해 주세요.");
      //view_keyword();

    }
    else if ((iUserDataCnt > 1 && input_KeyWordYN == "1") || (iUserDataCnt == 1)) {

      input_KeyWordYN = "0";

      iSelUser = "0";

      clicksearch = 0;

      if (iPlayerIDX == "") {
        iPlayerIDX = iUserDataT[1];
      }
      else if (iPlayerIDX != iUserData && iUserDataCnt == 1) {
        iPlayerIDX = iUserDataT[1];
      }

      //alert(iPlayerIDX);

      var oiDataYN = "";

      var oiData =
                  [
                    ["Element", "갯수", { role: "style" }]
                    //["금메달", 3, "#ffc21e"],
                    //["은메달", 1, "#bababa"],
                    //["동메달", 1, "#caae90"]
                  ];

      var iDate = document.getElementById('isvYear');
      var iSDate = iDate.value + "-01-01";
      var iEDate = iDate.value + "-12-31";
      var iGameTitleIDX = document.getElementById('iMatchTitle');

      var strAjaxUrl = "../Ajax/analysis-win.asp";

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
            fn_nodata();
            alert("조회된 데이터가 없습니다.");
          }
        },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
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

      }
      else {

        //document.getElementById("term-chart").innerHTML = "";
        //검색창 닫기
        click_close();


      }

    }
    else if (iSelUser == "1") {

      input_KeyWordYN = "0";

      iSelUser = "0";

      clicksearch = 0;

      //alert(iPlayerIDX);

      var oiDataYN = "";

      var oiData =
                  [
                    ["Element", "갯수", { role: "style" }]
                    //["금메달", 3, "#ffc21e"],
                    //["은메달", 1, "#bababa"],
                    //["동메달", 1, "#caae90"]
                  ];

      var iDate = document.getElementById('isvYear');
      var iSDate = iDate.value + "-01-01";
      var iEDate = iDate.value + "-12-31";
      var iGameTitleIDX = document.getElementById('iMatchTitle');

      var strAjaxUrl = "../Ajax/analysis-win.asp";

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
            fn_nodata();
            alert("조회된 데이터가 없습니다.");
          }
        },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
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

      }
      else {

        //document.getElementById("term-chart").innerHTML = "";
        //검색창 닫기
        click_close();

      }

    }

  }

  function fn_nodata() {

    $('.bg-inst').show();
    $('#chart_view').hide();

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
    IF request("iyear")  = "0000" or request("iyear")  = "" Then
    'IF request("iyear")  = "" Then
      response.Write "$('#iyear').val('"&year(date())&"');"
    else
      response.Write "$('#iyear').val('"&request("iyear")&"');"
      End if

    '대회타이틀IDX
    IF request("iMatchTitle")  <> "" Then
    response.Write "$.when( $.ajax(iYear_chg($('#iyear').val()))).then(function() {"
      response.Write "  $('#iMatchTitle').val('"&Request("iMatchTitle")&"');"
      response.Write "});"
    End IF

    IF request("fnd_KeyWord")  <> "" Then response.Write "$('#fnd_KeyWord').val('"&request("fnd_KeyWord")&"');"
    IF request("iMatchTitle") <> "" and request("fnd_KeyWord") <> "" Then
      response.Write "$.when( $.ajax(iYear_chg($('#iyear').val()))).then(function() {"
      response.Write "  $('#fnd_KeyWord').val('"&Request("fnd_KeyWord")&"');"

      if Request("hdPIDX") <> "" then

      response.Write "iSelUser = '1';"
      response.Write "iPlayerIDX = '"&Request("hdPIDX")&"';"

      end if

      response.Write "  chart_view();"
      response.Write "});"
    End IF
    '===========================================================================================================
    %>

     window.onpopstate = function (event) {
            $(".btn.btn-default").click();
             if (history.state == null) {

            } else {
                history.back();
            }
        };


        $('#show-score,#groupround-res').on('shown.bs.modal', function (e) {
            //history.pushState({ page: 1, name: '팝업' }, '', '?modal');
        });


        $('#show-score,#groupround-res').on('hidden.bs.modal', function (e) {

            if (history.state == null) {

            } else {
                history.back();
            }
        });
  });
</script>
<body class="lack-bg">

	<!-- S: sub-header -->
	<div class="sd-header sd-header-sub">
		<!-- #include file="../include/sub_header_arrow.asp" -->
		<h1>선수분석</h1>
		<!-- #include file="../include/sub_header_gnb.asp" -->
	</div>
	<!-- #include file = "../include/gnb.asp" -->
	<!-- E: sub-header -->

<!-- S: record-menu -->
<div class="record-menu analysis-menu">
  <div class="big-cat">
    <ul class="menu-list clearfix">
        <li><a href="javascript:onSubmitStat('./analysis-match-result.asp');" class="btn on">전적</a></li>
        <li><a href="javascript:onSubmitStat('./analysis-match-point.asp');" class="btn">대회득실점</a></li>
        <li><a href="javascript:onSubmitStat('./analysis-relativity-get.asp');" class="btn">상대성</a></li>
    </ul>
  </div>
  <div class="menu-list mid-cat">
    <ul class="rank-mid clearfix" style="display: block;">
      <li><a href="javascript:onSubmitStat('./analysis-match-result.asp');">선수 프로필</a></li>
      <li><a href="javascript:onSubmitStat('./analysis-win.asp');" class="on">입상현황</a></li>
      <li><a href="javascript:onSubmitStat('./analysis-film.asp');">대회영상모음</a></li>
      <li><a href="javascript:onSubmitStat('./analysis-film-fav.asp?videomode=youtube');">대회영상즐겨찾기<span class="icon-on-favorite">★</span></a></li>
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
            <option value="2016">2016년</option>
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
       <!-- S: 회원구분 -->
      <dl class="clearfix">
        <dt>회원구분</dt>
        <dd class="game-type">
          <select name="iEnterType" id="iEnterType" onchange="javascript:iEnterType_chg(this.options[this.selectedIndex].value);">
            <option value="T">:: 전체 ::</option>
            <option value="E">엘리트</option>
            <option value="A">생활체육</option>
          </select>
        </dd>
      </dl>
      <!-- E: 회원구분 -->
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
      <!-- S: 선수명 -->
      <input type="hidden" id="hdPIDX" name="hdPIDX" value="<%=Request("hdPIDX") %>" />
      <dl class="srch-inpt clearfix">
        <dt>선수명</dt>
        <dd class="none-deco">
          <!--<input type="text" placeholder=":: 선수명을 입력해주세요 ::" class="has-sub" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onKeyUp="view_keyword();" name="fnd_KeyWord" id="fnd_KeyWord">-->
          <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" placeholder=":: 선수명을 입력해주세요 ::" class="has-sub" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onKeyUp="view_keyword();" autocomplete="off">
          <ul class="srch-inpt dropdown-menu" role="menu" id="group-list">
          </ul>
        </dd>
      </dl>
      <!-- E: 선수명 -->
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
<div class="main stat-record ana-win" id="chart_view" style="display: none;">
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
            <input id="chk_day_ANALYSIS" type="checkbox" />
            <span>오늘 하루 보지 않기</span> </label>
          <button type="button" class="btn btn-default" data-dismiss="modal" onClick="closePop('ANALYSIS');">닫기</button>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- E: Modal 입상현황 팝업 -->
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
<!-- S: bot-config -->
<!-- #include file= "../include/bot_config.asp" -->
<!-- E: bot-config -->
	<script type="text/javascript">

		var EnterType = '<%=EnterType%>';

		//EnterType = "K";

		if (EnterType == "E" || EnterType == "A") {
			$("#iEnterType").val(EnterType).prop("selected", true);
		}

    // 알림 모달
    if (getCookie("ANALYSIS") != "done"){
     $('.init_btn').click();
    }

    $('.detail-win h3 a').click(function(){
      $(this).toggleClass('on');
    })

    var iNowYear = new Date();
    //alert(iNowYear.getFullYear());
    $('#iyear').val(iNowYear.getFullYear());
    iYear_chg(iNowYear.getFullYear());


  </script>
</body>
