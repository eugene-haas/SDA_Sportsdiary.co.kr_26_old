var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
	mx.CMD_GAMEINPUT = 30001;
	mx.CMD_GAMEINPUTEDIT = 30002; //수정
	mx.CMD_GAMEINPUTEDITOK = 30003;
	mx.CMD_GAMEINPUTDEL = 30004;// 삭제
	mx.CMD_GAMEAUTO = 30007;

	mx.CMD_INSERTDATA = 30008;
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
		case 2: alert('동일한 내용이 존재 합니다.');return; 	break;
		case 3:	alert('등록되지 않은 데이터가 존재합니다.');return; 	break;
		case 10: alert('중복된 데이터가 있습니다.');return;  break;
		case 88: alert('sitecode가 없습니다.  cfg.pub.asp 설정');return;  break;
		case 99: alert('정보가 일치하지 않습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
		}
  }

	switch (Number(reqcmd))	{
	case mx.CMD_GAMEAUTO:
	case mx.CMD_GAMEINPUT:	this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_CONTESTAPPEND:	this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_INSERTDATA:
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
	document.getElementById("gamehost").innerHTML = html;
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
		var re = /\r\n/g;    //개행문자를 나타내는 정규표현식
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUT;
		obj.PARR = [$("#mk_g0").val(),$("#mk_g1").val(),$("#mk_g2").val(),$("#mk_g3").val()]; 
		var msgarr = ["제목 입력해 ","대상을 입력해 ","대상필드를 입력해 ", "입력데이터를 입력해 "];
		var passarrno = [1,1,1,1]; //체크 페스 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		mx.SendPacket(null, obj);
	};

	mx.input_frmSubmit = function(){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUT;
		obj.PARR = [$("#mk_g0").val(),$("#mk_g1").val(),$("#mk_g2").val(),$("#mk_g3").val()]; 
		var msgarr = ["제목 입력해 ","대상을 입력해 ","대상필드를 입력해 ", "입력데이터를 입력해 "];
		var passarrno = [1,1,1,1]; //체크 페스 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}

		document.ssform.p.value =   JSON.stringify( obj  );
		document.ssform.action = mx.ajaxurl;
		document.ssform.submit();

	};


	mx.insertData = function(idx){
		var obj = {};
		obj.CMD = mx.CMD_INSERTDATA;
		obj.IDX = idx;
		mx.SendPacket('titlelist_'+idx, obj);
	};





////////////////////////////////////////
//수정
////////////////////////////////////////
mx.input_edit = function(idx){
	$( "#contest tr").css( "background-color", "white" ); 
	$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" ); 

	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTEDIT;
	obj.IDX = idx;
	mx.SendPacket('gamehost', obj);
};

mx.update_frm = function(){
	var obj = {};

	obj.CMD = mx.CMD_GAMEINPUTEDITOK;
	obj.IDX =	$("#e_idx").val();

	if (obj.IDX == undefined){
		alert("대상을 선택해 주세요.");
		return;
	}
	
	if ($("#hostname").val() == '' ){
		alert('명칭을 입력해 주십시오.');
		return;
	}
	obj.idx = mx.gameinfo.IDX;
	obj.hostname = $("#hostname").val();
	mx.SendPacket('titlelist_'+obj.idx, obj);
};

////////////////////////////////////////
//삭제
////////////////////////////////////////
mx.del_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTDEL;
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

mx.gameinfo = '';
$(document).ready(function(){
		localStorage.removeItem('MOREINFO');
		mx.init();
}); 

mx.init = function(){
	//$("#playerTable").tablesorter();
};