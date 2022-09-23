<!-- #include file="../include/config.asp" -->
<%
	dim currPage    : currPage    	= fInject(Request("currPage"))
	dim SDate     	: SDate     	= fInject(Request("SDate"))
	dim EDate     	: EDate     	= fInject(Request("EDate"))
	dim fnd_user  	: fnd_user    	= fInject(Request("fnd_user"))
	dim search_date : search_date   = fInject(Request("search_date"))
	dim typeMenu 	: typeMenu    	= fInject(Request("typeMenu"))
%>
<script type="text/javascript">
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

    //검색
  function chk_Submit(typeURL, CIDX, chkPage){
    //Default Board Contents
    var strAjaxUrl = "../Ajax/from_manager.asp";
    var SDate = $("#SDate").val();
    var EDate = $("#EDate").val();
    var fnd_user = $("#fnd_user").val();
    var search_date = $("select[name=search_date]").val();

    if(chkPage!="") $("#currPage").val(chkPage);

    var currPage = $("#currPage").val();

    if(typeURL=="VIEW"){
      $("#CIDX").val(CIDX);

      $('form[name=frm]').attr('action',"./counsel_view.asp");
      $('form[name=frm]').submit();
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
          $(".state-cont").show();
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

    var SDate = $("#SDate").val();
    var EDate = $("#EDate").val();

    if(SDate!="" && EDate!="") {
      $("select[name='search_date'] option[value='<%=search_date%>']").attr("selected", "selected");
    }
    else{
      $("#sbox").slideDown( "slow", function() {
        $('#click_close').show();
        $('#click_open').hide();
      });

      //Default : 최근 1주일
       $("select[name='search_date'] option[value='week']").attr("selected", "selected");
       chk_FndDateValue();
    }

	/*
    //Default Board Contents
    var strAjaxUrl = "/M_Parents/Ajax/from_manager.asp";
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
          currPage      : currPage
          ,SDate      : SDate
          ,EDate      : EDate
          ,fnd_user     : fnd_user
          ,search_date  : search_date
        },
      success: function(retDATA) {
        $("#board-contents").html(retDATA);
      }, error: function(xhr, status, error){
        alert ("오류발생! - 시스템관리자에게 문의하십시오!");
      }
    });
	*/

	//Default Board Contents
	chk_Submit();

	$('.state-cont').hide();
  });

  //SET Favorite
  function SET_Favorite(CIDX, strType){
    var strAjaxUrl = "../Ajax/counsel_write_ok.asp";

    $.ajax({
      url: strAjaxUrl,
      type: "POST",
      dataType: "html",
      data: {
         CIDX   : CIDX
        ,strType : strType
      },
      success: function(retDATA) {
        var strcut = retDATA.split("|");


        if (strcut[0]=="TRUE") {

		  alert("즐겨찾기 설정을 업데이트 하였습니다.");

          if(strcut[1]=="N") {
            $("#FAV"+CIDX).attr('class','icon-favorite  on');
          }
		  else{
            $("#FAV"+CIDX).attr('class','icon-favorite');
          }
        }
        else{
          alert("즐겨찾기 설정이 실패하였습니다.\n다시 시도해주세요.");
          return;
        }

      },
	  error: function(xhr, status, error){
        if(error!=""){
			alert ("오류발생! - 시스템관리자에게 문의하십시오!");
			return;
		}
      }
    });
  }

  function click_close(){
     $("#sbox").slideToggle( "slow", function() {
       $('#click_close').hide();
       $('#click_open').show();
    });
  }

  //검색창 열기
  function click_open(){
    $("#sbox").slideDown( "slow", function() {
      $('#click_close').show();
      $('#click_open').hide();
    });
  }

  //검색 작성자선택 조회
  function fnd_UserList(element, attname){
    var strAjaxUrl = "../Select/counsel_FndUser_Select.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
           element  : element
          ,attname  : attname
        },
      success: function(retDATA) {
        $("#"+element).html(retDATA);
      },
	  error: function(xhr, status, error){
        if(error!=""){
			alert ("오류발생! - 시스템관리자에게 문의하십시오!");
			return;
		}
      }
    });
  }
</script>
<body class="board-bg lack-bg" onLoad="fnd_UserList('search_user','fnd_user');">
	<!-- S: sub-header -->
	<div class="sd-header sd-header-sub">
		<!-- #include file="../include/sub_header_arrow.asp" -->
		<h1>지도자상담</h1>
		<!-- #include file="../include/sub_header_gnb.asp" -->
	</div>
	<!-- #include file = "../include/gnb.asp" -->
	<!-- E: sub-header -->

<!-- S: record-menu -->
<div class="record-menu">
  <div class="big-cat">
    <ul class="menu-list flex">
      <li><a href="./req_counsel.asp?typeMenu=req_counsel" class="btn">상담요청하기</a></li>
      <li><a href="./from_manager.asp?typeMenu=from_manager" class="btn on">상담받기</a></li>
      <li><a href="./favorite_counsel.asp?typeMenu=favorite_counsel" class="btn">즐겨찾기</a></li>
    </ul>
  </div>
</div>
<!-- E: record-menu -->
<!-- S: record-bg -->
<!-- #include file = "./intro-bg.asp" -->
<!-- E: record-bg -->
<!-- S: record-input -->
<form name="frm" method="post">
  <input type="hidden" name="typeMenu" id="typeMenu" value="<%=typeMenu%>" />
  <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
  <input type="hidden" name="CIDX" id="CIDX" />
  <div class="record-input bg-ipt" id="sbox">
    <!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 선택 -->
      <dl class="clearfix term-sel">
        <dt>기간선택</dt>
        <!--<dd class="on">-->
        <dd id="search_date">
          <select name="search_date" id="search_date_id" onChange="chk_FndDateValue();">
            <option value="week">최근 1주일</option>
            <option value="month">최근 1개월</option>
            <option value="month3">최근 3개월</option>
            <option value="month6">최근 6개월</option>
            <option value="year">최근 1년</option>
            <option value="year2">최근 2년</option>
            <option value="year3">최근 3년</option>
            <option value="yerar5">최근 5년</option>
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
          <input type="date" name="SDate" id="SDate" value="<%=SDate%>" maxlength="10" />
          </span> </dd>
        <dd class="flow"> <span>~</span> </dd>
        <!--<dd class="on">-->
        <dd> <span>
          <input type="date" name="EDate" id="EDate" value="<%=EDate%>" maxlength="10" />
          </span> </dd>
      </dl>
      <!-- E: 기간 조회 -->
      <!-- S: 작성자 검색 -->
      <dl class="clearfix term-user">
        <dt>작성자 선택
          </td>
          <!--<dd class="on">-->
        <dd id="search_user">
          <select name="fnd_user" id="fnd_user">
            <option value="">작성자선택</option>
          </select>
        </dd>
      </dl>
      <!-- E: 작성자 검색 -->
    </div>
    <!-- E: sel-list -->
    <div class="btn-list"> <a href="javascript:click_close();" class="btn-left btn">닫기</a> <a href="javascript:chk_Submit('FND','','');" class="btn-right btn">조회</a> </div>
  </div>
</form>
<!-- E: record-input -->
<!-- S: tail -->
<div class="tail bg-tail lack-sw-tail"> <a href="javascript:;"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" alt="열기"></a> <a href="javascript:;" ><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" style="display:none;" alt="닫기"></a> </div>
<!-- E: tail -->
<!-- S: state-cont -->
<div class="state-cont">
  <!-- S: top-counsel -->
  <div class="top-counsel write clearfix">
    <h3>지도자가 요청한 상담 내용을 확인해보세요.</h3>
  </div>
  <!-- E: top-counsel -->
  <!-- S: sub sub-main -->
  <div id="board-contents" class="sub sub-main board counsel"></div>
  <!-- E: sub sub-main board -->
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
