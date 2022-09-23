
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
/* GameTourney 게임 */

/* 조회된 경기장 및 날짜 */
mx.StadiumIdx = ""
mx.GameDay = ""
/* 조회된 경기장 및 날짜 */
mx.ResetGameTourney = function (){
  mx.GameLevelDtlIDX =""
  mx.TeamGameNum =""
  mx.GameNum=""
  mx.GroupGameGb=""
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
  Url ="/Ajax/GameNumber/SearchGameSchedule.asp";
  packet.CMD = CMD_SEARCHSCHDEULE;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = mx.StadiumIdx;
  packet.tGameDay = mx.GameDay;
  SendPacket(Url, packet);
};
////////////명령어////////////
CMD_SEARCHGAMETITLE = 1;
CMD_SEARCHGAMELEVEL = 2;
CMD_SEARCHTOURNEY = 3;
CMD_SEARCHSCHDEULE = 4;
CMD_SEARCHSTADIUMGAMEDAY = 5; 
CMD_INITGAMESCHEDULE =10;
CMD_UPDATEGAMETOURNEY = 20;
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

      default:{
      } break;
    }
};

function OnGameLevelSearch()
{
  txtGameLevelName = $("#txtGameLevelName").val(); 

  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SearchGameLevel.asp";
  packet.CMD = CMD_SEARCHGAMELEVEL;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tGameLevelName = txtGameLevelName;

  SendPacket(Url, packet);
};

function PrintSchedule()
{
  if (mx.GameTitleIdx != "" && mx.StadiumIdx != "" && mx.GameDay != "" )
  { 
    Url = "/Main/GameNumber/Print_SettingGameOrder.asp?" 
    + "GameTitleIDX=" + mx.GameTitleIdx +"&StadiumIdx=" + mx.StadiumIdx + "&GameDay=" + mx.GameDay; 
    location.href = Url;
  }
  else
  {
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
  Url ="/Ajax/GameNumber/SearchGameSchedule.asp";
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
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SearchGameDayOfStadium.asp";
  packet.CMD = CMD_SEARCHSTADIUMGAMEDAY;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = selStadiumIDX;
  packet.tGameDay = selGameDay;
  packet.load = load;
  SendPacket(Url, packet);
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

      

      if (typeof(teamGameNum) != "undefined" && 
                typeof(gameNum) != "undefined" && 
                    typeof(gameLevelDtlIDX) != "undefined" && 
                          typeof(groupGameGb) != "undefined" )
      {
        $('#tableToureny').resetColor();
        $(this).css('background-color','#81bcff');
        /* GameTourney 게임 */
        mx.GameLevelDtlIDX = gameLevelDtlIDX
        mx.TeamGameNum =teamGameNum
        mx.GameNum=gameNum
        mx.GroupGameGb = groupGameGb;
       console.log("gameLevelDtlIDX : " + mx.GameLevelDtlIDX  + ",teamGameNum :" + mx.TeamGameNum + ", gameNum : " + mx.GameNum + ", groupGameGb : " + mx.GroupGameGb);
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
      var stadiumIdx = $(this).find("#hiddenStadiumIdx").val();
      var gameDay = $(this).find("#hiddenGameDay").val();
      
      if(typeof(gameCourt) != "undefined" &&typeof(gameOrder) != "undefined") 
      {
        if (mx.GameLevelDtlIDX != "" && 
        mx.TeamGameNum != "" && 
          mx.GameNum != "" && 
            mx.GroupGameGb != "" )
        {
          if(confirm("코트 :" + gameCourt + ", 순서 " + gameOrder))
          {
            console.log("바꿀 위치 stadiumIdx : " + stadiumIdx + " gameDay : " + gameDay + "gameCourt :" + gameCourt + ", gameOrder : " + gameOrder)
            //암호화해야하는 URL
            Url ="/Ajax/GameNumber/updateGameSchedule.asp";
            var packet = {};
            packet.CMD = CMD_UPDATEGAMETOURNEY;

         
            /* 선택한 경기 */
            packet.tGameLevelDtlIDX = mx.GameLevelDtlIDX;
            packet.tTeamGameNum = mx.TeamGameNum;
            packet.tGameNum = mx.GameNum;
            packet.tGroupGameGb = mx.GroupGameGb;
            /* 선택한 경기 */

            /* 바꿀 위치 */
            packet.tStadiumIdx = stadiumIdx;
            packet.tGameDay = gameDay;
            packet.tGameCourt = gameCourt;
            packet.tGameOrder = gameOrder;
            /* 바꿀 위치 */
            SendPacket(Url, packet);
          }
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
