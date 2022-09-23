var mx =  mx || {};
mx.CMD_DATAGUBUN = 10000;

///////////////////////////////////////////
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

mx.ajaxurl = "/pub/ajax/bike/reqRequest.asp"; 
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
		switch (Number(jsondata.result))	{
		case 0:	break;
		case 1:	alert('데이터가 존재하지 않습니다.');return; 	break;
		case 2:	alert('중복된 데이터가 존제합니다.');return; 	break;
		case 300: alert('사용 중 입니다.');return; break;
		case 301: alert('사용가능 합니다.');return; break;
		case 302: alert('보호자의 전화번호를 정확히 입력해 주십시오.');return; break;

		case 400: alert('회원가입이 되어있지 않습니다.');return; break;
		case 401: alert('자전거 선수로 등록되어 있지 않습니다. 선수등록 후 이용해 주십시오.');return; break;

		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	//case mx.CMD_SETINFOCHANGE:this.OndrowHTML( reqcmd, jsondata, htmldata, sender );	break;
	}
};

///////////////////////////////////////////

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
};

mx.OnGoUrl = function(cmd, packet, html, sender){
	if (packet.adult == 'N'){//부모동의 발송
		packet.CMD = mx.CMD_PLMS;
		mx.SendPacket(sender, packet);			
	}
	else{
		mx.go(packet, sender);
	}
};

mx.OnAppend = function(cmd, packet, html, sender){
  $("#"+sender).append( html );
};

////////////////////////////////////////////


mx.go = function(packet, gourl){
	document.sform.p.value =   JSON.stringify( packet  );
	document.sform.action = gourl;
	document.sform.submit();
};


mx.goMall = function(packet, gourl){
	document.mallform.p.value =   JSON.stringify( packet  );
	document.mallform.action = gourl;
	document.mallform.submit();
};


//////////////////////////////////////////////////////////////////////////

//숫자만입력
mx.chkNo = function(){
	if(event.keyCode == 8 || event.keyCode ==46){}else{if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;}
};


mx.notice = function(){
	var $viewport = $('head meta[name="viewport"]');    
	$viewport.attr('content', 'width=device-width, minimum-scale=1, initial-scale=1');
	//$('#summary_modal').show();
};


mx.noticeclose = function(){
	var $viewport = $('head meta[name="viewport"]');    
	$viewport.attr('content','width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no');
};






//공통 script import //////////////////////////////////////////////////
mx.loadScript = function(url, callback) {
	var script = document.createElement('script');
	script.src = url;
	script.onload = callback;
	document.getElementsByTagName('head')[0].appendChild(script);
};
mx.myloaded = function() {
	//document.write(str);
};
mx.loadScript('/pub/js/bike/pub.js', mx.myloaded);
