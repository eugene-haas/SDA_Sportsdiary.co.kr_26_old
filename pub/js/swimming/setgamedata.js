var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_GETGAMELIST = 11000;

  mx.CMD_FILEFORM = 12000; //xls 업로드
  mx.CMD_INSERTMEMBER = 300;
  mx.CMD_INSERTMEMBERA = 301;
  mx.CMD_INSERTTEMP = 200;
  mx.CMD_INSERTTEMPA = 201;

  mx.CMD_RESETDATA = 400;
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqsetgamedata.asp";
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
      htmldata = data;
    }
  }
  else{

    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( jsondata !='' && jsondata != null){
    switch (Number(jsondata.result))  {
    case 0: break;
    case 1: alert('데이터가 존재하지 않습니다.');return;  break;
    case 2: alert('동일한 데이터가 존재합니다.');return;  break;
    case 3: alert('참가신청 자가 있어 수정및 삭제가 불가능 합니다.');return;  break;
    case 4: alert('대회에 생성된 부서가 있어 복사할수 없습니다.');return;  break;
    case 5: alert('이미 등록된 날짜 입니다.');return;  break;
    case 6: alert('이미 등록된 경기입니다.');return;  break;
    case 7: alert('이미 등록된 경기입니다.');return;  break;
    case 8: alert('대진표 편성이 완료 되지 않았습니다.');return;  break;
    case 9: alert('등록된 파일이 없습니다.');return;  break;
    case 99: alert('종목명이 정확히 기입되지 않았을 수 있습니다. 코드가 생성되지 않았습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}
	return;   break;

	}
  }

  switch (Number(reqcmd)) {
	case mx.CMD_INSERTTEMPA :
	case mx.CMD_INSERTTEMP  : alert("기본설정 저장완료"); 	window.location.reload();	break;
	case mx.CMD_INSERTMEMBERA:
	case mx.CMD_INSERTMEMBER :alert("참가자 신청이 완료되었습니다.");	window.location.reload();	break;
	case mx.CMD_RESETDATA :alert("설정과 참가자가 리셋되었습니다.");	window.location.reload();	break;
	case mx.CMD_FILEFORM:  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );	break;
  }
};


//요청##################################################################
	mx.resetData = function(tidx){
		  if (confirm("정말 삭제 하시겠습니까?")) {
				var obj = {};
				obj.CMD = mx.CMD_RESETDATA;
				obj.TIDX = tidx;
				mx.SendPacket('modalB', obj);
		  }
		  else{
			return;
		  }
	};

	mx.insertRequest = function(tidx){
		var obj = {};
		obj.CMD = mx.CMD_INSERTMEMBER;
		obj.TIDX = tidx;
		mx.SendPacket('modalB', obj);
	};


	//아마추어
	mx.insertRequestA = function(tidx){
		var obj = {};
		obj.CMD = mx.CMD_INSERTMEMBERA;
		obj.TIDX = tidx;
		mx.SendPacket('modalB', obj);
	};

	mx.insertTemp = function(tidx){
		var obj = {};
		obj.CMD = mx.CMD_INSERTTEMP;
		obj.TIDX = tidx;
		mx.SendPacket('modalB', obj);
	};

	//아마추어
	mx.insertTempA = function(tidx){
		var obj = {};
		obj.CMD = mx.CMD_INSERTTEMPA;
		obj.TIDX = tidx;
		mx.SendPacket('modalB', obj);
	};


	mx.fileupload = function(tidx){ 
		var obj = {};
		obj.CMD = mx.CMD_FILEFORM;
		obj.TIDX = tidx;
		mx.SendPacket('modalB', obj);
	}; 

		

	mx.fileUpload = function(){
		//폼전체를 보낼때
		var form = $('#FILEFORM')[0]; 
		var formData = new FormData(form);
		var fileext = mx.getExtensionOfFilename(form.exlfile.value);

		//console.log(fileext);		
		if (fileext != ".xls" &&  fileext != ".xlsx" )	{
			alert("xls, xlsx 파일만 허용합니다.")
			return;
		}


		//객체만들어서 하나씩 담을때
		//var formData = new FormData();
		//formData.append("fileObj", $("#FILETAG")[0].files[0]);
		$.ajax({
			url: '/pub/up/xlsUpload.asp',
					processData: false,
					contentType: false,
					data: formData,
					type: 'POST',
					success: function(rdata){
						$('#files').html(rdata);
						alert("파일이 업로드 되었습니다.");
						window.location.reload(); //리스트 상태 새로고침
						//$('#modalB').modal('show');
						//switch (chktype){
						//case "attachment":$('#files').html(rdata); break;
						//}
					}
			});
	};

	mx.getExtensionOfFilename = function(filename) {
	 
		var _fileLen = filename.length;
		var _lastDot = filename.lastIndexOf('.');
	 
		// 확장자 명만 추출한 후 소문자로 변경
		var _fileExt = filename.substring(_lastDot, _fileLen).toLowerCase();
		return _fileExt;
	};















//응답##################################################################
mx.OndrowHTML =  function(cmd, packet, html, sender){
	if(cmd == mx.CMD_FILEFORM){
		if( $('#modalB').length == 0 ){
			$('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
		}
		document.getElementById("modalB").innerHTML = html;
		$('#modalB').modal('show');
	}
	else{
		document.getElementById(sender).innerHTML = html;	
	}
};




//클릭위치로 돌려놓기
$(document).ready(function(){

        //var offset = $("#div" + seq).offset();
        $('html, body').animate({scrollTop : localStorage.getItem('scrollpostion')}, 400);
//document.body

//	$(document).scrollTop(localStorage.getItem('scrollpostion'));

	$(document).click(function(event){
		window.toriScroll = $(document).scrollTop();
		localStorage.setItem('scrollpostion',window.toriScroll);
		console.log(window.toriScroll);
	});
});

////////////////////////////////////////////////////////////////


