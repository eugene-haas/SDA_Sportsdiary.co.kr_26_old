
////////////명령어////////////
CMD_SELGAMETITLE = 1;
CMD_SELGAMELEVEL= 2;
CMD_SELSEARCH = 3;
CMD_GAMERESULTOPERATE = 4;
CMD_SEARCHGAMETITLE = 5;
CMD_CHANGEDGIFT = 5;
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
    case CMD_GAMERESULTOPERATE :
    if(dataType == "html")
    {
        $('#tbGameGift').html(htmldata); 
        $("#spanSearchResult").text("검색 완료되었습니다.");
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
  PlayLevelType = $("#selPlayLevelType").val();
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
  packet.tPlayLevelType = PlayLevelType;
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
  PlayLevelType = $("#selPlayLevelType").val();
  GroupGameGB = $("#selGroupGameGb").val();
  TotalClass= $("#selTotalClass").val();
  
  Url = "/Ajax/GameTitleMenu/GameGift_Operate.asp"

  packet.CMD = CMD_GAMERESULTOPERATE;
  packet.tGameTitleIDX = GameTitleIDX;
  packet.tGameDay = GameDay;
  packet.tStadiumIDX = StadiumIDX;
  packet.tStadiumNumber = StadiumNumber;
  packet.tSearchName = SearchName;
  packet.tPlayLevelType = PlayLevelType;
  packet.tGroupGameGB = GroupGameGB;
  packet.tTotalClass = TotalClass;

  SendPacket(Url, packet);
  $("#spanSearchResult").text("검색이 시작되었습니다. 잠시만 기다려주세요");
  
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

////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function(){
  initSearchControl();
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

