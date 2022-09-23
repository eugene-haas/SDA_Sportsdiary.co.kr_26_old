var mx =  mx || {};
////////////////////////////////////////
mx.CMD_DATAGUBUN = 10000;



mx.CMD_GAMEINPUT = 301;
mx.CMD_GAMEINPUTTEAM = 302;

mx.CMD_GAMEINPUTEDIT = 30002;
mx.CMD_GAMEINPUTEDITOK = 303;
mx.CMD_GAMEINPUTDEL = 304;


mx.CMD_GAMEINPUTTEST = 305;
mx.CMD_PLAYERLIST = 12000; //계영 신청 선수
mx.CMD_MEMBERIN = 400;
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqContestPlayer.asp";
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
    case 2: alert('현재 종목에 참여해 있습니다.');return;  break;
    case 3: alert('팀참가자가 이미 2명 있습니다.');return;  break;
    case 4: alert('참가한 종목수가 초과하였습니다.');return;  break;
    case 100: return;   break; //메시지 없슴
	}
  }

  switch (Number(reqcmd)) {
	case mx.CMD_PLAYERLIST:
	case mx.CMD_FINDBOODETAIL:  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;

	case mx.CMD_MEMBERIN :mx.playerList(jsondata.RIDX); break;


	case mx.CMD_GAMEINPUTTEAM :
	case mx.CMD_GAMEINPUTTEST:
	case mx.CMD_GAMEINPUTDEL:
	case mx.CMD_GAMEINPUTEDITOK: 
	case mx.CMD_GAMEINPUT:	window.location.reload();	break;
  }
};


//요청##################################################################
	mx.newMemberIn = function(){ //계셩 선수추가
		var obj = {};
		obj.CMD = mx.CMD_MEMBERIN;
		obj.RIDX = $('#newrequestidx').val();
		obj.PIDX = $('#newpidx').val();
		mx.SendPacket('modalB', obj);		
	};

	
	mx.playerList = function(ridx){
		var obj = {};
		obj.CMD = mx.CMD_PLAYERLIST;
		obj.RIDX = ridx;
		mx.SendPacket('modalB', obj);
	};

	
	mx.input_fromTest = function(lidx){
		var obj={};
		obj.CMD = 	mx.CMD_GAMEINPUTTEST;
		obj.LIDX = lidx;
		mx.SendPacket(null, obj);
	}
	
	
	mx.input_frm = function(lastno){

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
			msgarr[x] = "";
		}

		var passarrno = [0,0,0,0]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					return;
				}
			}
		}
		mx.SendPacket(null, obj);
	};

	mx.inputTeam_frm = function(lastno){

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTTEAM;
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
			msgarr[x] = "";
		}

		var passarrno = [0,0,0,0]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					return;
				}
			}
		}
		mx.SendPacket(null, obj);
	};






	mx.input_edit = function(idx){
		$( "#contest tr").css( "background-color", "white" );
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" );
	};

	mx.del_frm = function(idx){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDEL;
		obj.IDX = idx;



		if (confirm('대상을 삭제하시겠습니까?')) {
			mx.SendPacket('titlelist_'+obj.IDX, obj);
		} else {
			return;
		}
	};




//응답##################################################################

mx.OndrowHTML =  function(cmd, packet, html, sender){
	if(cmd == mx.CMD_PLAYERLIST ){
		if( $('#modalB').length == 0 ){
			$('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
		}
		document.getElementById("modalB").innerHTML = html;
		$('#modalB').modal('show');		
	}
	else{
		document.getElementById(sender).innerHTML = html;
	}
};


