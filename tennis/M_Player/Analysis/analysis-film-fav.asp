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

  var iPlayerIDX = '<%=PlayerIDX%>';
  var iMemberIDX = '<%=MemberIDX%>';


  var clicksearch = 0;

  function iYear_chg(year) {

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

    var strAjaxUrl = "../Ajax/analysis-film-fav-sub.asp";

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
          fn_nodata();
          alert("조회된 데이터가 없습니다.");
        }
        $('.stat-list').iconFavo('.stat-list');
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


  function iFavLink(link1) {
    //alert(link1);

    //alert(iSDate + "," + iPlayerIDX + "," + iEDate + "," + iGameTitleIDX.value);
    //alert(iPlayerIDX);

    var strAjaxUrl = "../Ajax/analysis-film-Mod.asp";

    //alert(strAjaxUrl);

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        iPlayerIDX: iPlayerIDX,
        iPlayerResultIdx: link1
      },
      success: function (retDATA) {
        if (retDATA) {
          //alert(retDATA);
          if (retDATA == "Y") {
            alert("즐겨찾기를 추가 했습니다.")
          }
          else {
            alert("즐겨찾기를 삭제 했습니다.")
          }
        } else {

        }
      },  error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
    });

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
			response.Write "	$('#iMatchTitle').val('"&Request("iMatchTitle")&"');"
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
    <h1 id="aaaaa">선수분석</h1>
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
      <li><a href="javascript:onSubmitStat('./analysis-win.asp');">입상현황</a></li>
      <li><a href="javascript:onSubmitStat('./analysis-film.asp');">대회영상모음</a></li>
      <li><a href="javascript:onSubmitStat('./analysis-film-fav.asp?videomode=youtube');" class="on">대회영상즐겨찾기<span class="icon-on-favorite">★</span></a></li>
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
<div class="main stat-record film-fav" id="chart_view" style="display: none;">
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
