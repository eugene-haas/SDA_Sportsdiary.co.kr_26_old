var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_VACCRESET = 422; //계좌정리
	
	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
	mx.CMD_GAMEINPUT = 30001;
	mx.CMD_GAMEINPUTEDIT = 30002; //수정
	mx.CMD_GAMEINPUTEDITOK = 30003;
	mx.CMD_GAMEINPUTDEL = 30004;// 삭제
	mx.CMD_EDITOR = 40000;
	mx.CMD_EDITOROK = 40001;

	mx.CMD_RNKLIST = 40003; //랭킹리스트목록
	mx.CMD_SETRNKINFO = 40004; //랭킹 반영 처리

	mx.CMD_MAKEGOODS = 50000; //상품팝업
	mx.CMD_INSERTDEP1 = 50002; //상품저장
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

mx.loading = function(){
	var width = $(window).width();
	var height = $(window).height();
	 
	//화면을 가리는 레이어의 사이즈 조정
	$(".backLayer").width(width);
	$(".backLayer").height(height);
	 
	//화면을 가리는 레이어를 보여준다 (0.5초동안 30%의 농도의 투명도)
	$(".backLayer").fadeTo(500, 0.3);
	 
	//팝업 레이어 보이게
	var loadingDivObj = $("#loadingDiv");
	loadingDivObj.css("top", $(document).height()/2-0);
	loadingDivObj.css("left",$(document).width()/2-0);
	loadingDivObj.fadeIn(500);
};

//esc키 누르면 화면 잠김 해제
$(document).keydown(function(event){
	if(event.which=='27'){
		$("#loadingDiv").fadeOut(300);
		$(".backLayer").fadeOut(1000);
	}
});

 //윈도우가 resize될때마다 backLayer를 조정
 $(window).resize(function(){
	var width = $(window).width();
	var height = $(window).height();
	$(".backLayer").width(width).height(height);
});





//동일한 패킷이 오는경우 (막음 처리해야겠지)
mx.SendPacket = function( sender, packet){
	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = "/pub/ajax/swim/reqTennisContest.asp";
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	setTimeout( function(){ reqdone = true; }, timeout );

    //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
	//	apploading("AppBody", "로딩 중 입니다.");
	//}
	//mx.loading();


	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){
			
				//$(".backLayer").hide();
				//$("#loadingDiv").hide();

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
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_GAMEINPUT:	this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_CONTESTAPPEND:	this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_GAMEINPUTEDITOK:
	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GAMEINPUTDEL:	this.OndelHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_EDITOR:	this.OnEditor( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_RNKLIST:	this.OnRnkList( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_SETRNKINFO:	this.OnsetRnk( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_EDITOROK:	this.OnEditorOK( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_VACCRESET:  this.ReturnVacOK( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_MAKEGOODS: this.OnwritePop( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_INSERTDEP1: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;	
	}
};


mx.OnwritePop =  function(cmd, packet, html, sender){
	if( $('#' + sender).length == 0 ){
		document.body.innerHTML = "<div class='modal fade basic-modal myModal' id='"+sender+"' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'></div>";
	}
	$('#' + sender).html(html);
	$('#' + sender).modal('show');
};

//생성 팝업창 요청
mx.makeGoods = function(){
	var obj = {};
    obj.CMD = mx.CMD_MAKEGOODS;
	mx.SendPacket('modalS', obj);
};

//생성 메뉴선택
mx.SelectDEP = function(depno, selectid, drowid , cmd) {
  var GbVal = $("#" + selectid).val();

  var obj = {};
  obj.CMD = cmd;
  obj.DEPNO = depno;
  obj.DPTYPE = GbVal;
  obj.DEP1 = $("#dep01").val();
  obj.DEP2 = $("#dep02").val();
  obj.DEP3 = $("#dep03").val();

  if(GbVal == "insert" ) {
		  if (depno == 3 && obj.DEP1 == ''){
			  alert("상품을 먼저 선택해 주십시오.");
			  return;
		  }

		var GbPrompt = prompt("메뉴명을 입력해주세요",'');
		if(GbPrompt != null && GbPrompt != "") {
		  if (depno == 1){
			  obj.DEP1 = GbPrompt;
		  }
		  else{
			  obj.DEP3 = GbPrompt;		  
		  }
		  mx.SendPacket('modalS', obj);
		}
		else{
		}
  }
  else{
	  //항목만 불러올때
  	  obj.DEPNO = 0;
	  mx.SendPacket('modalS', obj);
  }
};





mx.editor =  function(tidx,gametitle){
	var obj = {};
	obj.CMD = mx.CMD_EDITOR;
	obj.TIDX = tidx;
	obj.TITLE = gametitle;
	mx.SendPacket('myModal', obj);	
};

mx.editOK = function(tidx,gametitle){
	var obj = {};
	obj.CMD = mx.CMD_EDITOROK;
	obj.TIDX = tidx;
	obj.TITLE = gametitle;
	var editor = CKEDITOR.instances.editor1;
	var contents = editor.getData();
	if (editor.getData() == ''){
		editor.focus();
		return;
	}

//	var contents = $('#cont').html(); 
//	if (contents == ''){
//		//editor.focus();
//		return;
//	}

	obj.CONTENTS = contents;
	mx.SendPacket('myModal', obj);	
};


mx.rnkList =  function(gameyear,titlecode,tidx){
	var obj = {};
	obj.CMD = mx.CMD_RNKLIST;
	obj.TIDX = tidx;
	obj.TCODE = titlecode;
	obj.GAMEYEAR = gameyear;
	mx.SendPacket('myModal', obj);
};


mx.OnRnkList =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
};

mx.setRnkInfo = function(titlecode,tidx,teamgb,gameyear){
	var obj = {};
	obj.CMD = mx.CMD_SETRNKINFO;
	obj.TIDX = tidx;
	obj.TCODE = titlecode;
	obj.TEAMGB = teamgb;
	obj.GAMEYEAR = gameyear;
	mx.SendPacket('myModal', obj);	 	
};

mx.OnsetRnk =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
};

mx.OnEditor =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
	CKEDITOR.replace( 'editor1' );

};

mx.OnEditorOK =  function(cmd, packet, html, sender){
	alert("저장이 완료 되었습니다.");
};


mx.ReturnVacOK = function(cmd, packet, sender){
	console.log(packet);
	returnCount = packet.returnCount
	rpointChk = packet.rpointChk
	if ( rpointChk == "N" )	{
		alert( "랭킹반영후에 정리할 수 있습니다. " );
	} 	else {
	   alert( returnCount + "개 계좌 반환완료" );
	   window.location.reload();
	}
};



mx.OnPopClose= function(cmd, packet, html, sender){
	$(sender).modal('toggle');
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if( cmd = mx.CMD_GAMEINPUTEDITOK){
		mx.init();
	}
};

mx.OndelHTML =  function(cmd, packet, html, sender){
	$("#"+sender).remove();
	if( cmd = mx.CMD_GAMEINPUTDEL){
		document.getElementById('gameinput_area').innerHTML = html;	
		mx.init();
	}
};

mx.OnAppendHTML =  function(cmd, packet, html, sender){
	if ( packet.lastchk == "_end" ){return;}
	packet.NKEY = Number(packet.NKEY) + 1;
	localStorage.setItem('MOREINFO', JSON.stringify( packet  ));
	$('#'+sender).append(html);
	$("body").scrollTop($("body")[0].scrollHeight);
};


mx.OnBeforeHTML =  function(cmd, packet, html, sender){
	$('.gametitle').first().before(html);
};

mx.contestMore = function(){

	var moreinfo = localStorage.getItem('MOREINFO'); //다음

	if (moreinfo == null)	{
		var nextkey = 2;
	}
	else{
		moreinfo = JSON.parse(moreinfo);	
		var nextkey = moreinfo.NKEY;
	}
	var parmobj = {'CMD':mx.CMD_CONTESTAPPEND,'NKEY':nextkey };
	mx.SendPacket('contest', parmobj);
};


mx.input_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUT;
	obj.GameYear        				=	$("#GameYear").val();
	obj.GameTitleName 				=	$("#GameTitleName").val();
	obj.HostCode          				=	$("#HostCode").val();
	obj.GameS              			=	$("#GameS").val();
	obj.GameE              				=	$("#GameE").val();
	obj.GameArea         				=	$("#GameArea").val();
	obj.GameRcvS        				=	$("#GameRcvS").val();
	obj.GameRcvE        				=	$("#GameRcvE").val();
	obj.ViewYN              			=	$("#ViewYN").val();
	obj.MatchYN           				=	$("#MatchYN").val();
	obj.ViewState          			=	$("#ViewState").val();
	obj.TIE          						=	$("#tie").val();
	obj.DUC         						=	$("#deuce").val();
	obj.ENTERTYPE					=	$("#entertype").val();
	obj.CODEGRADE         			=	$("#code_grade").val();
	obj.bigo				       			=	$("#bigo").val();
	obj.chkrange						= 	$("#chkrange").val();	

	if (obj.GameTitleName == ''){
		alert('대회명을 입력해 주세요.');
		return;
	}
	if (obj.CODEGRADE == ''){
		alert('그룹/등급을 선택해주세요.');
		return;
	}
	console.log(obj);

	mx.SendPacket(null, obj);
};


mx.update_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTEDITOK;
	obj.IDX			        			=	$("#idx").val();

if (obj.IDX == undefined){
	alert("대상을 선택해 주세요.");
	return;
}

	obj.GameYear        				=	$("#GameYear").val();
	obj.GameTitleName 				=	$("#GameTitleName").val();
	obj.HostCode          				=	$("#HostCode").val();
	obj.GameS              			=	$("#GameS").val();
	obj.GameE              				=	$("#GameE").val();
	obj.GameArea         				=	$("#GameArea").val();
	obj.GameRcvS        				=	$("#GameRcvS").val();
	obj.GameRcvE        				=	$("#GameRcvE").val();
	obj.ViewYN              			=	$("#ViewYN").val();
	obj.MatchYN           				=	$("#MatchYN").val();
	obj.ViewState          			=	$("#ViewState").val();
	obj.TIE          						=	$("#tie").val();
	obj.DUC         						=	$("#deuce").val();
	obj.ENTERTYPE					  =	$("#entertype").val();
	obj.CODEGRADE         			=	$("#code_grade").val();
	obj.bigo				       			=	$("#bigo").val();	
	obj.chkrange						= 	$("#chkrange").val();	
	mx.SendPacket('titlelist_'+obj.IDX, obj);
};


mx.del_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTDEL;
	obj.IDX			        		    =	$("#idx").val();

if (obj.IDX == undefined){
	alert("대상을 선택해 주세요.");
	return;
}
	mx.SendPacket('titlelist_'+obj.IDX, obj);
};

mx.input_edit = function(idx){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTEDIT;
	obj.IDX = idx;
	mx.SendPacket('gameinput_area', obj);
};

mx.vaccreset = function(idx){
	var obj = {};
	obj.CMD = mx.CMD_VACCRESET;
	obj.IDX = idx;
	if (confirm("대회에 발급된 모든 계좌를 환수 시킵니다.")) {	
		mx.SendPacket("titlelist_"+idx, obj);
	}
};


$(document).ready(function(){
		localStorage.removeItem('MOREINFO');	
		localStorage.removeItem('GAMEINFO');
		mx.init();
}); 

mx.init = function(){

$(function() {
	$( "#GameS" ).datepicker({ 
			 changeYear:true,
			 changeMonth: true, 
			 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'], 
			 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			 showMonthAfterYear:true,
			 showButtonPanel: true, 
			 currentText: '오늘 날짜', 
			 closeText: '닫기', 
			 dateFormat: "yy-mm-dd"	
	});

	$( "#GameE" ).datepicker({ 
			 changeYear:true,
			 changeMonth: true, 
			 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'], 
			 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			 showMonthAfterYear:true,
			 showButtonPanel: true, 
			 currentText: '오늘 날짜', 
			 closeText: '닫기', 
			 dateFormat: "yy-mm-dd"	
	});


	$( "#GameRcvS" ).datepicker({ 
			 changeYear:true,
			 changeMonth: true, 
			 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'], 
			 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			 showMonthAfterYear:true,
			 showButtonPanel: true, 
			 currentText: '오늘 날짜', 
			 closeText: '닫기', 
			 dateFormat: "yy-mm-dd"	
	});



	$( "#GameRcvE" ).datepicker({ 
			 changeYear:true,
			 changeMonth: true, 
			 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'], 
			 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			 showMonthAfterYear:true,
			 showButtonPanel: true, 
			 currentText: '오늘 날짜', 
			 closeText: '닫기', 
			 dateFormat: "yy-mm-dd"	
	});
});


};


mx.golevel = function(idx,gametitle){
	var obj = {};
	obj.IDX = idx;
	obj.TITLE = gametitle;
	localStorage.setItem('GAMEINFO', JSON.stringify( obj  ));
	location.href="./contestlevel.asp?idx="+idx;
};

mx.goboo = function(idx,gametitle){
	var obj = {};
	obj.IDX = idx;
	obj.TITLE = gametitle;
	localStorage.setItem('GAMEINFO', JSON.stringify( obj  ));
	location.href="./contestlevel2.asp?idx="+idx;
};
