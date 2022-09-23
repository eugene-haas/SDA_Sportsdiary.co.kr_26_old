<!-- #include file="../include/config.asp" -->

<%

	EnterType =  Request.Cookies("EnterType")

%>

<script type="text/javascript">

	function iEnterType_chg() {

		var iyear = document.getElementById('iyear').value;
		iYear_chg(iyear);

	}

	function iYear_chg(year) {

    var SDate = year;
    document.getElementById('iyear').value = SDate;

    var iEnterType = document.getElementById('iEnterType').value;

    var strAjaxUrl = "../Ajax/Record-Search-MatchTitle.asp";
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
      	SDate: SDate,
      	EnterType: iEnterType
      },
      success: function (retDATA) {
        //alert(retDATA);
        if (retDATA) {
          $('#sub_table').html(retDATA);
        } else {
          $('#sub_table').html("");
        }
      }, error: function (xhr, status, error) {
        if (error != "") { alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); return; }
      }
    });

  }


  var sub_seliMatchTitle = "";
  var sub_iSDate = "";
  var sub_iEDate = "";

  function isearch_validation() {

    if (sub_seliMatchTitle == "00") {
      alert("대회명을 선택하세요.");
      return false;
    }
    else {
      return true;
    }

  }


  function iSearch_Click() {

    sub_seliMatchTitle = document.getElementById('iMatchTitle').value;

    var iDate = document.getElementById('iyear');
    sub_iSDate = iDate.value + "-01-01";
    sub_iEDate = iDate.value + "-12-31";

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

      fn_MainTitle();

      $('#chart_view').show();
      $('.bg-inst').hide();
      // alert("조회!")

      $('#click_close').click();
    }
  }

  function fn_MainTitle() {

    var iMatchTitleName = $('#iMatchTitle option:selected').text();

    var iHtml1 = '';

    iHtml1 = '<span>' + iMatchTitleName + '</span>';

    $('#maintitle').html(iHtml1);

  }

  function fn_itable() {

    var strAjaxUrl = "../Ajax/record-srch-weight.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: sub_iSDate,
        EDate: sub_iEDate,
        MatchTitle: sub_seliMatchTitle
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
        <li><a href="record-srch-win.asp">체급별 입상현황</a></li>
        <li><a href="record-srch-weight.asp" class="on">대회별 입상현황</a></li>
        <li><a href="record-srch-winner.asp">입상자(소속)조회</a></li>
      </ul>
    </div>
  </div>
  <!-- E: record-menu -->

  <!-- S: include intro-bg -->
  <!-- #include file = "./intro-bg-up-2.asp" -->
  <!-- E: include intro-bg -->

  <!-- S: record-input -->
  <div class="record-input bg-ipt" id="sbox">
    <!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 -->
      <dl class="clearfix">
        <dt>기간</dt>
        <dd>
          <select class="search-date" name="iyear" id="iyear" onChange="javascript:iYear_chg(this.options[this.selectedIndex].value);">
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
          <select name="iEnterType" id="iEnterType" onChange="javascript:iEnterType_chg(this.options[this.selectedIndex].value);">
            <option value="T">:: 전체 ::</option>
            <option value="E">엘리트</option>
            <option value="A">생활체육</option>
          </select>
        </dd>
      </dl>
      <!-- E: 회원구분 -->
      <!-- S: 경기방식 -->
      <dl class="clearfix">
        <dt>대회명</dt>
        <dd class="game-type">
          <!-- <label><input type="radio" name="game-type"><span>개인전</span></label>
        </dd>
        <dd class="game-type">
          <label><input type="radio" name="game-type"><span>단체전</span></label> -->
          <div id="sub_table">
          <select name="iMatchTitle" id="iMatchTitle">
            <option value="00">::대회명을 선택하세요::</option>
          </select>
          </div>
        </dd>
      </dl>
      <!-- E: 경기방식 -->
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
