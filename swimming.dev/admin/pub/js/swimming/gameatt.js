var mx = mx || {};
////////////////////////////////////////
mx.CMD_DATAGUBUN = 10000;


mx.CMD_SENDSMS = 100;
mx.CMD_CHECKSMS = 200;
mx.CMD_SETMLIST = 300;
mx.CMD_SETBLIST = 400;
mx.CMD_DELKIND = 500;

mx.CMD_SETREFUND = 600; //결제취소요청


mx.CMD_MLIST = 11000; //선수 리스트
mx.CMD_BOOLIST = 12000; //부목록

mx.CMD_PAYCANCELLIST = 13000;// 취소처리팝업
mx.CMD_PRINT = 60001; //인쇄

mx.CMD_SETOK = 700; //다이빙 ,아티스틱 단체 명수 체크
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqHome.asp";
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
			case 3: alert('지도자로 등록된 사용자가 아닙니다. 대한 체육회에 등록 후 이용하여 주십시오.'); return; break;
			case 4: alert('인증번호가 틀립니다. 정확히 입력하여 주십시오.'); return; break;
			case 8: alert(jsondata.msg); return; break;
			case 100: return; break; //메시지 없슴
			case 111: alert(jsondata.servermsg); return; break;
				return; break;
		}
	}

	switch (Number(reqcmd)) {
		case mx.CMD_DELKIND: $('#' + sender).remove(); return; break;

		case mx.CMD_SENDSMS: this.OnMsg(reqcmd, jsondata, htmldata, sender); break;
		case mx.CMD_CHECKSMS: this.OnCheck(reqcmd, jsondata, htmldata, sender); break;

		case mx.CMD_SETREFUND:
		case mx.CMD_SETBLIST:
		case mx.CMD_SETMLIST:
		case mx.CMD_GAMEINPUTDEL:
		case mx.CMD_GAMEINPUTEDITOK:
		case mx.CMD_GAMEINPUT: window.location.reload(); break;

		case mx.CMD_PAYCANCELLIST:
		case mx.CMD_MLIST:
		case mx.CMD_BOOLIST:
		case mx.CMD_GAMEINPUTEDIT: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;

		case mx.CMD_PRINT: this.OnPrint(reqcmd, jsondata, htmldata, sender); break;

		case mx.CMD_SETOK: this.goSubmit(jsondata.TEAM); break;
	}
};


//요청##################################################################
mx.print = function (tidx, teamcd) {
	var obj = {};
	obj.CMD = mx.CMD_PRINT;
	obj.TIDX = tidx;
	obj.TCD = teamcd;
	mx.SendPacket(null, obj);
};

//취소요청
mx.setRefundinfo = function (oidx) {
	var obj = {};
	obj.CMD = mx.CMD_PAYCANCELLIST;
	obj.OIDX = oidx;
	mx.SendPacket('cancelbody', obj);
};


mx.setRefund = function (oidx, paytype) {
	var obj = {};
	obj.CMD = mx.CMD_SETREFUND;
	obj.OIDX = oidx;
	obj.PAYTYPE = paytype;

	switch (paytype) {
		case "Card": break;
		case "DirectBank": break;
		case "VBank":
			var rnm = $('#refundnm').val();
			var rbnk = $('#refundbank').val();
			var rno = $('#refundno').val();

			if (rnm == "") {
				alert("성명을 입력해 주십시오.,");
				return;
			}
			if (rbnk == "") {
				alert("은행명을 입력해 주십시오.,");
				return;
			}
			if (rno == "") {
				alert("계좌번호를 입력해 주십시오.,");
				return;
			}

			obj.RNM = rnm;
			obj.RBNK = rbnk;
			obj.RNO = rno;
			break;
		case "HPP":
			break;
	}

	mx.SendPacket('cancelbody', obj);
}

//인증
mx.SMS = function () {
	var obj = {};
	obj.CMD = mx.CMD_SENDSMS;
	obj.NM = $('#nm').val();
	obj.PNO = $('#pno').val();
	obj.TIDX = $('#tidx').val();
	mx.SendPacket(null, obj);
};

//확인
mx.chkSMS = function () {
	var obj = {};
	obj.CMD = mx.CMD_CHECKSMS;
	obj.CHKNO = $('#chkno').val();
	mx.SendPacket(null, obj);
};

mx.fileCheck = function (file) {
	// 사이즈체크
	var maxSize = 5 * 1024 * 1024;    //5MB
	var fileSize = 0;

	// 브라우저 확인
	var browser = navigator.appName;

	// 익스플로러일 경우
	if (browser == "Microsoft Internet Explorer") {
		var oas = new ActiveXObject("Scripting.FileSystemObject");
		fileSize = oas.getFile(file.value).size;
	}
	// 익스플로러가 아닐경우
	else {
		fileSize = file.files[0].size;
	}

	//alert("파일사이즈 : "+ fileSize +", 최대파일사이즈 : 5MB");
	//return false;

	if (fileSize > maxSize) {
		alert("첨부파일 사이즈는 5MB 이내로 등록 가능합니다.    ");
		return false;
	}
	else {
		return true;
	}

};



mx.fileUpload = function () {
	//폼전체를 보낼때
	//게임코드 , 팀코드, 팀명칭
	$('#f_teamcd').val($('#teamnm').val());
	$('#f_teamnm').val($('#teamnm option:selected').text());


	var form = $('#FILEFORM')[0];
	var formData = new FormData(form);
	var fileext = mx.getExtensionOfFilename(form.inpFileApply.value);


	if (mx.fileCheck($('#FILEFORM')[0].inpFileApply) == false) { //파일크기 체크
		return false;
	}

	//console.log(fileext);
	if (fileext != ".txt" && fileext != ".pdf" && fileext != ".jpg" && fileext != ".hwp" && fileext != ".png") {
		alert("허용되지 않는 파일입니다.")
		return;
	}

	//객체만들어서 하나씩 담을때
	$.ajax({
		url: '/pub/up/scUpload.asp',
		processData: false,
		contentType: false,
		data: formData,
		type: 'POST',
		success: function (rdata) {
			alert("학교장 확인서가 업로드 되었습니다.");
			$('#recomfile').html(rdata);
		}
	});
};


mx.fileUpload2 = function () {
	//폼전체를 보낼때
	//게임코드 , 팀코드, 팀명칭
	$('#f_teamcd2').val($('#teamnm').val());
	$('#f_teamnm2').val($('#teamnm option:selected').text());


	var form = $('#FILEFORM2')[0];
	var formData = new FormData(form);
	var fileext = mx.getExtensionOfFilename(form.inpFileApply2.value);


	if (mx.fileCheck($('#FILEFORM2')[0].inpFileApply2) == false) { //파일크기 체크
		return false;
	}



	//console.log(fileext);
	if (fileext != ".txt" && fileext != ".pdf" && fileext != ".jpg" && fileext != ".hwp" && fileext != ".png") {
		alert("허용되지 않는 파일입니다.")
		return;
	}

	//객체만들어서 하나씩 담을때
	$.ajax({
		url: '/pub/up/scUpload2.asp',
		processData: false,
		contentType: false,
		data: formData,
		type: 'POST',
		success: function (rdata) {
			alert("학교폭력처분이력부존재서약서가 업로드 되었습니다.");
			$('#recomfile2').html(rdata);
		}
	});
};




mx.getExtensionOfFilename = function (filename) {

	var _fileLen = filename.length;
	var _lastDot = filename.lastIndexOf('.');

	// 확장자 명만 추출한 후 소문자로 변경
	var _fileExt = filename.substring(_lastDot, _fileLen).toLowerCase();
	return _fileExt;
};

//참가선수 추가 /삭제
mx.setMemberList = function () {
	var obj = {};
	obj.CMD = mx.CMD_MLIST;
	obj.TIDX = $('#tidx').val();
	obj.LEADERIDX = $('#leaderidx').val();
	obj.TEAM = $('#teamnm').val();
	mx.SendPacket('playerlist', obj);
};

//참가선수설정
mx.setPlayer = function () {
	var el = $('#chekBoxModalPlayer00');
	var $checkTable = el.parents("Table");
	var $checkList = $checkTable.find("input[type='checkbox']");
	var varr = new Array();
	var len = $checkList.length;
	var x = 0;
	for (var i = 0; i < len; i++) {
		if ($checkList[i].checked == true && $('#' + $checkList[i].id).val() != null && $('#' + $checkList[i].id).val() != "on") {
			varr[x] = $('#' + $checkList[i].id).val();
			x++;
		}
	}

	var obj = {};
	obj.CMD = mx.CMD_SETMLIST;
	obj.TIDX = $('#tidx').val();
	obj.TEAM = $('#teamnm').val();
	obj.LEADERIDX = $('#leaderidx').val(); //리더 21.2.23 추가 
	obj.PIDXARR = varr;
	mx.SendPacket(null, obj);
};

//참가종목리스트
mx.setBooList = function (seq, cdbnm, sex, uclass, kno) {
	var obj = {};
	obj.CMD = mx.CMD_BOOLIST;
	obj.SEQ = seq;
	obj.SEX = sex;
	obj.CDBNM = cdbnm;
	obj.UC = uclass;
	obj.LEADERIDX = $('#leaderidx').val(); //리더 21.2.23 추가 
	obj.KNO = kno;
	obj.TIDX = $('#tidx').val();
	obj.TEAM = $('#teamnm').val();
	mx.SendPacket('boolist', obj);
};

mx.setCapno = function (capid, targetid) {
	var targetval = $('#' + targetid).val();
	var capval = $('#' + capid).val();

	targetval = targetval.split('#')[0];
	$('#' + targetid).val(targetval + '#' + capval);
};

//참가부설정
mx.setBoo = function (kno) {
	var el = $('#chekBoxModalPlayertype00');
	var $checkTable = el.parents("Table");
	var $checkList = $checkTable.find("input[type='checkbox']");
	var varr = new Array();
	var groupcnt = 0;
	var len = $checkList.length;
	var x = 0;
	for (var i = 0; i < len; i++) {
		if ($checkList[i].checked == true && $('#' + $checkList[i].id).val() != null && $('#' + $checkList[i].id).val() != "on") {
			varr[x] = $('#' + $checkList[i].id).val();

			console.log(i + '' + $('#itgubun_' + i).val());
			if ($('#itgubun_' + i).val() == 'T') {
				groupcnt++;
			}
			x++;
		}
	}

	var obj = {};
	obj.CMD = mx.CMD_SETBLIST;
	obj.CHKSEQ = $('#check_seq').val();
	obj.TIDX = $('#tidx').val();
	obj.TEAM = $('#teamnm').val();
	obj.LIDXARR = varr;
	obj.GROUPCNT = groupcnt;
	obj.KNO = kno; //종목 번호
	obj.LEADERIDX = $('#leaderidx').val(); //리더 21.2.23 추가 
	mx.SendPacket(null, obj);
};

mx.delKind = function (seq, cdcnm, delid) {
	//$('#'+delid).remove();
	var obj = {};
	obj.CMD = mx.CMD_DELKIND;
	obj.SEQ = seq;
	obj.CDCNM = cdcnm;
	mx.SendPacket(delid, obj);
};

mx.goSubmit = function (teamcd) {
	px.goSubmit({ 'F1': teamcd }, 'apply-parti__pay.asp');
};

mx.wOK = function (tidx, leaderidx, chkstr, teamcd) {
	//첨부파일체크
	if ($('#recomfile').html() == '') {
		alert("첨부파일이 존재하지 않습니다.");
		return;
	}
	if ($('#recomfile2').html() == '') {
		alert("첨부파일이 존재하지 않습니다.");
		return;
	}

	//출전정보 있는지 체크
	if (chkstr == '') {
		alert("출전 정보를 생성해 주십시오.");
		return;
	}

	//시나리오 바로 일딴 api로 던져서 듀엣이나 팀 (E2, F2 가 정상인지 확인 하고 던져서 가져오자...)
	var obj = {};
	obj.CMD = mx.CMD_SETOK;
	obj.TIDX = tidx;
	obj.LEADERIDX = leaderidx;
	obj.TEAM = teamcd;
	mx.SendPacket(null, obj);


	//px.goSubmit({ 'F1': teamcd }, 'apply-parti__pay.asp');
};




//응답##################################################################
mx.OnPrint = function (cmd, packet, html, sender) {
	$('#printdiv').html(html);
	$('#printdiv').printThis({ importCSS: false, loadCSS: '', header: false, afterPrint: mx.afterPrint });
};

mx.OnMsg = function (cmd, packet, html, sender) {
	alert("인증 번호가 전송되있습니다.");
};
mx.OnCheck = function (cmd, packet, html, sender) {
	px.goSubmit({}, '/home/page/apply-parti.asp');
};


mx.OndrowHTML = function (cmd, packet, html, sender) {
	document.getElementById(sender).innerHTML = html;
	if (cmd == mx.CMD_MLIST) {
		$('#player-listModal').fadeIn(300);
		$('body').addClass('s_no-scroll');
	}
	if (cmd == mx.CMD_BOOLIST) {
		$('#player-selc-typeModal').fadeIn(300);
		$('body').addClass('s_no-scroll');
	}
	if (cmd == mx.CMD_PAYCANCELLIST) {
		$('#paycancel').fadeIn(300);
		$('body').addClass('s_no-scroll');
	}
};


$(document).ready(function () {

});


////////////////////////////////////////////////////////////////
