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


px.goPN = function(packet,pageno){
	packet.PN = pageno;
	var gourl = location.href;
	document.ssform.p.value = JSON.stringify(packet);
	document.ssform.action = gourl;
	document.ssform.submit();
};

$(document).ready(function() {
});


/////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
var tm =  tm || {};

////////////////////////////////////////
    // Data 구분자 - ( html + json data ) 유무 
    tm.CMD_DATAGUBUN = 10000;

////////////////////////////////////////
    // 검색
    tm.CMD_SEARCHRC        = 10001; //검색
	tm.CMD_SEARCHPLAYER  = 10002; //선수검색
	tm.CMD_PLAYERINFO		  = 10003; //상세정보
////////////////////////////////////////

tm.ajaxurl = "/pub/ajax/mobile/reqRecord.asp";
tm.ajaxtype = "POST";
tm.dataType = "text";

tm.Send = function( sender, packet){
	console.log(JSON.stringify( packet  ) );
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	$.ajax({url:tm.ajaxurl,type:tm.ajaxtype,data:strdata,dataType:tm.dataType,
	success: function(returnData){
		//console.log(returnData);
		tm.Receive( packet.CMD, returnData, sender )
		}
	});
};

tm.SendEx = function( sender, packet, urlAjax){
	console.log(JSON.stringify( packet  ) );
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	$.ajax({url:urlAjax,type:tm.ajaxtype,data:strdata,dataType:tm.dataType,
	success: function(returnData){
		//console.log(returnData);
		tm.Receive( packet.CMD, returnData, sender )
		}
	});
};

tm.Receive = function( reqcmd, data, sender ){
	//console.log(data);
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  if ( Number(reqcmd) > tm.CMD_DATAGUBUN  ){
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
		switch (Number(jsondata.result)){
            case 0: break;
            case 1: alert('데이터가 존재하지 않습니다.');return;  break;
            case 100: return;   break; //메시지 없슴
		}
  }

    switch (Number(reqcmd)) {
        case tm.CMD_SEARCHPLAYER:
		case tm.CMD_PLAYERINFO:
		case tm.CMD_SEARCHRC: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
    }    
};


///////////////////////////
//요청					      //
///////////////////////////
tm.searchRecord = function(sender,yy,gb,pidx) {	//기간만료 또는 진행여부 토글
    var obj = {};
    obj.CMD = tm.CMD_SEARCHRC;
	if (yy =='')	obj.YY = $(":input:radio[name=search_age]:checked").val();
	else obj.YY = yy;

	if (gb =='')	obj.GB = $(":input:radio[name=search_div_sd]:checked").val();
	else obj.GB = gb;
	obj.F1 = pidx;
    tm.Send(sender,obj);
};

tm.searchPlayer = function(sender,yy,gb) {	//기간만료 또는 진행여부 토글
    var obj = {};
    obj.CMD = tm.CMD_SEARCHPLAYER;
	obj.F1 = $('#SF1').val();
    if( obj.F1.length >= 1 ){
		tm.Send(sender,obj);
	}
};

tm.openDetail = function(sender,pidx,teamgb,yy){
    var obj = {};
    obj.CMD = tm.CMD_PLAYERINFO;
	obj.F1 = pidx;
	obj.GB = teamgb;
	obj.YY = yy;
	tm.Send(sender,obj);
};

///////////////////////////
//응답					      //
///////////////////////////
tm.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if (cmd == tm.CMD_PLAYERINFO)
	{
		detail_layer.open();
	}
};
