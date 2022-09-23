var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;

  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_SUMBOO = 11000; //수동통합
  mx.CMD_DIVBOO = 12000; //수동해제
  mx.CMD_AUTOSUMBOO = 11100; //자동통합

  mx.CMD_OKYN = 100; //성립부서 확정버튼
  mx.CMD_SETTIMEALL = 13000;//출전순서표 전체시작시간 맞추기
  mx.CMD_SETTIME = 200;// 개별시간설정
  mx.CMD_SETORDER = 14000;	 //경기별 순서생성

  mx.CMD_SETGIVEUP = 300;	 //기권사유선택
  mx.CMD_SETGIVEUPDOC = 301; //사유서제출

  mx.CMD_SETGIVEUPR = 340;	 //기권사유선택 -릴레이
  mx.CMD_SETGIVEUPDOCR = 350; //사유서제출 -릴레이

  mx.CMD_GAMEINPUT = 15000; //공지사항저장
  mx.CMD_GAMEINPUT2 = 15001; //공지사항저장2

  mx.CMD_SETORDERNO = 400; //출전순서 변경


 mx.CMD_GAMEINPUTDELSC = 410; //sc 공지 삭제 (새로고침)
 mx.CMD_GAMEINPUTEDIT  = 15002; //공지사항 내용 불러오기
 mx.CMD_GAMEINPUTEDITOKSC = 420;// sc수정완료

 mx.CMD_SHOWTOURN = 16000; //토너먼트 보기
 

 
 mx.CMD_CHANGENO = 320; //대진순서 설정
 mx.CMD_CHANGEORDERNO = 330; //리그 라운드순서변경
 mx.CMD_LGMAKE = 70000;
 mx.CMD_TNMAKE = 777;
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
    case 2: alert('편성조건에 만족하지 않습니다.');return;  break;
    case 3: alert('본선이 대진표가 완료된 경우 순위 변동을 할 수 없습니다..');return;  break;
    case 4: alert('본선이 대진표가 완료된 경우 추첨번호를 변경 할 수 없습니다.');return;    break; //메시지 없슴
    case 5: alert('순서번호를 정확히 입력해 주십시오.');return;    break; 
    case 20: alert('부별 조정완료가 되지 않은 부서가 있습니다. 부별조정에서 조정완료하신 후 이용해 주십시오.');return;    break; //메시지 없슴
    case 21: alert('출전 인원을 초과한 번호입니다.'); location.reload(); return;    break; //메시지 없슴

    case 30: alert('경기시간 2시간전에만 수정가능합니다.');return;    break; //마장마술 시간수정
    case 31: alert('경기시간 1시간전에만 수정가능합니다.');return;    break; //장애물 시간수정 + 기타
    case 90: alert('1라운드 이상 진행되어서 부를 통합할 수 없습니다.');return;    break; 
    case 91: alert('먼저 출전 순서를 부여해 주십시오.');return;    break; 
    case 100: return;   break; //메시지 없슴
    }
  }

  switch (Number(reqcmd)) {
  case mx.CMD_SETGIVEUP :
  case mx.CMD_SETGIVEUPR :
	if (jsondata.SAYOU == "W"){
		location.reload(); 
		return;
	}
	else{
		return;
	}
	break;


  case mx.CMD_LGMAKE:

  case mx.CMD_CHANGEORDERNO :
  case mx.CMD_CHANGENO :
  case mx.CMD_GAMEINPUTEDITOKSC:
  case mx.CMD_GAMEINPUTDELSC :
  case mx.CMD_SETORDERNO :   location.reload();    break;//출전순서 번호변경

  case mx.CMD_SETGIVEUPDOCR:
  case mx.CMD_SETGIVEUPDOC:
  case mx.CMD_SETTIME:
  case mx.CMD_OKYN : return;  break;//확정


  case mx.CMD_TNMAKE : 
  if(jsondata.CALLTYPE == "make") { location.reload();    break;}
  else{  this.OnShowTourn( reqcmd, jsondata, htmldata, sender ); break; }

  //case mx.CMD_LGMAKE: 

  case mx.CMD_GAMEINPUTEDIT:
  case mx.CMD_GAMEINPUT2 :
  case mx.CMD_GAMEINPUT :
  case mx.CMD_SETORDER :
  case mx.CMD_SETTIMEALL :
  case mx.CMD_DIVBOO :
  case mx.CMD_SUMBOO :
  case mx.CMD_AUTOSUMBOO :  
  case mx.CMD_SETGAMENO :   this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;//게임번호변경




  //case mx.CMD_SHOWTOURN:	mx.tourndata = jsondata ; this.OnShowTourn( reqcmd, jsondata, htmldata, sender );		break;  
  }
};
mx.tourndata= null;
//요청##################################################################
	//대진표 순서 변경
	mx.changeNo = function(midx, cngval){ //위로 1 아래로 2 범위안에 3
		var obj = {};
		obj.CMD = mx.CMD_CHANGENO;
		obj.MIDX = midx;
		obj.CNGVAL = cngval;
		mx.SendPacket(null, obj);		
	};
	
	//리그라운드 순서 변경
	mx.changeOrderNo = function(idx, cngval){ 
		var obj = {};
		obj.CMD = mx.CMD_CHANGEORDERNO;
		obj.IDX = idx;
		obj.CNGVAL = cngval;
		mx.SendPacket(null, obj);		
	};

	//대진표 생성
	mx.makeGameTable = function(tidx,gbidx,tabletype,calltype){

		var obj = {};
		obj.TABLETYPE = tabletype;
		if(Number(tabletype) == 1 ){
			obj.CMD = mx.CMD_LGMAKE;
		}
		else{
			obj.CMD = mx.CMD_TNMAKE;		
		}
		obj.TIDX = tidx;
		obj.LNO = gbidx;
		obj.TNO = $('#tableno').val(); //참가자수
		obj.CALLTYPE = calltype;

		mx.SendPacket('tournament2', obj);			
	};	

	//기권/실격사유
	mx.setGiveUpR =function(tidx,gbidx,idx,LR){
		var obj = {};
		obj.CMD = mx.CMD_SETGIVEUPR;	
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.IDX = idx;
		obj.LR = LR;
		obj.SAYOU = $('#giveup'+LR+'_'+ idx).val();
		$('#giveupr_'+ idx).css("borderColor","green");
		mx.SendPacket('null', obj);	
	};

	//사유서제출
	mx.setGiveUpDocR =function(tidx,gbidx,idx,LR){
		var obj = {};
		obj.CMD = mx.CMD_SETGIVEUPDOCR;	
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.IDX = idx;
		obj.LR = LR;
		obj.SAYOUDOC = $('#giveupdoc'+LR+'_'+ idx).val();
		$('#giveup'+LR+'_'+ idx).css("borderColor","green");
		mx.SendPacket('null', obj);	
	};














	
	mx.showTourn = function(tidx, gameyear, gbidx){
		var obj = {};
		obj.CMD =  mx.CMD_SHOWTOURN;
		obj.TIDX = tidx;
		obj.GMYEAR = gameyear;
		obj.GBIDX = gbidx;
		mx.SendPacket('myModal', obj);
	};		

	mx.setGameNo = function(idx, cngval){
		//alert(orgval +"--"+ cngval);
		var obj = {};
		obj.CMD = mx.CMD_SETGAMENO;
		obj.IDX = idx;
		obj.TIDX =mx.gameinfo.IDX;
		obj.GHANGEGNO = cngval;
		mx.SendPacket('listcontents', obj);
    };

	mx.setOrderNo = function(idx,tidx, gbidx, cngval){
		//alert(orgval +"--"+ cngval);
		var obj = {};
		obj.CMD = mx.CMD_SETORDERNO;
		obj.IDX = idx;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.GHANGEGNO = cngval;

		var ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqGameOrder.asp";
		mx.SendPacketEx('listcontents', obj, ajaxurl);
		//mx.SendPacket('listcontents', obj);
    };
    
    //자동 부통합 (공통 GBIDX 인지 확인후) 
    // string data는 2차원 배열이다. , |로 구분되어 있다. 
	mx.autoSumBoo = function(sender, tIdx, gYear, strRDetail, strBLimit){

        var strLog = utx.strPrintf("sender = {0}, tIdx = {1}, strRDetail = {2}, strBLimit = {3}",sender, tIdx, strRDetail, strBLimit);
        console.log(strLog);


        if( (strRDetail == undefined || strBLimit == undefined ) ||
            (strRDetail == "" || strBLimit == "" ) )
            {
                alert("대회 정보가 없습니다. 잠시후에 다시 시도하세요");
                return;
            } 

		var obj = {};
        obj.CMD = mx.CMD_AUTOSUMBOO;
        obj.GYEAR = gYear;              // GameYear
        obj.TIDX = tIdx;                // GameTitleIDX
        obj.DETAIL = strRDetail;        // List Array
        obj.LIMIT = strBLimit;          // 부별 Limit Array -         

		mx.SendPacket(sender, obj);
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
			$('#okYN_'+idx).html('<span style="color:red;">확정(Y)</span>');
			obj.YN = "Y";
		}
		else
		{
			$('#okYN_'+idx).text('확정(N)');
			obj.YN = "N";
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


	//저장 //촐전순서 부여 때 사용 sc.asp
	mx.input_frm = function(){
		var gubun = $('#e_gubun').val();
		if(gubun == "" || gubun == undefined){
			alert("리스트의 항목을 먼저 선택해 주십시오.")
			return;
		}
		if( Number(gubun) == 0  ){
			alert("출전 순서를 먼저 부여해 주십시오.");
			return;
		}

		var obj = {};
		obj.IDX = $('#e_idx').val();
		obj.PARR = new Array();
		obj.CMD = mx.CMD_GAMEINPUT;
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
		mx.SendPacket('listcontents', obj);
	};

	//저장
	mx.input_frm2 = function(){
		var eidx = $('#e_idx').val();
		var chksortno = $('#e_sortno').val();
		if(eidx == "" || eidx == undefined){
			alert("리스트의 항목을 먼저 선택해 주십시오.")
			return;
		}
		//이건 ajax에서 하자.
		//if( Number(gubun) == 0  ){
		//	alert("출전 순서를 먼저 부여해 주십시오.");
		//	return;
		//}

		var obj = {};
		obj.IDX = $('#e_idx').val();
		obj.SNO = chksortno;
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


	//항목선택 sc.asp
	mx.input_edit = function(idx,gubun,orderno){
		$( "#listcontents tr").css( "background-color", "white" ); 
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" ); 
		
		if( Number(gubun) == 0 ){
			alert("출전 순서를 먼저 부여해 주십시오.");
			return;
		}

		$('#mk_g0').val(orderno);
		$('#e_gubun').val(gubun);
		$('#e_idx').val(idx);
		
		if (Number(gubun) == 100 ){ //공지사항글 수정하기 위해서 누른거임.....
			var obj = {};
			obj.CMD = mx.CMD_GAMEINPUTEDIT;
			obj.IDX = idx;
			obj.GUBUN = gubun;
			mx.SendPacket('gameinput_area', obj);
		}
	};

	//항목선택
	mx.input_edit2 = function(idx,orderno,sortno){
		$( "#listcontents tr").css( "background-color", "white" ); 
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" ); 
		
		$('#mk_g0').val(orderno);
		$('#e_sortno').val(sortno);
		$('#e_idx').val(idx);

		if (Number(sortno) == 10000 ){ //공지사항글 수정하기 위해서 누른거임.....
			var obj = {};
			obj.CMD = mx.CMD_GAMEINPUTEDIT2;
			obj.IDX = idx;
			mx.SendPacket('gameinput_area', obj);
		}
	};


	mx.update_frmSC = function(){
		var gubun = $('#e_gubun').val();
		if(gubun == "" || gubun == undefined){
			alert("리스트의 항목을 먼저 선택해 주십시오.")
			return;
		}
		if( Number(gubun) != 100  ){
			alert("공지 일정을 선택해 주십시오.");
			return;
		}

		var obj = {};
		obj.IDX = $('#e_idx').val();
		obj.PARR = new Array();
		obj.CMD = mx.CMD_GAMEINPUTEDITOKSC;
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
		mx.SendPacket('listcontents', obj);
	};

	mx.del_frmSC = function(){
		var gubun = $('#e_gubun').val();
		if(gubun == "" || gubun == undefined){
			alert("리스트의 항목을 먼저 선택해 주십시오.")
			return;
		}
		if( Number(gubun) != 100  ){
			alert("공지 일정을 선택해 주십시오.");
			return;
		}
		
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDELSC;
		obj.IDX = $('#e_idx').val();

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

	mx.update_frm = function(){

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDITOK;
		obj.TIDX =mx.gameinfo.IDX;
		obj.TITLE = mx.gameinfo.TITLE;

		obj.PARR = new Array();

		var allidarr = ['e_idx','mk_g0','mk_g1','mk_g2','mk_g3','mk_g4','mk_g5','mk_g6','mk_g7','mk_g8','mk_g9','mk_g10','mk_g11','mk_g12','mk_g13','mk_g14','mk_g15','mk_g16','mk_g17','mk_g18','mk_g19','mk_g20','mk_g21','mk_g22','mk_g23'];
		var chkboxidarr = ['mk_g12','mk_g14','mk_g16','mk_g18','mk_g20','mk_g22']; //체크박스의 아이디들
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

		var msgarr = ["대상을 선택해 ", "","개인/단체를 선택해 ", "경기종목을 선택해 ","마종을 선택해 ","Class 를 선택해 ","Class 안내를 선택해 ",  "","대회일자를 선택해 ", "대회시간을 선택해 ","신청시작일을 선택해 ","신청시작사간을 ","신청종료일을 선택해",  "신청종료시간을 선택해 ", "", "", "", "", "", ""]; //메시지
		var passarrno = [1, 0,1,1,1,1,1,    1,1 ,1,1,1,1,    0,0, 0,0, 0,0, 0,0, 0,0, 0,0 ]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		//12 ~ 23까지중 체크가 모두 선택되지 않았을때 하나라도 입력하라고 표시
		mx.SendPacket('contest', obj);		
	};

	mx.del_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDEL;
		obj.IDX =  $("#e_idx").val();
		obj.GNO = $("#e_gno").val();

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





mx.tablejsondata = "";
mx.OnShowTourn =  function(cmd, packet, html, sender){

	 mx.tablejsondata = packet;
      var tournament2 = new Tournament();

	  tournament2.setOption({
        blockBoardWidth: 220, // integer board 너비
        blockBranchWidth: 40, // integer 트리 너비
        blockHeight : 80, // integer 블럭 높이(board 간 간격 조절)
        branchWidth : 2, // integer 트리 두께
        branchColor : '#a9afbf', // string 트리 컬러
        roundOf_textSize : 60, // integer 배경 라운드 텍스트 크기
        scale : 'decimal', // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
        board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
    		el:document.getElementById('tournament2') // element must have id
		});

      tournament2.setStyle('#tournament2');

	  tournament2.boardInner = function(data){
		var Lwincolor = "";
		var Rwincolor = "";	
		var Lnm = data.teamnmL;
		var Rnm = data.teamnmR;

		if (data.LWL == 'W'){
			Lwincolor = "style='background:orange;'";
		}
		if (data.RWL == 'W'){
			Rwincolor = "style='background:orange;'";
		}


		if (Lnm == '--' || Lnm == null ){
			Lnm = "";
		}
		if (Rnm == '--' || Rnm == null ){
			Rnm = "";
		}



        var html = [
          '<p class="ttMatch ttMatch_first"  '+Lwincolor+'>',
            '<span class="ttMatch__score">'+data.scoreL+'</span>',
            '<span class="ttMatch__playerWrap">',
              '<span class="ttMatch__playerInner"  title=ㅇㅇㅇ>',
                '<span class="ttMatch__player">'+Lnm+'</span>',
                '<span class="ttMatch__belong"></span>',
              '</span>',
            '</span>',

          '</p>',
          '<p class="ttMatch ttMatch_second" '+Rwincolor+'>',
            '<span class="ttMatch__score">'+data.scoreR+'</span>',
            '<span class="ttMatch__playerWrap">',
              '<span class="ttMatch__playerInner"   title=ㅌㅌㅌ>',
                '<span class="ttMatch__player">'+Rnm+'</span>',
                '<span class="ttMatch__belong"></span>',
              '</span>',
            '</span>',
          '</p>'
        ].join('');

    		return html;
	  }



	tournament2.draw({
		roundOf:packet.TotalRound,
		data:  packet
	});

};	


mx.drowLimitTourn =  function(startround , endround){
	
      var tournament2 = new Tournament();
	  
	  tournament2.setOption({
        blockBoardWidth: 220, // integer board 너비
        blockBranchWidth: 40, // integer 트리 너비
        blockHeight : 80, // integer 블럭 높이(board 간 간격 조절)
        branchWidth : 2, // integer 트리 두께
        branchColor : '#a9afbf', // string 트리 컬러
        roundOf_textSize : 60, // integer 배경 라운드 텍스트 크기
        scale : 'decimal', // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
        board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
    		el:document.getElementById('tournament2') // element must have id
    	});

      tournament2.setStyle('#tournament2');
	  tournament2.boardInner = function(data){
		var Lwincolor = "";
		var Rwincolor = "";	

		var Lnm = data.Lusername;
		var Rnm = data.Rusername;
		var Lteamnm = data.LteamAna;
		var Rteamnm = data.RteamAna;

		if (data.LWL == 'W'){
			Lwincolor = "style='background:orange;'";
		}
		if (data.RWL == 'W'){
			Rwincolor = "style='background:orange;'";
		}


		if (Lnm == '--' || Lnm == null ){
			Lnm = "";
		}
		if (Rnm == '--' || Rnm == null ){
			Rnm = "";
		}
		if (Lteamnm == null){
			Lteamnm = "";
		}
		if (Rteamnm == null){
			Rteamnm = "";
		}
		

        var html = [
          '<p class="ttMatch ttMatch_first"  '+Lwincolor+'>',
            '<span class="ttMatch__score">'+data.Ltryoutsortno+'</span>',
            '<span class="ttMatch__playerWrap">',
              '<span class="ttMatch__playerInner"  title=ㅇㅇㅇ>',
                '<span class="ttMatch__player">'+Lnm+'</span>',
                '<span class="ttMatch__belong">'+Lteamnm+'</span>',
              '</span>',
            '</span>',

          '</p>',
          '<p class="ttMatch ttMatch_second" '+Rwincolor+'>',
            '<span class="ttMatch__score">'+data.Rtryoutsortno+'</span>',
            '<span class="ttMatch__playerWrap">',
              '<span class="ttMatch__playerInner"   title=ㅌㅌㅌ>',
                '<span class="ttMatch__player">'+Rnm+'</span>',
                '<span class="ttMatch__belong">'+Rteamnm+'</span>',
              '</span>',
            '</span>',
          '</p>'
        ].join('');

    		return html;
    	}

	  tournament2.draw({
		limitedStartRoundOf: startround, //16    integer(짝수)  default:0 전체, 그리기 시작할 라운드 ex)8강 부터
		limitedEndRoundOf: endround, //8       integer(짝수)  default:0 전체, 그리기 끝날 라운드 ex)4강 까지
		roundOf:mx.tablejsondata.TotalRound,
		data:  mx.tablejsondata
      });

};






































mx.OndrowHTML2 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	//$("#drowbody").scrollTop(window.oriScroll);
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
//	if (cmd == mx.CMD_SETORDER && packet != null ){ //릴레이 코스 출전순서 재호출
//		mx.setOrder(packet.TIDX,packet.FINDYEAR,packet.GBIDX);
//		return;
//		//출전순서 부여 클릭해도 되고
//	}
	document.getElementById(sender).innerHTML = html;
	if( cmd == mx.CMD_GAMEINPUTEDIT ){
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
//클릭위치로 돌려놓기
$(document).ready(function(){
	$("#sc_body").scrollTop(localStorage.getItem('scrollpostion'));

	$("#sc_body").click(function(event){
		window.toriScroll = $("#sc_body").scrollTop();
		localStorage.setItem('scrollpostion',window.toriScroll);
		console.log(window.toriScroll);
	});
});


