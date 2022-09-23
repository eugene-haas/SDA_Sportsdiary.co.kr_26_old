var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_AUTOCOMPLETE = 100;

	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
	mx.CMD_GAMEINPUT = 30001;
	mx.CMD_GAMEINPUTEDIT = 30002; //수정
	mx.CMD_GAMEINPUTEDITOK = 30003;
	mx.CMD_GAMEINPUTDEL = 30004;// 삭제
	mx.CMD_GAMEAUTO = 30007;
	mx.CMD_FINDPLAYER = 30008;
	mx.CMD_RANKINGINPUT = 30010;
	mx.CMD_RANKPOINT = 30011;
	mx.CMD_RANKINGINPUTEDIT = 30012;
	mx.CMD_UPDATEGAMESETPOINT = 30013;
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
mx.SendPacket = function( sender, packet){
	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisGameDebug.asp";
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
	//alert(strdata)
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
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_GAMEAUTO:
	case mx.CMD_GAMEINPUT:	this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_CONTESTAPPEND:	this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_RANKPOINT:	this.OnRankHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GAMEINPUTEDITOK:
	case mx.CMD_FINDPLAYER:
	case mx.CMD_RANKINGINPUT:
	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GAMEINPUTDEL:	this.OndelHTML( reqcmd, jsondata, htmldata, sender );		break;
	}
};


mx.OnRankHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
};

///////////////////////////////////////////////////
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
	if( cmd == mx.CMD_GAMEINPUTEDITOK  || cmd == mx.CMD_FINDPLAYER  ||  cmd == mx.CMD_GAMEINPUTEDIT ){

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
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUT;
	obj.p1name = $("#p1name").val();
	obj.p1sex = $("#p1sex").val();
	obj.p1_birth = $("#p1_birth").val();
	obj.p1grade = $("#p1grade").val();
	obj.p1phone = $("#p1phone").val();
	obj.p1team1 = $("#p1team1").val();
	obj.p1team2 = $("#p1team2").val();
	obj.p1team1txt = $("#p1team1 option:selected").text();
	obj.p1team2txt = $("#p1team2 option:selected").text();



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


mx.updateMSet = function (setIndex,resultIDX,txtControl){
	var obj = {};
	str = txtControl.value.replace(/[^0-9]/g,'');

	if(str != "") {
		obj.CMD = mx.CMD_UPDATEGAMESETPOINT;
		obj.SETINDEX = setIndex;
		obj.RESULTINDEX = resultIDX;
		obj.VALUE = txtControl.value;
		mx.SendPacket(null, obj);
	}
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
	if (obj.IDX	 == '' || $("#p1name").value == '' || mx.gameinfo.NM != $("#p1name").val()){
		alert("대상을 선택해 주세요. 선수명은 수정될 수 없습니다.");
		return;
	}
	obj.p1idx = mx.gameinfo.IDX;
	obj.p1name = $("#p1name").val();
	obj.p1sex = $("#p1sex").val();
	obj.p1_birth = $("#p1_birth").val();
	obj.p1grade = $("#p1grade").val();
	obj.p1phone = $("#p1phone").val();
	obj.p1team1 = $("#p1team1").val();
	obj.p1team2 = $("#p1team2").val();
	obj.p1team1txt = $("#p1team1 option:selected").text();
	obj.p1team2txt = $("#p1team2 option:selected").text();

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
	
	//$("#playerTable").tablesorter();
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
