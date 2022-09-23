var bm=  bm|| {};
////////////////////////////////////////
	bm.CMD_DATAGUBUN = 10000;
	bm.CMD_SETSCORE = 20000;
	bm.CMD_EDITRESULT = 21000;

////////////////////////////////////////

bm.IsHttpSuccess = function( r ){
	try{
		return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
	}
	catch(e){}
	return false;
};

bm.HttpData = function( r, type ){
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

bm.ajaxurl = "/pub/ajax/reqBM.asp"; 
bm.SendPacket = function( sender, packet){

	console.log(packet);
	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = bm.ajaxurl;
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( bm.IsHttpSuccess( xhr ) ){
				bm.ReceivePacket( reqcmd, bm.HttpData( xhr, datatype ), sender );
				return true;
			}
			xhr = null;
		}
	};
	console.log(JSON.stringify( packet  ) );
	xhr.send( strdata );
};

bm.ReceivePacket = function( reqcmd, data, sender ){// data는 response string
	var rsp = null;
	var callback = null;
	var jsondata = null;
	var htmldata = null;
	var resdata = null;

	
	if ( Number(reqcmd) > bm.CMD_DATAGUBUN  ){
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
	case 	bm.CMD_SETSCORE: this.OnScore( reqcmd, jsondata, htmldata, sender );		break;
	case 	bm.CMD_EDITRESULT: alert('세트종료가 완료되었습니다.');		break;
	
	}
};


bm.SetScore = function(scid , obj) {
	  obj.CMD = bm.CMD_SETSCORE;
	  bm.SendPacket(scid, obj);  
};

bm.EditResult = function(scid , obj) {

	var chkconfirm = confirm( obj.SetNum + "세트를 종료합니다. 동의 하시면 확인버튼을 눌러주세요.");

	if(chkconfirm == false){
		return;
	}


	obj.CMD = bm.CMD_EDITRESULT;
	bm.SendPacket(scid, obj);  
};



//drow///////////////
bm.OnScore =  function(cmd, packet, html, sender){

	//document.getElementById("scoreboard").innerHTML = html;
	document.body.innerHTML = html;
};
//drow///////////////


















