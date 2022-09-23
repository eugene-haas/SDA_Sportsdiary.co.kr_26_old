
////////////명령어////////////
CMD_SEARCHLEVELMEMBER = 1;
CMD_SELLEVELDTLMEMBER = 2;
CMD_DELLEVELDTLMEMBER = 3;
CMD_DELLEVELDTLAllMEMBER = 6;
CMD_INSERTLEVELDTLMEMBER = 4;
CMD_SEARCHGAMELEVELENTRY= 5;
CMD_INSERTLEVELDTLMEMBERCHECKED = 6;


////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  switch(CMD) {
    case CMD_SELLEVELDTLMEMBER:
    {
      if(dataType == "html")
      {
          $('#divGameLevelDtlList').html(htmldata); 
      }
    } break;

    case  CMD_SEARCHLEVELMEMBER :
    {
      if(dataType == "html")
      {
        $('#divLevelDtlMember').html(htmldata); 
      }
      
    }break;
    
    case CMD_INSERTLEVELDTLMEMBER:
    {
      selLevelDtlChanged();
      GameLevelEntry();
    }break;

    case CMD_INSERTLEVELDTLMEMBERCHECKED:
    {
      selLevelDtlChanged();
      GameLevelEntry();
    }break;
    

    
    case CMD_DELLEVELDTLMEMBER:
    {
      selLevelDtlChanged();
      GameLevelEntry();
    }break;
    case CMD_DELLEVELDTLAllMEMBER:
    {
      selLevelDtlChanged();
      GameLevelEntry();
    }break;


    case CMD_SEARCHGAMELEVELENTRY :
    {
      if(dataType == "html")
      {
        $('#divLevelDtlMember').html(htmldata); 
      }
    }break;

    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

////////////Custom Function////////////
function searchLevelMember(NowPage = 1) {
  Url = "/Ajax/GameTitleMenu/selGamLevelEntry.asp"
  var tGameLevelDtlIDX = $( "#selGameLevelDtlIdx" ).val(); 
  var tGameIdx = $( "#selGameIdx" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
  var txtMember =  $("#strMember").val();
  var chkAllMember = $('input:checkbox[id="chkAllMember"]').is(":checked") 

  var packet = {};
  packet.CMD = CMD_SEARCHLEVELMEMBER;
  packet.tIdx = tGameIdx;
  packet.tGameLevelDtlIDX = tGameLevelDtlIDX;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.IsAllMember = chkAllMember;
  packet.tSearchName = txtMember;
  packet.NowPage = NowPage;
  
  SendPacket(Url, packet);
};

/*selLevelDtlChanged이 바뀌면 loadLevelDtlChanged 함수도 같이 바꿔야합니다.*/
function selLevelDtlChanged(){
  Url = "/Ajax/GameTitleMenu/selGamLevelTouneyEntry.asp"
  var tGameIdx = $( "#selGameIdx" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
  var tGameLevelDtlIdx = $( "#selGameLevelDtl" ).val(); 
  var tGroupGameGb = $( "#selGroupGameGb" ).val(); 
  var tSearchText = $( "#strTouneryEntryMember" ).val(); 
  var chkAllMember = $('input:checkbox[id="chkAllTouneryEntryMember"]').is(":checked") 
  
  if (typeof tSearchText  == "undefined" || tSearchText.Length == 0) {
    tSearchText = ""
  } 

  if (typeof tGameLevelDtlIdx  == "undefined" || tGameLevelDtlIdx.Length == 0) {
    tGameLevelDtlIdx = ""
  } 

  if (typeof chkAllMember  == "undefined" || chkAllMember.Length == 0) {
    tChkAllMember  = "A"
  }
  else{
    if(chkAllMember == true) {
      tChkAllMember  = "A"
    }
    else {
      tChkAllMember  = "S" 
    }
  }

  var packet = {};
  packet.CMD = CMD_SELLEVELDTLMEMBER;
  packet.tIdx = tGameIdx;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tGameLevelDtlIdx = tGameLevelDtlIdx;
  packet.tChkAllMember = tChkAllMember;
  packet.tSearchText = tSearchText;
  packet.NowPage = 1;
  //alert(packet.NowPage)
  SendPacket(Url, packet);
};


function loadLevelDtlChanged(gameLevelDtlIdx){
  Url = "/Ajax/GameTitleMenu/selGamLevelTouneyEntry.asp"
  var tGameIdx = $( "#selGameIdx" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
  var tGameLevelDtlIdx = gameLevelDtlIdx;
  var tGroupGameGb = $( "#selGroupGameGb" ).val(); 
  var tSearchText = $( "#strTouneryEntryMember" ).val(); 
  var chkAllMember = $('input:checkbox[id="chkAllTouneryEntryMember"]').is(":checked") 
  
  if (typeof tSearchText  == "undefined" || tSearchText.Length == 0) {
    tSearchText = ""
  } 


  if (typeof chkAllMember  == "undefined" || chkAllMember.Length == 0) {
    tChkAllMember  = "A"
  }
  else{
    if(chkAllMember == true) {
      tChkAllMember  = "A"
    }
    else {
      tChkAllMember  = "S" 
    }
  }

  var packet = {};
  packet.CMD = CMD_SELLEVELDTLMEMBER;
  packet.tIdx = tGameIdx;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tGameLevelDtlIdx = tGameLevelDtlIdx;
  packet.tChkAllMember = tChkAllMember;
  packet.tSearchText = tSearchText;
  packet.NowPage = 1;
  SendPacket(Url, packet);
};



function findChkAllMember(){
  var value = chkAllMember = $('input:checkbox[id="chkAllMember"]').is(":checked") 
  if(value == true)
    document.getElementById("strMember").disabled = true;
  else
    document.getElementById("strMember").disabled = false;
};

function findChkAllMemberTouneyEntry(){
  var value = chkAllMember = $('input:checkbox[id="chkAllTouneryEntryMember"]').is(":checked") 
  if(value == true)
    document.getElementById("strTouneryEntryMember").disabled = true;
  else
    document.getElementById("strTouneryEntryMember").disabled = false;
};



function insert_RequestLevelDtl(value){
  var data = confirm("출전 신청합니까?")
  if (data == true) {
    Url = "/Ajax/GameTitleMenu/inputLevelDtlMember_frm.asp"
    var tGameIdx = $( "#selGameIdx" ).val(); 
    var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
    var tGameLevelDtlIdx = $( "#selGameLevelDtl" ).val(); 
    var tGroupGameGb = $( "#selGroupGameGb" ).val(); 
    var packet = {};
    packet.CMD = CMD_INSERTLEVELDTLMEMBER;
    packet.tIdx = tGameIdx;
    packet.tGameLevelIdx = tGameLevelIdx;
    packet.tGameLevelDtlIdx = tGameLevelDtlIdx;
    packet.tGroupGameGb = tGroupGameGb;
    packet.tTeamIdx = value;
    SendPacket(Url, packet);
  }
};

function insert_RequestLevelDtl_check(){

  var data = confirm("선택된 팀을 출전 신청합니까?");

  var str_reqidx = "";
  var loopNum = 0;

  $("input[name=reqidx]:checked").each(function() {
    if(loopNum == 0){
      str_reqidx += $(this).val(); 
    }
    else{
      str_reqidx += "," + $(this).val(); 
    }

    loopNum += 1;
  });
  

  console.log("asd:"+str_reqidx);
  
  if (data == true) {
    Url = "/Ajax/GameTitleMenu/inputLevelDtlMember_all_frm.asp"
    var tGameIdx = $( "#selGameIdx" ).val(); 
    var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
    var tGameLevelDtlIdx = $( "#selGameLevelDtl" ).val(); 
    var tGroupGameGb = $( "#selGroupGameGb" ).val(); 
    var packet = {};
    packet.CMD = CMD_INSERTLEVELDTLMEMBERCHECKED;
    packet.tIdx = tGameIdx;
    packet.tGameLevelIdx = tGameLevelIdx;
    packet.tGameLevelDtlIdx = tGameLevelDtlIdx;
    packet.tGroupGameGb = tGroupGameGb;
    packet.tTeamIdx_checked = str_reqidx;
    SendPacket(Url, packet);
  }
 
};



function GameLevelEntry(NowPage = 1){
  Url = "/Ajax/GameTitleMenu/selGamLevelEntry.asp"
  var tGameIdx = $( "#selGameIdx" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
  var tGameLevelDtlIdx = $( "#selGameLevelDtlIdx" ).val(); 
  var tGroupGameGb = $( "#selGroupGameGb" ).val(); 
  var tSearchText = $( "#strMember" ).val(); 
  var chkAllMember = $('input:checkbox[id="chkAllMember"]').is(":checked") 
  var tParticipateEntryType = $( "#selParticipateEntryType" ).val(); 
  
  if (typeof tSearchText  == "undefined" || tSearchText.Length == 0) {
    tSearchText = ""
  } 

  if (typeof tGameLevelDtlIdx  == "undefined" || tGameLevelDtlIdx.Length == 0) {
    tGameLevelDtlIdx = ""
  } 

  if (typeof chkAllMember  == "undefined" || chkAllMember.Length == 0) {
    tChkAllMember  = "A"
  }
  else{
    if(chkAllMember == true) {
      tChkAllMember  = "A"
    }
    else {
      tChkAllMember  = "S" 
    }
  }
 
  if (typeof tParticipateEntryType  == "undefined" || tParticipateEntryType.Length == 0) {
    tParticipateEntryType = "A"
  } 
  
  var packet = {};
  packet.CMD = CMD_SEARCHGAMELEVELENTRY;
  packet.tIdx = tGameIdx;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tGameLevelDtlIdx = tGameLevelDtlIdx;
  packet.tGroupGameGb = tGroupGameGb;
  packet.tSearchText = tSearchText ;
  packet.tChkAllMember = tChkAllMember ;
  packet.tParticipateEntryType = tParticipateEntryType ;
  packet.NowPage = NowPage;
  SendPacket(Url, packet);

}

function cancel_RequestLevelDtl(value){
  var data = confirm("출전 취소하시겠습니까?")
  
  if (data == true) {
  Url = "/Ajax/GameTitleMenu/delLevelDtlMember_frm.asp"
  var tGameIdx = $( "#selGameIdx" ).val(); 
  var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
  var tGameLevelDtlIdx = $( "#selGameLevelDtl" ).val(); 
  var tGroupGameGb = $( "#selGroupGameGb" ).val(); 
  
  var packet = {};
  packet.CMD = CMD_DELLEVELDTLMEMBER;
  packet.tIdx = tGameIdx;
  packet.tGameLevelIdx = tGameLevelIdx;
  packet.tGameLevelDtlIdx = tGameLevelDtlIdx;
  packet.tGroupGameGb = tGroupGameGb;
  packet.tGameRequestTouneyIdx = value;
  SendPacket(Url, packet);
  }
};

function allCancel_RequestLevelDtl(value,levelDtlName)
{

  var data = confirm("["+levelDtlName +"]"+ "조 모든 선수 출전을 취소하시겠습니까?")
  
  if (data == true) {
    Url = "/Ajax/GameTitleMenu/delLevelDtlAllMember_frm.asp"
    var tGameIdx = $( "#selGameIdx" ).val(); 
    var tGameLevelIdx = $( "#selGameLevelIdx" ).val(); 
    var tGameLevelDtlIdx = $( "#selGameLevelDtl" ).val(); 
    var tGroupGameGb = $( "#selGroupGameGb" ).val(); 
    
    var packet = {};
    packet.CMD = CMD_DELLEVELDTLAllMEMBER;
    packet.tIdx = tGameIdx;
    packet.tGameLevelIdx = tGameLevelIdx;
    packet.tGameLevelDtlIdx = tGameLevelDtlIdx;
    packet.tGroupGameGb = tGroupGameGb;
    //console.log(packet)
    SendPacket(Url, packet);
  }

}


function checkall_list(){
//만약 전체 선택 체크박스가 체크된상태일경우 
console.log($("#all_reqidx").prop("checked"));
  if($("#all_reqidx").prop("checked")) 
  { 
      $("input[name=reqidx]").prop("checked",true); 
  }
  else { 
      $("input[name=reqidx]").prop("checked",false); 
  }

}



////////////Custom Function////////////
/*
$(document).ready(function(){
  init();
}); 

init = function(){

  //왼쪽 영역 불러오기
  GameLevelEntry();
  //오른쪽 영역 불러오기
  selLevelDtlChanged();
};
*/

function initSearchControl()
{
  $( "#strMember" ).autocomplete({
		source : function( request, response ) {
			$.ajax(
				{
						type: 'post',
						url: "../../Ajax/GameTitleMenu/searchLevelMember.asp",
						dataType: "json",
						data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHLEVELMEMBER, "SVAL":request.term}) },
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


}

href_back = function(tIdx, tGameLevelIdx,NowPage){
  post_to_url('./levelDtl.asp', { 'tIdx': tIdx,'tGameLevelIdx': tGameLevelIdx,'pType': 'level', 'i2': NowPage});
};

href_back2 = function(tIdx,tPGameLevelIdx, tGameLevelIdx, NowPage){
  post_to_url('./levelDtl.asp', { 'tIdx': tIdx,'tPGameLevelIdx':tPGameLevelIdx,'tGameLevelIdx': tGameLevelIdx,'pType': 'plevel' ,'i2': NowPage});
};

