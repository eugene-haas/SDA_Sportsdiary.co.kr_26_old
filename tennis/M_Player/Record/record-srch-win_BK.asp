<!-- #include file="../include/config.asp" -->

<%

  EnterType =  Request.Cookies("EnterType")

%>

<script type="text/javascript">

  function fn_EnterType() {

    fn_iteamgb();

    fn_Ggb();

  }

  function fn_iteamgb() {

    var iEnterType = document.getElementById('iEnterType').value;

    //alert(iEnterType);

    var strAjaxUrl = "../Ajax/Record-Search-TeamGubun.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {

        EnterType: iEnterType

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

  function fn_Ggb() {

    document.getElementById('iteamgb').value = "";
    document.getElementById('ilevelname').value = "";

    var iggb = document.getElementById('igroupgamegb').value;

    //alert(iggb);

    if (iggb == "sd040002") {
      $('#ilevelname').html("<option value=''>:: 소속구분 선택 ::</option>");
    }

  }

  function fn_Level(ia) {

    var iggb = document.getElementById('igroupgamegb').value;

    //alert(iggb);

    if (iggb == "sd040001") {

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
    else {

      $('#ilevelname').html("<option value=''>:: 소속구분 선택 ::</option>");

    }

  }


  var sub_seligroupgamegb = "";
  var sub_seliteamgb = "";
  var sub_selilevelname = "";
  var sub_iSDate = "";
  var sub_iEDate = "";
  var sub_iDate = "";

  function isearch_validation() {

    if (sub_seligroupgamegb == "") {
      alert("경기방식을 선택해 주세요.");
      return false;
    }
    else if (sub_seliteamgb == "") {
      alert("소속구분을 선택해 주세요.");
      return false;
    }
    else if (sub_selilevelname == "" && sub_seligroupgamegb == "sd040001") {
      alert("체급을 선택해 주세요.");
      return false;
    }
    else {
      return true;
    }

  }


  function iSearch_Click() {

    sub_seligroupgamegb = document.getElementById('igroupgamegb').value;
    sub_seliteamgb = document.getElementById('iteamgb').value;
    sub_selilevelname = document.getElementById('ilevelname').value;

    var iDate = document.getElementById('iyear');
    sub_iSDate = iDate.value + "-01-01";
    sub_iEDate = iDate.value + "-12-31";
    sub_iDate = iDate.value;

    if (isearch_validation() == false) {

      $('#iTotal_Intro').show();
      //$('#iTotal_Main').hide();

      $('#chart_view').hide();
      $('.bg-inst').show();
      // alert("미조회!");
    }
    else {

      $('#iTotal_Intro').hide();
      //$('#iTotal_Main').show();

      fn_itable();

      iMaintitle();

      $('#chart_view').show();
      $('.bg-inst').hide();
      // alert("조회!")

      $('#click_close').click();
    }
  }

  function iMaintitle() {

    var igroupgamegbname = $('#igroupgamegb option:selected').text();
    var iteamgbname = $('#iteamgb option:selected').text();
    var ilevelnamename = $('#ilevelname option:selected').text();

    var iHtml1 = '';

    if (igroupgamegbname == '개인전') {
      iHtml1 = '<span>' + sub_iDate + '년</span> / <span>' + igroupgamegbname + '</span> / <span>' + iteamgbname + '</span> / <span>' + ilevelnamename + '</span>';
    }
    else {
      iHtml1 = '<span>' + sub_iDate + '년</span> / <span>' + igroupgamegbname + '</span> / <span>' + iteamgbname + '</span>';
    }

    $('#maintitle').html(iHtml1);

  }


  function fn_itable() {

    var igroupgamegbname = $('#igroupgamegb option:selected').text();
    var iteamgbname = $('#iteamgb option:selected').text();
    var ilevelnamename = $('#ilevelname option:selected').text();

    //alert(igroupgamegbname);

    if (ilevelnamename == ":: 소속구분 선택 ::") {
      ilevelnamename = "";
    }

    var strAjaxUrl = "../Ajax/record-srch-win.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: sub_iSDate,
        EDate: sub_iEDate,
        GroupGameGb: sub_seligroupgamegb,
        TeamGb: sub_seliteamgb,
        Level: sub_selilevelname,
        igroupgamegbname: igroupgamegbname,
        iteamgbname: iteamgbname,
        ilevelnamename: ilevelnamename
      },
      success: function (retDATA) {
        //alert(retDATA);
        if (retDATA) {
          $('#iMainTable').html(retDATA);
        } else {
          $('#iMainTable').html("");
          //fn_null();
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }

  function fn_null() {

    $('#chart_view').hide();
    $('.bg-inst').show();

    alert("조회된 데이터가 없습니다.");

  }

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
  <div class="record-menu run-off">
    <div class="big-cat">
      <ul class="menu-list flex">
        <li><a href="record-srch-win.asp" class="btn on">성적조회</a></li>
        <!-- <li><a href="record-rank.asp" class="btn">순위</a></li> -->
        <li><a href="record-match-rate.asp" class="btn">순위</a></li>
      </ul>
    </div>
    <div class="mid-cat flex">
      <ul class="menu-list clearfix">
        <li><a href="record-srch-win.asp" class="on">체급별 입상현황</a></li>
        <li><a href="record-srch-weight.asp">대회별 입상현황</a></li>
        <li><a href="record-srch-winner.asp">입상자(소속)조회</a></li>
      </ul>
    </div>
  </div>
  <!-- E: record-menu -->

  <!-- S: include intro-bg -->
  <!-- #include file = './intro-bg-up-5.asp' -->
  <!-- E: include intro-bg -->

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
    <!-- S: 회원구분 -->
      <dl class="clearfix">
        <dt>회원구분</dt>
        <dd class="game-type">
          <select name="iEnterType" id="iEnterType" onchange="javascript:fn_EnterType();">
            <option value="T">:: 전체 ::</option>
            <option value="E">엘리트</option>
            <option value="A">생활체육</option>
          </select>
        </dd>
      </dl>
      <!-- E: 회원구분 -->
      <!-- S: 경기방식 -->
      <dl class="clearfix">
        <dt>경기방식</dt>
        <dd class="game-type">
          <!-- <label><input type="radio" name="game-type"><span>개인전</span></label>
        </dd>
        <dd class="game-type">
          <label><input type="radio" name="game-type"><span>단체전</span></label> -->
          <select name="igroupgamegb" id="igroupgamegb" onChange="javascript:fn_Ggb();">
            <option value="">:: 경기방식 선택 ::</option>
            <option value="sd040001">개인전</option>
            <option value="sd040002">단체전</option>
          </select>
        </dd>
      </dl>
      <!-- E: 경기방식 -->
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
      <dl class="clearfix">
        <dt>체급</dt>
        <dd>
          <select name="ilevelname" id="ilevelname">
            <option value="">:: 체급 선택 ::</option>
          </select>
        </dd>
      </dl>
      <!-- E: 체급 -->
    </div>
    <!-- E: sel-list -->
    <div class="btn-list">
      <a href="javascript:;" class="btn-left btn btn-close">닫기</a>
      <a href="javascript:;" onClick="javascript:iSearch_Click();" class="btn-right btn">조회</a>
    </div>
  </div>
  <!-- S: tail -->
  <div class="tail bg-tail">
    <a href="javascript:;"><img src="../images/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a>
    <a href="javascript:;"><img src="../images/record/open-tail@3x.png" id="click_close" alt="닫기"></a>
  </div>
  <!-- E: tail -->
  <!-- E: record-input -->



  <!-- S: win-state -->
  <div class="win-state state-cont" id="chart_view" style="display: none;">
    <h2 id="maintitle"></h2>
    <div id="iMainTable">

    </div>
  </div>
  <!-- E: win-state -->

  <!-- S: modal -->
  <!-- #include file="./record-film-detail.asp" -->
  <!-- E: modal -->

  <a href="#" data-target="#record-notice" data-toggle="modal" class="init_btn"></a>
    <!-- S: record-notice -->
  <div class="modal fade in confirm-modal record-notice" id="record-notice" tabindex="-1" role="dialog" aria-hidden="true" style="display:none;">
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
            <input id="chk_day_RECORDWIN" type="checkbox" />
            <span>오늘 하루 보지 않기</span>
          </label>
          <button type="button" class="btn btn-default" data-dismiss="modal" onClick="closePop('RECORDWIN');">닫기</button>
        </div>
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
     // 알림 모달
    if (getCookie("RECORDWIN") != "done"){
     $('.init_btn').click();
    }
     //$('.init_btn').click();
  </script>


  <script type="text/javascript">
    var iNowYear = new Date();
    //alert(iNowYear.getFullYear());
    $('#iyear').val(iNowYear.getFullYear());
    //iYear_chg(iNowYear.getFullYear());

    var EnterType = '<%=EnterType%>';

    //EnterType = "K";

    if (EnterType == "E" || EnterType == "A") {
      $("#iEnterType").val(EnterType).prop("selected", true);
    }

    fn_iteamgb();

  </script>

</body>
