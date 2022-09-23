var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_AUTOCOMPLETE = 100;
	mx.CMD_SETSTATE = 120;

	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
	mx.CMD_GAMEINPUT = 30001;
	mx.CMD_GAMEINPUTEDIT = 30002; //수정
	mx.CMD_GAMEINPUTEDITOK = 30003;
	mx.CMD_GAMEINPUTDEL = 30004;// 삭제
	//mx.CMD_FIND1 = 30005;
	//mx.CMD_FIND2 = 30006;
	mx.CMD_GAMEAUTO = 30007;
	mx.CMD_FINDPLAYER = 30008;
	//mx.CMD_FINDRANK = 30009;
	mx.CMD_RANKINGINPUT = 30010;
	mx.CMD_RANKPOINT = 30011;
	mx.CMD_RANKINGINPUTEDIT = 30012;

	mx.CMD_INFOCHANGE = 40000;
	mx.CMD_HELP = 40001;
	mx.CMD_WORKOK = 200;
	mx.CMD_DELOK = 201;
	mx.CMD_PLAYEREDITOK = 50001;

	mx.CMD_OPENRNK = 300; //오픈부 랭킹반영부서
	mx.CMD_UPGRADE = 400; //승급자설정
	mx.CMD_RESETUP = 500; //승급자 전체정보 리셋


	mx.CMD_RNKBOO = 202; //랭킹에 반영될 부

	mx.CMD_SUMPPOINT = 40002; //포인트 합치기
	mx.CMD_SUMPPOINTOK = 600;

	mx.CMD_SETRANKER = 40012;
	mx.CMD_SETRANKEROK = 610;
	mx.CMD_PROCESSRESULT = 40013;



	mx.CMD_MEMBERWINDOW = 60000; //회원검색팝업
	mx.CMD_FINDMEMBER = 60001; //회원검색후 리스트 표시
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
mx.ajaxurl = "/pub/ajax/RookieTennis/reqTennisMakePlayer.asp";
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
	//setTimeout( function(){ reqdone = true; }, timeout );

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
	case mx.CMD_SETSTATE: break;

	case mx.CMD_GAMEAUTO:
	case mx.CMD_GAMEINPUT:	this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_CONTESTAPPEND:	this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_RANKPOINT:	this.OnRankHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_MEMBERWINDOW :
	case mx.CMD_FINDMEMBER :

	case mx.CMD_SETRANKER:
	case mx.CMD_SUMPPOINT:
	case mx.CMD_HELP :
	case mx.CMD_INFOCHANGE:	this.OnRankHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_GAMEINPUTEDITOK:
	case mx.CMD_FINDPLAYER:
	case mx.CMD_RANKINGINPUT:
	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GAMEINPUTDEL:	this.OndelHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_DELOK:
	case mx.CMD_WORKOK: return; break;


	case mx.CMD_PLAYEREDITOK: 	this.OndrowHTML2( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_RNKBOO: return; break;
	}
};

mx.OndrowHTML2 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	alert("수정이 완료되었습니다.");
};



mx.OnRankHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
};

mx.OntableHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
};


mx.reqInfoChange = function(pageno){
	var obj = {};
	obj.CMD = mx.CMD_INFOCHANGE;
	obj.PAGENO = pageno;
	mx.SendPacket('myModal', obj);
};

mx.help = function(pageno){
	var obj = {};
	obj.CMD = mx.CMD_HELP;
	obj.HELPNO = 1;
	mx.SendPacket('myModal', obj);
};


mx.workok = function(idx,oo){
	var obj = {};
	obj.CMD = mx.CMD_WORKOK;
	obj.IDX = idx;
	if (oo.checked == true)
	{
		obj.OKVAL = 1;
	}
	else{
		obj.OKVAL = 0;
	}
	mx.SendPacket(null, obj);
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



mx.RankingPoint = function(idx, name){
	var obj = {};
	obj.CMD = mx.CMD_RANKPOINT;
	obj.IDX = idx;
	obj.NAME = name;
	mx.SendPacket('myModal', obj);
	//$('#myModal').modal('show');
};

///////////////////////////////////////////////////
/*mx.find1 = function(){
	var obj = {};
	obj.CMD = mx.CMD_FIND1;
	mx.SendPacket('level_form1', obj);
};*/


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
	if( cmd == mx.CMD_GAMEAUTO && Number(packet.AutoNo) > 0){
		$("#autono").val(packet.AutoNo);
		mx.SendPacket(null, packet);
	}
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
//자동생성
////////////////////////////////////////
mx.auto_frm = function(boonm){
	var obj = {};
	obj.CMD = mx.CMD_GAMEAUTO;

	obj.AutoNo =	$("#autono").val();
	mx.SendPacket(null, obj);
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

//	if(p2TeamAutoCtl != obj.p1team2txt){
//		$("#p2team").focus();
//		alert("검색된 2팀 목록에서 선택해주세요");
//		return ;
//	}



	if (obj.p1name == ""){
		alert('등록선수를 입력해 주세요.');
		//mx.splashmsg('등록선수를 입력해 주세요.',1500);
		return;
	}

	mx.SendPacket(null, obj);
};

mx.edit_Ranking = function(playerIdx,teamGb,cnt){
	var obj = {};
	obj.CMD = mx.CMD_RANKINGINPUT;
	obj.IDX = playerIdx;
	obj.TEAMGB = teamGb;
	obj.TYPE = "update";
	var txtRankingName = "#txtRankingPoint" + cnt;
	obj.RANKINGPOINT = $(txtRankingName).val();
	mx.SendPacket('RankingList', obj);
};

mx.input_Ranking = function(playerIdx,teamGb,cnt){
	var obj = {};
	obj.CMD = mx.CMD_RANKINGINPUT;
	obj.IDX = playerIdx;
	obj.TEAMGB = teamGb;
	obj.TYPE = "insert";
	var txtRankingName = "#txtRankingPoint" + cnt;
	obj.RANKINGPOINT = $(txtRankingName).val();

	mx.SendPacket('RankingList', obj);
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
	obj.syymm = $("#startyynmm").val();


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


//	if(p2TeamAutoCtl != obj.p1team2txt){
//		$("#p2team").focus();
//		alert("검색된 2팀 목록에서 선택해주세요");
//		return ;
//	}



	mx.SendPacket('titlelist_'+obj.p1idx, obj);
};


mx.setState = function(pidx,stateno,btnid){
	if(stateno == '0'){
		$('#'+btnid).html('해제');
	}
	else{
		$('#'+btnid).html('박탈');
	}
	var obj = {};
	obj.CMD = mx.CMD_SETSTATE;
	obj.PIDX = pidx;
	obj.STATE = stateno;
	mx.SendPacket(null, obj);
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
	/*
	if (obj.fndSTR == "" || obj.fndSTR == undefined){
		mx.splashmsg("검색할 내용을 넣어주세요.", 1000);
		return;
	}
	*/
	mx.SendPacket('contest', obj);
};

////////////////////////////////////////
//검색
////////////////////////////////////////
/*
mx.searchRanking = function(idx){
	var obj = {};
	obj.CMD = mx.CMD_FINDRANK;
	obj.GROUPGAMEGB = $("#GroupGameGb1").val();
	obj.TEAMGB = $("#TeamGb1").val();
	obj.IDX = idx;
	mx.SendPacket('RankingList', obj);
};
*/
//var teamOneCode,teamOneName;
//var teamTwoCode,teamTwoName;
mx.gameinfo;
mx.playerlist ;
$(document).ready(function(){
		//mx.playerlist = document.getElementById( "sortlisttable" );
		//mx.replace = replacement(mx.playerlist );

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
						url: "/pub/ajax/RookieTennis/reqTennisContestTeamFind.asp",
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
				url: "/pub/ajax/RookieTennis/reqTennisContestTeamFind.asp",
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



//mx.sortTD = function( idx ){
//	mx.replace.ascending( idx );
//};
//
//mx.reverseTD = function( idx ){
//	mx.replace.descending( idx );
//};


//$(function(){
//
//})


var index;      // cell index
var toggleBool; // sorting asc, desc
var type; //

function sorting(theadTR,thead, tbody, index, isNumber){

	this.index = index;
	type = isNumber

	if(toggleBool){
			toggleBool = false;
	}else{
			toggleBool = true;
	}

	var datas= new Array();

	//tbody의 row 길이
	var tbodyLength = tbody.rows.length;

	for(var i=0; i<tbodyLength; i++){
			datas[i] = tbody.rows[i];
	}

	// sort by cell[index]
	datas.sort(compareCells);

	for(var i=0; i<tbody.rows.length; i++){
			// rearrange table rows by sorted rows
			tbody.appendChild(datas[i]);
	}

	var theadRow = thead.getElementsByTagName('th');
	for(var j= 0; j< theadRow.length; j++) {
		var thCell = thead.rows[0].cells[j];
		console.log(thCell)
		var thSpan = thCell.getElementsByTagName('span');

		if(theadTR == thCell)
		{
			if(thSpan[0].className =="sort-by-des")
			thSpan[0].className = "sort-by-asc"
			else
			thSpan[0].className = "sort-by-des"
		}
		else{
			thSpan[0].className = "sort-by"
		}

	}
}

function compareCells(a,b) {
	var aVal = a.cells[index].innerText;
	var bVal = b.cells[index].innerText;

	aVal = aVal.replace(/\,/g, '');
	bVal = bVal.replace(/\,/g, '');

	if(toggleBool){
			var temp = aVal;
			aVal = bVal;
			bVal = temp;
	}

	straVal = aVal;
	strbVal = bVal;

	if( type == true)
	{
		straVal = straVal.replace(/[^0-9]/g,'');
		strbVal = strbVal.replace(/[^0-9]/g,'');

		if(straVal.length == 0 || straVal == undefined )
			straVal = "0";

		if(strbVal.length == 0 || strbVal == undefined  )
			strbVal = "0";
	}


	if(straVal.match(/^[0-9]+$/) || strbVal.match(/^[0-9]+$/)){

		//숫자 처리 방법
		//alert("aVal : " + aVal + "aVal : " + bVal)
		var result = parseFloat(straVal) - parseFloat(strbVal)
		//alert("Result" +  result)
		return parseFloat(straVal) - parseFloat(strbVal);
	}
	else{

		//문자 처리 방법
				if (aVal < bVal){
						return -1;
				}else if (aVal > bVal){
							return 1;
				}else{
						return 0;
				}
	}
}

mx.playeredit = function(pidx,tidx,levelno,ptype){
	var obj = {};
	obj.CMD = mx.CMD_PLAYEREDITOK;

	obj.pidx = pidx;
	obj.tidx = tidx;
	obj.levelno = levelno;
	if (!ptype) {
		obj.ptype = 1;
	} else {
		obj.ptype = ptype;
	}
	obj.pname = $("#u_name").val();
	obj.boo = $("#u_boo").val();
	obj.psex = $("#u_sex").val();

	obj.pbirth = $("#u_birth").val();
	obj.phone = $("#u_phone").val();

	obj.pteam1 = $("#u_team1nm").val();
	obj.pteam2 = $("#u_team2nm").val();


	mx.SendPacket('rankplayerinfo', obj);
};

mx.rankBooCheck = function(pidx,boono){
	var obj ={};
	obj.PIDX = pidx;
	obj.BNO = boono;
   if ( $("#rankboo"+boono+"_"+pidx).is(":checked") == true ) {
	   obj.CHK = 'Y';
   }
   else{
		obj.CHK = 'N';
   }
	obj.CMD = mx.CMD_RNKBOO;
	mx.SendPacket( null , obj);
};


//오픈부 랭킹지정
mx.setOpenRNK = function(s_id){
  if (confirm("오픈부 랭킹 위치를 저장 하시겠습니까?")) {
	var obj = {};
	obj.CMD = mx.CMD_OPENRNK;
	obj.PIDX = s_id.split("_")[1];
	obj.V = $('#' +s_id).val();
	//alert(obj.VAL);
	mx.SendPacket(null, obj);
  }else{
    return;
  }
};

//승급자설정
mx.setUPMember = function(s_id){
  if (confirm("승급자로 설정하시겠습니까?")) {
	var obj = {};
	obj.CMD = mx.CMD_UPGRADE;
	obj.PIDX = s_id.split("_")[1];
	obj.V = $('#' +s_id).val();

	if ($("#" + s_id ).val()) {
			obj.TITLECODE = $("#" + s_id ).val();
	};
	//alert(obj.V);
	mx.SendPacket(null, obj);
  }else{
    return;
  }
};

//승급자 년말 초기화
mx.resetUPMember = function(){
  if (confirm("승급자 정보를 초기화 합니다. 올해이전데이터만 초기화 됩니다.")) {
	var obj = {};
	obj.CMD = mx.CMD_RESETUP;
	//alert(obj.V);
	mx.SendPacket(null, obj);
  }else{
    return;
  }
};


//선수 관리
mx.resetUPMember = function(){
  if (confirm("승급자 정보를 초기화 합니다. 올해이전데이터만 초기화 됩니다.")) {
	var obj = {};
	obj.CMD = mx.CMD_RESETUP;
	//alert(obj.V);
	mx.SendPacket(null, obj);
  }else{
    return;
  }
};


//포인트 통합창
mx.sumPoint = function(pidx,pname){
	var obj = {};
	obj.CMD = mx.CMD_SUMPPOINT;
	obj.PIDX = pidx;
	obj.PNAME = pname;
	mx.SendPacket('myModal', obj);
};


//포인트 통합
mx.sumPointOK = function(packet){
  if (confirm("체크된 동일 이름을 가진 선수의 포인트를 모두 최종 통합될 선수의 포인트로 변환합니다.")) {
	var obj = {};
	obj.CMD = mx.CMD_SUMPPOINTOK;
	obj.PIDX = packet.PIDX;
	obj.PNAME = packet.PNAME;

	//체크된 선수 인덱스들
	var DATA='';
	$('input:checkbox[name=sm_nm]').each(function() {
		if($(this).is(':checked'))
			DATA += "|"+($(this).val());
	});
	if (DATA == ''){
		alert('통합할 선수를 체크하여 주십시오.');
		return;
	}
	obj.CHANGELIST = DATA;
	console.log(DATA);

	mx.SendPacket('myModal', obj);
  }else{
    return;
  }
};



//승급자 날짜 지정 (외부승급자)
mx.setRankerWindow = function(pidx,pname,rnktitle){
	var obj = {};
	obj.CMD = mx.CMD_SETRANKER;
	obj.PIDX = pidx;
	obj.PNAME = pname;
	obj.PTITLE = rnktitle;
	mx.SendPacket('myModal', obj);
};


//승급자 정보셋팅
mx.setRankerOK = function(packet){
  if (confirm("외부승급자 설정으로만사용바랍니다.만료날짜를 넣으면 기존 승급자도 만료난짜에 영향을 받습니다.")) {
		var obj = {};

		obj.CMD = mx.CMD_SETRANKEROK;
		obj.PIDX = packet.PIDX;
		obj.PNAME = packet.PNAME;
		//check 확인
		if ( $("#rnkyn").is(":checked") == true ) {
		   obj.RNKYN = 'Y';
		}
		else{
		   obj.RNKYN = 'N';
		}
		obj.BOONO = $("#boono").val(); 

		//입력받은 날짜 (시작, 종료)
		if ($("#rnkstart").val()) {
			obj.RNKSTART = $("#rnkstart").val();
		};
		if ($("#rnkend").val()) {
			obj.RNKEND = $("#rnkend").val();
		};


		//console.log(packet);
		mx.SendPacket('myModal', obj);
  } else {
    return;
  }
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
1