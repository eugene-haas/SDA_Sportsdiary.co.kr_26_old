var mx =  mx || {};
////////////////////////////////////////
	//========================
	mx.CMD_DATAGUBUN = 10000;
	//========================

	mx.CMD_INPUT = 30001;
	mx.CMD_EDIT = 30002; //수정
	mx.CMD_EDITOK = 30003;
	mx.CMD_DEL = 30004;// 삭제
	mx.CMD_DELFILE = 110; //개별파일삭제
	mx.CMD_SETVIDEO = 120;// URL저장

	//편집기
	mx.CMD_EDITOR = 40000;
	mx.CMD_EDITOROK = 40001;




	mx.CMD_BTNST = 100;
	mx.CMD_GETFINDPLAYER = 200; //선수정보가져오기

	mx.CMD_FILEFORM = 12000; //업로드(창)
	mx.CMD_POP = 12001; //팝업(리스트)
////////////////////////////////////////


mx.ajaxurl = "/pub/ajax/riding/reqBasic.asp";
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

mx.ReceivePacket = function( reqcmd, data, sender ){// data는 response string

	var IsJsonString = function(str) {
	try {
		var json = JSON.parse(str);
		return (typeof json === 'object');
		} catch (e) {
			return false;
		}
	};

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
      if (IsJsonString(data)){
			jsondata = JSON.parse(data);
      }
	  else{
	      htmldata = data;
	  }
    }
  }
  else{
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( IsJsonString(data) ){
	    switch (Number(jsondata.result))  {
		case 0: break;
		case 1: alert('데이터가 존재하지 않습니다.');return;  break;
		case 88: alert('sitecode가 없습니다.  cfg.pub.asp 설정');return;  break;
		case 99: alert('정보가 일치하지 않습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
		}
  }

	switch (Number(reqcmd))	{
	case mx.CMD_SETVIDEO : alert('경로가 저장되었습니다.'); break;
	case mx.CMD_DELFILE :
	//alert('파일이 삭제되었습니다.');
	 $('p').remove('#'+sender);
	  break;
	case mx.CMD_BTNST: return;
	case mx.CMD_INPUTDEL:
	case mx.CMD_EDITOK:
	case mx.CMD_DEL:
	case mx.CMD_INPUT:	window.location.reload();	break;

	case mx.CMD_POP:
	case mx.CMD_FILEFORM:
	case mx.CMD_EDIT:  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;


	case mx.CMD_EDITOR:	this.OnEditor( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_EDITOROK:	this.OnEditorOK( reqcmd, jsondata, htmldata, sender );		break;
	}
};



//요청##################################################################
	mx.videoURL = function(seq,sendpre,val){
		var obj = {};
		obj.CMD = mx.CMD_SETVIDEO;
		obj.SENDPRE = sendpre;
		obj.SEQ =	seq;
		obj.VAL = val;
		//alert(val);
		mx.SendPacket(null, obj);
	};

	mx.del_file = function(sendpre,seq){
		var obj = {};
		obj.CMD = mx.CMD_DELFILE;
		obj.SENDPRE = sendpre;
		obj.SEQ =	seq;

		if (confirm('대상을 삭제하시겠습니까?')) {
				mx.SendPacket('f_'+seq, obj);
		} else {
			return;
		}
	};

	mx.chkValue = function(chkval,msg){
		if (chkval == "" || chkval == undefined){
			//alert(msg + "주세요.");
			return false;
		}else{
			return true;
		}
	};

	mx.input_frm = function(sendpre){
		//var lastno = $("input[id^='mk_g']").length; //관련 폼아이디 갯수
		var lastno = $("[id^='mk_g']").length; //관련 폼아이디 갯수

		var obj = {};
		obj.CMD = mx.CMD_INPUT;
		obj.SENDPRE = sendpre;
		obj.PARR = new Array();

		var allidarr = [];
		//var passarrno = [0,0,0,0,0,0]; //체크메시지 통과여부 플레그 0패스 1체크
		var passarrno = [];
		var msgarr = []; //메세지
		for (var x = 0;x < lastno ;x++ ){
			allidarr[x] = "mk_g" + x;
			passarrno[x] = 1; //모두체크
			msgarr[x] = x + "번째 값을 넣어 ";
		}

		//객체파람설정
		for (var i = 0;i< allidarr.length ;i++ ){
			obj.PARR[i] = $("#"+allidarr[i]).val();
			//console.log(obj.PARR[i]);
		}

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (mx.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					//console.log(allidarr[i]);
					return;
				}
			}
		}
		mx.SendPacket(null, obj);
	};

	mx.input_edit = function(idx,sendpre){
		$( "#contest tr").css( "background-color", "white" );
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" );
		var obj = {};
		obj.CMD = mx.CMD_EDIT;
		obj.SENDPRE = sendpre;
		obj.IDX = idx;
		mx.SendPacket('gameinput_area', obj);
	};

	mx.update_frm = function(sendpre){
		if($('#e_idx').val() ==  undefined ){
			alert("목록에서 대상을 선택해 주세요.");
			return;
		}

		//var lastno = $("input[id^='mk_g']").length; //관련 폼아이디 갯수
		var lastno = $("[id^='mk_g']").length; //관련 폼아이디 갯수
		var obj = {};
		obj.CMD = mx.CMD_EDITOK;
		obj.SENDPRE = sendpre;
		obj.PARR = new Array();

		var allidarr = [];
		var passarrno = [];
		var msgarr = []; //메세지
		for (var x = 0;x < lastno ;x++ ){
			allidarr[x] = "mk_g" + x;
			passarrno[x] = 1; //모두체크
			msgarr[x] = x + "번째 값을 넣어 ";
		}
		allidarr[x] = "e_idx";

		for (var i = 0;i< allidarr.length ;i++ ){
			obj.PARR[i] = $("#"+allidarr[i]).val();
		}

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (mx.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					return;
				}
			}
		}
		mx.SendPacket(null, obj);
	};


	mx.del_frm = function(sendpre){
		var obj = {};
		obj.CMD = mx.CMD_DEL;
		obj.SENDPRE = sendpre;
		obj.IDX =	$("#e_idx").val();

		if (obj.IDX == undefined){
			alert("목록에서 대상을 선택해 주세요.");
			return;
		}

		if (confirm('대상을 삭제하시겠습니까?')) {
			mx.SendPacket('titlelist_'+obj.IDX, obj);
		} else {
			return;
		}
	};


	//버튼상태변경
	mx.setBtnState = function(targetid,seq,targetfld,sendpre) {
		var obj = {};
		obj.CMD = mx.CMD_BTNST;
		obj.SENDPRE = sendpre;
		obj.SEQ = seq;
		obj.FLD = targetfld;
		mx.SendPacket(null, obj);
	};

	mx.editor =  function(idx,title,sendpre){
		var obj = {};
		obj.CMD = mx.CMD_EDITOR;
		obj.IDX = idx;
		obj.TITLE = title;
		obj.SENDPRE = sendpre;
		mx.SendPacket('myModal', obj);
	};

	mx.editOK = function(idx,sendpre){
		var obj = {};
		obj.CMD = mx.CMD_EDITOROK;
		obj.IDX = idx;
		obj.SENDPRE = sendpre;
		var editor = CKEDITOR.instances.editor1;
		var contents = editor.getData();
		if (editor.getData() == ''){
			editor.focus();
			return;
		}
		obj.CONTENTS = contents;
		mx.SendPacket('myModal', obj);
	};



	//find list
	//playeridx,username,eng_nm,team,teamnm,ksportsno,sex,birthday
	mx.CMD_SEARCH = mx.CMD_GETFINDPLAYER;
	mx.pagenm = location.pathname.split('/').slice(-1)[0];
	mx.setfind = function(){

			if ( $("#mk_g1").length > 0 ) {
				$( "#mk_g1" ).autocomplete({
					source : function( request, response ) {

						var sendpre = "kor_";
						switch (mx.pagenm) {
						case 'korlist.asp': mx.CMD_SEARCH = mx.CMD_GETFINDPLAYER; sendpre = "kor_";	break;
						}

						 $.ajax({
								type: mx.ajaxtype,
								url: mx.ajaxurl,
								dataType: "json",
								data: { "REQ" : JSON.stringify({"CMD":mx.CMD_SEARCH, "SVAL":request.term, "PARM1": $("#mk_g0").val(), "SENDPRE": sendpre})  },
								success: function(data) {
									//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
									console.log( px.strReplaceAll(JSON.stringify( data  ), '\"', '\"\"') );
									response(
										$.map(data, function(item) {
											return {
												label: item.fa + ' | ' + item.fd,
												value: item.fa,
												idx:item.idx,
												fa:item.fa,
												fb:item.fb,
												fc:item.fc,
												fd:item.fd,
												fe:item.fe,
												ff:item.ff,
												fg:item.fg,

												}
										})
									);
								}
						   });
						},

					//조회를 위한 최소글자수
					minLength: 1,
					select: function( event, ui ) {
						switch (mx.pagenm) {
						case 'korlist.asp':
							$("#mk_g2").val(ui.item.idx);
							$("#mk_g3").val(ui.item.fb);
							$("#mk_g4").val(ui.item.fc);
							$("#mk_g5").val(ui.item.fd);
							$("#mk_g6").val(ui.item.fe);
							$("#mk_g7").val(ui.item.ff);
							$("#mk_g8").val(ui.item.fg);
						break;
						}

					}
				});
			}
	};


	$(document).ready(function(){
		mx.init();
	});

	mx.init = function(){

		//클릭위치로 돌려놓기
			$("#sc_body").scrollTop(localStorage.getItem('scrollpostion'));
			$("#sc_body").click(function(event){
				window.toriScroll = $("#sc_body").scrollTop();
				localStorage.setItem('scrollpostion',window.toriScroll);
				console.log($("#sc_body").scrollTop());
			});


		$(function() {
			$('.date').datetimepicker({
				format: 'YYYY-MM-DD',
				locale:'KO'
			});
		});

		mx.setfind();

	};




//응답##################################################################
	mx.OndrowHTML =  function(cmd, packet, html, sender){
		document.getElementById(sender).innerHTML = html;
		if( cmd == mx.CMD_EDIT){
			mx.init();
		}

		else if(cmd == mx.CMD_FILEFORM || cmd == mx.CMD_POP){
			if( $('#' + sender).length == 0 ){
				$('body').append("<div id='"+sender+"' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
			}
			$('#'+sender).html(html);
			$('#'+sender).modal('show');
		}
		else{
			$('#'+sender).html(html);
		}


	};







	//편집기 생성요청
	mx.OnEditor =  function(cmd, packet, html, sender){
		if( $('#' + sender).length == 0 ){
			$('#'+sender).html("<div class='modal fade basic-modal myModal' id='"+sender+"' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'></div>");
		}
		else{
			$('#'+sender).html(html);
		}
		$('#'+sender).modal('show');
		CKEDITOR.replace( 'editor1' );

	};

	mx.OnEditorOK =  function(cmd, packet, html, sender){
		alert("저장이 완료 되었습니다.");
		$('#'+sender).modal('hide');

	};



	mx.Pop = function(chkno,seq,sendpre){
		var obj = {};
		obj.CMD = mx.CMD_POP;
		obj.SENDPRE = sendpre;
		obj.CHKNO = chkno;
		obj.SEQ = seq;
		mx.SendPacket('modalB', obj);
	};


	//////////////////////////////////////////////////////////
	//파일업로드
	//////////////////////////////////////////////////////////
	mx.fileuploadPop = function(chkno,seq,sendpre){
		var obj = {};
		obj.CMD = mx.CMD_FILEFORM;
		obj.SENDPRE = sendpre;
		obj.CHKNO = chkno;
		obj.SEQ = seq;
		mx.SendPacket('modalB', obj);
	};

	mx.fileCheck =function( file )
	{
			// 사이즈체크
			var maxSize  = 3 * 1024 * 1024;    //3MB
			var fileSize = 0;

		// 브라우저 확인
		var browser=navigator.appName;
		
		// 익스플로러일 경우
		if (browser=="Microsoft Internet Explorer")
		{
			var oas = new ActiveXObject("Scripting.FileSystemObject");
			fileSize = oas.getFile( file.value ).size;
		}
		// 익스플로러가 아닐경우
		else
		{
			fileSize = file.files[0].size;
		}

		//alert("파일사이즈 : "+ fileSize +", 최대파일사이즈 : 3MB");
		//return false;

			if(fileSize > maxSize)
			{
				alert("첨부파일 사이즈는 3MB 이내로 등록 가능합니다.    ");
				return false;
			}
			else{
				return true;
			}

	};


	mx.fileUpload = function(){
		var getExtensionOfFilename = function(filename) {
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

		//var form = "";
		var formData = "";

		switch ($('#CHKNO').val())
		{
		case "1":
			//form = $('#FILEFORM')[0];
			formData = new FormData($('#FILEFORM')[0]);
			var fileext = getExtensionOfFilename($('#FILEFORM')[0].upfile.value);

			if (mx.fileCheck( $('#FILEFORM')[0].upfile ) == false){ //파일크기 체크
				return false;
			}


			//console.log(fileext);
			if (fileext != ".jpg" && fileext != ".hwp" &&  fileext != ".pdf" &&  fileext != ".doc" &&  fileext != ".exl" )	{
				alert("허용되는 파일이 아닙니다.")
				return;
			}
		break;
		case "2":
			//form = $('#FILEFORM')[0];
			formData = new FormData($('#FILEFORM')[0]);
			var fileext = getExtensionOfFilename($('#FILEFORM')[0].upfile.value);

			if (mx.fileCheck( $('#FILEFORM')[0].upfile ) == false){ //파일크기 체크
				return false;
			}

			//console.log(fileext);
			if (fileext != ".jpg" &&  fileext != ".png"  )	{
				alert("허용되는 파일이 아닙니다.")
				return;
			}
		break;
		}

		formData = new FormData($('#FILEFORM')[0]);

		var upurl = '/pub/up/ridingUpload.asp';
		$.ajax({
			url:  '/pub/up/ridingUpload.asp',
					processData: false,
					contentType: false,
					data: formData,
					type: 'POST',
					success: function(rdata){
						$('#files').html(rdata);
						alert("파일이 업로드 되었습니다.");
						window.location.reload(); //리스트 상태 새로고침
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
