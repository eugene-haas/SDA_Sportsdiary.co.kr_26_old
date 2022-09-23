var mx = {};

mx.EnterType = "";

mx.TeamGBIDX = "";

////////////명령어////////////
CMD_SEARCHTEAMGB = 1;
CMD_SEARCHLEVEL = 2;
CMD_SELECTLEVEL = 4;
CMD_SELECTTEAMGBCONTENT = 5;
CMD_SELECTPTEAMGB = 6;
CMD_SELECTMODALPTEAMGB = 7;
CMD_SELECTLEVELINFOCONTENT = 8;

CMD_INSERTTEAMGB = 20;
CMD_INSERTPTEAMGB = 21;
CMD_INSERTPLEVELINFO = 22;


CMD_DELTEAMGB = 40;
CMD_DELLEVEL = 41;
////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  switch(CMD) {


    case CMD_SEARCHTEAMGB :
    {
      $('#divTeamGb').html(htmldata);

      $('#tableLevelInfo > tbody').empty();

      var myTable = jQuery("#tableLevelInfo");
      var tbody = myTable.find("tbody");
      if (tbody.length===0){
        tbody = jQuery("<tbody></tbody>").appendTo(myTable);    
      }
      item = "<tr>"
      item = item + "<td colspan='3'>종목을 선택해주세요.</td>"
      item = item + "</tr>"
  
      $('#tableLevelInfo > tbody:last').append(item);

    } break;
    case CMD_SEARCHLEVEL :
    {
      $('#divLevel').html(htmldata);
      mx.TeamGBIDX = jsondata.TeamGBIDX;
      console.log(mx.TeamGBIDX);

    } break;
    case CMD_SELECTTEAMGBCONTENT : 
    {
      $("#teamGBModal").modal();
      $('#teamGBModalBody').html(htmldata);
    }break;
    case CMD_DELTEAMGB : {
      SearchTeamGB();
    } break;
    case CMD_SELECTPTEAMGB :{
      $('#selPTeamGB').html(htmldata);
      
    }break;
    case CMD_SELECTMODALPTEAMGB : {
      $('#selModalPTeamGb').html(htmldata);
    }break;
    case CMD_SELECTLEVELINFOCONTENT :{
      $("#levelInfoModal").modal();
      $('#levelInfoModalBody').html(htmldata);

    }break;
    case CMD_INSERTPTEAMGB : {
      Url ="/Ajax/GameTitleMenu/teamGB_SelectPTeamGb.asp"
      var packet = {};
      packet.CMD = CMD_SELECTMODALPTEAMGB;
      packet.EnterType = $("#txtInsertTeamGbEnterType").val();
      SendPacket(Url, packet)
    }break;
    case CMD_INSERTPLEVELINFO : {

      SearchNameLevel();
    }break;
    case CMD_DELLEVEL : {
      SearchNameLevel();
    }break;
    case CMD_INSERTTEAMGB : 
    {
      if(jsondata.result == 0)
      {
      $("#teamGBModal").modal("hide");
      SearchTeamGB();
      }
      else{
        alert("생성이 제대로 되지 않았습니다. 관리자에게 문의하세요.");
      }
    }break;
    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////

SearchTeamGB = function()
{
  Url ="/Ajax/GameTitleMenu/teamGB_SearchTeam.asp"
  var SearchTeamGbNM = $("#txtTeamGbNM").val();
  var SearchPTeamGb = $("#selPTeamGB").val();
  
  var packet = {};
  packet.CMD = CMD_SEARCHTEAMGB;
  packet.TeamGBNM = SearchTeamGbNM;
  packet.PTeamGB = SearchPTeamGb;
  packet.EnterType = mx.EnterType;
	SendPacket(Url, packet)
};



SearchNameLevel = function()
{
  if(mx.TeamGBIDX.length > 0 )
  {
    var SearchLevelInfoNM = $("#txtLevelInfoNM").val();
    Url ="/Ajax/GameTitleMenu/teamGB_SearchLevel.asp"
    var packet = {};
    packet.CMD = CMD_SEARCHLEVEL;
    packet.TeamGBIDX = mx.TeamGBIDX;
    packet.LevelINFONM = SearchLevelInfoNM;
    SendPacket(Url, packet)
  }
};

ModalTeamGB = function()
{
  Url ="/Ajax/GameTitleMenu/teamGB_ModalTeamGBContent.asp"
  var packet = {};
  packet.CMD = CMD_SELECTTEAMGBCONTENT;
  packet.EnterType = mx.EnterType;
  SendPacket(Url, packet)
};


ModalLevelInfo = function()
{
  //$("#levelInfoModal").modal();
  Url ="/Ajax/GameTitleMenu/teamGB_ModalLevelInfoContent.asp"
  var packet = {};
  packet.CMD = CMD_SELECTLEVELINFOCONTENT;
  packet.TeamGBIDX = mx.TeamGBIDX;
  packet.EnterType = mx.EnterType;
  SendPacket(Url, packet)
};

DeleteTeamGb = function(teamGBIdx,teamGbNM)
{
  if(confirm("정말로 " + teamGbNM + "을 삭제하시겠습니까?"))
  {
    Url ="/Ajax/GameTitleMenu/teamGB_DeleteTeam.asp"
    var packet = {};
    packet.CMD = CMD_DELTEAMGB;
    packet.TeamGBIDX = teamGBIdx;
    SendPacket(Url, packet)
  }
};

DeleteLevel = function(levelInfoIDX, levelInfoNM)
{
  if(confirm("정말로 " + levelInfoNM + "을 삭제하시겠습니까?"))
  {
  Url ="/Ajax/GameTitleMenu/teamGB_DeleteLevel.asp"
  var packet = {};
  packet.CMD = CMD_DELLEVEL;
  packet.LevelInfoIDX = levelInfoIDX ;
  SendPacket(Url, packet)
  }
};

OnClickEnterTypeTab = function (EnterType)
{
  mx.EnterType = EnterType;
  mx.TeamGBIDX = "";
  $("#txtLevelInfoNM").val("");
  SearchTeamGB();
  OnPTeamGbChanged();
};


OnClickInsertEnterTypeTab = function (EnterType)
{
  console.log(EnterType)
  $("#InsertTeamGbEnterType").val(EnterType);
  Url ="/Ajax/GameTitleMenu/teamGB_SelectPTeamGb.asp"
  var packet = {};
  packet.CMD = CMD_SELECTMODALPTEAMGB;
  packet.EnterType = EnterType;
  SendPacket(Url, packet)
};

OnPTeamGbChanged = function (){
  Url ="/Ajax/GameTitleMenu/teamGB_SelectPTeamGb.asp"
  var packet = {};
  packet.CMD = CMD_SELECTPTEAMGB;
  packet.EnterType = mx.EnterType;
  SendPacket(Url, packet)
};


InsertPTeamGb = function() {

  Url ="/Ajax/GameTitleMenu/teamGB_InsertPTeamGb.asp"

  txtInsertTeamGbEnterType= $("#txtInsertTeamGbEnterType").val();
  txtPTeamGBNM= $("#txtPTeamGBNM").val();
  if(txtPTeamGBNM.length > 0)
  {
    var packet = {};
    packet.CMD = CMD_INSERTPTEAMGB;
    packet.EnterType = txtInsertTeamGbEnterType;
    packet.PTeamGBNM = txtPTeamGBNM;
    SendPacket(Url, packet)
  }
};

InsertTeamGB = function() {
  Url ="/Ajax/GameTitleMenu/teamGB_InsertTeamGb.asp"
  txtInsertTeamGbEnterType= $("#txtInsertTeamGbEnterType").val();
  txtModalTeamGbNM= $("#txtModalTeamGbNM").val();
  selPTeamGb= $("#selModalPTeamGb").val();
  selPTeamGbNM= $("#selModalPTeamGb option:checked").text();
  
  if(txtModalTeamGbNM.length > 0)
  {
    var packet = {};
    packet.CMD = CMD_INSERTTEAMGB;
    packet.EnterType = txtInsertTeamGbEnterType;
    packet.TeamGBNM = txtModalTeamGbNM;
    packet.PTeamGb = selPTeamGb;
    packet.PTeamGbNM = selPTeamGbNM;
    
    SendPacket(Url, packet)
  }
};

  
InsertLevelInfo = function() {

  Url ="/Ajax/GameTitleMenu/teamGB_InsertLevelInfo.asp"
  txtInsertLevelInfoEnterType= $("#txtInsertLevelInfoEnterType").val();
  txtInsertLevelInfoTeamGBIDX= $("#txtInsertLevelInfoTeamGBIDX").val();
  txtLevelInfo= $("#txtLevelInfo").val();

  if(txtInsertLevelInfoTeamGBIDX.length > 0 && txtLevelInfo.length > 0 )
  {
    var packet = {};
    packet.CMD = CMD_INSERTPLEVELINFO;
    packet.EnterType = txtInsertLevelInfoEnterType;
    packet.TeamGBIDX = txtInsertLevelInfoTeamGBIDX;
    packet.LevelInfoNM = txtLevelInfo;
    SendPacket(Url, packet)
  }
  else
  {
    if(txtInsertLevelInfoTeamGBIDX.length == 0){
      alert("종목을 선택해주세요.");
    }
  
    if(txtLevelInfo.length == 0){
      alert("종목레벨을 입력해주세요.");
    }
  }
};

////////////Custom Function////////////

$(document).ready(function(){
  initTabSelected();  // TeamGB.asp 안에 Script
  SetJqueryEvent();
});



function SetJqueryEvent() {
  // 종별 테이블 Row 선택 Click 이벤트

  $(document).on("click", "#tableTeamGb tbody tr", function() {
    //some think
    if(event.target.type == undefined)
    {
      var innerHtml = $(this).html();
      var number = $(this).find("#hiddenNumber").val();
      var hiddenTeamGbIdx = $(this).find('#hiddenTeamGbIdx'+number).val();

      if (typeof(hiddenTeamGbIdx) != "undefined")
      {
        $('#tableTeamGb').resetColor();
        $(this).css('background-color','#81bcff');
        mx.TeamGBIDX = hiddenTeamGbIdx;
        SearchNameLevel();
      }
    }
  });
}


$.fn.resetColor = function() {
  $(this).find('tr').each(function() {
    //$(this).children('th').css('background-color','#white');
    $(this).css( "background-color", "white" );
  });
};
