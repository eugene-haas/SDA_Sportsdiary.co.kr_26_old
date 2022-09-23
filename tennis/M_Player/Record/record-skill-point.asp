<!-- #include file="../include/config.asp" -->
<!-- #include file="../include/config_chart.asp" -->
<!-- google chart -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- fusionchart api -->
<script src="../js/library/fusioncharts.js"></script>
<script src="../js/library/fusioncharts.theme.fint.js"></script>
<script src="../js/library/fusioncharts.charts.js"></script>

<script type="text/javascript">

  var sub_iSDate = "";
  var sub_iEDate = "";
  var sub_iteamgb = "";
  var sub_iteamgbNm = "";
  var sub_ilevelname = "";
  var sub_ilevelnameNm = "";
  var sub_iskilltype = "";
  var sub_iskilltypeNm = "";

  function fn_iteamgb() {

    var strAjaxUrl = "../Ajax/Record-Search-TeamGubun.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {

      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iteamgb').html(retDATA);
        } else {
          $('#iteamgb').html("");
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }

  function fn_iskilltype() {

    var strAjaxUrl = "../Ajax/Record-Search-SkillTypeGubun.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {

      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iskilltype').html(retDATA);
        } else {
          $('#iskilltype').html("");
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }

  function fn_Level(ia) {

    var strAjaxUrl = "../Ajax/Record-Search-LevelGubun.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        Level: ia
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#ilevelname').html(retDATA);
        } else {
          $('#ilevelname').html("");
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }

  function isearch_validation() {

    if (sub_iteamgb == "") {
      alert("소속구분을 선택해 주세요.");
      return false;
    }
    else if (sub_ilevelname == "") {
      alert("체급을 선택해 주세요.");
      return false;
    }
    else if (sub_iskilltype == "") {
      alert("기술명을 선택해 주세요.");
      return false;
    }
    else {
      return true;
    }

  }

  function iSearch_Click() {

    sub_iteamgb = document.getElementById('iteamgb').value;
    sub_iteamgbNm = $('#iteamgb option:selected').text();

    sub_ilevelname = document.getElementById('ilevelname').value;
    sub_ilevelnameNm = $('#ilevelname option:selected').text();

    //alert(sub_ilevelnameNm);

    sub_iskilltype = document.getElementById('iskilltype').value;
    sub_iskilltypeNm = $('#iskilltype option:selected').text();

    var iDate = document.getElementById('iyear');
    sub_iSDate = iDate.value + "-01-01";
    sub_iEDate = iDate.value + "-12-31";

    if (isearch_validation() == false) {

      $('#iTotal_Intro').show();
      $('#iTotal_Main').hide();

      //alert("false");

    }
    else {

      $('#iTotal_Intro').hide();
      $('#iTotal_Main').show();

      //alert("true");

      fn_itable();

    }

  }

  function fn_itable() {

    var iGroupGameGb = "";
    var iTeamGb = "";

    //alert(sub_iskilltypeNm);

    var strAjaxUrl = "../Ajax/record-skill-point.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: sub_iSDate,
        EDate: sub_iEDate,
        GroupGameGb: iGroupGameGb,
        TeamGb: iTeamGb,
        Level: sub_ilevelname,
        TxtName: sub_iskilltype,
        isub_iteamgbNm: sub_iteamgbNm,
        isub_ilevelnameNm: sub_ilevelnameNm,
        isub_iskilltypeNm: sub_iskilltypeNm
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iTotal_Main').html(retDATA);
        } else {
          $('#iTotal_Main').html("");
          fn_NoData();
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }

  function fn_NoData() {

    $('#iTotal_Intro').show();
    $('#iTotal_Main').hide();
    alert("조회된 데이터가 없습니다.");

  }

  fn_iteamgb();

  fn_iskilltype();

</script>
<body class="lack-bg">
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>경기 기록실</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: record-menu -->
  <div class="record-menu">
    <div class="big-cat">
      <ul class="menu-list flex">
                <li><a href="./record-srch-win.asp" class="btn">성적조회</a></li>
                <li><a href="./record-rank.asp" class="btn on">순위</a></li>
            </ul>
    </div>
    <div class="mid-cat">
      <ul class="rank-mid menu-list clearfix">
        <li><a href="record-rank.asp">점수득점</a></li>
        <li><a href="record-skill-point.asp" class="on">기술득점</a></li>
        <li><a href="record-match-rate.asp">경기승률</a></li>
        <li><a href="record-medal-rank.asp">메달순위</a></li>
        <li><a href="record-medal-total.asp">메달합계</a></li>
      </ul>
    </div>
  </div>
  <!-- E: record-menu -->



  <!-- S: record-bg -->
  <div class="record-bg bg-inst" id="iTotal_Intro">
    <div class="record-intro">
      <h2><strong>경기 기록실</strong>에서<br>빠르게 <strong>대회정보</strong>를 확인하세요!</h2>
    </div>
    <div class="bottom-logo">
      <span class="logo-img">
        <img src="http://img.sportsdiary.co.kr/sdapp/gnb/bottom_logo@3x.png" alt="스포츠다이어리 유도협회">
      </span>
    </div>
  </div>
  <!-- E: record-bg -->



  <!-- S: record-input -->
  <div class="record-input bg-ipt" id="sbox">
    <!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 -->
      <dl class="clearfix">
        <dt>기간</dt>
        <dd>
          <select name="iyear" id="iyear">
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
      <!-- S: 소속구분 -->
      <dl class="clearfix">
        <dt>소속구분</dt>
        <dd>
          <select name="iteamgb" id="iteamgb" onChange="javascript:fn_Level(this.options[this.selectedIndex].value);">
            <option value="">:: 소속구분 선택 ::</option>
          </select>
        </dd>
      </dl>
      <!-- E: 소속구분 -->
      <!-- S: 체급 -->
      <dl class="srch-inpt clearfix">
        <dt>체급</dt>
        <dd>
          <select name="ilevelname" id="ilevelname">
            <option value="">:: 체급 선택 ::</option>
          </select>
        </dd>
      </dl>
      <!-- E: 체급 -->
      <!-- S: 기술명 -->
      <dl class="srch-inpt clearfix">
        <dt>기술명</dt>
        <dd>
          <select name="iskilltype" id="iskilltype" class="search-date">
            <option value="">:: 기술명 선택 ::</option>
          </select>
        </dd>
      </dl>
      <!-- E: 기술명 -->
    </div>
    <!-- E: sel-list -->
    <div class="btn-list">
      <a href="javascript:;" class="btn-left btn btn-close">닫기</a>
      <a href="javascript:;" onClick="javascript:iSearch_Click();" class="btn-right btn">조회</a>
    </div>
  </div>
  <!-- S: tail -->
  <div class="tail bg-tail">
    <a href="javascript:;"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a>
    <a href="javascript:;"><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" alt="닫기"></a>
  </div>
  <!-- E: tail -->
  <!-- E: record-input -->




  <!-- S: skill-state -->
  <div class="skill-state state-cont" style="display: none;" id="iTotal_Main">

  </div>
  <!-- E: skill-state -->


  <!-- S: Modal -->
  <!-- #include file= "./record-skill-point-sub.asp" -->
  <!-- E: Modal -->


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


  <a href="#" data-target="#record-notice" data-toggle="modal" class="init_btn"></a>
    <!-- S: record-notice -->
  <div class="modal fade in confirm-modal record-notice" id="record-notice" tabindex="-1" role="dialog" aria-hidden="true" style="display:none">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title">알림</h4>
        </div>
        <div class="modal-body">
          <div class="modal-notice">
            <div class="ic-medal">
              <span class="golden">금메달</span>
              <span class="silver">은메달</span>
              <span class="bronze">동메달</span>
            </div>
            경기결과를 클릭하시면<br />
            해당 경기 영상을 보실 수 있습니다.
          </div>
        </div>
        <form name="notice_form">
        <div class="modal-footer">
          <label class="img-replace" onClick="inputExc($(this));">
            <input id="chk_day_RPOINT" type="checkbox" />
            <span>오늘 하루 보지 않기</span>
          </label>
          <button type="button" class="btn btn-default" data-dismiss="modal" onClick="closePop('RPOINT');">닫기</button>
        </div>
        <script>
          $(document).labelSw('label.img-replace');
        </script>
      </form>

        <!--
        <div class="modal-footer">
          <label class="img-replace"><input type="checkbox"><span>오늘 하루 보지 않기</span></label>
          <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        </div>
        -->

      </div>
    </div>
  </div>
  <!-- E: modal-player-profile -->

  <script type="text/javascript">
    var iNowYear = new Date();
    //alert(iNowYear.getFullYear());
    $('#iyear').val(iNowYear.getFullYear());
    //iYear_chg(iNowYear.getFullYear());

      // 알림 모달
    if (getCookie("RPOINT") != "done"){
     $('.init_btn').click();
    }
  </script>

</body>
