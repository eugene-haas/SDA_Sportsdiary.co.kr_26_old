var scorefreshCnt = 10;
var scorefreshR;
function scorefreshStart() {
    console.log("scorefreshR 실행");
    console.log(scorefreshCnt);

    if (scorefreshCnt > 100) {
        clearInterval(scorefreshR);
        console.log("scorefreshR 종료");
    } else {
        if (scorefreshCnt > 1) {
            scorefreshCnt--;
            $("#scorefreshCnt").text(" " + scorefreshCnt + " 초 후 새로고침");
        } else {
            $("#scorefreshCnt").click();
        }
    }
}

function scorefreshClear() {
    scorefreshCnt = 999;
    clearInterval(scorefreshR);
    console.log("scorefreshR 종료");
}

var score = score || {};
score.smenu = null;
score.gameSearch = function (tabletype) {
    scorefreshClear();
    var Round_s = tabletype;
    if (tabletype >= 10000) {
        $("#H_GameType").val(1);
        tabletype = 1;
        Round_s = Round_s - 10000;
    } else {
        $("#H_GameType").val(tabletype);
        Round_s = "";
    }
     
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
            Round_s = tabletype.Round_s;
        }
        else {
            tt = tabletype;
            sidx = 0;
            Round_s = Round_s;
        }

        //백버튼적용을 위해 검색내용 저장
        localStorage.setItem('searchinfo', [searchstr1, searchstr2, searchstr3, gameidx, tt, sidx, Round_s]);

        mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_Home, 'IDX': gameidx, 'S1': searchstr1, 'S2': searchstr2, 'S3': searchstr3, 'TT': tt, 'SIDX': sidx, 'Round_s': Round_s });
    }
};
score.gameSearch_result = function (tabletype) {
    scorefreshClear();
    var Round_s = tabletype;
    if (tabletype >= 10000) {
        $("#H_GameType").val(1);
        tabletype = 1;
        Round_s = Round_s - 10000;
    } else {
        $("#H_GameType").val(tabletype);
        Round_s = "";
    }

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
            Round_s = tabletype.Round_s;
        }
        else {
            tt = tabletype;
            sidx = 0;
            Round_s = Round_s;
        }

        //백버튼적용을 위해 검색내용 저장
        localStorage.setItem('searchinfo', [searchstr1, searchstr2, searchstr3, gameidx, tt, sidx, Round_s]);

        mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_Result_Home, 'IDX': gameidx, 'S1': searchstr1, 'S2': searchstr2, 'S3': searchstr3, 'TT': tt, 'SIDX': sidx, 'Round_s': Round_s });
    }
};

score.showScore = function (pobj) {
    if (pobj.movieYn == "Y") {
        iMovieLink("", "", "", pobj.SCIDX);
        $("#round-res").modal("show");
    } else {
        $(".modal-header").removeClass("livescore");
        $("#modalTitle").html("상세스코어").removeClass("livescore");
        pobj.CMD = mx.CMD_ScoreBoard;
        mx.SendPacket('ScoreBoard', pobj);

        //점수판
        pobj.CMD = mx.CMD_ScoreDetailBoard;

        //상세내역
        pobj.CMD = mx.CMD_ScoreDetailBoardLive;
        pobj.s2key = $("#TeamGb").val(); //	'단식 복식 구분
        pobj.entertype = "A"; //	''엘리트 E 아마추어 A

        mx.SendPacket('ScoreList', pobj);

        //기록 상세

        //영상
        // mx.SendPacket('videoBoard', pobj);
        $("#round-res-live").modal("show");
    }

};

score.showScoreLive = function (pobj) {
    $(".modal-header").addClass("livescore");
    $("#modalTitle").html("LiveScore").addClass("livescore");
    //점수판
    pobj.CMD = mx.CMD_ScoreBoardLive;
    mx.SendPacket('ScoreBoard', pobj);

    //상세내역
    pobj.CMD = mx.CMD_ScoreDetailBoardLive;
    pobj.s2key = $("#TeamGb").val(); //	'단식 복식 구분
    pobj.entertype = "A"; //	''엘리트 E 아마추어 A

    mx.SendPacket('ScoreList', pobj);
    $("#round-res-live").modal("show");
    scorefreshClear();
    scorefreshCnt = 10;
    scorefreshR = setInterval(scorefreshStart, 1000);
};

//스코어 입력전 정보 생성
score.inputScore = function (pobj) {

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
            mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_Home, 'IDX': selectinfo[3], 'S1': selectinfo[0], 'S2': selectinfo[1], 'S3': selectinfo[2], 'TT': selectinfo[4], 'SIDX': selectinfo[5] })
            localStorage.setItem('BackPage', 'rgamelist');
        }
        else if (localStorage.getItem("BackPage") == "enter-score-tourn") {



            var selectinfo = localStorage.getItem('searchinfo').split(','); //조회 저장 정보

            $("input:radio[name='game-type']:input[value='" + selectinfo[0] + "']").attr("checked", true);
            $("#TeamGb option[value=" + selectinfo[1] + "]").attr('selected', 'selected');

            score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
            mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_Home, 'IDX': selectinfo[3], 'S1': selectinfo[0], 'S2': selectinfo[1], 'S3': selectinfo[2], 'TT': selectinfo[4], 'SIDX': selectinfo[5] })
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


    $('#round-res-live').on('hidden.bs.modal', function (e) {
        scorefreshClear();
    });


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
    $("#tourney_title").html(localStorage.getItem("GameTitleName"));

});
