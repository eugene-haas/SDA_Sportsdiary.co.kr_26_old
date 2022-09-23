var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_GETGAMELIST = 11000;

  mx.CMD_GETGAMENOLIST = 510;		//경기정보
  mx.CMD_GAMEMEMBER = 520;			//참가자리스트
  mx.CMD_SAVERECORD = 530;			//기록 저장하기

////////////////////////////////////////


mx.ajaxurl = "/pub/SWAPI/REQ.asp";
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

mx.IsJsonString = function(str) {
	try {
		var json = JSON.parse(str);
	return (typeof json === 'object');
	} catch (e) {
		return false;
	}
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
      if (mx.IsJsonString(data)){
			jsondata = JSON.parse(data);
      }
	  else{
	      htmldata = data;
	  }
    }
  }
  else{
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( mx.IsJsonString(data) ){
    switch (Number(jsondata.result))  {
    case 0: break;
    case 1: alert('데이터가 존재하지 않습니다.');return;  break;
    case 2: alert('동일한 데이터가 존재합니다.');return;  break;
    case 3: alert('참가신청 자가 있어 수정및 삭제가 불가능 합니다.');return;  break;
    case 4: alert('대회에 생성된 부서가 있어 복사할수 없습니다.');return;  break;
    case 5: alert('이미 등록된 날짜 입니다.');return;  break;
    case 6: alert('이미 등록된 경기입니다.');return;  break;
    case 7: alert('이미 등록된 경기입니다.');return;  break;
    case 8: alert('대진표 편성이 완료 되지 않았습니다.');return;  break;

    case 500: alert('결승 경기에 진행된 값이 있어 초기화 하고 다시 설정할 수 없습니다.');return;  break;

    case 100: return;   break; //메시지 없슴
	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}
	return;   break;

	}
  }

  switch (Number(reqcmd)) {
	case mx.CMD_SETAPPYN:
	case mx.CMD_SETRCOK : return; break;
	case mx.CMD_RNDUP : this.OnLoadList( reqcmd, jsondata, htmldata, sender ); break; //alert("본선진출이 설정되었습니다.");
	
	case mx.CMD_OUTODR:
	case mx.CMD_INPUTODR: this.orderList(jsondata.RIDX); break;

	case mx.CMD_ORDERLIST: //this.orderList(jsondata.RIDX); break;
	case mx.CMD_GETGAMELIST: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );	break;
	case mx.CMD_SETOUT :
	case mx.CMD_SETRC:
	case mx.CMD_CHANGERANE:	this.OnLoadList( reqcmd, jsondata, htmldata, sender );  break; 

	case   mx.CMD_GETGAMENOLIST :
	case mx.CMD_SAVERECORD :
	case mx.CMD_GAMEMEMBER : 	this.OnLog( reqcmd, jsondata, htmldata, sender );  break; 
  }
};


//요청##################################################################

//	mx.CMD_GETGAMENOLIST =  510; //대회번호_대회조수
//  mx.CMD_GAMEMEMBER = 520;	//참가자리스트
//  mx.CMD_SAVERECORD = 530;	//기록 저장하기
	mx.getGameNoList = function(tidx, gamedate,ampm){
		var obj = {};
		obj.CMD = mx.CMD_GETGAMENOLIST;
		obj.TIDX = tidx;
		obj.GAMEDATE = gamedate;
		obj.AMPM = ampm;
		
		//요청 json 값 출력
   		$('#reqjson').html(JSON.stringify( obj  ));
		console.log(  obj  ); //요청
		mx.SendPacket('modalB', obj);
	};
	
	
	mx.getINFO = function(tidx, gameno,joono){
		var obj = {};
		obj.CMD = mx.CMD_GAMEMEMBER;
		obj.TIDX = tidx;
		obj.GAMENO = gameno;
		obj.JOONO = joono;
		
		//요청 json 값 출력
   		$('#reqjson').html(JSON.stringify( obj  ));
		console.log(  obj  ); //요청

		mx.SendPacket('modalB', obj);
	};

	mx.setResult = function(){
		var obj = {};
		var arrobj = {};
		obj.LIST = [];
		obj.CMD = mx.CMD_SAVERECORD;

		if (mx.selectPacket == undefined)
		{
			alert("출전선수 조회후 클릭해주세요");
			return;
		}
		else{
			for (var i = 0 ;i < mx.selectPacket.LIST.length ;i++ )
			{
				arrobj = {};
				arrobj.MIDX = mx.selectPacket.LIST[i].MIDX;
				arrobj.JOO = mx.selectPacket.LIST[i].JOO;
				arrobj.RANE = mx.selectPacket.LIST[i].RANE;
				arrobj.ODRNO = mx.selectPacket.LIST[i].ODRNO;
				arrobj.GAMERESULT = '003399';   //각각의 기록 또는 오류 코드
				obj.LIST[i] = arrobj;
			}
	   		$('#reqjson').html(JSON.stringify( obj  ));
			console.log(   obj ); //요청
			mx.SendPacket('modalB', obj);
		}
	};


	mx.selectPacket;
	mx.OnLog =  function(cmd, packet, html, sender){
		mx.selectPacket = packet;
		$('#resjson').html(JSON.stringify( packet  ));
	    console.log(  packet  );
	};