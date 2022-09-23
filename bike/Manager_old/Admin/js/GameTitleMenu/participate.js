
////////////명령어////////////
CMD_SEARCHMEMBER = 1
CMD_INSERTPARTICIPATE = 2;
CMD_SELPARTICIPATE = 3;
CMD_DELPARTICIPATE = 4;
CMD_UPDATEPARTICIPATE = 5;

////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SELPARTICIPATE:
    if(dataType == "html")
    {
        $('#input_area').html(htmldata); 
        initSearchControl2(jsondata);
    }
    break;
    case CMD_INSERTPARTICIPATE: {
      href_Participate2(jsondata,1)
      } 
    break;

    case CMD_DELPARTICIPATE : {
      href_Participate2(jsondata, jsondata.NowPage)
    }
    break;
    case CMD_UPDATEPARTICIPATE : {
      
      href_Participate2(jsondata, jsondata.NowPage)
    }
    break;

  
    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////


function delGameParticipate_frm(packet) {
  Url = "/Ajax/GameTitleMenu/delGameRequestGroup_frm.asp"
  //레벨
  var tGameRequestGroupIDX = $( "#hiddenGameRequestGroupIDX" ).val(); 
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 
  packet.CMD = CMD_DELPARTICIPATE;
  packet.tGameRequestGroupIDX = tGameRequestGroupIDX;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  //console.log(packet)
  SendPacket(Url, packet);
};


function inputGameParticipate_frm(packet) {
  Url = "/Ajax/GameTitleMenu/inputGameRequestPlayer_frm.asp"

  //레벨
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 
  var tPlayType = $( "#hiddenPlayType" ).val(); 
  var tGroupGameGb = $( "#GroupGameGb" ).val(); 

  var tMemberName1 = $( "#hiddenMemberName1" ).val(); 
  var tMemberIdx1 = $( "#hiddenMemberIdx1" ).val(); 
  var tTeam1 = $( "#hiddenTeam1" ).val(); 
  var tTeamName1 = $( "#hiddenTeamName1" ).val(); 

  var tMemberName2 = $( "#hiddenMemberName2" ).val(); 
  var tMemberIdx2 = $( "#hiddenMemberIdx2" ).val(); 
  var tTeam2 = $( "#hiddenTeam2" ).val(); 
  var tTeamName2 = $( "#hiddenTeamName2" ).val(); 

  packet.CMD = CMD_INSERTPARTICIPATE;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tPlayType = tPlayType;
  packet.tGroupGameGb = tGroupGameGb;
  packet.tMemberName1 = tMemberName1;
  packet.tMemberIdx1 = tMemberIdx1;
  packet.tTeam1 = tTeam1;
  packet.tTeamName1 = tTeamName1;
  packet.tMemberName2 = tMemberName2;
  packet.tMemberIdx2 = tMemberIdx2;
  packet.tTeam2 = tTeam2;
  packet.tTeamName2 = tTeamName2;
  
  SendPacket(Url, packet);
};




function updateGameParticipate_frm(packet) {
  Url = "/Ajax/GameTitleMenu/updateGameRequestPlayer_frm.asp"

  //레벨
  var tGameRequestGroupIDX = $("#hiddenGameRequestGroupIDX").val(); 
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 

  var tPlayType = $( "#hiddenPlayType" ).val(); 
  var tPlayTypeNm = $( "#hiddenPlayTypeNm" ).val(); 

  var tMemberName1 = $( "#hiddenMemberName1" ).val(); 
  var tMemberIdx1 = $( "#hiddenMemberIdx1" ).val(); 
  var tTeam1 = $( "#hiddenTeam1" ).val(); 
  var tTeamName1 = $( "#hiddenTeamName1" ).val(); 
  var tGameRequestPlayerIdx1 = $( "#hiddenGameRequestPlayerIDX1" ).val(); 

  var tMemberName2 = $( "#hiddenMemberName2" ).val(); 
  var tMemberIdx2 = $( "#hiddenMemberIdx2" ).val(); 
  var tTeam2 = $( "#hiddenTeam2" ).val(); 
  var tTeamName2 = $( "#hiddenTeamName2" ).val(); 
  var tGameRequestPlayerIdx2 = $( "#hiddenGameRequestPlayerIDX2" ).val(); 
  var tMajorTeam = $(':radio[name="majorTeam"]:checked').val();


  packet.CMD = CMD_UPDATEPARTICIPATE;
  packet.tGameRequestGroupIDX = tGameRequestGroupIDX;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tPlayType = tPlayType;
  packet.tPlayTypeNm = tPlayTypeNm;

  packet.tMemberName1 = tMemberName1;
  packet.tMemberIdx1 = tMemberIdx1;
  packet.tTeam1 = tTeam1;
  packet.tTeamName1 = tTeamName1;
  packet.tGameRequestPlayerIdx1 = tGameRequestPlayerIdx1;

  packet.tMemberName2 = tMemberName2;
  packet.tMemberIdx2 = tMemberIdx2;
  packet.tTeam2 = tTeam2;
  packet.tTeamName2 = tTeamName2;
  packet.tGameRequestPlayerIdx2 = tGameRequestPlayerIdx2;
  packet.tMajorTeam = tMajorTeam;
  SendPacket(Url, packet);
};


function SelParticipate(packet,selGroupIdx,NowPage)
{ 
  Url = "/Ajax/GameTitleMenu/selGameRequestGroup.asp"
  //레벨
  var tGameTitleIDX = $( "#selGameTitleIDX" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIDX" ).val(); 
  var tMemberName = $( "#hiddenMemberName" ).val(); 
  var tMemberIdx = $( "#hiddenMemberIdx" ).val(); 
  var tTeam = $( "#hiddenTeam" ).val(); 
  var tTeamName = $( "#hiddenTeamName" ).val(); 

  var tPlayType = $( "#hiddenPlayType" ).val(); 
  var tPlayTypeNm = $( "#hiddenPlayTypeNm" ).val(); 
  
  var tGroupGameGbNm = $( "#GroupGameGbNm" ).val(); 
  var tGroupGameGb = $( "#GroupGameGb" ).val(); 
  var tLevel = $( "#Level" ).val(); 
  var tLevelNm = $( "#LevelNm" ).val(); 
  
  var tSex = $( "#Sex" ).val(); 
  var selGameTitle = $( "#selGameTitle" ).val(); 

  packet.CMD = CMD_SELPARTICIPATE;
  packet.tGameRequestGroupIdx = selGroupIdx;
  packet.tGameTitleIDX = tGameTitleIDX;
  packet.tGameTitleNm = selGameTitle;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tGroupGameGbNm = tGroupGameGbNm;
  packet.tGroupGameGb = tGroupGameGb;
  packet.tPlayTypeNm = tPlayTypeNm;
  packet.tPlayType = tPlayType;
  packet.tLevel = tLevel;
  packet.tLevelNm = tLevelNm;
  packet.NowPage = NowPage;  
  packet.tSex = tSex;
  
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


function initSearchControl2(packet)
{
  $( "#strMember1" ).autocomplete({
		source : function( request, response ) {
      packet.CMD = CMD_SEARCHMEMBER;
      packet.SVAL = request.term;

			$.ajax(
				{
						type: 'post',
						url: "../../Ajax/GameTitleMenu/searchMember.asp",
						dataType: "json",
						data: { "REQ" : JSON.stringify(packet) },
						success: function(data) {
								//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
								response(
										$.map(data, function(item) {
												return {
														label: item.data + "("+item.teamNm + ")",
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
          obj.CMD = CMD_SEARCHMEMBER
          obj.uIdx = ui.item.uidx
          obj.value = ui.item.value
          obj.label = ui.item.label
          obj.team = ui.item.team
          obj.teamNm = ui.item.teamNm
          obj.userName = ui.item.value
          $("#tdTeam1").text(obj.teamNm)
          $("#hiddenTeamName1").val(obj.teamNm)
          $("#hiddenTeam1").val(obj.team)
          $("#hiddenMemberIdx1").val(obj.uIdx)
          $("#hiddenMemberName1").val(obj.userName)
        }
    });


    $( "#strMember2" ).autocomplete({
      source : function( request, response ) {
        packet.CMD = CMD_SEARCHMEMBER;
        packet.SVAL = request.term;
        $.ajax(
          {
              type: 'post',
              url: "../../Ajax/GameTitleMenu/searchMember.asp",
              dataType: "json",
              data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHMEMBER, "SVAL":request.term}) },
              success: function(data) {
                  //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                  response(
                      $.map(data, function(item) {
                          return {
                              label: item.data + "("+item.teamNm + ")",
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
            obj.CMD = CMD_SEARCHMEMBER
            obj.uIdx = ui.item.uidx
            obj.value = ui.item.value
            obj.label = ui.item.label
            obj.team = ui.item.team
            obj.teamNm = ui.item.teamNm
            obj.userName = ui.item.value
            $("#tdTeam2").text(obj.teamNm)
            $("#hiddenTeamName2").val(obj.teamNm)
            $("#hiddenTeam2").val(obj.team)
            $("#hiddenMemberIdx2").val(obj.uIdx)
            $("#hiddenMemberName2").val(obj.userName)
          }
      });
}


function initSearchControl()
{
  $( "#strMember1" ).autocomplete({
		source : function( request, response ) {
			$.ajax(
				{
						type: 'post',
						url: "../../Ajax/GameTitleMenu/searchMember.asp",
						dataType: "json",
						data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHMEMBER, "SVAL":request.term}) },
						success: function(data) {
								//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
								response(
										$.map(data, function(item) {
												return {
														label: item.data + "("+item.teamNm + ")",
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
          obj.CMD = CMD_SEARCHMEMBER
          obj.uIdx = ui.item.uidx
          obj.value = ui.item.value
          obj.label = ui.item.label
          obj.team = ui.item.team
          obj.teamNm = ui.item.teamNm
          obj.userName = ui.item.value
          $("#tdTeam1").text(obj.teamNm)
          $("#hiddenTeamName1").val(obj.teamNm)
          $("#hiddenTeam1").val(obj.team)
          $("#hiddenMemberIdx1").val(obj.uIdx)
          $("#hiddenMemberName1").val(obj.userName)
        }
    });


    $( "#strMember2" ).autocomplete({
      source : function( request, response ) {
        $.ajax(
          {
              type: 'post',
              url: "../../Ajax/GameTitleMenu/searchMember.asp",
              dataType: "json",
              data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHMEMBER, "SVAL":request.term}) },
              success: function(data) {
                  //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                  response(
                      $.map(data, function(item) {
                          return {
                              label: item.data + "("+item.teamNm + ")",
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
            obj.CMD = CMD_SEARCHMEMBER
            obj.uIdx = ui.item.uidx
            obj.value = ui.item.value
            obj.label = ui.item.label
            obj.team = ui.item.team
            obj.teamNm = ui.item.teamNm
            obj.userName = ui.item.value
            $("#tdTeam2").text(obj.teamNm)
            $("#hiddenTeamName2").val(obj.teamNm)
            $("#hiddenTeam2").val(obj.team)
            $("#hiddenMemberIdx2").val(obj.uIdx)
            $("#hiddenMemberName2").val(obj.userName)
          }
      });
}

href_Participate = function(tIdx,tGameLevelIdx,NowPage){
  post_to_url('./participate.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx,'i2': NowPage});
};

href_Participate2 = function(packet,NowPage){
  post_to_url('./participate.asp', { 'tIdx': packet.tIdx,'tGameLevelIdx': packet.tGameLevelIdx,'pType': packet.pType,'tPGameLevelIdx':packet.tPGameLevelIdx,'iSearchText':packet.iSearchText,'iSearchCol':packet.iSearchCol,'i2': NowPage});
};


href_ParticipateTeam = function(tIdx,tGameLevelIdx,NowPage){
  post_to_url('./participateTeam.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx,'i2': NowPage});
};


href_back = function(tIdx,tGameLevelIDX,NowPage){
  post_to_url('./level.asp', { 'tIdx': tIdx,'tGameLevelIdx':tGameLevelIDX,'i2': NowPage});
};

href_back2 = function(tIdx,tPGameLevelIDX,tGameLevelIDX,NowPage){
  post_to_url('./plevel.asp', { 'tIdx': tIdx,'tPGameLevelIDX':tPGameLevelIDX,'tGameLevelIdx':tGameLevelIDX,'i2': NowPage});
};