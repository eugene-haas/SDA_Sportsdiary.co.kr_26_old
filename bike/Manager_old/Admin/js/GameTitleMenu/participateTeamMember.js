
////////////명령어////////////
CMD_SEARCHTEAMMEMBER = 1
CMD_INSERTPARTICIPATETEAMMEMBER = 2;
CMD_SELPARTICIPATETEAMMEMBER = 3;
CMD_DELPARTICIPATETEAMMEMBER = 4;
CMD_UPDATEPARTICIPATETEAMMEMBER = 5;



////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SELPARTICIPATETEAMMEMBER:
    if(dataType == "html")
    {
        $('#input_area').html(htmldata); 
        initSearchControl();
    }
    break;
   
    case CMD_INSERTPARTICIPATETEAMMEMBER: {
      //console.log(jsondata)
      href_ParticipateTeamMember(jsondata.tGameTitleIDX,jsondata.tGameLevelIdx,jsondata.tGameRequestTeamIdx, jsondata.NowPage)
      } 
    break;

    case CMD_DELPARTICIPATETEAMMEMBER : {
      href_ParticipateTeamMember(jsondata.tGameTitleIDX,jsondata.tGameLevelIdx,jsondata.tGameRequestTeamIdx, jsondata.NowPage)
    }
    break;
    case CMD_UPDATEPARTICIPATETEAMMEMBER : {
      href_ParticipateTeamMember(jsondata.tGameTitleIDX,jsondata.tGameLevelIdx,jsondata.tGameRequestTeamIdx, jsondata.NowPage)
    }
    break;

  
    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////


function delGameParticipateTeamMember_frm(NowPage) {
  Url = "/Ajax/GameTitleMenu/delGameRequestPlayer_frm.asp"

  
    var tGameRequestPlayerIDX = $( "#hiddenGameRequestPlayerIDX" ).val(); 
    var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
    var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 
    var tGameRequestTeamIdx = $( "#selGameRequestTeamIdx" ).val(); 
    var packet = {};
    packet.CMD = CMD_DELPARTICIPATETEAMMEMBER;
    packet.tGameRequestPlayerIDX = tGameRequestPlayerIDX;
    packet.tGameRequestTeamIdx = tGameRequestTeamIdx;
    packet.tGameTitleIDX = tGameTitleIDX;
    packet.tGameLevelIdx = tGameLevelIdx;
    packet.NowPage = NowPage;
    SendPacket(Url, packet);
  
};


function inputGameParticipateTeamMember_frm(NowPage) {
  Url = "/Ajax/GameTitleMenu/inputGameRequestTeamPlayer_frm.asp"
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 
  var tGameRequestTeamIdx = $( "#selGameRequestTeamIdx" ).val(); 
  var tMemberName = $( "#hiddenMemberName" ).val(); 
  var tMemberIdx = $( "#hiddenMemberIdx" ).val(); 
  var tTeam = $( "#hiddenTeam" ).val(); 
  var tTeamName = $( "#hiddenTeamNm" ).val(); 

  var packet = {};
  packet.CMD = CMD_INSERTPARTICIPATETEAMMEMBER;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tGameRequestTeamIdx = tGameRequestTeamIdx;
  
  packet.tTeam = tTeam;
  packet.tMemberName = tMemberName;
  packet.tMemberIdx = tMemberIdx;
  packet.tTeamName = tTeamName;
  packet.NowPage = NowPage;
  //console.log(packet)
  SendPacket(Url, packet);
};

function updateGameParticipateTeamMember_frm(NowPage) {
  Url = "/Ajax/GameTitleMenu/updateGameRequestTeamPlayer_frm.asp"

  //레벨
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 
  var tGameRequestTeamIdx = $( "#selGameRequestTeamIdx" ).val(); 
  var tGameRequestPlayerIDX = $( "#hiddenGameRequestPlayerIDX" ).val(); 
  var tTeam = $( "#hiddenTeam" ).val(); 
  var tTeamName = $( "#hiddenTeamNm" ).val(); 
  var tMemberName = $( "#hiddenMemberName" ).val(); 
  var tMemberIdx = $( "#hiddenMemberIdx" ).val(); 
  

  var packet = {};
  packet.CMD = CMD_UPDATEPARTICIPATETEAMMEMBER;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tGameRequestTeamIdx = tGameRequestTeamIdx;
  packet.tGameRequestPlayerIDX = tGameRequestPlayerIDX;

  packet.tTeam = tTeam;
  packet.tTeamName = tTeamName;
  packet.tMemberName = tMemberName;
  packet.tMemberIdx = tMemberIdx;
  packet.NowPage = NowPage;
  //console.log(packet)
  SendPacket(Url, packet);
};


function SelParticipateTeamMember(packet)
{ 
  Url = "/Ajax/GameTitleMenu/selGameRequestTeamMember.asp"
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 
  var tGameRequestTeamIdx = $( "#selGameRequestTeamIdx" ).val(); 
  var tTeam = $( "#hiddenTeam" ).val(); 
  var tTeamName = $( "#hiddenTeamName" ).val(); 
  var tPlayType = $( "#hiddenPlayType" ).val(); 
  var tPlayTypeNm = $( "#hiddenPlayTypeNm" ).val(); 
  var tGroupGameGbNm = $( "#GroupGameGbNm" ).val(); 
  var tGroupGameGb = $( "#GroupGameGb" ).val(); 
  var tLevel = $( "#Level" ).val(); 
  var tLevelNm = $( "#LevelNm" ).val(); 
  var selGameTitle = $( "#selGameTitle" ).val(); 

  packet.CMD = CMD_SELPARTICIPATETEAMMEMBER;
  packet.tGameRequestTeamIdx = tGameRequestTeamIdx;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameTitleNm = selGameTitle;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tGroupGameGbNm = tGroupGameGbNm;
  packet.tGroupGameGb = tGroupGameGb;
  packet.tLevel = tLevel;
  packet.tLevelNm = tLevelNm;
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
  
  $( "#strMember" ).autocomplete({
    source : function( request, response ) {

      var tGameRequestTeamIdx = $( "#selGameRequestTeamIdx" ).val(); 
      console.log("tGameRequestTeamIdx" + tGameRequestTeamIdx );
      $.ajax(
        {
            type: 'post',
            url: "../../Ajax/GameTitleMenu/searchTeamMember.asp",
            dataType: "json",
            data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHTEAMMEMBER, "SVAL":request.term,"TeamIdx":tGameRequestTeamIdx }) },
            success: function(data) {
                //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                response(
                    $.map(data, function(item) {
                        return {
                          label: item.data + "("+item.teamNm + ")/" + item.tEnterType,
                          value: item.data,
                          uidx:item.uidx,
                          team : item.team,
                          teamNm : item.teamNm
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
          obj.CMD = CMD_SEARCHTEAMMEMBER
          obj.uIdx = ui.item.uidx
          obj.value = ui.item.value
          obj.label = ui.item.label
          obj.team = ui.item.team
          obj.teamNm = ui.item.teamNm
          obj.userName = ui.item.value
          $("#tdTeam").text(obj.teamNm)
          $("#hiddenTeamName").val(obj.teamNm)
          $("#hiddenTeamCode").val(obj.team)
          $("#hiddenMemberIdx").val(obj.uIdx)
          $("#hiddenMemberName").val(obj.userName)
        }
    });
  
}


href_ParticipateTeamMember = function(tIdx,tGameLevelIdx, tGameRequestTeamIdx, NowPage){
  post_to_url('./participateTeamMember.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx,'tGameRequestTeamIdx': tGameRequestTeamIdx,'i2': NowPage});
};

href_back = function(tIdx,tGameLevelIdx,NowPage){
  post_to_url('./participateTeam.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx,'i2': NowPage});
};
