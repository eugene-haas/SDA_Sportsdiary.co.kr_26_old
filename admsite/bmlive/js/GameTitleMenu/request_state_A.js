
var mx = {};

mx.TabType = "";


////////////명령어////////////
CMD_SELECTMENU = 1;
CMD_SEARCHLEVEL = 2;
CMD_SEARCHTEAM = 3;

////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {

  switch(CMD) {
    case CMD_SELECTMENU:

    if(dataType == "html") {
        $('#divMenuArea').html(htmldata);
    }
    break;

    case CMD_SEARCHLEVEL :
    {
      $('#info_request').html(htmldata);
      $('#LevelCnt').html(jsondata.LevelCnt);
      $('#ParticipateTeamCnt').html(jsondata.ParticipateTeamCnt);
    } break;

    case CMD_SEARCHTEAM : {
      $('#info_request').html(htmldata);
    } break;
    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////


OnClickTabType = function (TabType)
{
  var GameTitleIDX = $("#CIDX").val();
  console.log("TabType : " +TabType );
  console.log("mx.TabType : " + mx.TabType );
  if (TabType != mx.TabType)
  {

    if (TabType == "LEVEL")
    OnSearchLevel();
    else
    OnSearchTeam();
  }
  mx.TabType = TabType;
  $("#TabType").val(mx.TabType);

  Url ="/Ajax/Request/request_state_A_Menu.asp"
  var packet = {};
  packet.CMD = CMD_SELECTMENU;
  packet.GameTitleIDX = GameTitleIDX;
  packet.TabType = mx.TabType;
  packet.GroupGameGB = selObject.GroupGameGB;
  packet.Sex = selObject.Sex;
  packet.PlayType = selObject.PlayType;
  packet.LevelJoo = selObject.LevelJoo;
  SendPacket(Url, packet)
};

var selObject = {};
selObject.GroupGameGB = ""
selObject.Sex = ""
selObject.PlayType = "";
selObject.LevelJoo = ""


selectLevel = function (sexValue, playTypeValue){
  selObject.Sex= sexValue;
  selObject.PlayType = playTypeValue;

  //console.log("Sex : " + selObject.Sex);
  //console.log("PlayType : " + selObject.PlayType);
  OnClickTabType(mx.TabType);
  OnSearchLevel();

};


selectGroupGameGB = function (GroupGameGB){

  selObject.GroupGameGB= GroupGameGB;
  //console.log("GroupGameGB : " + selObject.GroupGameGB);
  //console.log("PlayType : " + selObject.PlayType);
  OnClickTabType(mx.TabType);
  OnSearchLevel();
};

selectLevelJoo = function(LevelJoo){
  selObject.LevelJoo = LevelJoo;
  //console.log("LevelJoo : " + selObject.LevelJoo);
  OnClickTabType(mx.TabType);
  OnSearchLevel();
};

OnSearchLevel = function() {

  Url = "/Ajax/Request/request_state_A_SearchLevel.asp"

  var GameTitleIDX = $( "#CIDX" ).val();
  var EnterType = $( "#fnd_EnterType" ).val();
  var packet = {};
  packet.CMD = CMD_SEARCHLEVEL;
  packet.GameTitleIDX = GameTitleIDX;
  packet.EnterType = EnterType;
  packet.Sex = selObject.Sex;
  packet.PlayType = selObject.PlayType;
  packet.LevelJoo = selObject.LevelJoo;
  packet.GroupGameGB = selObject.GroupGameGB;
  SendPacket(Url, packet);
};


OnSearchTeam = function() {
  Url = "/Ajax/Request/request_state_A_SearchTeam.asp"
  var GameTitleIDX = $( "#CIDX" ).val();
  var EnterType = $( "#fnd_EnterType" ).val();
  var SearchWord = $( "#txtSearchWord" ).val();
  var packet = {};
  packet.CMD = CMD_SEARCHTEAM;
  packet.GameTitleIDX = GameTitleIDX;
  packet.EnterType = EnterType;
  packet.SearchWord = SearchWord;
  SendPacket(Url, packet);
};



ViewParticipate = function(gameLevelIDX){
  var GameLevelIDX = $('<input type="hidden" value="'+ gameLevelIDX+ '" name="GameLevelIDX" id="GameLevelIDX">');
  $('form[name=s_frm]').append($(GameLevelIDX));
  valUrl = "./request_state_ParticipateLevel.asp"
  $('form[name=s_frm]').attr('action', valUrl);
  $('form[name=s_frm]').submit();
};



ViewParticipateTeam = function(teamCode,teamDtl){
  var TeamCode = $('<input type="hidden" value="'+ teamCode+ '" name="TeamCode" id="TeamCode">');
  var TeamDtl = $('<input type="hidden" value="'+ teamDtl+ '" name="TeamDtl" id="TeamDtl">');

  $('form[name=s_frm]').append($(TeamCode));
  $('form[name=s_frm]').append($(TeamDtl));
  valUrl = "./request_state_ParticipateTeam.asp"
  $('form[name=s_frm]').attr('action', valUrl);
  $('form[name=s_frm]').submit();
};

  //Make File: Excel file
  function make_FileExcel(){

    var SearchWord = $( "#txtSearchWord" ).val();
    var GroupGameGB = $('<input type="hidden" value="'+ selObject.GroupGameGB+ '" name="GroupGameGB" id="GroupGameGB">');
    var Sex = $('<input type="hidden" value="'+ selObject.Sex+ '" name="Sex" id="Sex">');
    var PlayType = $('<input type="hidden" value="'+ selObject.PlayType+ '" name="PlayType" id="PlayType">');
    var LevelJoo = $('<input type="hidden" value="'+ selObject.LevelJoo+ '" name="LevelJoo" id="LevelJoo">');

    $('form[name=s_frm]').append($(TabType));
    $('form[name=s_frm]').append($(GroupGameGB));
    $('form[name=s_frm]').append($(Sex));
    $('form[name=s_frm]').append($(PlayType));
    $('form[name=s_frm]').append($(LevelJoo));
    $('form[name=s_frm]').append($(SearchWord));
    $('form[name=s_frm]').attr('action','./request_state_excel.asp');
    $('form[name=s_frm]').submit();

    $('#GroupGameGB').remove();
    $('#Sex').remove();
    $('#PlayType').remove();
    $('#LevelJoo').remove();


  }

  function make_FileExcel_1(){

    var SearchWord = $( "#txtSearchWord" ).val();
    var GroupGameGB = $('<input type="hidden" value="'+ selObject.GroupGameGB+ '" name="GroupGameGB" id="GroupGameGB">');
    var Sex = $('<input type="hidden" value="'+ selObject.Sex+ '" name="Sex" id="Sex">');
    var PlayType = $('<input type="hidden" value="'+ selObject.PlayType+ '" name="PlayType" id="PlayType">');
    var LevelJoo = $('<input type="hidden" value="'+ selObject.LevelJoo+ '" name="LevelJoo" id="LevelJoo">');

    $('form[name=s_frm]').append($(TabType));
    $('form[name=s_frm]').append($(GroupGameGB));
    $('form[name=s_frm]').append($(Sex));
    $('form[name=s_frm]').append($(PlayType));
    $('form[name=s_frm]').append($(LevelJoo));
    $('form[name=s_frm]').append($(SearchWord));
    $('form[name=s_frm]').attr('action','./request_state_excel_gj.asp');
    $('form[name=s_frm]').submit();

    $('#GroupGameGB').remove();
    $('#Sex').remove();
    $('#PlayType').remove();
    $('#LevelJoo').remove();


  }


// 18.12.06 SSA 최승규과장님 요청 건 엑셀형식 수정작업으로 인한 테스트 함수
  function make_FileExcel_111() {
    var SearchWord = $( "#txtSearchWord" ).val();
    var GroupGameGB = $('<input type="hidden" value="'+ selObject.GroupGameGB+ '" name="GroupGameGB" id="GroupGameGB">');
    var Sex = $('<input type="hidden" value="'+ selObject.Sex+ '" name="Sex" id="Sex">');
    var PlayType = $('<input type="hidden" value="'+ selObject.PlayType+ '" name="PlayType" id="PlayType">');
    var LevelJoo = $('<input type="hidden" value="'+ selObject.LevelJoo+ '" name="LevelJoo" id="LevelJoo">');

    $('form[name=s_frm]').append($(TabType));
    $('form[name=s_frm]').append($(GroupGameGB));
    $('form[name=s_frm]').append($(Sex));
    $('form[name=s_frm]').append($(PlayType));
    $('form[name=s_frm]').append($(LevelJoo));
    $('form[name=s_frm]').append($(SearchWord));
    $('form[name=s_frm]').attr('action','./request_state_excel_gj_Team.asp');
    $('form[name=s_frm]').submit();

    $('#GroupGameGB').remove();
    $('#Sex').remove();
    $('#PlayType').remove();
    $('#LevelJoo').remove();

  }

  function make_FileExcel_hs() {
    var SearchWord = $( "#txtSearchWord" ).val();
    var GroupGameGB = $('<input type="hidden" value="'+ selObject.GroupGameGB+ '" name="GroupGameGB" id="GroupGameGB">');
    var Sex = $('<input type="hidden" value="'+ selObject.Sex+ '" name="Sex" id="Sex">');
    var PlayType = $('<input type="hidden" value="'+ selObject.PlayType+ '" name="PlayType" id="PlayType">');
    var LevelJoo = $('<input type="hidden" value="'+ selObject.LevelJoo+ '" name="LevelJoo" id="LevelJoo">');

    $('form[name=s_frm]').append($(TabType));
    $('form[name=s_frm]').append($(GroupGameGB));
    $('form[name=s_frm]').append($(Sex));
    $('form[name=s_frm]').append($(PlayType));
    $('form[name=s_frm]').append($(LevelJoo));
    $('form[name=s_frm]').append($(SearchWord));
    $('form[name=s_frm]').attr('action','./request_state_excel_gj_Team_hs.asp');
    $('form[name=s_frm]').submit();

    $('#GroupGameGB').remove();
    $('#Sex').remove();
    $('#PlayType').remove();
    $('#LevelJoo').remove();

  }

  function make_FileExcel_12() {
    var SearchWord = $( "#txtSearchWord" ).val();
    var GroupGameGB = $('<input type="hidden" value="'+ selObject.GroupGameGB+ '" name="GroupGameGB" id="GroupGameGB">');
    var Sex = $('<input type="hidden" value="'+ selObject.Sex+ '" name="Sex" id="Sex">');
    var PlayType = $('<input type="hidden" value="'+ selObject.PlayType+ '" name="PlayType" id="PlayType">');
    var LevelJoo = $('<input type="hidden" value="'+ selObject.LevelJoo+ '" name="LevelJoo" id="LevelJoo">');

    $('form[name=s_frm]').append($(TabType));
    $('form[name=s_frm]').append($(GroupGameGB));
    $('form[name=s_frm]').append($(Sex));
    $('form[name=s_frm]').append($(PlayType));
    $('form[name=s_frm]').append($(LevelJoo));
    $('form[name=s_frm]').append($(SearchWord));
    $('form[name=s_frm]').attr('action','./request_state_excel_JM.asp');
    $('form[name=s_frm]').submit();

    $('#GroupGameGB').remove();
    $('#Sex').remove();
    $('#PlayType').remove();
    $('#LevelJoo').remove();

  }
////////////Custom Function////////////
$(document).ready(function(){
  init();
  initTabSelected();
  if (mx.TabType =="LEVEL"){
    OnSearchLevel();
  }
  else{
    OnSearchTeam();
  }
});

init = function(){
  radio_btn();
  radio_btn1();
  radio_btn2();
};

function radio_btn()
{
  $(".radio_btn").eq(0).addClass("on");

  $(".radio_btn").click (function(){
    $(".radio_btn").removeClass("on");
    $(this).addClass("on");
  })
};

function radio_btn1()
{
  $(".radio_btn1").eq(0).addClass("on");

  $(".radio_btn1").click (function(){
    $(".radio_btn1").removeClass("on");
    $(this).addClass("on");
  })
};

function radio_btn2()
{
  $(".radio_btn2").eq(0).addClass("on");

  $(".radio_btn2").click (function(){
    $(".radio_btn2").removeClass("on");
    $(this).addClass("on");
  })
};
