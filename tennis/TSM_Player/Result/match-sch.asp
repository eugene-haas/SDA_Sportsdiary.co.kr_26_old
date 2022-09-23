<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
GameTitleIDX 	=   fInject(Request("GameTitleIDX"))

%>
<script type="text/javascript">
    $(document).ready(function () {
        $.ajax({
            url: "match-sch_JSON.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                ID: "idx"
            },
            success: function (retDATA) {
                //일정 확인 ( 날짜 )
                if (retDATA == "]") {
                    $(".result-match-sche").contents().remove();
                    alert("대회 정보가 없습니다.");
                    window.history.back();
                } else {
                    DATA_match_day(retDATA);
                    //개인전
                    //단체전
                    $.ajax({
                        url: "match-sch_JSON.asp",
                        type: 'POST',
                        dataType: 'html',
                        data: {
                            ID: ""
                        , GameDay: $("#match-day").val()
                        //, GameTitleIDX: GameTitleIDX
                        },
                        success: function (ROWDATA) {
                            DATA_F(ROWDATA);
                        }, error: function (xhr, status, error) {
                            if (error!='') {
								alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
							}
                        }
                    });
                }
            }, error: function (xhr, status, error) {
                if (error!='') {
						alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
					}
            }
        });

        $("#match-day").on({
            "change": function (e) {
                e.preventDefault();
                $.ajax({
                    url: "match-sch_JSON.asp",
                    type: 'POST',
                    dataType: 'html',
                    data: {
                        ID: ""
                        , GameDay: $("#match-day").val()
                    },
                    success: function (ROWDATA) {
                        DATA_F(ROWDATA);
                    }, error: function (xhr, status, error) {
                       if (error!='') {
						alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
					}
                    }
                });
            }
        });


        function DATA_match_day(data) {
            var retDATA = data;
            var retDATAobj = eval(retDATA);
            var len = retDATAobj.length;

            //체크 이미지
            for (var i = 0; i < len; i++) {
                var CNT = retDATAobj[i].CNT;
                var GameDay = retDATAobj[i].GameDay;
                var GameDayNM = retDATAobj[i].GameDayNM;

                if (CNT == 1) {
                    $("#match-day").append("<option value='" + GameDay + "'  selected='selected'>" + GameDayNM + "</option>");
                } else {
                    $("#match-day").append("<option value='" + GameDay + "'>" + GameDayNM + "</option>");
                }
            }
        }


        function DATA_F(data) {

            var retDATA = data;
            var retDATAobj = eval(retDATA);
            var len = retDATAobj.length;


            var alt = "";
            var PTeamGb = "";
            var PTeamGbNm = "";
            var TeamGb = "";
            var TeamGbNm = "";

            var Level = "";
            var LevelNm = "";
            var GroupGameGb = "";
            var GroupGameNm = "";
            var GameType = "";
            var GameENM = "";
            var GameTypeNm = "";
            var StadiumNumber = "";
            var TotRound = "";
            var EntryCnt = "";

            var cnt = 0;
            //체크 이미지
            for (var i = 0; i < len; i++) {
                var CNT = retDATAobj[i].GameTitleName;
                var GameDay = retDATAobj[i].GameDay;
                var GameDayNM = retDATAobj[i].GameDayNM;

                if (i <= 0) {
                    var GameDate = retDATAobj[i].GameSYY + "년 " + retDATAobj[i].GameSMM + "월 " + retDATAobj[i].GameSDD + "일(" + retDATAobj[i].GameSNM + ")   ";
                    if (retDATAobj[i].GameS != retDATAobj[i].GameE) {
                        GameDate = GameDate + "~ "
                        if (retDATAobj[i].GameSYY != retDATAobj[i].GameEYY) { GameDate = GameDate + retDATAobj[i].GameEYY + "년 "; }
                        if (retDATAobj[i].GameSMM != retDATAobj[i].GameEMM) { GameDate = GameDate + retDATAobj[i].GameEMM + "월 "; }
                        if (retDATAobj[i].GameSDD != retDATAobj[i].GameEDD) { GameDate = GameDate + retDATAobj[i].GameEDD + "일(" + retDATAobj[i].GameENM + ") "; }
                    }
                    var stadium = "지역:" + retDATAobj[i].SidoNm + " " + retDATAobj[i].SidoDtl + " / 경기장:" + retDATAobj[i].GameArea;
                    $("#GameTitleName").text(retDATAobj[i].GameTitleName);
                    $("#GameDate").text(GameDate);
                    $("#stadium").text(stadium);
                    $("#match-list").contents().remove();
                }

                if (TeamGb != retDATAobj[i].TeamGb) {
                    if (i > 0) {
                        if (GroupGameNm == "단체전") {
                            $("#match-list").append("<dl><dt>" + TeamGbNm + "</dt></dl>");
                        } else {
                            var strLevelNm = LevelNm.split(",");
                            var forlevelNm = "";
                            var forlevelNm1 = "";

                            for (var w = 1; w <= strLevelNm.length; w++) {
                                forlevelNm1 = forlevelNm1 + strLevelNm[w-1];
                                if (w % 5 == 0) {
                                    forlevelNm = forlevelNm + "<dd>" + forlevelNm1 + "</dd>";
                                    forlevelNm1 = "";
                                }
                            }
                            if (forlevelNm1 != "") {
                                forlevelNm = forlevelNm + "<dd>" + forlevelNm1 + "</dd>";
                                forlevelNm1 = "";
                            }
                            $("#match-list").append("<dl><dt>" + TeamGbNm + " (" + cnt + "체급)</dt>" + forlevelNm + "</dl><p></p>");
                        }
                        LevelNm = "";
                        cnt = 0;
                    }
                }
                //개인전여부
                if (GroupGameGb != retDATAobj[i].GroupGameGb) {
                    $("#match-list").append("<h3>" + retDATAobj[i].GroupGameNm + " </h3><p></p>");
                }

                if (LevelNm == "") {
                    LevelNm = "[ " + retDATAobj[i].LevelNm + " ] ";
                } else {
                    LevelNm = LevelNm + " , [ " + retDATAobj[i].LevelNm + " ]  ";
                }

                if (retDATAobj[i].GameTypeNm == "리그") {
                    //LevelNm = LevelNm + "(리그)";
                }


                GroupGameGb = retDATAobj[i].GroupGameGb;
                GroupGameNm = retDATAobj[i].GroupGameNm;
                Level = retDATAobj[i].Level;
                TeamGb = retDATAobj[i].TeamGb;
                TeamGbNm = retDATAobj[i].TeamGbNm;
                PTeamGb = retDATAobj[i].PTeamGb;
                PTeamGbNm = retDATAobj[i].PTeamGbNm;
                GameType = retDATAobj[i].GameType;
                GameTypeNm = retDATAobj[i].GameTypeNm;
                StadiumNumber = retDATAobj[i].StadiumNumber;
                TotRound = retDATAobj[i].TotRound;
                EntryCnt = retDATAobj[i].EntryCnt;
                cnt = cnt + 1
            }

            if (GroupGameNm == "단체전") {
                $("#match-list").append("<dl><dt>" + TeamGbNm + "</dt></dl>");
            } else {
                var strLevelNm = LevelNm.split(",");
                var forlevelNm = "";
                var forlevelNm1 = "";

                for (var w = 1; w <= strLevelNm.length; w++) {
                    forlevelNm1 = forlevelNm1 + strLevelNm[w - 1];
                    if (w % 5 == 0) {
                        forlevelNm = forlevelNm + "<dd>" + forlevelNm1 + "</dd>";
                        forlevelNm1 = "";
                    }
                }
                if (forlevelNm1 != "") {
                    forlevelNm = forlevelNm + "<dd>" + forlevelNm1 + "</dd>";
                    forlevelNm1 = "";
                }
                $("#match-list").append("<dl><dt>" + TeamGbNm + " (" + cnt + "체급)</dt>" + forlevelNm + "</dl>");

//                $("#match-list").append("<dl><dt>" + TeamGbNm + " ( " + cnt + " 체급 )</dt><dd> &emsp;&emsp;&nbsp;&nbsp;" + LevelNm + " </dd></dl>");
            }
        }
    });

</script>
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대회일정/일정표</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: main -->
  <div class="main result-match-sche">
    <!-- S: sche-title -->
    <div class="sche-title">
      <h2 id ="GameTitleName"></h2>
      <p id ="GameDate"class="match-term"></p>
    </div>
    <!-- E: sche-title -->
    <!-- S: stadium -->
    <div class="stadium">
      <p id ="stadium"></p>
    </div>
    <!-- E: stadium -->
    <!-- S: match-day -->
    <div class="match-day">
      <select id="match-day" name="match-day">    </select>
    </div>
    <!-- E: match-day -->
    <!-- S: match-list -->
    <div id ="match-list" class="match-list">

    </div>
    <!-- E: match-list -->
    <!-- S: time-table -->
    <!-- <div class="time-table">
     <ul>
        <li class="clearfix">
          <span class="time">10:00 ~</span>
          <span class="cont">경기시작</span>
        </li>
        <li class="now clearfix">
          <span class="time">11:00 ~</span>
          <span class="cont">개회식</span>
        </li>
        <li class="clearfix">
          <span class="time">17:00 ~</span>
          <span class="cont">결승 및 시상식(예정)</span>
        </li>
        <li class="clearfix">
          <span class="time">17:00 ~ 17:30</span>
          <span class="cont">공식계체(11.28일 참가선수)</span>
        </li>
      </ul>
    </div>-->
    <!-- E: time-table -->
  </div>
  <!-- E: main -->

  <!-- S: footer -->
  <div class="footer light-footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
</html>
