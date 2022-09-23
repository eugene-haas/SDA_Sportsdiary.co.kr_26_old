function decodeUTF8(str){return decodeURIComponent(str);}
function encodeUTF8(str){return encodeURIComponent(str);}

var mx =  mx || {};

mx.CMD_DATAGUBUN = 10000;
////////////////////////////////////////
var gameImages = new Array();

mx.pushImage = function (rownum, idx, filename, readnum, thumbnail) {
  var gameImage = {};
  gameImage.rownum = rownum;
  gameImage.idx = idx;
  gameImage.filename = filename;
  gameImage.readnum = readnum;
  gameImage.thumbnail = thumbnail;
  gameImages.push(gameImage);
  localStorage.setItem('gameImages', JSON.stringify(gameImages));
}

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

mx.ajaxurl = "/pub/ajax/bike/reqBBS.asp";
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
	setTimeout( function(){ reqdone = true; }, timeout );

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
		htmldata = data;
	}
	else{
		if(typeof data == 'string'){jsondata = JSON.parse(data);}
		else{jsondata = data;}
	}

	if( jsondata !='' && jsondata != null){
		switch (Number(jsondata.result))	{
		case 0:	break;
		case 1:	alert('데이터가 존재하지 않습니다.');return; 	break;
		case 100:	return; 	break; //메시지 없슴
		}
	}
};


mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
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
