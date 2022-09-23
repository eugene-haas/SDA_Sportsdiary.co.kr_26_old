
////////////명령어////////////
CMD_SELGAMETITLE = 1;
CMD_SELGAMELEVEL= 2;
CMD_SELSEARCH = 3;
CMD_GAMEORDEROPERATE = 4;
CMD_GROUPORDER_POPUP = 5;

CMD_INPUTTOURNEYTEAM = 6;
CMD_SELTEAMTEMP = 7;
CMD_DELETETOURNEYTEAM = 8;
CMD_TEAMTEMPCOMPLETE = 9;
CMD_ANOTHERGROUPRESULT= 10
CMD_POPUPANOTHERGROUPRESULT = 11;
CMD_POPUPGROUPRESULT = 12;
CMD_POPUPRESULT = 13;
CMD_EDITRESULT = 14;
CMD_TEAMGAMECOMPLETE = 15;
CMD_SIGNATURE = 16;
CMD_SIGNATUREDELETE = 17;
CMD_SETRESULT = 18;
CMD_GameOrderPaper = 19;
CMD_POPUPPLAYERDTL = 20;
CMD_ANOTHERRESULT = 21;
CMD_SEARCHGAMETITLE = 22;
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

        $('#tbGameResult').html(htmldata); 
    }
    break;        
    //단체전구성 팝업
    case CMD_GROUPORDER_POPUP:
    if(dataType == "html")
    {
        
        $('#DP_GroupOrder_Popup').html(htmldata); 

        selTeamTemp(jsondata.tGameLevelDtlIDX, jsondata.tTeamGameNum);
    }
    break;    

    case CMD_INPUTTOURNEYTEAM:
    if(dataType == "json")
    {

      if(jsondata.result == "1"){
        alert("이미 선수가 배치되어 있습니다. 해당선수를 재배치하시려면 삭제 후, 배치하시기 바랍니다.");
      }

      popup_GameOrder_Group(jsondata.tGameLevelDtlIDX, jsondata.tTeamGameNum, '0')
     
        
    }
    break; 

    case CMD_DELETETOURNEYTEAM:
    if(dataType == "json")
    {

      popup_GameOrder_Group(jsondata.tGameLevelDtlIDX, jsondata.tTeamGameNum, '0')
     
        
    }
    break;     
    
    case CMD_SELTEAMTEMP:
    if(dataType == "html")
    {
        $("#DP_GroupPlayerList").html(htmldata);
    }
    
    break; 

    case CMD_ANOTHERGROUPRESULT:
    if(dataType == "json")
    { 


      if(jsondata.result == "0"){
          alert('해당 경기결과 처리가 완료되었습니다.');
          
      }
      
      OnSearchClick();
      $(".group_modal").modal("hide");
      $(".etc-judge").modal("hide");
    }
    
    break;     

    case CMD_POPUPANOTHERGROUPRESULT:
    if(dataType == "html")
    { 

      $("#DP_GroupAnotherResult").html(htmldata);

      $(".etc-judge").modal();
    }
    
    break;         

    case CMD_POPUPRESULT:
    if(dataType == "html")
    { 

      $("#DP_Result").html(htmldata);

      AnthResultChk.TourneyGroupIDX1 = jsondata.AnthTourneyGroupIDX1;
      AnthResultChk.TourneyGroupIDX2 = jsondata.AnthTourneyGroupIDX2;
      AnthResultChk.AnthResult = jsondata.AnthResult;
      AnthResultChk.AnthResultDtl = jsondata.AnthResultDtl;

      console.log(AnthResultChk);      
    }
    
    break;         

    case CMD_POPUPGROUPRESULT:
    if(dataType == "html")
    { 

     $("#DP_GroupResult_Popup").html(htmldata);
    }
    
    break;        

    case CMD_POPUPPLAYERDTL:
    if(dataType == "html")
    { 

     $("#DP_Playerdtl").html(htmldata);
    }
    
    break;           
    
    case CMD_EDITRESULT:
    if(dataType == "json")
    { 
      //싸인저장
      prc_Signature(jsondata.GameLevelDtlIDX, jsondata.TeamGameNum, jsondata.GameNum, jsondata.WIN_TourneyGroupIDX, CMD_EDITRESULT ,jsondata.GroupGameGb);

      //OnResultBtnClick(jsondata.GameLevelDtlIDX, jsondata.TeamGameNum, jsondata.GameNum, jsondata.SetNum, jsondata.TourneyGroupIDX)

     
    }
    
    break;    

    case CMD_ANOTHERRESULT:
    if(dataType == "json")
    { 
      //싸인저장
      
      //prc_Signature(jsondata.GameLevelDtlIDX, jsondata.TeamGameNum, jsondata.GameNum, jsondata.WIN_TourneyGroupIDX, CMD_EDITRESULT,jsondata.GroupGameGb);

      //OnResultBtnClick(jsondata.GameLevelDtlIDX, jsondata.TeamGameNum, jsondata.GameNum, jsondata.SetNum, jsondata.TourneyGroupIDX)


      if(jsondata.GroupGameGb == "B0030001"){

        OnSearchClick();
        $(".play_detail_modal").modal("hide");
      }
      else{
          OnGroupResultBtnClick(jsondata.GameLevelDtlIDX, jsondata.TeamGameNum, jsondata.GameNum);      
          $(".winner-sign").modal();
          $(".play_detail_modal").modal("hide");
      }

      

      if($("#DP_Signature").length < 1){
        return;
      } 
      

    }    

    break;     
    
    case CMD_SETRESULT:
    if(dataType == "json")
    { 

      OnResultBtnClick(jsondata.GameLevelDtlIDX, jsondata.TeamGameNum, jsondata.GameNum, jsondata.SetNum, jsondata.TourneyGroupIDX)

    }
    
    break;          
    
    case CMD_TEAMTEMPCOMPLETE:
    if(dataType == "json")
    { 

      alert("단체전 오더 등록이 완료되었습니다.");

      $(".group-order").modal("hide");

      OnSearchClick();
    }
    
    
    break;       
    
    case CMD_TEAMGAMECOMPLETE:
    if(dataType == "json")
    { 
      if(jsondata.result == "0"){
          alert('해당 단체전 경기결과 처리가 완료되었습니다.');
          
      }
      OnSearchClick();
      //$(".winner-sign").modal("hide");

      $(".group_modal").modal("hide");
    }    
    
    break;       

    case CMD_SIGNATURE:
    if(dataType == "json")
    { 
      if(jsondata.before_CMD == CMD_EDITRESULT){

        //개인전
        if(jsondata.groupgamegb == "B0030001"){

          $(".play_detail_modal").modal("hide");
        }
        else{
            OnGroupResultBtnClick(jsondata.GameLevelDtlIDX, jsondata.TeamGameNum, jsondata.GameNum);

            //$(".winner-sign").modal();
            $(".play_detail_modal").modal("hide");
        }
      

      }
    }  

    case CMD_SIGNATUREDELETE:
    if(dataType == "json")
    { 
      OnResultBtnClick(jsondata.GameLevelDtlIDX, jsondata.TeamGameNum, jsondata.GameNum, jsondata.SetNum, jsondata.TourneyGroupIDX);
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

function OnAnthResultTypeChecked(str, resulttype)
{ 
  for (var i = 1; i <= 4; i++) {

    if (i == parseInt(str)) {

        console.log("선택");
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

function onPointCheckClick(obj, str, jumsu, gameleveldtlidx, teamgamenum, gamenum){


  if(PointChk.TourneyGroupIDX == ""){
    alert("수정하실 팀을 선택하세요.");
    return;
  }  

  for(i=0;i<=$("a[name=DP_WinnerPointChk]").length - 1;i++){
    
    $("a[name=DP_WinnerPointChk]:eq("+ i +")").css("background-color", "#bfbfbf");
 
   }    

  for(i=0;i<=$("a[name=DP_PointChk]").length - 1;i++){
    
    $("a[name=DP_PointChk]:eq("+ i +")").css("background-color", "#bfbfbf");
 
   } 

   $(obj).css("background-color", "#ec0a2e");

   PointChk.Select_ResultPoint = jumsu;

   var packet = {};    

   Url ="/Ajax/GameTitleMenu/GameSetEnd.asp"
 
   packet.CMD = CMD_SETRESULT;
 
   packet.GameLevelDtlIDX = gameleveldtlidx;
   packet.TeamGameNum = teamgamenum;
   packet.GameNum = gamenum;
   packet.SetNum = PointChk.SetNum;
   packet.TourneyGroupIDX = PointChk.TourneyGroupIDX;
   packet.Select_ResultPoint = PointChk.Select_ResultPoint;
 
   SendPacket(Url, packet);     
   
}

function onEditResultClick(gameleveldtlidx, teamgamenum, gamenum, gameround){

  var packet = {};    

  //그외 판정결과 선택 시,
  if(AnthResultChk.TourneyGroupIDX1 != "" || AnthResultChk.TourneyGroupIDX2 != ""){
    if(AnthResultChk.AnthResult == ""){
      alert('그외판정 결과 선택 시에는 판정 항목을 골라주세요.');
      return;
    }
    if(AnthResultChk.AnthResultDtl == ""){
      alert('그외판정 결과 선택 시에는 판정 사유를 골라주세요.');
      return;
    }    

    Url ="/Ajax/GameTitleMenu/GameEnd_Another.asp";
    packet.CMD = CMD_ANOTHERRESULT;


  }
  else{

    Url ="/Ajax/GameTitleMenu/GameEnd_List.asp";
    packet.CMD = CMD_EDITRESULT;


  }

  packet.GameLevelDtlIDX = gameleveldtlidx;
  packet.TeamGameNum = teamgamenum;
  packet.GameNum = gamenum;
  packet.GameRound = gameround;


  

  packet.AnthTourneyGroupIDX1 = AnthResultChk.TourneyGroupIDX1;
  packet.AnthTourneyGroupIDX2 = AnthResultChk.TourneyGroupIDX2;
  packet.AnthResult = AnthResultChk.AnthResult;
  packet.AnthResultDtl = AnthResultChk.AnthResultDtl;  

  SendPacket(Url, packet);     
  
}

function prc_Signature(gameleveldtlidx, teamgamenum, gamenum, tourneygroupidx, before_CMD, groupgamegb) {

  //개인전
  if(groupgamegb == "F9A43D4DE4191C125B08095CC465CD4B"){

    $(".play_detail_modal").modal("hide");
  }
  else{
      OnGroupResultBtnClick(jsondata.GameLevelDtlIDX, jsondata.TeamGameNum, jsondata.GameNum);

      //$(".winner-sign").modal();
      $(".play_detail_modal").modal("hide");
  }

  if($("#DP_Signature").length < 1){
    return;
  }

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;

  var packet = {};

  Url ="/ajax/GameTitleMenu/SignatureWrite.asp"

  packet.CMD = CMD_SIGNATURE;
  packet.GameLevelDtlIDX = GameLevelDtlIDX;
  packet.TeamGameNum = TeamGameNum;
  packet.GameNum = GameNum;
  packet.SignData = canvas.toDataURL();;
  packet.TourneyGroupIDX = tourneygroupidx;
  packet.before_CMD = before_CMD;
  
  SendPacket(Url, packet);
  
}  


function onSignDeleteClick(gameleveldtlidx, teamgamenum, gamenum) {

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;

  var packet = {};

  Url ="/ajax/GameTitleMenu/SignatureDelete.asp"

  packet.CMD = CMD_SIGNATUREDELETE;
  packet.GameLevelDtlIDX = GameLevelDtlIDX;
  packet.TeamGameNum = TeamGameNum;
  packet.GameNum = GameNum;

  SendPacket(Url, packet);
  
}  

/*
//그외경기결과 팀선택
function cli_GroupResult (str, team, teamdtl, teamname) {
  $("#DP_Group1").removeClass("on");
  $("#DP_Group2").removeClass("on");
  $("#DP_Group"+ str).addClass("on");
  
  
  for (var i = 1; i <= 2; i++) {
    if (i == parseInt(str)) {
        if ($("#DP_Group" + str).attr("class") == "btn btn-judge") {
            $("#DP_Group" + str).attr("class", "btn btn-judge on");
            //$("#DP_GroupchkIMG_" + str).attr("src", "./images/tournerment/score/ic_chk_on.png");
            if (str == "1") {
                ResultChk.Team1 = team;
                ResultChk.TeamDtl1 = teamdtl;
                ResultChk.TeamName1 = teamname;
                
            }
            else {
                ResultChk.Team2 = team;
                ResultChk.TeamDtl2 = teamdtl;
                ResultChk.TeamName2 = teamname;
            }
        }
        else {
            $("#DP_Group" + str).attr("class", "btn btn-judge");
            //$("#DP_GroupchkIMG_" + str).attr("src", "./images/tournerment/score/ic_chk.png");
            if (str == "1") {
                ResultChk.Team1 = "";
                ResultChk.TeamDtl1 = "";
                ResultChk.TeamName1 = "";
            }
            else {
                ResultChk.Team2 = "";
                ResultChk.TeamDtl2 = "";
                ResultChk.TeamName2 = "";
            }
        }
    }
  }

}
*/
//그외경기결과 팀선택
function cli_GroupResult (str, team, teamdtl, teamname) {
  for (var i = 1; i <= 2; i++) {
      if (i == parseInt(str)) {
          if ($("#DP_Group" + str).attr("class") == "btn btn-judge") {
              $("#DP_Group" + str).attr("class", "btn btn-judge on");
              //$("#DP_GroupchkIMG_" + str).attr("src", "./images/tournerment/score/ic_chk_on.png");
              if (str == "1") {
                  ResultChk.Team1 = team;
                  ResultChk.TeamDtl1 = teamdtl;
                  ResultChk.TeamName1 = teamname;
                  
              }
              else {
                  ResultChk.Team2 = team;
                  ResultChk.TeamDtl2 = teamdtl;
                  ResultChk.TeamName2 = teamname;
              }
          }
          else {
              $("#DP_Group" + str).attr("class", "btn btn-judge");
              //$("#DP_GroupchkIMG_" + str).attr("src", "./images/tournerment/score/ic_chk.png");
              if (str == "1") {
                  ResultChk.Team1 = "";
                  ResultChk.TeamDtl1 = "";
                  ResultChk.TeamName1 = "";
              }
              else {
                  ResultChk.Team2 = "";
                  ResultChk.TeamDtl2 = "";
                  ResultChk.TeamName2 = "";
              }
          }
      }
  }
  console.log(ResultChk);
}


//그외경기결과 1.판정결과 선택
function cli_GroupResultType (str, resulttype, resulttypenm) {
  

  for (var i = 1; i <= 3; i++) {

      if (i == parseInt(str)) {

          console.log("선택");
          if ($("#DP_ResultType" + str).attr("class") == "btn btn-judge") {
              $("#DP_ResultType" + str).attr("class", "btn btn-judge on");
              ResultChk.ResultType = resulttype;
              ResultChk.ResultTypeNM = resulttypenm;

          }
          else {
              $("#DP_ResultType" + str).attr("class", "btn btn-judge");
              ResultChk.ResultType = "";
              ResultChk.ResultTypeNM = resulttypenm;

          }

      }
      else{
        $("#DP_ResultType" + i).attr("class", "btn btn-judge");
      }

  }

}

//그외경기결과 1.판정결과 선택
function cli_GroupResultTypeDtl (str, resulttypedtl, resulttypedtlnm) {
  
  for (var i = 1; i <= 3; i++) {
      if (i == parseInt(str)) {
          if ($("#DP_ResultTypeDtl" + str).attr("class") == "btn btn-judge") {
              $("#DP_ResultTypeDtl" + str).attr("class", "btn btn-judge on");
              ResultChk.ResultTypeDtl = resulttypedtl;
              ResultChk.ResultTypeDtlNM = resulttypedtlnm;
          }
          else {
              $("#DP_ResultTypeDtl" + str).attr("class", "btn btn-judge");
              ResultChk.ResultTypeDtl = "";
              ResultChk.ResultTypeDtlNM = ""; 
          }
      }
      else{
        $("#DP_ResultTypeDtl" + i).attr("class", "btn btn-judge");
      }
  }

}

//그외경기결과 저장
function cli_AnotherResultComplete(gameleveldtlidx, gameround, teamgamenum, gamenum) {

  if (ResultChk.Team1 == "" && ResultChk.Team2 == "") {
      alert("판정할 팀을 선택하세요.");
      return;
  }
  if (ResultChk.ResultType == "") {
      alert("판정결과를 선택하세요.");
      return;
  }
  if (ResultChk.ResultTypeDtl == "") {
      alert("판정사유를 선택하세요.");
      return;
  }

  var strusername = "";

  if (ResultChk.Team1 != "" && ResultChk.Team2 != "") {
      strusername = "양측";
  }
  else {
      if (ResultChk.Team1 != "") {
          strusername = "[" + ResultChk.TeamName1 + "]";
      }
      if (ResultChk.Team2 != "") {
          strusername += "[" + ResultChk.TeamName2 + "]";
      }

  }

  var con_bool = confirm(strusername + "팀을 " + ResultChk.ResultTypeNM + "(" + ResultChk.ResultTypeDtlNM + ")" + "처리 합니다. 동의하시면 확인버튼을 눌러주세요.");

  if (con_bool == false) {
      return;
  }

  var packet = {};    

  Url ="/Ajax/GameTitleMenu/GameEnd_TeamAnother.asp"    

  packet.CMD = CMD_ANOTHERGROUPRESULT;

  packet.GameLevelDtlIDX = gameleveldtlidx;
  packet.GameRound = gameround;
  packet.TeamGameNum = teamgamenum;
  packet.GameNum = gamenum;
  packet.Anth_Team1 = ResultChk.Team1;
  packet.Anth_TeamDtl1 = ResultChk.TeamDtl1;
  packet.Anth_Team2 = ResultChk.Team2;
  packet.Anth_TeamDtl2 = ResultChk.TeamDtl2;
  packet.Anth_ResultType = ResultChk.ResultType;
  packet.Anth_ResultTypeDtl = ResultChk.ResultTypeDtl;

  SendPacket(Url, packet);
}

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
  
  Url = "/Ajax/GameTitleMenu/Select_GameResult.asp"

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

function OnTeamTempCompleteClick(gameleveldtlidx, teamgamenum){

  var con_test = confirm("단체전 오더 등록 시, 기존 등록된 기록이 삭제됩니다. 동의하시면 확인버튼을 눌러주세요.");

  if(con_test == false){
    return;
  }      

  GameTitleIDX = $("#selGameTitleIdx").val();
  GameDay = $("#selGameDay").val();

  var LPlayerA_length = $("input[name=LPlayerA]").length;
  var LPlayerB_length = $("input[name=LPlayerB]").length;
  var RPlayerA_length = $("input[name=RPlayerA]").length;
  var RPlayerB_length = $("input[name=RPlayerB]").length;
  
  var str_LPlayerA = ""
  var str_LPlayerB = ""
  var str_RPlayerA = ""
  var str_RPlayerB = ""

  for (i = 0; i < LPlayerA_length; i++) {
    if(i == 0){
      str_LPlayerA = $("input[name='LPlayerA']").eq(i).val();
    }
    else{
      str_LPlayerA += "," + $("input[name='LPlayerA']").eq(i).val();
    }
  }

  for (i = 0; i < LPlayerB_length; i++) {
    if(i == 0){
      str_LPlayerB = $("input[name='LPlayerB']").eq(i).val();
    }
    else{
      str_LPlayerB += "," + $("input[name='LPlayerB']").eq(i).val();
    }
  }

  for (i = 0; i < RPlayerA_length; i++) {
    if(i == 0){
      str_RPlayerA = $("input[name='RPlayerA']").eq(i).val();
    }
    else{
      str_RPlayerA += "," + $("input[name='RPlayerA']").eq(i).val();
    }
  }
  
  for (i = 0; i < RPlayerB_length; i++) {
    if(i == 0){
      str_RPlayerB = $("input[name='RPlayerB']").eq(i).val();
    }
    else{
      str_RPlayerB += "," + $("input[name='RPlayerB']").eq(i).val();
    }
  }  

  console.log("str_LPlayerA:" + str_LPlayerA);
  console.log("str_LPlayerB:" + str_LPlayerB);
  console.log("str_RPlayerA:" + str_RPlayerA);
  console.log("str_RPlayerB:" + str_RPlayerB);


  Url = "/Ajax/GameTitleMenu/inputTourneyTeam.asp"

  var packet = {};

  packet.CMD = CMD_TEAMTEMPCOMPLETE;
  packet.tGameLevelDtlIDX = gameleveldtlidx;
  packet.tTeamGameNum = teamgamenum;
  packet.tstr_LPlayerA = str_LPlayerA;
  packet.tstr_LPlayerB = str_LPlayerB;
  packet.tstr_RPlayerA = str_RPlayerA;
  packet.tstr_RPlayerB = str_RPlayerB;



  SendPacket(Url, packet);
}

//경기진행현황 리스트
function OnSearchClick(){

    $( '#tbGameResult').empty();

    var packet = {};

    GameTitleIDX = $("#selGameTitleIdx").val();
    GameDay = $("#selGameDay").val();
    StadiumIDX = $("#selStadiumIDX").val();
    StadiumNumber = $("#selStadiumNumber").val();
    SearchName = $("#txtSearchName").val();
    PlayLevelType = $("#selPlayLevelType").val();
    GroupGameGB = $("#selGroupGameGb").val();
    
    Url = "/Ajax/GameTitleMenu/GameResult_Operate.asp"


    packet.CMD = CMD_GAMEORDEROPERATE;
    packet.tGameTitleIDX = GameTitleIDX;
    packet.tGameDay = GameDay;
    packet.tStadiumIDX = StadiumIDX;
    packet.tStadiumNumber = StadiumNumber;
    packet.tSearchName = SearchName;
    packet.tPlayLevelType = PlayLevelType;
    packet.tGroupGameGB = GroupGameGB;
    SendPacket(Url, packet);
};    


//리스트상의 그외결과
function OnAnotherResultBtnClick(gameleveldtlidx, teamgamenum, gamenum){

  ResultChk.Team1 = "";
  ResultChk.TeamDtl1 = "";
  ResultChk.TeamName1 = "";
  ResultChk.Team2 = "";
  ResultChk.TeamDtl2 = "";      
  ResultChk.TeamName2 = "";
  ResultChk.ResultType = "";
  ResultChk.ResultTypeNM = "";
  ResultChk.ResultTypeDtl = "";
  ResultChk.ResultTypeDtlNM = "";

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;

  Url = "/Ajax/GameTitleMenu/Popup_AnotherGroupResult.asp"

  packet.CMD = CMD_POPUPANOTHERGROUPRESULT;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tGameNum = GameNum;

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

//리스트상의 경기결과입력
function OnResultBtnClick(gameleveldtlidx, teamgamenum, gamenum, setnum, tourneygroupidx){

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;
  SetNum = setnum;
  TourneyGroupIDX = tourneygroupidx;

  //그룹선택
  PointChk.TourneyGroupIDX = TourneyGroupIDX;
  PointChk.SetNum = SetNum;

  Url = "/Ajax/GameTitleMenu/Popup_Result.asp"

  packet.CMD = CMD_POPUPRESULT;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tGameNum = GameNum;
  packet.tSetNum = SetNum;
  packet.tTourneyGroupIDX = TourneyGroupIDX;

  SendPacket(Url, packet);
};    

//리스트상의 경기결과입력
function OnScoreBtnClick(gameleveldtlidx, teamgamenum, gamenum, setnum, tourneygroupidx){

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;
  SetNum = setnum;
  TourneyGroupIDX = tourneygroupidx;

  //그룹선택
  PointChk.TourneyGroupIDX = TourneyGroupIDX;
  PointChk.SetNum = SetNum;

  Url = "/Ajax/GameTitleMenu/Popup_PlayerDtlModify.asp"

  packet.CMD = CMD_POPUPPLAYERDTL;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tGameNum = GameNum;
  packet.tSetNum = SetNum;
  packet.tTourneyGroupIDX = TourneyGroupIDX;

  SendPacket(Url, packet);
};  

//리스트상의 경기결과입력
function OnGroupResultBtnClick(gameleveldtlidx, teamgamenum, gamenum){

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;

  //경기진행결과페이지라는 구분
  PageGubun = "ResultPage";

  Url = "/Ajax/GameTitleMenu/Popup_GroupResult.asp"

  packet.CMD = CMD_POPUPGROUPRESULT;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tGameNum = GameNum;
  packet.tPageGubun = PageGubun;

  SendPacket(Url, packet);
};    

function OnGroupResultPrintClick(gameleveldtlidx, teamgamenum, gamenum, isprint, groupgamegb, tempnum){



  Url = "/Main/GameTitleMenu/scorePageGroup_Excel.asp?" 
  + "GameLevelDtlIDX=" + gameleveldtlidx
  + "&TeamGameNum=" + teamgamenum
  + "&GameNum=" + gamenum
  + "&GroupGameGb=" + groupgamegb
  + "&TempNum=" + tempnum
  + "&IsPrint=" + isprint;

  var openNewWindow = window.open("about:blank");
  //console.log(Url);
  openNewWindow.location.href = Url;  
}

function OnGroupResultDtlBtnExcelClick(gameleveldtlidx, teamgamenum, gamenum, setnum, tourneygroupidx){
  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;
  SetNum = setnum;
  TourneyGroupIDX = tourneygroupidx;

  Url = "/Main/GameTitleMenu/GamePaperGroup_Excel.asp?" 
  + "GameLevelDtlIDX=" + gameleveldtlidx
  + "&TeamGameNum=" + teamgamenum
  + "&GameNum=" + gamenum
  + "&SetNum=" + SetNum
  + "&TourneyGroupIDX=" + TourneyGroupIDX;
  var openNewWindow = window.open("about:blank");
  openNewWindow.location.href = Url;  
}


//팀경기완료
function OnGroupResultCompleteClick(gameleveldtlidx, teamgamenum, gamenum, gameround){

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;
  GameRound = gameround;

  Url = "/Ajax/GameTitleMenu/GameEnd_Team.asp"

  packet.CMD = CMD_TEAMGAMECOMPLETE;
  packet.GameLevelDtlIDX = GameLevelDtlIDX;
  packet.TeamGameNum = TeamGameNum;
  packet.GameNum = GameNum;
  packet.GameRound = GameRound;

  SendPacket(Url, packet);
};    

//경기진행현황 리스트
function excel_GameOrder_list(){

  GameTitleIDX = $("#selGameTitleIdx").val();
  GameDay = $("#selGameDay").val();
  StadiumIDX = $("#selStadiumIDX").val();
  StadiumNumber = $("#selStadiumNumber").val();
  SearchName = $("#txtSearchName").val();
  PlayLevelType = $("#selPlayLevelType").val();

  Url = "/Main/GameTitleMenu/GameResult_List_Excel.asp?" 
  + "GameTitleIDX=" + GameTitleIDX
  + "&GameDay=" + GameDay
  + "&StadiumIDX=" + StadiumIDX
  + "&StadiumNumber=" + StadiumNumber
  + "&SearchName=" + SearchName
  + "&PlayLevelType=" + PlayLevelType;

  //alert(Url);
  //console.log(Url);
  location.href = Url;
};  

function print_EliteOrder_list(){
  GameTitleIDX = $("#selGameTitleIdx").val();

  Url = "/Main/GameTitleMenu/scorePage_Excel.asp?" 
  + "GameTitleIDX=" + GameTitleIDX;

  location.href = Url;
};

//경기진행현황 리스트
function print_GameOrder_list(){
  

  GameTitleIDX = $("#selGameTitleIdx").val();
  GameDay = $("#selGameDay").val();
  StadiumIDX = $("#selStadiumIDX").val();
  StadiumNumber = $("#selStadiumNumber").val();
  SearchName = $("#txtSearchName").val();
  PlayLevelType = $("#selPlayLevelType").val();

  Url = "/Main/GameTitleMenu/gamePaper_GameResult.asp?" 
  + "GameTitleIDX=" + GameTitleIDX
  + "&GameDay=" + GameDay
  + "&StadiumIDX=" + StadiumIDX
  + "&StadiumNumber=" + StadiumNumber
  + "&SearchName=" + SearchName
  + "&PlayLevelType=" + PlayLevelType;

  var openNewWindow = window.open("about:blank");
  //console.log(Url);
  openNewWindow.location.href = Url;
};    

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

function OnWaitPlayerClick(reqplayeridx){

  //선택시 hidden에 담음
  $("#SelectReqPlayerIDX").val(reqplayeridx);  
};

function OnWaitDeleteClick(gameleveldtlidx, teamgamenum, reqplayeridx){
  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  ReqPlayerIDX = reqplayeridx;

 
  Url = "/Ajax/GameTitleMenu/delTourneyTeamTemp.asp"

  packet.CMD = CMD_DELETETOURNEYTEAM;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tReqPlayerIDX = ReqPlayerIDX;
  


  SendPacket(Url, packet);  
};

function OnEmptyAreaClickse(strid, strside){

  if(strside != "" && strside != $("#SelectSide").val()){
    alert("상대편선수로 등록 하실 수 없습니다.");
    return;
  }

  //선택시 담은 hidden을 가져옴
  var str_membername = $("#SelectMemberName").val();
  var str_reqplayeridx = $("#SelectReqPlayerIDX").val();
  var str_btnid = $("#SelectBtnID").val();

  //입력값과 동일인 등록되어있는지 체크
  if(chkplayer(str_reqplayeridx, strside) == false){
    alert('동일한 선수를 여러번 등록 하실 수 없습니다.');
    return;
  }

  $("#DP_" + strside + strid).html(str_membername);
  $("#STR_" + strside + strid).val(str_reqplayeridx);

  //버튼변경
  $("#" + str_btnid).html("삭제");
  $("#" + str_btnid).attr("class","btn btn-red-empty");
  //삭제버튼일때, function값 설정
  $("#" + str_btnid).attr("onclick","OnWaitDeleteClick('" + str_reqplayeridx + "')");

  $("#SelectSide").val("");
  $("#SelectMemberName").val("");
  $("#SelectReqPlayerIDX").val("");
  $("#SelectBtnID").val("");

};


function OnEmptyAreaClick(gameleveldtlidx, teamgamenum, gamenum, orderby){

  if($("#SelectReqPlayerIDX").val() == ""){
    alert("배치할 선수를 선택하세요.");
    return;
  }

  var packet = {};

  GameLevelDtlIDX = gameleveldtlidx;
  TeamGameNum = teamgamenum;
  GameNum = gamenum;
  OrderBy = orderby;
  ReqPlayerIDX = $("#SelectReqPlayerIDX").val();  
 
  Url = "/Ajax/GameTitleMenu/inputTourneyTeamTemp.asp"

  packet.CMD = CMD_INPUTTOURNEYTEAM;
  packet.tGameLevelDtlIDX = GameLevelDtlIDX;
  packet.tTeamGameNum = TeamGameNum;
  packet.tGameNum = GameNum;
  packet.tOrderBy = OrderBy;
  packet.tReqPlayerIDX = ReqPlayerIDX;

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

function chkplayer(reqplayeridx, strside){
  if(strside == "L"){
    for(i=0; i<=$("input[name=LPlayerA]").length; i++ ){
      if($("input[name=LPlayerA]").val() == reqplayeridx){
        return false;
      }
    }
    for(i=0; i<=$("input[name=LPlayerB]").length; i++ ){
      if($("input[name=LPlayerB]").val() == reqplayeridx){
        return false;
      }      
    }    
  }
  if(strside == "R"){
    for(i=0; i<=$("input[name=RPlayerA]").length; i++ ){
      if($("input[name=RPlayerA]").val() == reqplayeridx){
        return false;
      }
    }
    for(i=0; i<=$("input[name=RPlayerB]").length; i++ ){
      if($("input[name=RPlayerB]").val() == reqplayeridx){
        return false;
      }      
    }    
  }  
  return true;
};


function OnGameOrderPaperClick (GameLevelDtlIDX, TeamGameNum){

  Url = "/Main/GameTitleMenu/gameOrderPaper.asp?" 
  + "GameLevelDtlIDX=" + GameLevelDtlIDX
  + "&TeamGameNum=" + TeamGameNum

  var openNewWindow = window.open("about:blank");
  openNewWindow.location.href = Url;

};

function OnPlayerResultClosed(groupgamegb){


  if(groupgamegb == "F9A43D4DE4191C125B08095CC465CD4B"){

    $(".play_detail_modal").modal("hide");
  }
  else{

      //$(".winner-sign").modal();
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
                    $("#DP_Print_Elite").css("display","none");
                  }
                  else if(item.EnterType == "E"){
                    $("#DP_Print_Ama").css("display","none");
                    $("#DP_Print_Elite").css("display","");
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
        OnSearchClick();
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