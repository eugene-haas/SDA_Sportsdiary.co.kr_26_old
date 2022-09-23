var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_DATAGUBUN = 10000;
	mx.CMD_MAKEGAME = 55555;
////////////////////////////////////////

mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','ming') + "/reqDataInsert.asp";
mx.ajaxtype = "POST";
mx.dataType = "text";


mx.SendPacket = function( sender, packet){
    console.log( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	$.ajax({url:mx.ajaxurl,type:mx.ajaxtype,data:strdata,dataType:mx.dataType,
	success: function(returnData){
		mx.ReceivePacket( packet.CMD, returnData, sender )
		}
	});
};

mx.SendPacketEx = function(sender, packet, reqUrl){
    var strData = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );

    console.log( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
    $.ajax({
        url : reqUrl, 
        type : mx.ajaxType,
        data : strData, 
        dataType : mx.ajaxDataType, 
        success: function(rcvData) {
			mx.ReceivePacket(packet.CMD, rcvData, sender);
        }             
    });
};


mx.ReceivePacket = function( reqcmd, data, sender ){
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  if ( Number(reqcmd) > mx.CMD_DATAGUBUN  ){
    if ( data.indexOf("`##`") !== -1 ){//json + html
      resdata = data.split( "`##`" );
      jsondata =  resdata[0];
      if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
        htmldata = resdata[1];
    }
    else{ //html
      htmldata = data;
    }
  }
  else{//json
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( jsondata !='' && jsondata != null){
		//case 2:	mx.splashmsg('동일한 내용이 존재 합니다.',1500);return; 	break;
		switch (Number(jsondata.result)){
		case 0: break;
		case 1: alert('데이터가 존재하지 않습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
		}
  }

	switch (Number(reqcmd))	{
	case mx.CMD_MAKEGAME:	this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;
	}

};

mx.makeGame = function(lineno){
	var obj = {};
	obj.CMD = mx.CMD_MAKEGAME;
	obj.TIDX = $('#F1_1').val();
	obj.DIDX = $('#F1_2').val();
	obj.NO = lineno;
	mx.SendPacket('listcontents', obj);
};

mx.OnAppendHTML =  function(cmd, packet, html, sender){
	if ( packet.NO == "_end" ){return;}
//	$("#nowcnt").html(packet.NKEY);
//	packet.NKEY = Number(packet.NKEY) + 1;
//	localStorage.setItem('MOREINFO', JSON.stringify( packet  ));


	$('#'+sender).append(html);
	$("#sc_body").scrollTop($("#sc_body")[0].scrollHeight);
	//setTimeout(mx.SendPacket('listcontents', packet), 1000);	
	mx.SendPacket('listcontents', packet);
};


mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
};
