var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_SEARCHGAMELIST = 60001 //  대회리스트 요청
	mx.CMD_SELECTGAME = 60002 // 대회 선택
	mx.CMD_INSERTGAMEVIDEO = 60003 // 대회정보 입력
	mx.CMD_EDITGAMEINPUT = 60004 //  대회정보 입력필드에 입력
	mx.CMD_EDITGAMEINFO = 60005 // 대회정보 수정
	mx.CMD_DELETEGAMEINFO = 60006 // 대회정보 삭제

	mx.CMD_SEARCHGAMEVIDEO = 60011 //대회검색
	mx.CMD_VIEWGAMEVIDEO = 60012 // 대회비디오 보기

	mx.CMD_SELECTCLASS = 60020 // 종목값선택 - 세부종별 구분값가져오기
	mx.CMD_INSERTDETAILTYPE = 60021 // 세부종별 구분값 추가입력

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

mx.loading = function(){
	var width = $(window).width();
	var height = $(window).height();

	//화면을 가리는 레이어의 사이즈 조정
	$(".backLayer").width(width);
	$(".backLayer").height(height);

	//화면을 가리는 레이어를 보여준다 (0.5초동안 30%의 농도의 투명도)
	$(".backLayer").fadeTo(500, 0.3);

	//팝업 레이어 보이게
	var loadingDivObj = $("#loadingDiv");
	loadingDivObj.css("top", $(document).height()/2-0);
	loadingDivObj.css("left",$(document).width()/2-0);
	loadingDivObj.fadeIn(500);
};

//esc키 누르면 화면 잠김 해제
$(document).keydown(function(event){
	if(event.which=='27'){
		$("#loadingDiv").fadeOut(300);
		$(".backLayer").fadeOut(1000);
	}
});

 //윈도우가 resize될때마다 backLayer를 조정
 $(window).resize(function(){
	var width = $(window).width();
	var height = $(window).height();
	$(".backLayer").width(width).height(height);
});


mx.ajaxurl = "/pub/ajax/ksports/reqKsports.asp";
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
		case 3: alert('대회를 선택해주세요');return; break;
		case 4: alert('종목을 선택해주세요');return; break;
		case 5: alert('중복값이 있습니다.');return; break;
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_SEARCHGAMELIST: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_SELECTGAME: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );				break;
	case mx.CMD_INSERTGAMEVIDEO: this.OnBeforeHTML(reqcmd, jsondata, htmldata, sender);	alert("데이터가 등록됐습니다.");	break;
	case mx.CMD_EDITGAMEINPUT: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_EDITGAMEINFO: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );			alert("데이터가 수정됐습니다.");	break;
	case mx.CMD_DELETEGAMEINFO: this.OndelHTML( reqcmd, jsondata, htmldata, sender );			alert("데이터가 삭제됐습니다.");	break;
	case mx.CMD_SEARCHGAMEVIDEO: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );  break;
	case mx.CMD_VIEWGAMEVIDEO: this.OnModal( reqcmd, jsondata, htmldata, sender );  break;
	case mx.CMD_INSERTDETAILTYPE: this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender ); break;
	case mx.CMD_SELECTCLASS: this.OndrowHTML( reqcmd, jsondata, htmldata, sender ); break;
	}
};


//drow///////////////
mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if( cmd == mx.CMD_E || cmd == mx.CMD_GAMEHOST || cmd == mx.CMD_GAMEORGN){
		mx.init();
	}

	if ( cmd == mx.CMD_EDITGAMEINPUT ) {
		mx.gameinfo = packet;
	}
	mx.init();
};

mx.OnBeforeHTML =  function(cmd, packet, html, sender){
	$(sender).first().before(html);
};

mx.OnModal =  function(cmd, packet, html, sender){
  document.getElementById(sender).innerHTML = html;
  $("#" + sender).modal('show');
};

mx.OndelHTML =  function(cmd, packet, html, sender){
//	localStorage.removeItem('MOREINFO'); //초기화
//	$("#totcnt").html(Number($("#totcnt").text()) - 1);
	$("#"+sender).remove();
};

mx.OnAppendHTML =  function(cmd, packet, html, sender){
	$('#'+sender).append(html);
};


mx.init = function(){
	$(function() {
		$( "#gameSDate" ).datepicker({
				 changeYear:true,
				 changeMonth: true,
				 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'],
				 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				 showMonthAfterYear:true,
				 showButtonPanel: true,
				 currentText: '오늘 날짜',
				 closeText: '닫기',
				 dateFormat: "yy-mm-dd"
		});

		$( "#gameEDate" ).datepicker({
				 changeYear:true,
				 changeMonth: true,
				 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'],
				 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				 showMonthAfterYear:true,
				 showButtonPanel: true,
				 currentText: '오늘 날짜',
				 closeText: '닫기',
				 dateFormat: "yy-mm-dd"
		});
	});
};

mx.init();


mx.searchGamelist = function () {
	var classCode = $( "#classinfo" ).val();
	var regYear = $( "#regYear" ).val();
	var eventName = $( "#eventName" ).val();
	if (regYear == "") {
		alert("등록년도를 선택해주세요.");
	} else if ( classCode == "" ) {
		alert("종목을 선택해주세요.");
	} else {
		var obj = {};
		obj.CMD = mx.CMD_SEARCHGAMELIST;
		obj.classCode = classCode;
		obj.regYear = regYear;
		obj.eventName = eventName;
		console.log(obj);
		mx.SendPacket("ul_2", obj);
	}
}

mx.selectGame = function () {
	var obj = {};
	var classCode; //종목코드
	var eventCode; // 대회고유코드
	var eventName; // 대회이름
	var eventYear; // 대회년도
	eventCode = $("#gl_1").val();
	classCode = $("#gl_1 option:selected").attr("classcode");
	eventName = $("#gl_1 option:selected").attr("eventname");
	eventYear= $("#gl_1 option:selected").attr("eventyear");

	obj.CMD = mx.CMD_SELECTGAME;
	obj.eventCode = eventCode;
	obj.classCode = classCode;
	obj.eventName= eventName;
	obj.eventYear = eventYear;

	console.log(obj);

}

mx.insertGame = function () {
	var obj = {};
	var classCode; //종목코드
	var eventYear; //대회 년도
	var gameCode; // 대회고유코드
	var gameName; // 대회이름
	var gameVideo; // 영상 링크
	var gameSDate; // 대회날짜
	var gameEDate; // 대회날짜
	var gameAgeDistinct // 학군
	var gameGroupType // 종별
	var gameMatchType //  리그,토너먼트
	var gameMemberGender //  성별
	var gameOrder //  경기순
	var gameMember // 참가선수
	var detailType // 세부종별
	var gameFileName // 영상 파일명



	gameCode = $("#gl_1").val();
	//임시입력선택시
	if (gameCode == 't99999999') {
		eventYear = $('#regYear option:selected').val();
		classCode = $("#classinfo option:selected").val();
		gameName = $("#tempGameName").val();
	// 대회선택시
	} else {
		eventYear = $("#gl_1 option:selected").attr("eventyear");
		classCode = $("#gl_1 option:selected").attr("classcode");
		gameName = $("#gl_1 option:selected").attr("eventname");
	}
	gameVideo = $("#gameVideo").val();
	gameSDate = $("#gameSDate").val();
	gameEDate = $("#gameEDate").val();
	gameAgeDistinct = $("#gameAgeDistinct").val();
	gameAgeDistinctText = $("#gameAgeDistinct option:selected").text();
	gameGroupType = $("#gameGroupType").val();
	gameGroupTypeText = $("#gameGroupType option:selected").text();
	gameMatchType = $("#gameMatchType").val();
	gameMatchTypeText = $("#gameMatchType option:selected").text();
	gameMemberGender = $("#gameMemberGender").val();
	gameMemberGenderText = $("#gameMemberGender option:selected").text();
	gameOrder = $("#gameOrder").val();
	gameMember = $("#gameMember").val();
	detailType = $("#gameDetailType").val();
	gameFileName = $("#gameFileName").val();

	obj.CMD = mx.CMD_INSERTGAMEVIDEO;
	obj.classCode = classCode
	obj.eventYear = eventYear
	obj.gameCode = gameCode
	obj.gameName = gameName
	obj.gameVideo = gameVideo
	obj.gameSDate  = gameSDate
	obj.gameEDate  = gameEDate
	obj.gameAgeDistinct = gameAgeDistinct
	obj.gameAgeDistinctText = gameAgeDistinctText
	obj.gameGroupType = gameGroupType
	obj.gameGroupTypeText = gameGroupTypeText
	obj.gameMatchType = gameMatchType
	obj.gameMatchTypeText = gameMatchTypeText
	obj.gameMemberGender = gameMemberGender
	obj.gameMemberGenderText = gameMemberGenderText
	obj.gameOrder = gameOrder
	obj.gameMember = gameMember
	obj.detailType = detailType
	obj.gameFileName = gameFileName

	// 데이터미입력 리턴처리
	if (!gameCode || !gameVideo || !gameSDate || !gameEDate || !gameAgeDistinct || !gameGroupType || !gameMatchType || !gameMemberGender || !gameOrder || !gameMember || !gameFileName) {
		if (!gameCode) {
				alert("대회를 선택해주세요.");
				$("#gl_1").focus();
		} else if (!gameVideo) {
				alert("비디오 링크를 입력해주세요.");
				$("#gameVideo").focus();
		} else if (!gameSDate || !gameEDate) {
				alert("경기날짜를 입력해주세요.");
				if (!gameSDate){
					$("#gameSDate").focus();
				} else if (!gameEDate){
					$("#gameEDate").focus();
				}
		} else if (!gameAgeDistinct)	{
				alert("학군을 선택해주세요.");
				 $("#gameAgeDistinct").focus();
		} else if (!gameGroupType) {
				alert("종별을 선택해주세요.");
				$("#gameGroupType").focus();
		} else if (!gameMatchType) {
				alert("리그방식을 선택해주세요.");
				$("#gameMatchType").focus();
		} else if (!gameMemberGender) {
				alert("성별을 선택해주세요.");
				$("#gameMemberGender").focus();
		} else if (!gameOrder) {
				alert("순서를 입력해주세요.");
				$("#gameOrder").focus();
		} else if (!gameMember) {
				alert("참가자를 입력해주세요.");
				$("#gameMember").focus();
		} else if (!gameFileName) {
			alert("영상파일명을 입력해주세요.");
			$("#gameFileName").focus();
		}
		return;
	}


	// 실행
	else {
		mx.SendPacket("#gamelist tr:nth-child(2)", obj);
	}

//	console.log(obj);
}

mx.input_edit = function(idx){
	$("td").css("color", "#49586a");
	$("#game_" + idx + " td").css("color", "red");

	var obj = {};
	obj.CMD = mx.CMD_EDITGAMEINPUT;
	obj.IDX = idx;


	mx.SendPacket("gameinput_area", obj);
};

mx.editGame = function () {
	if (mx.gameinfo	 == '' || mx.gameinfo	 == null  ){
		alert('대상을 선택해 주십시오.');
		return;
	}

	var obj = {};
	obj.CMD = mx.CMD_EDITGAMEINFO;
	obj.className = $("#classinfo option:selected").text();
	obj.gameCode = $("#gl_1").val();
	//임시입력선택시
	if (obj.gameCode == 't99999999') {
		obj.eventYear = $('#regYear option:selected').val();
		obj.classCode = $("#classinfo option:selected").val();
		obj.gameName = $("#tempGameName").val();
	// 대회선택시
	} else {
		obj.eventYear = $("#gl_1 option:selected").attr("eventyear");
		obj.classCode = $("#gl_1 option:selected").attr("classcode");
		obj.gameName = $("#gl_1 option:selected").attr("eventname");
	}

	if(!obj.gameCode) {
		alert("대회를 선택해주세요.");
		return;
	};

	obj.gameVideo = $("#gameVideo").val();
	obj.gameSDate  = $("#gameSDate").val();
	obj.gameEDate  = $("#gameEDate").val();
	obj.gameAgeDistinct = $("#gameAgeDistinct").val();
	obj.gameAgeDistinctText = $("#gameAgeDistinct option:selected").text();
	obj.gameGroupType = $("#gameGroupType").val();
	obj.gameGroupTypeText = $("#gameGroupType option:selected").text();
	obj.gameMatchType = $("#gameMatchType").val();
	obj.gameMatchTypeText = $("#gameMatchType option:selected").text();
	obj.gameMemberGender = $("#gameMemberGender").val();
	obj.gameMemberGenderText =  $("#gameMemberGender option:selected").text();
	obj.gameOrder = $("#gameOrder").val();
	obj.gameMember =  $("#gameMember").val();
	obj.IDX = mx.gameinfo.IDX;
	obj.detailType = $("#gameDetailType").val();
	obj.gameFileName = $("#gameFileName").val();

	if (confirm("데이터를 수정하시겠습니까?")){
		mx.SendPacket("game_" + mx.gameinfo.IDX, obj);
	};
	//	console.log(obj);
}

mx.deleteGame = function () {
	var obj = {};
	obj.CMD = mx.CMD_DELETEGAMEINFO;
	obj.IDX = mx.gameinfo.IDX;

	mx.SendPacket("game_" + mx.gameinfo.IDX, obj);
//	console.log(obj);
}

mx.searchPlayer = function (pageno) {
	var obj ={};
	obj.pg = pageno;

	if ($("#sRegYear").val()) {
		obj.sEventYear = $("#sRegYear").val();
	} else {
		obj.sEventYear = ""
	};

	if ($("#sClassinfo").val()) {
		obj.sClassCode = $("#sClassinfo").val();
	} else {
		obj.sClassCode = ""
	};

	if ($("#sGameName").val()) {
		obj.sGameName = $("#sGameName").val();
	} else {
		obj.sGameName = ""
	};

	document.sform.p.value =   JSON.stringify( obj  );
	document.sform.submit();
	console.log(oJSONoutput);
};

mx.viewGameVideo = function (videoName, videoId) {
	var obj = {};
	obj.CMD = mx.CMD_VIEWGAMEVIDEO
	obj.videoName = videoName;
	obj.videoId = videoId;

	mx.SendPacket("viewYoutube", obj);
};

mx.searchGameVideo = function () {
	var obj = {};
	obj.CMD = mx.CMD_SEARCHGAMEVIDEO;
	obj.eventYear = $("#regYear").val();
	obj.classCode = $("#classinfo").val();
	obj.gameName = $("#gameName").val();

	if (!obj.eventYear) {
		alert("검색년도를 선택해주세요.");
		return;
	} else if (!obj.classCode) {
		alert("대회 종목을 선택해주세요.")
		return;
	} else {
		mx.SendPacket("gamelist", obj);
	}
};

mx.searchGameInfo = function (page) {
	var obj = {};
	obj.pg = page;
	obj.sEventYear = $("#sRegYear").val();
	obj.sClassCode = $("#sClassinfo").val();
	obj.sGameName = $("#sGameName").val();

	console.log(obj);
	document.sform.action = "kgameinfo.asp";
	document.sform.p.value = JSON.stringify( obj  );
	document.sform.submit();
};

mx.insertDetailType = function() {
	obj = {};
	className = $("#classinfo option:selected").text();
	var classCode = $("#classinfo").val();
	if ($("#gameDetailType").val() == 'insert') {
		if(classCode) {
			//세부종별 추가
			detailType = prompt("세부종별추가","");
			if (detailType) {
				obj.detailType = detailType;
				obj.classCode = classCode;
				obj.CMD = mx.CMD_INSERTDETAILTYPE;
				//console.log(obj);
				if (confirm( className + "종목에 " + detailType + "을 추가하시겠습니까?")) {
					mx.SendPacket("#gameDetailType option:nth-child(2)", obj);
				};
			} else {

			};
		} else {
			alert("종목을선택해주세요");
		};
	} else {
		//세부종별 선택
	}
};

mx.selectClass = function() {
	obj = {};
	classCode = $("#classinfo").val();
	obj.classCode = classCode;
	obj.CMD = mx.CMD_SELECTCLASS;

	mx.SendPacket("gameinput_area", obj);
};
