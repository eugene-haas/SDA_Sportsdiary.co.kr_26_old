////////////명령어////////////

CMD_SELGAMETITLE = 1;


CMD_INSERTGAMETITLE = 2;
CMD_GAMETITLEMENULIST = 3;
CMD_DELGAMETITLE = 4;
CMD_UPDATEGAMETITLE = 5;
CMD_SELGAMETITLELIST = 6;
CMD_SEARCHGAMETITLE = 7;

CMD_SETFLAGAPPLYGAME = 100; //by 100

////////////명령어////////////

////////////Ajax Receive////////////

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {

  switch(CMD) {
    case CMD_SETFLAGAPPLYGAME: return; break;

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
        alert("대회가 정상적으로 등록되었습니다.");
        location.reload();
        break;
    case CMD_DELGAMETITLE :
        alert("삭제 되었습니다.");
        searchGameTitle(searchObj, false)
        location.reload();
      break;
    case CMD_UPDATEGAMETITLE :
        searchObj.NowPage = jsondata.NowPage;
        console.log(searchObj)
        //SelGameTitle(jsondata.tIDX,jsondata.NowPage)
        alert("내용이 수정되었습니다.");
        searchGameTitle(searchObj, false)
        location.reload();
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

    $( "#GameOpenS" ).datepicker({
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

    $( "#GameOpenE" ).datepicker({
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

  $('#GameRcvS_Time').timepicker({  /* 접수시작시간  */
      timeFormat: 'HH:mm',
      interval: 10,
     // defaultTime: '00:10',
      startTime: '00:10',
	  minHour : 00,
	  minMinutes: 10,
    dynamic: false,
    dropdown: true,
    scrollbar: true
  });

  $('#GameRcvE_Time').timepicker({ /* 접수종료시간  */
      timeFormat: 'HH:mm',
      interval: 10,
     // defaultTime: '00:10',
      startTime: '00:10',
	  minHour : 00,
	  minMinutes: 10,
    dynamic: false,
    dropdown: true,
    scrollbar: true
  });

  $('#GameOpenS_Time').timepicker({  /* 열람시작시간  */
      timeFormat: 'HH:mm',
      interval: 10,
     // defaultTime: '00:10',
      startTime: '00:10',
	  minHour : 00,
	  minMinutes: 10,
    dynamic: false,
    dropdown: true,
    scrollbar: true
  });

  $('#GameOpenE_Time').timepicker({ /* 열람종료시간 */
      timeFormat: 'HH:mm',
      interval: 10,
      //defaultTime: '00:10',
      startTime: '00:10',
	  minHour : 00,
	  minMinutes: 10,
    dynamic: false,
    dropdown: true,
    scrollbar: true
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

function onchangeDeuceYN(gubun){
  if(gubun == "E"){

    if($("#schDeuceYN").val() == "N"){
      $("#schMaxPoint").attr("disabled", true);
    }
    else{
      $("#schMaxPoint").attr("disabled", false);
    }
  }
  else{
    if($("#schDeuceYN_Ama").val() == "N"){
      $("#schMaxPoint_Ama").attr("disabled", true);
    }
    else{
      $("#schMaxPoint_Ama").attr("disabled", false);
    }

  }

}

function selEntertypeChanged(obj){
  if($(obj).val() == "E"){
    $("#GameSet_Name").show();
    $("#GameSet").show();
    $("#GameSet_Name_Ama").hide();
    $("#GameSet_Ama").hide();

    $("#DP_PersonRule").css("display","none");
    $("#DP_GroupRule").css("display","none");

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

    $("#DP_PersonRule").css("display","");
    $("#DP_GroupRule").css("display","");
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
  function onchange_personrule(strnum){
    for(i=1;i<=7;i++){
      if(i != strnum){
        if( $("#WinRule_Person_" + strnum).val() == $("#WinRule_Person_" + i).val()){
          $("#WinRule_Person_" + i).val("");
        }
      }
    }
  }

  function onchange_grouprule(strnum){
    for(i=1;i<=7;i++){
      if(i != strnum){
        if( $("#WinRule_Group_" + strnum).val() == $("#WinRule_Group_" + i).val()){
          $("#WinRule_Group_" + i).val("");
        }
      }
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



      GameRcvS_Time = $( "#GameRcvS_Time" ).val();
      GameRcvE_Time = $( "#GameRcvE_Time" ).val();

      GameOpenS = $("#GameOpenS").val();
      GameOpenE = $("#GameOpenE").val();

      GameOpenS_Time = $( "#GameOpenS_Time" ).val();
      GameOpenE_Time = $( "#GameOpenE_Time" ).val();


      EntryPersonPay = $("#EntryPersonPay").val();
      EntryGroupPay = $("#EntryGroupPay").val();

      SelGameTitleLocation = $( "#SelGameTitleLocation" ).val();
      selEntertype = $( "#selEntertype" ).val();
      selViewYN = $( "#selViewYN" ).val();
  	MobileViewYN  = $( "#MobileViewYN" ).val();
      selEntryViewYN = $( "#selEntryViewYN" ).val();

      selMatchesListViewYN= $( "#selMatchesListViewYN" ).val();

      txtGamePlace = $( "#txtGamePlace" ).val();
      txtGameTitleHost = $( "#txtGameTitleHost" ).val();
      txtGameTitleOldIDX = $( "#txtGameTitleOldIDX" ).val();

  	GameTitleSupervision = $( "#GameTitleSupervision" ).val(); //주관
  	GameTitleSponsor = $("#GameTitleSponsor").val(); //후원
  	GameGoodsSponsor =$("#GameGoodsSponsor").val(); // 용품협찬
  	GameTitleETC = $("#GameTitleETC").val();  //기타사항

  	CrossTourneyType = $("#CrossTourneyType").val();  //크로스대진방식
  	UniformYN =  $("#UniformYN").val();  //유니폼신청
  	WinToWinYN  =  $("#WinToWinYN").val();  //승자승사용여부
  	TeamType = $("#TeamType").val();   //출전선수등록방식
  	TeamScoreHalf  =  $("#TeamScoreHalf").val(); //단체전점수분배
  	MedalGang  = $("#MedalGang").val(); // 실적적용강수

  	MaxPoint = $( "#schMaxPoint" ).val();
      RallyPoint = $( "#schRallyPoint" ).val();
      DeuceYN = $( "#schDeuceYN" ).val();
      MaxPoint_Ama = $( "#schMaxPoint_Ama" ).val();
      RallyPoint_Ama = $( "#schRallyPoint_Ama" ).val();
      DeuceYN_Ama = $( "#schDeuceYN_Ama" ).val();

  	MainViewYN = $("#MainViewYN").val();

    schoolCHKYN = $("#schoolCHKYN").val();

    LiveViewYN = $("#selLiveViewYN").val();

    EntryChk_OldYN = $("#EntryChk_OldYN").val();
    EntryChk_RankYN = $("#EntryChk_RankYN").val();
    EntryChk_SameOldRankYN = $("#EntryChk_SameOldRankYN").val();

    WinRule_Person_1 = $("#WinRule_Person_1").val();
    WinRule_Person_2 = $("#WinRule_Person_2").val();
    WinRule_Person_3 = $("#WinRule_Person_3").val();
    WinRule_Person_4 = $("#WinRule_Person_4").val();
    WinRule_Person_5 = $("#WinRule_Person_5").val();
    WinRule_Person_6 = $("#WinRule_Person_6").val();
    WinRule_Person_7 = $("#WinRule_Person_7").val();

    var Rule_PersonCnt = 1;

    for(i=7;i>=1;i--){
      if($("#WinRule_Person_" + i).val() != ""){
        Rule_PersonCnt = i;
        console.log("asd:" + i);
        break;
      }
    }

    for(i=1;i<=Rule_PersonCnt;i++){
      if($("#WinRule_Person_" + i).val() == ""){
        alert("개인전 승패조건 " + i + "번째 조건이 선택되지 않았습니다. 선택해 주시기 바랍니다.");
        return;
      }
    }

    WinRule_Group_1 = $("#WinRule_Group_1").val();
    WinRule_Group_2 = $("#WinRule_Group_2").val();
    WinRule_Group_3 = $("#WinRule_Group_3").val();
    WinRule_Group_4 = $("#WinRule_Group_4").val();
    WinRule_Group_5 = $("#WinRule_Group_5").val();
    WinRule_Group_6 = $("#WinRule_Group_6").val();
    WinRule_Group_7 = $("#WinRule_Group_7").val();

    var Rule_GroupCnt = 1;

    for(i=7;i>=1;i--){
      if($("#WinRule_Group_" + i).val() != ""){
        Rule_GroupCnt = i;
        console.log("asd:" + i);
        break;
      }
    }

    for(i=1;i<=Rule_GroupCnt;i++){
      if($("#WinRule_Group_" + i).val() == ""){
        alert("단체전 승패조건 " + i + "번째 조건이 선택되지 않았습니다. 선택해 주시기 바랍니다.");
        return;
      }
    }


    console.log("Rule_PersonCnt:" + Rule_PersonCnt);

    console.log("WinRule_Person_1:" + WinRule_Person_1);
    console.log("WinRule_Person_2:" + WinRule_Person_2);
    console.log("WinRule_Person_3:" + WinRule_Person_3);
    console.log("WinRule_Person_4:" + WinRule_Person_4);
    console.log("WinRule_Person_5:" + WinRule_Person_5);
    console.log("WinRule_Person_6:" + WinRule_Person_6);
    console.log("WinRule_Person_7:" + WinRule_Person_7);

    console.log("WinRule_Group_1:" + WinRule_Group_1);
    console.log("WinRule_Group_2:" + WinRule_Group_2);
    console.log("WinRule_Group_3:" + WinRule_Group_3);
    console.log("WinRule_Group_4:" + WinRule_Group_4);
    console.log("WinRule_Group_5:" + WinRule_Group_5);
    console.log("WinRule_Group_6:" + WinRule_Group_6);
    console.log("WinRule_Group_7:" + WinRule_Group_7);



      var packet = {};
      packet.CMD = CMD_INSERTGAMETITLE;
      packet.NationType = selNationType;
      packet.GameTitleName = txtGameTitleName;

      packet.GameStartDate = GameS;
      packet.GameEndDate = GameE;

      packet.GameRcvDateS = GameRcvS;
      packet.GameRcvDateE = GameRcvE;

      packet.GameRcvTimeS = GameRcvS_Time;
      packet.GameRcvTimeE = GameRcvE_Time;

      packet.GameOpenS = GameOpenS;
      packet.GameOpenE = GameOpenE;

      packet.GameOpenSTime = GameOpenS_Time;
      packet.GameOpenETime = GameOpenE_Time;

      packet.EntryPersonPay = EntryPersonPay;
      packet.EntryGroupPay = EntryGroupPay;

      packet.GameTitleLocation = SelGameTitleLocation;
      packet.EnterType = selEntertype;
      packet.NationType = selNationType;
      packet.ViewYN = selViewYN;
  	packet.MobileViewYN = MobileViewYN;
      packet.EntryViewYN = selEntryViewYN;
      packet.MatchesListViewYN = selMatchesListViewYN;

      packet.GameTitleHost = txtGameTitleHost;
      packet.GamePlace = txtGamePlace;
      packet.NowPage = NowPage;
      packet.GameTitleOldIDX = txtGameTitleOldIDX;
      packet.GameTitleSupervision = GameTitleSupervision; //주관
      packet.GameTitleSponsor = GameTitleSponsor; //후원
      packet.GameGoodsSponsor = GameGoodsSponsor; //용품협찬
      packet.GameTitleETC = GameTitleETC; //기타사항
  	packet.CrossTourneyType = CrossTourneyType; //크로스대진방식
  	packet.UniformYN =  UniformYN; //유니폼신청
  	packet.WinToWinYN  = WinToWinYN; //승자승사용여부
  	packet.TeamType =TeamType; //출전선수등록방식
  	packet.TeamScoreHalf  =  TeamScoreHalf; //단체전점수분배
  	packet.MedalGang  =MedalGang; // 실적적용강수

      packet.MaxPoint = MaxPoint;
      packet.RallyPoint = RallyPoint;
      packet.DeuceYN = DeuceYN;
      packet.MaxPoint_Ama = MaxPoint_Ama;
      packet.RallyPoint_Ama = RallyPoint_Ama;
      packet.DeuceYN_Ama = DeuceYN_Ama;

  	packet.MainViewYN = MainViewYN;

    packet.schoolCHKYN = schoolCHKYN;

    packet.LiveViewYN = LiveViewYN;


    packet.EntryChk_OldYN = EntryChk_OldYN;
    packet.EntryChk_RankYN = EntryChk_RankYN;
    packet.EntryChk_SameOldRankYN = EntryChk_SameOldRankYN;

    packet.WinRule_Person_1 = WinRule_Person_1;
    packet.WinRule_Person_2 = WinRule_Person_2;
    packet.WinRule_Person_3 = WinRule_Person_3;
    packet.WinRule_Person_4 = WinRule_Person_4;
    packet.WinRule_Person_5 = WinRule_Person_5;
    packet.WinRule_Person_6 = WinRule_Person_6;
    packet.WinRule_Person_7 = WinRule_Person_7;

    packet.WinRule_Group_1 = WinRule_Group_1;
    packet.WinRule_Group_2 = WinRule_Group_2;
    packet.WinRule_Group_3 = WinRule_Group_3;
    packet.WinRule_Group_4 = WinRule_Group_4;
    packet.WinRule_Group_5 = WinRule_Group_5;
    packet.WinRule_Group_6 = WinRule_Group_6;
    packet.WinRule_Group_7 = WinRule_Group_7;

      SendPacket(Url, packet);
    };

delGameTitle_frm = function (NowPage) {
  if(confirm("삭제 시, 복구가 불가능합니다. 정말로 삭제하시겠습니까?")){
    tIDX = $( "#selGameTitleIdx" ).val();
    Url ="/Ajax/GameTitleMenu/delGameTitle_frm.asp";
    var packet = {};
    packet.CMD = CMD_DELGAMETITLE;
    packet.tIDX = tIDX;
    packet.NowPage = NowPage;
    SendPacket(Url, packet);
  }
};



searchGameTitle = function (packet, IsGetCtrlData) {

  Url ="/Ajax/GameTitleMenu/schGameTitle.asp";


  if(IsGetCtrlData) {
    selGameNationType = $( "#schSelGameNationType" ).val();
    selSido = $( "#schSelSido" ).val();
    txtSearchText = $( "#schtxtGameTitleName" ).val();
    schSelEnterType = $( "#schSelEnterType" ).val();
    packet.tGameNationType = selGameNationType;
    packet.tSido = selSido;
    packet.tSearchText = txtSearchText;
    packet.tEnterType = schSelEnterType;
    packet.NowPage = 1;
  }

  packet.CMD = CMD_SEARCHGAMETITLE;

  SendPacket(Url, packet);
};


searchGameTitle1 = function (packet, IsGetCtrlData) {

  Url ="/Ajax/GameTitleMenu/schGameTitle.asp";


  if(IsGetCtrlData) {
    schSelGameYear = $( "#schSelGameYear" ).val();
    schSelEnterType = $( "#schSelEnterType" ).val();
    selGameNationType = $( "#schSelGameNationType" ).val();
    selSido = $( "#schSelSido" ).val();
    txtSearchText = $( "#schtxtGameTitleName" ).val();

    packet.tGameYear = schSelGameYear;
    packet.tEnterType = schSelEnterType;
    packet.tGameNationType = selGameNationType;
    packet.tSido = selSido;
    packet.tSearchText = txtSearchText;
    packet.NowPage = 1;
  }

  packet.CMD = CMD_SEARCHGAMETITLE;

  SendPacket(Url, packet);
};


updateGameTitle_frm = function (packet) {

  var timeRegExp = /^([1-9]|[01][0-9]|2[0-3]):([0-5][0-9])$/;
  var dateRegExp = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;

  idx = $( "#selGameTitleIdx" ).val();
  selNationType = $( "#SelNationType" ).val();
  txtGameTitleName = $( "#txtGameTitleName" ).val();
  GameS = $( "#GameS" ).val();
  GameE = $( "#GameE" ).val();
  GameRcvS = $( "#GameRcvS" ).val();
  GameRcvE = $( "#GameRcvE" ).val();

  if(GameS != ""){
    if(dateRegExp.test(GameS) == false){
      alert('대회시작일은 날짜형식으로 입력해 주시기 바랍니다.(예:2018-01-01)');
      return;
    }
  }

  if(GameE != ""){
    if(dateRegExp.test(GameE) == false){
      alert('대회종료일은 날짜형식으로 입력해 주시기 바랍니다.(예:2018-01-01)');
      return;
    }
  }

  if(GameRcvS != ""){
    if(dateRegExp.test(GameRcvS) == false){
      alert('접수시작일은 날짜형식으로 입력해 주시기 바랍니다.(예:2018-01-01)');
      return;
    }
  }

  if(GameRcvE != ""){
    if(dateRegExp.test(GameRcvE) == false){
      alert('접수종료일은 날짜형식으로 입력해 주시기 바랍니다.(예:2018-01-01)');
      return;
    }
  }




  GameRcvS_Time = $( "#GameRcvS_Time" ).val();
  GameRcvE_Time = $( "#GameRcvE_Time" ).val();

  if (GameRcvS_Time != ""){
    if(timeRegExp.test(GameRcvS_Time) == false){
      alert('접수시작 시간은 00:00 ~ 23:59 사이 시간을 입력하시기 바랍니다');
      return;
    }
  }

  if (GameRcvE_Time != ""){
    if(timeRegExp.test(GameRcvE_Time) == false){
      alert('접수종료 시간은 00:00 ~ 23:59 사이 시간을 입력하시기 바랍니다');
      return;
    }
  }


  GameOpenS = $("#GameOpenS").val();
  GameOpenE = $("#GameOpenE").val();

  GameOpenS_Time = $( "#GameOpenS_Time" ).val();
  GameOpenE_Time = $( "#GameOpenE_Time" ).val();

  if (GameOpenS_Time != ""){
    if(timeRegExp.test(GameOpenS_Time) == false){
      alert('열람시작 시간은 00:00 ~ 23:59 사이 시간을 입력하시기 바랍니다');
      return;
    }
  }

  if (GameOpenE_Time != ""){
    if(timeRegExp.test(GameOpenE_Time) == false){
      alert('열람종료 시간은 00:00 ~ 23:59 사이 시간을 입력하시기 바랍니다');
      return;
    }
  }

  EntryPersonPay = $("#EntryPersonPay").val();
  EntryGroupPay = $("#EntryGroupPay").val();

  SelGameTitleLocation = $( "#SelGameTitleLocation" ).val();
  txtGamePlace = $( "#txtGamePlace" ).val();
  selEntertype = $( "#selEntertype" ).val();
  selViewYN = $( "#selViewYN" ).val();
  MobileViewYN = $("#MobileViewYN").val();
  selMatchesListViewYN= $( "#selMatchesListViewYN" ).val();

  txtGameTitleHost = $( "#txtGameTitleHost" ).val();
  selEntryViewYN = $( "#selEntryViewYN" ).val();
  txtGameTitleOldIDX = $( "#txtGameTitleOldIDX" ).val();

 GameTitleSupervision = $( "#GameTitleSupervision" ).val(); //주관
 GameTitleSponsor = $("#GameTitleSponsor").val(); //후원
 GameGoodsSponsor =$("#GameGoodsSponsor").val(); // 용품협찬
 GameTitleETC = $("#GameTitleETC").val();  //기타사항
 CrossTourneyType = $("#CrossTourneyType").val() ; //크로스대진방식
 UniformYN =  $("#UniformYN").val();  //유니폼신청
 WinToWinYN  =  $("#WinToWinYN").val();  //승자승사용여부
 TeamType = $("#TeamType").val();   //출전선수등록방식
 TeamScoreHalf  =  $("#TeamScoreHalf").val(); //단체전점수분배
 MedalGang  = $("#MedalGang").val();  // 실적적용강수

  MaxPoint = $( "#schMaxPoint" ).val();
  RallyPoint = $( "#schRallyPoint" ).val();
  DeuceYN = $( "#schDeuceYN" ).val();
  MaxPoint_Ama = $( "#schMaxPoint_Ama" ).val();
  RallyPoint_Ama = $( "#schRallyPoint_Ama" ).val();
  DeuceYN_Ama = $( "#schDeuceYN_Ama" ).val();

  MainViewYN = $("#MainViewYN").val();

  schoolCHKYN = $("#schoolCHKYN").val();

  LiveViewYN = $("#selLiveViewYN").val();

  EntryChk_OldYN = $("#EntryChk_OldYN").val();
  EntryChk_RankYN = $("#EntryChk_RankYN").val();
  EntryChk_SameOldRankYN = $("#EntryChk_SameOldRankYN").val();

  WinRule_Person_1 = $("#WinRule_Person_1").val();
  WinRule_Person_2 = $("#WinRule_Person_2").val();
  WinRule_Person_3 = $("#WinRule_Person_3").val();
  WinRule_Person_4 = $("#WinRule_Person_4").val();
  WinRule_Person_5 = $("#WinRule_Person_5").val();
  WinRule_Person_6 = $("#WinRule_Person_6").val();
  WinRule_Person_7 = $("#WinRule_Person_7").val();

  var Rule_PersonCnt = 1;

  for(i=7;i>=1;i--){
    if($("#WinRule_Person_" + i).val() != ""){
      Rule_PersonCnt = i;
      console.log("asd:" + i);
      break;
    }
  }

  for(i=1;i<=Rule_PersonCnt;i++){
    if($("#WinRule_Person_" + i).val() == ""){
      alert("개인전 승패조건 " + i + "번째 조건이 선택되지 않았습니다. 선택해 주시기 바랍니다.");
      return;
    }
  }

  WinRule_Group_1 = $("#WinRule_Group_1").val();
  WinRule_Group_2 = $("#WinRule_Group_2").val();
  WinRule_Group_3 = $("#WinRule_Group_3").val();
  WinRule_Group_4 = $("#WinRule_Group_4").val();
  WinRule_Group_5 = $("#WinRule_Group_5").val();
  WinRule_Group_6 = $("#WinRule_Group_6").val();
  WinRule_Group_7 = $("#WinRule_Group_7").val();

  var Rule_GroupCnt = 1;

  for(i=7;i>=1;i--){
    if($("#WinRule_Group_" + i).val() != ""){
      Rule_GroupCnt = i;
      console.log("fds:" + i);
      break;
    }
  }

  for(i=1;i<=Rule_GroupCnt;i++){
    if($("#WinRule_Group_" + i).val() == ""){
      alert("단체전 승패조건 " + i + "번째 조건이 선택되지 않았습니다. 선택해 주시기 바랍니다.");
      return;
    }
  }

  Url ="/Ajax/GameTitleMenu/updateGameTitle_frm.asp";


  packet.CMD = CMD_UPDATEGAMETITLE;
  packet.tIDX = idx;
  packet.NationType = selNationType;
  packet.GameTitleName = txtGameTitleName;
  packet.GameStartDate = GameS;
  packet.GameEndDate = GameE;
  packet.GameRcvDateS = GameRcvS;
  packet.GameRcvDateE = GameRcvE;
  packet.GameRcvTimeS = GameRcvS_Time;
  packet.GameRcvTimeE = GameRcvE_Time;
  packet.GameOpenS = GameOpenS;
  packet.GameOpenE = GameOpenE;
  packet.GameOpenSTime = GameOpenS_Time;
  packet.GameOpenETime = GameOpenE_Time;
  packet.EntryPersonPay = EntryPersonPay;
  packet.EntryGroupPay = EntryGroupPay;
  packet.GameTitleLocation = SelGameTitleLocation;
  packet.EnterType = selEntertype;
  packet.NationType = selNationType;
  packet.ViewYN = selViewYN;
  packet.MobileViewYN = MobileViewYN;
  packet.MatchesListViewYN = selMatchesListViewYN;
  packet.GameTitleHost = txtGameTitleHost;
  packet.EntryViewYN = selEntryViewYN;
  packet.GamePlace = txtGamePlace;
  packet.GameTitleOldIDX = txtGameTitleOldIDX;
  packet.GameTitleSupervision = GameTitleSupervision; //주관
  packet.GameTitleSponsor = GameTitleSponsor; //후원
  packet.GameGoodsSponsor = GameGoodsSponsor; //용품협찬
  packet.GameTitleETC = GameTitleETC; //기타사항
  packet.CrossTourneyType = CrossTourneyType; //크로스대진방식
  packet.UniformYN =  UniformYN; //유니폼신청
  packet.WinToWinYN  =WinToWinYN ;//승자승사용여부
  packet.TeamType = TeamType; //출전선수등록방식
  packet.TeamScoreHalf  = TeamScoreHalf; //단체전점수분배
  packet.MedalGang  =MedalGang;  // 실적적용강수
  packet.MaxPoint = MaxPoint;
  packet.RallyPoint = RallyPoint;
  packet.DeuceYN = DeuceYN;
  packet.MaxPoint_Ama = MaxPoint_Ama;
  packet.RallyPoint_Ama = RallyPoint_Ama;
  packet.DeuceYN_Ama = DeuceYN_Ama;
  packet.MainViewYN = MainViewYN;
  packet.schoolCHKYN = schoolCHKYN;
  packet.LiveViewYN = LiveViewYN;

  packet.EntryChk_OldYN = EntryChk_OldYN;
  packet.EntryChk_RankYN = EntryChk_RankYN;
  packet.EntryChk_SameOldRankYN = EntryChk_SameOldRankYN;

  packet.WinRule_Person_1 = WinRule_Person_1;
  packet.WinRule_Person_2 = WinRule_Person_2;
  packet.WinRule_Person_3 = WinRule_Person_3;
  packet.WinRule_Person_4 = WinRule_Person_4;
  packet.WinRule_Person_5 = WinRule_Person_5;
  packet.WinRule_Person_6 = WinRule_Person_6;
  packet.WinRule_Person_7 = WinRule_Person_7;

  packet.WinRule_Group_1 = WinRule_Group_1;
  packet.WinRule_Group_2 = WinRule_Group_2;
  packet.WinRule_Group_3 = WinRule_Group_3;
  packet.WinRule_Group_4 = WinRule_Group_4;
  packet.WinRule_Group_5 = WinRule_Group_5;
  packet.WinRule_Group_6 = WinRule_Group_6;
  packet.WinRule_Group_7 = WinRule_Group_7;
  //console.log(packet)
  SendPacket(Url, packet);
  //181121 SSA 크롬 개발자모드에서 CommonAjax data빈값으로 오류경고메시지뜨는부분 때문에 수정
  //location.reload();
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

    $('#GameRcvS_Time').timepicker({
      timeFormat: 'HH:mm',
      interval: 10,
      defaultTime: '00:10',
      startTime: '00:10',
	  minHour : 00,
	  minMinutes: 10,
      dynamic: false,
      dropdown: true,
      scrollbar: true
    });

    $('#GameRcvE_Time').timepicker({
      timeFormat: 'HH:mm',
      interval: 10,
      defaultTime: '00:10',
      startTime: '00:10',
	  minHour : 00,
	  minMinutes: 10,
      dynamic: false,
      dropdown: true,
      scrollbar: true
    });

    $('#GameOpenS_Time').timepicker({
      timeFormat: 'HH:mm',
      interval: 10,
      defaultTime: '00:10',
      startTime: '00:10',
	  minHour : 00,
	  minMinutes: 10,
      dynamic: false,
      dropdown: true,
      scrollbar: true
    });

    $('#GameOpenE_Time').timepicker({
      timeFormat: 'HH:mm',
      interval: 10,
      defaultTime: '00:10',
      startTime: '00:10',
	  minHour : 00,
	  minMinutes: 10,
      dynamic: false,
      dropdown: true,
      scrollbar: true
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

href_addinfo = function(tIdx, NowPage, type){
  if (type == "엘리트") {
    post_to_url('./GameTitleDtl_E_Write.asp', { 'tIDX': tIdx, 'i2': NowPage});
  } else {
  post_to_url('./GameTitleDtl_Write.asp', { 'tIDX': tIdx, 'i2': NowPage});
  }
};

href_refereeinfo = function(tIdx, NowPage, valType){
	if(valType=='MOD') post_to_url('./GameTitle_Referee.asp', { 'tIDX': tIdx, 'i2': NowPage});
	else post_to_url('./GameTitle_Referee_Mod.asp', { 'tIDX': tIdx, 'i2': NowPage});
};

href_admingametitle = function(tIdx, NowPage, valType){
	post_to_url('./AdminGameTitle.asp', { 'tIDX': tIdx, 'i2': NowPage});
};
