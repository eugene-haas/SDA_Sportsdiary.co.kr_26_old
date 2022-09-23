var mx =  mx || {};
////////////////////////////////////////
	//========================
	mx.CMD_DATAGUBUN = 10000;
	//========================

	mx.CMD_INPUT = 30001;
	mx.CMD_EDIT = 30002; //수정
	mx.CMD_EDITOK = 30003;
	mx.CMD_DEL = 30004;// 삭제

	//편집기
	mx.CMD_EDITOR = 40000;
	mx.CMD_EDITOROK = 40001;

	mx.CMD_BTNST = 100;
	mx.CMD_FILEFORM = 12000; //업로드(창)
	mx.CMD_POP = 50000;
	mx.CMD_POPHORSE = 51000; //말검색팝업
	mx.CMD_FINDHORSELIST= 51001;//말목록

	mx.CMD_SENDSMS = 200; //인증번호발송
	mx.CMD_CHECKSMS = 300; //인증번호확인

	mx.CMD_SENDSMSPWD = 210; //인증번호발송 (PWD)
	mx.CMD_CHECKSMSPWD = 310; //인증번호확인


	//증명서발급
	mx.CMD_CERTIFICATE = 50001;


	mx.CMD_GETFINDHORSE = 201; //말정보가져오기
	mx.CMD_SAVEPAYINFO = 601; //임시저장 (결제정보)

	mx.CMD_SHOWCONTENTS = 50002; //내용보기
	mx.CMD_SHOWATTFORM = 50003; //강습회참가화면
	mx.ATTSHORTCOURSE = 602; //강습회참가신청완료

	mx.CMD_PRINT = 60001; //인쇄
	mx.CMD_PRINTEND = 6001;


	mx.CMD_ATTGAMESTEP1 = 71000;
	mx.CMD_ATTGAMESTEP2 = 72000;
	mx.CMD_ATTGAMESTEP2PP = 73000;  //온라인 신청관리 참가 목록

	mx.CMD_SETBOO = 72100;


	//선수가 참가신청
	mx.CMD_ATTEND_PLAYER = 900;
	mx.CMD_POPPLAYER = 90000; //선수검색참
	mx.CMD_FINDPLAYERLIST = 91000; //선수목록검색
	mx.CMD_DELTEMPMEMBER = 92000; //결제전 선수삭제


	mx.CMD_FINDTEAM = 93000; //팀검색  또는 생성용 버튼

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
    console.log( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
	var strData = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
    $.ajax({
        url : reqUrl,
        type : mx.ajaxType,
        data : strData,
        dataType : mx.dataType,
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
		case 2: alert('이미 신청하셨습니다.');return;  break;
		case 3: alert('이미 회원가입이 되어있습니다. 선수나 지도자로 변경하시려면 마이페이지를 이용하여 주십시오.');return;  break;
		case 4: alert('인증확인 번호가 다릅니다.');return;  break;
		case 1: alert('데이터가 존재하지 않습니다.');return;  break;
		case 88: alert('sitecode가 없습니다.  cfg.pub.asp 설정');return;  break;
		case 99: alert('정보가 일치하지 않습니다.');return;  break;
		case 9: alert('로그인후 이용하여 주십시오.');location.href='/'; return;  break;
		case 12: alert('이미 인쇄를 이용하셨습니다. 오류로 인한 부분은 협회에 문의하여 주십시오.'); break;
		case 20: alert('올해 등록된 선수가 아니거나 로그아웃 상태입니다.\n 등록 또는 로그인 후 이용하여 주십시오.'); window.location.reload(); return; break;
		case 21: alert('선수나 말이 참가 조건에 충족하지 않습니다.'); return; break;
		case 22: alert('가입되지 않은 아이디 입니다.'); return; break;

		case 100: return;   break; //메시지 없슴
		}
  }

	switch (Number(reqcmd))	{
	case mx.CMD_DELTEMPMEMBER: alert('삭제되었습니다.'); break;
	case mx.ATTSHORTCOURSE: alert('참가신청이 완료되었습니다.'); break;

	case mx.CMD_SAVEPAYINFO: location.href= '/page/apply-online/apply-online_certificate_issued-history.asp'; break;
	case mx.CMD_EDITOK:
	case mx.CMD_PRINTEND:
	case mx.CMD_INPUT:	window.location.reload();	break;

	case mx.CMD_POP:  this.OnwritePop( reqcmd, jsondata, htmldata, sender );    break;
	case mx.CMD_SENDSMSPWD :
	case mx.CMD_SENDSMS : this.OnMsg( reqcmd, jsondata, htmldata, sender );  break;
	case mx.CMD_CHECKSMSPWD:
	case mx.CMD_CHECKSMS : this.OnCheck( reqcmd, jsondata, htmldata, sender );  break;



	case mx.CMD_SETBOO:
	case mx.CMD_FINDHORSELIST:
	case mx.CMD_FINDPLAYERLIST:
	case mx.CMD_POPPLAYER:
	case mx.CMD_POPHORSE:
	case mx.CMD_ATTGAMESTEP2:
	case mx.CMD_ATTGAMESTEP2PP:
	case mx.CMD_FINDTEAM:
	case mx.CMD_SHOWCONTENTS:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_PRINT	:	this.OnPrint( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_ATTEND_PLAYER : this.OnReloadGubun( reqcmd, jsondata, htmldata, sender );		break;
	}
};




//요청##################################################################
	mx.settr = function(id, teamidx, teamnm){
		$("#searchteamList tr").removeClass('s_on');
		$('#'+id).addClass('s_on');
		$("#teamidx").val(teamidx); //침인덱스
		$("#teamNm").val(teamnm); //침인덱스
	};

	mx.cancel = function(){
		$('#modalsearchteam').hide();
		$("#searchteamList tr").removeClass('s_on');
		$("#teamidx").val(''); //침인덱스
		$("#teamNm").val(''); //침인덱스
	};


	mx.teamNmModal = function(){
		$('#modalsearchteam').show()
	};

	//등록할팀검색
	mx.findTeam= function(findstr){
		var obj = {};
		obj.CMD = mx.CMD_FINDTEAM;
		obj.SENDPRE = 'home_';
		obj.FINDSTR = findstr;
		mx.SendPacket('searchteamList', obj);
	};
	
	
	mx.setSelectGame = function(trobj){
		$(trobj).parent().removeClass('s_on');
		$(trobj).addClass('s_on');
	};

	mx.delTempMember = function(obj, ridx){
		if(!confirm('선택한 정보를 삭제하시겠습니까?')){
				return;
		}

		obj.parents('tr').remove(); //지워
		var obj = {};
		obj.CMD = mx.CMD_DELTEMPMEMBER;
		obj.RIDX = ridx;
		obj.SENDPRE = 'home_';
		mx.SendPacket(null, obj);
		
	};

	//선수가 신청
	mx.attGameRequest = function(pidx, gubuntype){
		var selectgamelidx = $('#selectgamelidx').val();
		var hidx = $('#hidx').val();
		var hnm = $('#hnm').val();
		var gameboo = $('#attgameboo').val();

		if (pidx == ''){
			alert('선수를 선택하여 주십시오.');
			return;
		}
		if (hidx == ''){
			alert('말을 선택하여 주십시오.');
			return;
		}

		//if(!confirm('선택하신 신청항목에 대한 참가비 결제를 하시겠습니까?\n\n전체항목 선택/결제의 경우, 일부 결제취소는 불가합니다.\n일부 결제취소 희망 시, 주최협회에 별도 문의 및 \n취소요청을 부탁 드립니다.')){
		//		return;
		//}

		//결제모듈 호출
		var obj = {};
		obj.CMD = mx.CMD_ATTEND_PLAYER;
		obj.PIDX = pidx;
		obj.HIDX = hidx;
		obj.HNM = hnm;
		obj.PUBCODE = gameboo;
		obj.LEVELIDX = selectgamelidx;
		obj.RELAYTEAMNM = $('#relayteamnm').val();
		obj.GUBUNTYPE = gubuntype; //신청구분
		obj.SENDPRE = 'home_';
		mx.SendPacket(null, obj);
	};

	//선택된 종목의 부가져오기
	mx.setBoo = function(tidx, lidx,pteamgb){
		var obj = {};
		obj.CMD = mx.CMD_SETBOO;
		obj.TIDX = tidx;
		obj.LEVELIDX = lidx;
		obj.PTEAMGB = pteamgb;
		obj.SENDPRE = 'home_';

		$('#hidx').val('');
		$('#hnm').val('');

		$('#selectidx').val('');
		$('#selectnm').val('');
		$('#hidx').val('');
		$('#hnm').val('');
		$('#attpidx').val('');
		$('#pnm').val('');

		mx.SendPacket('gameboo', obj);
	};

	//공인대회참가신청 1
	mx.attCompetition = function(tidx){
		var obj = {};
		obj.CMD = mx.CMD_ATTGAMESTEP1;
		obj.PAGESTEP = "step1";
		obj.SENDPRE = "home_";
		obj.TIDX = tidx;
		px.goSubmit(obj, location.href);
		//mx.SendPacket('viewarea', obj);
	};

	//1.말검색 팝업창 요청
	mx.getPopHorse = function(levelidx, pidx){
		var obj = {};
		obj.CMD = mx.CMD_POPHORSE;
		obj.LEVELIDX = levelidx;
		obj.PIDX = pidx;
		obj.SENDPRE = 'home_';
		mx.SendPacket('modalsearchHorse', obj);
	};

	//2.목록검색
	mx.findHorse = function(sval,levelidx,pidx){
		if (pidx == ''){
			alert('선수를 먼저 검색하여 주십시오.');
			return;
		}
		var obj = {};
		obj.CMD = mx.CMD_FINDHORSELIST;
		obj.SS = sval;
		obj.PIDX = pidx;
		obj.LEVELIDX = levelidx; //제약조건 체크도 해야되는데
		obj.SENDPRE = 'home_';
		mx.SendPacket('findhorselist', obj);
	};

	//3.리스트선택
	mx.setHorseInfo = function(trobj,idx,pp,name,lidx){
		$(trobj).parent().children().removeClass('s_on');
		$(trobj).addClass('s_on');
		$('#selectidx').val(idx);
		$('#selectnm').val(name);
		$('#selectlidx').val(lidx);
	};

	//4.선택목록확인
	mx.inputHorseInfo = function(){
		$('#hidx').val($('#selectidx').val());
		$('#hnm').val($('#selectnm').val());
		$('#modalsearchHorse').hide ();
	};


	//1.선수검색 팝업창 요청_________________________________
	mx.getPopPlayer = function(levelidx, teamcd ='' ){ //단체인경우 팀코
		mx.checkmember= []; //다시열때 초기화되어야한다.
		var obj = {};
		obj.CMD = mx.CMD_POPPLAYER;
		obj.LEVELIDX = levelidx;
		obj.TEAMCD = teamcd; //단체신청인경우만사용
		obj.SENDPRE = 'home_';
		mx.SendPacket('modalsearchHorse', obj);
	};

	//2.목록검색
	mx.findPlayer = function(sval,levelidx){
		if ($('#hnm').val() != ''){ //선수를 재검색한다면 말정보 초기화
			$('#hidx').val('');
			$('#hnm').val('');
		}
		var obj = {};
		obj.CMD = mx.CMD_FINDPLAYERLIST;
		obj.SS = sval;
		obj.LEVELIDX = levelidx; //제약조건 체크도 해야되는데
		obj.SENDPRE = 'home_';
		mx.SendPacket('findplayerlist', obj);
	};

	//3.리스트 선택
	mx.setPlayerInfo = function(trobj,idx,pp,name,lidx){
		$(trobj).parent().children().removeClass('s_on');
		$(trobj).addClass('s_on');
		$('#selectidx').val(idx);
		$('#selectnm').val(name);
		$('#selectlidx').val(lidx);
	};

	//릴레이인경우 선택 3명
	mx.checkmember = [];
	mx.setPlayerInfoRelay = function(trobj,idx,pp,name,lidx){
		//s_on  갯수 체크

		//$(trobj).parent().children().removeClass('s_on');
		var checkcount = 0;
		var push_id_value;
		var pushcount;

		$(trobj).addClass('s_on');

		for (var i = 0; i< $(trobj).parent().children().length; i++){
			if ( $(trobj).parent().children()[i].className != '' ){
				checkcount = checkcount + 1;
				if( trobj.id ==$(trobj).parent().children()[i].id ){
					push_id_value = trobj.id;
				}
			}
		}

		if (checkcount == 4){
			$('#'+mx.checkmember[0]).removeClass('s_on');
			mx.checkmember.shift();
			pushcount = mx.checkmember.push(push_id_value);
			$('#selectidx').val($('#selectidx2').val());
			$('#selectnm').val($('#selectnm2').val());
			$('#selectidx2').val($('#selectidx3').val());
			$('#selectnm2').val($('#selectnm3').val());

			$('#selectidx3').val(idx);
			$('#selectnm3').val(name);
			//console.log($('#selectnm').val() +','+ $('#selectnm2').val() + ',' + $('#selectnm3').val());
		}
		else{
			pushcount = mx.checkmember.push(push_id_value);
			//console.log( 'push : ' + pushcount);
			switch (pushcount){
				case 1 :
				$('#selectidx').val(idx);
				$('#selectnm').val(name);
				break;
				case 2 :
				$('#selectidx2').val(idx);
				$('#selectnm2').val(name);
				break;
				case 3 :
				$('#selectidx3').val(idx);
				$('#selectnm3').val(name);
				break;
			}
		}

		//console.log(mx.checkmember);
		// $('#selectidx').val(idx);
		// $('#selectnm').val(name);
		$('#selectlidx').val(lidx); //이건머 공통이니까...
	};

	//4.선택목록확인
	mx.inputPlayerInfo = function(){
		$('#attpidx').val($('#selectidx').val());
		$('#pnm').val($('#selectnm').val());
		$('#modalsearchHorse').hide ();
	};

	//릴레이 선택목록 확인
	mx.inputPlayerInfoRelay =  function(){
		if ($('#inputgroupnm').val() == '') {
			alert("릴레이참가팀명칭을 입력해 주십시오.");
			return;
		}
		if( $('#selectidx').val() == '' || $('#selectidx2').val() =='' || $('#selectidx3').val()==''  ){
			alert('3명의 선수를 선택해 주십시오.');
			return;
		}

		$('#attpidx').val( $('#selectidx').val()+','+$('#selectidx2').val()+','+$('#selectidx3').val() );
		$('#pnm').val($('#selectnm').val()+','+ $('#selectnm2').val()+','+$('#selectnm3').val());
		$('#relayteamnm').val($('#inputgroupnm').val()); //릴레이 참가 팀명칭

		$('#modalsearchHorse').hide ();
	};


	//개인 참가 정보 가져오기
	mx.attInfoLoadMylist = function(attype,tidx){
		var obj = {};
		obj.CMD = mx.CMD_ATTGAMESTEP2PP;
		obj.PAGESTEP = "step2";
		obj.SENDPRE = "home_";
		obj.ATTTYPE = attype;
		obj.TIDX =  tidx;
		mx.SendPacket('boolist', obj);
	};




	//참가정보 가져오기
	mx.attInfoLoad = function(no_tidx){

		if(no_tidx.split('_')[0] =="3" && login.team == ""){ //head.asp 에서 로그인후 정의
			alert("팀을 등록 후 이용하여 주십시오.");
			return;
		}

		var obj = {};
		obj.CMD = mx.CMD_ATTGAMESTEP2;
		obj.PAGESTEP = "step2";
		obj.SENDPRE = "home_";
		obj.ATTTYPE = no_tidx.split('_')[0];
		obj.TIDX =  no_tidx.split('_')[1];
		mx.SendPacket('boolist', obj);
	};


	//강습회
	mx.attShortCourse = function(){
		var obj = {};
		obj.CMD = mx.ATTSHORTCOURSE;
		obj.SENDPRE = "home_";
		obj.SEQ = $('#attseq').val();
		mx.SendPacket('viewarea', obj);
		$('#modalJoinCompetition').hide();
	};

	mx.showAttForm = function(seq){
		var obj = {};
		obj.CMD = 	mx.CMD_SHOWATTFORM;
		obj.SENDPRE = "home_";
		obj.SEQ = seq;
		$('#attseq').val(seq);
		$('#modalJoinCompetitionAgree').show();
	};


	//목록보기
	mx.goList = function(){
		$('#viewarea').hide();
		$('#listarea').show();
	};
	//컨텐츠보기
	mx.showContents = function(seq){
		var obj = {};
		obj.CMD = mx.CMD_SHOWCONTENTS;
		obj.SENDPRE = "home_";
		obj.SEQ = seq;
		mx.SendPacket('viewarea', obj);
	};

	//증명서발급으로 가기
	mx.goKS = function(goUrl){
		px.goSubmit('','https://sic.sports.or.kr:444/intro.do');
	};

	//인증
	mx.SMS = function(nm,phoneno,birthday){
		var obj = {};
		if ($('#username').val() == ''){
			$('#username').focus();
			return;
		}
		if ($('#birthday').val() == ''){
			$('#birthday').focus();
			return;
		}else{
			if( $('#birthday').val().length != 8 ){
				alert('년월일 8자리로 입력해주십시오.');
				$('#birthday').focus();
				return;
			}
		}

		if ($('#telnumber').val() == ''){
			$('#telnumber').focus();
			return;
		}
		obj.CMD = mx.CMD_SENDSMS;
		obj.SENDPRE = "home_";
		obj.NM = nm;
		obj.MOBILENO = phoneno;
		obj.BIRTHDAY = birthday;
		mx.SendPacket(null, obj);
	};

	//비밀번호 찾기 시작
	mx.SMSPWD = function(){
		var id = $('#findPwId').val();
		if (id == ''){
			alert('아이디를 입력하여 주십시오.');
			return;
		}
		var obj = {};
		obj.CMD = mx.CMD_SENDSMSPWD;
		obj.SENDPRE = "home_";
		obj.NM = id;
		mx.SendPacket(null, obj);
	};

	//비밀번호 찾기 인증확인
	mx.chkSMSPWD = function(chkno){
		var chkno = $('#findchk').val();
		if (chkno == ''){
			alert('인증문자를 입력하여 주십시오.');
			return;
		}
		var obj = {};
		obj.CMD = mx.CMD_CHECKSMSPWD;
		obj.SENDPRE = "home_";
		obj.CHKNO = chkno;
		mx.SendPacket(null, obj);
	};


	//확인
	mx.chkSMS = function(chkno){
		var obj = {};
		var obj = {};
		if ($('#chkno').val() == ''){
			$('#chkno').focus();
			return;
		}
		obj.CMD = mx.CMD_CHECKSMS;
		obj.SENDPRE = "home_";
		obj.CHKNO = chkno;
		mx.SendPacket(null, obj);
	};


	mx.setCookie = function( name, value, expiredays ) {
		var todayDate = new Date();
		todayDate.setDate( todayDate.getDate() + expiredays );
		document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
	}

	//생성 팝업창 요청
	mx.getPop = function(sendpre){
		var obj = {};
		obj.CMD = mx.CMD_POP;
		obj.SENDPRE = sendpre;
		mx.SendPacket('notipopup', obj);
	};

	mx.oneDayClose = function(layerid){
		//expiredays의 1은 하루를 의미한다, 일주일은 7, 1년은 365로 입력
		if( $('#oneday').prop( "checked" ) == true ){
		mx.setCookie( layerid, "done" , 1);
		}
		$('#'+layerid).hide();
	};


	$(document).ready(function(){
		 // 도메인에 따라서 sendpre  설정 쿠키설정 (하자고)
		 var sendpre = "home_";
		mx.getPop(sendpre);

			$(document).mouseup(function (e){
			  var LayerPopup = $("#notipopup");
			  if(LayerPopup.has(e.target).length === 0){
				 $('#notipopup').hide();
			  }
			})



	});


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


	//결제정보저장 (임시)
	mx.savePayInfo = function(ortype,idx,nm,u1,u2){
		var obj = {};
		obj.CMD = mx.CMD_SAVEPAYINFO;
		obj.ORTYPE = ortype;
		obj.IDX = idx;
		obj.NM = nm;
		obj.U1 = u1;
		obj.U2 = u2;
		obj.SENDPRE = 'home_';
		mx.SendPacket(null, obj);
	};


	//find list
	//playeridx,username,eng_nm,team,teamnm,ksportsno,sex,birthday
	mx.CMD_SEARCH = mx.CMD_GETFINDHORSE;
	mx.pagenm = location.pathname.split('/').slice(-1)[0];
	mx.setfind = function(){

			if ( $("#searchstr").length > 0 ) {
				$( "#searchstr" ).autocomplete({
					source : function( request, response ) {

						var sendpre = "home_";
						switch (mx.pagenm) {
						case 'apply-online_certificate.asp': mx.CMD_SEARCH = mx.CMD_GETFINDHORSE; sendpre = "home_";	break;
						}

						 $.ajax({
								type: mx.ajaxtype,
								url: mx.ajaxurl,
								dataType: "json",
								data: { "REQ" : JSON.stringify({"CMD":mx.CMD_SEARCH, "SVAL":request.term, "PARM1": $("#searchstr").val(), "SENDPRE": sendpre})  },
								success: function(data) {
									//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
									console.log( px.strReplaceAll(JSON.stringify( data  ), '\"', '\"\"') );
									response(
										$.map(data, function(item) {
											return {
												label: item.fa,
												value: item.fa,
												idx:item.idx,
												fa:item.fa,
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
						case 'apply-online_certificate.asp':
							$("#kefno").html('KEF'+ ui.item.idx);
							$("#hidx").val(ui.item.idx);
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
			$("body").scrollTop(localStorage.getItem('scrollpostion'));
			$("body").click(function(event){
				window.toriScroll = $("body").scrollTop();
				localStorage.setItem('scrollpostion',window.toriScroll);
				console.log($("body").scrollTop());
			});


//		$(function() {
//			$('.date').datetimepicker({
//				format: 'YYYY-MM-DD',
//				locale:'KO'
//			});
//		});

		mx.setfind();

	};



//인쇄 /////////////////////////
    (function () {

        var beforePrint = function () {
            alert('Functionality to run before printing.');
        };

        var afterPrint = function () {
            alert('Functionality to run after printing');
        };


        if (window.matchMedia) {
            var mediaQueryList = window.matchMedia('print');

            mediaQueryList.addListener(function (mql) {
                alert($(mediaQueryList).html());
                if (mql.matches) {
                    beforePrint();
                } else {
                    afterPrint();
                }
            });
        }

        window.onbeforeprint = beforePrint;
        window.onafterprint = afterPrint;

    }());


	$(document).bind("keyup keydown", function (e) {
			 if (e.ctrlKey && e.keyCode == 80) {
				 setTimeout(function () { CallAfterWindowLoad();}, 5000);
				 return true;
			 }
	 });

		function CallAfterWindowLoad()
		{
			alert("Open and call");
		}

	mx.print = function(seq){
		var obj = {};
		obj.CMD = mx.CMD_PRINT;
		obj.SEQ = seq;
		$('#printkey').val(seq);
		obj.SENDPRE = 'home_';
		mx.SendPacket(null, obj);
	};


//  beforePrintEvent: null,     // function for printEvent in iframe
//  beforePrint: null,          // function called before iframe is filled
//  afterPrint: null            // function called before iframe is removed

    mx.afterPrint = function () {
			//제공하는거니까 그냥 쓰면됨.
			//if(!confirm('출력 또는 취소 하시면 재출력이 불가합니다.?')){
			//	return;
			//}
			var obj = {};
			obj.CMD = mx.CMD_PRINTEND;
			obj.SEQ = $('#printkey').val();
			obj.SENDPRE = 'home_';
			mx.SendPacket(null, obj);

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


	mx.OnPrint =  function(cmd, packet, html, sender){
		$('#printdiv').html(html);
		$('#printdiv').printThis({importCSS: false,loadCSS: '/css/print.css',header: false,afterPrint: mx.afterPrint });
	};



//응답##################################################################
	mx.OnReloadGubun =  function(cmd, packet, html, sender){
		switch (Number(packet.GUBUNTYPE)){
			case 1 : alert("참가신청이 완료되었습니다.");$('#radioApplySolo').click(); break;
			case 2 : alert("참가신청이 완료되었습니다.");$('#radioApplySoloSub').click(); break;
			case 3 : alert("참가신청이 완료되었습니다.");$('#radioApplyGroup').click(); break;
		}
	};

	mx.OnMsg =  function(cmd, packet, html, sender){
		if 	(cmd  == mx.CMD_SENDSMSPWD) {
			$('#inputarea').html('<label class="hide" for="findchk">인증문자 입력창</label><input id="findchk" type="text" placeholder="인증문자를 입력해주세요." autofocus>');
		    $('#btnarea').html('<button id="btnCertifi" class="btn-login t_blue s_on" type="button" name="button" onclick="mx.chkSMSPWD()"  style="width:100%">인증체크</button>');
		}
		alert("인증 번호가 전송되있습니다.");
	};
	mx.OnCheck =  function(cmd, packet, html, sender){
		if(cmd == mx.CMD_CHECKSMSPWD){
			alert("임시비밀번호가 발급되었습니다.");
		}
		else{
			px.goSubmit( {} , '/page/join.asp');
		}
	};

	mx.OndrowHTML =  function(cmd, packet, html, sender){
		$('#'+sender).html(html);
		if( cmd == mx.CMD_EDIT){
			mx.init();
		}

		else if(cmd == mx.CMD_FILEFORM){
			if( $('#' + sender).length == 1 ){
				$('body').append("<div id='"+sender+"' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
			}
			$('#'+sender).html(html);
			$('#'+sender).modal('show');
		}
		else if(cmd == mx.CMD_SHOWCONTENTS ){
			$('#listarea').hide();
			$('#viewarea').show();
		}
		else if(cmd == mx.CMD_POPHORSE || cmd == mx.CMD_POPPLAYER){
			$('#'+sender).show();
		}
		else if (cmd == mx.CMD_SETBOO){
			//참가신청내역 호출
			//mx.getAttList($('#selectgamelidx').val());
		}
		else{
			//$('#'+sender).html(html);
		}


	};


	mx.OnwritePop =  function(cmd, packet, html, sender){
		if( $('#' + sender).length == 0 ){
			$('body').append("<div id='"+sender+"' class='l_modal-wrap t_bg-hide'></div>");
		}
		$('#' + sender).html(html);

		var layer = $('#notipopup');
		var edate= new Date($('#popenddate').val());

		//닫기버튼 누를시 하루동안 열지않기
		cookiedata = document.cookie;
		if ( Date.now() <= edate && cookiedata.indexOf(sender+"=done") < 0 ){
			$('#' + sender).show();
		}
		else {
			$('#' + sender).hide();
		}
	};




//	 $(window).bind('beforeunload', function(){
//	   return '';
//	 });
//
//	 $(window).bind('unload', function(){
//
//	   //vm.ReqUpdate('cancel',{}); 저장 수정에 따라서
//	   let params = {};
//	   let keyarr = [];
//	   for (var i = 0; i < vm.mgr_list.length; i++) {
//		   keyarr.push(vm.mgr_list[i].seq);
//	   }
//	   params.seq= keyarr.join(',');
//	   params.state= vm.page_state;
//
//	   navigator.sendBeacon("./cancelsave.asp", JSON.stringify(params) );
//	   //return '';
//	 });