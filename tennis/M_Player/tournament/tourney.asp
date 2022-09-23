<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<script src="../../webtournament/www/js/global.js"></script>
<script src="../../SD_OS/js/tennis.js" type="text/javascript"></script>
<script type="text/javascript">

    var score = score || {};
    score.smenu = null;
    score.gameSearch = function (tabletype) {
        var gameidx = localStorage.getItem("GameTitleIDX"); //경기인덱스

        var searchstr1 = $('input:radio[name="game-type"]:checked').val();
        var searchstr2 = $("#TeamGb").val();
        var searchstr3 = $("#SexLevel").val();

        if (searchstr3 == '' || searchstr3 == undefined || searchstr3 == false) {
            alert("종목을 선택해 주세요.");
            return;
        }
        else {
            var tt, sidx; //sidx 조별 인덱스
            if (typeof tabletype == "object") {
                tt = tabletype.TT; //넘겨야할 TT값 설정( 스코어 ,결과 , 운영 에서 같은 ajax api 를 사용하므로 이를 구분할 값이 필요함
                sidx = tabletype.SIDX;
            }
            else {
                tt = tabletype;
                sidx = 0;
            }

            //백버튼적용을 위해 검색내용 저장
            localStorage.setItem('searchinfo', [searchstr1, searchstr2, searchstr3, gameidx, tt, sidx]);
            mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_app, 'IDX': gameidx, 'S1': searchstr1, 'S2': searchstr2, 'S3': searchstr3, 'TT': tt, 'SIDX': sidx });
        }
    };

    score.showScore = function (pobj) {
        pobj.CMD = mx.CMD_ScoreBoard;


        mx.SendPacket('ScoreBoard', pobj);

        //점수판
        pobj.CMD = mx.CMD_ScoreDetailBoard;

        //상세내역
        // mx.SendPacket('DetailScoreBoard', pobj);

        //영상
        // mx.SendPacket('videoBoard', pobj);

        $(".tn_modal").modal("show");
    };

    //스코어 입력전 정보 생성
    score.inputScore = function (pobj) {
        pobj.CMD = mx.CMD_FINDSCORE;
        var s1text;
        var gametitleidx = localStorage.getItem("GameTitleIDX");
        var gametitle = localStorage.getItem("GameTitleName");
        var entertype = localStorage.getItem("EnterType");
        var searchstr1 = $('input:radio[name="game-type"]:checked').val();
        if (searchstr1 == 'tn001001') {
            s1text = "개인전";
        }
        else {
            s1text = "단체전";
        }
        var searchkey2 = $("#TeamGb option:checked").val();
        var searchstr2 = $("#TeamGb option:checked").text();
        var searchkey3 = $("#SexLevel option:checked").val();
        var searchstr3 = $("#SexLevel option:checked").text();

        pobj.S1KEY = searchstr1;
        pobj.GIDX = gametitleidx;
        pobj.GTITLE = gametitle;
        pobj.S1STR = s1text;
        pobj.S2STR = searchstr2;
        pobj.S3STR = searchstr3;
        pobj.S2KEY = searchkey2;
        pobj.S3KEY = searchkey3;
        pobj.ETYPE = entertype;

        mx.SendPacket(null, pobj);
    };

    //스코어 입력전 정보 생성
    score.inputMainScore = function (pobj) {

    };


    score.drLevelList = function (targetid, TeamGb, lineall) {
        var obj = {};
        obj.SportsGb = localStorage.getItem("SportsGb");
        obj.GIDX = localStorage.getItem("GameTitleIDX");
        obj.TeamGb = TeamGb;
        obj.CMD = mx.CMD_TEAMCODERALLY;
        obj.LNALL = lineall;
        mx.SendPacket(targetid, obj);
    };

    score.settingSearch = function () {
        score.smenu = localStorage.getItem('smenu'); //메뉴항목 가져오기

        if (score.smenu == "" || score.smenu == undefined) { //메뉴가 구성되지 않았다면
            score.drLevelList("#SexLevel", $("#TeamGb").val(), 'setmenu');
        }
        else {
            //메뉴다시그리고######################
            if (score.smenu.split(",")[0] == 0) {//단식부
                $("#TeamGb").children("option").remove();
                if (score.smenu.split(",")[1] > 0) {//개인복식
                    $("#TeamGb").append("<option value='201' selected>복식</option>");
                }
                else {
                    $("#_s1menu1").hide();
                }
            }
            else {
                var teamgbval = $("#TeamGb option:selected").val();
                $("#TeamGb").children("option").remove();

                if (teamgbval = "200") {
                    $("#TeamGb").append("<option value='200' selected>단식</option>");
                }
                else {
                    $("#TeamGb").append("<option value='200'>단식</option>");
                }

                if (score.smenu.split(",")[1] > 0) {//개인복식
                    if (teamgbval = "200") {
                        $("#TeamGb").append("<option value='201' selected>복식</option>");
                    }
                    else {
                        $("#TeamGb").append("<option value='201'>복식</option>");
                    }
                }
            }

            if (score.smenu.split(",")[2] == 0) {//단체부
                $("#_s1menu2").hide();
            }
            //메뉴다시그리고######################

            //스코어입력페이징에서 이전페이지버튼 눌렀을시.. 기존SELECT 선택된값 선택
            if (localStorage.getItem("BackPage") == "enter-score") {
                var selectinfo = localStorage.getItem('searchinfo').split(','); //조회 저장 정보

                $("input:radio[name='game-type']:input[value='" + selectinfo[0] + "']").attr("checked", true);
                $("#TeamGb option[value=" + selectinfo[1] + "]").attr('selected', 'selected');

                score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
                mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_app, 'IDX': selectinfo[3], 'S1': selectinfo[0], 'S2': selectinfo[1], 'S3': selectinfo[2], 'TT': selectinfo[4], 'SIDX': selectinfo[5] })
                localStorage.setItem('BackPage', 'rgamelist');
            }
            else if (localStorage.getItem("BackPage") == "enter-score-tourn") {



                var selectinfo = localStorage.getItem('searchinfo').split(','); //조회 저장 정보

                $("input:radio[name='game-type']:input[value='" + selectinfo[0] + "']").attr("checked", true);
                $("#TeamGb option[value=" + selectinfo[1] + "]").attr('selected', 'selected');

                score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
                mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_app, 'IDX': selectinfo[3], 'S1': selectinfo[0], 'S2': selectinfo[1], 'S3': selectinfo[2], 'TT': selectinfo[4], 'SIDX': selectinfo[5] })
                localStorage.setItem('BackPage', 'rgamelist');



            }
            else {
                localStorage.setItem("GroupGameGb", $('input:radio[name="game-type"]:checked').val());
                localStorage.setItem('BackPage', 'rgamelist');
                score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
            }
        }

    };

    function onDeviceReady() {
        document.addEventListener("backbutton", onBackKey, false);
    }
    function onBackKey() {
        var userAgent = navigator.userAgent || navigator.vendor || window.opera;

    }


    $(document).ready(function () {
        //스코어입력 정보 삭제
        localStorage.removeItem('COURTPLAYERS');
        localStorage.removeItem('FIRSTPLAYERS');
        localStorage.removeItem('REQ');
        //스코어입력 정보 삭제


        /*radio click*/
        $("input[name='game-type']").click(function () {
            localStorage.setItem("GroupGameGb", $("input[name='game-type']:checked").val());

            if ($("input[name='game-type']:checked").val() == 'tn001001') { //개인전

                //메뉴다시그리고######################
                if (score.smenu.split(",")[0] == 0) {//단식부
                    $("#TeamGb").children("option").remove();
                    if (score.smenu.split(",")[1] > 0) {//개인복식
                        $("#TeamGb").append("<option value='201' selected>복식</option>");
                    }
                    else {
                        $("#_s1menu1").hide();
                    }
                }
                else {
                    $("#TeamGb").children("option").remove();
                    $("#TeamGb").append("<option value='200' selected>단식</option>");
                    if (score.smenu.split(",")[1] > 0) {//개인복식
                        $("#TeamGb").append("<option value='201'>복식</option>");
                    }
                }
                //메뉴다시그리고######################
            }
            else {
                $('#TeamGb').children("option").remove();
                $('#TeamGb').append("<option value='202'>복식</option>");
            }

            if (score.smenu == "" || score.smenu == undefined) { //메뉴가 구성되지 않았다면
                score.drLevelList("#SexLevel", $("#TeamGb").val(), 'setmenu');
            }
            else {
                score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
            }
        });

        document.addEventListener("deviceready", onDeviceReady, false);
        $("#tourney_title").html(localStorage.getItem("GameTitleName") + " 본선");
        score.settingSearch();
    });

</script>

<head>
<meta name="viewport" content="width=device-width, minimum-scale=1, initial-scale=1">
</head>
<body id="AppBody">
  <!--<a href="#" data-target="#show-tourney-pop" data-toggle="modal" class="init_btn"></a>-->

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대진표</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub sub-main -->
  <div class="sub sub-main tourney h-fix">
    <!-- S: tourney-title -->
    <div class="tourney-title">
      <h3 id="tourney_title"></h3>
    </div>
    <!-- E: tourney-title -->
    <!-- S: tourney-sel -->
    <div class="tourney-sel">
      <ul class="clearfix">
        <li class="game-type" id="_s1menu1">
            <label>
            <label for="game-typeA" class="type-text">개인전</label>
            <span><input type="radio" name="game-type" id="game-typeA" value="tn001001" checked=""></span>
            </label>
        </li>
        <li class="game-type" id="_s1menu2" style="display: none;">
            <label>
            <label for="game-typeB" class="type-text">단체전</label>
            <input type="radio" name="game-type" id="game-typeB" value="tn001002">
            </label>
        </li>
        <li>
            <select id="TeamGb" onchange="score.settingSearch();" data-native-menu="false">  <option value="201" selected="">복식</option></select>
        </li>
        <li>
          <select name="SexLevel" id="SexLevel"  data-native-menu="false"><option value="20101002" selected="">개나리부 (구리)</option></select>
        </li>
        <li>
          <button type="button" id="search" class="btn btn-warning btn-search" onmousedown="score.gameSearch(1)">조 회</button>
        </li>

      </ul>
    </div>
    <!-- E: tourney-sel -->

    <!-- S: tn_live_tab -->
    <div class="tn_live_tab">
      <!-- S: btn_list btn_2 -->
      <div class="btn_list btn_2">
        <ul class="flex">
         <!-- <li>
            <a href="./tourney.asp" class="btn btn-normal on">전체</a>
          </li>
          <li>
            <a href="./live_score.asp" class="btn btn-normal btn-live-score"><span class="ic_deco live">LIVE</span>LIVE SCORE <span class="ic_deco"><i class="fa fa-wifi"></i></span></a>
          </li>-->
        </ul>
      </div>
      <!-- E: btn_list btn_2 -->
    </div>
    <!-- E: tn_live_tab -->

    <!-- S: banner banner_md -->
    <!-- <div class="banner banner_md">
      <div class="img_box">
        <img src="../images/public/banner_md@3x.png" alt="광고영역">
      </div>
    </div> -->
    <!-- E: banner banner_md -->


    <!-- S: show-btn -->
		<!--
    <div class="show-btn">
      <ul class="flex">
        <li onclick="view_result('A');"><a href="#" class="tab-btn tourney-result result-search-list on" id="Btn_Tournament">예선</a></li>
        <li onclick="view_result('B');"><a href="#" class="tab-btn result-report result-search-list" id="Btn_ResultList">본선</a></li>
      </ul>
    </div>
		-->
    <!-- E: show-btn -->

     <!-- S: hidden-main -->
    <div class="tourney-mode " id="scoregametable">

    </div>
     <!-- E: hidden-main -->

     <!-- S: tourney-list -->
     <div class="tourney-list result-report" id ="DP_ResultReport" >   </div>
    <!-- E: tourney-list -->

 </div>
    <!-- E: tourney-mode -->
  <!-- E: sub sub-main board -->

  <!-- S: 테니스 상세스코어 모달 -->
  <!-- #include file="../include/modal/tn_score_record.asp" -->
  <!-- E: 테니스 상세스코어 모달 -->



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
