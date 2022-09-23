
////////////명령어////////////
CMD_SELGAMETITLE = 1;
CMD_SELGAMELEVEL= 2;
CMD_SELSEARCH = 3;
CMD_GAMERESULTOPERATE = 4;
CMD_SEARCHGAMETITLE = 5;
CMD_CHANGEDGIFT = 5;
CMD_POPUPGIFTSIGN = 7;
CMD_GIFTSIGNATURE = 8;
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
    case CMD_SELSEARCH:
    if(dataType == "html")
    {
        $('#DP_SelBox').html(htmldata); 
    }
    break;
    case CMD_SELGAMELEVEL:
    if(dataType == "html")
    {
        $('#divGameLevelMenu').html(htmldata); 
    }
    break;
    case CMD_POPUPGIFTSIGN:
    if(dataType == "html")
    {
        $('#DP_PopupGiftSign').html(htmldata); 
    }
    break;    
    case CMD_GIFTSIGNATURE:
    {
      OnSearchClick();
    }
    break;  

    
    

    case CMD_GAMERESULTOPERATE :
    if(dataType == "html")
    {
        $('#tbGameGift').html(htmldata); 
    }
    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////

function OnGameTitleChanged(value)
{ 
  Url = "/Ajax/GameTitleMenu/OnGameTitleChanged.asp"
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

  Url = "/Ajax/GameTitleMenu/OnGameTitleChanged.asp"

  packet.CMD = CMD_SELGAMELEVEL;
  packet.tGroupGameGb = GroupGameGbValue;
  packet.tTeamGb = TeamGbValue;
  packet.tPlayTypeSex = PlayTypeSexValue;
  packet.tLevel = LevelValue;
  //console.log(packet);
  SendPacket(Url, packet);
};

function OnSearchChanged()
{ 
  GameTitleIDX = $("#selGameTitleIdx").val();
  GameDay = $("#selGameDay").val();
  StadiumIDX = $("#selStadiumIDX").val();
  SearchName = $("#txtSearchName").val();
  
  StadiumNumber = $("#selStadiumNumber").val();
  GroupGameGB = $("#selGroupGameGb").val();
  TotalClass = $("#selTotalClass").val();
  
  

  Url = "/Ajax/GameTitleMenu/Select_GameGift.asp"

  var packet = {};

  packet.CMD = CMD_SELSEARCH;
  packet.tGameTitleIDX = GameTitleIDX;
  packet.tGameDay = GameDay;
  packet.tStadiumIDX = StadiumIDX;
  packet.tStadiumNumber = StadiumNumber;
  packet.tSearchName = SearchName;
  packet.tGroupGameGB = GroupGameGB;
  packet.tTotalClass = TotalClass;
  //console.log(packet);
  SendPacket(Url, packet);

};


function OnGameTitleLevelChanged()
{ 
  GameTitleIDX = $("#selGameTitleIdx").val();
  Url = "/Ajax/GameTitleMenu/Select_GameGift.asp"
  var packet = {};
  packet.CMD = CMD_SELSEARCH;
  packet.tGameTitleIDX = GameTitleIDX;
  SendPacket(Url, packet);
};



//경기진행현황 리스트
function OnSearchClick(){
  var packet = {};

  GameTitleIDX = $("#selGameTitleIdx").val();
  GameDay = $("#selGameDay").val();
  StadiumIDX = $("#selStadiumIDX").val();
  StadiumNumber = $("#selStadiumNumber").val();
  SearchName = $("#txtSearchName").val();
  GroupGameGB = $("#selGroupGameGb").val();
  TotalClass= $("#selTotalClass").val();
  Url = "/Ajax/GameTitleMenu/GameGift_Operate.asp"

  packet.CMD = CMD_GAMERESULTOPERATE;
  packet.tGameTitleIDX = GameTitleIDX;
  packet.tGameDay = GameDay;
  packet.tStadiumIDX = StadiumIDX;
  packet.tStadiumNumber = StadiumNumber;
  packet.tSearchName = SearchName;
  packet.tGroupGameGB = GroupGameGB;
  packet.tTotalClass = TotalClass;

  SendPacket(Url, packet);
};    

function OnTotalTeamRankClick()
{


}


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

  tGameTitleIdx = $("#selGameTitleIdx").val(); 
  var popUrl = addrs; //팝업창에 출력될 페이지 URL
  var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
  window.open(popUrl,"JoResult",popOption);

  post_to_url_popup('JoResult', './' + addrs, { 'tGameTitleIdx': tGameTitleIdx});

  
};

function OnGiftStatusChanged(GameLevelDtlidx,RequestIDX,GroupGameGb) {
  
  var packet = {};
  GameTitleIDX = $("#selGameTitleIdx").val();
  var giftCheckBox = document.getElementById(GameLevelDtlidx + "_" + RequestIDX);

  var checkResut = "N"

  Url = "/Ajax/GameTitleMenu/OnGiftStatusChanged.asp"

  if(giftCheckBox.checked) {
    checkResut = "Y"
  }
  else {
    checkResut ="N"
  }

  packet.CMD = CMD_CHANGEDGIFT;
  packet.tGameTitleIDX = GameTitleIDX;
  packet.tGameLevelDtlidx = GameLevelDtlidx;
  packet.tRequestIDX = RequestIDX;
  packet.tGiftCheck = checkResut;
  packet.tGroupGameGb = GroupGameGb;
  //console.log(packet);
  SendPacket(Url, packet);
}

function PopupGiftSign(GameLevelDtlidx,RequestIDX,GroupGameGb,canvasYN) {
  
  var packet = {};
  GameTitleIDX = $("#selGameTitleIdx").val();

  Url = "/Ajax/GameTitleMenu/Popup_GameGift.asp"

  packet.CMD = CMD_POPUPGIFTSIGN;
  packet.tGameTitleIDX = GameTitleIDX;
  packet.tGameLevelDtlidx = GameLevelDtlidx;
  packet.tRequestIDX = RequestIDX;
  packet.tGroupGameGb = GroupGameGb;
  packet.tCanvasYN = canvasYN;  
  
  //console.log(packet);
  SendPacket(Url, packet);
}


function prc_GiftSignature(gameleveldtlidx, reqeustidx, groupgamegb) {


  if($("#DP_GiftSignature").length < 1){
    return;
  }



  GameLevelDtlIDX = gameleveldtlidx;
  RequestIDX = reqeustidx;
  GroupGameGb = groupgamegb;

  var packet = {};

  Url ="/ajax/GameTitleMenu/SignatureGiftWrite.asp"


  packet.CMD = CMD_GIFTSIGNATURE;
  packet.GameLevelDtlIDX = GameLevelDtlIDX;
  packet.RequestIDX = RequestIDX;
  packet.GroupGameGb = GroupGameGb;
  packet.SignData = canvas.toDataURL();;


  SendPacket(Url, packet);
  
}  

function onSignDeleteClick(){
  
  var strHTML = "<canvas id='DP_GiftSignature' width='370' height='160'></canvas>";

  $("#DP_AREA_SIGN").html(strHTML);

}


////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function(){
  initSearchControl();
  OnSearchClick();
};

function initSearchControl()
{
  $( "#strGameTtitle" ).autocomplete({
    source : function( request, response ) {
      $.ajax(
        {
            type: 'post',
            url: "../../Ajax/GameTitleMenu/searchGameTitle.asp",
            dataType: "json",
            data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHGAMETITLE, "SVAL":request.term}) },
            success: function(data) {
                //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                response(
                    $.map(data, function(item) {
                        return {
                            label: item.gameTitleName + "(" + item.gameS + "~" + item.gameE + ")" + ", 번호 : " + item.uidx,
                            value: item.gameTitleName,
                            tidx : item.uidx,
                            gameTitleName : item.gameTitleName,
                            crypt_tidx : item.crypt_uidx
                        }
                    })
                );
            }
        }
      );
    },
        //조회를 위한 최소글자수
        minLength: 1,
        select: function( event, ui ) {
          var obj = {}
          
          obj.CMD = CMD_SEARCHGAMETITLE;
          obj.tIdx = ui.item.tidx;
          obj.crypt_tIdx = ui.item.crypt_tidx;
          obj.tGameTitleName = ui.item.gameTitleName;

          $("#selGameTitleIdx").val(obj.crypt_tIdx);
          OnGameTitleLevelChanged();
          
        }
    });
}


/*

href_Move = function(hrefMove){
  tGameTitleIdx = $("#selGameTitleIdx").val(); 
  GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
  PlayTypeSexValue = $("#selPlayTypeSex").val();
  TeamGbValue = $("#selTeamGb").val();
  LevelValue = $("#selLevel").val();
  if (hrefMove == "Operate.asp")
  {
    post_to_url('./' + hrefMove, { 'GameTitle': tGameTitleIdx,'GroupGameGb': GroupGameGbValue,'TeamGb': TeamGbValue,'Level': LevelValue, 'PlayType': PlayTypeSexValue}); 
  }
  else
  {
    post_to_url('./' + hrefMove, { 'tGameTitleIdx': tGameTitleIdx,'tGroupGameGb': GroupGameGbValue,'tTeamGb': TeamGbValue,'tLevel': LevelValue, 'tPlayTypeSex': PlayTypeSexValue}); 
  }
};

*/

