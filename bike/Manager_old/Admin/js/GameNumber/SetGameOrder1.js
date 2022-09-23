
////////////명령어////////////

CMD_SELGAMENUMBER = 1;
CMD_UPDATEGAMENUMBER = 2;
CMD_SETGAMENUMBER = 3;

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
            /*   
            if(swapRow.children()) {
              var tempValue = row.children().first().html();
              alert(tempValue)
              var firstValue = swapRow.children().first().html()
              row.children().first().html(firstValue);
              alert(firstValue)
              swapRow.children().first().html(tempValue);
            }
            */
            SetLevelGameNumber();  
          });

        }
    } break;
    case CMD_UPDATEGAMENUMBER : {
      if(dataType == "json")
      {
        SelectGameNumber();
      }
    } break;
    case CMD_SETGAMENUMBER : {
      if(dataType == "json") {
        SelectGameNumber();
      }
    }
    default:
        href_gametitle(1)
      break;
  }
};

  

////////////Ajax Receive////////////

////////////Custom Function////////////
function SelectGameNumber() {
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SelGameNumber.asp";
  selGameTitleIdx = $( "#selGameTitle" ).val(); 
  selStadiumIdx = $( "#selStadium" ).val();

  if (typeof selStadiumIdx  == "undefined") {
    selStadiumIdx = ""
  } 

  var packet = {};
  packet.CMD = CMD_SELGAMENUMBER;
  packet.tIDX = selGameTitleIdx;
  packet.tStadiumIdx = selStadiumIdx;
  SendPacket(Url, packet);
};
//
function applyGameNumber2() {
  var output = {}
  Url ="/Ajax/GameNumber/SetGameNumber.asp";
  var packet = {};
  packet.CMD = CMD_SETGAMENUMBER;
  var totalTourneyCnt = $( "#totalGameNumberTourneyCnt" ).val();
  var arrayObj = new Array(totalTourneyCnt);
  for(var i = 1 ; i <= totalTourneyCnt ; i ++)
  {
    
    GameNumTourney = $( "#GameNumTourney" + i ).val();
    GameNumTourneyDtlIDX  = $( "#GameNumTourneyDtlIDX" + i ).val();
    TurnNum = $( "#txtTurnNum" + i ).val();
    arrayObj.push(obj);
  }
  packet.data=arrayObj;
  SendPacket(Url, packet);
}

function applyGameNumber() {
  Url ="/Ajax/GameNumber/SetGameNumber.asp";
  var packet = {};
  packet.CMD = CMD_SETGAMENUMBER;
  packet.StadiumIDX = $("#selStadium").val();

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
}

function SelGameNumber(tIDX) {
  var packet = {};
  //암호화해야하는 URL
  Url ="/Ajax/GameNumber/SelGameNumber.asp";
  selGameTitleIdx = tIDX;
  selStadiumIdx = $( "#selStadium" ).val();
  
  if (typeof selStadiumIdx  == "undefined" || selStadiumIdx == null) {
    selStadiumIdx = ""
  } 
  
  
  packet.CMD = CMD_SELGAMENUMBER;
  packet.tIDX = selGameTitleIdx;
  packet.tStadiumIdx = selStadiumIdx;
  SendPacket(Url, packet);
};


function OnGameTitleChanged(tIdx)
{
  var packet = {};

  alert(tIdx)

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



////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function(){
  $(function() {
  
  });
};

href_gametitle = function(NowPage){
  post_to_url('./index.asp', { 'i2': NowPage});
}

href_level = function(tIdx){
  post_to_url('./level.asp', { 'tIDX': tIdx});
};
