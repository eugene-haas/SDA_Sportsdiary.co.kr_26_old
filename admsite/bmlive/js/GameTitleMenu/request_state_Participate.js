

var mx = {};

mx.TabType = "";


////////////명령어////////////
CMD_SEARCHPARTICIPATE = 1;

////////////명령어////////////

////////////Ajax Receive////////////
function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
  switch(CMD) {
    case CMD_SEARCHPARTICIPATE:
    if(dataType == "html") {
      
    }
    break;

    default:
      //$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
  }
};
////////////Ajax Receive////////////

location_request_state_A = function(){
  valUrl = "./request_state_A.asp"
  $('form[name=s_frm]').attr('action', valUrl);
  $('form[name=s_frm]').submit(); 
};
