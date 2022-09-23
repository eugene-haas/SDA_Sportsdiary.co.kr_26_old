<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
  check_login()
  SearchDate    = fInject(request("SearchDate"))  '조회일정
  GameTitleIDX  = fInject(request("GameTitleIDX"))  '대회IDX
  GameTitleName  = fInject(request("GameTitleName"))  '대회IDX
  PlayerReln    =  decode(Request.Cookies("PlayerReln"),0)
%>
<script type="text/javascript">
    var defaultGameTitleIDX = "<%=GameTitleIDX %>";
    var defaultGameTitleName = "<%=GameTitleName %>";
    var defaultStadiumNumber = "";
    var defaultStadiumNumberNm = "";
    var defaultSearchDate = "";
    var checkDefult = "N";

    var Now = new Date();
    var NowTime = Now.getFullYear();
    var month = (Now.getMonth() + 1)
    if (month < 10) {
        month = "0" + month;
    }

    var day = Now.getDate();
    if (day < 10) {
        day = "0" + day;
    }
    NowTime += '-' + month;
    NowTime += '-' + day;

    defaultSearchDate = NowTime;

    $(document).ready(function () {

        $.ajax({
            url: "match-time-table_JSON.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                ID: "idx",
                GameTitleIDX: defaultGameTitleIDX
            },
            success: function (retDATA) {
                //일정 확인 ( 날짜 )
                if (retDATA == "]") {
                    $("#stadium_title").html("");
                    $("#DP_TotalStadium").html("대회정보가 없습니다.");
                    alert("대회 정보가 없습니다.");
                    window.history.back();
                } else {
                    DATA_match_day(retDATA);
                    //경기 상세 일정
                    $.ajax({
                        url: "match-time-table_JSON.asp",
                        type: 'POST',
                        dataType: 'html',
                        data: {
                            ID: "stadium-state",
                            GameTitleIDX: defaultGameTitleIDX,
                            GameDay: $("#match-day").val()
                        },
                        success: function (DATA) {
                            //console.log(DATA);
                            if (DATA == "]") {
                                $("#stadium_title").html("");
                                $("#DP_TotalStadium").html("대회정보가 없습니다.");
                            } else {
                                DATA_stadium_Num(DATA);
                            }
                            $('.hori-scroll').scrollHoriMenu('.hori-scroll');
                        }, error: function (xhr, status, error) {
                            if (error != "") {
                                alert("오류발생! - 시스템관리자에게 문의하십시오!");
                                return;
                            }
                        }
                    });


                }
            }, error: function (xhr, status, error) {
                if (error != "") {
                    alert("오류발생! - 시스템관리자에게 문의하십시오!");
                    return;
                }
            }
        });



        $("#matchfinsh").on({
            "change": function (e) {
                e.preventDefault();
                list_search(defaultStadiumNumber, defaultStadiumNumberNm);
            }
        });

        $("#match-day").on({
            "change": function (e) {
                $("#DP_TotalStadium").html("<span>조회중입니다.</span>");
                e.preventDefault();
                //경기 상세 일정
                $.ajax({
                    url: "match-time-table_JSON.asp",
                    type: 'POST',
                    dataType: 'html',
                    data: {
                        ID: "stadium-state",
                        GameTitleIDX: defaultGameTitleIDX,
                        GameDay: $("#match-day").val()
                    },
                    success: function (DATA) {
                        if (DATA == "]") {
                            $("#stadium_title").html("");
                            $("#DP_TotalStadium").html("대회정보가 없습니다.");
                        } else {
                            DATA_stadium_Num(DATA);
                        }
                    }, error: function (xhr, status, error) {
                        if (error != "") {
                            alert("오류발생! - 시스템관리자에게 문의하십시오!");
                            return;
                        }
                    }
                });
            }
        });
    });

    /*일정 select*/
    function DATA_match_day(data) {
        var retDATA = data;
        var retDATAobj = eval(retDATA);
        var len = retDATAobj.length;


        for (var i = 0; i < len; i++) {
            var GameDay = retDATAobj[i].GameDay;
            var GameDayNM = retDATAobj[i].GameDayNM;

            if (GameDay == defaultSearchDate) {
                checkDefult = "Y";
            }
        };

        //체크 이미지
        for (var i = 0; i < len; i++) {
            var CNT = retDATAobj[i].CNT;
            var GameDay = retDATAobj[i].GameDay;
            var GameDayNM = retDATAobj[i].GameDayNM;

            if (checkDefult == "Y") {
                if (checkDefult == GameDay) {
                    $("#match-day").append("<option value='" + GameDay + "'  selected='selected'>" + GameDayNM + "</option>");
                } else {
                    $("#match-day").append("<option value='" + GameDay + "'>" + GameDayNM + "</option>");
                }
                $("#matchfinsh").val("0");
            } else {
                if (CNT == 1) {
                    $("#match-day").append("<option value='" + GameDay + "'  selected='selected'>" + GameDayNM + "</option>");
                } else {
                    $("#match-day").append("<option value='" + GameDay + "'>" + GameDayNM + "</option>");
                }
                $("#matchfinsh").val("1");
            }
        }
    }


    /*대회장소 select*/
    function DATA_stadium_Num(data) {
        var retDATA = eval(data);
        //체크 이미지
        var StadiumText = "";  //<li id='list_0'><a class='btn btn-stadium' onclick=list_search('','list_0');>전체</a></li>
        var StadiumNumber = ""; //0
        var StadiumNumberNm = ""; //전체
        var fStadiumNumberNm = ""; //전체
        var fStadiumNumber = ""; //전체


        for (var i = 0; i < retDATA.length; i++) {

            var GroupGameGb = retDATA[i].GroupGameGb;
            var GroupGameNm = retDATA[i].GroupGameNm;
            var PTeamGb = retDATA[i].PTeamGb;
            var PTeamGbNm = retDATA[i].PTeamGbNm;
            var TeamGb = retDATA[i].TeamGb;
            var TeamGbNm = retDATA[i].TeamGbNm;

            if (StadiumNumber != retDATA[i].StadiumNumber) {
                StadiumNumber = retDATA[i].StadiumNumber;
                StadiumNumberNm = retDATA[i].StadiumNumberNm;
                if (i == 0) {
                    StadiumText += "<li id='list_" + StadiumNumber + "'><a  class='btn btn-stadium on' onclick=list_search('" + StadiumNumber + "','list_" + StadiumNumber + "');>" + StadiumNumberNm + "</a></li>"
                    fStadiumNumberNm = "list_" + StadiumNumber;
                    fStadiumNumber = StadiumNumber;
                }
                else {
                    StadiumText += "<li id='list_" + StadiumNumber + "'><a  class='btn btn-stadium ' onclick=list_search('" + StadiumNumber + "','list_" + StadiumNumber + "');>" + StadiumNumberNm + "</a></li>"
                }
            }
        }
        $("#stadium_title").html(StadiumText);
        list_search(fStadiumNumber, fStadiumNumberNm);


    }



    function list_search(p_StadiumNumber, p_StadiumNumber_id) {
        //경기 상세 일정 리스트
        $("#stadium_title").children("li").children("a").removeClass("on");
        $("#" + p_StadiumNumber_id).children("a").addClass("on");
        defaultStadiumNumber = p_StadiumNumber;
        defaultStadiumNumberNm = p_StadiumNumber_id;
        $.ajax({
            url: "match-time-table_JSON.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                ID: "stadium-list",
                GameTitleIDX: defaultGameTitleIDX,
                GameDay: $("#match-day").val(),
                StadiumNumber: p_StadiumNumber
            },
            success: function (DATA) {
                if (DATA == "]") {
                    $("#DP_TotalStadium").html("대회정보가 없습니다.");
                } else {
                    list_Html(DATA);
                }
            }, error: function (xhr, status, error) {
                if (error != "") {
                    alert("오류발생! - 시스템관리자에게 문의하십시오!");
                    return;
                }
            }
        });

    }

    function list_Html(DATA) {
        var retDATA = eval(DATA); ;
        var strHtml = "";
        var StadiumNumber = "";
        var seq = 0;
        var forcusidFI = "";
        var forcusid = "";

        for (var i = 0; i < retDATA.length; i++) {

            if ($("#matchfinsh").val() == "0" && retDATA[i].GameStatus == "경기완료") {
                //진행중
                continue;
            }

            if ($("#matchfinsh").val() == "0") {
                if (retDATA[i].LUserName.indexOf("불참자") >= 0 || retDATA[i].RUserName.indexOf("불참자") >= 0 || retDATA[i].LResult == "sd019006" || retDATA[i].RResult == "sd019006") {
                    if (retDATA[i].BeforGameStatus = "sd050002") {
                        continue;
                    }
                }
            }



            var tabindexStr = "";
            if (checkDefult == "Y") {
                tabindexStr = " tabindex=-1 ";
            }
            var groupStrClass = ""

            if (retDATA[i].GroupGameGb == "sd040002") {
                groupStrClass = "group";
            }

            strHtml += "<div class='match " + groupStrClass + "' id='match" + i + "' " + tabindexStr + " >";

            strHtml += "<ul class='clearfix'>";
            strHtml += "<li  >" + retDATA[i].NowRoundNM + "</li>";

            if (retDATA[i].GameStatus == "") {
                strHtml += "<li><span class=''>" + retDATA[i].GameStatus + "</span></li>";
            } else if (retDATA[i].GameStatus == "경기완료") {
                strHtml += "<li><span class='playing'>" + retDATA[i].GameStatus + "</span></li>";
                forcusidFI = "match" + i;
            } else {
                strHtml += "<li ><span class='playing'>" + retDATA[i].GameStatus + "</span></li>";
                forcusid = "match" + i;
            }

            strHtml += "</ul>";
            strHtml += "<ul class='clearfix'>";
            strHtml += "<li>" + retDATA[i].GroupGameGbNM + "</li>";
            strHtml += "<li>" + retDATA[i].TeamGBNM + "</li>";
            strHtml += "<li>" + retDATA[i].LevelNM + "</li>";
            strHtml += "</ul>";
            strHtml += "<ul class='match-info clearfix'>";

            //GroupGameNum GameNum
            if (retDATA[i].GroupGameGb == "sd040001") {
                strHtml += "<li><span class='num-box'>" + retDATA[i].TempNum + "</span></li>";
                //strHtml += "<li><span class='num-box'>" + retDATA[i].GameNum + "</span></li>";
                //strHtml += "<li><span class='num-box'>" + retDATA[i].rowNum + "</span></li>";
            }
            else {
                strHtml += "<li><span class='num-box'>" + retDATA[i].TempNum + "</span></li>";
                //strHtml += "<li><span class='num-box'>" + retDATA[i].GroupGameNum + "</span></li>";
                //strHtml += "<li><span class='num-box'>" + retDATA[i].rowNum + "</span></li>";
            }


            strHtml += "<li class='clearfix'>";
            //7글자
            //학교 7개

            if (retDATA[i].GroupGameGb == "sd040001") {
                strHtml += "<div class='player player-1'>";
                strHtml += "<span class='player-name'>" + retDATA[i].LUserName.substr(0, 7) + "</span>";
                strHtml += "<span class='belong'>" + retDATA[i].LSchoolName.substr(0, 7) + "</span>";
                strHtml += "</div>";
                strHtml += "<span class='vs'>VS</span>";
                strHtml += "<div class='player player-2'>";
                strHtml += "<span class='player-name'>" + retDATA[i].RUserName.substr(0, 7) + "</span>";
                strHtml += "<span class='belong'>" + retDATA[i].RSchoolName.substr(0, 7) + "</span>";
                strHtml += "</div>";
            }
            else {
                strHtml += "<div class='player player-1'>";
                strHtml += "<span class='player-name'>" + retDATA[i].LSchoolName.substr(0, 7) + "</span>";
                strHtml += "<span class='belong'></span>";
                strHtml += "</div>";

                strHtml += "<span class='vs'>VS</span>";

                strHtml += "<div class='player player-2'>";
                strHtml += "<span class='player-name'>" + retDATA[i].RSchoolName.substr(0, 7) + "</span>";
                strHtml += "<span class='belong'></span>";
                strHtml += "</div>";
            }
            strHtml += "</li>";
            strHtml += "</ul>";
            strHtml += "</div>";

        }


        $("#DP_TotalStadium").html(strHtml);

        if (checkDefult == "Y") {
            if (forcusid != "") {
                $("#" + forcusid).tabindex = -1;
                $("#" + forcusid).focus();
            } else {
                if (forcusidFI != "") {
                    $("#" + forcusidFI).tabindex = -1;
                    $("#" + forcusidFI).focus();
                }
            }
        }
    }


    setInterval(function () { list_search(defaultStadiumNumber, defaultStadiumNumberNm); }, 20000);
</script>
<body class="lack-bg">

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>경기진행 현황</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: main -->
  <div class="main round-board">
    <!-- S: match-info -->
    <div class="match-info">
      <h2 class="title"><%=GameTitleName %></h2>
      <select id="match-day" name="match-day"> </select>
      <select id="matchfinsh" name="matchfinsh">
      <option value="0">진행중(예정)인 경기만 보기</option>
      <option value="1">경기완료 포함 보기</option></select>
    </div>
    <!-- E: match-info -->
    <!-- S: table-txt-box -->
    <div class="table-txt-box">
      <p class="info-txt">
        ※경기순서는 경기운영시 일부 변경 될 수 있습니다.
      </p>
  <!--    <p class="info-txt">
        ※<span>부전승</span>의 경우 진행사항표에 표기되지 않습니다.
      </p>-->
    </div>
    <!-- E: table-txt-box -->

    <!-- S: stadium-list -->
    <div class="stadium-list hori-scroll">
      <ul class="total-box clearfix" id="stadium_title">
        <li><a href="#" class="btn btn-stadium on">전체</a></li>
        <li><a href="#" class="btn btn-stadium">제1경기장</a></li>
        <li><a href="#" class="btn btn-stadium">제2경기장</a></li>
        <li><a href="#" class="btn btn-stadium">제3경기장</a></li>
        <li><a href="#" class="btn btn-stadium">제4경기장</a></li>
      </ul>
    </div>
    <!-- E: stadium-list -->

    <!-- S: round-table -->
    <div class="round-table" id="DP_TotalStadium">
      <!-- S: match -->
<!--      <div class="match match-1">
        <ul class="clearfix">
          <li>64강</li>
          <li>개인전</li>
          <li>남자고등부</li>
          <li>-60kg</li>
          <li><span class="playing">진행중</span></li>
        </ul>
        <ul class="match-info clearfix">
          <li><span class="num-box">25</span></li>
          <li class="clearfix">
            <div class="player player-1">
              <span class="player-name">김하윤</span>
              <span class="belong">삼정고등학교</span>
            </div>
            <span class="vs">VS</span>
            <div class="player player-2">
              <span class="player-name">임보영</span>
              <span class="belong">경민IT고등학교</span>
            </div>
          </li>
        </ul>
      </div>-->
      <!-- E: match -->

      <!-- S: match -->
<!--      <div class="match match-1">
        <ul class="clearfix">
          <li>64강</li>
          <li>개인전</li>
          <li>남자고등부</li>
          <li>-60kg</li>
          <li><span class="playing">진행중</span></li>
        </ul>
        <ul class="match-info clearfix">
          <li><span class="num-box">25</span></li>
          <li class="clearfix">
            <div class="player player-1">
              <span class="player-name">김하윤</span>
              <span class="belong">삼정고등학교</span>
            </div>
            <span class="vs">VS</span>
            <div class="player player-2">
              <span class="player-name">임보영</span>
              <span class="belong">경민IT고등학교</span>
            </div>
          </li>
        </ul>
      </div>-->
      <!-- E: match -->
    </div>
    <!-- E: round-table -->
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
