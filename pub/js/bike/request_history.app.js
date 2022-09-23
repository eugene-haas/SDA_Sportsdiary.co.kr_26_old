var mx =  mx || {};
mx.CMD_DATAGUBUN = 10000;
mx.CMD_CHKTEAM = 300; //팀명 중복 체크
mx.CMD_FINDPLAYER = 20010; //팀원 아이디 조회
mx.CMD_AGREE = 20020; //'동의창불러오기
mx.CMD_FINDEM = 20050; //수정할 맴버조회
mx.CMD_FINDEMOK = 700; //죄회한 맴버 수정

mx.CMD_TEAMLMS = 20100; //lms 보내기
mx.CMD_PLMS = 20200; //개인 보모동의 lms

mx.CMD_SETINFOCHANGE = 30000; //수정창부르기
mx.CMD_PNOCHK = 400;//인증
mx.CMD_PNOUPDATE = 410;//폰번호 업데이트
mx.CMD_ADDRUPDATE = 420;//주소업데이트
mx.CMD_EMAILUPDATE = 430; //이메일 업데이트


mx.CMD_PAGREE = 20030; //부모동의 확인 체크
mx.CMD_PAYNAME = 20040; //입금자명 입력

mx.CMD_LISTPOP = 40000; //부 팝업창

mx.CMD_PSMSPOP = 40010; //보호자동의 문자발송창

mx.CMD_AGREEPARENT = 500; //부모동의 완료
mx.CMD_REQREFUND = 600; //환불요청

///////////////////////////////////////////
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

//mx.ajaxurl = "/pub/ajax/bike/reqRequest.asp"; 
mx.ajaxurl = "/pub/ajax/bike/reqAttList.asp";  
mx.SendPacket = function( sender, packet){
	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = mx.ajaxurl;
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	//setTimeout( function(){ reqdone = true; }, timeout );

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){
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
		case 2:	alert('중복된 데이터가 존제합니다.');return; 	break;
		case 300: alert('사용 중 입니다.');return; break;
		case 301: alert('사용가능 합니다.');return; break;
		case 302: alert('보호자의 전화번호를 정확히 입력해 주십시오.');return; break;

		case 400: alert('회원가입이 되어있지 않습니다.');return; break;
		case 401: alert('자전거 선수로 등록되어 있지 않습니다. 선수등록 후 이용해 주십시오.');return; break;

		case 9090: alert('동의가 완료 되었습니다.');location.reload();return; break;
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_FINDEMOK : alert("팀원이 변경되었습니다."); break;
	case mx.CMD_FINDEM:this.OnFindMember( reqcmd, jsondata, htmldata, sender );	break; //팀원 수정 조회


	case mx.CMD_AGREE:this.OnbodyChange( reqcmd, jsondata, htmldata, sender );	break;
	case mx.CMD_FINDPLAYER:this.OndrowHTMLTAB( reqcmd, jsondata, htmldata, sender );	break;
	case mx.CMD_TEAMLMS : this.OnLMS( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_PLMS : this.OnPLMS( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_SETINFOCHANGE:this.OndrowHTML( reqcmd, jsondata, htmldata, sender );	break;
	case mx.CMD_PNOCHK : this.OnStartChk( reqcmd, jsondata, htmldata, sender );	break;
	case mx.CMD_EMAILUPDATE :
	case mx.CMD_ADDRUPDATE :
	case mx.CMD_PNOUPDATE  : this.OnUpdateEnd( reqcmd, jsondata, htmldata, sender );	break; //폰번호 업데이트 완료 원래화면 복귀


	case mx.CMD_PSMSPOP : //보호자동의 문자발송창
	case mx.CMD_LISTPOP : this.OndrowHTMLModal( reqcmd, jsondata, htmldata, sender );	break; //부팝업메뉴창
	case mx.CMD_PAGREE : this.OnpagreeCheck( reqcmd, jsondata, htmldata, sender );	break; //부모동의여부체크
	case mx.CMD_PAYNAME :this.OnpayName( reqcmd, jsondata, htmldata, sender );	break; //입금자명 입력

	case mx.CMD_REQREFUND :this.OnRefund( reqcmd, jsondata, htmldata, sender );	break; //환불신청완료
	}
};

///////////////////////////////////////////
mx.OnRefund =  function(cmd, packet, html, sender){
	mx.go(packet, sender);
};


//===========업데이트
	mx.m = '';
	mx.SetTime = 179;
	//mx.SetTime = 10;
	mx.msg_time = function(){
		if ( (mx.SetTime % 60) < 10){
			var ss = '0' + (mx.SetTime % 60);
		}
		else{
			var ss = (mx.SetTime % 60);
		}

		mx.m = Math.floor(mx.SetTime / 60) + ":" + ss;	// 남은 시간 계산
		
		//console.log(ss + " " + mx.SetTime);
		
		$('#chktime').html(mx.m);
		mx.SetTime--;					// 1초씩 감소
		if (mx.SetTime < 0) {			// 시간이 종료 되었으면..
			clearInterval(mx.tid);		// 타이머 해제
			mx.changeForm($('#orgvalue').val(),'pno_chk',2);
			//체크할 인증번호 삭제
		}
	};
	mx.tid;

	mx.OnStartChk = function(cmd, packet, html, sender){
		alert('인증번호가 전송되었습니다.');
		$('#confNo').val(packet.tempno);
		$('#confPno').val(packet.PNO);
		mx.tid=setInterval('mx.msg_time()',1000) ;
		$('#chkrnd_no').focus();
	};

	mx.OnUpdateEnd =  function(cmd, packet, html, sender){
		alert("수정 되었습니다.");
		mx.changeForm(packet.CHANGEVAL,packet.TARGETID, packet.FNO)
		//console.log("업데이트 완료");
	};
//===========업데이트

mx.OnpayName =  function(cmd, packet, html, sender){
	alert("입금자명이 입력되었습니다. 계좌로 입금후 확인하여 주십시오.");
	document.getElementById(sender).innerHTML = html;
};

mx.OnpagreeCheck =  function(cmd, packet, html, sender){
	if (packet.PA == 'Y'){
		document.getElementById(sender).innerHTML = html;
		if (packet.ATTM == 'Y'){
			$('#payinfobox').show();
		}
	}
	else{
		alert("보호자 동의가 완료 되지 않았습니다.");
	}
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
};

mx.OnFindMember = function(cmd, packet, html, sender){
	alert("사용가능합니다.");
	$('#search_'+sender).val(packet.fnm);	
	document.getElementById('team_'+sender).innerHTML = html;
};

mx.OnGoUrl = function(cmd, packet, html, sender){
	if (packet.adult == 'N'){//부모동의 발송
		packet.CMD = mx.CMD_PLMS;
		mx.SendPacket(sender, packet);			
	}
	else{
		mx.go(packet, sender);
	}
};



mx.delaypacket;
mx.delaysender;
mx.delaygo = function(){
	mx.go(mx.delaypacket, mx.delaysender);
};
mx.delaySend = function(){
	mx.SendPacket(mx.delaysender, mx.delaypacket);
};


mx.OnPLMS = function(cmd, packet, html, sender){
	  $("#lmsform").html(html);
	  document.lms_form.submit();
	  $('#'+sender).hide();
	  alert("전송이 완료되었습니다.");
	  //location.reload();
};


mx.OnLMS = function(cmd, packet, html, sender){
	if(Number(packet.lmsno) > 0 ){
		  $("#lmsform").html(html);
		  document.lms_form.submit();

		  if (Number(packet.lmsno) >= Number(packet.sendcnt) ){
			  console.log("종료페이지로 가기");
			  mx.go(packet, sender);
			  return;
		  }
		  else{
			packet.CMD = mx.CMD_TEAMLMS;
			//mx.SendPacket(sender, packet);
			mx.delaypacket = packet;
			mx.delaysender = sender;
			setTimeout("mx.delaySend()",500);	  
		  }
	}
	else{
			packet.CMD = mx.CMD_TEAMLMS;
			//mx.SendPacket(sender, packet);
			mx.delaypacket = packet;
			mx.delaysender = sender;
			setTimeout("mx.delaySend()",500);	
	}
};


mx.OnAppend = function(cmd, packet, html, sender){
  $("#"+sender).append( html );
};

mx.OndrowHTMLTAB =  function(cmd, packet, html, sender){
	if (Number(packet.tabno) == 0)	{
		mx.ids_1[packet.pno] = packet.uid;	
	}
	else{
		mx.ids_2[packet.pno] = packet.uid;	
	}
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).show();
};


mx.OndrowHTMLModal =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
	if (cmd == mx.CMD_PSMSPOP){
		userinfobtn();
	}
};

////////////////////////////////////////////


mx.go = function(packet, gourl){
	document.sform.p.value =   JSON.stringify( packet  );
	document.sform.action = gourl;
	document.sform.submit();
};

//////////////////////////////////////////////////////////////////////////

//숫자만입력
mx.chkNo = function(){
	if(event.keyCode == 8 || event.keyCode ==46){}else{if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;}
};


//인증번호전송
mx.chkMSG = function(){
	var tel1 = $('#tel1').val();
	var tel2 = $('#tel2').val();
	var tel3 = $('#tel3').val();
	if (tel2 == '' ){
		alert('휴대폰 번호를 입력해주십시오.');
		 $('#tel2').focus();
		 return;
	}
	if (tel3 == '' ){
		alert('휴대폰 번호를 입력해주십시오.');
		 $('#tel3').focus();
		 return;
	}

	if ($('#confNo').val()){
		if (!window.confirm('인증번호를 다시 전송하시겠습니까?')){
			return;
		}
		else{
			mx.m = '';
			mx.SetTime = 179;
			clearInterval(mx.tid);// 타이머 해제		
		}
	}

	var packet = {};
	packet.CMD = mx.CMD_PNOCHK;
	packet.PNO = tel1 +"-"+ tel2 +"-"+ tel3;
	mx.SendPacket('pno_chk', packet);
	
};

//인증번호 비교
mx.compRnd = function(){
	var myrndno = $('#chkrnd_no').val();
	var confNo = $('#confNo').val();
	var confPno = $('#confPno').val();

	if (myrndno == ''){
		if (confNo == ''){
			alert('인증을 클릭해 주십시오.');
		}
		else{
			alert('인증번호를 입력하세요.');
			$('#chkrnd_no').focus();
		}
		return;
	}
	if (myrndno == confNo){
		//현재 입력값과 인증받은 전화번호값이 같은지 비교
		//수정하로 가자...
		mx.m = '';
		mx.SetTime = 179;
		clearInterval(mx.tid);// 타이머 해제		
		var packet = {};
		packet.CMD = mx.CMD_PNOUPDATE;
		packet.PNO = confPno;
		mx.SendPacket('pno_chk', packet);
	}
	else{
		if (confNo == ''){
			alert('인증을 클릭해 주십시오.');
		}
		else{
			alert('인증번호가 다름니다. 정확히 입력해 주십시오.');
		}
		$('#chkrnd_no').focus();
		return;
	}
};

//주소저장
mx.saveAddr = function(){
	if ($("#uaddr").val() == '' || $("#uaddr2").val() == '' ){
		Postcode();
		return;
	}
	var packet = {};
	packet.ADDR = $("#uaddr").val();
	packet.ADDR2 = $("#uaddr2").val();
	packet.ZIPCODE = $("#zipcode").val();
	packet.SIDO = $("#sido").val();

	packet.CMD = mx.CMD_ADDRUPDATE;
	mx.SendPacket('addr_chk', packet);
};


mx.setEmail = function(){

	if($('#str_emaillist').val()== ''){
		$("#str_email2").val('');
		$("#str_email2").attr("disabled",false);
		$("#str_email1").focus();
	}
	else{
		$("#str_email2").val($('#str_emaillist').val());
		$("#str_email2").attr("disabled",true);
		$("#str_email1").focus();
	}
};


mx.saveEmail = function(){
	var e1 = $("#str_email1").val();
	var e2 = $("#str_email2").val();
	var email = e1 + "@" + e2;
	var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
	if(exptext.test(email)==false){
		alert('이메일 형식이 올바르지 않습니다.');
		return;
	}
	var packet = {};
	packet.CMD = mx.CMD_EMAILUPDATE;
	packet.EMAIL = email;
	mx.SendPacket('email_chk', packet);
};


//모달 내용 불러오기
mx.SetBbooPop = function(packet,sender){
	packet.CMD = mx.CMD_LISTPOP;
	mx.SendPacket(sender, packet);		
};

//부모동의확인
mx.pagreeChk = function(packet, sender){
	packet.CMD = mx.CMD_PAGREE;
	mx.SendPacket(sender, packet);		
};

//입금자명 입력
mx.payUpdate = function(packet, sender){
	packet.CMD = mx.CMD_PAYNAME;
	if ($('#payname').val()==''){
		alert("입금자 명을 입력하여 주십시오.");
		$('#payname').focus();
		return;
	}
	packet.PAYNM = $('#payname').val();
	mx.SendPacket(sender, packet);	
};

//부모동의창
mx.sendLms = function(packet,sender){
	packet.CMD = mx.CMD_PSMSPOP;
	mx.SendPacket(sender, packet);		
};


mx.sendReLms = function(packet, sender){


	var parent_relation = '부';
	if(   $('#parent_name').val() == ''   ){ //보호자정보 (미성년자 상관없이 입력, 문자만 미성년인경우 발송
		//보호자 장보 미입력
		alert("보호자 이름을  입력해 주십시오.");
		$('#parent_name').focus();
		return;
	}
	if(  $('#ptel2').val() == '' || $('#ptel3').val() == ''  ){
		alert("보호자 전화번호를  입력해 주십시오.");
		$('#ptel2').focus();
		return;
	}
	if(  $('input:radio[name=parent_relation]').is(':checked')   ){ 
		if( $(":input:radio[name=parent_relation]:checked").val() == '기타' ){
			 if( $('#parent_etc').val() == ''){
				alert('관계를 입력하여 주십시오.');
				$('#parent_etc').focus();
				return;
			 }else{
				  parent_relation = $('#parent_etc').val();
			 }
		}
		else{
		  parent_relation = $(":input:radio[name=parent_relation]:checked").val();				
		}
	}
	else{
		alert("관계 정보를  선택해 주십시오.");
		return;
	}

	if( $('#chkNM').val() ==  $('#parent_name').val()  ){
		alert("본인은 대상이 될수 없습니다.");
		return;
	}
	if( $('#chkPNO').val() == $('#ptel1').val() + "-" + $('#ptel2').val() +"-"+$('#ptel3').val() ){
		alert("본인의 핸드폰 입니다.");
		return;
	}

	//console.log(parent_relation);

	//참가신청 등록
	packet.p_nm = $('#parent_name').val();
	packet.p_phone = $('#ptel1').val() + "-" + $('#ptel2').val() +"-"+$('#ptel3').val();
	packet.p_relation = parent_relation;
	packet.CMD = mx.CMD_PLMS;
	mx.SendPacket(sender, packet);			
};


mx.agreeParent = function(packet){

	var parent_relation = '부';
	if ($('#my_agree').is(':checked')== true){
		if(   $('#parent_name').val() == ''   ){ //보호자정보 (미성년자 상관없이 입력, 문자만 미성년인경우 발송
			//보호자 장보 미입력
			alert("보호자명을  입력해 주십시오.");
			$('#parent_name').focus();
			return;
		}
		if(  $('#uaddr').val() == '' || $('#uaddr2').val() == ''  ){
			alert("보호자(동의인) 주소를  입력해 주십시오.");
			return;
		}
		if(  $('input:radio[name=parent_relation]').is(':checked')   ){ 
			if( $(":input:radio[name=parent_relation]:checked").val() == '기타' ){
				 if( $('#parent_etc').val() == ''){
					alert('신청자와의 관계를 입력하여 주십시오.');
					$('#parent_etc').focus();
					return;
				 }else{
					  parent_relation = $('#parent_etc').val();
				 }
			}
			else{
			  parent_relation = $(":input:radio[name=parent_relation]:checked").val();				
			}
		}
		else{
			alert("관계 정보를  선택해 주십시오.");
			return;
		}

		//console.log(parent_relation);

		//참가신청 등록
		packet.PAGREE = 'Y';
		packet.PNM = $('#parent_name').val();
		packet.PADDR = $('#uaddr').val() + " " + $('#uaddr2').val();
		packet.PRT = parent_relation;

		packet.CMD = mx.CMD_AGREEPARENT;
		mx.SendPacket(null, packet);		


	}
	else{
		alert('개인정보 취급방침에 동의하여 주십시오.');
		return;
	}

};


mx.reqRefund = function(packet, sender){
	if ($('#refundbanknm').val() == ''){
		alert("환불받으실 은행명을 선택해 주십시오.");
		return;
	}
	if($('#refundno').val() == ''){
		alert("환불받으실 계좌번호를 입력해 주십시오.");
		return;
	}
	packet.REFUNDBNK = $('#refundbanknm').val();
	packet.REFUNDNO = $('#refundno').val();
	packet.CMD = mx.CMD_REQREFUND;
	mx.SendPacket(sender, packet);	
};




mx.findEditMember = function(packet,mno){
	packet.CMD = mx.CMD_FINDEM;
	packet.findnm = $('#findm_'+mno).val(); 
	packet.attmidx  = $('#tm_'+mno).val();
	mx.SendPacket(mno, packet);
};

mx.EditMember = function(packet,mno){
	if( $('#search_'+mno).val() == ''){
		alert("먼저 조회하여 주십시오.");
		return;
	};
	packet.CMD = mx.CMD_FINDEMOK;
	packet.findnm = $('#search_'+mno).val(); 
	packet.attmidx  = $('#tm_'+mno).val();
	mx.SendPacket(mno, packet);
};