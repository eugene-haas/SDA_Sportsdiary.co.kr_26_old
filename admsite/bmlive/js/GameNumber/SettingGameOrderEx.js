const deleteMethod = "delete"; // 이전 값 삭제
const changeMethod = "change"; // 변경

mx = {};

/* 대회 */
mx.GameTitleIdx =""
/* 대회 */

/* GameLevel 종별 */
mx.GameLevelIdx =""
/* GameLevel 종별 */

/* GameTourney 게임 */
mx.GameLevelDtlIDX =""
mx.TeamGameNum =""
mx.GameNum=""
mx.GroupGameGb=""
mx.GameMethod=""
/* GameTourney 게임 */

/* 조회된 경기장 및 날짜 */
mx.StadiumIdx = ""
mx.GameDay = ""
mx.GameTime = ""
/* 조회된 경기장 및 날짜 */
mx.ResetGameTourney = function (){
  mx.GameLevelDtlIDX =""
  mx.TeamGameNum =""
  mx.GameNum=""
  mx.GroupGameGb=""
  mx.GameMethod =""
  mx.GameTime = ""
  $('#tableToureny').resetColor();
  console.log("Clear GameTourney")
};

mx.ResetSchedule = function(){
  mx.StadiumIdx = ""
  mx.GameDay = ""
  console.log("Clear ResetScheduleInfo")
};

mx.ResetLevel = function(){
  mx.GameLevelIdx =""
  console.log("Clear Level")
};

mx.SelectGameTitle = function(){

  $('#tableToureny > tbody').empty();
  $('#tableGameSchedule').empty();

  var item = "<tr>"
  item = item + "<td colspan=4>조회 결과가 존재 하지 않습니다.</td>"
  item = item + "</tr>"
  $('#tableToureny > tbody:last').append(item);
  
  var myTable = jQuery("#tableGameSchedule");
  var thead = myTable.find("thead");
  if (thead.length===0){
      thead = jQuery("<thead></thead>").appendTo(myTable);    
  }

  var tbody = myTable.find("tbody");
  if (tbody.length===0){
    tbody = jQuery("<tbody></tbody>").appendTo(myTable);    
  }

  item = "<tr>"
  item = item + "<td>1. 진행순서 조회 시 [경기장소]와 [경기일자] 선택 후 조회를 해주세요.</td>"
  item = item + "</tr>"
  item = item + "<tr>"
  item = item + "<td>2. 진행순서 생성 시 [경기장소] 선택, 경기진행 표에 경기를 넣고 달력으로 날짜 선택, 저장을 눌러주세요.</td>"
  item = item + "</tr>"
  $('#tableGameSchedule > tbody:last').append(item);
  item = "<tr>"
  item = item + "<th>경기진행 표</th>"
  item = item + "</tr>"
  $('#tableGameSchedule > thead:last').append(item);

  $('#btnInsertScheduleRow').remove();

};

mx.OnGameScheduleSearch =function () {
  var packet = {};

  if(mx.StadiumIdx == "")  {
    alert("경기장소를 선택해주세요.")
    return;
  }
  if(mx.GameDay == "") {
    alert("경기일짜를 선택해주세요.")
    return;
  }
  
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SearchGameScheduleEx.asp";
  packet.CMD = CMD_SEARCHSCHDEULE;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = mx.StadiumIdx;
  packet.tGameDay = mx.GameDay;
  SendPacket(Url, packet);
};

mx.applyOpenningGameTime =function (startTime, endTime, bAddOpenning) {
   var packet = {};

   var strLog = utx.sprintf("applyOpenningGameTime sTime = {0}, eTime = {1}, bAddOpenning = {2}", startTime, endTime, bAddOpenning );
   console.log(strLog);
 
   if(mx.StadiumIdx == "")  {
     alert("경기장소를 선택해주세요.")
     return;
   }
   if(mx.GameDay == "") {
     alert("경기일짜를 선택해주세요.")
     return;
   }
   
   //암호화해야하는 URL
   Url ="/Ajax/GameNumber/changeGameTime.asp";
   packet.CMD = (bAddOpenning) ? CMD_ADD_OPENNING_TIME : CMD_DEL_OPENNING_TIME;
   packet.GTIDX   = mx.GameTitleIdx;
   packet.SDIDX   = mx.StadiumIdx;
   packet.GDAY    = mx.GameDay;
   packet.STIME   = startTime; 
   packet.ETIME   = endTime; 
   SendPacket(Url, packet); 
 };
////////////명령어////////////
CMD_SEARCHGAMETITLE = 1;
CMD_SEARCHGAMELEVEL = 2;
CMD_SEARCHTOURNEY = 3;
CMD_SEARCHSCHDEULE = 4;
CMD_SEARCHSTADIUMGAMEDAY = 5; 
CMD_SELECTSCHEDULEGAME = 6;

CMD_INITGAMESCHEDULE =10;

CMD_UPDATEGAMETOURNEY = 20;
CMD_UPDATEMODALTOURNEY = 21;
CMD_UPDATETOURNEYPUSH = 22;
CMD_UPDATETOURNEYRESETTURNNUM = 23;
CMD_UPDATETOURNEYRESTORETURNNUM = 24;

CMD_ADD_OPENNING_TIME = 101;              // 개회식 시간을 추가한다. 
CMD_DEL_OPENNING_TIME = 102;              // 개회식 시간을 제거한다. 



////////////명령어////////////

////////////Ajax Receive////////////

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    
      case CMD_SEARCHGAMELEVEL: {
        
        $('#divGameLevelList').html(htmldata); 
        mx.ResetGameTourney();
        //버튼에 대한 이벤트 
        //SetKeyUpDown();
        $("#"+mx.GameLevelIdx).css('background-color','#81bcff');
      } break;

      case CMD_SEARCHTOURNEY:{
        $('#divGameTourney').html(htmldata); 
      } break;

      case CMD_SEARCHSCHDEULE:{
        mx.ResetGameTourney();
        $('#divGameSchedule').html(htmldata); 
      } break;

      case CMD_SEARCHSTADIUMGAMEDAY : {
        $('#divStadiumGameDay').html(htmldata); 
      } break;

      case CMD_INITGAMESCHEDULE : {
        $('#divGameSchedule').html(htmldata); 
      } break;

      case CMD_UPDATEGAMETOURNEY :{
        mx.OnGameScheduleSearch();
        mx.ResetGameTourney();
        OnGameTourenySearch();
        OnGameLevelSearch();
      } break;
      case CMD_SELECTSCHEDULEGAME : {
        $("#settingGameOrderModalBody").html(htmldata);
        $("#settingGameOrderModal").modal();

        $(".time_ipt").timepicker(
          {
            timeFormat: 'HH:mm',
            interval: 60,
            minTime: '7',
            maxTime: '06:00pm',
            startTime: '07:00',
            dynamic: false,
            dropdown: true,
            scrollbar: true
          });
          
          $('.ui-timepicker').css("z-index", "999999");
          $('.ui-timepicker').css("position", "absolute");
          
      }break;
      case CMD_UPDATEMODALTOURNEY : {
        $("#settingGameOrderModal").modal("hide");
        OnGameScheduleSearch();
      }break;
      case CMD_UPDATETOURNEYRESETTURNNUM :
      {
        OnGameScheduleSearch();
      }break;

      case CMD_UPDATETOURNEYRESTORETURNNUM :
      {
        OnGameScheduleSearch();
      }break;
      case CMD_ADD_OPENNING_TIME :        // 개회식 시간 설정 후 Search 호출해 List갱신 
      {
        OnGameScheduleSearch();
      }break;

      case CMD_DEL_OPENNING_TIME :        // 개회식 시간 삭제 후 Search 호출해 List갱신 
      {
        OnGameScheduleSearch();
      }break;

      
      default:{
      } break;
    }
};

function OnGameLevelSearch()
{
  txtGameLevelName = $("#txtGameLevelName").val(); 

  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SettingGameOrder_SearchGameLevel.asp";
  packet.CMD = CMD_SEARCHGAMELEVEL;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tGameLevelName = txtGameLevelName;

  SendPacket(Url, packet);
};

function PrintSchedule()
{

  selStadiumIDX = $("#selStadiumIDX").val(); 
  selGameDay = $("#selGameDay").val(); 

  if(selStadiumIDX == "")  {
    alert("경기장소를 선택해주세요.")
    return;
  }

  if(selGameDay == "") {
    alert("경기일짜를 선택해주세요.")
    return;
  }


  if (mx.GameTitleIdx != "" && selStadiumIDX != "" && selGameDay != "" ) { 
    Url = "/Main/GameNumber/Print_SettingGameOrderEx.asp?" 
    + "GameTitleIDX=" + mx.GameTitleIdx +"&StadiumIdx=" + selStadiumIDX + "&GameDay=" + selGameDay; 
    location.href = Url;
  }
  else {
    alert("경기진행순서 경기장소와 일자를 선택해주세요.");
  }
};

function PrintListSchedule()
{
  selStadiumIDX = $("#selStadiumIDX").val(); 
  selGameDay = $("#selGameDay").val(); 

  if(selStadiumIDX == "")  {
    alert("경기장소를 선택해주세요.")
    return;
  }

  if(selGameDay == "") {
    alert("경기일짜를 선택해주세요.")
    return;
  }

  if (mx.GameTitleIdx != "" && selStadiumIDX != "" && selGameDay != "" ) { 
    Url = "/Main/GameNumber/Print_SettingGameOrderList.asp?" 
    + "GameTitleIDX=" + mx.GameTitleIdx +"&StadiumIdx=" + selStadiumIDX + "&GameDay=" + selGameDay; 
    location.href = Url;
  }
  else {
    alert("경기진행순서 경기장소와 일자를 선택해주세요.");
  }
};

function PrintStadium()
{
  selStadiumIDX = $("#selStadiumIDX").val(); 
  selGameDay = $("#selGameDay").val(); 



  if(selStadiumIDX == "")  {
    alert("경기장소를 선택해주세요.")
    return;
  }

  if(selGameDay == "") {
    alert("경기일짜를 선택해주세요.")
    return;
  }

  if (mx.GameTitleIdx != "" && selStadiumIDX != "" && selGameDay != "" ) { 
    Url = "/Main/GameNumber/Print_SettingStadiumList.asp?" 
    + "GameTitleIDX=" + mx.GameTitleIdx +"&StadiumIdx=" + selStadiumIDX + "&GameDay=" + selGameDay; 
    location.href = Url;
  }
  else {
    alert("경기진행순서 경기장소와 일자를 선택해주세요.");
  }
};

function OnGameTourenySearch() {
  
  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SearchTourney.asp";
  packet.CMD = CMD_SEARCHTOURNEY;
  if(mx.GameLevelIdx != "")
  {
    packet.tGameTitleIDX = mx.GameTitleIdx;
    packet.tGameLevelIdx = mx.GameLevelIdx;
    SendPacket(Url, packet);
  }
};

function OnGameScheduleSearch() {

  var packet = {};
  selStadiumIDX = $("#selStadiumIDX").val(); 
  selGameDay = $("#selGameDay").val(); 

  if(selStadiumIDX == "")  {
    alert("경기장소를 선택해주세요.")
    return;
  }

  if(selGameDay == "") {
    alert("경기일짜를 선택해주세요.")
    return;
  }

  mx.StadiumIdx = selStadiumIDX;
  mx.GameDay = selGameDay;

  
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SearchGameScheduleEx.asp";
  packet.CMD = CMD_SEARCHSCHDEULE;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = selStadiumIDX;
  packet.tGameDay = selGameDay;
  SendPacket(Url, packet);
};

function OnGameTitleSearch()
{
  //조회중인 경기 및 경기진행순서 데이터 리셋
  mx.SelectGameTitle();
  //선택된 경기진행순서 조회 정보 리셋
  mx.ResetSchedule();
  //선택된 게임 정보 리셋
  mx.ResetGameTourney();
  //선택된 레벨 정보 리셋
  mx.ResetLevel();

  //종별 검색
  OnGameLevelSearch();
  OnStadiumChanged();
};

function OnStadiumChanged(load=false) {
  selStadiumIDX = $("#selStadiumIDX").val(); 
  selGameDay = $("#selGameDay").val(); 

  var packet = {};
  
  Url ="/Ajax/GameNumber/SearchGameDayOfStadium.asp";
  packet.CMD = CMD_SEARCHSTADIUMGAMEDAY;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = selStadiumIDX;
  packet.tGameDay = selGameDay;
  packet.load = load;
  SendPacket(Url, packet);
};

function UpdateModalTourney(gameLevelDtlIdx, teamGameNum, gameNum, groupGameGb){ 
  var selGameTime = $("#selGameTime").val(); 
  var selGameDay = $("#txt_selGameDay").val(); 

  var packet = {};
  Url ="/Ajax/GameNumber/SettingGameOrder_UpdateModalToruney.asp";
  packet.CMD = CMD_UPDATEMODALTOURNEY;
  packet.tGameLevelDtlIdx = gameLevelDtlIdx;
  packet.tTeamGameNum = teamGameNum;
  packet.tGameNum = gameNum;
  packet.tGroupGameGb = groupGameGb;
  packet.tGameTime = selGameTime;
  packet.tGameDay = selGameDay;
  SendPacket(Url, packet);
};

function UpdateResetTourneyTurnNum(gameLevelDtlIdx, teamGameNum, gameNum, groupGameGb){ 
  var packet = {};
  Url ="/Ajax/GameNumber/SettingGameOrder_UpdateResetTourneyTurnNum.asp";
  packet.CMD = CMD_UPDATETOURNEYRESETTURNNUM;
  packet.tGameLevelDtlIdx = gameLevelDtlIdx;
  packet.tTeamGameNum = teamGameNum;
  packet.tGameNum = gameNum;
  packet.tGroupGameGb = groupGameGb;
  SendPacket(Url, packet);

};

function UpdateRestoreTourneyTurnNum(gameLevelDtlIdx, teamGameNum, gameNum, groupGameGb, stadiumIdx,stadiumNum, turnNum){ 
  var packet = {};
  Url ="/Ajax/GameNumber/SettingGameOrder_UpdateRestoreResetTourneyTurnNum.asp";
  packet.CMD = CMD_UPDATETOURNEYRESTORETURNNUM;
  packet.tGameLevelDtlIdx = gameLevelDtlIdx;
  packet.tTeamGameNum = teamGameNum;
  packet.tGameNum = gameNum;
  packet.tGroupGameGb = groupGameGb;
  
  packet.tStadiumIdx = stadiumIdx;
  packet.tStadiumNum = stadiumNum;
  packet.tTurnNum = turnNum;
  SendPacket(Url, packet);

};




function UpdateTourneyPush(gameTitleIdx, stadiumIdx, gameLevelDtlIdx, teamGameNum, gameNum, groupGameGb, gameDay){ 
  var txtTourenyPushCourt = $("#txtTourenyPushCourt").val(); 
  var txtTourenyPushGameOrder = $("#txtTourenyPushGameOrder").val(); 
  if (txtTourenyPushCourt.length > 0 && txtTourenyPushGameOrder.length > 0)
  {
    if(confirm("정말로 " + txtTourenyPushCourt + "코트, " + txtTourenyPushGameOrder + "번호로 이동하면 이후 경기 번호들도 이동됩니다. 정말 하시겠습니까??")) {
    var packet = {};
    Url ="/Ajax/GameNumber/SettingGameOrder_UpdateTourneyPush.asp";
    packet.CMD = CMD_UPDATETOURNEYPUSH;
    packet.tGameTitleIdx = gameTitleIdx;
    packet.tStadiumIdx = stadiumIdx;
    packet.tGameLevelDtlIdx = gameLevelDtlIdx;
    packet.tTeamGameNum = teamGameNum;
    packet.tGameNum = gameNum;
    packet.tGroupGameGb = groupGameGb;
    packet.tGameDay = gameDay;
    packet.tTourenyPushCourt = txtTourenyPushCourt;
    packet.tTourenyPushGameOrder = txtTourenyPushGameOrder;
    SendPacket(Url, packet);
    }
  }

};

function initGameSchedule(){
  var packet = {};
 
  selStadiumIDX = $("#selStadiumIDX").val(); 
  selDatePicker = $("#initDatePicker").val(); 

  
  if(selGameTitleIdx == "")  {
    alert("상단의 대회를 선택해주세요.")
    return;
  }

  if(selStadiumIDX == "")  {
    alert("경기장소를 선택해주세요.")
    return;
  }
  if(selDatePicker == "")  {
    alert("달력으로 일자를 선택해주세요.")
    return;
  }

  mx.StadiumIdx = selStadiumIDX;
  mx.GameDay = selDatePicker;

  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/initGameSchedule.asp";
  packet.CMD = CMD_INITGAMESCHEDULE;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = selStadiumIDX;
  packet.tGameDay = selDatePicker;
  SendPacket(Url, packet);
};

$.fn.rowCount = function() {
  return $('tr', $(this).find('tbody')).length;
};

$.fn.columnCount = function() {
  return $('th', $(this).find('thead')).length;
};

$.fn.resetColor = function() {
  $(this).find('tr').each(function() { 
    //$(this).children('th').css('background-color','#white');
    $(this).css( "background-color", "white" );
  });
};

$.fn.resetTDColor = function() {
  $(this).find('td').each(function() { 
    //$(this).children('th').css('background-color','#white');
    $(this).css( "background-color", "white" );
  });
};

function insertScheduleRow(StadiumiDX, GameDay) {

  /*------------------ Row Length------------------ */
  var rowCount = $('#tableGameSchedule').rowCount();
  rowCount = rowCount + 1;
  console.log("rowCount" + rowCount)
  /*------------------ Row Length------------------ */

  /*------------------ Column Length------------------ */
  var columnCount = $('#tableGameSchedule').columnCount();
  console.log("columnCount" + columnCount)
  /*------------------ Column Length------------------ */

  /*------------------ New Tr------------------ */
  var item = "<tr>"
  item = item + "<td>" + rowCount + "</td>"
  for(var i = 1 ; i < columnCount; i++) {
    item = item + "<td>";
    item = item + "<span>" + i + " 코트 " + rowCount + "번호" + "</span>"
    item = item  + "<input type='hidden' id='hiddenGameCourt' name='hiddenGameCourt' value='" + i + "'/>"
    item = item  + "<input type='hidden' id='hiddenGameOrder' name='hiddenGameOrder' value='" + rowCount + "'/>"
    item = item  + "<input type='hidden' id='hiddenStadiumIdx' name='hiddenStadiumIdx' value='" +StadiumiDX + "'/>"
    item = item  + "<input type='hidden' id='hiddenGameDay' name='hiddenGameDay' value='" + GameDay + "'/>"
    item = item + "</td>"
  }
  item = item + "</tr>"
  $('#tableGameSchedule > tbody:last').append(item);
  /*------------------ New Tr------------------ */
  //var scheduleTable = document.getElementById("tableGameSchedule");
  //var lastRow = scheduleTable.rows.length; //It will return the last Index of the row[/HTML]
  //scheduleTable.insertRow(1);
  //var rowLength = $("#tableGameSchedule").attr('rows').length;
  //$('#tableGameSchedule').children('thead').children('tr').children('th').length;
  /* Row Index 제거
      $('table > tr').click( function() {
            $(this).index();
      });
  */

  /* Row ToalLength
      $("#myTable").attr('rows').length;
  */

 $("#tableGameSchedule tbody tr td").click(function() {
  var innerHtml = $(this).html();
  var gameCourt = $(this).find("#hiddenGameCourt").val();
  var gameOrder = $(this).find("#hiddenGameOrder").val();
  console.log("gameCourt : " + gameCourt + ", gameOrder:" + gameOrder  );
});

};

const const_down = "down"
const const_up = "up"

function ChangeGameLevelPosition(action, LCnt) {
  if(LCnt == 1 && const_up == action )
  {
    return; 
  }
  else{

    var beforeLCnt = LCnt - 1
    var afterLCnt = LCnt + 1

    if (beforeLCnt < 1 && const_up== action) {
      return;
    }

    var isBeforeObject = $('#hiddenGameLevelIdx'+ beforeLCnt )
    var isAfterObject = $('#hiddenGameLevelIdx'+ afterLCnt )
    var isObject = $('#hiddenGameLevelIdx'+ LCnt )
    
    if (const_up == action && isBeforeObject.length == 1 )
    {
      console.log("up Current Object : " + isObject.val() + ", Change Object : " + isBeforeObject.val() );
    }
    else if (const_down == action &&  isAfterObject.length == 1 )
    {
      console.log("down Current Object : " + isObject.val() + ", Change Object : " + isAfterObject.val() );
    }
  
  }
};

////////////Custom Function////////////
$(document).ready(function() {
  init();
}); 

init = function() {
  initSettingData();
  initSearchControl();
  //SetKeyUpDown();
  SetJqueryEvent();
  initDate();
  if ($("#selStadiumIDX").val() != "" && $("#selStadiumIDX").val() != "") {
    OnGameScheduleSearch();
  }

  if (mx.GameTitleIdx != ""){
  OnGameLevelSearch();
  }
};

function autoGameSchedule(){
  
  if(mx.GameTitleIdx == "")  {
    alert("상단의 대회를 선택해주세요.")
    return;
  }

  popupOpen("autoGameSchedule1.asp")

};

function initSettingData(){
  if(mx.GameTitleIdx == "") {
    mx.GameTitleIdx = $("#selGameTitleIdx").val(); 
  }
};

function OpenPopUpScheduleGame(GameTitleIdx,StadiumIdx,GameLevelDtlIdx, TeamGameNum, GameNum, GroupGameGb, GameDay) {
   Url ="/Ajax/GameNumber/SettingGameOrder_SelectScheduleGameEx.asp";
   var packet = {};
   packet.CMD = CMD_SELECTSCHEDULEGAME;
   if (GameLevelDtlIdx != "" && TeamGameNum != "" && GameNum != "" && GroupGameGb != "") {
    packet.tGameTitleIdx = GameTitleIdx;
    packet.tStadiumIdx = StadiumIdx;
    packet.tGameLevelDtlIdx = GameLevelDtlIdx;
    packet.tTeamGameNum = TeamGameNum;
    packet.tGameNum = GameNum;
    packet.tGroupGameGb = GroupGameGb;
    packet.tGameDay = GameDay;
    SendPacket(Url, packet);
   }
};

function SetJqueryEvent() {
  // 종별 테이블 Row 선택 Click 이벤트
  $(document).on("click", "#tableGameNumberLevel tbody tr", function() {
    //some think
    if(event.target.type == undefined)
    {
      var innerHtml = $(this).html();
      var number = $(this).find("#hiddenNumber").val();
      var gameLevelIdx = $(this).find('#hiddenGameLevelIdx'+number).val();

      if (typeof(gameLevelIdx) != "undefined")
      {
        $('#tableGameNumberLevel').resetColor();
        $(this).css('background-color','#81bcff');
        mx.GameLevelIdx = gameLevelIdx;
        mx.ResetGameTourney();
        OnGameTourenySearch();
      }
    }
  });

  // 게임 테이블 Row 선택 Click 이벤트
  $(document).on("click", "#tableToureny tbody tr", function() {
    //some think
    if(event.target.type == undefined)
    {
      var innerHtml = $(this).html();
      var teamGameNum = $(this).find("#hiddenTeamGameNum").val();
      var gameNum = $(this).find("#hiddenGameNum").val();
      var gameLevelDtlIDX = $(this).find("#hiddenGameLevelDtlIDX").val();
      var groupGameGb = $(this).find("#hiddenGroupGameGb").val();
      var gameTime = $(this).find("#hiddenGameTime").val();

      

      if (typeof(teamGameNum) != "undefined" && 
                typeof(gameNum) != "undefined" && 
                    typeof(gameLevelDtlIDX) != "undefined" && 
                          typeof(groupGameGb) != "undefined" )
      {
        $('#tableToureny').resetColor();
        $('#tableGameSchedule').resetTDColor();
        $(this).css('background-color','#81bcff');
        /* GameTourney 게임 */

        if ( mx.GameLevelDtlIDX  == gameLevelDtlIDX &&
                mx.TeamGameNum == teamGameNum && 
                    mx.GameNum == gameNum&& 
                      mx.GroupGameGb == groupGameGb ) 
        {
          mx.ResetGameTourney();
        }
        else  {
          mx.GameLevelDtlIDX = gameLevelDtlIDX
          mx.TeamGameNum =teamGameNum
          mx.GameNum=gameNum
          mx.GroupGameGb = groupGameGb;
          mx.GameMethod = deleteMethod;
          mx.GameTime = gameTime;
        }

      var strLog; 
      strLog = utx.sprintf("gameLevelDtlIDX = {0}, teamGameNum = {1}, gameNum = {2}, groupGameGb = {3}, deleteMethod = {4}, gameTime = {5}", 
      mx.GameLevelDtlIDX, mx.TeamGameNum, mx.GameNum, mx.GroupGameGb, mx.GameMethod, mx.GameTime );
      console.log(strLog);
      }
    }
  });


   // 게임 테이블 Row 선택 Click 이벤트
   $(document).on("click", "#tableGameSchedule tbody tr td", function() {
    //some think
    if(event.target.type == undefined)
    { 
      var innerHtml = $(this).html();
      var gameCourt = $(this).find("#hiddenGameCourt").val();
      var gameOrder = $(this).find("#hiddenGameOrder").val();
      var gameGroupGb = $(this).find("#hiddenGroupGameGB").val();
      var gameTeamGameNum = $(this).find("#hiddenTeamGameNum").val();
      var gameGameNum  = $(this).find("#hiddenGameNum").val();
      var stadiumIdx = $(this).find("#hiddenStadiumIdx").val();
      var gameDay = $(this).find("#hiddenGameDay").val();
      var gameLevelDtlIdx = $(this).find("#hiddenGameLevelDtlIdx").val();
      var gameTime = $(this).find("#hiddenGameTime").val();

      var strLog; 
      strLog = utx.sprintf("gameCourt = {0}, gameOrder = {1}, gameGroupGb = {2}, gameTeamGameNum = {3}", 
                     gameCourt, gameOrder, gameGroupGb, gameTeamGameNum);
      console.log(strLog);

      strLog = utx.sprintf("gameGameNum = {0}, stadiumIdx = {1}, gameDay = {2}, gameLevelDtlIdx = {3}, gameTime = {4}", 
                     gameGameNum, stadiumIdx, gameDay, gameLevelDtlIdx, gameTime  )
      console.log(strLog);

      
      if(typeof(gameCourt) != "undefined" &&typeof(gameOrder) != "undefined") 
      {
        if (mx.GameLevelDtlIDX != "" && 
              mx.TeamGameNum != "" && 
                mx.GameNum != "" && 
                  mx.GroupGameGb != "" )
        {
          //console.log("기존 위치 gameLevelDtlIdx : " + mx.GameLevelDtlIDX + " gameGameNum : " + mx.TeamGameNum + "gameTeamGameNum :" +  mx.GameNum + ", gameGroupGb : " + mx.GroupGameGb )
          //console.log("바꿀 위치 gameLevelDtlIdx : " + gameLevelDtlIdx + " gameGameNum : " + gameGameNum + "gameTeamGameNum :" + gameTeamGameNum + ", gameGroupGb : " + gameGroupGb)
          if ((mx.GameLevelDtlIDX != gameLevelDtlIdx) || (mx.GameNum !=  gameGameNum) || (mx.TeamGameNum != gameTeamGameNum) || (mx.GroupGameGb != gameGroupGb))
          {
            if(confirm("코트 :" + gameCourt + ", 순서 " + gameOrder))
            {
              //console.log("바꿀 위치 stadiumIdx : " + stadiumIdx + " gameDay : " + gameDay + "gameCourt :" + gameCourt + ", gameOrder : " + gameOrder)
              //암호화해야하는 URL
              Url ="/Ajax/GameNumber/updateGameScheduleEx.asp";
              var packet = {};
              packet.CMD = CMD_UPDATEGAMETOURNEY;

              /* 선택한 경기 */
              packet.tObjectGameLevelDtlIDX = mx.GameLevelDtlIDX;
              packet.tObjectTeamGameNum = mx.TeamGameNum;
              packet.tObjectGameNum = mx.GameNum;
              packet.tObjectGroupGameGb = mx.GroupGameGb;
              packet.tObjectGameTime = mx.GameTime;
              /* 선택한 경기 */

              /* 바꿀 위치 */
              packet.tOtherStadiumIdx = stadiumIdx;
              packet.tOtherGameDay = gameDay;
              packet.tOtherGameCourt = gameCourt;
              packet.tOtherGameOrder = gameOrder;
              packet.tOtherGameGroupGb = gameGroupGb;
              packet.tOtherGameTeamGameNum = gameTeamGameNum;
              packet.tOtherGameGameNum = gameGameNum;
              packet.tOtherGameTime = gameTime;
              packet.tMethod = mx.GameMethod;

              strLog = utx.sprintf("change gameTime1 = {0}, gameTime2 = {1}", packet.tObjectGameTime, packet.tOtherGameTime );
              console.log(strLog);
              
              /* 바꿀 위치 */
              SendPacket(Url, packet);
            }
          }
          else
          {
            //console.log("원래 위치 GameLevelDtlIDX : " + mx.GameLevelDtlIDX + " TeamGameNum : " + mx.TeamGameNum + "GameNum :" + mx.GameNum + ", GroupGameGb : " +  mx.GroupGameGb)
            //console.log("바꿀 위치 GameLevelDtlIDX : " + gameLevelDtlIdx + " TeamGameNum : " + gameTeamGameNum + "GameNum :" + gameGameNum + ", GroupGameGb : " + gameGroupGb)
            $('#tableToureny').resetColor();
            $('#tableGameSchedule').resetTDColor();
            mx.ResetGameTourney();
          }
        }
        else{
          $('#tableToureny').resetColor();
          $('#tableGameSchedule').resetTDColor();
          $(this).css('background-color','#81bcff');
          mx.GameLevelDtlIDX = gameLevelDtlIdx
          mx.TeamGameNum =gameTeamGameNum
          mx.GameNum= gameGameNum
          mx.GroupGameGb = gameGroupGb;
          mx.GameMethod = changeMethod;
          mx.GameTime = gameTime;
        }
      }
    }
  });
};




function SetKeyUpDown(){
  $(".up, .down").click(function() {
    
    if(event.target.type =="submit")
    {
      var $element = this;
      var row = $($element).parents("tr:first");
    }
    
  });
};

function initDate(){
  $(function() {
    $(".date_ipt" ).datepicker({ 
        changeYear:true,
        changeMonth: true, 
        dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        showMonthAfterYear:true,
        showButtonPanel: true, 
        currentText: '오늘 날짜', 
        closeText: '닫기', 
        dateFormat: "yy-mm-dd"
        
    });
    $(".date_ipt").datepicker('setDate', 'today');
  });

};

function initSearchControl() {
  $( "#strGameTtitle" ).autocomplete({
    source : function( request, response ) {
      $.ajax(
        {
            type: 'post',
            url: "../../Ajax/GameTitleMenu/searchGameTitle_NotEnd.asp",
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
          var obj = {}
          obj.CMD = CMD_SEARCHGAMETITLE;
          obj.tIdx = ui.item.tidx;
          obj.crypt_tIdx = ui.item.crypt_tidx;
          obj.tGameTitleName = ui.item.gameTitleName;
          mx.GameTitleIdx = obj.crypt_tIdx;
          OnGameTitleSearch();
        }
    });
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
  tGameTitleIdx = mx.GameTitleIdx 
  urltext = { 'tGameTitleIdx': mx.GameTitleIdx};
  var popUrl = addrs; //팝업창에 출력될 페이지 URL
  var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
  window.open(popUrl,"JoResult",popOption);
  post_to_url_popup('JoResult', './' + addrs, { 'tGameTitleIdx': tGameTitleIdx});
};
