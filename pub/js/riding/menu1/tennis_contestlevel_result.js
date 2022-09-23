var sd =  sd || {};
////////////////////////////////////////
  sd.CMD_DATAGUBUN = 10000;
  sd.CMD_PROCESSRESULT = 20000;
  sd.CMD_SETRANKER = 30000;
  sd.CMD_DELRANKER = 30001;
  sd.CMD_SETGAME = 40000;
  sd.CMD_SETRANK = 40001;

  sd.CMD_CHANGERANK = 100;
  sd.CMD_CHANGEPOINT = 200;
  sd.CMD_RESETRANK = 300;


  sd.CMD_SETRANKERWINDOW = 40012;
  sd.CMD_SETRANKEROK = 610;

  sd.CMD_MAKEGOODS = 50000;
  sd.CMD_INSERTDEP1 = 50002; //대분류선택
////////////////////////////////////////

sd.IsHttpSuccess = function( r ){
  try{
    return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
  }
  catch(e){}
  return false;
};

sd.HttpData = function( r, type ){
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
sd.waitUntil = function (fn, condition, interval) {
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


sd.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/admenu1/REQLevelResult.asp";
//동일한 패킷이 오는경우 (막음 처리해야겠지)
sd.SendPacket = function( sender, packet){
  var datatype = "mix";
  var timeout = 5000;
  var reqcmd = packet.CMD;
  var reqdone = false;//Closure
  var url = sd.ajaxurl;
  var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
  var xhr = new XMLHttpRequest();
  xhr.open( "POST", url );
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  setTimeout( function(){ reqdone = true; }, timeout );

    //if ( Number(packet.CMD) >= sd.CMD_DATAGUBUN  ){
  //  apploading("AppBody", "로딩 중 입니다.");
  //}

  xhr.onreadystatechange = function(){
    if( xhr.readyState == 4 && !reqdone ){
      if( sd.IsHttpSuccess( xhr ) ){

        //if ( Number(packet.CMD) >= sd.CMD_DATAGUBUN  ){
        //  $('#AppBody').oLoader('hide');
        //}

        sd.ReceivePacket( reqcmd, sd.HttpData( xhr, datatype ), sender );
        return true;
      }
      xhr = null;
    }
  };
  console.log(JSON.stringify( packet  ) );
  xhr.send( strdata );

};

sd.ReceivePacket = function( reqcmd, data, sender ){// data는 response string

  var rsp = null;
  var callback = null;
  var jsondata = null;
  var htmldata = null;
  var resdata = null;


  if ( Number(reqcmd) > sd.CMD_DATAGUBUN  ){
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
    case 2: alert('중복'); break;
	case 1001: alert('이미 등록된 이름입니다.');return;  break;
  case 1002: alert('대회 참가자가 아님니다.');return;  break;
  case 1004: alert('동일한 이름이 두명이상 존재합니다. 인덱스 번호로 입력해주십시오.');return;  break;
	case 1003: return;  break;

	case 3104: alert('승급자로 설정되었습니다(외부경기).');  return; 	break;
	case 3105: sd.contestResultBack(jsondata); return; break;


	}
  }

  switch (Number(reqcmd)) {
	case sd.CMD_SETGAME:
	case sd.CMD_PROCESSRESULT:sd.OntableHTML( reqcmd, jsondata, htmldata, sender );   break;
	case sd.CMD_SETRANKER:	sd.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;
	case sd.CMD_DELRANKER:	sd.OndelHTML( reqcmd, jsondata, htmldata, sender );		break;

	case sd.CMD_CHANGERANK:	sd.OnComment( reqcmd, jsondata, htmldata, sender );		break;
	case sd.CMD_CHANGEPOINT:	sd.OnComment( reqcmd, jsondata, htmldata, sender );		break;
	case sd.CMD_SETRANK:  sd.OnAppendHTML( reqcmd, jsondata, htmldata, sender );    break;

	case sd.CMD_RESETRANK:  sd.OnReLoad( reqcmd, jsondata, htmldata, sender );    break;

	case sd.CMD_SETRANKERWINDOW  : this.OnRankHTML( reqcmd, jsondata, htmldata, sender );		break;

	case sd.CMD_MAKEGOODS: this.OnwritePop( reqcmd, jsondata, htmldata, sender );		break;
	case sd.CMD_INSERTDEP1: this.OnDrawHTML( reqcmd, jsondata, htmldata, sender );		break;
  }
};



/////////////////////////////////////////
//호출
/////////////////////////////////////////
sd.OnDrawHTML =  function(cmd, packet, html, sender){
	$('#' + sender).html(html);
};


sd.OnwritePop =  function(cmd, packet, html, sender){
	if( $('#' + sender).length == 0 ){
		document.body.innerHTML = "<div class='modal fade basic-modal myModal' id='"+sender+"' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'></div>";
	}
	$('#' + sender).html(html);
	$('#' + sender).modal('show');
};

//생성 팝업창 요청
sd.makeGoods = function(){
	var obj = {};
    obj.CMD = sd.CMD_MAKEGOODS;
	sd.SendPacket('modalS', obj);
};

//생성 메뉴선택
sd.SelectDEP = function(depno, selectid, drowid , cmd) {
  var GbVal = $("#" + selectid).val();

  var obj = {};
  obj.CMD = cmd;
  obj.DEPNO = depno;
  obj.DPTYPE = GbVal;
  obj.DEP1 = $("#dep01").val();
  obj.DEP2 = $("#dep02").val();
  obj.DEP3 = $("#dep03").val();

  if(GbVal == "insert" ) {
		  if (depno == 3 && obj.DEP1 == ''){
			  alert("상품을 먼저 선택해 주십시오.");
			  return;
		  }

		var GbPrompt = prompt("메뉴명을 입력해주세요",'');
		if(GbPrompt != null && GbPrompt != "") {
		  if (depno == 1){
			  obj.DEP1 = GbPrompt;
		  }
		  else{
			  obj.DEP3 = GbPrompt;		  
		  }
		  sd.SendPacket('modalS', obj);
		}
		else{
		}
  }
  else{
	  //항목만 불러올때
  	  obj.DEPNO = 0;
	  sd.SendPacket('modalS', obj);
  }
};













sd.OnRankHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
};



sd.contestResult = function(idx, levelno ,teamnm, areanm){
  if (confirm("대회결과가 바로 처리됩니다. 처리하시겠습니까?")) {
	var obj ={};
	obj.CMD = sd.CMD_PROCESSRESULT;
	obj.IDX = idx;
	obj.TIDX = mx.gameinfo.IDX;
	obj.TITLE = mx.gameinfo.TITLE;
	obj.LEVELNO = levelno;
	obj.TeamNM = teamnm;
	obj.AreaNM = areanm;
	sd.SendPacket('myModal', obj);
  }
  else{
	return;
  }
};

sd.contestResultBack = function(packet){
	var obj ={};
	obj.CMD = sd.CMD_PROCESSRESULT;
	obj.IDX = packet.IDX;
	obj.TIDX = packet.TIDX;
	obj.TITLE = packet.TITLE;
	obj.LEVELNO = packet.LEVELNO;
	obj.TeamNM = packet.TeamNM;
	obj.AreaNM = packet.AreaNM;
  //console.log(obj);
	sd.SendPacket('myModal', obj);
};


sd.contestResultTest = function(idx, levelno ,teamnm, areanm){
  if (confirm("대회결과가 바로 처리됩니다. 처리하시겠습니까?")) {
	sd.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/admenu1/REQLevelResultTest.asp";
	var obj ={};
	obj.CMD = sd.CMD_PROCESSRESULT;
	obj.IDX = idx;
	obj.TIDX = mx.gameinfo.IDX;
	obj.TITLE = mx.gameinfo.TITLE;
	obj.LEVELNO = levelno;
	obj.TeamNM = teamnm;
	obj.AreaNM = areanm;
	sd.SendPacket('myModal', obj);
	sd.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/admenu1/REQLevelResult.asp";
  }
  else{
	return;
  }
};



sd.setGame = function(idx, levelno ,teamnm, areanm){
	var obj ={};
	obj.CMD = sd.CMD_SETGAME;
	obj.IDX = idx;
	obj.TIDX = mx.gameinfo.IDX;
	obj.TITLE = mx.gameinfo.TITLE;
	obj.LEVELNO = levelno;
	obj.TeamNM = teamnm;
	obj.AreaNM = areanm;
	sd.SendPacket('myModal', obj);
};



sd.setranker = function(levelno){
	var obj = {};
	obj.CMD = sd.CMD_SETRANKER;
	obj.RANKNO = $("#prankno").val();
	obj.NAME = $("#pname").val();
	obj.POINT = $("#ppoint").val();
	obj.TIDX = mx.gameinfo.IDX;
	obj.LEVELNO = levelno;
	sd.SendPacket(null, obj);
};

sd.delranker = function(idx){
	var obj = {};
	obj.CMD = sd.CMD_DELRANKER;
	obj.IDX = idx;
	sd.SendPacket("r_"+idx  , obj);
};

sd.changeRank = function(idx,svalue,levelno){
	var obj = {};
	obj.CMD = sd.CMD_CHANGERANK;
	obj.IDX = idx;
	obj.RANK = svalue;
	obj.TIDX = mx.gameinfo.IDX;
	obj.LEVELNO = levelno;
	sd.SendPacket("prank_"+idx  , obj);
};

sd.changePt= function(idx,svalue,levelno){
	var obj = {};
	obj.CMD = sd.CMD_CHANGEPOINT;
	obj.IDX = idx;
	obj.POINT = svalue;
	obj.TIDX = mx.gameinfo.IDX;
	obj.LEVELNO = levelno;
	sd.SendPacket("pt_"+idx  , obj);
};


sd.setRank = function(midx,tidx,levelno,startno){
	if (Number(midx) === 0){
		return;
	}

  var obj = {};
  obj.CMD = sd.CMD_SETRANK;
  obj.MIDX = midx;
  obj.LEVELNO = levelno;
  obj.TIDX = tidx;
  obj.SNO = startno;
  sd.SendPacket('rp_updatelog', obj);
};

sd.resetResult = function(idx,levelno,teamnm, areanm){
  var obj = {};
  obj.CMD = sd.CMD_RESETRANK;
  obj.LEVELNO = levelno;
  obj.IDX = idx;
  obj.TIDX = mx.gameinfo.IDX;
  obj.TITLE = mx.gameinfo.TITLE;
  obj.TeamNM =teamnm;
  obj.AreaNM = areanm;

  sd.SendPacket('rp_updatelog', obj);
};

/////////////////////////////////////////
//처리
/////////////////////////////////////////

sd.OnReLoad =  function(cmd, packet, html, sender){
	var obj ={};
	obj.CMD = sd.CMD_PROCESSRESULT;
	obj.IDX = packet.IDX;
	obj.TIDX = packet.TIDX;
	obj.TITLE = packet.TITLE;
	obj.LEVELNO = packet.LEVELNO;
	obj.TeamNM = packet.TeamNM;
	obj.AreaNM = packet.AreaNM;
	sd.SendPacket('myModal', obj);
};



sd.OnAppendHTML =  function(cmd, packet, html, sender){
	$('#'+sender).append(html);
	document.getElementById(sender).scrollTop = document.getElementById(sender).scrollHeight;

	if (Number(packet.MIDX) === 0){
		//location.reload();
		return;
	}
	else{
		sd.SendPacket(sender, packet);
	}
};


sd.OntableHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
};

sd.OnBeforeHTML =  function(cmd, packet, html, sender){
	$('.rgametitle').first().before(html);
};

sd.OndelHTML =  function(cmd, packet, html, sender){
	$("#"+sender).remove();
};

sd.OnComment =  function(cmd, packet, html, sender){
	$("#"+sender).css("borderColor", "red");
};





//승급자 날짜 지정 (외부승급자)
sd.setRanker = function(packet){//
	sd.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisMakePlayer.asp";
	packet.CMD = sd.CMD_SETRANKERWINDOW;
	packet.PNAME = "일시승격처리자";
	packet.PTITLE = "일시승격처리";
	sd.SendPacket('myModal', packet);
	sd.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/admenu1/REQLevelResult.asp";
};



//승급자 정보셋팅
sd.setRankerOK = function(packet){
  if (confirm("외부승급자 설정으로만사용바랍니다.만료날짜를 넣으면 기존 승급자도 만료날짜에 영향을 받습니다.")) {
    sd.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisMakePlayer.asp";
		var obj = packet;
    obj.CMD = sd.CMD_SETRANKEROK;

		//check 확인
		if ( $("#rnkyn").is(":checked") == true ) {
		   obj.RNKYN = 'Y';
		}
		else{
		   obj.RNKYN = 'N';
		}
		//입력받은 날짜 (시작, 종료)
		if ($("#rnkstart").val()) {
			obj.RNKSTART = $("#rnkstart").val();
		};
		if ($("#rnkend").val()) {
			obj.RNKEND = $("#rnkend").val();
		};

		//console.log(obj);
		sd.SendPacket('myModal', obj);
    sd.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/admenu1/REQLevelResult.asp";
  } else {
    return;
  }
};
