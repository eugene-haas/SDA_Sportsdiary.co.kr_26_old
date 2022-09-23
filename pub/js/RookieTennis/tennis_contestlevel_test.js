var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
  mx.CMD_GAMEINPUT = 30001;
  mx.CMD_GAMEINPUTEDIT = 30002; //수정
  mx.CMD_GAMEINPUTEDITOK = 30003;
  mx.CMD_GAMEINPUTDEL = 30004;// 삭제

  mx.CMD_FIND1 = 30005;
  mx.CMD_FIND2 = 30006;

  mx.CMD_LEAGUE = 30007; //리그
  mx.CMD_TOURN = 30008; //토너먼트

  mx.CMD_LEAGUEJOO = 30009; //리그조 표시

  mx.CMD_RPOINTEDIT = 30011; //리그전 랭킹포인트

  mx.CMD_GAMEADDITIONFLAG = 30012; //  입금, 출석, 사은품

  mx.CMD_CHANGESELECTAREA = 30013;
  
  mx.CMD_FILLINGEMPTYENTRY = 30014;

  mx.CMD_SEEDEDIT = 30015;

  mx.CMD_TOURNCHANGESELECTAREA = 30016; //토너먼트 소팅 변경

  mx.CMD_RNDNOEDIT = 30017;

  mx.CMD_REFRESHLEAGUEJOO = 30019; 

  mx.CMD_REFRESHGAMECOURT = 30020;

  mx.CMD_INPUTLEVEL = 30021;

  mx.CMD_SETWINNER = 10; //승자결정
  mx.CMD_SETCOURT = 11;//코트결정
  mx.CMD_SETRANKING = 12;//순위 결정
  mx.CMD_SETJOO = 13; //조 설정 완료
  mx.CMD_MAKETEMPPLAYER = 14; //부전승만들기
  mx.CMD_SETTOURN  = 15; //토너먼트 편성완료 1라운드
  mx.CMD_SETTOURNJOO = 16; //토너먼트 조 편성
  mx.CMD_SETLEAGUERANKING = 18;
  mx.CMD_SETCOURT_Try = 17;//예선 조 코트 배정
  mx.CMD_INPUTREGION = 19;
  mx.CMD_SETTOURNWINNER = 20; //본선 승자결정
  mx.CMD_SETJOORULE = 21;
  mx.CMD_BOOJUNLOAD = 30; //재호출(부전자 로드)
  

  //S : 토너먼트 
  mx.CMD_RoundInsert = 30041;//1라운드 부전입력
  mx.CMD_RoundEdit = 30042;//1라운드 대진자 수정
  

  mx.CMD_RoundJoo = 30044; //라운드 재편성 //완료
  mx.CMD_RoundSetWinner = 30045; //라운드 승자 입력
  mx.CMD_TOURNLASTROUND = 30050; //최종라운드 검사및 생성 화면 뷰
  //E : 토너먼트

////////////////////////////////////////

mx.IsHttpSuccess = function( r ){
  try{
    return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
  }
  catch(e){}
  return false;
};

mx.HttpData = function( r, type ){
  var ct = r.getResponseHeader( "Content-Type" );
  var data = !type && ct && ct.indexOf( "xml" ) >=0;
  data = type == "xml" || data ? r.responseXML : r.responseText;
  if( type == "script" ){
    eval.call( "window", data );
  }
  else if( type == "mix" ){
    if ( data.indexOf("$$$$") !== -1 ){
      var mixdata = data.split( "$$$$" );
      ( function () { eval.call("window", mixdata[0]); } () );
      data = mixdata[1];
    }
  }
  return data;
};

//innerHTML 로딩 시점을 알기위해 추가
mx.waitUntil = function (fn, condition, interval) {
    interval = interval || 100;

    var shell = function () {
            var timer = setInterval(
                function () {
                    var check;

                    try { check = !!(condition()); } catch (e) { check = false; }

                    if (check) {
                        clearInterval(timer);
                        delete timer;
                        fn();
                    }
                },
                interval
            );
        };

    return shell;
};

//동일한 패킷이 오는경우 (막음 처리해야겠지)
mx.SendPacket = function( sender, packet){
  var datatype = "mix";
  var timeout = 5000;
  var reqcmd = packet.CMD;
  var reqdone = false;//Closure
  var url = "/pub/ajax/reqTennisContestlevel_test.asp";
  var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
  var xhr = new XMLHttpRequest();
  xhr.open( "POST", url );
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  //setTimeout( function(){ reqdone = true; }, timeout );

    //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
  //  apploading("AppBody", "로딩 중 입니다.");
  //}

  xhr.onreadystatechange = function(){
    if( xhr.readyState == 4 && !reqdone ){
      if( mx.IsHttpSuccess( xhr ) ){
      
        //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){       
        //  $('#AppBody').oLoader('hide');
        //}

        mx.ReceivePacket( reqcmd, mx.HttpData( xhr, datatype ), sender );
        return true;
      }
      xhr = null;
    }
  };
  console.log(JSON.stringify( packet  ) );
  xhr.send( strdata );
 
};

mx.ReceivePacket = function( reqcmd, data, sender ){// data는 response string

  var rsp = null;
  var callback = null;
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  
  if ( Number(reqcmd) > mx.CMD_DATAGUBUN  ){
    if ( data.indexOf("`##`") !== -1 ){
      resdata = data.split( "`##`" );
      jsondata =  resdata[0];
      if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
        htmldata = resdata[1];

    }   
    else{

      htmldata = data;   
      try{
        jsondata = JSON.parse(data); 
      }
      catch(ex)
      {
        
      }
    }
  }
  else{
   
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( jsondata !='' && jsondata != null){
    switch (Number(jsondata.result))  {
    case 0: break;
    case 1: alert('데이터가 존재하지 않습니다.');return;  break;
    case 2: alert('편성조건에 만족하지 않습니다.');return;  break;
    case 3: alert('본선이 대진표가 완료된 경우 순위 변동을 할 수 없습니다..');return;  break;
    case 4: alert('본선이 대진표가 완료된 경우 추첨번호를 변경 할 수 없습니다.');return;    break; //메시지 없슴
    case 100: return;   break; //메시지 없슴
    case 101: mx.ChkIngGame(jsondata);   break; //메시지 없슴
    case 5: alert('본선이 대진표가 완료된 경우 추첨번호를 변경 할 수 없습니다.');    break; 
    case 999: console.log(jsondata.SqlQuery);    break; //메시지 없슴
    case 1234: alert('입력중인 경기일수 있으니 테블릿에서 확인해주십시오. 결과처리도 테블릿에서 하여 주십시오.');    break; //경기종료 테블릿 입력 값이 존재하는경우 
    }
  }
  
  switch (Number(reqcmd)) {
  case mx.CMD_SETTOURN:
  case mx.CMD_MAKETEMPPLAYER:
  case mx.CMD_SETRANKING:

  case mx.CMD_INPUTREGION:
  case mx.CMD_SETWINNER:
//  case mx.CMD_GAMEADDITIONFLAG : 
  case mx.CMD_CHANGESELECTAREA :
  case mx.CMD_FILLINGEMPTYENTRY:
  case mx.CMD_TOURNCHANGESELECTAREA:
  case mx.CMD_SETTOURNJOO:
  case mx.CMD_SETTOURNWINNER:
  case mx.CMD_SETCOURT:this.OnReLoad( reqcmd, jsondata, htmldata, sender );   break;

 // case mx.CMD_SETJOO:this.OnReLoadLeague( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_GAMEINPUT:  this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );    break;
  case mx.CMD_CONTESTAPPEND:  this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );    break;

  
  case mx.CMD_RoundJoo:
  case mx.CMD_RoundEdit:
  case mx.CMD_LEAGUEJOO:
  case mx.CMD_FIND1:
  case mx.CMD_FIND2:
  case mx.CMD_GAMEINPUTEDITOK:
  case mx.CMD_GAMEINPUTEDIT:  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_GAMEINPUTDEL: this.OndelHTML( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_TOURN:
  case mx.CMD_LEAGUE: this.OntableHTML( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_INPUTLEVEL  : this.OnLevelModal( reqcmd, jsondata, htmldata, sender );   break; 
  //case mx.CMD_SETLEAGUERANKING: this.delayHTML( reqcmd, jsondata, htmldata, sender );   break;
  //case mx.CMD_SETCOURT_Try: this.delayHTML2( reqcmd, jsondata, htmldata, sender );   break;
  //case mx.CMD_RNDNOEDIT: this.delayHTML2( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_SETCOURT_Try:
  case mx.CMD_SETLEAGUERANKING: 
  case mx.CMD_RNDNOEDIT: 
  case mx.CMD_RPOINTEDIT:
  case mx.CMD_SETJOO:
  case mx.CMD_GAMEADDITIONFLAG :  this.OnJooRefresh( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_REFRESHLEAGUEJOO : this.OnDrawingJoo( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_REFRESHGAMECOURT  : this.OnDrawingCourt( reqcmd, jsondata, htmldata, sender );   break; 

  case mx.CMD_TOURNLASTROUND  : this.OnlastRDProcess( reqcmd, jsondata, htmldata, sender );   break; 

  }
};

////////////////////////////////////////////////////////////////
//결승라운드 
////////////////////////////////////////////////////////////////
mx.setLastRound = function(idx,teamnm,areanm,levelno){
  var obj = {};
  obj.CMD = mx.CMD_TOURNLASTROUND;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;

  mx.SendPacket('myModal', obj);
  //mx.SendPacket('Modaltest', obj); //작은창
};

mx.OnlastRDProcess =  function(cmd, packet, html, sender){
  mx.players = packet;
  document.getElementById(sender).innerHTML = html;

  $('#'+sender).modal('show');
};
////////////////////////////////////////////////////////////////




mx.OnJooRefresh = function(cmd, packet, html, sender) {

  packet.ORIGINCMD = cmd;
  packet.CMD = mx.CMD_REFRESHLEAGUEJOO;
  mx.SendPacket(null, packet);
};

mx.OnDrawingJoo = function(cmd, packet, htmldata, sender) {
  $("#JoonoBox_" + packet.JONO).html(htmldata);
  if(packet.ORIGINCMD == mx.CMD_SETCOURT_Try)
  {
    packet.CMD = mx.CMD_REFRESHGAMECOURT;
    
    mx.SendPacket(null, packet);
  }
};

mx.OnDrawingCourt=  function(cmd, packet, htmldata, sender) {

  $("#divGameCourt").html(htmldata);

};


mx.delayHTML = function(packet){
	alert("천천히");
}

mx.delayHTML2 = function(packet){
	//alert("점유하고 있는 번호인지 확인해주세요");
}

mx.setTourn  = function(packet){
  packet.CMD = mx.CMD_SETTOURN;
  mx.SendPacket(null, packet);
};

mx.makeBujun = function(packet){
  packet.CMD = mx.CMD_MAKETEMPPLAYER;
  mx.SendPacket('myModal', packet);
};


mx.ChkIngGame = function(packet){
  if (confirm("생성된 게임이 존재합니다. 삭제 후 다시 편성하시겠습니까?")) {
    mx.SendPacket("myModal", packet);
  } else {
    return;
  } 	
};

mx.OnReLoadLeague = function(cmd, packet, html, sender){
  packet.CMD = mx.CMD_LEAGUE;
  mx.SendPacket('myModal', packet);
};


mx.OnReLoad =  function(cmd, packet, html, sender){
  //패킷 재정이 해서 다시 화면 호출
  var obj = {};
  
  //console.log("cmd:" + cmd);
  //console.log("packet:" + packet);
  //console.log("html:" + html);
  //console.log("sender:" + sender);

 if(cmd == mx.CMD_GAMEADDITIONFLAG || cmd == mx.CMD_CHANGESELECTAREA|| cmd == mx.CMD_FILLINGEMPTYENTRY || cmd == mx.CMD_RNDNOEDIT || cmd ==mx.CMD_SETLEAGUERANKING 
 || cmd ==mx.CMD_SETCOURT_Try || cmd == mx.CMD_INPUTREGION)
  {
    obj.CMD = mx.CMD_LEAGUE;
  }
  else if (cmd >= mx.CMD_SETWINNER && cmd <= mx.CMD_SETJOO   ) {
    obj.CMD = mx.CMD_LEAGUEJOO;
  }
  else if ( (cmd >= mx.CMD_MAKETEMPPLAYER && cmd <= mx.CMD_SETTOURN)  ||  cmd == mx.CMD_TOURNCHANGESELECTAREA || cmd == mx.CMD_SETTOURNJOO || cmd == mx.CMD_SETTOURNWINNER){
    obj.CMD = mx.CMD_TOURN;
	if (cmd == mx.CMD_SETTOURNJOO){
		obj.ONEMORE = packet.ONEMORE;
	}
	else{
		obj.ONEMORE = "notok";
	}


  }
  else{
    obj.CMD = cmd;
  }

if(packet.hasOwnProperty("IDX")){
	  obj.IDX = packet.IDX;
}

//if(packet.hasOwnProperty("RESET")){
	  obj.RESET = "notok";
//}

  obj.TitleIDX = packet.TitleIDX;
  obj.Title = packet.Title;
  obj.TeamNM = packet.TeamNM;
  obj.AreaNM = packet.AreaNM;
  obj.JONO = packet.JONO;
  obj.StateNo = packet.StateNo;
  mx.SendPacket('myModal',obj);
};




mx.OntableHTML =  function(cmd, packet, html, sender){
  mx.players = packet;

	if( cmd == mx.CMD_LEAGUE){
		  document.getElementById(sender).innerHTML = html;
		  $('#'+sender).modal('show');
	}
	else{
		if (packet.ONEMORE =="ok"){
		  document.getElementById(sender).innerHTML = html;
		  $('#'+sender).modal('show');
		  packet.ONEMORE = "notok";
		  setTimeout(mx.SendPacket('myModal',packet), 3000);
		}else{
		  document.getElementById(sender).innerHTML = html;
		  $('#'+sender).modal('show');
		}
	}
};

mx.OnLevelModal =  function(cmd, packet, html, sender){

  document.getElementById(sender).innerHTML = html;
  
  $('#'+sender).modal('show');
};







mx.SetJoo = function(packet){
/*
  if(packet.ExitYN1 == "N")
  {
    alert("1팀 채워주세요")
    return;
  }

  if(packet.ExitYN2 =="N")
  {
    alert("2팀 채워주세요")
    return;
  }
  */

  packet.CMD = mx.CMD_SETJOO;
	packet.DELOK = 0;
  mx.SendPacket("myModal", packet);
};


mx.SetCourt_try = function(packet, COURTID){
    if ($("#court_"+COURTID).val()=="999") {
        alert("해당 코트는 사용 중입니다.");
    } 
    packet.CMD = mx.CMD_SETCOURT_Try;
    packet.GN = 0; //예선
    packet.tryoutgroupno = COURTID; //예선 조
    packet.setCourtNo = $("#court_"+ COURTID).val(); //코트 번호
    mx.SendPacket("myModal", packet);
 };

mx.SetJooRule = function(idx,titleIdx,chkControl)
{
  var obj = {};

  obj.CMD = mx.CMD_SETJOORULE;
  obj.IDX = idx;
  obj.GAMETITLEIDX = titleIdx;
  
  if ( chkControl.checked == true ) {
    obj.CHKRULL = 1
  }
  else {
    obj.CHKRULL = 0
  }
  //console.log(obj)
  mx.SendPacket(null, obj);
};

mx.input_levelModal = function(IDX) {
  var obj = {};
  obj.CMD = mx.CMD_INPUTLEVEL;
  obj.IDX = IDX;

  mx.SendPacket("myLevelModel", obj);
};

mx.ReloadLevel = function(cmd, packet, html, sender){
  //var obj = {};
	//obj.IDX = packet.GAMETITLEIDX;
	//obj.GAMETITLEIDX = packet.gametitle;
	//localStorage.setItem('GAMEINFO', JSON.stringify( obj  ));
	location.href="./contestlevel.asp?idx="+packet.GAMETITLEIDX ;
};

mx.inputRegion = function(packet){

  var joRegion = "";

  for (var i = 1; i <= packet.EndGroup ;i++)
  {
    var placeText = $('#place_'+i).val();
    
    

    if(i == packet.EndGroup)    
      joRegion  = joRegion + i +"^"+ placeText;
    else
      joRegion  = joRegion + i +"^"+ placeText + "%";
  }

  if(joRegion.length > 0)
  {
    packet.CMD = mx.CMD_INPUTREGION;
    packet.JOREGION = joRegion
    
    mx.SendPacket(null, packet);
  }
};

mx.SetCourt = function(packet){
  var courtno = $('#'+packet.POS).val();
  if (confirm(courtno + "로 코트를 지정하시겠습니까?")) {
    packet.CMD = mx.CMD_SETCOURT;
    packet.GN = 0; //예선
    packet.COURTNO = courtno;
    mx.SendPacket("myModal", packet);
  } else {
    return;
  } 
};

mx.SetGameRanking = function(packet){
  
  var rankno = $('#'+packet.POS).val();
  //if (confirm(rankno + "로 순위를 지정하시겠습니까?")) {
  packet.CMD = mx.CMD_SETRANKING;
  packet.GN = 0; //예선
  packet.RANKNO = rankno;
  //console.log(packet)
  mx.SendPacket("myModal", packet);
  /*
    } else {
    return;
  } 
  */
};


mx.SetGameLeagueRanking = function(packet){
  
  var rankno = $('#'+packet.POS).val();
  //if (confirm(rankno + "로 순위를 지정하시겠습니까?")) {
  packet.CMD = mx.CMD_SETLEAGUERANKING;
  packet.GN = 0; //예선
  packet.RANKNO = rankno;
  
  mx.SendPacket("myModal", packet);
  /*
    } else {
    return;
  } 
  */
};

mx.SetTournGameResult = function(packet){
    packet.CMD = mx.CMD_SETTOURNWINNER;
    packet.GN = 1; //본선
    mx.SendPacket("myModal", packet);
};


mx.SetGameResult = function(packet){
  var msg = null;
  var resultno = $('#'+packet.POS).val();

  if(resultno == 0)
    return ;
  /*
  switch (Number(resultno)) {
    case 0:  alert('경기 결과를 선택해 주세요.'); return;  break; //판정결과 대기
    case 100: msg = "팀을 승자로 결정하시겠습니까?";   break; //승리
    case 1: msg = "팀을 부전승으로  결정하시겠습니까?";    break; //부전승
    case 2: msg = "팀을 기권승으로 결정하시겠습니까?";   break; //기권승
    case 3: msg = "팀을 실격승으로 결정하시겠습니까?";   break; //실격승
    case 4: msg = "팀 과 상대팀을 불참 처리 하시겠습니까?";   break; //양선수 불참
    case 5: msg = "팀 과 상대팀을 기권패 처리 하시겠습니까?";    break; //양선수 기권패
    case 6: msg = "팀 과 상대팀을 실격패 처리 하시겠습니까?";    break; //양선수 실격패
    case 1000: alert("1라운드만 편성이 가능합니다."); return;   break; 
    case 1001: alert("변경 중 중복 번호가 발생하여 초기화 되었습니다."); return;   break; 
    case 1002: alert("상위라운드 진출자가 있어 재편성 할 수 없습니다."); return;   break; 
  }
  
  
  if (packet.WINIDX == packet.P1){
    msg = packet.P1NM + msg;
  }
  else{
    msg = packet.P2NM + msg;
  }
  */
  /*
  if (confirm(msg)) {
    */
    packet.CMD = mx.CMD_SETWINNER;
    packet.GN = 0; //예선
    packet.RTNO = resultno; //결과 번호
    mx.SendPacket("myModal", packet);
  /*
  } else {
    return;
  } 
  */
};

mx.leagueJoo = function(packet){
  mx.SendPacket('myModal',packet);
};


///////////////////////////////////////////////////
mx.league = function(idx,teamnm,areanm,stateno){
  var obj = {};
  obj.CMD = mx.CMD_LEAGUE;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.StateNo = stateno;
  mx.SendPacket('myModal', obj);
  //$('#myModal').modal('show');
};

mx.tournament = function(idx,teamnm,areanm,resetflag){
  var obj = {};
  obj.CMD = mx.CMD_TOURN;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.ONEMORE = "notok";

  if (resetflag == "reset"){
	obj.RESET = "ok";
  }
  else{
	obj.RESET = "notok";
  }

  mx.SendPacket('myModal', obj);
  //$('#myModal').modal('show');
};

mx.update_rpoint = function(packet,memberIdx,rpoint){
  
    packet.CMD = mx.CMD_RPOINTEDIT;
    packet.GAMEMEMBERIDX = memberIdx;
    packet.RPOINT = rpoint;
    mx.SendPacket(null, packet);
    //$('#myModal').modal('show');
  };
  

mx.update_seed = function(idx, seed){

  var obj = {};
  obj.CMD = mx.CMD_SEEDEDIT;
  obj.IDX = idx;
  obj.SEED = seed;
  mx.SendPacket('seedFlag', obj);
  //$('#myModal').modal('show');
};

mx.update_rndno = function(packet, memberidx, str, rndno_obj){
  packet.CMD = mx.CMD_RNDNOEDIT;
  packet.MEMBERIDX = memberidx;
  packet.STR = str;
  packet.RNDNO = rndno_obj.value;
  mx.SendPacket('rndno', packet);
};

mx.OnPopClose= function(cmd, packet, html, sender){
  $(sender).modal('toggle');
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
  document.getElementById(sender).innerHTML = html;
  if( cmd == mx.CMD_GAMEINPUTEDIT){
    mx.init();
  }
};

mx.OndelHTML =  function(cmd, packet, html, sender){
  $("#"+sender).remove();
  if( cmd == mx.CMD_GAMEINPUTDEL){
    document.getElementById('gameinput_area').innerHTML = html; 
    mx.init();
  }
};

mx.OnAppendHTML =  function(cmd, packet, html, sender){
  if ( packet.lastchk == "_end" ){return;}
  packet.NKEY = Number(packet.NKEY) + 1;
  localStorage.setItem('MOREINFO', JSON.stringify( packet  ));
  $('#'+sender).append(html);
  $("body").scrollTop($("body")[0].scrollHeight);
};


mx.OnBeforeHTML =  function(cmd, packet, html, sender){
  if(html == '' ){
  alert("중복된 소속이 있습니다.");
  return;
  }
  $('.gametitle').first().before(html);
};

mx.contestMore = function(idx){

  var moreinfo = localStorage.getItem('MOREINFO'); //다음

  if (moreinfo == null) {
    var nextkey = 2;
  }
  else{
    moreinfo = JSON.parse(moreinfo);  
    var nextkey = moreinfo.NKEY;
  }
  var parmobj = {'CMD':mx.CMD_CONTESTAPPEND,'NKEY':nextkey,"IDX":idx };
  mx.SendPacket('contest', parmobj);
};


mx.input_frm = function(){
  var obj = {};
  obj.CMD = mx.CMD_GAMEINPUT;

  obj.StartSC =   $("#StartSC").val();
  obj.LastRnd =   $("#LastRnd").val();


  obj.GroupGameGb           = $("#GroupGameGb").val();
  obj.TeamGb            = $("#TeamGb").val();
  if ($("#LevelGb").val() == undefined){
    obj.LevelGb = '';
  }
  else{
  obj.LevelGb           = $("#LevelGb").val();  
  }
  obj.VersusGb                    = $("#VersusGb").val();
  obj.GameDate                  = $("#GameDate").val();
  obj.GameTime                = $("#GameTime").val();
  //obj.TitleIDX                  = $("#TitleIDX").val();
  obj.GroupNm = $("#GroupGameGb option:selected").text();
  obj.TeamNm = $("#TeamGb option:selected").text();
  obj.LevelNm = $("#LevelGb option:selected").text();
  obj.EntryCnt          = $("#entrycnt").val();
  obj.COURTCNT = $("#courtcnt").val();

  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  
  obj.bigo =$("#bigo").val();

  if (obj.GroupGameGb == ""){
    alert("구분을 선택해 주세요.");
    return;
  }
  if (obj.TeamGb == ""){
    alert("소속을 선택해 주세요.");
    return;
  }
  if(obj.LevelNm == '==선택=='){
    alert("지역을 선택해 주세요.");
    return;
  }
  
  mx.SendPacket(null, obj);
};

mx.flagChange = function(packet, type, sender)
{

  packet.CMD = mx.CMD_GAMEADDITIONFLAG;
  packet.TYPE = type;

  if(sender.checked){
    packet.FLAGCHECK = "Y";
  }
  else{
    packet.FLAGCHECK = "N";
  }

  event.stopPropagation();

  mx.SendPacket(null, packet);
   //상위로 이벤트가 전파되지 않도록 중단한다.
};

mx.tornGameIn = function(packet){

  packet.CMD = mx.CMD_SETTOURNJOO;

  //alert("T_ATTCNT : " + packet.T_ATTCNT)
  //alert("T_NOWRD : " + packet.T_NOWRD)
  //alert("T_RDID : " + packet.T_RDID)
  //alert("CMD : " + packet.CMD)


  mx.SendPacket("myModal", packet);

};

mx.FillingEmptyEntry = function(packet) {
  packet.CMD = mx.CMD_FILLINGEMPTYENTRY;

  var gubunField = document.getElementById("diffGubun").value;

  if(gubunField == "Y"){
    if (!confirm("랭킹 순서대로 정렬되면 편성완료가 초기화됩니다. 하시겠습니까?")) {
        return;
    }
  }
  else
  {
    if (!confirm("랭킹 순서대로 정렬됩니다. 하시겠습니까?")) {
      return;
    }
  }
  
  mx.SendPacket(null, packet);
};

mx.update_frm = function(){
  var obj = {};
  obj.CMD = mx.CMD_GAMEINPUTEDITOK;
  if (mx.gameinfo.hasOwnProperty('TEAMIDX') == false){
    alert("대상을 선택해 주세요.");
    return;
  }
  obj.IDX   = mx.gameinfo.TEAMIDX;
  obj.StartSC =   $("#StartSC").val();
  obj.LastRnd =   $("#LastRnd").val();
  obj.GroupGameGb   = $("#GroupGameGb").val();
  obj.TeamGb      = $("#TeamGb").val();
  if ($("#LevelGb").val() == undefined){
    obj.LevelGb = '';
  }
  else{
  obj.LevelGb           = $("#LevelGb").val();  
  }
  obj.VersusGb            = $("#VersusGb").val();
  obj.GameDate          = $("#GameDate").val();
  obj.GameTime          = $("#GameTime").val();
  obj.GroupNm = $("#GroupGameGb option:selected").text();
  obj.TeamNm = $("#TeamGb option:selected").text();
  obj.LevelNm = $("#LevelGb option:selected").text();
  obj.EntryCnt          = $("#entrycnt").val();
  obj.COURTCNT = $("#courtcnt").val();

  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  
  obj.bigo =$("#bigo").val();

  if (obj.GroupGameGb == ""){
    alert("구분을 선택해 주세요.");
    return;
  }
  if (obj.TeamGb == ""){
    alert("소속을 선택해 주세요.");
    return;
  }
  if(obj.LevelNm == '==선택=='){
    alert("지역을 선택해 주세요.");
    return;
  }
  
  mx.SendPacket('titlelist_'+obj.IDX, obj);
};


mx.del_frm = function(){
  var obj = {};
  obj.CMD = mx.CMD_GAMEINPUTDEL;
  if (mx.gameinfo.hasOwnProperty('TEAMIDX') == false){
    alert("대상을 선택해 주세요.");
    return;
  }
  obj.IDX = mx.gameinfo.TEAMIDX;
  mx.SendPacket('titlelist_'+obj.IDX, obj);
};

mx.input_edit = function(idx){
  var obj = {};
  obj.CMD = mx.CMD_GAMEINPUTEDIT;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.IDX = idx;

  mx.gameinfo.TEAMIDX = idx;
  localStorage.setItem('GAMEINFO', JSON.stringify( mx.gameinfo  ));
  mx.SendPacket('gameinput_area', obj);
};

mx.gameinfo;
$(document).ready(function(){
    localStorage.removeItem('MOREINFO');
    var gameinfo = localStorage.getItem('GAMEINFO');
	if (gameinfo == '' || gameinfo == null){
		location.href = 'contest.asp';
	}
    mx.gameinfo = JSON.parse(gameinfo);
    mx.init();


}); 

mx.init = function(){

  $(function() {
    $( "#GameDate" ).datepicker({ 
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


    $( "#GameTime" ).timepicker({ 
    showPeriodLabels: false,
    });
  });

};

mx.find1 = function(){
  var obj = {};
  obj.CMD = mx.CMD_FIND1;
  obj.TitleIDX =mx.gameinfo.IDX;
  obj.TITLE = mx.gameinfo.TITLE;
  obj.FSTR = $("#GroupGameGb").val();
  obj.COURTCNT = $("#courtcnt").val();

  obj.StartSC =   $("#StartSC").val();
  obj.LastRnd =   $("#LastRnd").val();
  obj.VersusGb            = $("#VersusGb").val();
  obj.GameDate          = $("#GameDate").val();
  obj.GameTime          = $("#GameTime").val();
  obj.EntryCnt          = $("#entrycnt").val();
  
  mx.SendPacket('level_form', obj);

};
mx.find2 = function(){
  var obj = {};
  obj.CMD = mx.CMD_FIND2;
  obj.TitleIDX =mx.gameinfo.IDX;;
  obj.TITLE = mx.gameinfo.TITLE;

  obj.FSTR = $("#GroupGameGb").val();
  obj.FSTR2 = $("#TeamGb").val();
  obj.COURTCNT = $("#courtcnt").val();

  obj.StartSC =   $("#StartSC").val();
  obj.LastRnd =   $("#LastRnd").val();
  obj.LevelGb           = $("#LevelGb").val();
  obj.VersusGb            = $("#VersusGb").val();
  obj.GameDate          = $("#GameDate").val();
  obj.GameTime          = $("#GameTime").val();
  obj.EntryCnt          = $("#entrycnt").val(); 

  mx.SendPacket('level_form', obj);
};

mx.goplayer = function(idx,levelno,teamnm,levelnm){
  mx.gameinfo.TEAMIDX = idx;
  mx.gameinfo.LEVELNO = levelno;

  mx.gameinfo.TEAMNM = teamnm;
  mx.gameinfo.LEVELNM = levelnm;

  localStorage.setItem('GAMEINFO', JSON.stringify( mx.gameinfo  ));
  location.href="./contestplayer.asp?idx="+mx.gameinfo.IDX + "&teamidx=" + idx;
};

mx.SelectDivObject = null;
mx.SeelctDivObjectBackground = null;
mx.ChangeDivObject = null;
mx.SelectObject = {};
mx.ChangeObject = {};

mx.changeSelectArea = function(IDX, control, groupNo, sortNo, packet)
{ 
  packet.CMD = mx.CMD_CHANGESELECTAREA;  


  if(event.target.tagName != "DIV")
    return;
  
  //첫 객체 선택
  if(mx.SelectDivObject == null )
  {
	mx.SelectDivObject = control;
	mx.SelectObject.IDX = IDX;
	mx.SelectObject.GROUPNO = groupNo;
	mx.SelectObject.SORTNO = sortNo;
	mx.SeelctDivObjectBackground = control.style.backgroundColor;
	control.style.backgroundColor ='#c7ecff'

  }
  else
  {

	  
    // 같은 객체 선택
    if(mx.SelectDivObject == control)
    {
      mx.SelectDivObject = null;
      mx.SelectObject = null;
      mx.SelectObject = {};
      control.style.backgroundColor = mx.SeelctDivObjectBackground
    }
    else
    {
      //첫 객체와 다른 객체 선택 시 교환 작업
      mx.ChangeDivObject = control;
      mx.ChangeObject.IDX = IDX;
      mx.ChangeObject.GROUPNO = groupNo;
      mx.ChangeObject.SORTNO = sortNo;

      var title = mx.SelectObject.GROUPNO + "조" + " " + mx.SelectObject.SORTNO + "번에서 "
      title = title + mx.ChangeObject.GROUPNO + "조" + " " + mx.ChangeObject.SORTNO + "번으로 "
      title = title + " 바꾸시겠습니까? ";

      //교환 
      if (confirm(title) == true){    //확인
        mx.SelectDivObject.style.backgroundColor =''
        mx.ChangeDivObject.style.backgroundColor =''
        packet.SELECTOBJECT = mx.SelectObject;  
        packet.CHANGEOBJECT = mx.ChangeObject;  
        mx.SelectObject = {};
        mx.ChangeObject = {};
        mx.SelectDivObject = null;
        mx.ChangeDivObject = null;
        //packet.SELECTOBJECTID = mx.SelectObject.IDX;  
        //packet.CHANGEOBJECTID = mx.ChangeObject.IDX;  
        //packet.SELECTOBJECTGROUPNO = mx.SelectObject.GROUPNO;  
        //packet.CHANGEOBJECTGROUPNO = mx.ChangeObject.GROUPNO;  
        //packet.SELECTOBJECTSORTNO = mx.SelectObject.SORTNO;  
        //packet.CHANGEOBJECTSORTNO = mx.ChangeObject.SORTNO;  
        //alert(obj.SELECTOBJECTID)
        //alert(obj.CHANGEOBJECTID)
        //alert(obj.SELECTOBJECTGROUPNO)
        //alert(obj.CHANGEOBJECTGROUPNO)
        //alert(obj.SELECTOBJECTSORTNO)
        //alert(obj.CHANGEOBJECTSORTNO)
        mx.SendPacket(null, packet);

      }else{   //취소
        mx.SelectDivObject.style.backgroundColor =''
        mx.ChangeDivObject.style.backgroundColor =''
        mx.SelectObject = {};
        mx.ChangeObject = {};
        mx.SelectDivObject = null;
        mx.ChangeDivObject = null;
        return;
      }
      
    }
  }
};



mx.tournChangeSelectArea = function(packet)
{ 
  packet.CMD = mx.CMD_TOURNCHANGESELECTAREA;  
	//T_MIDX = 123 , T_SORTNO =  1 , T_DIVID  = cell_1_1

  //if(event.target.tagName != "DIV")
  //  return;
  
	var control = document.getElementById(packet.T_DIVID);

  //첫 객체 선택
  if(mx.SelectDivObject == null )
  {
	mx.SelectDivObject = control;
	mx.SelectObject.IDX = packet.T_MIDX;
	mx.SelectObject.SORTNO = packet.T_SORTNO;
	mx.SeelctDivObjectBackground = control.style.backgroundColor;
	control.style.backgroundColor ='#c7ecff'
  }
  else
  {
    // 같은 객체 선택
    if(mx.SelectDivObject == control)
    {
      mx.SelectDivObject = null;
      mx.SelectObject = null;
      mx.SelectObject = {};
      control.style.backgroundColor = mx.SeelctDivObjectBackground
    }
    else
    {
      //첫 객체와 다른 객체 선택 시 교환 작업
      mx.ChangeDivObject = control;
      mx.ChangeObject.IDX = packet.T_MIDX;
      mx.ChangeObject.SORTNO = packet.T_SORTNO;

      var title = mx.SelectObject.SORTNO + "번에서 "
      title = title + mx.ChangeObject.SORTNO + "번으로 "
      title = title + " 바꾸시겠습니까? ";

      //교환 
      if (confirm(title) == true){    //확인
        mx.SelectDivObject.style.backgroundColor =''
        mx.ChangeDivObject.style.backgroundColor =''
        packet.SELECTOBJECT = mx.SelectObject;  
        packet.CHANGEOBJECT = mx.ChangeObject;  
        mx.SelectObject = {};
        mx.ChangeObject = {};
        mx.SelectDivObject = null;
        mx.ChangeDivObject = null;
        mx.SendPacket(null, packet);

      }else{   //취소
		mx.SelectDivObject.style.backgroundColor =''
        mx.ChangeDivObject.style.backgroundColor =''
        mx.SelectObject = {};
        mx.ChangeObject = {};
        mx.SelectDivObject = null;
        mx.ChangeDivObject = null;
        return;
      }
      
    }
  }
};



////////////////////////////////////////////////////////////////////////////////
    mx.players = null;
    mx.initial = null;
    mx.dragSrcEl_ = null;

    //수정 모드
    mx.mod= function(e) {
       
    };
    //완료 모드
    mx.comp= function(e) {
       
    };
    //예선 선택 
    mx.trySel= function(e,idxno,levelno,gameMemberIDX,checkId) {
        var targetobj = document.getElementById("drag_"+checkId);
          
          if ( targetobj.style.color =="red") {
                targetobj.style.color= 'black';
            }else {
                targetobj.style.color= 'red';
            }
          
           
        //체크 
        var obj = {};
          obj.CMD = mx.CMD_TOURN;
          obj.IDX = idxno;
          obj.TitleIDX = mx.gameinfo.IDX;
          obj.level = levelno;
          obj.gameMemberIDX = gameMemberIDX;
          obj.checkId = checkId;

          console.log(obj);
    };
    //본선 선택 
    mx.tornSel=function(e,idxno,levelno,gameMemberIDX,checkId) {
        var targetobj = document.getElementById(checkId);
           
          if ( targetobj.style.color =="red") {
                targetobj.style.color= 'black';
            }else {
                targetobj.style.color= 'red';
            }
          
           
        //체크 
        var obj = {};
          obj.CMD = mx.CMD_TOURN;
          obj.IDX = idxno;
          obj.TitleIDX = mx.gameinfo.IDX;
          obj.level = levelno;
          obj.gameMemberIDX = gameMemberIDX;
          obj.checkId = checkId;

          console.log(obj);
    };




    mx.allowDrop= function(e) {
      if (e.preventDefault) {
        e.preventDefault(); // Allows us to drop.
      }
      e.dataTransfer.dropEffect = 'move';
      return;
    };

    mx.drag = function(e) {
      var targetobj = document.getElementById(e.target.id);
      e.dataTransfer.effectAllowed = 'move';
      e.dataTransfer.setData('text', targetobj.innerHTML);
      mx.dragSrcEl_ = document.getElementById(e.target.id);
      targetobj.style.color = 'red';
    };

    mx.drop = function(e) {
      var targetobj = document.getElementById(e.target.id);
      if (e.stopPropagation) {
        e.stopPropagation(); 
      }

      if (mx.dragSrcEl_ != targetobj) {
        var dragobjrow = mx.dragSrcEl_.id.split('_')[1];  //행1
        var dropobjrow = targetobj.id.split('_')[1];       //행2
        var dragobjcol = mx.dragSrcEl_.id.split('_')[2];   //열1
        var dropbjcol = targetobj.id.split('_')[2];        //열2
        var gamestart = false;

        //1단계 위아래
//        if ( Number(dragobjrow) == 0 || Number(dragobjrow) == Number(mx.players[0].MAXRO) - 1 ) { //첫행과 마지막행
//          if(Number(dropobjrow) == 0 || Number(dropobjrow) == Number(mx.players[0].MAXRO) - 1){ //첫행과 마지막행
            
//            for (var i = 0;i<mx.players.length ;i++ ){
//              if( mx.players[i].RO > 1 ){ //경기가 발생했다면 변경금지(RO 행 1라운드보다 크다면 변경금지)
//                gamestart = true;
//              }
//            }

            if ( gamestart == false){ // //보이는 화면 변경 , 소팅번호변경 
              mx.dragSrcEl_.innerHTML = targetobj.innerHTML;
              targetobj.innerHTML = e.dataTransfer.getData('text').trim();

              var dragcolno = mx.players[mx.dragSrcEl_.id.split('_')[2]].CO;
              var targetcolno = mx.players[targetobj.id.split('_')[2]].CO;

              var changedata1 = mx.players[mx.dragSrcEl_.id.split('_')[2]];
              var changedata2 = mx.players[targetobj.id.split('_')[2]];

              changedata1.CO = targetcolno;
              changedata2.CO = dragcolno;

              mx.players[mx.dragSrcEl_.id.split('_')[2]] = changedata2;
              mx.players[targetobj.id.split('_')[2]] = changedata1;
            }
//          }
//        }
      }
      return false;   
    };


    mx.dragEnd = function(e) {
      var targetobj = document.getElementById(e.target.id);
      if (e.stopPropagation) {
        e.stopPropagation(); 
      }

      if (mx.dragSrcEl_ != targetobj) {
        var dragobjrow = mx.dragSrcEl_.id.split('_')[1];  //행1
        var dropobjrow = targetobj.id.split('_')[1];       //행2
        var dragobjcol = mx.dragSrcEl_.id.split('_')[2];   //열1
        var dropbjcol = targetobj.id.split('_')[2];        //열2
        var gamestart = false;

        //1단계 위아래
//        if (Number(dragobjrow) == Number(dropobjrow)) { //같은행이라면
//          if(Number(dragobjrow) == 0 || Number(dragobjrow) == Number(mx.players[0].MAXRO) - 1){ //첫번째 또는 마지막행

//            for (var i = 0;i<mx.players.length ;i++ ){
//              if( mx.players[i].RO > 1 ){ //경기가 발생했다면 변경금지(RO 행 1라운드보다 크다면 변경금지)
//                gamestart = true;
//              }
//            }

            if ( gamestart == false){ // //보이는 화면 변경 , 소팅번호변경 
              mx.dragSrcEl_.innerHTML = targetobj.innerHTML;
              targetobj.innerHTML = e.dataTransfer.getData('text').trim();

              var dragcolno = mx.players[mx.dragSrcEl_.id.split('_')[2]].CO;
              var targetcolno = mx.players[targetobj.id.split('_')[2]].CO;

              var changedata1 = mx.players[mx.dragSrcEl_.id.split('_')[2]];
              var changedata2 = mx.players[targetobj.id.split('_')[2]];

              changedata1.CO = targetcolno;
              changedata2.CO = dragcolno;

              mx.players[mx.dragSrcEl_.id.split('_')[2]] = changedata2;
              mx.players[targetobj.id.split('_')[2]] = changedata1;
            }
//          }
//        }

      }
      return false;   
    };

/**
 * 가로 아코디언
 * mx.Accordian
 * el = '.tourney_admin'
 */
mx.Accordian = function (el) {
  this._$tourneyAdm = null; /* el 담을 프로퍼티 */
  this._$toggleBtn = null; /* 이벤트를 발생시킬 버튼들 thead > .btn */
  this._$tourneyAdmTd = null; /* table의 td들 */

  this._actIdx = -1; /* 버튼 클릭시 해당 버튼의 index 값 */
  this._$column = null; /* 클릭한 버튼의 인덱스와 일치하는 td */
  this._$collapseTg = null; /* 줄어든 td 모음 */
  this._btnData = -1; /* 버튼의 data 담을 프로퍼티 */

  this._init(el);
  this._evt();
};

mx.Accordian.prototype._init = function(el){
  this._$tourneyAdm = $(el);
  this._$toggleBtn = $('thead .btn', this._$tourneyAdm);
  this._$tourneyAdmTd = $('td', this._$tourneyAdm);
}

mx.Accordian.prototype._evt = function() {
  var that = this;
  this._$toggleBtn.on('click', function(){
    that._actIdx = that._$toggleBtn.index(this); /* 클릭한 버튼의 인덱스 */
    this._btnData = $(this).data('collap'); // data-collap 속성 값
    that._execToggle(this._btnData); // collapse 기능 호출
  });
};

mx.Accordian.prototype._execToggle = function(btnData) {
  if (this._$collapseTg) { // 이전에 지정된 형태의 collapse가 있으면
    this._$collapseTg.removeClass('increase'); // 원상복구
  }

  this._$collapseTg = this._$tourneyAdmTd.filter('[rowspan='+btnData+']'); // collapse 새로 지정
  if (btnData == 1) {
    this._$collapseTg = this._$tourneyAdm.find('tr td:first-child');
    console.log(this._$collapseTg);
  }

  this._$collapseTg.addClass('increase') // 선택된 td들 늘리기
};


/**
 * on/off 버튼 구현
 */
mx.OnOffSwitch = function (el) {
  this._$tg = null; /* chk_btn */
  this._$swBtn = null; /* 스위치 할 버튼 */

  this._init(el);
  this._evt();

  $('.winnercell').parents('div').filter('div[id*="cell_"]').addClass('redy');
};

mx.OnOffSwitch.prototype._init = function(el) {
  this._$tg = $(el);
  this._$swBtn = $('.btn', this._$tg);
}

mx.OnOffSwitch.prototype._evt = function() {
  var that = this;
  this._$swBtn.on('click', function(){
    that._toggleBtn($(this))
  })
};

/**
 * _toggleBtn 버튼 구현
 * $this 는 클릭한 버튼
 */
mx.OnOffSwitch.prototype._toggleBtn = function($this) {
  if ($this.hasClass('on')) {
    $this.removeClass('on');
  } else {
    $this.addClass('on');
  }
};

mx.ChangeText = function(htmlobj, str) {
  
	if (htmlobj.value == "0")
	{
		htmlobj.value = "";
	}
};


/*
$(document).ready(function () {
    window.onpopstate = function (event) {
            $(".close").click();
            console.log("window.onpopstate myModal");
            if (history.state == null) {

            } else {
                history.back();
            }
        };

        $('#myModal').on('shown.bs.modal', function (e) {
            console.log("shown.bs.modal myModal");
            history.pushState({ page: 1, name: '팝업' }, '', '?popup');
        });

        $('#myModal').on('hidden.bs.modal', function (e) {
            console.log(" hidden.bs.modal myModal");
            if (history.state == null) {

            } else {
                history.back();
            }
        });
       
});
*/