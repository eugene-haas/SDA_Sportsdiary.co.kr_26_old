<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->  
<%

 'Storage 변수 영역
  Dim REQ : REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)


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
Dim strAmaPrint

GameTitleIDX = Request("GameTitle")
GroupGameGb = Request("GroupGameGb")
PlayType = Request("PlayType")
TeamGb = Request("TeamGb")
Level = Request("Level")
LevelDtl = Request("LevelDtl")

GameLevelIDX = Request("GameLevelIDX")

'새로 추가된 Param
reqGameDay = fInject(Request("GameDay")) '사용
reqStadiumIDX = fInject(crypt.DecryptStringENC(Request("StadiumIDX"))) '사용
crypt_reqStadiumIDX = crypt.EncryptStringENC(reqStadiumIDX)
reqStadiumNumber = fInject(Request("StadiumNumber")) '사용
reqSearchName = fInject(Request("SearchName")) '사용
reqPlayLevelType = fInject(Request("PlayLevelType")) '미사용
crypt_ReqGameTitleIdx = fInject(Request("GameTitle"))

If reqGameDay = "" Then
  reqGameDay = Year(Now) & "-" & Addzero(Month(now)) & "-" & Addzero(Day(now))
End If

If InStr(PlayType,"|") > 0 Then
    Arr_PlayType = Split(PlayType,"|")
    DEC_Sex = fInject(crypt.DecryptStringENC(Arr_PlayType(0)))
    DEC_PlayType = fInject(crypt.DecryptStringENC(Arr_PlayType(1)))
End if

If InStr(Level,"|") > 0 Then
    Arr_Level = Split(Level,"|")
    DEC_Level = fInject(crypt.DecryptStringENC(Arr_Level(0)))
    DEC_LevelJooName = fInject(crypt.DecryptStringENC(Arr_Level(1)))
    DEC_LevelJooNum = Arr_Level(2)
End if

DEC_GameTitleIDX = crypt.DecryptStringENC(GameTitleIDX)
DEC_GroupGameGb = crypt.DecryptStringENC(GroupGameGb)
DEC_TeamGb = crypt.DecryptStringENC(TeamGb)
DEC_LevelDtl = crypt.DecryptStringENC(LevelDtl)
reqLevelJooNum = DEC_LevelJooNum
reqLevelJooName = DEC_LevelJooName
reqLevel = DEC_Level
reqTeamGb = DEC_TeamGb
reqGroupGameGb = DEC_GroupGameGb
reqGameTitleIdx = DEC_GameTitleIDX
reqSex = DEC_Sex
reqPlayType = DEC_PlayType

reqGameLevelIDX = crypt.DecryptStringENC(fInject(GameLevelIDX))

Admin_Authority = crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("Authority")))

'Response.WrIte "GameTitleIDX : " & DEC_GameTitleIDX  & "<br/>"
'Response.WrIte "GroupGameGb : " & DEC_GroupGameGb  & "<br/>"
'Response.WrIte "TeamGb : " & DEC_TeamGb  & "<br/>"
'Response.WrIte "Level : " & DEC_Level  & "<br/>"
'Response.WrIte "LevelJooName : " & DEC_LevelJooName  & "<br/>"
'Response.WrIte "LevelJooNum : " & DEC_LevelJooNum  & "<br/>"

'crypt.DecryptStringENC(oJSONoutput.NationType)

'crypt.EncryptStringENC("13")
Call oJSONoutput.Set("tGameTitleIdx", GameTitleIDX )
 strjson = JSON.stringify(oJSONoutput)


%>
<style>
  #left-navi{display:none;}
  #header{display:none;}
</style>

<script>
  var locationStr;

</script>

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

  <!-- <link rel="stylesheet" href="/css/bmAdmin.css?ver=8">
  <link rel="stylesheet" href="/css/admin/admin.d.style.css"> -->
  <script src="/ckeditor/ckeditor.js"></script></style>

  <link rel="stylesheet" type="text/css" href="/css/normalize-4.1.1.css">
  <!-- <link rel="stylesheet" type="text/css" href="/css/style_bmtourney.css?v=2"> -->


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
<script src="../../js/jquery.oLoader.min.js"></script>
<script src="../../js/loadingbar.js"></script>
<script>
    ////////////명령어////////////
        CMD_SELGAMETITLE = 1;
        CMD_SELGAMELEVEL= 2;
        CMD_LevelDtlList = 3;
        CMD_TourneyGang = 4;
        CMD_Tourney = 5;
        CMD_TourneyTeam = 6;
        CMD_League = 7;
        CMD_LeagueTeam = 8
        CMD_RequestTeam = 9;
        CMD_RequestPlayer = 10;
        CMD_TourneyResult = 11;
        CMD_TourneyTeamResult = 12;
        CMD_SEARCHGAMETITLE = 13;
        CMD_LevelList = 14;
        CMD_RequestLevel = 15;

    ////////////명령어////////////

    $(document).ready(function () {

        //경기일자
        //sel_GameTitle();

        //sel_PlayType();

        //sel_TeamGb();

        //sel_Level();

        initSearchControl();

        sel_LevelList();

    });



function initSearchControl()
{
  $( "#strGameTtitle" ).autocomplete({
    source : function( request, response ) {
      $.ajax(
        {
            type: 'post',
            url: "../../Ajax/GameTitleMenu/searchGameTitle.asp",
            dataType: "json",
            data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHGAMETITLE, "SVAL":request.term}) },
            success: function(data) {
                //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                response(
                    $.map(data, function(item) {
                        return {
                            label: item.gameTitleName + "(" + item.gameS + "~" + item.gameE + ")" + ", 번호 : " + item.uidx,
                            value: item.gameTitleName,
                            tidx : item.uidx,
                            gameTitleName : item.gameTitleName,
                            crypt_tidx : item.crypt_uidx
                        }
                    })
                );
            }
        }
      );
    },
        //조회를 위한 최소글자수
        minLength: 1,
        select: function( event, ui ) {

          $(this).attr("isSelect",1);

          setTimeout(function(obj){
            $(obj).attr("isSelect",0);
          }, 500, this);

          var obj = {}
          obj.CMD = CMD_SEARCHGAMETITLE;
          obj.tIdx = ui.item.tidx;
          obj.crypt_tIdx = ui.item.crypt_tidx;
          obj.tGameTitleName = ui.item.gameTitleName;
          $("#selGameTitleIdx").val(obj.crypt_tIdx);
          OnGameTitleChanged(obj.crypt_tIdx);
          sel_LevelList();
        },
        search: function (event, ui){ // 검색된 대회 선택
          //console.log("찾는당");

          var isSelect = $(this).attr("isSelect");

          isSelect = (typeof isSelect === "undefinded") ? 0 : isSelect;

          if(isSelect == 1){
            console.log("선택직후니까 처리안함");
            return false;
          }
        }        
    });
}



    function OnGameTitleChanged(value)
    {
        Url = "/Ajax/GameTitleMenu/OnGameTitleChangedOperate.asp"
        var packet = {};
        packet.CMD = CMD_SELGAMETITLE;
        packet.tGameTitleIdx = value;
        SendPacket(Url, packet);
    };


    function OnGameLevelChanged(packet)
    {
    GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
    GameDay = $("#selGameDay").val();
    StadiumIDX = $("#selStadiumIDX").val();
    PlayTypeSexValue = $("#selPlayTypeSex").val();
    TeamGbValue = $("#selTeamGb").val();
    LevelValue = $("#selLevel").val();
    txtSearchLevel = $("#txtSearchLevel").val();

    Url = "/Ajax/GameTitleMenu/OnGameTitleChangedOperate.asp"

    packet.CMD = CMD_SELGAMELEVEL;
    packet.tGroupGameGb = GroupGameGbValue;
    packet.tGameDay = GameDay;
    packet.tStadiumIDX = StadiumIDX;
    packet.tTeamGb = TeamGbValue;
    packet.tPlayTypeSex = PlayTypeSexValue;
    packet.tLevel = LevelValue;
    packet.tSearchLevel = txtSearchLevel;

    //console.log(packet);
    SendPacket(Url, packet);
    };

    function TourneyAllPrint(){

        if($("#selGameTitleIdx").val() == ""){
          alert("대회를 선택하세요.");
          return;
        }

        console.log("TourneyAllPrint "); 

        var gameEnterType = getHiddenVal("hide_GameEnterType");
        console.log("TourneyLevelPrint enterType = " + gameEnterType); 

        if(gameEnterType == undefined || gameEnterType == "") gameEnterType = "A"; 

        if(gameEnterType == "A") window.open("../Print/Matchall_ViewEx.asp?GameTitleIDX=" + $("#selGameTitleIdx").val() + "&AmaTimeOnly=1", "_blank");
        else window.open("../Print/Matchall_ViewEx_elite.asp?GameTitleIDX=" + $("#selGameTitleIdx").val(), "_blank");

				//if(gameEnterType == "A") window.open("../Print/Matchall_View.asp?GameTitleIDX=" + $("#selGameTitleIdx").val() + "&AmaTimeOnly=1", "_blank");
        //else window.open("../Print/Matchall_ViewEx.asp?GameTitleIDX=" + $("#selGameTitleIdx").val(), "_blank");
    }

    function TourneyLevelPrint(gamelevelidx){

        if(gamelevelidx == ""){
          alert("해당 종목을 선택하세요.");
          return;
        }

        var gameEnterType = getHiddenVal("hide_GameEnterType");

        console.log("TourneyLevelPrint enterType = " + gameEnterType); 

        if(gameEnterType == undefined || gameEnterType == "") gameEnterType = "A"; 

        if(gameEnterType == "A") window.open("../Print/Matchall_ViewEx.asp?GameLevelIDX=" + gamelevelidx + "&AmaTimeOnly=1", "_blank");
        else window.open("../Print/Matchall_ViewEx_elite.asp?GameLevelIDX=" + gamelevelidx, "_blank");

				//if(gameEnterType == "A") window.open("../Print/Matchall_View.asp?GameLevelIDX=" + gamelevelidx + "&AmaTimeOnly=1", "_blank");
        //else window.open("../Print/Matchall_ViewEx.asp?GameLevelIDX=" + gamelevelidx, "_blank");
    }

   /* =================================================================================== 
       id를 입력받아 해당 hidden element value를 return 
       =================================================================================== */
   getHiddenVal = function(sender)
   {
      return $('#'+sender).val();
   }


    //대회명 SELECT BOX 불러오기
    function sel_LevelDtlList(){

        var packet = {};

        Url ="../../ajax/select/LevelDtlList.asp"

        packet.CMD = CMD_LevelDtlList;
        packet.GameTitleIDX = $("#selGameTitleIdx").val();
        packet.GroupGameGb = $(":input:radio[name=radioGroupGameGb]:checked").val();
        packet.GameDay = $("#selGameDay").val();
        packet.StadiumIDX = $("#selStadiumIDX").val();
        packet.PlayType = $("#selPlayTypeSex").val();
        packet.TeamGb = $("#selTeamGb").val();
        packet.Level = $("#selLevel").val();


        SendPacket(Url, packet);
    };

    //대회명 SELECT BOX 불러오기
    function sel_LevelList(){

        var packet = {};

        Url ="../../ajax/select/LevelList.asp"

        packet.CMD = CMD_LevelList;
        packet.GameTitleIDX = $("#selGameTitleIdx").val();
        packet.GroupGameGb = $(":input:radio[name=radioGroupGameGb]:checked").val();
        packet.GameDay = $("#selGameDay").val();
        packet.StadiumIDX = $("#selStadiumIDX").val();
        packet.PlayType = $("#selPlayTypeSex").val();
        packet.TeamGb = $("#selTeamGb").val();
        packet.Level = $("#selLevel").val();
        packet.tSearchLevel = $("#txtSearchLevel").val();

        //alert($("#txtSearchLevel").val());


        SendPacket(Url, packet);
    };

    var mx = {};
    mx.idx = 0;
    mx.obj = null;

    //대회명 SELECT BOX 불러오기
    function cli_RequestLevelDtl(idx,obj){
      var packet = {};

      if(mx.idx != idx)
      {
        $(mx.obj).removeClass('on');
        $(obj).addClass('on');
        mx.obj = obj;
        mx.idx = idx;
      }

      Url ="../../ajax/select/TourneyGang.asp"

      packet.CMD = CMD_TourneyGang;
      packet.GameLevelDtlIDX = idx

      $("#GameLevelDtlIDX").val(idx);

      SendPacket(Url, packet);
    };

    //대회명 SELECT BOX 불러오기
    function cli_RequestLevel(idx,obj){
      var packet = {};


      if(mx.idx != idx)
      {
        $(mx.obj).removeClass('on');
        $(obj).addClass('on');
        mx.obj = obj;
        mx.idx = idx;
      }

      $("#GameLevelIDX").val(idx);

      Url ="../../ajax/GameTitleMenu/alltourney.asp"

      packet.CMD = CMD_RequestLevel;
      packet.GameLevelIDX = idx;

      //메뉴팝업숨김
      document.getElementById('divLangSelect').style.display='none';

      SendPacket(Url, packet);

    };


    //강별 토너먼트 대진표
    var prc_Tourneyseasd = function (idx, strrnd) {

        var obj = {};

        obj.CMD = "Tourney";
        obj.GameLevelDtlIDX = idx;
        obj.strRound = strrnd;


        SendPacketSe(obj, "../../ajax/GameTitleMenu/Tourney.asp");
    }

    //대회명 SELECT BOX 불러오기
    function prc_Tourney(idx, strrnd){

        var packet = {};

        if ($("#GroupGameGb").val() == "B0030001") {
          Url ="../../ajax/GameTitleMenu/Tourney.asp"
          packet.CMD = CMD_Tourney;
        }
        else{
          Url ="../../ajax/GameTitleMenu/TourneyTeam.asp"
          packet.CMD = CMD_TourneyTeam;
        }

        packet.GameLevelDtlIDX = idx;
        packet.strRound = strrnd;

        SendPacket(Url, packet);
    };

    //대회명 SELECT BOX 불러오기
    function prc_League(idx, strrnd){

        var packet = {};



        if ($("#GroupGameGb").val() == "B0030001") {
          Url ="../../ajax/GameTitleMenu/league.asp"
          packet.CMD = CMD_League;
        }
        else{
          Url ="../../ajax/GameTitleMenu/leagueTeam.asp"
          packet.CMD = CMD_LeagueTeam;
        }


        packet.GameLevelDtlIDX = idx;
        packet.strRound = strrnd;

        SendPacket(Url, packet);
    };

    //대회명 SELECT BOX 불러오기
    function cli_TourneyResult(idx, gameround, teamgamenum, gamenum, wintype, groupidx, strarea){


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

        var packet = {};

        Url ="../../ajax/GameTitleMenu/GameEnd.asp"
        packet.CMD = CMD_TourneyResult;


        packet.GameLevelDtlIDX = idx;
        packet.GameRound = gameround;
        packet.TeamGameNum = teamgamenum;
        packet.GameNum = gamenum;
        packet.WinType = wintype;
        packet.TourneyGroupIDX = groupidx;
        packet.LGroupJumsu = $(obj_L).val();
        packet.RGroupJumsu = $(obj_R).val();
        packet.StrArea = strarea;

        SendPacket(Url, packet);
    };

    function prc_RequestTeam(idx, groupgamegb){

        var packet = {};

        if(groupgamegb == "B0030001"){
          Url ="../../ajax/select/RequestPlayer.asp";
          packet.CMD = CMD_RequestPlayer;

        }
        else{
          Url ="../../ajax/select/RequestTeam.asp";
          packet.CMD = CMD_RequestTeam;
        }

        packet.GameLevelDtlIDX = idx;

        $("#GameLevelDtlIDX").val(idx);

        SendPacket(Url, packet);
    };


    ////////////Ajax Receive////////////
    function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
    switch(CMD) {
      case CMD_SELGAMETITLE:
      {
        if(dataType == "html")
        {
          $("#divGameLevelMenu").html(htmldata);
          //sel_LevelDtlList();
          sel_LevelList();
        }
      }break;
      case CMD_SELGAMELEVEL:
      {
        if(dataType == "html")
        {
          $("#divGameLevelMenu").html(htmldata);
          //sel_LevelDtlList();
          sel_LevelList();
        }
      }
      break;

      case CMD_LevelDtlList:
      {
          $("#DP_LevelDtlList").html(htmldata);
      }break;

      case CMD_LevelList:
      {
          $("#DP_LevelDtlList").html(htmldata);

        <%
          '팝업으로 불러올 시, 해당체급 자동 클릭
          If reqGameLevelIDX <> "" Then
        %>

          $("#Btn_Level_<%=reqGameLevelIDX%>").trigger("click");

        <%End IF%>
      }break;

      case CMD_TourneyGang:
      {

        $("#TotRound").val(jsondata.TotRound);
        $("#GangCnt").val(jsondata.GangCnt);
        $("#GameType").val(jsondata.GameType);
        $("#GroupGameGb").val(jsondata.GroupGameGb);
        //alert("TEST"+jsondata.GameType);
        if(jsondata.GameType == "B0040001"){
            //prc_RequestTeam(jsondata.GameLevelDtlIDX, jsondata.GroupGameGb);
            prc_League(jsondata.GameLevelDtlIDX, "1");
        }
        else{
            //prc_RequestTeam(jsondata.GameLevelDtlIDX, jsondata.GroupGameGb);
            prc_Tourney(jsondata.GameLevelDtlIDX, "1");
        }



      }break;


      case CMD_Tourney:
      {
          $("#realTimeContents").html(htmldata);
      }break;
      case CMD_TourneyTeam:
      {
          $("#realTimeContents").html(htmldata);
      }break;
      case CMD_League:
      {
          $("#realTimeContents").html(htmldata);
      }break;

      case CMD_LeagueTeam:
      {
          $("#realTimeContents").html(htmldata);
      }break;

      case CMD_RequestLevel:
      {


          $("#realTimeContents").html(htmldata);
      }break;

      case CMD_TourneyGang:
      {
          sch_Tourney(jsondata.BtnNum);
      }
      case CMD_RequestTeam:
      {
          $("#DP_RequestGroup").html(htmldata);
      }break;
      case CMD_RequestPlayer:
      {
          $("#DP_RequestGroup").html(htmldata);
      }break;
      case CMD_TourneyResult:
      {
        if(jsondata.result == "0"){
          alert("경기결과 처리가 완료되었습니다.");

          cli_RequestLevelDtl(jsondata.GameLevelDtlIDX);
        }
      }break;
      case CMD_TourneyTeamResult:
      {
        if(jsondata.result == "0"){
          alert("경기결과 처리가 완료되었습니다.");

          cli_RequestLevelDtl(jsondata.GameLevelDtlIDX);
        }
      }break;

      default:

    }
    };
    ////////////Ajax Receive////////////

    href_Move = function(hrefMove)
    {
      var ParmmStorage = {};
      ParmmStorage.GameDay = "<%=reqGameDay%>";
      ParmmStorage.StadiumIDX = "<%=crypt_reqStadiumIDX%>";
      ParmmStorage.StadiumNumber = "<%=reqStadiumNumber%>";
      ParmmStorage.SearchName = "<%=reqSearchName%>";
      ParmmStorage.PlayLevelType = "<%=reqPlayLevelType%>";

      GameDay = ParmmStorage.GameDay;
      StadiumIDX = ParmmStorage.StadiumIDX;
      StadiumNumber = ParmmStorage.StadiumNumber;
      SearchName = ParmmStorage.SearchName;
      PlayLevelType = ParmmStorage.PlayLevelType;


      tGameTitleIdx = $("#selGameTitleIdx").val();
      GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
      PlayTypeSexValue = $("#selPlayTypeSex").val();
      TeamGbValue = $("#selTeamGb").val();
      LevelValue = $("#selLevel").val();


      if (hrefMove == "Operate.asp") {
        post_to_url('./' + hrefMove, { 'GameTitle': tGameTitleIdx,'GroupGameGb': GroupGameGbValue,'TeamGb': TeamGbValue,'Level': LevelValue, 'PlayType': PlayTypeSexValue, 'GameDay' : GameDay, 'StadiumIDX' : StadiumIDX ,'StadiumNumber' : StadiumNumber, 'SearchName' : SearchName, 'PlayLevelType' : PlayLevelType});
      }
      else {
        post_to_url('./' + hrefMove, { 'tGameTitleIdx': tGameTitleIdx,'tGroupGameGb': GroupGameGbValue,'tTeamGb': TeamGbValue,'tLevel': LevelValue, 'tPlayTypeSex': PlayTypeSexValue, 'GameDay' : GameDay, 'StadiumIDX' : StadiumIDX ,'StadiumNumber' : StadiumNumber, 'SearchName' : SearchName, 'PlayLevelType' : PlayLevelType});
      }
    };


    function popupOpen(addrs, w, h){
      if (w === undefined)
        w = 1280;
      if (h === undefined)
        h = 747;
      var popWidth = w; // 팝업창 넓이
      var popHeight = h; // 팝업창 높이
      var winWidth = document.body.clientWidth; // 현재창 넓이
      var winHeight = document.body.clientHeight; // 현재창 높이
      var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
      var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표
      var popLeftPos = (winX + (winWidth - popWidth) / 2); // 팝업 x 가운데
      var popTopPos = (winY + (winHeight - popHeight) / 2)-100; // 팝업 y 가운데

      tGameTitleIdx = $("#selGameTitleIdx").val();
      GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
      PlayTypeSexValue = $("#selPlayTypeSex").val();
      TeamGbValue = $("#selTeamGb").val();
      LevelValue = $("#selLevel").val();

      urltext = { 'tGameTitleIdx': tGameTitleIdx,'tGroupGameGb': GroupGameGbValue,'tTeamGb': TeamGbValue,'tLevel': LevelValue, 'tPlayTypeSex': PlayTypeSexValue};

      var popUrl = addrs; //팝업창에 출력될 페이지 URL
      var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
      window.open(popUrl,"JoResult",popOption);

      post_to_url_popup('JoResult', './' + addrs, { 'tGameTitleIdx': tGameTitleIdx,'tGroupGameGb': GroupGameGbValue,'tTeamGb': TeamGbValue,'tLevel': LevelValue, 'tPlayTypeSex': PlayTypeSexValue});


    };



    function chgpopupOpen(addrs, w, h, leveldtlidx, groupidx, teamgamenum, gamenum, ordernum, teamdtl){

      document.getElementById('divLangSelect').style.display='none';

      if (w === undefined)
        w = 1280;
      if (h === undefined)
        h = 747;
      var popWidth = w; // 팝업창 넓이
      var popHeight = h; // 팝업창 높이
      var winWidth = document.body.clientWidth; // 현재창 넓이
      var winHeight = document.body.clientHeight; // 현재창 높이
      var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
      var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표
      var popLeftPos = (winX + (winWidth - popWidth) / 2); // 팝업 x 가운데
      var popTopPos = (winY + (winHeight - popHeight) / 2)-100; // 팝업 y 가운데

      tGameLeveldtlIDX = leveldtlidx;
      tTourneyGroupIDX = groupidx;
      tTeamGameNum = teamgamenum;
      tGameNum = gamenum;
      tOrderNum = ordernum;
      tTeamDtl = teamdtl;
      
      urltext = {'tGameLeveldtlIDX': tGameLeveldtlIDX,'tTourneyGroupIDX': tTourneyGroupIDX,'tTeamGameNum': tTeamGameNum,'tGameNum': tGameNum,'tOrderNum': ordernum, 'tTeamDtl': tTeamDtl};

      var popUrl = addrs; //팝업창에 출력될 페이지 URL
      var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
      window.open(popUrl,"JoResult1",popOption);

      post_to_url_popup('JoResult1', './' + addrs, urltext);


    };    

    function menuOpen(addrs, w, h, leveldtlidx, groupidx, teamgamenum, gamenum, ordernum, teamdtl){
      var divTop = window.event.clientY + window.pageYOffset;
      var divLeft = window.event.clientX; //좌측 좌표

      console.log($(".tourney_table_box").offset().top);
      //chgpopupOpen
      $("#A_PlayerChg").attr("href","javascript:chgpopupOpen('" + addrs + "','" + w + "','" + h + "','" + leveldtlidx + "','" + groupidx + "','" + teamgamenum + "','" + gamenum + "','" + ordernum + "','" + teamdtl + "')");

      $('#divLangSelect').css({
          "top": divTop
          ,"left": divLeft
          ,"position": "absolute"
      }).show();
    }

</script>
</head>
<body id="DP_BODY">
<form name="Tourney_frm" method="post">
<input type="hidden" name="TotRound" id="TotRound" value="<%=TotRound%>" >
<input type="hidden" name="GangCnt" id="GangCnt" value="<%=GangCnt%>" >
<input type="hidden" name="GameType" id="GameType" value="<%=GameType%>" >
<input type="hidden" name="GameLevelDtlIDX" id="GameLevelDtlIDX" >
<input type="hidden" name="GameLevelIDX" id="GameLevelIDX" >
<input type="hidden" name="Select_STR1" id="Select_STR1" >
<input type="hidden" name="Select_STR2" id="Select_STR2" >
<input type="hidden" name="Select_GroupIDX" id="Select_GroupIDX" >
<input type="hidden" name="LeagueGameNum" id="LeagueGameNum" >
<input type="hidden" name="H_GroupGameGb" id="H_GroupGameGb" >
<input type="hidden" name="GroupGameGb" id="GroupGameGb" >
<!-- S: content Game_operation -->
<div class="Game_operation">
  <h2 class="t_title">경기운영관리</h2>

  <!-- S: competition_select -->
  <div class="competition_select">
      <%
        Admin_Authority = crypt.DecryptStringENC(Request.Cookies(global_HP)("Authority"))
        Admin_UserID = crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))

        IF (Admin_Authority <> "O" AND Admin_Authority <> "D") Then
          Dim tblGameTitleCnt :tblGameTitleCnt = 0
          LSQL = " SELECT GameTitleIDX, GameTitleName"
          LSQL = LSQL & " FROM tblGameTitle "
          LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = '" & reqGameTitleIdx & "'"
          Set LRs = Dbcon.Execute(LSQL)

          IF Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
              tblGameTitleCnt = tblGameTitleCnt + 1
              tGameTitleName = LRs("GameTitleName")
              LRs.MoveNext()
            Loop
          End If
          LRs.Close

          IF cdbl(tblGameTitleCnt) = 0 Then
            LSQL = " SELECT Top 1 GameTitleIDX, GameTitleName"
            LSQL = LSQL & " FROM tblGameTitle "
            LSQL = LSQL & " WHERE DelYN = 'N' "
            LSQL = LSQL & " Order By WriteDate desc "

            Set LRs = Dbcon.Execute(LSQL)

            IF Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                crypt_ReqGameTitleIdx =  crypt.EncryptStringENC(LRs("GameTitleIDX"))
                Call oJSONoutput.Set("tGameTitleIdx", crypt_ReqGameTitleIdx )
                strjson = JSON.stringify(oJSONoutput)
                tGameTitleName = LRs("GameTitleName")
                LRs.MoveNext()
              Loop
            End If
            LRs.Close
          End IF


    %>
    <input type="text" name="strGameTtitle" id="strGameTtitle" placeholder="검색할 대회명을 입력해 주세요." value="<%=tGameTitleName%>" style="width:750px">
    <input type="hidden" name="selGameTitleIdx" id="selGameTitleIdx" value="<%=crypt_ReqGameTitleIdx%>">
    <% Else%>


      <select id="selGameTitleIdx" name="selGameTitleIdx"  onchange="OnGameTitleChanged(this.value)">
          <%
              Dim GameTitleIdxCnt : GameTitleIdxCnt = 0
              LSQL = " SELECT a.GameTitleIDX, a.GameTitleName"
              LSQL = LSQL & " FROM tblGameTitle a "
              LSQL = LSQL & " INNER JOIN tblAdminGameTitle d on d.AdminID = '" & Admin_UserID &"' And a.GameTitleIDX = d.GameTitleIDX "
              LSQL = LSQL & " WHERE a.DelYN = 'N'"
              LSQL = LSQL & " ORDER BY A.GameS DESC"
              Set LRs = Dbcon.Execute(LSQL)

              IF Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                    GameTitleIdxCnt = GameTitleIdxCnt  + 1
                    tGameTitleIdx = LRs("GameTitleIDX")
                    crypt_tGameTitleIdx = crypt.EncryptStringENC(tGameTitleIdx)
                    tGameTitleName = LRs("GameTitleName")

                    IF(Len(reqGameTitleIdx) = 0 ) Then
                      IF (GameTitleIdxCnt = 1) Then
                        reqGameTitleIdx = tGameTitleIdx
                        crypt_reqGameTitleIdx = crypt.EncryptStringENC(reqGameTitleIdx)
                      End IF
                    End IF

                    If CDBL(reqGameTitleIdx) = CDBL(tGameTitleIdx)Then
                      %>
                        <option value="<%=crypt_tGameTitleIdx%>" selected> <%=tGameTitleName%></option>
                      <% Else %>
                        <option value="<%=crypt_tGameTitleIdx%>" > <%=tGameTitleName%></option>
                      <%
                    End IF
                  LRs.MoveNext()
                Loop
              End If
              LRs.Close
          %>
      </select>
    <% End IF %>
  </div>
  <!-- E: competition_select -->

  <!-- s: 대진표/경기진행 순서/경기진행 결과/상품수령 관리 탭 -->
  <div class="tab">
    <ul>
      <li style="width:20%" class="on">
        <a href='javascript:href_Move("OperateNew.asp")'>대진표</a>
      </li>
      <li style="width:20%">
        <a href='javascript:href_Move("GameOrder.asp")'>경기진행 순서</a>
      </li>
      <li style="width:20%">
        <a href='javascript:href_Move("GameResult.asp")'>경기진행 결과</a>
      </li>
      <li style="width:20%">
        <a href='javascript:href_Move("GameGift.asp")'>경기실적 관리</a>
      </li>
      <li style="width:20%">
        <a href='javascript:href_Move("GameETCGift.asp")'>추가점수 관리</a>
      </li>       
    </ul>
  </div>
  <!-- e: 대진표/경기진행 순서/경기진행 결과/상품수령 관리 탭 -->

  <!-- s: 연선 조 순위 결과 -->
  <div class="search_box" id="divGameLevelMenu">
    <%
      '예선 본선 값 설정
      LSQL = " SELECT PubCode, PubName  "
      LSQL = LSQL & " FROM  tblPubcode "
      LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B003'"
      LSQL = LSQL & " ORDER BY OrderBy "

      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        arryGroupGameGb = LRs.getrows()
      End If
    %>
    <label>
      <% If IsArray(arryGroupGameGb) Then
          For ar = LBound(arryGroupGameGb, 2) To UBound(arryGroupGameGb, 2)
            tGroupGameGb    = arryGroupGameGb(0, ar)
            crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
            tGroupGameGbName  = arryGroupGameGb(1, ar)
            if(tGroupGameGbName = "개인전") Then
      %>
            <input type="radio" name="radioGroupGameGb" value="<%=crypt_tGroupGameGb%>"  onClick='OnGameLevelChanged(<%=strjson%>)' <% if reqGroupGameGb = tGroupGameGb Then %> Checked <%End IF%> >
            <span>개인전</span>
      <%
            END IF
          Next
        End If
      %>
    </label>

    <label>
         <% If IsArray(arryGroupGameGb) Then
          For ar = LBound(arryGroupGameGb, 2) To UBound(arryGroupGameGb, 2)
            tGroupGameGb    = arryGroupGameGb(0, ar)
            crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
            tGroupGameGbName  = arryGroupGameGb(1, ar)

            if(tGroupGameGbName = "단체전") Then
              %>
                <input type="radio" name="radioGroupGameGb" value="<%=crypt_tGroupGameGb%>" onClick='OnGameLevelChanged(<%=strjson%>)' <% if reqGroupGameGb = tGroupGameGb Then %> Checked <%End IF%> >
                <span>단체전</span>
              <%
            END IF
          Next
        End If
      %>
    </label>

    <select id="selGameDay" onChange='OnSearchChanged()'>
       <option value="">::경기일자 선택::</option>
      <%
        LSQL = " SELECT GameDay"
        LSQL = LSQL & " FROM "
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT A.GameDay"
        LSQL = LSQL & " FROM dbo.tblTourney A"
        LSQL = LSQL & " INNER JOIN dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
        LSQL = LSQL & " INNER join dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND B.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"
        LSQL = LSQL & " AND A.GameDay IS NOT NULL"
        LSQL = LSQL & " "
        LSQL = LSQL & " UNION ALL"
        LSQL = LSQL & " "
        LSQL = LSQL & " SELECT A.GameDay"
        LSQL = LSQL & " FROM dbo.tblTourneyTeam A"
        LSQL = LSQL & " INNER JOIN dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
        LSQL = LSQL & " INNER join dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND B.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"
        LSQL = LSQL & " AND A.GameDay IS NOT NULL"
        LSQL = LSQL & " ) AS AA"
        LSQL = LSQL & " GROUP BY AA.GameDay"

        Set LRs = Dbcon.Execute(LSQL)
        IF Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            IF reqGameDay = LRs("GameDay") Then
              selectedReqGameDay = "selected"
            Else
              selectedReqGameDay =""
            End IF
            Response.Write "<option value=" & LRs("GameDay") & " " &  selectedReqGameDay  &">" & LRs("GameDay") & "</option>"
            LRs.MoveNext()
          Loop
        End If

        LRs.Close
      %>
    </select>

    <select id="selStadiumIDX" onchange='OnGameLevelChanged(<%=strjson%>)'>
    <option value="">::경기장소 선택::</option>
      <%
          LSQL = " SELECT AA.StadiumIDX, AA.StadiumName"
          LSQL = LSQL & " FROM"
          LSQL = LSQL & " ("
          LSQL = LSQL & " SELECT A.StadiumIDX, B.StadiumName"
          LSQL = LSQL & " FROM tblTourney A"
          LSQL = LSQL & " INNER JOIN tblStadium B ON B.StadiumIDX = A.StadiumIDX"
          LSQL = LSQL & " WHERE A.DelYN = 'N' "
          LSQL = LSQL & " AND B.DelYN = 'N'"
          LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"
          IF reqGameDay <> "" Then
            LSQL = LSQL & " AND A.GameDay = '" & reqGameDay & "'"
          END IF
          LSQL = LSQL & " AND ISNULL(A.StadiumIDX,'') <> ''"
          LSQL = LSQL & " GROUP BY A.StadiumIDX, B.StadiumName"
          LSQL = LSQL & " "
          LSQL = LSQL & " UNION ALL"
          LSQL = LSQL & " "
          LSQL = LSQL & " SELECT A.StadiumIDX, B.StadiumName"
          LSQL = LSQL & " FROM tblTourneyTeam A"
          LSQL = LSQL & " INNER JOIN tblStadium B ON B.StadiumIDX = A.StadiumIDX"
          LSQL = LSQL & " WHERE A.DelYN = 'N' "
          LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "'"
          IF reqGameDay <> "" Then
            LSQL = LSQL & " AND A.GameDay = '" & reqGameDay & "'"
          END IF
          LSQL = LSQL & " AND ISNULL(A.StadiumIDX,'') <> ''"
          LSQL = LSQL & " GROUP BY A.StadiumIDX, B.StadiumName"
          LSQL = LSQL & " ) AA"
          LSQL = LSQL & " GROUP BY AA.StadiumIDX, AA.StadiumName"

          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
              StadiumIDX = LRs("StadiumIDX")
              StadiumName = LRs("StadiumName")
              crypt_StadiumIDX = crypt.EncryptStringENC(StadiumIDX)

              IF reqStadiumIDX = StadiumIDX Then
                selectedStadiumIDX = "selected"
              Else
                selectedStadiumIDX =""
              End IF

          %>
              <option value="<%=crypt_StadiumIDX%>" <%=selectedStadiumIDX%>><%=StadiumName%></option>
          <%
              LRs.MoveNext
            Loop
          End If
          LRs.Close
      %>
    </select>

    <select id="selPlayTypeSex" name="selPlayTypeSex"  onChange='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::종목 선택::</option>
      <%
          LSQL = " SELECT  Sex, PlayType, dbo.FN_NameSch(Sex,'PubCode') AS SexName, dbo.FN_NameSch(PlayType,'PubCode') AS PlayTypeName"
          LSQL = LSQL & " FROM tblGameLevel"
          LSQL = LSQL & " WHERE DelYN = 'N'"
          LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "'"
          IF reqGroupGameGb <> "" Then
            LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
          End IF
          LSQL = LSQL & " GROUP BY Sex, PlayType"

          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
              tSex = LRs("Sex")
              crypt_tSex = crypt.EncryptStringENC(tSex)
              tSexName= LRs("SexName")
              tPlayType = LRs("PlayType")
              crypt_tPlayType= crypt.EncryptStringENC(tPlayType)
              tPlayTypeName= LRs("PlayTypeName")

              IF (reqSex = tSex) and  (reqPlayType = tPlayType) Then %>
                <option value="<%=crypt_tSex%>|<%=crypt_tPlayType%>" selected><%=tSexName & tPlayTypeName%></option>
              <%Else%>
                <option value="<%=crypt_tSex%>|<%=crypt_tPlayType%>" ><%=tSexName & tPlayTypeName%></option>
              <%End IF
              LRs.MoveNext()
              Loop
            End If
          LRs.Close
          %>
    </select>

    <% 'Response.Write " LSQL : " & LSQL & "<BR/>"  %>
    <select id="selTeamGb" name="selTeamGb"  onChange='OnGameLevelChanged(<%=strjson%>)'>
        <option value="">::부서 선택::</option>
      <%
        LSQL = " SELECT a.TeamGb, dbo.FN_NameSch(a.TeamGb,'TeamGb') AS TeamGbNm,"
        LSQL = LSQL & " SexNm = (case a.Sex when  'man' then	'남자' when 'woman' then '여자' else  '혼합' End  )"
        LSQL = LSQL & " FROM tblGameLevel a"
        LSQL = LSQL & " inner Join tblTeamGbInfo b on a.TeamGb = b.TeamGb and b.DelYN = 'N'"
        LSQL = LSQL & " WHERE a.DelYN = 'N'"
        LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "'"
        IF reqGroupGameGb <> "" Then
            LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
        End IF
        IF ReqSex <> "" Then
            LSQL = LSQL & " AND Sex = '" & ReqSex & "'"
        End IF
        IF ReqPlayType <> "" Then
            LSQL = LSQL & " AND PlayType = '" & ReqPlayType & "'"
        End IF
        LSQL = LSQL & " GROUP BY a.TeamGb, Sex"
        Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            tTeamGb = LRs("TeamGb")
            tSexNm = LRs("SexNm")
            crypt_tTeamGb = crypt.EncryptStringENC(tTeamGb)

            IF (reqTeamGb = tTeamGb) Then
            %>
            <option value="<%=crypt_tTeamGb%>" selected ><%=LRs("TeamGbNM")%>-<%=tSexNm%></option>
            <% ELSE  %>
            <option value="<%=crypt_tTeamGb%>" <%If TeamGb =  crypt.EncryptStringENC(LRs("TeamGb")) Then%>selected<%End If %>><%=LRs("TeamGbNM")%>-<%=tSexNm%></option>
            <% END IF
              LRs.MoveNext()
            Loop
          End If
          LRs.Close
        %>

    </select>
    <%'Response.Write "LSQL :" & LSQL & "<bR>"%>
    <select  id="selLevel" name="selLevel"  onChange='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::종목 선택::</option>
        <%
            LSQL = " SELECT Level, dbo.FN_NameSch(Level,'Level') AS LevelNm , dbo.FN_NameSch(leveljooName, 'PubCode') AS LevelJooNameNm, LevelJooName,LevelJooNum "
            LSQL = LSQL & " FROM tblGameLevel "
            LSQL = LSQL & " WHERE DelYN = 'N' "
            LSQL = LSQL & " AND UseYN = 'Y' "
            LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "' "
            IF reqGroupGameGb <> "" Then
            LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
            End IF
            IF ReqSex <> "" Then
                LSQL = LSQL & " AND Sex = '" & ReqSex & "'"
            End IF
            IF ReqPlayType <> "" Then
                LSQL = LSQL & " AND PlayType = '" & ReqPlayType & "'"
            End IF
            IF reqTeamGb <> "" Then
                LSQL = LSQL & " AND TeamGb = '" & reqTeamGb & "'"
            End IF
            'LSQL = LSQL & " AND Level <> '' "
            LSQL = LSQL & " And (LevelJooName <> '' or LevelJooName <> 'B0120007') "
            LSQL = LSQL & " GROUP BY Level, leveljooName, LevelJooNum"

             Set LRs = Dbcon.Execute(LSQL)
                IF Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                  tLevel = LRs("Level")
                  crypt_tLevel = crypt.EncryptStringENC(tLevel)
                  tLevelNM = LRs("LevelNm")

                  tLevelJooName = LRs("LevelJooName")
                  crypt_tLevelJooName = crypt.EncryptStringENC(tLevelJooName)

                  tLevelJooNameNm= LRs("LevelJooNameNm")

                  IF(tLevelJooNameNm = "미선택") Then
                    tLevelJooNameNm = ""
                  End IF

                  tLevelJooNum = LRs("LevelJooNum")
                  IF (reqLevel = tLevel) AND (reqLevelJooName = tLevelJooName) And (reqLevelJooNum = tLevelJooNum) Then%>
                    <option value="<%=crypt_tLevel%>|<%=crypt_tLevelJooName%>|<%=tLevelJooNum%>" selected> <%=tLevelNM & " " & tLevelJooNameNm & " " & tLevelJooNum%>조</option>
                  <%ELSE%>
                    <option value="<%=crypt_tLevel%>|<%=crypt_tLevelJooName%>|<%=tLevelJooNum%>"> <%=tLevelNM & " " & tLevelJooNameNm & " " & tLevelJooNum%>조</option>
                  <%
                  END IF
                    LRs.MoveNext()
                  Loop
                End If
              LRs.Close %>
    </select>

    <input id="txtSearchLevel" type="text" placeholder="종목,팀,선수 검색" value="">
    <a href='javascript:OnGameLevelChanged(<%=strjson%>);' class="gray_btn" >검색</a>
    <%'Response.Write "LSQL :" & LSQL & "<bR>"%>
    <a href="javascript:popupOpen('ranking_result_popup.asp');" class="red_btn">예선 최종 순위 결과 <i class="fas fa-angle-right"></i></a>
    <a href="../GameNumber/SettingGameOrder_elite.asp" class="red_btn" target="_blank">경기진행순서 변경 <i class="fas fa-angle-right"></i></a>
    <%If Admin_Authority = "O" OR Admin_Authority = "A" OR Admin_Authority = "C" OR Admin_Authority = "F" Then%>
    <a href="../GameNumber/SettingGameOrder_board.asp" class="red_btn" target="_blank">전광판코트배정<i class="fas fa-angle-right"></i></a>
    <%End If%>
  </div>
  <!-- e: 연선 조 순위 결과 -->

  <!-- s: 검색 -->
  <!--
  <div class="search_box">
    <select>
      <option>::경기장소 선택::</option>
    </select>
    <select>
      <option>코트 선택</option>
    </select>
    <input type="text" placeholder="이름을 검색하세요">
    <a href="#" class="gray_btn">검색</a>
  </div>
  -->
  <!-- e: 검색 -->
</div>
<!-- E: content Game_operation -->

<div class="content-wrap operate">
  <!-- S: match_sel -->
  <div class="match_sel">
  <!--
    <h3 class="title">
      <span>일반부</span>
      <span>혼합복식</span>
      <span>40대 D</span>
    </h3>
  -->
  </div>
  <!-- E: match_sel_val -->

  <!-- S: drowbody-->
  <div id="drowbody" class="clearfix">

      <!-- S: ctr-box -->
      <div class="ctr-box">
        <table class="table-list table-head">
          <thead>
            <tr><th>편성표<a href="javascript:TourneyAllPrint();" class="all-print" title="대진표 전체출력">출력</a><a href="javascript:sel_LevelList();();" class="all-print">갱신</a></th></tr>
          </thead>
        </table>

        <!-- S: scroll-box -->
        <div class="scroll-box">
          <table class="table-list sel-match" id="DP_LevelDtlList">
            <tbody>
            </tbody>
          </table>
        </div>
        <!-- E: scroll-box -->
      </div>
      <!-- E: ctr-box -->


      <!-- S: ctr-box -->
      <div class="ctr-box">
        <!--
        <table class="table-list table-head">
          <thead>
            <tr>
              <th>순번</th>
              <th>참가대기 선수(팀)</th>

            </tr>
          </thead>
        </table>
        -->
        <!-- S: scroll-box -->
        <!--
        <div class="scroll-box">
          <table class="table-list sel-match" id="DP_RequestGroup">
            <tbody>

            </tbody>
          </table>
        </div>
        -->
        <!-- E: scroll-box -->
      </div>
      <!-- E: ctr-box -->


    <div class="tourney-container" id="realTimeContents">

          <table class="tourney_admin table-fix-head 64" id="tourney_admin">
            <thead>
              <tr id="DP_GangBtn">
              <th><a href='' class='btn_a btn_func' data-collap='' id='DP_Gang'>-강</a></th>

             <!--
              <th">
              <a href='' class="btn_a btn_func" data-collap="" id="set_Round_a1">64&nbsp;강</a>
              </th>
              <th">
              <a href='' class="btn_a btn_func" data-collap="" id="A1">32&nbsp;강</a>
              </th>
              <th">
              <a href='' class="btn_a btn_func" data-collap="" id="A2">16&nbsp;강</a>
              </th>
              <th">
              <a href='' class="btn_a btn_func" data-collap="" id="A3">8&nbsp;강</a>
              </th>
              <th">
              <a href='' class="btn_a btn_func" data-collap="" id="A4">4&nbsp;강</a>
              </th>
              <th">
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

<!-- <a href="#" class="btn btn-default" data-toggle="modal" data-target=".set-order">단체전 오더 등록</a>
<p>단체전 오더 등록은 경기진행 순서에서</p> -->

<!-- S: include set_order 단체전 오더 등록 -->
<!-- #include file = "./groupGame/set_order.asp" -->
<!-- E: include set_order 단체전 오더 등록 -->

<!-- 폼 레이어  -->
<div id="divLangSelect" style="position:absolute;display:none;background-color:#f3f3f3;border:solid 2px #d0d0d0;width:200px;height:150px;padding:10px;">
  <div style="position:absolute;top:5px;right:5px">
    <span onClick="javascript:document.getElementById('divLangSelect').style.display='none'" style="cursor:pointer;font-size:1.5em" title="닫기">✕</span>
  </div>
  <div>
    <div>
    <a href="#" id="A_PlayerChg" style="width:156px;height: 35px;line-height: 35px;margin-top: 20px;background: #ec0a2e;color: #fff;text-align: center;border-radius: 3px;margin-left: 5px;">
      대진표 선수교체
    </a>
    </div>
    <div>
    <!--
    <a href="#" id="A_InputResult" style="width:156px;height: 35px;line-height: 35px;margin-top: 20px;background: #ec0a2e;color: #fff;text-align: center;border-radius: 3px;margin-left: 5px;">
      결과입력
    </a>
    --> 
    </div>  
  </div>
</div>
<!-- //폼 레이어  -->


</form>
<script>
	var $windowHeight = $(window).height(); /* 윈도창 높이 */
	var $leftscrollBox = $(".content-wrap.operate .ctr-box .scroll-box");
	var $Gameoperation =$(".Game_operation").outerHeight(true);
	var $tableHead = $(".content-wrap.operate .table-head").outerHeight(true);
	var $operateMatch = $(".operate .match_sel").outerHeight(true);
	var $rightTable = $(".tourney-container .league_table_box");
	$leftscrollBox.css("height",$windowHeight - $Gameoperation - $tableHead - $operateMatch -30);
	$rightTable.css("height",$windowHeight - $Gameoperation - $tableHead - $operateMatch -30);

  //cli_RequestLevelDtl('1327',this)
</script>
</body>
</html>
