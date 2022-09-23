var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;


  mx.CMD_SENDSMS = 101;
  mx.CMD_CHECKSMS = 200;
  mx.CMD_SETCINFO = 222; //temp 정보저장

  mx.CMD_SETGAMETITLE = 10001; //선택년도 대회명 가져오기
  mx.CMD_PRINT = 60001; //인쇄
  mx.CMD_PRINTPRE = 60002;


////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqCertificate.asp";
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
    case 2: alert('동일한 데이터가 존재합니다.');return;  break;
    case 3: alert('등록된 선수 명단에 없습니다. 별도문의 후  이용하여 주십시오.');return;  break;
    case 4: alert('인증번호가 틀립니다. 정확히 입력하여 주십시오.');return;  break;    
    case 8: alert(jsondata.msg);return;  break;
    case 100: return;   break; //메시지 없슴
	return;   break;
	}
  }

  switch (Number(reqcmd)) {
	case mx.CMD_SETCINFO: return; break;

	case mx.CMD_SENDSMS : this.OnMsg( reqcmd, jsondata, htmldata, sender );  break;
	case mx.CMD_CHECKSMS : this.OnCheck( reqcmd, jsondata, htmldata, sender );  break;


	case mx.CMD_GAMEINPUT:	window.location.reload();	break;

	case mx.CMD_SETGAMETITLE :
	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_PRINTPRE :
	case mx.CMD_PRINT	:	this.OnPrint( reqcmd, jsondata, htmldata, sender );		break;
  }
};


//요청##################################################################
	//인증
	mx.SMS = function(){
		var obj = {};
		obj.CMD = mx.CMD_SENDSMS;
		obj.NM = $('#nm').val();
		obj.PNO = $('#pno').val();
		obj.CTYPE = $('#certificatetype').val();
		mx.SendPacket(null, obj);
	};

	//확인
	mx.chkSMS = function(){
		var obj = {};
		obj.CMD = mx.CMD_CHECKSMS;
		obj.NM = $('#nm').val();
		obj.PNO = $('#pno').val();
		obj.CTYPE = $('#certificatetype').val();
		obj.CHKNO = $('#chkno').val();
		mx.SendPacket(null, obj);
	};


	//정보변경
	mx.setCInfo  = function(pidx){
		var obj = {};
		obj.CMD = mx.CMD_SETCINFO;
		obj.C1 = $('#c1').val();
		obj.C2 = $('#c2').val();
		obj.C3 = $('#c3').val();
		obj.C4 = mx.gameidx.join();
		obj.PIDX = pidx;

		if(obj.C3 == "1"){
			$('#ctitle').html("대회참가확인서");
			$('#gubun2').hide();
			$('#gubun1').show();
		}
		else{
			$('#ctitle').html("선수실적증명서");
			$('#gubun1').hide();
			$('#gubun2').show();
		}

		mx.SendPacket(null, obj);
	};



	mx.getExtensionOfFilename = function(filename) {

		var _fileLen = filename.length;
		var _lastDot = filename.lastIndexOf('.');

		// 확장자 명만 추출한 후 소문자로 변경
		var _fileExt = filename.substring(_lastDot, _fileLen).toLowerCase();
		return _fileExt;
	};

	//참가선수 추가 /삭제
	mx.setMemberList = function(){
		var obj = {};
		obj.CMD = mx.CMD_MLIST;
		obj.TIDX = $('#tidx').val();
		obj.TEAM = $('#teamnm').val();
		mx.SendPacket('playerlist', obj);
	};

	//참가선수설정
	mx.setPlayer = function(){
		var el = $('#chekBoxModalPlayer00');
		var $checkTable = el.parents("Table");
		var $checkList = $checkTable.find("input[type='checkbox']");
        var varr = new Array();
        var len = $checkList.length;
        var x = 0;
		for (var i = 0 ; i < len ; i++){
   			if ( $checkList[i].checked == true && $('#'+$checkList[i].id).val() !=null  && $('#'+$checkList[i].id).val() != "on" )	{
				varr[x] = $('#'+$checkList[i].id).val();
				x++;
			}
        }

		var obj = {};
		obj.CMD = mx.CMD_SETMLIST;
		obj.TIDX = $('#tidx').val();
		obj.TEAM = $('#teamnm').val();
		obj.PIDXARR = varr;
		mx.SendPacket(null, obj);
	};

	//참가종목리스트
	mx.setBooList = function(seq,cdbnm,sex,uclass){
		var obj = {};
		obj.CMD = mx.CMD_BOOLIST;
		obj.SEQ = seq;
		obj.SEX = sex;
		obj.CDBNM = cdbnm;
		obj.UC = uclass;
		obj.TIDX = $('#tidx').val();
		obj.TEAM = $('#teamnm').val();
		mx.SendPacket('boolist', obj);
	};


	mx.setCapno = function(capid,targetid){
		var targetval = $('#'+targetid).val();
		var capval = $('#'+capid).val();

		targetval = targetval.split('#')[0];
		$('#'+targetid)	.val( targetval + '#' + capval  );
	};



	//참가부설정
	mx.setBoo = function(){
		var el = $('#chekBoxModalPlayertype00');
		var $checkTable = el.parents("Table");
		var $checkList = $checkTable.find("input[type='checkbox']");
        var varr = new Array();
		var groupcnt = 0;
        var len = $checkList.length;
        var x = 0;
		for (var i = 0 ; i < len ; i++){
   			if ( $checkList[i].checked == true && $('#'+$checkList[i].id).val() !=null  && $('#'+$checkList[i].id).val() != "on" )	{
				varr[x] = $('#'+$checkList[i].id).val();
					
					console.log(  i + '' +  $('#itgubun_'+ i).val());
				if ( $('#itgubun_'+ i ).val()  ==  'T'){
					groupcnt++;
				}
				x++;
			}
        }

		var obj = {};
		obj.CMD = mx.CMD_SETBLIST;
		obj.CHKSEQ = $('#check_seq').val();
		obj.TIDX = $('#tidx').val();
		obj.TEAM = $('#teamnm').val();
		obj.LIDXARR = varr;
		obj.GROUPCNT = groupcnt;
		mx.SendPacket(null, obj);
	};


	mx.delKind = function(seq,cdcnm,delid){
		$('#'+delid).remove();
		var obj = {};
		obj.CMD = mx.CMD_DELKIND;
		obj.SEQ = seq;
		obj.CDCNM = cdcnm;
		mx.SendPacket(null, obj);
	};


	mx.wOK = function(chkstr, teamcd){
		//첨부파일체크
		if($('#recomfile').html() == ''){
			alert("첨부파일이 존재하지 않습니다.");
			return;
		}
		//출전정보 있는지 체크
		if(chkstr == ''){
			alert("출전 정보를 생성해 주십시오.");
			return;
		}

		px.goSubmit({'F1':teamcd},'apply-parti__pay.asp');
	};

	mx.print = function(seq){
		var obj = {};
		obj.CMD = mx.CMD_PRINT;
		obj.SEQ = seq; 
		mx.SendPacket(null, obj);
	};


	mx.printpre = function(pidx){
		var obj = {};
		obj.CMD = mx.CMD_PRINTPRE;
		obj.PIDX = pidx; 
		mx.SendPacket(null, obj);
	};


//응답##################################################################
mx.OnPrint =  function(cmd, packet, html, sender){
	$('#printdiv').html(html);
	$('#printdiv').printThis({importCSS: false,loadCSS: '/home/css/style.css',header: false,afterPrint: mx.afterPrint });
};

mx.OnMsg =  function(cmd, packet, html, sender){
	alert("인증 번호가 전송되있습니다.");
};

mx.OnCheck =  function(cmd, packet, html, sender){
	px.goSubmit( packet , '/home/page/certificate_userlist.asp');
};


mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if (cmd == mx.CMD_MLIST ){
        $('#player-listModal').fadeIn(300);
        $('body').addClass('s_no-scroll');
	}
	if(cmd == mx.CMD_BOOLIST){
        $('#player-selc-typeModal').fadeIn(300);
        $('body').addClass('s_no-scroll');
	}
	if(cmd == mx.CMD_PAYCANCELLIST){
        $('#paycancel').fadeIn(300);
        $('body').addClass('s_no-scroll');
	}
};


$(document).ready(function(){
	mx.selectyear.push($('#ytotal').html());
});




////////////////////////////////////////////////////////////////

mx.multiSelectBox = function(target){
	target.toggleClass('s_open');
};


//출력정보 선택  
mx.selectyear = [];
mx.gameidx = [];

mx.SelectValue = function(target, selectvalue, pidx, selectobjno){
	target.parent().toggleClass('s_selected');

	switch (selectobjno){
	case 1 : 
		if(mx.selectyear.indexOf(selectvalue) == -1 ){
			mx.selectyear.push(selectvalue);
		}
		else{
			mx.selectyear.splice(mx.selectyear.indexOf(selectvalue),1);
		}

		if(mx.selectyear.length > 2){
			$('#ytotal').html( mx.selectyear[0]+","+mx.selectyear[1]+"..." );			
		}
		else{
			$('#ytotal').html( mx.selectyear.join() );
		}

		var obj = {};
		obj.CMD = mx.CMD_SETGAMETITLE;
		obj.SELECTYEAR = mx.selectyear;
		obj.PIDX = pidx;
		mx.SendPacket( 'gametitlearea', obj);


	break;
	
	case 2 :  //타이틀
		if(mx.gameidx.indexOf(selectvalue) == -1 ){
			$('#selectgame').html( target.html() );
			mx.gameidx.push(selectvalue);
		}
		else{
			$('#selectgame').html('');
			mx.gameidx.splice(mx.gameidx.indexOf(selectvalue),1);
		}

		mx.setCInfo(pidx); //저장
	break;


	}
};




