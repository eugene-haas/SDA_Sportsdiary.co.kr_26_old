var mx = mx || {};
////////////////////////////////////////
mx.CMD_DATAGUBUN = 10000;

mx.CMD_GETGAMELIST = 11000;  //부별 선수목록리스트
mx.CMD_JUDGEWINDOW = 20010; //심사기록창
mx.CMD_CHANGEREFEREEWINDOW = 20008; //심판수정창
mx.CMD_CHANGEREFEREEOK = 75; //수정완료
mx.CMD_SETTKTOTALDEDUCTION = 78; //테크총감점(1라운드)
mx.CMD_SETELETOTALDEDUCTION = 80; //엘리먼트총감점 감점상태변경
mx.CMD_SETTOTALDEDUCTION = 82; //총감점 전체에서 감점
mx.CMD_SETELEDEDUCTION = 84; //엘리먼트 마다 0.5
mx.CMD_SETROUNDZEROAVG = 87; //0점 인원 평균값으로 만들기(심판이 판단해서)	
mx.CMD_SETROUNDOUT = 90; //실격상태변경
mx.CMD_SETTOTALOUT = 410; //실격사유선택
mx.CMD_SETROUNDVALUE = 420; //심판별 각라운드 점수 입력


mx.CMD_SETAPPYN = 630; //앱노출정보 저장
mx.CMD_SENDRESULT = 610; //실적전송




////////////////////////////////////////

mx.ajaxurl = "/pub/ajax/swimming/reqInputRecord_F2.asp";
mx.ajaxtype = "POST";
mx.dataType = "text";

mx.SendPacket = function (sender, packet) {
	console.log(px.strReplaceAll(JSON.stringify(packet), '\"', '\"\"'));
	var strdata = "REQ=" + encodeURIComponent(JSON.stringify(packet));
	$.ajax({
		url: mx.ajaxurl, type: mx.ajaxtype, data: strdata, dataType: mx.dataType,
		success: function (returnData) {
			mx.ReceivePacket(packet.CMD, returnData, sender)
		}
	});
};

mx.IsJsonString = function (str) {
	try {
		var json = JSON.parse(str);
		return (typeof json === 'object');
	} catch (e) {
		return false;
	}
};


mx.ReceivePacket = function (reqcmd, data, sender) {// data는 response string

	var jsondata = null;
	var htmldata = null;
	var resdata = null;


	if (Number(reqcmd) > mx.CMD_DATAGUBUN) {
		if (data.indexOf("`##`") !== -1) {
			resdata = data.split("`##`");
			jsondata = resdata[0];
			if (jsondata != '') { jsondata = JSON.parse(jsondata); }
			htmldata = resdata[1];
		}
		else {
			if (mx.IsJsonString(data)) {
				jsondata = JSON.parse(data);
			}
			else {
				htmldata = data;
			}
		}
	}
	else {
		if (typeof data == 'string') { jsondata = JSON.parse(data); }
		else { jsondata = data; }
	}

	if (mx.IsJsonString(data)) {
		switch (Number(jsondata.result)) {
			case 0: break;
			case 1: alert('데이터가 존재하지 않습니다.'); return; break;
			case 2: alert('동일한 데이터가 존재합니다.'); return; break;
			case 3: alert('참가신청 자가 있어 수정및 삭제가 불가능 합니다.'); return; break;
			case 4: alert('대회에 생성된 부서가 있어 복사할수 없습니다.'); return; break;
			case 5: alert('이미 등록된 날짜 입니다.'); return; break;
			case 6: alert('이미 등록된 경기입니다.'); return; break;
			case 7: alert('이미 등록된 경기입니다.'); return; break;
			case 8: alert('대진표 편성이 완료 되지 않았습니다.'); return; break;
			case 22: alert('요청 리스트가 없습니다.'); return; break;
			case 23: alert('심사한 내용이 있어 변경할 수 없습니다.'); return; break;
			case 24: alert('선택항목 중 통합된 경기가 있습니다. '); return; break;
			case 25: alert('변경하려눈 순서는 통합된 경기입니다. 해제 후 순서를 변경해 주십시오. '); return; break;
			case 28: alert('숫자가 경기숫자 번호를 범위를 초과하였습니다. '); return; break;
			case 99: alert('실적이 최종인증되어 실적에는 반영되지 않습니다.'); return; break;
			case 111: alert(jsondata.servermsg); return; break;
			case 500: alert('결승 경기에 진행된 값이 있어 초기화 하고 다시 설정할 수 없습니다.'); return; break;

			case 100: return; break; //메시지 없슴
				/*새로고침*/
				if ($("#tryouting").length > 0) { $('#tryouting').click(); }
				if ($("#tourning").length > 0) { $('#tourning').click(); }
			default: return; break;
				return; break;

		}
	}

	switch (Number(reqcmd)) {

		case mx.CMD_CHANGEREFEREEWINDOW:
		case mx.CMD_GETGAMELIST:
		case mx.CMD_JUDGEWINDOW: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;

		case mx.CMD_SETTOTALOUT: //실격(전체)
		case mx.CMD_SETTKTOTALDEDUCTION:
		case mx.CMD_SETELETOTALDEDUCTION: //엘리먼트총감점 감점상태변경
		case mx.CMD_SETTOTALDEDUCTION: //총감점 전체에서 감점
		case mx.CMD_SETROUNDOUT: //실격상태변경

			//return; break;  TEST
			this.getGameList('game_' + jsondata.LIDX, jsondata.LIDX, 'am', ''); break; //리스트 호출


		//case mx.CMD_SETROUNDVALUE : return; break;  TEST
		case mx.CMD_SETROUNDZEROAVG: //0점 인원 평균값으로 만들기(심판이 판단해서)
		case mx.CMD_SETELEDEDUCTION: //엘리먼트 마다 0.5	
		case mx.CMD_SETROUNDVALUE: //심판별 각라운드 점수 입력 (결과가 연산될수 있으므로 다시그릴필요있음)
			this.judgeWindow(jsondata.TIDX, jsondata.LIDX, jsondata.MIDX, jsondata.RNO); break;

		case mx.CMD_CHANGEREFEREEOK: $('#modalC').modal('hide'); this.judgeWindow(jsondata.TIDX, jsondata.LIDX, jsondata.MIDX, jsondata.RNO); break;
	}
};

//요청##################################################################

mx.setAppShow = function (btnnm, lidx) {
	var fld = "DAY1";
	switch ($('#' + btnnm).attr('class')) {
		case "btn btn-primary": $('#' + btnnm).attr('class', 'btn bg-yellow'); $('#' + btnnm).text('1차종료'); fld = "DAY1"; break;
		case "btn bg-yellow": $('#' + btnnm).attr('class', 'btn bg-green'); $('#' + btnnm).text('경기종료'); fld = "DAY2"; break;
		case "btn bg-green": $('#' + btnnm).attr('class', 'btn btn-primary'); $('#' + btnnm).text('경기전'); fld = ""; break;
	}

	var obj = {};
	obj.CMD = mx.CMD_SETAPPYN;
	obj.LIDX = lidx;
	obj.FLD = fld;
	mx.SendPacket(null, obj);
};

mx.sendResult = function (lidx, itgubun) { //결승 레인배정
	//'게임번호,  tblRGameLevel.RGameLevelidx, 오전오후(am,pm) , l_gubun(예선, 결승 , 1, 3)
	if (confirm("실적을 전송 하시겠습니까?")) {
		var obj = {};

		$("#btn4_" + lidx).attr('class', 'btn btn-warning');
		$("#btn4_" + lidx).text("실적전송(완료)");


		obj.CMD = mx.CMD_SENDRESULT;
		obj.LIDX = lidx;
		obj.ITGUBUN = itgubun; //개인, 단체
		mx.SendPacket('modalB', obj);
	}
};

mx.setRoundZeroAvg = function (tidx, lidx, midx, roundno, judgeno, setvalue) { //0점 인원 평균값으로 만들기(심판이 판단해서)

	var msg = "평균점으로 0점을 처리하시겠습니까 복구되지 않습니다.?";
	if (!confirm(msg)) {
		return;
	}

	var obj = {};
	obj.CMD = mx.CMD_SETROUNDZEROAVG;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;
	obj.RNO = roundno;
	mx.SendPacket(null, obj);
};



//소수점 자동생성
mx.setValueCheckE2 = function (inputobj) {
	var invalue = inputobj.value.replace('.', '');
	if (Number(invalue) > 100) {
		inputobj.value = '10.0';
		return;
	}
	if (invalue.length > 3) {
		invalue = invalue.substring(0, 3);
	}

	if (invalue.length > 1) {
		inputobj.value = invalue.substring(0, invalue.length - 1) + "." + invalue.slice(-1);
	}
	else {
		inputobj.value = inputobj.value;
	}
	return;
};

mx.setRoundValue = function (tidx, lidx, midx, roundno, cdc, judgeno, setvalue) { //심판이 주는 각점수
	//그냥 보내 안에서 체크하고 말자.
	if (setvalue > 10) {
		alert("10점 이상 점수가 줄 수 없습니다.");
		return;
	}
	var invalue = setvalue.replace('.', '');
	//	if (invalue.length < 3){
	//		alert("3자리 숫자이상 입력해주세요.");
	//		return;
	//	}

	var obj = {};
	obj.CMD = mx.CMD_SETROUNDVALUE;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;
	obj.RNO = roundno;
	obj.CDC = cdc;
	obj.JNO = judgeno;
	obj.SETVAL = setvalue;
	mx.SendPacket(null, obj);
};

//실격사유(전체)
mx.setTotalOut = function (tidx, lidx, midx, roundno, setvalue) {
	var obj = {};
	obj.CMD = mx.CMD_SETTOTALOUT;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;
	obj.RNO = roundno;
	obj.SETVAL = setvalue;
	mx.SendPacket(null, obj);
};


//테크(1라운드) 총감점
mx.setTkTotalDeduction = function (tidx, lidx, midx, roundno, btnstate) {//감점
	var msg = "감점 처리하시겠습니까?";
	if (btnstate == "danger") {
		msg = "감점 처리를 해제하시겠습니까?";
	}

	if (!confirm(msg)) {
		return;
	}

	var obj = {};
	obj.CMD = mx.CMD_SETTKTOTALDEDUCTION;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;
	obj.RNO = roundno;
	obj.BTNST = btnstate;
	mx.SendPacket(null, obj);
};

//엘리먼트 총감점
mx.setEleTotalDeduction = function (tidx, lidx, midx, roundno, btnstate) {//감점
	var msg = "감점 처리하시겠습니까??";
	if (btnstate == "danger") {
		msg = "감점 처리를 해제하시겠습니까??";
	}

	if (!confirm(msg)) {
		return;
	}

	var obj = {};
	obj.CMD = mx.CMD_SETELETOTALDEDUCTION;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;
	obj.RNO = roundno;
	obj.BTNST = btnstate;
	mx.SendPacket(null, obj);
};

//전체점수감점
mx.setTotalDeduction = function (tidx, lidx, midx, roundno, setvalue) {//감점
	var msg = "감점 처리하시겠습니까?";
	if (setvalue == 0) {
		msg = "감점 처리를 해제하시겠습니까?";
	}

	if (!confirm(msg)) {
		return;
	}

	var obj = {};
	obj.CMD = mx.CMD_SETTOTALDEDUCTION;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;
	obj.RNO = roundno;
	obj.SETVAL = setvalue;
	mx.SendPacket(null, obj);
};

//각엘리먼트 감점
mx.setEleDeduction = function (tidx, lidx, midx, roundno, btnstate) {//감점
	var msg = "감점 처리하시겠습니까?";
	if (btnstate == "danger") {
		msg = "감점 처리를 해제하시겠습니까?";
	}

	if (!confirm(msg)) {
		return;
	}

	var obj = {};
	obj.CMD = mx.CMD_SETELEDEDUCTION;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;
	obj.RNO = roundno;
	obj.BTNST = btnstate;
	mx.SendPacket(null, obj);
};


mx.setRoundOut = function (tidx, lidx, midx, roundno, btnstate) {//실격
	var msg = "실격 처리하시겠습니까?";
	if (btnstate == "danger") {
		msg = "실격 처리를 해제하시겠습니까?";
	}
	if (!confirm(msg)) {
		return;
	}

	var obj = {};
	obj.CMD = mx.CMD_SETROUNDOUT;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;
	obj.RNO = roundno;
	obj.BTNST = btnstate;
	mx.SendPacket(null, obj);
};

mx.judgeWindow = function (tidx, lidx, midx, roundno) { //심사기록창
	var obj = {};
	obj.CMD = mx.CMD_JUDGEWINDOW;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.MIDX = midx;
	obj.RNO = roundno;
	mx.SendPacket('modalB', obj);
};

mx.changeJudge = function (tidx, lidx, myfldno, jidx) { //심판수정
	var obj = {};
	obj.CMD = mx.CMD_CHANGEREFEREEWINDOW;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.MYFLDNO = myfldno;
	obj.JIDX = jidx;
	mx.SendPacket('modalC', obj);
};

mx.changeJudgeOK = function (tidx, lidx, jidx, targetjidx, myfldno, targetfldno) { //심판수정
	if (targetfldno != '') {
		if (!confirm("동일부의 심판입니다. 심판과 심사위치가 변경됩니다. 전행하시겠습니까?")) {
			return;
		}
	}
	var obj = {};
	obj.CMD = mx.CMD_CHANGEREFEREEOK;
	obj.TIDX = tidx;
	obj.LIDX = lidx;
	obj.JIDX = jidx;
	obj.TARGETJIDX = targetjidx;
	obj.MYFLDNO = myfldno;
	obj.TARGETFLDNO = targetfldno;

	obj.MIDX = $('#modal_MIDX').val();
	obj.RNO = $('#modal_RNO').val();
	mx.SendPacket('modalB', obj);
};

mx.getGameList = function (sender, lidx, ampm, gubun) { //gubunam 오전(고정) tryout 사용 
	var obj = {};
	obj.CMD = mx.CMD_GETGAMELIST;
	obj.AMPM = ampm;
	obj.LIDX = lidx;
	obj.GUBUN = gubun;
	mx.SendPacket(sender, obj);
};

//응답##################################################################
mx.OndrowHTML = function (cmd, packet, html, sender) {
	if (sender == "modalB") {
		if ($('#modalB').length == 0) {
			$('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
		}
		document.getElementById("modalB").innerHTML = html;
		$('#modalB').modal('show');
	}
	else if (sender == "modalC") {
		if ($('#modalC').length == 0) {
			$('body').append("<div id='modalC' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel' style='z-index:4000'></div>");
		}
		document.getElementById("modalC").innerHTML = html;
		$('#modalC').modal('show');
	}
	else {
		$("#" + sender).fadeIn("slow", function () {
			document.getElementById(sender).innerHTML = html;
		});

	}
};



//클릭위치로 돌려놓기
$(document).ready(function () {
	//var offset = $("#div" + seq).offset();
	$('html, body').animate({ scrollTop: localStorage.getItem('scrollpostion') }, 400);
	$(document).click(function (event) {
		window.toriScroll = $(document).scrollTop();
		localStorage.setItem('scrollpostion', window.toriScroll);
		console.log(window.toriScroll);
	});

});


