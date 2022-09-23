var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_LOGIN = 1; //로그인
	mx.CMD_LOGOUT = 2;
	mx.CMD_LOGCHECK = 3;
	mx.CMD_CAL = 4;

	mx.CMD_PCODE = 5; //공통코드 호출
	mx.CMD_TEAMCODE = 6; //팀코드


	mx.CMD_FINDSCORE = 7; //스코어 입력 창으로 이동 없을경우 인서트 
	mx.CMD_RECORDER = 8; //기록관입력
	mx.CMD_SAVECOURT = 9; //코트 정보저장
	mx.CMD_MODECHANGE = 10; //코트정보 수정모드
	mx.CMD_SETPOINT = 11;  //포인트 입력

	mx.CMD_TEST = 12; //테스트를 위해 설정된 값들을 초기화 시킨다
	mx.CMD_GAMEEND = 13; //한게임 종료
	//mx.CMD_GAMEPOINT= 14; //GAMEPOINT 생성
	mx.SETSERVE = 15; //두번째 서비스 설정
	mx.CMD_PRE = 16; //이전단계로
	mx.CMD_ENTERSCOREEND = 17; //경기종료 버튼클릭

	mx.CMD_DATAGUBUN = 10000;


	mx.CMD_GAMESEARCH = 20000; //경기스코어 검색
	mx.CMD_SETSCORE = 20001; //경기스코어보기 / 수정
	mx.CMD_STATUSSEARCH = 20002; //현황보기 검색

	mx.CMD_GAMEGRADEPERSON = 30000;  //경기기록실 성적, 입상현황개인
	mx.CMD_GAMEGRADEPERSONAPPEND = 30001;  //경기기록실 성적, 입상현황개인

	mx.CMD_GAMEGRADEGROUP = 30002;
	mx.CMD_GAMEGRADEGROUPAPPEND = 30003;

	mx.CMD_RANKINGRATE = 30004; //경기승률
	mx.CMD_RANKINGRATEAPPEND = 31000; //경기승률 more

	mx.CMD_RANKINGMEDAL = 30005; //메달순위
	mx.CMD_RANKINGMEDALAPPEND =  31001; //메달순위 more


	mx.CMD_RANKINGMEDALTOTAL = 30006; //메달합계
	mx.CMD_CMD_RANKINGMEDALTOTALAPPEND =  31002; //메달순위 more

	mx.CMD_ENTERSCORE = 30007; //스코어 입력 화면
	mx.CMD_SCORELIST = 30009; //포인트 기록화면 불러오기



////////////////////////////////////////

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


//히스토리 저장/////////////////////////////////////////////////////////////////////////
mx.arrKey = ["CMD","PG",'SEQ',"IDX","T","R","SP","LVL","FT","SSTR","DN","NM","ST"]; //"PAGEC",'SEQ',"IDX","TID","REF","STEP","LVL","FINDTYPE","SEARCHSTR","DBNAME","이전다음 상태"
mx.historybackstr = null;

mx.CheckForHash = function(){ //백버튼 클릭시 위치로 이동
	if( document.location.hash && document.location.hash != mx.historybackstr  ){
		mx.historybackstr = document.location.hash;

		var HashLocationName = document.location.hash;
		HashLocationName = HashLocationName.replace("#","");

		var objkey = HashLocationName.split('^');
		var sendparam = {};
		var keylen = mx.arrKey.length;
		for ( var  i= 0 ;i < keylen ;i++ )	{
			if (objkey[i] != '')	{
				sendparam[mx.arrKey[i]] = objkey[i];
			}
		}
		var objlen = Object.keys(sendparam).length;
		if (objlen > 0 ){
			mx.SendPacket(null, sendparam);
		}
	}else{
		//첫페이지 불러오기
	}
};

mx.RenameAnchor = function (anchorid, anchorname){
	document.getElementById(anchorid).name = anchorname; //this renames the anchor
}

mx.RedirectLocation = function (anchorid, anchorname, HashName){
	mx.RenameAnchor(anchorid, anchorname);
	document.location = HashName;
};

mx.HashCheckInterval = setInterval("mx.CheckForHash()", 1000);
window.onload = mx.CheckForHash;
//히스토리 저장/////////////////////////////////////////////////////////////////////////

//innerHTML 로딩 시점을 알기위해 추가
mx.waitUntil = function (fn, condition, interval) {
    interval = interval || 100;

    var shell = function () {
            var timer = setInterval(
                function () {
                    var check;

                    try { check = !!(condition()); } catch (e) { check = false; }

                    if (check) {
                        clearInterval(timer);
                        delete timer;
                        fn();
                    }
                },
                interval
            );
        };

    return shell;
};

mx.login = function(){
	if($("#UserID").val() == ""){
		alert("아이디를 입력하시기 바랍니다.");
		return;
	}

	if($("#UserPass").val() == ""){
		alert("패스워드를 입력하시기 바랍니다.");
		return;
	}
	mx.SendPacket(null, {'CMD':mx.CMD_LOGIN,'ID':$("#UserID").val(),'PWD':$("#UserPass").val()})	
};



//동일한 패킷이 오는경우 (막음 처리해야겠지)
mx.SendPacket = function( sender, packet){

	//var objlen = Object.keys(packet).length;
	if ( (Number(packet.CMD) >= mx.CMD_DATAGUBUN && Number(packet.CMD) < mx.CMD_DATAGUBUN + 10000)  && sender != null){ //보이는 화면 만 히스토리에 저장
		var locstr='';
		var iskey = false;
		var keylen = mx.arrKey.length;
			
		for ( var  i= 0 ;i < keylen ;i++ )	{ //배열갯수만큼만 생성

			for (var key in packet) { //한개씩만 붙여나가자
				if (key == mx.arrKey[i])	{
					if (i == 0 ){
						locstr += packet[key];
						iskey = true;
						break;
					}
					else{
						locstr += '^' + packet[key];
						iskey = true;
						break;
					}
				}
				else{
					iskey = false;
					//locstr += '^';
					//break;
				}
			}
			if (iskey == false){
				locstr += '^';
			}

		}

		mx.RedirectLocation("LocationAnchor", packet.CMD, "#"+locstr);
		return;
	}




	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = "/pub/ajax/reqTennis_operating.asp";
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	//setTimeout( function(){ reqdone = true; }, timeout );

    if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
		apploading("AppBody", "로딩 중 입니다.");
	}

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){
			
				if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){				
					$('#AppBody').oLoader('hide');
				}

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
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_LOGIN:	this.OnLogin( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_LOGOUT:	this.OnLogout( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_LOGCHECK:	this.OnLoginchk( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_STATUSSEARCH:
	case mx.CMD_GAMEGRADEPERSON:
	case mx.CMD_GAMEGRADEGROUP:
	case mx.CMD_RANKINGRATE:
	case mx.CMD_RANKINGMEDAL:
	case mx.CMD_RANKINGMEDALTOTAL:
	case mx.CMD_SCORELIST:
	case mx.CMD_GAMESEARCH:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_CMD_RANKINGMEDALTOTALAPPEND:
	case mx.CMD_RANKINGMEDALAPPEND:
	case mx.CMD_RANKINGRATEAPPEND:
	case mx.CMD_GAMEGRADEGROUPAPPEND :
	case mx.CMD_GAMEGRADEPERSONAPPEND : this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_RECORDER:	this.OnPopClose( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_PRE:	this.OnPreLoad( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_SETSCORE:	this.OnshowModal( reqcmd, jsondata, htmldata, sender );		break;
	}
};

mx.OnPopClose= function(cmd, packet, html, sender){
	$(sender).modal('toggle');
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;

	if (cmd == mx.CMD_SCORELIST){
		$('#listpointbtn').hide();
		$('.point-board').animate({"margin-right": '+=1273'});
	}

	if (cmd == mx.CMD_GAMEGRADEPERSON){ //입상현황 조회
		localStorage.setItem("nextkey",packet.nextkey);
	}

	if( cmd == mx.CMD_STATUSSEARCH ){
		$('.operating-list').operatingListScroll('.operating-list');
	}

};

mx.OnAppendHTML =  function(cmd, packet, html, sender){

	if( cmd == mx.CMD_GAMEGRADEGROUPAPPEND || cmd == mx.CMD_RANKINGRATEAPPEND || cmd == mx.CMD_RANKINGMEDALAPPEND || cmd == mx.CMD_CMD_RANKINGMEDALTOTALAPPEND){ //마지막 페이지 처리
		if ( packet.lastchk == "_end" ){
			return;
		}
	}
	
	
	$('#'+sender+' > tbody:last').append(html);
	$("body").scrollTop($("body")[0].scrollHeight);

	if (cmd == mx.CMD_GAMEGRADEPERSONAPPEND){ //입상현황 더보기
		if (packet.nextkey == '_end'){
			$('#_more').hide();
		}
	}
};

mx.OnshowModal =  function(cmd, packet, html, sender){
	localStorage.setItem('REQ', JSON.stringify( packet  ));
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('toggle');
};

mx.OnLogin =  function(cmd, packet, html, sender){
	if (packet.logincheck ==  "1"){ //성공
		document.getElementById("DP_Login").style.display = "none";
		document.getElementById("DP_Logout").style.display = "block";
	}
	else{
		$('#login-modal').modal('toggle');
	}
};

mx.OnLogout =  function(cmd, packet, html, sender){
	//document.getElementById("DP_Logout").style.display = "none";
	//document.getElementById("DP_Login").style.display = "block";
	location.href = "index.asp";
};

mx.OnLoginchk =  function(cmd, packet, html, sender){

	  if (packet.go == "0"){
			//$('#advise-modal').modal('toggle');
		  apploading("AppBody", "경기스코어입력 화면으로 이동 중 입니다.");
		  location.href = "Calendar.asp";
	  }
	  else{
		localStorage.setItem("IntroIndex", packet.no);
		switch (packet.no){
		case "1":
		  apploading("AppBody", "경기스코어입력 화면으로 이동 중 입니다.");
		  location.href = "Calendar.asp";
		  break;
		case "2":
		  apploading("AppBody", "대회결과보기 화면으로 이동 중 입니다.");
		  location.href = "Calendar.asp";
		  break;
		case "3":
		  apploading("AppBody", "경기운영본부 화면으로 이동 중 입니다.");
		  location.href = "Calendar.asp";
		  break;
		case "4":
		  apploading("AppBody", "대회통계 화면으로 이동 중 입니다.");
		  location.href = "stat-winner-state.asp";
		  break;
		}
	  }
};