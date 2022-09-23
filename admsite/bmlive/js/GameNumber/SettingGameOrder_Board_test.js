const deleteMethod = "delete"; // 이전 값 삭제
const changeMethod = "change"; // 변경

mx = {};

/* 대회 */
mx.GameTitleIdx =""
mx.dec_GameTitleIdx = ""
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

  var GameStatus = $("#selGameStatus").val()

  if(mx.StadiumIdx == "")  {
    alert("경기장소를 선택해주세요.")
    return;
  }
  if(mx.GameDay == "") {
    alert("경기일짜를 선택해주세요.")
    return;
  }

  $("#URLCopy").css("display","");
  $("#hiddenURL").css("display","");

  if(GameStatus == "A"){
    Url ="/Ajax/GameNumber/SearchGameSchedule_Board_GameEnd.asp";
  }
  else{
    Url ="/Ajax/GameNumber/SearchGameSchedule_Board_test.asp";
  }


  //암호화해야하는 URL
  
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
   Url ="/Ajax/GameNumber/changeGameTime_Board.asp";
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
CMD_SEARCHUSECOURT = 7;
CMD_STADIUMOFF = 8;

CMD_INITGAMESCHEDULE =10;

CMD_UPDATEGAMETOURNEY = 20;
CMD_UPDATEMODALTOURNEY = 21;
CMD_UPDATETOURNEYPUSH = 22;
CMD_UPDATETOURNEYRESETTURNNUM = 23;
CMD_UPDATETOURNEYRESTORETURNNUM = 24;

CMD_GROUPORDER_POPUP = 25;
CMD_SELTEAMTEMP = 26;

CMD_INPUTTOURNEYTEAM = 27;
CMD_DELETETOURNEYTEAM = 28;
CMD_TEAMTEMPCOMPLETE = 29;
CMD_UPDATESTADIUMSTATUS = 30;

CMD_ADD_OPENNING_TIME = 101;              // 개회식 시간을 추가한다. 
CMD_DEL_OPENNING_TIME = 102;              // 개회식 시간을 제거한다. 


CMD_SAVESTADIUMNUM = 103;



////////////명령어////////////

////////////Ajax Receive////////////
//$("#divGameScheduleScroll").scroll(function () { var scrollValue = $(document).scrollTop(); console.log(scrollValue); });
//$(window).scroll(function () { var scrollValue = $(document).scrollTop(); console.log(scrollValue); });


function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    
      case CMD_SEARCHGAMELEVEL: {
        
        $('#divGameLevelList').html(htmldata); 
        mx.ResetGameTourney();
        //버튼에 대한 이벤트 
        //SetKeyUpDown();
        $("#"+mx.GameLevelIdx).css('background-color','#81bcff');
      } break;

      //단체전구성 팝업
      case CMD_GROUPORDER_POPUP:
      if(dataType == "html")
      {
          
          //$('#DP_GroupOrder_Popup').html(htmldata); 
          $('#DP_GroupOrder_Popup').html(htmldata); 

          selTeamTemp(jsondata.tGameLevelDtlIDX, jsondata.tTeamGameNum);
      }
      break;    


      case CMD_SEARCHTOURNEY:{
        $('#divGameTourney').html(htmldata); 
      } break;

      case CMD_SEARCHSCHDEULE:{
        mx.ResetGameTourney();
        $('#divGameSchedule').html(htmldata); 
        OnGameUseCourt();
      } break;
      
      case CMD_SEARCHUSECOURT : {
        $('#divGameBoard').html(htmldata); 
        namedisplay();

      } break;

      case CMD_SEARCHSTADIUMGAMEDAY : {
        $('#divStadiumGameDay').html(htmldata); 
      } break;

      case CMD_INITGAMESCHEDULE : {
        $('#divGameSchedule').html(htmldata); 
      } break;

      case CMD_UPDATEGAMETOURNEY :{
        //mx.OnGameScheduleSearch(jsondata.tObjectGameLevelDtlIDX, jsondata.tObjectTeamGameNum, jsondata.tObjectGameNum);
        OnGameScheduleSearch(jsondata.tObjectGameLevelDtlIDX, jsondata.tObjectTeamGameNum, jsondata.tObjectGameNum, jsondata.int_scroll);
        mx.ResetGameTourney();
        OnGameTourenySearch();
        OnGameLevelSearch();
      } break;

      case CMD_SAVESTADIUMNUM :{
        //mx.OnGameScheduleSearch(jsondata.tObjectGameLevelDtlIDX, jsondata.tObjectTeamGameNum, jsondata.tObjectGameNum);
        OnGameScheduleSearch();
      } break;      

      case CMD_UPDATESTADIUMSTATUS :{
        //mx.OnGameScheduleSearch(jsondata.tObjectGameLevelDtlIDX, jsondata.tObjectTeamGameNum, jsondata.tObjectGameNum);
        OnGameUseCourt();
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
      case CMD_DELETETOURNEYTEAM:
      if(dataType == "json")
      {
  
        popup_GameOrder_Group(jsondata.tGameLevelDtlIDX, jsondata.tTeamGameNum, '0')
       
          
      }
      break;     
      case CMD_TEAMTEMPCOMPLETE:
      if(dataType == "json")
      {  
        alert("단체전 오더 등록이 완료되었습니다.");
  
        $(".group-order").modal("hide");
  
        OnSearchClick();
      }break;      
      
      case CMD_SELTEAMTEMP:
      if(dataType == "html")
      {
          $("#DP_GroupPlayerList").html(htmldata);
      }break;       

      case CMD_INPUTTOURNEYTEAM:
      if(dataType == "json")
      {
  
        if(jsondata.result == "1"){
          alert("이미 선수가 배치되어 있습니다. 해당선수를 재배치하시려면 삭제 후, 배치하시기 바랍니다.");
        }
        popup_GameOrder_Group(jsondata.tGameLevelDtlIDX, jsondata.tTeamGameNum, '0')
       
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
  Url ="/Ajax/GameNumber/SettingGameOrder_SearchGameLevel_Board.asp";
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
    Url = "/Main/GameNumber/Print_SettingGameOrder_board.asp?" 
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
    Url = "/Main/GameNumber/Print_SettingGameOrderList_board.asp?" 
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
    Url = "/Main/GameNumber/Print_SettingStadiumList_board.asp?" 
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
  Url ="/Ajax/GameNumber/SearchTourney_board.asp";
  packet.CMD = CMD_SEARCHTOURNEY;
  if(mx.GameLevelIdx != "")
  {
    packet.tGameTitleIDX = mx.GameTitleIdx;
    packet.tGameLevelIdx = mx.GameLevelIdx;
    SendPacket(Url, packet);
  }
};




//경기진행현황 리스트
function popup_GameOrder_Group(gameleveldtlidx, teamgamenum, gamenum){

  
var packet = {};

GameLevelDtlIDX = gameleveldtlidx;
TeamGameNum = teamgamenum;
GameNum = gamenum;

Url = "/Ajax/GameTitleMenu/Popup_GameOrderGroup.asp"

packet.CMD = CMD_GROUPORDER_POPUP;
packet.tGameLevelDtlIDX = GameLevelDtlIDX;
packet.tTeamGameNum = TeamGameNum;
packet.tGameNum = GameNum;

SendPacket(Url, packet);

};    

function selTeamTemp(gameleveldtlidx, teamgamenum){

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
 
  Url = "/Ajax/GameTitleMenu/selTourneyTeamTemp.asp"

  packet.CMD = CMD_SELTEAMTEMP;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;

  SendPacket(Url, packet);

};



var timerId = null;
const con_seconds = "11";
var seconds = "11";

function OnGameScheduleSearch(scrl_dtlidx, scrl_teamgamenum, scrl_gamenum, scrl_scrollnum) {


  console.log("+++++++++++++++++++scrl_dtlidx" + scrl_dtlidx);
  console.log("+++++++++++++++++++scrl_teamgamenum" + scrl_teamgamenum);
  console.log("+++++++++++++++++++scrl_gamenum" + scrl_gamenum);
  console.log("+++++++++++++++++++scrl_scrollnum" + scrl_scrollnum);
  
  var packet = {};
  selStadiumIDX = $("#selStadiumIDX").val(); 
  selGameDay = $("#selGameDay").val(); 
  UseCourtCnt = $("#UseCourtCnt").val(); 

  if(selStadiumIDX == "")  {
    alert("경기장소를 선택해주세요.")
    return;
  }

  if(selGameDay == "") {
    alert("경기일짜를 선택해주세요.")
    return;
  }

  var regNumber = /^[0-9]*$/;

  if (UseCourtCnt != "") {
      if (!regNumber.test(UseCourtCnt)) {
          alert('숫자만 입력해주세요.');
          return;
      }
  }

  $("#URLCopy").css("display","");

  clearInterval(timerId);

  seconds = con_seconds;

  var int_scroll = "";
  console.log("조회int_scroll:" + int_scroll);

  /* 인터벌*/
  
  timerId = setInterval(function() {

    seconds = parseInt(seconds);
    
    --seconds;

    console.log(String(seconds) + "초 후, 갱신");
   
    $('#second_countdown').html(String(seconds) + "초 후, 갱신");
    seconds = seconds;
  
    if(seconds < 1){
  
       int_scroll = $("#divGameScheduleScroll").scrollTop();
       //clearInterval(interval);
       OnGameScheduleSearch("", "", "", int_scroll);
       seconds = 10;
    }
  }, 1000);
  


  mx.StadiumIdx = selStadiumIDX;
  mx.GameDay = selGameDay;

  var GameStatus = $("#selGameStatus").val()

  if(GameStatus == "A"){
    Url ="/Ajax/GameNumber/SearchGameSchedule_Board_GameEnd.asp";
  }
  else{
    Url ="/Ajax/GameNumber/SearchGameSchedule_Board_test.asp";
  }

  
  //암호화해야하는 URL
  //Url ="/Ajax/GameNumber/SearchGameSchedule_Board.asp";
  packet.CMD = CMD_SEARCHSCHDEULE;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = selStadiumIDX;
  packet.tGameDay = selGameDay;

  packet.scrl_dtlidx = scrl_dtlidx;
  packet.scrl_teamgamenum = scrl_teamgamenum;
  packet.scrl_gamenum = scrl_gamenum;  
  packet.scrl_scrollnum = scrl_scrollnum;  
  
  SendPacket(Url, packet);
};

function copy_to_clipboard(){
  var GameTitleIdx = mx.dec_GameTitleIdx;
  var StadiumIDX = $("#selStadiumIDX").find("option:selected").data("id");
  var GameDay = $("#selGameDay").val();

  if(GameTitleIdx == ""){
    alert("대회를 선택해주세요");
  }
  if(StadiumIDX == ""){
    alert("경기장을 선택해주세요");
  }
  if(GameDay == ""){
    alert("대회일자를 선택해주세요");
  }    

  $("#hiddenURL").val("http://dev.koreabadminton.org/ScoreBoardElite/scoreboard_view_elite_new.asp?Gametitleidx=" + GameTitleIdx + "&GameDay="+ GameDay + "&stadiumIDX=" + StadiumIDX);

  var copyText = document.getElementById("hiddenURL");
  copyText.select();
  document.execCommand("Copy");
  //document.execCommand("http://dev.koreabadminton.org/ScoreBoardElite/scoreboard_view_elite_new.asp?Gametitleidx=" + GameTitleIdx + "&GameDay"+ GameDay + "&stadiumIDX=" + StadiumIDX);
  alert("클립보드 복사 완료");
  return;
}

function OnGameUseCourt() {

  var packet = {};
  selStadiumIDX = $("#selStadiumIDX").val(); 
  selGameDay = $("#selGameDay").val(); 
  UseCourtCnt = $("#UseCourtCnt").val(); 

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
  Url ="/Ajax/GameNumber/SearchUseCourt.asp";
  packet.CMD = CMD_SEARCHUSECOURT;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = selStadiumIDX;
  packet.tGameDay = selGameDay;
  packet.tUseCourtCnt = UseCourtCnt;  
  SendPacket(Url, packet);
};

function SaveStatiumNum() {

  var packet = {};
  selStadiumIDX = $("#selStadiumIDX").val(); 
  selGameDay = $("#selGameDay").val(); 
  UseCourtCnt = $("#UseCourtCnt").val(); 

  if(selStadiumIDX == "")  {
    alert("경기장소를 선택해주세요.")
    return;
  }

  if(selGameDay == "") {
    alert("경기일짜를 선택해주세요.")
    return;
  }

  if(UseCourtCnt == "") {
    alert("사용하실 코트갯수를 입력하세요.")
    return;
  }  

  
  mx.StadiumIdx = selStadiumIDX;
  mx.GameDay = selGameDay;

  
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/StadiumNum_Modify.asp";
  packet.CMD = CMD_SAVESTADIUMNUM;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = selStadiumIDX;
  packet.tGameDay = selGameDay;
  packet.tUseCourtCnt = UseCourtCnt;  
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

  clearInterval(timerId);
  $('#second_countdown').html("");

  //종별 검색
  OnGameLevelSearch();
  OnStadiumChanged();
};

function aaaaaa(){

  $("#aaa123").focus();
 
}

function BoardControl(){

  selStadiumIDX = $("#selStadiumIDX").val(); 
  selGameDay = $("#selGameDay").val();   

  if(mx.GameTitleIdx == ""){
    alert("대회를 선택하시기 바랍니다.");
    return;
  }

  if(selStadiumIDX == ""){
    alert("경기장을 선택하시기 바랍니다.");
    return;
  }  

  if(selGameDay == ""){
    alert("경기일자를 선택하시기 바랍니다.");
    return;
  }  


  var popWidth = 400; // 팝업창 넓이
  var popHeight = 400; // 팝업창 높이
  var winWidth = document.body.clientWidth; // 현재창 넓이
  var winHeight = document.body.clientHeight; // 현재창 높이
  var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
  var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표
  var popLeftPos = (winX + (winWidth - popWidth) / 2); // 팝업 x 가운데
  var popTopPos = (winY + (winHeight - popHeight) / 2)-100; // 팝업 y 가운데


  urltext = { 'GameTitleIdx': mx.GameTitleIdx, 'StadiumIdx' : selStadiumIDX, 'GameDay' : selGameDay};
  var popUrl = "../GameTitleMenu/GameStadiumBoard_Board.asp"; //팝업창에 출력될 페이지 URL
  var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
  window.open(popUrl,"JoResult",popOption);
  post_to_url_popup('JoResult', './' + "../GameTitleMenu/GameStadiumBoard_Board.asp", urltext);  
}


function OnStadiumChanged(load=false) {
  selStadiumIDX = $("#selStadiumIDX").val(); 
  selGameDay = $("#selGameDay").val(); 

  var packet = {};
  
  Url ="/Ajax/GameNumber/SearchGameDayOfStadium_Board.asp";
  packet.CMD = CMD_SEARCHSTADIUMGAMEDAY;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = selStadiumIDX;
  packet.tGameDay = selGameDay;
  packet.load = load;
  SendPacket(Url, packet);
};

function onchange_stadiumoff(str_gubun, str_gametitleidx, str_gameday, str_stadiumidx, str_stadiumnum){

  Url = "/Ajax/GameTitleMenu/StadiumStastus_Update.asp"
  var packet = {};

  if(str_gubun == "" || str_gametitleidx == "" || str_gameday == "" || str_stadiumidx == "" || str_stadiumnum == "" ){
    alert('잘못된 접근 입니다. 관리자에게 문의바랍니다.');
    return;
  }

  if(str_gubun == "Y"){
    str_msg = "미노출";
  }
  else{
    str_msg = "노출";
  }

  var con_bool = confirm("해당 경기장을 " + str_msg + "상태로 변경합니다. 동의하시면 확인 버튼을 눌러주세요.");

  if(con_bool == false){
    return;
  }

  packet.CMD = CMD_UPDATESTADIUMSTATUS;
  packet.tGuBun = str_gubun;
  packet.tGameTitleIdx = str_gametitleidx;
  packet.tGameDay  = str_gameday;
  packet.tStadiumIDX  = str_stadiumidx;
  packet.tStadiumNum = str_stadiumnum;
  SendPacket(Url, packet);

}

function UpdateModalTourney(gameLevelDtlIdx, teamGameNum, gameNum, groupGameGb){ 
  var selGameTime = $("#selGameTime").val(); 
  var selGameDay = $("#txt_selGameDay").val(); 

  var packet = {};
  Url ="/Ajax/GameNumber/SettingGameOrder_UpdateModalToruney_Board.asp";
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
  Url ="/Ajax/GameNumber/SettingGameOrder_UpdateResetTourneyTurnNum_Board.asp";
  packet.CMD = CMD_UPDATETOURNEYRESETTURNNUM;
  packet.tGameLevelDtlIdx = gameLevelDtlIdx;
  packet.tTeamGameNum = teamGameNum;
  packet.tGameNum = gameNum;
  packet.tGroupGameGb = groupGameGb;
  SendPacket(Url, packet);

};

function UpdateRestoreTourneyTurnNum(gameLevelDtlIdx, teamGameNum, gameNum, groupGameGb, stadiumIdx,stadiumNum, turnNum){ 
  var packet = {};
  Url ="/Ajax/GameNumber/SettingGameOrder_UpdateRestoreResetTourneyTurnNum_Board.asp";
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
    Url ="/Ajax/GameNumber/SettingGameOrder_UpdateTourneyPush_Board.asp";
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
  Url ="/Ajax/GameNumber/initGameSchedule_Board.asp";
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
    var rgb = $(this).css('background-color');
    var colorcode;

    if (!rgb) {
        return '#FFFFFF'; //default color
    }
    var hex_rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/); 
    function hex(x) {return ("0" + parseInt(x).toString(16)).slice(-2);}
    if (hex_rgb) {
      colorcode = "#" + hex(hex_rgb[1]) + hex(hex_rgb[2]) + hex(hex_rgb[3]);
    } else {
      colorcode = rgb; //ie8 returns background-color in hex format then it will make                 compatible, you can improve it checking if format is in hexadecimal
    }
    

    if(colorcode != "#808080" && colorcode != "#86e57f"){
      //$(this).children('th').css('background-color','#white');
      $(this).css( "background-color", "white" );
    }
  });
};

$.fn.resetTDColor = function() {
  $(this).find('td').each(function() { 
   
    var rgb = $(this).css('background-color');
    var colorcode;

    if (!rgb) {
        return '#FFFFFF'; //default color
    }
    var hex_rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/); 
    function hex(x) {return ("0" + parseInt(x).toString(16)).slice(-2);}
    if (hex_rgb) {
      colorcode = "#" + hex(hex_rgb[1]) + hex(hex_rgb[2]) + hex(hex_rgb[3]);
    } else {
      colorcode = rgb; //ie8 returns background-color in hex format then it will make                 compatible, you can improve it checking if format is in hexadecimal
    }
   

    if(colorcode != "#808080" && colorcode != "#86e57f"){
      //$(this).children('th').css('background-color','#white');
      $(this).css( "background-color", $(this).data("color") );

    }
      
  });
};

$.fn.getHexBackgroundColor = function() {
  var rgb = $(this).css('background-color');
  if (!rgb) {
      return '#FFFFFF'; //default color
  }
  var hex_rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/); 
  function hex(x) {return ("0" + parseInt(x).toString(16)).slice(-2);}
  if (hex_rgb) {
      return "#" + hex(hex_rgb[1]) + hex(hex_rgb[2]) + hex(hex_rgb[3]);
  } else {
      return rgb; //ie8 returns background-color in hex format then it will make                 compatible, you can improve it checking if format is in hexadecimal
  }
}

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
    //OnGameScheduleSearch();
  }

  if (mx.GameTitleIdx != ""){
  //OnGameLevelSearch();
  }
};

function autoGameSchedule(){
  
  if(mx.GameTitleIdx == "")  {
    alert("상단의 대회를 선택해주세요.")
    return;
  }

  popupOpen("autoGameSchedule1_Board.asp")

};

function initSettingData(){
  if(mx.GameTitleIdx == "") {
    mx.GameTitleIdx = $("#selGameTitleIdx").val(); 
    mx.dec_GameTitleIdx = $("#selGameTitleIdx").data("id"); 
  }
};

function OpenPopUpScheduleGame(GameTitleIdx,StadiumIdx,GameLevelDtlIdx, TeamGameNum, GameNum, GroupGameGb, GameDay) {
   Url ="/Ajax/GameNumber/SettingGameOrder_SelectScheduleGame_Board.asp";
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

   
  $(document).on("click", "#tableGameBoard tbody tr td", function() {
    

    console.log("선택한경기 배치");

    var bd_GameTitleIDX = $(this).find("#Bd_GameTitleIDX").val();
    var bd_GameLevelDtlIDX = $(this).find("#Bd_GameLevelDtlIDX").val();
    var bd_TeamGameNum = $(this).find("#Bd_TeamGameNum").val();
    var bd_GameNum = $(this).find("#Bd_GameNum").val();
    var bd_CourtNum = $(this).find("#Bd_CourtNum").val();
    var bd_TempNum = $(this).find("#Bd_TempNum").val();
    var bd_GameDay = $(this).find("#Bd_GameDay").val();
    var bd_StadiumIDX = $(this).find("#Bd_StadiumIDX").val();

    console.log(mx.GameMethod);
    
    
    var int_scroll = $("#divGameScheduleScroll").scrollTop();

    //console.log("바꿀 위치 stadiumIdx : " + stadiumIdx + " gameDay : " + gameDay + "gameCourt :" + gameCourt + ", gameOrder : " + gameOrder)
    //암호화해야하는 URL
    Url ="/Ajax/GameNumber/updateGameSchedule_Board.asp";
    var packet = {};
    packet.CMD = CMD_UPDATEGAMETOURNEY;

   
    packet.tObjectGameLevelDtlIDX = mx.GameLevelDtlIDX;
    packet.tObjectTeamGameNum = mx.TeamGameNum;
    packet.tObjectGameNum = mx.GameNum;
    packet.tObjectGroupGameGb = mx.GroupGameGb;
    packet.tObjectGameTime = mx.GameTime;
    packet.tObjectGameDay = mx.GameDay;
    packet.tObjectStadiumIDX = mx.StadiumIDX;
   
    packet.tOtherGameTitleIDX = bd_GameTitleIDX;
    packet.tOtherGameLevelDtlIDX = bd_GameLevelDtlIDX;
    packet.tOtherTeamGameNum = bd_TeamGameNum;
    packet.tOtherGameNum = bd_GameNum;
    packet.tOtherCourtNum = bd_CourtNum;
    packet.tOtherTempNum = bd_TempNum;
    packet.tOtherGameDay = bd_GameDay;
    packet.tOtherStadiumIDX = bd_StadiumIDX;

    packet.int_scroll = int_scroll;



    console.log("tObjectGameLevelDtlIDX:" + packet.tObjectGameLevelDtlIDX);
    console.log("tObjectTeamGameNum:" + packet.tObjectTeamGameNum);
    console.log("tObjectGameNum:" + packet.tObjectGameNum);
    console.log("tObjectGroupGameGb:" + packet.tObjectGroupGameGb);
    console.log("tObjectGameTime:" + packet.tObjectGameTime);

    console.log("tOtherGameTitleIDX:" + packet.tOtherGameTitleIDX);
    console.log("tOtherGameLevelDtlIDX:" + packet.tOtherGameLevelDtlIDX);
    console.log("tOtherTeamGameNum:" + packet.tOtherTeamGameNum);
    console.log("tOtherGameNum:" + packet.tOtherGameNum);
    console.log("tOtherCourtNum:" + packet.tOtherCourtNum);
    console.log("tOtherTempNum:" + packet.tOtherTempNum);

    if(mx.GameLevelDtlIDX == "" && bd_GameLevelDtlIDX == ""){
      return;      
    }


    if(mx.GameLevelDtlIDX == ""){
      var strbool = confirm("해당 경기를 배정된 전광판리스트에서 삭제합니다. 동의하시면 확인버튼을 눌러주세요.");

      if(strbool == false){
        return;
      }
    }

    

    SendPacket(Url, packet);    
  });
  

  // 게임 테이블 Row 선택 Click 이벤트
  $(document).on("click", "#tableGameSchedule tbody tr td", function() {
    //some think

    console.log("옮길경기선택");
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
      var gameStatus = $(this).find("#hiddenGameStatus").val();
      var gameSelectYN = $(this).find("#hiddenSelectYN").val();
      
      if(gameStatus == "GameEnd"){
        alert("종료된 경기는 선택이 불가능합니다.");
        return;
      }

      if(gameSelectYN == "N"){
        alert("상대선수가 결정되지 않은 경기는 선택이 불가능합니다.");
        return;        
      }

      if ((mx.GameLevelDtlIDX != gameLevelDtlIdx) || (mx.GameNum !=  gameGameNum) || (mx.TeamGameNum != gameTeamGameNum) || (mx.GroupGameGb != gameGroupGb))
      {
       
        $('#tableToureny').resetColor();
        $('#tableGameSchedule').resetTDColor();
        $(this).css('background-color','#EDED01');
        mx.GameLevelDtlIDX = gameLevelDtlIdx
        mx.TeamGameNum =gameTeamGameNum
        mx.GameNum= gameGameNum
        mx.GroupGameGb = gameGroupGb;
        mx.GameMethod = changeMethod;
        mx.GameTime = gameTime;
        mx.GameDay = gameDay;
        mx.StadiumIDX = stadiumIdx;
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

function OnWaitPlayerClick(reqplayeridx, loopnum){

  //선택시 hidden에 담음
  $("#SelectReqPlayerIDX").val(reqplayeridx);  

 
  for(i=0;i<=$("[name='TR_Btn_Player']").length;i++){
    $("[name='TR_Btn_Player']").eq(i).css("background-color","#ffffff");
  }

  
  $("#TR_Btn_Player" + loopnum).css("background-color","yellow");

};


function OnWaitDeleteClick(gameleveldtlidx, teamgamenum, gamenum ,reqplayeridx){
  Url = "/Ajax/GameTitleMenu/delTourneyTeamTemp.asp"
  var packet = {};
  packet.CMD = CMD_DELETETOURNEYTEAM;
  packet.tGameLevelDtlIDX = gameleveldtlidx;
  packet.tGameNum = gamenum;
  packet.tTeamGameNum = teamgamenum;
  packet.tReqPlayerIDX = reqplayeridx;

  if(confirm("해당 선수를 삭제하시겠습니까?"))
  {
    SendPacket(Url, packet);  
  }
};


function OnEmptyAreaClick(gameleveldtlidx, teamgamenum, gamenum, orderby){

  if($("#SelectReqPlayerIDX").val() == ""){
    alert("배치할 선수를 선택하세요.");
    return;
  }

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;
  OrderBy = orderby;
  ReqPlayerIDX = $("#SelectReqPlayerIDX").val();  
 
  Url = "/Ajax/GameTitleMenu/inputTourneyTeamTemp.asp"

  packet.CMD = CMD_INPUTTOURNEYTEAM;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tGameNum = GameNum;
  packet.tOrderBy = OrderBy;
  packet.tReqPlayerIDX = ReqPlayerIDX;

  SendPacket(Url, packet);

};


function OnTeamTempCompleteClick(gameleveldtlidx, teamgamenum){

  var con_test = confirm("단체전 오더 등록 시, 기존 등록된 기록이 삭제됩니다. 동의하시면 확인버튼을 눌러주세요.");

  if(con_test == false){
    return;
  }      


  GameTitleIDX = $("#selGameTitleIdx").val();
  GameDay = $("#selGameDay").val();

  var LPlayerA_length = $("input[name=LPlayerA]").length;
  var LPlayerB_length = $("input[name=LPlayerB]").length;
  var RPlayerA_length = $("input[name=RPlayerA]").length;
  var RPlayerB_length = $("input[name=RPlayerB]").length;
  
  var str_LPlayerA = ""
  var str_LPlayerB = ""
  var str_RPlayerA = ""
  var str_RPlayerB = ""

  for (i = 0; i < LPlayerA_length; i++) {
    if(i == 0){
      str_LPlayerA = $("input[name='LPlayerA']").eq(i).val();
    }
    else{
      str_LPlayerA += "," + $("input[name='LPlayerA']").eq(i).val();
    }
  }

  for (i = 0; i < LPlayerB_length; i++) {
    if(i == 0){
      str_LPlayerB = $("input[name='LPlayerB']").eq(i).val();
    }
    else{
      str_LPlayerB += "," + $("input[name='LPlayerB']").eq(i).val();
    }
  }

  for (i = 0; i < RPlayerA_length; i++) {
    if(i == 0){
      str_RPlayerA = $("input[name='RPlayerA']").eq(i).val();
    }
    else{
      str_RPlayerA += "," + $("input[name='RPlayerA']").eq(i).val();
    }
  }
  
  for (i = 0; i < RPlayerB_length; i++) {
    if(i == 0){
      str_RPlayerB = $("input[name='RPlayerB']").eq(i).val();
    }
    else{
      str_RPlayerB += "," + $("input[name='RPlayerB']").eq(i).val();
    }
  }  

  console.log("str_LPlayerA:" + str_LPlayerA);
  console.log("str_LPlayerB:" + str_LPlayerB);
  console.log("str_RPlayerA:" + str_RPlayerA);
  console.log("str_RPlayerB:" + str_RPlayerB);


  Url = "/Ajax/GameTitleMenu/inputTourneyTeam.asp"

  var packet = {};

  packet.CMD = CMD_TEAMTEMPCOMPLETE;
  packet.tGameLevelDtlIDX = gameleveldtlidx;
  packet.tTeamGameNum = teamgamenum;
  packet.tstr_LPlayerA = str_LPlayerA;
  packet.tstr_LPlayerB = str_LPlayerB;
  packet.tstr_RPlayerA = str_RPlayerA;
  packet.tstr_RPlayerB = str_RPlayerB;



  SendPacket(Url, packet);
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
          mx.dec_GameTitleIdx = obj.tIdx;
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
