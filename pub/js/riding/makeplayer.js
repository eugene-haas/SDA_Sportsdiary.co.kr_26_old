var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_AUTOCOMPLETE = 100;
	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
	mx.CMD_GAMEINPUT = 30001;
	mx.CMD_GAMEINPUTEDIT = 30002; //수정
	mx.CMD_GAMEINPUTEDITOK = 30003;
	mx.CMD_GAMEINPUTDEL = 30004;// 삭제
	mx.CMD_FINDPLAYER = 30008;

	mx.CMD_DELOK = 201;
	mx.CMD_PROCESSRESULT = 40013;

	mx.CMD_MEMBERWINDOW = 60000; //회원검색팝업
	mx.CMD_FINDMEMBER = 60001; //회원검색후 리스트 표시
    mx.CMD_COPYPLAYER = 400;
////////////////////////////////////////



mx.IsHttpSuccess = function( r ){
	try{
		return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
	}
	catch(e){}
	return false;
};

mx.HttpData = function( r, type ){
	var ct = r.getResponseHeader( "Content-Type" );
	var data = !type && ct && ct.indexOf( "xml" ) >=0;
	data = type == "xml" || data ? r.responseXML : r.responseText;
	if( type == "script" ){
		eval.call( "window", data );
	}
	else if( type == "mix" ){
		if ( data.indexOf("$$$$") !== -1 ){
			var mixdata = data.split( "$$$$" );
			( function () { eval.call("window", mixdata[0]); } () );
			data = mixdata[1];
		}
	}
	return data;
};

//innerHTML 로딩 시점을 알기위해 추가
mx.waitUntil = function (fn, condition, interval) {
    interval = interval || 100;

    var shell = function () {
            var timer = setInterval(
                function () {
                    var check;

                    try { check = !!(condition()); } catch (e) { check = false; }

                    if (check) {
                        clearInterval(timer);
                        delete timer;
                        fn();
                    }
                },
                interval
            );
        };

    return shell;
};

//동일한 패킷이 오는경우 (막음 처리해야겠지)
mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqMakePlayer.asp";
mx.SendPacket = function( sender, packet){
	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = mx.ajaxurl;
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	setTimeout( function(){ reqdone = true; }, timeout );

    //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
	//	apploading("AppBody", "로딩 중 입니다.");
	//}

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){

				//if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
				//	$('#AppBody').oLoader('hide');
				//}

				mx.ReceivePacket( reqcmd, mx.HttpData( xhr, datatype ), sender );
				return true;
			}
			xhr = null;
		}
	};
	console.log(JSON.stringify( packet  ) );
	xhr.send( strdata );
};

mx.ReceivePacket = function( reqcmd, data, sender ){// data는 response string
	var rsp = null;
	var callback = null;
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
		switch (Number(jsondata.result))	{
		case 0:	break;
		case 1:	alert('데이터가 존재하지 않습니다.');return; 	break;
		case 2:	alert('이미 신청된 사용자가 있습니다.');return; 	break;
		case 3:	alert('등록되지 않은 선수가 존재합니다.');return; 	break;

		case 3100: alert('오픈부랭킹이 설정되었습니다.');return; 	break;
		case 3101: alert('승급자로 설정되었습니다.');
		$('#hiddensbtn').click();
		return; 	break;
		case 3102: alert('전체 초기화 되었습니다.');return; 	break;
		case 3103: alert('동일이름의 포인트가 모두 합쳐졌습니다..');return; break;
		case 3104:
			alert('승급자로 설정되었습니다(외부경기).');
		//if (jsondata.pidx != "0"){
		$('#hiddensbtn').click(); //$("#hiddenSetrank_" + jsondata.pidx).click();
		//}
		return; 	break;



		case 3105: alert('외부랭커포인트 날짜지정이 설정되었습니다.'); $("#myModal").modal("hide"); $('#hiddensbtn').click(); return; break;
		case 3106: alert("ok"); return; break;

		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_COPYPLAYER:window.location.reload();	break;
	case mx.CMD_GAMEINPUT:	this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_CONTESTAPPEND:	this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_MEMBERWINDOW :
	case mx.CMD_FINDMEMBER :	this.OnRankHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_GAMEINPUTEDITOK:
	case mx.CMD_FINDPLAYER:
	case mx.CMD_GAMEINPUTDEL:	this.OndelHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_DELOK:
	case mx.CMD_WORKOK: return; break;



	}
};

mx.OndrowHTML2 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	alert("수정이 완료되었습니다.");
};



mx.OnRankHTML =  function(cmd, packet, html, sender){
	console.log(sender);
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
};

mx.OntableHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
};


mx.delOk = function(idx,trid){
  if (confirm("삭제 하시겠습니까?")) {
	$("#"+trid).remove();
	var obj = {};
	obj.CMD = mx.CMD_DELOK;
	obj.IDX = idx;
	mx.SendPacket(null, obj);
  }else{
    return;
  }
};


///////////////////////////////////////////////////
//선수정보를 가져온다.
mx.copyPlayer = function(){
	var obj = {};
	obj.CMD = mx.CMD_COPYPLAYER;
	mx.SendPacket(null, obj);	
};

mx.memberChoice = function(midx, uid,unm,uphone,ubirth,usex){
	$('#t_memberidx').val(midx);
	$('#t_userid').val(uid);
	$('#p1name').val(unm);
	$('#p1phone').val(uphone);
	$('#p1_birth').val(ubirth);
	$('#p1sex').val(usex);
	$('#myModal').modal('hide');
};


mx.findMember = function(st){
	var obj = {};
	obj.CMD = mx.CMD_MEMBERWINDOW;
	if (st == "find"){
		obj.NM = 	$('#membernm').val();
	}
	mx.SendPacket('myModal', obj);
};
///////////////////////////////////////////////////
mx.OnPopClose= function(cmd, packet, html, sender){
	$(sender).modal('toggle');
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;

	if(cmd == mx.CMD_FINDPLAYER  ||  cmd == mx.CMD_GAMEINPUTEDIT ){
		//alert(packet)
		localStorage.setItem('PINFO', JSON.stringify( packet  )); // mx.CMD_GAMEINPUTEDITOK "null" 초기화

		mx.gameinfo = packet;

		mx.init();
		if (cmd == mx.CMD_FINDPLAYER) {
			//{"CMD":30008,"findTYPE":"s_name","findSEX":"0","fndSTR":"생","PAGENO":1,"result":"0","lastchk":"_end","totalcnt":4,"totalpage":1}
			$("#totcnt").html(packet.totalcnt);
			$("#nowcnt").html(packet.totalpage);
		}
	}
};

mx.OndelHTML =  function(cmd, packet, html, sender){
	localStorage.removeItem('PINFO'); //초기화
	$("#totcnt").html(Number($("#totcnt").text()) - 1);
	$("#"+sender).remove();
};

mx.OnAppendHTML =  function(cmd, packet, html, sender){
	if ( packet.lastchk == "_end" ){return;}
	$("#nowcnt").html(packet.NKEY);
	packet.NKEY = Number(packet.NKEY) + 1;
	localStorage.setItem('MOREINFO', JSON.stringify( packet  ));
	$('#'+sender).append(html);
	$("body").scrollTop($("body")[0].scrollHeight);
};


mx.OnBeforeHTML =  function(cmd, packet, html, sender){
	if(html == '' ){
	alert("중복된 소속이 있습니다.");
	return;
	}

	$('.gametitle').first().before(html);
	$("#totcnt").html(Number($("#totcnt").text()) + 1);
};

////////////////////////////////////////
//목록 불러오기
////////////////////////////////////////
mx.contestMore = function(){

	var moreinfo = localStorage.getItem('MOREINFO'); //다음

	if (moreinfo == null)	{
		var nextkey = 2;
	}
	else{
		moreinfo = JSON.parse(moreinfo);
		var nextkey = moreinfo.NKEY;
	}
	var parmobj = {'CMD':mx.CMD_CONTESTAPPEND,'NKEY':nextkey};

	if(mx.gameinfo == null || mx.gameinfo == ""){
		parmobj.findTYPE = "";
		parmobj.findSEX = "";
		parmobj.fndSTR = "";
	}
	 else{
		if (mx.gameinfo.hasOwnProperty('fndSTR') == true){
			parmobj.findTYPE = mx.gameinfo.findTYPE;
			parmobj.findSEX = mx.gameinfo.findSEX;
			parmobj.fndSTR = mx.gameinfo.fndSTR;
		}
		else{
			parmobj.findTYPE = "";
			parmobj.findSEX = "";
			parmobj.fndSTR = "";
		}
	 }

	if( $("input:checkbox[id='winner']").is(":checked") == true ){
		parmobj.winner = 1;
	}

	mx.SendPacket('contest', parmobj);
};

////////////////////////////////////////
//일시적으로 팝업 보여줌
////////////////////////////////////////
mx.splashmsg = function(msg, deltime){
	$("#w_msg").html(msg);
	$(".warn_modal").modal("show");
	setTimeout(function(){$(".warn_modal").modal('hide');},deltime);
};


////////////////////////////////////////
//입력
////////////////////////////////////////
mx.input_frm = function(){

	if ($('#t_memberidx').val() == ''){
		mx.findMember	();
		return;
	}




	var obj = {};

	obj.CMD = mx.CMD_GAMEINPUT;


	obj.t_midx = $("#t_memberidx").val();
	obj.t_mid = $("#t_userid").val();

	obj.p1name = $("#p1name").val();
	obj.p1sex = $("#p1sex").val();
	obj.p1_birth = $("#p1_birth").val();
	obj.p1grade = $("#p1grade").val();
	obj.p1phone = $("#p1phone").val();



	p1TeamAutoCtl = $("#p1team").val();
	p2TeamAutoCtl = $("#p2team").val();
	obj.p1team1txt = $("#hiddenP1TeamNm").val();
	obj.p1team2txt = $("#hiddenP2TeamNm").val();
	obj.p1team1 = $("#hiddenP1Team").val();
	obj.p1team2 = $("#hiddenP2Team").val();
	obj.boo = $("#boo").val();

	if(p1TeamAutoCtl != obj.p1team1txt){
		$("#p1team").focus();
		alert("검색된 1팀 목록에서 선택해주세요");
		return ;
	}


	if (obj.p1name == ""){
		alert('등록선수를 입력해 주세요.');
		return;
	}

	mx.SendPacket(null, obj);
};


////////////////////////////////////////
//수정
////////////////////////////////////////
mx.input_edit = function(idx){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTEDIT;
	obj.IDX = idx;
	mx.SendPacket('player1', obj);
};

mx.update_frm = function(){
	var obj = {};

	var gameinfo = localStorage.getItem('PINFO');

	if (gameinfo == "" || gameinfo == null || gameinfo == "null"){
		alert("대상을 선택해 주십시오.");
		return;
	}
	obj.CMD = mx.CMD_GAMEINPUTEDITOK;

	if (obj.IDX	 == '' || $("#p1name").value == '' ){ //|| mx.gameinfo.NM != $("#p1name").val()
		alert("대상을 선택해 주세요. ");
		return;
	}
	obj.p1idx = mx.gameinfo.IDX;
	obj.p1name = $("#p1name").val();
	obj.p1sex = $("#p1sex").val();
	obj.p1_birth = $("#p1_birth").val();
	obj.p1grade = $("#p1grade").val();
	obj.p1phone = $("#p1phone").val();


	p1TeamAutoCtl = $("#p1team").val();
	p2TeamAutoCtl = $("#p2team").val();
	obj.p1team1txt = $("#hiddenP1TeamNm").val();
	obj.p1team2txt = $("#hiddenP2TeamNm").val();
	obj.p1team1 = $("#hiddenP1Team").val();
	obj.p1team2 = $("#hiddenP2Team").val();
	obj.boo = $("#boo").val();

	if(p1TeamAutoCtl != obj.p1team1txt){
		$("#p1team").focus();
		alert("검색된 1팀 목록에서 선택해주세요");
		return ;
	}

	if (p2TeamAutoCtl == ''){
		obj.p1team2txt = '';
		obj.p1team2 = '';
	}

	mx.SendPacket('titlelist_'+obj.p1idx, obj);
};


////////////////////////////////////////
//삭제
////////////////////////////////////////
mx.del_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTDEL;
	var gameinfo = localStorage.getItem('PINFO');
	if (gameinfo == "" || gameinfo == null || gameinfo == "null"){
		alert("대상을 선택해 주십시오.");
		return;
	}
	obj.IDX = mx.gameinfo.IDX;
	mx.SendPacket('titlelist_' + obj.IDX, obj);
};

////////////////////////////////////////
//검색
////////////////////////////////////////
mx.searchPlayer = function(){

	var obj = {};
	obj.CMD = mx.CMD_FINDPLAYER;
	obj.findTYPE = $("#fnd_Type").val();
	obj.findSEX = $("#fnd_SEX").val();
	obj.fndSTR = $("#fnd_Str").val();
	if( $("input:checkbox[id='winner']").is(":checked") == true ){
		obj.winner = 1;
	}
	obj.PAGENO = 1;
	mx.SendPacket('contest', obj);
};

////////////////////////////////////////
//검색
////////////////////////////////////////

mx.gameinfo;
mx.playerlist ;
$(document).ready(function(){
		localStorage.removeItem('PINFO');
		var gameinfo = localStorage.getItem('PINFO');
		mx.gameinfo = JSON.parse(gameinfo);
		mx.init();
});

mx.init = function(){
	$( "#p1team" ).autocomplete({
		source : function( request, response ) {
			teamOneCode = "";
			teamOneName ="";
			$.ajax({
						type: 'post',
						url: "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestTeamFind.asp",
						dataType: "json",
						data: { "REQ" : JSON.stringify({"CMD":mx.CMD_AUTOCOMPLETE, "SVAL":request.term}) },
						success: function(data) {
							//alert("data");
								//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
								response(
										$.map(data, function(item) {
												return {
													label: item.TeamName + "(" + item.TeamCode + ")",
													value: item.TeamName,
													code : item.TeamCode
												}
										})
								);
						}, error: function (xhr,status,error){
							alert("에러발생")
						}
			})
		},
		minLength : 1,
		select: function( event, ui ) {
			$( "#hiddenP1TeamNm" ).val(ui.item.value)
			$( "#hiddenP1Team" ).val(ui.item.code)
			}
	});

	$( "#p2team" ).autocomplete({
		source : function( request, response ) {
			teamTwoCode = "";
			teamTwoName ="";
			$.ajax({
				type: 'post',
				url: "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestTeamFind.asp",
				dataType: "json",
				data: { "REQ" : JSON.stringify({"CMD":mx.CMD_AUTOCOMPLETE, "SVAL":request.term}) },
				success: function(data) {
					//alert("data");
						//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
						response(
								$.map(data, function(item) {
										return {
											label: item.TeamName + "(" + item.TeamCode + ")",
											value: item.TeamName,
											code : item.TeamCode
										}
								})
						);
				}, error: function (xhr,status,error){
					alert("에러발생")
				}
			})
		},
		minLength : 1,
		select: function( event, ui ) {
			$( "#hiddenP2TeamNm" ).val(ui.item.value)
			$( "#hiddenP2Team" ).val(ui.item.code)
			}
	});
};

mx.contestResult = function(packet){
  if (confirm("대회결과가 바로 처리됩니다. 처리하시겠습니까?")) {
	var obj ={};
	obj.CMD = mx.CMD_PROCESSRESULT;
	obj.IDX = packet.IDX;
	obj.TIDX = packet.TIDX;
	obj.TITLE = packet.TITLE;
	obj.LEVELNO = packet.LEVELNO;
	obj.TeamNM = packet.TeamNM;
	obj.AreaNM = packet.AreaNM;
	mx.SendPacket('myModal', obj);
  }
  else{
	return;
  }
};

/////////////////////////////////////////////////////////
//클릭위치로 돌려놓기
$(document).ready(function(){
	$("#sc_body").scrollTop(localStorage.getItem('scrollpostion'));

	$("#sc_body").click(function(event){
		window.toriScroll = $("#sc_body").scrollTop();
		localStorage.setItem('scrollpostion',window.toriScroll);
		console.log(window.toriScroll);
	});
});


