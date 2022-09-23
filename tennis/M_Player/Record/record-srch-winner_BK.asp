<!-- #include file="../include/config.asp" -->

<%

	EnterType =  Request.Cookies("EnterType")

%>


<script type="text/javascript">


  var sub_selschgubun = "";
  var sub_iSDate = "";
  var sub_iEDate = "";
  var sub_txtname = "";
  var sub_groupgubun = "";

  var iUserData = "";
  var iPlayerIDX = "";
  var input_KeyWordYN = "0";

  function input_KeyWord(word, idx) {

    //alert(word + ', ' + idx);

    $("#fnd_KeyWord").val(word);
    iPlayerIDX = idx;
    input_KeyWordYN = "1";
  }

  function iUser() {

    //var list = document.getElementById("group-list");
    //var ischgubun = document.getElementById('schgubun');
    //var iDate = document.getElementById('iyear');
    //var iSDate = iDate.value + "-01-01";
    //var iEDate = iDate.value + "-12-31";
    //var ifnd_KeyWord = $("#fnd_KeyWord").val();
  	var itextno = sub_txtname.length;
  	var iEnterType = $("#iEnterType").val();

    //alert(sub_iSDate + ', ' + sub_iEDate + ', ' + sub_selschgubun + ', ' + sub_txtname);

    if (itextno > 0) {
      var strAjaxUrl = "../Ajax/Record-Search-UserName_Sch.asp";
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        async: false,
        data: {
          SDate: sub_iSDate,
          EDate: sub_iEDate,
          Schgubun: sub_selschgubun,
          Fnd_KeyWord: sub_txtname,
          EnterType: iEnterType
        },
        success: function (retDATA) {
          //alert(retDATA);
          iUserData = retDATA;
      }, error: function (xhr, status, error) {
          if (error != '') {
              alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
          }
      }
      });
    }

  }

  function view_keyword() {

    var list = document.getElementById("group-list");
    var ischgubun = document.getElementById('schgubun');
    var iDate = document.getElementById('iyear');
    var iSDate = iDate.value + "-01-01";
    var iEDate = iDate.value + "-12-31";
    var ifnd_KeyWord = $("#fnd_KeyWord").val();
    var itextno = ifnd_KeyWord.length;
    var iEnterType = $("#iEnterType").val();

    var strAjaxUrl = "../Ajax/Record-Search-UserName.asp";

    if (itextno > 0) {

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          SDate: iSDate,
          EDate: iEDate,
          Schgubun: ischgubun.value,
          Fnd_KeyWord: ifnd_KeyWord,
          EnterType: iEnterType
        },
        success: function (retDATA) {

          //alert(retDATA);
          $("#group-list").html(retDATA);

        }, error: function (xhr, status, error) {
          if (error != '') {
            alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
          }
        }
      });

    }
    else if (itextno == 0) {
      $("#group-list").html("");
    }


  }

  function fn_schgubun() {

    $("#fnd_KeyWord").val('');
    $("#group-list").html("");

  }

  function isearch_validation() {

    if (sub_selschgubun == "") {
      alert("선수/소속을 선택해 주세요.");
      $('.bg-inst').show();
      return false;
    }
    else if (sub_txtname == "") {
      alert("선수명/소속명을 입력해 주세요.");
      $('.bg-inst').show();
      return false;
    }
    else {
      $('.bg-inst').hide();
      return true;
    }

  }

  function iSearch_Click() {

    var iDate = document.getElementById('iyear');
    sub_iSDate = iDate.value + "-01-01";
    sub_iEDate = iDate.value + "-12-31";
    sub_groupgubun = document.getElementById('groupgubun').value;
    sub_selschgubun = document.getElementById('schgubun').value;
    sub_txtname = $("#fnd_KeyWord").val();

    //alert(sub_selschgubun);

    if (sub_selschgubun == "schteam") {

      if (isearch_validation() == false) {

        $('.bg-inst').show();
        $('#iTotal_Main').hide();
      }
      else {

        $('.bg-inst').hide();
        $('#iTotal_Main').show();

        fn_itable_Team(sub_txtname);

        $('#click_close').click();
      }

    }
    else {

      //alert('1');

      iUser();

      //alert('2');

      var iUserDataT = iUserData.split("^");
      var iUserDataCnt = Number(iUserDataT[0]);

      //alert(iUserDataCnt + ', ' + input_KeyWordYN);

      if (isearch_validation() == false) {

        $('.bg-inst').show();
        $('#iTotal_Main').hide();

      }
      else if (iUserDataCnt == 0) {
        $('.bg-inst').show();
        $('#iTotal_Main').hide();
        alert("조회된 선수가 없습니다.");
      }
      else if (iUserDataCnt > 1 && input_KeyWordYN == "0") {
        $('.bg-inst').show();
        $('#iTotal_Main').hide();
        alert("같은 검색어로 검색된 선수가 두명 이상 입니다.\r\n선택해 주세요.");
      }
      else if ((iUserDataCnt > 1 && input_KeyWordYN == "1") || (iUserDataCnt == 1)) {

        $('.bg-inst').hide();
        $('#iTotal_Main').show();

        input_KeyWordYN = "0";


        //json통신 url parameter

        if (iPlayerIDX == "") {
          iPlayerIDX = iUserDataT[1];
        }
        else if (iPlayerIDX != iUserData && iUserDataCnt == 1) {
          iPlayerIDX = iUserDataT[1];
        }

        fn_itable_User(iPlayerIDX);

        $('#click_close').click();

      }

    }



  }

  function fn_itable_User(ia) {

    //alert('TEXT : ' +ia);

    var iGroupGameGb = sub_groupgubun;
    var iTeamGb = "";
    var iLevel = "";

    var strAjaxUrl = "../Ajax/record-srch-winner.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: sub_iSDate,
        EDate: sub_iEDate,
        GroupGameGb: iGroupGameGb,
        TeamGb: iTeamGb,
        Level: iLevel,
        Selschgubun: sub_selschgubun,
        Txtname: ia
      },
      success: function (retDATA) {
        //alert(retDATA);
        if (retDATA) {
          $('#iTotal_Main').html(retDATA);
        } else {
          $('#iTotal_Main').html("");
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }

  function fn_itable_Team(ia) {

    //alert('TEXT : ' + ia);

    var iGroupGameGb = sub_groupgubun;
    var iTeamGb = "";
    var iLevel = "";

    var strAjaxUrl = "../Ajax/record-srch-winner.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: sub_iSDate,
        EDate: sub_iEDate,
        GroupGameGb: iGroupGameGb,
        TeamGb: iTeamGb,
        Level: iLevel,
        Selschgubun: sub_selschgubun,
        Txtname: ia
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iTotal_Main').html(retDATA);
        } else {
          $('#iTotal_Main').html("");
        }
  }, error: function (xhr, status, error) {
      if (error != '') {
          alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
      }
  }
    });

  }
</script>
<body class="lack-bg">
  <a href="#" data-target="#record-notice" data-toggle="modal" class="init_btn"></a>
	
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
    <div class="mid-cat">
      <ul class="record-mid menu-list clearfix">
        <li><a href="record-srch-win.asp">체급별 입상현황</a></li>
        <li><a href="record-srch-weight.asp">대회별 입상현황</a></li>
        <li><a href="record-srch-winner.asp" class="on">입상자(소속)조회</a></li>
      </ul>
  </div>
  <!-- E: record-menu -->

  <!-- S: include record-bg -->
  <!-- #include file = "intro-bg-up-4.asp" -->
  <!-- E: include record-bg -->

  <!-- S: record-input -->
  <div class="record-input bg-ipt" id="sbox">
    <!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 -->
      <dl class="clearfix">
        <dt>기간</dt>
        <dd>
          <select name="iyear" id="iyear">
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
          <select name="iEnterType" id="iEnterType">
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
        <dd>
          <div class="sel-date srch-condi flex-2">
            <select id="groupgubun">
              <option value="">전체</option>
              <option value="sd040001">개인전</option>
              <option value="sd040002">단체전</option>
            </select>
          </div>
        </dd>
      </dl>
      <!-- E: 경기방식 -->
      <!-- S: 선수소속 -->
      <dl class="clearfix">
        <dt>선수/소속</dt>
        <dd>
          <select name="schgubun" id="schgubun" onChange="javascript:fn_schgubun();">
            <!--<option value="">::선수/소속 선택::</option>-->
            <option value="schuser">선수</option>
            <option value="schteam">소속</option>
          </select>
        </dd>
      </dl>
      <!-- <dl class="clearfix">
        <dt>선수/소속</dt>
        <dd class="game-type">
          <label><input type="radio" name="name-type" checked><span>선수명</span></label>
        </dd>
        <dd class="game-type">
          <label><input type="radio" name="name-type"><span>소속명</span></label>
        </dd>
      </dl> -->
      <!-- E: 선수소속 -->
      <!-- S: 체급 -->
      <dl class="srch-inpt clearfix">
        <dt>검색</dt>
        <dd class="none-deco">
          <input type="text" placeholder="선수명 or 소속명을 입력하세요" onKeyUp="view_keyword();" name="fnd_KeyWord" id="fnd_KeyWord" class="has-sub" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" />
            <ul class="srch-inpt dropdown-menu" role="menu" id="group-list">
              <li><a href="">:: 선수 선택 ::</a></li>
            </ul>
        </dd>
      </dl>
      <!-- E: 체급 -->
    </div>
    <!-- E: sel-list -->
    <div class="btn-list">
      <a href="javascript:;" class="btn-left btn btn-close">닫기</a>
      <a href="javascript:;" onClick="javascript:iSearch_Click();" class="btn-right btn btn-srch">조회</a>
    </div>
  </div>
  <!-- S: tail -->
  <div class="tail bg-tail">
    <a href="javascript:;"><img src="../images/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a>
    <a href="javascript:;"><img src="../images/record/open-tail@3x.png" id="click_close" alt="닫기"></a>
  </div>
  <!-- E: tail -->
  <!-- E: record-input -->



  <!-- S: winner-state -->
  <div class="winner-state state-cont" style="display:none;" id="iTotal_Main">

  </div>
  <!-- E: winner-state -->


  <!-- S: modal -->
  <!-- #include file="./record-film-detail.asp" -->
  <!-- E: modal -->


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
            <input id="chk_day_RECORDWINNER" type="checkbox" />
            <span>오늘 하루 보지 않기</span>
          </label>
          <button type="button" class="btn btn-default" data-dismiss="modal" onClick="closePop('RECORDWINNER');">닫기</button>
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
  <script>
    //$('.init_btn').click();
	if (getCookie("RECORDWINNER") != "done"){
     $('.init_btn').click();
    }
  </script>
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
  	//iYear_chg(iNowYear.getFullYear());

    var EnterType = '<%=EnterType%>';

    //EnterType = "K";

    if (EnterType == "E" || EnterType == "A") {
    	$("#iEnterType").val(EnterType).prop("selected", true);
    }

  </script>

</body>
