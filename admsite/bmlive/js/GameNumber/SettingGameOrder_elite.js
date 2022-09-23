const deleteMethod = "delete"; // 이전 값 삭제
const changeMethod = "change"; // 변경

////////////명령어////////////
CMD_SEARCHGAMETITLE = 1;
CMD_SEARCHSCHDEULE = 4;
CMD_SEARCHSTADIUMGAMEDAY = 5; 
CMD_SELECTSCHEDULEGAME = 6;

CMD_INITGAMESCHEDULE =10;

CMD_UPDATEGAMETOURNEY = 20;
CMD_UPDATEMODALTOURNEY = 21;
CMD_UPDATETOURNEYPUSH = 22;
CMD_UPDATETOURNEYRESETTURNNUM = 23;
CMD_UPDATETOURNEYRESTORETURNNUM = 24;

/* ================================================= */
// 경기 진행 순서 변경 화면... 
CMD_CHANGECELLPOS_REPLACE     = 101;         // Replace          - 선택한 셀과 위치를 바꾼다. 
CMD_CHANGECELLPOS_INSERTUP    = 102;         // Insert Up        - 선택한 셀의 위로 넣어준다. 
CMD_CHANGECELLPOS_INSERTDOWN  = 103;         // Insert Down      - 선택한 셀의 아래로 넣어준다. 
/* ================================================= */

////////////명령어////////////

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
mx.GameDay=""                     // by Aramdry GameTourney의 인자로 추가
mx.StadiumIdx = ""                // by Aramdry 
mx.GameCourt = ""                 // by Aramdry 
mx.GameOrder = ""                   // by Aramdry 
/* GameTourney 게임 */

/* =================== select cell pos (x, y) ======================= */
mx.posX = -1;
mx.posY = -1;
/* =================== select cell pos (x, y) ======================= */

/* =================== Move된 Cell 이전 Pos정보 ======================= */
mx.fromPosX = -1;
mx.fromPosY = -1;
mx.toPosX = -1;
mx.toPosY = -1;
/* =================== Move된 Cell 이전 Pos정보 ======================= */


/* 조회된 경기장 및 날짜 */
mx.searchStadiumIdx = ""          // by Aramdry GameTourney의 인자로 추가할 변수와 이름이 겹쳐서 수정함. mx.StadiumIdx -> mx.searchStadiumIdx
mx.searchGameDay = ""             // by Aramdry GameTourney의 인자로 추가할 변수와 이름이 겹쳐서 수정함. mx.GameDay -> mx.searchGameDay 

/* 종별명 */
mx.TotalGameName = ""

/* 조회된 경기장 및 날짜 */
mx.ResetGameTourney = function (){
  mx.GameLevelDtlIDX ="";
  mx.TeamGameNum ="";
  mx.GameNum="";
  mx.GroupGameGb="";
  mx.GameMethod ="";
  mx.TotalGameName = "";
  mx.GameDay=""
  mx.GameCourt = ""
  mx.StadiumIdx = ""
  mx.GameOrder = ""

  mx.posX = -1
  mx.posY = -1
  $('#tableToureny').resetColor();
  console.log("Clear GameTourney")
};

mx.ResetSchedule = function(){
  mx.searchStadiumIdx = ""
  mx.searchGameDay = ""
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

  if(mx.searchStadiumIdx == "")  {
    alert("경기장소를 선택해주세요.")
    return;
  }
  if(mx.searchGameDay == "") {
    alert("경기일짜를 선택해주세요.")
    return;
  }

  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SearchGameSchedule_elite.asp";
  packet.CMD = CMD_SEARCHSCHDEULE;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = mx.searchStadiumIdx;
  packet.tGameDay = mx.searchGameDay;
  SendPacket(Url, packet);
};

mx.getMovePosFrom = function()
{
  var posObj = {};
  posObj.x = mx.fromPosX;
  posObj.y = mx.fromPosY;
  return posObj; 
}

mx.setMovePosFrom = function(x, y)
{
  mx.fromPosX = Number(x); 
  mx.fromPosY = Number(y); 
}

mx.getMovePosTo = function()
{
  var posObj = {};
  posObj.x = mx.toPosX;
  posObj.y = mx.toPosY;
  return posObj; 
}

mx.setMovePosTo = function(x, y)
{
  mx.toPosX = Number(x); 
  mx.toPosY = Number(y); 
}

mx.setMovePos = function(jsonData)
{
  if( hasown(jsonData, "FromPosX") == "ok" && hasown(jsonData, "FromPosY") == "ok") {
    mx.setMovePosFrom(jsonData.FromPosX, jsonData.FromPosY)
  }

  if( hasown(jsonData, "ToPosX") == "ok" && hasown(jsonData, "ToPosY") == "ok") {
    mx.setMovePosTo(jsonData.ToPosX, jsonData.ToPosY)
  }

  var strLog = strPrintf(" Move From ( {0},{1} ) To ( {0},{1} ) ", mx.fromPosX, mx.fromPosY, mx.toPosX, mx.toPosY);
  console.log(strLog); 
}
////////////Ajax Receive////////////

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
    console.log(" OnReceiveAjax : cmd = " + CMD); 
  switch(CMD) {  
        
      case CMD_SEARCHSCHDEULE:{
        $('#divGameSchedule').html(htmldata); 
        drawMovePos(); 
        console.log(" drawMovePos() "); 
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

      case CMD_CHANGECELLPOS_REPLACE :
      case CMD_CHANGECELLPOS_INSERTUP :
      case CMD_CHANGECELLPOS_INSERTDOWN : {
        printObj(jsondata); 

        mx.setMovePos(jsondata); 
        $("#settingGameOrderModal").modal("hide");
        OnGameScheduleSearch();
      }break;
      
      default:{
      } break;
    }
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
    Url = "/Main/GameNumber/Print_SettingGameOrder.asp?" 
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


function OnGameScheduleSearch() {

    console.log(" In OnGameScheduleSearch.. ");

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

  mx.searchStadiumIdx = selStadiumIDX;
  mx.searchGameDay = selGameDay;

  console.log(" In OnGameScheduleSearch.. 2" );
  mx.ResetGameTourney();
  
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SearchGameSchedule_elite.asp";

  console.log(" In OnGameScheduleSearch.. 3" & Url);
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

  mx.searchStadiumIdx = selStadiumIDX;
  mx.searchGameDay = selDatePicker;

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


function displayMouseOver(str, seltype){

  var strTotalGameName = "▼ 다음경기로 이동 ▼<br>";

  strTotalGameName += mx.TotalGameName;
  
  if (mx.GameLevelDtlIDX != "" && mx.TeamGameNum != "" && mx.GameNum != "" && mx.GroupGameGb != "" ){
    if(seltype == "over"){
      $("#DP_SelectTarget" + str).html(strTotalGameName);
    }
    else{
      $("#DP_SelectTarget" + str).html("");
    }
  }
  else{
    $("#DP_SelectTarget" + str).html("");
  }
}

function OpenPopUpScheduleGame(GameTitleIdx,StadiumIdx,GameLevelDtlIdx, TeamGameNum, GameNum, GroupGameGb, GameDay) {
   Url ="/Ajax/GameNumber/SettingGameOrder_SelectScheduleGame.asp";
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
    console.log("In SetJqueryEvent.. "); 

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
        }
       console.log("gameLevelDtlIDX : " + mx.GameLevelDtlIDX  + ",teamGameNum :" + mx.TeamGameNum + ", gameNum : " + mx.GameNum + ", groupGameGb : " + mx.GroupGameGb + ", deleteMethod : " +deleteMethod );
      }
    }
  });

    function getMoveConfirmStr(MoveType)
    {
        var strMoveType = "";
        switch(MoveType) {
            case 1: strMoveType = "교환 - Replace\n"; break; 
            case 2: strMoveType = "위로 추가 - Insert Up\n"; break; 
            case 3: strMoveType = "아래로 추가 - Insert Down\n"; break; 
        }
        return strMoveType;
    }

  // by Aramdry GameTourney 함수 수정 - 인자만 정리 
  // 게임 테이블 Row 선택 Click 이벤트
  $(document).on("click", "#tableGameSchedule tbody tr td", function() {

    if($("#ModifyCloseYN").val() == "Y"){
      alert("마감된 경기는 변경이 불가합니다. 필요 시, 전산관리자에게 요청 바랍니다.");
      return;
    }

    //some think
    if(event.target.type == undefined)
    { 
      var posObj, strConfirm, strInfos;      
      var innerHtml = $(this).html();
      var gameCourt = $(this).find("#hiddenGameCourt").val();
      var gameOrder = $(this).find("#hiddenGameOrder").val();
      var gameGroupGb = $(this).find("#hiddenGroupGameGB").val();
      var gameTeamGameNum = $(this).find("#hiddenTeamGameNum").val();
      var gameGameNum  = $(this).find("#hiddenGameNum").val();
      var stadiumIdx = $(this).find("#hiddenStadiumIdx").val();
      var gameDay = $(this).find("#hiddenGameDay").val();
      var gameLevelDtlIdx = $(this).find("#hiddenGameLevelDtlIdx").val();
      var cellMoveType = getSelectVal("sel_cellMoveType");      
      var posObj = getPosInTableByCell("tableGameSchedule", this); 

      var strLog = strPrintf("게임 테이블 Row sel Pos = ({0}, {1}), id={2}, cellMoveType = {3}", posObj.x, posObj.y, this.id, cellMoveType);
      console.log(strLog);

      if(posObj.x == -1 || posObj.y == -1) return; 

      strInfos = getColumnDataByCellPos(posObj.x); 
      console.log(strInfos);
      
      if (mx.posX != -1 && (posObj.x != mx.posX || posObj.y != mx.posY) )     // 테이블 위치가 틀리다. 
      {        
        strConfirm = getMoveConfirmStr(Number(cellMoveType));
        strConfirm += strPrintf("코트 이동 : ({0}, {1}) => ({2}, {3}) ", mx.posX, mx.posY, posObj.x, posObj.y); 
        if(confirm(strConfirm) == true)
        {  
          Url ="/Ajax/GameNumber/updateGameCourtOrder_elite.asp";
          var packet = {};

          packet.CMD = CMD_CHANGECELLPOS_REPLACE;
          
          switch(Number(cellMoveType)) {
            case 1: packet.CMD = CMD_CHANGECELLPOS_REPLACE; break; 
            case 2: packet.CMD = CMD_CHANGECELLPOS_INSERTUP; break; 
            case 3: packet.CMD = CMD_CHANGECELLPOS_INSERTDOWN; break; 
          }
          
          /* ====================== 선택한 경기 ====================== */
          packet.FromPosX = mx.posX;
          packet.FromPosY = mx.posY;          
          packet.FromStadiumIdx = mx.StadiumIdx;                     // 경기장 번호 
          packet.FromGameDay = mx.GameDay;                           // 게임 날짜 : 게임 시작 날짜 
          packet.FromGameCourt = mx.GameCourt;                       // 게임 코트 : 몇 코트 (장소)
          packet.FromGameOrder = mx.GameOrder;                       // 게임 순서 : 몇회전
          packet.FromGameGroupGb = mx.GroupGameGb;                   // Game 방식 : 개인전 / 단체전 
          packet.FromGameLevelDtlIDX = mx.GameLevelDtlIDX;
          packet.FromGameTeamGameNum = mx.TeamGameNum;               // Team 게임 Number - unique
          packet.FromGameNum = mx.GameNum;                           // 게임 Number - unique
          /* ====================== 선택한 경기 ====================== */

          /* ====================== 바꿀 위치 ====================== */
          packet.ToPosX = posObj.x;
          packet.ToPosY = posObj.y;          
          packet.ToStadiumIdx = stadiumIdx;                     // 경기장 번호 
          packet.ToGameDay = gameDay;                           // 게임 날짜 : 게임 시작 날짜 
          packet.ToGameCourt = gameCourt;                       // 게임 코트 : 몇 코트 (장소)
          packet.ToGameOrder = gameOrder;                       // 게임 순서 : 몇회전
          packet.ToGameGroupGb = gameGroupGb;                   // Game 방식 : 개인전 / 단체전 
          packet.ToGameLevelDtlIDX = gameLevelDtlIdx;
          packet.ToGameTeamGameNum = gameTeamGameNum;           // Team 게임 Number - unique
          packet.ToGameNum = gameGameNum;                       // 게임 Number - unique
          /* ====================== 바꿀 위치 ====================== */

          /* ============================================ */
          // Replace가 아니면 해당 cell 세로 전체 Data를 가져온다. 
      //    if(packet.CMD != CMD_CHANGECELLPOS_REPLACE)
          {
            strInfos = getColumnDataByCellPos(posObj.x); 
            if(strInfos != "") packet.gameInfos = strInfos;
          }
          /* ============================================ */

          printObj(packet);
          SendPacket(Url, packet);
        }
        else {      // click 초기화             
          $('#tableGameSchedule').resetTDColor();
          mx.ResetGameTourney();
        }
      }
      else
      {
        $('#tableToureny').resetColor();  
        var objnum = $(this).data("id");

        //색깔리셋
        $(this).css('background-color','#81bcff');
        mx.GameLevelDtlIDX = gameLevelDtlIdx            // 경기 타입 - unique   
        mx.StadiumIdx = stadiumIdx;                     // 경기장 번호 
        mx.GameDay = gameDay;                           // 게임 날짜 : 게임 시작 날짜 
        mx.GameCourt = gameCourt;                       // 게임 코트 : 몇 코트 (장소)
        mx.GameOrder = gameOrder;                       // 게임 순서 : 몇회전
        mx.GroupGameGb = gameGroupGb;                   // Game 방식 : 개인전 / 단체전 
        mx.TeamGameNum = gameTeamGameNum;               // Team 게임 Number - unique
        mx.GameNum = gameGameNum;                       // 게임 Number - unique         
        
        mx.TotalGameName = $("#hiddenTotalGameName" + objnum).val();

        mx.posX = posObj.x; 
        mx.posY = posObj.y;     
      } 
    }    
  });
}
  


//    // 게임 테이블 Row 선택 Click 이벤트
//    $(document).on("click", "#tableGameSchedule tbody tr td", function() {

//     //some think
//     if(event.target.type == undefined)
//     { 
//         console.log("게임 테이블 Row 선택 Click 이벤트.. order elite.js"); 
//       var innerHtml = $(this).html();
//       var gameCourt = $(this).find("#hiddenGameCourt").val();
//       var gameOrder = $(this).find("#hiddenGameOrder").val();
//       var gameGroupGb = $(this).find("#hiddenGroupGameGB").val();
//       var gameTeamGameNum = $(this).find("#hiddenTeamGameNum").val();
//       var gameGameNum  = $(this).find("#hiddenGameNum").val();
//       var stadiumIdx = $(this).find("#hiddenStadiumIdx").val();
//       var gameDay = $(this).find("#hiddenGameDay").val();
//       var gameLevelDtlIdx = $(this).find("#hiddenGameLevelDtlIdx").val();
      
//       if(typeof(gameCourt) != "undefined" &&typeof(gameOrder) != "undefined") 
//       {
//         if (mx.GameLevelDtlIDX != "" && 
//               mx.TeamGameNum != "" && 
//                 mx.GameNum != "" && 
//                   mx.GroupGameGb != "" )
//         {
//           //console.log("기존 위치 gameLevelDtlIdx : " + mx.GameLevelDtlIDX + " gameGameNum : " + mx.TeamGameNum + "gameTeamGameNum :" +  mx.GameNum + ", gameGroupGb : " + mx.GroupGameGb )
//           //console.log("바꿀 위치 gameLevelDtlIdx : " + gameLevelDtlIdx + " gameGameNum : " + gameGameNum + "gameTeamGameNum :" + gameTeamGameNum + ", gameGroupGb : " + gameGroupGb)
//           if ((mx.GameLevelDtlIDX != gameLevelDtlIdx) || (mx.GameNum !=  gameGameNum) || (mx.TeamGameNum != gameTeamGameNum) || (mx.GroupGameGb != gameGroupGb))
//           {
//             console.log("In 게임 테이블 Row 선택 Click 이벤트.. 2"); 
//             if(confirm("코트 :" + gameCourt + ", 순서 " + gameOrder))
//             {
//               //console.log("바꿀 위치 stadiumIdx : " + stadiumIdx + " gameDay : " + gameDay + "gameCourt :" + gameCourt + ", gameOrder : " + gameOrder)
//               //암호화해야하는 URL

//               Url ="/Ajax/GameNumber/updateGameSchedule_elite.asp";
//               var packet = {};
//               packet.CMD = CMD_UPDATEGAMETOURNEY;

//               /* 선택한 경기 */
//               packet.tObjectGameLevelDtlIDX = mx.GameLevelDtlIDX;
//               packet.tObjectTeamGameNum = mx.TeamGameNum;
//               packet.tObjectGameNum = mx.GameNum;
//               packet.tObjectGroupGameGb = mx.GroupGameGb;
//               /* 선택한 경기 */

//               /* 바꿀 위치 */
//               packet.tOtherStadiumIdx = stadiumIdx;                     // 경기장 번호 
//               packet.tOtherGameDay = gameDay;                           // 게임 날짜 : 게임 시작 날짜 
//               packet.tOtherGameCourt = gameCourt;                       // 게임 코트 : 몇 코트 (장소)
//               packet.tOtherGameOrder = gameOrder;                       // 게임 순서 : 몇회전
//               packet.tOtherGameGroupGb = gameGroupGb;                   // Game 방식 : 개인전 / 단체전 
//               packet.tOtherGameTeamGameNum = gameTeamGameNum;           // Team 게임 Number - unique
//               packet.tOtherGameGameNum = gameGameNum;                   // 게임 Number - unique
//               packet.tMethod = mx.GameMethod;
              
//               /* 바꿀 위치 */
//               SendPacket(Url, packet);
//             }
//           }
//           else
//           {
//             //console.log("원래 위치 GameLevelDtlIDX : " + mx.GameLevelDtlIDX + " TeamGameNum : " + mx.TeamGameNum + "GameNum :" + mx.GameNum + ", GroupGameGb : " +  mx.GroupGameGb)
//             //console.log("바꿀 위치 GameLevelDtlIDX : " + gameLevelDtlIdx + " TeamGameNum : " + gameTeamGameNum + "GameNum :" + gameGameNum + ", GroupGameGb : " + gameGroupGb)
//             $('#tableToureny').resetColor();
//             $('#tableGameSchedule').resetTDColor();
//             mx.ResetGameTourney();
//           }
//         }
//         else{
//           $('#tableToureny').resetColor();

//           var objnum = $(this).data("id");

//           //색깔리셋
//           //$('#tableGameSchedule').resetTDColor();
//           $(this).css('background-color','#81bcff');
//           mx.GameLevelDtlIDX = gameLevelDtlIdx
//           mx.TeamGameNum = gameTeamGameNum;
//           mx.GameNum = gameGameNum;
//           mx.GroupGameGb = gameGroupGb;
//           mx.GameMethod = changeMethod;
          
//           mx.TotalGameName = $("#hiddenTotalGameName" + objnum).val();
          
//         }
//       }
//     }
//   });
// };




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

/* =================================================================================== 
  Format String ex) strVal = utx.strPrintf("this {0} a tes{1} string containing {2} values", "is","t","some");
  =================================================================================== */
  drawMovePos = function()
  {    
      if( mx.toPosY != -1 ) {
        var id = strPrintf("spid_moveFrom_{0}_{1}", mx.toPosY, mx.toPosX )
        var strVal = strPrintf("moveFrom ({0},{1})", mx.fromPosX, mx.fromPosY) 
        $('#'+id).html(strVal);

        strLog = strPrintf(" In drawMovePos id = {0} , val  = {1} ", id, strVal)
        console.log(strLog); 
      }
  }


/* =================================================================================== 
  Format String ex) strVal = utx.strPrintf("this {0} a tes{1} string containing {2} values", "is","t","some");
  =================================================================================== */
  strPrintf = function()
  {
      var content = arguments[0];
      for (var i=0; i < arguments.length-1; i++)
      {
              var replacement = '{' + i + '}';
              content = content.replace(replacement, arguments[i+1]);  
      }
      return content;
  }

/* =================================================================================== 
    table id, table 안의 tb ctrl을 받아서 그 pos을 반환한다. 
    posObj.x : col position, posObj.y : row position
  =================================================================================== */
getPosInTableByCell = function(id_table, tbCell) {
  var table, rows, cols;
  var posObj = {};
  posObj.x = -1; posObj.y = -1;
  
  table = document.getElementById(id_table);
  if( table  == null) return posObj; 

  rows = table.rows;

  for(var i=0; i< rows.length; i++)
  {
    cells = rows[i].cells;    
    for(var j=0; j<cells.length; j++)
    { 
      if(cells[j] == tbCell) {
        posObj.x = j; posObj.y = i;   
        return posObj; 
      }     
    }
  }
  
  return posObj; 
}

/* =================================================================================== 
  select element - id, value를 입력받아 value를 가지고 있는 option을 선택한다. 
  =================================================================================== */
  setSelectVal = function(sender, selData)
  {
      $("#"+sender).val(selData);
  }
  
  /* =================================================================================== 
      select element - id를 입력받아 현재 선택된 value를 return 한다. 
    =================================================================================== */
  getSelectVal = function(sender)
  {       
      return $("#"+sender+ " option:selected").val();       
  }

  /* =================================================================================== 
      object이 property를 가지고 있는지 유무 
    =================================================================================== */
  function hasown(obj,  prop){
    if (obj.hasOwnProperty(prop) == true){
      return "ok";
    }
    else{
      return "notok";
    }
  }

/* ===================================================================================     
    column position을 입력받아 모든 row의 column Data를 반환한다. 
    Return Data 형식 column Data는 ,로 구분 ex) ,,,,  
              각 row의 column Data는 /로 구분 ex) ,,,,/,,,,/,,,,   (3개의 column Data가 존재)
    Return Data는 .asp파일에서 (/)구분자와 (,)구분자를 이용하여 Data Array를 만든다. 
  =================================================================================== */
  getColumnDataByCellPos = function(posCol) {
    var table, rows, cols;
    var strData = "";
    
    table = document.getElementById("tableGameSchedule");
    if( table  == null) return strData; 
  
    rows = table.rows;
  
    for(var i=0; i< rows.length; i++)
    {
      cells = rows[i].cells;    
      for(var j=0; j<cells.length; j++)
      { 
        if(cells[j] && j == posCol) {
          var gameCourt = $(cells[j]).find("#hiddenGameCourt").val();
          var gameOrder = $(cells[j]).find("#hiddenGameOrder").val();
          var gameGroupGb = $(cells[j]).find("#hiddenGroupGameGB").val();
          var gameTeamGameNum = $(cells[j]).find("#hiddenTeamGameNum").val();
          var gameGameNum  = $(cells[j]).find("#hiddenGameNum").val();          
          var gameDay = $(cells[j]).find("#hiddenGameDay").val();
          var gameLevelDtlIdx = $(cells[j]).find("#hiddenGameLevelDtlIdx").val();

          if(strData == ""){
            if(gameGroupGb != undefined && gameGroupGb != "") 
              strData = strPrintf("{0},{1},{2},{3},{4},{5},{6},{7}", i, gameCourt, gameOrder, 
                                                        gameGroupGb, gameLevelDtlIdx, gameTeamGameNum, gameGameNum, gameDay);
          }
          else{
            if(gameGroupGb != undefined && gameGroupGb != "") 
              strData += strPrintf("/{0},{1},{2},{3},{4},{5},{6},{7}", i, gameCourt, gameOrder, 
                                                        gameGroupGb, gameLevelDtlIdx, gameTeamGameNum, gameGameNum, gameDay);          
          }          
        }     
      }
    }    
    console.log(strData); 

    return strData; 
  }
