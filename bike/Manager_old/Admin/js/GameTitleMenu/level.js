
////////////명령어////////////

CMD_GAMELEVELLIST = 1;
CMD_MODALINSERTGAMELEVEL = 2;
CMD_INSERTGAMELEVEL = 3;
CMD_MODALUPDATEGAMELEVEL = 4;
CMD_UPDATEGAMELEVEL = 5;
CMD_DELETEGAMELEVEL = 6;
CMD_MODALGAMELEVELDTL = 7;
CMD_INSERTGAMELEVELDTL = 8;
CMD_UPDATEGAMELEVELDTL = 9;
CMD_DELETEGAMELEVELDTL = 10;
CMD_SELGAMELEVEL = 11;
CMD_SELLEVELINFO = 12;
CMD_SELGROUPGAMEGB = 13;
CMD_APPLYGAMESEEDLEVEL = 14;
CMD_APPLYGAMEJOODIVISIONLEVEL = 15;
CMD_APPLYGAMERANKLEVEL = 16;
CMD_SELGAMELEVELENTERTYPE = 17;
CMD_APPLYLEVELREMATCH = 18;


////////////명령어////////////

////////////Ajax Receive////////////

initDateContrl = false;

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {


    case CMD_SELGAMELEVEL:
      if(dataType == "html")
      {
          $('#gamelevelinput_area').html(htmldata); 
        
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
                dateFormat: "yy-mm-dd"	,
                setDate : new Date()
            });
          });

      }
    break;
    case CMD_SELGAMELEVELENTERTYPE : {

      $('#gamelevelinput_area').html(htmldata); 
      
      if (jsondata.tGameLevelIdx == ""){
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
              dateFormat: "yy-mm-dd"	,
              setDate : new Date()
          });
        });

      }
      else
      {

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
              dateFormat: "yy-mm-dd"	,
          });
        });


      }



    } break;

    case CMD_MODALINSERTGAMELEVEL:
      if(dataType == "html") {
        $('#myModal').modal('show');
        $('#myModelContent').html(htmldata); 
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
        });
      }
    break;

    case CMD_INSERTGAMELEVEL: {
      href_gameLevel(1, jsondata.tIDX)
      } 
    break;

    case CMD_APPLYLEVELREMATCH: {
      if(dataType=="json") {
        if(jsondata.result == 1) {
          alert("조 배분한 대진표를 지운 후 선택해주세요.")
        }
        else if(jsondata.result == 0) {
          alert("작업이 완료된 ")
        }
        else if(jsondata.result == 0) {
          href_gameLevel(1, jsondata.tIDX)
        }
      }
    } break;

    case CMD_DELETEGAMELEVEL : {
      href_gameLevel(jsondata.NowPage, jsondata.tIDX)
    }
    break;

    case CMD_MODALUPDATEGAMELEVEL :{

      if(dataType == "html") {
      
        $('#myModal').modal('show');

        $('#myModelContent').html(htmldata); 

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
        });
      
      }
    }
    break;

    case CMD_MODALGAMELEVELDTL :{
      $('#levelDtlModal').modal('show');
      $('#mylevelDtlModalContent').html(htmldata); 
      //console.log(jsondata)
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
        $(".date_ipt" ).datepicker('setDate', 'today');

        $('.timepicker').timepicker({
          timeFormat: 'h:mm p',
          interval: 60,
          defaultTime: '8',
          startTime: '08:00',
          dynamic: false,
          dropdown: true,
          scrollbar: true
        });
        
      });
      
      
    }
    break;

    case CMD_UPDATEGAMELEVEL :{
      href_gameLevel(jsondata.NowPage,jsondata.tIDX)
    }
    break;
    case CMD_INSERTGAMELEVELDTL:{
      if(dataType == "json") {
        ModalGameLevelDtlManage(jsondata.tGameLevelIdx,jsondata) 
      }
    }
    break;
    case CMD_SELLEVELINFO : {
      if(dataType == "html") {
        $('#divTeamGbLevel').html(htmldata); 
      }
    }
    break;
    case CMD_APPLYGAMESEEDLEVEL : {
        
      if(dataType == "html") {
        var divId = "divSeedCnt_" + jsondata.tGameLevelIDX
        $('#' + divId).html(htmldata); 
      }
    }
    break;

    case CMD_APPLYGAMERANKLEVEL : {
        
      if(dataType == "html") {
        var divId = "txtGoUpRank_" + jsondata.tGameLevelIDX
        $('#' + divId).html(htmldata); 
      }
    } break;

    case CMD_APPLYGAMEJOODIVISIONLEVEL : {
      if(dataType == "html") {
        //alert(jsondata.NowPage)
        //alert(jsondata.tIDX)
        href_gameLevel(jsondata.NowPage,jsondata.tIDX)
      }
    } break;
    default: $('#content').html(jsondata);
    break;
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////

function initDatePicker()
{
  if(initDateContrl == false ){
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
    });
    initDateContrl = true;
  }
};


function SelGameLevel(levelIdx,NowPage) {
  //암호화해야하는 URL
  Url ="/Ajax/GameTitleMenu/selGameLevel.asp"
  var tIDX = $( "#selGameTitleIdx" ).val(); 
  var packet = {};
  packet.CMD = CMD_SELGAMELEVEL;
  packet.tIDX = tIDX;
  packet.tGameLevelIdx = levelIdx;
  packet.NowPage = NowPage;

  SendPacket(Url, packet)
};


function updateGameLevel_frm(NowPage) {
  Url ="/Ajax/GameTitleMenu/updateGameLevel_frm.asp"
  var tIDX = $( "#selGameTitleIdx" ).val(); 
  var tLevelIdx = $( "#selGameLevelIdx" ).val();  
  
  if(tLevelIdx == ""){
    alert("종목 선택 후 수정해주세요")
    return;
  }
  var tTeamGB = $( "#selTeamGB" ).val();
  var tPlayType = $( "#selPlayType" ).val();
  var tGroupGameGb = $( "#selGroupGameGb" ).val();
  var tGameS = $( "#GameS" ).val();
  var tSex = $( "#selSex" ).val();
  var tViewYN = $( "#selViewYN" ).val();
  var tTeamGBLevel = $( "#selTeamGBLevel" ).val();
  var tLevelJoo = $( "#selLevelJoo" ).val(); 
  var tLevelJooNum = $( "#selLevelJooNum" ).val(); 
  var tEntertype = $( "#selEntertype" ).val(); 
  var txtPayment = $( "#txtPayment" ).val();
  var tStadiumNum = $( "#selStadiums" ).val(); 
  var tStadiumName = $( "#txtStadiumName" ).val(); 
  var tStadiumCourt = $( "#txtStadiumCourt" ).val();

  var packet = {};
  packet.CMD = CMD_UPDATEGAMELEVEL;
  packet.tIDX = tIDX;
  packet.tGameLevelIdx = tLevelIdx;
  packet.tTeamGB =  tTeamGB;
  packet.tPlayType =  tPlayType;
  packet.tTeamGBLevel = tTeamGBLevel;
  packet.tGroupGameGb =  tGroupGameGb;
  packet.tGameS =  tGameS;
  packet.tGameSex =  tSex;
  packet.tViewYN =  tViewYN;
  packet.NowPage =  NowPage;
  packet.tLevelJoo = tLevelJoo;
  packet.tLevelJooNum = tLevelJooNum;
  packet.tEntertype = tEntertype;
  packet.tPayment = txtPayment;
  packet.tStadiumNum = tStadiumNum;
  packet.tStadiumName = tStadiumName;
  packet.tStadiumCourt = tStadiumCourt;
  //console.log(packet)
  SendPacket(Url, packet);
};

function delGameLevel_frm(NowPage){
  Url ="/Ajax/GameTitleMenu/delGameLevel_frm.asp"
  var tidx = $( "#selGameTitleIdx" ).val();
  var tLevelIdx = $( "#selGameLevelIdx" ).val();  

  if(tLevelIdx == ""){
    alert("종목 선택 후 삭제해주세요")
    return;
  }
    
  var packet = {};
  packet.CMD = CMD_DELETEGAMELEVEL;
  packet.tGameLevelIDX = tLevelIdx;
  packet.tIDX = tidx
  packet.NowPage = NowPage;
  SendPacket(Url, packet)
};

function inputGameLevel_frm(NowPage) {

  Url ="/Ajax/GameTitleMenu/inputGameLevel_frm.asp"
  var tIDX = $( "#selGameTitleIdx" ).val(); 
  var tPlayType = $( "#selPlayType" ).val();
  var tGroupGameGb = $( "#selGroupGameGb" ).val();
  var tTeamGB = $( "#selTeamGB" ).val();
  var tTeamGBLevel = $( "#selTeamGBLevel" ).val();
  var tGameS = $( "#GameS" ).val();
  var tSex = $( "#selSex" ).val();
  //var tViewYN = $( "#selViewYN" ).val();
  var tLevelJoo = $( "#selLevelJoo" ).val(); 
  var tLevelJooNum = $( "#selLevelJooNum" ).val(); 
  var tEntertype = $( "#selEntertype" ).val(); 
  var txtPayment = $( "#txtPayment" ).val();
  var tStadiumNum = $( "#selStadiums" ).val(); 
  
  var tStadiumName = $( "#txtStadiumName" ).val(); 
  var tStadiumCourt = $( "#txtStadiumCourt" ).val();
  
  var packet = {};
  packet.CMD = CMD_INSERTGAMELEVEL;
  packet.tIDX = tIDX;
  packet.tPlayType =  tPlayType;
  packet.tGroupGameGb =  tGroupGameGb;
  packet.tTeamGB =  tTeamGB;
  packet.tGameS =  tGameS;
  packet.tGameSex =  tSex;
  packet.tTeamGBLevel = tTeamGBLevel;
  //packet.tViewYN =  tViewYN;
  packet.NowPage =  NowPage;
  packet.tLevelJoo = tLevelJoo;
  packet.tLevelJooNum = tLevelJooNum;
  packet.tEntertype = tEntertype;
  packet.tPayment = txtPayment;
  packet.tStadiumName = tStadiumName;
  packet.tStadiumCourt = tStadiumCourt;
  packet.tStadiumNum = tStadiumNum;
  
  SendPacket(Url, packet);
  console.log(packet);
};

function onTeamGBChanged(teamGb){
  Url = "/Ajax/GameTitleMenu/selLevelInfo.asp"
  var packet = {};
  packet.CMD = CMD_SELLEVELINFO;
  packet.TEAMGB = teamGb;
  SendPacket(Url, packet);
};

function OnGroupGameGbChanged(GroupGameGb){
  if(GroupGameGb =="B4E57B7A4F9D60AE9C71424182BA33FE") {
    document.getElementById("thGroupGameGb").style.visibility = "hidden"; 
    document.getElementById("tdGroupGameGb").style.visibility = "hidden"; 
  }else{
    document.getElementById("thGroupGameGb").style.visibility = "visible"; 
    document.getElementById("tdGroupGameGb").style.visibility = "visible"; 
  }
};


function ApplyLevelSeed(gameLevelIDX){
  Url = "/Ajax/GameTitleMenu/updateLevelSeed.asp"
  var packet = {};
  packet.CMD = CMD_APPLYGAMESEEDLEVEL;
  seedCnt = document.getElementById("txtSeedCnt_" + gameLevelIDX).value
  packet.tGameLevelIDX = gameLevelIDX;
  packet.SEEDCNT = seedCnt;
  //alert("ApplyLevelSeed")
  SendPacket(Url, packet);
};

function ApplyLevelJooDIvision(gameLevelIDX,NowPage){
  Url = "/Ajax/GameTitleMenu/updateLevelJooDIvision.asp"
  var tidx = $( "#selGameTitleIdx" ).val();
  
  var packet = {};
  packet.CMD = CMD_APPLYGAMEJOODIVISIONLEVEL;
  jooDivision = document.getElementById("txtJooDivision_" + gameLevelIDX).value
  packet.NowPage = NowPage;
  packet.tIDX = tidx
  packet.tPGameLevelIDX = gameLevelIDX;
  packet.JOODIVISION = jooDivision;
  SendPacket(Url, packet);
};


function ApplyLevelRank(gameLevelIDX){
  Url = "/Ajax/GameTitleMenu/updateLevelSeedRank.asp"
  var packet = {};
  packet.CMD = CMD_APPLYGAMERANKLEVEL;
  rankNum = document.getElementById("txtGoUpRank_" + gameLevelIDX).value
  packet.tGameLevelIDX = gameLevelIDX;
  packet.RANKNUM = rankNum;
  SendPacket(Url, packet);
};


function GameLevelList(tIDX){
  Url = "/Ajax/GameTitleMenu/GameLevelList.asp"
  var packet = {};
  packet.CMD = CMD_GAMELEVELLIST;
  packet.tIDX = tIDX;
  //console.log(packet)
  SendPacket(Url, packet);
};

function OnEnterTypeChanged(packet){
  
  //암호화해야하는 URL
  Url ="/Ajax/GameTitleMenu/selGameLevelEnterType.asp"
  var tEnterType = $( "#selEntertype" ).val(); 
  packet.CMD = CMD_SELGAMELEVELENTERTYPE;
  packet.tEnterType = tEnterType;
  //console.log(packet);
  SendPacket(Url, packet)
};

function ApplyReMatch(value){
  //암호화해야하는 URL
  Url ="/Ajax/GameTitleMenu/ApplyLevelReMatch.asp"
  var tIDX = $( "#selGameTitleIdx" ).val(); 
  var packet = {};
  packet.CMD = CMD_APPLYLEVELREMATCH;
  packet.tIDX = tIDX;
  packet.tGameLevelIdx = value;
  SendPacket(Url, packet)
};

function href_PLevel(tIdx, tPGameLevelIdx){
  post_to_url('./plevel.asp', { 'tIdx': tIdx,'tPGameLevelIdx': tPGameLevelIdx});
};
////////////Custom Function////////////
$(document).ready(function(){
  init();
}); 

init = function(){
  $(".date_ipt").datepicker('setDate', 'today');
  radio_btn();
  radio_btn1();
};

href_LevelDtl = function(packet){
  post_to_url('./levelDtl.asp', { 'tIdx': packet.tIdx,'tGameLevelIdx': packet.tGameLevelIdx,'pType':"level", 'beforeNowPage':packet.NowPage});
};

/*
href_Participate = function(tIdx,tGameLevelIdx){
  post_to_url('./participate.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx, 'pType':"level"});
};
*/

href_Participate = function(packet){
  post_to_url('./participate.asp', { 'tIdx': packet.tIdx,'tGameLevelIdx': packet.tGameLevelIdx, 'pType':"level", 'beforeNowPage':packet.NowPage});
};


href_ParticipateTeam = function(tIdx,tGameLevelIdx){
  post_to_url('./participateTeam.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx});
};


href_gameLevel = function(NowPage,tIdx){
  post_to_url('./level.asp', {'i2': NowPage, 'tIdx': tIdx});
};

href_back = function(NowPage){
  post_to_url('./index.asp', { 'i2': NowPage});
};

href_GameNumber = function(tIdx) {

  popupOpen('./SettingGameOrder.asp');
  
  //post_to_url_openType('./GameNumber.asp','',{ 'tIdx' : tIdx },'_blank');
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

  tGameTitleIdx = $("#selGameTitleIdx").val(); 
  var popUrl = addrs; //팝업창에 출력될 페이지 URL
  var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
  window.open(popUrl,"JoResult",popOption);

  post_to_url_popup('JoResult', './' + addrs, { 'tGameTitleIdx': tGameTitleIdx});

  
};


var selectRadioBtn = {};

OnJooChecked = function(Ctrl)
{
  Ctrl.style.class = "on"
  //$(this).addClass("on");
  

  //Ctrl.style.backgroundColor="red";


};


function radio_btn()
{
  $(".radio_btn").eq(0).addClass("on");

  $(".radio_btn").click (function(){
    $(".radio_btn").removeClass("on");
    $(this).addClass("on");
  })
};


function radio_btn1()
{
  $(".radio_btn1").eq(0).addClass("on");

  $(".radio_btn1").click (function(){
    $(".radio_btn1").removeClass("on");
    $(this).addClass("on");
  })
};