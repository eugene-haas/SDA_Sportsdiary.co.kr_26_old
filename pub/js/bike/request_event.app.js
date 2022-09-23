var mx =  mx || {};
mx.CMD_DATAGUBUN = 10000;
mx.CMD_REGGAME = 200; //참가신청
mx.CMD_REGTEAMGAME = 210; //참가신청
mx.CMD_AGREETEAMMEMBER = 220; //팀원동의

mx.CMD_PLUSMEMBER = 20000; //단체추발 추가 인원 양식 추가
mx.CMD_CHKTEAM = 300; //팀명 중복 체크
mx.CMD_FINDPLAYER = 20010; //팀원 아이디 조회
mx.CMD_AGREE = 20020; //'동의창불러오기


mx.CMD_TEAMLMS = 20100; //lms 보내기
mx.CMD_PLMS = 20200; //개인 보모동의 lms

mx.CMD_SETINFOCHANGE = 30000; //수정창부르기

mx.CMD_PNOCHK = 400;//인증
mx.CMD_PNOUPDATE = 410;//폰번호 업데이트
mx.CMD_ADDRUPDATE = 420;//주소업데이트
mx.CMD_EMAILUPDATE = 430; //이메일 업데이트
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

mx.ajaxurl = "/pub/ajax/bike/reqRequest.asp";
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

		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_CHKTEAM:this.OnChkTeam( reqcmd, jsondata, htmldata, sender );	break;

	case mx.CMD_AGREE:this.OnbodyChange( reqcmd, jsondata, htmldata, sender );	break;
	case mx.CMD_FINDPLAYER:this.OndrowHTMLTAB( reqcmd, jsondata, htmldata, sender );	break;
	case mx.CMD_PLUSMEMBER:this.OnAppend( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_AGREETEAMMEMBER : //팀원동의
	case mx.CMD_REGGAME: this.OnGoUrl( reqcmd, jsondata, htmldata, sender );				break;

	case mx.CMD_REGTEAMGAME	: this.OnLMS( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_TEAMLMS : this.OnLMS( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_PLMS : this.OnPLMS( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_SETINFOCHANGE:this.OndrowHTML( reqcmd, jsondata, htmldata, sender );	break;
	case mx.CMD_PNOCHK : this.OnStartChk( reqcmd, jsondata, htmldata, sender );	break;

	case mx.CMD_EMAILUPDATE :
	case mx.CMD_ADDRUPDATE :
	case mx.CMD_PNOUPDATE  : this.OnUpdateEnd( reqcmd, jsondata, htmldata, sender );	break; //폰번호 업데이트 완료 원래화면 복귀
	}
};

///////////////////////////////////////////

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

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
};

mx.OnChkTeam = function(cmd, packet, html, sender){
	$("#tncopy_" + packet.chkgame.split(",")[0]).val(packet.teamnm);
	alert("사용가능합니다.");
	$('#teamnm_'+packet.chkgame.split(",")[0]).focus();
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
mx.delaygo =function(){
	mx.go(mx.delaypacket, mx.delaysender);
};
mx.delaySend = function(){
	mx.SendPacket(mx.delaysender, mx.delaypacket);
};

mx.OnPLMS = function(cmd, packet, html, sender){
	  $("#lmsform").html(html);
	  document.lms_form.submit();
	  //mx.go(packet, sender);

	  mx.delaypacket = packet;
	  mx.delaysender = sender;
	  setTimeout("mx.delaygo()",500);
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


mx.OnbodyChange = function(cmd, packet, html, sender){
  if($("#agreeDiv").text() == '' ){
	  $("#agreeDiv").html(html);
  }
  $("#div_01").hide();
  $("#div_02").hide();
  $("#div_03").hide();
  $("#div_04").hide();

  checkboxdesign2(); //없으니까 한번 실행해주고. 체크박스.  bike.ui.js
  userinfobtn();//라디오

  $("#agreeDiv").show();
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
	//$('#'+sender).modal('show'); //#request_search_modal
};

////////////////////////////////////////////


mx.go = function(packet, gourl){
	document.sform.p.value =   JSON.stringify( packet  );
	document.sform.action = gourl;
	document.sform.submit();
};

mx.selectGame = function(packet, gourl){
	var bookey = "";
	var gradeid = "";
	var gradeval = "";
	var chkgame = "";
	var msgshow = true;
	var attcnt = 0;
    $("input:checkbox:checked").each(function (index) {
		bookey = $(this).val();
		gradeid = "pgrade_" + bookey;
		gradeval = $('#'+gradeid).val();
		if (gradeval == '' || msgshow == false){
			if (msgshow){
				alert("선택한 경기의 등급을 입력해 주십시오.");
				msgshow = false;
			}
			return;
		}
		attcnt = Number(attcnt) + 1;
		chkgame += bookey + "," + gradeval + ":"
    });

	packet.chkgame = chkgame;
	if (chkgame == ''){
		if (msgshow){
			alert("종목을 선택하여 주십시오.");
		}
		return;
	}
	//단체인 경우 한종목씩 참가신청 가능
	if(Number(packet.subtype) == 2 ){
		if (Number(attcnt) != 1){
			alert("단체경기는 한종목씩 참가신청이 가능합니다.");
			return;
		}
	}

	if (msgshow){
		mx.go(packet, gourl);
	}
	else{
		return;
	}
};

//참가신청 (개인전/단체)
mx.regNext = function(packet, gourl){
	packet.bikeidx = $('#bikeidx').val();
	for (var i = 1;i <= 2 ;i++ ){
		if ( $("#MarriageGb"+i).is(":checked") == true ) {
			packet.marriage = $('#MarriageGb'+i).val();
		}
	}
	if (packet.marriage == undefined || packet.marriage == '' ){
		alert("결혼유무를 체크하여 주십시오.");
		return;
	}
	packet.job = $('#Bike_Job').val();
	if (packet.job == undefined || packet.job == '' ){
		alert("직업을 선택하여 주십시오.");
		return;
	}
	for (var i = 1;i <= 4 ;i++ ){
		if ( $("#BloodType"+i).is(":checked") == true ) {
			packet.bloodtype = $('#BloodType'+i).val();
		}
	}
	if (packet.bloodtype == undefined || packet.bloodtype == '' ){
		alert("혈액형을 선택하여 주십시오.");
		return;
	}
	packet.career = $('#Bike_Career').val();
	if (packet.career == undefined || packet.career == '' ){
		alert("자전거 경력을 선택하여 주십시오.");
		return;
	}
	packet.brand = $('#Bike_brand').val();
	if (packet.brand == undefined  || packet.brand == '' ){
		alert("사용중인 자전거 프레임을 선택하여 주십시오.");
		return;
	}
	for (var i = 1;i <= 5 ;i++ ){
		if ( $("#gamegift"+i).is(":checked") == true ) {
			packet.gamegift = $('#gamegift'+i).val();
		}
	}
	// if (packet.gamegift == undefined   || packet.gamegift == ''){
	// 	alert("사은품을 선택하여 주십시오.");
	// 	return;
	// }

	if(packet.hasOwnProperty("attmidx")){
		packet.CMD = mx.CMD_AGREE;
		mx.SendPacket(gourl, packet);
	}
	else{
		if (Number(packet.subtype) == 1){
			packet.CMD = mx.CMD_AGREE;
			mx.SendPacket(gourl, packet);
		}
		else{
			packet.CMD = mx.CMD_REGGAME;
			mx.SendPacket(gourl, packet);
		}
	}

};







//개인 참가신청, 또는 팀원 동의때 사용
mx.regPerson = function(packet, gourl){


	var parent_relation = '부';
	if ($('#my_agree').is(':checked')== true){
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
		packet.agree = 'Y';
		packet.adult =$('#myageST').val(); //성인미성년여부
		packet.teamnm = $('#teamnm_'+packet.chkgame.split(":")[0].split(',')[0]).val();
		packet.teamlist = mx.ids_1.join(); //참가자 아이디
		packet.p_nm = $('#parent_name').val();
		packet.p_phone = $('#ptel1').val() + "-" + $('#ptel2').val() +"-"+$('#ptel3').val();
		packet.p_relation = parent_relation;

		if(packet.hasOwnProperty("attmidx")){ //팀원 동의하로 왔을때
			packet.CMD = mx.CMD_AGREETEAMMEMBER;
			mx.SendPacket(gourl, packet);
		}
		else{
			packet.CMD = mx.CMD_REGGAME;
			mx.SendPacket(gourl, packet);
			console.log(packet)
		}

	}
	else{
		alert('동의가 있어야 참가신청이 가능합니다.');
		return;
	}
};


//참가신청 (단체전 서약서및 보호자 동의)
mx.myAgree = function(packet, gourl){
	//단체전 어떤타입인지...단체추발 4명까지 팀스프린트 3명

	var selectgame = packet.chkgame.split(":");
	if (Number(selectgame.length) == 3){ //2팀이라면
		if(	mx.ids_1[0] == '' || mx.ids_1[1] == '' || mx.ids_1[2] == '' || mx.ids_2[0] == '' || mx.ids_2[1] == '' || mx.ids_2[2] == '' ){
			alert('참가선수를 모두 조회해서 입력해 주십시오.');
			return;
		}
	}
	else{

		if( $('#teamnm_'+selectgame[0].split(',')[0]).val() == '' || $("#tncopy_" + selectgame[0].split(',')[0]).val() != $('#teamnm_'+selectgame[0].split(',')[0]).val()    ){ //조회여부확인
			alert('팀명을 조회하여 입력하여 주십시오.');
			$('#teamnm_'+selectgame[0].split(',')[0]).focus();
			return;
		}
		if(	mx.ids_1[0] == '' || mx.ids_1[1] == '' || mx.ids_1[2] == '' ){
			alert('참가선수를 모두 조회해서 입력해 주십시오.');
			return;
		}
	}

	packet.CMD = mx.CMD_AGREE;
	mx.SendPacket(gourl, packet);
};

mx.reqTeamNext = function(packet, gourl){
	var parent_relation = '부';
	if ($('#my_agree').is(':checked')== true){
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

		console.log(parent_relation);

		//참가신청 등록
		packet.agree = 'Y';
		packet.adult =$('#myageST').val(); //성인미성년여부
		packet.teamnm = $('#teamnm_'+packet.chkgame.split(":")[0].split(',')[0]).val();
		packet.teamlist = mx.ids_1.join(); //참가자 아이디
		packet.p_nm = $('#parent_name').val();
		packet.p_phone = $('#ptel1').val() + "-" + $('#ptel2').val() +"-"+$('#ptel3').val();
		packet.p_relation = parent_relation;
		packet.CMD = mx.CMD_REGTEAMGAME;
		mx.SendPacket(gourl, packet);

	}
	else{
		alert('동의가 있어야 참가신청이 가능합니다.');
		return;
	}

};


mx.myAgreeClose = function(){
  //$("#agreeDiv").html(html);
/*
  $("#agreeDiv").hide();
  $(".sub-header").show();
  $(".sub-content").show();
  $(".check-point").show();
  $(".pd-15").show();
*/
  $("#agreeDiv").hide();
  $("#div_01").show();
  $("#div_02").show();
  $("#div_03").show();
  $("#div_04").show();
}

//////////////////////////////////////////////////////////////////////////
mx.plusMember= 0;
mx.removeDom = function(domid,levelidx,tabno){
	mx.plusMember--;
	if(tabno == 0){
		mx.ids_1[3] = '';
	}
	if(tabno == 1){
		mx.ids_2[3] = '';
	}

	$("#"+domid).remove();
};

mx.appendDom = function(domid,levelidx,packet,tabno){
	if (  mx.plusMember == 0   ){
		mx.plusMember++;
	}
	else{
		alert("최대 4명까지만 참여가 가능합니다.");
		return;
	}


	packet.CMD = mx.CMD_PLUSMEMBER;
	packet.levelidx = levelidx;
	packet.tabno = tabno;
	mx.SendPacket(domid, packet);
};

mx.chkTeam = function(packet,levelidx){
	packet.CMD = mx.CMD_CHKTEAM;
	packet.levelidx = levelidx;
	packet.teamnm = $('#teamnm_'+levelidx).val();
	if(packet.teamnm == '' ){
		alert('팀명을 입력해 주십시오.');
		$('#teamnm_'+levelidx).focus();
		return;
	}
	mx.SendPacket('teamnm_'+levelidx, packet);
};


mx.ids_1 = ['','','','']; //탭1의 참여 아이디 (4개 고정)
mx.ids_2 = ['','','',''];
mx.chkPlayer = function(packet , levelidx, pno, tabno){
	packet.CMD =  mx.CMD_FINDPLAYER;
	packet.levelidx = levelidx;
	packet.tabno = tabno; //텝번호
	packet.pno = pno; //배열번호

	if(tabno == 0){
		mx.ids_1[0] = $('#ids_'+tabno).val();
	}
	if(tabno == 1){
		mx.ids_2[0] = $('#ids_'+tabno).val();
	}

	if (tabno ==0 ){
		packet.ids = mx.ids_1.join();
	}
	else{
		packet.ids = mx.ids_2.join();
	}

	packet.uid = $('#m'+pno+'_'+levelidx).val();

	if(packet.uid == '' ){
		alert('팀원 아이디를 입력해 주십시오.');
		$('#m'+pno+'_'+levelidx).focus();
		return;
	}
	mx.SendPacket('p'+pno+'_'+levelidx, packet);


//	$('#request_search_modal').modal('show'); //#request_search_modal
};

mx.changeForm = function(orgvalue, targetid, formno){
	var packet = {};
	packet.CMD = mx.CMD_SETINFOCHANGE;
	packet.FNO = formno;
	packet.OVAL = orgvalue;
	packet.TARGET = targetid;
	mx.SendPacket(targetid, packet);
};

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

mx.notice = function(){
	//$('#summary_modal').show();
	var $viewport = $('head meta[name="viewport"]');
	$viewport.attr('content', 'width=device-width, minimum-scale=1, initial-scale=1');
};

mx.noticeclose = function(){
	var $viewport = $('head meta[name="viewport"]');
	$viewport.attr('content','width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no');
};

mx.searchLevel = function(jsonobj){
	var obj = jsonobj;
	obj.levelTitle = $('#pgrade_126').val();
	//
	document.sform2.p.value =   JSON.stringify( obj  );
	document.sform2.submit();

	console.log(obj);
};
