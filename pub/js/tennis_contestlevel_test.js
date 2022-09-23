var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;

  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
  mx.CMD_GAMEINPUT = 30001;
  mx.CMD_GAMEINPUTEDIT = 30002; //수정
  mx.CMD_GAMEINPUTEDITOK = 30003;
  mx.CMD_GAMEINPUTDEL = 30004;// 삭제

  mx.CMD_FIND1 = 30005;
  mx.CMD_FIND2 = 30006;

  mx.CMD_LEAGUE = 30007; //리그
  mx.CMD_LEAGUEPRE = 31007; //대회준비
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

  mx.CMD_INSERTGROUPGAMEGB = 30022;

  mx.CMD_INSERTLEVELGB = 30023;

  mx.CMD_UPDATEMEMBER = 30024;

  mx.CMD_JOODIVISION = 30025;

  mx.CMD_JOOAREA = 30026;

  mx.CMD_ATTSTATE = 200;

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

  mx.CMD_GAMECANCEL = 50; //승취소

  mx.CMD_INITRULL = 51; //본선룰 다시 적용

  //S : 토너먼트
  mx.CMD_RoundInsert = 30041;//1라운드 부전입력
  mx.CMD_RoundEdit = 30042;//1라운드 대진자 수정


  mx.CMD_RoundJoo = 30044; //라운드 재편성 //완료
  mx.CMD_RoundSetWinner = 30045; //라운드 승자 입력
  mx.CMD_TOURNLASTROUND = 30050; //최종라운드 검사및 생성 화면 뷰
  //E : 토너먼트


  mx.CMD_CHANGEPLAYER = 300; //선수교체 요청
  mx.CMD_SETTEAM = 301; //신규팀등록
  mx.CMD_CHKPLAYER = 302;//중복체크 선수생성
  mx.CMD_SETPLAYER = 303;//선수생성
  mx.CMD_DELTEAM = 304;//팀참여 취소

  mx.CMD_LASTIN = 400;
  mx.CMD_LASTOUT = 401;
  mx.CMD_LASTIN2 = 402;
  mx.CMD_LASTOUT2 = 403;

  mx.CMD_SETLAKET = 820;

  //=======================
  mx.CMD_FINDPLAYER2 = 50000; //지정경로가 다름
  mx.CMD_HTML01 = 80000;
  mx.CMD_HTML01OK = 80001;

  mx.CMD_INITCOURT = 81000; //코트 화면 불러옴
  mx.CMD_INITCOURTMAKE = 81001; //코트 생성
  mx.CMD_INITCOURTEDIT = 81002; //코트 수정
  mx.CMD_INITCOURTDEL = 81003; //코트 삭제

  mx.CMD_INITLAKET = 82001; //라켓정보


  mx.CMD_LEAGUEWIN = 40000; //승처리
  mx.CMD_LEAGUECOURT = 40001; //코트 지정한 후 셀다시 그리기

  mx.CMD_TOURNWAITCOURT = 40002; //본선진행 예정코트 설정
  mx.CMD_TOURNCOURT = 40003; //본선진행 코트 설정
  mx.CMD_TOURNWIN = 40004;//승처리
  mx.CMD_TOURNEND = 40005;//종료

  mx.CMD_UPDATEJOOCNT = 500; //조수 변경

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
mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp";
mx.SendPacket = function( sender, packet){
  var datatype = "mix";
  var timeout = 5000;
  var reqcmd = packet.CMD;
  var reqdone = false;//Closure
  var url = mx.ajaxurl;
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
	case 500: alert('편성인원이 입력된 조수보다 많습니다.'); return;   break;

	case 999: console.log(jsondata.SqlQuery);    break; //메시지 없슴
    case 10: alert('한글영문숫자로만기입해 주십시오.'); return;   break;
	case 4001: alert('리그 1조로 편성되었습니다..'); return;   break;
    case 4002: alert('숫자로만 폰번호를 입력해 주십시오.'); return;   break;
    case 4003: alert('이미 등록된 선수 입니다.'); return;   break;
    case 4004: alert('사용가능한 선수명 + 전화번호 입니다.'); return;   break;
    case 5000: alert('사용중인 코트입니다.');

	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}

	return;   break;
    case 5001: alert('예선에 편성완료된 조가 존재합니다.'); return;   break;
    case 9090: alert('본선시드배정이 생성되지 않았습니다.'); return;   break;
    case 9091: alert('편성된 선수중 존재하지않는 선수가 있습니다.'); return;   break;
    case 9092: alert('현재 자리에 생성정보가 있습니다. 새로고침하십시오.'); return;   break;
    case 9093: alert('이미 변경된 정보가 있습니다. 새로고침 후 이용해주세요.'); return;   break;


    case 1234: alert('입력중인 경기일수 있으니 테블릿에서 확인해주십시오. 결과처리도 테블릿에서 하여 주십시오.');    break; //경기종료 테블릿 입력 값이 존재하는경우

	
    case 100001: alert('1라운드 본선이 편성되지 않았거나. 명수가 틀립니다. 본선 1라운드 재편성 후 실행해 주세요.'); return;  break;	 ///새로불러와도 안바뀌는걸 불러오니...return 필요없음.
    case 100002: alert('랜덤번호를 먼저 설정해 주세요.'); return; break;	 ///새로불러와도 안바뀌는걸 불러오니...return 필요없음. 
    case 100003: alert('본선 추첨룰이 없습니다.'); return; break;	 ///새로불러와도 안바뀌는걸 불러오니...return 필요없음. 
	}
  }

  switch (Number(reqcmd)) {
  case mx.CMD_SETTOURN:
  case mx.CMD_MAKETEMPPLAYER:
  case mx.CMD_SETRANKING:

  case mx.CMD_INPUTREGION:
  case mx.CMD_SETWINNER:
  case mx.CMD_GAMECANCEL = 50:

//  case mx.CMD_GAMEADDITIONFLAG :
  case mx.CMD_CHANGESELECTAREA :
  case mx.CMD_FILLINGEMPTYENTRY:
  case mx.CMD_TOURNCHANGESELECTAREA:
  case mx.CMD_SETTOURNJOO:
  case mx.CMD_SETTOURNWINNER:
  case mx.CMD_JOODIVISION:
  case mx.CMD_JOOAREA:
  case mx.CMD_INITRULL:
  case mx.CMD_SETCOURT:this.OnReLoad( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_GAMEINPUT:  this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );    break;
  case mx.CMD_CONTESTAPPEND:  this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );    break;


  case mx.CMD_RoundJoo:
  case mx.CMD_RoundEdit:
  case mx.CMD_LEAGUEJOO:
  case mx.CMD_FIND1:
  case mx.CMD_FIND2:
  case mx.CMD_GAMEINPUTEDITOK:
  case mx.CMD_INSERTGROUPGAMEGB:
  case mx.CMD_INSERTLEVELGB:

  case mx.CMD_FINDPLAYER2: this.OndrowHTML2( reqcmd, jsondata, htmldata, sender );		break;

  case mx.CMD_GAMEINPUTEDIT:  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_GAMEINPUTDEL: this.OndelHTML( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_LEAGUEPRE:
  case mx.CMD_TOURN:
  case mx.CMD_TOURNEND:
  case mx.CMD_LEAGUE: this.OntableHTML( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_INPUTLEVEL  : this.OnLevelModal( reqcmd, jsondata, htmldata, sender );   break;
  //case mx.CMD_SETLEAGUERANKING: this.delayHTML( reqcmd, jsondata, htmldata, sender );   break;
  //case mx.CMD_SETCOURT_Try: this.delayHTML2( reqcmd, jsondata, htmldata, sender );   break;
  //case mx.CMD_RNDNOEDIT: this.delayHTML2( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_SETCOURT_Try:
  case mx.CMD_SETLEAGUERANKING:
  //case mx.CMD_RNDNOEDIT:  이거 색만 변경하고 새로고치지마
  case mx.CMD_RPOINTEDIT:
  case mx.CMD_SETJOO:

  case mx.CMD_GAMEADDITIONFLAG :  this.OnJooRefresh( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_REFRESHLEAGUEJOO : this.OnDrawingJoo( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_REFRESHGAMECOURT  : this.OnDrawingCourt( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_TOURNLASTROUND  : this.OnlastRDProcess( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_UPDATEMEMBER:this.OnModalUpdateMember( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_ATTSTATE: return; break;
  case mx.CMD_SETTEAM:
  case mx.CMD_DELTEAM:
  case mx.CMD_CHANGEPLAYER:this.OnChangeReload( reqcmd, jsondata, htmldata, sender ); break;


  case mx.CMD_LASTIN2:
  case mx.CMD_LASTOUT2:

  case mx.CMD_LASTIN:
  case mx.CMD_LASTOUT:this.OnLastRoad( reqcmd, jsondata, htmldata, sender ); break;

  case mx.CMD_INITLAKET: this.OndrowHTML3( reqcmd, jsondata, htmldata, sender ); break;
  case mx.CMD_SETLAKET: if ( jsondata.racketName )
						{
						    $("#" + jsondata.playeridx).text(jsondata.racketName);
						}
						break;

  case mx.CMD_INITCOURT :
  case mx.CMD_HTML01:this.OndrowHTML3( reqcmd, jsondata, htmldata, sender ); break;
  case mx.CMD_HTML01OK:alert("저장이 완료되었습니다."); break;
  case mx.CMD_SETPLAYER:alert("선수가 생성되었습니다."); break;

  case mx.CMD_LEAGUEWIN:
  case mx.CMD_LEAGUECOURT:$('#tryouting').click(); break;

  case mx.CMD_TOURNWIN:
  case mx.CMD_TOURNWAITCOURT:$('#tourning').click(); break;
  case mx.CMD_TOURNCOURT:$('#tourning').click(); break;
  }
};

mx.OndrowHTML2 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;

	$("#drowbody").scrollTop(window.oriScroll);
};

mx.OndrowHTML3 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
	if (cmd != mx.CMD_INITLAKET){
		$("#courtarea").scrollTop($("#courtarea")[0].scrollHeight);
	}
};



mx.OnChangeReload =  function(cmd, packet, html, sender){
	$("#reloadbtn").click();
	alert("적용 되었습니다."); //선수 교체 또는 신규팀등록
	$('#Modaltest').modal('hide');
};

mx.OnLastRoad =  function(cmd, packet, html, sender){
	$('#loadmsg').text('&nbsp;새로 고침 중.....');

	if (Number(packet.mclose) == 1){
	  $('#myModal').modal('hide');
	}

	mx.setLastRound(packet.IDX,packet.TeamNM,packet.AreaNM,packet.LevelNo);
};

////////////////////////////////////////////////////////////////
//결승라운드
////////////////////////////////////////////////////////////////
mx.setLastRound = function(idx,teamnm,areanm,levelno,rdtype){
  var obj = {};
  obj.CMD = mx.CMD_TOURNLASTROUND;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;
  if (rdtype == '' || rdtype == undefined) {
	  rdtype = 0;
  }
  obj.rdtype = rdtype;

  mx.SendPacket(null, obj);
  //mx.SendPacket('Modaltest', obj); //작은창
};

mx.OnlastRDProcess =  function(cmd, packet, html, sender){
  mx.players = packet;

  if (Number(packet.rdtype) > 0 ){
	  document.getElementById('myModal').innerHTML = html;
	  $('#myModal').modal('show');
  }
  else{
	  document.getElementById('ModallastRound').innerHTML = html;
	  $('#ModallastRound').modal('show');
  }
};

mx.lastMemberIn = function(idx,teamnm,areanm,levelno,midx){ //최종라운드 관련
  var obj = {};
  obj.CMD = mx.CMD_LASTIN;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;
  obj.midx = midx;
  mx.SendPacket(null, obj);
};

mx.lastMemberOut = function(idx,teamnm,areanm,levelno,midx){
  var obj = {};
  obj.CMD = mx.CMD_LASTOUT;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;
  obj.midx = midx;
  mx.SendPacket(null, obj);
};


mx.lastMemberIn2 = function(idx,teamnm,areanm,levelno,midx){
  var obj = {};
  obj.CMD = mx.CMD_LASTIN2;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;
  obj.midx = midx;
  mx.SendPacket(null, obj);
};

mx.lastMemberOut2 = function(idx,teamnm,areanm,levelno,midx){
  var obj = {};
  obj.CMD = mx.CMD_LASTOUT2;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;
  obj.midx = midx;
  mx.SendPacket(null, obj);
};



////////////////////////////////////////////////////////////////

mx.OnModalUpdateMember =  function(cmd, packet, html, sender){
  window.oriScroll = $("#drowbody").scrollTop();
  document.getElementById(sender).innerHTML = html;
  mx.gameinfo.LEVELNO = packet.S3KEY;
  localStorage.setItem('GAMEINFO', JSON.stringify( mx.gameinfo  ));

  //mx.initPlayer();
  $('#'+sender).modal('show');
};


mx.OnJooRefresh = function(cmd, packet, html, sender) {

  if (packet.ALLDROW == true){
		$('#reloadbtn').click();
		return;
  }




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
1};

mx.OnReLoadLeague = function(cmd, packet, html, sender){
  packet.CMD = mx.CMD_LEAGUE;
  mx.SendPacket('myModal', packet);
};


mx.OnReLoad =  function(cmd, packet, html, sender){
  //패킷 재정이 해서 다시 화면 호출
  var obj = {};

 if(cmd == mx.CMD_GAMEADDITIONFLAG || cmd == mx.CMD_CHANGESELECTAREA|| cmd == mx.CMD_FILLINGEMPTYENTRY || cmd == mx.CMD_RNDNOEDIT || cmd ==mx.CMD_SETLEAGUERANKING
 || cmd ==mx.CMD_SETCOURT_Try || cmd == mx.CMD_INPUTREGION || cmd == mx.CMD_JOODIVISION || cmd ==mx.CMD_JOOAREA)
  {
    obj.CMD = mx.CMD_LEAGUE;
  }
  else if ( (cmd >= mx.CMD_MAKETEMPPLAYER && cmd <= mx.CMD_SETTOURN)  ||  cmd == mx.CMD_TOURNCHANGESELECTAREA || cmd == mx.CMD_SETTOURNJOO || cmd == mx.CMD_SETTOURNWINNER  || cmd == mx.CMD_GAMECANCEL || cmd ==  mx.CMD_INITRULL){
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

if(packet.hasOwnProperty("roundSel")){
	  obj.roundSel = packet.roundSel;
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

//	if ( cmd == mx.CMD_TOURN){
//	  $("#realTimeContents").scrollTop(window.toriScroll);
//	}

	if( cmd == mx.CMD_LEAGUE){
		  document.getElementById(sender).innerHTML = html;
		  $("#drowbody").scrollTop(window.oriScroll);
		  $('#'+sender).modal('show');
	}
	else if (cmd == mx.CMD_LEAGUEPRE){
		  document.getElementById(sender).innerHTML = html;
		  $('#'+sender).modal('show');
		  $('#opencourt').click();
	}
	else{
		  if (packet != null){
			  if (packet.hasOwnProperty('ONEMORE') == true){
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
		  }
		  else{
			  document.getElementById(sender).innerHTML = html;
		  }
		  if( packet == null && cmd == mx.CMD_TOURN){ //본선진행
			  $("#t2_drowbody").scrollTop(window.t2oriScroll);
		  }
		  else{
			  $("#realTimeContents").scrollTop(window.toriScroll);
		  }
	}
};

mx.OnLevelModal =  function(cmd, packet, html, sender){

  document.getElementById(sender).innerHTML = html;

  $('#'+sender).modal('show');
};







mx.SetJoo = function(packet){
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

  mx.SendPacket("myModal", obj);
};

mx.updateMember = function (packet){
  packet.CMD = mx.CMD_UPDATEMEMBER;
  mx.SendPacket("Modaltest", packet);
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

mx.setJooDivision = function(packet) {
  var jooDivisionValue = $("#JooDivision").val();

  if( jooDivisionValue > packet.EndGroup ) {
    alert("현재 그룹개수보다 클 수 없습니다.");
  } else {
    packet.CMD = mx.CMD_JOODIVISION;
    packet.JooDivision = jooDivisionValue;
    mx.SendPacket(null, packet);
  }
};

mx.setJooArea = function(packet) {
  var jooAreaValue = $("#selJooArea").val();
  packet.CMD = mx.CMD_JOOAREA;
  packet.JooAreaValue = jooAreaValue;
  //alert(jooAreaValue);
  //console.log(packet);
  mx.SendPacket(null, packet);
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
    window.toriScroll = $("#realTimeContents").scrollTop();
	console.log(window.toriScroll);
	mx.SendPacket("myModal", packet);
};


//승처리 취소
mx.SetTournGameCanCel = function(packet){
    packet.CMD = mx.CMD_GAMECANCEL;
    packet.GN = 1; //본선
    window.toriScroll = $("#realTimeContents").scrollTop();
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
  packet.CMD = mx.CMD_LEAGUEJOO;
  mx.SendPacket('myModal',packet);
};

mx.league_ing = function(packet){
  mx.ajaxurl = "/pub/ajax/reqTennisLeague_ing.asp";
  packet.CMD = mx.CMD_LEAGUEJOO;
  mx.SendPacket('myModal',packet);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
};

mx.league_court = function(tdid,packet){
  mx.ajaxurl = "/pub/ajax/reqTennisLeague_ing.asp";
  packet.CMD = mx.CMD_LEAGUECOURT;
  packet.COURTNO = $("#gcourt_"+tdid).val();
  window.oriScroll = $("#drowbody").scrollTop();
  mx.SendPacket(tdid,packet);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
};

mx.league_win = function(winidx,packet){
	if (!confirm( "처리 하시겠습니까?")) {
		return;
	}
  mx.ajaxurl = "/pub/ajax/reqTennisLeague_ing.asp";
  packet.CMD = mx.CMD_LEAGUEWIN;
  packet.WINIDX = winidx;
  window.oriScroll = $("#drowbody").scrollTop();
  mx.SendPacket(null,packet);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
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
};

mx.leaguepre = function(idx,teamnm,areanm,stateno){
  var obj = {};
  obj.CMD = mx.CMD_LEAGUEPRE;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.StateNo = stateno;
  mx.SendPacket('myModal', obj);
};


mx.tournament_ing = function(idx,teamnm,areanm,resetflag){
  mx.ajaxurl = "/pub/ajax/reqTennisTourn_ing.asp";
  var obj = {};
  obj.CMD = mx.CMD_TOURN;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.ONEMORE = "notok";

   if (resetflag == "roundsel") {
    obj.roundSel = $("#roundsel").val();
  }else {
     obj.roundSel = "";
 }

  if (resetflag == "reset"){
	obj.RESET = "ok";
  }
  else{
	obj.RESET = "notok";
  }


  if (Number($('#court_areaname option:selected').val()) == 0 || $('#court_areaname option:selected').val() == undefined){ // 전체
	obj.COURTAREA = 0;
  }
  else{
	obj.COURTAREA = $('#court_areaname option:selected').val();
  }

  mx.SendPacket('myModal', obj);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
};

mx.tournament_ing_end = function(idx,teamnm,areanm,resetflag){
  mx.ajaxurl = "/pub/ajax/reqTennisTourn_ing.asp";
  var obj = {};
  obj.CMD = mx.CMD_TOURNEND;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.ONEMORE = "notok";

   if (resetflag == "roundsel") {
    obj.roundSel = $("#roundsel").val();
  }else {
     obj.roundSel = "";
 }

  if (resetflag == "reset"){
	obj.RESET = "ok";
  }
  else{
	obj.RESET = "notok";
  }


  if (Number($('#court_areaname option:selected').val()) == 0 || $('#court_areaname option:selected').val() == undefined){ // 전체
	obj.COURTAREA = 0;
  }
  else{
	obj.COURTAREA = $('#court_areaname option:selected').val();
  }

  mx.SendPacket('myModal', obj);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
};



mx.tourn_waitcourt = function(tdid,packet){
  mx.ajaxurl = "/pub/ajax/reqTennisTourn_ing.asp";
  packet.CMD = mx.CMD_TOURNWAITCOURT;
  packet.COURTNO = $("#waitcourt_"+tdid).val();
  window.t2oriScroll = $("#t2_drowbody").scrollTop();
  mx.SendPacket(tdid,packet);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
};

mx.tourn_court = function(tdid,packet){
  mx.ajaxurl = "/pub/ajax/reqTennisTourn_ing.asp";
  packet.CMD = mx.CMD_TOURNCOURT;
  packet.COURTNO = $("#gcourt_"+tdid).val();
  window.t2oriScroll = $("#t2_drowbody").scrollTop();
  mx.SendPacket(tdid,packet);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
};

mx.tourn_win = function(teamstr,winidx,packet){
	if (!confirm( teamstr + "을 승리로 처리 하시겠습니까?")) {
		return;
	}
  mx.ajaxurl = "/pub/ajax/reqTennisTourn_ing.asp";
  packet.CMD = mx.CMD_TOURNWIN;
  packet.WINIDX = winidx;
  packet.SCOREA = $("#scoreA_"+packet.T_M1IDX).val();
  packet.SCOREB = $("#scoreB_"+packet.T_M2IDX).val();
  window.t2oriScroll = $("#t2_drowbody").scrollTop();
  mx.SendPacket(null,packet);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
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

   if (resetflag == "roundsel") {
    obj.roundSel = $("#roundsel").val();
  }else {
     obj.roundSel = "";
 }

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


  mx.update_seed = function(packet, idx, seed){
  packet.CMD = mx.CMD_SEEDEDIT;
  obj.IDX = idx;
  obj.SEED = seed;
  mx.SendPacket('seedFlag', obj);
  //$('#myModal').modal('show');
};

mx.update_rndno = function(packet, memberidx, str, rndno_obj){

//	var st1 = $('#rankL_'+ packet.JONO + '_1').val();
//	var st2 = $('#rankL_'+ packet.JONO + '_2').val();
//	var st3 = $('#rankL_'+ packet.JONO + '_3').val();

	var eqcnt = 0;
	var eqmsg  = '';
	if(Number(str) == 1){
//		if (st1 == "1" || st2 == "1" || st3 =="1"){}
//		else{
//			alert("1위를 먼저 지정하여 주십시오.");
//			rndno_obj.value=rndno_obj.defaultValue;
//			return;
//		}


		for (var i = 0;i< $('input[name="rndno1[]"]').length;i ++ )	{
			if ( $('input[name="rndno1[]"]')[i].value == rndno_obj.value ){
				eqcnt++;
			}
		}
	}
	if(Number(str) == 2){
//		if (st1 == "2" || st2 == "2" || st3 =="2"){}
//		else{
//			alert("2위를 먼저 지정하여 주십시오.");
//			rndno_obj.value=rndno_obj.defaultValue;
//			return;
//		}

		for (var i = 0;i< $('input[name="rndno2[]"]').length;i ++ )	{
			if ( $('input[name="rndno2[]"]')[i].value == rndno_obj.value ){
				eqcnt++;
			}
		}
	}

	if (eqcnt > 1 ){
		eqmsg = '[동일한 랜덤번호 존재] ';
	}

	if (confirm(eqmsg + packet.JONO+"조 "+str+"위의 추첨번호를 변경 하시겠습니까?"))
	{
	  packet.CMD = mx.CMD_RNDNOEDIT;
	  packet.MEMBERIDX = memberidx;
	  packet.STR = str;
	  packet.RNDNO = rndno_obj.value;
	  mx.SendPacket('rndno', packet);
	}
	else
	{
	  //rndno_obj.value=rndno_obj.defaultValue;
	}
};

mx.OnPopClose= function(cmd, packet, html, sender){
  $(sender).modal('toggle');
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
  document.getElementById(sender).innerHTML = html;
  if( cmd == mx.CMD_GAMEINPUTEDIT){
    mx.init();

//    $("#GroupGameGb").attr("disabled",true);
//    $("#TeamGb").attr("disabled",true);
//    $("#LevelGb").attr("disabled",true);

    $("#btnupdate").show();
    $("#btndel").show();
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

  obj.fee =   $("#fee").val();
  obj.fund =   $("#fund").val();
  obj.LastRchk =   $("#LastRchk").val(); //최종라운드에서 랭킹강수를 구하기 위해 필요한 정보

  obj.VersusGb                    = $("#VersusGb").val();
  obj.GameDate                  = $("#GameDate").val();
  obj.GameTime                = $("#GameTime").val();
  //obj.TitleIDX                  = $("#TitleIDX").val();
  obj.GroupNm = $("#GroupGameGb option:selected").text();
  obj.TeamNm = $("#TeamGb option:selected").text();
  obj.LevelNm = $("#LevelGb option:selected").text();
  obj.EntryCnt          = $("#entrycnt").val();
  obj.COURTCNT = $("#courtcnt").val();
  obj.JOOCNT = $("#joocnt").val();

   if ($("#transsmy").is(":checked") == true) {
	   obj.TRANSSMY = 'Y';
   }
   else{
	   obj.TRANSSMY = 'N';
   }
   if ($("#attwrite").is(":checked") == true) {
	   obj.ATTW = 'Y';
   }
   else{
	   obj.ATTW = 'N';
   }
   if ($("#attedit").is(":checked") == true) {
	   obj.ATTE = 'Y';
   }
   else{
	   obj.ATTE = 'N';
   }
   if ($("#attdel").is(":checked") == true) {
	   obj.ATTD = 'Y';
   }
   else{
	   obj.ATTD = 'N';
   }

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

  obj.fee =   $("#fee").val();
  obj.fund =   $("#fund").val();
  obj.LastRchk =   $("#LastRchk").val(); //최종라운드에서 랭킹강수를 구하기 위해 필요한 정보


  obj.VersusGb            = $("#VersusGb").val();
  obj.GameDate          = $("#GameDate").val();
  obj.GameTime          = $("#GameTime").val();
  obj.GroupNm = $("#GroupGameGb option:selected").text();
  obj.TeamNm = $("#TeamGb option:selected").text();
  obj.LevelNm = $("#LevelGb option:selected").text();
  obj.EntryCnt          = $("#entrycnt").val();
  obj.COURTCNT = $("#courtcnt").val();
  obj.JOOCNT = $("#joocnt").val();

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

   if ($("#transsmy").is(":checked") == true) {
	   obj.TRANSSMY = 'Y';
   }
   else{
	   obj.TRANSSMY = 'N';
   }
   if ($("#attwrite").is(":checked") == true) {
	   obj.ATTW = 'Y';
   }
   else{
	   obj.ATTW = 'N';
   }
   if ($("#attedit").is(":checked") == true) {
	   obj.ATTE = 'Y';
   }
   else{
	   obj.ATTE = 'N';
   }
   if ($("#attdel").is(":checked") == true) {
	   obj.ATTD = 'Y';
   }
   else{
	   obj.ATTD = 'N';
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
		 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'],
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

  $("#btnupdate").hide();

    $("#btndel").hide();
};

mx.find2 = function(){
  var obj = {};
  obj.CMD = mx.CMD_FIND2;
  obj.TitleIDX =mx.gameinfo.IDX;;
  obj.TITLE = mx.gameinfo.TITLE;
  obj.FSTR = $("#GroupGameGb").val();
  var teamGbVal = $("#TeamGb").val();

  if(teamGbVal == "insert" ) {
    var teamGbPrompt = prompt("생성할 부를 입력해주세요");

    if(teamGbPrompt != null && teamGbPrompt != "")  {
      obj.GROUPGAMEGB =teamGbPrompt;
      obj.CMD = mx.CMD_INSERTGROUPGAMEGB;
      mx.SendPacket('level_form', obj);
    }

    $('#TeamGb option')[0].selected = true;
    return;
  }

  obj.FSTR2 = teamGbVal
  obj.COURTCNT = $("#courtcnt").val();
  obj.StartSC =   $("#StartSC").val();
  obj.LastRnd =   $("#LastRnd").val();
  obj.LevelGb           = $("#LevelGb").val();
  obj.VersusGb            = $("#VersusGb").val();
  obj.GameDate          = $("#GameDate").val();
  obj.GameTime          = $("#GameTime").val();
  obj.EntryCnt          = $("#entrycnt").val();
  mx.SendPacket('level_form', obj);


  $("#btnupdate").hide();
    $("#btndel").hide();

};

mx.SelectLevelGb = function() {
  var levelGbVal = $("#LevelGb").val();
  if(levelGbVal == "insert" ) {
    var levelGbPrompt = prompt("생성할 지역을 입력해주세요");
    if(levelGbPrompt != null && levelGbPrompt != "") {
      var obj = {};
      obj.CMD = mx.CMD_INSERTLEVELGB;
      obj.TitleIDX =mx.gameinfo.IDX;;
      obj.TITLE = mx.gameinfo.TITLE;
      obj.FSTR = $("#GroupGameGb").val();
      obj.TEAMGB  = $("#TeamGb").val();
      obj.LEVELGB = levelGbPrompt ;

      console.log(obj);

      mx.SendPacket('level_form', obj);
    }
    $('#LevelGb option')[0].selected = true;



    return;
  }

  $("#btnupdate").hide();
    $("#btndel").hide();

};


mx.goplayer = function(idx,levelno,teamnm,levelnm){
  mx.gameinfo.TEAMIDX = idx;
  mx.gameinfo.LEVELNO = levelno;

  mx.gameinfo.TEAMNM = teamnm;
  mx.gameinfo.LEVELNM = levelnm;

  localStorage.setItem('GAMEINFO', JSON.stringify( mx.gameinfo  ));
  location.href="./contestplayer.asp?idx="+mx.gameinfo.IDX + "&teamidx=" + idx;
};



mx.initLaket = function (packet){ //코트생성 설정 수정등등
  mx.ajaxurl = "/pub/ajax/reqTennisView.asp";
  packet.CMD = mx.CMD_INITLAKET;


	if(packet.hasOwnProperty("CST")){
	  if (packet.CST == "w"){
		  if($("#kcourtname").val() == ""){alert('지역명을 입력해 주십시오.');return;}
		  packet.CTNAME = $("#kcourtname").val();
	  }
	  else if(packet.CST == "e"){
		  if($("#ct_" + packet.CIDX).val() == ""){alert('지역명을 입력해 주십시오.');return;}
		  packet.CTNAME = $("#ct_" + packet.CIDX).val();
	  }
	  else if(packet.CST == "r"){
		  packet.CTNAME = $("#ct_" + packet.CIDX).val();
	  }
	  else{
		  packet.CTNAME = $("#kcourtname").val();
	  }
	}

  mx.SendPacket('LaketModal', packet);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
};

mx.setLaket = function (titleidx, levelno, playeridx, itemIDX) {

	var obj = {};
	obj.CMD = mx.CMD_SETLAKET;
	obj.titleidx = titleidx;
	obj.levelno = levelno;
	obj.playeridx = playeridx;
	obj.itemIDX = itemIDX;
	console.log(obj);
	mx.SendPacket(null, obj);

};
//////////////////////////////////////////////////////////////////////

mx.initCourt = function (packet){ //코트생성 설정 수정등등
  mx.ajaxurl = "/pub/ajax/reqTennisView.asp";
  packet.CMD = mx.CMD_INITCOURT;


	if(packet.hasOwnProperty("CST")){
	  if (packet.CST == "w"){
		  if($("#kcourtname").val() == ""){alert('지역명을 입력해 주십시오.');return;}
		  packet.CTNAME = $("#kcourtname").val();
	  }
	  else if(packet.CST == "e"){
		  if($("#ct_" + packet.CIDX).val() == ""){alert('지역명을 입력해 주십시오.');return;}
		  packet.CTNAME = $("#ct_" + packet.CIDX).val();
	  }
	  else if(packet.CST == "r"){
		  packet.CTNAME = $("#ct_" + packet.CIDX).val();
	  }
	  else{
		  packet.CTNAME = $("#kcourtname").val();
	  }
	}

  mx.SendPacket('Modaltest', packet);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
};

mx.writeNotice = function(idx){
mx.ajaxurl = "/pub/ajax/reqTennisView.asp";
  var obj = {};
  obj.CMD = mx.CMD_HTML01;
  obj.IDX = idx;
  mx.SendPacket('myModal',obj);
  mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
};


mx.writeNoticeOK = function(idx){
	mx.ajaxurl = "/pub/ajax/reqTennisView.asp";
	var obj = {};
	obj.CMD = mx.CMD_HTML01OK;
	obj.IDX = idx;
	var contents = $("#notice").val();
	if (contents == ''){
		return;
	}

	obj.CONTENTS = contents;
	mx.SendPacket('myModal', obj);
	mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
};
//////////////////////////////////////////////////////////////////////



//mx.goProceeding = function(idx,levelno,teamnm,levelnm){
//
//  mx.gameinfo.TEAMIDX = idx;
//  mx.gameinfo.LEVELNO = levelno;
//  mx.gameinfo.TEAMNM = teamnm;
//  mx.gameinfo.LEVELNM = levelnm;
//
//  localStorage.setItem('GAMEINFO', JSON.stringify( mx.gameinfo  ));
//  location.href="./proceeding.asp?idx="+mx.gameinfo.IDX + "&teamidx=" + idx;
//};



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
		window.oriScroll = $("#drowbody").scrollTop();
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


mx.attCheck = function(idx, typeno,cfg){
	var chkobjid;
	var obj ={};
	obj.IDX = idx;
	switch (Number(typeno))
	{
	case 1:
	   chkobjid = "attins" + idx;
	   if ( $("#attins_"+idx).is(":checked") == true ) {
		   obj.CHK = 'Y';
	   }
	   else{
			obj.CHK = 'N';
	   }
		break;
	case 2:
	   chkobjid = "attedit" + idx;
	   if ( $("#attedit_"+idx).is(":checked") == true ) {
		   obj.CHK = 'Y';
	   }
	   else{
			obj.CHK = 'N';
	   }
		break;
	case 3:
	   chkobjid = "attdel" + idx;
	   if ( $("#attdel_"+idx).is(":checked") == true ) {
		   obj.CHK = 'Y';
	   }
	   else{
			obj.CHK = 'N';
	   }
		break;
	}

	obj.CFG = cfg;
	obj.TYPENO = typeno;
	obj.CMD = mx.CMD_ATTSTATE;
	mx.SendPacket(chkobjid, obj);
};

//선수교체 요청
mx.changePlayer = function(){
	var obj = {};
	obj.CMD = mx.CMD_CHANGEPLAYER;
	obj.ridx =  	$("#requestidx").val();
	obj.orgp1idx = 	$("#orgp1idx").val();
	obj.orgp2idx = $("#orgp2idx").val();
	obj.p1idx = $("#p1idx").val();
	obj.p2idx = $("#p2idx").val();

	if( Number(obj.orgp1idx) == Number(obj.p1idx) && Number(obj.orgp2idx) == Number(obj.p2idx) ){
		alert("참가신청자 이거나 변경된 정보가 없습니다.");
		return;
	}

	obj.tidx = mx.gameinfo.IDX;
	obj.levelno = mx.gameinfo.LEVELNO;
	mx.SendPacket('player1', obj);
};

//신규팀등록
mx.setTeam = function(lidx){
	var obj = {};
	obj.CMD = mx.CMD_SETTEAM;
	obj.lidx = lidx;
	obj.p1idx = $("#p1idx").val();
	obj.p2idx = $("#p2idx").val();
	obj.pos = $("#tryout_pos").val();
	if( obj.p1idx == '' || obj.p2idx == '' ){
		alert("등록할 선수를 검색해 주십시오.");
		return;
	}
	obj.tidx = mx.gameinfo.IDX;
	obj.levelno = mx.gameinfo.LEVELNO;
	mx.SendPacket('player1', obj);
};

//중복체크
mx.chkPlayer = function(){
	var obj = {};
	obj.CMD = mx.CMD_CHKPLAYER;
	obj.pname = $("#nname").val();
	obj.phone = $("#nphone").val();

	if( obj.pname == '' || obj.phone == '' ){
		alert("이름과 핸드폰번호를 입력해주세요.");
		return;
	}
	mx.SendPacket('player1', obj);
};

//선수생성
mx.setPlayer = function(){
	var obj = {};
	obj.CMD = mx.CMD_SETPLAYER;
	obj.pname = $("#nname").val();
	obj.pphone = $("#nphone").val();
	obj.pteam1 = $("#nteam1").val();
	obj.pteam2 = $("#nteam2").val();

	if( obj.pname == '' && obj.phone == '' ){
		alert("이름과 핸드폰번호를 입력해주세요.");
		return;
	}
	if( obj.team1 == '' || obj.team2 == '' ){
		alert("1개이상 클럽명을 기입해 주세요.");
		return;
	}

	obj.tidx = mx.gameinfo.IDX;
	obj.levelno = mx.gameinfo.LEVELNO;
	mx.SendPacket('player1', obj);
};



/*선수 정보 자동완성*/
mx.initPlayer = function(reloadchk){

    $( "#p1name" ).autocomplete({

		open: function(){
			setTimeout(function () {
				$('.ui-autocomplete').css('z-index', 1300);
			}, 0);
		},

		source : function( request, response ) {
			$.ajax(
				{
						type: 'post',
						url: "/pub/ajax/reqTennisContestPlayerFind.asp",
						dataType: "json",
						//request.term = $("#autocomplete").val()
						data: { "REQ" : JSON.stringify({"CMD":mx.CMD_AUTOCOMPLETEALL, "SVAL":request.term, "TIDX":mx.gameinfo.IDX,"LIDX":mx.gameinfo.LEVELNO}) },
						success: function(data) {
								//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                                console.log(data);
								response(
										$.map(data, function(item) {
                                        console.log(item);
												return {
														label: item.data + item.teamTitle,
														value: item.data,
														uidx:item.uidx
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
			if( Number(ui.item.uidx) == 0 ){
				return;
			}
			// 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생 파인트 새로고침
			var obj = {};
			obj.CMD = mx.CMD_FINDPLAYER2;
			mx.ajaxurl = "/pub/ajax/reqTennisContestPlayer.asp";
			obj.pidx = ui.item.uidx;
			obj.levelno = mx.gameinfo.LEVELNO;
			obj.playerno = 1;
			obj.tidx = mx.gameinfo.IDX;
			obj.levelnm = mx.gameinfo.LEVELNM;
			mx.SendPacket('player1', obj);
			mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
        }
    });


	$( "#p2name" ).autocomplete({

		open: function(){
			setTimeout(function () {
				$('.ui-autocomplete').css('z-index', 1300);
			}, 0);
		},

		source : function( request, response ) {
             $.ajax({
                    type: 'post',
                    url: "/pub/ajax/reqTennisContestPlayerFind.asp",
                    dataType: "json",
                    //request.term = $("#autocomplete").val()
					data: { "REQ" : JSON.stringify({"CMD":mx.CMD_AUTOCOMPLETEALL, "SVAL":request.term, "TIDX":mx.gameinfo.IDX,"LIDX":mx.gameinfo.LEVELNO}) },
                    success: function(data) {
                        //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                        response(
                            $.map(data, function(item) {
                                return {
                                    label: item.data + item.teamTitle,
                                    value: item.data,
																		uidx:item.uidx,
																		urpoint:item.urpoint,
                                }
                            })
                        );
                    }
               });
            },

		//조회를 위한 최소글자수
        minLength: 1,
        select: function( event, ui ) {
            // 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생 파인트 새로고침
			var obj = {};
			mx.ajaxurl = "/pub/ajax/reqTennisContestPlayer.asp";
			obj.CMD = mx.CMD_FINDPLAYER2;
			obj.pidx = ui.item.uidx;
			obj.levelno = mx.gameinfo.LEVELNO;
			obj.playerno = 2;
			obj.tidx = mx.gameinfo.IDX;
			obj.levelnm = mx.gameinfo.LEVELNM;
			mx.SendPacket('player2', obj);
			mx.ajaxurl = "/pub/ajax/reqTennisContestlevel_test.asp"; //원래대로
        }
    });
};

mx.updateJoocnt = function(obj,levelno){

var packet = {};
packet.CMD = mx.CMD_UPDATEJOOCNT;
packet.ID = obj.id;
packet.VALUE = obj.value;
packet.TIDX = mx.gameinfo.IDX;
packet.LEVELNO = levelno;

  if ( confirm("예선 조수를 변경 하시겠습니까?")  == false ) {
    obj.value = $("#h_" + packet.ID).val();
	return;
  }

	mx.SendPacket(null, packet);
};

mx.delTeam = function(packet){
  if ( confirm("참여팀을 삭제하시겠습니까?")  == false ) {
	return;
  }

  packet.CMD = mx.CMD_DELTEAM;
  mx.SendPacket(null, packet);
};



mx.findno = 0;
/////////////////////////////////////////
mx.searchAndHighlight = function(searchTerm, targetarea, selector ,findtype) {
	if (searchTerm) {
		var selector = selector || "#realTimeContents"; //use body as selector if none provided
		var searchTermRegEx = new RegExp(searchTerm, "ig");
		var matches = $(selector).text().match(searchTermRegEx);
		if (matches != null && matches.length > 0) {
			$('.highlighted').removeClass('highlighted'); //Remove old search highlights

			//Remove the previous matches
			$span = $('#'+targetarea+' span');
			$span.replaceWith($span.html());

			if (searchTerm === "&") {
				searchTerm = "&amp;";
				searchTermRegEx = new RegExp(searchTerm, "ig");
			}
			$(selector).html($(selector).html().replace(searchTermRegEx, "<span class='match'>" + searchTerm + "</span>"));
			$('.match:first').addClass('highlighted');


				if (mx.findno >= $('.match').length) mx.findno = 0;
				$('.match').removeClass('highlighted');
				$('.match').eq(mx.findno).addClass('highlighted');
				$('.ui-mobile-viewport').animate({
					scrollTop: $('.match').eq(mx.findno).offset().top
				}, 300);


			if ($('.highlighted:first').length) { //if match found, scroll to where the first one appears

				//$('#drowbody').scrollTop($('.highlighted:first').position().top); //#drowbody
				switch ( findtype )
				{
				case "table1":
				$('#drowbody').scrollTop($('.highlighted:first').parent().parent().parent().parent().parent().position().top - 90);
				mx.findno= Number(mx.findno) + 1;
				break;
				case "table2":
				$('#drowbody').scrollTop($('.highlighted:first').parent().parent().parent().parent().parent().parent().position().top - 135);
				mx.findno= Number(mx.findno) + 1;
				break;
				case "table3":
				$('#realTimeContents').scrollTop($('.highlighted:first').position().top -180);
				mx.findno= Number(mx.findno) + 1;
				break;
				case "table4":
				$('#t2_drowbody').scrollTop($('.highlighted:first').parent().parent().parent().parent().parent().parent().position().top - 135);
				mx.findno= Number(mx.findno) + 1;
				break;
				}


				//   var column = $('.highlighted:first').parent().parent().parent().parent().prop('cellIndex');
				//   var row = $('.highlighted:first').parent().parent().parent().parent().parent().position().top;//prop('rowIndex').
				//    alert([column, ',', row].join(''));
			}
			return true;
		}
	}
	return false;
};


mx.docfindstr = function(inputclassname, targetarea,selector, findtype){
	$(".highlighted").removeClass("highlighted").removeClass("match");
	if (  !mx.searchAndHighlight( $('.'+inputclassname).val(), targetarea ,selector, findtype)  ) {
	alert("검색한 내용이 존재 하지 않습니다.");
	}
};




mx.OnFocusOut = function(lastTabIndex, tabobj,classname, copvalue)
{
	var copvalue = copvalue || "";

	var currentElement = tabobj;
    var curIndex = currentElement.tabIndex;
    if(curIndex == lastTabIndex) {
        curIndex = 0;
    }
    var tabbables = $('.'+classname);
    for(var i=0; i<tabbables.length; i++) {
        if(tabbables[i].tabIndex == (curIndex+1)) {
            if( classname == 'tabarea' ){ //지역 내용 복사
				tabbables[i].value = copvalue;
			}
			tabbables[i].focus();
            break;
        }
    }
};

//본선대진룰 대진표에 다시반영 (바이자리, 빈자리, 위치제조정, 없는선수 정리 , 중복값 정리)
mx.initResetRull = function(packet){
    packet.CMD = mx.CMD_INITRULL;
	mx.SendPacket("myModal", packet);
};

/////////////////////////////////////////////////////////
