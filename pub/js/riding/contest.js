var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_VACCRESET = 422; //계좌정리
	mx.CMD_SETFLAG	 = 500; //참가,달력, 대진표 설정변경 1,2,3

	//========================
	mx.CMD_DATAGUBUN = 10000;
	//========================

	mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
	mx.CMD_GAMEINPUT = 30001;
	mx.CMD_GAMEINPUTEDIT = 30002; //수정
	mx.CMD_GAMEINPUTEDITOK = 30003;
	mx.CMD_GAMEINPUTDEL = 30004;// 삭제
	mx.CMD_EDITOR = 40000;
	mx.CMD_EDITOROK = 40001;
	mx.CMD_LIMIT = 41000;
	mx.CMD_LIMITOK = 41001;

	mx.CMD_RNKLIST = 40003; //랭킹리스트목록
	mx.CMD_SETRNKINFO = 40004; //랭킹 반영 처리

	mx.CMD_MAKEGOODS = 50000; //상품팝업
	mx.CMD_INSERTDEP1 = 50002; //상품저장

	mx.CMD_DELFILE = 51000; //파일삭제
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContest.asp";
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

mx.SendPacketEx = function(sender, packet, reqUrl){
    var strData = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );

    console.log( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
    $.ajax({
        url : reqUrl,
        type : mx.ajaxType,
        data : strData,
        dataType : mx.ajaxDataType,
        success: function(rcvData) {
			mx.ReceivePacket(packet.CMD, rcvData, sender);
        }
    });
};


mx.ReceivePacket = function( reqcmd, data, sender ){
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  if ( Number(reqcmd) > mx.CMD_DATAGUBUN  ){
    if ( data.indexOf("`##`") !== -1 ){//json + html
      resdata = data.split( "`##`" );
      jsondata =  resdata[0];
      if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
        htmldata = resdata[1];
    }
    else{ //html
      htmldata = data;
      //try{jsondata = JSON.parse(data); }
      //catch(ex){return;}
    }
  }
  else{//json
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( jsondata !='' && jsondata != null){
		switch (Number(jsondata.result)){
		case 0: break;
		case 1: alert('데이터가 존재하지 않습니다.');return;  break;
		case 88: alert('sitecode가 없습니다.  cfg.pub.asp 설정');return;  break;
		case 99: alert('정보가 일치하지 않습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
		}
  }

	switch (Number(reqcmd))	{
	case mx.CMD_GAMEINPUT:	this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_CONTESTAPPEND:	this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_DELFILE:
	case mx.CMD_GAMEINPUTEDITOK:
	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GAMEINPUTDEL:	this.OndelHTML( reqcmd, jsondata, htmldata, sender );		break;


	case mx.CMD_LIMIT:	this.OnLimit( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_LIMITOK:	this.OnLimitOK( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_EDITOR:	this.OnEditor( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_EDITOROK:	this.OnEditorOK( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_RNKLIST:	this.OnRnkList( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_SETRNKINFO:	this.OnsetRnk( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_VACCRESET:  this.ReturnVacOK( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_MAKEGOODS: this.OnwritePop( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_INSERTDEP1: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	}

};



//요청##################################################################
	mx.input_frm = function(){

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUT;
		//국제, 체전, 장소, 주최 , 주관, 후원, 대회명, 그룹, [전문, 생활, 유소년], [개인, 단체], 시작일, 종료일
		obj.PARR = new Array();

		var allidarr = ['mk_g0','mk_g1','mk_g2','mk_g3','mk_g4','mk_g5','mk_g6','mk_g7','mk_g8','mk_g9','mk_g10','mk_g11','mk_g12','mk_g13','mk_g14'];
		var chkboxidarr = ['mk_g8','mk_g9','mk_g10','mk_g11','mk_g12']; //체크박스의 아이디들
		var typechkbox = false;

		for (var i = 0;i< allidarr.length ;i++ ){
			typechkbox = false;
			for (var n = 0;n< chkboxidarr.length ;n++ ){
				if (allidarr[i] ==chkboxidarr[n]){ //체크박스라면
					typechkbox = true;
				}
			}

			if (typechkbox == true){
				if (  $("#"+allidarr[i]).is(":checked")  ){
					obj.PARR[i] = px.strReplaceAll( $("#"+allidarr[i]).val()  ,"," ,"`" );
				}
				else{
					obj.PARR[i] = '';
				}
			}
			else{
				obj.PARR[i] = px.strReplaceAll( $("#"+allidarr[i]).val()  , "," , "`" ); 
			}

		}

		var msgarr = ["","", "경기장소를 입력해 ","주최를 선택해 ","주관","후원",  "대회명을 입력해 ", "그룹을 선택해 ", "전문","생활","유소년","개인","단체","시작일을 입력해 ","종료일을 입력해 "]; //메시지
		var passarrno = [0,0,1,1,0,0, 1,1 ,0,0,0, 0,0, 1,1]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		mx.SendPacket(null, obj);
	};

	mx.input_edit = function(idx){
		$( "#contest tr").css( "background-color", "white" );
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" );

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDIT;
		obj.IDX = idx;
		mx.SendPacket('gameinput_area', obj);
	};

	mx.update_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDITOK;
		//국제, 체전, 장소, 주최 , 주관, 후원, 대회명, 그룹, [전문, 생활, 유소년], [개인, 단체], 시작일, 종료일
		obj.PARR = new Array();

		var allidarr = ['e_idx','mk_g0','mk_g1','mk_g2','mk_g3','mk_g4','mk_g5','mk_g6','mk_g7','mk_g8','mk_g9','mk_g10','mk_g11','mk_g12','mk_g13','mk_g14'];
		var chkboxidarr = ['mk_g8','mk_g9','mk_g10','mk_g11','mk_g12']; //체크박스의 아이디들
		var typechkbox = false;

		for (var i = 0;i< allidarr.length ;i++ ){
			typechkbox = false;
			for (var n = 0;n< chkboxidarr.length ;n++ ){
				if (allidarr[i] ==chkboxidarr[n]){ //체크박스라면
					typechkbox = true;
				}
			}

			if (typechkbox == true){
				if (  $("#"+allidarr[i]).is(":checked")  ){
					obj.PARR[i] = px.strReplaceAll( $("#"+allidarr[i]).val()  , "," , "`" ); 
				}
				else{
					obj.PARR[i] = '';
				}
			}
			else{
				obj.PARR[i] = px.strReplaceAll( $("#"+allidarr[i]).val()  , "," , "`" ); 
			}

		}

		var msgarr = ["대상을 선택해 ","","", "경기장소를 입력해 ","주최를 선택해 ","주관","후원",  "대회명을 입력해 ", "그룹을 선택해 ", "전문","생활","유소년","개인","단체","시작일을 입력해 ","종료일을 입력해 "]; //메시지
		var passarrno = [1,0,0,1,1,0,0, 1,1 ,0,0,0, 0,0, 1,1]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		mx.SendPacket('titlelist_'+obj.PARR[0], obj);
	};


	mx.del_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDEL;
		obj.IDX =	$("#e_idx").val();

		if (obj.IDX == undefined){
			alert("대상을 선택해 주세요.");
			return;
		}

		if (confirm('대상을 삭제하시겠습니까?')) {
			mx.SendPacket('titlelist_'+obj.IDX, obj);
		} else {
			return;
		}
	};

	mx.setFlag = function(idx, btnno ){
		var obj = {};
		obj.CMD = mx.CMD_SETFLAG;
		obj.IDX =	idx;
		obj.BTNNO = btnno;
		mx.SendPacket(null, obj);
	};


//응답##################################################################

	mx.OnBeforeHTML =  function(cmd, packet, html, sender){
		$('#fc').before(html);
	};

	mx.OndrowHTML =  function(cmd, packet, html, sender){
		document.getElementById(sender).innerHTML = html;
		if( cmd = mx.CMD_GAMEINPUTEDITOK){
			mx.init();
		}
	};

	mx.OndelHTML =  function(cmd, packet, html, sender){
		document.getElementById("gameinput_area").innerHTML = html;
		$("#"+sender).remove();

	};

	mx.OnAppendHTML =  function(cmd, packet, html, sender){
		$('#'+sender).append(html);
		//$("body").scrollTop($("body")[0].scrollHeight);
	};














//생성 팝업창 요청
mx.makeGoods = function(){
	var obj = {};
    obj.CMD = mx.CMD_MAKEGOODS;
	mx.SendPacket('modalS', obj);
};

mx.OnwritePop =  function(cmd, packet, html, sender){
	if( $('#' + sender).length == 0 ){
		document.body.innerHTML = "<div class='modal fade basic-modal myModal' id='"+sender+"' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'></div>";
	}
	$('#' + sender).html(html);
	$('#' + sender).modal('show');
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
	obj.NOTICETYPE =  $(":input:radio[name=noticetype]:checked").val();
	var editor = CKEDITOR.instances.editor1;
	var contents = editor.getData();
	if (editor.getData() == ''){
		editor.focus();
		return;
	}
	obj.CONTENTS = contents;
	mx.SendPacket('myModal', obj);
};



mx.setLimit =  function(tidx,gametitle){
	var obj = {};
	obj.CMD = mx.CMD_LIMIT;
	obj.TIDX = tidx;
	obj.TITLE = gametitle;
	mx.SendPacket('myModal', obj);
};

mx.limitOK = function(tidx,gametitle){
	var obj = {};
	obj.CMD = mx.CMD_LIMITOK;
	obj.TIDX = tidx;
	obj.TITLE = gametitle;
	//var editor = CKEDITOR.instances.editor1;
	//var contents = editor.getData();
	//if (editor.getData() == ''){
	//	editor.focus();
	//	return;
	//}
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


mx.OnLimit =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
	//CKEDITOR.replace( 'editor1' );
};

mx.OnLimitOK =  function(cmd, packet, html, sender){
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

mx.OnAppendHTML =  function(cmd, packet, html, sender){
	if ( packet.lastchk == "_end" ){return;}
	packet.NKEY = Number(packet.NKEY) + 1;
	localStorage.setItem('MOREINFO', JSON.stringify( packet  ));
	$('#'+sender).append(html);
	$("body").scrollTop($("body")[0].scrollHeight);
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



mx.vaccreset = function(idx){
	var obj = {};
	obj.CMD = mx.CMD_VACCRESET;
	obj.IDX = idx;
	if (confirm("대회에 발급된 모든 계좌를 환수 시킵니다.")) {
		mx.SendPacket("titlelist_"+idx, obj);
	}
};


$(document).ready(function(){
		mx.init();
});

mx.init = function(){

	$(function() {
		// $( "#mk_g13" ).datepicker({
		// 		 changeYear:true,
		// 		 changeMonth: true,
		// 		 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'],
		// 		 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		// 		 showMonthAfterYear:true,
		// 		 showButtonPanel: true,
		// 		 currentText: '오늘 날짜',
		// 		 closeText: '닫기',
		// 		 dateFormat: "yy-mm-dd"
		// });
		//
		// $( "#mk_g14" ).datepicker({
		// 		 changeYear:true,
		// 		 changeMonth: true,
		// 		 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'],
		// 		 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		// 		 showMonthAfterYear:true,
		// 		 showButtonPanel: true,
		// 		 currentText: '오늘 날짜',
		// 		 closeText: '닫기',
		// 		 dateFormat: "yy-mm-dd"
		// });

		$('.date').datetimepicker({
			format: 'YYYY-MM-DD',
			locale:'KO'
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



mx.getExtensionOfFilename = function(filename) {
 
    var _fileLen = filename.length;
 
    /** 
     * lastIndexOf('.') 
     * 뒤에서부터 '.'의 위치를 찾기위한 함수
     * 검색 문자의 위치를 반환한다.
     * 파일 이름에 '.'이 포함되는 경우가 있기 때문에 lastIndexOf() 사용
     */
    var _lastDot = filename.lastIndexOf('.');
 
    // 확장자 명만 추출한 후 소문자로 변경
    var _fileExt = filename.substring(_lastDot, _fileLen).toLowerCase();
 
    return _fileExt;
};




//////////////////////////////////////////////////////////
//파일업로드
//////////////////////////////////////////////////////////
mx.fileUpload = function(chktype){
	switch (chktype)
	{
	case "noticeimg":
		var form = $('#JPGFORM')[0]; 
		var formData = new FormData(form);
		var fileext = mx.getExtensionOfFilename(form.noticefile.value);

		//console.log(fileext);		
		if (fileext != ".jpg" )	{
			alert("jpg 파일만 허용합니다.")
			return;
		}
	break;
	case "attachment":
		//폼전체를 보낼때
		var form = $('#FILEFORM')[0]; 
		var formData = new FormData(form);
		var fileext = mx.getExtensionOfFilename(form.noticefile.value);

		//console.log(fileext);		
		if (fileext != ".hwp" &&  fileext != ".pdf" )	{
			alert("hwp, pdf 파일만 허용합니다.")
			return;
		}
	break;
	}

	//객체만들어서 하나씩 담을때
	//var formData = new FormData();
	//formData.append("fileObj", $("#FILETAG")[0].files[0]);
	$.ajax({
		url: '/pub/up/imgUpload.gamenotice.asp',
				processData: false,
				contentType: false,
				data: formData,
				type: 'POST',
				success: function(rdata){
					switch (chktype){
					case "noticeimg":$('#noticeimgs').html(rdata); break;
					case "attachment":$('#files').html(rdata); break;
					}
				}
		});
};


mx.delFile = function(tidx,filename,chktype){ //대회인덱스, 파일명, 이미지인지, 파일인지 타입
	if (!confirm('삭제하시겠습니까?')) {
		return;
	}
	//삭제할지 물어보고
	var obj = {};
	obj.CMD = mx.CMD_DELFILE;
	obj.TIDX = tidx;
	obj.FNM = filename;
	obj.UPTYPE = chktype;
	switch (chktype){
	case "img":mx.SendPacket('noticeimgs', obj);	 break;
	case "file":mx.SendPacket('files', obj);	 break;
	}	
	
};
