var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;

  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_FINDBOODETAIL = 11000; //부세부종목 불러오기
  mx.CMD_FINDBOO = 11001; //부
  mx.CMD_GAMECOPY = 12000; //타대회복사
  mx.CMD_GAMECOPYSEARCH = 12001;
  mx.CMD_GAMELEVELCOPY = 500;

  mx.CMD_GAMEINPUT = 301;
  mx.CMD_GAMEINPUTEDIT = 30002;
  mx.CMD_GAMEINPUTEDITOK = 303;
  mx.CMD_GAMEINPUTDEL = 304;

////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqlevel.asp";
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

mx.InitInputData = function(){
   let parr_obj = sessionStorage.getItem('PARR') || null;
   if (parr_obj) {
      parr_obj = JSON.parse(parr_obj);
   } else if( parr_obj === null ){
      return;
   }
   // console.log(parr_obj)
   $('#mk_g0').val(parr_obj[0]);
   $('#mk_g1').val(parr_obj[1]);
   mx.setTeamGb();
   $('#mk_g2').val(parr_obj[2]);
   mx.setBoo();
   setTimeout(function(){
      $('#mk_g3').val(parr_obj[3]);
      $('#mk_g4').val(parr_obj[4]);
   },100);
}


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
    case 3: alert('참가신청 자가 있어 수정및 삭제가 불가능 합니다.');return;  break;
    case 4: alert('대회에 생성된 부서가 있어 복사할수 없습니다.');return;  break;
    case 100: return;   break; //메시지 없슴
	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}
	return;   break;

	}
  }

  switch (Number(reqcmd)) {
  case mx.CMD_FINDBOO:
    this.OndrowHTML( reqcmd, jsondata, htmldata, sender );
    break;
  case mx.CMD_FINDBOODETAIL:
    this.OndrowHTML( reqcmd, jsondata, htmldata, sender );
    break;

	case mx.CMD_GAMEINPUTDEL:
      window.location.reload();
   	break;
	case mx.CMD_GAMEINPUTEDITOK:
      window.location.reload();
   	break;
	case mx.CMD_GAMEINPUT:
      window.location.reload();
   	break;

	case mx.CMD_GAMECOPYSEARCH:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GAMECOPY:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_GAMELEVELCOPY  : alert("대회가 복사되었습니다.");window.location.reload(); break;
  }
};


//요청##################################################################
	mx.gameList = function(tidx){
		var obj = {};
		obj.CMD = mx.CMD_GAMECOPY;
		obj.TIDX =tidx;
		mx.SendPacket('modalB', obj);
	};

	mx.gameSearchList = function( tidx,f1,f2 ){
		var obj = {};
		obj.CMD = mx.CMD_GAMECOPYSEARCH;
		obj.TIDX =tidx;
		obj.F1 = f1;
		obj.F2 = f2;
		mx.SendPacket('modalB', obj);
	};

	mx.copyGame	= function(targetidx, copyidx){
		var obj = {};
		obj.CMD = mx.CMD_GAMELEVELCOPY;
		obj.TIDX =targetidx;
		obj.CIDX = copyidx;
		mx.SendPacket('modalB', obj);
	};

	mx.setTeamGb = function(){
		var obj = {};
		obj.CMD = mx.CMD_FINDBOODETAIL;
		obj.GBCD =$('#mk_g0').val();
		obj.ITCD =$('#mk_g1').val(); //개인단체
		obj.SEX =$('#mk_g2').val(); //남자여자


		mx.SendPacket('boodetail', obj);
	};

	mx.setBoo = function(){
		var obj = {};
		obj.CMD = mx.CMD_FINDBOO;
		obj.SEXNO =$('#mk_g2').val();
		mx.SendPacket('boo', obj);
	};


	mx.input_frm = function(lastno){

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUT;
		//종목 개인[단체] 성별 부서 세부종목
		obj.PARR = new Array();

		var allidarr = [];
		for (var x = 0;x < lastno ;x++ ){
			allidarr[x] = "mk_g" + x;
		}

		var chkboxidarr = []; //체크박스의 아이디들
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
		for (var x = 0;x < lastno ;x++ ){
			msgarr[x] = "";
		}

		var passarrno = [0,0,0,0,0,0]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					return;
				}
			}
		}
      sessionStorage.setItem('PARR', JSON.stringify(obj.PARR));
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

	mx.update_frm = function(lastno){
		if($('#e_idx').val() ==  undefined ){
			alert("목록에서 대상을 선택해 주세요.");
			return;
		}

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDITOK;
		//종목 개인[단체] 성별 부서 세부종목
		obj.PARR = new Array();

		var allidarr = [];
		for (var x = 0;x < lastno ;x++ ){
			allidarr[x] = "mk_g" + x;
		}
		allidarr[x] = "e_idx";

		var chkboxidarr = []; //체크박스의 아이디들
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
		for (var x = 0;x < lastno ;x++ ){
			msgarr[x] = "";
		}

		var passarrno = [0,0,0,0,0,0]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					return;
				}
			}
		}
      sessionStorage.setItem('PARR', JSON.stringify(obj.PARR));
		mx.SendPacket(null, obj);
	};


	mx.del_frm = function(idx){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDEL;
		if(idx == ''){
			obj.IDX =	$("#e_idx").val();
		}
		else{
			obj.IDX = idx;
		}

		if (obj.IDX == undefined){
			alert("목록에서 대상을 선택해 주세요.");
			return;
		}

		if (confirm('대상을 삭제하시겠습니까?')) {
         sessionStorage.removeItem('PARR');
			mx.SendPacket('titlelist_'+obj.IDX, obj);
		} else {
			return;
		}
	};




//응답##################################################################

mx.OndrowHTML =  function(cmd, packet, html, sender){
	if(cmd == mx.CMD_GAMECOPY ){
		if( $('#modalB').length == 0 ){
			$('body').append("<div id='modalB' class='modal fade' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
		}
		document.getElementById("modalB").innerHTML = html;
		$('#modalB').modal('show');
	}else{
		document.getElementById(sender).innerHTML = html;
	}
};






////////////////////////////////////////////////////////////////

//function hashHandler() {
//  console.log('The hash has changed!');
//  return;
//}
//
//window.addEventListener('hashchange', hashHandler, false);

//let this snippet run before your hashchange event binding code
//if(!window.HashChangeEvent)(function(){
//	var lastURL=document.URL;
//	window.addEventListener("hashchange",function(event){
//		Object.defineProperty(event,"oldURL",{enumerable:true,configurable:true,value:lastURL});
//		Object.defineProperty(event,"newURL",{enumerable:true,configurable:true,value:document.URL});
//		lastURL=document.URL;
//	});
//}());


//var backControl = function(callbackFunction){
//	//window 내 mouse 위치여부를 체크하기 위한 변수
//	window.innerDoc = false;
//	//mouseover Event Listener
//	window.addEventListener('mouseover', function(event){
//		window.innerDoc = true;
//	});
//	//mouseout Event Listener
//	window.addEventListener('mouseout', function(event){
//		window.innerDoc = false;
//	});
//
//	//바로 이전 페이지로 이동하는 것을 막기위해 history State 추가
//	history.pushState({page:"first"}, document.title, location.pathname + '#first');
//
//	//popstate Event Listener
//	window.addEventListener('popstate', function(event){
//		//history State 추가하여 페이지 이동 막음(뒤로가기 막기)
//
//		history.pushState({page:"historyChanged"}, document.title, location.pathname + '#changed');
//
//		//window 영역 밖에서 history가 변경 됐을 경우 callbackFunction 실행(뒤로가기 버튼 등)
//		//이전 POST 페이지에 정상적으로 데이터 재전송하여 SUBMIT 등 수행
//
//		if (!window.innerDoc){
//			callbackFunction();
//		}
//	});
//
//}
//
////window 영역 밖의 핸들링 되지 않은 버튼으로 history 변경 이동했을 경우 실행할 function
//var callbackFunction = function(){
//	//document.referrer 등 체크하여 이전 post 페이지로 정상 이동 할수 있도록 데이터 생성및 추가 및 submit
//	//window 내 버튼 등을 통한 이동 외에 페이지 이동 불가 alert 안내등 처리
//	return;
//}
//
//
////스크립트 실행
//backControl(callbackFunction);

//history.pushState(null, null, location.href);
//
//window.onpopstate = function(event) {
//
//	history.go(1);
//
//};
//


window.onload  = function() {

mx.InitInputData();

};
