<%
mainscript = "tennis.js"
headimgstr = "<img src=""images/tournerment/header/kata_tennis_logo@3x.png"" alt=""KATA"" width=""146"" height=""22"">"

pagename = LCase(Mid(URL_PATH, InStrRev(URL_PATH, "/") + 1))
Select Case pagename
Case "calendar.asp"
homeurl = "index.asp"
headtitle = "<span class=""prev-txt"" id=""DP_Title_Left"">경기스코어 입력 /&nbsp;</span><span class=""prev-txt""> 경기일정</span>"

Case "stat-winner-state.asp","stat-grade-state-before.asp","stat-winning-rate.asp","stat-medal.asp","stat-medal-total.asp","stat-tourney-result.asp","stat-result-list.asp"
mainscript = "tennis_operating.js"
If pagename = "stat-tourney-result.asp" Or pagename = "stat-result-list.asp" Then
	strsubtitle = " / 결과보기"
End if

headtitle = "<span class=""prev-txt"">경기 기록실"&strsubtitle&"</span>"

Case "rgamelist.asp"
headtitle = "<span class=""prev-txt"" id=""DP_Title_Left"">경기 입력 조회</span>"
homeurl = "javascript:mx.SendPacket(null, {'CMD':mx.CMD_LOGCHECK,'NO':1});"


Case "rgameresultlist.asp"
headtitle = "<span class=""prev-txt"">대회별 결과 보기</span>"
homeurl = "index.asp"

Case "operating-state.asp"
mainscript = "tennis_operating.js"
headtitle = "<span class=""prev-txt"">대회별 현황보기</span>"
homeurl = "index.asp"

Case "enter-score.asp"
headtitle = "<span class=""prev-txt"">경기스코어 입력</span>"
homeurl = "javascript:history.back();"
headimgstr = "<a href=""./enter-score.asp""><img src=""images/tournerment/header/kata_tennis_logo@3x.png"" alt=""KATA"" width=""146"" height=""22""></a>"


Case "testadmin.asp"
mainscript = "temp.js"
headtitle = "<span class=""prev-txt"">데이터초기화</span>"
homeurl = "testadmin.asp"

Case Else
headtitle = "<span class=""prev-txt"" id=""DP_Title_Left"">경기스코어 입력 /&nbsp;</span><span class=""prev-txt""> 경기일정</span>"
homeurl = "javascript:history.back();"
End Select 
%>


	
	<title>스포츠 다이어리</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <meta name="apple-mobile-web-app-title" content="스포츠 다이어리">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, minimum-scale=1, initial-scale=1, user-scalable=no">
    <style>
        @-ms-viewport { width: 100vw ; min-zoom: 100% ; zoom: 100% ; }          @viewport { width: 100vw ; min-zoom: 100% zoom: 100% ; }
        @-ms-viewport { user-zoom: fixed ; min-zoom: 100% ; }                   @viewport { user-zoom: fixed ; min-zoom: 100% ; }
    </style>




    <!-- font-awesome -->
    <link rel="stylesheet" type="text/css" href="css/library/font-awesome.min.css">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/bootstrap-theme.css">
    <link href="css/fullcalendar.css" rel="stylesheet">
    <link href="css/fullcalendar.print.css" rel="stylesheet" media="print">
    <!-- custom css -->
    <link rel="stylesheet" type="text/css" href="css/style.css?ver=9">
    <script src="js/library/jquery-1.12.2.min.js"></script>
    <script src="js/jquery.oLoader.min.js"></script><!--로딩바-->
    <script type='application/javascript' src='js/fastclick.js'></script><!--클릭반응속도up-->
    <script src="js/bootstrap.js"></script>

    <%'<script src="cordova.js" id="xdkJScordova_"></script>%>

    <script src="js/app.js"></script>           <!-- for your event code, see README and file comments for details -->
    <script src="js/init-app.js"></script>      <!-- for your init code, see README and file comments for details -->
    <script src="xdk/init-dev.js"></script>     <!-- normalizes device and document ready events, see file for details -->

    <script src="js/global.js?ver=8"></script>

	<script src="js/<%=mainscript%>?ver=7"></script>




