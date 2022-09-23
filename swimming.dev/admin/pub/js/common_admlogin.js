var px =  px || {};
px.go = function(packet,gourl){
	document.ssform.p.value =   JSON.stringify( packet  );
	document.ssform.action = gourl;
	document.ssform.submit();
};

px.goSearch = function(packet, pageno,f1,f2){
	packet.F1 = f1;
	packet.F2 = f2;
	packet.PN = pageno;
	var gourl = location.href;

	document.ssform.p.value =   JSON.stringify( packet  );
	document.ssform.action = gourl;
	document.ssform.submit();
};

$(document).ready(function() {

});


/////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
var plg =  plg || {};
plg.CMD_DATAGUBUN = 10000;
plg.CMD_LOGINCHK = 10;
plg.CMD_PHONENUM = 11;


plg.ajaxurl = "/pub/ajax/reqLogin.asp";
plg.ajaxtype = "POST";
plg.dataType = "text";

plg.Send = function( sender, packet){
	console.log(JSON.stringify( packet  ) );
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	$.ajax({url:plg.ajaxurl,type:plg.ajaxtype,data:strdata,dataType:plg.dataType,
	success: function(returnData){
		//console.log(returnData);
		plg.Receive( packet.CMD, returnData, sender )
		}
	});
};

plg.Receive = function( reqcmd, data, sender ){
  //console.log(data);
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  if ( Number(reqcmd) > plg.CMD_DATAGUBUN  ){
    if ( data.indexOf("`##`") !== -1 ){//json + html
      resdata = data.split( "`##`" );
      jsondata =  resdata[0];
      if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
        htmldata = resdata[1];
    }
    else{ //html
      htmldata = data;
      try{jsondata = JSON.parse(data); }
      catch(ex){return;}
    }
  }
  else{//json
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( jsondata !='' && jsondata != null){
		switch (Number(jsondata.result)){
		case 0: break;
		case 1: alert('데이터가 존재하지 않습니다.');return;  break;
		case 88: alert('sitecode가 없습니다.  cfg.pub.asp 설정');return;  break;
		case 99: alert('정보가 일치하지 않습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
		}
  }

  switch (Number(reqcmd)) {
	case plg.CMD_LOGINCHK: this.OnLoignOK( reqcmd, jsondata, htmldata, sender );		break;

	case plg.CMD_ENDST:
	case plg.CMD_PRESSST:
	case plg.CMD_SHOWSTATE: this.OnToggleEnd( reqcmd, jsondata, htmldata, sender );		break;
	case plg.CMD_SALEDATE: this.OnStateToggleEnd( reqcmd, jsondata, htmldata, sender );		break;
  }
};


///////////////////////////
//요청					      //
///////////////////////////
plg.setFocusColor = function(inputid){
	var colorCode = "#" + Math.round(Math.random() * 0xffffff).toString(16);
	if($('#'+inputid).val() == ''){
		$('#'+inputid).css('border-color', colorCode);
		$('#'+inputid).focus();
		setTimeout(function(){$('#txtID').css('border-color', '');},2000);
	}
};

plg.login = function(sender,gourl) {
		var colorCode = "#" + Math.round(Math.random() * 0xffffff).toString(16);
		var obj = {};
		obj.CMD = plg.CMD_LOGINCHK;
		obj.ID = $('#txtID').val();
		if(obj.ID == ''){
			plg.setFocusColor('txtID');
			return;
		}
		obj.PWD = $('#psAdmin').val();
		if(obj.PWD == ''){
			plg.setFocusColor('psAdmin');
			return;
		}
		obj.CODE = $('#txtCODE').val();
		if(obj.CODE == ''){
			plg.setFocusColor('txtCODE');
			return;
		}

		obj.CHK = $('#login-check-1').is(":checked");
		//alert(obj.CHK);

		obj.RETURNURL = gourl;
		plg.Send(sender,obj);
};

plg.logout = function(sender,uid,upwd,gourl) {
		var obj = {};
		obj.CMD = plg.CMD_LOGOUT;
		obj.ID = uid;
		obj.PWD = upwd;
		obj.RETURNURL = gourl;
		plg.Send(sender,obj);
};

///////////////////////////
//응답					      //
///////////////////////////
plg.OnLoignOK =  function(cmd, packet, html, sender){
	px.go(packet,packet.RETURNURL);
};

plg.OnToggleEnd =  function(cmd, packet, html, sender){
	var classnm = $('#'+sender).attr('class');
	if (classnm == "green-btn")
	{
		$('#'+sender).attr('class','gray-btn');
		$('#'+sender).html('N');
	}
	else{
		$('#'+sender).attr('class','green-btn');
		$('#'+sender).html('Y');
	}
};

plg.OnStateToggleEnd =  function(cmd, packet, html, sender){
	var classnm = $('#'+sender).attr('class');
	if (classnm == "blue-btn" || classnm == "gray-btn" )
	{
		$('#'+sender).attr('class','black-btn');
		$('#'+sender).html('종료');
		$('#sdate_'+packet.SEQ).val(packet.SDATE);
		$('#edate_'+packet.SEQ).val(packet.EDATE);
	}
	else{
		$('#'+sender).attr('class','blue-btn');
		$('#'+sender).html('진행');
		$('#sdate_'+packet.SEQ).val(packet.SDATE);
		$('#edate_'+packet.SEQ).val(packet.EDATE);
	}
};
