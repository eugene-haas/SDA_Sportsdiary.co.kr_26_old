
////////////명령어////////////
CMD_INSERTGAMELEVELDTL = 1;
CMD_SELGAMELEVELDTL = 2;
CMD_DELGAMELEVELDTL = 3;
CMD_UPDATEGAMELEVELDTL = 4;
CMD_LEVELDTLDIVISION = 5;
////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  switch(CMD) {

    case CMD_SELGAMELEVELDTL:
      if(dataType == "html")
      {
        $('#gameLevelDtlInput_area').html(htmldata); 
          
        $(function() {
          $(".date_ipt" ).datepicker({ 
              changeYear:true,
              changeMonth: true, 
              dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
              monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
              showMonthAfterYear:true,
              showButtonPanel: true, 
              currentText: '오늘 날짜', 
              closeText: '닫기', 
              dateFormat: "yy-mm-dd"
              
          });
         
          $('.time_ipt').timepicker({
            timeFormat: 'h:mm p',
            interval: 60,
            defaultTime: '8',
            startTime: '08:00',
            dynamic: false,
            dropdown: true,
            scrollbar: true
          });
        });
      }break;
    case CMD_INSERTGAMELEVELDTL :
    {
      ////alert(jsondata.tGameLevelIdx)
      //console.log(jsondata.tGameLevelIdx)
      href_gameLevel2 (jsondata, 1)
    }break;
    case CMD_DELGAMELEVELDTL :
    {
      //alert(jsondata.tGameLevelIdx)
      //console.log(jsondata.tGameLevelIdx)
      href_gameLevel2 (jsondata, jsondata.NowPage)
    }break;

    case CMD_UPDATEGAMELEVELDTL :
    {
      //alert(jsondata.tGameLevelIdx)
      //console.log(jsondata)
      //console.log(jsondata.tGameLevelIdx)
      
      href_gameLevel2 (jsondata, jsondata.NowPage)
    }
    break;

    case CMD_LEVELDTLDIVISION:
    {
      //alert(jsondata.tIdx)
      //alert(jsondata.tGameLevelIdx)
      //alert(jsondata.NowPage)
      href_gameLevel(jsondata.tIdx, jsondata.tGameLevelIdx, jsondata.NowPage)
    } break;

    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////

function inputGameLevelDtl_frm(packet){

  Url = "/Ajax/GameTitleMenu/inputGameLevelDtl_frm.asp"
  var tGameIdx = $( "#selGameIdx" ).val(); 
  var tPlayLevelType = $( "#selPlayLevelType" ).val(); 
  var tGameType = $( "#selGameType" ).val(); 
  var tSelStadium = $( "#selStadiums" ).val(); 
  var tTotalRound = $( "#selTotalRound" ).val(); 
  var tEntryCnt = $( "#txtEntryCnt" ).val(); 
  var tGameDay = $( "#selGameDay" ).val(); 
  var tGameTime = $( "#selGameTime" ).val(); 
  var tViewYN = $( "#selViewYN" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
  var tLevelJooNum = $( "#selLevelJooNum" ).val(); 
  var tJooDivision = $( "#txtJooDivision" ).val(); 
  var tFullGameYN = $("#selFullGameYN").val();
  //var tLevelJoo = $( "#selLevelJoo" ).val(); 
  //var tLevelJooNum = $( "#selLevelJooNum" ).val(); 

  packet.CMD = CMD_INSERTGAMELEVELDTL;
  packet.tIdx = tGameIdx;
  packet.tPlayLevelType = tPlayLevelType;
  packet.tGameType = tGameType;
  packet.tStadium = tSelStadium;
  packet.tTotalRound = tTotalRound;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tEntryCnt = tEntryCnt;
  packet.tGameTime = tGameTime;
  packet.tViewYN = tViewYN;
  packet.tGameDay = tGameDay
  packet.tLevelJooNum = tLevelJooNum
  packet.tJooDivision = tJooDivision
  packet.tFullGameYN = tFullGameYN
  //packet.tLevelJoo = tLevelJoo;
  //packet.tLevelJooNum = tLevelJooNum;
  //console.log(packet)
  SendPacket(Url, packet);
};

function SelGameLevelDtl(packet,levelIdx,levelDtlIdx,NowPage){
  var tGameTitleIdx = $( "#selGameIdx" ).val(); 
  Url = "/Ajax/GameTitleMenu/selGameLevelDtl.asp"
  packet.CMD = CMD_SELGAMELEVELDTL;
  packet.tIdx = tGameTitleIdx;
  packet.tGameLevelIdx = levelIdx;
  packet.tGameLevelDtlIdx = levelDtlIdx;
  packet.NowPage = NowPage;
  //console.log(packet);
  SendPacket(Url, packet);
}

function ApplyLevelDtlDIvision(levelIdx,NowPage){
  Url = "/Ajax/GameTitleMenu/updateLevelDtlJooDIvision.asp"

  
  var tdivisionNum = $( "#txtJooDivision" ).val(); 
  var tViewYN = $( "#selViewYN" ).val(); 
  

  var tGameTitleIdx = $( "#selGameIdx" ).val(); 
  var tRequestGameType = $( "#RequestGameType" ).val(); 
  var packet = {};
  packet.CMD = CMD_LEVELDTLDIVISION;
  //몇조로, 무슨 레벨인지
  packet.tGameLevelIdx = levelIdx;
  packet.tDivisionNum = divisionNum;
  packet.tRequestGameType = tRequestGameType;
  packet.tIdx = tGameTitleIdx;
  packet.NowPage = NowPage;
  SendPacket(Url, packet);
};

function ApplyLevelDtlDIvision2(levelIdx,NowPage){
  Url = "/Ajax/GameTitleMenu/updateLevelDtlJooDIvision.asp"
  var divisionNum = $( "#LevelDtlDivisionNum" ).val(); 
  var tGameTitleIdx = $( "#selGameIdx" ).val(); 
  var tRequestGameType = $( "#RequestGameType" ).val(); 
  var packet = {};
  packet.CMD = CMD_LEVELDTLDIVISION;
  //몇조로, 무슨 레벨인지
  packet.tGameLevelIdx = levelIdx;
  packet.tDivisionNum = divisionNum;
  packet.tRequestGameType = tRequestGameType;
  packet.tIdx = tGameTitleIdx;
  packet.NowPage = NowPage;
  SendPacket(Url, packet);
};


function updateGameLevelDtl_frm(packet){
  Url = "/Ajax/GameTitleMenu/updateGameLevelDtl_frm.asp"
  
  var tPlayLevelType = $( "#selPlayLevelType" ).val(); 
  var tGameType = $( "#selGameType" ).val(); 
  var tSelStadium = $( "#selStadiums" ).val(); 
  var tTotalRound = $( "#selTotalRound" ).val(); 
  var tEntryCnt = $( "#txtEntryCnt" ).val(); 
  var tGameDay = $( "#selGameDay" ).val(); 
  var tGameTime = $( "#selGameTime" ).val(); 
  var tViewYN = $( "#selViewYN" ).val(); 
  var tGameIdx = $( "#selGameIdx" ).val(); 
  var tGameLevelDtlIDX = $( "#selGameLeveDtlIIdx" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
  var tLevelJooNum = $( "#selLevelJooNum" ).val(); 
  var tJooDivision = $( "#txtJooDivision" ).val(); 
  var tFullGameYN = $("#selFullGameYN").val();
  var tJooRank= $("#txtJooRank").val();

  

  //var tLevelJoo = $( "#selLevelJoo" ).val(); 
  //var tLevelJooNum = $( "#selLevelJooNum" ).val(); 
  if(tGameLevelDtlIDX == ""){
    alert("수정할 대진표를 선택해주세요");
    return;
  }

  packet.CMD = CMD_UPDATEGAMELEVELDTL;
  packet.tIdx = tGameIdx;
  packet.tGameLevelDtlIDX = tGameLevelDtlIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tStadium = tSelStadium
  packet.tPlayLevelType = tPlayLevelType;
  packet.tGameType = tGameType;
  packet.tTotalRound = tTotalRound;
  packet.tEntryCnt = tEntryCnt;
  packet.tGameTime = tGameTime;
  packet.tViewYN = tViewYN;
  packet.tGameDay = tGameDay
  packet.tLevelJooNum = tLevelJooNum
  packet.tJooDivision = tJooDivision
  packet.tFullGameYN = tFullGameYN
  packet.tJooRank = tJooRank
  //packet.tLevelJoo = tLevelJoo;
  //packet.tLevelJooNum = tLevelJooNum;
  //console.log(packet)
  SendPacket(Url, packet);
};

function delGameLevelDtl_frm(packet) {
  Url = "/Ajax/GameTitleMenu/delGameLevelDtl_frm.asp"
  var tGameLevelDtlIDX = $( "#selGameLeveDtlIIdx" ).val(); 
  var tGameIdx = $( "#selGameIdx" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
  packet.CMD = CMD_DELGAMELEVELDTL;
  packet.tIdx = tGameIdx;
  packet.tGameLevelDtlIDX = tGameLevelDtlIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  SendPacket(Url, packet);
};

function onGameTypeChanged(value) {
  if(value =="143222846ECFA17ECBDF9B9DE506DCBD") {
    document.getElementById("selTotalRound").style.visibility = "hidden"; 
  }else{
    document.getElementById("selTotalRound").style.visibility = "visible"; 
  }
};

////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function(){
  var mindate =new Date(0,0,0,8,0,0)
  $(".date_ipt" ).datepicker({ 
    changeYear:true,
    changeMonth: true, 
    dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    showMonthAfterYear:true,
    showButtonPanel: true, 
    currentText: '오늘 날짜', 
    closeText: '닫기', 
    dateFormat: "yy-mm-dd"
    
});

  $(".date_ipt").datepicker('setDate', 'today');
  $(".time_ipt").timepicker(
    {
      minTime : mindate,
      defaultTime : mindate
    }
  );
};

href_gameLevel = function(tIdx, tGameLevelIdx,NowPage){
  if(NowPage == 0 || NowPage =="" )
    NowPage = 1
  post_to_url('./levelDtl.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx, 'i2': NowPage});
};

href_gameLevel2 = function(packet, NowPage){
  post_to_url('./levelDtl.asp', { 'tIdx': packet.tIdx,'tGameLevelIdx': packet.tGameLevelIdx,'tPGameLevelIdx':packet.tPGameLevelIdx,'pType':packet.pType,'iSearchText':packet.iSearchText ,'iSearchCol' :packet.iSearchCol,'i2': NowPage,'NowPage':NowPage});
};


href_back = function(tIdx, NowPage){
  post_to_url('./level.asp', { 'tIdx': tIdx,'i2': NowPage});
};


href_back2 = function(tIdx, tPGameLevelIdx, NowPage){
  post_to_url('./plevel.asp', { 'tIdx': tIdx,'tPGameLevelIdx': tPGameLevelIdx,'i2': NowPage});
};


href_LevelDtlParticipate = function (tPGameLevelIdx,tGameLevelIdx,tGameLevelDtlIdx, pType) {
  var tGameIdx = $( "#selGameIdx" ).val(); 
  post_to_url('./levelDtlParticipate.asp', { 'tIdx': tGameIdx,'tPGameLevelIdx': tPGameLevelIdx,'tGameLevelIdx': tGameLevelIdx, 'tGameLevelDtlIdx': tGameLevelDtlIdx,"pType" : pType});
};

OnPlayLevelTypeChanged = function(value) {
  if("D096EC5BB8B02F96118B096392C18758" == value){
    document.getElementById("thJooDivision").style.visibility = "visible"; 
    document.getElementById("tdJooDivision").style.visibility = "visible"; 
  }
  else {
    document.getElementById("thJooDivision").style.visibility = "hidden"; 
    document.getElementById("tdJooDivision").style.visibility = "hidden"; 
  }
};
