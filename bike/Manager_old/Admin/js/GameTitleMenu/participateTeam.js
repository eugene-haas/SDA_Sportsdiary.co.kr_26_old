
////////////명령어////////////
CMD_SEARCHTEAM = 1;
CMD_INSERTPARTICIPATETEAM = 2;
CMD_SELPARTICIPATETEAM = 3;
CMD_DELPARTICIPATETEAM = 4;
CMD_UPDATEPARTICIPATETEAM = 5;
CMD_COPYPARTICIPATETEAM= 6;



////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SELPARTICIPATETEAM:
    if(dataType == "html")
    {
        $('#input_area').html(htmldata); 
        initSearchControl();
    }
    break;
    case CMD_INSERTPARTICIPATETEAM: {
      href_ParticipateTeam(jsondata.tGameTitleIDX,jsondata.tGameLevelIdx, 1)
      } 
    break;

    case CMD_COPYPARTICIPATETEAM : {
      href_ParticipateTeam(jsondata.tGameTitleIDX,jsondata.tGameLevelIdx, jsondata.NowPage)
    }break;

    case CMD_DELPARTICIPATETEAM : {
      href_ParticipateTeam(jsondata.tGameTitleIDX,jsondata.tGameLevelIdx, jsondata.NowPage)
    }
    break;
    case CMD_UPDATEPARTICIPATETEAM : {
      href_ParticipateTeam(jsondata.tGameTitleIDX,jsondata.tGameLevelIdx, jsondata.NowPage)
    }
    break;

  
    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////


function delGameParticipateTeam_frm(NowPage) {
  Url = "/Ajax/GameTitleMenu/delGameRequestTeam_frm.asp"
  var tGameRequestTeamIdx = $( "#hiddenGameRequestTeamIdx" ).val(); 
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 

  var packet = {};
  packet.CMD = CMD_DELPARTICIPATETEAM;
  packet.tGameRequestTeamIdx = tGameRequestTeamIdx;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.NowPage = NowPage;

  SendPacket(Url, packet);
};


function inputGameParticipateTeam_frm(NowPage) {
  Url = "/Ajax/GameTitleMenu/inputGameRequestTeam_frm.asp"

  //레벨
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 
  var tGroupGameGb = $( "#GroupGameGb" ).val(); 

  var tTeam = $( "#hiddenTeam" ).val(); 
  var tTeamName = $( "#hiddenTeamName" ).val(); 
  var tTeamDtl = $( "#strTeamDtl" ).val(); 
  
  var packet = {};
  packet.CMD = CMD_INSERTPARTICIPATETEAM;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  
  packet.tGroupGameGb = tGroupGameGb;
  packet.tTeam = tTeam;
  packet.tTeamName = tTeamName;
  packet.tTeamDtl = tTeamDtl;
   
  packet.NowPage = NowPage;
  
  SendPacket(Url, packet);
};

function updateGameParticipateTeam_frm(NowPage) {
  Url = "/Ajax/GameTitleMenu/updateGameRequestTeam_frm.asp"

  //레벨
  var tGameRequestTeamIdx = $( "#hiddenGameRequestTeamIdx" ).val(); 
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 
  var tGroupGameGb = $( "#GroupGameGb" ).val(); 

  var tTeam = $( "#hiddenTeam" ).val(); 
  var tTeamName = $( "#hiddenTeamName" ).val(); 
  var tTeamDtl = $( "#strTeamDtl" ).val(); 
  var packet = {};
  packet.CMD = CMD_UPDATEPARTICIPATETEAM;
  packet.tGameRequestTeamIdx = tGameRequestTeamIdx;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tGroupGameGb = tGroupGameGb;
  packet.tTeam = tTeam;
  packet.tTeamDtl = tTeamDtl;
  packet.tTeamName = tTeamName;
  packet.NowPage = NowPage;
  //console.log(packet)
  SendPacket(Url, packet);
};

function Copy_ParticipateForTeam(tIdx, tGameLevelIdx, tGameRequestTeamIdx, NowPage)
{
  Url = "/Ajax/GameTitleMenu/copyGameRequestTeam_frm.asp"
  var packet = {};
  packet.CMD = CMD_COPYPARTICIPATETEAM;
  packet.tGameTitleIDX = tIdx;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tGameRequestTeamIdx = tGameRequestTeamIdx;
  packet.NowPage = NowPage;
  
  SendPacket(Url, packet);
};


function SelParticipateTeam(selTeamIdx,NowPage)
{ 
  Url = "/Ajax/GameTitleMenu/selGameRequestTeam.asp"
  //레벨
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 
  var tTeam = $( "#hiddenTeam" ).val(); 
  var tTeamName = $( "#hiddenTeamName" ).val(); 

  var tPlayType = $( "#hiddenPlayType" ).val(); 
  var tPlayTypeNm = $( "#hiddenPlayTypeNm" ).val(); 
  
  var tGroupGameGbNm = $( "#GroupGameGbNm" ).val(); 
  var tGroupGameGb = $( "#GroupGameGb" ).val(); 

  var tLevel = $( "#Level" ).val(); 
  var tLevelNm = $( "#LevelNm" ).val(); 
  var selGameTitle = $( "#selGameTitle" ).val(); 

  var packet = {};

  packet.CMD = CMD_SELPARTICIPATETEAM;
  packet.tGameRequestTeamIdx = selTeamIdx;

  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameTitleNm = selGameTitle;
  packet.tGameLevelIdx = tGameLevelIdx;

  packet.tGroupGameGbNm = tGroupGameGbNm;
  packet.tGroupGameGb = tGroupGameGb;

  packet.tLevel = tLevel;
  packet.tLevelNm = tLevelNm;

  packet.NowPage = NowPage;
  
  //console.log(packet)
  SendPacket(Url, packet);
};

////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function(){
  
  initSearchControl();
};

function initSearchControl()
{
  $( "#strTeam" ).autocomplete({
    source : function( request, response ) {
      $.ajax(
        {
            type: 'post',
            url: "../../Ajax/GameTitleMenu/searchTeam.asp",
            dataType: "json",
            data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHTEAM, "SVAL":request.term}) },
            success: function(data) {
                //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                response(
                    $.map(data, function(item) {
                        return {
                            label: item.teamNm + "(" + item.teamCode + ")",
                            value: item.teamNm,
                            team: item.team,
                            teamCode: item.teamCode,
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
          obj.CMD = CMD_SEARCHTEAM
          obj.teamIdx = ui.item.teamidx
          obj.value = ui.item.value
          obj.label = ui.item.label
          obj.team = ui.item.team
          $("#tdTeam").text(obj.value)
          $("#hiddenTeamName").val(obj.value)
          $("#hiddenTeam").val(obj.team)
        }
    });
}

href_ParticipateTeam = function(tIdx,tGameLevelIdx,NowPage){
  post_to_url('./participateTeam.asp', { 'tIDX': tIdx,'tGameLevelIdx': tGameLevelIdx,'i2': NowPage});
};

href_ParticipateForTeam = function(tIdx,tGameLevelIdx, tGameRequestTeamIdx,tGameRequestTeamGroupIdx){
  post_to_url('./participateTeamMember.asp', { 'tIDX': tIdx,'tGameLevelIdx': tGameLevelIdx,'tGameRequestTeamIdx': tGameRequestTeamIdx,'tGameRequestTeamGroupIdx' : tGameRequestTeamGroupIdx,'i2': 1});
};

href_back = function(tIdx, NowPage){
  post_to_url('./level.asp', { 'tIdx': tIdx,'i2': NowPage});
};