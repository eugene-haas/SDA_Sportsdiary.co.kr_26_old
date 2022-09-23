mx = {};


/* 빈값 */
mx.empty = "empty"
/* 빈값 */

/* 대회 */
mx.GameTitleIdx = "";
mx.GameTitleIdxName = "";
/* 대회 */

/* 구분 */
mx.GroupGameGb = mx.empty;
mx.GroupGameGbName = "";
/* 구분 */

/* 종목 */
mx.TeamGb = mx.empty;
mx.TeamGbName = "";
/* 종목 */

/* 그룹 */
mx.LevelJoo = mx.empty;
mx.LevelJooName = "";
/* 그룹 */

/* 그룹 번호 */
mx.LevelJooNum = mx.empty;
/* 그룹 번호 */


/* 종별 */
mx.Level = mx.empty;
mx.LevelName = "";
/* 종별 */

/* 경기구분 */
mx.PlayLevelType = mx.empty;
mx.PlayLevelTypeName = "";
/* 경기구분 */

/* 코트여부 */
mx.StartCourt = "";
mx.EndCourt = "";
/* 코트여부 */

/* Stadium */
mx.InsertStadiumIdx = ""
mx.StadiumIdx = ""
mx.StadiumIdxName = "";
/* Stadium */

/* Stadium */
mx.GameDay = ""
/* Stadium */

/* 종목구분 */
mx.Sex= mx.empty;
mx.SexName= ""
mx.PlayType= mx.empty;
mx.PlayTypeName= ""
/* 종목구분 */

/* Delete Schedules */
mx.DeleteSchedules = ""
/* Delete Schedules */

mx.ResetAll = function (){
  mx.GroupGameGb = mx.empty;
  mx.GroupGameGbName = "";

  mx.TeamGb = mx.empty;
  mx.TeamGbName = "";

  mx.Sex = mx.empty;
  mx.SexName = "";

  mx.PlayType = mx.empty;
  mx.PlayTypeName = "";

  mx.LevelJoo = mx.empty;
  mx.LevelJooName = "";

  mx.Level = mx.empty;
  mx.LevelName = "";

  mx.PlayLevelType = mx.empty;
  mx.PlayLevelTypeName = "";
};



mx.ResetGroupGameChanged = function (){
  mx.TeamGb = mx.empty;
  mx.TeamGbName = "";

  mx.Sex = mx.empty;
  mx.SexName = "";

  mx.PlayType = mx.empty;
  mx.PlayTypeName = "";

  mx.LevelJoo = mx.empty;
  mx.LevelJooName = "";

  mx.Level = mx.empty;
  mx.LevelName = "";

  mx.PlayLevelType = mx.empty;
  mx.PlayLevelTypeName = "";

};


mx.ResetTeamGbChanged = function (){

  mx.Sex = mx.empty;
  mx.SexName = "";

  mx.PlayType = mx.empty;
  mx.PlayTypeName = "";

  mx.LevelJoo = mx.empty;
  mx.LevelJooName = "";

  mx.Level = mx.empty;
  mx.LevelName = "";

  mx.PlayLevelType = mx.empty;
  mx.PlayLevelTypeName = "";

  mx.Sex = mx.empty;
  mx.SexName = "";

 
};


mx.ResetSexPlayTypeChanged = function (){
  mx.LevelJoo = mx.empty;
  mx.LevelJooName = "";

  mx.Level = mx.empty;
  mx.LevelName = "";

  mx.PlayLevelType = mx.empty;
  mx.PlayLevelTypeName = "";
};


mx.ResetLevelJooNameChanged = function (){
  mx.PlayLevelType = mx.empty;
  mx.PlayLevelTypeName = "";
};


mx.ResetLevelChanged = function (){

  mx.LevelJoo = mx.empty;
  mx.LevelJooName = "";

  mx.PlayLevelType = mx.empty;
  mx.PlayLevelTypeName = "";
};



////////////명령어////////////
CMD_SEARCHGAMETITLE = 1;
CMD_SEARCHGAMELEVEL = 2;
CMD_SEARCHGAMELEVELDTL = 3;
CMD_SEARCHGAMEINFO = 4;
CMD_SEARCHGAMESCHEDULESTADIUM = 5;
CMD_SELECTGAMELEVELINFO = 6;
CMD_SELECTGAMESTADIUM = 7;
CMD_SELECTSTADIUMCOURT = 8;

CMD_SETGAMESCHEDULESTADIUM = 10;
CMD_RESTOREGAMESCHEDULE = 11;
CMD_UPDATEGAMEORDER = 12; 
CMD_UPDATEGROUPGAMEORDER = 13;
CMD_AUTOGAMESCHEDULE = 14;
CMD_UPDATEGAMESCHEDULETIME = 15;
CMD_UPDATESTADIUMCOURT = 16;
CMD_UPDATESCHEDULEGAMEORDER = 17;

CMD_DELETEGAMESCHEDULE = 20;
////////////명령어////////////

////////////Ajax Receive////////////

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
      case CMD_SEARCHGAMELEVEL: {
        initSearchControl();
        $('#divGameLevelList').html(htmldata); 
        SelectGameLevelInfo();
      } break;

      case CMD_SEARCHGAMELEVELDTL : {
        $('#divGameLevelDtlList').html(htmldata); 
      } break;

      case  CMD_SEARCHGAMEINFO : {
        if(dataType =="json")
        {
          $('#ApplyGameCnt').text(jsondata.TourneyNumber); 
          $('#TotalGameCnt').text(jsondata.TouneyTotalCnt); 
          $('#GamePercent').text(jsondata.TourneyPercent + "%"); 
        }
      } break; 
      
      case CMD_SELECTGAMELEVELINFO : {
        if(dataType =="json")
        {
          $('#selGameCnt').text(jsondata.TourneyCnt); 
        }
      }break;

      case CMD_SETGAMESCHEDULESTADIUM : {
        
        if(dataType =="json") {
          console.log("CMD_SETGAMESCHEDULESTADIUM:" + jsondata.result)
          
          if(jsondata.result == "0")
          {
            alert("정상적으로 등록되었습니다.")
          }
          else if(jsondata.result == "1")
          {
            alert("데이터가 이미 등록되어있습니다.")
          }
          SearchGameScheduleStadium();
          OnGameLevelSearch();
        }
      }break;
      case CMD_SEARCHGAMESCHEDULESTADIUM :{
        $('#divGameScheduleStadium').html(htmldata); 

        //여기
        SelectSchedule();
      } break;
      case CMD_SELECTGAMESTADIUM : {
        $('#divAutoGameSchedule').html(htmldata); 
        $(".time_ipt").timepicker(
          {
            timeFormat: 'HH:mm',
            interval: 60,
            minTime: '7',
            maxTime: '06:00pm',
            startTime: '07:00',
            dynamic: false,
            dropdown: true,
            scrollbar: true,
            change : function(time){
              selgameTime = $('#selGameTime').val();
              var packet = {};
              Url ="/Ajax/GameNumber/AutoSchedule_updateGameScheduleTime.asp";
              packet.CMD = CMD_UPDATEGAMESCHEDULETIME;
              packet.tGameTitleIDX = mx.GameTitleIdx;
              packet.tStadiumIDX = mx.StadiumIdx;
              packet.tGameDay = mx.GameDay;
              packet.tGameTime = selgameTime;
              SendPacket(Url, packet);
            }
          }
        );
        //OnScheduleTimeChanged();

      } break;

      case CMD_DELETEGAMESCHEDULE : {
        SearchGameScheduleStadium();
        SelectSchedule();
        OnGameLevelSearch();
      }break;
      case CMD_RESTOREGAMESCHEDULE : {
        SearchGameScheduleStadium();
        SelectSchedule();
        OnGameLevelSearch();
      }break;
      case CMD_AUTOGAMESCHEDULE : {
        if(dataType =="json") {
          if(jsondata.result == 0) {
            if(confirm("적용 완료되었습니다. 진행순서를 보시겠습니까?"))
            {
              GameScheduleView();
            }
          }
        }
      }break;
      case CMD_UPDATEGAMESCHEDULETIME :{
        if(dataType =="json") {
          if(jsondata.result == 0) {
          }
        }
      }break;
      case CMD_SELECTSTADIUMCOURT :{
        if(dataType =="html") {
          $('#scheduleCourtModalBody').html(htmldata); 
          $('#modalTeamGB').html(jsondata.tTeamGb);
          $('#modalSubTitle').html(jsondata.tSubTitle);
        }
      }break;

      case CMD_UPDATESTADIUMCOURT : {
        if(dataType =="json") {
          if(jsondata.result == 0) {
            SearchGameScheduleStadium();
            $("#scheduleCourtModal").modal("hide");
          }
          else{
            alert("업데이트 실패 관리자에게 문의하세요.")
          }
        }
      }break;
      case CMD_UPDATESCHEDULEGAMEORDER : {
        if(dataType =="json") {
          if(jsondata.result == 0) {
            alert("적용 완료");
            SelectSchedule();
          }
          else{
            alert("적용 실패");
          }
        }

      }break;
      default:{
      } break;
    }
};

function OnGameTitleSearch()
{
  OnGameLevelSearch();
  OnGameInfoSearch();
  SearchGameScheduleStadium();
};


function SelectSchedule(){
  if(mx.StadiumIdx == "")
    return;

  var packet = {};
  mx.GameDay = $("#initDatePicker").val();
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SelectGameSchedule.asp";
  packet.CMD = CMD_SELECTGAMESTADIUM;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = mx.StadiumIdx;
  packet.tStadiumName = mx.StadiumIdxName;
  packet.tGameDay = mx.GameDay;
  SendPacket(Url, packet);
};


function SetGameScheduleStadium(StadiumIdx)
{
  var packet = {};
  GameDay = $("#initDatePicker").val();
  GameTime = $("#selGameTime").val();
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SetGameScheduleStadium.asp";
  packet.CMD = CMD_SETGAMESCHEDULESTADIUM;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIdx = StadiumIdx;
  packet.tGroupGameGb = mx.GroupGameGb;
  packet.tTeamGb = mx.TeamGb;
  packet.tSex = mx.Sex;
  packet.tPlayType = mx.PlayType;
  packet.tLevelJooName = mx.LevelJoo;
  packet.tLevelJooNameNum = mx.LevelJooNum;
  packet.tLevel = mx.Level;
  packet.tPlayLevelType = mx.PlayLevelType;
  packet.tGameDay = GameDay;
  packet.tGameTime = GameTime;
  packet.tStartCourt = mx.StartCourt;
  packet.tEndCourt = mx.EndCourt;
  SendPacket(Url, packet);
};


function OnGameInfoSearch()
{
  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SearchGameInfo.asp";
  packet.CMD = CMD_SEARCHGAMEINFO;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  SendPacket(Url, packet);
};


function SelectGameLevelInfo()
{
  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SelectGameLevel.asp";
  packet.CMD = CMD_SELECTGAMELEVELINFO;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tGroupGameGb = mx.GroupGameGb;
  packet.tTeamGb = mx.TeamGb;
  packet.tSex = mx.Sex;
  packet.tPlayType = mx.PlayType;
  packet.tLevelJooName = mx.LevelJoo;
  packet.tLevelJooNameNum = mx.LevelJooNum;
  packet.tLevel = mx.Level;
  packet.tPlayLevelType = mx.PlayLevelType;
  SendPacket(Url, packet);
};

function SelectGameStadium(value,name) {
  mx.StadiumIdx = value;
  mx.StadiumIdxName = name;
  SearchGameScheduleStadium();
};

function SearchGameScheduleStadium()
{
  mx.GameDay = $("#initDatePicker").val();

  var Gamedelay = $("#txt_Gamedelay").val();

  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SearchGameScheduleStadiumEx.asp";
  packet.CMD = CMD_SEARCHGAMESCHEDULESTADIUM;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = mx.StadiumIdx;
  packet.tGameDay = mx.GameDay;
  packet.tGamedelay = Gamedelay;
  SendPacket(Url, packet);
};

function OnGameLevelSearch()
{
  if (mx.GameTitleIdx =="" && mx.GameTitleIdx.length == 0 )
    return;
  var packet = {};



  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SearchGameLevel.asp";
  packet.CMD = CMD_SEARCHGAMELEVEL;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tGroupGameGb = mx.GroupGameGb;
  packet.tTeamGb = mx.TeamGb;
  packet.tSex = mx.Sex;
  packet.tPlayType = mx.PlayType;
  packet.tLevelJooName = mx.LevelJoo;
  packet.tLevelJooNameNum = mx.LevelJooNum;
  packet.tLevel = mx.Level;
  packet.tPlayLevelType = mx.PlayLevelType;
  packet.tStadiumIDX = mx.InsertStadiumIdx;
  packet.tStartCourt = mx.StartCourt;
  packet.tEndCourt = mx.EndCourt;
  
  SendPacket(Url, packet);
};

function OnGameLevelAllSearch()
{
  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SearchGameLevel.asp";
  packet.CMD = CMD_SEARCHGAMELEVEL;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  mx.ResetAll();
  SendPacket(Url, packet);
};

function SearchGameLevelDtl(){

  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SearchGameLevelDtl.asp";
  packet.CMD = CMD_SEARCHGAMELEVELDTL;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tGroupGameGb = mx.GroupGameGb;
  packet.tTeamGb = mx.TeamGb;
  packet.tLevelJooName = mx.LevelJoo;
  packet.tLevel = mx.Level;
  packet.tPlayLevelType = mx.PlayLevelType;
  SendPacket(Url, packet);
};


function deleteAutoGameSchedule() {
  mx.DeleteSchedules = "" 
  $('input[name=chkBox]').each(function() { 
    if(this.checked== true) {
      mx.DeleteSchedules = mx.DeleteSchedules + $(this).val() + "_" ; 
    }
  });

  if (mx.DeleteSchedules.length > 0  && confirm("정말로 삭제하시겠습니까?")) {
    var packet = {};
    Url ="/Ajax/GameNumber/AutoSchedule_DeleteGameSchedule.asp";
    packet.CMD = CMD_DELETEGAMESCHEDULE;
    packet.tDeleteSchedules = mx.DeleteSchedules;
    SendPacket(Url, packet);
  }
};

function updateAutoScheduleGameOrder(GameTitleIdx, StadiumIdx, GameDay){
  var packet = {};
  Url ="/Ajax/GameNumber/AutoSchedule_updateScheduleGameOrder.asp";
  packet.CMD = CMD_UPDATESCHEDULEGAMEORDER;
  packet.tGameTitleIDX = GameTitleIdx;
  packet.tStadiumIdx = StadiumIdx;
  packet.tGameDay = GameDay;
  SendPacket(Url, packet);
};

function restoreAutoGameSchedule() {
  if (mx.DeleteSchedules.length > 0  && confirm("정말로 되돌리시겠습니까?")) {
    var packet = {};
    Url ="/Ajax/GameNumber/AutoSchedule_RestoreGameSchedule.asp";
    packet.CMD = CMD_RESTOREGAMESCHEDULE;
    packet.tDeleteSchedules = mx.DeleteSchedules;
    SendPacket(Url, packet);
  }
};

function setAutoGameNumber() {

  if($("#ModifyCloseYN").val() == "Y"){
    alert('마감된 경기는 리셋이 불가합니다. 필요 시, 전산관리자에게 요청 바랍니다.');
    return;
  }

  if (confirm("[" + mx.GameTitleIdxName + "]" + " 대회에 모든 경기장 및 진행순서를 삭제하고, 설정한 자동순서로 적용하시겠습니까??")) {
  var packet = {};

  var Gamedelay = $("#txt_Gamedelay").val();

  Url ="/Ajax/GameNumber/AutoSchedule_SetAutoGameNumberEx.asp";
  packet.CMD = CMD_AUTOGAMESCHEDULE;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tGamedelay = Gamedelay;
  
  SendPacket(Url, packet);
  }
};

function setAutoGameNumber_select(str_stadiumidx, str_gameday) {

  if($("#ModifyCloseYN").val() == "Y"){
    alert('마감된 경기는 리셋이 불가합니다. 필요 시, 전산관리자에게 요청 바랍니다.');
    return;
  }

  if (confirm("※※※※※ 주의사항 ※※※※※\r\n[" + mx.GameTitleIdxName + "]" + " 대회의 선택하신 날짜의 경기장만 삭제되고, 자동순서가 적용됩니다. 동의하시면 확인버튼을 눌러주세요.")) {
  var packet = {};

  var Gamedelay = $("#txt_Gamedelay").val();

  Url ="/Ajax/GameNumber/AutoSchedule_SetAutoGameNumber_SelectEx.asp";
  packet.CMD = CMD_AUTOGAMESCHEDULE;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tGamedelay = Gamedelay;

  packet.tGameDay = str_gameday;
  packet.tStadiumIDX = str_stadiumidx;
  
  SendPacket(Url, packet);
  }
};


function onGroupGameOrderChanged(GameScheduleIDX, value){

  var packet = {};
  Url ="/Ajax/GameNumber/AutoSchedule_updateGroupGameOrder.asp";
  packet.CMD = CMD_UPDATEGROUPGAMEORDER;
  packet.tGameScheduleIDX = GameScheduleIDX;
  packet.tNumber = value;
  SendPacket(Url, packet);
};

function onGameOrderChanged(GameScheduleIDX, value){
  var packet = {};
  Url ="/Ajax/GameNumber/AutoSchedule_updateGameOrder.asp";
  packet.CMD = CMD_UPDATEGAMEORDER;
  packet.tGameScheduleIDX = GameScheduleIDX;
  packet.tNumber = value;
  SendPacket(Url, packet);
};

function OnStartCourtChanged(value)
{
  mx.StartCourt = value;
};

function OnEndCourtChanged(value)
{
  mx.EndCourt = value;
};

////////////Custom Function////////////
$(document).ready(function() {
  init();
}); 

init = function() {
  initSearchControl();
  initDate();

  
};

function initControl(){
  if($("#allCheck").prop("checked")) {
    $("input[name=chkBox]").prop("checked",true);
    } else {
    $("input[name=chkBox]").prop("checked",false);
    }
}


$(window).load(function() {
  initSettingData();
  OnGameTitleSearch();
});
  

function printLevelGame(){
  GameTitleIDX = mx.GameTitleIdx;

  if (typeof(GameTitleIDX) != "undefined" && GameTitleIDX != "")
  {

    Url = "/Main/GameNumber/Print_GameLevel.asp?" 
    + "GameTitleIDX=" + GameTitleIDX
    location.href = Url;
  }
};

function initSettingData(){
  if(mx.GameTitleIdx == "") {
    mx.GameTitleIdx = $("#selGameTitleIdx").val(); 
    mx.GameTitleIdxName = $("#strGameTtitle").val()
    $("#span_GameTitleName").text(mx.GameTitleIdxName);
    mx.GameDay = $("#initDatePicker").val();
  }
};

function OnGroupGameGbChanged (value, name){
  console.log(" GroupGameGb : "+ value);
  mx.GroupGameGb = value;
  mx.GroupGameGbName = name;
  //LevelJooName, Level, PlayLevelType
  mx.ResetGroupGameChanged();
  OnGameLevelSearch();
};

function OnTeamGbChanged (value, name){
  if(mx.GroupGameGb == mx.empty  && $("#hiddenGroupGameGbCnt").val() > 0 ) {
    alert("먼저 경기구분을 선택해주세요");
    return;
  }
  console.log(" TeamGB : "+ value);
  mx.TeamGb = value;
  mx.TeamGbName = name;
  //LevelJooName, Level, PlayLevelType
  mx.ResetTeamGbChanged();
  OnGameLevelSearch();
};

function OnSexPlayTypeChanged(Sex, SexNM, PlayType, PlayTypeNM) {

  if(mx.GroupGameGb == mx.empty  && $("#hiddenGroupGameGbCnt").val() > 0 ) {
    alert("먼저 경기구분을 선택해주세요");
    return;
  }
  
  if(mx.TeamGb == mx.empty  && $("#hiddenTeamGbCnt").val() > 0) {
    alert("종목을 선택해주세요");
    return;
  }

  mx.Sex = Sex;
  mx.SexName = SexNM;
  mx.PlayType = PlayType;
  mx.PlayTypeNM = PlayTypeNM;

  mx.ResetSexPlayTypeChanged();
  OnGameLevelSearch();
};

function OnLevelJooNameChanged(value, name, number){

  if(mx.GroupGameGb == mx.empty  && $("#hiddenGroupGameGbCnt").val() > 0 ) {
    alert("먼저 경기구분을 선택해주세요");
    return;
  }
  
  if(mx.TeamGb == mx.empty  && $("#hiddenTeamGbCnt").val() > 0) {
    alert("종목을 선택해주세요");
    return;
  }
 
  if(mx.Sex == mx.empty && mx.PlayType == mx.empty && $("#hiddenSexPlayTypeCnt").val() > 0 ) {
    alert("종목구분을 선택해주세요");
    return;
  }

  console.log(" LevelJooName : "+ value);
  mx.LevelJoo = value;
  mx.LevelJooName = name;
  mx.LevelJooNum = number;
  //LevelJooName, Level, PlayLevelType
  mx.ResetLevelJooNameChanged();
  OnGameLevelSearch();
};

function OnLevelChanged(value, name){

  if(mx.GroupGameGb == mx.empty  && $("#hiddenGroupGameGbCnt").val() > 0 ) {
    alert("먼저 경기구분을 선택해주세요");
    return;
  }
  
  if(mx.TeamGb == mx.empty  && $("#hiddenTeamGbCnt").val() > 0) {
    alert("종목을 선택해주세요");
    return;
  }
 
  if(mx.Sex == mx.empty && mx.PlayType == mx.empty && $("#hiddenSexPlayTypeCnt").val() > 0 ) {
    alert("종목구분을 선택해주세요");
    return;
  }
  console.log(" Level : "+ value);
  mx.Level = value;
  mx.LevelName = name;
   //PlayLevelType
   mx.ResetLevelChanged();
  OnGameLevelSearch();
};

function OnPlayLevelTypeChanged(value, name){

  if(mx.GroupGameGb == mx.empty  && $("#hiddenGroupGameGbCnt").val() > 0 ) {
    alert("먼저 경기구분을 선택해주세요");
    return;
  }
  
  if(mx.TeamGb == mx.empty  && $("#hiddenTeamGbCnt").val() > 0) {
    alert("종목을 선택해주세요");
    return;
  }
 
  if(mx.Sex == mx.empty && mx.PlayType == mx.empty && $("#hiddenSexPlayTypeCnt").val() > 0 ) {
    alert("종목구분을 선택해주세요");
    return;
  }
  
  if(mx.LevelJoo == mx.empty && $("#hiddenLevelJooNameCnt").val() > 0) {
    alert("급수를 선택해주세요.");
    return;
  }
  

  if(mx.Level == mx.empty && $("#hiddentLevelCnt").val() > 0) {
    alert("종별을 선택해주세요.");
    return;
  }

  console.log(" PlayLevelType : "+ value);
  mx.PlayLevelType = value;
  mx.PlayLevelTypeName = name;
  OnGameLevelSearch();
};

function OnStadiumChanged(value, name){
  console.log(" Stadium : "+ value);
  mx.InsertStadiumIdx = value;
  //mx.StadiumIdx = value;
  //mx.StadiumIdxName = name;
  OnGameLevelSearch();
  var title = "[" + mx.GroupGameGbName 

  if (mx.TeamGbName.length > 0) {
    title = title  +  " " + mx.TeamGbName + mx.LevelJooName 
  }

  if (mx.LevelName.length > 0) {
    title = title  + "-" + mx.LevelName
  }

  if (mx.PlayLevelTypeName.length > 0) {
    title = title  +" " + mx.PlayLevelTypeName 
  }

  title = title + "]";

  if(confirm(title  +"를 " + "[" + name+ "]"+ "경기장에 추가하시겠습니까?")) {
    SetGameScheduleStadium(value);
  }
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
    
    if($(".date_ipt" ).val() =="" ){
      $(".date_ipt").datepicker('setDate', 'today');
    }
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
							
						    gameS : item.gameS,
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
		  //190121 SEH 검색한 해당경기 시작일 INPUT 박스 보여지게 수정 작업 
		  obj.gameS = ui.item.gameS;
          mx.GameTitleIdx = obj.crypt_tIdx;
          mx.GameTitleIdxName = obj.tGameTitleName;
          $("#selGameTitleIdx").val(obj.crypt_tIdx); 
          $("#span_GameTitleName").text(obj.tGameTitleName);
		  $("#initDatePicker").val(obj.gameS);
		  //alert(obj.tIdx);
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

  console.log("GameTitleIdx : " + mx.GameTitleIdx );
  console.log("StadiumIdx : " + mx.StadiumIdx );
  console.log("GameDay : " + mx.GameDay );

  if (mx.StadiumIdx === undefined)
  {
    mx.StadiumIdx = ""
  }

  if (mx.GameDay === undefined)
  {
    mx.GameDay = ""
  }
  
  urltext = { 'GameTitleIdx': mx.GameTitleIdx, 'StadiumIdx' : mx.StadiumIdx, 'GameDay' : mx.GameDay};
  var popUrl = addrs; //팝업창에 출력될 페이지 URL
  var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
  window.open(popUrl,"JoResult" + addrs,popOption);
  post_to_url_popup('JoResult' + addrs, './' + addrs, urltext);
};

function GameScheduleView(){
  
  if(mx.GameTitleIdx == "")  {
    alert("상단의 대회를 선택해주세요.")
    return;
  }
  else{
    popupOpen("SettingGameOrder.asp");
  }
};


function viewAutoGameEx(){
  if(mx.GameTitleIdx == "")  {
    alert("상단의 대회를 선택해주세요.")
    return;
  }
  else{
    popupOpen("autoGameScheduleViewEx.asp");
  }
};

function OnGameTitleChanged()
{
  var langSelect = document.getElementById("selGameTitleIdx");
  var selectText = langSelect.options[langSelect.selectedIndex].text;
  
  mx.GameTitleIdx = langSelect.options[langSelect.selectedIndex].value;
  mx.GameTitleIdxName = selectText;
  $("#selGameTitleIdx").val(mx.GameTitleIdx); 
  $("#span_GameTitleName").text(selectText);
  if (mx.GameTitleIdx.length > 0)
  {
    OnGameTitleSearch();
  }
  
};

//닫기
function UpdateCourtChanged(AllOREach)
{
  var packet = {};
  Url ="/Ajax/GameNumber/AutoSchedule_updateStadiumCourt.asp";
  packet.CMD = CMD_UPDATESTADIUMCOURT;
  
  if (AllOREach =="all")
  {
    packet.tStartCourt ="";
    packet.tEndCourt ="";
  }
  else{
    packet.tStartCourt = $("#txtEditStartCourt").val();
    packet.tEndCourt = $("#txtEditEndCourt").val();
  }
  
  packet.tScheduleIdx = $("#txtEditScheduleIdx").val();
  SendPacket(Url, packet);
};

//열기
function ModalGameScheduleCourt(scheduleIdx,teamGBNM, subTitle)
{
  $("#scheduleCourtModal").modal();

  var packet = {};
  Url ="/Ajax/GameNumber/AutoSchedule_SelectStadiumCourt.asp";
  packet.CMD = CMD_SELECTSTADIUMCOURT;
  packet.tGameScheduleIDX = scheduleIdx;
  packet.tTeamGb = teamGBNM;
  packet.tSubTitle = subTitle;
  SendPacket(Url, packet);

};