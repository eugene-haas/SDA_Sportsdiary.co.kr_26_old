
////////////명령어////////////

CMD_SELGAMETITLE = 1;
CMD_INSERTGAMETITLE = 2;
CMD_GAMETITLEMENULIST = 3;
CMD_DELGAMETITLE = 4;
CMD_UPDATEGAMETITLE = 5;
CMD_SELGAMETITLELIST = 6;

////////////명령어////////////

////////////Ajax Receive////////////

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SELGAMETITLE:
          if(dataType == "html")
          {
            $('#formGameTitle').html(htmldata); 
            $(function() {
   
              $( "#GameS" ).datepicker({ 
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
          
              $( "#GameE" ).datepicker({ 
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
    case CMD_INSERTGAMETITLE:
      SelGameTitleList();
        break;
    case CMD_DELGAMETITLE : 
      SelGameTitleList();
      break;
    case CMD_UPDATEGAMETITLE : 
      SelGameTitleList();
      break;
    case CMD_SELGAMETITLELIST : 
        if(dataType == "html"){$('#contest').html(htmldata); }
      break;
    default:
      $(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
      break;
  }
};

  

////////////Ajax Receive////////////

////////////Custom Function////////////
function SelGameTitle(idx) {
  //암호화해야하는 URL
  Url ="/Ajax/GameTitleMenu/selGameTitleMenuInfo.asp"
  var packet = {};
  packet.CMD = CMD_SELGAMETITLE
  packet.idx = idx
  SendPacket(Url, packet)
};

function SelGameTitleList() {
  //암호화해야하는 URL
  Url ="/Ajax/GameTitleMenu/selGameTitleMenuList.asp"
  var packet = {};
  packet.CMD = CMD_SELGAMETITLELIST
 
  SendPacket(Url, packet)
};


inputGameTitle_frm = function() {

    //암호화해야하는 URL
    Url ="/Ajax/GameTitleMenu/inputGameTitle_frm.asp"
    selNationType = $( "#SelNationType" ).val();
    txtGameTitleName = $( "#txtGameTitleName" ).val();
    txtGamePlace = $( "#txtGamePlace" ).val();
    GameS = $( "#GameS" ).val();
    GameE = $( "#GameE" ).val();
    SelGameTitleLocation = $( "#SelGameTitleLocation" ).val();
    selEntertype = $( "#selEntertype" ).val();
    selViewYN = $( "#selViewYN" ).val();

    var packet = {};
    packet.CMD = CMD_INSERTGAMETITLE
    packet.NationType = selNationType
    packet.GameTitleName = txtGameTitleName
    packet.GamePlace = txtGamePlace
    packet.GameStartDate = GameS
    packet.GameEndDate = GameE
    packet.GameTitleLocation = SelGameTitleLocation
    packet.EnterType = selEntertype
    packet.NationType = selNationType
    packet.ViewYN = selViewYN

    SendPacket(Url, packet)
  };

delGameTitle_frm = function () {

  idx = $( "#selGameTitleIdx" ).val();

  Url ="/Ajax/GameTitleMenu/delGameTitle_frm.asp"
  var packet = {};
  packet.CMD = CMD_DELGAMETITLE
  packet.IDX = idx
  SendPacket(Url, packet)
};

updateGameTitle_frm = function () {

  idx = $( "#selGameTitleIdx" ).val();
  selNationType = $( "#SelNationType" ).val();
  txtGameTitleName = $( "#txtGameTitleName" ).val();
  txtGamePlace = $( "#txtGamePlace" ).val();
  GameS = $( "#GameS" ).val();
  GameE = $( "#GameE" ).val();
  SelGameTitleLocation = $( "#SelGameTitleLocation" ).val();
  selEntertype = $( "#selEntertype" ).val();
  selViewYN = $( "#selViewYN" ).val();

  Url ="/Ajax/GameTitleMenu/updateGameTitle_frm.asp"
  var packet = {};
  packet.CMD = CMD_UPDATEGAMETITLE
  packet.IDX = idx
  packet.NationType = selNationType
  packet.GameTitleName = txtGameTitleName
  packet.GamePlace = txtGamePlace
  packet.GameStartDate = GameS
  packet.GameEndDate = GameE
  packet.GameTitleLocation = SelGameTitleLocation
  packet.EnterType = selEntertype
  packet.NationType = selNationType
  packet.ViewYN = selViewYN
  console.log(packet)
  SendPacket(Url, packet)
};

////////////Custom Function////////////

$(document).ready(function(){
  init();
}); 

init = function(){
  $(function() {
   
    $( "#GameS" ).datepicker({ 
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

    $( "#GameE" ).datepicker({ 
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
};


href_level = function(idx, titleName){
	location.href="./level.asp?tIDX="+idx 
};
