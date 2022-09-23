<!-- #include file="../include/config.asp" -->
<%
 	dim SDate : SDate = Request("SDate")	'검색 시작일
	dim EDate : EDate = Request("EDate")	'검색 종료일
	dim search_date : search_date 	= fInject(Request("search_date"))
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

  // 체력 분포
  function chart_view() {

    if (isearch_val() == false) {

    }
    else {

      $('#sub_chart_total').hide();

      //json통신 url parameter
      var SDate = $('#SDate').val();
      var EDate = $('#EDate').val();
      var strJsonUrl = "../Json/stat-gauge.asp?SDate=" + SDate + "&EDate=" + EDate + "&iMemberIDX=" + iMemberIDX;

      //alert(strJsonUrl);

      FusionCharts.ready(function () {
        var demographicsChart = new FusionCharts({
          type: 'radar',
          renderAt: 'type-chart',
          width: '100%',
          height: '290',
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

  }

  // 체력 분포 서브
  function chart_sub(sub_type, sub_title_name) {

    var iStimFistCd = sub_type;

    $('#sub_chart_total').show();

    //sub_type = fitness,uniform
    //json통신 url parameter
    var SDate = $('#SDate').val();
    var EDate = $('#EDate').val();
    var strJsonUrl = "../Json/stat-gauge-sub.asp?SDate=" + SDate + "&EDate=" + EDate + "&iStimFistCd=" + iStimFistCd + "&iMemberIDX=" + iMemberIDX;

    FusionCharts.ready(function () {
      var fusioncharts = new FusionCharts({
        type: 'bar2d',
        renderAt: 'sub_chart',
        width: '95%',
        height: '160',
        dataFormat: 'jsonurl',
        dataSource: strJsonUrl
      }).render();
    });


    $('#sub_chart_title').html(sub_title_name);
    $('#sub_chart_title').show();

    $('#sub_during_date').show();
    $('#sub_during_date').html($('#SDate').val() + "~" + $('#EDate').val());

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
        <li> <a href="javascript:onSubmit('../Stats/stat-ptrain-place.asp');" class="btn goodth">공식훈련</a> </li>
        <li> <a href="javascript:onSubmit('../Stats/stat-strain-place.asp');" class="btn badth">개인훈련</a> </li>
        <li> <a href="javascript:onSubmit('../Stats/stat-injury-dist.asp');" class="btn my-diary">부상정보</a> </li>
        <li> <a href="javascript:onSubmit('../Stats/stat-gauge.asp');" class="btn counsel on">체력측정결과</a> </li>
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
      <li><a href="javascript:onSubmit('../Stats/stat-gauge.asp');" class="on">종합표</a></li>
      <li><a href="javascript:onSubmit('../Stats/stat-cur-result.asp');">측정 항목별 결과</a></li>
      <li><a href="javascript:onSubmit('../Stats/stat-stamina-rank.asp');">체력랭킹</a></li>
    </ul>
  </div>
  <div class="menu-list small-cat flex"></div>
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
<div class="tail bg-tail"> <a href="javascript:click_open();"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a> <a href="#" ><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" alt="닫기"></a> </div>
<!-- E: tail -->
<!-- S: state-cont -->
<div class="state-cont" id="chart_view" style="display:none;">
  <!-- S: 훈련 장소 stat-chart -->
  <section class="stat-chart stat-gauge">
    <div class="chart-title">
      <h3>체력분포</h3>
      <p id="during_date">2016-07-27~2016-08-03</p>
    </div>
    <div id="type-chart"></div>
    <p class="orangy">*기술유형을 누르시면 상세 현황을 보실 수 있습니다.</p>
    <!-- S: detail-table -->
    <div class="detail-table" id="sub_chart_total">
      <div class="chart-title">
        <h3 id="sub_chart_title" style="display:block;">근력</h3>
      </div>
      <div id="sub_chart"></div>
    </div>
    <!-- E: detail-table -->
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
