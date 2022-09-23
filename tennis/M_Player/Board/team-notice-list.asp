<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
	Check_Login()

	dim currPage    : currPage    	= fInject(Request("currPage"))
	dim SDate     	: SDate     	= fInject(Request("SDate"))
	dim EDate     	: EDate     	= fInject(Request("EDate"))
	dim fnd_user  	: fnd_user    	= fInject(Request("fnd_user"))
	dim search_date : search_date   = fInject(Request("search_date"))
%>
<script type="text/javascript">
  //검색창 닫기
  function click_close(){
     $("#sbox").slideToggle( "slow", function() {
       $('#click_close').hide();
       $('#click_open').show();

      // Animation complete.
    });
  }

  //검색창 열기
  function click_open(){
    $("#sbox").slideDown( "slow", function() {
      $('#click_close').show();
      $('#click_open').hide();
      // Animation complete.
    });
  }

  function pad(num) {
    num = num + '';
    return num.length < 2 ? '0' + num : num;
  }

  function dateToYYYYMMDD(date,status) {
    if (status == "M") { return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate() + 1);}
    else if (status == "Y") { return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate() + 1);}
    else if (status == "W") { return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate());}
  }

    //기간선택 날짜 조회
  function chk_FndDateValue(){
    var date = new Date();
    var todayDate = date.toISOString().slice(0,10);

    if($('#search_date_id').val()=="date"){
      $('#SDate').val("");
      $('#EDate').val("");
      $('#SDate').focus();
    }
    else{

      var prevDate;
      var prevSetDate;

      if($('#search_date_id').val()=="month"){ prevDate = new Date(new Date().setMonth(new Date().getMonth() - 1)); var prevSetDate = dateToYYYYMMDD(prevDate, 'M');}
      else if($('#search_date_id').val()=="month3"){ prevDate = new Date(new Date().setMonth(new Date().getMonth() - 3)); var prevSetDate = dateToYYYYMMDD(prevDate, 'M');}
      else if($('#search_date_id').val()=="month6"){ prevDate = new Date(new Date().setMonth(new Date().getMonth() - 6)); var prevSetDate = dateToYYYYMMDD(prevDate, 'M');}
      else if($('#search_date_id').val()=="year"){ prevDate = new Date(new Date().setMonth(new Date().getMonth() - 12)); var prevSetDate = dateToYYYYMMDD(prevDate, 'Y');}
      else if($('#search_date_id').val()=="year2"){ prevDate = new Date(new Date().setMonth(new Date().getMonth() - 24)); var prevSetDate = dateToYYYYMMDD(prevDate, 'Y');}
      else if($('#search_date_id').val()=="year3"){ prevDate = new Date(new Date().setMonth(new Date().getMonth() - 36)); var prevSetDate = dateToYYYYMMDD(prevDate, 'Y');}
      else if($('#search_date_id').val()=="year5"){ prevDate = new Date(new Date().setMonth(new Date().getMonth() - 60)); var prevSetDate = dateToYYYYMMDD(prevDate, 'Y');}
      else if($('#search_date_id').val()=="year10"){ prevDate = new Date(new Date().setMonth(new Date().getMonth() - 120)); var prevSetDate = dateToYYYYMMDD(prevDate, 'Y');}
      else{ prevDate = new Date(new Date().setDate(new Date().getDate()-6)); var prevSetDate = dateToYYYYMMDD(prevDate, "W");}

      $('#SDate').val(prevSetDate);
      $('#EDate').val(todayDate);
    }
  }


  //동일 소속팀 팀매니저 목록
  function CHK_TeamMember(){
    var strAjaxUrl="../select/team_notice_list_Coach.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {},
      success: function(retDATA) {

        $("#search_user").html(retDATA);

      },
	  error: function(xhr, status, error){
        if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
      }
    });
  }

  //검색
  function chk_Submit(typeURL, NtcIDX, chkPage){
    //Default Board Contents
    var strAjaxUrl = "../Ajax/team-notice-list.asp";

    var SDate = $("#SDate").val();
    var EDate = $("#EDate").val();
    var fnd_user = $("#fnd_user").val();
    var search_date = $("select[name=search_date]").val();

    if(chkPage!="") $("#currPage").val(chkPage);

    var currPage = $("#currPage").val();

    if(typeURL=="VIEW"){
      $("#NtcIDX").val(NtcIDX);

      $('form[name=s_frm]').attr('action',"./team-notice-view.asp");
      $('form[name=s_frm]').submit();
    }
    else{
      $.ajax({
        url: strAjaxUrl,
        type: "POST",
        dataType: "html",
        data: {
          currPage    : currPage ,
          SDate     : SDate ,
          EDate     : EDate ,
          fnd_user  : fnd_user ,
          search_date : search_date
        },
        success: function(retDATA) {
          $('.bg-inst').hide();
          $("#board-contents").show();
          $('.sub.board').css('paddingBottom', '80px');
          $('.board-list').css('paddingBottom','10px');
          $("#board-contents").html(retDATA);
          if(typeURL=="FND")  click_close();
        },
		error: function(xhr, status, error){
          if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
        }
      });
    }
  }

  $(document).ready(function(){

    var SDate = "<%=SDate%>";
    var EDate = "<%=EDate%>";

    if(SDate!="" && EDate!="") {
      $("select[name='search_date'] option[value='<%=search_date%>']").attr("selected", "selected");
      //검색후 검색조건 Close
      click_close();
    }
    else{
      //Default : 최근 1주일
       $("select[name='search_date'] option[value='year']").attr("selected", "selected");
       chk_FndDateValue();
    }

	//Default Board Contents
	chk_Submit('LIST','',1);

	/*
	//Default Board Contents
    var strAjaxUrl = "../Ajax/team-notice-list.asp";
    var currPage = $("#currPage").val();
    var SDate = $("#SDate").val();
    var EDate = $("#EDate").val();
    var fnd_user = $("#fnd_user").val();
    var search_date = $("select[name=search_date]").val();

    $.ajax({
      url: strAjaxUrl,
      type: "POST",
      dataType: "html",
      data: {
        currPage    : currPage ,
        SDate     : SDate ,
        EDate     : EDate ,
        fnd_user  : fnd_user ,
        search_date : search_date
      },
      success: function(retDATA) {
        $("#board-contents").html(retDATA);
      }, error: function(xhr, status, error){
        alert ("오류발생! - 시스템관리자에게 문의하십시오!");
      }
    });
    */

    // CHK_TeamMember();
    // $("#board-contents").hide();
    // $('.sub.board').css('paddingBottom',0);
    // $('.board-list').css('paddingBottom',0);
    // $('.bg-inst').show();
  });
</script>
<body class="lack-bg">
	<!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>팀 공지사항</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

<!-- S: sub sub-main -->
<div id="div_Main" class="sub sub-main board">
  <!-- S: search
    <div class="search">
      <label>
        <span class="label-title">작성자 검색</span>
        <select name="">
          <option value="">::전체::</option>
          <option value="">::전체::</option>
          <option value="">::전체::</option>
        </select>
        <input type="submit" value="검색">
      </label>
    </div>
    <!-- E: search -->
  <!-- S: board-list -->
  <div class="board-list">
    <!-- S: board-search-input 상단검색 -->
    <form name="s_frm" method="post">
      <input type="hidden"  class="on_val" id="on_val" name="on_val" />
      <input type="hidden"  class="active_val"  id="active_val" name="active_val"  />
      <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
      <input type="hidden" name="NtcIDX" id="NtcIDX" />
      <div class="board-search-input record-input" id="sbox">
        <!-- S: sel-list -->
        <div class="sel-list">
          <!-- S: 기간 선택 -->
          <dl class="clearfix term-sel">
            <dt>기간선택</dt>
            <!--<dd class="on">-->
            <dd id="search_date">
              <select name="search_date" id="search_date_id" onChange="chk_FndDateValue();">
                <!--<option value="date" selected>기간 조회</option>-->
                <option value="week">최근 1주일</option>
                <option value="month">최근 1개월</option>
                <option value="month3">최근 3개월</option>
                <option value="month6">최근 6개월</option>
                <option value="year">최근 1년</option>
                <option value="year2">최근 2년</option>
                <option value="year3">최근 3년</option>
                <option value="year5">최근 5년</option>
                <option value="year10">최근 10년</option>
              </select>
            </dd>
          </dl>
          <!-- E: 기간 선택 -->
          <!-- S: 기간 조회 -->
          <dl class="clearfix term-srch">
            <dt>기간조회</dt>
            <!--<dd class="on">-->
            <dd> <span>
              <input type="date" name="SDate" id="SDate" value="<%=SDate%>" />
              </span> </dd>
            <dd class="flow"> <span>~</span> </dd>
            <!--<dd class="on">-->
            <dd> <span>
              <input type="date" name="EDate" id="EDate" value="<%=EDate%>" />
              </span> </dd>
          </dl>
          <!-- E: 기간 조회 -->
          <!-- S: 작성자 검색 -->
          <dl class="clearfix term-user">
            <dt>작성자 검색</dt>
            <!--<dd class="on">-->
            <dd id="search_user">
              <!-- 작성자 셀렉트로 변경 -->
              <select name="fnd_user" id="fnd_user">
                <option value="">작성자</option>
              </select>
            </dd>
            <dd class="enter-btn-srch"><a href="javascript:chk_Submit('FND','','');" class="btn-gray">검색</a></dd>
          </dl>
        </div>
        <!-- E: sel-list -->
      </div>
      <!-- E: board-search-input 상단검색 -->
    </form>
    <!-- S: tail -->
    <div class="tail bg-tail"> <a href="javascript:click_open();"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a> <a href="javascript:click_close();"><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" alt="닫기"></a> </div>
    <!-- E: tail -->
    <!-- S: 게시판 리스트 -->
    <ul id="board-contents">
      <!-- S: 리스트
        <li class="require">
          <h4>[필독] 훈련시간 변동안내</h4>
          <p class="write-info clearfix">
            <span>관리자</span>
            <span>2016.12.26</span>
            <span class="seen">조회수</span>
            <span>4,221</span>
          </p>
        </li>


        <li>
          <h4>팀 공지사항입니다.</h4>
          <p class="write-info clearfix">
            <span>홍길동(코치)</span>
            <span>2016.12.26</span>
            <span class="seen">조회수</span>
            <span>4,221</span>
          </p>
        </li>
         E: 리스트 -->
    </ul>
    <!-- E: 게시판 리스트 -->
  </div>
  <!-- E: board-list -->
  <!-- S: board-bullet
    <div class="board-bullet">
          <a href="#" class="prev"><img src="../images/board/board-l-arrow@3x.png" alt="이전페이지"></a>
          <a href="#" class="on">1</a>
          <a href="#">2</a>
          <a href="#">3</a>
          <a href="#" class="next"><img src="../images/board/board-r-arrow@3x.png" alt="이전페이지"></a>
    </div>
       E: board-bullet -->
</div>
<!-- E: sub sub-main board -->

<!-- S: include intro-bg -->
<!-- #include file ="./intro-bg.asp" -->
<!-- E: include intro-bg -->

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
