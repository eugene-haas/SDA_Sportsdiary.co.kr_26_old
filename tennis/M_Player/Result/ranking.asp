<!-- #include virtual = "/pub/header.RookieTennis.mobile.asp" -->
<%
Set db = new clsDBHelper
'##############################################
' 소스 뷰 경계
'##############################################
%>
<!DOCTYPE html>
<html lang="ko">
  <head>
	<!--#include virtual="/tennis/M_Player/html/html.head.asp"--><!-- 전체 공통 CSS JS 정의  -->
	<%'response.write "<script src='"&LURL&"/js/library/moment.min.js"&CONST_JSVER&"'></script>"		'페이지별도 스크립트 또는 CSS 정의%>
  </head>

  <body class="sd-body">
	<!-- S: sub-header -->
	<div class="sd-header sd-header-sub">
		<!-- #include file="../include/sub_header_arrow.asp" --><h1 id="aaaaa">경기기록</h1><!-- #include file="../include/sub_header_right.asp" -->
	</div>
	<!-- E: sub-header -->
    <!-- #include file = "../include/gnb_new.asp" -->


    <!-- S: main -->
    <div class="main sd-main-E sd-scroll [ _sd-scroll ]">
	  <!-- S: main banner -->
      <%
		  bnSource = Stream_BinaryToString( GetHTTPFile("http://tennis.sportsdiary.co.kr/pub/banner.asp?bntype=1&bngb=tennis&bnidx=12") , "utf-8" )
		  Response.write bnSource
	  %>
      <!-- E: main banner -->

		
		<!-- S: start -->
        <div class="sd-calendar-container">
				컨텐츠
        </div>
        <!-- E: end -->



    </div>
    <!-- E: main -->

    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- #include file= "../include/bot_config.asp" -->
<%
	Call db.Dispose
	Set db = Nothing
%>
  </body>
  </html>
