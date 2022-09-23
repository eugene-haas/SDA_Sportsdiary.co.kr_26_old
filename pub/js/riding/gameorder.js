var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;

  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_AUTOSUMBOO = 11100; //자동통합
  mx.CMD_SUMBOO = 11000; //수동통합
  mx.CMD_DIVBOO = 12000; //수동해제

  mx.CMD_OKYN = 100; //성립부서 확정버튼
  mx.CMD_SETTIMEALL = 13000;//출전순서표 전체시작시간 맞추기
  mx.CMD_SETTIME = 200;// 개별시간설정
  mx.CMD_SETORDER = 14000;	 //경기별 순서생성

  mx.CMD_SETGIVEUP = 300;	 //기권사유선택
  mx.CMD_SETGIVEUPDOC = 301; //사유서제출

  mx.CMD_GAMEINPUT = 15000; //공지사항저장
  mx.CMD_GAMEINPUT2 = 15001; //공지사항저장2
  mx.CMD_GAMEINPUTEDITOK = 302; //수정
  mx.CMD_GAMEINPUTDEL = 303; //삭제
  mx.CMD_GAMEINPUTEDIT2  = 15004; //공지사항 내용 불러오기
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqBooControl.asp";
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
    case 2: alert('편성조건에 만족하지 않습니다.');return;  break;
    case 3: alert('본선이 대진표가 완료된 경우 순위 변동을 할 수 없습니다..');return;  break;
    case 4: alert('본선이 대진표가 완료된 경우 추첨번호를 변경 할 수 없습니다.');return;    break; //메시지 없슴
    case 20: alert('부별 조정완료가 되지 않은 부서가 있습니다. 부별조정에서 조정완료하신 후 이용해 주십시오.');return;    break; //메시지 없슴

    case 30: alert('경기시간 2시간전에만 수정가능합니다.');return;    break; //마장마술 시간수정
    case 31: alert('경기시간 1시간전에만 수정가능합니다.');return;    break; //장애물 시간수정 + 기타

    case 100: return;   break; //메시지 없슴
    }
  }

  switch (Number(reqcmd)) {
  case mx.CMD_SETGIVEUP :
  case mx.CMD_SETGIVEUPDOC:
  case mx.CMD_SETTIME:
  case mx.CMD_OKYN : return;  break;//확정


  case mx.CMD_GAMEINPUTDEL:
  case mx.CMD_GAMEINPUTEDITOK: location.reload();    break;//수정



  case mx.CMD_GAMEINPUTEDIT2:
  case mx.CMD_GAMEINPUT2 :
  case mx.CMD_GAMEINPUT :
  case mx.CMD_SETORDER :
  case mx.CMD_SETTIMEALL :
  case mx.CMD_DIVBOO :
  case mx.CMD_SUMBOO :
  case mx.CMD_AUTOSUMBOO :
  case mx.CMD_SETGAMENO :   this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;//게임번호변경
  }
};



//요청##################################################################
	mx.setGameNo = function(idx, cngval){
		//alert(orgval +"--"+ cngval);
		var obj = {};
		obj.CMD = mx.CMD_SETGAMENO;
		obj.IDX = idx;
		obj.TIDX =mx.gameinfo.IDX;;
		obj.GHANGEGNO = cngval;
		mx.SendPacket('listcontents', obj);
	};

    //자동 부통합 (공통 GBIDX 인지 확인후) 
    // string data는 2차원 배열이다. , |로 구분되어 있다. 
	mx.autoSumBoo = function(strRDetail, strBLimit){

        if( (strRDetail == undefined || strBLimit == undefined ) ||
            (strRDetail == "" || strBLimit == "" ) )
            {
                alert("대회 정보가 없습니다. 잠시후에 다시 시도하세요");
                return;
            }

		var obj = {};
        obj.CMD = mx.CMD_AUTOSUMBOO;
        obj.DETAIL = strRDetail;        // List Array
        obj.LIMIT = strBLimit;          // 부별 Limit Array - 

		mx.SendPacket('listcontents', obj);
	};


	//체크항목 부통합 (공통 GBIDX 인지 확인후)
	mx.sumBoo = function(){
		var obj = {};
		var gbidx = '';
		var chkcnt = 0;
		var pregbidx = '';
		obj.PARR = new Array();
		obj.CMD = mx.CMD_SUMBOO;
		var n = 0; //obj.PARR 체크된 항목의 배열순서번호

	    var trCheck = $("#listcontents").find("input[type=checkbox]");
		for (var i = 0 ; i < trCheck.length ;i++ ){
			if( $("#"+ trCheck[i].id).is(":checked") == true ) {

					gbidx = trCheck[i].id.split("_")[0];
					if (pregbidx != '' && gbidx != pregbidx){
						alert("대회번호가 다른 항목이 존재합니다.");
						return;
					}
					
					chkcnt++;
					obj.PARR[n] = $("#"+ trCheck[i].id).val();
					n++;
					pregbidx = gbidx;
			}
		}

		if ( chkcnt < 2 ){
			alert("항목을 2개이상 선택해  선택해 주세요.");
			return;
		}

		if (confirm(' 생성된 공지사항이 모두 삭제됩니다.\n 선택한 대상을 통합 하시겠습니까?') == false) {
			return;
		}	

		mx.SendPacket('listcontents', obj);
	};
	
	//체크항목 원래대로 (공통 GBIDX 인지 확인후)
	mx.divBoo = function(){
		var obj = {};
		var gbidx = '';
		var pubcode = '';
		var chkcnt = 0;
		var pregbidx = '';
		obj.PARR = new Array();
		obj.CMD = mx.CMD_DIVBOO;
		var n = 0; //obj.PARR 체크된 항목의 배열순서번호

	    var trCheck = $("#listcontents").find("input[type=checkbox]");
		for (var i = 0 ; i < trCheck.length ;i++ ){
			if( $("#"+ trCheck[i].id).is(":checked") == true ) {

					gbidx = trCheck[i].id.split("_")[0];
					pubcode =  trCheck[i].id.split("_")[1];
					if (Number(pubcode) < 7 ){
						alert("통합된 부서가 아닙니다.");
						return;
					}
					
					chkcnt++;
					obj.PARR[n] = $("#"+ trCheck[i].id).val();
					n++;
					pregbidx = gbidx;
			}
		}

		if ( chkcnt == 0 || chkcnt >1 ){
			alert("1개의 통합된 부서를 선택해  선택해 주세요.");
			return;
		}

		if (confirm(' 생성된 공지사항이 모두 삭제됩니다.\n 선택한 대상을 분리 하시겠습니까? ') == false) {
			return;
		}	

		mx.SendPacket('listcontents', obj);
	};
	
	//확정버튼
	mx.okYN = function(idx){
		var obj = {};
		obj.CMD = mx.CMD_OKYN;	
		obj.IDX = idx;
		if( $('#okYN_'+idx).text() == '확정(N)' )
		{
			$('#okYN_'+idx).text('확정(Y)');
		}
		else
		{
			$('#okYN_'+idx).text('확정(N)');
		}
		mx.SendPacket('null', obj);
	}
	
	//출전순서표 전체 동일시간 설정
	mx.setTimeAll= function(tidx,findyear){

		if (confirm('전체 경기 시작 시간이 모두 적용됩니다. 적용하시겠습니까?')) {
		} else {
			return;
		}	

		var obj = {};
		obj.CMD = mx.CMD_SETTIMEALL;	
		obj.TIDX = tidx;
		obj.FINDYEAR = findyear;
		obj.TM  = $('#allstarttime').val();
		mx.SendPacket('listcontents', obj);
	};

	mx.setTime= function(tidx,findyear,ttype,idx){
		var obj = {};
		obj.CMD = mx.CMD_SETTIME;	
		obj.TTYPE = ttype;
		obj.H = $('#h'+ ttype + "_" + idx).val();
		obj.M = $('#m'+ ttype + "_" + idx).val();
		obj.IDX = idx;

		$('#h'+ ttype + "_" + idx).css("borderColor","green");
		$('#m'+ ttype + "_" + idx).css("borderColor","green");

		obj.TIDX = tidx;
		if (ttype == "g"){
			obj.GBIDX = findyear;
		}
		obj.FINDYEAR = findyear;
		mx.SendPacket('null', obj);
	};
	
	//출전순서부여
	mx.setOrder =function(tidx,findyear,gbidx){
		var obj = {};
		obj.CMD = mx.CMD_SETORDER;	
		obj.TIDX = tidx;
		obj.FINDYEAR = findyear;
		obj.GBIDX = gbidx;
		mx.SendPacket('listcontents', obj);	
	};

	//기권/실격사유
	mx.setGiveUp =function(tidx,gbidx,idx,ridx){
		var obj = {};
		obj.CMD = mx.CMD_SETGIVEUP;	
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.IDX = idx;
		obj.RIDX = ridx;
		obj.SAYOU = $('#giveup_'+ idx).val();
		$('#giveup_'+ idx).css("borderColor","green");
		mx.SendPacket('null', obj);	
	};

	//사유서제출
	mx.setGiveUpDoc =function(tidx,gbidx,idx,ridx){
		var obj = {};
		obj.CMD = mx.CMD_SETGIVEUPDOC;	
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.IDX = idx;
		obj.RIDX = ridx;
		obj.SAYOUDOC = $('#giveupdoc_'+ idx).val();
		$('#giveup_'+ idx).css("borderColor","green");
		mx.SendPacket('null', obj);	
	};



	mx.SelectLevelGb = function(ingno) {
		var obj = {};
		obj.PARR = new Array();
		obj.CMD = mx.CMD_FIND1;
		obj.TitleIDX =mx.gameinfo.IDX;;
		obj.TITLE = mx.gameinfo.TITLE;
		var typechkbox = false;
		for (var i = 0 ; i <= ingno ;i++ ){
			obj.PARR[i] = $("#mk_g"+ i ).val();
		}


		var msgarr = ["","개인/단체를 선택해 ", "경기종목을 선택해 ","마종을 선택해 ","Class 를 선택해 ","Class 안내를 선택해 "]; //메시지
		var passarrno = [0,1,1,1,1,1]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		mx.SendPacket('level_form', obj);
	};




	//저장
	mx.input_frm = function(){
		var eidx = $('#e_idx').val();
		var sno = $('#e_sortno').val();
		var noidx = $('#e_noidx').val(); //공지인덱스

		if(eidx == "" || eidx == undefined){
			alert("리스트의 항목을 먼저 선택해 주십시오.")
			return;
		}

		var obj = {};
		obj.IDX = eidx;
		obj.NOIDX = noidx;
		obj.SNO = sno;

		obj.PARR = new Array();
		obj.CMD = mx.CMD_GAMEINPUT2;
		var typechkbox = false;
		for (var i = 0 ; i < 5 ;i++ ){
			obj.PARR[i] = $("#mk_g"+ i ).val();
		}

		var msgarr = ["","", "시작 시간을 입력해 ","종료시간을 입력해 ","일정명칭을 입력해 "]; //메시지
		var passarrno = [0,0,1,1,1]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		var ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqGameOrder.asp";
		mx.SendPacketEx('listcontents', obj, ajaxurl);
	};


	//항목선택 ( 넘겨야할꺼 idx, 공지idx, gameno, sortno)
	mx.input_edit = function(idx,gameno,sortno,noidx){
		$( "#listcontents tr").css( "background-color", "white" ); 
		$( "#titlelist_"+sortno+"_" + idx ).css( "background-color", "#BFBFBF" ); 		
		
		$('#mk_g0').val(gameno); //idx
		$('#e_sortno').val(sortno); //sortno 
		$('#e_idx').val(idx); //부인덱스
		$('#e_noidx').val(idx); //공지인덱스
		$('#mk_g4').val(''); //내용

		if (Number(sortno) != 10000 ){ //공지사항글 수정하기 위해서 누른거임.....
			var obj = {};
			obj.CMD = mx.CMD_GAMEINPUTEDIT2;
			obj.IDX = idx;
			obj.SNO = sortno;
			obj.NOIDX = noidx;
			obj.GNO = gameno
			var ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqGameOrder.asp";
			mx.SendPacketEx('gameinput_area', obj, ajaxurl);
		}
	};


	mx.update_frm = function(){
		var eidx = $('#e_idx').val();
		var sno = $('#e_sortno').val();
		var noidx = $('#e_noidx').val(); //공지인덱스

		if(eidx == "" || eidx == undefined){
			alert("리스트의 항목을 먼저 선택해 주십시오.")
			return;
		}

		var obj = {};
		obj.IDX = eidx;
		obj.NOIDX = noidx;
		obj.SNO = sno;

		obj.PARR = new Array();
		obj.CMD = mx.CMD_GAMEINPUTEDITOK;
		var typechkbox = false;
		for (var i = 0 ; i < 5 ;i++ ){
			obj.PARR[i] = $("#mk_g"+ i ).val();
		}

		var msgarr = ["","", "시작 시간을 입력해 ","종료시간을 입력해 ","일정명칭을 입력해 "]; //메시지
		var passarrno = [0,0,1,1,1]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		var ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqGameOrder.asp";
		mx.SendPacketEx('listcontents', obj, ajaxurl);
	};



	mx.del_frm = function(){
		var eidx = $('#e_idx').val();
		var sno = $('#e_sortno').val();
		var noidx = $('#e_noidx').val(); //공지인덱스
		
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDEL;
		obj.IDX =  eidx;
		obj.SNO = sno;

		if (Number(sno) == 10000){ //공지사항글 수정하기 위해서 누른거임.....
			alert('공지사항만 삭제 하실 수 있습니다.');
			return;
		}


		if (obj.IDX == undefined){
			alert("대상을 선택해 주세요.");
			return;
		}

		if (confirm('대상을 삭제하시겠습니까?')) {
			var ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqGameOrder.asp";
			mx.SendPacketEx('listcontents', obj, ajaxurl);
		} else {
			return;
		}	
	};




//응답##################################################################

mx.init = function(){
		  $(function() {
				$('#GameTimeWrap').datetimepicker({
				  format: 'LT',
				  locale:'KO'
				});

				$('#GameTimeWrap1').datetimepicker({
				  format: 'LT',
				  locale:'KO'
				});


				$('#GameTimeWrap2').datetimepicker({
				  format: 'LT',
				  locale:'KO'
				});

		  });
};



mx.OndrowHTML2 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	//$("#drowbody").scrollTop(window.oriScroll);
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if( cmd == mx.CMD_GAMEINPUTEDIT || cmd == mx.CMD_GAMEINPUTEDIT2 ){
		mx.init();
	}
};

mx.OndelHTML =  function(cmd, packet, html, sender){
  var trgbstr = $( "#e_gno").val(); //gameno
  $( ".gametitle_" + trgbstr ).remove();
//  if( cmd == mx.CMD_GAMEINPUTDEL){
//    document.getElementById('gameinput_area').innerHTML = html;
//    mx.init();
//  }
};



/////////////////////////////////////////////////////////
