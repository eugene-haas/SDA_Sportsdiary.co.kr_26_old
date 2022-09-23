var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
	mx.CMD_GAMEINPUT = 30001;
	mx.CMD_GAMEINPUTEDIT = 30002; //수정
	mx.CMD_GAMEINPUTEDITOK = 30003;
	mx.CMD_GAMEINPUTDEL = 30004;// 삭제
	mx.CMD_GAMEAUTO = 30007;
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
	var url = "/pub/ajax/reqTennisoperator.asp";
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	//setTimeout( function(){ reqdone = true; }, timeout );

    //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
	//	apploading("AppBody", "로딩 중 입니다.");
	//}

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){
			
				//if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){				
				//	$('#AppBody').oLoader('hide');
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
		case 2:	mx.splashmsg('동일한 내용이 존재 합니다.',1500);return; 	break;
		case 3:	alert('등록되지 않은 데이터가 존재합니다.');return; 	break;
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_GAMEAUTO:
	case mx.CMD_GAMEINPUT:	this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_CONTESTAPPEND:	this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GAMEINPUTEDITOK:
	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GAMEINPUTDEL:	this.OndelHTML( reqcmd, jsondata, htmldata, sender );		break;
	}
};


mx.OnPopClose= function(cmd, packet, html, sender){
	$(sender).modal('toggle');
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if( cmd == mx.CMD_GAMEINPUTEDITOK ||  cmd == mx.CMD_GAMEINPUTEDIT ){
		mx.gameinfo = packet;
		mx.init();
	}
};

mx.OndelHTML =  function(cmd, packet, html, sender){
	localStorage.removeItem('MOREINFO'); //초기화
	$("#totcnt").html(Number($("#totcnt").text()) - 1);
	$("#"+sender).remove();
};

mx.OnAppendHTML =  function(cmd, packet, html, sender){
	if ( packet.lastchk == "_end" ){return;}
	$("#nowcnt").html(packet.NKEY);
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
	$("#totcnt").html(Number($("#totcnt").text()) + 1);
	if( cmd == mx.CMD_GAMEAUTO && Number(packet.AutoNo) > 0){
		$("#autono").val(packet.AutoNo);
		mx.SendPacket(null, packet);
	}
};

////////////////////////////////////////
//목록 불러오기
////////////////////////////////////////
mx.contestMore = function(){

	var moreinfo = localStorage.getItem('MOREINFO'); //다음

	if (moreinfo == null)	{
		var nextkey = 2;
	}
	else{
		moreinfo = JSON.parse(moreinfo);	
		var nextkey = moreinfo.NKEY;
	}
	var parmobj = {'CMD':mx.CMD_CONTESTAPPEND,'NKEY':nextkey};

	mx.SendPacket('contest', parmobj);
};

////////////////////////////////////////
//일시적으로 팝업 보여줌
////////////////////////////////////////
mx.splashmsg = function(msg, deltime){
	$("#w_msg").html(msg);
	$(".warn_modal").modal("show");
	setTimeout(function(){$(".warn_modal").modal('hide');},deltime);
};


////////////////////////////////////////
//입력
////////////////////////////////////////
mx.input_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUT;
	obj.ADID = $("#ad_id").val();
	obj.ADPWD = $("#ad_pwd").val();
	obj.ADTITLE = $("#ad_title").val();

	if (obj.ADID == "" || obj.ADPWD == "" || obj.ADTITLE == "" ){
		mx.splashmsg('입력해 주세요.',1500);
		return;				
	}
	
	mx.SendPacket(null, obj);
};

////////////////////////////////////////
//수정
////////////////////////////////////////
mx.input_edit = function(idx){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTEDIT;
	obj.IDX = idx;
	mx.SendPacket('gamehost', obj);
};

mx.update_frm = function(){
	var obj = {};

	obj.CMD = mx.CMD_GAMEINPUTEDITOK;
	obj.idx = mx.gameinfo.IDX;

	obj.ADID = $("#ad_id").val();
	obj.ADPWD = $("#ad_pwd").val();
	obj.ADTITLE = $("#ad_title").val();

	if (obj.ADID == "" || obj.ADPWD == "" || obj.ADTITLE == "" ){
		mx.splashmsg('입력해 주세요.',1500);
		return;				
	}


	mx.SendPacket('titlelist_'+obj.idx, obj);
};

////////////////////////////////////////
//삭제
////////////////////////////////////////
mx.del_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTDEL;

	if (mx.gameinfo	 == '' || mx.gameinfo	 == null ||  $("#hostname").val() == '' ){
		mx.splashmsg('대상을 선택해 주십시오.',1500);
		return;
	}

	obj.IDX = mx.gameinfo.IDX;
	mx.SendPacket('titlelist_'+obj.IDX, obj);
};

mx.gameinfo = '';
$(document).ready(function(){
		localStorage.removeItem('MOREINFO');
		mx.init();
}); 

mx.init = function(){
	//$("#playerTable").tablesorter();
};