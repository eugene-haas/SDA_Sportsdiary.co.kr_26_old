<!-- #include virtual = "/pub/header.RookieTennis.mobile.asp" -->
<%
Set db = new clsDBHelper
'##############################################
' 소스 뷰 경계
'##############################################
%>

<!--#include file="../include/config_bn.asp"-->
<%

  iLIUserID = Request.Cookies("SD")("UserID")
  iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
  iLIMemberIDXd = iLIMemberIDXG
  iLISportsGb = SportsGb

  LocateIDX_1 = "88"
  LocateIDX_2 = "90"

%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
	<!-- #include virtual="/tennis/M_Player/html/html.head.asp" -->
	<script src='/pub/js/tennis/record.js<%=CONST_JSVER%>'></script><!-- 페이지별도 스크립트 또는 CSS -->
</head>

<body>
<div class="l">

  <%dbtype = "class"%>

  <!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">경기기록실</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>

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
    <ul class="m_recordTab__menu">
      <li class="m_recordTab__item s_active"><a href="record_sd.asp" class="m_recordTab__txt">SD랭킹</a></li>
      <li class="m_recordTab__item"><!---<a href="javascript:alert('현재 페이지 준비중입니다.\n랭킹은 KATA 홈페이지에서 확인하실 수 있습니다.')" class="m_recordTab__txt">-->
	  <a href="record_Kata.asp" class="m_recordTab__txt">KATA랭킹</a></li>
    </ul>
    <div class="l_search__wrap">
        <div class="l_searchInfo__box">
    
        <!-- .s. (SD랭킹 / KATA랭킹)조회 후 나오는 영역 .s. -->
          <!-- <p class="l_searchInfo__txt"><%=nowyear%>년</p>
            <p class="l_searchInfo__txt"><%=boostr%></p> -->
            
            <button class="m_btnPopup" onclick="openSearching('부서검색')"><span class="img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/team_navy_@3x.png" alt=""></span>부서검색</button>
            <button class="m_btnPopup" onclick="openSearching('선수검색')"><span class="img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/person_navy_@3x.png" alt=""></span>선수검색</button>
    
            <!-- //e. (SD랭킹 / KATA랭킹)조회 후 나오는 영역 .e. -->
          <!-- <button class="l_search__btn" onclick="openSearching()"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt=""></button> -->
        </div>
      </div>
    
	</div>
  <!-- #include file = "./body/c.record_sd.asp" -->
  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
<%
	Call db.Dispose
	Set db = Nothing
%>
</div>
</body>
</html>
