var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
	mx.CMD_GAMEINPUT = 30001;
	mx.CMD_GAMEINPUTEDIT = 30002; //수정
	mx.CMD_GAMEINPUTEDITOK = 30003;
	mx.CMD_GAMEINPUTDEL = 30004; // 삭제
	mx.CMD_GAMEAUTO = 30007;
	mx.CMD_FINDPLAYER = 30008;
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
mx.SendPacket = function (sender, packet) {
    var datatype = "mix";
    var timeout = 5000;
    var reqcmd = packet.CMD;
    var reqdone = false; //Closure
    var url = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisTeamInfo.asp";
    var strdata = "REQ=" + encodeURIComponent(JSON.stringify(packet));
    var xhr = new XMLHttpRequest();
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    setTimeout(function () { reqdone = true; }, timeout);

    //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
    //	apploading("AppBody", "로딩 중 입니다.");
    //}

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && !reqdone) {
            if (mx.IsHttpSuccess(xhr)) {

                //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){				
                //	$('#AppBody').oLoader('hide');
                //}

                mx.ReceivePacket(reqcmd, mx.HttpData(xhr, datatype), sender);
                return true;
            }
            xhr = null;
        }
    };

    console.log(JSON.stringify(packet));
    console.log(strdata);

    xhr.send(strdata);
};

mx.ReceivePacket = function (reqcmd, data, sender) {// data는 response string
    var rsp = null;
    var callback = null;
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
            case 1: alert('데이터가 존재하지 않습니다.'); return; break;
			case 200:	alert('동일한 팀명칭이 있습니다.');return; 	break;
			case 100: return; break; //메시지 없슴
        }
    }

    switch (Number(reqcmd)) {

        case mx.CMD_GAMEAUTO:
        case mx.CMD_GAMEINPUT: this.OnBeforeHTML(reqcmd, jsondata, htmldata, sender); break;

        case mx.CMD_CONTESTAPPEND: this.OnAppendHTML(reqcmd, jsondata, htmldata, sender); break;

        case mx.CMD_FINDPLAYER:
        case mx.CMD_GAMEINPUTEDITOK:
        case mx.CMD_GAMEINPUTEDIT: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;

        case mx.CMD_GAMEINPUTDEL: this.OndelHTML(reqcmd, jsondata, htmldata, sender); break;

    }
};

mx.OnPopClose= function(cmd, packet, html, sender){
	$(sender).modal('toggle');
};

mx.OndrowHTML = function (cmd, packet, html, sender) {

    document.getElementById(sender).innerHTML = html;

    if (cmd == mx.CMD_GAMEINPUTEDITOK || cmd == mx.CMD_FINDPLAYER || cmd == mx.CMD_GAMEINPUTEDIT) {
        mx.init();

        if (cmd == mx.CMD_FINDPLAYER) {
            $("#totcnt").html(packet.totalcnt);
            $("#nowcnt").html(packet.NKEY);
            packet.NKEY = Number(packet.NKEY) + 1;
            localStorage.setItem('MOREINFO', JSON.stringify(packet));
        }
    }
};

mx.OndelHTML =  function(cmd, packet, html, sender){
	$("#"+sender).remove();
	if( cmd = mx.CMD_GAMEINPUTDEL){
	    document.getElementById('Teaminfoform').innerHTML = html;	
		mx.init();
	}
};

mx.OnAppendHTML =  function(cmd, packet, html, sender){
    if (packet.lastchk == "_end") { return; }
    $("#nowcnt").html(packet.NKEY);
	packet.NKEY = Number(packet.NKEY) + 1;
	localStorage.setItem('MOREINFO', JSON.stringify( packet  ));
	$('#'+sender).append(html);
	$("body").scrollTop($("body")[0].scrollHeight);
};


mx.OnBeforeHTML = function (cmd, packet, html, sender) {

    $('.gametitle').first().before(html);

    $("#totcnt").html(Number($("#totcnt").text()) + 1);

    if (cmd == mx.CMD_GAMEAUTO && Number(packet.AutoNo) > 0) {
        $("#autono").val(packet.AutoNo);
        mx.SendPacket(null, packet);
    }
};



mx.input_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUT;

	obj.Team = $("#Team").val();
	obj.TeamNm = $("#TeamNm").val();
	obj.sido = $("#sido").val();
	obj.ZipCode = $("#ZipCode").val();
	obj.Address = $("#Address").val();
	obj.AddrDtl = $("#AddrDtl").val();
	obj.TeamTel = $("#TeamTel").val();
	obj.TeamLoginPwd = $("#TeamLoginPwd").val(); 

	mx.SendPacket(null, obj);
};


mx.update_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTEDITOK;
	obj.TeamIDX		=	$("#TeamIDX").val();

    if (obj.TeamIDX == undefined){
	    alert("대상을 선택해 주세요.");
	    return;
    }

	obj.Team = $("#Team").val();
	obj.TeamNm = $("#TeamNm").val();
	obj.sido = $("#sido").val();
	obj.ZipCode = $("#ZipCode").val();
	obj.Address = $("#Address").val();
	obj.AddrDtl = $("#AddrDtl").val();
	obj.TeamTel = $("#TeamTel").val();
	obj.TeamLoginPwd = $("#TeamLoginPwd").val(); 

	mx.SendPacket('titlelist_'+obj.TeamIDX, obj);
};


mx.del_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTDEL;
	obj.TeamIDX	=	$("#TeamIDX").val();

if (obj.TeamIDX == undefined){
	alert("대상을 선택해 주세요.");
	return;
}
	mx.SendPacket('titlelist_'+obj.TeamIDX, obj);
};



mx.input_edit = function(TeamIDX){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTEDIT;
	obj.TeamIDX = TeamIDX;
	mx.SendPacket('Teaminfoform', obj);
};


////////////////////////////////////////
//검색
////////////////////////////////////////
mx.searchTeam = function () {
    var moreinfo = localStorage.getItem('MOREINFO');

    var obj = {};
    obj.CMD = mx.CMD_FINDPLAYER;
    obj.NKEY = 1;
    obj.findSido = $("#fnd_sido").val();
    obj.findTYPE = $("#fnd_Type").val();
    obj.fndSTR = $("#fnd_Str").val();

//    if (obj.fndSTR == "" || obj.fndSTR == undefined) {
//        if (obj.findSido == "" || obj.findSido == undefined) {
//            mx.splashmsg("검색할 내용을 넣어주세요.", 1000);
//            return;
//        }
//    }

    mx.SendPacket('contest', obj);
};

mx.contestMore = function () {

    var moreinfo = localStorage.getItem('MOREINFO'); //다음
    var nextkey = 2;

    if (moreinfo != null) {
        moreinfo = JSON.parse(moreinfo);
        nextkey = moreinfo.NKEY;
    }
    
    var obj = {};
    obj.CMD = mx.CMD_CONTESTAPPEND;
    obj.NKEY = nextkey;
    obj.findSido = $("#fnd_sido").val();
    obj.findTYPE = $("#fnd_Type").val();
    obj.fndSTR = $("#fnd_Str").val();
    mx.SendPacket('contest', obj);
};


//오토 팀 생성
mx.auto_frm = function () {
    var obj = {};
    obj.CMD = mx.CMD_GAMEAUTO;
    obj.AutoNo = $("#autono").val();
    mx.SendPacket(null, obj);
};

////////////////////////////////////////
//일시적으로 팝업 보여줌
////////////////////////////////////////
mx.splashmsg = function (msg, deltime) {
    $("#w_msg").html(msg);
    $(".warn_modal").modal("show");
    setTimeout(function () { $(".warn_modal").modal('hide'); }, deltime);
};


$(document).ready(function(){
		localStorage.removeItem('MOREINFO');	
		localStorage.removeItem('GAMEINFO');
		mx.init();
}); 

mx.init = function(){

$(function() {
	 
});


};
