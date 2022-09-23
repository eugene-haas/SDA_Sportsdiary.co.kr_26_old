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
        alert("오류발생! - 시스템관리자에게 문의하십시오!");
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

    //alert(iSDate + "," + iPlayerIDX + "," + iEDate + "," + iGameTitleIDX.value);
    //alert(iPlayerIDX);

    var strAjaxUrl = "../Ajax/stat-film-sub.asp";

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
        alert("오류발생! - 시스템관리자에게 문의하십시오!");
      }
    });

  }

  function iMovieLink(link1, link2) {
    //alert(link1 + "," + link2);

    //alert(iSDate + "," + iPlayerIDX + "," + iEDate + "," + iGameTitleIDX.value);
    //alert(iPlayerIDX);
    history.pushState({ page: 1, name: '팝업' }, '', '?modal');
    if (link2 == "개인전") {

      var strAjaxUrl = "../Ajax/stat-DetailScore-Game-Sch.asp";

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
            $('#detailScore').html(retDATA);
            $('.film-modal').filmTab('.film-modal');
            $('.groups-res').filmTab('.groups-res');
          } else {
            $('#detailScore').html("");
          }
        }, error: function (xhr, status, error) {
          alert("오류발생! - 시스템관리자에게 문의하십시오!");
        }
      });

    }
    else {

      var strAjaxUrl = "../Ajax/stat-DetailScore-Game-Sch-Team.asp";

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
          alert("오류발생! - 시스템관리자에게 문의하십시오!");
        }
      });

    }


  }


  function chart_view() {


      clicksearch = 0;



      table_ajax();


      //검색창 닫기
      click_close();
      $('.bg-inst').hide();

      //차트부분 보이기
      $('#chart_view').show();


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
      <!--//<li>
          <a href="../Stats/weight-in-record.asp" class="btn">대회별 계체기록</a>
        </li>-->
    </ul>
  </div>
  <div class="mid-cat">
    <ul class="rank-mid menu-list clearfix">
      <li><a href="../Stats/stat-record.asp">선수 프로필</a></li>
      <li><a href="javascript:onSubmitStat('../Stats/stat-win.asp');">입상현황</a></li>
      <li><a href="javascript:onSubmitStat('../Stats/stat-film.asp');" class="on">대회영상모음</a></li>
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
            <select name="iMatchTitle" id="iMatchTitle" onChange="javascript:iMatch_chg();">
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
<div class="main stat-record" id="chart_view" style="display: none;">
  <div id="sub_table1"> </div>
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
<!-- E: 영상보기 모달 modal -->
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
    var iNowYear = new Date();
    //alert(iNowYear.getFullYear());
    $('#iyear').val(iNowYear.getFullYear());
    iYear_chg(iNowYear.getFullYear());
  </script>
</body>
