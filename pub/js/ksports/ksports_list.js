var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_SELECTGB = 30022; //대분류검색
	mx.CMD_INSERTGB = 30023; //대분류생성
	mx.CMD_INSERTSUBGB = 30024; //종목명생성
	mx.CMD_SELECTSUBGB = 30035;//종목검색

	mx.CMD_GAMEHOST = 30036; //주최추가
	mx.CMD_GAMEORGN = 30038; //주관추가

	mx.CMD_SETBOODATE = 30040; //날짜추가

	mx.CMD_W = 40001; //등록
	mx.CMD_E = 40002; //수정불러오기
	mx.CMD_EOK = 40003; //수정완료
	mx.CMD_D = 40004; //삭제

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
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_E:
	case mx.CMD_EOK:
	case mx.CMD_GAMEHOST:
	case mx.CMD_GAMEORGN:
	case mx.CMD_SELECTGB:
	case mx.CMD_SELECTSUBGB:
	case mx.CMD_INSERTSUBGB:
	case mx.CMD_INSERTGB: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_SETBOODATE:this.OnModal( reqcmd, jsondata, htmldata, sender );   break; 
	case mx.CMD_W:	this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_D:	this.OndelHTML( reqcmd, jsondata, htmldata, sender );		break;
	}
};


mx.SelectGb = function() {
  var idx = $("#idx").val();
  var GbVal = $("#sportsgb").val();
  if(GbVal == "insert" ) {
    var GbPrompt = prompt("대분류를 입력해주세요",'');
    if(GbPrompt != null && GbPrompt != "") {
      var obj = {};
      obj.CMD = mx.CMD_INSERTGB;
	  obj.GB = GbPrompt;
	  if (idx != ''){
		  obj.IDX = idx;
	  }
	  mx.SendPacket('ul_1', obj);
    }
    $('#sportsgb option')[0].selected = true;
    return;
  }
  else if(GbVal != ""){
	  var obj = {};
	  obj.CMD = mx.CMD_SELECTGB;
	  obj.GB = GbVal;
	  if (idx != ''){
		  obj.IDX = idx;
	  }
	  mx.SendPacket('ul_1', obj);  
  }
};

mx.SelectSubGb = function() {
  var idx = $("#idx").val();
  var GbVal = $("#sportsgb").val();
  if (GbVal == ''){
	 alert('대분류를 먼저 선택해 주십시오.');
	 return;
  }
  var GbSubVal = $("#sportssubgb").val();
  if(GbSubVal == "insert" ) {
    var GbPrompt = prompt("종목명을 입력해주세요",'');
    if(GbPrompt != null && GbPrompt != "") {
      var obj = {};
      obj.CMD = mx.CMD_INSERTSUBGB;
	  obj.GB = GbVal;
	  obj.GBSUB = GbPrompt;
	  if (idx != ''){
		  obj.IDX = idx;
	  }
      mx.SendPacket('ul_1', obj);
    }
    $('#sportssubgb option')[0].selected = true;
    return;
  }
};

mx.Select = function(id,cmd) {
  var idx = $("#idx").val();
  var games = $("#GameS").val();
  var gamee = $("#GameE").val();

  var gamehost = $("#gamehost").val();
  var gameorganize = $("#gameorganize").val();

  
  var GbVal = $("#"+id).val();
  var sval = $("#"+id).val();
  if(sval == "insert" ) {
    var GbPrompt = prompt("명칭을 입력해주세요",'');
    if(GbPrompt != null && GbPrompt != "") {
      var obj = {};
      obj.CMD = cmd;
	  obj.NAME = GbPrompt;
	  if (idx != ''){
		  obj.IDX = idx;
	  }
	  obj.GAMES = games;
	  obj.GAMEE = gamee;

	  obj.GH = gamehost;
	  obj.GO = gameorganize;

      mx.SendPacket('ul_3', obj);
    }
    $('#'+id+' option')[0].selected = true;
    return;
  }
};

//drow///////////////
mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if( cmd == mx.CMD_E || cmd == mx.CMD_GAMEHOST || cmd == mx.CMD_GAMEORGN){
		mx.init();
	}
};

mx.OnBeforeHTML =  function(cmd, packet, html, sender){
	$('#contest').first().before(html);
};

mx.OnModal =  function(cmd, packet, html, sender){
  document.getElementById(sender).innerHTML = html;
  mx.initdate();

  if (packet.hasOwnProperty('voddate') == true){
		var varr = packet.voddate.split(',');	
		for (var i = 0;i < varr.length ;i++ ){
			mx.SetLoadVodDate('mscul', varr[i],packet.BTYPE,i);
		}

		if (packet.BTYPE  == 'm'){ //중등
			for(var i = varr.length ; i < mx.mdate.length; i++){
				mx.drowdate("mscul", mx.mdate[i], packet.BTYPE);	
			}
		}
		else{//고등
			for(var i = varr.length ; i < mx.hdate.length; i++){
				mx.drowdate("mscul", mx.hdate[i],packet.BTYPE);	
			}
		}


  }
  else{
	  if (packet.BTYPE  == 'm'){ //중등
		for(var i = 0 ; i < mx.mdate.length; i++){
			mx.drowdate("mscul", mx.mdate[i], packet.BTYPE);	
		}
	  }
	  else{//고등
		for(var i = 0 ; i < mx.hdate.length; i++){
			mx.drowdate("mscul", mx.hdate[i],packet.BTYPE);	
		}
	  }
  }
  $('#'+sender).modal('show');
};

mx.OndelHTML =  function(cmd, packet, html, sender){
	$("#"+sender).remove();
};
//drow///////////////

mx.mdate = [];
mx.hdate = [];
mx.drowdate = function(sender,inputvalue, btype){
  var html = '<li id="'+btype+inputvalue+'"><span>'+inputvalue+'</span><a href="javascript:mx.delVodDate(\''+inputvalue+'\',\''+btype+'\')" class="btn btn-remove">삭제</a></li>';
  $('#'+sender).append(html);	
};


mx.setBooDate = function (modalid,bootype){
  var obj ={};
  var idx = $("#idx").val();
  var emode = $("#emode").val();
  obj.CMD = mx.CMD_SETBOODATE;
  obj.BTYPE = bootype;

  if ( emode == "e"){
	  if (idx != ''){
//		  mx.mdate = [];
//		  mx.hdate = [];
		  obj.IDX = idx;
	  }
  }

  mx.SendPacket(modalid, obj);
};


mx.SetLoadVodDate = function(sender, inputvalue,btype,i){ //날짜 로드할때 
  if (btype == 'm'){
	//mx.mdate.push(inputvalue);
	mx.mdate[i] = inputvalue;
  }
  else{
	//mx.hdate.push(inputvalue);
	mx.hdate[i] = inputvalue;
  }

  mx.drowdate(sender, inputvalue,btype);
  document.getElementById(sender).scrollTop = document.getElementById(sender).scrollHeight;
};


mx.SetVodDate = function(sender, inputvalue,btype){
  if (btype == 'm'){
	mx.mdate.push(inputvalue);
  }
  else{
	mx.hdate.push(inputvalue);
  }

  mx.drowdate(sender, inputvalue,btype);
  document.getElementById(sender).scrollTop = document.getElementById(sender).scrollHeight;
};


mx.delVodDate = function(delval , btype){
  if (btype == 'm'){
	var idx = mx.mdate.indexOf(delval);
	if (idx > -1) mx.mdate.splice(idx, 1);
	$('#'+btype+delval).remove();
  }
  else{
	var idx = mx.hdate.indexOf(delval);
	if (idx > -1) mx.hdate.splice(idx, 1);
	$('#'+btype+delval).remove();
  }
};


mx.vodbtn = function(ckbtnno, btnid){
	if ( $("#on-off-sc" + ckbtnno ).is(":checked") == true ){
		$('#'+btnid).show();
	}
	else{
		$('#'+btnid).hide();	
	}
};

mx.element_layer;
$(document).ready(function(){
	// 우편번호 찾기 화면을 넣을 element
	mx.element_layer = document.getElementById('dnlayer');
	mx.init();
}); 


mx.initdate = function(){
	$(function() {
		$( "#mscdate" ).datepicker({ 
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


mx.init = function(){
	$(function() {
		$( "#GameS" ).datepicker({ 
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

		$( "#GameE" ).datepicker({ 
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


mx.input_frm = function(){
	$("#idx").val('');//수정모드 해제
	var obj = {};
	obj.CMD = mx.CMD_W;
	obj.SGB        				=	$("#sportsgb").val();
	obj.SGBSUB			 		=	$("#sportssubgb").val();
	obj.TITLE       				=	$("#gametitle").val();
	obj.GTYPE	         		=	$("#gametype").val();

	obj.SIDO	         			=	$("#sido").val();
	obj.ZIPCODE	         	=	$("#zipcode").val();
	obj.ADDR	         		=	$("#gameaddr").val();
	obj.STADIUM         		=	$("#stadium").val();
	
	obj.GameS              	=	$("#GameS").val();
	obj.GameE              		=	$("#GameE").val();
	obj.HOST              		=	$("#gamehost").val();
	obj.ORG              		=	$("#gameorganize").val();
	obj.VOD						= "";

	for (var i = 1;i <= 6 ;i++ ){
		if ( $("#on-off-sc"+i).is(":checked") == true ) {
		   obj.VOD = obj.VOD +  'Y';		
		}
		else{
		   obj.VOD = obj.VOD +  'N';
		}
	}

	if ( $("#on-off-sc2").is(":checked") == true ){
		obj.MDATE = mx.mdate;
	}

	if ( $("#on-off-sc3").is(":checked") == true ){
		obj.HDATE = mx.hdate;
	}
	mx.SendPacket(null, obj);
};

mx.input_edit = function(idx){
	mx.mdate = [];
	mx.hdate = [];

	var obj = {};
	obj.CMD = mx.CMD_E;
	obj.IDX = idx;
	mx.SendPacket('gameinput_area', obj);
};


mx.update_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_EOK;
	obj.IDX						=	$("#idx").val();

	if (obj.IDX == undefined){
		alert("대상을 선택해 주세요.");
		return;
	}

	obj.SGB        				=	$("#sportsgb").val();
	obj.SGBSUB			 		=	$("#sportssubgb").val();
	obj.TITLE       				=	$("#gametitle").val();
	obj.GTYPE	         		=	$("#gametype").val();

	obj.SIDO	         			=	$("#sido").val();
	obj.ZIPCODE	         	=	$("#zipcode").val();
	obj.ADDR	         		=	$("#gameaddr").val();
	obj.STADIUM         		=	$("#stadium").val();
	
	obj.GameS              	=	$("#GameS").val();
	obj.GameE              		=	$("#GameE").val();
	obj.HOST              		=	$("#gamehost").val();
	obj.ORG              		=	$("#gameorganize").val();
	obj.VOD						= "";

	for (var i = 1;i <= 6 ;i++ ){
		if ( $("#on-off-sc"+i).is(":checked") == true ) {
		   obj.VOD = obj.VOD +  'Y';		
		}
		else{
		   obj.VOD = obj.VOD +  'N';
		}
	}

	if ( $("#on-off-sc2").is(":checked") == true ){
		obj.MDATE = mx.mdate;
	}

	if ( $("#on-off-sc3").is(":checked") == true ){
		obj.HDATE = mx.hdate;
	}
	mx.SendPacket('titlelist_'+obj.IDX, obj);
};



mx.del_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_D;
	obj.IDX	=	$("#idx").val();
	$("#idx").val('');//수정모드 해제

if (obj.IDX == undefined){
	alert("대상을 선택해 주세요.");
	return;
}
	mx.SendPacket('titlelist_'+obj.IDX, obj);
};


mx.searchPlayer = function(pageno){
	var obj ={};
	obj.pg = pageno;
	document.sform.p.value =   JSON.stringify( obj  );
	document.sform.submit();

};

//###################################################################################
function closeDaumPostcode() {
	// iframe을 넣은 element를 안보이게 한다.
	mx.element_layer.style.display = 'none';
}

// 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
// resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
// 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
function initLayerPosition(){
	var width = 500; //우편번호서비스가 들어갈 element의 width
	var height = 400; //우편번호서비스가 들어갈 element의 height
	var borderWidth = 5; //샘플에서 사용하는 border의 두께

	// 위에서 선언한 값들을 실제 element에 넣는다.
	mx.element_layer.style.width = width + 'px';
	mx.element_layer.style.height = height + 'px';
	mx.element_layer.style.border = borderWidth + 'px solid';
	// 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
	mx.element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
	mx.element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/4 - borderWidth) + 'px';
}		
	

function Postcode() {

        // iframe을 넣은 element를 보이게 한다.
        mx.element_layer.style.display = 'block';
        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition();		
		
		new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zipcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('gameaddr').value = fullAddr;
                document.getElementById('stadium').focus();

                var DataSido = data.sido;

                if (DataSido == "제주특별자치도") {
                    DataSido = "제주";
                } else if (DataSido == "세종특별자치시") {
                    DataSido = "세종";
                }
                document.getElementById('sido').value = DataSido;

                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                mx.element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%',
            maxSuggestItems : 5
        }).embed(mx.element_layer);


}


