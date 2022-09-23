mx = {};
/* 빈값 */
mx.empty = "empty"
/* 빈값 */

/* 대회 */
mx.GameTitleIdx = "";
mx.GameTitleIdxName = "";
/* 대회 */

/* Stadium */
mx.StadiumIdx = mx.empty;
mx.StadiumIdxName = "";
/* Stadium */

/* Stadium */
mx.GameDay = mx.empty;
/* Stadium */

/* Delete Schedules */
mx.DeleteSchedules = ""
/* Delete Schedules */

////////////명령어////////////
CMD_SEARCHGAMETITLE = 1;
CMD_SEARCHGAMESCHEDULEMENU = 2;
CMD_SEARCHAUTOGAMESCHEDULELIST = 3;


CMD_UPDATEGROUPGAMEORDER = 10;
CMD_UPDATEGAMEORDER = 11;
CMD_RESTOREGAMESCHEDULE = 12;

CMD_DELETEGAMESCHEDULE = 20; 
////////////명령어////////////



////////////Ajax Receive////////////

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  switch(CMD) {

    case CMD_SEARCHGAMESCHEDULEMENU :{
      $('#divGameScheduleList').html(htmldata); 
    } break;
    case CMD_SEARCHAUTOGAMESCHEDULELIST : {
      $('#divScheduleBox').html(htmldata); 
      
    }break;


    case CMD_DELETEGAMESCHEDULE : {
      OnAutoGameScheduleListSearch();
    }break;
    case CMD_RESTOREGAMESCHEDULE : {
      OnAutoGameScheduleListSearch();
    }break;

      default:{
      } break;
    }
};


mx.ResetStadiumChanged = function (){
  mx.GameDay = mx.empty;
};

mx.ResetAllChanged = function (){
  mx.StadiumIdx = mx.empty;
  mx.StadiumIdxName = "";
  mx.GameDay = mx.empty;
};

function OnGameTitleSearch()
{
  mx.ResetAllChanged();
  OnGameScheduleSearch();
  OnAutoGameScheduleListSearch();
};

function OnStadiumChanged(value, name){ 
  mx.ResetStadiumChanged();
  mx.StadiumIdx = value;
  mx.StadiumIdxName = name;
  OnGameScheduleSearch();
  OnAutoGameScheduleListSearch();
};

function OnGameDayChanged(value) {
  if(mx.StadiumIdx == mx.empty) {
    alert("먼저 경기장을 선택해주세요");
    return;
  }

  mx.GameDay = value;
  OnGameScheduleSearch();
  OnAutoGameScheduleListSearch();
};

function OnGameScheduleSearch() {
  if (mx.GameTitleIdx =="" && mx.GameTitleIdx.length == 0 )
    return;
  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SearchGameSchedule.asp";
  packet.CMD = CMD_SEARCHGAMESCHEDULEMENU;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = mx.StadiumIdx;
  packet.tGameDay = mx.GameDay;
  SendPacket(Url, packet);
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


function OnAutoGameScheduleListSearch() {
  if (mx.GameTitleIdx =="" && mx.GameTitleIdx.length == 0 )
    return;
  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/AutoSchedule_SearchSchedule.asp";
  packet.CMD = CMD_SEARCHAUTOGAMESCHEDULELIST;
  packet.tGameTitleIDX = mx.GameTitleIdx;
  packet.tStadiumIDX = mx.StadiumIdx;
  packet.tGameDay = mx.GameDay;
  SendPacket(Url, packet);
};


////////////Custom Function////////////
$(document).ready(function() {
  init();
}); 

init = function() {
  initSearchControl();
};



$(window).load(function() {
  initSettingData();
  OnGameTitleSearch();
});
  

function initSettingData(){
  if(mx.GameTitleIdx == "") {
    mx.GameTitleIdx = $("#selGameTitleIdx").val(); 
    mx.GameTitleIdxName = $("#strGameTtitle").val()
    $("#span_GameTitleName").text(mx.GameTitleIdxName);
    mx.GameDay = $("#initDatePicker").val();
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
          mx.GameTitleIdxName = obj.tGameTitleName;
          $("#selGameTitleIdx").val(obj.crypt_tIdx); 
          $("#span_GameTitleName").text(obj.tGameTitleName);
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
    mx.StadiumIdx = mx.empty;
  }

  if (mx.GameDay === undefined)
  {
    mx.GameDay = mx.empty;
  }
  
  urltext = { 'GameTitleIdx': mx.GameTitleIdx, 'StadiumIdx' : mx.StadiumIdx, 'GameDay' : mx.GameDay};
  var popUrl = addrs; //팝업창에 출력될 페이지 URL
  var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
  window.open(popUrl,"JoResult",popOption);
  post_to_url_popup('JoResult', './' + addrs, urltext);
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


function viewAutoGame(){
  if(mx.GameTitleIdx == "")  {
    alert("상단의 대회를 선택해주세요.")
    return;
  }
  else{
    popupOpen("autoGameScheduleView.asp");
  }
};

function initControl(){
  if($("#allCheck").prop("checked")) {
    $("input[name=chkBox]").prop("checked",true);
    } else {
    $("input[name=chkBox]").prop("checked",false);
    }
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


function restoreAutoGameSchedule() {
  if (mx.DeleteSchedules.length > 0  && confirm("정말로 되돌리시겠습니까?")) {
    var packet = {};
    Url ="/Ajax/GameNumber/AutoSchedule_RestoreGameSchedule.asp";
    packet.CMD = CMD_RESTOREGAMESCHEDULE;
    packet.tDeleteSchedules = mx.DeleteSchedules;
    SendPacket(Url, packet);
  }
};
