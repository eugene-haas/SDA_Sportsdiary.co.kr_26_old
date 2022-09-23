
////////////명령어////////////
CMD_SELGAMETITLE = 1;
CMD_SELGAMELEVEL= 2;
CMD_SELSEARCH = 3;
CMD_GAMEORDEROPERATE = 4;
CMD_GROUPORDER_POPUP = 5;
CMD_POPUPGROUPRESULT = 6;

CMD_SELTEAMTEMP = 7;
CMD_SEARCHGAMETITLE = 22;

CMD_URLUPDATE = 33;


////////////명령어////////////

////////////그외경기결과 체크////////////
var ResultChk = {
  Team1: "",
  TeamDtl1: "",
  TeamName1: "",
  Team2: "",
  TeamDtl2: "",      
  TeamName2: "",
  ResultType: "",
  ResultTypeNM: "",
  ResultTypeDtl: "",
  ResultTypeDtlNM: ""
}  
////////////그외경기결과 체크////////////

////////////개인전 포인트 체크////////////
var PointChk = {
  SetNum : "",
  TourneyGroupIDX : "",
  Select_ResultPoint : ""
}  
////////////개인전 포인트 체크////////////

////////////개인전 그외경기결과 체크////////////
var AnthResultChk = {
  TourneyGroupIDX1 : "",
  TourneyGroupIDX2 : "",
  AnthResult : "",
  AnthResultDtl : ""
}  
////////////개인전 그외경기결과 체크////////////

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
        $('#tbGameOrder').html(htmldata); 



        $("#DP_TotalCnt").html(jsondata.TotalGameCnt); 
        $("#DP_RestCnt").html(jsondata.RestGameCnt); 

    }
    break;        
    //단체전구성 팝업
    case CMD_GROUPORDER_POPUP:
    if(dataType == "html")
    {
        
        //$('#DP_GroupOrder_Popup').html(htmldata); 
        $('#DP_GroupOrder_Popup').html(htmldata); 

        selTeamTemp(jsondata.tGameLevelDtlIDX, jsondata.tTeamGameNum);
    }
    break;    


    
    case CMD_SELTEAMTEMP:
    if(dataType == "html")
    {
        $("#DP_GroupPlayerList").html(htmldata);
    }
    
    break; 
     

    case CMD_POPUPGROUPRESULT:
    if(dataType == "html")
    { 

     //$("#DP_GroupResult").html(htmldata);
     $("#DP_GroupResult_Popup").html(htmldata);
     
    }
    
    break;    

    case CMD_URLUPDATE:
    if(dataType == "json")
    { 

     //$("#DP_GroupResult").html(htmldata);
     alert('저장완료');
     return;
     
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
  Url = "/Ajax/GameTitleMenu/OnGameTitleChanged.asp"
  var packet = {};
  packet.CMD = CMD_SELGAMETITLE;
  packet.tGameTitleIdx = value;
  SendPacket(Url, packet);
};


function OnAnthTorneyGroupChecked(str, tourneygroupidx)
{ 
  for (var i = 1; i <= 2; i++) {
      if (i == parseInt(str)) {
          if ($("#DP_IMGAnthCheck_" + str).attr("src") == "/include/modal/img/btn_icon1.png") {
            
              $("#DP_A_AnthCheck_" + str).attr("class", "red_btn");
              $("#DP_IMGAnthCheck_" + str).attr("src", "/include/modal/img/btn_icon2.png");
              //$("#DP_GroupchkIMG_" + str).attr("src", "./images/tournerment/score/ic_chk_on.png");
              if (str == "1") {
                  AnthResultChk.TourneyGroupIDX1 = tourneygroupidx;
                  
              }
              else {
                  AnthResultChk.TourneyGroupIDX2 = tourneygroupidx;
              }
          }
          else {
              
            $("#DP_A_AnthCheck_" + str).attr("class", "whith_btn");
              $("#DP_IMGAnthCheck_" + str).attr("src", "/include/modal/img/btn_icon1.png");
              //$("#DP_GroupchkIMG_" + str).attr("src", "./images/tournerment/score/ic_chk.png");
              if (str == "1") {
                  AnthResultChk.TourneyGroupIDX1 = "";
              }
              else {
                  AnthResultChk.TourneyGroupIDX2 = "";
              }
          }
      }
  }

  console.log(AnthResultChk);

};


//리스트상의 경기결과입력
function OnGroupResultBtnClick(gameleveldtlidx, teamgamenum, gamenum){

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;

  //경기진행결과페이지라는 구분
  PageGubun = "OrderPage";  

  Url = "/Ajax/GameTitleMenu/Popup_GroupGameURL.asp"
  console.log("OnGroupResultBtnClick");

  packet.CMD = CMD_POPUPGROUPRESULT;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tGameNum = GameNum;
  packet.tPageGubun = PageGubun;

  SendPacket(Url, packet);
};    


//리스트상의 경기결과입력
function onUrlInputBtnClick(gameleveldtlidx, teamgamenum, gamenum, idurl){

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;
  MovieURL = $("#"+idurl).val();

  Url = "/Ajax/GameTitleMenu/GameURLUpdate.asp"

  packet.CMD = CMD_URLUPDATE;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tGameNum = GameNum;
  packet.tMovieURL = MovieURL;

  SendPacket(Url, packet);
};    

//리스트상의 경기결과입력
function onYoutubeUrlInputBtnClick(gameleveldtlidx, teamgamenum, gamenum, idurl){

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;
  MovieURL = $("#"+idurl).val();

  Url = "/Ajax/GameTitleMenu/GameYouTubeURLUpdate.asp"

  packet.CMD = CMD_URLUPDATE;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tGameNum = GameNum;
  packet.tMovieURL = MovieURL;

  SendPacket(Url, packet);
};    

function OnAnthResultTypeChecked(str, resulttype)
{ 
  for (var i = 1; i <= 4; i++) {

    if (i == parseInt(str)) {

        console.log("선택");OnGroupResultBtnClick 
        if ($("#DP_AnthResultType_" + str).attr("class") == "white_btn") {
            $("#DP_AnthResultType_" + str).attr("class", "red_btn");
            AnthResultChk.AnthResult = resulttype;


        }
        else {
            $("#DP_AnthResultType_" + str).attr("class", "white_btn");
            AnthResultChk.AnthResult = "";

        }

    }
    else{
      $("#DP_AnthResultType_" + i).attr("class", "white_btn");
    }

  }

  console.log(AnthResultChk);

};

function OnAnthResultDtlTypeChecked(str, resulttypedtl)
{ 
  for (var i = 1; i <= 4; i++) {

    if (i == parseInt(str)) {

        console.log("선택");
        if ($("#DP_AnthResultDtlType_" + str).attr("class") == "white_btn") {
            $("#DP_AnthResultDtlType_" + str).attr("class", "red_btn");
            AnthResultChk.AnthResultDtl = resulttypedtl;


        }
        else {
            $("#DP_AnthResultDtlType_" + str).attr("class", "white_btn");
            AnthResultChk.AnthResultDtl = "";

        }

    }
    else{
      $("#DP_AnthResultDtlType_" + i).attr("class", "white_btn");
    }

  }

  console.log(AnthResultChk);

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
  StadiumNumber = $("#selStadiumNumber").val();
  SearchName = $("#txtSearchName").val();
  PlayLevelType = $("#selPlayLevelType").val();
  GroupGameGB = $("#selGroupGameGb").val();

  Url = "/Ajax/GameTitleMenu/Select_GameOrder.asp"

  var packet = {};

  packet.CMD = CMD_SELSEARCH;
  packet.tGameTitleIDX = GameTitleIDX;
  packet.tGameDay = GameDay;
  packet.tStadiumIDX = StadiumIDX;
  packet.tStadiumNumber = StadiumNumber;
  packet.tSearchName = SearchName;
  packet.tPlayLevelType = PlayLevelType;
  packet.tGroupGameGB = GroupGameGB;
  //console.log(packet);
  SendPacket(Url, packet);

};



//경기진행현황 리스트
function OnSearchClick(liveSearch = false){

    if(liveSearch == false) 
      $( '#tbGameOrder').empty();

    var packet = {};

    GameTitleIDX = $("#selGameTitleIdx").val();
    GameDay = $("#selGameDay").val();
    StadiumIDX = $("#selStadiumIDX").val();
    StadiumNumber = $("#selStadiumNumber").val();
    SearchName = $("#txtSearchName").val();
    PlayLevelType = $("#selPlayLevelType").val();
    GroupGameGB = $("#selGroupGameGb").val();

    IngType = $("#selIngType").val();
    GameURLYN = $("#selGameURLYN").val();
  
    Url = "/Ajax/GameTitleMenu/GameURL_Operate.asp"


    packet.CMD = CMD_GAMEORDEROPERATE;
    packet.tGameTitleIDX = GameTitleIDX;
    packet.tGameDay = GameDay;
    packet.tStadiumIDX = StadiumIDX;
    packet.tStadiumNumber = StadiumNumber;
    packet.tSearchName = SearchName;
    packet.tPlayLevelType = PlayLevelType;
    packet.tGroupGameGB = GroupGameGB;

    packet.tIngType = IngType;
    packet.tGameURLYN = GameURLYN;

    SendPacket(Url, packet);
};    



function OnGroupResultDtlBtnClick(gameleveldtlidx, teamgamenum, gamenum, setnum, tourneygroupidx){

  $(".winner-sign").modal("hide");
  $(".play_detail_modal").modal();
  OnResultBtnClick(gameleveldtlidx, teamgamenum, gamenum, setnum, tourneygroupidx);

  //개인전 그외경기결과 선택했던것 리셋
  AnthResultChk.TourneyGroupIDX1 = "";
  AnthResultChk.TourneyGroupIDX2 = "";
  AnthResultChk.AnthResult = "";
  AnthResultChk.AnthResultDtl = "";
  
}


function checkall_list(){
  //만약 전체 선택 체크박스가 체크된상태일경우 
  console.log($("#all_reqidx").prop("checked"));
    if($("#all_reqidx").prop("checked")) 
    { 
        $("input[name=chk_Operate]").prop("checked",true); 
    }
    else { 
        $("input[name=chk_Operate]").prop("checked",false); 
    }
  
}
  
  

//경기진행현황 리스트
function popup_GameOrder_Group(gameleveldtlidx, teamgamenum, gamenum){

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;
 
  Url = "/Ajax/GameTitleMenu/Popup_GameOrderGroup.asp"

  packet.CMD = CMD_GROUPORDER_POPUP;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tGameNum = GameNum;

  SendPacket(Url, packet);

};    



function selTeamTemp(gameleveldtlidx, teamgamenum){

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
 
  Url = "/Ajax/GameTitleMenu/selTourneyTeamTemp.asp"

  packet.CMD = CMD_SELTEAMTEMP;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;

  SendPacket(Url, packet);

};

function OnPlayerResultClosed(groupgamegb){



  if(groupgamegb == "F9A43D4DE4191C125B08095CC465CD4B" || groupgamegb == "B0030001"){

    $(".play_detail_modal").modal("hide");
  }
  else{

      $(".winner-sign").modal();
      $(".play_detail_modal").modal("hide");
  }


};

////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function(){
  OnSearchClick();
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

                $.map(data, function(item) {
                  if(item.EnterType == "A"){
                    $("#DP_Print_Ama").css("display","");
                    //$("#DP_Print_Elite").css("display","none");
                  }
                  else if(item.EnterType == "E"){
                    $("#DP_Print_Ama").css("display","none");
                    //$("#DP_Print_Elite").css("display","");
                  }
                  else if(item.EnterType == "M"){
                    $("#DP_Print_Ama").css("display","");
                    $("#DP_Print_Elite").css("display","");
                  }                                    
                })



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
          OnGameTitleChanged(obj.crypt_tIdx);
          OnSearchClick();
        }
    });
}

