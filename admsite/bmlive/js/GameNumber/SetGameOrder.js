mx = {};

////////////명령어////////////
CMD_SELGAMENUMBER = 1;
CMD_UPDATEGAMENUMBER = 2;
CMD_SETGAMENUMBER = 3;
CMD_SETGAMEORDER = 4;
CMD_SETAUTOGAMENUMBER = 5;
////////////명령어////////////

////////////Ajax Receive////////////

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SELGAMENUMBER:
    { 
        if(dataType == "html")
        {
          $('#divGameNumberBody').html(htmldata); 
          
          $(".up, .down").click(function() {

          var $element = this;
          var row = $($element).parents("tr:first");
          var swapRow = $(this).is('.up') ? row.prev() : row.next();
  
          if ($(this).is('.up')) {
              row.insertBefore(swapRow);
          } else {
              row.insertAfter(swapRow);
          }
          SetLevelGameNumber();
          });
        
          $(".date_ipt").datepicker({
            onSelect: function(dateText) {
              mx.NowDate = dateText;
            },
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

          $(".date_ipt").datepicker('setDate', mx.NowDate );

        }
    } break;

    case CMD_SETGAMEORDER:{
      SelGameNumber();
    }break;

    case CMD_UPDATEGAMENUMBER :{
      SelGameNumber(); 
    }break;

    case CMD_SETGAMENUMBER : {
      SelGameNumber(); 
    }break;

    case CMD_SETAUTOGAMENUMBER: {
      alert("번호부여 완료")
      SelGameNumber(); 
    }break;

    default:
      href_gametitle(1)
      break;
    }
};

  
function SelGameNumber() {
  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SelGameNumber.asp";
  selGameTitleIdx = $( "#selGameTitle" ).val(); 
  selStadiumIdx = $( "#selStadium" ).val();
  
  if (typeof selStadiumIdx  == "undefined" || selStadiumIdx == null) {
    selStadiumIdx = ""
  } 
  
  packet.CMD = CMD_SELGAMENUMBER;
  packet.tIDX = selGameTitleIdx;
  packet.tStadiumIdx = selStadiumIdx;
  SendPacket(Url, packet);
};


function SetLevelGameNumber() {
  var tableGameLevelCnt = document.getElementById("tableGameLevelList").rows.length;
  var GameLevelIdxs = ""
  var enGameLevelIdxs = ""

  if(tableGameLevelCnt > 0 ) {
    
    for (var i = 0; i < tableGameLevelCnt; i++) {
      var selectElement = document.getElementById("tableGameLevelList").rows[i].cells[0].querySelector('input')
      var enSelectElement = document.getElementById("tableGameLevelList").rows[i].cells[1].querySelector('input')
      
      if(selectElement != null) {
        var selectValue = selectElement.value;
        GameLevelIdxs = GameLevelIdxs + selectValue + "_";
      }

      if(enSelectElement != null) {
        var enSelectValue = enSelectElement.value;
        enGameLevelIdxs = enGameLevelIdxs + enSelectValue + "_";
      }
    }
   
    if(GameLevelIdxs.length > 0 && enGameLevelIdxs.length > 0)
    {
      var SplitIndex= GameLevelIdxs.lastIndexOf("_"); 
      var newGameLevelIdxs = GameLevelIdxs.substring(0, SplitIndex);
      var EnSplitIndex= enGameLevelIdxs.lastIndexOf("_"); 
      var newEnGameLevelIdxs = enGameLevelIdxs.substring(0, EnSplitIndex);
      Url ="/Ajax/GameNumber/SetLevelGameNumber.asp";
      selGameTitle = $( "#selGameTitle" ).val();
      var packet = {};
      packet.CMD = CMD_UPDATEGAMENUMBER;
      packet.tIDX = selGameTitle;
      packet.tGameLevelIdxs = newGameLevelIdxs ;
      packet.tEnGameLevelIdxs = newEnGameLevelIdxs  ;
      SendPacket(Url, packet);
    }
  }
};

function autoSetGameNumber(){
  
  Url ="/Ajax/GameNumber/SetAutoGameNumber.asp";
  var packet = {};
  packet.CMD = CMD_SETAUTOGAMENUMBER;
  packet.tIDX =  $( "#selGameTitle" ).val(); 
  packet.tStadiumIdx = $( "#selStadium" ).val();
  packet.tGameS = $( "#GameS" ).val();
  SendPacket(Url, packet);
}

function applyGameNumber() {
  Url ="/Ajax/GameNumber/SetGameNumber.asp";
  var packet = {};
  packet.CMD = CMD_SETGAMENUMBER;
  packet.StadiumIDX = $("#selStadium").val();
``
  var totalTourneyCnt = $( "#totalGameNumberTourneyCnt" ).val();
  var tourneyString = ""

  for(var i = 1 ; i <= totalTourneyCnt ; i ++) {
    GameNumTourneyDtlIDX  = $( "#GameNumTourneyDtlIDX" + i ).val();
    GameNumTourney = $( "#GameNumTourney" + i ).val();
    TurnNum = $( "#txtTurnNum" + i ).val();
    GameDay = $("#txtGameDay" + i).val();
    StadiumNum = $("#txtStadiumNum" + i).val();
    tourneyString = tourneyString +  GameNumTourneyDtlIDX + "^" + GameNumTourney + "^" + TurnNum + "^" + GameDay + "^" + StadiumNum + "%"
  }

  if (tourneyString.length > 0) {
    tourneyString = tourneyString.substring(0, tourneyString.lastIndexOf("%"));
  }
  packet.data = tourneyString;
  //console.log(packet)
  SendPacket(Url, packet);
};



////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function() {
  mx.NowDate = new Date();

  $(".up, .down").click(function() 
  {
    var $element = this;
    var row = $($element).parents("tr:first");
    var swapRow = $(this).is('.up') ? row.prev() : row.next();

    if ($(this).is('.up')) {
        row.insertBefore(swapRow);
    } else {
        row.insertAfter(swapRow);
    }

    SetLevelGameNumber();
  });


  $(function() {
    $(".date_ipt").datepicker({
      onSelect: function(dateText) {
        mx.NowDate = dateText;
      },
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
    $(".date_ipt").datepicker('setDate', mx.NowDate );
  });

};

OnGameOrderChagned = function(gameLevelIdx,value){
  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SetGameLevelOrder.asp";
  packet.CMD = CMD_SETGAMEORDER ;
  packet.tGameLevelIdx = gameLevelIdx;
  packet.tGameOrder = value;
  //console.log(packet);
  SendPacket(Url, packet);
};

href_gametitle = function(NowPage){
  post_to_url('./index.asp', { 'i2': NowPage});
};

href_level = function(tIdx){
  post_to_url('./level.asp', { 'tIDX': tIdx});
};

href_viewGameNumber = function() {
  post_to_url('./ViewGameOrder.asp', {} );
};