
////////////명령어////////////

CMD_LEVELMOVESELECTLIST = 1;
CMD_LEVELMOVELIST = 2;
CMD_LEVELMOVE = 3;

////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  switch(CMD) {

    case  CMD_LEVELMOVESELECTLIST :
    {
      if(dataType == "html")
      {
        $('#divLevelDtlMember').html(htmldata); 
      }
      
    }break;
    
    case  CMD_LEVELMOVELIST :
    {
      if(dataType == "html")
      {

        $('#divGameLevelDtlList').html(htmldata); 
      }
      
    }break;

    case  CMD_LEVELMOVE :
    {
      
      if(dataType == "json")
      {
        if(jsondata.result == "0"){
          alert("종목이동이 완료되었습니다.");
        }        
        if(jsondata.result == "1"){
          alert("선수 선택값이 없습니다.[ERR:1]");
          return;
        }
        if(jsondata.result == "2"){
          alert("종목 선택값이 없습니다.[ERR:2]");
          return;
        }        
        if(jsondata.result == "3"){
          alert("해당종목은 존재하지 않습니다.[ERR:3]");
          return;
        }                
        if(jsondata.result == "4"){
          alert("개인종목과 단체종목을 같이 통합할 수 없습니다.[ERR:4]");
          return;
        }                


        if(jsondata.tViewType == "LEFT"){
          LevelMoveSelectList(jsondata.tGameTitleIDX,jsondata.tSelect_GamelevelIDX);
          LevelMoveList(jsondata.tGameTitleIDX,jsondata.tTarget_GamelevelIDX);
        }
        else{
          LevelMoveSelectList(jsondata.tGameTitleIDX,jsondata.tTarget_GamelevelIDX);
          LevelMoveList(jsondata.tGameTitleIDX,jsondata.tSelect_GamelevelIDX);          
        }

      }
      
    }break;    
    


    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////
function LevelMoveSelectList(gametitleidx,gamelevelidx) {


  Url = "/Ajax/GameTitleMenu/SelLevelMoveSelectList.asp"
  var tGameTitleIDX = gametitleidx; 
  var tGameLevelIDX = gamelevelidx;

  var packet = {};
  packet.CMD = CMD_LEVELMOVESELECTLIST;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameLevelIDX = tGameLevelIDX;
  packet.tSearchType = $("#SearchType_LEFT").val();
  packet.tSearchValue = $("#SearchValue_LEFT").val();
  packet.tViewType = "LEFT";

  SendPacket(Url, packet);
};

function LevelMoveList(gametitleidx,gamelevelidx) {
  Url = "/Ajax/GameTitleMenu/SelLevelMoveSelectList.asp"
  var tGameTitleIDX = gametitleidx; 
  var tGameLevelIDX = gamelevelidx;

  var packet = {};
  packet.CMD = CMD_LEVELMOVELIST;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameLevelIDX = tGameLevelIDX;
  packet.tSearchType = $("#SearchType_RIGHT").val();
  packet.tSearchValue = $("#SearchValue_RIGHT").val();
  packet.tViewType = "RIGHT";

  SendPacket(Url, packet);
};

function membermove(viewtype, gametitleidx){

  var str_reqidx = "";
  var loopNum = 0;

  $("input[name=reqidx_" + viewtype + "]:checked").each(function() {

   
    if(loopNum == 0){
      str_reqidx += $(this).val(); 
    }
    else{
      str_reqidx += "," + $(this).val(); 
    }

    loopNum += 1;
  });
  
  console.log("+" + str_reqidx);
  
  if(str_reqidx == ""){
    alert("종목이동 하실 선수를 선택해 주시기 바랍니다.");
    return;
  }

  var data = "";
  var tSelect_GamelevelIDX = "";
  var tTarget_GamelevelIDX = "";

  if(viewtype == "LEFT"){
    tSelect_GamelevelIDX = $("#GameLevelIDX_LEFT").val();
    tTarget_GamelevelIDX = $("#GameLevelIDX_RIGHT").val();
  }
  else{
    tSelect_GamelevelIDX = $("#GameLevelIDX_RIGHT").val();
    tTarget_GamelevelIDX = $("#GameLevelIDX_LEFT").val();    
  }

  if(tSelect_GamelevelIDX == "" || tTarget_GamelevelIDX == ""){
    alert("이동하실 종목을 선택해 주시기 바랍니다.");
    return;
  }

  if(tSelect_GamelevelIDX == tTarget_GamelevelIDX){
    alert("동일한 종목은 이동하실 수 없습니다.");
    return;
  }  

  if(viewtype == "LEFT"){
    data = confirm("선택된 좌측팀 -> 우측팀으로 이동 합니다. 동의하시면 확인버튼을 눌러주세요.");
  }
  else{
    data = confirm("선택된 우측팀 -> 좌측팀으로 이동 합니다. 동의하시면 확인버튼을 눌러주세요.");
  }


  if (data == true) {
    Url = "/Ajax/GameTitleMenu/levelRequestMoveParticipate_update.asp"
    var tGameTitleIDX = gametitleidx; 
    var tUSerId_Checked = str_reqidx; 

    var packet = {};
    packet.CMD = CMD_LEVELMOVE;
    packet.tGameTitleIDX = tGameTitleIDX;
    packet.tUSerId_Checked = tUSerId_Checked;
    packet.tSelect_GamelevelIDX = tSelect_GamelevelIDX;
    packet.tTarget_GamelevelIDX = tTarget_GamelevelIDX;
    packet.tViewType = viewtype;

    console.log("packet.tUSerId_Checked:" + tUSerId_Checked);
    console.log("packet.tSelect_GamelevelIDX:" + tSelect_GamelevelIDX);
    console.log("packet.tTarget_GamelevelIDX:" + tTarget_GamelevelIDX);


    SendPacket(Url, packet);
  }		
}


////////////Custom Function////////////

href_back = function(tIdx, tGameLevelIdx,NowPage){
  post_to_url('./level.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx,'pType': 'level', 'i2': NowPage});
};

href_back2 = function(tIdx,tPGameLevelIdx, tGameLevelIdx, NowPage){
  post_to_url('./level.asp', { 'tIdx': tIdx,'tPGameLevelIdx':tPGameLevelIdx,'tGameLevelIdx': tGameLevelIdx,'pType': 'plevel' ,'i2': NowPage});
};

