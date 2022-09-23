
////////////명령어////////////
CMD_SELGAMETITLE = 1;
CMD_SELGAMELEVEL= 2;
////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SELGAMETITLE:
    if(dataType == "html")
    {
        $('#divGameLevelMenu').html(htmldata); 
    }
    break;
    case CMD_SELGAMELEVEL:
    if(dataType == "html")
    {
        $('#divGameLevelMenu').html(htmldata); 
    }
    break;
    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////

function OnGameTitleChanged(value)
{ 
  Url = "/Ajax/GameTitleMenu/OnGameTitleChangedOperate.asp"
  var packet = {};
  packet.CMD = CMD_SELGAMETITLE;
  packet.tGameTitleIdx = value;
  SendPacket(Url, packet);
};


function OnGameLevelChanged(packet)
{ 
  GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
  PlayTypeSexValue = $("#selPlayTypeSex").val();
  TeamGbValue = $("#selTeamGb").val();
  LevelValue = $("#selLevel").val();

  Url = "/Ajax/GameTitleMenu/OnGameTitleChangedOperate.asp"

  packet.CMD = CMD_SELGAMELEVEL;
  packet.tGroupGameGb = GroupGameGbValue;
  packet.tTeamGb = TeamGbValue;
  packet.tPlayTypeSex = PlayTypeSexValue;
  packet.tLevel = LevelValue;
  //console.log(packet);
  SendPacket(Url, packet);
};


////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function(){
  
};


href_Move = function(tGameTitleIdx, hrefMove){
  GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
  PlayTypeSexValue = $("#selPlayTypeSex").val();
  TeamGbValue = $("#selTeamGb").val();
  LevelValue = $("#selLevel").val();
  post_to_url('./' + hrefMove, { 'tGameTitleIdx': tGameTitleIdx,'tGroupGameGb': GroupGameGbValue,'tTeamGb': TeamGbValue,'tLevel': LevelValue, 'tPlayTypeSex': PlayTypeSexValue});
};
