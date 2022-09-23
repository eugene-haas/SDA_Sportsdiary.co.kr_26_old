var mx = mx || {};
////////////////////////////////////////
mx.CMD_DATAGUBUN = 10000;
mx.CMD_CREATE = 100;
mx.CMD_READ = 20000;
mx.CMD_UPDATE = 200;
mx.CMD_DELETE = 300;
////////////////////////////////////////



mx.ajaxurl = "/api/req/reqSportsOrg.asp";
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
			htmldata = data;
		}
	}
	else {
		if (typeof data == 'string') { jsondata = JSON.parse(data); }
		else { jsondata = data; }
	}

	if (jsondata != '' && jsondata != null) {
		switch (Number(jsondata.result)) {
			case 0: break;
			case 100: return; break; //메시지 없슴
			case 111: alert(jsondata.servermsg); return; break;
				return; break;
		}
	}

	switch (Number(reqcmd)) {
		case mx.CMD_READ: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
		case mx.CMD_DELETE:
		case mx.CMD_UPDATE:
		case mx.CMD_CREATE: window.location.reload(); break;
	}
};


//요청##################################################################
mx.input_frm = function (lastno) {
	var obj = {};
	obj.CMD = mx.CMD_CREATE;
	obj.ETBLIDX = $('#EvalTableIDX').val();
	//종목 개인[단체] 성별 부서 세부종목
	obj.PARR = new Array();

	var allidarr = [];
	for (var x = 0; x < lastno; x++) {
		allidarr[x] = "mk_g" + x;
	}

	for (var i = 0; i < allidarr.length; i++) {
		obj.PARR[i] = $("#" + allidarr[i]).val();
	}

	var msgarr = [];
	for (var x = 0; x < lastno; x++) {
		msgarr[x] = "";
	}
	//체크할항목
	msgarr[0] = "평가군을 선택해 ";
	msgarr[1] = "회원군을 선택해 ";
	msgarr[2] = "종목단체명을 입력해 ";

	var passarrno = []; //체크메시지 통과여부 플레그 0패스 1체크
	for (var x = 0; x < lastno; x++) {
		passarrno[x] = 0;
	}
	//체크할항목
	passarrno[0] = 1;
	passarrno[1] = 1;
	passarrno[2] = 1;

	for (var i = 0; i < obj.PARR.length; i++) {
		if (passarrno[i] == 1) {
			if (px.chkValue(obj.PARR[i], msgarr[i]) == false) {
				$("#" + allidarr[i]).focus();
				return;
			}
		}
	}
	mx.SendPacket(null, obj);
};


mx.input_edit = function (idx) {
	$("#contest tr").css("background-color", "white");
	$("#titlelist_" + idx).css("background-color", "#BFBFBF");

	var obj = {};
	obj.CMD = mx.CMD_READ;
	obj.IDX = idx;
	obj.ETBLIDX = $('#EvalTableIDX').val();
	mx.SendPacket('gameinput_area', obj);
};

mx.update_frm = function (lastno) {
	if ($('#e_idx').val() == undefined) {
		alert("목록에서 대상을 선택해 주세요.");
		return;
	}

	var obj = {};
	obj.CMD = mx.CMD_UPDATE;
	obj.ETBLIDX = $('#EvalTableIDX').val();
	//종목 개인[단체] 성별 부서 세부종목
	obj.PARR = new Array();

	var allidarr = [];
	for (var x = 0; x < lastno; x++) {
		allidarr[x] = "mk_g" + x;
	}
	allidarr[x] = "e_idx";

	var chkboxidarr = []; //체크박스의 아이디들


	for (var i = 0; i < allidarr.length; i++) {
		obj.PARR[i] = $("#" + allidarr[i]).val();
	}

	var msgarr = [];
	for (var x = 0; x < lastno; x++) {
		msgarr[x] = "";
	}

	//체크할항목
	msgarr[0] = "평가군을 선택해 ";
	msgarr[1] = "회원군을 선택해 ";
	msgarr[2] = "종목단체명을 입력해 ";

	var passarrno = []; //체크메시지 통과여부 플레그 0패스 1체크
	for (var x = 0; x < lastno; x++) {
		passarrno[x] = 0;
	}
	//체크할항목
	passarrno[0] = 1;
	passarrno[1] = 1;
	passarrno[2] = 1;

	for (var i = 0; i < obj.PARR.length; i++) {
		if (passarrno[i] == 1) {
			if (px.chkValue(obj.PARR[i], msgarr[i]) == false) {
				$("#" + allidarr[i]).focus();
				return;
			}
		}
	}
	mx.SendPacket(null, obj);
};


mx.del_frm = function () {
	var obj = {};
	obj.CMD = mx.CMD_DELETE;
	obj.IDX = $("#e_idx").val();
	obj.ETBLIDX = $('#EvalTableIDX').val();

	if (obj.IDX == undefined) {
		alert("목록에서 대상을 선택해 주세요.");
		return;
	}

	if (confirm('대상을 삭제하시겠습니까?')) {
		mx.SendPacket('titlelist_' + obj.IDX, obj);
	} else {
		return;
	}
};


//응답##################################################################

mx.OndrowHTML = function (cmd, packet, html, sender) {
	document.getElementById(sender).innerHTML = html;
};

