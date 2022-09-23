var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;


  mx.CMD_CHANGEREFEREEWINDOW = 20008; //심판수정창
  mx.CMD_CHANGEREFEREEOK = 75; //수정완료
  mx.CMD_REFEREEWINDOW = 20000; //심판배정
  mx.CMD_SETREFEREE = 70; //배정심판넣기
  mx.CMD_GETGAMELIST = 11000;
  mx.CMD_SETGAMEROUND = 50; //라운드 설정
  mx.CMD_SETJUDGECNT = 51; //심판수설정
  mx.CMD_SUMBOO = 53;//선택항목통합
  mx.CMD_SETGAMEPER = 55; //게임난이율키저장
  mx.CMD_SETGAMEDATE2 = 57; //날짜설정
  mx.CMD_SETGAMEDATENEXT = 58; //날짜설정
  mx.CMD_SETAMPM = 59; //오전오후설정 시간으로 
  mx.CMD_SETAMPMNEXT = 60; //오전오후설정 시간으로 
  mx.CMD_DIVBOO = 61; //해제
  mx.CMD_CHANGEORDER = 63; //경기순서변경

	mx.CMD_TEMPORDER = 64; //임시경기번호저장
	mx.CMD_SETGAMENO = 66; //경기번호 일괄적용
	mx.CMD_SETJUDGEALL = 71; //심판 전체배정

  mx.CMD_FINDJUDGE = 20003; //심판불러오기 20개만..
  mx.CMD_SETJUDGE = 20005; //심판등록
  mx.CMD_DELJUDGE = 65;
  mx.CMD_CHANGEMEMBERORDER = 310;
  mx.CMD_GAMECODEWINDOW = 20012; //난이율코드등록창
////////////////////////////////////////

mx.ajaxurl = "/pub/ajax/swimming/reqSetRecord_F2.asp";
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
    case 23: alert('심사한 내용이 있어 변경할 수 없습니다.');return;  break;
    case 24: alert('선택항목 중 통합된 경기가 있습니다. ');return;  break;
    case 25: alert('변경하려눈 순서는 통합된 경기입니다. 해제 후 순서를 변경해 주십시오. ');return;  break;
    case 28: alert('숫자가 경기숫자 번호를 범위를 초과하였습니다. ');return;  break;
    case 99: alert('실적이 최종인증되어 실적에는 반영되지 않습니다.');return;  break;
	case 111: alert(jsondata.servermsg);return;break;

	case 112: 	 
		if (confirm(jsondata.servermsg)) {
			this.setreferee(jsondata.TIDX,jsondata.LIDX, jsondata.GBIDX,"confirmpass");
		}
	return;break;

    case 500: alert('결승 경기에 진행된 값이 있어 초기화 하고 다시 설정할 수 없습니다.');return;  break;

    case 100: return;   break; //메시지 없슴
	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}
	default : return; break;
	return;   break;

	}
  }

  switch (Number(reqcmd)) {
	case mx.CMD_GAMECODEWINDOW :
	case mx.CMD_SETJUDGE  :
	case mx.CMD_FINDJUDGE :
	case mx.CMD_GETGAMELIST:
	case mx.CMD_CHANGEREFEREEWINDOW:
	case mx.CMD_REFEREEWINDOW: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );	break;



	case mx.CMD_SETJUDGEALL:
	case mx.CMD_SETGAMENO :
	case mx.CMD_SETAMPM:
	case mx.CMD_SETAMPMNEXT:
	case mx.CMD_SETGAMEDATE2 :
	case mx.CMD_SETGAMEDATENEXT: //날짜설정
	case mx.CMD_SETJUDGECNT : //심판수
	case mx.CMD_SETREFEREE:
	case mx.CMD_CHANGEORDER :
	case mx.CMD_DIVBOO :
	case mx.CMD_SUMBOO : //부한경기로 (하지만 각각 계산한다...)
	case mx.CMD_SETGAMEROUND : window.location.reload();	break;

	case mx.CMD_TEMPORDER:
	case mx.CMD_DELJUDGE: return; break;

	case mx.CMD_SETGAMEPER: this.setGameCodeWindow(jsondata.TIDX,jsondata.LIDX,jsondata.MIDX); break;


	case mx.CMD_CHANGEMEMBERORDER : mx.getGameList('game_'+jsondata.LIDX,jsondata.LIDX,'am',''); break;
	case mx.CMD_CHANGEREFEREEOK : $('#modalB').modal('hide'); mx.getGameList('game_'+jsondata.LIDX,jsondata.LIDX,'am',''); break;
  }
};

//요청##################################################################
//경기순서변경 (통합 순서와는 변경불가 풀어서)
mx.tempOrder = function(cda,tidx,lidx, orderno, preorderno){
	var obj = {};
	obj.CMD = mx.CMD_TEMPORDER;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.ORDERNO = orderno;
	obj.PREORDERNO = preorderno;
	obj.CDA = cda;
	//console.log(obj);
	mx.SendPacket(null, obj);
};

mx.setJudgeAll = function(tidx){
	if (!confirm("심판배정된곳이 있다면 전체 재배정 됩니다.. 진행하시겠습니까?")) {
		return;
	}	
	var obj = {};
	obj.CMD = mx.CMD_SETJUDGEALL;
	obj.TIDX = tidx;
	mx.SendPacket("jsetarea", obj);
};

mx.setGameno = function(tidx){
	if (!confirm("설정한 경기순서를 대회에 반영하시겠습니까?")) {
		return;
	}
	var obj = {};
	obj.CMD = mx.CMD_SETGAMENO;
	obj.TIDX =tidx;
	mx.SendPacket('modalB', obj);	
};


mx.setGameCodeWindow = function(tidx,lidx,midx){ //개인난이률설정창
    var obj = {};
    obj.CMD = mx.CMD_GAMECODEWINDOW;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;
    mx.SendPacket('modalB', obj);
};



//선수경기순서변경
mx.changeMemberOrder = function(midx, cngval , lidx , listlidx, gameround){ //listlidx 통합본 인덱스 
	if (cngval == ''){
		return;
	}
	var obj = {};
	obj.CMD = mx.CMD_CHANGEMEMBERORDER;
	obj.MIDX = midx;
	obj.CNGVAL = cngval;
	obj.CHOICELIDX = lidx;
	obj.LIDX = listlidx;
	obj.RND = gameround;
	mx.SendPacket(null, obj);
};


mx.refereeWindow = function(tidx,cda){ //심판배정
    var obj = {};
    obj.CMD = mx.CMD_REFEREEWINDOW;
    obj.TIDX =tidx;
	obj.CDA = cda;
    mx.SendPacket('modalB', obj);
};


mx.changeJudge = function(tidx,lidx,myfldno,jidx ,cdc, gameround){ //심판수정 
    var obj = {};
    obj.CMD = mx.CMD_CHANGEREFEREEWINDOW;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.MYFLDNO = myfldno;
	obj.JIDX = jidx;

	obj.CDC = cdc;
	obj.RND = gameround;
    mx.SendPacket('modalB', obj);
};

mx.changeJudgeOK = function(tidx,lidx ,jidx,targetjidx, myfldno, targetfldno ,cdc, gameround){ //심판수정
	if (targetfldno != ''){
		if (!confirm("동일부의 심판입니다. 심판과 심사위치가 변경됩니다. 전행하시겠습니까?")) {
			return;
		}
	}
    var obj = {};
    obj.CMD = mx.CMD_CHANGEREFEREEOK;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.JIDX = jidx;
	obj.TARGETJIDX = targetjidx;
	obj.MYFLDNO =myfldno;  
	obj.TARGETFLDNO = targetfldno;
	obj.CDC = cdc; //변경할라운드
	obj.RND = gameround; //변경할라운드
    mx.SendPacket('modalB', obj);
};

mx.setreferee = function(tidx, lidx,gbidx, chkpass){ //배정심판 확인및 변경
    var obj = {};
    obj.CMD = mx.CMD_SETREFEREE;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.GBIDX = gbidx;
	obj.CHKPASS = chkpass;
    mx.SendPacket('modalB', obj);
};

mx.setRound = function(tidx, lidx, gbidx,rndcnt,chkjidx){ //chkjidx 심판이 들어가있는지 판단
	if (chkjidx !="" && chkjidx != "0"){
		if (!confirm("심판이 배정되어있습니다. 변경시 초기화 됩니다. 전행하시겠습니까?")) {
			window.location.reload();
			return;
		}
	}
	
    var obj = {};
    obj.CMD = mx.CMD_SETGAMEROUND;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.GBIDX = gbidx;
	obj.RNDCNT = rndcnt;
	//console.log(obj);
	mx.SendPacket(null , obj);	
};


mx.setJudgeCnt = function(tidx, lidx, gbidx, jcnt,chkjidx){
	if (chkjidx !="" && chkjidx != "0"){
		if (!confirm("심판이 배정되어있습니다. 변경시 초기화 됩니다. 전행하시겠습니까?")) {
			window.location.reload();
			return;
		}
	}
	var obj = {};
    obj.CMD =   mx.CMD_SETJUDGECNT;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.GBIDX = gbidx;
	obj.JCNT = jcnt;
	//console.log(obj);
	mx.SendPacket(null , obj);	
};

//난이율 등록 /수정
mx.setGamePer = function(ridx, gamecodeseq   ,tidx,lidx,midx ,gameround){
	var obj = {};
    obj.CMD =   mx.CMD_SETGAMEPER;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;

	obj.RIDX = ridx;
	obj.GCSEQ = gamecodeseq;
	obj.RND = gameround;
	mx.SendPacket(null , obj);	
};

mx.setGamedate2 = function(tidx, lidx, gbidx, gamedate){
	if (gamedate == ''){
		alert('대회 날짜를 선택해 주세요.');
		return;
	}

	var obj = {};
    obj.CMD =   mx.CMD_SETGAMEDATE2;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.GBIDX = gbidx;
	obj.GAMEDATE = gamedate;
	mx.SendPacket(null , obj);	
};


mx.setGamedateNext = function(tidx, lidx, gbidx, gamedate){
	if (gamedate == ''){
		alert('대회 날짜를 선택해 주세요.');
		return;
	}

	var obj = {};
    obj.CMD =   mx.CMD_SETGAMEDATENEXT;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.GBIDX = gbidx;
	obj.GAMEDATE = gamedate;
	mx.SendPacket(null , obj);	
};

mx.setAMPM = function(tidx, lidx, gbidx, timestr){
	var obj = {};
    obj.CMD =   mx.CMD_SETAMPM;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.GBIDX = gbidx;
	obj.TIMESTR = timestr;
	mx.SendPacket(null , obj);	
};

mx.setAMPMNext = function(tidx, lidx, gbidx, timestr){
	var obj = {};
    obj.CMD =   mx.CMD_SETAMPMNEXT;
    obj.TIDX =tidx;
	obj.LIDX = lidx;
	obj.GBIDX = gbidx;
	obj.TIMESTR = timestr;
	mx.SendPacket(null , obj);	
};


//경기순서변경 (통합 순서와는 변경불가 풀어서)
mx.changeOrder = function(cda,tidx,lidx, orderno, preorderno){
	var obj = {};
	obj.CMD = mx.CMD_CHANGEORDER;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.ORDERNO = orderno;
	obj.PREORDERNO = preorderno;
	obj.CDA = cda;
	//console.log(obj);
	mx.SendPacket(null, obj);
};

mx.findJudge = function(cda, tidx, findval){
	 //저장된건 검색되지 않도록 하자.
	var obj = {};
	obj.CMD = mx.CMD_FINDJUDGE;
	obj.TIDX = tidx;
	obj.FINDVAL = findval;
	obj.CDA = cda;
	mx.SendPacket("jfindarea", obj);
};

mx.setJudge = function(cda,tidx,idx){
	$('#jftr_'+idx).remove();

	var obj = {};
	obj.CMD = mx.CMD_SETJUDGE;
	obj.TIDX = tidx;
	obj.CDA = cda;
	obj.IDX = idx;
	mx.SendPacket("jsetarea", obj);
};


mx.delJudge = function(cda,tidx,idx){
	$('#setjftr_'+idx).remove();

	var obj = {};
	obj.CMD = mx.CMD_DELJUDGE;
	obj.TIDX = tidx;
	obj.CDA = cda;
	obj.IDX = idx;
	mx.SendPacket(null, obj);
};


///////////////////////////////////////////
//경기통합 체크
///////////////////////////////////////////
	mx.removeItemOnce = function(arr, value) {
	  var index = arr.indexOf(value);
	  if (index > -1) {
		arr.splice(index, 1);
	  }
	  return arr;
	}

	mx.chkgrp = false;
	mx.lidxarr = [];
	mx.sumCheck = function(chkobj){
		var valarr = chkobj.val().split('_');
		var grpidx = valarr[0];
		var lidx = valarr[1];

		if(chkobj.is(':checked') == true ){

			if (mx.chkgrp == true ){
				alert("통합된 경기가 이미 선택되었습니다. 통합항목을  해제 후 선택하십시오.");
				chkobj.attr("checked", false);
				return;
			}

			//라운드, 심판수, 난의율, 날짜 오전/오후 빈값이 있다면 리턴
			if ( $('#rd_'+lidx).val() == '' || $('#j_'+lidx).val() == '' || $('#d_'+lidx).val() == '' || $('#gamedate_'+lidx).val() == '' || $('#ap_'+lidx).val() == '' ) {
				alert('라운드, 심판수, 난이율, 날짜, 오전오후 에 값 중 비어있는 값을 채운 후 이용하여 주십시오.');
				chkobj.attr("checked", false);
				return;
			}
			//라운드수를 동일하게 맞춘후 사용할수 있도록 메시지
			for (var i = 0 ;i < mx.lidxarr.length ; i++){
				if ( $('#rd_'+lidx).val() != $('#rd_'+mx.lidxarr[i]).val() ) {
					chkobj.attr("checked", false);
					alert("통합할 경기들의 라운드를 동일하게 하시고 이용해 주십시오.");
					return;
				}
			}


			mx.lidxarr.push(lidx);
			if ( grpidx != '')	{
				mx.chkgrp = true; //그룹아이디 선택됨
			}

		}

		else{
			mx.removeItemOnce(mx.lidxarr, lidx);
			if ( grpidx != '')	{
				mx.chkgrp = false; //그룹아이디 해제됨
			}
		}

		console.log(mx.lidxarr);
		console.log("그룹인덱스" + grpidx + " 부인덱스" + lidx );
	};
///////////////////////////////////////////


mx.sumGame = function(){
	//선택항목 경기통합.
	//선택된 항목이 2개이상
	if (mx.lidxarr.length < 2 ){
		alert('통합할 항목을 2개 이상 선태해 주십시오. 해제항목이라면 해제버튼을 눌러주세요.');
		return;
	}
	if (!confirm("통합시 심판배정정보는 초기화 됩니다. 통합하시겠습니까?")) {
		return;
	}
	
	//경고메시지 (경기순서는 그냥 두자) 라운드, 심판수, 난의율, 날짜가 동일하게 변경됩니다.
    var obj = {};
    obj.CMD =   mx.CMD_SUMBOO;
	obj.LIDXARR = mx.lidxarr;
	mx.SendPacket(null , obj);	
};

mx.divGame = function(tidx){
	if (mx.lidxarr.length == 0 || mx.lidxarr.length > 1  ){
		alert('통합된 항목을 선택해 주십시오.');
		return;
	}

	if (!confirm("선택항목 해제시 심판배정정보는 해제됩니다.")) {
		return;
	}

    var obj = {};
    obj.CMD =   mx.CMD_DIVBOO;
	obj.TIDX = tidx;
	obj.LIDX = mx.lidxarr[0];
	mx.SendPacket(null , obj);		
};


mx.getGameList = function(sender,lidx,ampm, gubun){ //gubunam gubunpm 오전 오후에 각 예선 결승 구분값
	var obj = {};
	obj.CMD = mx.CMD_GETGAMELIST;
	obj.AMPM = ampm;
	obj.LIDX =lidx;
	obj.GUBUN = gubun;
	mx.SendPacket(sender, obj);
};

//응답##################################################################
mx.OndrowHTML =  function(cmd, packet, html, sender){
	if( sender == "modalB" ){
		if( $('#modalB').length == 0 ){
			$('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
		}
		document.getElementById("modalB").innerHTML = html;
		$('#modalB').modal('show');
	}
	else{
		$( "#" + sender ).fadeIn( "slow", function() {
			document.getElementById(sender).innerHTML = html;
		});

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


