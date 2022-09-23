
var mx =  mx || {};

////////////////////////////////////////
	mx.CMD_VACCRESET = 422; //계좌정리
	mx.CMD_SETP = 455; //포인트 설정
	
	//========================
	mx.CMD_DATAGUBUN = 10000;
	//========================

	mx.CMD_WRITE = 50001; //등록
	mx.CMD_EDIT = 50002; //내용불러오기
	mx.CMD_EDITOK = 50003; //수정
	mx.CMD_DEL = 50004; //삭제
	mx.CMD_SETPOINT = 50006; //포인트창
////////////////////////////////////////


mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqKind.asp";
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
	case mx.CMD_SETPOINT:	this.OndrowPointModal( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_SETP:	this.OnP( reqcmd, jsondata, htmldata, sender );		break;
	}
};

//요청##################################################################
	mx.input_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_WRITE;
		obj.PARR = [$("#mk_g0").val(),$("#mk_g1").val(),$("#mk_g2").val(),$("#mk_g3").val(),$("#mk_g4").val(),$("#mk_g5").val()]; //년도, 개인(단체), 종목,마종, class, class안내
		var msgarr = ["사용년도를 입력해 ","개인/단체중에 선택해 ","종목명을 선택해 ", "마종을 선택해 ", "Class를 입력해 ","Class 안내를 입력해 "]; //메시지
		var passarrno = [0,1,1,1,1,1]; //체크 페스 플레그 0패스 1체크

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
		obj.PARR = [$("#e_idx").val(), $("#mk_g0").val(),$("#mk_g1").val(),$("#mk_g2").val(),$("#mk_g3").val(),$("#mk_g4").val(),$("#mk_g5").val()]; //년도, 개인(단체), 종목,마종, class, class안내
		var msgarr = ["대상을 선택해 ","사용년도를 입력해 ","개인/단체중에 선택해 ","종목명을 선택해 ", "마종을 선택해 ", "Class를 입력해 ","Class 안내를 입력해 "]; //메시지
		var passarrno = [1,0,1,1,1,1,1]; //체크 페스 플레그 0패스 1체크

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

	//포인트 창열기
	mx.setPoint = function(idx){
		var obj = {};
		obj.CMD = mx.CMD_SETPOINT;
		obj.IDX = idx;
		mx.SendPacket('ptmodalcontents', obj);
	};
	//각 포인트 설정하기
	mx.setP = function(inputobj, idx, arrkey){
		px.setZero(inputobj); //0일때 바로쓸수 있도록 value 초기화 
		var obj = {};
		obj.CMD = mx.CMD_SETP;
		obj.IDX = idx;
		obj.ARRKEY = arrkey;
		obj.INVAL = inputobj.value;
		console.log(obj);
		//$('#'+inputobj.id).css('background','orange');
		mx.SendPacket(inputobj, obj);		
	};
//응답##################################################################
	mx.OnP = function(cmd, packet, html, sender){
		$('#'+sender.id).css('background','orange');	
	};

	mx.OndrowHTML =  function(cmd, packet, html, sender){
		document.getElementById(sender).innerHTML = html;
	};


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

	// 10.22 update :: wyn
	mx.OndrowPointModal = function(cmd, packet, html, sender) {
		document.getElementById(sender).innerHTML = html;
		$('#pointInputModal').modal('show');

	};

//	$(document).ready(function(){
//		// 포인트 모달창 띄우기
//		$('.btnpoint').click(function(e){
//			var btnId = $(this)[0].id;
//			
//			if (btnId == 'p_majang') {
//				$('#c_pointMajang').css('display', 'inline-block');
//				$('#c_pointObatacle').css('display', 'none');
//			}
//			else {
//				$('#c_pointMajang').css('display', 'none');
//				$('#c_pointObatacle').css('display', 'inline-block');
//			}
//		});
//
//		// 마장마술 포인트 득점 입력 제한
//		$('#k_gamescore').keyup(function(e){
//			var kInpScore = $(this).val();
//
//			if (kInpScore > 450) {
//				alert('450점 이상은 입력할 수 없습니다.');
//				$(this).val('');
//			}
//		});
//
//		// 장애물 순위 입력 제한
//		$('#k_gamerank').keyup(function(e){
//			var kInpRank = $(this).val();
//
//			if (kInpRank > 10) {
//				alert('10위 이상은 입력할 수 없습니다.');
//				$(this).val('');
//			} else if (kInpRank == 0) {
//				alert('0은 입력할 수 없습니다.');
//				$(this).val('');
//			}
//		});
//	});