var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_LOGIN = 1; //로그인
	mx.CMD_LOGOUT = 2;
	mx.CMD_LOGCHECK = 3;
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

mx.ajaxurl = "/pub/ajax/ksports/req.asp";
mx.SendPacket = function (sender, packet) {

	var datatype = "mix";
    var timeout = 5000;
    var reqcmd = packet.CMD;
    var reqdone = false; //Closure
    var url = mx.ajaxurl;
    var strdata = "REQ=" + encodeURIComponent(JSON.stringify(packet));
    var xhr = new XMLHttpRequest();
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    setTimeout(function () { reqdone = true; }, timeout);

    if (Number(packet.CMD) >= mx.CMD_DATAGUBUN) {
        //apploading("AppBody", "로딩 중 입니다.");
    }

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && !reqdone) {
            if (mx.IsHttpSuccess(xhr)) {

                if (Number(packet.CMD) >= mx.CMD_DATAGUBUN) {
                    //$('#AppBody').oLoader('hide');
                }
 
                mx.ReceivePacket(reqcmd, mx.HttpData(xhr, datatype), sender);
                return true;
            }
            xhr = null;
        }
    };
    console.log(JSON.stringify(packet));
    xhr.send(strdata);
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
		}
	}
	else{
		if(typeof data == 'string'){jsondata = JSON.parse(data);}
		else{jsondata = data;}
	}

	if( jsondata !='' && jsondata != null){

		//debug print
		if (jsondata.hasOwnProperty('debug') == true ){
			console.log("debug : " + jsondata.debug);
		}

		switch (Number(jsondata.result))	{
		case 0:	break;
		case 1:	alert('데이터가 존재하지 않습니다.');return; 	break;
		case 50:	mx.confirm();return; 	break;
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_LOGIN:	this.OnLogin( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_LOGOUT:	this.OnLogout( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_LOGCHECK:	this.OnLoginchk( reqcmd, jsondata, htmldata, sender );		break;
	}
};

mx.login = function(){
	if($("#UserID").val() == ""){
		alert("아이디를 입력하여 주십시오.");
		return;
	}

	if($("#UserPass").val() == ""){
		alert("패스워드를 입력하여 주십시오");
		return;
	}
	mx.SendPacket(null, {'CMD':mx.CMD_LOGIN,'ID':$("#UserID").val(),'PWD':$("#UserPass").val()})	
};


mx.OnLogin =  function(cmd, packet, html, sender){
	if (packet.logincheck ==  "1"){ //성공
		location.href= packet.targeturl;
	}
	else{
		alert("입력하신 내용이 일치하지 않습니다.");
	}
};