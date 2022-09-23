var px =  px || {};

px.go = function(packet,gourl){
//	if($('form[name="ssfrom"]').length == 0) {
//		document.body.innerHTML = "<form method='post' name='sform'><input type='hidden' name='p'></form>";
//	}

	document.ssform.p.value =   JSON.stringify( packet  );
	document.ssform.action = gourl;
	document.ssform.submit();
};

px.goSearch = function(packet, pageno,f1,f2){
	packet.F1 = f1;
	packet.F2 = f2;
	packet.PN = pageno;
	var gourl = location.href;
	//if($('form[name="ssfrom"]').length == 0) {
		//document.body.innerHTML = "<form method='post' name='ssform'><input type='hidden' name='p'></form>";
	//}


	document.ssform.p.value =   JSON.stringify( packet  );
	document.ssform.action = gourl;
	document.ssform.submit();
};


px.goPN = function(packet,pageno){
	packet.PN = pageno;
	var gourl = location.href;
//	if($('form[name="ssfrom"]').length == 0) {
//		document.body.innerHTML = "<form method='post' name='ssform'><input type='hidden' name='p'></form>";
//	}
	document.ssform.p.value = JSON.stringify(packet);
	document.ssform.action = gourl;
	document.ssform.submit();
};


$(document).ready(function() {
//  head_cart_count_view();
//    //상품검색 엔터키 이벤트
//  $("#search_key").keypress(function (e) {
//    if (e.which == 13){
//      if ($("#search_key").val()=="")
//        {
//          alert("검색어를 입력해 주세요");
//          $("#search_key").focus();
//          return false;
//        }
//      chk_search_keybord();  // 실행할 이벤트
//    }
//  });
});


/////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
var sda =  sda || {};

////////////////////////////////////////
    // Data 구분자 - ( html + json data ) 유무 
    sda.CMD_DATAGUBUN = 10000;
////////////////////////////////////////    


////////////////////////////////////////
    // 기존 Command
    sda.CMD_ADMINSALE = 200;
    sda.CMD_VIEWNO = 201;
    sda.CMD_SHOWSTATE = 203;
    sda.CMD_SALEDATE = 204;

    sda.CMD_ENDST = 210;
    sda.CMD_PRESSST = 211;

    // 쿠폰 등록 Command    
    sda.CMD_COUPON_WRITE        = 40001; //등록
    sda.CMD_COUPON_SELCHANGE    = 40002; //리스트 선택 
    sda.CMD_COUPON_MODIFY       = 40003; //수정완료
    sda.CMD_COUPON_DEL          = 40004; //삭제
////////////////////////////////////////

sda.ajaxurl = "/pub/ajax/RookieTennis/reqAdmin.asp";
sda.ajaxtype = "POST";
sda.dataType = "text";

sda.Send = function( sender, packet){
	console.log(JSON.stringify( packet  ) );
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	$.ajax({url:sda.ajaxurl,type:sda.ajaxtype,data:strdata,dataType:sda.dataType,
	success: function(returnData){
		//console.log(returnData);
		sda.Receive( packet.CMD, returnData, sender )
		}
	});
};

sda.SendEx = function( sender, packet, urlAjax){
	console.log(JSON.stringify( packet  ) );
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	$.ajax({url:urlAjax,type:sda.ajaxtype,data:strdata,dataType:sda.dataType,
	success: function(returnData){
		//console.log(returnData);
		sda.Receive( packet.CMD, returnData, sender )
		}
	});
};

sda.Receive = function( reqcmd, data, sender ){
	//console.log(data);
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  if ( Number(reqcmd) > sda.CMD_DATAGUBUN  ){
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
        case sda.CMD_VIEWNO:
        case sda.CMD_ADMINSALE: this.OnChangeEnd( reqcmd, jsondata, htmldata, sender );		break;

        case sda.CMD_ENDST:
        case sda.CMD_PRESSST:
        case sda.CMD_SHOWSTATE: this.OnToggleEnd( reqcmd, jsondata, htmldata, sender );		break;
        case sda.CMD_SALEDATE: this.OnStateToggleEnd( reqcmd, jsondata, htmldata, sender );		break;

        // =========== coupon command ============
        case sda.CMD_COUPON_WRITE:
        case sda.CMD_COUPON_SELCHANGE:
        case sda.CMD_COUPON_MODIFY:
        case sda.CMD_COUPON_DEL:  this.ReceiveCoupon(reqcmd, jsondata, htmldata, sender ); break; 
        // =========== coupon command ============
    }    
};


///////////////////////////
//요청					      //
///////////////////////////
sda.adm_sale = function(sender,seq,svalue) {	//운영자 판매수량 + 
    var obj = {};
    obj.CMD = sda.CMD_ADMINSALE;
    obj.SEQ = seq;
    obj.SVAL = svalue;
    sda.Send(sender,obj);
};

sda.setViewNo = function(sender,seq,svalue) {	//소팅순서
    var obj = {};
    obj.CMD = sda.CMD_VIEWNO;
    obj.SEQ = seq;
    obj.SVAL = svalue;
    sda.Send(sender,obj);
};

sda.setShowState = function(sender,seq,svalue) {	//전시여부
//		console.log($('#'+sender.id).attr('class'));
    var obj = {};
    obj.CMD = sda.CMD_SHOWSTATE;
    obj.SEQ = seq;
    obj.SVAL = svalue;
    sda.Send(sender,obj);
};

sda.setEndState = function(sender,seq,svalue) {	//마감임박
    var obj = {};
    obj.CMD = sda.CMD_ENDST;
    obj.SEQ = seq;
    obj.SVAL = svalue;
    sda.Send(sender,obj);
};

sda.setPressState = function(sender,seq,svalue) {	//긴급물량확보
    var obj = {};
    obj.CMD = sda.CMD_PRESSST;
    obj.SEQ = seq;
    obj.SVAL = svalue;
    sda.Send(sender,obj);
};

sda.setSaleDate = function(sender,seq,svalue) {	//기간만료 또는 진행여부 토글
    var obj = {};
    obj.CMD = sda.CMD_SALEDATE;
    obj.SEQ = seq;
    obj.SVAL = svalue;
    sda.Send(sender,obj);
};


///////////////////////////
//응답					      //
///////////////////////////
sda.OnChangeEnd =  function(cmd, packet, html, sender){
	var colorCode = "#" + Math.round(Math.random() * 0xffffff).toString(16);
	$('#' + sender.id).css('border-color', colorCode);
};

sda.OnToggleEnd =  function(cmd, packet, html, sender){
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

sda.OnStateToggleEnd =  function(cmd, packet, html, sender){
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



//////////////////////////////////////////////
sda.goPN = function(packet,pageno){
	packet.PN = pageno;
	var gourl = location.href;
//	if($('form[name="ssfrom"]').length == 0) {
//		document.body.innerHTML = "<form method='post' name='ssform'><input type='hidden' name='p'></form>";
//	}
	document.ssform.p.value =   JSON.stringify( packet  );
	document.ssform.action = gourl;
	document.ssform.submit();
};