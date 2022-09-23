var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_GETGAMELIST = 11000;
  mx.CMD_CHANGERANE = 310;
  mx.CMD_SETRC = 400;
  mx.CMD_SETRCE2 = 401; //다이빙
  mx.CMD_SETOUT = 410;
  mx.CMD_SETOUTE2 = 411;
  mx.CMD_ORDERLIST = 12000; //계영 신청 선수
  mx.CMD_INPUTODR = 500;
  mx.CMD_OUTODR = 501;
  mx.CMD_RNDUP = 600; //본선진출 설정
  mx.CMD_SENDRESULT = 610; //실적전송
  mx.CMD_SETRCOK = 700; //인정 , 승인



  mx.CMD_GETGAMENOLIST = 510;		//경기정보
  mx.CMD_GAMEMEMBER = 520;	//참가자리스트
  mx.CMD_SAVERECORD = 530;	//기록 저장하기
  mx.CMD_SAVESECTIONRECORD = 540; //구간기록저장

  mx.CMD_SETAPPYN = 630; //앱노출정보 저장
  mx.CMD_SETGAMEDATE = 620; //경영제외한 경기날짜저장

  mx.CMD_SECTIONINFOLIST = 13000; //구간기록 윈도우
  mx.CMD_DELSECTION  = 13100;
  mx.CMD_CHANGEBOOWIN = 13200; //부번경

  mx.CMD_SETSECTIONRC = 12; //구간기록 입력
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqinputRecord.asp";
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
    case 22: alert('요청 리스트가 없습니다.');return;  break;
    case 99: alert('실적이 최종인증되어 실적에는 반영되지 않습니다.');return;  break;

    case 500: alert('결승 경기에 진행된 값이 있어 초기화 하고 다시 설정할 수 없습니다.');return;  break;

    case 100: return;   break; //메시지 없슴
	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}
	return;   break;

	}
  }

  switch (Number(reqcmd)) {
	case mx.CMD_SETGAMEDATE: alert('날짜가 설정되었습니다.'); return; break;


	case mx.CMD_DELSECTION:
	case mx.CMD_SETAPPYN:
	case mx.CMD_SETRCOK : return; break;
	case mx.CMD_RNDUP : this.OnLoadList( reqcmd, jsondata, htmldata, sender ); break; //alert("본선진출이 설정되었습니다.");

	case mx.CMD_OUTODR:
	case mx.CMD_INPUTODR: this.orderList(jsondata.RIDX); break;

	case mx.CMD_CHANGEBOOWIN :
	case mx.CMD_ORDERLIST: //this.orderList(jsondata.RIDX); break;
    case mx.CMD_SECTIONINFOLIST :
    case mx.CMD_GETGAMELIST: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );	break;
	case mx.CMD_SETOUT :
	case mx.CMD_SETOUTE2:
	case mx.CMD_SETRCE2:
	case mx.CMD_SETRC:
	case mx.CMD_CHANGERANE:	this.OnLoadList( reqcmd, jsondata, htmldata, sender );  break;

	case   mx.CMD_GETGAMENOLIST :
	case mx.CMD_SAVERECORD :
    case mx.CMD_SAVESECTIONRECORD :
	case mx.CMD_GAMEMEMBER : 	this.OnLog( reqcmd, jsondata, htmldata, sender );  break;

	case mx.CMD_SETSECTIONRC : $("#btn3_"+ sender).click(); break; //구간기록 입력     mx.SectionInfoListWindow('game_101',11306,'pm','3')
  }
};


//요청##################################################################
	mx.setSectionRecord = function(midx ,  l_gno, ampm){

		  var rc = prompt("입력후엔 기존데이터복구가 불가합니다.\n 쉽표로 구분하여 구간기록을 입력하십시오.");
		  if (rc != null) {
				var obj = {};
				obj.CMD = mx.CMD_SETSECTIONRC;
				obj.MIDX = midx;
				obj.RC = rc;
				obj.AMPM = ampm;
				mx.SendPacket(l_gno, obj);	
		  }
	
	};

	
	
	
	mx.changeBoo = function(tidx,lidx,midx,gamedate,ampm){
		var obj = {};
		obj.CMD = mx.CMD_CHANGEBOOWIN;
		obj.TIDX = tidx;
		obj.LIDX = lidx;
		obj.MIDX = midx;
		obj.GAMEDATE = gamedate;
		obj.AMPM = ampm;
		mx.SendPacket('modalB', obj);
	};
	
	mx.delSectionRecord = function(midxs){
	  if (confirm("정말 삭제하시겠습니까?")) {
		var obj = {};
		obj.CMD = mx.CMD_DELSECTION;
		obj.MIDXS = midxs;
		mx.SendPacket('modalB', obj);
		$('#modalB').modal('hide');
	  }
	};
	
	
	mx.setGameDate = function(gamedate , tidx, savetype){
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




//	mx.CMD_GETGAMENOLIST =  510; //대회번호_대회조수
//  mx.CMD_GAMEMEMBER = 520;	//참가자리스트
//  mx.CMD_SAVERECORD = 530;	//기록 저장하기
	mx.getGameNoList = function(tidx, gamedate,ampm){
		mx.ajaxurl = "/pub/SWAPI/REQ.asp";
		var obj = {};
		obj.CMD = mx.CMD_GETGAMENOLIST;
		obj.TIDX = tidx;
		obj.GAMEDATE = gamedate;
		obj.AMPM = ampm;

		//요청 json 값 출력
   		$('#reqjson').html(JSON.stringify( obj  ));
		console.log(  obj  ); //요청


		mx.SendPacket('modalB', obj);
		mx.ajaxurl = "/pub/ajax/swimming/reqinputRecord.asp";
	};


	mx.getINFO = function(tidx, gameno,joono){
		mx.ajaxurl = "/pub/SWAPI/REQ.asp";
		var obj = {};
		obj.CMD = mx.CMD_GAMEMEMBER;
		obj.TIDX = tidx;
		obj.GAMENO = gameno;
		obj.JOONO = joono;

		//요청 json 값 출력
   		$('#reqjson').html(JSON.stringify( obj  ));
		console.log(  obj  ); //요청


		mx.SendPacket('modalB', obj);
		mx.ajaxurl = "/pub/ajax/swimming/reqinputRecord.asp";
	};

	mx.selectPacket;
	mx.OnLog =  function(cmd, packet, html, sender){
		mx.selectPacket = packet;
		$('#resjson').html(JSON.stringify( packet  ));
	    console.log(  packet  );

	};

	mx.setResult = function(){
		mx.ajaxurl = "/pub/SWAPI/REQ.asp";
		var obj = {};
		var arrobj = {};
		obj.LIST = [];
		obj.CMD = mx.CMD_SAVERECORD;
		obj.MODE = "test"; //테스트 상태에서 저장안됨

		//console.log(":" + mx.selectPacket);
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
				arrobj.GAMERESULT = '003399';   //mx.selectPacket.LIST[i].GAMERESULT;
				obj.LIST[i] = arrobj;
			}
	   		$('#reqjson').html(JSON.stringify( obj  ));
			console.log(   obj ); //요청
			mx.SendPacket('modalB', obj);
		}


		mx.ajaxurl = "/pub/ajax/swimming/reqinputRecord.asp";
	};


    //구간기록 전송
    mx.setSectionResult = function(){
		mx.ajaxurl = "/pub/SWAPI/REQ.asp";
		var obj = {};
		var arrobj = {};
		obj.LIST = [];
		obj.CMD = mx.CMD_SAVESECTIONRECORD;
		obj.MODE = "ok"; //테스트 상태에서 저장안됨

		//console.log(":" + mx.selectPacket);
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
                arrobj.SECTIONNO = '50'; //50m 100m ~
                arrobj.SECTIONRESULT = '001234';
				arrobj.GAMERESULT = '004321';   //mx.selectPacket.LIST[i].GAMERESULT;
				obj.LIST[i] = arrobj;
			}
	   		$('#reqjson').html(JSON.stringify( obj  ));
			console.log(   obj ); //요청
			mx.SendPacket('modalB', obj);
		}

		mx.ajaxurl = "/pub/ajax/swimming/reqinputRecord.asp";
	};






	//rcOK.asp
	mx.setRCOK = function(midx,okno,onoff  ,rndstr,sinstr,fldno,rc,pidx){
		if (onoff == "on"){
			if( $('#okon'+okno+'_'+midx).attr('class') == "btn btn-success"){
				return;
			}
			else{
				$('#okon'+okno+'_'+midx).attr('class','btn btn-success');
				$('#okoff'+okno+'_'+midx).attr('class','btn btn-default');
			}
		}
		else{
			if($('#okoff'+okno+'_'+midx).attr('class') == "btn bg-gray"){
				return;
			}
			else{
			$('#okon'+okno+'_'+midx).attr('class','btn btn-default');
			$('#okoff'+okno+'_'+midx).attr('class','btn bg-gray');
			}
		}

		var obj = {};
		obj.CMD = mx.CMD_SETRCOK;
		obj.MIDX = midx;
		obj.OKNO = okno; //1인정 2승인
		obj.ONOFF = onoff;
		obj.RNDSTR = rndstr;//sinround = "결승"
		obj.SINSTR = sinstr; //singistr = "대회신기록"
		obj.FLDNO = fldno; //savefld = "2"
		obj.RC = rc;
		obj.PIDX = pidx;

		mx.SendPacket('modalB', obj);

	};



	mx.sendResult = function(gameno, lidx, ampm, gubun, itgubun){ //결승 레인배정
	//'게임번호,  tblRGameLevel.RGameLevelidx, 오전오후(am,pm) , l_gubun(예선, 결승 , 1, 3)
	  if (confirm("실적을 전송 하시겠습니까?")) {
		var obj = {};


		$("#btn4_" + gameno).attr('class','btn btn-warning');
		$("#btn4_" + gameno).text("실적전송(완료)");


		obj.CMD = mx.CMD_SENDRESULT;
		obj.GNO = gameno;
		obj.LIDX = lidx;
		obj.AMPM = ampm;
		obj.GUBUN = gubun;
		obj.ITGUBUN = itgubun; //개인, 단체
		mx.SendPacket('modalB', obj);
	  }
	};





	mx.setRoundUp = function(gameno, lidx, ampm, gubun){ //결승 레인배정
	//'게임번호,  tblRGameLevel.RGameLevelidx, 오전오후(am,pm) , l_gubun(예선, 결승 , 1, 3)
	  if (confirm("결승진출자를 생성하고 레인을 배정하시겠습니까?")) {

		var chkArr = [];
		var i = 0;
		$("input[name=chk_"+gameno+"]:checked").each(function() {
			chkArr[i] = $(this).val();
			i++;
		});

		var obj = {};
		obj.CMD = mx.CMD_RNDUP;
		obj.GNO = gameno;
		obj.LIDX = lidx;
		obj.GUBUN = ampm;
		obj.QMARR = chkArr;
		mx.SendPacket('modalB', obj);
	  }
	};


	//계영선수지정
	mx.outMember = function(idx,ridx,pidx){
		var obj = {};
		obj.CMD = mx.CMD_OUTODR;
		obj.IDX = idx;
		obj.RIDX = ridx;
		obj.PIDX = pidx;
		mx.SendPacket('modalB', obj);
	};

	//계영선수지정취소
	mx.inputMember = function(idx,ridx){
		var obj = {};
		obj.CMD = mx.CMD_INPUTODR;
		obj.IDX = idx;
		obj.RIDX = ridx;
		mx.SendPacket('modalB', obj);
	};

	mx.orderList = function(ridx){
		var obj = {};
		obj.CMD = mx.CMD_ORDERLIST;
		obj.RIDX = ridx;
		mx.SendPacket('modalB', obj);
	};


	mx.getGameList = function(sender,lidx,ampm, gubun){ //gubunam gubunpm 오전 오후에 각 예선 결승 구분값
		var obj = {};
		obj.CMD = mx.CMD_GETGAMELIST;
		obj.AMPM = ampm;
		obj.LIDX =lidx;
		obj.GUBUN = gubun;
		mx.SendPacket(sender, obj);
	};

	mx.getGameList2 = function(sender,lidx,ampm, gubun){ //소팅
		var obj = {};
		obj.CMD = mx.CMD_GETGAMELIST;
		obj.AMPM = ampm;
		obj.LIDX =lidx;
		obj.GUBUN = gubun;
		obj.SORT = 1;
		mx.SendPacket(sender, obj);
	};


	//레인번호변경
	mx.changeRane = function(midx, cngval , cngtype , gameno, ampm){ //위로 1 아래로 2 범위안에 3
		var obj = {};
		obj.CMD = mx.CMD_CHANGERANE;
		obj.MIDX = midx;
		obj.CNGVAL = cngval;
		obj.CNGTYPE = cngtype;
		obj.GNO = gameno;
		obj.AMPM = ampm;
		mx.SendPacket(null, obj);
	};


	//기록 저장 하기
	mx.setP = function(inputobj, midx, lidx, gameno, grouprcID){

		px.setZeroSm(inputobj); //0일때 바로쓸수 있도록 value 초기화
		if (inputobj.value == '' || inputobj.value == "00:00.00" ){
			return;
		}
		if( inputobj.value.length != 6 ){
			inputobj.value = inputobj.defaultValue;
			return;
		}

		//다음 탭으로 갈수 있도록
		//console.log( $('#' + inputobj.id).attr('tabindex'));
		var nexttabindex = Number($('#' + inputobj.id).attr('tabindex')) + 1;
		localStorage.setItem('rctab', nexttabindex);

		var obj = {};
		obj.CMD = mx.CMD_SETRC;
		obj.MIDX = midx;
		obj.LIDX = lidx;
		obj.GNO = gameno;
		obj.INVAL = inputobj.value.replace(":","").replace(".","");

		obj.FIRSTINVAL = $('#'+grouprcID).val().replace(":","").replace(".",""); //첫주자기록

		//탭할 ID를 찾아서 스토리지에 넣어두자.

		mx.SendPacket(inputobj, obj);
	};


	//기록 저장 하기(다이빙)
	mx.setPE2 = function(inputobj, midx, lidx, gameno, grouprcID){

		px.setZeroE2(inputobj); //0일때 바로쓸수 있도록 value 초기화
		if (inputobj.value == '' || inputobj.value == "000.00" ){
			return;
		}
		if( inputobj.value.length != 5 ){
			inputobj.value = inputobj.defaultValue;
			return;
		}

		//다음 탭으로 갈수 있도록
		//console.log( $('#' + inputobj.id).attr('tabindex'));
		var nexttabindex = Number($('#' + inputobj.id).attr('tabindex')) + 1;
		localStorage.setItem('rctab', nexttabindex);

		var obj = {};
		obj.CMD = mx.CMD_SETRCE2;
		obj.MIDX = midx;
		obj.LIDX = lidx;
		obj.GNO = gameno;
		obj.INVAL = inputobj.value;
		mx.SendPacket(inputobj, obj);
	};


	//기록 저장 하기(아티스틱)
	mx.setPF2 = function(inputobj, midx, lidx, gameno, grouprcID){

		px.setZeroF2(inputobj); //0일때 바로쓸수 있도록 value 초기화
		if (inputobj.value == '' || inputobj.value == "000.0000" ){
			return;
		}
		if( inputobj.value.length != 7 ){
			inputobj.value = inputobj.defaultValue;
			return;
		}

		//다음 탭으로 갈수 있도록
		//console.log( $('#' + inputobj.id).attr('tabindex'));
		var nexttabindex = Number($('#' + inputobj.id).attr('tabindex')) + 1;
		localStorage.setItem('rctab', nexttabindex);

		var obj = {};
		obj.CMD = mx.CMD_SETRCE2;
		obj.MIDX = midx;
		obj.LIDX = lidx;
		obj.GNO = gameno;
		obj.INVAL = inputobj.value;
		mx.SendPacket(inputobj, obj);
	};



	//실격사유
	mx.setOut = function(inputobj, midx, lidx, gameno){
		var obj = {};
		obj.CMD = mx.CMD_SETOUT;
		obj.MIDX = midx;
		obj.LIDX = lidx;
		obj.GNO = gameno;
		obj.INVAL = inputobj.value;
		mx.SendPacket(inputobj, obj);
	};

	//다이빙등(음 안써 일단)
//	mx.setOutE2 = function(inputobj, midx, lidx, gameno){
//		var obj = {};
//		obj.CMD = mx.CMD_SETOUTE2;
//		obj.MIDX = midx;
//		obj.LIDX = lidx;
//		obj.GNO = gameno;
//		obj.INVAL = inputobj.value;
//		mx.SendPacket(inputobj, obj);
//	};


mx.SectionInfoListWindow = function(sender,lidx,ampm, gubun){ //구간 기록 정보를가져온다.
    var obj = {};
    obj.CMD = mx.CMD_SECTIONINFOLIST;
    obj.AMPM = ampm;
    obj.LIDX =lidx;
    obj.GUBUN = gubun;
    mx.SendPacket('modalB', obj);
};


//응답##################################################################
mx.OnLoadList =  function(cmd, packet, html, sender){
	if(packet.SORT == "" || packet.SORT == null ){
		if (cmd == mx.CMD_SETRCE2 || cmd == mx.CMD_SETOUTE2 || packet.GNO == '0' ){
			$('#btn_'+packet.LIDX).click();
		}
		else{
			$('#btn_'+packet.GNO).click();
		}
	}
	else{
		if (cmd == mx.CMD_SETRCE2 || cmd == mx.CMD_SETOUTE2 || packet.GNO == '0' ){
			$('#btn2_'+packet.LIDX).click();
		}
		else{
			$('#btn2_'+packet.GNO).click();
		}
	}
};






mx.OndrowHTML =  function(cmd, packet, html, sender){
	if(cmd == mx.CMD_GAMELIST || cmd == mx.CMD_GAMEBESTLIST || cmd == mx.CMD_GAMEEXLLIST || cmd == mx.CMD_ORDERLIST || cmd == mx.CMD_SECTIONINFOLIST || cmd == mx.CMD_CHANGEBOOWIN ){
		if( $('#modalB').length == 0 ){
			$('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
		}
		document.getElementById("modalB").innerHTML = html;
		$('#modalB').modal('show');
	}
	else{
		document.getElementById(sender).innerHTML = html;


		if(cmd == mx.CMD_GETGAMELIST){
			if (localStorage.getItem('rctab') != 'NaN'){
				//$('[tabindex=' + localStorage.getItem('rctab') + ']').focus();
			}
		}

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
