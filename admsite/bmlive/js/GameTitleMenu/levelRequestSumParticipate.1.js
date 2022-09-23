
////////////명령어////////////

CMD_LEVELSUMSELECTLIST = 1;
CMD_LEVELSUMLIST = 2;
CMD_LEVELSUM = 3;

////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  switch(CMD) {

    case  CMD_LEVELSUMSELECTLIST :
    {
      if(dataType == "html")
      {
        $('#divLevelDtlMember').html(htmldata); 
      }
      
    }break;
    
    case  CMD_LEVELSUMLIST :
    {
      if(dataType == "html")
      {
        $('#divGameLevelDtlList').html(htmldata); 
      }
      
    }break;

    case  CMD_LEVELSUM :
    {
      
      if(dataType == "json")
      {
        if(jsondata.result == "1"){
          alert("개인종목과 단체종목을 같이 통합할 수 없습니다.[ERR:1]");
          return;
        }
        if(jsondata.result == "2"){
          alert("통합 대상 종목을 찾을 수 없습니다.[ERR:2]");
          return;
        }        
        if(jsondata.result == "3"){
          alert("개인종목과 단체종목을 같이 통합할 수 없습니다.[ERR:3]");
          return;
        }                
      }
      
    }break;    
    


    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////
function LevelSumSelectList(gametitleidx) {
  Url = "/Ajax/GameTitleMenu/SelLevelSumSelectList.asp"
  var tGameTitleIDX = gametitleidx; 

  var strLevelName = $("#strLevelName_SELECT").val();
  var strGroupGameGb = $("#GroupGameGb_SELECT").val();

  var packet = {};
  packet.CMD = CMD_LEVELSUMSELECTLIST;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.strLevelName = strLevelName;
  packet.tGroupGameGb = strGroupGameGb;
  packet.ViewType = "SELECT";

  SendPacket(Url, packet);
};

function LevelSumList(gametitleidx) {
  Url = "/Ajax/GameTitleMenu/SelLevelSumSelectList.asp"
  var tGameTitleIDX = gametitleidx; 

  var strLevelName = $("#strLevelName_TARGET").val();
  var strGroupGameGb = $("#GroupGameGb_TARGET").val();

  var packet = {};
  packet.CMD = CMD_LEVELSUMLIST;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.strLevelName = strLevelName;
  packet.tGroupGameGb = strGroupGameGb;
  packet.ViewType = "TARGET";

  SendPacket(Url, packet);
};


function SumLevel(gametitleidx, levelidx) {

  var sellevelidx = "";

  $('input:checkbox[name="chk_LevelIDX"]').each(function() {
    
   

    if(this.checked){//checked 처리된 항목의 값
      //console.log(this.value); 
      sellevelidx += this.value + ',';
    }
  
  });

  if(sellevelidx == ""){
    alert("통합하실 종목을 체크해 주시기 바랍니다.");
    return;
  }

  var confirmYN = confirm("왼쪽 체크된 종목의 참가팀을, 누르신 종목으로 통합합니다. 동의하시면 확인버튼을 눌러주세요.");

  if(confirmYN == false){
    return;
  }
  
  Url = "/Ajax/GameTitleMenu/levelRequestSumParticipate_update.asp"
  var tGameTitleIDX = gametitleidx; 
  var tSelectLevelIDX = sellevelidx.substr(0,sellevelidx.length-1); 
  var tLevelIDX = levelidx; 

  var packet = {};
  packet.CMD = CMD_LEVELSUM;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tSelectLevelIDX = tSelectLevelIDX;
  packet.tLevelIDX = tLevelIDX;

  SendPacket(Url, packet);
  
};

////////////Custom Function////////////

href_back = function(tIdx, tGameLevelIdx,NowPage){
  post_to_url('./levelDtl.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx,'pType': 'level', 'i2': NowPage});
};

href_back2 = function(tIdx,tPGameLevelIdx, tGameLevelIdx, NowPage){
  post_to_url('./levelDtl.asp', { 'tIdx': tIdx,'tPGameLevelIdx':tPGameLevelIdx,'tGameLevelIdx': tGameLevelIdx,'pType': 'plevel' ,'i2': NowPage});
};

