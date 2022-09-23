<!-- #include file="../include/config.asp" -->

<%

	EnterType =  Request.Cookies("EnterType")

%>

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

  function fn_EnterType() {

  	fn_iteamgb();

  	fn_Level("");

  }

  function fn_iteamgb() {

  	var iEnterType = document.getElementById('iEnterType').value;

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
      },error: function (xhr, status, error) {
               	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
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
		<%
		'검색조건이 있는경우
		IF request("ilevelname") <>"" Then
			response.Write ",fnd_ilevelname : "&request("ilevelname")
		End IF
		%>
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#ilevelname').html(retDATA);
        } else {
          $('#ilevelname').html("");
        }
      }, error: function (xhr, status, error) {
               	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
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
      //else if (sub_ipointtype == "") {
      //  alert("점수를 선택해 주세요.");
      //  return false;
      //}
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

    //sub_ipointtype = document.getElementById('ipointtype').value;
    //sub_ipointtypeNm = $('#ipointtype option:selected').text();

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

      $('#click_close').click();

    }

  }

  function fn_itable() {

    var iMHtml = "";

    iMHtml = iMHtml + '<span>' + sub_iSDate.substring(0, 4) + '년</span> / <span>' + sub_iteamgbNm + '</span> / <span>' + sub_ilevelnameNm + '</span>';

    $('#iMain_Title').html(iMHtml);

    var iGroupGameGb = "";
    var iTeamGb = "";

    //alert(sub_ilevelname);

    var strAjaxUrl = "../Ajax/record-medal-rank.asp";

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
        isub_iteamgbNm: sub_iteamgbNm,
        isub_ilevelnameNm: sub_ilevelnameNm
      },
      success: function (retDATA) {
        if (retDATA) {
          $('#iTotal_Main_Contents').html(retDATA);
        } else {
          $('#iTotal_Main_Contents').html("");
          fn_null();
        }
      }, error: function (xhr, status, error) {
               	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
				}
            }
    });

  }

  function fn_null() {

    $('#iTotal_Intro').show();
    $('#iTotal_Main').hide();

    alert("조회된 데이터가 없습니다.");

  }

  fn_iteamgb();

  function onSubmit(valUrl){
    $('form[name=s_frm]').attr('action', valUrl);
    $('form[name=s_frm]').submit();
  }

   $(document).ready(function(){
      <%
    '===========================================================================================================
    '페이지 이동시 검색조건이 있는 경우 selected
    '===========================================================================================================
    IF request("iyear") <> "" Then response.Write "$('#iyear').val('"&request("iyear")&"');"
    '===========================================================================================================
	IF request("iteamgb") <> "" Then
		response.Write "$('#iteamgb').val('"&request("iteamgb")&"');"
		response.Write "fn_Level('"&request("iteamgb")&"');"
	End IF
    %>

        window.onpopstate = function (event) {
            $(".close").click();
            if (history.state == null) {

            } else {
                history.back();
            }
        };


        $('.modal.fade').on('shown.bs.modal', function (e) {
            history.pushState({ page: 1, name: '팝업' }, '', '?modal');
        });


        $('.modal.fade').on('hidden.bs.modal', function (e) {

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
    <h1>경기 기록실</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->


<form name="s_frm" method="post">
  <!-- S: record-menu -->
  <div class="record-menu">
    <div class="menu-list big-cat flex">
      <ul class="menu-list flex">
                <li><a href="./record-srch-win.asp" class="btn">성적조회</a></li>
                <li><a href="./record-rank.asp" class="btn on">순위</a></li>
            </ul>
    </div>
    <div class="mid-cat">
      <ul class="rank-mid menu-list clearfix">
        <!-- <li><a href="record-rank.asp" >점수득점</a></li>
        <li><a href="record-skill-point.asp">기술득점</a></li> -->
        <li><a href="javascript:onSubmit('record-match-rate.asp');" >경기승률</a></li>
        <li><a href="javascript:onSubmit('record-medal-rank.asp');" class="on">메달순위</a></li>
        <li><a href="javascript:onSubmit('record-medal-total.asp');">메달합계</a></li>
      </ul>
    </div>
    <div class="menu-list small-cat flex"></div>
  </div>
  <!-- E: record-menu -->

  <!-- #include file = "intro-bg.asp" -->

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


  <!-- S: skill-state -->
  <div class="medal-rank state-cont" style="display: none;" id="iTotal_Main">
    <h2 id="iMain_Title"><!--<span>2016년</span> / <span>개인전</span> / <span>여자고등부</span> / <span>-52kg</span>--></h2>
    <!-- S: match-list -->
    <div class="match-list match-rank" id="iTotal_Main_Contents">

    </div>
    <!-- E: match-list -->
  </div>
  <!-- E: skill-state -->



    <!-- S: profile-pop -->
    <!-- #include file="./record-sub.asp" -->
    <!-- E: profile-pop -->



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


  <!-- E: modal-player-profile -->
  <!--<a href="#" data-target="#init_notice" data-toggle="modal" class="init_btn"></a>
  <div class="modal fade in confirm-modal record-notice" id="init_notice" tabindex="-1" role="dialog" aria-hidden="true">
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
        <div class="modal-footer">
          <label class="img-replace"><input type="checkbox"><span>오늘 하루 보지 않기</span></label>
          <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        </div>
      </div>
    </div>
  </div>-->
  <!-- E: modal-player-profile -->



  <script type="text/javascript">

    var iNowYear = new Date();
    //alert(iNowYear.getFullYear());
    $('#iyear').val(iNowYear.getFullYear());
    //iYear_chg(iNowYear.getFullYear())

      // 알림 모달
    $('.init_btn').click();

    var EnterType = '<%=EnterType%>';

    //EnterType = "K";

    if (EnterType == "E" || EnterType == "A") {
    	$("#iEnterType").val(EnterType).prop("selected", true);
    }

    fn_iteamgb();

  </script>
  </form>
</body>
