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

  // ASP 로 처리 - 사용 안함
  function iYear_fn()
  {
    var dt = new Date();
    var iyear1 = dt.getFullYear();
    var iyear1_no = iyear1 - 2016;

    for (var i = 1; i < iyear1_no + 1 ; i++) {
      var frm = document.s_frm;
      var op = new Option();
      op.value = 2016 + i; // 값 설정
      op.text = 2016 + i + "년"; // 텍스트 설정

      //op.selected = true; // 선택된 상태 설정 (기본값은 false이며 선택된 상태로 만들 경우에만 사용)

      frm.iyear.options.add(op); // 옵션 추가
    }
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
    if (iDate.value == "0000") {
      iSDate = "";
      iEDate = "";
    }
    var iGameTitleIDX = document.getElementById('iMatchTitle');

    var strAjaxUrl = "../Ajax/analysis-match-result.asp";
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

  function iResult_Total() {

    var iDate = document.getElementById('isvYear');
    var iSDate = iDate.value + "-01-01";
    var iEDate = iDate.value + "-12-31";
    if (iDate.value == "0000") {
      iSDate = "";
      iEDate = "";
    }
    var iGameTitleIDX = document.getElementById('iMatchTitle');

    var strAjaxUrl = "../Ajax/analysis-match-result-total.asp";
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
          $('#iResultTotal').html(retDATA);
        } else {
          $('#iResultTotal').html("");
        }
      },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
    });

  }

  function iResult_NowYear() {

    var iDate = document.getElementById('isvYear');
    var iSDate = iDate.value + "-01-01";
    var iEDate = iDate.value + "-12-31";
    if (iDate.value == "0000") {
      iSDate = "";
      iEDate = "";
    }
    var iGameTitleIDX = document.getElementById('iMatchTitle');

    var strAjaxUrl = "../Ajax/analysis-match-result-nowyear.asp";
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
          $('#iResultNowYear').html(retDATA);
        } else {
          $('#iResultNowYear').html("");
        }
      },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
    });

  }

  function iGameResult() {

    var iDate = document.getElementById('isvYear');
    var iSDate = iDate.value + "-01-01";
    var iEDate = iDate.value + "-12-31";
    if (iDate.value == "0000") {
      iSDate = "";
      iEDate = "";
    }
    var iGameTitleIDX = document.getElementById('iMatchTitle');

    var strAjaxUrl = "../Ajax/analysis-match-result-gameresult.asp";
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
      },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
    });

  }

  function iSkillResult() {

    var iDate = document.getElementById('isvYear');
    var iSDate = iDate.value + "-01-01";
    var iEDate = iDate.value + "-12-31";
    if (iDate.value == "0000") {
      iSDate = "";
      iEDate = "";
    }
    var iGameTitleIDX = document.getElementById('iMatchTitle');

    var strAjaxUrl = "../Ajax/analysis-match-result-skillresult.asp";
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
      },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
    });

  }


  function chart_time() {

    var iDate = document.getElementById('isvYear');
    var iSDate = iDate.value + "-01-01";
    var iEDate = iDate.value + "-12-31";
    if (iDate.value == "0000") {
      iSDate = "";
      iEDate = "";
    }
    var iGameTitleIDX = document.getElementById('iMatchTitle');

    var strJsonUrl = "../Json/analysis-match-result.asp?SDate=" + iSDate + "&EDate=" + iEDate + "&iPlayerIDX=" + iPlayerIDX + "&GameTitleIDX=" + iGameTitleIDX.value;

    FusionCharts.ready(function () {
      //Creating a new inline theme.
      //You can move this entire code block to a separate file, and load.
      FusionCharts.register('theme', {
        name: 'fire',
        theme: {
          base: {
            chart: {
              paletteColors: '#FF4444, #FFBB33, #99CC00, #33B5E5, #AA66CC',
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


  function chart_view() {
    //alert(input_KeyWordYN);

    //alert(iPlayerIDX);

    iUser();

    //alert(iUserData);
    //alert(iPlayerIDX + ', '+input_KeyWordYN);

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
      alert("같은 검색어로 검색된 선수가 두 명 이상입니다.\r\n선택해 주세요.");
      //view_keyword();

    }
    else if ((iUserDataCnt > 1 && input_KeyWordYN == "1") || (iUserDataCnt == 1))  {

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

      table_ajax();

      iResult_Total();

      iResult_NowYear();

      iGameResult();

      iSkillResult();

      chart_time();

      //검색창 닫기
      click_close();
      $('.bg-inst').hide();

      //차트부분 보이기
      $('#chart_view').show();


    }
    else if (iSelUser == "1") {

      //alert(iPlayerIDX);

      input_KeyWordYN = "0";

      iSelUser = "0";

      clicksearch = 0;

      table_ajax();

      iResult_Total();

      iResult_NowYear();

      iGameResult();

      iSkillResult();

      chart_time();

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
    'IF request("iyear")  = "0000" or request("iyear")  = "" Then
    IF request("iyear")  = "" Then
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
    //alert('<%=Request("hdPIDX") %>');
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
        <li><a href="javascript:onSubmitStat('./analysis-match-result.asp');" class="on">선수 프로필</a></li>
        <li><a href="javascript:onSubmitStat('./analysis-win.asp');">입상현황</a></li>
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
      <dl class="clearfix">
        <dt>년도</dt>
        <dd>
          <select name="iyear" id="iyear" onChange="javascript:iYear_chg(this.options[this.selectedIndex].value);">
            <option value="0000">전체</option>
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
            <select name="iMatchTitle" id="iMatchTitle">
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
    <div class="btn-list">
      <a href="#" class="btn-left btn btn-close">닫기</a>
      <a href="javascript:chart_view();" class="btn-right btn">조회</a>
    </div>
  </div>
  </form>
  <!-- E: record-input -->

  <!-- S: tail -->
  <div class="tail bg-tail">
  <!--<div class="tail short-tail">-->
    <a href="javascript:click_open();"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a>
    <a href="#" ><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" alt="닫기"></a>
  </div>
  <!-- E: tail -->

<!--   S: record-bg
<div class="record-bg">
  <div class="record-intro">
    <h2><strong>상대선수의 정보</strong>를<br>쉽고 빠르게 확인하세요!</h2>
  </div>
  <div class="bottom-logo">
    <span class="logo-img">
      <img src="../images/include/gnb/bottom_logo@3x.png" alt="스포츠다이어리 유도협회">
    </span>
  </div>
</div>
E: record-bg -->


  <!-- S: main stat-record -->
  <div class="main stat-record" id="chart_view" style="display: none;">


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
        <dd>조회된 데이터가 없습니다.</dd>
      </dl>
    </section>
      <!-- E: 최근 경기이력 best-win -->


      <!-- S: 대회기록 best-win -->
      <section class="record best-win">
      <h3>대회기록</h3>
      <h4>기술별 득실점</h4>
      <!-- S: between-chart -->
      <div class="between-chart container" id="iSkillResult">
        조회된 데이터가 없습니다.
      </div>
      <!-- E: between-chart -->

      <!-- S: time-record-chart -->
      <div class="time-record-chart">
        <h3>시간대별 득실점</h3>
        <div id="time-record-chart"></div>
        <p class="no-apply-txt">※복식의 경우 파트너를 포함한 팀의 득실점 데이터로 합산되어 나타납니다.</p>
      </div>
      <!-- E: time-record-chart -->
    </section>
      <!-- E: 대회기록 best-win -->



    </div>

  </div>
  <!-- E: main stat-record -->


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

  	var EnterType = '<%=EnterType%>';

  	//EnterType = "K";

  	if (EnterType == "E" || EnterType == "A") {
  		$("#iEnterType").val(EnterType).prop("selected", true);
  	}

    var iNowYear = new Date();
    //alert(iNowYear.getFullYear());
    $('#iyear').val(iNowYear.getFullYear());
    iYear_chg(iNowYear.getFullYear());
  </script>

</body>
