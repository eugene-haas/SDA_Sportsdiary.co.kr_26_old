
////////////명령어////////////

CMD_SELPGAMELEVEL = 1;
CMD_APPLYGAMEJOODIVISIONLEVEL = 2
CMD_DELPGAMELEVEL = 3

////////////명령어////////////

////////////Ajax Receive////////////

initDateContrl = false;

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SELPGAMELEVEL:
    if(dataType == "json") {
      document.getElementById("selGameLevelIdx").value = jsondata.selGameLevelIDX;
    } break;
      
    case CMD_APPLYGAMEJOODIVISIONLEVEL :
    if(dataType == "html") {
        href_PLevel(jsondata)
    }
    break;

    case CMD_DELPGAMELEVEL :
    
    if(dataType == "json") {
        href_PLevel(jsondata)
    }
    break;

    

    default: $('#content').html(jsondata);
    break;
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////

function selPGameLevel(levelIdx) {
  //암호화해야하는 URL
  Url ="/Ajax/GameTitleMenu/selPGameLevel.asp"
  var tIDX = $( "#selGameTitleIdx" ).val(); 
  var packet = {};
  packet.CMD = CMD_SELPGAMELEVEL;
  packet.tIDX = tIDX;
  packet.tGameLevelIDX = levelIdx;
  SendPacket(Url, packet)
};

function delPGameLevel(packet) {
  //암호화해야하는 URL
  Url ="/Ajax/GameTitleMenu/delPGameLevel_frm.asp"
  var tIDX = $( "#selGameTitleIdx" ).val(); 
  var selGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
  var selPGameLevelIdx = $( "#selPGameLevelIdx" ).val(); 
  
  packet.CMD = CMD_DELPGAMELEVEL;
  packet.tIDX = tIDX;
  packet.tGameLevelIDX =selGameLevelIdx;
  packet.tPGameLevelIDX = selPGameLevelIdx  ;
  SendPacket(Url, packet)
};

function ApplyLevelJooDIvision(packet){
  if (confirm("조 재분배 시 기존의 대진표가 사라집니다.") == true){
    Url = "/Ajax/GameTitleMenu/updateLevelJooDIvision.asp"
    var tidx = $( "#selGameTitleIdx" ).val();
    var NowPage = 1;
    packet.CMD = CMD_APPLYGAMEJOODIVISIONLEVEL;
    jooDivision = document.getElementById("txtJooDivision").value
    packet.NowPage = NowPage;
    packet.tIDX = tidx
    packet.JOODIVISION = jooDivision;
    SendPacket(Url, packet);
  }
};



function href_PLevel(packet){
  post_to_url('./plevel.asp', { 'tIdx': packet.tIdx,'tPGameLevelIdx': packet.tPGameLevelIdx,'iSearchText':packet.iSearchText,'iSearchCol':packet.iSearchCol});
};
////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

function init(){

};

href_back = function(NowPage, tIdx){
  post_to_url('./level.asp', {'i2': NowPage, 'tIdx': tIdx});
};

/*
href_Participate = function(tIdx,tPGameLevelIdx,tGameLevelIdx){
  post_to_url('./participate.asp', { 'tIdx': tIdx,'tPGameLevelIdx': tPGameLevelIdx,'tGameLevelIdx': tGameLevelIdx,'pType':"plevel"});
};
*/

href_Participate = function(packet){
  post_to_url('./participate.asp', { 'tIdx': packet.tIdx,'tPGameLevelIdx': packet.tPGameLevelIdx,'tGameLevelIdx': packet.tGameLevelIdx,'pType':"plevel", 'beforeNowPage':packet.NowPage});
};


href_ParticipateTeam = function(tIdx,tGameLevelIdx){
  post_to_url('./participateTeam.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx});
};

href_LevelDtl = function(packet){
  post_to_url('./levelDtl.asp', { 'tIdx': packet.tIdx,'tPGameLevelIdx': packet.tPGameLevelIdx,'tGameLevelIdx': packet.tGameLevelIdx,'pType':"plevel"});
};


