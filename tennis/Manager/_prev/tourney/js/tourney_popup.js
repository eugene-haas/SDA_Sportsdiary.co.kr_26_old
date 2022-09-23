
//S:스코어 수정버튼 눌렀을 시..
function editscore(objbtn) {

    if (typeof 변수 == "undefined") {
        return false;
    }

    var objClass = $(objbtn).attr("class");
    //게임 번호 가져오기
    //단체전일때 단체전 구성페이지, 개인전일때 스코어 입력페이지
    if (localStorage.getItem("GroupGameGb") == "sd040001") {
        //몇라운드인지 담기
        localStorage.setItem("PlayerGameNum", objbtn.getAttribute("data-id"));
        //라운드 depth 담기(몇번째 강인지..)
        localStorage.setItem("PlayRound", objbtn.getAttribute("data-whatever"));

        //몇라운드인지 담기
        localStorage.setItem("GroupGameNum", "0");
        //라운드 depth 담기(몇번째 강인지..)
        localStorage.setItem("GroupRound", "0");

        //현재점수가져오기
        nowscore(objbtn.getAttribute("data-id"));

        //선수 & 승자가져오기
        loadwinresult(objbtn.getAttribute("data-id"));

        //현재 양측 부전패,무승부인지
        nowdualresult(objbtn.getAttribute("data-id"));

        //경기로그 가져오기
        loadplaylog(objbtn.getAttribute("data-id"));


        $("#show-score").modal("show");
        history.pushState({ page: 1, name: '팝업' }, '', '?GameTitleIDX=' + localStorage.getItem("GameTitleIDX") + '&GameTitleName=' + localStorage.getItem("GameTitleName"));
    }
    else {

        localStorage.setItem("GroupGameNum", objbtn.getAttribute("data-id"));
        //라운드 depth 담기(몇번째 강인지..)
        localStorage.setItem("GroupRound", objbtn.getAttribute("data-whatever"));

        //학교vs학교 결과 및 점수
        select_groupresult();

        //현재 양측 부전패,무승부인지
        nowGroupdualresult(objbtn.getAttribute("data-id"));

        //학교의 참가자
        select_rplayer();
        $("#groupshow-score").modal("show");
        history.pushState({ page: 1, name: '팝업' }, '', '?GameTitleIDX=' + localStorage.getItem("GameTitleIDX") + '&GameTitleName=' + localStorage.getItem("GameTitleName"));
    }
}



//S:현재점수 가져오기
var nowscore = function (strPlayerGameNum) {
    var defer = $.Deferred();

    var obj = {};

    obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
    obj.PlayerGameNum = strPlayerGameNum;

    var jsonData = JSON.stringify(obj);

    var events = "";

    $.ajax({
        url: '../../ajax/judo_os/GGameNowScore.ashx',
        type: 'post',
        data: jsonData,
        success: function (sdata) {

            var myArr = JSON.parse(sdata);


            if (myArr.length > 0) {

                if (myArr[0].Left01 != "") {

                    $("#LJumsuGb1").html(myArr[0].Left01);
                    $("#LJumsuGb2").html(myArr[0].Left02);
                    //$("#LJumsuGb3").html(myArr[0].Left03);
                    $("#LJumsuGb4").html(myArr[0].Left04);
                    $("#RJumsuGb1").html(myArr[0].Right01);
                    $("#RJumsuGb2").html(myArr[0].Right02);
                    //$("#RJumsuGb3").html(myArr[0].Right03);
                    $("#RJumsuGb4").html(myArr[0].Right04);

                }
                else {

                    $("#LJumsuGb1").html("0");
                    $("#LJumsuGb2").html("0");
                    //$("#LJumsuGb3").html("0");
                    $("#LJumsuGb4").html("0");
                    $("#RJumsuGb1").html("0");
                    $("#RJumsuGb2").html("0");
                    //$("#RJumsuGb3").html("0");
                    $("#RJumsuGb4").html("0");
                }


            }
            else {

                $("#LJumsuGb1").html("0");
                $("#LJumsuGb2").html("0");
                //$("#LJumsuGb3").html("0");
                $("#LJumsuGb4").html("0");
                $("#RJumsuGb1").html("0");
                $("#RJumsuGb2").html("0");
                //$("#RJumsuGb3").html("0");
                $("#RJumsuGb4").html("0");

            }

            defer.resolve(sdata);
        },
        error: function (errorText) {
            defer.reject(errorText);
        }
    });

    return defer.promise();

}
//E:현재점수 가져오기


//S:대전선수명 및 승자 가져오기
var loadwinresult = function (strPlayerGameNum) {
    var defer = $.Deferred();

    var obj = {};

    obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
    obj.PlayerGameNum = strPlayerGameNum;

    var jsonData = JSON.stringify(obj);

    var events = "";


    $("#DP_L_GameResult").find("option").remove();
    $("#DP_R_GameResult").find("option").remove();

    $.ajax({
        url: '../../ajax/judo_os/GGameWinResult.ashx',
        type: 'post',
        data: jsonData,
        success: function (sdata) {


            //alert(sdata);

            var myArr = JSON.parse(sdata);

            if (myArr.length > 0) {

                $("#DP_Edit_LPlayer").attr("class", "player-name");
                $("#DP_Edit_RPlayer").attr("class", "player-name");

                //modal 선수명 표시
                $("#DP_Edit_LPlayer").html(myArr[0].LPlayerName);
                $("#DP_Edit_RPlayer").html(myArr[0].RPlayerName);

                $("#DP_Edit_LSCName").html(myArr[0].LSchoolName);
                $("#DP_Edit_RSCName").html(myArr[0].RSchoolName);

                localStorage.setItem("MediaLink", myArr[0].MediaLink);

                if (localStorage.getItem("MediaLink") == "") {
                    $("#btn_movie").addClass("off").html('영상미등록'); //.text("영상미등록");
                } else {
                    $("#btn_movie").removeClass("off").html('<span class="ic-deco"><img src="../images/film-icon@3x.png" alt="">  </span><span>영상보기</span>'); //.text("영상보기");
                }

                if (myArr[0].LResult != "") {
                    //승리자 트로피표시
                    $("#DP_Edit_LPlayer").attr("class", "player-name");
                    $("#DP_Edit_LPlayer").prev().attr("class", "disp-win");

                    //상단 승리표시
                    $("#DP_Win_Title").html(myArr[0].LResult);


                    //좌측선수 반칙,실격,부전/기권 승 selected
                    if (myArr[0].LPlayerResult == "sd019005" || myArr[0].LPlayerResult == "sd019013" || myArr[0].LPlayerResult == "sd019006" || myArr[0].LPlayerResult == "sd019022" || myArr[0].LPlayerResult == "sd019025" || myArr[0].LPlayerResult == "sd019026") {
                        $("#DP_L_GameResult").append("<option value='" + myArr[0].LPlayerResult + "'>" + myArr[0].LResult + "</option>");
                    }
                    else {
                        $("#DP_L_GameResult").append("<option value=''>" + "-" + "</option>");
                    }

                    if (myArr[0].LPlayerResult == "sd019012" || myArr[0].RPlayerResult == "sd019021") {
                        $("#DP_Edit_LPlayer").attr("class", "player-name");
                    }

                    $(".modal-body").find("h4 > span").html(myArr[0].LResult);
                }
                else {
                    $("#DP_L_GameResult").append("<option value=''>" + "-" + "</option>");
                    $("#DP_Edit_LPlayer").attr("class", "player-name");
                    $("#DP_Edit_LPlayer").prev().attr("class", "disp-none");
                }

                if (myArr[0].RResult != "") {
                    //승리자 트로피표시
                    $("#DP_Edit_RPlayer").attr("class", "player-name");
                    $("#DP_Edit_RPlayer").prev().attr("class", "disp-win");
                    //상단 승리표시
                    $("#DP_Win_Title").html(myArr[0].RResult);


                    //좌측선수 반칙,실격,부전/기권 승 selected
                    if (myArr[0].RPlayerResult == "sd019005" || myArr[0].RPlayerResult == "sd019013" || myArr[0].RPlayerResult == "sd019006" || myArr[0].RPlayerResult == "sd019022" || myArr[0].RPlayerResult == "sd019025" || myArr[0].RPlayerResult == "sd019026") {
                        $("#DP_R_GameResult").append("<option value='" + myArr[0].RPlayerResult + "'>" + myArr[0].RResult + "</option>");
                    }
                    else {
                        $("#DP_R_GameResult").append("<option value=''>" + "-" + "</option>");
                    }

                    if (myArr[0].RPlayerResult == "sd019012" || myArr[0].RPlayerResult == "sd019021") {
                        $("#DP_Edit_RPlayer").attr("class", "player-name");
                    }



                    $(".modal-body").find("h4 > span").html(myArr[0].RResult);

                }
                else {
                    $("#DP_R_GameResult").append("<option value=''>" + "-" + "</option>");
                    $("#DP_Edit_RPlayer").attr("class", "player-name");
                    $("#DP_Edit_RPlayer").prev().attr("class", "disp-none");
                }


            }

            else {
                $("#DP_L_GameResult").append("<option value=''>" + "-" + "</option>");
                $("#DP_Edit_LPlayer").attr("class", "player-name");
                $("#DP_R_GameResult").append("<option value=''>" + "-" + "</option>");
                $("#DP_Edit_RPlayer").attr("class", "player-name");

                $("#DP_Edit_LPlayer").html("불참자");
                $("#DP_Edit_RPlayer").html("불참자");

                $("#DP_Edit_LSCName").html("불참학교");
                $("#DP_Edit_RSCName").html("불참학교");
            }

            $(".player-match-option.player-point").hide();
            $("#DP_L_GameResult").attr("disabled", "disabled");
            $("#DP_R_GameResult").attr("disabled", "disabled");

            defer.resolve(sdata);
        },
        error: function (errorText) {
            defer.reject(errorText);
        }
    });
    return defer.promise();
}
//E:대전선수명 및 승자 가져오기




//S:유도 경기로그 가져오기
function loadplaylog(strPlayerGameNum) {
    var defer = $.Deferred();

    var obj = {};

    obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
    obj.GroupGameNum = localStorage.getItem("GroupGameNum");
    obj.PlayerGameNum = strPlayerGameNum;

    var jsonData = JSON.stringify(obj);

    var events = "";

    $.ajax({
        url: '../../ajax/judo_os/tblGameResultDtlSelect.ashx',
        type: 'post',
        data: jsonData,
        success: function (sdata) {

            var myArr = JSON.parse(sdata);

            if (myArr.length > 0) {

                var strplaylog = "";

                for (var i = 0; i < myArr.length; i++) {

                    if (myArr[i].PlayerPosition == "LPlayer") {
                        if (myArr[i].JumsuGb == "") {
                            strplaylog += "<li class='opponent recent'>";
                        }
                        else {
                            strplaylog += "<li class='opponent'>";
                        }

                    }
                    else {
                        if (myArr[i].JumsuGb == "") {
                            strplaylog += "<li class='mine recent'>";
                        }
                        else {
                            strplaylog += "<li class='mine'>";
                        }
                    }

                    if (myArr[i].OverTime == "1") {
                        strplaylog += "(연)"
                    }

                    strplaylog += "[<span class='record-time'>";

                    strplaylog += myArr[i].CheckTime + "</span>]<span class='record-type'>" + myArr[i].PlayerName + "</span>:";
                    strplaylog += "";

                    if (myArr[i].JumsuGb == "지도") {
                        strplaylog += ": <span class='skill'>" + myArr[i].JumsuGb + "</span>";
                    }
                    else {
                        strplaylog += ": <span class='skill'>" + myArr[i].JumsuGb + " " + myArr[i].SpecialtyGb + "</span>(<span class='skill'>" + myArr[i].SpecialtyDtl + "</span>)";
                    }

                    strplaylog += "</li>";

                }

                $("#DP_result-list-title").html();
                $("#DP_result-list").html(strplaylog);


            } else {

                // $("#DP_result-list").html("");
                //다른 데이터 클릭 후 득실기록이 없는 데이터 클릴시 득실기록 초기화
                var strplaylog = "";
                strplaylog += "<li class='opponent recent'>";
                strplaylog += "</li>";
                $("#DP_result-list").html(strplaylog);
            }

            if (localStorage.getItem("MediaLink") == "") {
                $("#btn_movie").addClass("off").html('영상미등록'); //.text("영상미등록");
            } else {
                $("#btn_movie").removeClass("off").html('<span class="ic-deco"><img src="../images/film-icon@3x.png" alt="">  </span><span>영상보기</span>'); //.text("영상보기");
            }

            defer.resolve(sdata);
        },
        error: function (errorText) {
            defer.reject(errorText);
        }
    });
    return defer.promise();
}

//E:유도 경기로그 가져오기


//S:양선수 부전패, 무승부 판정 가져오기
function nowdualresult(strPlayerGameNum) {

    var defer = $.Deferred();

    var obj = {};

    obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
    obj.GroupGameNum = localStorage.getItem("GroupGameNum");
    obj.PlayerGameNum = strPlayerGameNum;

    var jsonData = JSON.stringify(obj);

    var events = "";

    $.ajax({
        url: '../../ajax/judo_os/GGameDualResultList.ashx',
        type: 'post',
        data: jsonData,
        success: function (sdata) {

            var myArr = JSON.parse(sdata);

            if (myArr.length > 0) {


                //양선수 부전패라면..
                if (myArr[0].LPlayerResult == "sd019012") {
                    $("#LRResult_Lose").attr("class", "tgClass default on");

                    if (localStorage.getItem("GroupGameGb") == "sd040001") {
                        $("#LRResult_Draw").attr("class", "tgClass no-attend");
                    }
                    else {
                        $("#LRResult_Draw").attr("class", "tgClass draw");
                    }

                    //양선수 이름상단 (패)로 표기
                    $("#DP_Edit_LPlayer").attr("class", "player-name");
                    $("#DP_Edit_RPlayer").attr("class", "player-name");
                }
                //무승부(단체전)라면..
                else if (myArr[0].LPlayerResult == "sd019024") {
                    $("#LRResult_Lose").attr("class", "tgClass default");
                    $("#LRResult_Draw").attr("class", "tgClass draw on");

                    //양선수 이름상단 (패)로 표기
                    $("#DP_Edit_LPlayer").attr("class", "player-name");
                    $("#DP_Edit_RPlayer").attr("class", "player-name");
                }
                //불참(단체전)라면..
                else if (myArr[0].LPlayerResult == "sd019021") {
                    $("#LRResult_Lose").attr("class", "tgClass default");
                    $("#LRResult_Draw").attr("class", "tgClass no-attend on");

                    $("#DP_Edit_LPlayer").attr("class", "player-name");
                    $("#DP_Edit_RPlayer").attr("class", "player-name");
                }
                else {
                    $("#LRResult_Lose").attr("class", "tgClass default");
                    $("#LRResult_Draw").attr("class", "tgClass no-attend");
                }

            }
            else {

                $("#LRResult_Lose").attr("class", "tgClass default");
                $("#LRResult_Draw").attr("class", "tgClass no-attend");
            }

            defer.resolve(sdata);
        },
        error: function (errorText) {
            defer.reject(errorText);
        }
    });
    return defer.promise();

}
//E:양선수 부전패, 무승부 판정 가져오기




//S:학교VS학교 점수및 결과가져오기
function select_groupresult() {

    var defer = $.Deferred();

    var obj = {};

    obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
    obj.GroupGameNum = localStorage.getItem("GroupGameNum");

    var jsonData = JSON.stringify(obj);

    console.log("end_s:" + jsonData);

    var events = "";

    //var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기

    $.ajax({
        url: '../../ajax/judo_os/GGameGroupWinEndCheck.ashx',
        type: 'post',
        data: jsonData,
        success: function (sdata) {
            var strlist = "";
            var i = 0;

            var myArr = JSON.parse(sdata);


            if (myArr.length > 0) {
                //4승4패(25점)
                $("#DP_LSchoolName").html(myArr[0].LeftSchoolName);
                $("#DP_LResult").html(myArr[0].LeftWinCnt + "승" + myArr[0].LeftDrawCnt + "무" + myArr[0].LeftLoseCnt + "패(" + myArr[0].LeftJumsu + ")");
                $("#DP_RSchoolName").html(myArr[i].RightSchoolName);
                $("#DP_RResult").html(myArr[0].RightWinCnt + "승" + myArr[0].RightDrawCnt + "무" + myArr[0].RightLoseCnt + "패(" + myArr[0].RightJumsu + ")");

                localStorage.setItem("NowGroupGameCnt", myArr[0].GameCnt);

                localStorage.setItem("LeftWinCnt", myArr[0].LeftWinCnt);
                localStorage.setItem("RightWinCnt", myArr[0].RightWinCnt);

                localStorage.setItem("MediaLink", myArr[0].MediaLink);

                if (localStorage.getItem("MediaLink") == "") {
                    $("#btn_groupmovie").addClass("off").html('영상미등록'); //.text("영상미등록");
                } else {
                    $("#btn_groupmovie").removeClass("off").html('<span class="ic-deco"><img src="../images/film-icon@3x.png" alt="">  </span><span>영상보기</span>'); //.text("영상보기");
                }
                //상단 WIN표시 초기화
                $("#DP_LSchoolName").attr("class", "");
                $("#DP_RSchoolName").attr("class", "");

                //승패구분하여 승리팀 상단에 표시
                if (Number(myArr[0].LeftWinCnt) > myArr[0].RightWinCnt) {
                    $("#DP_WinGroup").html(myArr[0].LeftSchoolName + "(" + myArr[0].LeftJumsu + ")");
                    $("#DP_LSchoolName").attr("class", "win");
                }
                else if (Number(myArr[0].LeftWinCnt) < myArr[0].RightWinCnt) {
                    $("#DP_WinGroup").html(myArr[0].RightSchoolName + "(" + myArr[0].RightJumsu + ")");
                    $("#DP_RSchoolName").attr("class", "win");
                }
                else {
                    if (Number(myArr[0].LeftJumsu) > Number(myArr[0].RightJumsu)) {
                        $("#DP_WinGroup").html(myArr[0].LeftSchoolName + "(" + myArr[0].LeftJumsu + ")");
                        $("#DP_LSchoolName").attr("class", "win");
                    }
                    else if (Number(myArr[0].LeftJumsu) < Number(myArr[0].RightJumsu)) {
                        $("#DP_WinGroup").html(myArr[0].RightSchoolName + "(" + myArr[0].RightJumsu + ")");
                        $("#DP_RSchoolName").attr("class", "win");
                    }
                    else {

                        if (myArr[0].LResult != "" && (myArr[0].LResult = myArr[0].RResult)) {
                            $("#DP_WinGroup").html("양측" + " " + myArr[0].LResultNM);
                            $("#DP_LResult").html(myArr[0].LResultNM);
                            $("#DP_RResult").html(myArr[0].RResultNM);
                        }
                        else if (myArr[0].LResult == "sd019006") {
                            $("#DP_WinGroup").html(myArr[0].LeftSchoolName + " " + myArr[0].LResultNM);
                            $("#DP_LSchoolName").attr("class", "win");
                            $("#DP_LResult").html("승(부전)");
                            $("#DP_RResult").html("패(부전)");
                        }
                        else if (myArr[0].RResult == "sd019006") {
                            $("#DP_WinGroup").html(myArr[0].RightSchoolName + " " + myArr[0].RResultNM);
                            $("#DP_LSchoolName").attr("class", "win");
                            $("#DP_LResult").html("패(부전)");
                            $("#DP_RResult").html("승(부전)");
                        }

                        else {
                            $("#DP_WinGroup").html("동점");
                        }
                    }
                }


                if (myArr[0].LeftWinCnt == myArr[0].RightWinCnt) {
                    if (myArr[0].LeftJumsu == myArr[0].RightJumsu) {
                        //경기등록 확인창
                        $("#btn_groupcomplete").attr("data-target", "#result-save-modal");
                    }
                    else {
                        //동점입니다 창
                        $("#btn_groupcomplete").attr("data-target", "#same-score-modal");
                    }

                }
                else {
                    //경기등록 확인창
                    $("#btn_groupcomplete").attr("data-target", "#result-save-modal");
                }



            }
            else {

            }

            defer.resolve(sdata);
        },
        error: function (errorText) {
            defer.reject(errorText);
        }


    });
    return defer.promise();
}
//E:학교VS학교 점수및 결과가져오기


//S:양선수 부전패, 무승부 판정 가져오기
function nowGroupdualresult(strPlayerGameNum) {

    var defer = $.Deferred();

    var obj = {};

    obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
    obj.GroupGameNum = strPlayerGameNum;

    var jsonData = JSON.stringify(obj);

    var events = "";

    $.ajax({
        url: '../../ajax/judo_os/GGameGroupDualResultList.ashx',
        type: 'post',
        data: jsonData,
        success: function (sdata) {

            //alert(sdata);

            $("#DP_LSchoolName").attr("class", "");
            $("#DP_RSchoolName").attr("class", "");



            var myArr = JSON.parse(sdata);


            if (myArr.length > 0) {

                //양선수 부전패라면..

                $("#DP_LSchoolName").html(myArr[0].LSchoolName);
                $("#DP_RSchoolName").html(myArr[0].RSchoolName);

                if (myArr[0].LResult != "" && (myArr[0].LResult == myArr[0].RResult)) {

                    if (myArr[0].LResult == "sd019012") {
                        $("#DP_WinGroup").html("양측 부전패");
                    }
                    //무승부(단체전)라면..
                    else if (myArr[0].LResult == "sd019024") {
                        $("#DP_WinGroup").html("양측 무승부");
                    }

                    else {
                        $("#DP_WinGroup").html("ETC 결과");
                    }

                }
                else {
                    if (myArr[0].LResult != "") {
                        $("#DP_WinGroup").html(myArr[0].LSchoolName + "(" + myArr[0].LResultName + ")");

                        $("#DP_LSchoolName").attr("class", "win");
                        $("#DP_RSchoolName").attr("class", "");
                    }

                    if (myArr[0].RResult != "") {
                        $("#DP_WinGroup").html(myArr[0].RSchoolName + "(" + myArr[0].RResultName + ")");

                        $("#DP_LSchoolName").attr("class", "");
                        $("#DP_RSchoolName").attr("class", "win");
                    }
                }

                if ($("#DP_LResult").html() == "") {
                    $("#DP_LResult").html("0승0무0패");
                }

                if ($("#DP_RResult").html() == "") {
                    $("#DP_RResult").html("0승0무0패");
                }

            }


            defer.resolve(sdata);
        },
        error: function (errorText) {
            defer.reject(errorText);
        }
    });
    return defer.promise();

}
//E:양선수 부전패, 무승부 판정 가져오기



//S:등록했던 단체전 선수 불러오기
function select_rplayer() {

    var defer = $.Deferred();

    var obj = {};

    obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
    obj.GroupGameNum = localStorage.getItem("GroupGameNum");

    var jsonData = JSON.stringify(obj);

    var strhtml_left_title = "";
    var strhtml_right_title = "";

    var strhtml_left = "";
    var strhtml_right = "";

    strhtml_left_title = "<ul class='title clearfix'>";
    strhtml_left_title += "<li>선수명</li>";
    strhtml_left_title += "<li>체급항목</li>";
    strhtml_left_title += "<li>승패</li>";
    strhtml_left_title += "</ul>";

    strhtml_right_title = "<ul class='title clearfix'>";
    strhtml_right_title += "<li>승패</li>";
    strhtml_right_title += "<li>체급항목</li>";
    strhtml_right_title += "<li>선수명</li>";
    strhtml_right_title += "</ul>";


    //var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기

    $.ajax({
        url: '../../ajax/judo_os/GGameGroupRPlayerSelect.ashx',
        type: 'post',
        data: jsonData,
        success: function (sdata) {

            var strlist = "";

            var myArr = JSON.parse(sdata);

            if (myArr.length > 0) {

                var LName_FontSize = "";
                var RName_FontSize = "";


                for (var i = 0; i < myArr.length; i++) {

                    if (myArr[i].LUserName.length > 5) {
                        LName_FontSize = "style='font-size:7px'";
                    }
                    else {
                        LName_FontSize = "";
                    }

                    if (myArr[i].RUserName.length > 5) {
                        RName_FontSize = "style='font-size:7px'";
                    }
                    else {
                        RName_FontSize = "";
                    }


                    strhtml_left += "<ul class='clearfix'>";
                    strhtml_left += "<li>" + myArr[i].LUserName + "</li>";
                    strhtml_left += "<li>" + myArr[i].LLevelName + "</li>";
                    strhtml_left += "<li " + LName_FontSize + ">" + myArr[i].LPlayerResult + "</li>";
                    strhtml_left += "</ul>";

                    strhtml_right += "<ul class='clearfix'>";
                    strhtml_right += "<li>" + myArr[i].RPlayerResult + "</li>";
                    strhtml_right += "<li>" + myArr[i].RLevelName + "</li>";
                    strhtml_right += "<li " + RName_FontSize + ">" + myArr[i].RUserName + "</li>";
                    strhtml_right += "</ul>";

                    $("#DP_LeftGroup").html(strhtml_left_title + strhtml_left);
                    $("#DP_RightGroup").html(strhtml_right_title + strhtml_right);

                }

            }
            else {
                $("#DP_LeftGroup").html(strhtml_left_title);
                $("#DP_RightGroup").html(strhtml_right_title);
            }

            defer.resolve(sdata);
        },
        error: function (errorText) {
            defer.reject(errorText);
        }

    });

    return defer.promise();
}
//E:등록했던 단체전 선수 불러오기


//S:개인전 팝업 설정
//기록보기/영상보기 버튼

function change_btn() {
    //기록보기 눌렀을 시
    if ($("#btn_movie").css("display") == "none") {

        $("#DP_GameVideo").html("");

        $("#DP_GameVideo").css("display", "none");
        $("#DP_Record").css("display", "");

        $("#btn_movie").css("display", "inline-block");

        $("#btn_log").css("display", "none");
    }
    else {

        if (localStorage.getItem("MediaLink") == "") {
            //        alert("등록된 영상이 없습니다.");
            return;
        }


        var strYoutubeLink = "<iframe width='568' height='318' src='" + localStorage.getItem("MediaLink")
        strYoutubeLink += "&controls=0&showinfo=0&autohide=2&loop=1&autoplay=1&fs=1&vq=hd720&rel=0&enablejsapi=1&api=1' modestbranding='0' frameborder='0' allowfullscreen>"
        strYoutubeLink += "</iframe>"


        $("#DP_GameVideo").html(strYoutubeLink);

        $("#DP_GameVideo").css("display", "");
        $("#DP_Record").css("display", "none");

        $("#btn_movie").css("display", "none");
        $("#btn_log").css("display", "");
    }
}


//S:단체전 팝업 설정
//기록보기/영상보기 버튼
function changegroup_btn() {
    //기록보기 눌렀을 시
    if ($("#btn_groupmovie").css("display") == "none") {

        $("#DP_GroupGameVideo").html("");

        $("#DP_GroupGameVideo").css("display", "none");
        $("#DP_GroupRecord").css("display", "");

        $("#btn_groupmovie").css("display", "");
        $("#btn_grouplog").css("display", "none");
    }
    else {

        if (localStorage.getItem("MediaLink") == "") {
            //        alert("등록된 영상이 없습니다.");
            return;
        }


        var strYoutubeLink = "<iframe width='568' height='318' src='" + localStorage.getItem("MediaLink")
        strYoutubeLink += "&controls=0&showinfo=0&autohide=2&loop=1&autoplay=1&fs=1&vq=hd720&loop=1&rel=0&enablejsapi=1&api=1'modestbranding='0' frameborder='0' allowfullscreen>"
        strYoutubeLink += "</iframe>"


        $("#DP_GroupGameVideo").html(strYoutubeLink);

        $("#DP_GroupGameVideo").css("display", "");
        $("#DP_GroupRecord").css("display", "none");

        $("#btn_groupmovie").css("display", "none");
        $("#btn_grouplog").css("display", "");
    }
}
