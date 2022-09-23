var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;
  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_GAMEINPUT = 301;
  mx.CMD_GAMEINPUTEDIT = 30002;
  mx.CMD_GAMEINPUTEDITOK = 303;
  mx.CMD_GAMEINPUTDEL = 304;

////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqGameCode.asp";
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

mx.ReceivePacket = function( reqcmd, data, sender ){// data는 response string

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
    switch (Number(jsondata.result))  {
    case 0: break;
    case 1: alert('데이터가 존재하지 않습니다.');return;  break;
    case 2: alert('동일한 데이터가 존재합니다.');return;  break;
    case 3: alert('참가신청 자가 있어 수정및 삭제가 불가능 합니다.');return;  break;
    case 100: return;   break; //메시지 없슴
	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}
	return;   break;

	}
  }

  switch (Number(reqcmd)) {

	case mx.CMD_GAMEINPUTDEL:
	case mx.CMD_GAMEINPUTEDITOK:
	case mx.CMD_GAMEINPUT:	window.location.reload();	break;
	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
  }
};


//요청##################################################################

	mx.input_frm = function(lastno){

		if($('#e_idx').val() ==  undefined ){
			//등록
		}
		else{
			alert("수정모드입니다.");
			return;
		}

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUT;
		//종목 개인[단체] 성별 부서 세부종목
		obj.PARR = new Array();

		var allidarr = [];
		for (var x = 0;x < lastno ;x++ ){
			allidarr[x] = "mk_g" + x;
		}

		var chkboxidarr = []; //체크박스의 아이디들
		var typechkbox = false;

		for (var i = 0;i< allidarr.length ;i++ ){
			typechkbox = false;
			for (var n = 0;n< chkboxidarr.length ;n++ ){
				if (allidarr[i] ==chkboxidarr[n]){ //체크박스라면
					typechkbox = true;
				}
			}

			if (typechkbox == true){
				if (  $("#"+allidarr[i]).is(":checked")  ){
					obj.PARR[i] = $("#"+allidarr[i]).val();
				}
				else{
					obj.PARR[i] = '';
				}
			}
			else{
				obj.PARR[i] = $("#"+allidarr[i]).val();
			}

		}

		var msgarr = [];
		for (var x = 0;x < lastno ;x++ ){
			msgarr[x] = x+ "입력해 ";
		}

		var passarrno = []; //체크메시지 통과여부 플레그 0패스 1체크
		for (var x = 0;x < lastno ;x++ ){
			passarrno[x] = 1;
		}

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					return;
				}
			}
		}

		var cdc  = $('#mk_g1 option:selected').text(); //cdc 필요해서 추가 21.6.7
		obj.PARR.push(cdc);
		//console.log(cdc);
		//return;


		mx.SendPacket(null, obj);
	};



	mx.input_select = function(idx){
		$( "#contest tr").css( "background-color", "white" );
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" );
	};



	mx.input_edit = function(idx){
		$( "#contest tr").css( "background-color", "white" );
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" );

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDIT;
		obj.IDX = idx;
		mx.SendPacket('gameinput_area', obj);
	};



	mx.update_frm = function(lastno){
		if($('#e_idx').val() ==  undefined ){
			alert("목록에서 대상을 선택해 주세요.");
			return;
		}

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDITOK;
		//종목 개인[단체] 성별 부서 세부종목
		obj.PARR = new Array();

		var allidarr = [];
		for (var x = 0;x < lastno ;x++ ){
			allidarr[x] = "mk_g" + x;
		}
	
		allidarr[x] = "e_idx";

		var chkboxidarr = []; //체크박스의 아이디들
		var typechkbox = false;

		for (var i = 0;i< allidarr.length ;i++ ){
			obj.PARR[i] = $("#"+allidarr[i]).val();
		}

		var msgarr = [];
		for (var x = 0;x < lastno ;x++ ){
			msgarr[x] = "내용을 입력해 ";
		}

		var passarrno = []; //체크메시지 통과여부 플레그 0패스 1체크
		for (var x = 0;x < lastno ;x++ ){
			passarrno[x] = 1;
		}

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					return;
				}
			}
		}

		var cdc  = $('#mk_g1 option:selected').text();
		obj.PARR.push(cdc);

		mx.SendPacket(null, obj);
	};


	mx.del_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDEL;
		obj.IDX =	$("#e_idx").val();

		if (obj.IDX == undefined){
			alert("목록에서 대상을 선택해 주세요.");
			return;
		}

		if (confirm('대상을 삭제하시겠습니까?')) {
			mx.SendPacket('titlelist_'+obj.IDX, obj);
		} else {
			return;
		}
	};



//응답##################################################################



mx.OndrowHTML =  function(cmd, packet, html, sender){

	if(cmd == mx.CMD_TEAMFIND ){

		if( $('#modalB').length == 0 ){
			$('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
		}
		document.getElementById("modalB").innerHTML = html;
		$('#modalB').modal('show');
		$('#findteamstr').focus();


	}
	else{
	
		document.getElementById(sender).innerHTML = html;
		//if (cmd == mx.CMD_GAMEINPUTEDIT ){
		//	mx.init();
		//}

	}



};

$(document).ready(function(){
		//mx.init();
});


////////////////////////////////////////////////////////////////
