<!-- #include file="../include/config.asp" -->
<%
    dim SDate : SDate = Request("SDate")  '검색 시작일
  dim EDate : EDate = Request("EDate")  '검색 종료일
  dim search_date : search_date   = fInject(Request("search_date"))
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

      for (var i = 1; i < 10; i++) {
        $('#Injury_sd00300' + i+"_N").show();
        $('#Injury_sd00300' + i).hide();
        $('#tbody_sd00300' + i).hide();

    }

    for (var i = 10; i < 19; i++) {
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

    var strAjaxUrl = "../Ajax/stat-injury-f.asp";

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
        if (error!='') {
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
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

          $('#Injury_' + iJRPubCode1arr[i]).show();
          $('#tbody_' + iJRPubCode1arr[i]).show();

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
    $('.table_01').chkInjury('.table_01');

    // 부상부위 뒤
    //$('.table_02').chkInjury('.table_01');

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
      <li><a href="javascript:onSubmit('../Stats/stat-injury-f.asp');" class="on">부상부위(앞)</a></li>
      <li><a href="javascript:onSubmit('../Stats/stat-injury-b.asp');">부상부위(뒤)</a></li>
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
<div class="tail bg-tail">
  <!--<div class="tail short-tail">-->
  <a href="javascript:click_open();"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a> <a href="#" ><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" alt="닫기"></a> </div>
<!-- E: tail -->
<!-- S: state-cont -->
<form name="form1" id="form1">
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
        <h3>부상부위(앞)</h3>
        <p id="during_date">2016-07-27~2016-08-03</p>
      </div>
      <div id="injury">
        <!-- S: 부상부위 이미지가 들어갑니다. -->
        <div class="dist-cont">
          <table class="table_01" border="0" style="font-size:12px; background-image: url(http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_bg.png);" cellpadding="0" cellspacing="0">
            <tbody>
              <tr>
                <td align="right"><table class="left_label" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                      <tr>
                        <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003001_P" value="sd003001">
                            <span id="Injury_sd003001" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)쇄골(0)</span> <span id="Injury_sd003001_N">(우)쇄골</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003003_P" value="sd003003">
                            <span id="Injury_sd003003" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)어깨(0)</span> <span id="Injury_sd003003_N">(우)어깨</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                            <!-- <input type="checkbox" disabled name="InjuryArea" id="InjuryArea5" value="sd003005">-->
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003005_P" value="sd003005">
                            <span id="Injury_sd003005" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)늑골(0)</span> <span id="Injury_sd003005_N">(우)늑골</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003007_P" value="sd003007">
                            <span id="Injury_sd003007" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)고관절(0)</span> <span id="Injury_sd003007_N">(우)고관절</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003009_P" value="sd003009">
                            <span id="Injury_sd003009" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)앞허벅지(0)</span> <span id="Injury_sd003009_N">(우)앞허벅지</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003011_P" value="sd003011">
                            <span id="Injury_sd003011" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)무릎(0)</span> <span id="Injury_sd003011_N">(우)무릎</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003013_P" value="sd003013">
                            <span id="Injury_sd003013" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)정강이(0)</span> <span id="Injury_sd003013_N">(우)정강이</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003015_P" value="sd003015">
                            <span id="Injury_sd003015" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)발목(0)</span> <span id="Injury_sd003015_N">(우)발목</span> </label></td>
                      </tr>
                      <tr>
                        <td height="28" style="text-align:right;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003017_P" value="sd003017">
                            <span id="Injury_sd003017" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)발/발가락(5)(5%)</span> <span id="Injury_sd003017_N">(우)발/발가락</span> </label></td>
                      </tr>
                    </tbody>
                  </table></td>
                <td colspan="3" align="center"><table class="body-img" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                      <tr style="height:138px">
                        <td style="width:51px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_01.png" id="tbody_sd003003" style="display:none" width="51" height="138"></td>
                        <td style="width:27px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_02.png" id="tbody_sd003001" style="display: none;" width="27" height="138"></td>
                        <td style="width:28px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_03.png" id="tbody_sd003002" style="display:none" width="28" height="138"></td>
                        <td style="width:49px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_04.png" id="tbody_sd003004" style="display:none" width="49" height="138"></td>
                      </tr>
                      <tr style="height:60px">
                        <td colspan="2" style="width:78px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_05.png" style="display:none" id="tbody_sd003005" width="78" height="60"></td>
                        <td colspan="2" style="width:77px"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_06.png" style="display: none;" id="tbody_sd003006" width="77" height="60"></td>
                      </tr>
                      <tr style="height:53px">
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_07.png" id="tbody_sd003007" style="display:none" width="78" height="53"></td>
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_08.png" id="tbody_sd003008" style="display:none" width="77" height="53"></td>
                      </tr>
                      <tr style="height:52px">
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_09.png" id="tbody_sd003009" style="display:none" width="78" height="52"></td>
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_10.png" id="tbody_sd003010" style="display:none" width="77" height="52"></td>
                      </tr>
                      <tr style="height:41px">
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_11.png" id="tbody_sd003011" style="display:none" width="78" height="41"></td>
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_12.png" id="tbody_sd003012" style="display:none" width="77" height="41"></td>
                      </tr>
                      <tr style="height:35px">
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_13.png" id="tbody_sd003013" style="display:none" width="78" height="35"></td>
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_14.png" id="tbody_sd003014" style="display:none" width="77" height="35"></td>
                      </tr>
                      <tr style="height:32px">
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_15.png" id="tbody_sd003015" style="display:none" width="78" height="32"></td>
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_16.png" id="tbody_sd003016" style="display:none" width="77" height="32"></td>
                      </tr>
                      <tr style="height:32px">
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_17.png" id="tbody_sd003017" style="display: none;" width="78" height="32"></td>
                        <td colspan="2"><img src="http://img.sportsdiary.co.kr/sdapp/<% if Sex = "WoMan" then %>stats-injury-woman<%Else%>stats-injury-man<% end if %>/f_18.png" id="tbody_sd003018" style="display:none" width="77" height="32"></td>
                      </tr>
                    </tbody>
                  </table></td>
                <td><table class="left_label" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                      <tr>
                        <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003002_P" value="sd003002">
                            <span id="Injury_sd003002" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)쇄골(0)</span> <span id="Injury_sd003002_N">(좌)쇄골</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003004_P" value="sd003004">
                            <span id="Injury_sd003004" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)어깨(0)</span> <span id="Injury_sd003004_N">(좌)어깨</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003006_P" value="sd003006">
                            <span id="Injury_sd003006" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)늑골(1)(1%)</span> <span id="Injury_sd003006_N">(좌)늑골</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003008_P" value="sd003008">
                            <span id="Injury_sd003008" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)고관절(0)</span> <span id="Injury_sd003008_N">(좌)고관절</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003010_P" value="sd003010">
                            <span id="Injury_sd003010" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)앞허벅지(0)</span> <span id="Injury_sd003010_N">(좌)앞허벅지</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003012_P" value="sd003012">
                            <span id="Injury_sd003012" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)무릎(0)</span> <span id="Injury_sd003012_N">(좌)무릎</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003014_P" value="sd003014">
                            <span id="Injury_sd003014" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)정강이(0)</span> <span id="Injury_sd003014_N">(좌)정강이</span> </label></td>
                      </tr>
                      <tr>
                        <td height="52" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003016_P" value="sd003016">
                            <span id="Injury_sd003016" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)발목(0)</span> <span id="Injury_sd003016_N">(좌)발목</span> </label></td>
                      </tr>
                      <tr>
                        <td height="28" style="text-align:left;vertical-align: text-top;"><label style="font-size:12px">
                            <input type="checkbox" disabled name="InjuryArea" id="Injury_sd003018_P" value="sd003018">
                            <span id="Injury_sd003018" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(좌)발/발가락(0)</span> <span id="Injury_sd003018_N">(좌)발/발가락</span> </label></td>
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
</form>
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
<script>

    //$('input:checkbox[id="InjuryArea1"]').prop("checked", true);

  </script>
</body>
