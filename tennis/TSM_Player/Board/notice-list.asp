<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->

  <%

    iLIUserID = Request.Cookies("SD")("UserID")
    iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    iLISportsGb = SportsGb

  	LocateIDX_1 = "18"
  	'LocateIDX_2 = "10"
  	'LocateIDX_3 = "13"

  %>

  <%
    dim currPage    : currPage    = fInject(Request("currPage"))
    dim SDate     : SDate     = fInject(Request("SDate"))
    dim EDate     : EDate     = fInject(Request("EDate"))
    dim fnd_user  : fnd_user    = fInject(Request("fnd_user"))
    dim search_date : search_date   = fInject(Request("search_date"))

  %>
  <script type="text/javascript">
    //검색창 닫기
    function searching_close(){
      $("#sbox").slideToggle( "slow", function() {
         $('#click_close').hide();
         $('#click_open').show();
      // Animation complete.
      });
    }

    //검색창 열기
    function searching_open(){
      $("#sbox").slideDown( "slow", function() {
          $('#click_close').show();
          $('#click_open').hide();
        // Animation complete.
      });
    }

      //검색
    function chk_Submit(typeURL, NtcIDX, chkPage){
      //Default Board Contents
      var strAjaxUrl = "../Ajax/notice-list.asp";

      var SDate = $("#SDate").val();
      var EDate = $("#EDate").val();
      var fnd_user = $("#fnd_user").val();
      var search_date = $("select[name=search_date]").val();

      if(chkPage!="") $("#currPage").val(chkPage);

      var currPage = $("#currPage").val();

      if(typeURL=="VIEW"){
        $("#NtcIDX").val(NtcIDX);

        $('form[name=s_frm]').attr('action',"./notice-view.asp");
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
            $('.sub.board').css('paddingBottom', '80px');
            $('.board-list').css('paddingBottom','10px');

        $("#board-contents").show();
            $("#board-contents").html(retDATA);

        if(typeURL=="FND")  searching_close();

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

    //검색 작성자선택 조회
    function fnd_UserList(element, attname){
      var strAjaxUrl = "../select/notice_list_Select.asp";

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          element  : element
          ,attname  : attname
        },
        success: function(retDATA) {
          $("#"+attname).html(retDATA);
          searching_close();
        },
        error: function(xhr, status, error){
          if(error!=""){
            alert ("오류발생! - 시스템관리자에게 문의하십시오!");
            return;
          }
        }
      });
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
      }

      /*
      //Default Board Contents
      var strAjaxUrl = "../Ajax/notice-list.asp";
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

      //Default Board Contents
      chk_Submit('LIST','',1);

      //검색 작성자 Select Box 목록조회
      fnd_UserList('search_user','fnd_user');

      // $("#board-contents").hide();
      // $('.sub.board').css('paddingBottom',0);
      // $('.board-list').css('paddingBottom',0);
      // $('.bg-inst').show();
    });
  </script>
</head>
<body>
<div class="l m_bg_edf0f4">

  <!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
  		<h1 class="m_header__tit">공지사항</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>

    <div class="m_horizon"></div>

    <!-- S: main banner 01 -->
    <%
      imType = "1"
      imSportsGb = "tennis"
      imLocateIDX = LocateIDX_1

      LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"
      'response.Write "LSQL="&LSQL&"<br>"
      'response.End

      Set LRs = DBCon6.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
    %>
    <div class="major_banner">
      <div class="banner banner_<%=LRs("LocateGb")%> carousel">
    	  <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
    		<!-- #include file="../include/banner_Include.asp" -->
    		</div>
    	</div>
    </div>
    <%
      End If
      LRs.close
    %>
    <!-- E: main banner 01 -->

    <!-- 게시판 검색 -->
    <div class="m_forumSearch">
      <form name="s_frm" method="post" class="m_forumSearch__form" id="sbox">
        <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
        <input type="hidden" name="NtcIDX" id="NtcIDX" />
        <input type="hidden"  class="on_val" id="on_val" name="on_val" />
        <input type="hidden"  class="active_val"  id="active_val" name="active_val"  />

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
            <input type="date" name="SDate" id="SDate" class="m_forumSearch__input" maxlength="10" value="<%=SDate%>" />
            <span class="m_forumSearch__dateTxt">~</span>
            <input type="date" name="EDate" id="EDate" class="m_forumSearch__input" maxlength="10" value="<%=EDate%>" />
          </div>
        </div>
        <div id="search_user" class="m_forumSearch__formItem">
          <label for="fnd_user" class="m_forumSearch__label">작성자검색</label>
          <div class="m_forumSearch__inputWrap">
            <select name="fnd_user" id="fnd_user" class="m_forumSearch__select">
              <option value="">작성자</option>
            </select>
          </div>
        </div>
        <div class="m_forumSearch__formCtrlItem">
          <button type="button" onclick="javascript:searching_close();" class="m_forumSearch__formCtrlbtn s_close">닫기</button>
          <button type="button" onclick="javascript:chk_Submit('FND','','');" class="m_forumSearch__formCtrlbtn s_searching">검색</button>
        </div>
      </form>

      <div class="m_forumSearch__ctrl">
        <a href="javascript:searching_open();" id="click_open" class="m_forumSearch__ctrlBtn s_open">열기</a>
        <a href="javascript:searching_close();" id="click_close" class="m_forumSearch__ctrlBtn s_close">닫기</a>
      </div>
    </div>
	</div>

  <div id="div_Main" class="l_content m_scroll [ _content _scroll ]">

    <!-- 게시판 리스트 -->
    <div id="board-contents" class="m_forumBox">

      <!-- <ul > -->
        <!-- S: 리스트 -->
        <!--
          <li class="require">
            <h4>[필독] 스포츠다이어리 신규결제 안내</h4>
            <p class="write-info clearfix">
              <span>관리자</span>
              <span>2016.12.26</span>
              <span class="seen">조회수</span>
              <span>4,221</span>
            </p>
          </li>
          <li>
            <h4>스포츠다이어리 공지사항입니다.</h4>
            <p class="write-info clearfix">
              <span>관리자</span>
              <span>2016.12.26</span>
              <span class="seen">조회수</span>
              <span>4,221</span>
            </p>
          </li>
          -->
        <!-- E: 리스트 -->
      <!-- </ul> -->
      <!-- E: 게시판 리스트 -->

    </div>

    <!-- #include file ="./intro-bg.asp" -->
  </div>

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->

</div>
</body>
</html>
<% AD_DBClose() %>
<!-- #include file="../Library/sub_config.asp" -->