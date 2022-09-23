<!-- #include file="../../dev/dist/config.asp"-->
<% 
Dim LSQL, LRs
Dim i

Dim GameTitleIDX
Dim GroupGameGb
Dim Sex 
Dim PlayType
Dim TeamGb
Dim Level
Dim LevelJooName
Dim LevelJooNum

GameTitleIDX = Request("GameTitle")
GroupGameGb = Request("GroupGameGb")
PlayType = Request("PlayType")
TeamGb = Request("TeamGb")
Level = Request("Level")
LevelDtl = Request("LevelDtl")


If InStr(PlayType,"|") > 1 Then
    Arr_PlayType = Split(PlayType,"|")
    DEC_Sex = fInject(crypt.DecryptStringENC(Arr_PlayType(0)))
    DEC_PlayType = fInject(crypt.DecryptStringENC(Arr_PlayType(1)))
End if

If InStr(Level,"|") > 1 Then
    Arr_Level = Split(Level,"|")
    DEC_Level = fInject(crypt.DecryptStringENC(Arr_Level(0)))
    DEC_LevelJooName = fInject(crypt.DecryptStringENC(Arr_Level(1)))
    DEC_LevelJooNum = Arr_Level(2)
End if

DEC_GameTitleIDX = crypt.DecryptStringENC(GameTitleIDX)
DEC_GroupGameGb = crypt.DecryptStringENC(GroupGameGb)
DEC_TeamGb = crypt.DecryptStringENC(TeamGb)
DEC_LevelDtl = crypt.DecryptStringENC(LevelDtl)


'Response.WrIte "DEC_GameTitleIDX : " & DEC_GameTitleIDX  & "<br/>"
'Response.WrIte "DEC_GroupGameGb : " & DEC_GroupGameGb  & "<br/>"
'Response.WrIte "DEC_TeamGb : " & DEC_TeamGb  & "<br/>"
'Response.WrIte "DEC_LevelDtl : " & DEC_LevelDtl  & "<br/>"

'crypt.DecryptStringENC(oJSONoutput.NationType)

'crypt.EncryptStringENC("13")

%>
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta charset="utf-8">
  <title>경기운영관리</title>
  <!--[if IE]>
  <script type="text/javascript">
  document.createElement('header');document.createElement('aside');document.createElement('article');document.createElement('footer');</script>
  <![endif]-->
  <link href="/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="../../css/fontawesome-all.css">
  <script src="/js/jquery-1.12.2.min.js"></script>
  <script src="/js/jquery-ui.min.js"></script>

  <link href="/css/bootstrap.min.css" rel="stylesheet" media="screen">
  <script src="/js/bootstrap.min.js"></script>

  <style>
  [draggable] {
    -moz-user-select: none;
    -khtml-user-select: none;
    -webkit-user-select: none;
    user-select: none;
    /* Required to make elements draggable in old WebKit */
    -khtml-user-drag: element;
    -webkit-user-drag: element;
  }
  </style>
  <link rel="stylesheet" href="/css/bmAdmin.css?ver=8">
  <link rel="stylesheet" href="/css/admin/admin.d.style.css">
  <script src="/ckeditor/ckeditor.js"></script></style>

  <link rel="stylesheet" type="text/css" href="/css/normalize-4.1.1.css">
  <link rel="stylesheet" type="text/css" href="/css/style_bmtourney.css?v=2">


<style>
    .highlighted{background-color: yellow;}
    .highlight{background-color: #fff34d;}
    
    /*
     * Timepicker stylesheet
     * Highly inspired from datepicker
     * FG - Nov 2010 - Web3R 
     *
     * version 0.0.3 : Fixed some settings, more dynamic
     * version 0.0.4 : Removed width:100% on tables
     * version 0.1.1 : set width 0 on tables to fix an ie6 bug
     */
    .ui-timepicker-inline { display: inline; }
    #ui-timepicker-div { padding: 0.2em; }
    .ui-timepicker-table { display: inline-table; width: 0; }
    .ui-timepicker-table table { margin:0.15em 0 0 0; border-collapse: collapse; }
    .ui-timepicker-hours, .ui-timepicker-minutes { padding: 0.2em;  }
    .ui-timepicker-table .ui-timepicker-title { line-height: 1.8em; text-align: center; }
    .ui-timepicker-table td { padding: 0.1em; width: 2.2em; }
    .ui-timepicker-table th.periods { padding: 0.1em; width: 2.2em; }

    /* span for disabled cells */
    .ui-timepicker-table td span {
        display:block;
        padding:0.2em 0.3em 0.2em 0.5em;
        width: 1.2em;

        text-align:right;
        text-decoration:none;
    }
    /* anchors for clickable cells */
    .ui-timepicker-table td a {
        display:block;
        padding:0.2em 0.3em 0.2em 0.5em;
       /* width: 1.2em;*/
        cursor: pointer;
        text-align:right;
        text-decoration:none;
    }


    /* buttons and button pane styling */
    .ui-timepicker .ui-timepicker-buttonpane {
        background-image: none; margin: .7em 0 0 0; padding:0 .2em; border-left: 0; border-right: 0; border-bottom: 0;
    }
    .ui-timepicker .ui-timepicker-buttonpane button { margin: .5em .2em .4em; cursor: pointer; padding: .2em .6em .3em .6em; width:auto; overflow:visible; }
    /* The close button */
    .ui-timepicker .ui-timepicker-close { float: right }

    /* the now button */
    .ui-timepicker .ui-timepicker-now { float: left; }

    /* the deselect button */
    .ui-timepicker .ui-timepicker-deselect { float: left; }

</style>
<script src="//cdn.rawgit.com/fgelinas/timepicker/master/jquery.ui.timepicker.js"></script>
<script src="../../js/CommonAjax.js"></script>
<script>
    $(document).ready(function () {

        //경기일자
        //sel_GameTitle();
        
        //sel_PlayType();

        //sel_TeamGb();

        //sel_Level();

    });

    var sel_GameTitle = function () {

        var obj = {};

        obj.CMD = "GameTitle";

        //location.href = "../../ajax/select/GameTitle.asp?CMD=" + obj.CMD;

        SendPacketSe(obj, "../../ajax/select/GameTitle.asp");
    }

    var sel_PlayType = function () {

        var obj = {};

        obj.CMD = "PlayType";
        obj.GameTitleIDX = $("#GameTitle").val();
        obj.GroupGameGb = $(":input:radio[name=GroupGameGb]:checked").val();

        //location.href = "../../ajax/select/TeamGb.asp?CMD=" + obj.CMD +
        //"&GameTitleIDX=" + $("#GameTitle").val();

        SendPacketSe(obj, "../../ajax/select/PlayType.asp");
    }

    var sel_TeamGb = function () {

        var obj = {};

        obj.CMD = "TeamGb";
        obj.GameTitleIDX = $("#GameTitle").val();
        obj.GroupGameGb = $(":input:radio[name=GroupGameGb]:checked").val();
        obj.PlayType = $("#PlayType").val();

        //location.href = "../../ajax/select/TeamGb.asp?CMD=" + obj.CMD +
        //"&GameTitleIDX=" + $("#GameTitle").val();

        SendPacketSe(obj, "../../ajax/select/TeamGb.asp");
    }

    var sel_Level = function () {

        var obj = {};

        obj.CMD = "Level";
        obj.GameTitleIDX = $("#GameTitle").val();
        obj.GroupGameGb = $(":input:radio[name=GroupGameGb]:checked").val();
        obj.PlayType = $("#PlayType").val();
        obj.TeamGb = $("#TeamGb").val();

       /*
        location.href = "../../ajax/select/Level.asp?CMD=" + obj.CMD +
        "&GameTitleIDX=" + $("#GameTitle").val() +
        "&TeamGb=" + $("#TeamGb").val() +
        "&GroupGameGb=" + $(":input:radio[name=GroupGameGb]:checked").val();
       */

        SendPacketSe(obj, "../../ajax/select/Level.asp");
    }

    /*
    var sel_LevelDtl = function () {

        var obj = {};

        obj.CMD = "LevelDtl";
        obj.GameTitleIDX = $("#GameTitle").val();
        obj.GroupGameGb = $(":input:radio[name=GroupGameGb]:checked").val();
        obj.PlayType = $("#PlayType").val();
        obj.TeamGb = $("#TeamGb").val();
        obj.Level = $("#Level").val();

      
        location.href = "../../ajax/select/LevelDtl.asp?CMD=" + obj.CMD +
        "&GameTitleIDX=" + $("#GameTitle").val() +
        "&GroupGameGb=" + $(":input:radio[name=GroupGameGb]:checked").val() +
        "&PlayType=" + $("#PlayType").val() +
        "&TeamGb=" + $("#TeamGb").val() +
        "&Level=" + $("#Level").val();
      

        SendPacketSe(obj, "../../ajax/select/LevelDtl.asp");
    }
      */

    var sel_LevelDtlList = function () {

        var obj = {};

        obj.CMD = "LevelDtlList";
        obj.GameTitleIDX = $("#GameTitle").val();
        obj.GroupGameGb = $(":input:radio[name=GroupGameGb]:checked").val();
        obj.PlayType = $("#PlayType").val();
        obj.TeamGb = $("#TeamGb").val();
        obj.Level = $("#Level").val();

        /*
        window.open('about:blank').location.href = "../../ajax/select/LevelDtlList.asp?CMD=" + obj.CMD +
        "&GameTitleIDX=" + $("#GameTitle").val() +
        "&GroupGameGb=" + $(":input:radio[name=GroupGameGb]:checked").val() +
        "&PlayType=" + $("#PlayType").val() +
        "&TeamGb=" + $("#TeamGb").val() +
        "&Level=" + $("#Level").val();
        */

        SendPacketSe(obj, "../../ajax/select/LevelDtlList.1.asp");
    }

    var cli_tourney = function () {
        location.href = "lottery.asp" +
        "?GameTitle=" + $("#GameTitle").val() +
        "&GroupGameGb=" + $(":input:radio[name=GroupGameGb]:checked").val() +
        "&PlayType=" + $("#PlayType").val() +
        "&TeamGb=" + $("#TeamGb").val() +
        "&Level=" + $("#Level").val() +
        "&LevelDtl=" + $("#LevelDtl").val();
    }

    var cli_tourneysave = function () {
        //console.log($("input[name=Hidden_Data]").val());

        var str_Hidden_Data = "";
        var select_length = 0;

        select_length = $("input[name=Hidden_Data]").length;

        console.log("그룹박스 수:" + $("input[name=Hidden_Data]").length);

        for (i = 0; i < select_length; i++) {

            if (i == 0) {
                str_Hidden_Data = $("input[name='Hidden_Data']").eq(i).val();
            }
            else {
                str_Hidden_Data += "," + $("input[name='Hidden_Data']").eq(i).val();
            }
        }

        var obj = {};

        obj.CMD = "TourneySave";
        obj.LevelDtl = $("#GameLevelDtlIDX").val();
        obj.RequestGroupIDX = str_Hidden_Data;
        obj.LeagueGameNum = $("#LeagueGameNum").val();


        /*
        location.href = "../../ajax/select/LevelDtl.asp?CMD=" + obj.CMD +
        "&GameTitleIDX=" + $("#GameTitle").val() +
        "&GroupGameGb=" + $(":input:radio[name=GroupGameGb]:checked").val() +
        "&PlayType=" + $("#PlayType").val() +
        "&TeamGb=" + $("#TeamGb").val() +
        "&Level=" + $("#Level").val();
        */


        if ($("#GameType").val() == "B0040001") {
            window.open('about:blank').location.href = "../../ajax/GameTitleMenu/LeagueSave.asp?CMD=" + obj.CMD +
            "&LevelDtl=" + obj.LevelDtl +
            "&RequestGroupIDX=" + obj.RequestGroupIDX +
            "&LeagueGameNum=" + obj.LeagueGameNum;
        }
        else {
            window.open('about:blank').location.href = "../../ajax/GameTitleMenu/TourneySave.asp?CMD=" + obj.CMD +
            "&LevelDtl=" + obj.LevelDtl +
            "&RequestGroupIDX=" + obj.RequestGroupIDX +
            "&LeagueGameNum=" + obj.LeagueGameNum;
        }

        if (GameType == "B0040001") {
            //SendPacketSe(obj, "../../ajax/select/LeagueSave.asp");
        }
        else {
            //SendPacketSe(obj, "../../ajax/select/TourneySave.asp");
        }

    }

    

    var cli_Request = function (str1, str2, idx) {

        $("#Select_STR1").val(str1);
        $("#Select_STR2").val(str2);
        $("#Select_GroupIDX").val(idx);

    }

    var cli_tourneyinsert = function (strgang, strnum, strgametype) {

        var num_TotRound = $("#TotRound").val();

        if ($("#Select_GroupIDX").val() != "") {

            console.log("0:" + num_TotRound);

            for (var i = 1; i <= num_TotRound; i++) {

                console.log("1:" + $("#Hidden_Data_" + strgang + "_" + i).val());
                console.log("2:" + $("#Select_GroupIDX").val());


                if ($("#Hidden_Data_" + strgang + "_" + i).val() == $("#Select_GroupIDX").val()) {
                    alert("이미 대진에 포함된 선수(팀) 입니다.");
                    return;
                }
            }

        }

        $("#Hidden_Data_" + strgang + "_" + strnum).val($("#Select_GroupIDX").val());
        $("#DP_UserName_" + strgang + "_" + strnum).html($("#Select_STR1").val() + "<br>" + $("#Select_STR2").val());

        if (strgametype == "B0040001") {
            cli_leagueinsert(strgang, strnum);
        }

        $("#Select_STR1").val(""); 
        $("#Select_STR2").val("");
        $("#Select_GroupIDX").val("");


    }

    //
    var cli_leagueinsert = function (strgang, strnum) {

        $("#Hidden_Data_" + strgang + "_" + strnum).val();

        $("#DP_R_UserName_" + strgang + "_" + strnum).html($("#Select_STR1").val() + "<br>" + $("#Select_STR2").val());

    }

    var cli_RequestLevelDtl = function (idx) {

        var obj = {};

        obj.CMD = "RequestLevelDtl";
        obj.GameLevelDtlIDX = idx;

        $("#GameLevelDtlIDX").val(idx);


        //window.open('about:blank').location.href = "../../ajax/Select/RequestLevelDtl.asp?CMD=" + obj.CMD +
        //"&GameLevelDtlIDX=" + obj.GameLevelDtlIDX;

        SendPacketSe(obj, "../../ajax/select/RequestLevelDtl.1.asp");
    }

    //강별 토너먼트 대진표
    var prc_Tourney = function (idx, strrnd) {

        var obj = {};

        obj.CMD = "Tourney";
        obj.GameLevelDtlIDX = idx;
        obj.strRound = strrnd;


        //window.open('about:blank').location.href = "../../ajax/GameTitleMenu/Tourney.asp?CMD=" + obj.CMD +
        //"&GameLevelDtlIDX=" + obj.GameLevelDtlIDX +
        //"&strRound=" + obj.strRound;

        SendPacketSe(obj, "../../ajax/GameTitleMenu/Tourney.asp");
    }

    //리그전 대진표
    var prc_League = function (idx, strrnd) {

        var obj = {};

        obj.CMD = "League";
        obj.GameLevelDtlIDX = idx;
        obj.strRound = strrnd;

        /*
        window.open('about:blank').location.href = "../../ajax/GameTitleMenu/league.asp?CMD=" + obj.CMD +
        "&GameLevelDtlIDX=" + obj.GameLevelDtlIDX +
        "&strRound=" + obj.strRound;
        */

        SendPacketSe(obj, "../../ajax/GameTitleMenu/league.asp");
    }

    var cli_TourneyResult = function (idx, gameround, teamgamenum, gamenum, wintype, groupidx, strarea) {

        console.log("cli_TourneyResult:" + idx + "," + gameround + "," + teamgamenum + "," + gamenum + "," + wintype + "," + groupidx);

        var obj_L = "#LGroupJumsu_" + gamenum;
        var obj_R = "#RGroupJumsu_" + gamenum;

        var regNumber = /^[0-9]*$/;

        if ($(obj_L).val() != "") {
            if (!regNumber.test($(obj_L).val())) {
                alert('숫자만 입력해주세요.');
                $(obj_L).focus();
                return;
            }
        }

        if ($(obj_R).val() != "") {
            if (!regNumber.test($(obj_R).val())) {
                alert('숫자만 입력해주세요.');
                $(obj_R).focus();
                return;
            }
        }

        var obj = {};

        obj.cmd = "TourneyResult";
        obj.GameLevelDtlIDX = idx;
        obj.GameRound = gameround;
        obj.TeamGameNum = teamgamenum;
        obj.GameNum = gamenum;
        obj.WinType = wintype;
        obj.TourneyGroupIDX = groupidx;
        obj.LGroupJumsu = $(obj_L).val();
        obj.RGroupJumsu = $(obj_R).val();
        obj.StrArea = strarea;


       /*
        window.open('about:blank').location.href = "../../ajax/GameTitleMenu/GameEnd.asp?CMD=" + obj.CMD +
        "&GameLevelDtlIDX=" + obj.GameLevelDtlIDX +
        "&GameRound=" + obj.GameRound +
        "&TeamGameNum=" + obj.TeamGameNum +
        "&GameNum=" + obj.GameNum +
        "&WinType=" + obj.WinType +
        "&TourneyGroupIDX=" + obj.TourneyGroupIDX +
        "&LGroupJumsu=" + obj.LGroupJumsu +
        "&RGroupJumsu=" + obj.RGroupJumsu +
        "&StrArea=" + obj.StrArea;
      */

        SendPacketSe(obj, "../../ajax/GameTitleMenu/GameEnd.asp");
    }


    OnReceiveAjax = function (retdata) {


        var myArr = JSON.parse(retdata);

        if (myArr.CMD == "GameTitle") {


            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);


                $("#GameTitle").find("option").remove();

                for (var i = 0; i < dtlArr.length; i++) {
                    $("#GameTitle").append(new Option(dtlArr[i].GameTitleName, dtlArr[i].GameTitleIDX));

                }

            }
            else {
                $("#GameTitle").find("option").remove();
                $("#GameTitle").append(new Option("-", ""));
            }

            sel_PlayType();
            sel_TeamGb();
            sel_Level();

            sel_LevelDtlList();

        }

        else if (myArr.CMD == "Tourney") {

            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                var strTourneyHTML = "";
                var strRound = "";

                console.log($("#H_GroupGameGb").val());

                if ($("#GameType").val() == "B0040002") {

                    for (var i = 0; i < dtlArr.length; i++) {

                        strRound = dtlArr[i].STRRound;

                        console.log("123:" + myArr.RESULT);

                        strTourneyHTML += "<div class='player'>";
                        strTourneyHTML += "<div class='pre-num'>" + dtlArr[i].GameNum + "</div>";

                        if (dtlArr[i].Result != "" && dtlArr[i].Result != null && (dtlArr[i].Win_TourneyGroupIDX == dtlArr[i].LTourneyGroupIDX)) {
                            strTourneyHTML += "<div class='tourney_ctr_btn redy'>";
                        }
                        else {
                            strTourneyHTML += "<div class='tourney_ctr_btn' style='background:#E5E5E5;'>";
                        }

                        strTourneyHTML += "<ul class='team clearfix'>";
                        strTourneyHTML += "<li>";
                        strTourneyHTML += "<input type='hidden' name='Hidden_Data' id='Hidden_Data_" + i + "'>";
                        strTourneyHTML += "<span class='player' name='DP_UserName' id='DP_UserName_" + i + "'>"

                        if (dtlArr[i].Result != "" && dtlArr[i].Result != null && (dtlArr[i].Win_TourneyGroupIDX == dtlArr[i].LTourneyGroupIDX)) {
                            strTourneyHTML += "<span class='stair winner'>"
                        }
                        else {
                            strTourneyHTML += "<span class='stair'>"
                        }

                        if (dtlArr[i].LPlayer1 != "" && dtlArr[i].LPlayer1 != null) {
                            strTourneyHTML += "<span class='LPlayer1'>" + dtlArr[i].LPlayer1 + "(" + dtlArr[i].LTeam1 + ")" + "</span>";
                        }

                        if (dtlArr[i].LPlayer1 != "" && dtlArr[i].LPlayer1 != null) {
                            strTourneyHTML += "<span class='LPlayer2'>" + dtlArr[i].LPlayer2 + "(" + dtlArr[i].LTeam2 + ")" + "</span>";
                        }
                        strTourneyHTML += "<input type='text' id='LGroupJumsu_" + dtlArr[i].GameNum + "' class='ipt-point' value='" + dtlArr[i].LDtlJumsu + "'>"
                        strTourneyHTML += "</span>"

                        if (dtlArr[i].Result != "" && dtlArr[i].Result != null && (dtlArr[i].Win_TourneyGroupIDX == dtlArr[i].LTourneyGroupIDX)) {
                            strTourneyHTML += "<span class='stair winner'><a class='btn chk-win' onclick=\"cli_TourneyResult(\'" + dtlArr[i].GameLevelDtlIDX + "\',\'" + dtlArr[i].STRRound + "\',\'" + dtlArr[i].TeamGameNum + "\',\'" + dtlArr[i].GameNum + "\',\'WIN\',\'" + dtlArr[i].LTourneyGroupIDX + "\',\'L\')\">승</a>";
                        }
                        else {
                            strTourneyHTML += "<span class='stair'><a class='btn chk-win' onclick=\"cli_TourneyResult(\'" + dtlArr[i].GameLevelDtlIDX + "\',\'" + dtlArr[i].STRRound + "\',\'" + dtlArr[i].TeamGameNum + "\',\'" + dtlArr[i].GameNum + "\',\'WIN\',\'" + dtlArr[i].LTourneyGroupIDX + "\',\'L\')\">승</a>";
                        }



                        strTourneyHTML += "<a class='btn chk-draw' onclick=\"cli_TourneyResult(\'" + dtlArr[i].GameLevelDtlIDX + "\',\'" + dtlArr[i].STRRound + "\',\'" + dtlArr[i].TeamGameNum + "\',\'" + dtlArr[i].GameNum + "\',\'LRLOSE\',\'\')\">기권</a></span>";

                        strTourneyHTML += "</span>";
                        strTourneyHTML += "<span class='player' style='font-size:15px;'>";
                        strTourneyHTML += "</span>";
                        strTourneyHTML += "</li>";
                        strTourneyHTML += "</ul>";
                        strTourneyHTML += "<div class='chk_win_lose'>";
                        strTourneyHTML += "</div>";
                        strTourneyHTML += "</div>";
                        strTourneyHTML += "</div>";

                        strTourneyHTML += "<div class='player'>";
                        strTourneyHTML += "<div class='pre-num'>" + dtlArr[i].GameNum + "</div>";

                        if (dtlArr[i].Result != "" && dtlArr[i].Result != null && (dtlArr[i].Win_TourneyGroupIDX == dtlArr[i].RTourneyGroupIDX)) {
                            strTourneyHTML += "<div class='tourney_ctr_btn'>";
                        }
                        else {
                            strTourneyHTML += "<div class='tourney_ctr_btn'>";
                        }

                        strTourneyHTML += "<ul class='team clearfix'>";
                        strTourneyHTML += "<li>";
                        strTourneyHTML += "<input type='hidden' name='Hidden_Data' id='Hidden_Data_" + i + "'>";
                        strTourneyHTML += "<span class='player' name='DP_UserName' id='DP_UserName_" + i + "'>"

                        if (dtlArr[i].Result != "" && dtlArr[i].Result != null && (dtlArr[i].Win_TourneyGroupIDX == dtlArr[i].RTourneyGroupIDX)) {
                            strTourneyHTML += "<span class='stair winner'>"
                        }
                        else {
                            strTourneyHTML += "<span class='stair'>"
                        }

                        if (dtlArr[i].RPlayer1 != "" && dtlArr[i].RPlayer1 != null) {
                            strTourneyHTML += "<span class='RPlayer1'>" + dtlArr[i].RPlayer1 + "(" + dtlArr[i].RTeam1 + ")" + "</span>";
                        }

                        if (dtlArr[i].RPlayer2 != "" && dtlArr[i].RPlayer2 != null) {
                            strTourneyHTML += "<span class='RPlayer2'>" + dtlArr[i].RPlayer2 + "(" + dtlArr[i].RTeam2 + ")";
                        }

                        strTourneyHTML += "<input type='text' id='RGroupJumsu_" + dtlArr[i].GameNum + "' class='ipt-point' value='" + dtlArr[i].RDtlJumsu + "'></span>"


                        if (dtlArr[i].Result != "" && dtlArr[i].Result != null && (dtlArr[i].Win_TourneyGroupIDX == dtlArr[i].RTourneyGroupIDX)) {
                            strTourneyHTML += "<span class='stair winner'><a class='btn chk-win' onclick=\"cli_TourneyResult(\'" + dtlArr[i].GameLevelDtlIDX + "\',\'" + dtlArr[i].STRRound + "\',\'" + dtlArr[i].TeamGameNum + "\',\'" + dtlArr[i].GameNum + "\',\'WIN\',\'" + dtlArr[i].RTourneyGroupIDX + "\',\'R\')\">승</a>";
                        }
                        else {
                            strTourneyHTML += "<span class='stair'><a class='btn chk-win' onclick=\"cli_TourneyResult(\'" + dtlArr[i].GameLevelDtlIDX + "\',\'" + dtlArr[i].STRRound + "\',\'" + dtlArr[i].TeamGameNum + "\',\'" + dtlArr[i].GameNum + "\',\'WIN\',\'" + dtlArr[i].RTourneyGroupIDX + "\',\'R\')\">승</a>";
                        }

                        strTourneyHTML += "<a class='btn chk-draw' onclick=\"cli_TourneyResult(\'" + dtlArr[i].GameLevelDtlIDX + "\',\'" + dtlArr[i].STRRound + "\',\'" + dtlArr[i].TeamGameNum + "\',\'" + dtlArr[i].GameNum + "\',\'LRLOSE\',\'\')\" class='btn btn-chk-draw'>기권</a></span>";

                        strTourneyHTML += "</span>";
                        strTourneyHTML += "<span class='player'>";
                        strTourneyHTML += "</span>";
                        strTourneyHTML += "</li>";
                        strTourneyHTML += "</ul>";
                        strTourneyHTML += "<div class='chk_win_lose'>";
                        strTourneyHTML += "</div>";
                        strTourneyHTML += "</div>";
                        strTourneyHTML += "</div>";

                        $("#DP_Td_" + strRound).html(strTourneyHTML);

                    }


                }
                /*
                else {
                strNum = 3;

                strTourneyHTML += "<table border='1'>";
                strTourneyHTML += "<tr>";
                strTourneyHTML += "<td style='width:100px;'>-</td>";

                for (var i = 1; i <= strNum; i++) {
                strTourneyHTML += "<td style='width:100px;' onclick=cli_tourneyinsert('1','" + i + "','" + myArr.GameType + "')><input type='text' name='Hidden_Data' id='Hidden_Data_1_" + i + "'>";
                strTourneyHTML += "<span class='player' name='DP_UserName' id='DP_UserName_1_" + i + "' style='font-size:13px;'></span>"
                strTourneyHTML += "</td>";
                }

                strTourneyHTML += "</tr>";



                var leagueGameNum = 1;

                var Array_GameNum = new Array();

                for (var i = 0; i <= strNum; i++) {
                Array_GameNum[i] = "";
                }


                var i_num = 0;
                var j_num = 0;


                for (var i = 0; i <= strNum - 1; i++) {

                i_num = i + 1;


                strTourneyHTML += "<tr>";
                strTourneyHTML += "<td id='DP_R_UserName_1_" + i_num + "' onclick=cli_tourneyinsert('1','" + i_num + "','" + myArr.GameType + "')></td>";

                for (var j = 0; j <= strNum - 1; j++) {

                j_num = j + 1;

                if (i < j && i != j) {


                if (Array_GameNum[i] == "") {
                Array_GameNum[i] = leagueGameNum;
                }
                else {
                Array_GameNum[i] += "," + leagueGameNum;
                }

                if (Array_GameNum[j] == "") {
                Array_GameNum[j] = leagueGameNum;
                }
                else {
                Array_GameNum[j] += "," + leagueGameNum;
                }



                leagueGameNum += 1;
                }

                strTourneyHTML += "<td id='DP_VSUserName_1_" + i_num + "'>";



                strTourneyHTML += "</td>";

                }
                strTourneyHTML += "</tr>";
                }

                }
                */


            }

        }

        else if (myArr.CMD == "League") {

            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                var strTourneyHTML = "";

                strTourneyHTML = "<td id='DP_Td_1' class='league_table_box'>";
                strTourneyHTML += "<table>";
                strTourneyHTML += "    <tr>";
                strTourneyHTML += "    <td></td>";

                var colsnum = 0;
                var rowsnum = 0;
                var leagueGameNum = 0;

                for (var i = 0; i < dtlArr.length; i++) {

                    colsnum = i + 1;

                    strTourneyHTML += "  <td width='100px;'>";
                    strTourneyHTML += "  <span class='player'>" + colsnum + "." + dtlArr[i].Player1 + "(" + dtlArr[i].Team1 + ")";
                    strTourneyHTML += "  <br/>," + dtlArr[i].Player2 + "(" + dtlArr[i].Team2 + ")</span>";
                    strTourneyHTML += "  </td>        ";
                }

                strTourneyHTML += " <td class='score' width='100px;'><span class='player'>승패(점수)</span></td>";
                strTourneyHTML += " <td class='rank' width='60px;'><span class='player'>순위</span></td>";
                strTourneyHTML += " </tr>";




                for (var i = 0; i < dtlArr.length; i++) {

                    rowsnum = i + 1;

                    strTourneyHTML += "  <tr>";
                    strTourneyHTML += "  <td width='100px;'>";
                    strTourneyHTML += "  <p class='player-name'><span class='pre-num'>" + rowsnum + "</span>" + dtlArr[i].Player1 + "(" + dtlArr[i].Team1 + ")</p>";
                    strTourneyHTML += "  <p class='player-school'>" + dtlArr[i].Player2 + "(" + dtlArr[i].Team2 + ")</p>";
                    strTourneyHTML += "  </td>  ";

                    for (var j = 0; j < dtlArr.length; j++) {


                        if (i < j) {
                            leagueGameNum += 1;
                        }

                        strTourneyHTML += "                <td class='write'>";


                        if ((dtlArr[i].ORDERBY != dtlArr[j].ORDERBY) && i < j) {


                            //promise

                            //리그 경기결과확인

                            var objresult = {};
                            var resultArr = "";

                            objresult.cmd = "PointCountDetail";
                            objresult.GameLevelDtlIDX = $("#GameLevelDtlIDX").val();
                            objresult.TeamGameNum = "0";
                            objresult.GameNum = leagueGameNum;


                            var loaddata_result = $.when(SendPacketSe(objresult, "../../ajax/GameTitleMenu/PointCountDetail.asp"));

                            var resultArr = "";
                            var result_TourneyGroupIDX1 = "";
                            var result_TourneyGroupIDX2 = "";
                            var result_WinType1 = "";
                            var result_WinType2 = "";
                            var result_DtlJumsu1 = "";
                            var result_DtlJumsu2 = "";

                            loaddata_result.done(function (rsdata) {

                                console.log("rsdata.리절트:" + objresult.GameLevelDtlIDX + "," + objresult.TeamGameNum + "," + objresult.GameNum + "," + rsdata);

                                var resultArr = JSON.parse(rsdata);

                                if (resultArr.GAMERESULT != null) {


                                    var resultArrdtl = JSON.parse(resultArr.GAMERESULT);


                                    console.log("ㅋㅋ:" + result_DtlJumsu1 + "," + result_DtlJumsu2);

                                    result_TourneyGroupIDX1 = resultArrdtl[0].TourneyGroupIDX;
                                    result_TourneyGroupIDX2 = resultArrdtl[1].TourneyGroupIDX;
                                    result_WinType1 = resultArrdtl[0].WinType;
                                    result_WinType2 = resultArrdtl[1].WinType;
                                    result_DtlJumsu1 = resultArrdtl[0].DtlJumsu;
                                    result_DtlJumsu2 = resultArrdtl[1].DtlJumsu;


                                }



                            });

                            //리그 경기결과확인
                            //var resultArr = JSON.parse(loaddata_result);

                            //console.log("presult" + resultArr.GAMERESULT);


                            //promise



                            //strTourneyHTML += "경기번호:" + leagueGameNum;

                            console.log("1:" + dtlArr[i].TourneyGroupIDX + "," + result_TourneyGroupIDX1 + "," + result_WinType1);

                            if (dtlArr[i].TourneyGroupIDX == result_TourneyGroupIDX1 && result_WinType1 == "WIN") {
                                strTourneyHTML += "<div class='stair'><span class='p_name'><font color='#2e8fda'>" + dtlArr[i].Player1 + "," + dtlArr[i].Player2 + "</font></span>";
                            }
                            else if (dtlArr[i].TourneyGroupIDX == result_TourneyGroupIDX1 && result_WinType1 == "LOSE") {
                                strTourneyHTML += "<div class='stair'><span class='p_name'>" + dtlArr[i].Player1 + "," + dtlArr[i].Player2 + "</span>";
                            }
                            else {
                                strTourneyHTML += dtlArr[i].Player1 + "," + dtlArr[i].Player2;
                            }

                            strTourneyHTML += "<input type='text' id='LGroupJumsu_" + leagueGameNum + "' class='ipt-point' value='" + result_DtlJumsu1 + "'></div>"
                            strTourneyHTML += "<span class='chk-win'><a onclick=\"cli_TourneyResult(\'" + $("#GameLevelDtlIDX").val() + "\',\'1\',\'0\',\'" + leagueGameNum + "\',\'WIN\',\'" + dtlArr[i].TourneyGroupIDX + "\',\'L\')\" class='btn btn-chk-win btn-left'>[좌]승</a></span>";

                            //strTourneyHTML += dtlArr[i].Player1 + "(" + dtlArr[i].Team1 + ")";
                            strTourneyHTML += "<span class='vs'>vs</span>";
                            //strTourneyHTML += dtlArr[j].Player2 + "(" + dtlArr[j].Team2 + ")";

                            if (dtlArr[j].TourneyGroupIDX == result_TourneyGroupIDX2 && result_WinType2 == "WIN") {
                                strTourneyHTML += "<div class='stair'><span class='bluy'><font color='#2e8fda'>" + dtlArr[j].Player1 + "," + dtlArr[j].Player2 + "</font></span>";
                            }
                            else if (dtlArr[j].TourneyGroupIDX == result_TourneyGroupIDX2 && result_WinType2 == "LOSE") {
                                strTourneyHTML += "<div class='stair'><span class='redy'>" + dtlArr[j].Player1 + "," + dtlArr[j].Player2 + "</span>";
                            }
                            else {
                                strTourneyHTML += dtlArr[j].Player1 + "," + dtlArr[j].Player2;
                            }

                            strTourneyHTML += "<input type='text' id='RGroupJumsu_" + leagueGameNum + "' class='ipt-point' value='" + result_DtlJumsu2 + "'></div>"
                            strTourneyHTML += "<span class='chk-win'><a onclick=\"cli_TourneyResult(\'" + $("#GameLevelDtlIDX").val() + "\',\'1\',\'0\',\'" + leagueGameNum + "\',\'WIN\',\'" + dtlArr[j].TourneyGroupIDX + "\',\'R\')\" class='btn btn-chk-win btn-right'>[우]승</a></span>";

                            strTourneyHTML += "<span class='btn chk-draw'><a onclick=\"cli_TourneyResult(\'" + $("#GameLevelDtlIDX").val() + "\',\'1\',\'0\',\'" + leagueGameNum + "\',\'LRLOSE\',\'" + dtlArr[j].TourneyGroupIDX + "\')\">기권</a></span>";

                        }

                        strTourneyHTML += " </p>";
                        strTourneyHTML += " </td>";

                    }


                    var objwincnt = {};
                    var wincntArr = "";
                    var wincnt = "";
                    var losecnt = "";
                    var ranking = "";

                    objwincnt.cmd = "GameWinLoseCnt";
                    objwincnt.GameLevelDtlIDX = $("#GameLevelDtlIDX").val();
                    objwincnt.TourneyGroupIDX = dtlArr[i].TourneyGroupIDX;

                    var loaddata_wincnt = $.when(SendPacketSe(objwincnt, "../../ajax/GameTitleMenu/GameWinLoseCnt.asp"));

                    loaddata_wincnt.done(function (rsdata) {



                        var wincntArr = JSON.parse(rsdata);

                        console.log("테스트" + rsdata);

                        wincnt = wincntArr.WinCnt;
                        losecnt = wincntArr.LoseCnt;
                        ranking = wincntArr.Ranking;

                    });

                    strTourneyHTML += " <td >" + wincnt + "승" + losecnt + "패" + "</td>";
                    strTourneyHTML += " <td >" + ranking + "</td>";
                    strTourneyHTML += "</tr>";

                }



                strTourneyHTML += "</table>";
                strTourneyHTML += "</td>";

                $("#DP_Tr").html(strTourneyHTML);
            }
        }

        else if (myArr.CMD == "PlayType") {

            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                $("#PlayType").find("option").remove();

                for (var i = 0; i < dtlArr.length; i++) {
                    $("#PlayType").append(new Option(dtlArr[i].SexName + dtlArr[i].PlayTypeName, dtlArr[i].Sex + "|" + dtlArr[i].PlayType));

                }

            }
            else {
                $("#PlayType").find("option").remove();
                $("#PlayType").append(new Option("-", ""));
            }

            sel_TeamGb();
            sel_Level();

            sel_LevelDtlList();

        }
        else if (myArr.CMD == "TeamGb") {


            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                $("#TeamGb").find("option").remove();

                for (var i = 0; i < dtlArr.length; i++) {
                    $("#TeamGb").append(new Option(dtlArr[i].TeamGbNM, dtlArr[i].TeamGb));

                }

            }
            else {
                $("#TeamGb").find("option").remove();
                $("#TeamGb").append(new Option("-", ""));
            }

            sel_Level();

            sel_LevelDtlList();

        }
        else if (myArr.CMD == "Level") {

            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                $("#Level").find("option").remove();

                for (var i = 0; i < dtlArr.length; i++) {
                    $("#Level").append(new Option(dtlArr[i].LevelNM + " " + dtlArr[i].LevelJooNM + " " + dtlArr[i].LevelJooNum, dtlArr[i].Level + "|" + dtlArr[i].LevelJooName + "|" + dtlArr[i].LevelJooNum));

                }

            }
            else {
                $("#Level").find("option").remove();
                $("#Level").append(new Option("-", ""));
            }

            sel_LevelDtlList();

        }
        else if (myArr.CMD == "Level") {

            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                $("#Level").find("option").remove();

                for (var i = 0; i < dtlArr.length; i++) {
                    $("#Level").append(new Option(dtlArr[i].LevelNM + " " + dtlArr[i].LevelJooNM + " " + dtlArr[i].LevelJooNum, dtlArr[i].Level + "|" + dtlArr[i].LevelJooName + "|" + dtlArr[i].LevelJooNum));

                }

            }
            else {
                $("#Level").find("option").remove();
                $("#Level").append(new Option("-", ""));
            }

            sel_LevelDtlList();



        }
        else if (myArr.CMD == "LevelDtlList") {



            var strHTML = "";

            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);



                for (var i = 0; i < dtlArr.length; i++) {
                    strHTML += "<tr><td><span class='txt'>" + dtlArr[i].SexName + dtlArr[i].PlayTypeName + " ";
                    strHTML += dtlArr[i].TeamGbName + " ";
                    strHTML += dtlArr[i].LevelName + " " + dtlArr[i].LevelJooName + dtlArr[i].LevelJooNum + " ";

                    console.log("!@#!@#:" + dtlArr[i].PlayLevelType);

                    if (dtlArr[i].PlayLevelType == "B0100001") {
                        strHTML += "예선" + dtlArr[i].LevelJooNumDtl + "조";
                    }
                    else if (dtlArr[i].PlayLevelType == "B0100002") {
                        strHTML += "본선";
                    }
                    else {
                        strHTML += "-";
                    }

                    strHTML += "[C:" + dtlArr[i].GameLevelDtlIDX + "] "
                    strHTML += "</span>"
                    strHTML += "<a class='btn btn-league-sel' onclick=cli_RequestLevelDtl('" + dtlArr[i].GameLevelDtlIDX + "') >선택</a>"
                    strHTML += "</td></tr>";


                }

            }
            else {
                strHTML = "";
            }

            $("#DP_LevelDtlList").html(strHTML);

        }

        //결과입력
        else if (myArr.CMD == "TourneyResult") {
            //리그
            if ($("#GameType").val() == "B0040001") {

                prc_League($("#GameLevelDtlIDX").val(), "1");

            }
            //토너먼트
            else {
                for (var i = 1; i <= Number($("#GangCnt").val()); i++) {
                    prc_Tourney($("#GameLevelDtlIDX").val(), i);
                }
            }

        }

        else if (myArr.CMD == "RequestLevelDtl") {

            //강 및 강카운트
            $("#TotRound").val("");
            $("#GangCnt").val("");
            $("#H_GroupGameGb").val("");

            if (myArr.GangCnt != null) {
                $("#GangCnt").val(myArr.GangCnt);
            }

            if (myArr.GroupGameGb != null) {
                $("#H_GroupGameGb").val(myArr.GroupGameGb);
            }

            var strPlayer1 = "";
            var strPlayer2 = "";
            var strHTML = "";
            var strNum = 0;

            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                console.log(myArr.RESULT);

                //출전대기자
                for (var i = 0; i < dtlArr.length; i++) {

                    strPlayer1 = "";
                    strPlayer2 = "";

                    if (dtlArr[i].Player1 != "") {

                        strPlayer1 = dtlArr[i].Player1 + "(" + dtlArr[i].Team1 + ")";
                    }

                    if (dtlArr[i].Player2 != "") {

                        strPlayer2 = "," + dtlArr[i].Player2 + "(" + dtlArr[i].Team2 + ")";

                    }


                    strNum = i + 1;

                    strHTML += "<tr>";
                    strHTML += "<td>" + strNum + "</td>";
                    //strHTML += "<td><span style='color:red;'></span></td>";
                    strHTML += "<td>[" + dtlArr[i].GameRequestGroupIDX + "]";
                    strHTML += "<a href='#' class='btn btn-player-sel' onclick=cli_Request('" + strPlayer1 + "','" + strPlayer2 + "','" + dtlArr[i].GameRequestGroupIDX + "')>";
                    strHTML += strPlayer1 + ", <br>" + strPlayer2;
                    strHTML += "</a>";
                    strHTML += "</td>";
                    strHTML += "</tr>";

                }

            }

            var strTourneyRow = 0;
            var strTourneyHTML = "";
            var strGangBtn = "";
            var TourneyGameNum = 1;

            if (myArr.TotRound != null) {
                $("#TotRound").val(myArr.TotRound);
                $("#DP_Gang").html(myArr.TotRound + "강");
                $("#GameType").val(myArr.GameType);

                strTourneyRow = Number(myArr.TotRound);
                strGangBtnName = Number(myArr.TotRound);
                //우측표(토너먼트)
                if (myArr.GameType == "B0040002") {

                    for (var i = 1; i <= Number($("#GangCnt").val()); i++) {

                        strTourneyHTML += "<td id='DP_Td_" + i + "'>";
                        strTourneyHTML += "</td>";

                        if (i > 1) {
                            strGangBtnName = strGangBtnName / 2
                        }

                        strGangBtn += "<a href='' class='btn_a btn_func' data-collap='' id='DP_Gang" + i + "'>" + strGangBtnName + "강</a>"

                        $("#DP_GangBtn").html(strGangBtn);




                    }

                    $("#DP_Tr").html(strTourneyHTML);

                    for (var i = 1; i <= Number($("#GangCnt").val()); i++) {
                        prc_Tourney($("#GameLevelDtlIDX").val(), i);
                    }


                }
                //우측표(리그)
                else {
                    //리그

                    strGangBtn = "<th style='padding:2px'><a href='' class='btn_a btn_func' data-collap='' id='DP_Gang'>" + strGangBtnName + "강</a></th>"

                    $("#DP_GangBtn").html(strGangBtn);

                    prc_League($("#GameLevelDtlIDX").val(), "1");
                }

                //console.log(Array_GameNum);
                //console.log("0번째" + Array_GameNum[0]);

                //console.log(Array_GameNum);




            }


            $("#DP_RequestGroup").html(strHTML);


        }
    }
</script>
</head>
<body>
<form name="Tourney_frm" method="post">

<!-- S: setup-header -->
  <div class="setup-header">
    <!--<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>-->
    <h3 id="myModalLabel"><span class="tit">경기운영관리</span> <span class="txt"><!--- 모집: 1 , - 신청 : 0 - 코트수 : 9--></span></h3>
  </div>
<!-- E: setup-header -->

<!-- S: setup-body operate -->
<div class="setup-body operate">
  <!-- S: top-ctr -->
  <div class="top-ctr">
    <!-- S: stair -->
    <div class="stair clearfix">
        <select id="GameTitle" class="sel-ctr big-sel" onchange="sel_PlayType();">
            <option value="">==선택==</option>
        <% 
            LSQL = " SELECT GameTitleIDX, GameTitleName"
            LSQL = LSQL & " FROM tblGameTitle "
            LSQL = LSQL & " WHERE DelYN = 'N'"    

            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

                Do Until LRs.Eof
        %>
            <option value="<%=crypt.EncryptStringENC(LRs("GameTitleIDX"))%>" <%If GameTitleIDX =  crypt.EncryptStringENC(LRs("GameTitleIDX")) Then%>selected<%End If %>><%=LRs("GameTitleName")%></option>
        <%
                    LRs.MoveNext()
                Loop

            End If   
            
            LRs.Close         
        %>
        </select>
      </div>
      <!-- E: stair -->

      <!-- S: stair -->
      <div class="stair">
        <label>
            <input type="radio" name="GroupGameGb" value="<%=crypt.EncryptStringENC("B0030001")%>" onchange="sel_PlayType();" <%If GroupGameGb = crypt.EncryptStringENC("B0030001") OR GroupGameGb = "" Then%>checked<%End If %>> <span class="txt">개인전</span></label>
        <label>
          <input type="radio" name="GroupGameGb" value="<%=crypt.EncryptStringENC("B0030002")%>" onchange="sel_PlayType();" <%If GroupGameGb = crypt.EncryptStringENC("B0030002") Then%>checked<%End If %>> <span class="txt">단체전</span>
        </label>

        <select id="PlayType" class="sel-ctr" onchange="sel_TeamGb();">
            <option value="">==선택==</option>
        <% 
            LSQL = " SELECT  Sex, PlayType, KoreaBadminton.dbo.FN_NameSch(Sex,'PubCode') AS SexName, KoreaBadminton.dbo.FN_NameSch(PlayType,'PubCode') AS PlayTypeName"
            LSQL = LSQL & " FROM tblGameLevel"
            LSQL = LSQL & " WHERE DelYN = 'N'"
            LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"
            LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "'"
            LSQL = LSQL & " GROUP BY Sex, PlayType"
           
            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

                Do Until LRs.Eof
        %>
            <option value="<%=crypt.EncryptStringENC(LRs("Sex"))%>|<%=crypt.EncryptStringENC(LRs("PlayType"))%>" <%If PlayType =  crypt.EncryptStringENC(LRs("Sex")) & "|" & crypt.EncryptStringENC(LRs("PlayType")) Then%>selected<%End If %>><%=LRs("SexName") & LRs("PlayTypeName")%></option>
        <%
                    LRs.MoveNext()
                Loop

            End If   
            
            LRs.Close         
        %>
        </select>
       
  


        <select id="TeamGb" class="sel-ctr" onchange="sel_Level();">
            <option value="">==선택==</option>
        <% 
            LSQL = " SELECT TEamGb, KoreaBadminton.dbo.FN_NameSch(TEamGb,'TeamGb') AS TeamGbNM"
            LSQL = LSQL & " FROM tblGameLevel"
            LSQL = LSQL & " WHERE DelYN = 'N'"
            LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"
            LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "'"
            LSQL = LSQL & " AND Sex = '" & DEC_Sex & "'"
            LSQL = LSQL & " AND PlayType = '" & DEC_PlayType & "'"
            LSQL = LSQL & " GROUP BY TEamGb, Sex"

            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

                Do Until LRs.Eof
        %>
            <option value="<%=crypt.EncryptStringENC(LRs("TEamGb"))%>" <%If TeamGb =  crypt.EncryptStringENC(LRs("TeamGb")) Then%>selected<%End If %>><%=LRs("TeamGbNM")%></option>
        <%
                    LRs.MoveNext()
                Loop

            End If   
            
            LRs.Close         
        %>
        </select>

        <select id="Level" class="sel-ctr" onchange="sel_LevelDtlList();">
            <option value="">==선택==</option>
        <% 
            LSQL = " SELECT Level, KoreaBadminton.dbo.FN_NameSch(Level,'Level') AS LevelNM , KoreaBadminton.dbo.FN_NameSch(leveljooName, 'PubCode') AS LevelJooNM, LevelJooName,"
            LSQL = LSQL & " LevelJooNum "
            LSQL = LSQL & " FROM tblGameLevel "
            LSQL = LSQL & " WHERE DelYN = 'N' "
            LSQL = LSQL & " AND UseYN = 'Y' "
            LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "' "
            LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "' "
            LSQL = LSQL & " AND Sex = '" & DEC_Sex & "' "
            LSQL = LSQL & " AND PlayType = '" & DEC_PlayType & "' "
            LSQL = LSQL & " AND TeamGb = '" & DEC_TeamGb & "' "
            LSQL = LSQL & " GROUP BY Level, leveljooName, LevelJooNum"


            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

                Do Until LRs.Eof
        %>
            <option value="<%=crypt.EncryptStringENC(LRs("Level"))%>|<%=crypt.EncryptStringENC(LRs("LevelJooName"))%>|<%=LRs("LevelJooNum")%>" <%If Level =  crypt.EncryptStringENC(LRs("Level")) & "|" & crypt.EncryptStringENC(LRs("LevelJooName")) & "|" & LRs("LevelJooNum") Then%>selected<%End If %>><%=LRs("LevelNM") & " " & LRs("LevelJooNM") & " " & LRs("LevelJooNum")%></option>
        <%
                    LRs.MoveNext()
                Loop

            End If   
            
            LRs.Close         
        %>
        </select>

        <!--<a href='#' onclick="cli_tourney()" class="btn btn_func" style="margin-left:10px;">조회</a>-->
        <!--<a href='#' onclick="cli_tourneysave()" class="btn btn_func" style="margin-left:10px;">대진저장</a>-->
      </div>
    </div>
    <!-- E: stair -->
    
    <!-- S: sel_box -->
    <div class="sel_box">
      <p class="tit"></p>
      <!--<select id="roundsel" style="float:left;">
        <option>1라운드제외</option>
        <option>2라운드제외</option>
        <option>시드</option>
      </select>
      -->
      <input type="hidden" name="TotRound" id="TotRound" value="<%=TotRound%>" >
      <input type="hidden" name="GangCnt" id="GangCnt" value="<%=GangCnt%>" >
      <input type="hidden" name="GameType" id="GameType" value="<%=GameType%>" >
      
      <input type="hidden" name="GameLevelDtlIDX" id="GameLevelDtlIDX" >
      <input type="hidden" name="Select_STR1" id="Select_STR1" >
      <input type="hidden" name="Select_STR2" id="Select_STR2" >
      <input type="hidden" name="Select_GroupIDX" id="Select_GroupIDX" >

      <input type="hidden" name="LeagueGameNum" id="LeagueGameNum" >

      <input type="hidden" name="H_GroupGameGb" id="H_GroupGameGb" >
    </div>
    <!-- E: sel_box -->
  </div>
  <!-- E: top-ctr -->
</div>
<!-- E: game-ctr -->



<div class="content-wrap operate">
  <!-- S: drowbody-->
  <div id="drowbody" class="clearfix">

      <!-- S: ctr-box -->
      <div class="ctr-box">
        <table class="table-list table-head">
          <thead>
            <tr><th>대진표</th></tr>
          </thead>
        </table>

        <!-- S: scroll-box -->
        <div class="scroll-box">
          <table class="table-list sel-match" id="Table1">
            <tbody id="DP_LevelDtlList">
            </tbody>
          </table>
        </div>
        <!-- E: scroll-box -->
      </div>
      <!-- E: ctr-box -->


      <!-- S: ctr-box -->
      <div class="ctr-box">
        <table class="table-list table-head">
          <thead>
            <tr>
              <th>순번</th>
              <th>참가대기 선수(팀)</th>
            <!--<th colspan="2">2위</th>-->
            </tr>
          </thead>
        </table>

        <!-- S: scroll-box -->
        <div class="scroll-box">
          <table class="table-list sel-match" id="gametable">
            <tbody id="DP_RequestGroup">
              <!--S: 출전대기선수-->
              <!--E: 출전대기선수-->
            </tbody>
          </table>
        </div>
        <!-- E: scroll-box -->
      </div>
      <!-- E: ctr-box -->


    <div class="tourney-container" id="realTimeContents">

          <table class="tourney_admin table-fix-head 64" id="tourney_admin">
            <thead>
              <tr id="DP_GangBtn">
              <th style='padding:2px'><a href='' class='btn_a btn_func' data-collap='' id='DP_Gang'>-강</a></th>

             <!--        
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="set_Round_a1">64&nbsp;강</a>
              </th>
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="A1">32&nbsp;강</a>
              </th>
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="A2">16&nbsp;강</a>
              </th>
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="A3">8&nbsp;강</a>
              </th>
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="A4">4&nbsp;강</a>
              </th>
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="A5">2&nbsp;강</a>
              </th>
              -->
              </tr>
            </thead>
          </table>

          <!-- S: scroll_box -->
          <div class="scroll_box">
            <table class="table-fix-body tourn-table">
              <tbody>
                <tr id="DP_Tr">
                  <td id="DP_Td_1">
                          <!--
                          <div style="border-left:1px solid #000;width:100%;border-right:1px solid #965F41;padding:0px;margin:0px;border-bottom:3px dotted #7F7F7F;">
                              <div style="flex:1;height:100%;background:#FFFFFF;"></div>
              

                              <div class="tourney_ctr_btn redy" style="flex:10;height:100%;background:#EEEEE;" onclick="cli_tourneyinsert()">
                                <ul class="team clearfix">
                                  <li>  
                                    <input type="text" name="Hidden_Data" id="Hidden_Data_">
                                    <span class="player" name="DP_UserName" id="DP_UserName_" style="font-size:13px;">
                                    </span>
                                    <span class="player" style="font-size:15px;">
                                    </span>
                                  </li>
                                </ul>
                                <div class="chk_win_lose">
                                </div>
                              </div>
              
                          </div>
                          -->
                      <!--    
                      <div style="border-left:1px solid #000;width:100%;border-right:1px solid #965F41;padding:0px;margin:0px;border-bottom:4px solid #000;">
                                    
                         <div id="no_1_2" style="flex:1;height:100%;background:#C7E61D;">1<br>2<br> 2</div>
              

                         <div class="tourney_ctr_btn" id="cell_1_2" style="flex:10;height:100%;background:#E5E5E5;">
                           <a name="신은_1"></a><a name="mark_1_2"></a>
                           <ul class="team clearfix">
                              <li>  
                                <span class="player" style="font-size:15px;">신은&nbsp;조혜경</span>
                              </li>
                           </ul>
                           <div class="chk_win_lose"></div>
                         </div>
                      </div>
                      
                      --> 
          
                 </td>


                  <!--
                  <td id="1_row" style="padding:0px;">

                          <div style="border-left:1px solid #000;width:100%;border-right:1px solid #965F41;padding:0px;margin:0px;border-bottom:3px dotted #7F7F7F;">

                              <div id="no_1_1" style="flex:1;height:100%;background:#C7E61D;">1<br>1<br> 1</div>
              

                              <div class="tourney_ctr_btn redy" id="cell_1_1" style="flex:10;height:100%;background:#E5E5E5;">
                                <a name="김선영_1"></a><a name="mark_1_1"></a>
                                <ul class="team clearfix">
                                  <li>  
                                    <span class="player" style="font-size:15px;">김선영&nbsp;김점순</span>
                                  </li>
                                </ul>
                                <div class="chk_win_lose">
                                  <!--<span class="winnercell" style="font-size:18px;">승리</span>--
                                </div>
                              </div>
              
                          </div>

                      
                      <!--    
                      <div style="border-left:1px solid #000;width:100%;border-right:1px solid #965F41;padding:0px;margin:0px;border-bottom:4px solid #000;">
                                    
                         <div id="no_1_2" style="flex:1;height:100%;background:#C7E61D;">1<br>2<br> 2</div>
              

                         <div class="tourney_ctr_btn" id="cell_1_2" style="flex:10;height:100%;background:#E5E5E5;">
                           <a name="신은_1"></a><a name="mark_1_2"></a>
                           <ul class="team clearfix">
                              <li>  
                                <span class="player" style="font-size:15px;">신은&nbsp;조혜경</span>
                              </li>
                           </ul>
                           <div class="chk_win_lose"></div>
                         </div>
                      </div>
                      
                     
          
                 </td>
                          
                 <td id="2_row" style="padding:0px;">
                 </td>
                 <td id="3_row" style="padding:0px;">
                 </td>
                 <td id="4_row" style="padding:0px;">
                 </td>
                 <td id="5_row" style="padding:0px;">
                 </td>
                 <td id="6_row" style="padding:0px;">
                 </td>
                 <td id="7_row" style="padding:0px;">
                 </td>
               -->    
                      </tr>
              </tbody>
            </table>
          </div>
          <!-- E: scroll-box -->

  </div>
  <!-- E: tourney-container -->
</div>
<!-- E: drowbody -->

<a href="#" class="btn btn-default" data-toggle="modal" data-target=".set-order">단체전 오더 등록</a>

<!-- S: include set_order 단체전 오더 등록 -->
<!-- #include file = "./groupGame/set_order.asp" -->
<!-- E: include set_order 단체전 오더 등록 -->

</form>
</body>
</html>