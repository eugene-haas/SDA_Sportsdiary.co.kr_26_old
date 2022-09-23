<!-- #include file="../include/config.asp" -->
<%
	Check_Login()

	dim currPage    	: currPage    	= fInject(Request("currPage"))
	dim SDate     		: SDate     	= fInject(Request("SDate"))
	dim EDate     		: EDate     	= fInject(Request("EDate"))
	dim fnd_KeyWord  	: fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
	dim search_date 	: search_date   = fInject(Request("search_date"))

%>
<script>
  // 검색창 닫기
  function click_close(){
   $("#sbox").slideToggle( "slow", function() {
     $('#click_close').hide();
     $('#click_open').show();
  });
  }

  // 검색창 열기
  function click_open(){
    $("#sbox").slideDown( "slow", function() {
      $('#click_close').show();
      $('#click_open').hide();
    });
  }

  //검색
  function chk_Submit(typeURL, CIDX, chkPage){
    //Default Board Contents
    var strAjaxUrl = "../Ajax/my_memo_list.asp";

    var SDate = $("#SDate").val();
    var EDate = $("#EDate").val();
    var fnd_KeyWord = $("#fnd_KeyWord").val();
    var search_date = $("select[name=search_date]").val();

    if(chkPage!="") $("#currPage").val(chkPage);

    var currPage = $("#currPage").val();

    if(typeURL=="VIEW"){
      $("#CIDX").val(CIDX);

      $('form[name=s_frm]').attr('action',"./my_memo_view.asp");
      $('form[name=s_frm]').submit();
    }
    else{
    //  alert(fnd_User);

      $.ajax({
        url: strAjaxUrl,
        type: "POST",
        dataType: "html",
        data: {
          currPage    : currPage
          ,SDate     : SDate
          ,EDate     : EDate
          ,fnd_KeyWord  : fnd_KeyWord
          ,search_date : search_date
        },
        success: function(retDATA) {
          $('.state-cont').show();
          // $('.bg-inst').hide();
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
       $("select[name='search_date'] option[value='week']").attr("selected", "selected");
       chk_FndDateValue();
    };

    //Default Board Contents
    chk_Submit('LIST','',1);
    // $('.state-cont').hide();
  });
</script>
<body class="lack-bg">

<form name="s_frm" method="post">
  <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
  <input type="hidden" name="CIDX" id="CIDX" />
  <input type="hidden"  class="on_val" id="on_val" name="on_val" />
  <input type="hidden"  class="active_val"  id="active_val" name="active_val"  />
	<!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>나의 메모장</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: record-input -->
  <div class="sub board qa-srch-board">
    <div class="record-input qa-record-input" id="sbox">
      <!-- S: sel-list -->
      <div class="sel-list qa-sel-list">
        <!-- S: 기간 선택 -->
        <dl class="clearfix term-sel">
          <dt>기간선택</dt>
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
          <dd> <span>
            <input type="date" name="SDate" id="SDate" value="<%=SDate%>" maxlength="10" />
            </span> </dd>
          <dd class="flow"> <span>~</span> </dd>
          <dd> <span>
            <input type="date" name="EDate" id="EDate" value="<%=EDate%>" maxlength="10" />
            </span> </dd>
        </dl>
        <!-- E: 기간 조회 -->
        <!-- S: 작성자 조회 -->
        <dl class="clearfix term-user">
          <dt>키워드조회</dt>
          <dd id="search_user">
            <input type="text" id="fnd_KeyWord" name="fnd_KeyWord" placeholder="검색할 키워드를 입력해 주세요." value="<%=fnd_KeyWord%>">
          </dd>
          <dd class="btn-list qa_btn">
            <!-- <a href="javascript:click_close();" class="btn-left btn">닫기</a> -->
            <a href="javascript:chk_Submit('FND','','');" class="btn-right btn">검색</a> </dd>
        </dl>
        <!-- E: 작성자 조회 -->
      </div>
      <!-- E: sel-list -->
    </div>
  </div>
  <!-- E: record-input -->

  <!-- S: tail -->
  <div class="tail bg-tail"> <a href="javascript:click_open();"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" alt="열기" style="display: none;"></a> <a href="javascript:click_close();" ><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" style="display:block;" alt="닫기"></a> </div>
  <!-- E: tail -->
  <!-- S: state-cont -->
  <div  class="state-cont">
    <!-- S: top-counsel -->
    <div class="top-counsel qa-top clearfix">
      <h3 class="write_guide">메모 사항을 적어주세요.</h3>
      <a href="./memo_write.asp" class="btn btn-or">글쓰기 <span class="icon"><i class="fa fa-pencil" aria-hidden="true"></i></span></a> </div>
    <!-- E: top-counsel -->
    <!-- S: sub sub-main -->
    <div id="board-contents" class="sub sub-main board qa-board panel-group qa-srch-board">
      <!-- S: panel -->
      <!--
      <div class="container">
        <ul class="qa-pack">
          <li class="word-list">
              <a href="./qa_board_view.asp" class="tit" data-parent="board-contents"><span class="txt">잘 됩니다. 잘 됩니다. 잘 됩니다. 잘 됩니다.</span><span class="ic-re">Re</span><span class="ic-new">N</span></a>
              <p class="write-info clearfix">
                <span>홍길동</span>
                <span>2016.12.26</span>
                <span class="seen">조회수</span>
                <span>4,221</span>
              </p>
            </li>
            <li class="re-cont reply-1">
              <div class="counsel-tit-wrap">
                <div class="counsel-row">
                  <div class="counsel-tit">
                    <span class="icon"><img src="../images/board/ic_reply@3x.png" alt></span>
                    <span class="icon-gray">답변</span>
                    <span class="txt">감사.감사.감사.감사.감사.감사.감사.</span>
                    <span class="ic-new">N</span>
                  </div>
                </div>
                <p class="write-info clearfix">
                <span>관리자</span>
                <span>2016.12.26</span>
              </p>
              </div>
            </li>
        </ul>
      </div>
      -->
      <!-- E: panel -->
      <!-- S: pagination -->
      <!--
    <div class="pagination">
      <a href="#"><img src="../images/board/board-l-arrow@3x.png" alt="이전페이지"></a>
      <a href="#" class="on">1</a>
      <a href="#">2</a>
      <a href="#">3</a>
      <a href="#"><img src="../images/board/board-r-arrow@3x.png" alt="다음페이지"></a>
    </div>
    -->
      <!-- E: pagination -->
    </div>
    <!-- E: sub sub-main board -->

    <!-- S: include intro-bg -->
  <!-- #include file ="./intro-bg.asp" -->
    <!-- E: include intro-bg -->

  </div>
  <!-- E: state-cont -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</form>
</body>
