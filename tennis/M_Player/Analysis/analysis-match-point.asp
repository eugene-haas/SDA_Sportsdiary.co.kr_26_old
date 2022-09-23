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

  var clicksearch1 = 0;
  var clicksearch2 = 0;

  //$('input.has-sub').dropdown();

  var iUserData = "";
  var input_KeyWordYN = "0";
  var iPlayerIDX = "";
  var iSelUser = "0";

  function iEnterType_chg() {

  	var iyear = document.getElementById('iyear').value;
  	iYear_chg(iyear);

  }

  function input_KeyWord(word,idx) {
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

  function table_ajax(sub_type) {

    //alert(sub_type);

    var iDate = document.getElementById('isvYear');
    var iSDate = iDate.value + "-01-01";
    var iEDate = iDate.value + "-12-31";
    var iGameTitleIDX = document.getElementById('iMatchTitle');

    //alert(iSDate + "," + iPlayerIDX + "," + iEDate + "," + iGameTitleIDX.value);

    var strAjaxUrl = "../Ajax/analysis-match-point.asp";

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
      },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
    });

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

  function chart_view() {

    //alert(input_KeyWordYN);

    iUser();

    var iUserDataT = iUserData.split("^");
    var iUserDataCnt = Number(iUserDataT[0]);
    //alert(iUserDataCnt);

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
      alert("같은 검색어로 검색된 선수가 두명 이상입니다.\r\n선택해 주세요.");
      //view_keyword();

    }
    else if ((iUserDataCnt > 1 && input_KeyWordYN == "1") || (iUserDataCnt == 1)) {

      input_KeyWordYN = "0";
      iSelUser = "0";


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

      //json통신 url parameter

      if (iPlayerIDX == "") {
        iPlayerIDX = iUserDataT[1];
      }
      else if (iPlayerIDX != iUserData && iUserDataCnt == 1) {
        iPlayerIDX = iUserDataT[1];
      }

      //alert(iPlayerIDX);

      var iDate = document.getElementById('isvYear');
      var iSDate = iDate.value + "-01-01";
      var iEDate = iDate.value + "-12-31";
      var iGameTitleIDX = document.getElementById('iMatchTitle');

      var strJsonUrl = "../Json/analysis-match-point.asp?SDate=" + iSDate + "&EDate=" + iEDate + "&GameTitleIDX=" + iGameTitleIDX.value + "&PlayerIDX=" + iPlayerIDX;
      //alert(strJsonUrl);

      FusionCharts.ready(function () {
        var demographicsChart = new FusionCharts({
          type: 'msbar3d',
          renderAt: 'match-total-chart',
          width: '100%',
          height: '300',
          dataFormat: 'jsonurl',
          dataSource: strJsonUrl
        }).render();
      });

      //검색창 닫기
      click_close();
      $('.bg-inst').hide();

      //차트부분 보이기
      $('#chart_view').show();

    }
    else if (iSelUser == "1") {

      input_KeyWordYN = "0";

      iSelUser = "0";

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


      //alert(iPlayerIDX);

      var iDate = document.getElementById('isvYear');
      var iSDate = iDate.value + "-01-01";
      var iEDate = iDate.value + "-12-31";
      var iGameTitleIDX = document.getElementById('iMatchTitle');

      var strJsonUrl = "../Json/analysis-match-point.asp?SDate=" + iSDate + "&EDate=" + iEDate + "&GameTitleIDX=" + iGameTitleIDX.value + "&PlayerIDX=" + iPlayerIDX;
      //alert(strJsonUrl);

      FusionCharts.ready(function () {
        var demographicsChart = new FusionCharts({
          type: 'msbar3d',
          renderAt: 'match-total-chart',
          width: '100%',
          height: '300',
          dataFormat: 'jsonurl',
          dataSource: strJsonUrl
        }).render();
      });

      //검색창 닫기
      click_close();
      $('.bg-inst').hide();

      //차트부분 보이기
      $('#chart_view').show();

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
			response.Write "	$('#iMatchTitle').val('"&Request("iMatchTitle")&"');"
			response.Write "});"
		End IF

		IF request("fnd_KeyWord")  <> "" Then response.Write "$('#fnd_KeyWord').val('"&request("fnd_KeyWord")&"');"
		IF  request("iyear") <> "" and request("iMatchTitle") <> "" and request("fnd_KeyWord") <> "" Then
			response.Write "$.when( $.ajax(iYear_chg('"&request("iyear")&"'))).then(function() {"
			response.Write "	$('#fnd_KeyWord').val('"&Request("fnd_KeyWord")&"');"

			if Request("hdPIDX") <> "" then

			response.Write "iSelUser = '1';"
			response.Write "iPlayerIDX = '"&Request("hdPIDX")&"';"

			end if

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
		<h1>선수분석</h1>
		<!-- #include file="../include/sub_header_gnb.asp" -->
	</div>
	<!-- #include file = "../include/gnb.asp" -->
<!-- E: sub-header -->

  <!-- S: record-menu -->
  <div class="record-menu analysis-menu">
    <div class="big-cat">
      <ul class="menu-list clearfix">
        <li><a href="javascript:onSubmitStat('./analysis-match-result.asp');" class="btn">전적</a></li>
        <li><a href="javascript:onSubmitStat('./analysis-match-point.asp');" class="btn on">대회득실점</a></li>
        <li><a href="javascript:onSubmitStat('./analysis-relativity-get.asp');" class="btn">상대성</a></li>
      </ul>
    </div>
    <div class="menu-list mid-cat">
      <ul class="record-mid clearfix" style="display: block;">
        <li><a href="javascript:onSubmitStat('./analysis-match-point.asp');" class="on">점수별</a></li>
        <li><a href="javascript:onSubmitStat('./analysis-match-skill.asp');">기술별</a></li>
        <li><a href="javascript:onSubmitStat('./analysis-match-time.asp');">시간대별</a></li>
      </ul>
    </div>
  </div>
  <!-- E: record-menu -->

  <!-- S: include intro-bg -->
  <!-- #include file ="./intro-bg.asp" -->
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

  <!-- S: state-cont -->
  <div class="state-cont" id="chart_view" style="display:none;">
   <div class="chart-tab container clearfix">
      <a href="javascript:click_tab('totalpoint');" class="on" id="itotalpoint">전체</a>
      <a href="javascript:click_tab('pluspoint');" id="ipluspoint">득점</a>
      <a href="javascript:click_tab('minuspoint');" id="iminuspoint">실점</a>
    </div>

    <!-- S: 전체 차트 -->
    <div id="ichart">
    <section class="stat-chart train-place container">
      <div class="chart-title">
        <h3>점수별 전체 득실점</h3>
      </div>
      <div class="relativity-chart">
        <!--<p class="unit">k(단위):1,000</p>-->
        <div id="match-total-chart"></div>
        <!-- <div class="chart-guide">
          <ul class="flex">
            <li><a href="#">득점</a></li>
            <li><a href="#">실점</a></li>
          </ul>
        </div> -->
      </div>
    </section>
    </div>
    <!-- E: 전체 차트 -->

    <!-- S: 득점 -->
    <div id="itable">
    <section class="stat-chart train-place">
      <div class="chart-title">
        <h3>점수별 기술구사</h3>
      </div>
      <div class="point-gain-chart container" id="sub_table1">
      </div>
      <p class="no-apply-txt">※지도는 기술이 아니므로 기술구사 득실점 횟수에 반영되지 않습니다.</p>
    </section>
    </div>
    <!-- E: 득점 -->

    <!-- S: 실점 -->
    <div id="itable1">
      <section class="stat-chart train-place">
      <div class="chart-title">
        <h3>점수별 기술구사</h3>
      </div>
      <div class="point-lost-chart container" id="sub_table2">
      </div>
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
