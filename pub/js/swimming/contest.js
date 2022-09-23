var mx =  mx || {};
////////////////////////////////////////
	//========================
	mx.CMD_DATAGUBUN = 10000;
	//========================

	mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기

	mx.CMD_GAMEINPUT = 30001;
	mx.CMD_GAMEINPUTEDIT = 30002; //수정
	mx.CMD_GAMEINPUTEDITOK = 30003;
	mx.CMD_GAMEINPUTDEL = 30004;// 삭제

	mx.CMD_BTNST = 100;
	mx.CMD_SETBEA	 = 40000;

  mx.CMD_PRINT = 60001; //인쇄
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','ming') + "/reqContest.asp";
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

mx.IsJsonString = function(str) {
	try {
		var json = JSON.parse(str);
	return (typeof json === 'object');
	} catch (e) {
		return false;
	}
};


mx.ReceivePacket = function( reqcmd, data, sender ){// data는 response string

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
      if (mx.IsJsonString(data)){
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

  if( mx.IsJsonString(data) ){
	    switch (Number(jsondata.result))  {
		case 0: break;
		case 1: alert('데이터가 존재하지 않습니다.');return;  break;
		case 88: alert('sitecode가 없습니다.  cfg.pub.asp 설정');return;  break;
		case 99: alert('정보가 일치하지 않습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
		}
  }

	switch (Number(reqcmd))	{
	case mx.CMD_BTNST: return;
	case mx.CMD_GAMEINPUTDEL:
	case mx.CMD_GAMEINPUTEDITOK:
	case mx.CMD_GAMEINPUT:	window.location.reload();	break;
	//case mx.CMD_GAMEINPUT:	break;

	case mx.CMD_SETBEA	:
	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_PRINT	:	this.OnPrint( reqcmd, jsondata, htmldata, sender );		break;
	}

};

	mx.gameCodeWindow = function(codestr){
			if( $('#modalB').length == 0 ){
				$('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'><div class='modal-dialog'><div class='modal-content'><div class='modal-header game-ctr'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button><h4 class='modal-title' id='myModalLabel'>대회코드</button></h4></div><div class='box-body' id='gc'>  </div><div class='modal-footer'><a href='#' class='btn btn-default' data-dismiss='modal'>닫기</a></div></div></div></div>");
			}
			document.getElementById("gc").innerHTML = codestr;
			$('#modalB').modal('show');
	};




//요청##################################################################
//인쇄요청
//  beforePrintEvent: null,     // function for printEvent in iframe
//  beforePrint: null,          // function called before iframe is filled
//  afterPrint: null            // function called before iframe is removed

mx.afterPrint = function () {
	//제공하는거니까 그냥 쓰면됨.
	//if(!confirm('출력 또는 취소 하시면 재출력이 불가합니다.?')){
	//	return;
	//}
							// var obj = {};
							// obj.CMD = mx.CMD_PRINTEND;
							// obj.SEQ = $('#printkey').val();
							// obj.SENDPRE = 'home_';
							// mx.SendPacket(null, obj);

	//if (window.matchMedia) {
	//	var mediaQueryList = window.matchMedia('print');
	//	mediaQueryList.addListener(function (mql) {
	//		console.log($(mediaQueryList).html());
	//		if (mql.matches) {
	//			beforePrint();
	//		} else {
	//			afterPrint();
	//		}
	//	});
	//}
};

mx.print = function(tidx,f1,f2, linecnt){
	var obj = {};
	obj.CMD = mx.CMD_PRINT;
	obj.TIDX = tidx;
	obj.F1 = f1;
	obj.F2 = f2;
	obj.LINECNT  = linecnt;
	obj.GUBUN = 1;

	var $checkTable = $('#swtable');
	var $checkList = $checkTable.find("input[type='checkbox']");

	var checkkeys = "";



	for (let i = 1; i < $checkList.length; i++) {

		 if($('#'+$checkList[i].id).is(":checked") == true){
				if (i == 1 ){
					checkkeys = $('#'+$checkList[i].id).val();
				}
				else{
					checkkeys = checkkeys + ',' + $('#'+$checkList[i].id).val();
				}
		 }
	}

	if(checkkeys == ""){
		alert("인쇄할 항목을 선택해 주십시오.");
		return;
	}
	obj.MKEYS = checkkeys;
	mx.SendPacket(null, obj);
};

mx.print2 = function(tidx,f1,f2, linecnt){
	var obj = {};
	obj.CMD = mx.CMD_PRINT;
	obj.TIDX = tidx;
	obj.F1 = f1;
	obj.F2 = f2;
	obj.LINECNT  = linecnt;
	obj.GUBUN = 2;

	var $checkTable = $('#swtable');
	var $checkList = $checkTable.find("input[type='checkbox']");

	var checkkeys = "";



	for (let i = 1; i < $checkList.length; i++) {

		 if($('#'+$checkList[i].id).is(":checked") == true){
				if (i == 1 ){
					checkkeys = $('#'+$checkList[i].id).val();
				}
				else{
					checkkeys = checkkeys + ',' + $('#'+$checkList[i].id).val();
				}
		 }
	}

	if(checkkeys == ""){
		alert("인쇄할 항목을 선택해 주십시오.");
		return;
	}
	obj.MKEYS = checkkeys;
	mx.SendPacket(null, obj);
};



//인쇄응답
mx.OnPrint =  function(cmd, packet, html, sender){
	$('#printdiv').html(html);
	$('#printdiv').printThis({importCSS: false,loadCSS: '/pub/css/print.css?ver=0.0.1',header: false, afterPrint: mx.afterPrint });
};

mx.setBea = function(){
		var obj = {};
		obj.CMD = mx.CMD_SETBEA;
		obj.VAL  = $('#mk_g15').val();
		mx.SendPacket('bea', obj);
};

	mx.input_frm = function(){

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUT;
		//국제, 체전, 장소, 주최 , 주관, 후원, 대회명, 그룹, [전문, 생활, 유소년], [개인, 단체], 시작일, 종료일
		obj.PARR = new Array();

		var allidarr = [];
		for (var x = 0;x < 23 ;x++ ){
			allidarr[x] = "mk_g" + x;
		}

		var chkboxidarr = ['mk_g17','mk_g18','mk_g19','mk_g20']; //체크박스의 아이디들
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
					obj.PARR[i] = $("#"+allidarr[i]).val();
				}
				else{
					obj.PARR[i] = '';
				}
			}
			else{
				obj.PARR[i] = $("#"+allidarr[i]).val();
			}

		}

		var msgarr = [];
		for (var x = 0;x < 23 ;x++ ){
			msgarr[x] = "";
		}
		msgarr[2] = "경기장소를 입력해 ";
		msgarr[7] = "대회명을 입력해 ";
		msgarr[11] = "대회코드를 입력해 ";
		msgarr[12] = "참가비를 입력해 ";
		msgarr[13] = "대회기간을 입력해 ";
		msgarr[14] = "신청기간을 입력해 ";


		//var msgarr = ["경기장소를 입력해 ","대회명을 입력해 ", "대회코드를 입력해 ", "참가비를 입력해 ","대회기간을 입력해 ","신청기간을 입력해 ", "개인","팀","시도신청","시도승인"]; //메시지
		var passarrno = [0,0,1,0,0,0,0  ,1,0,0,0,1,1  ,1,1,0,0, 0,0,0,0,0,0]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
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
		if($('#e_idx').val() ==  undefined ){
			alert("목록에서 대상을 선택해 주세요.");
			return;
		}

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDITOK;
		//e_idx , 국제, 체전, 장소, 주최 , 주관, 후원, 대회명, 그룹, [전문, 생활, 유소년], [개인, 단체], 시작일, 종료일
		obj.PARR = new Array();

		var allidarr = [];
		for (var x = 0;x < 23 ;x++ ){
			allidarr[x] = "mk_g" + x;
		}
		allidarr[x] = "e_idx";

		var chkboxidarr = ['mk_g17','mk_g18','mk_g19','mk_g20']; //체크박스의 아이디들
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
					obj.PARR[i] = $("#"+allidarr[i]).val();
				}
				else{
					obj.PARR[i] = '';
				}
			}
			else{
				obj.PARR[i] = $("#"+allidarr[i]).val();
			}
		}

		var msgarr = [];
		for (var x = 0;x < 23 ;x++ ){
			msgarr[x] = "";
		}
		msgarr[2] = "경기장소를 입력해 ";
		msgarr[7] = "대회명을 입력해 ";
		msgarr[11] = "대회코드를 입력해 ";
		msgarr[12] = "참가비를 입력해 ";
		msgarr[13] = "대회기간을 입력해 ";
		msgarr[14] = "신청기간을 입력해 ";
		msgarr[17] = "개인";
		msgarr[18] = "팀";
		msgarr[19] = "시도신청";
		msgarr[20] = "시도승인";

		//var msgarr = ["경기장소를 입력해 ","대회명을 입력해 ", "대회코드를 입력해 ", "참가비를 입력해 ","대회기간을 입력해 ","신청기간을 입력해 ", "개인","팀","시도신청","시도승인"]; //메시지
		var passarrno = [0,0,1,0,0,0,0  ,1,0,0,0,1,1  ,1,1,0,0, 0,0,0,0,0,0]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					return;
				}
			}
		}
		mx.SendPacket(null, obj);
	};


	mx.del_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDEL;
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
	mx.setBtnState = function(targetid,seq,targetfld) {
		var obj = {};
		obj.CMD = mx.CMD_BTNST;
		if ( $('#'+targetid).text().trim() == "N")	{
			$('#'+targetid).text('Y');
			$('#'+targetid).attr('class','btn btn-fix-sm btn-warning');
		}
		else{
			$('#'+targetid).text('N');
			$('#'+targetid).attr('class','btn btn-fix-sm btn-default');
		}

		obj.SEQ = seq;
		obj.FLD = targetfld;
		mx.SendPacket(null, obj);
	};





//응답##################################################################

	mx.OnBeforeHTML =  function(cmd, packet, html, sender){
		$('#fc').before(html);
	};

	mx.OndrowHTML =  function(cmd, packet, html, sender){
		document.getElementById(sender).innerHTML = html;
		if( cmd == mx.CMD_GAMEINPUTEDIT){
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
		//mx.init();
});

mx.init = function(){


    //Date range picker
    $('#mk_g13').daterangepicker({format: 'YYYY/MM/DD',locale:'KO'});
    //Date range picker with time picker
    $('#mk_g14').daterangepicker({timePicker: true, timePickerIncrement: 30, format: 'YYYY/MM/DD h:mm A',locale:'KO'});
    //Date range as a button
    $('#daterange-btn').daterangepicker(
        {
          ranges: {
            'Today': [moment(), moment()],
            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
            'Last 7 Days': [moment().subtract(6, 'days'), moment()],
            'Last 30 Days': [moment().subtract(29, 'days'), moment()],
            'This Month': [moment().startOf('month'), moment().endOf('month')],
            'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
          },
          startDate: moment().subtract(29, 'days'),
          endDate: moment()
        },
        function (start, end) {
          $('#daterange-btn span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
        }
    );



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
