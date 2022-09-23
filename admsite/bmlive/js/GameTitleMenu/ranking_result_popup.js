
////////////명령어////////////
CMD_SELGAMETITLE = 1;
CMD_SELGAMELEVEL= 2;
CMD_SELSEARCH = 3;
CMD_GAMEORDEROPERATE = 4;
CMD_LEVELDtl = 5;
CMD_RANKINGRESULT = 6;
CMD_FINALTOURNAMENT = 7;

////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SELGAMETITLE:
    
    if(dataType == "html")
    {
        $('#divGameLevelMenu').html(htmldata); 
        OnSearchChanged();

    }
    break;
    case CMD_SELGAMELEVEL:
    if(dataType == "html")
    {
        $('#divGameLevelMenu').html(htmldata); 

      
    }
    break;
    case CMD_SELSEARCH:

    if(dataType == "html")
    {
        $('#DP_SelBox').html(htmldata); 
      
    }
    break;
    case CMD_GAMEORDEROPERATE:

    if(dataType == "html")
    {

        $('#DP_GameOrderList').html(htmldata); 
    }
    break;       

    case CMD_RANKINGRESULT:

    if(dataType == "html")
    {
        $('#DP_TeamGbResult').html(htmldata); 
        $("#LoadSpan").html("조회가 완료되었습니다.")
    }
    break;      
    
    case CMD_FINALTOURNAMENT:    

    if(dataType == "json")
    {
       if(jsondata.result == "0"){
          alert('본선진출이 완료되었습니다.');
       }
       else{
        alert('관리자에게 문의바랍니다.');
       }
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
  RankingValue = $("#selRanking").val();
  StadiumIDX = $("#selStadiumIDX").val();



  Url = "/Ajax/GameTitleMenu/OnGameRanking.asp"
  
  packet.CMD = CMD_SELGAMELEVEL;
  packet.tGroupGameGb = GroupGameGbValue;
  packet.tTeamGb = TeamGbValue;
  packet.tPlayTypeSex = PlayTypeSexValue;
  packet.tLevel = LevelValue;
  packet.tRankingValue = RankingValue;
  packet.tStadiumIDX = StadiumIDX;
  
  //console.log(packet);
  SendPacket(Url, packet);
};

function OnSearchChanged()
{ 


  GameTitleIDX = $("#selGameTitleIdx").val();
  GameDay = $("#selGameDay").val();
  StadiumIDX = $("#selStadiumIDX").val();
  StadiumNumber = $("#selStadiumNumber").val();
  SearchName = $("#txtSearchName").val();

  Url = "/Ajax/GameTitleMenu/Select_GameOrder.asp"

  var packet = {};

  packet.CMD = CMD_SELSEARCH;
  packet.tGameTitleIDX = GameTitleIDX;
  packet.tGameDay = GameDay;
  packet.tStadiumIDX = StadiumIDX;
  packet.tStadiumNumber = StadiumNumber;
  packet.tSearchName = SearchName;
  //console.log(packet);
  SendPacket(Url, packet);

};


function OnRankingResultClick(packet)
{ 

  GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
  PlayTypeSexValue = $("#selPlayTypeSex").val();
  TeamGbValue = $("#selTeamGb").val();
  LevelValue = $("#selLevel").val();
  StadiumIDX = $("#selStadiumIDX").val();
  RankingValue = $("#selRanking").val();
  
  
  Url = "/Ajax/GameTitleMenu/Ranking_Result.asp"
  
  packet.CMD = CMD_RANKINGRESULT;
  packet.tGroupGameGb = GroupGameGbValue;
  packet.tTeamGb = TeamGbValue;
  packet.tPlayTypeSex = PlayTypeSexValue;
  packet.tLevel = LevelValue;
  packet.tStadiumIDX = StadiumIDX ;
  packet.tRankingValue = RankingValue ;
  //console.log(packet);
  SendPacket(Url, packet);
  $("#LoadSpan").html("조회 중입니다. 다소 시간이 걸릴 수 있습니다.")
};

function OnRankingResultExcelClick(packet)
{ 
  GameTitleIDX = packet.tGameTitleIdx;
  //alert(GameTitleIDX)
  GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
  PlayTypeSexValue = $("#selPlayTypeSex").val();
  TeamGbValue = $("#selTeamGb").val();
  LevelValue = $("#selLevel").val();
  StadiumIDX = $("#selStadiumIDX").val();
  RankingValue = $("#selRanking").val();
  
  Url = "/Main/GameTitleMenu/ranking_result_popup_excel.asp" 
  + "?GameTitleIDX=" + GameTitleIDX
  + "&GroupGameGbValue=" + GroupGameGbValue
  + "&PlayTypeSexValue=" + PlayTypeSexValue
  + "&TeamGbValue=" + TeamGbValue
  + "&LevelValue=" + LevelValue
  + "&StadiumIDX=" + StadiumIDX
  + "&RankingValue=" + RankingValue;

  location.href = Url;
};


function OnFinalTournamentClick(packet)
{ 
  var checkconfirm = confirm("해당 최종순위로 본선진출에 동의하시면 확인버튼을 눌러주세요.");

  if(checkconfirm == false){
    return;
  }

  var TotalRankingResult = $("#TotalRankingResult").val();
  //alert(TotalRankingResult);
  var DataReulst = "";
  for( i = 1 ; i <= TotalRankingResult ; i++ ){
    var STR_GameLevelIdx = $("#STR_GameLevelIdx_" + i ).val();
    var STR_GameLevelDtlIdx = $("#STR_GameLevelDtlIdx_" + i ).val();
    var STR_TourneyGroupIDX = $("#STR_TourneyGroupIDX_" + i ).val();
    var STR_Team = $("#STR_Team_" + i ).val();
    var STR_TeamDtl = $("#STR_TeamDtl_" + i ).val();
    var STR_Grade = $("#STR_Grade_" + i ).val();
    var STR_RequestIdx = $("#STR_RequestIdx" + i ).val();
    
    DataReulst = DataReulst + STR_GameLevelIdx + "^" + STR_GameLevelDtlIdx + "^" + STR_TourneyGroupIDX + "^"+ STR_Team + "^" + STR_TeamDtl + "^" + STR_Grade +"^" + STR_RequestIdx+"%"
  }
  //console.log("DataReulst:" + DataReulst );
  
  GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
  PlayTypeSexValue = $("#selPlayTypeSex").val();
  TeamGbValue = $("#selTeamGb").val();
  LevelValue = $("#selLevel").val();
  Url = "/Ajax/GameTitleMenu/Ranking_ResultWrite.asp"
  packet.CMD = CMD_FINALTOURNAMENT;
  packet.tGroupGameGb = GroupGameGbValue;
  packet.tTeamGb = TeamGbValue;
  packet.tPlayTypeSex = PlayTypeSexValue;
  packet.tLevel = LevelValue;
  packet.tDataReulst = DataReulst;
  //console.log(packet);
  SendPacket(Url, packet);

};

  //대진표불러오는 SELECT박스 
  function sch_LevelDtl(packet){


    Url ="./ajax/Game_LevelDtl.asp"

    if(packet == undefined){
      var packet = {};
      CMD_LEVELDtl = 3;
    }

    /*
    if (packet.hasOwnProperty("CMD") == false){
      
    }
    */

    packet.CMD = CMD_LEVELDtl;
    packet.GameTitleIDX = GameTitleIDX;
    packet.GroupGameGb = $(":input:radio[name=radioGroupGameGb]:checked").val();
    packet.PlayType = $("#selPlayTypeSex").val();
    packet.TeamGb = $("#selTeamGb").val();
    packet.Level = $("#selLevel").val();        

    SendPacket(Url, packet);
};           


////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function(){

};


href_Move = function(hrefMove){
  tGameTitleIdx = $("#selGameTitleIdx").val(); 
  GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
  PlayTypeSexValue = $("#selPlayTypeSex").val();
  TeamGbValue = $("#selTeamGb").val();
  LevelValue = $("#selLevel").val();
  post_to_url('./' + hrefMove, { 'tGameTitleIdx': tGameTitleIdx,'tGroupGameGb': GroupGameGbValue,'tTeamGb': TeamGbValue,'tLevel': LevelValue, 'tPlayTypeSex': PlayTypeSexValue});
};