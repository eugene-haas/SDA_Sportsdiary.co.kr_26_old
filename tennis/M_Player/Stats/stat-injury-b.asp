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

  Sex = Request.Cookies("Sex")

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
  var iSex = '<%=Sex%>';

  //alert(iSex);

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

  function iInjury_N_fn() {
      for (var i = 19; i < 35; i++) {
          $('#Injury_sd0030' + i + "_N").show();
        $('#Injury_sd0030' + i).hide();
        $('#tbody_sd0030' + i).hide();

    }
  }


  function iInjury_fn() {


    //json통신 url parameter
    var SDate = $('#SDate').val();
    var EDate = $('#EDate').val();

    $('#SDate1').text(SDate);
    $('#EDate1').text(EDate);

    var strAjaxUrl = "../Ajax/stat-injury-b.asp";

    //alert(strAjaxUrl);

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        SDate: SDate,
        EDate: EDate,
        iMemberIDX: iMemberIDX
      },
      async: false,
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


    var LRsCnt1 = Number($('#LRsCnt1').val());

    //alert(LRsCnt1);

    if (LRsCnt1 > 0) {

      var iJRPubCode1 = $('#iJRPubCode1').val();
      var iPubName1 = $('#iPubName1').val();
      var iICnt1 = $('#iICnt1').val();

      var iJRPubCode1arr = iJRPubCode1.split("^");
      var iPubName1arr = iPubName1.split("^");
      var iICnt1arr = iICnt1.split("^");

      for (var i = 1; i < LRsCnt1 + 1; i++) {
          $('#tbody_' + iJRPubCode1arr[i]).show();
        $('#Injury_' + iJRPubCode1arr[i]).show();
        $('#Injury_' + iJRPubCode1arr[i]).text(iPubName1arr[i] + "(" + iICnt1arr[i] + ")");
        $('#Injury_' + iJRPubCode1arr[i] + '_N').hide();
        $('input:checkbox[id="Injury_' + iJRPubCode1arr[i] + '_P"]').attr("checked", true);

      }

      //$('input:checkbox[id="Injury_sd003003_P"]').attr("checked", true);
      //$('input:checkbox[id="Injury_sd003005_P"]').attr("checked", true);
      // alert($('input:checkbox[id="InjuryArea1"]').is(":checked"));
    }

  }


  // 훈련장소
  function chart_view() {

    iInjury_N_fn();

    var SDate = $('#SDate').val();
    var EDate = $('#EDate').val();

    $('#SDate1').text(SDate);
    $('#EDate1').text(EDate);

    //alert(strJsonUrl);

    iInjury_fn();

    // 부상부위 앞
    //$('.table_01').chkInjury('.table_01');

    // 부상부위 뒤
    $('.table_02').chkInjury('.table_02');

    //검색창 닫기
    click_close();
    $('.bg-inst').hide();

    $('#during_date').html($('#SDate').val() + "~" + $('#EDate').val());

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
        <li> <a href="javascript:onSubmit('../Stats/stat-injury-dist.asp');" class="btn my-diary on">부상정보</a> </li>
        <li> <a href="javascript:onSubmit('../Stats/stat-gauge.asp');" class="btn counsel">체력측정결과</a> </li>
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
      <li><a href="javascript:onSubmit('../Stats/stat-injury-dist.asp');">부상분포</a></li>
      <li><a href="javascript:onSubmit('../Stats/stat-injury-f.asp');">부상부위(앞)</a></li>
      <li><a href="javascript:onSubmit('../Stats/stat-injury-b.asp');" class="on">부상부위(뒤)</a></li>
    </ul>
  </div>
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
<div class="tail bg-tail">
  <!--<div class="tail short-tail">-->
  <a href="javascript:click_open();"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a> <a href="#" ><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" alt="닫기"></a> </div>
<!-- E: tail -->
<!-- S: state-cont -->
<div class="state-cont" id="chart_view" style="display:none;">
  <div id="sub_table1"></div>
  <!-- <div class="stat-title">
      <h2>훈련참석 현황</h2>
      <ul>
        <li>훈련 참여일 : 41일</li>
        <li>훈련 불참일 : 8일<span class="redy">(총 훈련일의 16%)</span></li>
      </ul>
    </div> -->
  <!-- S: 훈련 장소 stat-chart -->
  <section class="stat-chart train-place">
    <div class="chart-title">
      <h3>부상부위(뒤)</h3>
      <p id="during_date">2016-07-27~2016-08-03</p>
    </div>
    <div id="injury">
      <!-- S: 부상부위 이미지가 들어갑니다. -->
      <div class="dist-cont">
        <!-- <table class="table_02" border="0" style="font-size:12px; background-image: url(../images/stats/injury/<% if Sex = "WoMan" then %>girl/<% end if %>b_bg.png)" cellpadding="0" cellspacing="0"> -->
        <table class="table_02" border="0" style="font-size:12px; background-image: url(http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_bg.png)" cellpadding="0" cellspacing="0">
          <tbody>
            <tr>
              <td align="right"><table class="left_label" border="0" cellspacing="0" cellpadding="0">
                  <tbody>
                    <tr>
                      <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003019_P" value="sd003019">
                          <span id="Injury_sd003019" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">목(0)</span> <span id="Injury_sd003019_N">목</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003021_P" value="sd003021">
                          <span id="Injury_sd003021" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">등(0)</span> <span id="Injury_sd003021_N">등</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003023_P" value="sd003023">
                          <span id="Injury_sd003023" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)팔꿈치(0)</span> <span id="Injury_sd003023_N">(좌)팔꿈치</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003025_P" value="sd003025">
                          <span id="Injury_sd003025" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)손목(0)</span> <span id="Injury_sd003025_N">(좌)손목</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003027_P" value="sd003027">
                          <span id="Injury_sd003027" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)손/손가락(0)</span> <span id="Injury_sd003027_N">(좌)손/손가락</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003029_P" value="sd003029">
                          <span id="Injury_sd003029" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)뒤허벅지(0)</span> <span id="Injury_sd003029_N">(좌)뒤허벅지</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003031_P" value="sd003031">
                          <span id="Injury_sd003031" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)종아리(0)</span> <span id="Injury_sd003031_N">(좌)종아리</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003033_P" value="sd003033">
                          <span id="Injury_sd003033" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)아킬레스(0)</span> <span id="Injury_sd003033_N">(좌)아킬레스</span> </label></td>
                    </tr>
                    <tr>
                      <td height="28" style="text-align:right;"></td>
                    </tr>
                  </tbody>
                </table></td>
              <td colspan="3" align="center" class="body-img"><table width="155" border="0" cellspacing="0" cellpadding="0">
                  <tbody>
                    <tr style="height:88px">
                      <!-- <td colspan="3" style="width:155px"><img src="../images/stats/injury/<% if Sex = "WoMan" then %>girl/<% end if %>b_01.png" id="tbody_sd003019" style="display:none" width="155" height="88"></td> -->
                      <td colspan="3" style="width:155px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_01.png" id="tbody_sd003019" style="display:none" width="155" height="88"></td>
                    </tr>
                    <tr style="height:99px;width:155px">
                      <td style="width:43px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_02.png" id="tbody_sd003023" style="display:none" width="43" height="99"></td>
                      <td id="ttd_sd003021"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_03_1.png" id="tbody_sd003021" style="position: relative; left: 10px; display:none; width: 70px;" width="70" height="99"></td>
                      <td id="ttd_sd003020"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_03.png" id="tbody_sd003020" style="display:none; width: 70px; position: relative; left: 12px; " width="70" height="99"></td>
                      <td id="ttd_sd00302021"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_03_all.png" id="tbody_sd00302021" style="display:none" width="70" height="99"></td>
                      <td style="width:42px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_04.png" id="tbody_sd003024" style="display:none;" width="42" height="99"></td>
                    </tr>
                    <tr style="height:52px">
                      <td><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_05.png" id="tbody_sd003025" style="display:none" width="43" height="52"></td>
                      <td><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_06.png" id="tbody_sd003022" style="display:none; width: 70px;" width="70" height="52"></td>
                      <td><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_07.png" id="tbody_sd003026" style="display:none;width: 42px;" width="42" height="52"></td>
                    </tr>
                    <tr>
                      <td colspan="3"><table width="155" border="0" cellspacing="0" cellpadding="0">
                          <tbody>
                            <tr style="height:28px">
                              <td style="width:79px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_08.png" id="tbody_sd003027" style="display:none" width="79" height="28"></td>
                              <td style="width:76px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_09.png" id="tbody_sd003028" style="display:none" width="76" height="28"></td>
                            </tr>
                            <tr style="height:49px">
                              <td><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_10.png" id="tbody_sd003029" style="display:none" width="79" height="49"></td>
                              <td><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_11.png" id="tbody_sd003030" style="display:none" width="76" height="49"></td>
                            </tr>
                            <tr style="height:63px">
                              <td><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_12.png" id="tbody_sd003031" style="display:none" width="79" height="63"></td>
                              <td><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_13.png" id="tbody_sd003032" style="display:none" width="76" height="63"></td>
                            </tr>
                            <tr style="height:64px">
                              <td><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_14.png" id="tbody_sd003033" style="display:none" width="79" height="64"></td>
                              <td><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/b_15.png" id="tbody_sd003034" style="display:none" width="76" height="64"></td>
                            </tr>
                          </tbody>
                        </table></td>
                    </tr>
                  </tbody>
                </table></td>
              <td><table class="right_label" border="0" cellspacing="0" cellpadding="0">
                  <tbody>
                    <tr>
                      <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003020_P" value="sd003020">
                          <span id="Injury_sd003020" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">척추(0)</span> <span id="Injury_sd003020_N">척추</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003022_P" value="sd003022">
                          <span id="Injury_sd003022" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">허리(0)</span> <span id="Injury_sd003022_N">허리</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003024_P" value="sd003024">
                          <span id="Injury_sd003024" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)팔꿈치(0)</span> <span id="Injury_sd003024_N">(우)팔꿈치</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003026_P" value="sd003026">
                          <span id="Injury_sd003026" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)손목(0)</span> <span id="Injury_sd003026_N">(우)손목</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003028_P" value="sd003028">
                          <span id="Injury_sd003028" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)손/손가락(0)</span> <span id="Injury_sd003028_N">(우)손/손가락</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003030_P" value="sd003030">
                          <span id="Injury_sd003030" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)뒤허벅지(0)</span> <span id="Injury_sd003030_N">(우)뒤허벅지</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003032_P" value="sd003032">
                          <span id="Injury_sd003032" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)종아리(0)</span> <span id="Injury_sd003032_N">(우)종아리</span> </label></td>
                    </tr>
                    <tr>
                      <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                          <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003034_P" value="sd003034">
                          <span id="Injury_sd003034" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)아킬레스(0)</span> <span id="Injury_sd003034_N">(우)아킬레스</span> </label></td>
                    </tr>
                    <tr>
                      <td height="28" style="text-align:left;"></td>
                    </tr>
                  </tbody>
                </table></td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- E: 부상부위 이미지가 들어갑니다. -->
    </div>
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
