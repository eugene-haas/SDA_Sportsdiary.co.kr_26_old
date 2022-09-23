
////////////명령어////////////

CMD_SELSEARCH = 1;
CMD_SELSEARCHFILTER = 2;

////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
  
    case CMD_SELSEARCH:

    if(dataType == "html")
    {
        $('#DP_TeamGbResult').html(htmldata); 
      
    }
    break;

    case CMD_SELSEARCHFILTER:

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


function OnResultSearch()
{ 
  GameTitleIDX = $("#selGameTitleIdx").val();
  Ranking = $("#selRanking").val();
  
  Url = "/Ajax/GameTitleMenu/TotalRanking_Result.asp"
  var packet = {};
  packet.CMD = CMD_SELSEARCH;
  packet.tGameTitleIDX = GameTitleIDX;
  packet.tRanking = Ranking;
  SendPacket(Url, packet);
};

function OnGameLevelChanged()
{
  GameTitleIDX = $("#selGameTitleIdx").val();
  Ranking = $("#selRanking").val();
  
  Url = "/Ajax/GameTitleMenu/OnGameTotalRankingChanged.asp"
  var packet = {};
  packet.CMD = CMD_SELSEARCHFILTER;
  packet.tGameTitleIDX = GameTitleIDX;
  packet.tRanking = Ranking;
  SendPacket(Url, packet);
};

////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function(){
  OnResultSearch();
};


