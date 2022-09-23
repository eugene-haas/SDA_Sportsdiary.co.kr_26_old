mx = {};

/* 대회 */
mx.GameTitleIdx = "";
mx.GameTitleName = "";
mx.GameTitleGameS = "";
mx.GameTitleGameE = "";
/* 대회 */

/* 경기 날짜 */
mx.GameDay = "";
/* 경기 날짜 */

/* 경기시간(경기장별 모든 경기 끝나는 시간 확인용) */
mx.GameDelay = "15";
/* 경기시간(경기장별 모든 경기 끝나는 시간 확인용) */

/* Stadium */
mx.StadiumIdx = "";
mx.StadiumIdxName = "";
/* Stadium */


/* 배정할 경기 항목 선택 옵션 */
{
  /* 엘: 경기구분 (개인전 / 단체전), 생: 구분*/
  mx.GroupGameGb = "";
  mx.GroupGameGbName = "";

  /* 엘: 부서 (초등부, 중학부 등), 생: 종목*/
  mx.TeamGb = "";
  mx.TeamGbName = "";
  mx.JooNum_SubNm = "";

  /* 엘: 종별 (남단, 여복, 혼복 등), 생: 종목구분 */
  mx.Sex = "";
  mx.SexName = "";
  mx.PlayType = "";
  mx.PlayTypeName = ""

  /* 경기구분 (본선, 예선, 결선) */
  mx.PlayLevelType = "";
  mx.PlayLevelTypeName = "";

  /* 엘: 강수/그룹 */
  mx.GameTypeNumber = ""; // 토너먼트: 1(32강), 2(16강), 3(8강), 4(준결승), 5(결승) / 리그: 1(1그룹), 2(2그룹), 3(3그룹)
  mx.GameTypeName = "";

  mx.GameTypeDtl = "";

  mx.JooNum = "";
  mx.GameLevelDtlIDX = "";

  /* 엘: 경기번호 */
  mx.GameNumbers = "";
}
/* 배정할 경기 항목 선택 옵션 */


/* 경기장별 경기 일정 리스트 */
mx.ScheduleIdx1 = "";
mx.ScheduleIdx2 = "";
mx.ScheduleOrder1 = "";
mx.ScheduleOrder2 = "";

mx.DeleteSchedules = "";
/* 경기장별 경기 일정 리스트 */



////////////명령어////////////
CMD_SEARCHGAMETITLE = 1;

CMD_SEARCHGAMEINFO = 4; // 배정된 경기 정보(배정된 경기/총 경기수, 진행률)
CMD_SEARCHGAMELEVEL = 2; // 배정할 경기 선택
CMD_SETGAMESCHEDULESTADIUM = 10; // 배정할 경기 등록
CMD_DELETEGAMESCHEDULE = 20 // 배정된 경기 삭제
CMD_SAVEGAMESCHEDULE = 21 // 배정된 경기 삭제

CMD_SEARCHGAMESCHEDULESTADIUM = 5; // 경기장 리스트

CMD_SELECTGAMESTADIUM = 7; // 경기장별 배정된 경기 리스트
CMD_UPDATEGAMEORDER = 12; // 경기장별 배정된 경기 순서 변경

CMD_MOVEGAMELIST = 13;





function OnReceiveAjax(CMD, dataType, htmldata, jsondata){
  switch (CMD){
    case CMD_SEARCHGAMEINFO : { // 배정된 경기 정보(배정된 경기/총 경기수, 진행률)
      $('#ulGameInfo').html(htmldata);
      break;
    }

    case CMD_SEARCHGAMELEVEL : { // 배정할 경기 선택
      $('#divGameLevelList').html(htmldata);
      break;
    }

    case CMD_SAVEGAMESCHEDULE : {
      alert('현재 진행순서로 저장이 완료되었습니다.');
      break;
    }

    case CMD_SETGAMESCHEDULESTADIUM : { // 배정할 경기 등록
      if(dataType =="json"){
        console.log("CMD_SETGAMESCHEDULESTADIUM:" + jsondata.result)

        if(jsondata.result == "1"){
          alert("이미 등록되어 있음");
        }
        else if(jsondata.result == "1"){
          alert("등록 할 수 없음");
        }

        SearchGameInfo();
        SelectSchedule();
        SearchGameScheduleStadium();
      }
      break;
    }

    case CMD_SEARCHGAMESCHEDULESTADIUM : { // 경기장 리스트
      //var $uls = $('<div></div>').html(htmldata).children();
      //$('#divGameStadiumList').html('').append($uls.eq(0));
      $('#divGameScheduleStadium').html('').append(htmldata);

      SelectSchedule();
      break;
    }

    case CMD_SELECTGAMESTADIUM : { // 경기장별 배정된 경기 리스트
      $('#divAutoGameSchedule').html(htmldata);

      mx.ScheduleIdx1 = "";
      mx.ScheduleIdx2 = "";
      mx.ScheduleOrder1 = "";
      mx.ScheduleOrder2 = "";

      mx.DeleteSchedules = "";
      break;
    }

    case CMD_UPDATEGAMEORDER : { // 경기장별 배정된 경기 순서 변경
      SelectSchedule();
      break;
    }

    case CMD_MOVEGAMELIST : { 
      SearchGameScheduleStadium();
      break;
    }
    

    case CMD_DELETEGAMESCHEDULE : { // 배정된 경기 삭제
      SearchGameInfo();
      SearchGameScheduleStadium();
      SelectSchedule();
      break;
    }
  }
}




// ========
// 대회 검색
function searchGameTitle(data){
  var deferred = $.Deferred();

  $.ajax({
    type: 'post',
    url: "../../Ajax/GameTitleMenu/searchGameTitle.asp",
    dataType: "json",
    data: data,
  })
  .done(function (response){
    deferred.resolve(response)
  })
  .fail(function (error){
    deferred.reject(error);
  });

  return deferred.promise();
}

function OnGameTitleInfo(obj){

  mx.GameTitleIdx = obj.crypt_uidx;


  mx.GameTitleName = obj.gameTitleName;
  mx.GameTitleGameS= obj.gameS;
  mx.GameTitleGameE = obj.gameE;
  mx.GameDay = obj.gameS;



  $("#span_GameTitleName").text(mx.GameTitleName);
  $("#strGameTtitle").val(mx.GameTitleName);

  $("#initDatePicker").datepicker('option', 'minDate', mx.GameTitleGameS);
  $("#initDatePicker").datepicker('option', 'maxDate', mx.GameTitleGameE);
  $("#initDatePicker").datepicker('setDate', mx.GameDay);
}
// ========




// ========
// 배정된 경기 정보(배정된 경기/총 경기수, 진행률)
function SearchGameInfo(){
  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SearchGameInfo_Elite.asp";
  packet.CMD = CMD_SEARCHGAMEINFO;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  SendPacket(Url, packet);
}

// 배정할 경기 선택
{
  function SearchGameLevel(){
    if(mx.GameTitleIdx =="" && mx.GameTitleIdx.length == 0 ) return;


    var packet = {};
    //암호화해야하는 URL
    Url ="/Ajax/GameNumber/AutoSchedule_SearchGameLevel_Elite.asp";
    // Url ="/Ajax/GameNumber/AutoSchedule_SearchGameLevel.asp";
    packet.CMD = CMD_SEARCHGAMELEVEL;
    packet.tGameTitleIDX = mx.GameTitleIdx;

    packet.tGroupGameGb = mx.GroupGameGb;
    packet.tTeamGb = mx.TeamGb;
    packet.tJooNum_SubNm = mx.JooNum_SubNm;

    packet.tSex = mx.Sex;
    packet.tPlayType = mx.PlayType;

    packet.tPlayLevelType = mx.PlayLevelType;

    packet.tJooNum = mx.JooNum;
    packet.tGameLevelDtlIDX = mx.GameLevelDtlIDX;

    packet.tGameTypeNumber = mx.GameTypeNumber;
    packet.tGameNumbers = mx.GameNumbers;
    packet.tStadiumIDX = mx.StadiumIdx;

    console.log("packet.tStadiumIdx:" + packet.tStadiumIdx);

    SendPacket(Url, packet);
  }

  // 경배정할 경기 항목 초기화
  function OnGameLevelReset(){

    mx.GroupGameGb = "";
    mx.GroupGameGbName = "";

    mx.TeamGb = "";
    mx.TeamGbName = "";
    mx.JooNum_SubNm = "";

    mx.Sex = "";
    mx.SexName = "";
    mx.PlayType = "";
    mx.PlayTypeName = ""

    mx.PlayLevelType = "";
    mx.PlayLevelTypeName = "";

    mx.GameTypeNumber = "";
    mx.GameTypeNumberName = "";
    mx.GameTypeDtl = "";

    mx.JooNum = "";
    mx.GameLevelDtlIDX = "";

    mx.GameNumbers = "";
  }

  // 경기 구분 선택
  function OnGroupGameGbChanged(value, name){

    mx.GroupGameGb = value;
    mx.GroupGameGbName = name;

    mx.TeamGb = "";
    mx.TeamGbName = "";
    mx.JooNum_SubNm = "";

    mx.Sex = "";
    mx.SexName = "";
    mx.PlayType = "";
    mx.PlayTypeName = ""

    mx.PlayLevelType = "";
    mx.PlayLevelTypeName = "";

    mx.GameTypeNumber = "";
    mx.GameTypeNumberName = "";
    mx.GameTypeDtl = "";

    mx.JooNum = "";
    mx.GameLevelDtlIDX = "";

    mx.GameNumbers = "";
  }

  // 부서 선택
  function OnTeamGbChanged(value, name, subname){

    if(mx.GroupGameGb == ""){
      alert("경기구분을 선택하세요.");
      return;
    }

    mx.TeamGb = value;
    mx.TeamGbName = name;
    mx.JooNum_SubNm = subname;

    mx.Sex = "";
    mx.SexName = "";
    mx.PlayType = "";
    mx.PlayTypeName = ""

    mx.PlayLevelType = "";
    mx.PlayLevelTypeName = "";

    mx.GameTypeNumber = "";
    mx.GameTypeNumberName = "";
    mx.GameTypeDtl = "";

    mx.JooNum = "";
    mx.GameLevelDtlIDX = "";

    mx.GameNumbers = "";
  }

  // 종별 선택
  function OnSexPlayTypeChanged(sex, sexNM, playType, playTypeNM){

    if(mx.GroupGameGb == ""){
      alert("경기구분을 선택하세요.");
      return;
    }

    if(mx.TeamGb == ""){
      alert("부서를 선택하세요.");
      return;
    }

    mx.Sex = sex;
    mx.SexName = sexNM;
    mx.PlayType = playType;
    mx.PlayTypeNM = playTypeNM;

    mx.PlayLevelType = "";
    mx.PlayLevelTypeName = "";

    mx.GameTypeNumber = "";
    mx.GameTypeNumberName = "";
    mx.GameTypeDtl = "";

    mx.JooNum = "";

    mx.GameNumbers = "";
  }

  // 경기 유형 선택
  function OnPlayLevelTypeChanged(value, name){

    if(mx.GroupGameGb == ""){
      alert("경기구분을 선택하세요.");
      return;
    }

    if(mx.TeamGb == ""){
      alert("부서를 선택하세요.");
      return;
    }
    
    if(mx.Sex == ""){
      alert("종별을 선택하세요.");
      return;
    }    

    mx.PlayLevelType = value;
    mx.PlayLevelTypeName = name;

    mx.GameTypeNumber = "";
    mx.GameTypeNumberName = "";
    mx.GameTypeDtl = "";

    mx.JooNum = "";
    mx.GameLevelDtlIDX = "";

    mx.GameNumbers = "";
  };

  // 경기 유형 선택
  function OnJoChanged(value, value2, name){

    if(mx.GroupGameGb == ""){
      alert("경기구분을 선택하세요.");
      return;
    }

    if(mx.TeamGb == ""){
      alert("부서를 선택하세요.");
      return;
    }
    
    if(mx.Sex == ""){
      alert("종별을 선택하세요.");
      return;
    }    

    if(mx.PlayLevelType == ""){
      alert("경기유형을 선택하세요.");
      return;
    }    

    mx.JooNum = value;
    mx.GameLevelDtlIDX = value2;

    mx.GameTypeNumber = "";
    mx.GameTypeNumberName = "";
    mx.GameTypeDtl = "";

    mx.GameNumbers = "";
  };  

  // 강수/그룹 선택
  function OnGameTypeNumberChanged(value, name, gametypedtl){

    if(mx.GroupGameGb == ""){
      alert("경기구분을 선택하세요.");
      return;
    }

    if(mx.TeamGb == ""){
      alert("부서를 선택하세요.");
      return;
    }
    
    if(mx.Sex == ""){
      alert("종별을 선택하세요.");
      return;
    }    

    if(mx.PlayLevelType == ""){
      alert("경기유형을 선택하세요.");
      return;
    }    

    if(mx.GameLevelDtlIDX == ""){
      alert("조를 선택하세요.");
      return;
    }        

    mx.GameTypeNumber = value;
    mx.GameTypeNumberName = name;
    mx.GameTypeDtl = gametypedtl;

    mx.GameNumbers = "";
  }

  // 경기번호(토너먼트) 선택
  function OnTournamentGameNumberChanged(startNumber, endNumber){
    console.log('tournament')

    if(mx.GameNumbers === "" || !Array.isArray(mx.GameNumbers)){
      mx.GameNumbers = [];
    }

    if(startNumber){
      mx.GameNumbers[0] = startNumber;
    }

    if(endNumber){
      mx.GameNumbers[1] = endNumber;
    }
  }

  // 경기번호(리그) 선택
  function OnLeagueGameNumberChanged(gameNumber){
    console.log('league')

    if(mx.GameNumbers === "" || !Array.isArray(mx.GameNumbers)){
      mx.GameNumbers = [];
    }

    if(Array.isArray(gameNumber)){
      mx.GameNumbers = gameNumber;
    }
    else{
      var idx = mx.GameNumbers.findIndex(function (item){
        return item === gameNumber
      });

      if(idx > -1){
        mx.GameNumbers.splice(idx, 1);
      }
      else{
        mx.GameNumbers.push(gameNumber);
      }
    }
  }
}

// 배정할 경기 등록
function SetGameScheduleStadium(){
  // var title = "[" + mx.GroupGameGbName
  //
  // if(mx.TeamGbName.length > 0){
  //   title = title  +  " " + mx.TeamGbName + mx.LevelJooName
  // }
  //
  // if(mx.LevelName.length > 0){
  //   title = title  + "-" + mx.LevelName
  // }
  //
  // if(mx.PlayLevelTypeName.length > 0){
  //   title = title  +" " + mx.PlayLevelTypeName
  // }
  //
  // title = title + "]";
  //
  // if(confirm(title  +"를 " + "[" + name+ "]"+ "경기장에 추가하시겠습니까?")){
  //   SetGameScheduleStadium(value);
  // }

  if(mx.StadiumIdx == ""){
    alert("경기장을 선택하시기 바랍니다.");
    return;
  }

  var packet = {};

  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SetGameScheduleStadium_Elite.asp";
  packet.CMD = CMD_SETGAMESCHEDULESTADIUM;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIdx = mx.StadiumIdx;
  packet.tGroupGameGb = mx.GroupGameGb;
  packet.tTeamGb = mx.TeamGb;
  packet.tJooNum_SubNm = mx.JooNum_SubNm;
  packet.tSex = mx.Sex;
  packet.tPlayType = mx.PlayType;
  packet.tPlayLevelType = mx.PlayLevelType;

  packet.tGameTypeDtl = mx.GameTypeDtl;

  packet.tGameLevelDtlIDX = mx.GameLevelDtlIDX;

  packet.tGameTypeNumber = mx.GameTypeNumber;
  packet.tGameNumbers = mx.GameNumbers;

  packet.tGameDay = mx.GameDay;

  SendPacket(Url, packet);
};
// ========


// 배정된 경기 삭제
{
  function DeleteGameSchedule(){
    if(mx.DeleteSchedules !== "" && mx.DeleteSchedules.length > 0  && confirm("정말로 삭제하시겠습니까?")){
      var packet = {};
      Url ="/Ajax/GameNumber/AutoSchedule_DeleteGameSchedule_Elite.asp";
      packet.CMD = CMD_DELETEGAMESCHEDULE;
      packet.tDeleteSchedules = mx.DeleteSchedules;
      
      SendPacket(Url, packet);
    }
  }

  function SaveGameSchedule(){

    var con_bool = confirm("해당 내용 저장 시,  기존 내역은 리셋됩니다.\r\n현재 진행순서로 저장하시겠습니까?\r\n동의하시면 확인버튼을 눌러주세요.");

    if (con_bool == false) {
        return;
    }    
    

    var packet = {};
    Url ="/Ajax/GameNumber/AutoSchedule_SaveGameSchedule_Elite.asp";
    packet.CMD = CMD_SAVEGAMESCHEDULE;
    
    packet.tGameTitleIDX = mx.GameTitleIdx;
    packet.tStadiumIdx = mx.StadiumIdx;
    packet.tGameDay = mx.GameDay;    


    SendPacket(Url, packet);
    
  }  

  // 배정된 경기 전체선택/해제(삭제를 위한)
  function OnCheckAll(target){
    if($('#AllCheck').prop("checked")){
      $("input[name=chkBox]").prop("checked", true);
    }
    else{
      $("input[name=chkBox]").prop("checked", false);
    }

    mx.DeleteSchedules = [];
    $('[name="chkBox"]:checked').each(function (){
      mx.DeleteSchedules.push($(this).val());
    });
  }

  // 배정된 경기 선택/해제(삭제를 위한)
  function OnCheckGameSchedule(){
    var isAllCheck = true;
    $('[name="chkBox"]').each(function (index, item){
      if(!$(item).prop("checked")){
        isAllCheck = false;
        return false;
      }
    });

    if(isAllCheck){
      $("#AllCheck").prop("checked", true);
    }
    else{
      $("#AllCheck").prop("checked", false);
    };

    mx.DeleteSchedules = [];
    $('[name="chkBox"]:checked').each(function (){
      mx.DeleteSchedules.push($(this).val());
    });


  }
}



// ========
// 경기장 리스트
function SearchGameScheduleStadium(){
  var packet = {};
  //암호화해야하는 URL
  // Url ="/Ajax/GameNumber/AutoSchedule_SearchGameScheduleStadium.asp";
  Url ="/Ajax/GameNumber/AutoSchedule_SearchGameScheduleStadium_elite.asp";
  packet.CMD = CMD_SEARCHGAMESCHEDULESTADIUM;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = mx.StadiumIdx;
  packet.tGameDay = mx.GameDay;
  packet.tGameDelay = mx.GameDelay;

  SendPacket(Url, packet);
};

function openOperate(){

  var url = "SettingGameOperate_elite.asp";

  var tGameTitleIDX = mx.GameTitleIdx;
  var tStadiumIDX = mx.StadiumIdx;
  var tGameDay = mx.GameDay;  

  url = url + "?GameTitleIdx=" + tGameTitleIDX + "&StadiumIDX=" + tStadiumIDX + "&GameDay=" + tGameDay;

  var win = window.open(url, '_blank');
  win.focus();  
  return;
}

function onchangeGameOrder(mtype, midx){

  var packet = {};

  Url ="/Ajax/GameNumber/AutoSchedule_MoveGameList_elite.asp";
  packet.CMD = CMD_MOVEGAMELIST;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = mx.StadiumIdx;
  packet.tGameDay = mx.GameDay;
  packet.tMType = mtype;
  packet.tMIDX = midx;

  SendPacket(Url, packet);
}

// 경기장 선택
function OnStadiumChanged(value, name){
  // mx.InsertStadiumIdx = value;

  mx.StadiumIdx = value;
  mx.StadiumIdxName = name;
};

// 경기 시간 변경
function OnGameDelay(value){
  mx.GameDelay = value;
}
// ========


// ========
// 경기장별 배정된 경기 리스트
function SelectSchedule(){
  // if(mx.StadiumIdx == "") return;

  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SelectGameSchedule_Elite.asp";
  packet.CMD = CMD_SELECTGAMESTADIUM;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = mx.StadiumIdx;
  packet.tStadiumName = mx.StadiumIdxName;
  packet.tGameDay = mx.GameDay;
  SendPacket(Url, packet);
};

// 경기장별 배정된 경기 순서 변경
function SetScheduleOrder(){
  if(mx.ScheduleIdx1 === "" || mx.ScheduleOrder1 === "" || mx.SchdeuleIdx2 === "" || mx.ScheduleOrder2 === ""){
    return;
  }

  var packet = {};
  Url ="/Ajax/GameNumber/AutoSchedule_updateGameOrder_Elite.asp";
  packet.CMD = CMD_UPDATEGAMEORDER;
  packet.tScheduleIdx1 = mx.ScheduleIdx1;
  packet.tScheduleOrder1 = mx.ScheduleOrder1;
  packet.tScheduleIdx2 = mx.ScheduleIdx2;
  packet.tScheduleOrder2 = mx.ScheduleOrder2;
  SendPacket(Url, packet);
}

// !@# 추가확인 필요
// 경기장별 배정된 경기 리스트에서 순서 변경할 경기 선택/해제
function OnScheduleOrderChanged(GameScheduleIdx, order, target){
  if(mx.ScheduleIdx1 === "" || mx.ScheduleOrder1 === ""){
    mx.ScheduleIdx1 = GameScheduleIdx;
    mx.ScheduleOrder1 = order;

    // targe style 변경
    $(target).addClass('active');

    mx.ScheduleIdx2 = "";
    mx.ScheduleOrder2 = "";
  }
  else if(mx.ScheduleIdx1 === GameScheduleIdx || mx.ScheduleOrder1 === order){
    mx.ScheduleIdx1 = "";
    mx.ScheduleOrder1 = "";

    $(target).removeClass('active');

    mx.ScheduleIdx2 = "";
    mx.ScheduleOrder2 = "";
  }
  else{

    mx.ScheduleIdx2 = GameScheduleIdx;
    mx.ScheduleOrder2 = order;

    $(target).addClass('active');

    // targe style 변경
  }
}
// ========



$(window).ready(function (){

  // 초기화
  searchGameTitle({ "REQ" : JSON.stringify({"CMD":CMD_SEARCHGAMETITLE, "SVAL":''}) })
  .then(function (res){
    //OnGameTitleInfo(res[0]);
   
    //SearchGameLevel();
    //SearchGameInfo();
    //SearchGameScheduleStadium();
  });

  // 대회 검색바
  $("#strGameTtitle").autocomplete({
    minLength: 1, //조회를 위한 최소글자수
    delay: 300, //검색 딜레이
    focus: function (event, ui){return false;}, //한글 키보드 컨트롤 오류 해결
    source : function(request, response){

      searchGameTitle({ "REQ" : JSON.stringify({"CMD":CMD_SEARCHGAMETITLE, "SVAL":request.term}) })
      .then(function (res){
        //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
        response(
          $.map(res, function (item){
            return {
              label: item.gameTitleName + "(" + item.gameS + "~" + item.gameE + ")" + ", 번호 : " + item.uidx,
              value: item.gameTitleName,
              tidx : item.uidx,
              gameTitleName : item.gameTitleName,
              gameS : item.gameS,
              gameE : item.gameE,
              crypt_uidx : item.crypt_uidx
            }
          })
        );
      });
    },
    search: function (event, ui){ // 검색된 대회 선택
      //console.log("찾는당");

      var isSelect = $(this).attr("isSelect");

      isSelect = (typeof isSelect === "undefinded") ? 0 : isSelect;

      if(isSelect == 1){
        console.log("선택직후니까 처리안함");
        return false;
      }
    },    
    select: function (event, ui){ // 검색된 대회 선택

      $(this).attr("isSelect",1);

      setTimeout(function(obj){
        $(obj).attr("isSelect",0);
      }, 500, this);

      OnGameTitleInfo(ui.item);

      console.log("asdadsdaaaaaaaaaa");

      mx.StadiumIdx = "";
      mx.StadiumIdxName = "";

      SearchGameLevel();
      SearchGameInfo();
      SearchGameScheduleStadium();
    }
  });

  // 날짜 선택
  $("#initDatePicker").datepicker({
    changeYear:true,
    changeMonth: true,
    dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'],
    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    showMonthAfterYear:true,
    showButtonPanel: false,
    currentText: '오늘 날짜',
    closeText: '닫기',
    dateFormat: "yy-mm-dd",
    onSelect: function (date){ // 날짜 선택
      mx.GameDay = date;

      SearchGameScheduleStadium();
    }
  });

});
