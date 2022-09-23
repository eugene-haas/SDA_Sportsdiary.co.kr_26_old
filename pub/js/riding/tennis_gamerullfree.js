var mx_gameRull = mx_gameRull || {};
////////////////////////////////////////
  mx_gameRull.CMD_DATAGUBUN = 10000;
  mx_gameRull.CMD_FIND1 = 30005;
  mx_gameRull.CMD_FIND2 = 30006;
  mx_gameRull.CMD_SETGAME = 40000;

  mx_gameRull.CMD_SAVEGAME = 45000;
  mx_gameRull.CMD_SAVETrJoono = 45010;

  mx_gameRull.CMD_Delete = 46010;
////////////////////////////////////////

mx_gameRull.IsHttpSuccess = function( r ){
  try{
    return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
  }
  catch(e){}
  return false;
};

mx_gameRull.HttpData = function( r, type ){
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
mx_gameRull.waitUntil = function (fn, condition, interval) {
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
mx_gameRull.SendPacket = function( sender, packet){
  var datatype = "mix";
  var timeout = 5000;
  var reqcmd = packet.CMD;
  var reqdone = false;//Closure
  var url = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisGameRullfree.asp";
  var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
  var xhr = new XMLHttpRequest();
  xhr.open( "POST", url );
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  setTimeout( function(){ reqdone = true; }, timeout );



  xhr.onreadystatechange = function(){
    if( xhr.readyState == 4 && !reqdone ){
      if( mx_gameRull.IsHttpSuccess( xhr ) ){

        mx_gameRull.ReceivePacket( reqcmd, mx_gameRull.HttpData( xhr, datatype ), sender );
        return true;
      }
      xhr = null;
    }
  };
  console.log(JSON.stringify( packet  ) );
  xhr.send( strdata );
};

mx_gameRull.ReceivePacket = function (reqcmd, data, sender) {// data는 response string
    var rsp = null;
    var callback = null;
    var jsondata = null;
    var htmldata = null;
    var resdata = null;


    if (Number(reqcmd) > mx_gameRull.CMD_DATAGUBUN) {
        if (data.indexOf("`##`") !== -1) {
            resdata = data.split("`##`");
            jsondata = resdata[0];
            if (jsondata != '') { jsondata = JSON.parse(jsondata); }
            htmldata = resdata[1];

        }
        else {

            htmldata = data;
            try {
                jsondata = JSON.parse(data);
            }
            catch (ex) {

            }
        }
    }
    else {

        if (typeof data == 'string') { jsondata = JSON.parse(data); }
        else { jsondata = data; }
    }

    if (jsondata != '' && jsondata != null) {
        switch (Number(jsondata.result)) {
            case 0: break;
            case 1: alert('데이터가 존재하지 않습니다.'); return; break;
            case 2: alert('편성조건에 만족하지 않습니다.'); return; break;
            case 3: alert('본선이 대진표가 완료된 경우 순위 변동을 할 수 없습니다..'); return; break;
            case 4: alert('본선이 대진표가 완료된 경우 추첨번호를 변경 할 수 없습니다.'); return; break; //메시지 없슴
            case 20: alert("삭제되었습니다."); $("#" + sender).remove(); return; break; //메시지 없슴
            case 12345: alert('저장이 완료되었습니다.'); return; break; //메시지 없슴
            case 12346: alert('경기가 종료되었습니다.'); return; break; //메시지 없슴
			case 100: return; break; //메시지 없슴
        }
    }

    switch (Number(reqcmd)) {
        case mx_gameRull.CMD_FIND1: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_gameRull.CMD_FIND2: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_gameRull.CMD_SETGAME: this.OnAppendHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_gameRull.CMD_SAVEGAME: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break; 
    }


    if (jsondata != '' && jsondata != null) {
        switch (Number(jsondata.result)) {
            case 99: console.log("조회"); break; //메시지 없슴
        }
    }



    if (Number(reqcmd) == mx_gameRull.CMD_SAVEGAME) {
        mx_gameRull.find2();
    }

    if (Number(reqcmd) == mx_gameRull.CMD_SAVETrJoono) {

        if (Number(jsondata.result) == 0) {
            //this.id="newid";
            var oldId = jsondata.order + "_" + jsondata.joono1;
            var newId = jsondata.order + "_" + jsondata.joono2;
            $("#" + sender).prop("id", "b_" + newId).val(jsondata.joono2);
            $("#" + "c_" + oldId).prop("id", "c_" + newId);
            $("#" + "i_" + oldId).prop("id", "i_" + newId);
            $("#" + "c_" + newId).html(jsondata.joono2);
        } else {
            console.log(123);
        }
    }

};
 

mx_gameRull.OndrowHTML = function (cmd, packet, html, sender) {
    if (cmd == mx_gameRull.CMD_FIND2) {
		$("#jono").val(packet.jonocnt);
        $("#seedcnt").val(packet.seedcnt);
        $("#attteamcnt").val(packet.attcnt);
		$('#btnsave2').click();
    }
	else{
    document.getElementById(sender).innerHTML = html;	
	}

};


mx_gameRull.OnAppendHTML =  function(cmd, packet, html, sender){
  document.getElementById(sender).innerHTML = html;
};



mx_gameRull.find1 = function(){
  var obj = {};
  obj.CMD = mx_gameRull.CMD_FIND1;
  obj.FSTR = $("#TitleCode").val();
  mx_gameRull.SendPacket('level_form', obj);

  $("#btnmake").hide();
  $("#btndelGame").hide();
};
mx_gameRull.find2 = function(){
  var obj = {};
  obj.CMD = mx_gameRull.CMD_FIND2;
  obj.FSTR = $("#TitleCode").val();
  obj.FSTR2 = $("#booColde").val();
  mx_gameRull.SendPacket('updatelog', obj);
};

mx_gameRull.DelGame = function () {
    if (confirm("생성된 대진표를 삭제 하시겠습니까?")) {
        var id = $("#mxjoono").val();
        if (id) {
            var obj = {};
            obj.CMD = mx_gameRull.CMD_Delete;
            obj.mxjoono = id;
            mx_gameRull.SendPacket('gametablelist', obj);
        }
    }
}

mx_gameRull.saveGame = function () {
    if (document.getElementById('rullmsg') == null) {
        alert("대진표 생성 후 저장하여 주십시오.");
        return;
    }
    //룰생을 먼저 하도록 유도

    var obj = {};
    obj.CMD = mx_gameRull.CMD_SAVEGAME;
    if ($("#TitleCode").val() == '') {
        alert("대회를 선택해 주세요.");
        return;
    }
    if ($("#booColde").val() == '') {
        alert("부를 선택해 주세요.");
        return;
    }
    if ($("#attteamcnt").val() == '') {
        alert("드로우수를 입력해 주십시오.");
        return;
    }

    obj.FSTR = $("#TitleCode").val();
    obj.FSTR2 = $("#booColde").val();
    obj.ATTCNT = $("#attteamcnt").val();
    obj.SEED = $("#seedcnt").val();
    obj.JONO = $("#jono").val();


    //조건검사
    if (Number(Number(obj.ATTCNT) / Number(obj.SEED)) % 8 != 0) {
        alert("8의 배수 요건에 충족하지 않습니다.");
        return;
    }

    if (Number(obj.ATTCNT) - (Number(obj.JONO) * 2) < 0) {
        alert("팀수가 드로우수보다 많습니다.");
        return;
    }

    if (Number(Number(obj.ATTCNT) / 2) > Number(obj.JONO) * 2) {
        alert("팀수가 너무 적습니다.");
        return;
    }


    var boxcnt = Math.floor(Number(obj.ATTCNT) / 16);
    if (boxcnt == 2 || boxcnt == 4 || boxcnt == 8 || boxcnt == 16) {
        //기본룰 사용
        obj.BOXORDER = 0
    }
    else {

        var boxorder = prompt(boxcnt + "개의 박스배열순서를 넣어주세요. 숫자사이에 ',' 사용");

        if (boxorder == null) {
            return;
        }
        else {
            obj.BOXORDER = boxorder;
        }
    }


    mx_gameRull.SendPacket('rullmsg', obj);
    $("#btnmake").hide();
    $("#btndelGame").hide();

}

mx_gameRull.jonoChange = function () {
    if ($("#jono").val() > 2 && $("#jono").val() <= 4) {
        $("#attteamcnt").val(8);
    }else if ($("#jono").val() > 4 && $("#jono").val() <= 8) {
        $("#attteamcnt").val(16);
    } else if ($("#jono").val() > 8 && $("#jono").val() <= 16) {
        $("#attteamcnt").val(32);
    } else if ($("#jono").val() > 16 && $("#jono").val() <= 32) {
        $("#attteamcnt").val(64);
    } else if ($("#jono").val() > 32 && $("#jono").val() <= 64) {
        $("#attteamcnt").val(128);
    } else if ($("#jono").val() > 64 && $("#jono").val() <= 128) {
        $("#attteamcnt").val(256);
    } else if ($("#jono").val() > 128 && $("#jono").val() <= 256) {
        $("#attteamcnt").val(512);
    }
    else {
        $("#attteamcnt").val(8);
    }
}
mx_gameRull.trjoonoSave = function (val) {
    var inputId = val.id;
    //input 값 변경 및 화면 다시그리기 
    var sd = inputId.split('_');
    var obj = {}; 
    obj.CMD = mx_gameRull.CMD_SAVETrJoono;
    obj.FSTR = $("#TitleCode").val();
    obj.FSTR2 = $("#booColde").val();
    obj.order = sd[1];
    obj.joono1 = sd[2];
    obj.joono2 = $("#" + inputId).val();

    if ($("#i_" + sd[1]+"_" + sd[2]).val() == "0") {
        alert("추첨번호는 대진표 저장 후 변경 할 수 있습니다.");
        $("#" + inputId).val(sd[2]);
    } else if ($("#" + inputId).val() <= 0) {
        alert("추첨번호는 0 보다 커야 됩니다.");
        $("#" + inputId).val(sd[2]);
    } else {
        if (document.getElementById("b_" + sd[1] + "_" + $("#" + inputId).val())) {
            alert("이미 사용중인 추첨번호 입니다.");
            $("#" + inputId).val(sd[2]);
        } else {
            obj.FSTR_idx = $("#i_" + sd[1] + "_" + sd[2]).val();
            mx_gameRull.SendPacket(inputId, obj);
        }
    }
}

mx_gameRull.setGame = function () {
    var obj = {};
    obj.CMD = mx_gameRull.CMD_SETGAME;
    if ($("#TitleCode").val() == '') {
        alert("대회를 선택해 주세요.");
        return;
    }
    if ($("#booColde").val() == '') {
        alert("부를 선택해 주세요.");
        return;
    }
    if ($("#attteamcnt").val() == '') {
        alert("드로우수를 입력해 주십시오.");
        return;
    }

    obj.FSTR = $("#TitleCode").val();
    obj.FSTR2 = $("#booColde").val();
    obj.ATTCNT = $("#attteamcnt").val();
    obj.SEED = $("#seedcnt").val();
    obj.JONO = $("#jono").val();

	if (Number(obj.SEED) == 0 ){
		obj.SEED = 1;
	}


    //조건검사
    if (Number(Number(obj.ATTCNT) / Number(obj.SEED)) % 8 != 0) {
        alert("8의 배수 요건에 충족하지 않습니다.");
        return;
    }

    if (Number(obj.ATTCNT) - (Number(obj.JONO) * 2) < 0) {
        alert("팀수가 드로우수보다 많습니다.");
        return;
    }

    if (Number(Number(obj.ATTCNT) / 2) > Number(obj.JONO) * 2) {
        alert("팀수가 너무 적습니다.");
        return;
    }


    var boxcnt = Math.floor(Number(obj.ATTCNT) / 16);
    if (boxcnt == 2 || boxcnt == 4 || boxcnt == 8 || boxcnt == 16) {
        //기본룰 사용
        obj.BOXORDER = 0
    }
    else {

		var bx = localStorage.getItem('BOXORDER');
		if (bx == null){
			var boxorder = prompt(boxcnt + "개의 박스배열순서를 넣어주세요. 숫자사이에 ',' 사용");
		}else{
			var boxorder = prompt(boxcnt + "개의 박스배열순서를 넣어주세요. 숫자사이에 ',' 사용", bx);		
		}

			if (boxorder == null) {
				return;
			}
			else {
				obj.BOXORDER = boxorder;
				localStorage.setItem('BOXORDER', obj.BOXORDER);
			}
    }


    mx_gameRull.SendPacket('updatelog', obj);
    $("#btnmake").show();
    $("#btndelGame").show();
};




//============================================================
mx_gameRull.reset1ST = function(packet){

	var st1str = "";
	var byestr = "";
	var box1stno=0;
	var st1sum = 0;
	var boxbyeno=0;
	var byesum = 0;

	for (var i = 1; i <= packet.boxcnt ;i++){
		box1stno = $('#st1_'+i).val();
		st1sum = st1sum + Number(box1stno);
		boxbyeno = $('#bye_'+i).val();
		byesum = byesum + Number(boxbyeno);

		if(i == 1){
		  st1str  = box1stno;
		  byestr  = boxbyeno;
		}
		else{
		  st1str  = st1str +":"+ box1stno;
		  byestr  = byestr +":"+ boxbyeno;
		}
	}

	if (Number(st1sum)  != Number(packet.JONO)){
		alert("총 1위 자리 합이 틀림니다.");
		return;
	}
	if (Number(byesum)  != Number(packet.totalbye)){
		alert("총 BYE의 합이 틀림니다."+ byesum);
		return;
	}

	packet.CMD = mx_gameRull.CMD_SETGAME;
	packet.ST1 = st1str;
	packet.BYE = byestr;

	mx_gameRull.SendPacket('updatelog', packet);
};

mx_gameRull.reset1STvalue = function(packet){

	for (var i = 1; i <= Number(packet.ATTCNT) ;i++){
		$('#ik_'+i).val('');
	}
};

mx_gameRull.resetBYEvalue = function(packet){
	for (var i = 1; i <= Number(packet.ATTCNT) ;i++){
		$('#iv_'+i).val('');
	}
};


mx_gameRull.saveRull = function(packet){
	var st1str = "";
	var byestr = "";
	var box1stno=0;
	var st1sum = 0;
	var boxbyeno=0;
	var byesum = 0;

	for (var i = 1; i <= Number(packet.ATTCNT);i++){
		box1stno = $('#ik_'+i).val();
		st1sum++;
		boxbyeno = $('#iv_'+i).val();
		byesum++;

		if(i == 1){
		  st1str  = box1stno;
		  byestr  = boxbyeno;
		}
		else{
		  st1str  = st1str +":"+ box1stno;
		  byestr  = byestr +":"+ boxbyeno;
		}
	}

	if (Number(st1sum)  != Number(packet.ATTCNT)){
		alert("순위 번호에 빈자리가 있습니다.");
		return;
	}
	if (Number(byesum)  != Number(packet.ATTCNT)){
		alert("랜덤번호에 빈자리가 있습니다.");
		return;
	}

	packet.CMD = mx_gameRull.CMD_SETGAME;
	packet.ST1V = st1str;
	packet.BYEV = byestr;

	////////////////////////////
	st1str = "";
	byestr = "";
	box1stno=0;
	st1sum = 0;
	boxbyeno=0;
	byesum = 0;

	for (var i = 1; i <= packet.boxcnt ;i++){
		box1stno = $('#st1_'+i).val();
		st1sum = st1sum + Number(box1stno);
		boxbyeno = $('#bye_'+i).val();
		byesum = byesum + Number(boxbyeno);

		if(i == 1){
		  st1str  = box1stno;
		  byestr  = boxbyeno;
		}
		else{
		  st1str  = st1str +":"+ box1stno;
		  byestr  = byestr +":"+ boxbyeno;
		}
	}

	if (Number(st1sum)  != Number(packet.JONO)){
		alert("총 1위 자리 합이 틀림니다.");
		return;
	}
	if (Number(byesum)  != Number(packet.totalbye)){
		alert("총 BYE의 합이 틀림니다." +byesum  + " "+ packet.totalbye);
		return;
	}
	packet.ST1 = st1str;
	packet.BYE = byestr;


	mx_gameRull.SendPacket('updatelog', packet);
};