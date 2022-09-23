

////////////명령어////////////

CMD_SELGAMETITLE = 1;
CMD_INSERTGAMETITLE = 2;
CMD_GAMETITLEMENULIST = 3;
CMD_DELGAMETITLE = 4;
CMD_UPDATEGAMETITLE = 5;
CMD_SELGAMETITLELIST = 6;
CMD_SEARCHGAMETITLE = 7;

////////////명령어////////////

////////////Ajax Receive////////////

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SELGAMETITLE:
          if(dataType == "html")
          {
            $('#formGameTitle').html(htmldata); 
            SetControlDatePicker();
          }
        break;
    case CMD_INSERTGAMETITLE:
        //console.log(jsondata)
        SelGameTitle(jsondata.tIdx, 1)
        searchGameTitle(searchObj, false)
        break;
    case CMD_DELGAMETITLE : 
        searchGameTitle(searchObj, false)
      break;
    case CMD_UPDATEGAMETITLE : 
        searchObj.NowPage = jsondata.NowPage;
        console.log(searchObj)
        //SelGameTitle(jsondata.tIDX,jsondata.NowPage)
        searchGameTitle(searchObj, false)
        //href_gametitle(jsondata.NowPage)
      break;
    case CMD_SELGAMETITLELIST : 
        if(dataType == "html"){$('#contest').html(htmldata); }
      break;
    case CMD_SEARCHGAMETITLE :
    { 
      if(dataType == "html")
      {
        $('#schDivResult').html(htmldata); 

        searchObj.tGameNationType = jsondata.tGameNationType;
        searchObj.tSido = jsondata.tSido;
        searchObj.tSearchText = jsondata.tSearchText;
        searchObj.NowPage = jsondata.NowPage;
        console.log(searchObj);

      }
    }break;
    default:
        href_gametitle(1)
      break;
  }
};

function SetControlDatePicker()
{
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

    $( "#GameRcvS" ).datepicker({ 
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

    $( "#GameRcvE" ).datepicker({ 
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

////////////Ajax Receive////////////

////////////Custom Function////////////
function SelGameTitle(tIDX,NowPage) {
  //암호화해야하는 URL
  Url ="/Ajax/GameTitleMenu/selGameTitleMenuInfo.asp"
  var packet = {};
  packet.CMD = CMD_SELGAMETITLE;
  packet.tIDX = tIDX;
  packet.NowPage = NowPage;
  SendPacket(Url, packet);
};

function SelGameTitleList() {
  //암호화해야하는 URL
  Url ="/Ajax/GameTitleMenu/selGameTitleMenuList.asp"
  var packet = {};
  packet.CMD = CMD_SELGAMETITLELIST
 
  SendPacket(Url, packet)
};

function selEntertypeChanged(obj){
  if($(obj).val() == "E"){
    $("#GameSet_Name").show();
    $("#GameSet").show();
    $("#GameSet_Name_Ama").hide();
    $("#GameSet_Ama").hide();
    //$("#GameSet_Name").css("display","");
    //$("#GameSet").css("display","");    
    //$("#GameSet_Name_Ama").css("display","none");
    //$("#GameSet_Ama").css("display","none");
  }
  else if($(obj).val() == "A"){
    $("#GameSet_Name").hide();
    $("#GameSet").hide();
    $("#GameSet_Name_Ama").show();
    $("#GameSet_Ama").show();    
    //$("#GameSet_Name").css("display","none");
    //$("#GameSet").css("display","none");    
    //$("#GameSet_Name_Ama").css("display","");
    //$("#GameSet_Ama").css("display","");
  }  
  else{
    $("#GameSet_Name").show();
    $("#GameSet").show();
    $("#GameSet_Name_Ama").show();
    $("#GameSet_Ama").show();       
    //$("#GameSet_Name").css("display","");
    //$("#GameSet").css("display","");    
    //$("#GameSet_Name_Ama").css("display","");
    //$("#GameSet_Ama").css("display","");    
  }
}

inputGameTitle_frm = function(NowPage) {

    //암호화해야하는 URL
    Url ="/Ajax/GameTitleMenu/inputGameTitle_frm.asp";
    selNationType = $( "#SelNationType" ).val();
    txtGameTitleName = $( "#txtGameTitleName" ).val();
    GameS = $( "#GameS" ).val();
    GameE = $( "#GameE" ).val();
    GameRcvS = $( "#GameRcvS" ).val();
    GameRcvE = $( "#GameRcvE" ).val();
    SelGameTitleLocation = $( "#SelGameTitleLocation" ).val();
    selEntertype = $( "#selEntertype" ).val();
    selViewYN = $( "#selViewYN" ).val();
    selEntryViewYN = $( "#selEntryViewYN" ).val();
    txtGamePlace = $( "#txtGamePlace" ).val();
    txtGameTitleHost = $( "#txtGameTitleHost" ).val();
    txtGameTitleOldIDX = $( "#txtGameTitleOldIDX" ).val();

    MaxPoint = $( "#schMaxPoint" ).val();
    RallyPoint = $( "#schRallyPoint" ).val();
    DeuceYN = $( "#schDeuceYN" ).val();
    MaxPoint_Ama = $( "#schMaxPoint_Ama" ).val();
    RallyPoint_Ama = $( "#schRallyPoint_Ama" ).val();
    DeuceYN_Ama = $( "#schDeuceYN_Ama" ).val();
    
    
    var packet = {};
    packet.CMD = CMD_INSERTGAMETITLE;
    packet.NationType = selNationType;
    packet.GameTitleName = txtGameTitleName;
    packet.GameStartDate = GameS;
    packet.GameEndDate = GameE;
    packet.GameRcvDateS = GameRcvS;
    packet.GameRcvDateE = GameRcvE;
    packet.GameTitleLocation = SelGameTitleLocation;
    packet.EnterType = selEntertype;
    packet.NationType = selNationType;
    packet.ViewYN = selViewYN;
    packet.EntryViewYN = selEntryViewYN;
    packet.GameTitleHost = txtGameTitleHost;
    packet.GamePlace = txtGamePlace;
    packet.NowPage = NowPage;
    packet.GameTitleOldIDX = txtGameTitleOldIDX;

    packet.MaxPoint = MaxPoint;
    packet.RallyPoint = RallyPoint;
    packet.DeuceYN = DeuceYN;
    packet.MaxPoint_Ama = MaxPoint_Ama;
    packet.RallyPoint_Ama = RallyPoint_Ama;
    packet.DeuceYN_Ama = DeuceYN_Ama;
    
    SendPacket(Url, packet);
  };

delGameTitle_frm = function (NowPage) {
  tIDX = $( "#selGameTitleIdx" ).val();
  Url ="/Ajax/GameTitleMenu/delGameTitle_frm.asp";
  var packet = {};
  packet.CMD = CMD_DELGAMETITLE;
  packet.tIDX = tIDX;
  packet.NowPage = NowPage;
  SendPacket(Url, packet);
};


searchGameTitle = function (packet, IsGetCtrlData) {
  //alert("하이")
  Url ="/Ajax/GameTitleMenu/schGameTitle.asp";

  if(IsGetCtrlData) {
    selGameNationType = $( "#schSelGameNationType" ).val();
    selSido = $( "#schSelSido" ).val();
    txtSearchText = $( "#schtxtGameTitleName" ).val();
    packet.tGameNationType = selGameNationType;
    packet.tSido = selSido;
    packet.tSearchText = txtSearchText;
    packet.NowPage = 1;
  }

  packet.CMD = CMD_SEARCHGAMETITLE;

  SendPacket(Url, packet);
};

updateGameTitle_frm = function (packet) {
  
  idx = $( "#selGameTitleIdx" ).val();
  selNationType = $( "#SelNationType" ).val();
  txtGameTitleName = $( "#txtGameTitleName" ).val();
  GameS = $( "#GameS" ).val();
  GameE = $( "#GameE" ).val();
  GameRcvS = $( "#GameRcvS" ).val();
  GameRcvE = $( "#GameRcvE" ).val();
  SelGameTitleLocation = $( "#SelGameTitleLocation" ).val();
  txtGamePlace = $( "#txtGamePlace" ).val();
  selEntertype = $( "#selEntertype" ).val();
  selViewYN = $( "#selViewYN" ).val();
  txtGameTitleHost = $( "#txtGameTitleHost" ).val();
  selEntryViewYN = $( "#selEntryViewYN" ).val();
  txtGameTitleOldIDX = $( "#txtGameTitleOldIDX" ).val();

  MaxPoint = $( "#schMaxPoint" ).val();
  RallyPoint = $( "#schRallyPoint" ).val();
  DeuceYN = $( "#schDeuceYN" ).val();
  MaxPoint_Ama = $( "#schMaxPoint_Ama" ).val();
  RallyPoint_Ama = $( "#schRallyPoint_Ama" ).val();
  DeuceYN_Ama = $( "#schDeuceYN_Ama" ).val();  
  
  Url ="/Ajax/GameTitleMenu/updateGameTitle_frm.asp";
  
  packet.CMD = CMD_UPDATEGAMETITLE;
  packet.tIDX = idx;
  packet.NationType = selNationType;
  packet.GameTitleName = txtGameTitleName;
  packet.GameStartDate = GameS;
  packet.GameEndDate = GameE;
  packet.GameRcvDateS = GameRcvS;
  packet.GameRcvDateE = GameRcvE;
  packet.GameTitleLocation = SelGameTitleLocation;
  packet.EnterType = selEntertype;
  packet.NationType = selNationType;
  packet.ViewYN = selViewYN;
  packet.GameTitleHost = txtGameTitleHost;
  packet.EntryViewYN = selEntryViewYN;
  packet.GamePlace = txtGamePlace;
  packet.GameTitleOldIDX = txtGameTitleOldIDX;

  packet.MaxPoint = MaxPoint;
  packet.RallyPoint = RallyPoint;
  packet.DeuceYN = DeuceYN;
  packet.MaxPoint_Ama = MaxPoint_Ama;
  packet.RallyPoint_Ama = RallyPoint_Ama;
  packet.DeuceYN_Ama = DeuceYN_Ama;  
  
  
  //console.log(packet)
  SendPacket(Url, packet);
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

    $( "#GameRcvS" ).datepicker({ 
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

    $( "#GameRcvE" ).datepicker({ 
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

href_gametitle = function(NowPage){
  post_to_url('./index.asp', { 'i2': NowPage});
}

href_level = function(tIdx){
  post_to_url('./level.asp', { 'tIDX': tIdx});
};

href_stadium = function(tIdx){
  post_to_url('./stadium.asp', { 'tIDX': tIdx});
};

href_addinfo = function(tIdx, NowPage){
  post_to_url('./GameTitleDtl_Write.asp', { 'tIDX': tIdx, 'i2': NowPage});
};

href_refereeinfo = function(tIdx, NowPage, valType){
	if(valType=='MOD') post_to_url('./GameTitle_Referee.asp', { 'tIDX': tIdx, 'i2': NowPage});
	else post_to_url('./GameTitle_Referee_Mod.asp', { 'tIDX': tIdx, 'i2': NowPage});	
};