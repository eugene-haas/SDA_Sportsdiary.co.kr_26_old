var mx =  mx || {};
////////////////////////////////////////

    mx.CMD_DATAGUBUN = 10000;

	mx.CMD_PLMS = 20200;

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

mx.loading = function(){
	var width = $(window).width();
	var height = $(window).height();

	//화면을 가리는 레이어의 사이즈 조정
	$(".backLayer").width(width);
	$(".backLayer").height(height);

	//화면을 가리는 레이어를 보여준다 (0.5초동안 30%의 농도의 투명도)
	$(".backLayer").fadeTo(500, 0.3);

	//팝업 레이어 보이게
	var loadingDivObj = $("#loadingDiv");
	loadingDivObj.css("top", $(document).height()/2-0);
	loadingDivObj.css("left",$(document).width()/2-0);
	loadingDivObj.fadeIn(500);
};

//esc키 누르면 화면 잠김 해제
$(document).keydown(function(event){
	if(event.which=='27'){
		$("#loadingDiv").fadeOut(300);
		$(".backLayer").fadeOut(1000);
	}
});

 //윈도우가 resize될때마다 backLayer를 조정
 $(window).resize(function(){
	var width = $(window).width();
	var height = $(window).height();
	$(".backLayer").width(width).height(height);
});


mx.ajaxurl = "/pub/ajax/bike/reqContestPlayer.asp";
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
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_PLMS : this.OnPLMS( reqcmd, jsondata, htmldata, sender );		break;


	}
};


//drow///////////////
mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
};

mx.OnBeforeHTML =  function(cmd, packet, html, sender){
	$('#contest').first().before(html);
};

mx.OnModal =  function(cmd, packet, html, sender){
  document.getElementById(sender).innerHTML = html;
  $('#'+sender).modal('show');
};

mx.OndelHTML =  function(cmd, packet, html, sender){
	$("#"+sender).remove();
};
//drow///////////////

mx.OnPLMS = function(cmd, packet, html, sender){
	  $("#lmsform").html(html);
	  document.lms_form.submit();
	  //mx.go(packet, sender);

	//   mx.delaypacket = packet;
	//   mx.delaysender = sender;
	//   setTimeout("mx.delaygo()",500);
};

mx.sendLMS = function(attmidx, levelno, titleIDX, playeridx){
		packet = {};
		packet.CMD = mx.CMD_PLMS;
		packet.attmidx = attmidx;
		packet.LVLIDX = levelno;
		packet.tidx = titleIDX;
		packet.p_phone = $("#p_phone_" + playeridx).text();
    //packet.p_phone = "010-2242-7718";
		console.log(packet);
		if(confirm("문자를 보내시겠습니까?")){
			mx.SendPacket(null, packet);
		}
};

mx.searchPlayer = function(pageno){
	var obj ={};
	obj.pg = pageno;
	obj.st = $('#fnd_Type').val();

	if ( $('#fnd_Str').length > 0 ) {
		obj.sv = $('#fnd_Str').val();
	}
	if ( $('#tidx').length > 0 ) {
		obj.tidx = $('#tidx').val();
		if (obj.tidx == ''){
			obj.tidx = 0;
		}
	}
	if ( $('#gidx').length > 0 ) {
		obj.gidx = $('#gidx').val();
		if (obj.gidx == ''){
			obj.gidx = 0;
		}
	}
	if ( $('#ridx').length > 0 ) {
		obj.ridx = $('#ridx').val();
		if (obj.ridx == ''){
			obj.ridx = 0;
		}
	}
	document.sform.p.value =   JSON.stringify( obj  );
	document.sform.submit();
};
