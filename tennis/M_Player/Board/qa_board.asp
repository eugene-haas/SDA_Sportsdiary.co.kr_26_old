<!DOCTYPE html>
<html lang="ko">
<head>
	<!-- #include file="../include/head.asp" -->
	<!-- #include file="../include/config.asp" -->
  <!-- #include file="../Library/sub_config.asp" -->
	<%
		'Check_Login()


		dim currPage   	: currPage    	= fInject(Request("currPage"))
		dim SDate     	: SDate     	= fInject(Request("SDate"))
		dim EDate     	: EDate     	= fInject(Request("EDate"))
		dim fnd_User  	: fnd_User    	= fInject(Request("fnd_User"))
		dim search_date	: search_date   = fInject(Request("search_date"))

	%>
	<script>
	  // 검색창 닫기
	  function searching_close(){
	   $("#sbox").slideToggle( "slow", function() {
	     $('#click_close').hide();
	     $('#click_open').show();
	  });
	  }

	  // 검색창 열기
	  function searching_open(){
	    $("#sbox").slideDown( "slow", function() {
	      $('#click_close').show();
	      $('#click_open').hide();
	    });
	  }

	  //검색
	  function chk_Submit(typeURL, CIDX, chkPage){
	    //Default Board Contents
	    var strAjaxUrl = "../Ajax/qa_board_list.asp";

	    var SDate = $("#SDate").val();
	    var EDate = $("#EDate").val();
	    var fnd_User = $("#fnd_User").val();
	    var search_date = $("select[name=search_date]").val();

	    if(chkPage!="") $("#currPage").val(chkPage);

	    var currPage = $("#currPage").val();

	    if(typeURL=="VIEW"){
	      $("#CIDX").val(CIDX);

	      $('form[name=s_frm]').attr('action',"./qa_board_view.asp");
	      $('form[name=s_frm]').submit();
	    }
	    else{
	    //  alert(fnd_User);

	      $.ajax({
	        url: strAjaxUrl,
	        type: "POST",
	        dataType: "html",
	        data: {
	          currPage    : currPage ,
	          SDate     : SDate ,
	          EDate     : EDate ,
	          fnd_User  : fnd_User ,
	          search_date : search_date
	        },
	        success: function(retDATA) {
	          $('.state-cont').show();
	          // $('.bg-inst').hide();
	          $("#board-contents").html(retDATA);

	          if(typeURL=="FND")  searching_close();

	        }, error: function(xhr, status, error){
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
	      searching_close();
	    }
	    else{
	      //Default : 최근 1주일
	       $("select[name='search_date'] option[value='year']").attr("selected", "selected");
	       chk_FndDateValue();
	    };

	    //Default Board Contents
	    chk_Submit('FND','',1);
	    // $('.state-cont').hide();
	  });
	</script>
</head>
<body>
<div class="l m_bg_edf0f4">

	<!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
		<div class="m_header s_sub">
	    <!-- #include file="../include/header_back.asp" -->
	    <h1 class="m_header__tit">Q&amp;A 게시판</h1>
	    <!-- #include file="../include/header_gnb.asp" -->
		</div>

		<div class="m_horizon"></div>

		<!-- 게시판 검색 -->
    <div class="m_forumSearch">
			<form name="s_frm" method="post" class="m_forumSearch__form" id="sbox">
			  <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
			  <input type="hidden" name="CIDX" id="CIDX" />
			  <input type="hidden"  class="on_val" id="on_val" name="on_val" />
			  <input type="hidden"  class="active_val"  id="active_val" name="active_val"  />

				<div class="sd-searching-box-A record-input qa-record-input">
					<div class="m_forumSearch__formItem">
						<label for="search_date_id" class="m_forumSearch__label">기간선택</label>
						<div class="m_forumSearch__inputWrap">
							<select name="search_date" id="search_date_id" class="m_forumSearch__select" onChange="chk_FndDateValue();">
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
						</div>
					</div>

					<div class="m_forumSearch__formItem">
						<label for="SDate" class="m_forumSearch__label">기간조회</label>
						<div class="m_forumSearch__inputWrap">
							<input type="date" name="SDate" id="SDate" class="m_forumSearch__input" value="<%=SDate%>" maxlength="10" />
							<span class="m_forumSearch__dateTxt">~</span>
							<input type="date" name="EDate" id="EDate" class="m_forumSearch__input" value="<%=EDate%>" maxlength="10" />
						</div>
					</div>

					<div id="search_user" class="m_forumSearch__formItem">
						<label for="fnd_user" class="m_forumSearch__label">작성자검색</label>
						<div class="m_forumSearch__inputWrap">
							<input type="text" id="fnd_User" class="m_forumSearch__input" name="fnd_User" placeholder="작성자를 입력해 주세요." value="<%=fnd_User%>">
						</div>
					</div>

					<div class="m_forumSearch__formCtrlItem">
						<button type="button" onclick="javascript:searching_close();" class="m_forumSearch__formCtrlbtn s_close">닫기</button>
						<button type="button" onclick="javascript:chk_Submit('FND','','');" class="m_forumSearch__formCtrlbtn s_searching">검색</button>
					</div>
				</div>
			</form>

			<div class="m_forumSearch__ctrl">
				<a href="javascript:searching_open();" id="click_open" class="m_forumSearch__ctrlBtn s_open">열기</a>
				<a href="javascript:searching_close();" id="click_close" class="m_forumSearch__ctrlBtn s_close">닫기</a>
			</div>
		</div>
  </div>

	<div id="" class="l_content m_scroll [ _content _scroll ]">

		<div class="m_forumHeader">
      <p class="write_guide">문의 사항을 남겨주세요.</p>
      <a href="./qa_board_write.asp" class="btn-or">글쓰기 <span class="icon"><i class="fa fa-pencil" aria-hidden="true"></i></span></a>
		</div>

		<div id="board-contents" class="m_forumBox">
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

		<!-- #include file ="./intro-bg.asp" -->

	</div>

	<!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->

</div>
</body>
</html>
<!-- #include file="../Library/sub_config.asp" -->