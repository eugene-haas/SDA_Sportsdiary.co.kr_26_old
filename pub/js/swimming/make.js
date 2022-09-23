
var mx =  mx || {};

////////////////////////////////////////
	mx.CMD_VACCRESET = 422; //계좌정리
	
	//========================
	mx.CMD_DATAGUBUN = 10000;
	//========================

	mx.CMD_WRITE = 50001; //등록
	mx.CMD_EDIT = 50002; //내용불러오기
	mx.CMD_EDITOK = 50003; //수정
	mx.CMD_DEL = 50004; //삭제
////////////////////////////////////////


mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','ming') + "/reqMake.asp";
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
		switch (Number(jsondata.result)){
		case 0: break;
		case 1: alert('데이터가 존재하지 않습니다.');return;  break;
		case 10: alert('중복된 데이터가 있습니다.');return;  break;
		case 88: alert('sitecode가 없습니다.  cfg.pub.asp 설정');return;  break;
		case 99: alert('정보가 일치하지 않습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
		}
  }

	switch (Number(reqcmd))	{
	case mx.CMD_WRITE:	this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_CONTESTAPPEND:	this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_EDITOK:
	case mx.CMD_EDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_DEL:	this.OndelHTML( reqcmd, jsondata, htmldata, sender );		break;
	}

};

//요청##################################################################
	mx.input_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_WRITE;
		obj.PARR = [$("#mk_g0").val(),$("#mk_g1").val(),$("#mk_g2").val()]; //년도, 종목,성립인원
		var msgarr = ["사용년도를 입력해 ","종목명을 선택해 ", "참가실제 명수를 입력해 "]; //메시지
		var passarrno = [0,1,1]; //체크 페스 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		mx.SendPacket(null, obj);
	};

	mx.input_edit = function(idx){
		$( "#contest tr").css( "background-color", "white" ); 
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" ); 
		
		var obj = {};
		obj.CMD = mx.CMD_EDIT;
		obj.IDX = idx;
		mx.SendPacket('gameinput_area', obj);
	};



	mx.update_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_EDITOK;
		obj.PARR = [$("#e_idx").val(), $("#mk_g0").val(),$("#mk_g1").val(),$("#mk_g2").val()]; //년도, 종목,성립인원
		var msgarr = ["대상을 선택해", "사용년도를 입력해 ","종목명을 선택해 ", "참가실제 명수를 입력해 "]; //메시지
		var passarrno = [1,0,1,1]; //체크 페스 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		mx.SendPacket('titlelist_'+obj.PARR[0], obj);
	};


	mx.del_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_DEL;
		obj.IDX =	$("#e_idx").val();

		if (obj.IDX == undefined){
			alert("대상을 선택해 주세요.");
			return;
		}

		if (confirm('대상을 삭제하시겠습니까?')) {
			mx.SendPacket('titlelist_'+obj.IDX, obj);
		} else {
			return;
		}	
	};

//응답##################################################################

	mx.OnBeforeHTML =  function(cmd, packet, html, sender){
		$('#fc').before(html);
	};

	mx.OndrowHTML =  function(cmd, packet, html, sender){
		document.getElementById(sender).innerHTML = html;
		//if( cmd = mx.CMD_GAMEINPUTEDITOK){
		//mx.init();
		//}
	};

	mx.OndelHTML =  function(cmd, packet, html, sender){
		document.getElementById("gameinput_area").innerHTML = html;
		$("#"+sender).remove();

	};

	mx.OnAppendHTML =  function(cmd, packet, html, sender){
		$('#'+sender).append(html);
		//$("body").scrollTop($("body")[0].scrollHeight);
	};
