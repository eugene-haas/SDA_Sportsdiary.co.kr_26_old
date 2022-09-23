var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_SETAMPM = 100;
  mx.CMD_INPUT = 200;
  mx.CMD_SETFLAG = 201;
  mx.CMD_GAMEINPUTDEL = 300;// 삭제

  mx.CMD_CHANGEODR = 310;

  mx.CMD_DELAMDATA = 320;
  mx.CMD_DELPMDATA = 340;

  mx.CMD_SETGAMENO = 350;
  mx.CMD_SETJOONO = 352;
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqGameOrder.asp";
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
    case 11: alert('예선없이 결승이 생성되어야 하는 경기입니다.');return;  break;
    case 12: alert('레인배정이 되지 않은 경기입니다.');return;  break;
    case 100: return;   break; //메시지 없슴
	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}
	return;   break;

	}
  }

  switch (Number(reqcmd)) {
	case mx.CMD_SETJOONO:
	case mx.CMD_SETGAMENO: return; break;

	case mx.CMD_CHANGEODR:
	case mx.CMD_SETFLAG:
	case mx.CMD_INPUT:
	case mx.CMD_GAMEINPUTDEL:

	case mx.CMD_DELAMDATA:
	case mx.CMD_DELPMDATA:
	case mx.CMD_SETAMPM:	window.location.reload();	break;

	case mx.CMD_GAMEEXLLIST:
	case mx.CMD_GAMEBESTLIST :
	case mx.CMD_GAMELISTSEARCH:
	case mx.CMD_GAMELIST: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GETBESTRC  : alert("기준 기록이 반영되었습니다.");window.location.reload(); break;
  }
};


//요청##################################################################
	//조수수정
	mx.setJoono = function(lidx, gameno, changetype){
//	  if (confirm("변경할 조의 수가 정확한가요. 수정하시겠습니까")) { 
		var obj = {};
		obj.CMD = mx.CMD_SETJOONO;
		obj.LIDX =lidx;
		obj.GNO = gameno;
		obj.CTYPE = changetype;
		mx.SendPacket(null, obj);	
//	  }
	};

	//gameno 수정
	mx.setGameno = function(lidx, gameno, changetype){
//	  if (confirm("중복된 게임번호를 사용하면 대회운영이 진행되지 않습니다. 수정하시겠습니까")) { 
		var obj = {};
		obj.CMD = mx.CMD_SETGAMENO;
		obj.LIDX =lidx;
		obj.GNO = gameno;
		obj.CTYPE = changetype;
		mx.SendPacket(null, obj);	
//	  }
	};


	//지정된 순서 삭제
	mx.delAMData = function(lidx){
	  if (confirm("설정한 경기순서가 초기화 됩니다. 초기화 후 복구 되지 않습니다.")) { 
		var obj = {};
		obj.CMD = mx.CMD_DELAMDATA;
		obj.LIDX =lidx;
		mx.SendPacket(null, obj);	
	  }
	};

	mx.delPMData = function(lidx){
	  if (confirm("설정한 경기순서가 초기화 됩니다. 초기화 후 복구 되지 않습니다.")) { 
		var obj = {};
		obj.CMD = mx.CMD_DELPMDATA;
		obj.LIDX =lidx;
		mx.SendPacket(null, obj);	
	  }
	};
	
	
	mx.setAMPM = function(tidx){
		var obj = {};
		obj.CMD = mx.CMD_SETAMPM;
		obj.TIDX =tidx;
		obj.GDATE = $('#sdate').val();
		obj.AM = $('#amtm').val();
		obj.PM = $('#pmtm').val();
		mx.SendPacket(null, obj);	
	};
	
	mx.setGubun = function(gubun)	{
		switch (gubun)
		{
		case 1:
			$('#gn1').attr('class', 'btn btn-success btn-flat');
			$('#gn2').attr('class', 'btn btn-default btn-flat');
			$('#mk_g2').val(gubun);
			break;
		case 3:
			$('#gn1').attr('class', 'btn btn-default btn-flat');
			$('#gn2').attr('class', 'btn btn-success btn-flat');
			$('#mk_g2').val(gubun);
			break;
		case "am":
			$('#gn3').attr('class', 'btn btn-success btn-flat');
			$('#gn4').attr('class', 'btn btn-default btn-flat');
		    $('#mk_g4').val(gubun);
			break;
		case "pm":
			$('#gn3').attr('class', 'btn btn-default btn-flat');
			$('#gn4').attr('class', 'btn btn-success btn-flat');
		    $('#mk_g4').val(gubun);
			break;
		}
	};

	mx.setSelectFlag = function(tidx){
		var obj = {};
		obj.CMD = mx.CMD_SETFLAG;
		obj.TIDX = tidx;
		obj.FIDX = $('#mk_g0').val();
		mx.SendPacket(null, obj);		
	};


	mx.input_frm = function(tidx){
		var obj = {};
		obj.CMD = mx.CMD_INPUT;
		obj.TIDX =tidx;
		obj.BASEDATE = $('#mk_g0').val(); //idx
		if (obj.BASEDATE == "" || obj.BASEDATE == null){
			alert('시작 날짜와 기준 시간을 먼저 등록해 주십시오.');
			return;
		}
		obj.LIDX = $('#mk_g1').val(); //신청된 개별 종목부서 코드
		obj.GUBUN = $('#mk_g2').val();
		obj.CDC = $('#mk_g3').val(); //종목
		obj.AMPM = $('#mk_g4').val(); //오전에 넣을지 오후에 넣을지 

		if (obj.LIDX == ''){ //전체 부서
			if (obj.CDC == '' )	{ 
				alert('세부종목을 선택해 주세요.');
				return;
			}
			else{
				mx.SendPacket(null, obj);
			}
		}
		else{ //개별부서라면 Lidx 라면 그냥 무시하고 보내자.
			mx.SendPacket(null, obj);		
		}
		

	};




	mx.del_frm = function(tidx){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDEL;
		obj.TIDX =tidx;
		obj.BASEDATE = $('#mk_g0').val(); //idx

		if (confirm('현재 날짜의 설정이 모두 초기화 됩니다?')) {
			mx.SendPacket('titlelist_'+obj.IDX, obj);
		} else {
			return;
		}
	};


	//순서변경
	mx.changeOrder = function(midx, cngtype,ampm){ //위로 1 아래로 2 범위안에 3
		var obj = {};
		obj.CMD = mx.CMD_CHANGEODR;
		obj.MIDX = midx;
		obj.CNGTYPE = cngtype;
		obj.AMPM = ampm;
		mx.SendPacket(null, obj);		
	};






//응답##################################################################

mx.OndrowHTML =  function(cmd, packet, html, sender){
	if(cmd == mx.CMD_GAMELIST || cmd == mx.CMD_GAMEBESTLIST || cmd == mx.CMD_GAMEEXLLIST ){
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




//클릭위치로 돌려놓기
$(document).ready(function(){

        //var offset = $("#div" + seq).offset();
        $('html, body').animate({scrollTop : localStorage.getItem('scrollpostion')}, 400);
//document.body

//	$(document).scrollTop(localStorage.getItem('scrollpostion'));

	$(document).click(function(event){
		window.toriScroll = $(document).scrollTop();
		localStorage.setItem('scrollpostion',window.toriScroll);
		console.log(window.toriScroll);
	});
});

////////////////////////////////////////////////////////////////


