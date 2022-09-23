
////////////명령어////////////

CMD_LEVELSUMSELECTLIST = 1;
CMD_LEVELSUMLIST = 2;
CMD_LEVELSUM = 3;

////////////명령어////////////



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
  post_to_url('./level.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx,'pType': 'level', 'i2': NowPage});
};

href_back2 = function(tIdx,tPGameLevelIdx, tGameLevelIdx, NowPage){
  post_to_url('./level.asp', { 'tIdx': tIdx,'tPGameLevelIdx':tPGameLevelIdx,'tGameLevelIdx': tGameLevelIdx,'pType': 'plevel' ,'i2': NowPage});
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

  tGameTitleIdx = $("#selGameIdx").val(); 
  var popUrl = addrs; //팝업창에 출력될 페이지 URL
  var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
  window.open(popUrl,"MoveResult",popOption);

  post_to_url_popup('MoveResult', './' + addrs, { 'tGameTitleIdx': tGameTitleIdx});

  
};

