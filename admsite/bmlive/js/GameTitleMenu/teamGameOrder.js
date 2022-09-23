
////////////명령어////////////
CMD_INSERTGAMEORDERDTL = 1;
CMD_SELGAMEORDERDTL = 2;
CMD_DELGAMEORDERDTL = 3;
CMD_UPDATEGAMEORDERDTL = 4;
////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  switch(CMD) {

    case CMD_SELGAMEORDERDTL:
      if(dataType == "html")
      {
        $('#gameOrderInput_area').html(htmldata);

      }break;
    case CMD_INSERTGAMEORDERDTL :
    {
      console.log("결과:" + jsondata.result);
      if(jsondata.result == 1){
        alert("이미 사용중인 오더 입니다.");
      }else{
        href_gameOrder2 (jsondata)
      }
    }break;
    case CMD_DELGAMEORDERDTL :
    {
      href_gameOrder2 (jsondata)
    }break;

    case CMD_UPDATEGAMEORDERDTL :
    {
      href_gameOrder2 (jsondata)
    }
    break;

    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

href_back = function(tIdx, NowPage){
  post_to_url('./level.asp', { 'tIdx': tIdx,'i2': NowPage});
};

href_gameOrder2 = function(packet){
  post_to_url('./teamGameorder.asp', { 'tIdx': packet.tIdx,'tGameLevelIdx': packet.tGameLevelIdx });
};

function SelGameOrderDtl(packet,tIdx,levelIdx,tGroupGameOrderIDX){
  var tGameTitleIdx = $( "#selGameIdx" ).val();
  Url = "/Ajax/GameTitleMenu/SelGameOrderDtl.asp"
  packet.CMD = CMD_SELGAMEORDERDTL;
  packet.tIdx = tGameTitleIdx;
  packet.tGameLevelIdx = levelIdx;
  packet.tGroupGameOrderIDX = tGroupGameOrderIDX;
  //console.log(packet);
  SendPacket(Url, packet);
}

function inputGameOrderDtl_frm(packet){

  Url = "/Ajax/GameTitleMenu/inputGameOrderDtl_frm.asp"
  var gameType = $( "#gameType" ).val();
  var gender = $( "#gender" ).val();
  var orderNumber = $( "#orderNumber" ).val();

  packet.CMD = CMD_INSERTGAMEORDERDTL;
  packet.tgameType = gameType;
  packet.tgender = gender;
  packet.torderNumber = orderNumber;

  if(orderNumber == ""){
    alert("오더순서를 선택하세요.");
    return;
  }

  SendPacket(Url, packet);
};

function updateGameOrderDtl_frm(packet){
  Url = "/Ajax/GameTitleMenu/updateGameOrderDtl_frm.asp"

  var selGroupGameOrderIDX = $( "#selGroupGameOrderIDX" ).val();
  var gameType = $( "#gameType" ).val();
  var gender = $( "#gender" ).val();
  var orderNumber = $( "#orderNumber" ).val();

  if(selGroupGameOrderIDX == ""){
    alert("수정할 오더를 선택하세요.");
    return;
  }

  packet.CMD = CMD_UPDATEGAMEORDERDTL;
  packet.tGroupGameOrderIDX = selGroupGameOrderIDX;
  packet.tgameType = gameType;
  packet.tgender = gender;
  packet.torderNumber = orderNumber;
  SendPacket(Url, packet);
};

function delGameOrderDtl_frm(packet) {
  Url = "/Ajax/GameTitleMenu/delGameOrderDtl_frm.asp"
  var selGroupGameOrderIDX = $( "#selGroupGameOrderIDX" ).val();

  if(selGroupGameOrderIDX == ""){
    alert("삭제할 오더를 선택하세요.");
    return;
  }

  packet.CMD = CMD_DELGAMEORDERDTL;
  packet.tGroupGameOrderIDX = selGroupGameOrderIDX;
  SendPacket(Url, packet);
};
