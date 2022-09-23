
var m_SelTeamCode_NowGame = function (id, selTeamGb) {

    var $d = $.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.EnterType = localStorage.getItem("EnterType");
    obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
    obj.GameDay = localStorage.getItem("GameDay");
    obj.GroupGameGb = localStorage.getItem("GroupGameGb");

    var jsonData = JSON.stringify(obj);
    $.ajax({
        url: '../../ajax/judo_OS/management/DirTeamNowGame_day.ashx',
        type: 'post',
        data: jsonData,
        success: function (data) { fsuccess(data) }, error: ferror
    });

    //훈련 select 세팅
    function fsuccess(data) {


        var myArr = JSON.parse(data);

        //$(id).find("option").remove();
        $(id).children("option").not("[value='']").remove();

        if (myArr.length > 0) {
            for (var i = 0; i < myArr.length; i++) {

                var varSportsGb = myArr[i].SportsGb;
                var varTeamGb = myArr[i].TeamGb;
                var varTeamGbNm = myArr[i].TeamGbNm;

                if (varTeamGb == selTeamGb) {
                    $(id).append("<option value='" + varTeamGb + "' selected>" + varTeamGbNm + "</option>");
                }
                else {
                    $(id).append("<option value='" + varTeamGb + "'>" + varTeamGbNm + "</option>");
                }

            }
        }

        $d.resolve(data);
    }

    function ferror(error) {
        console.log(error);
        $d.reject(error);
    }

    return $d.progress();
};

//지도자버전에서 검색 체급목록 공통 SSG 20160802
var m_drLevelList_sum_NowGame = function (id, TeamGb, sellevelcode) {
    var defer = $.Deferred();
    var obj = {};

    obj.SportsGb = localStorage.getItem("SportsGb"); // $("#SportsGb").val();
    obj.TeamGb = TeamGb;
    obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");// $("#GameTitleIDX").val()//localStorage.getItem("GameTitleIDX");
    obj.GameDay = localStorage.getItem("GameDay");// $("#GameDay").val()//localStorage.getItem("GameDay");
    obj.GroupGameGb = localStorage.getItem("GroupGameGb");// $("#game-type").val()//localStorage.getItem("GroupGameGb");
    obj.Sex = $("#SexLevel option:selected").attr("data-sex");
    obj.Level = $("#SexLevel option:selected").attr("data-level");

    var jsonData = JSON.stringify(obj);

    $.ajax({
        url: '../../Ajax/judo_OS/Management/LevelInfo_sum_NowGame_day.ashx',
        type: 'post',
        data: jsonData,
        success: function (data) { fsuccess(data) }, error: ferror
    });

    //훈련 select 세팅
    function fsuccess(data) {
        console.log(data);

        var myArr = JSON.parse(data);
        $(id).children("option").remove();

        console.log();
        if (myArr.length > 0) {
            if (localStorage.getItem("GroupGameGb") == "" || localStorage.getItem("GroupGameGb") == "sd040001") {

                $(id).append("<option data-sex='' data-level='' value='' selected>::체급::</option>");

                for (var i = 0; i < myArr.length; i++) {
                    var varSex = "";

                    if (myArr[i].Sex == "Man") {
                        varSex = "남자";
                    }
                    else {
                        varSex = "여자";
                    }

                    if (myArr[i].Sex + "|" + myArr[i].Level == sellevelcode) {
                        $(id).append("<option data-sex='" + myArr[i].Sex + "' data-level='" + myArr[i].Level + "' value='" + myArr[i].Sex + "|" + myArr[i].Level + "' selected>" +  /*varSex + " " +*/myArr[i].LevelNm + "</option>");
                    }
                    else {
                        $(id).append("<option data-sex='" + myArr[i].Sex + "' data-level='" + myArr[i].Level + "' value='" + myArr[i].Sex + "|" + myArr[i].Level + "'>" +  /*varSex + " " +*/myArr[i].LevelNm + "</option>");
                    }

                }
            }
            else if (localStorage.getItem("GroupGameGb") == "sd040002") {
                $(id).append("<option data-sex='" + myArr[0].Sex + "' data-level='' value='WoMan' >무차별</option>");
            }
            else {
                $(id).append("<option data-sex='' data-level='' value='' selected>::체급::</option>");
                $(id).append("<option data-sex='" + myArr[0].Sex + "' data-level='' value='WoMan' >무차별</option>");
            }
        }
        else {
            if (localStorage.getItem("GroupGameGb") == "" || localStorage.getItem("GroupGameGb") == "sd040001") {
                $(id).append("<option data-sex='' data-level='' value='' selected>::체급::</option>");
            }
            else {
                if ($("#TeamGb option:selected").text().indexOf("남자") >= 0) {
                    localStorage.setItem("Sex", "Man");
                    $(id).append("<option data-sex='Man' data-level='' value='' >무차별</option>");
                } else {
                    localStorage.setItem("Sex", "WoMan");
                    $(id).append("<option data-sex='WoMan' data-level='' value='' >무차별</option>");
                }
            }
        }

        defer.resolve(data);

    }

    function ferror() {
        defer.reject(error);
    }
    return defer.progress();
}



//공식대회남녀체급레벨조회
var callRGameLevel = function (varLeftRightGb, strBackPage) {

    var defer = $.Deferred();
    var obj = {};

    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
    obj.GroupGameGb = localStorage.getItem("GroupGameGb");
    obj.TeamGb = $("#TeamGb").val();
    obj.Sex =  localStorage.getItem("Sex");
    obj.Level = localStorage.getItem("Level") ;
    obj.LeftRightGb = varLeftRightGb;

    var jsonData = JSON.stringify(obj);
    $.ajax({
        url: '../../ajax/judo_os/GGameSearchList.ashx',
        dataType: "text",
        type: 'post',
        data: jsonData,
        async: false,
        success: function (sdata) {
            var myArr = JSON.parse(sdata);
            if (myArr.length > 0) {
                //localStorage.setItem("RGameLevelidx",myArr[0].RGameLevelidx);
            }
            /* 개인전, 단체전에 따른 player-info 높이 조절 */
            // $('.enter-type').changeType('.btn-list .btn');
            defer.resolve(sdata);
        },
        error: function (errorText) {
            defer.reject(errorText);
        }
    });
    return defer.promise();

}


function iMovieLink(link1, link2, playeridx) {

    if (link2 == "개인전") {

        var strAjaxUrl = "/M_Player/Ajax/analysis-DetailScore-Game-Sch.asp";

        $.ajax({

            url: strAjaxUrl,

            type: 'POST',

            dataType: 'html',

            data: {

                iPlayerIDX: playeridx,

                iGameScoreIDX: link1,

                iGroupGameGbName: link2

            },

            success: function (retDATA) {

                // console.log(retDATA);

                if (retDATA) {

                    $('#detailScore').html(retDATA);

                    $('.film-modal').filmTab('.film-modal');

                    $('.groups-res').filmTab('.groups-res');

                } else {

                    $('#detailScore').html("");

                }

            }, error: function (xhr, status, error) {
                if (error != "") {
                    alert("오류발생! - 시스템관리자에게 문의하십시오!");
                    return;
                }
            }

        });


    }

    else {

        var strAjaxUrl = "/M_Player/Ajax/analysis-DetailScore-Game-Sch-Team.asp";

        $.ajax({

            url: strAjaxUrl,

            type: 'POST',

            dataType: 'html',

            data: {

                iPlayerIDX: playeridx,

                iGameScoreIDX: link1,

                iGroupGameGbName: link2

            },

            success: function (retDATA) {

                if (retDATA) {

                    $('#detailScore_Team').html(retDATA);

                    $('.film-modal').filmTab('.film-modal');

                    $('.groups-res').filmTab('.groups-res');

                } else {

                    $('#detailScore_Team').html("");

                }

            }, error: function (xhr, status, error) {
                if (error != "") {
                    alert("오류발생! - 시스템관리자에게 문의하십시오!");
                    return;
                }
            }

        });


    }


    $("#show-score").modal('show');



}


function iFavLink(link1, playeridx) {

    var strAjaxUrl = "/M_Player/Ajax/analysis-film-Mod.asp";

    $.ajax({

        url: strAjaxUrl,

        type: 'POST',

        dataType: 'html',

        data: {

            iPlayerIDX: playeridx,

            iPlayerResultIdx: link1

        },

        success: function (retDATA) {


        }, error: function (xhr, status, error) {
            if (error != "") {
                alert("오류발생! - 시스템관리자에게 문의하십시오!");
                return;
            }
        }

    });

}

//S:최종평가전의 패자부활전 및 결승전등 노출여부..
//해당경기번호의 카운트가 0보다 크면 노출시킴
function playnumberCheck() {

    var defer = $.Deferred();

    var obj = {};

    obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");

    var jsonData = JSON.stringify(obj);

    var strGroupPlayerCnt = "";

    $.ajax({
        url: '/ajax/judo_os/GGamePlayNumberCheck.ashx',
        type: 'post',
        async: false,
        data: jsonData,
        success: function (sdata) {

            var myArr = JSON.parse(sdata);

            defer.resolve(sdata);
        },
        error: function (errorText) {
            defer.reject(errorText);
        }
    });

    return defer.promise();

}
//E:최종평가전의 패자부활전 및 결승전등 노출여부..
