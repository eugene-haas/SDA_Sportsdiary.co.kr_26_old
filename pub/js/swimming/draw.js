var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;

  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_FINDBOODETAIL = 11000; //부세부종목 불러오기
  mx.CMD_FINDBOO = 11001; //부
  mx.CMD_GAMELIST = 12000; //기존기록조회
  mx.CMD_GAMEBESTLIST = 12100;
  mx.CMD_GAMEEXLLIST = 12200; //엑셀다운로드

  mx.CMD_GAMELISTSEARCH = 12001;
  mx.CMD_GAMELISTSEARCH2 = 12002;

  mx.CMD_GETBESTRC = 502;
  mx.CMD_SETRANE = 510;


  mx.CMD_CHANGERANE = 310;
  mx.CMD_CHANGERANEJOO = 311; //조랑 레인같이 변경
  mx.CMD_CHANGENO = 320; //대진순서 설정

  mx.CMD_LGMAKE = 70000;
  mx.CMD_TNMAKE = 700;
  mx.CMD_SETSCORE = 800;
  mx.CMD_SETSAVESOOGOO = 810;

  mx.CMD_GAMEINRC = 13000; //게임결과 입력
  mx.CMD_SETGAMEDATE = 620; //경영제외한 경기날짜저장




  mx.CMD_ORDERLIST = 12000; //신청 선수
  mx.CMD_INPUTODR = 500;
  mx.CMD_OUTODR = 501;
  mx.CMD_SETLEGORDER = 603;
  mx.CMD_SENDRC  = 604; //수구실적전송
  mx.CMD_SETAPPYN = 630; //앱노출정보 저장

  mx.CMD_SETSTART = 669; //경기시작형태
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqDraw.asp";
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
    case 5: alert('값이 부정확합니다.');return;  break;
    case 100: return;   break; //메시지 없슴
	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}
	return;   break;

	}
  }




  switch (Number(reqcmd)) {
	case mx.CMD_SENDRC : alert('실적전송이 완료되었습니다.'); return; break;
	case mx.CMD_SETGAMEDATE: alert('날짜가 설정되었습니다.'); return; break;

	case mx.CMD_SETAPPYN:
	case mx.CMD_SETLEGORDER:
	case mx.CMD_SETSCORE: return; break;

	case mx.CMD_SETSTART:
	case mx.CMD_SETSAVESOOGOO :
	case mx.CMD_CHANGENO :
	case mx.CMD_CHANGERANEJOO:
	case mx.CMD_CHANGERANE:	window.location.reload();	break;

	case mx.CMD_SETRANE : //줄깨져서 그냥 두번 돌린거...
		//if (mx.setcnt == 1){mx.setcnt = 2;mx.setRane(jsondata.TIDX,jsondata.GBIDX,jsondata.STARTTYPE)}
		//else{window.location.reload();}
		window.location.reload();
	break;



	case mx.CMD_TNMAKE : this.OnShowTourn( reqcmd, jsondata, htmldata, sender ); break; //토너먼트

	case mx.CMD_LGMAKE:
	case mx.CMD_GAMEEXLLIST:
	case mx.CMD_GAMEBESTLIST :
	case mx.CMD_GAMELISTSEARCH:
	case mx.CMD_GAMELISTSEARCH2:

	case mx.CMD_GAMEINRC:

	case mx.CMD_ORDERLIST:
	case mx.CMD_GAMELIST: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GETBESTRC  : alert("기준 기록이 반영되었습니다.");window.location.reload(); break;


  	case mx.CMD_OUTODR:
	case mx.CMD_INPUTODR: this.orderList(jsondata.RIDX); break;
  }
};


//요청##################################################################
	mx.setStart = function(tidx,gbidx,cdc, starttype){
		var obj = {};
		obj.CMD = mx.CMD_SETSTART;
		obj.TIDX = tidx;
		obj.GBIDX= gbidx;
		obj.CDC = cdc;
		obj.STYPE = starttype;
		mx.SendPacket(null, obj);
	};



	mx.setAppShow = function(btnnm,lidx,ampm,gubun){
		if($('#'+btnnm).attr('class') == "btn btn-default"){
			$('#'+btnnm).attr('class','btn bg-yellow');
		}
		else{
			$('#'+btnnm).attr('class','btn btn-default');
		}

		var obj = {};
		obj.CMD = mx.CMD_SETAPPYN;
		obj.LIDX = lidx;
		obj.AMPM = ampm;
		obj.GUBUN = gubun;
		mx.SendPacket('modalB', obj);
	};


	//수구 기록저장및 실적전송
	mx.sendRC = function(tidx,levelno,lidx){
		var obj = {};
		obj.CMD = mx.CMD_SENDRC;
		obj.TIDX = tidx;
		obj.LNO = levelno;
		obj.LIDX = lidx;
		mx.SendPacket('modalB', obj);
	};

	//순위강제 설정
	mx.setLegOrder = function(inputobj, midx){
		var obj = {};
		obj.CMD = mx.CMD_SETLEGORDER;
		obj.MIDX = midx;
		obj.INVAL = inputobj.value;
		mx.SendPacket('modalB', obj);
	}


	//선수지정취소
	mx.outMember = function(idx,ridx,pidx){
		mx.ajaxurl = "/pub/ajax/swimming/reqinputRecord.asp";
		var obj = {};
		obj.CMD = mx.CMD_OUTODR;
		obj.IDX = idx;
		obj.RIDX = ridx;
		obj.PIDX = pidx;
		mx.SendPacket('modalB', obj);
		mx.ajaxurl = "/pub/ajax/swimming/reqDraw.asp";
	};

	//선수지정
	mx.inputMember = function(idx,ridx){
		mx.ajaxurl = "/pub/ajax/swimming/reqinputRecord.asp";
		var obj = {};
		obj.CMD = mx.CMD_INPUTODR;
		obj.IDX = idx;
		obj.RIDX = ridx;
		mx.SendPacket('modalB', obj);
		mx.ajaxurl = "/pub/ajax/swimming/reqDraw.asp";
	};


	mx.orderList = function(ridx){
		mx.ajaxurl = "/pub/ajax/swimming/reqinputRecord.asp";
		var obj = {};
		obj.CMD = mx.CMD_ORDERLIST;
		obj.RIDX = ridx;
		mx.SendPacket('modalB', obj);
		mx.ajaxurl = "/pub/ajax/swimming/reqDraw.asp";
	};


	mx.setGameDate = function(gamedate , tidx, savetype){
		mx.ajaxurl = "/pub/ajax/swimming/reqinputRecord.asp";
		if (gamedate == ''){
			alert('대회 날짜를 선택해 주세요.');
			return;
		}

		var obj = {};
		obj.CMD = mx.CMD_SETGAMEDATE;
		obj.TIDX = tidx;
		obj.GAMEDATE = gamedate;
		obj.SVTYPE = savetype;
		mx.SendPacket('modalB', obj);
		mx.ajaxurl = "/pub/ajax/swimming/reqDraw.asp";
	};


	//수구 기록 저장 하기
	mx.setScore= function(inputobj, idx , leftright){

		// px.setZero(inputobj); //0일때 바로쓸수 있도록 value 초기화
		// if (inputobj.value == '' || inputobj.value == "0" ){
		// 	return;
		// }

		var obj = {};
		obj.CMD = mx.CMD_SETSCORE;
		obj.IDX = idx;
		obj.LR = leftright;
		obj.ID = inputobj.id;
		obj.INVAL = inputobj.value;

		var lresult = Number($('#lpl1').val()) + Number($('#lpl2').val()) + Number($('#lpl3').val()) + Number($('#lpl4').val()) + Number($('#lpl5').val());
		var rresult = Number($('#rpl1').val()) + Number($('#rpl2').val()) + Number($('#rpl3').val()) + Number($('#rpl4').val()) + Number($('#rpl5').val()) ;

		if (leftright == "l")	{
			//total
			$('#ltotal').val(  lresult  );
		}
		else{
			$('#rtotal').val( rresult   );
		}

		if (lresult > rresult){
			$('#lresult').html( "승"   );
			$('#rresult').html( "패"   );
		}
		else if(lresult == rresult){
			$('#lresult').html( "패"   );
			$('#rresult').html( "패"   );
		}
		else{
			$('#lresult').html( "패"   );
			$('#rresult').html( "승"   );
		}
		mx.SendPacket(inputobj, obj);
	};


	//수구 승패 저장 하기
	mx.setSaveSooGoo= function(idx, midxL, midxR){

		var obj = {};
		obj.CMD = mx.CMD_SETSAVESOOGOO;
		obj.IDX = idx;
		obj.INVAL = $('#sayou').val(); //사유

		var lresult = $('#ltotal').val();
		var rresult = $('#rtotal').val();

		if (Number(lresult) > Number(rresult)){
			obj.LR = "L";
			obj.WIN = midxL;
		}
		else if(Number(lresult) == Number(rresult)){
			obj.LR = "";
			obj.WIN = '';
		}
		else{
			obj.LR = "R";
			obj.WIN = midxR;
		}
		mx.SendPacket(null, obj);
	};





	mx.setFocus = function(jno){
		$( "#jmn tr").css( "background-color", "#ECF0F5" );
		$( "#jmn_" + jno ).css( "background-color", "#BFBFBF" );
		$( "#swtable tbody tr").css( "background-color", "white" );
		$( "#contest_" + jno + " tr").css( "background-color", "#BFBFBF" );

		var offset = $( "#contest_" + jno + " tr").offset();
        $('html, body').animate({scrollTop : offset.top}, 400);
		//$( "#contest_" + jno + " tr").focus();
	};

	//수구 결과 입력창
	mx.soogooWindow = function(idx){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINRC;
		obj.IDX =idx;
		mx.SendPacket('modalB', obj);
	};

	//기준기록조회
	mx.gameList = function(tidx,gbidx,cdc){
		var obj = {};
		obj.CMD = mx.CMD_GAMELIST;
		obj.TIDX =tidx;
		obj.GBIDX = gbidx;
		obj.CDC = cdc;
		mx.SendPacket('modalB', obj);
	};


	mx.gameBestList = function(tidx,gbidx,cdc){
		var obj = {};
		obj.CMD = mx.CMD_GAMEBESTLIST;
		obj.TIDX =tidx;
		obj.GBIDX = gbidx;
		obj.CDC = cdc;
		mx.SendPacket('modalB', obj);
	};


	mx.gameExlList = function(tidx,gbidx,cdc){
		var obj = {};
		obj.CMD = mx.CMD_GAMEEXLLIST;
		obj.TIDX =tidx;
		obj.GBIDX = gbidx;
		obj.CDC = cdc;
		mx.SendPacket('modalB', obj);
	};



	mx.gameSearchList = function( tidx,gbidx,cdc, f1,f2 ){
		var obj = {};
		obj.CMD = mx.CMD_GAMELISTSEARCH;
		obj.TIDX =tidx;
		obj.GBIDX = gbidx;
		obj.CDC = cdc;
		obj.F1 = f1;
		obj.F2 = f2;
		mx.SendPacket('modalB', obj);
	};

	mx.gameSearchList2 = function( tidx,gbidx,cdc, f1,f2 ){
		var obj = {};
		obj.CMD = mx.CMD_GAMELISTSEARCH2;
		obj.TIDX =tidx;
		obj.GBIDX = gbidx;
		obj.CDC = cdc;
		obj.F1 = f1;
		obj.F2 = f2;
		mx.SendPacket('modalB', obj);
	};


	mx.setBestRecord = function(tidx,gbidx,cdc){
		var obj = {};
		obj.CMD = mx.CMD_GETBESTRC;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.CDC = cdc;

		//체크된 항목들의 Lidx
		var chkArr = [];
		var i = 0;

		$("input[name=chk_game]:checked").each(function() {
			chkArr[i] = $(this).val();
			i++;
		});


		obj.CHKLIDX = chkArr;

		mx.SendPacket('modalB', obj);
	};

	mx.setBestExcelDown = function(tidx,gbidx,cdc){
		var obj = {};
		obj.CMD = mx.CMD_GETBESTRC;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.CDC = cdc;

		//체크된 항목들의 Lidx
		var chkArr = [];
		var i = 0;

		$("input[name=chk_game]:checked").each(function() {
			chkArr[i] = $(this).val();
			i++;
		});


		obj.CHKLIDX = chkArr;

		px.goSubmit(obj,"excelBest.asp");

		//자유형50m 남여 구분해서 최고기록 불러서 엑셀출력...
		//mx.SendPacket('modalB', obj);
	};

	mx.setBestExcelDown2 = function(tidx,gbidx,cdc){
		var obj = {};
		obj.CMD = mx.CMD_GETBESTRC;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.CDC = cdc;

		//체크된 항목들의 Lidx
		var chkArr = [];
		var i = 0;

		$("input[name=chk_game]:checked").each(function() {
			chkArr[i] = $(this).val();
			i++;
		});


		obj.CHKLIDX = chkArr;

		px.goSubmit(obj,"excelBest2.asp");

		//자유형50m 남여 구분해서 최고기록 불러서 엑셀출력...
		//mx.SendPacket('modalB', obj);
	};



	//레인배정
	mx.setcnt = 1; //두번돌릴꺼다 오류처리를 위해서 20210208 by baek
	mx.setRane = function(tidx,gbidx,starttype){
		var obj = {};
		obj.CMD = mx.CMD_SETRANE;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.STARTTYPE = starttype;
		mx.SendPacket(null, obj);
	};


	//레인+조 번호변경
	mx.changeRaneJoo = function(midx, cngval, cngval2 , cngtype){ //위로 1 아래로 2 범위안에 3
		var obj = {};
		obj.CMD = mx.CMD_CHANGERANEJOO;
		obj.MIDX = midx;
		obj.CNGVAL = cngval;
		obj.CNGVAL2 = cngval2;
		obj.CNGTYPE = cngtype;
		mx.SendPacket(null, obj);
	};


	//레인번호변경
	mx.changeRane = function(midx, cngval , cngtype){ //위로 1 아래로 2 범위안에 3
		var obj = {};
		obj.CMD = mx.CMD_CHANGERANE;
		obj.MIDX = midx;
		obj.CNGVAL = cngval;
		obj.CNGTYPE = cngtype;
		mx.SendPacket(null, obj);
	};


	//대진표 순서 변경
	mx.changeNo = function(midx, cngval , cngtype){ //위로 1 아래로 2 범위안에 3
		var obj = {};
		obj.CMD = mx.CMD_CHANGENO;
		obj.MIDX = midx;
		obj.CNGVAL = cngval;
		obj.CNGTYPE = cngtype;
		mx.SendPacket(null, obj);
	};


	//대진표 생성
	mx.makeGameTable = function(tidx,levelno, tabletype, tableno, calltype){

		var obj = {};
		obj.TABLETYPE = tabletype;
		if(tabletype == 1 ){
			obj.CMD = mx.CMD_LGMAKE;
		}
		else{
			obj.CMD = mx.CMD_TNMAKE;
		}
		obj.TIDX = tidx;
		obj.LNO = levelno;
		obj.TNO = tableno; //참가자수
		obj.CALLTYPE = calltype;

		mx.SendPacket('tournament2', obj);

	};










//응답##################################################################

mx.OndrowHTML =  function(cmd, packet, html, sender){
	if(cmd == mx.CMD_GAMELIST || cmd == mx.CMD_GAMEBESTLIST || cmd == mx.CMD_GAMEEXLLIST || cmd == mx.CMD_GAMEINRC || cmd == mx.CMD_ORDERLIST){
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
