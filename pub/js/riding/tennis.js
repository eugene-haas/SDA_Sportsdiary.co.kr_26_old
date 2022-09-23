function decodeUTF8(str){return decodeURIComponent(str);}
function encodeUTF8(str){return encodeURIComponent(str);}	

var mx =  mx || {};
mx.CMD_TABLECMT	 =	1; //코멘트 인서트, 업데이트
mx.CMD_COLUMNCMT	 =	2; //코멘트 인서트, 업데이트
mx.CMD_LOGIN = 3; //로그인
mx.CMD_CAL = 4  //'대회 리스트 조회

mx.CMD_BOARDWRITEOK = 500;

mx.CMD_DATAGUBUN = 10000;
mx.CMD_TABLELIST = 10001;
mx.CMD_TABLECLUMN = 10002;
mx.CMD_IISINFO = 10003;
mx.CMD_TARGETSITE = 10004;
mx.CMD_DBBASIC = 20005;


mx.CMD_GAMETITLE = 20001;
mx.CMD_GAMETABLE = 20002;


mx.CMD_BOARDVIEW = 20003;
mx.CMD_BOARDEDIT = 20004;


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


//히스토리 저장/////////////////////////////////////////////////////////////////////////
mx.arrKey = ["CMD","PG",'SEQ',"IDX","T","R","SP","LVL","FT","SSTR","DN","NM","ST"]; //"PAGEC",'SEQ',"IDX","TID","REF","STEP","LVL","FINDTYPE","SEARCHSTR","DBNAME","이전다음 상태"
mx.historybackstr = null;

mx.CheckForHash = function(){ //백버튼 클릭시 위치로 이동
	if( document.location.hash && document.location.hash != mx.historybackstr  ){
		mx.historybackstr = document.location.hash;

		var HashLocationName = document.location.hash;
		HashLocationName = HashLocationName.replace("#","");

		var objkey = HashLocationName.split('^');
		var sendparam = {};
		var keylen = mx.arrKey.length;
		for ( var  i= 0 ;i < keylen ;i++ )	{
			if (objkey[i] != '')	{
				sendparam[mx.arrKey[i]] = objkey[i];
			}
		}
		var objlen = Object.keys(sendparam).length;
		if (objlen > 0 ){
			mx.SendPacket(null, sendparam);
		}
	}else{
		//첫페이지 불러오기
	}
};

mx.RenameAnchor = function (anchorid, anchorname){
	document.getElementById(anchorid).name = anchorname; //this renames the anchor
}

mx.RedirectLocation = function (anchorid, anchorname, HashName){
	mx.RenameAnchor(anchorid, anchorname);
	document.location = HashName;
};

mx.HashCheckInterval = setInterval("mx.CheckForHash()", 1000);
window.onload = mx.CheckForHash;
//히스토리 저장/////////////////////////////////////////////////////////////////////////

mx.SendPacket = function( sender, packet){

	//var objlen = Object.keys(packet).length;
	if ( (Number(packet.CMD) >= mx.CMD_DATAGUBUN && packet.CMD != mx.CMD_TABLECLUMN && packet.CMD != mx.CMD_DBBASIC)  && sender != null){ //보이는 화면 만 히스토리에 저장 >> 정해두어야하나
		var locstr='';
		var iskey = false;
		var keylen = mx.arrKey.length;
			
		for ( var  i= 0 ;i < keylen ;i++ )	{ //배열갯수만큼만 생성

			for (var key in packet) { //한개씩만 붙여나가자
				if (key == mx.arrKey[i])	{
					if (i == 0 ){
						locstr += packet[key];
						iskey = true;
						break;
					}
					else{
						locstr += '^' + packet[key];
						iskey = true;
						break;
					}
				}
				else{
					iskey = false;
					//locstr += '^';
					//break;
				}
			}
			if (iskey == false){
				locstr += '^';
			}

		}

		mx.RedirectLocation("LocationAnchor", packet.CMD, "#"+locstr);
		return;
	}



	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisAdmin.asp";
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	setTimeout( function(){ reqdone = true; }, timeout );

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){
				mx.ReceivePacket( reqcmd, mx.HttpData( xhr, datatype ), sender );
				return true;
			}
			xhr = null;
		}
	};
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
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_TABLELIST:	this.OnList( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_TABLECLUMN:	this.OnClumn( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_TABLECMT:	this.OnComment( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_COLUMNCMT:	this.OnComment( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_IISINFO:	this.OnIIS( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_TARGETSITE:	this.OnSite( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_LOGIN:	this.OnLogin( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_DBBASIC:	this.OnShow( reqcmd, jsondata, htmldata, sender );		break;


	case mx.CMD_GAMETITLE:	this.OnGameTitle( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GAMETABLE:	this.OnGameTable( reqcmd, jsondata, htmldata, sender );		break;

	
	case mx.CMD_BOARDWRITEOK:	this.OnBoardWriteOK( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_BOARDVIEW:	this.OnBoardView( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_BOARDEDIT:	this.OnBoardEdit( reqcmd, jsondata, htmldata, sender );		break;
	}
};

mx.OnSave =  function(cmd, packet, html, sender){
	var id = packet.ID.split("_")[1];
	document.getElementById('in_'+id).value = packet.in;
	document.getElementById('out_'+id).value = packet.out;
	document.getElementById('st_'+id).innerText = packet.st;
};


mx.OnList =  function(cmd, packet, html, sender){
	document.getElementById("dbselect").style.display = "block";
	document.getElementById("axcontents").innerHTML = html;
};

mx.OnShow =  function(cmd, packet, html, sender){
	document.getElementById("dbselect").style.display = "none";
	document.getElementById("axcontents").innerHTML = html;
};

mx.OnIIS =  function(cmd, packet, html, sender){
	document.getElementById("dbselect").style.display = "none";
	document.getElementById("axcontents").innerHTML = html;
};

mx.OnSite =  function(cmd, packet, html, sender){
	//document.getElementById("dbselect").style.display = "none";
	document.getElementById("myModal").innerHTML = html;
	$('#myModal').modal('show');
};

mx.OnClumn =  function(cmd, packet, html, sender){
	document.getElementById("myModal").innerHTML = html;
	document.getElementById("myModalLabel").innerHTML = "필드명, 타입, 내용";
	$('#myModal').modal('show');
	if(sender != null){
		sender.style.color='orange';
	}
};


mx.OnComment =  function(cmd, packet, html, sender){
	sender.style.borderColor  = 'red';
};


mx.OnLogin =  function(cmd, packet, html, sender){
	if (packet.logincheck ==  "1"){
		$('#login-modal').modal('toggle');
		document.getElementById("axcontents").innerHTML = "로그인 테스트 성공";
	}
	else{
		msgChange($('#div-login-msg'), $('#icon-login-msg'), $('#text-login-msg'), "error", "glyphicon-remove", "Login error");			
	}
};




mx.OnGameTitle =  function(cmd, packet, html, sender){
	document.getElementById("axcontents").innerHTML = html;
};

mx.OnGameTable =  function(cmd, packet, html, sender){
	mx.players = packet;
	document.getElementById("axcontents").innerHTML = html;
};




mx.OnBoardWriteOK =  function(cmd, packet, html, sender){
	mx.SendPacket(this,{"CMD":mx.CMD_BOARD});	
};


mx.OnBoardView =  function(cmd, packet, html, sender){
	document.getElementById("axcontents").innerHTML = html;
};

mx.OnBoardEdit =  function(cmd, packet, html, sender){
	document.getElementById("axcontents").innerHTML = html;
	CKEDITOR.replace( 'editor1' );
};





mx.writeOk = function(){
	var bbsform = document.fbbs;

	var editor = CKEDITOR.instances.editor1;

	var btitle, contents;
	btitle = bbsform.title.value;
	contents = editor.getData();

	if (btitle == ''){
		bbsform.title.focus();
		return;
	}

	if (editor.getData() == ''){
		editor.focus();
		return;
	}

//	if (ref == undefined){
//		ref = '';
//		step = '';
//		level='';
//	}

	mx.SendPacket(this, {'CMD':mx.CMD_BOARDWRITEOK,'TITLE':btitle,'CON':contents});

//	bbsform.target = 'hiddenFrame';
//	bbsform.pagec.value = pageno;
//	bbsform.ref.value = ref;
//	bbsform.step.value = step;
//	bbsform.level.value = level;
//	bbsform.submit();
};


mx.editOk = function(){
	var bbsform = document.fbbs;

	var editor = CKEDITOR.instances.editor1;

	var btitle, contents, seq;
	seq = bbsform.seq.value;
	btitle = bbsform.title.value;
	contents = editor.getData();

	if (btitle == ''){
		bbsform.title.focus();
		return;
	}

	if (editor.getData() == ''){
		editor.focus();
		return;
	}

	mx.SendPacket(this, {'CMD':mx.CMD_BOARDEDITOK,'TITLE':btitle,'CON':contents,'SEQ':seq});
};


//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
mx.Hmodal = function(cmd){
	//ajax 콜
	mx.SendPacket(this,{"CMD":cmd});
	$('#myModal').modal('toggle');
};
















var $modalAnimateTime = 300;
var $msgAnimateTime = 150;
var $msgShowTime = 2000;

function msgChange($divTag, $iconTag, $textTag, $divClass, $iconClass, $msgText) {
	var $msgOld = $divTag.text();
	msgFade($textTag, $msgText);
	$divTag.addClass($divClass);
	$iconTag.removeClass("glyphicon-chevron-right");
	$iconTag.addClass($iconClass + " " + $divClass);
	setTimeout(function() {
		msgFade($textTag, $msgOld);
		$divTag.removeClass($divClass);
		$iconTag.addClass("glyphicon-chevron-right");
		$iconTag.removeClass($iconClass + " " + $divClass);
	}, $msgShowTime);
}

function msgFade ($msgId, $msgText) {
	$msgId.fadeOut($msgAnimateTime, function() {
		$(this).text($msgText).fadeIn($msgAnimateTime);
	});
}

function modalAnimate ($oldForm, $newForm) {
	var $oldH = $oldForm.height();
	var $newH = $newForm.height();
	$divForms.css("height",$oldH);
	$oldForm.fadeToggle($modalAnimateTime, function(){
		$divForms.animate({height: $newH}, $modalAnimateTime, function(){
			$newForm.fadeToggle($modalAnimateTime);
		});
	});
}




















/* #####################################################################
   #
   #   Project       : Modal Login with jQuery Effects
   #   Author        : Rodrigo Amarante (rodrigockamarante)
   #   Version       : 1.0
   #   Created       : 07/29/2015
   #   Last Change   : 08/04/2015
   #
   ##################################################################### */

$(function() {
	
    var $formLogin = $('#login-form');
    var $formLost = $('#lost-form');
    var $formRegister = $('#register-form');
    var $divForms = $('#div-forms');

	var $modalAnimateTime = 300;
	var $msgAnimateTime = 150;
	var $msgShowTime = 2000;


    $("form").submit(function () {
        switch(this.id) {
            case "login-form":
                var $lg_username=$('#login_username').val();
                var $lg_password=$('#login_password').val();
				var $lg_save = $('#login_save').val();
				if ($('#login_save').is(":checked") == false){
					$lg_save= "0";
				}


				
				if ($lg_username == "ERROR") {
                    msgChange($('#div-login-msg'), $('#icon-login-msg'), $('#text-login-msg'), "error", "glyphicon-remove", "Login error");
                } else {
                    //msgChange($('#div-login-msg'), $('#icon-login-msg'), $('#text-login-msg'), "success", "glyphicon-ok", "Login OK");
					mx.SendPacket(this, {'CMD':mx.CMD_LOGIN,'ID':$lg_username,'PWD':$lg_password,'ISV':$lg_save});
                }

                return false;
                break;
            case "lost-form":
                var $ls_email=$('#lost_email').val();
                if ($ls_email == "ERROR") {
                    msgChange($('#div-lost-msg'), $('#icon-lost-msg'), $('#text-lost-msg'), "error", "glyphicon-remove", "Send error");
                } else {
                    msgChange($('#div-lost-msg'), $('#icon-lost-msg'), $('#text-lost-msg'), "success", "glyphicon-ok", "Send OK");
                }
                return false;
                break;
            case "register-form":
                var $rg_username=$('#register_username').val();
                var $rg_email=$('#register_email').val();
                var $rg_password=$('#register_password').val();
                if ($rg_username == "ERROR") {
                    msgChange($('#div-register-msg'), $('#icon-register-msg'), $('#text-register-msg'), "error", "glyphicon-remove", "Register error");
                } else {
                    msgChange($('#div-register-msg'), $('#icon-register-msg'), $('#text-register-msg'), "success", "glyphicon-ok", "Register OK");
                }
                return false;
                break;
            default:
                return false;
        }
        return false;
    });
    
    $('#login_register_btn').click( function () { modalAnimate($formLogin, $formRegister) });
    $('#register_login_btn').click( function () { modalAnimate($formRegister, $formLogin); });
    $('#login_lost_btn').click( function () { modalAnimate($formLogin, $formLost); });
    $('#lost_login_btn').click( function () { modalAnimate($formLost, $formLogin); });
    $('#lost_register_btn').click( function () { modalAnimate($formLost, $formRegister); });
    $('#register_lost_btn').click( function () { modalAnimate($formRegister, $formLost); });

	
function msgChange($divTag, $iconTag, $textTag, $divClass, $iconClass, $msgText) {
	var $msgOld = $divTag.text();
	msgFade($textTag, $msgText);
	$divTag.addClass($divClass);
	$iconTag.removeClass("glyphicon-chevron-right");
	$iconTag.addClass($iconClass + " " + $divClass);
	setTimeout(function() {
		msgFade($textTag, $msgOld);
		$divTag.removeClass($divClass);
		$iconTag.addClass("glyphicon-chevron-right");
		$iconTag.removeClass($iconClass + " " + $divClass);
	}, $msgShowTime);
}

function msgFade ($msgId, $msgText) {
	$msgId.fadeOut($msgAnimateTime, function() {
		$(this).text($msgText).fadeIn($msgAnimateTime);
	});
}

function modalAnimate ($oldForm, $newForm) {
	var $oldH = $oldForm.height();
	var $newH = $newForm.height();
	$divForms.css("height",$oldH);
	$oldForm.fadeToggle($modalAnimateTime, function(){
		$divForms.animate({height: $newH}, $modalAnimateTime, function(){
			$newForm.fadeToggle($modalAnimateTime);
		});
	});
}


});



////////////////////////////////////////////////////////////////////////////////
		mx.players = null;
		mx.initial = null;
		mx.dragSrcEl_ = null;

		mx.allowDrop= function(e) {
			if (e.preventDefault) {
			  e.preventDefault(); // Allows us to drop.
			}
			e.dataTransfer.dropEffect = 'move';
			return;
		};

		mx.drag = function(e) {
			var targetobj = document.getElementById(e.target.id);
			e.dataTransfer.effectAllowed = 'move';
			e.dataTransfer.setData('text', targetobj.innerHTML);
			mx.dragSrcEl_ = document.getElementById(e.target.id);
			targetobj.style.color = 'red';
		};

		mx.drop = function(e) {
			var targetobj = document.getElementById(e.target.id);
			if (e.stopPropagation) {
			  e.stopPropagation(); 
			}

			if (mx.dragSrcEl_ != targetobj) {
			  var dragobjrow = mx.dragSrcEl_.id.split('_')[1];  //행1
			  var dropobjrow = targetobj.id.split('_')[1];			 //행2
			  var dragobjcol = mx.dragSrcEl_.id.split('_')[2];	 //열1
			  var dropbjcol = targetobj.id.split('_')[2];				 //열2
			  var gamestart = false;

			  //1단계 위아래
			  if ( Number(dragobjrow) == 0 || Number(dragobjrow) == Number(mx.players[0].MAXRO) - 1 ) { //첫행과 마지막행
				  if(Number(dropobjrow) == 0 || Number(dropobjrow) == Number(mx.players[0].MAXRO) - 1){ //첫행과 마지막행
						for (var i = 0;i<mx.players.length ;i++ ){
							if( mx.players[i].RO > 1 ){ //경기가 발생했다면 변경금지(RO 행 1라운드보다 크다면 변경금지)
								gamestart = true;
							}
						}

						if ( gamestart == false){ // //보이는 화면 변경 , 소팅번호변경 
							mx.dragSrcEl_.innerHTML = targetobj.innerHTML;
							targetobj.innerHTML = e.dataTransfer.getData('text').trim();

							var dragcolno = mx.players[mx.dragSrcEl_.id.split('_')[2]].CO;
							var targetcolno = mx.players[targetobj.id.split('_')[2]].CO;

							var changedata1 = mx.players[mx.dragSrcEl_.id.split('_')[2]];
							var changedata2 = mx.players[targetobj.id.split('_')[2]];

							changedata1.CO = targetcolno;
							changedata2.CO = dragcolno;

							mx.players[mx.dragSrcEl_.id.split('_')[2]] = changedata2;
							mx.players[targetobj.id.split('_')[2]] = changedata1;
						}
				  }
			  }
			}
			return false;   
		};


		mx.dragEnd = function(e) {
			var targetobj = document.getElementById(e.target.id);
			if (e.stopPropagation) {
			  e.stopPropagation(); 
			}

			if (mx.dragSrcEl_ != targetobj) {
			  var dragobjrow = mx.dragSrcEl_.id.split('_')[1];  //행1
			  var dropobjrow = targetobj.id.split('_')[1];			 //행2
			  var dragobjcol = mx.dragSrcEl_.id.split('_')[2];	 //열1
			  var dropbjcol = targetobj.id.split('_')[2];				 //열2
			  var gamestart = false;

			  //1단계 위아래
			  if (Number(dragobjrow) == Number(dropobjrow)) { //같은행이라면
				  if(Number(dragobjrow) == 0 || Number(dragobjrow) == Number(mx.players[0].MAXRO) - 1){ //첫번째 또는 마지막행
						for (var i = 0;i<mx.players.length ;i++ ){
							if( mx.players[i].RO > 1 ){ //경기가 발생했다면 변경금지(RO 행 1라운드보다 크다면 변경금지)
								gamestart = true;
							}
						}

						if ( gamestart == false){ // //보이는 화면 변경 , 소팅번호변경 
							mx.dragSrcEl_.innerHTML = targetobj.innerHTML;
							targetobj.innerHTML = e.dataTransfer.getData('text').trim();

							var dragcolno = mx.players[mx.dragSrcEl_.id.split('_')[2]].CO;
							var targetcolno = mx.players[targetobj.id.split('_')[2]].CO;

							var changedata1 = mx.players[mx.dragSrcEl_.id.split('_')[2]];
							var changedata2 = mx.players[targetobj.id.split('_')[2]];

							changedata1.CO = targetcolno;
							changedata2.CO = dragcolno;

							mx.players[mx.dragSrcEl_.id.split('_')[2]] = changedata2;
							mx.players[targetobj.id.split('_')[2]] = changedata1;
						}
				  }
			  }
			}
			return false;   
		};

		mx.sgfBuffer = function(s) {//String Copy가 Recursive마다 일어나는 것을 방지하기 위해
			this.str = s;
			if( s != null ) this.len = s.length;
			else this.len = 0;
			this.stack = 0;
		};

		mx.replaceAll = function(str, searchStr, replaceStr){
			return str.split(searchStr).join(replaceStr);
		};
