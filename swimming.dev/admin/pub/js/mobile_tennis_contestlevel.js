var mx =  mx || {};
////////////////////////////////////////
mx.CMD_SETTOURNJOO = 16; //토너먼트 조 편성
mx.CMD_SETLEAGUERANKING = 18;
mx.CMD_INPUTREGION = 19; // 지역저장
mx.CMD_SETTOURNWINNER = 20; //본선 승자결정
mx.CMD_GAMECANCEL = 50; //승취소

mx.CMD_DATAGUBUN = 10000;
mx.CMD_TOURN = 30008; //본선 경기진행
mx.CMD_LEAGUEJOO = 30009; // 예선경기진행
mx.CMD_TOURNTABLE = 30010; //본선 대진표
mx.CMD_LEAGUEPRE = 31007; //출전신고 예선 대진표 (대회준비)
mx.CMD_RNDNOEDIT = 30017; // 랜덤번호 업데이트
mx.CMD_GAMEADDITIONFLAG = 30012; //  입금, 출석, 사은품
mx.CMD_LEAGUEWIN = 40000; //승처리
mx.CMD_LEAGUECOURT = 40001;
mx.CMD_TOURNCOURT = 40003; //본선진행 코트 설정
mx.CMD_TOURNWIN = 40004; //승처리
mx.CMD_TOURNEND = 40005; //종료
mx.CMD_LEAGUEDRAW = 41000; //추첨
mx.CMD_INITCOURT = 81000; //코트 화면 불러옴





mx.CMD_UPDATEMEMBER = 30024;
mx.CMD_AUTOCOMPLETE = 100;
mx.CMD_AUTOCOMPLETEALL = 110;
mx.CMD_FINDPLAYER2 = 50000; //지정경로가 다름

mx.CMD_CHANGEPLAYER = 300; //선수교체 요청
mx.CMD_SETTEAM = 301; //신규팀등록
mx.CMD_CHKPLAYER = 302;//중복체크 선수생성
mx.CMD_SETPLAYER = 303;//선수생성
mx.CMD_DELTEAM = 304;//팀참여 취소


mx.CMD_BYEWIN = 99; //순위결정후 본선대진표 호출
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
mx.ajaxurl = "/pub/ajax/reqMobileTennisContestlevel.asp";
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



  xhr.onreadystatechange = function(){
    if( xhr.readyState == 4 && !reqdone ){
      if( mx.IsHttpSuccess( xhr ) ){

        mx.ReceivePacket( reqcmd, mx.HttpData( xhr, datatype ), sender );
        return true;
      }
      xhr = null;
    }
  };
  console.log(JSON.stringify( packet  ) );
  xhr.send( strdata );

};


mx.IsJsonString = function(str) {
	try {
		var json = JSON.parse(str);
	return (typeof json === 'object');
	} catch (e) {
		return false;
	}
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
      if (mx.IsJsonString(data)){
			jsondata = JSON.parse(data);
      }
	  else{
	      htmldata = data;
	  }
    }
  }
  else{
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( mx.IsJsonString(data) ){
    switch (Number(jsondata.result))  {
    case 0: break;
    case 1: alert('데이터가 존재하지 않습니다.');return;  break;
    case 2: alert('편성조건에 만족하지 않습니다.');return;  break;
    case 3: alert('본선이 대진표가 완료된 경우 순위 변동을 할 수 없습니다..');return;  break;
    case 4: alert('본선이 대진표가 완료된 경우 추첨번호를 변경 할 수 없습니다.');return;    break; //메시지 없슴
    case 100: return;   break; //메시지 없슴
    case 101: mx.ChkIngGame(jsondata);   break; //메시지 없슴

    case 102: alert("동일 순위가 있어 자동으로 순위를 알 수 없습니다."); $('#reloadbtn').click(); return;   break; //메시지 없슴


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
  	if ( $("#reloadbtn").length > 0 ) { $('#reloadbtn').click();}

  	return;   break;

    case 5001: alert('예선에 편성완료된 조가 존재합니다.'); return;   break;
    case 9090: alert('본선시드배정이 생성되지 않았습니다.'); return;   break;
    case 9091: alert('편성된 선수중 존재하지않는 선수가 있습니다.'); return;   break;
    case 9092: alert('현재 자리에 생성정보가 있습니다. 새로고침하십시오.'); return;   break;
    case 9093: alert('이미 변경된 정보가 있습니다. 새로고침 후 이용해주세요.'); return;   break;


    case 1234: alert('입력중인 경기일수 있으니 테블릿에서 확인해주십시오. 결과처리도 테블릿에서 하여 주십시오.');    break; //경기종료 테블릿 입력 값이 존재하는경우
    }
  }

  switch (Number(reqcmd)) {
    case mx.CMD_SETTOURNJOO: this.OnRefresh(); break;
    case mx.CMD_SETLEAGUERANKING: this.OnRefreshOrder(reqcmd, jsondata, htmldata, sender); break;

    case mx.CMD_INPUTREGION: alert("저장성공"); this.OnRefresh(); break;
    case mx.CMD_SETTOURNWINNER: this.OnRefresh(); break;
    case mx.CMD_GAMECANCEL: this.OnRefresh(); break;
    case mx.CMD_TOURN : this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break; // 본선경기진행
    case mx.CMD_TOURNTABLE : this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break; // 본선경기진행
    case mx.CMD_LEAGUEJOO : this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break; // 예선진행
    case mx.CMD_LEAGUEPRE : this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break; // 출전신고, 예선대진표
    case mx.CMD_RNDNOEDIT : this.OnRefresh(); break;
    case mx.CMD_INITCOURT : this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
    case mx.CMD_GAMEADDITIONFLAG : this.OnRefresh(); break;
    case mx.CMD_LEAGUEWIN: this.OnRefresh(); break;
    case mx.CMD_LEAGUEDRAW: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
    case mx.CMD_LEAGUECOURT: this.OnRefresh(); break;
    case mx.CMD_TOURNWIN: this.OnRefresh(); break;
    case mx.CMD_TOURNEND: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
    case mx.CMD_TOURNCOURT: this.OnRefresh(); break;



  case mx.CMD_UPDATEMEMBER:this.OnModalUpdateMember( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_FINDPLAYER2: this.OndrowHTML2( reqcmd, jsondata, htmldata, sender );		break;
  case mx.CMD_CHANGEPLAYER:this.OnChangeReload( reqcmd, jsondata, htmldata, sender ); break;

  
  case mx.CMD_BYEWIN: this.OnRefresh(); break;
  }
};

mx.OndrowHTML =  function(cmd, packet, html, sender) {
  closeModal();

	document.getElementById(sender).innerHTML = html;
	$('#'+sender).addClass('s_show');
  document.querySelector('body').classList.add('s_modal');
};

function closeModal() {
  var $modal = document.querySelectorAll('.l_modal');
  for (var i = 0; i < $modal.length; i++) {
    $modal[i].classList.remove('s_show');
    $modal[i].innerHTML = "";
  }

  document.querySelector('body').classList.remove('s_modal');
}

mx.OnRefresh = function() {
	$('#reloadbtn').click();
	return;
}

mx.OnRefreshOrder = function(cmd, packet, html, sender) {
	//본선대진
	//$('#reloadbtn').click();
	//return;

//  obj.IDX = idx;
//  obj.TitleIDX = mx.gameinfo.IDX;
//  obj.Title = mx.gameinfo.TITLE;
//  obj.TeamNM = teamnm;
//  obj.AreaNM = areanm;
//  obj.ONEMORE = "notok";
	
//	packet.IDX = packet.LIDX;
//	packet.TeamNM = packet.LIDX;
//	packet.AreaNM = packet.LIDX;
	//본선대진표 (부전승처리)
	packet.CMD = mx.CMD_BYEWIN;
	mx.SendPacket(null, packet);
}



mx.gameinfo;
$(document).ready(function() {
  localStorage.removeItem('MOREINFO');
  var gameinfo = localStorage.getItem('GAMEINFO');

	if (gameinfo == '' || gameinfo == null) {
		location.href = 'mobile_index.asp';
	}
  mx.gameinfo = JSON.parse(gameinfo);
});


//코트 목록
mx.initCourt = function(idx,teamnm,areanm,stateno) {
  var obj = {};
  obj.CMD = mx.CMD_INITCOURT;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.StateNo = stateno;

  mx.SendPacket('t_court', obj);
};


//코트 생성, 수정, 삭제, 잠금
mx.manage_court = function(packet) {
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

  mx.SendPacket('t_court', packet);
}



// S:출전신고 예선 대진표
mx.leaguepre = function(idx,teamnm,areanm,stateno,gno) {
  var obj = {};
  obj.CMD = mx.CMD_LEAGUEPRE;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.StateNo = stateno;
  obj.Gno = gno;

  mx.SendPacket('t_league_pre', obj);
}

// 그룹선택
mx.changeGroup = function(packet) {
  packet.Gno = $("#groupSelect option:selected").val();
  console.log(packet);
  mx.SendPacket('t_league_pre', packet);
}

// 출석, 입금, 사은품
mx.flagChange = function(packet, type, sender) {
  packet.CMD = mx.CMD_GAMEADDITIONFLAG;
  packet.TYPE = type;

  if(sender.value == "Y"){
    packet.FLAGCHECK = "N";
  }
  else {
    packet.FLAGCHECK = "Y";
  }

  event.stopPropagation();

  mx.SendPacket(null, packet);
   //상위로 이벤트가 전파되지 않도록 중단한다.
};

// 순위변경
mx.SetGameLeagueRanking = function(packet){
  var rankno = $('#'+packet.POS).val();
  //if (confirm(rankno + "로 순위를 지정하시겠습니까?")) {
  packet.CMD = mx.CMD_SETLEAGUERANKING;
  packet.GN = 0; //예선
  packet.RANKNO = rankno;

  mx.SendPacket("t_league_pre", packet);

};

// E:출전신고 예선 대진표

// S: 예선경기진행
mx.league_ing = function(idx,teamnm,areanm,stateno,gno){
  var obj = {};
  obj.CMD = mx.CMD_LEAGUEPRE;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.StateNo = stateno;
  obj.JONO = 0;
  obj.CMD = mx.CMD_LEAGUEJOO;
  obj.GNO = gno;
  mx.SendPacket('t_match-list',obj);
};

// 그룹선택
mx.changeLeagueGroup = function(packet) {
  packet.GNO = $("#groupSelect option:selected").val();
  console.log(packet);
  mx.SendPacket('t_league_pre', packet);
}

mx.league_win = function(winidx,packet,num){
	if (!confirm( "처리 하시겠습니까?")) {
		return;
	}
  packet.CMD = mx.CMD_LEAGUEWIN;
  packet.T1_SCORE = $("#t1_score" + num + " option:selected").val();
  packet.T2_SCORE = $("#t2_score" + num + " option:selected").val();
  packet.WINIDX = winidx;
  mx.SendPacket(null,packet);
};

mx.league_court = function(tdid,packet){
  packet.CMD = mx.CMD_LEAGUECOURT;
  packet.COURTNO = $("#gcourt_"+tdid).val();
  mx.SendPacket(tdid,packet);
};
// E: 예선경기진행


// S: 본선 대진추첨

// 대진표
mx.league_draw = function(idx,teamnm,areanm,stateno) {
  var obj = {};
  obj.CMD = mx.CMD_LEAGUEDRAW;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.StateNo = stateno;

  mx.SendPacket('t_draw-lots', obj);
}

// 지역저장
mx.inputRegion = function(packet) {

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

// 번호 변경
mx.update_rndno = function(packet, memberidx, str, rndno_obj) {

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
// E: 본선 대진추첨


// S: 본선 경기진행

// 경기진행 화면
mx.tournament_ing = function(idx,teamnm,areanm,resetflag){
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

  mx.SendPacket('t_match_main', obj);
};

mx.tourn_court = function(tdid,packet){
  packet.CMD = mx.CMD_TOURNCOURT;
  packet.COURTNO = $("#gcourt_"+tdid).val();
  mx.SendPacket(tdid,packet);
};

mx.tourn_win = function(teamstr,winidx,packet){
	if (!confirm( teamstr + "을 승리로 처리 하시겠습니까?")) {
		return;
	}
  packet.CMD = mx.CMD_TOURNWIN;
  packet.WINIDX = winidx;
  packet.SCOREA = $("#scoreA_"+packet.T_M1IDX).val();
  packet.SCOREB = $("#scoreB_"+packet.T_M2IDX).val();
  window.t2oriScroll = $("#t2_drowbody").scrollTop();
  mx.SendPacket(null,packet);
};

mx.tournament_ing_end = function(idx,teamnm,areanm,resetflag){
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

  mx.SendPacket('t_match_main', obj);
};

mx.change_tourn_list = function (idx,teamnm,areanm,resetflag,$el) {
  var state = $el.find("option:selected").val();
  if (state == 'ing') {
    mx.tournament_ing(idx,teamnm,areanm,resetflag);
  } else if (state == 'end') {
    mx.tournament_ing_end(idx,teamnm,areanm,resetflag);
  }
}

// 대진표
mx.tournament_table = function(idx,teamnm,areanm,resetflag){
  var obj = {};
  obj.CMD = mx.CMD_TOURNTABLE;
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

  mx.SendPacket('t_match_main', obj);
};

mx.SetTournGameResult = function(packet){
  packet.CMD = mx.CMD_SETTOURNWINNER;
  packet.GN = 1; //본선
  window.toriScroll = $("#realTimeContents").scrollTop();
	console.log(window.toriScroll);
	mx.SendPacket("t_match_main", packet);
};

//승처리 취소
mx.SetTournGameCanCel = function(packet){
    packet.CMD = mx.CMD_GAMECANCEL;
    packet.GN = 1; //본선
    window.toriScroll = $("#realTimeContents").scrollTop();
	mx.SendPacket("t_match_main", packet);
};

mx.tornGameIn = function(packet){
  packet.CMD = mx.CMD_SETTOURNJOO;
  mx.SendPacket("t_match_main", packet);
};


// E: 본선 경기진행







////////////////////////////////////////////////////////////////////////////


mx.updateMember = function (packet){
  packet.CMD = mx.CMD_UPDATEMEMBER;
  mx.SendPacket("Modaltest", packet);
};


mx.OnModalUpdateMember =  function(cmd, packet, html, sender){
  //window.oriScroll = $("#drowbody").scrollTop();
  document.getElementById(sender).innerHTML = html;
  mx.gameinfo.LEVELNO = packet.S3KEY;
  localStorage.setItem('GAMEINFO', JSON.stringify( mx.gameinfo  ));
  $('#'+sender).show();
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
			mx.ajaxurl = "/pub/ajax/reqMobileTennisContestlevel.asp"; //원래대로
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
			mx.ajaxurl = "/pub/ajax/reqMobileTennisContestlevel.asp"; //원래대로
        }
    });
};


mx.OndrowHTML2 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;

	$("#drowbody").scrollTop(window.oriScroll);
};

mx.OnChangeReload =  function(cmd, packet, html, sender){
	$('#Modaltest').hide();
	$('#reloadbtn').click();
	//alert("적용 되었습니다."); //선수 교체 또는 신규팀등록
};
